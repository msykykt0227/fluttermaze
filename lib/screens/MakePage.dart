import 'package:flutter/material.dart';
import 'package:maze/widgets/MakeBase.dart';
import 'package:maze/models/MazeData.dart';
import 'package:maze/models/SettingData.dart';
import 'package:maze/screens/SettingPage.dart';
import 'package:maze/screens/RankPage.dart';
import 'package:maze/screens/AboutPage.dart';

class MakePage extends StatefulWidget {
  MakePage({super.key});

  @override
  State<MakePage> createState() => MakePageState();
}

class MakePageState extends State<MakePage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SettingData().load(() {
        MazeData().load();
        MazeData().setupImg(() {
            setState(() {});
        });
    });
  }

// https://qiita.com/kenji1203/items/7f590d56bf12c9a6ba73
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//    debugPrint("lifecycle state change=$state");
    if(state == AppLifecycleState.paused) {
        MazeData().save();
    }
  }
  
  update() {
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Make'),
        ),
        // https://qiita.com/suga_slj/items/019838b063db8c708391
        body: Column(
            children: [
                Expanded(
                    child: MakeBase(),
                ),
            ]),
        );
  }
}

