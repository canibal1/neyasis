import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neyasis/accounts/accounts.dart';
import 'package:neyasis/constants/colors.dart';

class AccountsList extends StatefulWidget {
  const AccountsList({super.key});

  @override
  State<AccountsList> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        switch (state.status) {
          case AccountStatus.failure:
            return const Center(child: Text('failed to fetch accounts'));
          case AccountStatus.success:
            return successListState(state, context);
          case AccountStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget successListState(AccountState accountState, BuildContext context) {
    if (accountState.accounts.isEmpty) {
      return const Center(child: Text('no accounts'));
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          _onScroll();
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<AccountBloc>().add(AccountRefresh());
          context.read<AccountBloc>().add(AccountFetchEvent());
        },
        child: ListView.builder(
          key: Key("account_list__key"),
          itemBuilder: (BuildContext context, int index) {
            return index >= accountState.accounts.length
                ? const BottomLoader()
                : listViewGestureDetector(
                    accountState,
                    context,
                    index,
                  );
          },
          itemCount: accountState.hasReachedMax ? accountState.accounts.length : accountState.accounts.length + 1,
          controller: _scrollController,
        ),
      ),
    );
  }

  GestureDetector listViewGestureDetector(AccountState accountState, BuildContext context, int index) {
    return GestureDetector(
      onLongPress: () {
        if (!accountState.editMode.isEditMode) {
          context.read<AccountBloc>().add(
                ToggleEditModeEvent(
                  isEditActive: !accountState.editMode.isEditMode,
                  selectedAccount: accountState.accounts[index],
                ),
              );
        }
      },
      onTap: () {
        if (accountState.editMode.isEditMode) {
          context.read<AccountBloc>().add(
                ToggleEditModeEvent(
                  isEditActive: false,
                  selectedAccount: Account(),
                ),
              );
        }
      },
      child: Container(
        color: accountState.editMode.isEditMode && accountState.editMode.selectedAccount.id == (accountState.accounts[index].id ?? "")
            ? ColorUi.selectedItem
            : null,
        child: AccountListItem(
          key: Key("account_list_item$index"),
          account: accountState.accounts[index],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    if (_isBottom) context.read<AccountBloc>().add(AccountFetchEvent(isPagination: true));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.90) && currentScroll <= (maxScroll * 1);
  }
}
