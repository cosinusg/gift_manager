import 'package:flutter/material.dart';
import 'package:gift_manager/data/storage/shared_preference_data.dart';
import 'package:gift_manager/presentation/login/view/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(child: Text("HomePage")),
          SizedBox(height: 42,),
          TextButton(onPressed: () async {
            await SharedPreferenceData.getInstance().setToken(null);
            Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,);
          }, child: Text('Logout')),
        ],
      ),

    );
  }
}