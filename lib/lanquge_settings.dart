import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Util/StaticValue.dart';

class LanquageSettings extends StatefulWidget {
  const LanquageSettings({Key key}) : super(key: key);

  @override
  _LanquageSettingsState createState() => _LanquageSettingsState();
}

class _LanquageSettingsState extends State<LanquageSettings> {
  String languageId = "English";
  String languageId1 = "0";

  @override
  void initState() {
    super.initState();
    setLanguage();
  }

  void setLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String language = preferences.getString(StaticValues.languageId) ?? "";
    setState(() {
      switch (language) {
        case "0":
          languageId = "English";
          break;
        case "1":
          languageId = "French";
          break;
        case "2":
          languageId = "Spanish";
          break;
        case "3":
          languageId = "Portuguese";
          break;
        default:
          languageId = "English"; // fallback to default
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Select Language"),
            InkWell(
              onTap: () {
                saveData();
                print("Language : $languageId");
                print("LanguageId : $languageId1");
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Card(
            child: RadioListTile(
              activeColor: Theme.of(context).secondaryHeaderColor,
              title: Text("English"),
              value: "English",
              groupValue: languageId,
              onChanged: (value) {
                setState(() {
                  languageId = value.toString();
                  languageId1 = "0";
                });
              },
            ),
          ),
          Card(
            child: RadioListTile(
              activeColor: Theme.of(context).secondaryHeaderColor,
              title: Text("French"),
              value: "French",
              groupValue: languageId,
              onChanged: (value) {
                setState(() {
                  languageId = value.toString();
                  languageId1 = "1";
                });
              },
            ),
          ),
          Card(
            child: RadioListTile(
              activeColor: Theme.of(context).secondaryHeaderColor,
              title: Text("Spanish"),
              value: "Spanish",
              groupValue: languageId,
              onChanged: (value) {
                setState(() {
                  languageId = value.toString();
                  languageId1 = "2";
                });
              },
            ),
          ),
          Card(
            child: RadioListTile(
              activeColor: Theme.of(context).secondaryHeaderColor,
              title: Text("Portuguese"),
              value: "Portuguese",
              groupValue: languageId,
              onChanged: (value) {
                setState(() {
                  languageId = value.toString();
                  languageId1 = "3";
                });
              },
            ),
          )
        ],
      ),
    );
  }

  void saveData() async {
    SharedPreferences preferences = StaticValues.sharedPreferences;

    await preferences.setString(StaticValues.languageId, languageId1);

    Navigator.of(context).pushReplacementNamed("/HomePage");
  }
}
