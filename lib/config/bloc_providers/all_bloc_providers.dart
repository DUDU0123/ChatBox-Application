import 'package:chatbox/presentation/bloc/bottomNavBloc/bottom_nav_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class AppBlocProvider{
  static  List<SingleChildWidget>  allBlocProviders=[
    BlocProvider(
              create: (context) => BottomNavBloc(),
            ),
  ];
}