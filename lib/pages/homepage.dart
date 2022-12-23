import 'package:expense_tracker_hive/controller/db_helper.dart';
import 'package:expense_tracker_hive/pages/add_txn.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dbhelper dbhelper = Dbhelper();
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;

  getTotalBalance(Map entireData) {
    totalExpense = 0;
    totalIncome = 0;
    totalBalance = 0;
    entireData.forEach((key, value) {
      print(value);
      if (value['type'] == 'Income') {
        totalBalance += (value['amount'] as int);
        totalIncome += (value['amount'] as int);
      } else {
        totalBalance -= (value['amount'] as int);
        totalExpense += (value['amount'] as int);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddTxn(),
            ),
          )
              .whenComplete(() {
            setState(() {});
          });
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: FutureBuilder<Map>(
          future: dbhelper.fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Unexpected Error"),
              );
            }
            if (snapshot.hasData) {
              getTotalBalance(snapshot.data!);
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white70,
                              ),
                              padding: EdgeInsets.all(12),
                            ),
                            Text(
                              "Hey There",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            )
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white70,
                          ),
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.settings,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.all(
                      12,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade600,
                              offset: Offset(5, 5),
                              blurRadius: 15,
                              spreadRadius: 1),
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5, -5),
                              blurRadius: 15,
                              spreadRadius: 1)
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 8,
                      ),
                      child: Column(children: [
                        Text(
                          "Total Balance",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Rs $totalBalance",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardIncome(
                                totalIncome.toString(),
                              ),
                              cardExpense(
                                totalExpense.toString(),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Total Expenses",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map dataAtIndex = snapshot.data![index];
                      if (dataAtIndex['type'] == 'Income') {
                        return incomeTile(
                          dataAtIndex['amount'],
                          dataAtIndex['note'],
                        );
                      } else {
                        return expenseTile(
                          dataAtIndex['amount'],
                          dataAtIndex['note'],
                        );
                      }
                    },
                  )
                ],
              );
            }
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text("No Values Found"),
              );
            } else {
              return Center(
                child: Text("Unexpected Error"),
              );
            }
          }),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.amber,
              ],
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          padding: EdgeInsets.all(6),
          child: Icon(
            Icons.arrow_downward_rounded,
            size: 25,
          ),
          margin: EdgeInsets.only(right: 8),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.amber,
              ],
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          padding: EdgeInsets.all(6),
          child: Icon(
            Icons.arrow_upward_rounded,
            size: 25,
          ),
          margin: EdgeInsets.only(right: 8),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget expenseTile(int value, String note) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 190, 209, 218),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_up_outlined,
                size: 30,
                color: Colors.red,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "Expense",
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
          Text(
            "- $value",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }

  Widget incomeTile(int value, String note) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 190, 209, 218),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_down_outlined,
                size: 30,
                color: Colors.green,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "Income",
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
          Text(
            "+ $value",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
