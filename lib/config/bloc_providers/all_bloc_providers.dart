import 'package:chatbox/data/data_sources/contact_data/contact_data.dart';
import 'package:chatbox/data/data_sources/user_data/user_data.dart';
import 'package:chatbox/data/repositories/auth_repo/authentication_repo_impl.dart';
import 'package:chatbox/data/repositories/contact_repository/contact_repo_impl.dart';
import 'package:chatbox/data/repositories/user_repository/user_repository_impl.dart';
import 'package:chatbox/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:chatbox/presentation/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:chatbox/presentation/bloc/contact/contact_bloc.dart';
import 'package:chatbox/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class AppBlocProvider {
  static List<SingleChildWidget> allBlocProviders = [
    BlocProvider(
      create: (context) => BottomNavBloc(),
    ),
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: UserRepositoryImpl(userData: UserData()),
        authenticationRepo: AuthenticationRepoImpl(),
      )..add(CheckUserLoggedInEvent()),
    ),
    BlocProvider(
      create: (context) => ContactBloc(
        contactRepository: ContactRepoImpl(
          contactData: ContactData(),
          firebaseFirestore: FirebaseFirestore.instance,
        ),
      ),
    ),
    BlocProvider(
      create: (context) => MessageBloc(),
    ),
    BlocProvider(
      create: (context) => UserBloc(
        firebaseAuth: FirebaseAuth.instance,
        userRepository: UserRepositoryImpl(
          userData: UserData(),
        ),
      )..add(GetCurrentUserData()),
    ),
  ];
}
