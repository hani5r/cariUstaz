import 'dart:convert';

import 'package:cu1/components/appointment_card.dart';
import 'package:cu1/components/doctor_card.dart';
import 'package:cu1/utils/config.dart';
import 'package:cu1/providers/dio_provider.dart';
//import 'package:cu1/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.circle,
      "category": "General",
    },
    {
      "icon": FontAwesomeIcons.circle,
      "category": "Fiqh",
    },
    {
      "icon":FontAwesomeIcons.circle,
      "category": "Tauhid",
    },
    {
      "icon": FontAwesomeIcons.circle,
      "category": "Sirah",
    },
    {
      "icon": FontAwesomeIcons.circle,
      "category": "Tasawwuf",
    },
    {
      "icon": FontAwesomeIcons.circle,
      "category": "Hadis",
    },
  ];

  // Future<void> getData() async {
  //   //get token from shared preferences
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token') ?? '';

  //   if (token.isNotEmpty && token != '') {
  //     //get user data
  //     final response = await DioProvider().getUser(token);
  //     if (response != null) {
  //       setState(() {
  //         //json decode
  //         user = json.decode(response);
  //         // print(user);
  //       });
  //     }
  //   }
  // }
  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty) {
      try {
        // Get user data
        final response = await DioProvider().getUser(token);

        // Log response for debugging
        debugPrint('API Response: $response');

        if (response != null) {
          setState(() {
            // Decode the JSON response
            user = json.decode(response);
           // print(user);
            debugPrint('User data: $user'); // Print the user data
          });
        } else {
          debugPrint('Response is null');
        }
      } catch (e) {
        // Catch and log any errors
        debugPrint('Error fetching user data: $e');
      }
    } else {
      debugPrint('Token is empty');
    }
  }

  @override
  void initState() {
    //try again
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      //if user is empty, then return progress indicator
      body: user.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    user.isNotEmpty
                        ? Text(
                            user['name'] ?? 'User',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage('assets/profile1.jpg'), //insert image
                      ),
                    )
                  ],
                ),
                Config.spaceMedium,
                //category listing
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                //build category list
                SizedBox(
                  height: Config.heightSize * 0.05,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(medCat.length, (index) {
                      return Card(
                        margin: const EdgeInsets.only(right: 20),
                        color: Config.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FaIcon(
                                medCat[index]['icon'],
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                medCat[index]['category'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Config.spaceSmall,
                const Text(
                  'Appointment Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                //display appointment card widget
                const AppointmentCard(),
                Config.spaceSmall,
                const Text(
                  'Top Ustaz',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //list doctor card
                Config.spaceSmall,
                Column(
                  children: List.generate(user['doctor'].length, (index) {
                    return DoctorCard(
                      route: 'doc_details',
                      doctor: user['doctor'][index],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
