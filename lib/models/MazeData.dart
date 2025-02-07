import 'dart:math' as math;
import 'dart:ui' as ui;
import "package:hex/hex.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as hoge;
import 'package:maze/models/SettingData.dart';

class MazeData {
  static bool isReady = false;
//    MazeData({required int nx, required int ny, required int nz});
  // シングルトンインスタンスを保持する静的な変数
  static final MazeData _instance = MazeData._internal();
  // インスタンスを取得するためのファクトリコンストラクタ
  // 常に同じインスタンスを返す
  factory MazeData() {
    return _instance;
  }
/*  factory MazeData(int nx, int ny, int nz) {
      _instance.nx = nx;
      _instance.ny = ny;
      _instance.nz = nz;
      _instance.init(nx,ny,nz);
      return _instance;
    }*/

  // インスタンス生成時に使用されるプライベートな名前付きコンストラクタ
  MazeData._internal() {
      print('MazeDataクラスのインスタンスが生成されました');
  }


    int did = 0;
  
    int type = 0; // =0:ポイント,1:スコア
    int nx = 0;
    int ny = 0;
    int nz = 0;
    int mx = 9;
    int my = 9;
    int mz = 1;
    int nflg = 10;
    int nBomb = 5;
    int iniB = 5;
    int iniHp = 10;
    int nPotion = 3;
    
    int havB = 5;
    int useB = 0;
    int mcnt = 0;
    int nHp = 10;
    int nxtflg = 0;
    
    List<List<List<int>>> map = [];
    List<int> flgPos =[];
    String startMap = '';
    
    int px = 0;
    int py = 0;
    int pz = 0;
    int dr = 3;
    int vw = 0;
    int vm = 0;
    setPos(int px, int py, int pz, int dr, int vw) {
        this.px = px;
        this.py = py;
        this.pz = pz;
        this.dr = dr;
        this.vw = vw;
    }
    
    bool showMap = true;
    
    init(int nx,int ny, int nz) {
        this.nx = nx;
        this.ny = ny;
        this.nz = nz;
        mx = nx*2-1;
        my = ny*2-1;
        mz = nz*2-1;
        iniHp = (nx*ny*nz*2-1)*3 ~/ 2;
        make();
    }
    
    List<int> digAble(int ix, int iy, int iz) {
//        print('digAble $ix,$iy,$iz');
        List<int> ans = [];
        if(1<ix && map[iz][iy][ix-1]==0 && map[iz][iy][ix-2]==0) { ans.add(0); }
        if(ix<mx-2 && map[iz][iy][ix+1]==0 && map[iz][iy][ix+2]==0) { ans.add(1); }
        if(1<iy && map[iz][iy-1][ix]==0 && map[iz][iy-2][ix]==0) { ans.add(2); }
        if(iy<my-2 && map[iz][iy+1][ix]==0 && map[iz][iy+2][ix]==0) { ans.add(3); }
        if(1<iz && map[iz-1][iy][ix]==0 && map[iz-2][iy][ix]==0) { ans.add(4); }
        if(iz<mz-2 && map[iz+1][iy][ix]==0 && map[iz+2][iy][ix]==0) { ans.add(5); }
        return ans;
    }
    bool isDigAble(int ix, int iy, int iz, int idr) {
        switch(idr) {
            case 0:
                if(ix>0 && map[iz][iy][ix-1]==0)  return true;
                break;
            case 1:
                if(ix<mx-1 && map[iz][iy][ix+1]==0)  return true;
                break;
            case 2:
                if(iy>0 && map[iz][iy-1][ix]==0)  return true;
                break;
            case 3:
                if(iy<my-1 && map[iz][iy+1][ix]==0)  return true;
                break;
            case 4:
                if(iz>0 && map[iz-1][iy][ix]==0)  return true;
                break;
            case 5:
                if(iz<mz-1 && map[iz+1][iy][ix]==0)  return true;
                break;
        }
        return false;
    }
    int doDig(int ix, int iy, int iz, int idr) {
        int v = (type==0)?2:1;
        switch(idr) {
            case 0:
                map[iz][iy][ix-1]=v;
                map[iz][iy][ix-2]=v;
                break;
            case 1:
                map[iz][iy][ix+1]=v;
                map[iz][iy][ix+2]=v;
                break;
            case 2:
                map[iz][iy-1][ix]=v;
                map[iz][iy-2][ix]=v;
                break;
            case 3:
                map[iz][iy+1][ix]=v;
                map[iz][iy+2][ix]=v;
                break;
            case 4:
                map[iz-1][iy][ix]=v;
                map[iz-2][iy][ix]=v;
                break;
            case 5:
                map[iz+1][iy][ix]=v;
                map[iz+2][iy][ix]=v;
                break;
        }
        return (iz*my+iy)*mx+ix;
    }
    int mvX(int idr) {
        if(idr==0)  return -1;
        else if(idr==1)  return 1;
        return 0;
    }
    int mvY(int idr) {
        if(idr==2)  return -1;
        else if(idr==3)  return 1;
        return 0;
    }
    int mvZ(int idr) {
        if(idr==4)  return -1;
        else if(idr==5)  return 1;
        return 0;
    }
    
