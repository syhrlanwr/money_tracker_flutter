import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:money_track/api_service.dart';
import 'package:money_track/constant.dart';
import 'package:money_track/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../model/recent.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final simpleFormat = NumberFormat.simpleCurrency(locale: 'id_ID');
  final compactFormat = NumberFormat.compactSimpleCurrency(locale: 'id_ID');
  int? totalBalance;
  int? totalIncome;
  int? totalExpense;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getInformation();
  }

  void getInformation() async {
    ApiService.getBudget().then((value) {
      setState(() {
        totalBalance = value.totalBudget;
      });
    });
    ApiService.getIncome().then((value) {
      setState(() {
        totalIncome = value.total;
      });
    });
    ApiService.getOutcome().then((value) {
      setState(() {
        totalExpense = value.total;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void loadingDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Row(
                children: const [
                  SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text('Loading...'),
                ],
              ),
            );
          });
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add-transaction');
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('MoneyTracker'),
          actions: [
            IconButton(
                onPressed: () async {
                  loadingDialog();
                  await ApiService.logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getInformation();
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: SafeArea(
                child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green[400]!,
                                Colors.green[600]!,
                                Colors.green[800]!,
                              ],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.0))),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(
                              "Total Balance",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22.0, color: Colors.white),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            totalBalance == null
                                ? const Text(
                                    'Loading...',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  )
                                : Text(
                                    simpleFormat
                                        .format(totalBalance)
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  cardIncome(totalIncome.toString()),
                                  cardExpense(totalExpense.toString()),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Transactions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/transaction');
                              },
                              child: const Text('See All'))
                        ],
                      ),
                      FutureBuilder(
                          future: ApiService.getRecent(),
                          builder: (context, snapshot) {
                            debugPrint(snapshot.data?.length.toString());
                            if (snapshot.hasData) {
                              if (snapshot.data?.isEmpty ?? false) {
                                return const Center(
                                  child: Text('No Transaction'),
                                );
                              } else {
                                List<Recent> recent =
                                    snapshot.data as List<Recent>;
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        (recent.length > 5) ? 5 : recent.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          leading: Icon(
                                            recent[index].type == 'income'
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward,
                                            color:
                                                recent[index].type == 'income'
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                          title:
                                              Text(recent[index].description!),
                                          subtitle: Text(recent[index]
                                              .createdAt!
                                              .substring(0, 10)),
                                          trailing: Text(
                                              simpleFormat
                                                  .format(recent[index].amount)
                                                  .toString(),
                                              style: TextStyle(
                                                  color: recent[index].type ==
                                                          'income'
                                                      ? Colors.green
                                                      : Colors.red)),
                                        ),
                                      );
                                    });
                              }
                            } else {
                              return const Text('Loading...');
                            }
                          })
                    ],
                  ),
                ),
              ],
            )),
          ),
        ));
  }
}

Widget cardIncome(String value) {
  final compactFormat = NumberFormat.compactSimpleCurrency(
    locale: 'id_ID',
  );
  return Row(
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
          (value == 'null')
              ? SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  compactFormat.format(int.parse(value)).toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
    ],
  );
}

///////////////

Widget cardExpense(String value) {
  final compactFormat = NumberFormat.compactSimpleCurrency(
    locale: 'id_ID',
  );
  return Row(
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
          (value == 'null')
              ? SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  compactFormat.format(int.parse(value)),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
    ],
  );
}
