import 'dart:convert';

import 'package:boszhan_sales/views/physical_persons/add_new_outlet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';
import '../order/product_list_page.dart';

class OutletListPage extends StatefulWidget {
  @override
  _OutletListPageState createState() => _OutletListPageState();
}

class _OutletListPageState extends State<OutletListPage> {
  final searchController = TextEditingController();
  List<dynamic> outletList = [];

  @override
  void initState() {
    getOutlets();
    super.initState();
  }

  void searchAction() async {
    outletList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responsePhysicalOutlets")!;
    if (data != 'Error') {
      List<dynamic> responseList = jsonDecode(data);
      for (int i = 0; i < responseList.length; i++) {
        if (responseList[i]['name']
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          setState(() {
            outletList.add(responseList[i]);
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            Image.asset(
              "assets/images/bbq_bg.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Scaffold(
              backgroundColor: Colors.white.withOpacity(0.85),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                            child: SizedBox(
                              child: Image.asset("assets/images/logo.png"),
                              width: MediaQuery.of(context).size.width * 0.2,
                            )),
                        Spacer(),
                        Text(
                          'Торговые точки'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 34),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddNewOutlet(0, 0, 1, "0")));
                            },
                            label: Text(
                              "Добавить",
                              style: TextStyle(color: Colors.black),
                            ),
                            icon: Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              minimumSize: const Size.fromHeight(50), // NEW
                            ),
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                    Divider(
                      color: Colors.yellow[700],
                    ),
                    Row(
                      children: [
                        Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: "Поиск",
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            searchAction();
                          },
                          child: Icon(
                            Icons.search,
                            size: 40,
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                    _createDataTable(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Theme _createDataTable() {
    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.yellow[700]),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            showCheckboxColumn: false,
            columns: _createColumns(),
            rows: _createRows(),
            dataRowHeight: 80,
          ),
        ));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Название')),
      DataColumn(label: Text('Адрес')),
      DataColumn(label: Text('Номер телефона')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < outletList.length; i++)
        DataRow(
            onSelectChanged: (newValue) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductListPage(
                          outletList[i]['name'],
                          outletList[i]['discount'],
                          outletList[i]['id'],
                          0,
                          outletList[i]['salesrep']['name'],
                          0,
                          1,
                          '0',
                          outletList[i])));
            },
            cells: [
              DataCell(Text(outletList[i]['name'])),
              DataCell(Text(outletList[i]['address'])),
              DataCell(Text(outletList[i]['phone'])),
            ]),
    ];
  }

  void getOutlets() async {
    outletList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("responsePhysicalOutlets")!;
    if (data != 'Error') {
      List<dynamic> responseList = jsonDecode(data);
      setState(() {
        outletList = responseList;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.", style: TextStyle(fontSize: 20)),
      ));
    }
  }
}
