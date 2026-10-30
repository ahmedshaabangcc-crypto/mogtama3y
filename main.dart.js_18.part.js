((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,H,B={
Gn(d){var x,w,v
if(d==null)return null
try{x=A.dU(d)
w=isNaN(x)?null:x
return w}catch(v){return null}},
aFN:function aFN(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.r=_.f=_.e=!1
_.w=null},
aFP:function aFP(d){this.a=d},
aFQ:function aFQ(d){this.a=d},
aFO:function aFO(d){this.a=d},
cr_(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.Fs(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
Fs(d){var x=C.f.a3(d,360)
return x<0?x+360:x},
crk(d,e){var x=B.Fs(d-e)
return x>=180?x-360:x},
cL6(d){var x,w,v,u,t,s=d.length
if(s<2)return 0
for(x=0,w=0,v=0;v<d.length;d.length===s||(0,A.K)(d),++v){u=d[v]*3.141592653589793/180
x+=Math.cos(u)
w+=Math.sin(u)}t=Math.sqrt(x*x+w*w)/d.length
if(t>=1)return 0
if(t<=1e-9)return 180
return Math.sqrt(-2*Math.log(t))*180/3.141592653589793},
aML:function aML(d){this.a=d
this.c=this.b=null},
zR:function zR(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
cBJ(){return new B.x8(null)},
x8:function x8(d){this.a=d},
a0W:function a0W(d,e,f,g,h,i,j){var _=this
_.d=d
_.e=e
_.f=f
_.r=!1
_.w=g
_.x=h
_.y=i
_.as=_.Q=_.z=null
_.CW=_.ch=_.ay=_.ax=_.at=!1
_.cy=_.cx=null
_.db=j
_.c=_.a=null},
bMF:function bMF(d){this.a=d},
bME:function bME(d){this.a=d},
bMA:function bMA(){},
bMB:function bMB(d){this.a=d},
bMz:function bMz(){},
bMu:function bMu(d){this.a=d},
bMv:function bMv(d){this.a=d},
bMw:function bMw(d){this.a=d},
bMx:function bMx(d,e){this.a=d
this.b=e},
bMy:function bMy(d){this.a=d},
bMC:function bMC(d,e){this.a=d
this.b=e},
bMD:function bMD(d){this.a=d},
ZP:function ZP(d,e,f){this.c=d
this.d=e
this.a=f},
apR:function apR(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
avS:function avS(d){this.a=d},
anU:function anU(d,e){this.b=d
this.a=e}},D,I,K,F,L,M,E,G
J=c[1]
A=c[0]
C=c[2]
H=c[15]
B=a.updateHolder(c[5],B)
D=c[30]
I=c[12]
K=c[33]
F=c[32]
L=c[31]
M=c[28]
E=c[16]
G=c[18]
B.aFN.prototype={
k7(){var x=0,w=A.j(y.e),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$k7=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
n=b.G
r=A.ku(n.DeviceOrientationEvent)
if(r==null||r.requestPermission==null){n=A.ku(n.DeviceOrientationEvent)
v=n!=null
x=1
break}x=7
return A.c(A.eH(A.cU(A.cQ(r,"requestPermission",null,null,null,null)),y.w),$async$k7)
case 7:q=e
p=q==="granted"
if(p)s.Od()
v=p
x=1
break
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
A.n(o)
v=!1
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$k7,w)},
al7(){var x,w,v,u,t,s
try{u=b.G
x=A.ku(u.screen)
t=x
w=A.ku(t==null?null:t.orientation)
t=w
v=B.Gn(t==null?null:t.angle)
if(v!=null)return v
u=B.Gn(u.orientation)
if(u==null)u=0
return u}catch(s){return 0}},
aJD(d){var x,w,v,u,t,s,r,q,p,o,n=this,m="deviceorientationabsolute"
if(n.f)return
try{x=B.Gn(d.beta)
w=B.Gn(d.gamma)
v=B.Gn(d.webkitCompassHeading)
if(v!=null){n.w=new A.aP(Date.now(),0,!1)
n.a.E(0,new B.zR(B.Fs(v+n.al7()),B.Gn(d.webkitCompassAccuracy),x,w))
return}u=B.Gn(d.alpha)
if(u==null)return
r=A.q(d.type)
t=r==null?null:r
if(!J.k(t,m)){q=A.en(d.absolute)
if(q==null)q=null
p=q===!0}else p=!0
s=p
if(!s)return
if(J.k(t,m))n.r=!0
else if(n.r)return
n.w=new A.aP(Date.now(),0,!1)
n.a.E(0,new B.zR(B.Fs(360-u+n.al7()),null,x,w))}catch(o){}},
op(){var x,w,v,u=this,t=null,s="addEventListener"
if(u.e||u.f)return
u.e=!0
u.Od()
x=u.c=A.cos(new B.aFP(u))
w=b.G
v=A.ku(w.document)
if(v!=null)A.cQ(v,s,"visibilitychange",x,t,t)
A.cQ(w,s,"pageshow",x,t,t)
u.d=A.he(C.ne,new B.aFQ(u))},
Od(){var x,w,v=this,u=null,t="addEventListener"
if(v.f)return
v.aep()
x=v.b=A.fX(new B.aFO(v))
w=b.G
if("ondeviceorientationabsolute" in w)A.cQ(w,t,"deviceorientationabsolute",x,u,u)
A.cQ(w,t,"deviceorientation",x,u,u)},
aep(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.cQ(x,v,"deviceorientationabsolute",u,w,w)
A.cQ(x,v,"deviceorientation",u,w,w)
this.b=null},
m(){var x,w,v,u=this,t=null,s="removeEventListener"
if(u.f)return
u.f=!0
x=u.d
if(x!=null)x.au()
u.aep()
w=u.c
if(w!=null){x=b.G
v=A.ku(x.document)
if(v!=null)A.cQ(v,s,"visibilitychange",w,t,t)
A.cQ(x,s,"pageshow",w,t,t)}u.a.bA()}}
B.aML.prototype={}
B.zR.prototype={}
B.x8.prototype={
O(){var x=$.ctk().a,w=x[1],v=x[2]
x=x[0]
return new B.a0W(w,v,x+" (\u062a\u0642\u0631\u064a\u0628\u064a)",new B.aFN(new A.lO(null,null,y.o)),new B.aML(0.2),A.a([],y.h),new A.aP(A.kD(0,0,!1),0,!1))}}
B.a0W.prototype={
W(){var x,w,v,u=this
u.Z()
x=A.ku(b.G.DeviceOrientationEvent)
u.ch=x!=null&&x.requestPermission!=null
w=u.w
v=w.a
u.z=new A.fx(v,A.y(v).i("fx<1>")).jt(u.gaYG())
w.op()
u.cx=A.cR(D.ajA,new B.bMF(u))
u.b18()},
m(){var x=this,w=x.cx
if(w!=null)w.au()
w=x.cy
if(w!=null)w.au()
w=x.z
if(w!=null)w.au()
x.w.m()
x.a0()},
aYH(d){var x,w,v,u,t,s,r,q,p,o=this
if(o.c==null)return
x=o.y
w=d.a
x.push(w)
if(x.length>15)C.b.kB(x,0)
v=o.x
w=w*3.141592653589793/180
u=Math.cos(w)
t=Math.sin(w)
w=v.b
if(w==null){v.b=u
v.c=t
v=t
w=u}else{s=v.a
w=v.b=w+(u-w)*s
r=v.c
r.toString
s=v.c=r+(t-r)*s
if(Math.abs(w)<0.000001&&Math.abs(s)<0.000001){v.b=u
v.c=t
v=t
w=u}else v=s}w=B.Fs(Math.atan2(v,w)*180/3.141592653589793)
w.toString
q=Math.abs(B.crk(B.cr_(o.d,o.e),w))<=5
if(q&&!o.CW)A.c9N(80)
v=o.Q
o.Q=w
o.CW=q
o.as=d.b
w=d.c
s=d.d
if(!(w!=null&&Math.abs(w)>35))w=s!=null&&Math.abs(s)>35
else w=!0
o.at=w
o.ax=x.length>=10&&B.cL6(x)>12
o.ay=o.ch=!1
p=new A.aP(Date.now(),0,!1)
if(v==null||p.dD(o.db).a>33e3){o.db=p
x=o.cy
if(x!=null)x.au()
o.cy=null
o.j(new B.bMA())}else if(o.cy==null)o.cy=A.cR(C.FF,new B.bMB(o))},
NQ(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$NQ=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.w
x=3
return A.c(t.k7(),$async$NQ)
case 3:s=e
if(u.c==null){x=1
break}if(s){u.j(new B.bMu(u))
t.op()}else{u.j(new B.bMv(u))
u.c.H(y.q).f.Y(A.aI(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null,null),null,C.w,null,null,null,null,null,null,null,null,null,null))}case 1:return A.h(v,w)}})
return A.i($async$NQ,w)},
BA(d){return this.aWl(d)},
b18(){return this.BA(!1)},
aWl(d){var x=0,w=A.j(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$BA=A.e(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:r.j(new B.bMw(r))
u=4
x=d?7:9
break
case 7:x=10
return A.c(A.jS(!0),$async$BA)
case 10:x=8
break
case 9:x=11
return A.c(A.DT(),$async$BA)
case 11:case 8:q=f
if(r.c==null||q==null){s=[1]
x=5
break}r.j(new B.bMx(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null&&d)o.H(y.q).f.Y(A.aI(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null,null),null,C.w,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.j(new B.bMy(r))
x=s.pop()
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$BA,w)},
Qy(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$Qy=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(I.cqN(s),$async$Qy)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.j(new B.bMC(u,t))
case 1:return A.h(v,w)}})
return A.i($async$Qy,w)},
t(d){var x,w,v,u,t,s,r,q,p=this,o=null,n=B.cr_(p.d,p.e),m=p.Q,l=m==null,k=!l,j=k?B.crk(n,m):0,i=k&&p.CW,h=p.as
if(h!=null)x=h<0||h>25
else x=!1
h=y.u
w=A.a([D.aqX,C.O,A.R(A.d(p.f,o,o,o,o,o,C.bA,o,o,o),1)],h)
if(p.r)w.push(L.uc)
else w.push(A.bP(o,o,o,o,D.avo,o,o,new B.bMD(p),o,o,o,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",o))
w.push(A.b8(D.bvC,o,o,o,p.gb0n(),o,o))
w=A.z(w,C.h,C.d,C.e,0,o,o)
v=l?0:m
v=A.bL(A.am(new B.apR(v,k?j:n,i,o),290,290),o,o)
u=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+(E.bq(C.j.a3(C.f.al(B.Fs(n)),360))+"\xb0")+" \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",o,o,o,o,o,M.a1N,C.Y,o,o)
t=D.aC3[C.j.a3(C.f.aI(B.Fs(n)+22.5,45),8)]
s=p.d
r=p.e
q=Math.pow(Math.sin((21.4225-s)*3.141592653589793/180/2),2)+Math.cos(s*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-r)*3.141592653589793/180/2),2)
t=A.a([new E.dE(w,C.a6,C.aM,o,!1,o),C.H,v,C.a0,u,A.d("\u0646\u0627\u062d\u064a\u0629 "+t+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bq(C.f.al(12742*Math.atan2(Math.sqrt(q),Math.sqrt(1-q))))+" \u0643\u0645",o,o,o,o,o,G.aO,C.Y,o,o)],h)
if(k){w=E.bq(C.j.a3(C.f.al(B.Fs(m)),360))
v=p.as
v=v!=null&&v>=0?" \u2022 \u062f\u0642\u0629 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \xb1"+E.bq(C.f.al(v))+"\xb0":""
t.push(A.d("\u0627\u062a\u062c\u0627\u0647 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u062f\u0644\u0648\u0642\u062a\u064a "+(w+"\xb0")+v,o,o,o,o,o,D.bfk,C.Y,o,o))}t.push(C.a5)
if(p.ch&&l)C.b.A(t,A.a([A.fq(D.atl,D.bnN,p.gaHg(),A.eq(C.u,C.ah,o,o,o,o,o)),C.v],h))
if(k){l=i?"aligned":"turn "+C.f.al(j)
if(i)h="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{h=Math.abs(j)
h=j>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bq(C.f.al(h))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bq(C.f.al(h))+"\xb0"}t.push(A.bE(o,o,o,new E.dE(A.d(h,o,o,o,o,o,A.bB(o,o,i?F.cU:C.i,o,o,o,o,o,o,o,o,16,o,o,C.R,o,o,!0,o,o,o,o,o,o,o,o),C.Y,o,o),C.a6,C.aM,o,i,o),!1,o,o,o,!1,o,!1,o,o,o,o,o,o,o,o,o,o,l,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,C.a_,o))}else if(p.ay&&!p.ch)t.push(D.ano)
else if(!p.ch)t.push(D.abr)
if(k&&p.at)t.push(D.bJc)
if(k)l=x||p.ax
else l=!1
if(l)t.push(D.bJb)
t.push(C.v)
t.push(D.bmm)
return H.xX(o,t,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.ZP.prototype={
t(d){var x=null
return new E.dE(A.z(A.a([A.aX(this.c,C.u,x,22),C.Z,A.R(A.d(this.d,x,x,x,x,x,F.a1P,x,x,x),1)],y.u),C.h,C.d,C.e,0,x,x),C.a6,C.aM,x,!1,x)}}
B.apR.prototype={
t(d){var x,w=null,v=this.e,u=v?F.cU:C.u,t=A.akw(-this.c*3.141592653589793/180,A.ha(w,w,w,new B.avS(w),D.a0W)),s=this.d,r=C.f.al(s)
r=A.bE(w,w,w,A.akw(s*3.141592653589793/180,A.ha(w,w,w,new B.anU(u,w),D.a0W)),!1,w,w,w,!1,w,!1,w,w,w,w,w,w,w,w,w,w,"qibla-arrow "+r,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,C.a_,w)
s=v?u:C.cT
x=A.aK(u,2)
return A.dz(C.P,A.a([t,r,D.aZU,A.E(w,A.aX(C.ft,v?C.ah:C.u,w,w),C.k,w,w,new A.F(s,w,x,w,w,w,w,C.bW),w,54,w,w,w,w,w,54)],y.u),C.m,C.bm,w)}}
B.avS.prototype={
aQ(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=null,i=e.jl(C.A),h=e.gfu()/2-18
$.ap()
x=A.be()
x.r=C.i.aa(0.06).gu()
d.h1(i,h,x)
x=A.be()
x.b=C.bR
x.r=C.ir.gu()
x.c=2
d.h1(i,h,x)
for(x=d.a,w=i.a,v=i.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a3(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=h-(s?14:7)
m=new A.md(C.dA,C.cY,C.fM,C.hq,C.eh)
m.r=(s?C.i:C.eX).gu()
m.c=s?2.5:1.2
l=m.es()
x.drawLine.apply(x,[w+r*h,v+q*h,w+p*n,v+o*n,l])
l.delete()}for(x=D.aTO.gcO(),x=x.ga_(x),r=h-28;x.v();){q=x.gG()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.aeH:C.ao
k=new A.r4(new A.eP(q,j,j,C.bv,j,j,j,j,j,j,new A.r(!0,p,j,j,j,j,16,C.T,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j)),C.t,C.b7,new A.iC(1),j,j,j,j,C.bJ,j)
k.tt()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aQ(d,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gd_()/2))}},
fj(d){return!1}}
B.anU.prototype={
aQ(d,e){var x,w,v,u,t,s=e.jl(C.A),r=e.gfu()/2-18,q=s.a6(0,C.lU.aD(0,r+12)),p=$.ap(),o=A.be(),n=this.b
o.r=n.gu()
x=s.a6(0,C.lU.aD(0,34))
w=s.a6(0,C.lU.aD(0,r-6))
v=A.be()
v.r=n.gu()
v.c=5
v.d=C.ki
d.ln(x,w,v)
u=s.a6(0,C.lU.aD(0,r-14))
t=new A.cT(p.r,C.aE,null,null,A.a([],y.a))
t.aP(new A.h3(q.a,q.b))
t.aP(new A.dD(u.a6(0,C.hl.aD(0,11)).a,u.a6(0,C.hl.aD(0,11)).b))
t.aP(new A.dD(u.ag(0,C.hl.aD(0,11)).a,u.ag(0,C.hl.aD(0,11)).b))
t.aP(new A.nd())
d.hk(t,o)},
fj(d){return!d.b.l(0,this.b)}}
var z=a.updateTypes(["al<~>()","~(zR)"])
B.aFP.prototype={
$0(){var x,w,v=this.a
if(v.f)return
x=A.ku(b.G.document)
w=A.q(x==null?null:x.visibilityState)
if((w==null?null:w)==="visible")v.Od()},
$S:26}
B.aFQ.prototype={
$1(d){var x=this.a,w=x.w
if(w!=null&&new A.aP(Date.now(),0,!1).dD(w).a>3e6){x.w=new A.aP(Date.now(),0,!1)
x.Od()}},
$S:28}
B.aFO.prototype={
$1(d){return this.a.aJD(d)},
$S:6}
B.bMF.prototype={
$0(){var x=this.a
if(x.c!=null&&x.Q==null)x.j(new B.bME(x))},
$S:0}
B.bME.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bMA.prototype={
$0(){},
$S:0}
B.bMB.prototype={
$0(){var x=this.a
x.cy=null
x.db=new A.aP(Date.now(),0,!1)
if(x.c!=null)x.j(new B.bMz())},
$S:0}
B.bMz.prototype={
$0(){},
$S:0}
B.bMu.prototype={
$0(){return this.a.ch=!1},
$S:0}
B.bMv.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bMw.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bMx.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bMy.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bMC.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gn6()},
$S:0}
B.bMD.prototype={
$0(){return this.a.BA(!0)},
$S:0};(function installTearOffs(){var x=a._instance_1u,w=a._instance_0u
var v
x(v=B.a0W.prototype,"gaYG","aYH",1)
w(v,"gaHg","NQ",0)
w(v,"gb0n","Qy",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a6,[B.aFN,B.aML,B.zR])
x(A.ll,[B.aFP,B.bMF,B.bME,B.bMA,B.bMB,B.bMz,B.bMu,B.bMv,B.bMw,B.bMx,B.bMy,B.bMC,B.bMD])
x(A.iN,[B.aFQ,B.aFO])
w(B.x8,A.L)
w(B.a0W,A.N)
x(A.a3,[B.ZP,B.apR])
x(A.Gx,[B.avS,B.anU])})()
A.pv(b.typeUniverse,JSON.parse('{"x8":{"L":[],"l":[]},"a0W":{"N":["x8"]},"ZP":{"a3":[],"l":[]},"apR":{"a3":[],"l":[]},"avS":{"aD":[]},"anU":{"aD":[]}}'))
var y={a:A.ae("H<f6>"),u:A.ae("H<l>"),h:A.ae("H<a2>"),w:A.ae("o"),o:A.ae("lO<zR>"),q:A.ae("ps"),e:A.ae("M"),v:A.ae("~")};(function constants(){var x=a.makeConstList
D.bsy=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.aO,null,null,null,null,null,null,null,null)
D.abr=new A.ci(C.P,null,null,D.bsy,null)
D.aeH=new A.U(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.ajA=new A.bF(3e6)
D.biO=new A.r(!0,C.ao,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bwI=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.biO,null,null,null,null,null,null,null,null)
D.ano=new E.dE(D.bwI,C.a6,C.aM,null,!1,null)
D.aqX=new A.G(K.HX,null,C.u,null,null,null)
D.atl=new A.G(C.HH,null,null,null,null,null)
D.avo=new A.G(C.hc,null,C.ao,null,null,null)
D.aC3=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ae("H<o>"))
D.aTO=new A.d_([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ae("d_<x,o>"))
D.atW=new A.G(C.yr,34,C.i,null,null,null)
D.aZU=new A.qE(null,0,null,null,null,null,D.atW,null)
D.a0W=new A.W(290,290)
D.bfk=new A.r(!0,C.ao,null,null,null,null,13,null,null,null,null,null,1.8,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmm=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633 \u0648\u062c\u0631\u0627\u0628 \u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.aO,C.Y,null,null,null,null,null,null,null)
D.bnN=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.bvC=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.eS,null,null,null,null,null,null,null,null)
D.aoC=new A.Q(62812,"MaterialIcons",null,!1)
D.bJb=new B.ZP(D.aoC,"\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u062d\u062a\u0627\u062c\u0629 \u0645\u0639\u0627\u064a\u0631\u0629: \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0639\u0644\u0649 \u0634\u0643\u0644 8 \u0641\u064a \u0627\u0644\u0647\u0648\u0627 \u0643\u0627\u0645 \u0645\u0631\u0629",null)
D.aqr=new A.Q(985111,"MaterialIcons",null,!1)
D.bJc=new B.ZP(D.aqr,"\u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0641\u0631\u0648\u062f (\u0645\u0633\u0637\u0651\u062d \u0632\u064a \u0627\u0644\u0635\u064a\u0646\u064a\u0629) \u0639\u0634\u0627\u0646 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u064a\u0628\u0642\u0649 \u0645\u0638\u0628\u0648\u0637",null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cT7","ctk",()=>A.ceg())})()};
(a=>{a["x4ZmYsyzk0lThu6ToUw7H3yjQNA="]=a.current})($__dart_deferred_initializers__);