import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neyasis/accounts/accounts.dart';
import 'package:neyasis/edit_account/bloc/edit_account_bloc.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  void initState() {
    BlocProvider.of<AccountBloc>(context).add(AccountFetchEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
      appBar: AppBar(
        title: Text('accounts_title').tr(),
        actions: [
          BlocBuilder<AccountBloc, AccountState>(builder: (context, state) {
            return Row(
              children: [
                if (state.editMode.isEditMode)
                  CupertinoButton(
                      child: Text(
                        "delete_button",
                        style: TextStyle(color: Colors.red),
                      ).tr(),
                      onPressed: () {
                        context.read<AccountBloc>().add(
                              AccountDeleteEvent(
                                isEditActive: false,
                                selectedAccount: state.editMode.selectedAccount,
                              ),
                            );
                        context.read<AccountBloc>().add(
                          ToggleEditModeEvent(
                            isEditActive: false,
                            selectedAccount: Account(),
                          ),
                        );
                      }),
                CupertinoButton(
                    child: Text(
                      state.editMode.isEditMode ? "edit_button" : "add_button",
                      style: TextStyle(color: Colors.white),
                    ).tr(),
                    onPressed: () {
                      if (state.editMode.isEditMode) {
                        BlocProvider.of<EditAccountBloc>(context).add(
                          EditAccountEvent(
                            account: state.editMode.selectedAccount,
                          ),
                        );
                        context.read<AccountBloc>().add(
                              ToggleEditModeEvent(
                                isEditActive: false,
                                selectedAccount: Account(),
                              ),
                            );
                        Navigator.pushNamed(
                          context,
                          "/editAccountPage",
                        ).then(
                          (value) => BlocProvider.of<EditAccountBloc>(context).add(
                            EditAccountChangeStatusEvent(
                              status: EditAccountStatus.initial,
                            ),
                          ),
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          "/addAccountPage",
                        );
                      }
                    }),
              ],
            );
          })
        ],
      ),
      body: const AccountsList(),
    );
  }
}
