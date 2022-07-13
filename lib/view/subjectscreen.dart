import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/constant.dart';
import 'package:mytutor/model/user.dart';
import 'package:mytutor/model/subject.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/view/cartscreen.dart';

class SubjectScreen extends StatefulWidget {
  final User user;
  const SubjectScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  // ignore: prefer_typing_uninitialized_variables
  var numofpage, curpage = 1;
  // ignore: prefer_typing_uninitialized_variables
  var color;
  int cart = 0;

  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
    super.initState();
    _loadSubjects(1, search);
  }

  void _loadSubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/load_subject.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
        } else {
          titlecenter = "No Subject Available";
          subjectList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Product Available";
        subjectList.clear();
        setState(() {});
      }
    });
  }

  void _loadDetailDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Subject Detail"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 150,
                    child: CachedNetworkImage(
                      imageUrl: CONSTANTS.server +
                          "/mytutor/assets/courses/" +
                          subjectList[index].subjectId.toString() +
                          '.png',
                      fit: BoxFit.contain,
                      width: resWidth,
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.badge,
                            color: Colors.black,
                          ),
                          title: Text(
                            subjectList[index].subjectName.toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 11, 135, 160),
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.text_format,
                            color: Colors.black,
                          ),
                          title: Text(
                            subjectList[index].subjectDescription.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.price_check,
                            color: Colors.black,
                          ),
                          title: Text(
                            "RM " +
                                subjectList[index].subjectPrice.toString() +
                                " / " +
                                subjectList[index].subjectSessions.toString() +
                                " Hours",
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 215, 50, 50),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.rate_review,
                            color: Colors.black,
                          ),
                          title: Text(
                            subjectList[index].subjectRating.toString() +
                                " Star Rating",
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 236, 147, 14),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _loadSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: const Text(
              "Search",
            ),
            content: SizedBox(
              height: screenHeight / 10,
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  search = searchController.text;
                  Navigator.of(context).pop();
                  _loadSubjects(1, search);
                },
                child: const Text("Search"),
              ),
            ],
          );
        });
      },
    );
  }

  _addtocartDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Add this subject to your cart?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // content: Row(),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addCart(index);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  _addCart(int index) {
    http.post(
      Uri.parse(CONSTANTS.server + "/mytutor/php/add_cart.php"),
      body: {
        "email": widget.user.email.toString(),
        "subjectid": subjectList[index].subjectId.toString(),
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then(
      (response) {
        var jsondata = jsonDecode(response.body);
        if (response.statusCode == 200 && jsondata['status'] == 'success') {
          // print(jsondata['data']['carttotal'].toString());
          setState(() {
            widget.user.cart = jsondata['data']['carttotal'].toString();
          });
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0,
          );
        }
      },
    );
  }

  void _loadMyCart() {
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/load_mycartqty.php"),
        body: {
          "email": widget.user.email.toString(),
        }).timeout(const Duration(seconds: 5), onTimeout: () {
      return http.Response(
          'Error', 408); // Request Timeout response status code
    }).then((response) {
      var jsondata = jsonDecode(response.body);
      // print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        // print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.5,
        backgroundColor: const Color.fromARGB(255, 11, 135, 160),
        title: Text('My Tutor',
            style: GoogleFonts.pacifico(
                fontSize: 31,
                color: Colors.white,
                fontWeight: FontWeight.normal)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => CartScreen(user: widget.user)),
              );
              _loadSubjects(1, search);
              _loadMyCart();
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(widget.user.cart.toString(),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: subjectList.isEmpty
          // Situation that the product list is empty
          ? Center(
              child: Text(
                titlecenter,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    crossAxisCount: 2,
                    childAspectRatio: (1 / 1),
                    children: List.generate(
                      subjectList.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            _loadDetailDialog(index);
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: CachedNetworkImage(
                                    imageUrl: CONSTANTS.server +
                                        "/mytutor/assets/courses/" +
                                        subjectList[index]
                                            .subjectId
                                            .toString() +
                                        '.png',
                                    fit: BoxFit.cover,
                                    width: resWidth,
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  subjectList[index].subjectName.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 11, 135, 160),
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  "RM " +
                                                      subjectList[index]
                                                          .subjectPrice
                                                          .toString() +
                                                      " / " +
                                                      subjectList[index]
                                                          .subjectSessions
                                                          .toString() +
                                                      " Hours",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  subjectList[index]
                                                          .tutorId
                                                          .toString() +
                                                      " Tutors Available",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 236, 14, 14),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  subjectList[index]
                                                          .subjectRating
                                                          .toString() +
                                                      " Star Rating",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 236, 147, 14),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: IconButton(
                                              onPressed: () {
                                                _addtocartDialog(index);
                                              },
                                              icon: const Icon(
                                                  Icons.shopping_cart),
                                              color: Color.fromARGB(
                                                  255, 11, 135, 160),
                                            ),
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
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = const Color.fromARGB(255, 11, 135, 160);
                      } else {
                        color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {_loadSubjects(index + 1, "")},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
