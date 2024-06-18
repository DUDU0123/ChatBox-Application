part of 'account_creation_bloc.dart';

@immutable
class AccountCreationState {}

class AccountCreationInitial extends AccountCreationState {}


class AccountCreationLoadingEvent extends AccountCreationState{}
class AccountCreationSuccessEvent extends AccountCreationState{}
class AccountCreationErrorEvent extends AccountCreationState{}

