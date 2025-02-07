import 'package:flutter/material.dart';
import 'package:maze/models/MazeData.dart';
import 'dart:async';
import 'package:maze/models/SettingData.dart';
import 'package:maze/widgets/MazeMap.dart';
import 'package:maze/models/RankHttpClient.dart';

class MazeBase extends StatefulWidget {
  MazeBase({super.key});
  
  @override
  State<MazeBase> createState() => MazeState();
}

class MazeState extends State<MazeBase> {
  int px = 0;
  int py = 0;
  int pz = 0;
  int dr = 3;
  int vw = 0;
  
  MazeData mdt = MazeData();
  
  var drnm = ['W','E','S','N'];
  
  void _clearFlg() async {
      await Future.delayed(Duration(milliseconds:400));
      _checkFlag();
      setState(() {});
  }
  _checkFlag() {
      _iniPos();
//      print('$px,$py,$pz,${mdt.map[pz][py][px]}');
      if(mdt.map[pz][py][px]>9) {
          if(mdt.type==0) {
            int ic = mdt.map[pz][py][px]-10;
            if(ic==mdt.nxtflg) {
                mdt.map[pz][py][px] = 2;
                mdt.nxtflg++;
            }
          } else {
              mdt.map[pz][py][px] = 2;
              mdt.nxtflg++;
          }
          print('${mdt.nxtflg}');
          if(mdt.nxtflg == mdt.nflg) {
              _regist();
          }
      } else if(mdt.map[pz][py][px] == 1) {
          mdt.map[pz][py][px]=2;
      } else if(mdt.map[pz][py][px] == 3) {
          mdt.map[pz][py][px]=2;
          mdt.havB++;
      } else if(mdt.map[pz][py][px] == 4) {
          mdt.map[pz][py][px]=2;
          mdt.nHp += 10;
      }
  }
  _checkMove(int idr) {
    _checkFlag();
    if(mdt.nHp<=mdt.mcnt) {
        return;
    }
    int nx = px;
    int ny = py;
    int nz = pz;
    nx += mdt.mvX(idr);
    if(nx<0 || nx>=mdt.mx) return;
    ny += mdt.mvY(idr);
    if(ny<0 || ny>=mdt.my) return;
    nz += mdt.mvZ(idr);
    if(nz<0 || nz>=mdt.mz) return;
//    print('$idr,$nx,$ny,$nz,${mdt.map[nz][ny][nx]}');
    if(mdt.map[nz][ny][nx] != 0) {
        px = nx; py = ny; pz = nz;
        mdt.setPos(px, py, pz, dr, vw);
        mdt.mcnt++;
        
        if(mdt.map[nz][ny][nx] > 2) {
            _clearFlg();
        }
    }
  }
  _goFoward() {
      setState(() {
          _checkMove(mdt.mvF);
      });
  }
  _goBack() {
      setState(() {
          _checkMove(mdt.mvB);
      });
  }
  _goLeft() {
      setState(() {
          _checkMove(mdt.mvL);
      });
  }
  _goRight() {
      setState(() {
          _checkMove(mdt.mvR);
      });
  }
  _goDown() {
      setState(() {
          _checkMove(mdt.mvD);
          mdt.vm = mdt.pz;
      });
  }
  _goUp() {
      setState(() {
          _checkMove(mdt.mvU);
          mdt.vm = mdt.pz;
      });
  }
  
  _rotLeft() {
      _checkFlag();
      setState(() {
          dr = mdt.mvL;
          mdt.setPos(px,py,pz,dr,vw);
      });
  }
  _rotRight() {
      _checkFlag();
      setState(() {
          dr = mdt.mvR;
          mdt.setPos(px,py,pz,dr,vw);
      });
  }
  _lookDown() {
      _checkFlag();
      setState(() {
          if(vw==0) {
              vw = 1;
          } else if(vw==2) {
              vw = 0;
          }
          mdt.setPos(px,py,pz,dr,vw);
      });
  }
  _lookUp() {
      _checkFlag();
      setState(() {
          if(vw==0) {
              vw = 2;
          } else if(vw==1) {
              vw = 0;
          }
          mdt.setPos(px,py,pz,dr,vw);
      });
  }
  _lookFoward() {
      _checkFlag();
      setState(() {
          vw = 0;
          mdt.setPos(px,py,pz,dr,vw);
      });
  }
  _toggleMap(int ud) {
      if(ud > 0) {
          if(mdt.vm<mdt.mz-1) {
              setState(() { mdt.vm++; });
          }
        } else if(ud < 0) {
          if(mdt.vm>0) {
              setState(() { mdt.vm--; });
          }
        } else {
          if(mdt.pz == mdt.vm) {
               setState(() { mdt.showMap = !mdt.showMap; });
           } else {
              setState(() { mdt.vm = mdt.pz; });
          }
      }
  }
  _reset() {
      setState(() {
          mdt.reset();
      });
  }

