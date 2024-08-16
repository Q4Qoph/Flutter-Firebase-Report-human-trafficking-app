import 'package:flutter/material.dart';
import 'package:project_app1/incident_report/models/person_model.dart';
import 'package:project_app1/utils/theme.dart';

class PopUpForm extends StatefulWidget {
  final Function(Person) onAdd;
  const PopUpForm({super.key, required this.onAdd});

  @override
  State<PopUpForm> createState() => _PopUpFormState();
}

class _PopUpFormState extends State<PopUpForm> {
  String? description;
  String? perType;
  Person? person;
  List<String> persona = ['Witness', 'Victim', 'Trafficker'];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Additional Details'),
      scrollable: true,
      content: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          child: Column(
            children: <Widget>[selectTraffTypeField(), getTraffDescField()],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black)),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(Colors.lightGreen.shade900)),
          child: const Text(
            "Add",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            person = Person(perType!, description!);
            widget.onAdd(person!);
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  selectTraffTypeField() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: 400,
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            isExpanded: true,
            hint: Text("Please select persona"),
            items: persona.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (perType == null) {
                return "Please select the type of the person";
              }
              return null;
            },
            onChanged: (value) {
              perType = value.toString();
            },
          ),
        ),
      ),
    );
  }

  getTraffDescField() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        minLines: 5,
        maxLines: 8,
        keyboardType: TextInputType.multiline,
        decoration: ThemeHelper().textInputDecoReport(
            "Enter the name, contact details, or any other details such as "
            "appearance, cloths, distinct features and more."),
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
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
    );
  }
}
