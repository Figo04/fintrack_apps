import 'package:fintrack_app/home/screen/start.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'id_ID', null); // inisialisasi locale Indonesia
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fintrack',
        debugShowCheckedModeBanner: false,
        home: StartScreen() //StreamBuilder(
        //stream: FirebaseAuth.instance.authStateChanges(),
        //builder: (ctx, snapshot) {
        //if (snapshot.connectionState == ConnectionState.waiting) {
        //return const SplashScreen();
        //}

        //if (snapshot.hasData) {
        //return const TabsScreen();
        //}

        //return const StartScreen();
        //}//),
        );
  }
}
