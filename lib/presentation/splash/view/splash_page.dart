import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/presentation/home/view/home_page.dart';
import 'package:gift_manager/presentation/login/view/login_page.dart';
import 'package:gift_manager/presentation/splash/bloc/splash_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = SplashBloc();
    _bloc.add(SplashLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashUnauthorized) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginPage()));
          } else if (state is SplashAuthorized) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
          }
        },
        child: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
