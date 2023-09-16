part of 'account_bloc.dart';

enum AccountStatus { initial, success, failure }

final class AccountState extends Equatable {
  const AccountState({
    this.status = AccountStatus.initial,
    this.accounts = const <Account>[],
    this.hasReachedMax = false,
    this.editMode = const EditModeModel(),
    this.page = 0,
  });

  final AccountStatus status;
  final List<Account> accounts;
  final bool hasReachedMax;
  final EditModeModel editMode;
  final int page;

  AccountState copyWith({
    AccountStatus? status,
    List<Account>? accounts,
    bool? hasReachedMax,
    EditModeModel? editMode,
    int? page,
  }) {
    return AccountState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      editMode: editMode ?? this.editMode,
      page: page ?? this.page,
    );
  }

  @override
  String toString() {
    return '''AccountState { status: $status, hasReachedMax: $hasReachedMax,isEditMode: $editMode, page: $page, accounts: ${accounts.length} }''';
  }

  @override
  List<Object> get props => [status, accounts, hasReachedMax, editMode, page];
}