    _make1() {
        int ix = 0;
        int iy = 0;
        int iz = 0;
        int nc = nx*ny*nz-1;
        map[0][0][0] = 2;
        List<int> stck = [0];
        var random = math.Random();
        while(nc>0) {
            var ans = digAble(ix,iy,iz);
            if(ans.length<=0)  {
                if(stck.length<=0) break;
                int ip = stck.removeLast();
                ix = ip%mx;
                ip = ip~/mx;
                iy = ip%my;
                iz = ip~/my;
                continue;
            }

            int idr = ans[random.nextInt(ans.length)];
            stck.add(doDig(ix,iy,iz,idr));
            nc--;
            ix+=mvX(idr)*2;
            iy+=mvY(idr)*2;
            iz+=mvZ(idr)*2;
        }
    }
    
    _putFlags() {
        // 0,0,0には配置しない（loadの都合）
        List<int> pos = List.generate(nx*ny*nz-1,(e) => e+1);
        flgPos = List.filled(nflg, 0);
        var random = math.Random();
        for(int ic=0; ic<nflg; ic++) {
            int ip = random.nextInt(pos.length);
            int ixyz = pos.removeAt(ip);
            int ix = (ixyz % nx)*2;
            ixyz = ixyz ~/ nx;
            int iy = (ixyz % ny)*2;
            int iz = (ixyz ~/ ny)*2;
            map[iz][iy][ix] = ic+10;
            flgPos[ic] = (iz*my+iy)*mx+ix;
        }
        for(int ic=0; ic<nBomb; ic++) {
            int ip = random.nextInt(pos.length);
            int ixyz = pos.removeAt(ip);
            int ix = (ixyz % nx)*2;
            ixyz = ixyz ~/ nx;
            int iy = (ixyz % ny)*2;
            int iz = (ixyz ~/ ny)*2;
            map[iz][iy][ix] = 3;
        }
        for(int ic=0; ic<nPotion; ic++) {
            int ip = random.nextInt(pos.length);
            int ixyz = pos.removeAt(ip);
            int ix = (ixyz % nx)*2;
            ixyz = ixyz ~/ nx;
            int iy = (ixyz % ny)*2;
            int iz = (ixyz ~/ ny)*2;
            map[iz][iy][ix] = 4;
        }
    }
    int flgStt(int ic) {
        if(flgPos.length<=ic)  return 0;
            int iz = flgPos[ic];
            if(iz==0) {
                return 0;
            }
            int ix = iz % mx;
            iz = iz ~/ mx;
            int iy = iz % my;
            iz = iz ~/ my;
            if(type==0) {
                if(ic==nxtflg) {
                    return 1;
                } else {
                    if(map[iz][iy][ix]==1 || map[iz][iy][ix]==2) {
                        return 0;
                    } else {
                        return 2;
                    }
                }
            } else {
                if(map[iz][iy][ix]==1 || map[iz][iy][ix]==2) {
                    return 0;
                } else {
                    return 1;
                }
            }
    }
    
