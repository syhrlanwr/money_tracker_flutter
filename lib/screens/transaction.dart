import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_track/api_service.dart';
import 'package:money_track/constant.dart';
import 'package:money_track/model/income.dart';
import 'package:http/http.dart' as http;
import 'package:money_track/model/outcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  Income? income;
  Outcome? outcome;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIncome();
    getOutcome();
  }

  void getIncome() async {
    ApiService.getIncome().then((value) {
      setState(() {
        income = value;
      });
    });
  }

  void getOutcome() async {
    ApiService.getOutcome().then((value) {
      setState(() {
        outcome = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final simpleFormat = NumberFormat.simpleCurrency(
      locale: 'id_ID',
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Income',
              ),
              Tab(
                text: 'Expense',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  20.0,
                                ),
                              ),
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.arrow_upward,
                                size: 28.0,
                                color: Colors.green[700],
                              ),
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Income",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white70,
                                  ),
                                ),
                                (income == null)
                                    ? SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        simpleFormat.format(income!.total),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            (income == null) ? 0 : income!.income!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              Icons.arrow_upward,
                              color: Colors.green,
                            ),
                            title: Text(
                              income!.income![index].description,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              income!.income![index].createdAt.substring(0, 10),
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            trailing: Text(
                              simpleFormat.format(
                                income!.income![index].amount,
                              ),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Delete'),
                                    content: Text(
                                        'Are you sure want to delete this transaction?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteIncome(
                                            income!.income![index].id,
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  )),
            ),
            SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  20.0,
                                ),
                              ),
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.arrow_downward,
                                size: 28.0,
                                color: Colors.red[700],
                              ),
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Expense",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white70,
                                  ),
                                ),
                                (outcome == null)
                                    ? SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        simpleFormat.format(outcome!.total),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            (outcome == null) ? 0 : outcome!.outcome!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              Icons.arrow_downward,
                              color: Colors.red,
                            ),
                            title: Text(
                              outcome!.outcome![index].description!,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              outcome!.outcome![index].createdAt!
                                  .substring(0, 10),
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            trailing: Text(
                              simpleFormat.format(
                                outcome!.outcome![index].amount!,
                              ),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Delete'),
                                    content: Text(
                                        'Are you sure want to delete this transaction?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteOutcome(
                                            outcome!.outcome![index].id!,
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void deleteIncome(int i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    debugPrint(token);
    var url =
        Uri.https(Constant.baseUrl, '${Constant.incomeEndpoint}/delete/$i');
    debugPrint(url.toString());
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction deleted'),
        ),
      );
      getIncome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete transaction'),
        ),
      );
    }
  }

  void deleteOutcome(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    debugPrint(token);
    var url =
        Uri.https(Constant.baseUrl, '${Constant.outcomeEndpoint}/delete/$id');
    debugPrint(url.toString());
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction deleted'),
        ),
      );
      getOutcome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete transaction'),
        ),
      );
    }
  }
}
