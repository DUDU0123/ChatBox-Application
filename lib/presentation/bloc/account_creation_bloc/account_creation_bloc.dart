import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'account_creation_event.dart';
part 'account_creation_state.dart';

class AccountCreationBloc extends Bloc<AccountCreationEvent, AccountCreationState> {
  AccountCreationBloc() : super(AccountCreationInitial()) {
    on<AccountCreationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
