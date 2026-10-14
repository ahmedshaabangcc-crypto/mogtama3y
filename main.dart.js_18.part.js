((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,H,B={
Fu(d){var x,w,v
if(d==null)return null
try{x=A.dT(d)
w=isNaN(x)?null:x
return w}catch(v){return null}},
aDp:function aDp(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.r=_.f=_.e=!1
_.w=null},
aDr:function aDr(d){this.a=d},
aDs:function aDs(d){this.a=d},
aDq:function aDq(d){this.a=d},
ckh(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.EA(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
EA(d){var x=C.f.a2(d,360)
return x<0?x+360:x},
ckD(d,e){var x=B.EA(d-e)
return x>=180?x-360:x},
cDY(d){var x,w,v,u,t,s=d.length
if(s<2)return 0
for(x=0,w=0,v=0;v<d.length;d.length===s||(0,A.M)(d),++v){u=d[v]*3.141592653589793/180
x+=Math.cos(u)
w+=Math.sin(u)}t=Math.sqrt(x*x+w*w)/d.length
if(t>=1)return 0
if(t<=1e-9)return 180
return Math.sqrt(-2*Math.log(t))*180/3.141592653589793},
aK8:function aK8(d){this.a=d
this.c=this.b=null},
zd:function zd(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
cuJ(){return new B.wI(null)},
wI:function wI(d){this.a=d},
a_B:function a_B(d,e,f,g,h,i,j){var _=this
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
bHq:function bHq(d){this.a=d},
bHp:function bHp(d){this.a=d},
bHl:function bHl(){},
bHm:function bHm(d){this.a=d},
bHk:function bHk(){},
bHf:function bHf(d){this.a=d},
bHg:function bHg(d){this.a=d},
bHh:function bHh(d){this.a=d},
bHi:function bHi(d,e){this.a=d
this.b=e},
bHj:function bHj(d){this.a=d},
bHn:function bHn(d,e){this.a=d
this.b=e},
bHo:function bHo(d){this.a=d},
Yv:function Yv(d,e,f){this.c=d
this.d=e
this.a=f},
anZ:function anZ(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
atY:function atY(d){this.a=d},
am2:function am2(d,e){this.b=d
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
B.aDp.prototype={
jW(){var x=0,w=A.j(y.e),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$jW=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
n=b.G
r=A.kc(n.DeviceOrientationEvent)
if(r==null||r.requestPermission==null){n=A.kc(n.DeviceOrientationEvent)
v=n!=null
x=1
break}x=7
return A.c(A.eA(A.cZ(A.cQ(r,"requestPermission",null,null,null,null)),y.w),$async$jW)
case 7:q=e
p=q==="granted"
if(p)s.ND()
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
return A.i($async$jW,w)},
ajQ(){var x,w,v,u,t,s
try{u=b.G
x=A.kc(u.screen)
t=x
w=A.kc(t==null?null:t.orientation)
t=w
v=B.Fu(t==null?null:t.angle)
if(v!=null)return v
u=B.Fu(u.orientation)
if(u==null)u=0
return u}catch(s){return 0}},
aHO(d){var x,w,v,u,t,s,r,q,p,o,n=this,m="deviceorientationabsolute"
if(n.f)return
try{x=B.Fu(d.beta)
w=B.Fu(d.gamma)
v=B.Fu(d.webkitCompassHeading)
if(v!=null){n.w=new A.aW(Date.now(),0,!1)
n.a.E(0,new B.zd(B.EA(v+n.ajQ()),B.Fu(d.webkitCompassAccuracy),x,w))
return}u=B.Fu(d.alpha)
if(u==null)return
r=A.u(d.type)
t=r==null?null:r
if(!J.l(t,m)){q=A.ec(d.absolute)
if(q==null)q=null
p=q===!0}else p=!0
s=p
if(!s)return
if(J.l(t,m))n.r=!0
else if(n.r)return
n.w=new A.aW(Date.now(),0,!1)
n.a.E(0,new B.zd(B.EA(360-u+n.ajQ()),null,x,w))}catch(o){}},
ol(){var x,w,v,u=this,t=null,s="addEventListener"
if(u.e||u.f)return
u.e=!0
u.ND()
x=u.c=A.chQ(new B.aDr(u))
w=b.G
v=A.kc(w.document)
if(v!=null)A.cQ(v,s,"visibilitychange",x,t,t)
A.cQ(w,s,"pageshow",x,t,t)
u.d=A.hx(C.mV,new B.aDs(u))},
ND(){var x,w,v=this,u=null,t="addEventListener"
if(v.f)return
v.adf()
x=v.b=A.fP(new B.aDq(v))
w=b.G
if("ondeviceorientationabsolute" in w)A.cQ(w,t,"deviceorientationabsolute",x,u,u)
A.cQ(w,t,"deviceorientation",x,u,u)},
adf(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.cQ(x,v,"deviceorientationabsolute",u,w,w)
A.cQ(x,v,"deviceorientation",u,w,w)
this.b=null},
m(){var x,w,v,u=this,t=null,s="removeEventListener"
if(u.f)return
u.f=!0
x=u.d
if(x!=null)x.az()
u.adf()
w=u.c
if(w!=null){x=b.G
v=A.kc(x.document)
if(v!=null)A.cQ(v,s,"visibilitychange",w,t,t)
A.cQ(x,s,"pageshow",w,t,t)}u.a.bH()}}
B.aK8.prototype={}
B.zd.prototype={}
B.wI.prototype={
O(){var x=$.cmD().a,w=x[1],v=x[2]
x=x[0]
return new B.a_B(w,v,x+" (\u062a\u0642\u0631\u064a\u0628\u064a)",new B.aDp(new A.lz(null,null,y.o)),new B.aK8(0.2),A.a([],y.h),new A.aW(A.kl(0,0,!1),0,!1))}}
B.a_B.prototype={
W(){var x,w,v,u=this
u.Y()
x=A.kc(b.G.DeviceOrientationEvent)
u.ch=x!=null&&x.requestPermission!=null
w=u.w
v=w.a
u.z=new A.fq(v,A.y(v).i("fq<1>")).jo(u.gaWB())
w.ol()
u.cx=A.cL(D.ai5,new B.bHq(u))
u.aZQ()},
m(){var x=this,w=x.cx
if(w!=null)w.az()
w=x.cy
if(w!=null)w.az()
w=x.z
if(w!=null)w.az()
x.w.m()
x.a_()},
aWC(d){var x,w,v,u,t,s,r,q,p,o=this
if(o.c==null)return
x=o.y
w=d.a
x.push(w)
if(x.length>15)C.b.ku(x,0)
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
w=u}else v=s}w=B.EA(Math.atan2(v,w)*180/3.141592653589793)
w.toString
q=Math.abs(B.ckD(B.ckh(o.d,o.e),w))<=5
if(q&&!o.CW)A.c3p(80)
v=o.Q
o.Q=w
o.CW=q
o.as=d.b
w=d.c
s=d.d
if(!(w!=null&&Math.abs(w)>35))w=s!=null&&Math.abs(s)>35
else w=!0
o.at=w
o.ax=x.length>=10&&B.cDY(x)>12
o.ay=o.ch=!1
p=new A.aW(Date.now(),0,!1)
if(v==null||p.dL(o.db).a>33e3){o.db=p
x=o.cy
if(x!=null)x.az()
o.cy=null
o.k(new B.bHl())}else if(o.cy==null)o.cy=A.cL(C.EU,new B.bHm(o))},
Ng(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$Ng=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.w
x=3
return A.c(t.jW(),$async$Ng)
case 3:s=e
if(u.c==null){x=1
break}if(s){u.k(new B.bHf(u))
t.ol()}else{u.k(new B.bHg(u))
u.c.I(y.q).f.Z(A.aN(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))}case 1:return A.h(v,w)}})
return A.i($async$Ng,w)},
B9(d){return this.aUg(d)},
aZQ(){return this.B9(!1)},
aUg(d){var x=0,w=A.j(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$B9=A.e(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:r.k(new B.bHh(r))
u=4
x=d?7:9
break
case 7:x=10
return A.c(A.k8(!0),$async$B9)
case 10:x=8
break
case 9:x=11
return A.c(A.D4(),$async$B9)
case 11:case 8:q=f
if(r.c==null||q==null){s=[1]
x=5
break}r.k(new B.bHi(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null&&d)o.I(y.q).f.Z(A.aN(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.k(new B.bHj(r))
x=s.pop()
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$B9,w)},
PT(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$PT=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(I.ck6(s),$async$PT)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.k(new B.bHn(u,t))
case 1:return A.h(v,w)}})
return A.i($async$PT,w)},
u(d){var x,w,v,u,t,s,r,q,p=this,o=null,n=B.ckh(p.d,p.e),m=p.Q,l=m==null,k=!l,j=k?B.ckD(n,m):0,i=k&&p.CW,h=p.as
if(h!=null)x=h<0||h>25
else x=!1
h=y.u
w=A.a([D.apg,C.L,A.R(A.d(p.f,o,o,o,o,C.bt,o,o,o),1)],h)
if(p.r)w.push(L.tK)
else w.push(A.bR(o,o,o,o,D.atC,o,o,new B.bHo(p),o,o,o,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",o))
w.push(A.bh(D.brQ,o,o,o,p.gaZ7(),o,o))
w=A.A(w,C.i,C.d,C.e,0,o,o)
v=l?0:m
v=A.bQ(A.aq(new B.anZ(v,k?j:n,i,o),290,290),o,o)
u=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+(E.bp(C.j.a2(C.f.am(B.EA(n)),360))+"\xb0")+" \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",o,o,o,o,M.a0V,C.a0,o,o)
t=D.azX[C.j.a2(C.f.aH(B.EA(n)+22.5,45),8)]
s=p.d
r=p.e
q=Math.pow(Math.sin((21.4225-s)*3.141592653589793/180/2),2)+Math.cos(s*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-r)*3.141592653589793/180/2),2)
t=A.a([new E.du(w,C.a5,C.aM,o,!1,o),C.J,v,C.a3,u,A.d("\u0646\u0627\u062d\u064a\u0629 "+t+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bp(C.f.am(12742*Math.atan2(Math.sqrt(q),Math.sqrt(1-q))))+" \u0643\u0645",o,o,o,o,G.aK,C.a0,o,o)],h)
if(k){w=E.bp(C.j.a2(C.f.am(B.EA(m)),360))
v=p.as
v=v!=null&&v>=0?" \u2022 \u062f\u0642\u0629 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \xb1"+E.bp(C.f.am(v))+"\xb0":""
t.push(A.d("\u0627\u062a\u062c\u0627\u0647 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u062f\u0644\u0648\u0642\u062a\u064a "+(w+"\xb0")+v,o,o,o,o,D.bbO,C.a0,o,o))}t.push(C.a4)
if(p.ch&&l)C.b.A(t,A.a([A.fj(D.arB,D.bka,p.gaFu(),A.ev(C.v,C.ac,o,o,o,o,o)),C.t],h))
if(k){l=i?"aligned":"turn "+C.f.am(j)
if(i)h="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{h=Math.abs(j)
h=j>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bp(C.f.am(h))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bp(C.f.am(h))+"\xb0"}t.push(A.bG(o,o,o,new E.du(A.d(h,o,o,o,o,A.bK(o,o,i?F.cL:C.h,o,o,o,o,o,o,o,o,16,o,o,C.S,o,o,!0,o,o,o,o,o,o,o,o),C.a0,o,o),C.a5,C.aM,o,i,o),!1,o,o,o,!1,o,!1,o,o,o,o,o,o,o,o,o,o,l,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,C.a_,o))}else if(p.ay&&!p.ch)t.push(D.alG)
else if(!p.ch)t.push(D.aah)
if(k&&p.at)t.push(D.bEJ)
if(k)l=x||p.ax
else l=!1
if(l)t.push(D.bEI)
t.push(C.t)
t.push(D.biM)
return H.xu(o,t,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.Yv.prototype={
u(d){var x=null
return new E.du(A.A(A.a([A.b0(this.c,C.v,x,22),C.Y,A.R(A.d(this.d,x,x,x,x,F.a0Z,x,x,x),1)],y.u),C.i,C.d,C.e,0,x,x),C.a5,C.aM,x,!1,x)}}
B.anZ.prototype={
u(d){var x,w=null,v=this.e,u=v?F.cL:C.v,t=A.aiG(-this.c*3.141592653589793/180,A.h1(w,w,w,new B.atY(w),D.a03)),s=this.d,r=C.f.am(s)
r=A.bG(w,w,w,A.aiG(s*3.141592653589793/180,A.h1(w,w,w,new B.am2(u,w),D.a03)),!1,w,w,w,!1,w,!1,w,w,w,w,w,w,w,w,w,w,"qibla-arrow "+r,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,C.a_,w)
s=v?u:C.cK
x=A.aG(u,2)
return A.dw(C.P,A.a([t,r,D.aWW,A.D(w,A.b0(C.fn,v?C.ac:C.v,w,w),C.k,w,w,new A.F(s,w,x,w,w,w,w,C.c_),w,54,w,w,w,w,54)],y.u),C.m,C.bj,w)}}
B.atY.prototype={
aP(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=null,i=e.jg(C.z),h=e.gfp()/2-18
$.ao()
x=A.bf()
x.r=C.h.ae(0.06).gt()
d.fZ(i,h,x)
x=A.bf()
x.b=C.bX
x.r=C.il.gt()
x.c=2
d.fZ(i,h,x)
for(x=d.a,w=i.a,v=i.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a2(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=h-(s?14:7)
m=new A.lV(C.ds,C.cP,C.fH,C.hj,C.ea)
m.r=(s?C.h:C.eR).gt()
m.c=s?2.5:1.2
l=m.eQ()
x.drawLine.apply(x,[w+r*h,v+q*h,w+p*n,v+o*n,l])
l.delete()}for(x=D.aRg.gcQ(),x=x.ga0(x),r=h-28;x.v();){q=x.gJ()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.adw:C.am
k=new A.qJ(new A.f0(q,j,j,C.by,j,j,j,j,j,j,new A.r(!0,p,j,j,j,j,16,C.V,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j)),C.u,C.bh,new A.io(1),j,j,j,j,C.bH,j)
k.td()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aP(d,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gcX()/2))}},
ff(d){return!1}}
B.am2.prototype={
aP(d,e){var x,w,v,u,t,s=e.jg(C.z),r=e.gfp()/2-18,q=s.a6(0,C.lD.aD(0,r+12)),p=$.ao(),o=A.bf(),n=this.b
o.r=n.gt()
x=s.a6(0,C.lD.aD(0,34))
w=s.a6(0,C.lD.aD(0,r-6))
v=A.bf()
v.r=n.gt()
v.c=5
v.d=C.k7
d.le(x,w,v)
u=s.a6(0,C.lD.aD(0,r-14))
t=new A.cH(p.r,C.aD,null,null,A.a([],y.a))
t.aO(new A.fV(q.a,q.b))
t.aO(new A.dk(u.a6(0,C.hf.aD(0,11)).a,u.a6(0,C.hf.aD(0,11)).b))
t.aO(new A.dk(u.ad(0,C.hf.aD(0,11)).a,u.ad(0,C.hf.aD(0,11)).b))
t.aO(new A.mT())
d.hj(t,o)},
ff(d){return!d.b.l(0,this.b)}}
var z=a.updateTypes(["ak<~>()","~(zd)"])
B.aDr.prototype={
$0(){var x,w,v=this.a
if(v.f)return
x=A.kc(b.G.document)
w=A.u(x==null?null:x.visibilityState)
if((w==null?null:w)==="visible")v.ND()},
$S:26}
B.aDs.prototype={
$1(d){var x=this.a,w=x.w
if(w!=null&&new A.aW(Date.now(),0,!1).dL(w).a>3e6){x.w=new A.aW(Date.now(),0,!1)
x.ND()}},
$S:31}
B.aDq.prototype={
$1(d){return this.a.aHO(d)},
$S:6}
B.bHq.prototype={
$0(){var x=this.a
if(x.c!=null&&x.Q==null)x.k(new B.bHp(x))},
$S:0}
B.bHp.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bHl.prototype={
$0(){},
$S:0}
B.bHm.prototype={
$0(){var x=this.a
x.cy=null
x.db=new A.aW(Date.now(),0,!1)
if(x.c!=null)x.k(new B.bHk())},
$S:0}
B.bHk.prototype={
$0(){},
$S:0}
B.bHf.prototype={
$0(){return this.a.ch=!1},
$S:0}
B.bHg.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bHh.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bHi.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bHj.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bHn.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gn0()},
$S:0}
B.bHo.prototype={
$0(){return this.a.B9(!0)},
$S:0};(function installTearOffs(){var x=a._instance_1u,w=a._instance_0u
var v
x(v=B.a_B.prototype,"gaWB","aWC",1)
w(v,"gaFu","Ng",0)
w(v,"gaZ7","PT",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aDp,B.aK8,B.zd])
x(A.l3,[B.aDr,B.bHq,B.bHp,B.bHl,B.bHm,B.bHk,B.bHf,B.bHg,B.bHh,B.bHi,B.bHj,B.bHn,B.bHo])
x(A.iw,[B.aDs,B.aDq])
w(B.wI,A.K)
w(B.a_B,A.L)
x(A.a3,[B.Yv,B.anZ])
x(A.FE,[B.atY,B.am2])})()
A.pa(b.typeUniverse,JSON.parse('{"wI":{"K":[],"k":[]},"a_B":{"L":["wI"]},"Yv":{"a3":[],"k":[]},"anZ":{"a3":[],"k":[]},"atY":{"az":[]},"am2":{"az":[]}}'))
var y={a:A.ae("E<f_>"),u:A.ae("E<k>"),h:A.ae("E<a2>"),w:A.ae("o"),o:A.ae("lz<zd>"),q:A.ae("p7"),e:A.ae("N"),v:A.ae("~")};(function constants(){var x=a.makeConstList
D.boP=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.aK,null,null,null,null,null,null,null,null)
D.aah=new A.cf(C.P,null,null,D.boP,null)
D.adw=new A.S(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.ai5=new A.bE(3e6)
D.bfc=new A.r(!0,C.am,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bsS=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.bfc,null,null,null,null,null,null,null,null)
D.alG=new E.du(D.bsS,C.a5,C.aM,null,!1,null)
D.apg=new A.G(K.H4,null,C.v,null,null,null)
D.arB=new A.G(C.GR,null,null,null,null,null)
D.atC=new A.G(C.hJ,null,C.am,null,null,null)
D.azX=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ae("E<o>"))
D.aRg=new A.cU([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ae("cU<x,o>"))
D.asb=new A.G(C.xO,34,C.h,null,null,null)
D.aWW=new A.qi(null,0,null,null,null,null,D.asb,null)
D.a03=new A.T(290,290)
D.bbO=new A.r(!0,C.am,null,null,null,null,13,null,null,null,null,null,1.8,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.biM=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633 \u0648\u062c\u0631\u0627\u0628 \u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.aK,C.a0,null,null,null,null,null,null,null)
D.bka=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.brQ=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.eK,null,null,null,null,null,null,null,null)
D.amX=new A.Q(62812,"MaterialIcons",null,!1)
D.bEI=new B.Yv(D.amX,"\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u062d\u062a\u0627\u062c\u0629 \u0645\u0639\u0627\u064a\u0631\u0629: \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0639\u0644\u0649 \u0634\u0643\u0644 8 \u0641\u064a \u0627\u0644\u0647\u0648\u0627 \u0643\u0627\u0645 \u0645\u0631\u0629",null)
D.aoO=new A.Q(985111,"MaterialIcons",null,!1)
D.bEJ=new B.Yv(D.aoO,"\u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0641\u0631\u0648\u062f (\u0645\u0633\u0637\u0651\u062d \u0632\u064a \u0627\u0644\u0635\u064a\u0646\u064a\u0629) \u0639\u0634\u0627\u0646 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u064a\u0628\u0642\u0649 \u0645\u0638\u0628\u0648\u0637",null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cLP","cmD",()=>A.c7N())})()};
(a=>{a["KCrIrRbKCvcnOJ6ULr06ce6IrSY="]=a.current})($__dart_deferred_initializers__);