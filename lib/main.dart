import 'package:pbl/core.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ceker',
      navigatorKey: Get.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 5),
      () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Fungsi untuk membuat animasi fade in
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) {
              return const MyHomePage(
                title: "Ceker",
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              "assets/images/LOGO.png",
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "MADE WITH",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xffFDFDFD),
                    ),
                  ),
                  Text(
                    " LOVE",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xffE20000),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseReference _voltageRef =
      FirebaseDatabase.instance.ref().child('voltage');

  final DatabaseReference _batteryRef =
      FirebaseDatabase.instance.ref().child('battery');

  final DatabaseReference _temperatureRef =
      FirebaseDatabase.instance.ref().child('temperature');

  double voltage = 0.0;
  int battery = 0;
  double temperature = 0.0;

  @override
  void initState() {
    super.initState();
    _voltageRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          voltage = double.parse(event.snapshot.value.toString());
        });
      }
    });

    _batteryRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          battery = int.parse(event.snapshot.value.toString());
        });
      }
    });

    _temperatureRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          temperature = double.parse(event.snapshot.value.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double batteryPercentage = battery / 100;
    return Scaffold(
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 210,
              decoration: const BoxDecoration(
                color: Color(0xff51a9e7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(63),
                  bottomRight: Radius.circular(63),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 10,
                    child: Image.asset(
                      'assets/images/LOGO.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const Positioned(
                    top: 95,
                    child: Text(
                      'Ceker',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Positioned(
                    top: 150,
                    child: Text(
                      "BATTERY STATUS",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  // Positioned(
                  //   top: 200,
                  //   child: Container(
                  //     height: 28,
                  //     width: 180,
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xffFF0000),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: const Center(
                  //       child: Text(
                  //         "Not Connected",
                  //         style: TextStyle(
                  //             fontFamily: 'Poppins',
                  //             color: Colors.white,
                  //             fontSize: 20.0,
                  //             fontWeight: FontWeight.w600),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "BATTERY PERCENTAGE",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Color(0xff51a9e7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 30,
                    backgroundColor: const Color(0xff51a9e7).withOpacity(0.3),
                    animation: true,
                    lineHeight: 150.0,
                    animationDuration: 1500,
                    percent: batteryPercentage,
                    center: Text(
                      "${(batteryPercentage * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 72.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xfff1f1f1),
                      ),
                    ),
                    barRadius: const Radius.circular(20),
                    progressColor: const Color(0xff51a9e7),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            const Text(
                              "VOLTAGE",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0,
                                fontFamily: 'Poppins',
                                color: Color(0xff51a9e7),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            CircularPercentIndicator(
                              radius: 70.0,
                              lineWidth: 13.0,
                              animation: true,
                              animationDuration: 1555,
                              percent: voltage / 4.2,
                              backgroundColor:
                                  const Color(0xff51a9e7).withOpacity(0.3),
                              center: Text(
                                "${voltage.toStringAsFixed(1)}V",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30.0,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: const Color(0xff51a9e7),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              "Max Voltage: 4.2V",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        height: 200,
                        width: 155,
                        decoration: const BoxDecoration(
                          color: Color(0xff51a9e7),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "TEMPERATURE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    color: Color(0xfff1f1f1),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "${temperature.toStringAsFixed(1)}°C",
                                style: const TextStyle(
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const TipsPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: const Color(0xffb3e3ff),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Tips & Tricks',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff51a9e7),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),
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
  }
}
