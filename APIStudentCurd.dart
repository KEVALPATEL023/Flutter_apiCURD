import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(
    const MaterialApp(home: demoApi(), debugShowCheckedModeBanner: false),
  );
}
class demoApi extends StatefulWidget {
  const demoApi({super.key});
  @override
  State<demoApi> createState() => _demoApiState();
}

class _demoApiState extends State<demoApi> {
  TextEditingController name = TextEditingController();
  int? editID;
  List demo = [];
  String url = "https://68cab2a0430c4476c34a90de.mockapi.io/demo";
  Future<void> getData() async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        setState(() {
          demo = json.decode(res.body);
        });
      } else {
        print("Get failed ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("error $e");
    }
  }

  Future<void> AddData(Map data) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        await getData();
      } else {
        print("Get failed ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("error $e");
    }
  }

  Future<void> UpdateData(int id, Map data) async {
    try {
      final res = await http.put(
        Uri.parse("$url/$id"),
        body: json.encode(data),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        await getData();
      } else {
        print("Get failed ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("error $e");
    }
  }

  Future<void> RemoveData(int id) async {
    try {
      final res = await http.delete(
        Uri.parse("$url/$id"),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        await getData();
      } else {
        print("Get failed ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("demo api")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 150, child: Text("enter name")),
                  Expanded(
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(labelText: "enter name"),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> demo = {"name": name.text};
                      if (editID == null) {
                        AddData(demo);
                        name.clear();
                      } else {
                        UpdateData(editID!, demo);
                        editID = null;
                        name.clear();
                      }
                    },
                    child: Text(editID == null ? "Submit" : "Update"),
                  ),
                ],
              ),
              SizedBox(height: 50, child: Text("data")),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: demo.length,
                itemBuilder: (context, index) {
                  final demos = demo[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(child: Text(demos["id"].toString())),
                          SizedBox(width: 50),
                          Expanded(child: Text(demos["name"])),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                name.text = demos["name"];
                                editID = int.tryParse(demos["id"].toString());
                                UpdateData(demos["id"], demos);
                              });
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              RemoveData(int.tryParse(demos["id"].toString())!);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
