import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:maze/models/MazeData.dart';
import 'package:maze/models/SettingData.dart';

class MazeMap extends CustomPainter {
//    const MazeMap({super.key, required MazeData mdt, required int px, required int py, required int pz});
    
    drawStr(Canvas canvas, String str, double x, double y, double sz, Color col) {
            TextSpan span = TextSpan(
                style: TextStyle(
                    color: col,
                    fontSize: sz,
                    fontWeight: FontWeight.bold,
                ),
                text: str,
            );
            final textPainter = TextPainter(
                text: span,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
            );
            textPainter.layout();
            textPainter.paint(canvas, Offset(x, y));
    }
    
    drawCube(Canvas canvas, int mvf, int mvx, int mvy, double xl, double fct) {
        Paint lpen = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0
            ..color = SettingData().fg;
        Paint fpen = Paint()
            ..style = PaintingStyle.fill
            ..color = SettingData().bg;
                var mz = MazeData();

        int ix = mz.px+mvf*mz.mvX(mz.vwF)+mvy*mz.mvX(mz.vwU)+mvx*mz.mvX(mz.mvR);
        int iy = mz.py+mvf*mz.mvY(mz.vwF)+mvy*mz.mvY(mz.vwU)+mvx*mz.mvY(mz.mvR);
        int iz = mz.pz+mvf*mz.mvZ(mz.vwF)+mvy*mz.mvZ(mz.vwU)+mvx*mz.mvZ(mz.mvR);
        int stt = mz.posState(ix, iy, iz);
        if(stt==0) return;
        var dls = xl*fct;
        var dle = xl*fct/0.6;
        var xsl = dls*(mvx-0.5);
        var xsr = xsl+dls;
        var xel = dle*(mvx-0.5);
        var xer = xel+dle;
        var ysu = dls*(-mvy-0.5);
        var ysd = ysu+dls;
        var yeu = dle*(-mvy-0.5);
        var yed = yeu+dle;
/*                    if(stt&1 != 0) {
                        p.moveTo(xel,yeu);
                        p.lineTo(xer,yeu);
                        p.lineTo(xer,yed);
                        p.lineTo(xel,yed);
                        p.close();
                        canvas.drawPath(p,lpen);
                    }*/
        if((stt&mz.stF) != 0) {
            Rect rct = Rect.fromLTWH(xsl,ysu, xsr-xsl, ysd-ysu);
            canvas.drawRect(rct,fpen);
            canvas.drawRect(rct,lpen);
//                        p.moveTo(xsl,ysu);
//                        p.lineTo(xsr,ysu);
//                        p.lineTo(xsr,ysd);
//                        p.lineTo(xsl,ysd);
//                        p.close();
//                        canvas.drawPath(p,fpen);
//                        canvas.drawPath(p,lpen);
        }
        Path pl = Path()
            ..moveTo(xel,yeu)
            ..lineTo(xsl,ysu)
            ..lineTo(xsl,ysd)
            ..lineTo(xel,yed)
            ..close();
        if((stt&mz.stL) != 0) {
            canvas.drawPath(pl,fpen);
        }
        Path pr = Path()
            ..moveTo(xsr,ysu)
            ..lineTo(xer,yeu)
            ..lineTo(xer,yed)
            ..lineTo(xsr,ysd)
            ..close();
        if((stt&mz.stR) != 0) {
            canvas.drawPath(pr,fpen);
        }
        Path pu = Path()
            ..moveTo(xel,yeu)
            ..lineTo(xer,yeu)
            ..lineTo(xsr,ysu)
            ..lineTo(xsl,ysu)
            ..close();
        if((stt&mz.stU) != 0) {
            canvas.drawPath(pu,fpen);
        }
        Path pd = Path()
            ..moveTo(xsl,ysd)
            ..lineTo(xsr,ysd)
            ..lineTo(xer,yed)
            ..lineTo(xel,yed)
            ..close();
        if((stt&mz.stD) != 0) {
            canvas.drawPath(pd,fpen);
        }
                    
        if(stt&mz.stL != 0) {
            canvas.drawPath(pl,lpen);
        }
        if(stt&mz.stR != 0) {
            canvas.drawPath(pr,lpen);
        }
        if(stt&mz.stU != 0) {
            canvas.drawPath(pu,lpen);
        }
        if(stt&mz.stD != 0) {
            canvas.drawPath(pd,lpen);
        }
        if(stt&32 == 0) { // 梯子
            lpen..strokeWidth = 8.0;
            if(mz.vw==0) {
                double xl = xsl*0.85+xsr*0.15;
                canvas.drawLine(Offset(xl,ysu),Offset(xl,ysd), lpen);
                double xr = xsl*0.65+xsr*0.35;
                canvas.drawLine(Offset(xr,ysu),Offset(xr,ysd), lpen);
                double y = ysd*0.8+ysu*0.2;
                canvas.drawLine(Offset(xl,y),Offset(xr,y), lpen);
                y = ysd*0.6+ysu*0.4;
                canvas.drawLine(Offset(xl,y),Offset(xr,y), lpen);
                y = ysd*0.4+ysu*0.6;
                canvas.drawLine(Offset(xl,y),Offset(xr,y), lpen);
                y = ysd*0.2+ysu*0.8;
                canvas.drawLine(Offset(xl,y),Offset(xr,y), lpen);
            } else {
                double xlu = xsl*0.85+xsr*0.15;
                double xru = xsl*0.65+xsr*0.35;
                double xld = xel*0.85+xer*0.15;
                double xrd = xel*0.65+xer*0.35;
                canvas.drawLine(Offset(xlu,ysd),Offset(xld,yed), lpen);
                canvas.drawLine(Offset(xru,ysd),Offset(xrd,yed), lpen);
                double y = ysd*0.8+yed*0.2;
                double xl = xlu*0.8+xld*0.2;
                double xr = xru*0.8+xrd*0.2;
                canvas.drawLine(Offset(xl,y),Offset(xr,y), lpen);
                y = ysd*0.6+yed*0.4;
                xl = xlu*0.6+xld*0.4;
                xr = xru*0.6+xrd*0.4;
                canvas.drawLine(Offset(xl,y),Offset(xr,y), lpen);
                y = ysd*0.4+yed*0.6;
                xl = xlu*0.4+xld*0.6;
                xr = xru*0.4+xrd*0.6;
                canvas.drawLine(Offset(xl,y),Offset(xr,y), lpen);
                y = ysd*0.2+yed*0.8;
                xl = xlu*0.2+xld*0.8;
                xr = xru*0.2+xrd*0.8;
                canvas.drawLine(Offset(xl,y),Offset(xr,y), lpen);
             }
        }
        if(mz.map[iz][iy][ix]>2) {
            if(mz.readyImg) {
                canvas.save();
                canvas.scale(fct);
                if(mz.map[iz][iy][ix]>9) {
                    canvas.drawImage(mz.flag, Offset(xsr/fct-200, ysd/fct-200), fpen);
                    int nm = mz.map[iz][iy][ix]-9;
                    drawStr(canvas, '$nm', (xsr-dls*0.2)/fct, (ysd-dls*0.32)/fct, dls*0.2/fct, Colors.white);
                } else if(mz.map[iz][iy][ix]==3) {
                    canvas.drawImage(mz.bomb, Offset((xsr+xsl)*0.5/fct-100, ysd/fct-180), fpen);
                } else if(mz.map[iz][iy][ix]==4) {
 //                   canvas.drawImage(mz.bomb, Offset((xsr+xsl)*0.5/fct-100, ysd/fct-180), fpen);
                    drawStr(canvas, '♡',(xsr+xsl)*0.5/fct-100, ysd/fct-180, dls*0.5/fct, Colors.cyan);
                }
                canvas.restore();
            }
        }
    }
    
