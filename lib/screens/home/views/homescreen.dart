import 'package:bugget_app/screens/add_expense/views/add_expense.dart';
import 'package:bugget_app/screens/home/views/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:bugget_app/screens/statistics/statistics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return buildPlatformSpecificWidget(context);
  }

  Widget buildPlatformSpecificWidget(BuildContext context) {
    if (kIsWeb) {
      return buildWebLayout(context);
      //app bar 

    } else {
      return buildMobileLayout(context);
      //bottom navigation bar

    }
  }

  Widget buildWebLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Tracker App"),
        shape: const RoundedRectangleBorder(),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.home, color: Colors.white),
        ),
        backgroundColor: Color(0xFFFECBDA),
        actions: <Widget>[
          // butonul de navigare pentru adaugarea unui nou expense
          MaterialButton( 
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AddExpense(),
                ),
              );
            },
            shape: const CircleBorder(),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.tertiary,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary,
                  ],
                  transform: const GradientRotation(pi / 4),
                ),
              ),
              child: const Icon(CupertinoIcons.add, color: Colors.white),
            ),
          ),

          //butonul pentru pagina de statistici
          IconButton(
            icon: const Icon(
              CupertinoIcons.graph_square_fill,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const StatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: const MainScreen(),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 3,
        items: [
          //butonul pentru acasa
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(CupertinoIcons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const HomeScreen(),
                  ),
                );
              },
            ),
            label: 'Home',
          ),

          //butonul pentru statistici
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(CupertinoIcons.graph_square_fill),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const StatisticsScreen(),
                  ),
                );
              },
            ),
            label: 'Stats',
          ),
        ],
      ),

      //butonul pentru adaugarea unui nou expense
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const AddExpense(),
            ),
          );
        },
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
              transform: const GradientRotation(pi / 4),
            ),
          ),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      body: const MainScreen(),
    );
  }

  
}
