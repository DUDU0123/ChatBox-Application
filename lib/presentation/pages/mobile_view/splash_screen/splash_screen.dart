import 'package:chatbox/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:chatbox/presentation/widgets/common_widgets/app_icon_hold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationInitial) {
            state.isUserSignedIn
                ? Navigator.pushNamedAndRemoveUntil(
                    context,
                    "bottomNav_Navigator",
                    (route) => false,
                  )
                : Navigator.pushNamed(
                    context,
                    "welcome_page",
                  );
          }
        },
        child: const Center(
          child: AppIconHoldWidget(),
        ),
      ),
    );
  }
}
