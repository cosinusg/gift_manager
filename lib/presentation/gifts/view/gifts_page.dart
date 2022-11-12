import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/di/service_locator.dart';
import 'package:gift_manager/presentation/gifts/bloc/gifts_bloc.dart';
import 'package:gift_manager/presentation/login/view/login_page.dart';

class GiftsPage extends StatelessWidget {
  const GiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<GiftsBloc>()..add(GiftsPageLoaded()),
      child: _GiftsPageWidget(),
    );
  }
}

class _GiftsPageWidget extends StatelessWidget {
  const _GiftsPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<GiftsBloc, GiftsState>(
        builder: (context, state) {
          if (state is InitialGiftsLoadingState) {
            //TODO
          } else if (state is NoGiftsState) {
            //TODO
          } else if (state is InitialLoadingErrorState) {
            //TODO
          } else if (state is LoadedGiftsState) {
            //TODO
          }
          debugPrint("Unknown state $state");
          //TODO
          return Text("GiftsPage");
        },
      ),
    );
  }
}
