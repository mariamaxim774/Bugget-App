import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../../widgets/AppButton.dart';
import '../../../widgets/CustomFormField.dart';
import '../../../providers/category_provider.dart';
import '../../../models/category_model.dart';
import '../../../providers/expense_provider.dart';
import '../../../models/expense_model.dart';
import '../../home/views/homescreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//pagina in care se adauga un nou expense
class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectDate = DateTime.now();

  //lista de iconite
  List<String> myCategoriesIcons = [
    'animals',
    'cinema',
    'food',
    'home',
    'shopping',
    'tech',
    'travel',
  ];

  //butonul de afisare
  bool afiseazaCategoriile = false;
  //creez o noua categorie
  bool creeazaCategorie = false;

  @override
  void initState() {
    dateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now()); // setez data initiala din formular la data de azi
    super.initState();
  }

  void afiseazaCategoriileFunc({bool? newValue}) {
    setState(() {
      if (newValue == null) {
        afiseazaCategoriile = !afiseazaCategoriile;
      } else {
        afiseazaCategoriile = newValue;
      }
    });
  }

  void creeazaCategoriileFunc() {
    setState(() {
      creeazaCategorie = !creeazaCategorie;
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildPlatformSpecificWidget(context);
  }

  Widget buildPlatformSpecificWidget(BuildContext context) {
    if (kIsWeb) {
      return buildWebLayout(context); //build web layout pentru partea de web
      //la crearea unei categorii apare o lista
      //column type
    } else {
      return buildMobileLayout(context); //build mobile pentru mobile
      //la crearea unei categorii apare un dialog window
      //row type
    }
  }

  Widget buildWebLayout(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 10),
                        //suma
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: insertExpense(context),
                        ),

                        //category Form
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: categoryForm(context),
                        ),

                        //date form
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: dateForm(context),
                        ),

                        //buton de save final
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: CustomButton(
                            text: "Save",
                            onPressed: () {
                              final selectedCategory =
                                  Provider.of<CategoryProvider>(
                                    context,
                                    listen: false,
                                  ).selectedCategory;
                              if (selectedCategory != null &&
                                  double.tryParse(expenseController.text) !=
                                      null) {
                                Expense newExpense = Expense(
                                  amount: double.parse(expenseController.text),
                                  category: selectedCategory,
                                  date: DateFormat(
                                    "dd/MM/yyyy",
                                  ).parse(dateController.text),
                                );
                                Provider.of<ExpenseProvider>(
                                  context,
                                  listen: false,
                                ).addExpense(newExpense);

                                Navigator.push(
                                  // ma intorc la pagina de home
                                  context,
                                  MaterialPageRoute<void>(
                                    builder:
                                        (BuildContext context) =>
                                            const HomeScreen(),
                                  ),
                                );
                              } else {
                                //tratare erori
                                if (selectedCategory == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Please select a category"),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Please insert an amount"),
                                    ),
                                  );
                                }
                              }
                              ;
                            },
                            backgroundColor: Colors.black,
                            borderRadius: 12,
                            fontSize: 22,
                            textColor: Colors.white,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (afiseazaCategoriile)
              Column(
                children: [
                  SizedBox(height: 20),
                  if (Provider.of<CategoryProvider>(
                    context,
                    listen: false,
                  ).categories.isNotEmpty) ...[
                    Title(
                      color: Colors.black,
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ] else ...[
                    Title(
                      color: Colors.black,
                      child: Text(
                        "Please add a new category!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                  //lista cu categoriile
                  SizedBox(
                    width: double.maxFinite,
                    child: Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: categoryProvider.categories.length,
                          itemBuilder: (context, index) {
                            final category = categoryProvider.categories[index];
                            return ListTile(
                              title: Text(category.name),
                              onTap: () {
                                Provider.of<CategoryProvider>(
                                  context,
                                  listen: false,
                                ).setSelectedCategory(category);
                                categoryController.text =
                                    category
                                        .name; // setez numele categorie la categoria selectata pentru a adauga un expense
                                afiseazaCategoriileFunc(newValue: false);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: Column(
          // aici sunt sub forma de coloana
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Add expenses",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            insertExpense(context), // adaugarea pretului
            SizedBox(height: 10),
            categoryForm(context), //formularul pentru adaugarea categoriei
            SizedBox(height: 10),
            dateForm(context), //formularul pentru data
            SizedBox(height: 10),

            //Save final
            SizedBox(height: 16),
            CustomButton(
              text: "Save",
              onPressed: () {
                final selectedCategory =
                    Provider.of<CategoryProvider>(
                      context,
                      listen: false,
                    ).selectedCategory;
                if (selectedCategory != null &&
                    double.tryParse(expenseController.text) != null) {
                  Expense newExpense = Expense(
                    amount: double.parse(expenseController.text),
                    category: selectedCategory,
                    date: DateFormat("dd/MM/yyyy").parse(dateController.text),
                  );
                  Provider.of<ExpenseProvider>(
                    context,
                    listen: false,
                  ).addExpense(newExpense);

                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const HomeScreen(),
                    ),
                  );
                } else {
                  //tratare erori
                  if (selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select a category")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please insert an amount")),
                    );
                  }
                }
              },
              backgroundColor: Colors.black,
              borderRadius: 12,
              fontSize: 22,
              textColor: Colors.white,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryForm(BuildContext context) {
    return CustomFormField(
      readOnly: true,
      prefixOnTap: () {
        !kIsWeb
            ? showDialog(
              //pe android afisez ca un dialog
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text("Select a category"),
                  content: Container(
                    width: double.maxFinite,
                    child: Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: categoryProvider.categories.length,
                          itemBuilder: (context, index) {
                            final category = categoryProvider.categories[index];
                            return ListTile(
                              title: Text(category.name),
                              onTap: () {
                                Provider.of<CategoryProvider>(
                                  context,
                                  listen: false,
                                ).setSelectedCategory(category);
                                categoryController.text = category.name;
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            )
            : afiseazaCategoriileFunc(); //la web le afisez direct in buildWebLayout
      },
      suffixOnTap: () {
        //partea de adaugare categorie noua
        afiseazaCategoriileFunc(newValue: false);
        showDialog(
          context: context,
          builder: (ctx) {
            bool isExpanded = false;
            String iconSelected = '';
            Color categoryColor = Colors.white;
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text("Create a category"),
                  content: SingleChildScrollView(
                    child: Container(
                      width:
                          kIsWeb
                              ? MediaQuery.of(context).size.width / 2
                              : 200, // vreau dimensiuni diferite pentru web si android
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 16),
                            CustomFormField(
                              //numele categoriei
                              textEditingController: categoryNameController,
                              hintText: 'Name',
                              isFilled: true,
                              isDense: true,
                              fillColor: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            SizedBox(height: 16),
                            CustomFormField(
                              //iconita
                              suffixOnTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              readOnly: true,
                              hintText: 'Icon',
                              isFilled: true,
                              isDense: true,
                              fillColor: Colors.white,
                              borderRadius:
                                  isExpanded
                                      ? BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      )
                                      : BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                              sufixIcon: CupertinoIcons.chevron_down,
                              hasSuffix: true,
                              iconSize: 10,
                            ),
                            if (isExpanded)
                              Container(
                                //iconitele
                                height:
                                    kIsWeb
                                        ? MediaQuery.of(context).size.width / 10
                                        : 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: kIsWeb ? 7 : 3,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                        ),
                                    itemCount: myCategoriesIcons.length,
                                    itemBuilder: (context, int i) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            iconSelected = myCategoriesIcons[i];
                                          });
                                        },

                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 3,
                                              color:
                                                  iconSelected ==
                                                          myCategoriesIcons[i]
                                                      ? Colors.greenAccent
                                                      : Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/${myCategoriesIcons[i]}.png',
                                              ),
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            SizedBox(height: 16),
                            CustomFormField(
                              //alegere culoare
                              readOnly: true,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ColorPicker(
                                            pickerColor: Colors.white,
                                            onColorChanged: (value) {
                                              setState(() {
                                                categoryColor = value;
                                              });
                                            },
                                          ),
                                          if (kIsWeb) SizedBox(height: 10),
                                          CustomButton(
                                            text: "Save",
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            height: 70,
                                            backgroundColor: Colors.black,
                                            borderRadius: 12,
                                            fontSize: 22,
                                            textColor: Colors.white,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },

                              hintText: 'Colors',
                              isFilled: true,
                              isDense: true,
                              fillColor: categoryColor,
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            SizedBox(height: 14),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomButton(
                                //buton salvare categorie
                                text: "Save category",
                                onPressed: () {
                                  Category newCategory = Category(
                                    name: categoryNameController.text,
                                    color: categoryColor,
                                    icon: iconSelected,
                                  );

                                  Provider.of<CategoryProvider>(
                                    context,
                                    listen: false,
                                  ).addCategory(newCategory);

                                  Navigator.pop(ctx);
                                },
                                height: 50,
                                backgroundColor: Colors.black,
                                borderRadius: 12,
                                fontSize: 22,
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      textEditingController: categoryController,
      hintText: 'Category',
      isFilled: true,
      fillColor: Colors.white,
      prefixIcon: FontAwesomeIcons.list,
      hasPrefix: true,
      iconSize: 16,
      iconColor: Colors.grey,
      sufixIcon: FontAwesomeIcons.plus,
      hasSuffix: true,
      hasTextLabel: true,
      label: "Category",
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
  }

  Widget dateForm(BuildContext context) {
    //formular pentru data
    return CustomFormField(
      textEditingController: dateController,
      readOnly: true,
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: selectDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (newDate != null) {
          setState(() {
            selectDate = newDate;
            dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
          });
        }
      },
      isFilled: true,
      fillColor: Colors.white,
      prefixIcon: FontAwesomeIcons.clock,
      hasPrefix: true,
      iconColor: Colors.grey,
      iconSize: 16,
      hasTextLabel: true,
      label: "Date",
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
      textAlignVertical: TextAlignVertical.center,
    );
  }

  Widget insertExpense(BuildContext context) {
    //inserare nou expense
    return CustomFormField(
      hintText: kIsWeb ? "Amount.." : "",
      textEditingController: expenseController,
      isFilled: true,
      fillColor: Colors.white,
      hasPrefix: true,
      prefixIcon: FontAwesomeIcons.dollarSign,
      iconSize: 16,
      iconColor: Colors.grey,
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    );
  }
}
