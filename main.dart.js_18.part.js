((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,H,B={
FA(d){var x,w,v
if(d==null)return null
try{x=A.dW(d)
w=isNaN(x)?null:x
return w}catch(v){return null}},
aDw:function aDw(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.r=_.f=_.e=!1
_.w=null},
aDy:function aDy(d){this.a=d},
aDz:function aDz(d){this.a=d},
aDx:function aDx(d){this.a=d},
ckR(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.EH(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
EH(d){var x=C.f.a2(d,360)
return x<0?x+360:x},
clb(d,e){var x=B.EH(d-e)
return x>=180?x-360:x},
cEz(d){var x,w,v,u,t,s=d.length
if(s<2)return 0
for(x=0,w=0,v=0;v<d.length;d.length===s||(0,A.L)(d),++v){u=d[v]*3.141592653589793/180
x+=Math.cos(u)
w+=Math.sin(u)}t=Math.sqrt(x*x+w*w)/d.length
if(t>=1)return 0
if(t<=1e-9)return 180
return Math.sqrt(-2*Math.log(t))*180/3.141592653589793},
aKh:function aKh(d){this.a=d
this.c=this.b=null},
zk:function zk(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
cvh(){return new B.wN(null)},
wN:function wN(d){this.a=d},
a_I:function a_I(d,e,f,g,h,i,j){var _=this
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
bHL:function bHL(d){this.a=d},
bHK:function bHK(d){this.a=d},
bHG:function bHG(){},
bHH:function bHH(d){this.a=d},
bHF:function bHF(){},
bHA:function bHA(d){this.a=d},
bHB:function bHB(d){this.a=d},
bHC:function bHC(d){this.a=d},
bHD:function bHD(d,e){this.a=d
this.b=e},
bHE:function bHE(d){this.a=d},
bHI:function bHI(d,e){this.a=d
this.b=e},
bHJ:function bHJ(d){this.a=d},
YC:function YC(d,e,f){this.c=d
this.d=e
this.a=f},
ao7:function ao7(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
au6:function au6(d){this.a=d},
amb:function amb(d,e){this.b=d
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
B.aDw.prototype={
jZ(){var x=0,w=A.j(y.e),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$jZ=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
n=b.G
r=A.kj(n.DeviceOrientationEvent)
if(r==null||r.requestPermission==null){n=A.kj(n.DeviceOrientationEvent)
v=n!=null
x=1
break}x=7
return A.c(A.eD(A.d1(A.cT(r,"requestPermission",null,null,null,null)),y.w),$async$jZ)
case 7:q=e
p=q==="granted"
if(p)s.NF()
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
return A.i($async$jZ,w)},
ajT(){var x,w,v,u,t,s
try{u=b.G
x=A.kj(u.screen)
t=x
w=A.kj(t==null?null:t.orientation)
t=w
v=B.FA(t==null?null:t.angle)
if(v!=null)return v
u=B.FA(u.orientation)
if(u==null)u=0
return u}catch(s){return 0}},
aHR(d){var x,w,v,u,t,s,r,q,p,o,n=this,m="deviceorientationabsolute"
if(n.f)return
try{x=B.FA(d.beta)
w=B.FA(d.gamma)
v=B.FA(d.webkitCompassHeading)
if(v!=null){n.w=new A.aV(Date.now(),0,!1)
n.a.E(0,new B.zk(B.EH(v+n.ajT()),B.FA(d.webkitCompassAccuracy),x,w))
return}u=B.FA(d.alpha)
if(u==null)return
r=A.u(d.type)
t=r==null?null:r
if(!J.l(t,m)){q=A.ef(d.absolute)
if(q==null)q=null
p=q===!0}else p=!0
s=p
if(!s)return
if(J.l(t,m))n.r=!0
else if(n.r)return
n.w=new A.aV(Date.now(),0,!1)
n.a.E(0,new B.zk(B.EH(360-u+n.ajT()),null,x,w))}catch(o){}},
om(){var x,w,v,u=this,t=null,s="addEventListener"
if(u.e||u.f)return
u.e=!0
u.NF()
x=u.c=A.cin(new B.aDy(u))
w=b.G
v=A.kj(w.document)
if(v!=null)A.cT(v,s,"visibilitychange",x,t,t)
A.cT(w,s,"pageshow",x,t,t)
u.d=A.hD(C.mV,new B.aDz(u))},
NF(){var x,w,v=this,u=null,t="addEventListener"
if(v.f)return
v.adk()
x=v.b=A.fU(new B.aDx(v))
w=b.G
if("ondeviceorientationabsolute" in w)A.cT(w,t,"deviceorientationabsolute",x,u,u)
A.cT(w,t,"deviceorientation",x,u,u)},
adk(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.cT(x,v,"deviceorientationabsolute",u,w,w)
A.cT(x,v,"deviceorientation",u,w,w)
this.b=null},
m(){var x,w,v,u=this,t=null,s="removeEventListener"
if(u.f)return
u.f=!0
x=u.d
if(x!=null)x.az()
u.adk()
w=u.c
if(w!=null){x=b.G
v=A.kj(x.document)
if(v!=null)A.cT(v,s,"visibilitychange",w,t,t)
A.cT(x,s,"pageshow",w,t,t)}u.a.bH()}}
B.aKh.prototype={}
B.zk.prototype={}
B.wN.prototype={
O(){var x=$.cnb().a,w=x[1],v=x[2]
x=x[0]
return new B.a_I(w,v,x+" (\u062a\u0642\u0631\u064a\u0628\u064a)",new B.aDw(new A.lF(null,null,y.o)),new B.aKh(0.2),A.a([],y.h),new A.aV(A.ks(0,0,!1),0,!1))}}
B.a_I.prototype={
W(){var x,w,v,u=this
u.Y()
x=A.kj(b.G.DeviceOrientationEvent)
u.ch=x!=null&&x.requestPermission!=null
w=u.w
v=w.a
u.z=new A.fu(v,A.y(v).i("fu<1>")).jp(u.gaWE())
w.om()
u.cx=A.cO(D.ahZ,new B.bHL(u))
u.aZT()},
m(){var x=this,w=x.cx
if(w!=null)w.az()
w=x.cy
if(w!=null)w.az()
w=x.z
if(w!=null)w.az()
x.w.m()
x.a_()},
aWF(d){var x,w,v,u,t,s,r,q,p,o=this
if(o.c==null)return
x=o.y
w=d.a
x.push(w)
if(x.length>15)C.b.kv(x,0)
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
w=u}else v=s}w=B.EH(Math.atan2(v,w)*180/3.141592653589793)
w.toString
q=Math.abs(B.clb(B.ckR(o.d,o.e),w))<=5
if(q&&!o.CW)A.c3T(80)
v=o.Q
o.Q=w
o.CW=q
o.as=d.b
w=d.c
s=d.d
if(!(w!=null&&Math.abs(w)>35))w=s!=null&&Math.abs(s)>35
else w=!0
o.at=w
o.ax=x.length>=10&&B.cEz(x)>12
o.ay=o.ch=!1
p=new A.aV(Date.now(),0,!1)
if(v==null||p.dK(o.db).a>33e3){o.db=p
x=o.cy
if(x!=null)x.az()
o.cy=null
o.k(new B.bHG())}else if(o.cy==null)o.cy=A.cO(C.EW,new B.bHH(o))},
Ni(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$Ni=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.w
x=3
return A.c(t.jZ(),$async$Ni)
case 3:s=e
if(u.c==null){x=1
break}if(s){u.k(new B.bHA(u))
t.om()}else{u.k(new B.bHB(u))
u.c.I(y.q).f.Z(A.aO(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))}case 1:return A.h(v,w)}})
return A.i($async$Ni,w)},
Bb(d){return this.aUj(d)},
aZT(){return this.Bb(!1)},
aUj(d){var x=0,w=A.j(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$Bb=A.e(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:r.k(new B.bHC(r))
u=4
x=d?7:9
break
case 7:x=10
return A.c(A.kf(!0),$async$Bb)
case 10:x=8
break
case 9:x=11
return A.c(A.Dc(),$async$Bb)
case 11:case 8:q=f
if(r.c==null||q==null){s=[1]
x=5
break}r.k(new B.bHD(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null&&d)o.I(y.q).f.Z(A.aO(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.k(new B.bHE(r))
x=s.pop()
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Bb,w)},
PW(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$PW=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(I.ckG(s),$async$PW)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.k(new B.bHI(u,t))
case 1:return A.h(v,w)}})
return A.i($async$PW,w)},
u(d){var x,w,v,u,t,s,r,q,p=this,o=null,n=B.ckR(p.d,p.e),m=p.Q,l=m==null,k=!l,j=k?B.clb(n,m):0,i=k&&p.CW,h=p.as
if(h!=null)x=h<0||h>25
else x=!1
h=y.u
w=A.a([D.ap8,C.L,A.R(A.d(p.f,o,o,o,o,C.bt,o,o,o),1)],h)
if(p.r)w.push(L.tL)
else w.push(A.bR(o,o,o,o,D.att,o,o,new B.bHJ(p),o,o,o,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",o))
w.push(A.bh(D.brM,o,o,o,p.gaZa(),o,o))
w=A.A(w,C.h,C.d,C.e,0,o,o)
v=l?0:m
v=A.bQ(A.aq(new B.ao7(v,k?j:n,i,o),290,290),o,o)
u=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+(E.bp(C.j.a2(C.f.al(B.EH(n)),360))+"\xb0")+" \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",o,o,o,o,M.a0M,C.a0,o,o)
t=D.azM[C.j.a2(C.f.aH(B.EH(n)+22.5,45),8)]
s=p.d
r=p.e
q=Math.pow(Math.sin((21.4225-s)*3.141592653589793/180/2),2)+Math.cos(s*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-r)*3.141592653589793/180/2),2)
t=A.a([new E.dx(w,C.a3,C.aM,o,!1,o),C.J,v,C.a4,u,A.d("\u0646\u0627\u062d\u064a\u0629 "+t+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bp(C.f.al(12742*Math.atan2(Math.sqrt(q),Math.sqrt(1-q))))+" \u0643\u0645",o,o,o,o,G.aK,C.a0,o,o)],h)
if(k){w=E.bp(C.j.a2(C.f.al(B.EH(m)),360))
v=p.as
v=v!=null&&v>=0?" \u2022 \u062f\u0642\u0629 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \xb1"+E.bp(C.f.al(v))+"\xb0":""
t.push(A.d("\u0627\u062a\u062c\u0627\u0647 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u062f\u0644\u0648\u0642\u062a\u064a "+(w+"\xb0")+v,o,o,o,o,D.bbM,C.a0,o,o))}t.push(C.a5)
if(p.ch&&l)C.b.A(t,A.a([A.fn(D.art,D.bk8,p.gaFx(),A.ey(C.u,C.ac,o,o,o,o,o)),C.t],h))
if(k){l=i?"aligned":"turn "+C.f.al(j)
if(i)h="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{h=Math.abs(j)
h=j>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bp(C.f.al(h))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bp(C.f.al(h))+"\xb0"}t.push(A.bG(o,o,o,new E.dx(A.d(h,o,o,o,o,A.bJ(o,o,i?F.cL:C.i,o,o,o,o,o,o,o,o,16,o,o,C.S,o,o,!0,o,o,o,o,o,o,o,o),C.a0,o,o),C.a3,C.aM,o,i,o),!1,o,o,o,!1,o,!1,o,o,o,o,o,o,o,o,o,o,l,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,C.a_,o))}else if(p.ay&&!p.ch)t.push(D.aly)
else if(!p.ch)t.push(D.aa8)
if(k&&p.at)t.push(D.bEH)
if(k)l=x||p.ax
else l=!1
if(l)t.push(D.bEG)
t.push(C.t)
t.push(D.biL)
return H.xz(o,t,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.YC.prototype={
u(d){var x=null
return new E.dx(A.A(A.a([A.b0(this.c,C.u,x,22),C.Y,A.R(A.d(this.d,x,x,x,x,F.a0Q,x,x,x),1)],y.u),C.h,C.d,C.e,0,x,x),C.a3,C.aM,x,!1,x)}}
B.ao7.prototype={
u(d){var x,w=null,v=this.e,u=v?F.cL:C.u,t=A.aiO(-this.c*3.141592653589793/180,A.h6(w,w,w,new B.au6(w),D.a_V)),s=this.d,r=C.f.al(s)
r=A.bG(w,w,w,A.aiO(s*3.141592653589793/180,A.h6(w,w,w,new B.amb(u,w),D.a_V)),!1,w,w,w,!1,w,!1,w,w,w,w,w,w,w,w,w,w,"qibla-arrow "+r,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,C.a_,w)
s=v?u:C.cK
x=A.aG(u,2)
return A.dz(C.P,A.a([t,r,D.aWO,A.D(w,A.b0(C.fo,v?C.ac:C.u,w,w),C.k,w,w,new A.F(s,w,x,w,w,w,w,C.c_),w,54,w,w,w,w,54)],y.u),C.m,C.bj,w)}}
B.au6.prototype={
aQ(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=null,i=e.jh(C.z),h=e.gfp()/2-18
$.ao()
x=A.bf()
x.r=C.i.ae(0.06).gt()
d.h_(i,h,x)
x=A.bf()
x.b=C.bX
x.r=C.il.gt()
x.c=2
d.h_(i,h,x)
for(x=d.a,w=i.a,v=i.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a2(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=h-(s?14:7)
m=new A.m2(C.ds,C.cP,C.fI,C.hj,C.ea)
m.r=(s?C.i:C.eS).gt()
m.c=s?2.5:1.2
l=m.eQ()
x.drawLine.apply(x,[w+r*h,v+q*h,w+p*n,v+o*n,l])
l.delete()}for(x=D.aR7.gcP(),x=x.ga0(x),r=h-28;x.v();){q=x.gJ()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.adn:C.am
k=new A.qP(new A.f3(q,j,j,C.by,j,j,j,j,j,j,new A.r(!0,p,j,j,j,j,16,C.V,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j)),C.v,C.bh,new A.it(1),j,j,j,j,C.bI,j)
k.td()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aQ(d,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gcW()/2))}},
ff(d){return!1}}
B.amb.prototype={
aQ(d,e){var x,w,v,u,t,s=e.jh(C.z),r=e.gfp()/2-18,q=s.a6(0,C.lD.aD(0,r+12)),p=$.ao(),o=A.bf(),n=this.b
o.r=n.gt()
x=s.a6(0,C.lD.aD(0,34))
w=s.a6(0,C.lD.aD(0,r-6))
v=A.bf()
v.r=n.gt()
v.c=5
v.d=C.k7
d.le(x,w,v)
u=s.a6(0,C.lD.aD(0,r-14))
t=new A.cJ(p.r,C.aD,null,null,A.a([],y.a))
t.aP(new A.h_(q.a,q.b))
t.aP(new A.dn(u.a6(0,C.hf.aD(0,11)).a,u.a6(0,C.hf.aD(0,11)).b))
t.aP(new A.dn(u.ad(0,C.hf.aD(0,11)).a,u.ad(0,C.hf.aD(0,11)).b))
t.aP(new A.n_())
d.hj(t,o)},
ff(d){return!d.b.l(0,this.b)}}
var z=a.updateTypes(["ak<~>()","~(zk)"])
B.aDy.prototype={
$0(){var x,w,v=this.a
if(v.f)return
x=A.kj(b.G.document)
w=A.u(x==null?null:x.visibilityState)
if((w==null?null:w)==="visible")v.NF()},
$S:26}
B.aDz.prototype={
$1(d){var x=this.a,w=x.w
if(w!=null&&new A.aV(Date.now(),0,!1).dK(w).a>3e6){x.w=new A.aV(Date.now(),0,!1)
x.NF()}},
$S:31}
B.aDx.prototype={
$1(d){return this.a.aHR(d)},
$S:6}
B.bHL.prototype={
$0(){var x=this.a
if(x.c!=null&&x.Q==null)x.k(new B.bHK(x))},
$S:0}
B.bHK.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bHG.prototype={
$0(){},
$S:0}
B.bHH.prototype={
$0(){var x=this.a
x.cy=null
x.db=new A.aV(Date.now(),0,!1)
if(x.c!=null)x.k(new B.bHF())},
$S:0}
B.bHF.prototype={
$0(){},
$S:0}
B.bHA.prototype={
$0(){return this.a.ch=!1},
$S:0}
B.bHB.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bHC.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bHD.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bHE.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bHI.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gn1()},
$S:0}
B.bHJ.prototype={
$0(){return this.a.Bb(!0)},
$S:0};(function installTearOffs(){var x=a._instance_1u,w=a._instance_0u
var v
x(v=B.a_I.prototype,"gaWE","aWF",1)
w(v,"gaFx","Ni",0)
w(v,"gaZa","PW",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aDw,B.aKh,B.zk])
x(A.lb,[B.aDy,B.bHL,B.bHK,B.bHG,B.bHH,B.bHF,B.bHA,B.bHB,B.bHC,B.bHD,B.bHE,B.bHI,B.bHJ])
x(A.iC,[B.aDz,B.aDx])
w(B.wN,A.K)
w(B.a_I,A.M)
x(A.a3,[B.YC,B.ao7])
x(A.FK,[B.au6,B.amb])})()
A.pg(b.typeUniverse,JSON.parse('{"wN":{"K":[],"k":[]},"a_I":{"M":["wN"]},"YC":{"a3":[],"k":[]},"ao7":{"a3":[],"k":[]},"au6":{"az":[]},"amb":{"az":[]}}'))
var y={a:A.ae("G<f2>"),u:A.ae("G<k>"),h:A.ae("G<a2>"),w:A.ae("o"),o:A.ae("lF<zk>"),q:A.ae("pd"),e:A.ae("N"),v:A.ae("~")};(function constants(){var x=a.makeConstList
D.boM=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.aK,null,null,null,null,null,null,null,null)
D.aa8=new A.cg(C.P,null,null,D.boM,null)
D.adn=new A.S(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.ahZ=new A.bE(3e6)
D.bfb=new A.r(!0,C.am,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bsO=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.bfb,null,null,null,null,null,null,null,null)
D.aly=new E.dx(D.bsO,C.a3,C.aM,null,!1,null)
D.ap8=new A.H(K.H8,null,C.u,null,null,null)
D.art=new A.H(C.GV,null,null,null,null,null)
D.att=new A.H(C.hJ,null,C.am,null,null,null)
D.azM=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ae("G<o>"))
D.aR7=new A.cX([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ae("cX<x,o>"))
D.as2=new A.H(C.xQ,34,C.i,null,null,null)
D.aWO=new A.qo(null,0,null,null,null,null,D.as2,null)
D.a_V=new A.T(290,290)
D.bbM=new A.r(!0,C.am,null,null,null,null,13,null,null,null,null,null,1.8,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.biL=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633 \u0648\u062c\u0631\u0627\u0628 \u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.aK,C.a0,null,null,null,null,null,null,null)
D.bk8=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.brM=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.eL,null,null,null,null,null,null,null,null)
D.amO=new A.Q(62812,"MaterialIcons",null,!1)
D.bEG=new B.YC(D.amO,"\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u062d\u062a\u0627\u062c\u0629 \u0645\u0639\u0627\u064a\u0631\u0629: \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0639\u0644\u0649 \u0634\u0643\u0644 8 \u0641\u064a \u0627\u0644\u0647\u0648\u0627 \u0643\u0627\u0645 \u0645\u0631\u0629",null)
D.aoF=new A.Q(985111,"MaterialIcons",null,!1)
D.bEH=new B.YC(D.aoF,"\u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0641\u0631\u0648\u062f (\u0645\u0633\u0637\u0651\u062d \u0632\u064a \u0627\u0644\u0635\u064a\u0646\u064a\u0629) \u0639\u0634\u0627\u0646 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u064a\u0628\u0642\u0649 \u0645\u0638\u0628\u0648\u0637",null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cMr","cnb",()=>A.c8g())})()};
(a=>{a["7VmiwMk/twMfKOMrBex1cQtG2/g="]=a.current})($__dart_deferred_initializers__);