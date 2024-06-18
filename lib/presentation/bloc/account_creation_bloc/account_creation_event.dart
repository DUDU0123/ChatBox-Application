part of 'account_creation_bloc.dart';

@immutable
sealed class AccountCreationEvent {}

class AccountCreationOtpSentEvent extends AccountCreationEvent{}

class AccountCreatedEvent extends AccountCreationEvent{}
