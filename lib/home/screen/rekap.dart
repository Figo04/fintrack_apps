import 'package:fintrack_app/core/themes/color.dart';
import 'package:flutter/material.dart';

class RekapScreen extends StatefulWidget {
  const RekapScreen({super.key});

  @override
  State<RekapScreen> createState() => _RekapScreenState();
}

class _RekapScreenState extends State<RekapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // header
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondary, AppColors.primary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10, top: 10, right: 250),
            child: Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.history, size: 24), // Ganti icon sesuai kebutuhan
                SizedBox(width: 5),
                Text(
                  'Riwayat ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.only(bottom: 10, top: 10, right: 160),
            child: Text(
              'Riwayat Pendapatan:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 100),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))
              ],
              image: DecorationImage(
                image: AssetImage('assets/images/icon_1.png'),
              ),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.only(bottom: 10, top: 10, right: 160),
            child: Text(
              'Riwayat Pendapatan:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 100),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))
              ],
              image: DecorationImage(
                image: AssetImage('assets/images/icon_1.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
