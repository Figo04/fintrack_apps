import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:fintrack_app/data/models/model_data.dart';
import 'package:fintrack_app/data/service/service_data.dart';
import 'package:fintrack_app/storage_cash/screen/pendapatan.dart';
import 'package:fintrack_app/storage_cash/screen/pengeluaran.dart';
import 'package:fintrack_app/core/themes/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FinancialService _financialService = FinancialService();
  final int _currentUserId = 1;

  double _totalBalance = 0.0;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  List<Map<String, dynamic>> _userAccounts = [];
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final totalBalance =
          await _financialService.getTotalBalance(_currentUserId);
      final userAccounts =
          await _financialService.getUserAccountsWithDetails(_currentUserId);

      final totalIncome =
          await _financialService.getTotalIncome(_currentUserId);
      final totalExpense =
          await _financialService.getTotalExpense(_currentUserId);
      final transactions =
          await _financialService.getTransactionHistory(_currentUserId);

      setState(() {
        _totalBalance = totalBalance;
        _totalIncome = totalIncome;
        _totalExpense = totalExpense;
        _userAccounts = userAccounts;
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _refreshData() => _loadData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header Saldo
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.secondary, AppColors.primary],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total Saldo',
                        style: TextStyle(color: AppColors.white, fontSize: 16),
                      ),
                      Text(
                        FinancialService.formatCurrency(_totalBalance),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Summary Income & Expense
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem("Pemasukan",
                          FinancialService.formatCurrency(_totalIncome),
                          isPositive: true),
                      _buildSummaryItem("Pengeluaran",
                          FinancialService.formatCurrency(_totalExpense)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Header Riwayat Transaksi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Riwayat Transaksi',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_transactions.length} transaksi',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Daftar Transaksi
                Expanded(
                  child: _transactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/icon_1.png',
                                  width: 300, height: 300),
                              const SizedBox(height: 15),
                              const Text('Tidak ada data transaksi',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                              const SizedBox(height: 8),
                              const Text(
                                  'Mulai tambahkan pendapatan atau pengeluaran',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _transactions[index];
                            final isIncome =
                                transaction.type == TransactionType.income;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isIncome
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    isIncome
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded,
                                    color: isIncome ? Colors.green : Colors.red,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  transaction.description,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.account_balance_wallet,
                                            size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            _getAccountName(
                                                transaction.accountId),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time,
                                            size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          _formatDateDetailed(
                                              transaction.createdAt),
                                          style: const TextStyle(
                                              fontSize: 11, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    if (transaction.category.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text(
                                            transaction.category,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${isIncome ? '+' : '-'}${FinancialService.formatCurrency(transaction.amount)}',
                                      style: TextStyle(
                                          color: isIncome
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(isIncome ? 'Masuk' : 'Keluar',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        animatedIconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.third,
        overlayOpacity: 0.1,
        spacing: 12,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.remove_shopping_cart),
            backgroundColor: AppColors.fourty,
            label: 'Pengeluaran',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PengeluaranScreen(userId: _currentUserId,)),
              );
              if (result == true) _refreshData();
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.attach_money),
            backgroundColor: AppColors.fivety,
            label: 'Pendapatan',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PendapatanScreen(userId: _currentUserId)),
              );
              if (result == true) _refreshData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String amount,
      {bool isPositive = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              amount,
              style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateDetailed(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    final dateStr = (dateOnly == today)
        ? 'Hari ini'
        : (dateOnly == yesterday)
            ? 'Kemarin'
            : DateFormat('dd MMM yyyy', 'id_ID').format(date);
    final timeStr = DateFormat('HH:mm').format(date);
    return '$dateStr, $timeStr';
  }

  String _getAccountName(int accountId) {
    try {
      final accountMap =
          _userAccounts.firstWhere((acc) => acc['account'].id == accountId);
      final accountType = accountMap['accountType'] as AccountType;
      return accountType.name;
    } catch (_) {
      return 'Akun Tidak Diketahui';
    }
  }
}
