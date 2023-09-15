import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:neyasis/accounts/accounts.dart';
import 'package:http/http.dart' as http;
import 'package:neyasis/constants/urls.dart';
import 'package:neyasis/utils/http_client.dart';
import 'package:stream_transform/stream_transform.dart';

part 'account_event.dart';
part 'account_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({required this.httpClient}) : super(const AccountState()) {
    on<AccountFetchEvent>(
      _onAccountFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<AccountDeleteEvent>(
      _onAccountDelete,
      transformer: throttleDroppable(throttleDuration),
    );
    on<AccountPostEvent>(
      _onAccountPost,
      transformer: throttleDroppable(throttleDuration),
    );
    on<AccountEditEvent>(
      _onAccountEdited,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ToggleEditModeEvent>(
      _onToggleEditMode,
      transformer: throttleDroppable(throttleDuration),
    );
    on<AccountRefresh>(
      _onAccountRefresh,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final HttpClient httpClient;

  /// Handle the event of fetching accounts.
  Future<void> _onAccountFetched(
    AccountFetchEvent event,
    Emitter<AccountState> emit,
  ) async {
    try {
      if (state.status == AccountStatus.initial) {
        // Fetch the initial list of accounts.
        final accounts = await _fetchAccounts();
        var page = (accounts.length / 15).ceil();
        var limit = 15;
        var startIndex = 0;

        // Handle cases where there are no accounts or less than a page.
        if (page == 0 || accounts.length < 15) {
          emit(
            state.copyWith(
              status: AccountStatus.success,
              accounts: accounts,
              hasReachedMax: true,
              page: 0,
            ),
          );
          return;
        }
        // Handle paginated accounts.
        if (accounts.length > 0) {
          emit(
            state.copyWith(
              status: AccountStatus.success,
              accounts: accounts.sublist(startIndex, startIndex + limit),
              hasReachedMax: false,
              page: page,
            ),
          );
          startIndex += limit;
        }

        // Check if all accounts have been loaded.
        if (startIndex >= accounts.length) {
          emit(state.copyWith(hasReachedMax: true));
          return;
        }
      }

      // Handle pagination when more accounts are requested.
      if (state.status == AccountStatus.success && event.isPagination) {
        final accounts = await _fetchAccounts();

        if (accounts.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
          return;
        }

        var startIndex = state.accounts.length;
        var limit = 15;
        var endIndex = startIndex + limit;

        if (endIndex > accounts.length) {
          endIndex = accounts.length;
        }

        final paginatedAccounts = accounts.sublist(startIndex, endIndex);

        var hasReachedMax = endIndex == accounts.length;

        emit(
          state.copyWith(
            status: AccountStatus.success,
            accounts: List.of(state.accounts)..addAll(paginatedAccounts),
            hasReachedMax: hasReachedMax,
            page: state.page + 1,
          ),
        );
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: AccountStatus.failure));
    }
  }

  Future<void> _onAccountPost(
    AccountPostEvent event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final state = this.state;

      final account = await _postAccount(account: event.account.copyWith(id: "${state.accounts.length + 1}"));
      if (account == false) return;
      final newAccounts = [...state.accounts];
      newAccounts.add(event.account);
      newAccounts.sort(
        (a, b) => (int.parse(a.id ?? "0")).compareTo(int.parse(b.id ?? "0")),
      );
      return emit(
        AccountState(accounts: newAccounts, status: AccountStatus.success, hasReachedMax: true),
      );
    } catch (_) {
      emit(state.copyWith(status: AccountStatus.failure));
    }
  }

  Future<void> _onAccountEdited(
    AccountEditEvent event,
    Emitter<AccountState> emit,
  ) async {
    final state = this.state;
    try {
      final success = await _editAccount(account: event.account);
      if (success == false) return;
      final newAccounts = [...state.accounts];
      int accountId = newAccounts.indexWhere((element) => element.id == event.account.id);
      if (accountId == -1) return;
      newAccounts.removeAt(accountId);
      newAccounts.add(event.account);
      newAccounts.sort((a, b) => (int.parse(a.id ?? "0")).compareTo(int.parse(b.id ?? "0")));
      return emit(
        state.copyWith(
          status: AccountStatus.success,
          accounts: newAccounts,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: AccountStatus.failure));
    }
  }

  Future<void> _onToggleEditMode(
    ToggleEditModeEvent event,
    Emitter<AccountState> emit,
  ) async =>
      emit(state.copyWith(
          editMode: EditModeModel(
        isEditMode: event.isEditActive,
        selectedAccount: event.selectedAccount,
      )));

  Future<void> _onAccountDelete(
    AccountDeleteEvent event,
    Emitter<AccountState> emit,
  ) async {
    final state = this.state;

    try {
      final accounts = await _deleteAccount(accountId: event.selectedAccount.id);
      print(accounts);
      if (accounts == false) return;

      int accountIndex = state.accounts.indexWhere((element) => element.id == event.selectedAccount.id);
      if (accountIndex == -1) return;

      final newAccountList = [...state.accounts];
      newAccountList.removeAt(accountIndex);

      return emit(
        state.copyWith(
          status: AccountStatus.success,
          accounts: newAccountList,
          editMode: EditModeModel(
            isEditMode: false,
            selectedAccount: Account(),
          ),
          hasReachedMax: true,
        ),
      );
    } catch (e) {
      print(e);
      emit(state.copyWith(status: AccountStatus.failure));
    }
  }

  Future<void> _onAccountRefresh(
    AccountRefresh event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.initial));
  }

  Future<List<Account>> _fetchAccounts() async {
    final response = await httpClient.get(Urls.getAccounts);
    if (response!.statusCode == 200) {
      final body = response.data as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Account.fromJson(map);
      }).toList();
    }
    throw Exception('error fetching accounts');
  }

  Future<bool> _deleteAccount({required accountId}) async {
    try {
      final response = await httpClient.delete(Urls.deleteAccount.replaceAll("{accountId}", accountId));
      if (response!.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _postAccount({required Account account}) async {
    try {
      final data = account.toJson();
      final response = await httpClient.post(Urls.addAccount, data);
      if (response!.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print("error : $e");
      return false;
    }
  }

  Future<bool> _editAccount({required Account account}) async {
    final data = account.toJson();
    final response = await httpClient.put(Urls.updateAccount.replaceAll("{accountId}", account.id ?? ""), data);
    if (response!.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
