import 'package:flutter/material.dart';
import 'package:maze/models/MazeData.dart';
import 'dart:async';
import 'package:maze/models/SettingData.dart';
import 'package:maze/widgets/MazeMap.dart';
import 'package:maze/models/RankHttpClient.dart';

class MakeBase extends StatefulWidget {
  MakeBase({super.key});
  
  @override
  State<MakeBase> createState() => MakeState();
}

class MakeState extends State<MakeBase> {
  int px = 0;
  int py = 0;
  int pz = 0;
  int dr = 3;
  int vw = 0;
  
  MazeData mdt = MazeData();
  
  var drnm = ['W','E','S','N'];
  
  _checkDig(int idr) {
    _iniPos();
//    if(mdt.nHp<=mdt.mcnt) {
//        return;
//    }
    int nx = px;
    int ny = py;
    int nz = pz;
    nx += mdt.mvX(idr);
    if(nx<0 || nx>=mdt.mx) return;
    ny += mdt.mvY(idr);
    if(ny<0 || ny>=mdt.my) return;
    nz += mdt.mvZ(idr);
    if(nz<0 || nz>=mdt.mz) return;
    print('$nx,$ny,$nz,${mdt.map[nz][ny][nx]}');
    if(mdt.map[nz][ny][nx] == 0) {
        mdt.map[nz][ny][nx] = 1;
    }
    if(mdt.map[nz][ny][nx] != 0) {
        px = nx; py = ny; pz = nz;
        mdt.setPos(px, py, pz, dr, vw);
    }
  }
  _goFoward() {
      setState(() {
          _checkDig(mdt.mvF);
      });
  }
  _goBack() {
      setState(() {
          _checkDig(mdt.mvB);
      });
  }
  _goLeft() {
      setState(() {
          _checkDig(mdt.mvL);
      });
  }
  _goRight() {
      setState(() {
          _checkDig(mdt.mvR);
      });
  }
  _goDown() {
      setState(() {
          _checkDig(mdt.mvD);
          mdt.vm = mdt.pz;
      });
  }
  _goUp() {
      setState(() {
          _checkDig(mdt.mvU);
          mdt.vm = mdt.pz;
      });
  }
  
  _rotLeft() {
      setState(() {
          dr = mdt.mvL;
          mdt.setPos(px,py,pz,dr,vw);
      });
  }
  _rotRight() {
      setState(() {
          dr = mdt.mvR;
          mdt.setPos(px,py,pz,dr,vw);
      });
  }
  _lookDown() {
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

  _putFlag() {
      mdt.putObj(1);
  }
  _putBomb() {
      mdt.putObj(2);
  }
  _putHp() {
      mdt.putObj(3);
  }
  _putWall() {
      mdt.putObj(0);
  }
  _save() {
      mdt.storeMap();
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
    mdt.setupMap();
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
                                 onTap:(){
                                     _putFlag();
                                     },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('旗', style:TextStyle(fontSize:30)),
                                )))),
                            Positioned(
                                left:160, top:85,
                                child: GestureDetector(
                                 onTap:(){
                                     _putWall();
                                     },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('壁', style:TextStyle(fontSize:30)),
                                )))),

                            Positioned(
                                left:220, top:35,
                                child: GestureDetector(
                                 onTap:(){
                                     _putHp();
                                     },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('薬', style:TextStyle(fontSize:30)),
                                )))),
                            Positioned(
                                left:220, top:85,
                                child: GestureDetector(
                                 onTap:(){
                                     _putBomb();
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:40, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('爆', style:TextStyle(fontSize:30)),
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
                                     _save();
                                     Navigator.of(context).pop(1);
                                    },
                                child:Container(
                                    padding:EdgeInsets.all(5),
                                    color:Color(0xff888888),
                                    child:Container(
                                    width:80, height:40,
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('閉じる', style:TextStyle(fontSize:18)),
                                )))),
                        ],
                    ),
                ),
            ]),
        );
    }
    
}
