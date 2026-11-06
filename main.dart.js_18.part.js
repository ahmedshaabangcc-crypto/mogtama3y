((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,H,B={
Gw(d){var x,w,v
if(d==null)return null
try{x=A.dV(d)
w=isNaN(x)?null:x
return w}catch(v){return null}},
aG4:function aG4(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.r=_.f=_.e=!1
_.w=null},
aG6:function aG6(d){this.a=d},
aG7:function aG7(d){this.a=d},
aG5:function aG5(d){this.a=d},
csq(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.FB(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
FB(d){var x=C.f.a3(d,360)
return x<0?x+360:x},
csL(d,e){var x=B.FB(d-e)
return x>=180?x-360:x},
cMy(d){var x,w,v,u,t,s=d.length
if(s<2)return 0
for(x=0,w=0,v=0;v<d.length;d.length===s||(0,A.L)(d),++v){u=d[v]*3.141592653589793/180
x+=Math.cos(u)
w+=Math.sin(u)}t=Math.sqrt(x*x+w*w)/d.length
if(t>=1)return 0
if(t<=1e-9)return 180
return Math.sqrt(-2*Math.log(t))*180/3.141592653589793},
aN2:function aN2(d){this.a=d
this.c=this.b=null},
zW:function zW(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
cDb(){return new B.xb(null)},
xb:function xb(d){this.a=d},
a18:function a18(d,e,f,g,h,i,j){var _=this
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
bNL:function bNL(d){this.a=d},
bNK:function bNK(d){this.a=d},
bNG:function bNG(){},
bNH:function bNH(d){this.a=d},
bNF:function bNF(){},
bNA:function bNA(d){this.a=d},
bNB:function bNB(d){this.a=d},
bNC:function bNC(d){this.a=d},
bND:function bND(d,e){this.a=d
this.b=e},
bNE:function bNE(d){this.a=d},
bNI:function bNI(d,e){this.a=d
this.b=e},
bNJ:function bNJ(d){this.a=d},
a_1:function a_1(d,e,f){this.c=d
this.d=e
this.a=f},
aq5:function aq5(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
aw6:function aw6(d){this.a=d},
ao8:function ao8(d,e){this.b=d
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
B.aG4.prototype={
k7(){var x=0,w=A.j(y.e),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$k7=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
n=b.G
r=A.kv(n.DeviceOrientationEvent)
if(r==null||r.requestPermission==null){n=A.kv(n.DeviceOrientationEvent)
v=n!=null
x=1
break}x=7
return A.c(A.eK(A.cW(A.cR(r,"requestPermission",null,null,null,null)),y.w),$async$k7)
case 7:q=e
p=q==="granted"
if(p)s.Op()
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
alp(){var x,w,v,u,t,s
try{u=b.G
x=A.kv(u.screen)
t=x
w=A.kv(t==null?null:t.orientation)
t=w
v=B.Gw(t==null?null:t.angle)
if(v!=null)return v
u=B.Gw(u.orientation)
if(u==null)u=0
return u}catch(s){return 0}},
aJY(d){var x,w,v,u,t,s,r,q,p,o,n=this,m="deviceorientationabsolute"
if(n.f)return
try{x=B.Gw(d.beta)
w=B.Gw(d.gamma)
v=B.Gw(d.webkitCompassHeading)
if(v!=null){n.w=new A.aR(Date.now(),0,!1)
n.a.D(0,new B.zW(B.FB(v+n.alp()),B.Gw(d.webkitCompassAccuracy),x,w))
return}u=B.Gw(d.alpha)
if(u==null)return
r=A.q(d.type)
t=r==null?null:r
if(!J.k(t,m)){q=A.eq(d.absolute)
if(q==null)q=null
p=q===!0}else p=!0
s=p
if(!s)return
if(J.k(t,m))n.r=!0
else if(n.r)return
n.w=new A.aR(Date.now(),0,!1)
n.a.D(0,new B.zW(B.FB(360-u+n.alp()),null,x,w))}catch(o){}},
op(){var x,w,v,u=this,t=null,s="addEventListener"
if(u.e||u.f)return
u.e=!0
u.Op()
x=u.c=A.cpT(new B.aG6(u))
w=b.G
v=A.kv(w.document)
if(v!=null)A.cR(v,s,"visibilitychange",x,t,t)
A.cR(w,s,"pageshow",x,t,t)
u.d=A.hh(C.nm,new B.aG7(u))},
Op(){var x,w,v=this,u=null,t="addEventListener"
if(v.f)return
v.aeH()
x=v.b=A.fY(new B.aG5(v))
w=b.G
if("ondeviceorientationabsolute" in w)A.cR(w,t,"deviceorientationabsolute",x,u,u)
A.cR(w,t,"deviceorientation",x,u,u)},
aeH(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.cR(x,v,"deviceorientationabsolute",u,w,w)
A.cR(x,v,"deviceorientation",u,w,w)
this.b=null},
m(){var x,w,v,u=this,t=null,s="removeEventListener"
if(u.f)return
u.f=!0
x=u.d
if(x!=null)x.av()
u.aeH()
w=u.c
if(w!=null){x=b.G
v=A.kv(x.document)
if(v!=null)A.cR(v,s,"visibilitychange",w,t,t)
A.cR(x,s,"pageshow",w,t,t)}u.a.bA()}}
B.aN2.prototype={}
B.zW.prototype={}
B.xb.prototype={
O(){var x=$.cuL().a,w=x[1],v=x[2]
x=x[0]
return new B.a18(w,v,x+" (\u062a\u0642\u0631\u064a\u0628\u064a)",new B.aG4(new A.lP(null,null,y.o)),new B.aN2(0.2),A.a([],y.h),new A.aR(A.kE(0,0,!1),0,!1))}}
B.a18.prototype={
W(){var x,w,v,u=this
u.Z()
x=A.kv(b.G.DeviceOrientationEvent)
u.ch=x!=null&&x.requestPermission!=null
w=u.w
v=w.a
u.z=new A.fz(v,A.y(v).i("fz<1>")).jt(u.gaZ2())
w.op()
u.cx=A.cS(D.ak7,new B.bNL(u))
u.b1z()},
m(){var x=this,w=x.cx
if(w!=null)w.av()
w=x.cy
if(w!=null)w.av()
w=x.z
if(w!=null)w.av()
x.w.m()
x.a0()},
aZ3(d){var x,w,v,u,t,s,r,q,p,o=this
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
w=u}else v=s}w=B.FB(Math.atan2(v,w)*180/3.141592653589793)
w.toString
q=Math.abs(B.csL(B.csq(o.d,o.e),w))<=5
if(q&&!o.CW)A.cbc(80)
v=o.Q
o.Q=w
o.CW=q
o.as=d.b
w=d.c
s=d.d
if(!(w!=null&&Math.abs(w)>35))w=s!=null&&Math.abs(s)>35
else w=!0
o.at=w
o.ax=x.length>=10&&B.cMy(x)>12
o.ay=o.ch=!1
p=new A.aR(Date.now(),0,!1)
if(v==null||p.dE(o.db).a>33e3){o.db=p
x=o.cy
if(x!=null)x.av()
o.cy=null
o.j(new B.bNG())}else if(o.cy==null)o.cy=A.cS(C.FT,new B.bNH(o))},
NZ(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$NZ=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.w
x=3
return A.c(t.k7(),$async$NZ)
case 3:s=e
if(u.c==null){x=1
break}if(s){u.j(new B.bNA(u))
t.op()}else{u.j(new B.bNB(u))
u.c.H(y.q).f.Y(A.aB(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))}case 1:return A.h(v,w)}})
return A.i($async$NZ,w)},
BD(d){return this.aWH(d)},
b1z(){return this.BD(!1)},
aWH(d){var x=0,w=A.j(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$BD=A.e(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:r.j(new B.bNC(r))
u=4
x=d?7:9
break
case 7:x=10
return A.c(A.jU(!0),$async$BD)
case 10:x=8
break
case 9:x=11
return A.c(A.E1(),$async$BD)
case 11:case 8:q=f
if(r.c==null||q==null){s=[1]
x=5
break}r.j(new B.bND(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null&&d)o.H(y.q).f.Y(A.aB(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.j(new B.bNE(r))
x=s.pop()
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$BD,w)},
QJ(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$QJ=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(I.csd(s),$async$QJ)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.j(new B.bNI(u,t))
case 1:return A.h(v,w)}})
return A.i($async$QJ,w)},
t(d){var x,w,v,u,t,s,r,q,p=this,o=null,n=B.csq(p.d,p.e),m=p.Q,l=m==null,k=!l,j=k?B.csL(n,m):0,i=k&&p.CW,h=p.as
if(h!=null)x=h<0||h>25
else x=!1
h=y.u
w=A.a([D.art,C.O,A.Q(A.d(p.f,o,o,o,o,o,C.bA,o,o,o),1)],h)
if(p.r)w.push(L.um)
else w.push(A.bP(o,o,o,o,D.avX,o,o,new B.bNJ(p),o,o,o,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",o))
w.push(A.b2(D.bzc,o,o,o,p.gb0L(),o,o))
w=A.A(w,C.h,C.d,C.e,0,o,o)
v=l?0:m
v=A.bL(A.am(new B.aq5(v,k?j:n,i,o),290,290),o,o)
u=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+(E.bq(C.j.a3(C.f.al(B.FB(n)),360))+"\xb0")+" \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",o,o,o,o,o,M.a2d,C.Y,o,o)
t=D.aCH[C.j.a3(C.f.aI(B.FB(n)+22.5,45),8)]
s=p.d
r=p.e
q=Math.pow(Math.sin((21.4225-s)*3.141592653589793/180/2),2)+Math.cos(s*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-r)*3.141592653589793/180/2),2)
t=A.a([new E.dG(w,C.a7,C.aM,o,!1,o),C.J,v,C.T,u,A.d("\u0646\u0627\u062d\u064a\u0629 "+t+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bq(C.f.al(12742*Math.atan2(Math.sqrt(q),Math.sqrt(1-q))))+" \u0643\u0645",o,o,o,o,o,G.aP,C.Y,o,o)],h)
if(k){w=E.bq(C.j.a3(C.f.al(B.FB(m)),360))
v=p.as
v=v!=null&&v>=0?" \u2022 \u062f\u0642\u0629 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \xb1"+E.bq(C.f.al(v))+"\xb0":""
t.push(A.d("\u0627\u062a\u062c\u0627\u0647 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u062f\u0644\u0648\u0642\u062a\u064a "+(w+"\xb0")+v,o,o,o,o,o,D.biA,C.Y,o,o))}t.push(C.a5)
if(p.ch&&l)C.b.A(t,A.a([A.fn(D.atU,o,D.brb,p.gaHy(),A.el(C.w,C.ah,o,o,o,o,o)),C.v],h))
if(k){l=i?"aligned":"turn "+C.f.al(j)
if(i)h="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{h=Math.abs(j)
h=j>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bq(C.f.al(h))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bq(C.f.al(h))+"\xb0"}t.push(A.bG(o,o,o,new E.dG(A.d(h,o,o,o,o,o,A.bB(o,o,i?F.cU:C.i,o,o,o,o,o,o,o,o,16,o,o,C.R,o,o,!0,o,o,o,o,o,o,o,o),C.Y,o,o),C.a7,C.aM,o,i,o),!1,o,o,o,!1,o,!1,o,o,o,o,o,o,o,o,o,o,l,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,C.a0,o))}else if(p.ay&&!p.ch)t.push(D.anU)
else if(!p.ch)t.push(D.abU)
if(k&&p.at)t.push(D.bN7)
if(k)l=x||p.ax
else l=!1
if(l)t.push(D.bN6)
t.push(C.v)
t.push(D.bpF)
return H.y_(o,t,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.a_1.prototype={
t(d){var x=null
return new E.dG(A.A(A.a([A.aX(this.c,C.w,x,22),C.a_,A.Q(A.d(this.d,x,x,x,x,x,F.a2f,x,x,x),1)],y.u),C.h,C.d,C.e,0,x,x),C.a7,C.aM,x,!1,x)}}
B.aq5.prototype={
t(d){var x,w=null,v=this.e,u=v?F.cU:C.w,t=A.akL(-this.c*3.141592653589793/180,A.hd(w,w,w,new B.aw6(w),D.a1m)),s=this.d,r=C.f.al(s)
r=A.bG(w,w,w,A.akL(s*3.141592653589793/180,A.hd(w,w,w,new B.ao8(u,w),D.a1m)),!1,w,w,w,!1,w,!1,w,w,w,w,w,w,w,w,w,w,"qibla-arrow "+r,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,C.a0,w)
s=v?u:C.cT
x=A.aK(u,2)
return A.dA(C.P,A.a([t,r,D.b0y,A.E(w,A.aX(C.fu,v?C.ah:C.w,w,w),C.k,w,w,new A.G(s,w,x,w,w,w,w,C.bX),w,54,w,w,w,w,w,54)],y.u),C.m,C.bn,w)}}
B.aw6.prototype={
aR(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=null,i=e.jl(C.A),h=e.gfv()/2-18
$.ap()
x=A.bf()
x.r=C.i.a9(0.06).gu()
d.h1(i,h,x)
x=A.bf()
x.b=C.bS
x.r=C.is.gu()
x.c=2
d.h1(i,h,x)
for(x=d.a,w=i.a,v=i.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a3(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=h-(s?14:7)
m=new A.mf(C.dB,C.cZ,C.fN,C.hs,C.ei)
m.r=(s?C.i:C.eZ).gu()
m.c=s?2.5:1.2
l=m.eu()
x.drawLine.apply(x,[w+r*h,v+q*h,w+p*n,v+o*n,l])
l.delete()}for(x=D.aVq.gcN(),x=x.ga_(x),r=h-28;x.v();){q=x.gG()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.afb:C.ao
k=new A.r9(new A.eT(q,j,j,C.bv,j,j,j,j,j,j,new A.r(!0,p,j,j,j,j,16,C.U,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j)),C.u,C.b8,new A.iE(1),j,j,j,j,C.bJ,j)
k.tu()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aR(d,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gd_()/2))}},
fj(d){return!1}}
B.ao8.prototype={
aR(d,e){var x,w,v,u,t,s=e.jl(C.A),r=e.gfv()/2-18,q=s.a6(0,C.m3.aE(0,r+12)),p=$.ap(),o=A.bf(),n=this.b
o.r=n.gu()
x=s.a6(0,C.m3.aE(0,34))
w=s.a6(0,C.m3.aE(0,r-6))
v=A.bf()
v.r=n.gu()
v.c=5
v.d=C.kq
d.lo(x,w,v)
u=s.a6(0,C.m3.aE(0,r-14))
t=new A.cU(p.r,C.aF,null,null,A.a([],y.a))
t.aP(new A.h5(q.a,q.b))
t.aP(new A.dE(u.a6(0,C.hn.aE(0,11)).a,u.a6(0,C.hn.aE(0,11)).b))
t.aP(new A.dE(u.ag(0,C.hn.aE(0,11)).a,u.ag(0,C.hn.aE(0,11)).b))
t.aP(new A.nh())
d.hk(t,o)},
fj(d){return!d.b.l(0,this.b)}}
var z=a.updateTypes(["al<~>()","~(zW)"])
B.aG6.prototype={
$0(){var x,w,v=this.a
if(v.f)return
x=A.kv(b.G.document)
w=A.q(x==null?null:x.visibilityState)
if((w==null?null:w)==="visible")v.Op()},
$S:25}
B.aG7.prototype={
$1(d){var x=this.a,w=x.w
if(w!=null&&new A.aR(Date.now(),0,!1).dE(w).a>3e6){x.w=new A.aR(Date.now(),0,!1)
x.Op()}},
$S:28}
B.aG5.prototype={
$1(d){return this.a.aJY(d)},
$S:7}
B.bNL.prototype={
$0(){var x=this.a
if(x.c!=null&&x.Q==null)x.j(new B.bNK(x))},
$S:0}
B.bNK.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bNG.prototype={
$0(){},
$S:0}
B.bNH.prototype={
$0(){var x=this.a
x.cy=null
x.db=new A.aR(Date.now(),0,!1)
if(x.c!=null)x.j(new B.bNF())},
$S:0}
B.bNF.prototype={
$0(){},
$S:0}
B.bNA.prototype={
$0(){return this.a.ch=!1},
$S:0}
B.bNB.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bNC.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bND.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bNE.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bNI.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gn7()},
$S:0}
B.bNJ.prototype={
$0(){return this.a.BD(!0)},
$S:0};(function installTearOffs(){var x=a._instance_1u,w=a._instance_0u
var v
x(v=B.a18.prototype,"gaZ2","aZ3",1)
w(v,"gaHy","NZ",0)
w(v,"gb0L","QJ",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a7,[B.aG4,B.aN2,B.zW])
x(A.lm,[B.aG6,B.bNL,B.bNK,B.bNG,B.bNH,B.bNF,B.bNA,B.bNB,B.bNC,B.bND,B.bNE,B.bNI,B.bNJ])
x(A.iP,[B.aG7,B.aG5])
w(B.xb,A.K)
w(B.a18,A.N)
x(A.a3,[B.a_1,B.aq5])
x(A.GG,[B.aw6,B.ao8])})()
A.pz(b.typeUniverse,JSON.parse('{"xb":{"K":[],"l":[]},"a18":{"N":["xb"]},"a_1":{"a3":[],"l":[]},"aq5":{"a3":[],"l":[]},"aw6":{"aI":[]},"ao8":{"aI":[]}}'))
var y={a:A.ag("H<f8>"),u:A.ag("H<l>"),h:A.ag("H<a2>"),w:A.ag("o"),o:A.ag("lP<zW>"),q:A.ag("pw"),e:A.ag("M"),v:A.ag("~")};(function constants(){var x=a.makeConstList
D.bw4=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.aP,null,null,null,null,null,null,null,null)
D.abU=new A.ce(C.P,null,null,D.bw4,null)
D.afb=new A.V(1,1,0.4196078431372549,0.4196078431372549,C.t)
D.ak7=new A.bH(3e6)
D.bm5=new A.r(!0,C.ao,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bAl=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.bm5,null,null,null,null,null,null,null,null)
D.anU=new E.dG(D.bAl,C.a7,C.aM,null,!1,null)
D.art=new A.F(K.Ia,null,C.w,null,null,null)
D.atU=new A.F(C.HV,null,null,null,null,null)
D.avX=new A.F(C.he,null,C.ao,null,null,null)
D.aCH=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ag("H<o>"))
D.aVq=new A.cZ([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ag("cZ<x,o>"))
D.auu=new A.F(C.yD,34,C.i,null,null,null)
D.b0y=new A.qJ(null,0,null,null,null,null,D.auu,null)
D.a1m=new A.X(290,290)
D.biA=new A.r(!0,C.ao,null,null,null,null,13,null,null,null,null,null,1.8,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bpF=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633 \u0648\u062c\u0631\u0627\u0628 \u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.aP,C.Y,null,null,null,null,null,null,null)
D.brb=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.bzc=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.eT,null,null,null,null,null,null,null,null)
D.ap7=new A.R(62812,"MaterialIcons",null,!1)
D.bN6=new B.a_1(D.ap7,"\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u062d\u062a\u0627\u062c\u0629 \u0645\u0639\u0627\u064a\u0631\u0629: \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0639\u0644\u0649 \u0634\u0643\u0644 8 \u0641\u064a \u0627\u0644\u0647\u0648\u0627 \u0643\u0627\u0645 \u0645\u0631\u0629",null)
D.aqY=new A.R(985111,"MaterialIcons",null,!1)
D.bN7=new B.a_1(D.aqY,"\u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0641\u0631\u0648\u062f (\u0645\u0633\u0637\u0651\u062d \u0632\u064a \u0627\u0644\u0635\u064a\u0646\u064a\u0629) \u0639\u0634\u0627\u0646 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u064a\u0628\u0642\u0649 \u0645\u0638\u0628\u0648\u0637",null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cUz","cuL",()=>A.cfG())})()};
(a=>{a["d6ZiSCf9IkjUiuQ+w31sf/zxRyU="]=a.current})($__dart_deferred_initializers__);