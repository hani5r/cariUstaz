import 'package:cu1/utils/config.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

// Enum for appointment status
enum FilterStatus { upcoming, completed, cancelled }

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.upcoming; // Initial status
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [
    {
      "doctor_name": "Zafarina",
      "doctor_profile": "assets/doc1.jpg",
      "category": "Dental",
      "status": FilterStatus.upcoming,
    },
    {
      "doctor_name": "Jenny",
      "doctor_profile": "assets/doc1.jpg",
      "category": "Dermatology",
      "status": FilterStatus.completed,
    },
    {
      "doctor_name": "Rose",
      "doctor_profile": "assets/doc1.jpg",
      "category": "Cardiology",
      "status": FilterStatus.cancelled,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Return filtered appointment
    List<dynamic> filteredSchedules = schedules.where((schedule) {
      return schedule['status'] == status; // Filtering based on the selected status
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Appointment Schedule',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall,
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Filter tabs
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (filterStatus == FilterStatus.upcoming) {
                                  status = FilterStatus.upcoming;
                                  _alignment = Alignment.centerLeft;
                                } else if (filterStatus == FilterStatus.completed) {
                                  status = FilterStatus.completed;
                                  _alignment = Alignment.center;
                                } else if (filterStatus == FilterStatus.cancelled) {
                                  status = FilterStatus.cancelled;
                                  _alignment = Alignment.centerRight;
                                }
                              });
                            },
                            child: Center(
                              child: Text(filterStatus.name),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Config.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        status.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Config.spaceSmall,
            Expanded(
              child: ListView.builder(
                itemCount: filteredSchedules.length,
                itemBuilder: (context, index) {
                  var schedule = filteredSchedules[index];
                  bool isLastElement = filteredSchedules.length == index + 1;
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: !isLastElement
                    ? const EdgeInsets.only(bottom: 20)
                    : EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                AssetImage(schedule['doctor_profile']),
                              ),
                             const SizedBox(
                               width: 10,
                             ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    schedule['doctor_name'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    schedule['category'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                         const ScheduleCard(),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {  },
                                  child: const Text(
                                    'Cancel',
                                    style:
                                    TextStyle(color: Config.primaryColor),
                                  ),
                              ),
                              ),
                              const SizedBox(width: 20,),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                  backgroundColor: Config.primaryColor,
                                  ),
                                  onPressed: () {  },
                                  child: const Text(
                                    'Reschedule',
                                    style:
                                    TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                            ],
                          )

                        ],
                      ),
                    ),
                    // child: ListTile(
                    //   leading: CircleAvatar(
                    //     backgroundImage: AssetImage(_schedule['doctor_profile']),
                    //   ),
                    //   title: Text(_schedule['doctor_name']),
                    //   subtitle: Text(_schedule['category']),
                    // ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            Icon(Icons.calendar_today,
              color: Config.primaryColor,
              size: 15,
            ),
            SizedBox(width: 5,),
            Text(
              'Monday 26/8/2024',
              style: TextStyle(color: Config.primaryColor),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.access_alarm,
              color: Config.primaryColor,
              size: 17,
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
                child: Text(
                  '2:00pm',
                  style: TextStyle(color: Config.primaryColor),
                )
            )
          ]
      ),
    );
  }
}
