import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrscaner/qr%20scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAJ_ltekoautAP-i0zpBL8J5o7qaRzYQ54",
      appId: "1:802992401132:android:44f4a524a24224610653c9",
      messagingSenderId: "802992401132",
      projectId: "progect-80cea",
      storageBucket: "progect-80cea.appspot.com",
    ),
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "QR Scanner",
    theme: ThemeData(
        appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    )),
    home: qrscanner(),
  ));
}

class qrscanner extends StatelessWidget {
  const qrscanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => qr(),
                ));
          },
          label: Icon(Icons.add)),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('scanned').snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index]['data'].toString();
                List<String> parts = data.split("_");

                String department = parts[0];
                String doctor = parts[1];
                String patient = parts[2];
                String age = parts[3];
                String gender = parts[4];
                String time = parts[5];
                String date = parts[6];
                String token = parts[7];
                String phone = parts[8];

                return ListTile(
                  leading: Text("Token No: $token"),
                  title: Text(department),
                  subtitle: Text("Doctor : $doctor\nPatient: $patient\nAge: $age  Gender: $gender\nPhone: $phone"),
                  trailing: Text("$date\n$time"),
                );
              },
            );
          }),
    );
  }
}
