import 'package:flutter/material.dart';
import 'package:cu1/utils/config.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.route, required this.doctor});

  final String route;
  final Map<String, dynamic> doctor; //receive doctor details

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                child: Image.network(
                  "http://10.0.2.2:8000${doctor['doctor_profile']}",
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Dr ${doctor['doctor_name']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${doctor['category']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                          size: 16,
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Text('4.5'),
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          'Reviews',
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          '(20)',
                        ),
                        Spacer(
                          flex: 7,
                        )
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
        onTap: () {
          //pass details to detail page
          Navigator.of(context).pushNamed(route, arguments: doctor);
        }, //direct to doctor details
      ),
    );
  }
}
