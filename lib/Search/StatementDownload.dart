import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passbook_core/Search/SearchHome.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StatementDownload extends StatefulWidget {
  const StatementDownload({Key key}) : super(key: key);

  @override
  _StatementDownloadState createState() => _StatementDownloadState();
}

class _StatementDownloadState extends State<StatementDownload> {

  final _formKey = GlobalKey<FormState>();

  final imgUrl =
      "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
  String folderName = "PASSBOOK";
  int _progress;
  bool _downProgress = false;

  var dio = Dio();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void showDownloadProgress(received, total) {
    if (total != -1) {
      setState(() {
        _downProgress = true;
      });
      _progress = int.parse((received / total * 100).toStringAsFixed(0));

      //_progress != 100?CircularProgressIndicator():"";
      print((received / total * 100).toStringAsFixed(0) + "%");
      if(_progress == 100){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download Compleated")));
        setState(() {
          _downProgress = false;
        });
      }

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text((received / total * 100).toStringAsFixed(0) + "%")));
    }
  }

  Future<File> downloadFile(
    String url,
    String savePath,
  ) async {
    Dio dio = new Dio();
    Response response = await dio.get(
      url,
     onReceiveProgress: showDownloadProgress,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    print(response.headers);
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  }

  Future<String> _createFolder() async {
    Directory folder;
    if(Platform.isIOS){
      folder = Directory('${(await getApplicationDocumentsDirectory()).path}/$folderName');
    }else{
     // folder = Directory('${(await getExternalStorageDirectory()).path}/$folderName');
      folder = Directory('storage/emulated/0/$folderName');
    }

    var _permission = await grantPermission();
    if (_permission == null) {
      return null;
    } else if (_permission) {
      if ((await folder.exists())) {
        print('exist');
        String _path =
            '${folder.path}/Statement\_${DateFormat('dd-MM-yyyy-HH:mm:ss').format(DateTime.now())}.pdf';
        print(_path);
        return _path;
      } else {
        print('not exist');
        await folder.create();
        String _path =
            '${folder.path}/Statement\_${DateFormat('dd-MM-yyyy-HH:mm:ss').format(DateTime.now())}.pdf';
        print(_path);
        return _path;
      } // t should print PermissionStatus.granted

    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Invoice can\'t be download, without the the '
              'storage permission')));
      return null;
    }
  }

  Future<bool> grantPermission() async {
    var status = await Permission.storage.status;
    print('STATUS OF PERMISSION $status');

    switch (status) {
      case PermissionStatus.denied:
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
        return statuses[Permission.storage].isGranted;
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
                'This action need permission.You can grant them in app settings')));
        return null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffoldKey,

        appBar: AppBar(
          title: Text("Statement Download"),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                String fullPath = await _createFolder();
                print('full path $fullPath');

                downloadFile(imgUrl, fullPath);
              },
              child: _downProgress?CircularProgressIndicator():Text("Download"),
            ),
            SizedBox(
              height: 30.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Amount"
              ),
              validator: (value){
                if(double.parse(value) < 1000){
                  return 'Amount must be heigher';
                }
                else{
                  return null;
                }
              },

            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Amount 2"
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(onPressed: (){
              if(_formKey.currentState.validate()) {


              }
            },
            child: Text("Validate"),)
          ],
        ),
      ),
    );
  }
}