    clearMap() {
// https://zenn.dev/tsukatsuka1783/articles/flutter_factory
//        map = List.filled(mz, List.filled(my, List.filled(mx, 0)));
// https://qiita.com/lacolaco/items/99554704b4d4733eed6d
        map = [];
        for(int iz=0; iz<mz; iz++) {
            List<List<int>> y = [];
            for(int iy=0; iy<my; iy++) {
                List<int> x = List.filled(mx, 0);
                y.add(x);
            }
            map.add(y);
        }
    }
    make() {
        clearMap();
        _make1();
        _putFlags();
        
        startMap = encode();
        px = 0;
        py = 0;
        pz = 0;
        dr = 3;
        vw = 0;
        vm = 0;
        mcnt = 0;
        havB = iniB;
        useB = 0;
        nHp = iniHp;
        nxtflg = 0;
    }
    
    setupMap() {
        clearMap();
        map[0][0][0] = 2;
        px = 0;
        py = 0;
        pz = 0;
        dr = 3;
        vw = 0;
        vm = 0;
        
        flgPos = [];
        useB = nBomb;
        nHp = nPotion;
    }
    putObj(int type) {
        if(map[pz][py][px]!=1) {
            return;
        }
        if(type == 1 && flgPos.length < nflg) { // flag
            if(px+py+pz == 0)  return; // flag は0,0,0禁止
            int ixyz = (pz*my+py)*mx+px;
            flgPos.add(ixyz);
            map[pz][py][px] = flgPos.length+9;
        } else if(type == 2 && useB > 0) { // bomb
            useB--;
            map[pz][py][px] = 3;
        } else if(type == 3 && nHp > 0) { // potion
            nHp--;
            map[pz][py][px] = 4;
        } else if(type == 0) { // wall
            map[pz][py][px] = 0;
        }
    }
    storeMap() {
        startMap = encode();
        px = 0;
        py = 0;
        pz = 0;
        dr = 3;
        vw = 0;
        vm = 0;
        mcnt = 0;
        havB = iniB;
        useB = 0;
        nHp = iniHp;
        nxtflg = 0;
    }

/*
  z+
   5  3 y+s
   |/
0--*--1 x+
  /|
2  4
*/
    int mvF = 0; // 後
    int mvB = 1;
    int mvL = 2;
    int mvR = 3;
    int mvD = 4;
    int mvU = 5;
    int vwF = 0;
    int vwD = 4;
    int vwU = 5;
    
    int stF = 1;
    int stB = 1;
    int stL = 1;
    int stR = 1;
    int stU = 1;
    int stD = 1;
    setMove(int idr, int ivw) {
        mvF = 0; // 後
        mvL = 2;
        mvR = 3;
        mvD = 4;
        mvU = 5;
        if(idr==1) {
            mvF = 1; // 前
            mvL = 3;
            mvR = 2;
        } else if(idr==2) {
            mvF = 2; // 左
            mvL = 1;
            mvR = 0;
        } else if(idr==3) {
            mvF = 3; // 右
            mvL = 0;
            mvR = 1;
        }
        vwF = mvF;
        vwD = mvD;
        vwU = mvU;
        
        if(ivw==1) {
            vwU = mvF;
            vwD = mvF ^ 1;
            vwF = 4; // 下
        } else if(ivw==2) {
            vwD = mvF;
            vwU = mvF ^ 1;
            vwF = 5; // 上
        }
        mvB = mvF ^ 1;
        
        stF = 1<<vwF;
        stB = 1<<(vwF ^ 1);
        stL = 1<<mvL;
        stR = 1<<mvR;
        stD = 1<<vwD;
        stU = 1<<vwU;
    }

