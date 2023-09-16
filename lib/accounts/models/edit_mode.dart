import 'package:equatable/equatable.dart';
import 'package:neyasis/accounts/models/account.dart';

class EditModeModel extends Equatable {
  final bool isEditMode;
  final Account selectedAccount;

  const EditModeModel({
    this.isEditMode = false,
    this.selectedAccount = const Account(),
  });

  EditModeModel copyWith({
    bool? isEditMode,
    Account? selectedAccount,
  }) =>
      EditModeModel(
        isEditMode: isEditMode ?? this.isEditMode,
        selectedAccount: selectedAccount ?? this.selectedAccount,
      );

  @override
  List<Object> get props => [isEditMode, selectedAccount];
}
