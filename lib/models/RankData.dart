import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:maze/models/RankHttpClient.dart';

class RankData {

  static final RankData _instance = RankData._internal();

  factory RankData() {
    return _instance;
  }

  RankData._internal() {
    print('RankDataクラスのインスタンスが生成されました');
  }

    String user = '';
    List<Rank>sames = [];
    List<Rank>ranks = [];
}

class UserData {
    final String name;
    final String code;
    final int mcnt;
    final int mbom;
    
    const UserData(this.name, this.code,this.mcnt, this.mbom);
    
    Map<String, dynamic> toMap() {
        return {
            'name' : this.name,
            'code' : this.code,
            'mcnt' : this.mcnt,
            'mbom' : this.mbom,
        };
    }
    
    UserData.fromJson(Map<String, dynamic>map)
    : this.name = map['name'],
      this.code = map['code'],
      this.mcnt = map['mcnt'],
      this.mbom = map['mbom'];

}

class Rank {
    final String name;
    final int did;
    final int mcnt;
    final int mbom;
    final int score;
    final String date;
    
    const Rank(this.did, this.name, this.mcnt, this.mbom, this.score, this.date);
    
    Map<String, dynamic> toMap() {
        return {
            'did' : this.did,
            'user' : this.name,
            'mcnt' : this.mcnt,
            'mbom' : this.mbom,
            'score' : this.score,
            'date' : date
        };
    }
    
    Rank.fromJson(Map<String, dynamic>map)
    : did = map['did'], name = map['user'], mcnt = map['mcnt'], mbom = map['mbom'], score = map['score'], date = map['date'];
}