    final double flgcw = 30.0;
    
    @override
    void paint(Canvas canvas, Size size) {
        if(!MazeData.isReady)  return;
        var ww = size.width;
        var hh = size.height;
//        print('$size.width,$size.height');
        Paint lpen = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 8.0
            ..color = Colors.black;
        Paint fpen = Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.white;
        canvas.save();
        canvas.translate(ww*0.5, hh*0.5);
        Rect rct = Rect.fromLTWH(-ww*0.48,-ww*0.48,ww*0.96,ww*0.96);
        canvas.clipRect(rct);
        var xl = ww*1.2;
//        var yl = size.height;
        int nf = 5;
        double fct = 0.6*0.6*0.6*0.6*0.6*0.6;
        var mz = MazeData();
        mz.setMove(mz.dr,mz.vw);
        for(int mvf=5; mvf>=0; mvf--) {
            for(int mvy= 3; mvy>0; mvy--) {
                for(int mvx= 3; mvx>0; mvx--) {
                    drawCube(canvas,mvf,-mvx,-mvy,xl,fct);
                    drawCube(canvas,mvf,mvx,-mvy,xl,fct);
                    drawCube(canvas,mvf,-mvx,mvy,xl,fct);
                    drawCube(canvas,mvf,mvx,mvy,xl,fct);
                }
            }
            for(int mvx= 3; mvx>0; mvx--) {
                drawCube(canvas,mvf,-mvx,0,xl,fct);
                drawCube(canvas,mvf,mvx,0,xl,fct);
                drawCube(canvas,mvf,0,-mvx,xl,fct);
                drawCube(canvas,mvf,0,mvx,xl,fct);
            }
            drawCube(canvas,mvf,0,0,xl,fct);
            fct /= 0.6;
        }
        canvas.restore();
        
//        canvas.scale(21,21);
        if(mz.showMap) { // 地図表示
            double blsz = 20.0;
            if(ww/(mz.mx+2)<blsz) { blsz = ww/(mz.mx+2); }
            if(ww/(mz.my+2)<blsz) { blsz = ww/(mz.my+2); }
            fpen.color = Color(0x44ff0000); // 壁
//        fpen.blendMode = BlendMode.plus;
            canvas.drawRect(Rect.fromLTWH(0,0,blsz*(mz.mx+2),blsz*(mz.my+2)), fpen);
            fpen.color = Color(0x44ffffff); // 通路
            for(int iy=0; iy<mz.my; iy++) {
                for(int ix=0; ix<mz.mx; ix++) {
                    if(mz.map[mz.vm][iy][ix]==2) {
                        canvas.drawRect(Rect.fromLTWH((ix+1)*blsz,(mz.my-iy)*blsz,blsz,blsz), fpen);
                    }
                }
            }
            for(int iy=0; iy<mz.my; iy++) { // フラッグ
                for(int ix=0; ix<mz.mx; ix++) {
                    int ic = mz.map[mz.vm][iy][ix];
                    if(ic>9) {
                        if(mz.type==0) {
                            if(ic-10==mz.nxtflg) {
                                fpen.color = Color(0xffffff00);
                            } else {
                                fpen.color = Color(0xffaaaa00);
                            }
                        } else {
                            fpen.color = Color(0xffffff00);
                        }
                        canvas.drawRect(Rect.fromLTWH((ix+1)*blsz,(mz.my-iy)*blsz,blsz,blsz), fpen);
                    } else if(ic==3) {
                        fpen.color = Color(0xffff0000);
                        canvas.drawRect(Rect.fromLTWH((ix+1)*blsz,(mz.my-iy)*blsz,blsz,blsz), fpen);                        
                    } else if(ic==4) {
                        fpen.color = Color(0xff00ffff);
                        canvas.drawRect(Rect.fromLTWH((ix+1)*blsz,(mz.my-iy)*blsz,blsz,blsz), fpen);                        
                    }
                }
            }
            // 方向表示
            if(mz.vm == mz.pz) {
            fpen.color = Color(0xaa00ff00);
            double p1x=blsz; double p1y=blsz;
            double p2x=blsz; double p2y=0;
            double p3x=0; double p3y=blsz*0.5;
            if(mz.dr==1) {
                p1x=0; p1y=blsz;
                p3x=0; p3y=0;
                p2x=blsz; p2y=blsz*0.5;                
            } else if(mz.dr==2) {
                p1x=0; p1y=0;
                p2x=blsz; p2y=0;
                p3x=blsz*0.5; p3y=blsz;                
            } else if(mz.dr==3) {
                p1x=0; p1y=blsz;
                p2x=blsz; p2y=blsz;
                p3x=blsz*0.5; p3y=0;                                
            }
            p1x += (mz.px+1)*blsz;
            p2x += (mz.px+1)*blsz;
            p3x += (mz.px+1)*blsz;
            p1y += (mz.my-mz.py)*blsz;
            p2y += (mz.my-mz.py)*blsz;
            p3y += (mz.my-mz.py)*blsz;
            Path p = Path()..moveTo(p1x,p1y)..lineTo(p2x,p2y)..lineTo(p3x,p3y)..close();
            canvas.drawPath(p, fpen);
//            canvas.drawRect(Rect.fromLTWH((mz.px+1)*blsz,(mz.my-mz.py)*blsz,blsz,blsz), fpen);
            }
            drawStr(canvas, '${mz.vm+1}F', (mz.mx+2)*blsz*0.5, (mz.my+1)*blsz, blsz, Colors.white);
        }
        
        // 爆破アニメ
        if(mz.mskBomb>0) {
            fpen.color = Color((mz.mskBomb<<24)|0xfff8080);
            rct = Rect.fromLTWH(ww*0.02,hh*0.02,ww*0.96,hh*0.96);
            canvas.drawRect(rct,fpen);
        }
        
        // 進捗インジケータ
        double dx = ww/mz.nflg;
        if(dx>flgcw)  { dx = flgcw; }
        double xs = (ww-dx*mz.nflg)*0.5;
        for(int i=0; i<mz.nflg; i++) {
            double x = (i+0.2)*dx;
            double y = hh-flgcw;
            int nm = i+1;
            fpen.color = SettingData().bg;
            var col = Colors.black;
            if(mz.flgStt(i) == 1) {
                fpen.color = Color(0xffffff00);
                col = Colors.red;
            } else if(mz.flgStt(i) == 2) {
                fpen.color = Color(0xffaaaaaa);
                col = Colors.black;
            }
            canvas.drawRect(Rect.fromLTWH(x+2+xs, y+2, dx-4, flgcw-4),fpen);
            drawStr(canvas, '$nm', x+xs+4, y, flgcw-4, col);
        }
    }
    
    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
