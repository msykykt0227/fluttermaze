import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:hex/hex.dart";
import 'package:maze/widgets/MazeBase.dart';
import 'package:maze/models/MazeData.dart';
import 'package:maze/models/RankData.dart';
import 'package:maze/models/RankHttpClient.dart';

class RankPage extends StatefulWidget {
  RankPage({super.key});
  
  @override
  State<RankPage> createState() => RankState();
}

class RankState extends State<RankPage> {

  RankHttpClient client = RankHttpClient();
  MazeData mdt = MazeData();
  
  List<Rank> _same = [];
  List<Rank> _rank = [];
  
  @override
  void initState() {
    super.initState();
    loadRank();
  }
  
  loadRank() {
    client.getRank(0,(rank) {
        _rank = rank;            
        client.getRank((mdt.did==0)?-1:mdt.did, (rank) {
            setState(() {
            _same = rank;
            });
        });
      });
  }
  
  final List<String> dmy = ['a','b','c'];
  
  Widget listRow(BuildContext context, int index, Rank dt) {
      return GestureDetector(
        onTap: () {
            print(dt.did);
            RankHttpClient client = RankHttpClient();
            client.getData(dt.did, (code) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => _alertBuilder(context, code));
            });
        },
        child: Row(
            children:[
                Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child:Text('${(index+1).toString().padLeft(2,' ')} ')),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 8,
                    child: Text(dt.name)),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 3,
                    child:Text(dt.score.toString())),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 5,
                    child:Text(dt.date.substring(2,10))),
            ],
        ));
  }
  
  @override
  Widget build(BuildContext context) {
//      print('build');
    return Scaffold(
        appBar: AppBar(
            title: const Text('ランク'),
        ),
        body: Padding(
                padding: const EdgeInsets.all(10.0),
                child:Column(
                children: [
                Text('データ：${MazeData().did}'),
                // https://www.flutter-study.dev/widgets/container-widget
                Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration:BoxDecoration(
                        border: Border.all(color:Colors.black, width:1),
                        borderRadius: BorderRadius.circular(6)
                    ),
                    child:Text(mdt.encode(),style:TextStyle(fontSize:12)),
                ),
                Text('同じデータのランク'),
                Container(
                height: 150,
                child:ListView.builder(
                itemCount: _same.length,
                itemBuilder: (context, index) {
                    return listRow(context,index, _rank[index]);
                },
                )),
                Text('クリアデータ上位'),
                Container(
                height: 300,
                child:ListView.builder(
                itemCount: _rank.length,
                itemBuilder: (context, index) {
                    return listRow(context, index, _rank[index]);
                },
                )),
            ]),
        ));
    }
    
    AlertDialog _alertBuilder(BuildContext context,  String code ) {
        int did = HEX.decode(code.substring(0,2))[0]*256+HEX.decode(code.substring(2,4))[0];
        int type = int.parse(code.substring(4,5));
        int mx = int.parse(code.substring(5,7));
        int my = int.parse(code.substring(7,9));
        int mz = int.parse(code.substring(9,11));
        String msg = 'サイズ $mx x $my x $mz に挑戦しますか？';
        return AlertDialog(
            title: const Text('データ読み込み'),
            content: Text(msg),
            actions: [
                TextButton(
                    onPressed: () {
                    Navigator.pop(context);
                    MazeData().read(code);
                    Navigator.of(context).pop(1);
                    },
                    child: const Text('上書きする')),
                TextButton(
                    onPressed: () {
//                    Navigator.pop(context);
                    Navigator.pop(context);
                    },
                child: const Text('やめる'))
            ],
        );
    }
}
