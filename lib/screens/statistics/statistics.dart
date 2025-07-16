import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/expense_provider.dart';
import '../../models/expense_model.dart';

enum Date { Day, Month, Year, None }

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool category = false;
  Date? date;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    bool day = date == Date.Day;
    bool month = date == Date.Month;
    bool year = date == Date.Year;

    final groupedExpenses = Provider.of<ExpenseProvider>(
      context,
    ).groupExpenses(day: day, month: month, year: year, byCategory: category);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Statistics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildFilters(),
            if (isChecked)
              Expanded(
  child: kIsWeb
      ? _buildGroupedExpensesTable(groupedExpenses)
      : buildGroupedExpenseListView(context, groupedExpenses),
)
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sort transactions by:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Wrap(
                spacing: 10,
                children:
                    Date.values.map((d) {
                      return RadioListTile<Date>(
                        value: d,
                        groupValue: date,
                       title: Text(d == Date.None ? "No Date" : d.name),
                        onChanged: (val) => setState(() => date = val),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
              ),
            ),
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Category", style: TextStyle(fontSize: 14)),
                value: category,
                onChanged: (bool value) {
                  setState(() {
                    category = value;
                  });
                },
              ),
            ),
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupedExpensesTable(
    Map<String, List<Expense>> groupedExpenses,
  ) {
    return ListView(
      children:
          groupedExpenses.entries.map((entry) {
            final String groupKey = entry.key;
            final List<Expense> expenses = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Group: $groupKey',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Date')),
                    ],
                    rows:
                        expenses.map<DataRow>((expense) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Image.asset(
                                  'assets/${expense?.category.icon}.png',
                                  width: 30,
                                  height: 30,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(Icons.image_not_supported),
                                ),
                              ),
                              DataCell(Text(expense.category.name)),
                              DataCell(Text('-${expense?.amount} \$')),
                              DataCell(
                                Text(
                                  DateFormat('dd/MM/yyyy').format(expense.date),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

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
            // Titlu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                groupKey,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            // Lista de cheltuieli 
            ...expenses.map((expense) => buildExpenseListItem(context, expense)).toList(),
          ],
        ),
      );
    }).toList(),
  );
}

}
