part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class AccountRefresh extends AccountEvent {}

final class AccountFetchEvent extends AccountEvent {
  AccountFetchEvent({
    this.isPagination = false,
  });
  final bool isPagination;
}

final class AccountDeleteEvent extends AccountEvent {
  AccountDeleteEvent({
    this.selectedAccount = const Account(),
    this.isEditActive = false,
  });
  final Account selectedAccount;
  final bool isEditActive;
}

final class AccountPostEvent extends AccountEvent {
  AccountPostEvent({
    Account? account,
  }) : account = account ??
            Account(
              id: "",
              phoneNumber: "",
              name: "",
              identity: "",
              birthdate: DateTime.now(),
              salary: 0.0,
              surname: "",
            );

  final Account account;
}

final class AccountEditEvent extends AccountEvent {
  AccountEditEvent({
    Account? account,
  }) : account = account ??
            Account(
              id: "",
              phoneNumber: "",
              name: "",
              identity: "",
              birthdate: DateTime.now(),
              salary: 0.0,
              surname: "",
            );

  final Account account;
}

final class ToggleEditModeEvent extends AccountEvent {
  ToggleEditModeEvent({
    this.isEditActive = false,
    this.selectedAccount = const Account(),
  });

  final bool isEditActive;
  final Account selectedAccount;
}
