import 'package:flutter/material.dart';

class TambahSaldoScreen extends StatelessWidget {
  final String walletName;

  const TambahSaldoScreen({Key? key, required this.walletName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Saldo: $walletName")),
      body: Center(
        child: Text("Isi Saldo untuk $walletName"),
      ),
    );
  }
}
