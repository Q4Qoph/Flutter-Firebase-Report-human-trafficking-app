import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project_app1/incident_report/components/location.dart';
import 'package:project_app1/incident_report/components/popup_form.dart';
import 'package:project_app1/incident_report/models/categories_list.dart';
import 'package:project_app1/incident_report/models/person_model.dart';
import 'package:project_app1/incident_report/models/report_model.dart';
import 'package:project_app1/services/auth.dart';
import 'package:project_app1/utils/theme.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:project_app1/widgets/bottomnav.dart';

class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({super.key});

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

const kGoogleApiKey = '<GoogleMapAPIKey>';

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  final _formKey = GlobalKey<FormState>();
  bool haveFile = false;
  bool havePerson = false;
  String? formattedDate;
  DateTime? pickedDate;
  TextEditingController dateCtl = TextEditingController();
  TimeOfDay? pickedTime;
  TextEditingController timeCtl = TextEditingController();
  String? catego;
  String? description;
  String? reporterType;
  List selectedFiles = [];
  List<Person> personas = [];
  // final Mode _mode = Mode.overlay;
  String? location;
  double? lng;
  double? lat;
  LatLng? selectedLocation;
  String? selectedPlaceName;

  void selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'mp3', 'mp4', 'jpeg'],
        allowMultiple: true);
    if (result == null) return;
    selectedFiles = result.files;
    setState(() {
      haveFile = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Human Trafficking',
            style: TextStyle(
                color: Colors.lightGreen.shade800,
                fontWeight: FontWeight.w600)),
        // centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(20), child: Container()),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SafeArea(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getLocationField(),
                    getDateTimeFeild(),
                    traffickingTypeField(),
                    traffickingDescField(),
                    getCustomButton(
                        text: "Add Evidence Media / Files",
                        background: Colors.lightGreen.shade300,
                        textcolor: Colors.lightGreen.shade800,
                        fontSize: 15,
                        padding: 45,
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.lightGreen.shade800,
                        ),
                        onPressed: () {
                          selectFile();
                        }),
                    getShowSelectedImages(),
                    getRadioButton(),
                    Container(
                      child: getCustomButton(
                          text:
                              "Additional Trafficker / Victim / Witness Details",
                          background: Colors.lightGreen.shade300,
                          textcolor: Colors.lightGreen.shade800,
                          padding: 10,
                          fontSize: 12,
                          icon: Icon(
                            Icons.add,
                            color: Colors.lightGreen.shade900,
                          ),
                          onPressed: () {
                            getPopUp();
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    submitButtonBar()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        defaultSelectedIndex: 1,
      ),
    );
  }

  getPopUp() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpForm(
            onAdd: (value) {
              setState(() {
                personas.add(value);
                havePerson = true;
              });
            },
          );
        });
  }

  getLocationField() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
        onPressed: _openMapScreen,
        // onPressed: _handleLocationButton,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.lightGreen.shade900))),
          backgroundColor: WidgetStateProperty.all(Colors.lightGreen.shade50),
          padding: WidgetStateProperty.all(EdgeInsets.all(15)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Colors.lightGreen.shade900,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              selectedLocation != null
                  ? selectedPlaceName!
                  : "Select Incident Location",
              style: TextStyle(color: Colors.lightGreen.shade800, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMapScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          onLocationSelected: (location, placeName) {
            setState(() {
              selectedLocation = location;
              selectedPlaceName = placeName;
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedLocation = result['location'];
        selectedPlaceName = result['placeName'];
      });
    }
  }

  getDateTimeFeild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          width: 175,
          child: TextFormField(
            controller: dateCtl,
            readOnly: true,
            decoration: ThemeHelper().textInputDecoReport(
                'Select Date',
                Icon(
                  Icons.calendar_today,
                  color: Colors.lightGreen.shade900,
                )),
            onTap: () async {
              pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.lightGreen.shade700,
                        onPrimary: Colors.lightGreen.shade50,
                        onSurface: Colors.lightGreen.shade900,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.lightGreen),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);
              dateCtl.text = formattedDate!;
            },
            validator: (val) {
              if (val!.isEmpty) {
                return "Please select a date";
              }
              return null;
            },
          ),
          decoration: ThemeHelper().inputBoxDecorationShaddow(),
        ),
        Container(
          width: 155,
          padding: EdgeInsets.only(bottom: 10),
          child: TextFormField(
            controller: timeCtl,
            readOnly: true,
            decoration: ThemeHelper().textInputDecoReport(
                'Select Time',
                Icon(
                  Icons.watch_later_outlined,
                  color: Colors.lightGreen.shade900,
                )),
            onTap: () async {
              pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.lightGreen.shade900,
                        onPrimary: Colors.lightGreen.shade50,
                        onSurface: Colors.lightGreen,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Colors.lightGreen.shade900, // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              //String formattedDate = DateFormat('HH:mm:ss').format(pickedDate!);
              timeCtl.text = formatTimeOfDay(pickedTime!);
            },
            validator: (val) {},
          ),
          decoration: ThemeHelper().inputBoxDecorationShaddow(),
        )
      ],
    );
  }

  traffickingTypeField() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        width: 400,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.lightGreen.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.lightGreen)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            isExpanded: true,
            hint: Text("Select Category"),
            items: categories.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (catego == null) {
                return "Please select Category of the Trafficking";
              }
              return null;
            },
            onChanged: (value) {
              catego = value.toString();
            },
          ),
        ),
      ),
    );
  }

  traffickingDescField() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        minLines: 3,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        decoration: ThemeHelper().textInputDecoReport(
            "Enter the description of the trafficking incident"),
        onChanged: (val) {
          setState(() {
            description = val;
          });
        },
        validator: (val) {
          if (val!.isEmpty) {
            return "Description of the incident is required";
          }
          return null;
        },
      ),
    );
  }

  getShowSelectedImages() {
    return Visibility(
      visible: haveFile,
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          height: 150,
          color: Colors.lightGreen.shade50,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              itemCount: selectedFiles.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                final file = selectedFiles[index];
                final extension = file.extension?.toLowerCase() ?? 'none';

                if (['jpg', 'jpeg', 'png'].contains(extension)) {
                  return Column(
                    children: [
                      Expanded(
                        child: Image.file(
                          File(file.path!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(file.name, overflow: TextOverflow.ellipsis),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              extension.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(file.name, overflow: TextOverflow.ellipsis),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  getRadioButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Please Select, I am the ",
          style: TextStyle(fontSize: 16, color: Colors.lightGreen.shade900),
        ),
        RadioListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          activeColor: Colors.lightGreen.shade900,
          title: Text(
            "Victim",
            style: TextStyle(color: Colors.lightGreen.shade900),
          ),
          value: "Victim",
          groupValue: reporterType,
          onChanged: (value) {
            setState(() {
              reporterType = value.toString();
            });
          },
        ),
        RadioListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          activeColor: Colors.lightGreen.shade900,
          title: Text(
            "Witness",
            style: TextStyle(color: Colors.lightGreen.shade900),
          ),
          value: "Witness",
          groupValue: reporterType,
          onChanged: (value) {
            setState(() {
              reporterType = value.toString();
            });
          },
        ),
        RadioListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          activeColor: Colors.lightGreen.shade900,
          title: Text(
            "Anonymous",
            style: TextStyle(color: Colors.lightGreen.shade900),
          ),
          value: "Anonymous",
          groupValue: reporterType,
          onChanged: (value) {
            setState(() {
              reporterType = value.toString();
            });
          },
        )
      ],
    );
  }

  submitButtonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getCustomButton(
            text: "Report",
            textcolor: Colors.lightGreen.shade900,
            padding: 50,
            background: Colors.lightGreen,
            fontSize: 25,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Upload files to Firebase Storage
                List<String> mediaUrls = await _uploadFiles();

                // Create the report with media URLs
                final report = IncidentReport(
                  location: selectedLocation != null
                      ? "${selectedLocation!.latitude},${selectedLocation!.longitude}"
                      : null,
                  date: pickedDate,
                  time: timeCtl.text,
                  category: catego,
                  description: description,
                  reporterType: reporterType,
                  mediaFiles: mediaUrls,
                );
                try {
                  await AuthService().submitIncidentReport(report);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incident report submitted successfully!'),
                      backgroundColor: Colors.lightGreen,
                      duration: Duration(seconds: 3),
                    ),
                  );
                  // Reset the form fields and state
                  _formKey.currentState!.reset();
                  dateCtl.clear();
                  timeCtl.clear();
                  selectedFiles.clear();
                  personas.clear();
                  selectedLocation = null;
                  selectedPlaceName = null;
                  catego = null;
                  description = null;
                  reporterType = null;
                  haveFile = false;
                  havePerson = false;

                  // Refresh the UI
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Failed to submit report. Please try again.'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }
            }),
      ],
    );
  }

  Future<List<String>> _uploadFiles() async {
    List<String> mediaUrls = [];
    for (var file in selectedFiles) {
      if (file.path != null) {
        File uploadFile = File(file.path!);
        String fileName = file.name;
        Reference storageRef =
            FirebaseStorage.instance.ref().child('uploads/$fileName');
        UploadTask uploadTask = storageRef.putFile(uploadFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        mediaUrls.add(downloadUrl);
      }
    }
    return mediaUrls;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }
}
