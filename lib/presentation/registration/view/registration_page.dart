import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gift_manager/extentions/build_context.dart';
import 'package:gift_manager/extentions/theme_extentions.dart';
import 'package:gift_manager/presentation/registration/bloc/registration_bloc.dart';
import 'package:gift_manager/resources/app_colors.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: Scaffold(
        body: _RegistrationPageWidget(),
      ),
    );
  }
}

class _RegistrationPageWidget extends StatefulWidget {
  const _RegistrationPageWidget({Key? key}) : super(key: key);

  @override
  State<_RegistrationPageWidget> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<_RegistrationPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          _AvatarWidget(),
        ],
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(
        left: 8,
        top: 6,
        bottom: 6,
        right: 4,
      ),
      decoration: BoxDecoration(
        color: context.dynamicPlainColor(
            lightThemeColor: AppColors.lightLightBlue100,
            darkThemeColor: AppColors.darkWhite20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.network(
            'https://avatars.dicebear.com/api/croodles/test.svg',
            height: 48,
            width: 48,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Ваш аватар',
            style: context.theme.h3,
          ),
          SizedBox(
            width: 8,
          ),
          Spacer(),
          TextButton(
            onPressed: () => context
                .read<RegistrationBloc>()
                .add(RegistrationChangeAvatar()),
            child: Text('Изменить'),
          ),
        ],
      ),
    );
  }
}
