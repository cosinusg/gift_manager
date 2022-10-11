import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/presentation/home/view/home_page.dart';
import 'package:gift_manager/presentation/login/bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: _LoginPageWidget(),
      ),
    );
  }
}

class _LoginPageWidget extends StatefulWidget {
  const _LoginPageWidget({Key? key}) : super(key: key);

  @override
  State<_LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<_LoginPageWidget> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.authenticated) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => HomePage(),
            ),
          );
        }
      },
      child: Column(
        children: [
          SizedBox(height: 64),
          Center(
            child: Text(
              "Вход",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
          ),
          Spacer(flex: 88),
          _EmailField(
              emailFocusNode: _emailFocusNode,
              passwordFocusNode: _passwordFocusNode),
          SizedBox(
            height: 8,
          ),
          _PasswordField(passwordFocusNode: _passwordFocusNode),
          SizedBox(
            height: 40,
          ),
          _LoginButton(),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Еще нет аккаунта?'),
              TextButton(
                  onPressed: () => debugPrint('Нажали кнопку Создать'),
                  child: Text('Создать')),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          TextButton(
              onPressed: () => debugPrint('Нажали кнопку Не помню пароль'),
              child: Text('Не помню пароль')),
          Spacer(flex: 284),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 36),
      width: double.infinity,
      child: BlocSelector<LoginBloc, LoginState, bool>(
        selector: (state) {
          return (state.emailValid && state.passwordValid);
        },
        builder: (context, fieldsValid) {
          return ElevatedButton(
            onPressed: fieldsValid ? () {
              context.read<LoginBloc>().add(LoginLoginButtonClicked());
            } : null,
            child: Text('Войти'),
          );
        },
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    Key? key,
    required FocusNode emailFocusNode,
    required FocusNode passwordFocusNode,
  })  : _emailFocusNode = emailFocusNode,
        _passwordFocusNode = passwordFocusNode,
        super(key: key);

  final FocusNode _emailFocusNode;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 36,
      ),
      child: TextField(
        focusNode: _emailFocusNode,
        onChanged: (text) =>
            context.read<LoginBloc>().add(LoginEmailChanged(text)),
        decoration: InputDecoration(hintText: 'Почта'),
        onSubmitted: (_) => _passwordFocusNode.requestFocus(),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    Key? key,
    required FocusNode passwordFocusNode,
  })  : _passwordFocusNode = passwordFocusNode,
        super(key: key);

  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 36,
      ),
      child: TextField(
        focusNode: _passwordFocusNode,
        onChanged: (text) =>
            context.read<LoginBloc>().add(LoginPasswordChanged(text)),
        decoration: InputDecoration(hintText: 'Пароль'),
        onSubmitted: (_) =>
            context.read<LoginBloc>().add(LoginLoginButtonClicked()),
      ),
    );
  }
}
