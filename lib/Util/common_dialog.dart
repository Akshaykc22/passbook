import 'package:flutter/material.dart';
import 'package:passbook_core/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

showCustomDialog({BuildContext context}) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Wrap(
        children: [
          Text(
            "Delete MPin",
            style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          ),
          Text("Are you sure want to delete MPin."),
          TextButton(
            onPressed: () => Navigator.pop(
              context,
            ),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (prefs.getString(StaticValues.Mpin) == null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("No MPin Set")));

                Navigator.pop(
                  context,
                );
                Dialog(
                  child: Wrap(
                    children: [Text("No MPIN is Set")],
                  ),
                );
                //     .showSnackBar(SnackBar(
                //     content: Text(
                //         "${noList[int.parse(languageId)]} MPin ${setList[int.parse(languageId)]}")));
              } else {
                prefs.remove(StaticValues.Mpin);

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("MPin Deleted")));

                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/LoginPage", (_) => false);
              }
              // prefs.setString(StaticValues.Mpin, "");
            },
            child: Text("YES"),
            // child: Text(yesList[int.parse(languageId)]),
          ),
        ],
      ),
    ),
  );
}
