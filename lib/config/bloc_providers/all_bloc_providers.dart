import 'package:chatbox/features/presentation/bloc/bottomNavBloc/bottom_nav_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class AppBlocProviders{
  static  List<SingleChildWidget>  allBlocProviders=[
    BlocProvider(
              create: (context) => BottomNavBloc(),
            ),
  ];
}