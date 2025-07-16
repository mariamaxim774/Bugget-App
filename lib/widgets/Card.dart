import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../providers/expense_provider.dart';
import 'package:provider/provider.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key});

  @override
  Widget build(BuildContext context) {
    return buildAdaptiveAppCard(context);
  }

  Widget buildAdaptiveAppCard(BuildContext context) {
    if (kIsWeb) {
      return buildWebAppCard(context);
    } else {
      return buildMobileAppCard(context);
    }
  }

  Widget buildMobileAppCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey.shade300,
            offset: const Offset(5, 5),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
          ],
          transform: const GradientRotation(pi / 4),
        ),
      ),
      child: buildCardContent(context),
    );
  }

  Widget buildWebAppCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.width / 4,
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
      child: buildCardContent(context),
    );
  }

  Widget buildCardContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(
          'Total Balance',
          style: TextStyle(
            fontSize:
                kIsWeb
                    ? MediaQuery.of(context).size.width * 0.04
                    : MediaQuery.of(context).size.width * 0.07,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Consumer<ExpenseProvider>(
          builder: (context, expenseProvider, child) {
            return Text(
              '\$ ${4000 - expenseProvider.totalExpenses}',
              style: TextStyle(
                fontSize:
                    kIsWeb
                        ? MediaQuery.of(context).size.width * 0.03
                        : MediaQuery.of(context).size.width * 0.08,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [buildIncomeRow(context), buildExpensesRow(context)],
          ),
        ),
      ],
    );
  }

  Widget buildIncomeRow(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Colors.white30,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.arrow_down,
                    size: 12,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                'Income',
                style: TextStyle(
                  fontSize:
                      kIsWeb
                          ? MediaQuery.of(context).size.width * 0.02
                          : MediaQuery.of(context).size.width * 0.06,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '\$ 2400',
                style: TextStyle(
                  fontSize:
                      kIsWeb
                          ? MediaQuery.of(context).size.width * 0.02
                          : MediaQuery.of(context).size.width * 0.04,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildExpensesRow(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Colors.white30,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.arrow_down,
                    size: 12,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Consumer<ExpenseProvider>(
            builder: (context, expenseProvider, child) {
              return Column(
                children: [
                  Text(
                    'Expenses',
                    style: TextStyle(
                      fontSize:
                          kIsWeb
                              ? MediaQuery.of(context).size.width * 0.02
                              : MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '\$ ${expenseProvider.totalExpenses}',
                    style: TextStyle(
                      fontSize:
                          kIsWeb
                              ? MediaQuery.of(context).size.width * 0.02
                              : MediaQuery.of(context).size.width * 0.04,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
