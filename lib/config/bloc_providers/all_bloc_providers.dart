import 'package:chatbox/data/repositories/auth_repo/authentication_repo_impl.dart';
import 'package:chatbox/data/repositories/user_repository/user_repository_impl.dart';
import 'package:chatbox/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:chatbox/presentation/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class AppBlocProvider {
  static List<SingleChildWidget> allBlocProviders = [
    BlocProvider(
      create: (context) => BottomNavBloc(),
    ),
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: UserRepositoryImpl(),
        authenticationRepo: AuthenticationRepoImpl(),
      )..add(CheckUserLoggedInEvent()),
    ),
  ];
}
