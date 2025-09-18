import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIStudentCRUD extends StatefulWidget {
  const APIStudentCRUD({super.key});
  @override
  State<APIStudentCRUD> createState() => _APIStudentCRUDState();
}

class _APIStudentCRUDState extends State<APIStudentCRUD> {
  @override
  void initState() {
    super.initState();
    getstudent();
  }

  String url = "https://68bfef970b196b9ce1c2931b.mockapi.io/Student";
  Future<void> getstudent() async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        setState(() {
          students = json.decode(res.body);
        });
      } else {
        print("Get failed ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("error in get Student $e");
    }
  }

  Future<void> addStudent(Map data) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        await getstudent();
      } else {
        print("Post failed ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("error in Add Student $e");
    }
  }

  Future<void> updateStudent(String id, Map data) async {
    try {
      final res = await http.put(
        Uri.parse("$url/$id"),
        body: json.encode(data),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        await getstudent();
      } else {
        print("Update failed ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("error in Update Student$e");
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      final res = await http.delete(Uri.parse("$url/$id"));
      if (res.statusCode == 201 || res.statusCode == 200) {
        await getstudent();
      } else {
        print("Delete failed ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("error in delete Student $e");
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  String? gender;
  List<String> hobbies = ['Movie', 'Game', 'Travel'];
  List<String> selHobbies = [];
  String? editId; // changed to String
  List students = [];
  void resetForm() {
    name.clear();
    gender = null;
    selHobbies.clear();
    editId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    // Name
                    Row(
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text(
                            "Enter Name :",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: name,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Name",
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 2),
                              ),
                              prefixIcon: const Icon(Icons.person),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Gender
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(
                              width: 150,
                              child: Text(
                                "Enter Gender : ",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: const Text("Male"),
                                secondary: Icon(
                                  Icons.male,
                                  color: Colors.red.shade900,
                                ),
                                value: "Male",
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 150),
                            Expanded(
                              child: RadioListTile(
                                title: const Text("Female"),
                                secondary: Icon(
                                  Icons.female,
                                  color: Colors.red.shade900,
                                ),
                                value: "Female",
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Hobbies
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text(
                            "Enter Hobbies :",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: hobbies
                                .map(
                                  (hobby) => CheckboxListTile(
                                    title: Text(hobby),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: selHobbies.contains(hobby),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          selHobbies.add(hobby);
                                        } else {
                                          selHobbies.remove(hobby);
                                        }
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Map<String, dynamic> student = {
                                "name": name.text,
                                "gender": gender,
                                "hobbies": selHobbies,
                              };
                              if (editId == null) {
                                addStudent(student);
                              } else {
                                updateStudent(editId!, student);
                              }
                              resetForm();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(editId == null ? "Submit" : "Update"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: resetForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              "Reset",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Student List
              const Text(
                "Student List",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    color: Colors.grey.shade400,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade800),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.numbers),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(student['id'].toString()),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.person),
                                    const SizedBox(width: 5),
                                    Expanded(child: Text(student['name'])),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      student['gender'] == 'Male'
                                          ? Icons.male
                                          : Icons.female,
                                      color: student['gender'] == 'Male'
                                          ? Colors.blue
                                          : Colors.pink,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        student['gender'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.palette_outlined),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        student['hobbies'].toString(),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await deleteStudent(
                                          student['id'].toString(),
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          editId = student['id']; // keep string
                                          name.text = student['name'];
                                          gender = student['gender'];
                                          selHobbies = List<String>.from(
                                            student['hobbies'],
                                          );
                                        });
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
