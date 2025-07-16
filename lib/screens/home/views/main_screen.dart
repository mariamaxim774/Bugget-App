import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../widgets/Card.dart';
import '../../../providers/expense_provider.dart';
import 'package:provider/provider.dart';
import '../../../models/expense_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:math';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return buildPlatformSpecificWidget(context);
  }

  Widget buildPlatformSpecificWidget(BuildContext context) {
    if (kIsWeb) {
      return buildWebLayout(context);
      //expenses sunt afisate intr un tabel
    } else {
      return buildMobileLayout(context);
      //expenses sunt afisate intr o lista
    }
  }

  Widget buildWebLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  buildProfileHeader(
                    context,
                  ), //headerul pentru profilul userului
                  const SizedBox(height: 15),
                  AppCard(), //Cardul meu
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  // afisez doar daca sunt elemente in lista de expenses
                  buildTransactionsHeader(context),
                  if (Provider.of<ExpenseProvider>(
                    context,
                    listen: false,
                  ).expenses.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Expanded(
                      //tabelul de expenses
                      child: Column(children: [buildExpenseDataTable(context)]),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExpenseDataTable(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        return DataTable(
          columns: const [
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Date')),
          ],
          rows:
              expenseProvider.expenses
                  .map(
                    (expense) => DataRow(
                      cells: [
                        DataCell(
                          Container(
                            color: expense.category.color,
                            child: Image.asset(
                              'assets/${expense.category.icon}.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                        DataCell(Text(expense.category.name)),
                        DataCell(Text('-${expense.amount} \$')),
                        DataCell(
                          Text(DateFormat('dd/MM/yyyy').format(expense.date)),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            //profile header
            buildProfileHeader(context),
            const SizedBox(height: 15),
            AppCard(), //cardul
            const SizedBox(height: 40),
            buildTransactionsHeader(context), //headerul pentru tranzactii
            const SizedBox(height: 20),
            Expanded(
              child: buildExpenseListView(context),
            ), //lista de tranzactii
          ],
        ),
      ),
    );
  }

  Widget buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                //cercul din jurul iconitei
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow[700],
                ),
              ),
              Icon(
                CupertinoIcons.person_fill,
                color: Colors.yellow[900],
              ), //iconita persoana
            ],
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              Text(
                "Maria",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTransactionsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        kIsWeb ?
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Colors.grey.shade400,
                offset: const Offset(3, 3),
              ),
            ],
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.tertiary,
              ],
              transform: const GradientRotation(pi / 6),
            ),
          ),
          child: Text(
            "Transactions",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ) 
        :
        Text(
            "Transactions",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget buildExpenseListView(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        return ListView.builder(
          itemCount: expenseProvider.expenses.length,
          itemBuilder: (context, index) {
            final expense = expenseProvider.expenses[index];
            return buildExpenseListItem(context, expense);
          },
        );
      },
    );
  }

//construim elementele din lista in functie de categoria lor
  Widget buildExpenseListItem(BuildContext context, Expense expense) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: expense.category.color, //culoarea categoriei
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container( //ajuta la setarea marimii imaginii
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/${expense.category.icon}.png', //imaginea pentru icon
                            ),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Text(
                    expense.category.name, //numele categoriei
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(//suma+data
                children: [
                  Text(
                    '-${expense.amount} \$', //suma
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(expense.date),//data
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGroupedExpenseListView(BuildContext context, Map<String, List<Expense>> groupedExpenses) {
  return ListView(
    children: groupedExpenses.entries.map((entry) {
      final String groupKey = entry.key;
      final List<Expense> expenses = entry.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titlu grup
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                groupKey,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            // Lista de cheltuieli din grup
            ...expenses.map((expense) => buildExpenseListItem(context, expense)).toList(),
          ],
        ),
      );
    }).toList(),
  );
}

}
