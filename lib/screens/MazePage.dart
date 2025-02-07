import 'package:flutter/material.dart';
import 'package:maze/widgets/MazeBase.dart';
import 'package:maze/models/MazeData.dart';
import 'package:maze/models/SettingData.dart';
import 'package:maze/screens/SettingPage.dart';
import 'package:maze/screens/RankPage.dart';
import 'package:maze/screens/MakePage.dart';
import 'package:maze/screens/AboutPage.dart';

  final menuList = ['迷路', 'ランク', '設定', 'エディタ', 'About'];

class MazePage extends StatefulWidget {
  MazePage({super.key});

  @override
  State<MazePage> createState() => MazePageState();
}

class MazePageState extends State<MazePage> with WidgetsBindingObserver {

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
            title: const Text('Maze'),
        ),
        // https://qiita.com/suga_slj/items/019838b063db8c708391
        drawer: Drawer(
        child: ListView(
            children: [
                const DrawerHeader(
                    child: Center(
                        child: Text('DrawerHeader',
                            style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                    ),
                    decoration: BoxDecoration(
                    color: Colors.blue,
                    ),
                ),
                const Divider(
                    thickness: 1.0,
                    color: Colors.black,
                ),
                ...menuList.map(
                    (e) => listTile(e, context),
                )
            ],
        ),
        ),
        body: Column(
            children: [
                Expanded(
                    child: MazeBase(),
                ),
            ]),
        );
    }

  Widget listTile(String title, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              IconButton(
                onPressed: () async { 
                    print(title);
                    int idx = menuList.indexOf(title);
                    if(idx==1) { // Rank
                        Navigator.of(context).pop();
                        int? ret = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => RankPage(),
                        ),
                        );
                        // todo reflesh maze
                        if(ret !=null && ret==1) { update(); }
                    } else if(idx==2) { // Setting
                    // https://qiita.com/hiko1129/items/9d31938046bbf4dcad2e
                        Navigator.of(context).pop();
                        int? ret = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SettingPage(),
                        ),
                        );
                        if(ret!=null && ret==1) { update(); }
                    } else if(idx==3) {
                        Navigator.of(context).pop();
                        int? ret = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MakePage(),
                        ),
                        );
                        if(ret!=null && ret==1) { update(); }
                    } else if(idx==4) {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AboutPage(),
                        ),
                        );
                        
                    }
                },
                icon: const Icon(Icons.arrow_circle_right),
              )
            ],
          ),
        ),
        const Divider(
          thickness: 1.0,
          color: Colors.black,
        ),
      ],
    );
  }
}

