import 'package:flutter/material.dart';
import 'package:maze/widgets/MazeBase.dart';
import 'package:maze/models/MazeData.dart';
import 'package:maze/models/SettingData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  SettingPage({super.key});
  @override
  State<SettingPage> createState() => SettingState();
}

class SettingState extends State<SettingPage> {

  final MazeData mdt = MazeData();
  int _type = 0;
  int _mX = 5;
  int _mY = 5;
  int _mZ = 2;
  int _nF = 0;
  int _nB = 0;
  int _nP = 0;
  String _nickname = '';
  String _host = '';
  bool _isEdit = false;
  
  _save() {
      if(mdt.type != _type || mdt.mx != _mX || mdt.my != _mY || mdt.mz != _mZ || mdt.nflg != _nF || mdt.nBomb != _nB) {
        mdt.type = _type;
//      mdt.mx = _mX;
//      mdt.my = _mY;
//      mdt.mz = _mZ;
        int nsp = (_mX+1)*(_mY+1)*(_mZ+1) ~/ 8 -1; // 0,0,0未配置
        if(_type==0) {
        mdt.iniHp = nsp*2*12 ~/ 10;
        } else {
        mdt.iniHp = nsp*2*3 ~/ 10;
        }
        if(nsp < _nF) {
          _nF = nsp;
        }
        nsp -= _nF;
        mdt.nflg = _nF;
        if(nsp < _nB) {
          _nB = nsp;
        }
        nsp -= _nB;
        mdt.iniB = _nB ~/ 2;
        mdt.nBomb = _nB - mdt.iniB; 
        if(nsp < _nP) {
          _nP = nsp;
        }
        mdt.nPotion = _nP;
        mdt.init((_mX+1) ~/ 2, (_mY+1) ~/ 2, (_mZ+1) ~/ 2);
      }
      
      if(_host.isNotEmpty) {
          SettingData().setHost(_host);
      }
      SettingData().setUser(_nickname);
  }
  
  @override
  void initState() {
    super.initState();
    _type = mdt.type;
    _mX = mdt.mx;
    _mY = mdt.my;
    _mZ = mdt.mz;
    _nF = mdt.nflg;
    _nB = mdt.iniB+mdt.nBomb;
    _nP = mdt.nPotion;
    
    _host = SettingData().host;
    _nickname = SettingData().user;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('設定'),
        ),
        body: Column(
            children: [
                Row(
                    children:[
                        Text('競技 ポイント'),
                        Radio<int>(
                            value: 0,
                            groupValue: _type,
                            onChanged:(value) {
                                setState((){
                                _type = value!;
                                });
                            },
                        ),
                        Text(' スコア'),
                        Radio<int>(
                            value: 1,
                            groupValue: _type,
                            onChanged:(value) {
                                setState((){
                                _type = value!;
                                });
                            },
                        ),
                    ],
                ),
                Row(
                    children:[
                        Text(' X=$_mX'),
                        Slider(
                            min: 3,
                            max: 23,
                            divisions: 10,
                            value: _mX.toDouble(),
                            onChanged: (value) {
                                setState((){
                                _mX = value.toInt();
                                });
                            },
                        ),
                    ],
                ),
                Row(
                    children:[
                        Text(' Y=$_mY'),
                        Slider(
                            min: 3,
                            max: 23,
                            divisions: 10,
                            value: _mY.toDouble(),
                            onChanged: (value) {
                                setState((){
                                _mY = value.toInt();
                                });
                            },
                        ),
                    ],
                ),
                Row(
                    children:[
                        Text(' Z=$_mZ'),
                        Slider(
                            min: 1,
                            max: 19,
                            divisions: 9,
                            value: _mZ.toDouble(),
                            onChanged: (value) {
                                setState((){
                                _mZ = value.toInt();
                                });
                            },
                        ),
                    ],
                ),
                Row(
                    children:[
                        Text('Flag $_nF'),
                        Slider(
                            min: 1,
                            max: 15,
                            divisions: 14,
                            value: _nF.toDouble(),
                            onChanged: (value) {
                                setState((){
                                _nF = value.toInt();
                                });
                            },
                        ),
                    ],
                ),
                Row(
                    children:[
                        Text('MB $_nB'),
                        Slider(
                            min: 0,
                            max: 10,
                            divisions: 10,
                            value: _nB.toDouble(),
                            onChanged: (value) {
                                setState((){
                                _nB = value.toInt();
                                });
                            },
                        ),
                    ],
                ),
                Row(
                    children:[
                        Text('HP $_nP'),
                        Slider(
                            min: 0,
                            max: 5,
                            divisions: 5,
                            value: _nP.toDouble(),
                            onChanged: (value) {
                                setState((){
                                _nP = value.toInt();
                                });
                            },
                        ),
                    ],
                ),

                Row(children: [
                    Text('ニックネーム'),
                    Container(width:200,
                        padding:EdgeInsets.all(5),
                        child:TextField(
                            maxLines: 1,
                            controller: TextEditingController(text: _nickname),
                        decoration: InputDecoration(
                            labelText: 'Enter your name',
                            border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                            _nickname=text;
                        },
                    )),
                ]),
                
                Row(children:[
                    Text('ランキングサーバー'),
                    TextButton(
                        onPressed:() {
                            setState((){
                            _isEdit = true;
                            });
                         },
                        child:Text('編集')
                    ),
                ]),
                Visibility(visible: _isEdit,
                    child: Container(width:double.infinity,
                        padding:EdgeInsets.all(5),
                        child:TextField(
                            maxLines: 1,
                            controller: TextEditingController(text: _host),
                        decoration: InputDecoration(
                            labelText: 'host url',
                            border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                            _host=text;
                        },
                        onSubmitted: (text) {
                            _host = text;
                            print(_host);
                            setState((){
                            _isEdit = false;
                            });
                        },
                    )),
                ),
                Text(_host),

                TextButton(
                onPressed:(){
                    _save();
                    Navigator.of(context).pop(1);
                },
                child: Text('保存する')
                )
            ]),
        );
    }
}
