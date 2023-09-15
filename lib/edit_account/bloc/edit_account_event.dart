part of 'edit_account_bloc.dart';

sealed class EditAccountsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class EditAccountChangeStatusEvent extends EditAccountsEvent {
  EditAccountChangeStatusEvent({
    this.status = EditAccountStatus.initial,
  });
  final EditAccountStatus status;
}

final class EditAccountEvent extends EditAccountsEvent {
  EditAccountEvent({
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
