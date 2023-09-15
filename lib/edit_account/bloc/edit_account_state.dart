part of 'edit_account_bloc.dart';

enum EditAccountStatus { initial, ready }

final class EditAccountState extends Equatable {
  const EditAccountState({
    this.status = EditAccountStatus.initial,
    this.account = const Account(),
  });
  final Account account;
  final EditAccountStatus status;
  EditAccountState copyWith({
    Account? account,
    EditAccountStatus? status,
  }) {
    return EditAccountState(
      account: account ?? this.account,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '''AccountState { account: ${account}, status: ${status} }''';
  }

  @override
  List<Object> get props => [account, status];
}