    int posState(int ix, int iy, int iz) {
        int stt = 0;
        if(ix<0 || ix>=mx || iy<0 || iy>=my ||
           iz<0 || iz>=mz || map[iz][iy][ix]==0) { return stt; }
        
        int tx=ix-1;
        if(tx<0 || map[iz][iy][tx]==0) {
            stt |= 1;
        }
        tx=ix+1;
        if(tx>=mx || map[iz][iy][tx]==0) {
            stt |= 2;
        }
        int ty=iy-1;
        if(ty<0 || map[iz][ty][ix]==0) {
            stt |= 4;
        }
        ty=iy+1;
         if(ty>=my || map[iz][ty][ix]==0) {
            stt |= 8;
        }
        int tz=iz-1;
        if(tz<0 || map[tz][iy][ix]==0) {
            stt |= 16;
        }
        tz=iz+1;
        if(tz>=mz || map[tz][iy][ix]==0) {
            stt |= 32;
        }
        return stt&0x3f;
    }
    
    int mskBomb = 0;
    bool bombBlock(int ix, int iy, int iz) {
        if(havB<=0)  return false;
        if(ix<0 || ix>=mx || iy<0 || iy>=my || iz<0 || iz>=mz) {
            return false;
        }
        if(map[iz][iy][ix]==0) {
            map[iz][iy][ix] = 1;
            havB--;
            useB++;
            return true;
        }
        return false;
    }
    
    final String txt64 = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#';
    int nobj = 0;
    String encsub(int flg) {
        int ic = 0x1;
        String code = '';
        nobj = 0;
        for(int iz=0; iz<mz; iz++) {
            for(int iy=0; iy<my; iy++) {
                for(int ix=0; ix<mx; ix++) {
                    ic = (ic<<1)|(map[iz][iy][ix]==flg?1:0);
                    if(ic&0x40 != 0) {
                        ic &= 0x3f;
                        code += txt64.substring(ic,ic+1);
                        ic = 1;
                    }
                    if(map[iz][iy][ix]>2) {
                        nobj++;
                    }
                }
            }
        }
        if(ic != 0x1) {
            int sl =(mx*my*mz)%6;
            ic = (ic<<(6-sl))&0x3f;
            print('$ic');
            code += txt64.substring(ic,ic+1);
        }
        return code;
    }
    String encode() {
        // https://qiita.com/lacolaco/items/2526bcc7803c44c0be3c
        String def = did.toRadixString(16).padLeft(4,"0")+type.toString()
        +mx.toString().padLeft(2, "0")+my.toString().padLeft(2, "0")+mz.toString().padLeft(2, "0")+nflg.toString().padLeft(2,"0")+nBomb.toString().padLeft(2,"0")+iniB.toString().padLeft(2,"0")        +nPotion.toString().padLeft(2,"0")+iniHp.toString().padLeft(3,"0");
//        int ic = 0x1;
//        String code = '';
        int nob = 0;
/*        for(int iz=0; iz<mz; iz++) {
            for(int iy=0; iy<my; iy++) {
                for(int ix=0; ix<mx; ix++) {
                    ic = (ic<<1)|(map[iz][iy][ix]==0?0:1);
                    if(ic&0x40 != 0) {
                        ic &= 0x3f;
                        code += txt64.substring(ic,ic+1);
                        ic = 1;
                    }
                    if(map[iz][iy][ix]>2) {
                        nob++;
                    }
                }
            }
        }
        if(ic != 0x1) {
            int sl =(mx*my*mz)%6;
            ic = (ic<<(6-sl))&0x3f;
            print('$ic');
            code += txt64.substring(ic,ic+1);
        }*/
        String code1 = encsub(1);
        nob = nobj;
        String code2 = encsub(2);
        print('$nobj,$nob,${code1.length},${code2.length},$code1,$code2');
        String obj = nob.toString().padLeft(2,'0')
        +havB.toString().padLeft(2,"0")+useB.toString().padLeft(2,"0")+nHp.toString().padLeft(3,"0")+mcnt.toString().padLeft(3,"0")
        +nxtflg.toString().padLeft(2,"0");
        for(int iz=0; iz<mz; iz++) {
            for(int iy=0; iy<my; iy++) {
                for(int ix=0; ix<mx; ix++) {
                    if(map[iz][iy][ix]>1) {
                        int ic = map[iz][iy][ix];
                        int ixyz = ((iz*my)+iy)*mx+ix;
                        obj += ixyz.toString().padLeft(5,'0')+txt64.substring(ic,ic+1);
                    }
                }
            }
        }
        return def+code1+code2+obj;
    }

