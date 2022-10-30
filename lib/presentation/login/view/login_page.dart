import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/extentions/theme_extentions.dart';
import 'package:gift_manager/presentation/home/view/home_page.dart';
import 'package:gift_manager/presentation/login/bloc/login_bloc.dart';
import 'package:gift_manager/presentation/login/model/email_error.dart';
import 'package:gift_manager/presentation/login/model/models.dart';
import 'package:gift_manager/presentation/login/model/password_error.dart';
import 'package:gift_manager/presentation/registration/view/registration_page.dart';
import 'package:gift_manager/resources/app_colors.dart';

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
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.authenticated) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HomePage(),
                ),
              );
            }
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.requestError != RequestError.noError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Произошла ошибка',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red[900],
              ));
              context.read<LoginBloc>().add(LoginRequestErrorShowed());
            }
          },
        ),
      ],
      child: Column(
        children: [
          SizedBox(height: 64),
          Center(
            child: Text(
              "Вход",
              style: context.theme.h2,
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
              Text(
                'Еще нет аккаунта?',
                style: context.theme.h4.dynamicColor(
                  context: context,
                  lightThemeColor: AppColors.lightGrey60,
                  darkThemeColor: AppColors.darkWhite60,
                ),
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RegistrationPage())),
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
        selector: (state) => state.allFieldsValid,
        builder: (context, fieldsValid) {
          return ElevatedButton(
            onPressed: fieldsValid
                ? () {
                    context.read<LoginBloc>().add(LoginLoginButtonClicked());
                  }
                : null,
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
      child: BlocSelector<LoginBloc, LoginState, EmailError>(
        selector: (state) => state.emailError,
        builder: (context, emailError) {
          return TextField(
            focusNode: _emailFocusNode,
            onChanged: (text) =>
                context.read<LoginBloc>().add(LoginEmailChanged(text)),
            decoration: InputDecoration(
              labelText: 'Почта',
              errorText: emailError == EmailError.noError
                  ? null
                  : emailError.toString(),
            ),
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          );
        },
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
      child: BlocSelector<LoginBloc, LoginState, PasswordError>(
        selector: (state) => state.passwordError,
        builder: (context, passwordError) {
          return TextField(
            focusNode: _passwordFocusNode,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onChanged: (text) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(text)),
            decoration: InputDecoration(
              labelText: 'Пароль',
              errorText: passwordError == PasswordError.noError
                  ? null
                  : passwordError.toString(),
            ),
            onSubmitted: (_) =>
                context.read<LoginBloc>().add(LoginLoginButtonClicked()),
          );
        },
      ),
    );
  }
}
