import 'package:flutter/material.dart';
import 'map_kemarin.dart';
import 'package:provider/provider.dart';
import 'tire_data_model.dart';
import 'mqtt_service.dart';

class MyHomePage extends StatefulWidget {
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late TireDataModel tireDataModel;

  late MqttService _mqttService;

@override

void initState() {
  super.initState();
  _mqttService = MqttService();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final tireDataModel = Provider.of<TireDataModel>(context, listen: false);
    _mqttService.connect(context, tireDataModel, null);
  });
}


  void didChangeDependencies() {
    super.didChangeDependencies();
    tireDataModel = Provider.of<TireDataModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final double height=MediaQuery.of(context).size.height;
    final double width=MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
              color:Color(0xFF363f93),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 0,
                  child:Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )
                    )
                  )
                ),
                Positioned(
                  top: 65,
                  left: 15,
                  child: Text("TPMS MONITORING",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color:Color(0xFF363f93)))
                  )
              ],
            )
          ),
          SizedBox(height: height*0.05,),
          Container(
            height: 230,
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  left: 20,
                  child: Material(
                    child: Container(
                      height: 150.0,
                      width: width*0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: new Offset(-10.0, 10.0),
                            blurRadius: 20.0,
                            spreadRadius: 4.0)],
                      ),
                    )
                )),
                Positioned(
                  top: 0,
                  left: 30,
                  child: Card(
                    elevation: 10.0,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        height: 150,
                        width: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xFF363f93),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("images/maps2.png"),
                            )
                        ),),
                  )
                ),
                Positioned(
                  top: 45,
                  left: 190,
                  child: Container(
                    height: 150,
                    width: 162,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your Location", style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF363f93),
                          fontWeight: FontWeight.bold,
                        ),),
                        Divider(color: Colors.black),
                        Text("Hi there! You can check your track location here.", 
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),),
                        TextButton(
                          child: Text(
                            "Check!"),
                            style: TextButton.styleFrom(
                              primary: Colors.blue,
                            ),
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => DiTrackingMapPage()),
                            );
                          },
                          ),
                      ],
                    ),
                  ))
              ],
            )
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 360,
                height: 335,
                color: Colors.white,
              ),
              Positioned(
                top: 0,
                left: 25,
                child: Container(
                  width: 145,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0,3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                            child: Text(
                              "TPMS 1",
                              style: TextStyle(
                                color: Color(0xFF363f93),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            padding: const EdgeInsets.all(12)
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Icon(Icons.thermostat_auto_sharp,
                              size: 25, color: Colors.blueAccent),
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),

                          Consumer<TireDataModel>(
                            builder: (context, tireDataModel, child) {
                              double? frontRightTemp = tireDataModel.frontRightTemp;
                              return Container(
                                child: Text(
                                  '$frontRightTemp°C',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                              );
                            },
                          )
                          ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Icon(Icons.scale_sharp,
                              size: 25, color: Colors.blueAccent),
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),

                          Consumer<TireDataModel>(
                            builder: (context, tireDataModel, child) {
                              double? frontRightPressure = tireDataModel.frontRightPressure;
                              return Container(
                                child: Text(
                                  '$frontRightPressure Psi',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12)
                              );
                            },
                          )
                        ]
                      )
                    ],
                    )
                ),
              ),
              Positioned(
                top: 0,
                right: 25,
                child: Container(
                  width: 145,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0,3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                            child: Text(
                              "TPMS 2",
                              style: TextStyle(
                                color: Color(0xFF363f93),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            padding: const EdgeInsets.all(12)
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Icon(Icons.thermostat_auto_sharp,
                              size: 25, color: Colors.blueAccent),
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),

                          Consumer<TireDataModel>(
                             builder: (context, tireDataModel, child) {
                              double? frontLeftTemp= tireDataModel.frontLeftTemp;
                              return Container(
                                child: Text(
                                  '$frontLeftTemp °C',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12)
                                );
                              },
                            )
                          ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Icon(Icons.scale_sharp,
                              size: 25, color: Colors.blueAccent),
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),

                          Consumer<TireDataModel>(
                            builder: (context, tireDataModel, child) {
                              double? frontLeftPressure = tireDataModel.frontLeftPressure;
                              return Container(
                                child: Text(
                                  '$frontLeftPressure Psi',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12)
                              );
                            },
                          )
                        ]
                      )
                    ],
                  )
                ),
              ),
              Positioned(
                bottom: 15,
                left: 25,
                child: Container(
                  width: 145,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0,3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                            child: Text(
                              "TPMS 3",
                              style: TextStyle(
                                color: Color(0xFF363f93),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            padding: const EdgeInsets.all(12)
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Icon(Icons.thermostat_auto_sharp,
                              size: 25, color: Colors.blueAccent),
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),

                          Consumer<TireDataModel>(
                            builder: (context, tireDataModel, child) {
                              double? backLeftTemp = tireDataModel.backLeftTemp;
                              return Container(
                                child: Text(
                                  '$backLeftTemp °C',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                              );
                            },
                          )
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Icon(Icons.scale_sharp,
                              size: 25, color: Colors.blueAccent),
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),

                          Consumer<TireDataModel>(
                            builder: (context, tireDataModel, child) {
                              double? backLeftPressure = tireDataModel.backLeftPressure;
                              return Container(
                                child: Text(
                                  '$backLeftPressure Psi',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12)
                              );
                            },
                          )
                        ]
                      )
                    ],
                  )
                ),
              ),
              Positioned(
                bottom: 15,
                right: 25,
                child: Container(
                  width: 145,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0,3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                            child: Text(
                              "TPMS 4",
                              style: TextStyle(
                                color: Color(0xFF363f93),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            padding: const EdgeInsets.all(12)
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Icon(Icons.thermostat_auto_sharp,
                              size: 25, color: Colors.blueAccent),
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),

                          Consumer<TireDataModel>(
                            builder: (context, tireDataModel, child) {
                              double? backRightTemp = tireDataModel.backRightTemp;
                              return Container(
                                child: Text(
                                  '$backRightTemp °C',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12)
                                );
                              },
                            )
                          ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Icon(Icons.scale_sharp,
                              size: 25, color: Colors.blueAccent),
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),

                          Consumer<TireDataModel>(
                            builder: (context, tireDataModel, child)  {
                             double? backRightPressure = tireDataModel.backRightPressure;
                              return Container(
                                child: Text(
                                  '$backRightPressure Psi',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12)
                              );
                            },
                          )
                        ]
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}

