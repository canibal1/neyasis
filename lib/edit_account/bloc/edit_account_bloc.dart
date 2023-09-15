import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:neyasis/accounts/accounts.dart';
import 'package:stream_transform/stream_transform.dart';

part 'edit_account_event.dart';
part 'edit_account_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class EditAccountBloc extends Bloc<EditAccountsEvent, EditAccountState> {
  EditAccountBloc() : super(const EditAccountState()) {
    on<EditAccountEvent>(
      _onAccountEdited,
      transformer: throttleDroppable(throttleDuration),
    );
    on<EditAccountChangeStatusEvent>(
      _onInitEvent,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onInitEvent(
    EditAccountChangeStatusEvent event,
    Emitter<EditAccountState> emit,
  ) async {
    emit(state.copyWith(status: event.status));
  }

  Future<void> _onAccountEdited(
    EditAccountEvent event,
    Emitter<EditAccountState> emit,
  ) async {
    emit(state.copyWith(account: event.account));
  }
}