  int _flsh = 0;
  _onTimer(Timer timer) {
          mdt.mskBomb= _flsh;
          setState(() { });
          _flsh = _flsh>>1;
          if(_flsh==0) {
              timer.cancel();
          }
  }
  _throwBomb() {
      bool scss = mdt.bombBlock(mdt.px+mdt.mvX(mdt.mvF),mdt.py+mdt.mvY(mdt.mvF),mdt.pz+mdt.mvZ(mdt.mvF));
      if(scss) {
        _flsh = 0xff;
        Timer.periodic(Duration(milliseconds: 200), _onTimer);
      }
  }
  _dropBomb() {
      bool scss = mdt.bombBlock(mdt.px+mdt.mvX(mdt.mvD),mdt.py+mdt.mvY(mdt.mvD),mdt.pz+mdt.mvZ(mdt.mvD));
      if(scss) {
        _flsh = 0xff;
        Timer.periodic(Duration(milliseconds: 200), _onTimer);
      }
  }
  
  _doRegist() {
      RankHttpClient client = RankHttpClient();
      client.postData(_nickname);
  }
  _regist() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _alertBuilder( context, "データを登録しますか？", 'ゴール', showReg ) );
  }
  
  _iniPos() {
      px = mdt.px;
      py = mdt.py;
      pz = mdt.pz;
      dr = mdt.dr;
      vw = mdt.vw;
  }

  @override
  void initState() {
    // 画面が表示された時に３秒カウントを開始する
//    mdt.init(5,5,1);
    super.initState();

//    mdt.load();
//    mdt.setupImg(() {
//        setState(() {});
//    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children:[
 //           Image.asset('assets/image/flag.jpg'),
                Container(
                    height: 60.0,
                    color: SettingData().bg,
                    child: Row(
                        children: [
                            Flexible(
                                flex:2,
                                fit: FlexFit.tight,
                                child:Text('位置x:$px y:$py z:$pz', style:TextStyle(color:Colors.white,fontSize:20)),
                            ),
                            Flexible(
                                flex:1,
                                fit: FlexFit.tight,
                                child:Text('方向'+drnm[MazeData().dr], style:TextStyle(color:Colors.white,fontSize:20)),
                            ),
                            Flexible(
                                flex:1,
                                fit: FlexFit.tight,
                                child:Text('MP:${mdt.havB}', style:TextStyle(color:Colors.white,fontSize:20)),
                            ),
                            Flexible(
                                flex:1,
                                fit: FlexFit.tight,
                                child:Text('HP:${mdt.nHp-mdt.mcnt}', style:TextStyle(color:Colors.white,fontSize:20)),
                            ),
                        ],
                    ),
                ),
                Expanded(
                child:Container(
                width: double.infinity,
                    color:SettingData().bg,
                    child:CustomPaint(
                        painter: MazeMap(),
                    ),
                )),
                Container(
                    height:180.0,
                    color:Colors.blue,
                    child:Stack(
                        children:[
                            Positioned(
                                left:0, top:60,
                                child: GestureDetector(
                                 onTap:(){
                                     _rotLeft();
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('左', style:TextStyle(fontSize:30)),
                                )))),
                            Positioned(
                                left:50, top:10,
                                child: GestureDetector(
                                 onTap:(){
                                     _goUp();
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('↑', style:TextStyle(fontSize:30)),
                                )))),
                            Positioned(
                                left:50, top:60,
                                child: GestureDetector(
                                 onTap:(){
                                     _goFoward();
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('前', style:TextStyle(fontSize:30)),
                                )))),
                            Positioned(
                                left:50, top:110,
                                child: GestureDetector(
                                 onTap:(){
                                     _goDown();
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('↓', style:TextStyle(fontSize:30)),
                                )))),
                            Positioned(
                                left:100, top:60,
                                child: GestureDetector(
                                 onTap:(){
                                     _rotRight();
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('右', style:TextStyle(fontSize:30)),
                                )))),

                            Positioned(
                                left:160, top:35,
                                child: GestureDetector(
                                 onTapDown:(detail){
                                     _lookUp();
                                    },
                                    onTapUp:(detail){
                                     _lookFoward();
                                    },
                                    onTapCancel:(){
                                     _lookFoward();
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('上', style:TextStyle(fontSize:30)),
                                )))),
                            Positioned(
                                left:160, top:85,
                                child: GestureDetector(
                                 onTapDown:(detail){
                                     _lookDown();
                                    },
                                    onTapUp:(detail){
                                     _lookFoward();
                                    },
                                    onTapCancel:(){
                                     _lookFoward();
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('下', style:TextStyle(fontSize:30)),
                                )))),

                            Positioned(
                                left:220, top:35,
                                child: GestureDetector(
                                 onTap:(){
                                     _throwBomb();
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('投', style:TextStyle(fontSize:30)),
                                )))),
                            Positioned(
                                left:220, top:85,
                                child: GestureDetector(
                                 onTap:(){
                                     _dropBomb();
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('落', style:TextStyle(fontSize:30)),
                                )))),

                            Positioned(
                                left:275, top:10,
                                child: GestureDetector(
                                 onTap:(){
                                     _toggleMap(0);
                                        print('press マップ');
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:80, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('マップ', style:TextStyle(fontSize:20)),
                                )))),
                            Positioned(
                                left:275, top:60,
                                child: GestureDetector(
                                 onTap:(){
                                    _toggleMap(1);
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('▲', style:TextStyle(fontSize:20)),
                                )))),
                            Positioned(
                                left:315, top:60,
                                child: GestureDetector(
                                 onTap:(){
                                    _toggleMap(-1);
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('▼', style:TextStyle(fontSize:20)),
                                )))),
                            Positioned(
                                left:275, top:110,
                                child: GestureDetector(
                                 onTap:(){
                                     _reset();
                                        print('press 下');
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:80, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('リセット', style:TextStyle(fontSize:18)),
                                )))),
                        ],
                    ),
                ),
            ]),
        );
    }
    
    AlertDialog _alertBuilder( BuildContext context,  String msg, String ttl, Function() cb ) {
        return AlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
                TextButton(
                    onPressed: () {
                    Navigator.pop(context);
//                    showReg();
                    cb();
                    },
                    child: const Text('する')),
                TextButton(
                    onPressed: () {
                    Navigator.pop(context);
                    },
                child: const Text('しない'))
            ],
        );
    }
  
    String _nickname = '';
    showReg() async {
        _nickname = SettingData().user;
        final result = await showModalBottomSheet<int>(
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
            ),            
            builder: (context) => SizedBox(
                height: 400.0,
                child: Column(
                    children: [
                        Text('登録'),
                        Row(children: [
                            Text('ニックネーム'),
                            Container(width:200,
                            padding:EdgeInsets.all(5),
                            child:TextField(
//                            maxLength: 10,
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
                        Container(
                            padding:EdgeInsets.all(5),
                            decoration:BoxDecoration(
                                border: Border.all(color:Colors.black, width:1),
                                borderRadius: BorderRadius.circular(6)
                            ),
                            child: Text(mdt.startMap,style:TextStyle(fontSize:10)),
                        ),
                        Row(children:[
                            TextButton(
                                onPressed:() {
                                  Navigator.of(context).pop();
                                  _doRegist();
                                },
                                child: Text('登録する'),
                            ),
                            TextButton(
                                onPressed:() {
                                    Navigator.of(context).pop();
                                },
                                child: Text('キャンセル'),
                            ),
                        ]),
                    ]
                ),
            ),
        );
    }
}
