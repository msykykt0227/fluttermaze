import 'dart:convert';
import 'package:maze/models/MazeData.dart';
import 'package:maze/models/RankData.dart';
import 'package:maze/models/SettingData.dart';
import 'package:http/http.dart' as http;

// https://qiita.com/naoi/items/90b4db605134e77ceec1
class RankHttpClient {
 
 // https://zenn.dev/hassan/articles/81fa728f140aa3
 // https://note.com/hatchoutschool/n/n6f4317f41741
  getRank(int did, Function(List<Rank>) cb) async {
    List<Rank> list = [];
    
    print('${SettingData().host}/maze/rank?did=$did');
    var uri = Uri.parse('${SettingData().host}maze/rank?did=$did');
    var response = await http.get(uri);
//    print(response.statusCode);
//    print(response.body);
    var jsdt = jsonDecode(response.body);
//    print(jsdt);
    Iterable iterable = jsdt['rank'];
    var conertList = iterable.map((e) => Rank.fromJson(e)).toList();
    list.addAll(conertList);
    cb(list);
  }

  getData(int did, Function(String) cb) async {
    List<Rank> list = [];

    var uri = Uri.parse('${SettingData().host}maze/getdata?did=$did');
    var response = await http.get(uri);
    if(response.statusCode==200) {
        print(response.body);
        cb(response.body);
    } else {
//        print(response.body);
    }
  }

  Future<bool> postData(String user) async {
    http.Response? response;
    var mdt = MazeData();
    UserData ud = UserData(user, mdt.startMap, mdt.mcnt, mdt.useB);
    
    response = await http.post(
        Uri.parse('${SettingData().host}api/maze/regist'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(ud.toMap()),
    );
    
    if(response.statusCode == 200) {
        SettingData().setUser(user);
        MazeData().startMap = response.body;
        print(response.body);
      return true;
    }
  
  print(response.body);
    return false;
  }
}