    int decsub(String code, int ip, int flg, List<List<List<int>>> mpz) {
        int msk = 1;
        int ic = 0;
        for(int iz=0; iz<mz; iz++) {
//            List<List<int>> mpy = [];
            for(int iy=0; iy<my; iy++) {
//                List<int> mpx = [];
                for(int ix=0; ix<mx; ix++) {
                    if(msk==1) {
                        ic = txt64.indexOf(code.substring(ip,ip+1));
                         if(ic<0)  return -1;
                        ip++;
                        msk = 0x40;
                    }
                    msk = msk>>1;
                    if(ic&msk != 0) {
                        mpz[iz][iy][ix] = 1;
                    }
                }
//                mpy.add(mpx);
            }
//            mpz.add(mpy);
        }
        return ip;
    }
    bool decode(String code, bool isCheck) {
        // https://qiita.com/lacolaco/items/2526bcc7803c44c0be3c
        print('$code');
        int did = HEX.decode(code.substring(0,2))[0]*256+HEX.decode(code.substring(2,4))[0];
        int type = int.parse(code.substring(4,5));
        int mx = int.parse(code.substring(5,7));
        int my = int.parse(code.substring(7,9));
        int mz = int.parse(code.substring(9,11));
        int nx = (mx+1)~/2;
        int ny = (my+1)~/2;
        int nz = (mz+1)~/2;
        int nf = int.parse(code.substring(11,13));
        int nb = int.parse(code.substring(13,15));
        int ib = int.parse(code.substring(15,17));
        int nP = int.parse(code.substring(17,19));
        int iP = int.parse(code.substring(19,22));
        int ip = 22;
        print('$mx,$my,$mz');
        int msk = 1;
        List<List<List<int>>> mpz = [];
        int ic = 0;
        for(int iz=0; iz<mz; iz++) {
            List<List<int>> y = [];
            for(int iy=0; iy<my; iy++) {
                List<int> x = List.filled(mx, 0);
                y.add(x);
            }
            mpz.add(y);
        }
        for(int iz=0; iz<mz; iz++) {
            for(int iy=0; iy<my; iy++) {
                for(int ix=0; ix<mx; ix++) {
                    if(msk==1) {
                        ic = txt64.indexOf(code.substring(ip,ip+1));
                         if(ic<0)  return false;
                        ip++;
                        msk = 0x40;
                    }
                    msk = msk>>1;
                    if(ic&msk != 0) {
                        mpz[iz][iy][ix] = 1;
                    }
                }
            }
        }
//        ip = decsub(code,ip,1,mpz);
        print('ip=$ip');
        msk = 1;
        for(int iz=0; iz<mz; iz++) {
            for(int iy=0; iy<my; iy++) {
                for(int ix=0; ix<mx; ix++) {
                    if(msk==1) {
                        ic = txt64.indexOf(code.substring(ip,ip+1));
                         if(ic<0)  return false;
                        ip++;
                        msk = 0x40;
                    }
                    msk = msk>>1;
                    if(ic&msk != 0) {
                        mpz[iz][iy][ix] = 2;
                    }
                }
            }
        }
//        ip = decsub(code,ip,2,mpz);
        print('ip=$ip');

        int nob = int.parse(code.substring(ip,ip+2));
        ip += 2;
        print('$nob');
        int hB = int.parse(code.substring(ip,ip+2));
        ip += 2;
        int uB = int.parse(code.substring(ip,ip+2));
        ip += 2;
        int nh = int.parse(code.substring(ip,ip+3));
        ip += 3;
        int mc = int.parse(code.substring(ip,ip+3));
        ip += 3;
        int nxf = int.parse(code.substring(ip,ip+2));
        ip += 2;
        List<int> fp = List.filled(nf, 0);
        for(int iob=0; iob<nob; iob++) {
            int ixyz = int.parse(code.substring(ip,ip+5));
            int ix = ixyz%mx;
            ixyz = ixyz ~/ my;
            int iy = ixyz%my;
            int iz = ixyz ~/ my;
            if(iz>=mz)  return false;
            int ic = txt64.indexOf(code.substring(ip+5, ip+6));
            ip += 6;
            mpz[iz][iy][ix] = ic;
            if(ic>9) {
                ic -= 10;
                fp[ic] = ((iz*my)+iy)*mx+ix;
            }
        }
        if(!isCheck) {
            this.did = did;
            this.type = type;
            this.mx = mx;
            this.my = my;
            this.mz = mz;
            this.nx = nx;
            this.ny = ny;
            this.nz = nz;
            this.nBomb = nb;
            this.iniB = ib;
            this.nPotion = nP;
            this.iniHp = iP;
            this.nflg = nf;
            this.havB = hB;
            this.useB = uB;
            this.nHp = nh;
            this.mcnt = mc;
            this.nxtflg = nxf;
            this.flgPos = fp;
            this.map = mpz;
        }
        return true;
    }
    
