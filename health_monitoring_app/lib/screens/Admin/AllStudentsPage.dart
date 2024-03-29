// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/Student/UserDetails.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';

class AllStudentsPage extends StatefulWidget {
  const AllStudentsPage({super.key});
  @override
  AllStudentsPageState createState() => AllStudentsPageState();
}

class AllStudentsPageState extends State<AllStudentsPage> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allUserStream =
        context.watch<UserProvider>().allUserStream;

    allUserStream.listen((QuerySnapshot snapshot) {
      List<UserModel> updatedUsers = [];

      // Iterate over the documents in the snapshot and convert them to UserModels
      for (var doc in snapshot.docs) {
        UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

        updatedUsers.add(user);
      }

      // Update the users list and filteredUsers list
      setState(() {
        users = updatedUsers;
        filteredUsers = updatedUsers;
      });
    });

    void filterUsers(String query) {
      setState(() {
        filteredUsers = users
            .where((user) =>
                user.name!.toLowerCase().contains(query.toLowerCase()) ||
                user.stdnum!.contains(query) ||
                user.college!.toLowerCase().contains(query.toLowerCase()) ||
                user.course!.toLowerCase().contains(query.toLowerCase()) ||
                user.email!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    final backButton = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IconButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFFA095C1),
            ),
          ),
        )
      ],
    );

    searchEngine() {
      return Column(
        children: [
          backButton,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("🔍 UPLB's Stat",
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                            color: Color(0xFF432C81),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5))),
              )
            ],
          ),
          SizedBox(
              width: 198,
              child: Image.asset(
                'assets/images/The Lifesavers One on One.png',
                fit: BoxFit.fitWidth,
              )),
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterUsers(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Search Student',
                ),
              )),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredUsers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return Container(
                  height: 170,
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserDetails(user: user),
                        ),
                      );
                    },
                    child: Card(
                      color: const Color(0xFFEDECF4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                              color: Color(0xFF432C81), width: 1)),
                      elevation: 4,
                      shadowColor: Colors.black87,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: 120,
                              child: Image.asset(
                                'assets/images/Lifesavers Avatar.png',
                                fit: BoxFit.fitWidth,
                              )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${user.name}",
                                  style: GoogleFonts.raleway(
                                      textStyle: const TextStyle(
                                          color: Color(0xFF432C81),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.5))),
                              const SizedBox(
                                height: 8,
                              ),
                              Wrap(
                                direction: Axis.vertical,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 18),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFEDECF4),
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xFF432C81)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text("${user.college}",
                                          style: GoogleFonts.raleway(
                                              textStyle: const TextStyle(
                                                  color: Color(0xFF432C81),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400)))),
                                  const SizedBox(height: 2),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 18),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFEDECF4),
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xFF432C81)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text("${user.course}",
                                          style: GoogleFonts.raleway(
                                              textStyle: const TextStyle(
                                                  color: Color(0xFF432C81),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400)))),
                                  const SizedBox(height: 2),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 18),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFEDECF4),
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xFF432C81)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text("${user.email}",
                                          style: GoogleFonts.raleway(
                                              textStyle: const TextStyle(
                                                  color: Color(0xFF432C81),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400)))),
                                  const SizedBox(height: 2),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 18),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFEDECF4),
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xFF432C81)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text("${user.stdnum}",
                                          style: GoogleFonts.raleway(
                                              textStyle: const TextStyle(
                                                  color: Color(0xFF432C81),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ],
      );
    }

    return Scaffold(
        body: SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          searchEngine(),
        ],
      ),
    ));
  }
}
