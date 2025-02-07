import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

class SettingData {

  static final SettingData _instance = SettingData._internal();

  factory SettingData() {
    return _instance;
  }

  SettingData._internal() {
    print('SettingDataクラスのインスタンスが生成されました');
    load((){ });
  }

    ui.Color bg = ui.Color(0xff336633);
    ui.Color fg = ui.Color(0xff00ff00);
    
    bool isReady = false;
    late SharedPreferences prefs;
    String user = '';
    String host = '';
    
    load(Function cb) async {
        if(isReady)  return;
        prefs = await SharedPreferences.getInstance();
        isReady = true;
        user = prefs.getString('nickname')??'';
        host = prefs.getString('host')??'http://i5-mac-mini.local:8800/';
        print('Setting ready');
        cb();
    }
    
    save() {
        
    }
    
    int getInt(String nm, int def) {
        return prefs.getInt(nm)??def;
    }
    String getString(String nm, String def) {
        return prefs.getString(nm)??def;
    }
    
    setInt(String nm, int v) {
        prefs.setInt(nm,v);
    }
    setString(String nm, String v) {
        prefs.setString(nm,v);
    }
    setUser(String user) {
        this.user = user;
        prefs.setString('nickname',user);
    }
    setHost(String host) {
        this.host = host;
        prefs.setString('host',host);
    }

}