    int score() {
        return 1;
    }
    
    
    // https://stackoverflow.com/questions/49784225/flutter-how-to-draw-an-image-on-canvas-using-drawimage-method
    Future<ui.Image> loadImage(String imageName) async {
        final data = await rootBundle.load('assets/image/$imageName');
        return decodeImageFromList(data.buffer.asUint8List());
    }
    //https://stackoverflow.com/questions/59923245/flutter-convert-and-resize-asset-image-to-dart-ui-image
    Future<ui.Image> getUiImage(String imageName, int height, int width) async {
        final ByteData assetImageByteData = await rootBundle.load('assets/image/$imageName');
        final codec = await ui.instantiateImageCodec(
            assetImageByteData.buffer.asUint8List(),
            targetHeight: height,
            targetWidth: width,
        );
        return (await codec.getNextFrame()).image;
    }
        
    late ui.Image flag;
    late ui.Image bomb;
    bool readyImg = false;

    setupImg(Function cb) async {
        flag = await getUiImage('flag.dat', 200,200);
        print(flag);
        bomb = await getUiImage('bomb.dat', 200,200);
        readyImg = true;
//        ui.Image img = await loadImage('flag.jpg');
//        img = hoge.copyResize(img, width:100);
        cb();
    }
    
    save() {
        String code = encode();
        SettingData().setString('save', code);
        SettingData().setString('start', startMap);
    }
    load() async {
        print('load in');
        String start = SettingData().getString('start', '');
        print(start);
        if(start=='') {
            init(5, 5, 2);
            print('load end');
            isReady = true;
            return;
        }
        startMap = start!;
        String code = SettingData().getString('save', startMap);
        decode(code, false);
        print('load end2');
        isReady = true;
    }
    bool read(String code) {
        if(!decode(code, false)) {
            return false;
        }
        startMap = code;
        decode(code, true);
        mcnt = 0;
        px = 0;
        py = 0;
        pz = 0;
        dr = 3;
        vw = 0;
        return true;
    }
    reset() {
        bool ret = decode(startMap, false);
        mcnt = 0;
        px = 0;
        py = 0;
        pz = 0;
        dr = 3;
        vw = 0;
        print('reset $ret');
    }
        
}