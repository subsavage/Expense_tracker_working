import 'package:expense_tracker_hive/controller/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTxn extends StatefulWidget {
  const AddTxn({super.key});

  @override
  State<AddTxn> createState() => _HomePageState();
}

class _HomePageState extends State<AddTxn> {
  int? amount;
  String note = "Some Expense";
  String type = "Income";
  DateTime selectedDate = DateTime.now();
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022, 11),
      lastDate: DateTime(2100, 01),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: ListView(
          padding: EdgeInsets.all(
            12,
          ),
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Add Transactions",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.attach_money,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      try {
                        amount = int.parse(val);
                      } catch (e) {}
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "0",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.description,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Note on Transaction",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 25),
                    onChanged: (val) {
                      note = val;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.moving_sharp,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ChoiceChip(
                  label: Text(
                    "Income",
                    style: TextStyle(
                      fontSize: 15,
                      color: type == "Income" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Colors.blue,
                  selected: type == "Income" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Income";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                ChoiceChip(
                  label: Text(
                    "Expense",
                    style: TextStyle(
                      fontSize: 15,
                      color: type == "Expense" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Colors.blue,
                  selected: type == "Expense" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Expense";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.description,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${selectedDate.day} ${months[selectedDate.month - 1]}",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (amount != null && note.isNotEmpty) {
                    Dbhelper dbhelper = Dbhelper();
                    await dbhelper.addData(amount!, selectedDate, note, type);
                    Navigator.of(context).pop();
                  } else {
                    print("Please fill all the fields");
                  }
                },
                child: Text(
                  "Add",
                ),
              ),
            ),
          ]),
    );
  }
}
