((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={a3u:function a3u(){this.a=$
this.b=null},azW:function azW(d){this.a=d},
ciB(){return new B.vn(null)},
vn:function vn(d){this.a=d},
Y0:function Y0(d,e,f){var _=this
_.d=d
_.e=e
_.f="\u0627\u0644\u0642\u0627\u0647\u0631\u0629 (\u062a\u0642\u0631\u064a\u0628\u064a)"
_.r=!1
_.w=f
_.y=_.x=null
_.as=_.Q=_.z=!1
_.c=_.a=_.at=null},
bzW:function bzW(d){this.a=d},
bzV:function bzV(d,e,f){this.a=d
this.b=e
this.c=f},
bzX:function bzX(d){this.a=d},
bzU:function bzU(d){this.a=d},
bzS:function bzS(d){this.a=d},
bzT:function bzT(d){this.a=d},
bzY:function bzY(d){this.a=d},
bzZ:function bzZ(d,e){this.a=d
this.b=e},
bA_:function bA_(d){this.a=d},
bA1:function bA1(){},
bA0:function bA0(d,e){this.a=d
this.b=e},
bA2:function bA2(d,e){this.a=d
this.b=e},
akP:function akP(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
aqE:function aqE(d,e,f){this.b=d
this.c=e
this.a=f},
c8K(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.a1i(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
a1i(d){var x=C.i.a4(d,360)
return x<0?x+360:x},
bYK(d,e){var x=B.a1i(d-e)
return x>180?x-360:x}},D,F,E,G
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[5],B)
D=c[17]
F=c[16]
E=c[9]
G=c[11]
B.a3u.prototype={
jA(){var x=0,w=A.l(y.e),v,u=2,t=[],s,r,q,p,o
var $async$jA=A.h(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
q=b.G
s=A.wV(q.DeviceOrientationEvent)
if(s==null||s.requestPermission==null){q=A.wV(q.DeviceOrientationEvent)
v=q!=null
x=1
break}x=7
return A.c(A.fL(A.kN(s,"requestPermission",null,null,y.h),y.w),$async$jA)
case 7:r=e
v=r==="granted"
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
v=!1
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.j(v,w)
case 2:return A.i(t.at(-1),w)}})
return A.k($async$jA,w)},
agV(){var x,w,v,u,t,s,r
try{t=b.G
x=A.wV(t.screen)
s=x
w=A.wV(s==null?null:s.orientation)
s=w
v=s==null?null:s.angle
if(v!=null){t=A.dR(v)
return t}u=t.orientation
t=u==null?0:A.dR(u)
return t}catch(r){return 0}},
aS8(d){var x,w,v,u,t,s,r,q=this
try{x=d.webkitCompassHeading
if(x!=null){t=q.a
t===$&&A.b()
t.F(0,B.a1i(A.dR(x)+q.agV()))
return}w=d.alpha
if(w==null)return
s=A.v(d.type)
v=s==null?null:s
t=A.eU(d.absolute)
if(t==null)t=null
u=t===!0
if(J.e(v,"deviceorientationabsolute")||u){t=q.a
t===$&&A.b()
t.F(0,B.a1i(360-A.dR(w)+q.agV()))}}catch(r){}},
aEe(){var x,w,v,u="addEventListener"
if(this.b!=null)return
x=this.b=A.hh(new B.azW(this))
w=b.G
v=y.q
A.kN(w,u,"deviceorientationabsolute",x,v)
A.kN(w,u,"deviceorientation",x,v)},
ai1(){var x,w,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
w=y.q
A.kN(x,v,"deviceorientationabsolute",u,w)
A.kN(x,v,"deviceorientation",u,w)
this.b=null}}
B.vn.prototype={
O(){var x=C.b.ga5(F.qb),w=C.b.ga5(F.qb),v=new B.a3u()
v.a=new A.l5(v.gaEd(),v.gaZO(),y.o)
return new B.Y0(x.b,w.c,v)}}
B.Y0.prototype={
X(){var x,w,v=this
v.Y()
x=A.wV(b.G.DeviceOrientationEvent)
w=x!=null&&x.requestPermission!=null
v.Q=w
if(!w)v.aeh()
v.Gt()},
m(){var x=this,w=x.at
if(w!=null)w.aG()
w=x.x
if(w!=null)w.aG()
w=x.w
w.ai1()
w=w.a
w===$&&A.b()
w.bB()
x.a1()},
aeh(){var x=this,w=x.x
if(w!=null)w.aG()
w=x.w.a
w===$&&A.b()
x.x=new A.f3(w,A.x(w).i("f3<1>")).j6(new B.bzW(x))
w=x.at
if(w!=null)w.aG()
x.at=A.cU(D.ae_,new B.bzX(x))},
M_(){var x=0,w=A.l(y.v),v,u=this,t
var $async$M_=A.h(function(d,e){if(d===1)return A.i(e,w)
for(;;)switch(x){case 0:x=3
return A.c(u.w.jA(),$async$M_)
case 3:t=e
if(u.c==null){x=1
break}u.l(new B.bzS(u))
if(t)u.aeh()
else{u.l(new B.bzT(u))
u.c.I(y.r).f.Z(A.aR(null,null,null,null,null,C.l,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))}case 1:return A.j(v,w)}})
return A.k($async$M_,w)},
Gt(){var x=0,w=A.l(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$Gt=A.h(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:r.l(new B.bzY(r))
u=4
x=7
return A.c(A.jL(),$async$Gt)
case 7:q=e
if(r.c==null){s=[1]
x=5
break}r.l(new B.bzZ(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null)o.I(y.r).f.Z(A.aR(null,null,null,null,null,C.l,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.l(new B.bA_(r))
x=s.pop()
break
case 6:case 1:return A.j(v,w)
case 2:return A.i(t.at(-1),w)}})
return A.k($async$Gt,w)},
Oo(){var x=0,w=A.l(y.v),v,u=this,t,s
var $async$Oo=A.h(function(d,e){if(d===1)return A.i(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(A.ex(null,new B.bA1(),s,!1,null,null,y.C),$async$Oo)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.l(new B.bA2(u,t))
case 1:return A.j(v,w)}})
return A.k($async$Oo,w)},
u(d){var x,w,v,u,t,s,r=this,q=null,p=B.c8K(r.d,r.e),o=r.y,n=o!=null,m=n?B.bYK(p,o):0,l=y.u,k=A.a([D.akO,C.K,A.X(A.d(r.f,q,q,q,q,C.cE,q,q,q),1)],l)
if(r.r)k.push(F.YK)
else k.push(A.cf(q,q,q,D.aoA,q,q,r.gaVq(),q,q,q,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",q))
k.push(A.by(D.bhF,q,q,r.gaUO(),q,q))
k=A.D(k,C.h,C.d,C.e,0,q,q)
x=n?-o:0
x=A.bO(A.ap(new B.akP(x,p,r.as&&n,q),290,290),q,q)
w=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+E.dY(C.i.av(p,0))+"\xb0 \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",q,q,q,q,D.b1s,C.a8,q,q)
v=D.auE[C.k.a4(C.i.aY(B.a1i(p)+22.5,45),8)]
u=r.d
t=r.e
s=Math.pow(Math.sin((21.4225-u)*3.141592653589793/180/2),2)+Math.cos(u*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-t)*3.141592653589793/180/2),2)
l=A.a([new E.h7(k,C.ae,C.br,q,!1,q),C.R,x,C.a4,w,A.d("\u0646\u0627\u062d\u064a\u0629 "+v+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.dY(C.i.aC(12742*Math.atan2(Math.sqrt(s),Math.sqrt(1-s))))+" \u0643\u0645",q,q,q,q,G.cF,C.a8,q,q),C.a3],l)
if(r.Q)l.push(A.iD(D.amP,D.baC,r.gaC2(),A.h6(C.A,C.av,q)))
else if(n){k=r.as
if(k)x="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{x=Math.abs(m)
x=m>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.dY(C.i.aC(x))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.dY(C.i.aC(x))+"\xb0"}l.push(new E.h7(A.d(x,q,q,q,q,D.b2P,C.a8,q,q),C.ae,C.br,q,k,q))}else if(r.z)l.push(D.aho)
else l.push(D.a71)
l.push(C.u)
l.push(D.bif)
return E.afE(l,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.akP.prototype={
u(d){var x=null,w=this.e,v=A.b03(this.c*3.141592653589793/180,A.hn(x,x,x,new B.aqE(this.d,w,x),D.aZG)),u=w?C.A:C.ei,t=A.aE(C.A,2)
return A.dk(C.O,A.a([v,D.aQO,A.C(x,A.bo(C.fG,w?C.av:C.A,x,x),C.j,x,x,new A.E(u,x,t,x,x,x,x,C.cd),x,54,x,x,x,x,54)],y.u),C.l,C.bh,x)}}
B.aqE.prototype={
aP(a2,a3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=null,a0=a3.jT(C.x),a1=a3.gfo()/2-18
$.am()
x=A.bj()
x.r=C.f.au(0.06).gt()
a2.iI(a0,a1,x)
x=A.bj()
x.b=C.bZ
x.r=C.uP.gt()
x.c=2
a2.iI(a0,a1,x)
for(x=a2.a,w=a0.a,v=a0.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.k.a4(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=a1-(s?14:7)
m=new A.lq(C.de,C.d3,C.fl,C.fQ,C.dX)
m.r=(s?C.f:C.lZ).gt()
m.c=s?2.5:1.2
l=m.eD()
x.drawLine.apply(x,[w+r*a1,v+q*a1,w+p*n,v+o*n,l])
l.delete()}for(x=D.aLA.gcS(),x=x.ga_(x),r=a1-28;x.v();){q=x.gM()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.aad:C.as
k=new A.pP(new A.eT(q,d,d,C.bw,d,d,d,d,d,d,new A.r(!0,p,d,d,d,d,16,C.W,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d)),C.r,C.bl,new A.i6(1),d,d,d,d,C.bB,d)
k.rD()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aP(a2,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gcM()/2))}t=(this.b-90)*3.141592653589793/180
x=Math.cos(t)
w=Math.sin(t)
j=new A.w(x,w)
i=new A.w(-w,x)
h=a0.a0(0,j.aw(0,a1+12))
g=a0.a0(0,j.aw(0,34))
x=$.am()
f=A.bj()
w=(this.c?C.A:C.A.au(0.9)).gt()
f.r=w
v=a0.a0(0,j.aw(0,a1-6))
r=A.bj()
r.r=A.cw(w).gt()
r.c=5
r.d=C.jv
a2.kV(g,v,r)
e=new A.cD(x.r,C.az,d,d,A.a([],y.a))
e.aN(new A.fE(h.a,h.b))
x=a1-14
e.aN(new A.d4(a0.a0(0,j.aw(0,x)).a0(0,i.aw(0,11)).a,a0.a0(0,j.aw(0,x)).a0(0,i.aw(0,11)).b))
e.aN(new A.d4(a0.a0(0,j.aw(0,x)).ab(0,i.aw(0,11)).a,a0.a0(0,j.aw(0,x)).ab(0,i.aw(0,11)).b))
e.aN(new A.ml())
a2.hh(e,f)},
f7(d){return d.b!==this.b||d.c!==this.c}}
var z=a.updateTypes(["aj<~>()","~()"])
B.azW.prototype={
$1(d){return this.a.aS8(d)},
$S:4}
B.bzW.prototype={
$1(d){var x,w,v,u=this.a
if(u.c==null)return
x=u.y
w=x==null?d:B.a1i(x+B.bYK(d,x)*0.35)
v=Math.abs(B.bYK(B.c8K(u.d,u.e),w))<4
if(v&&!u.as)A.bTU(80)
u.l(new B.bzV(u,w,v))},
$S:103}
B.bzV.prototype={
$0(){var x=this.a
x.y=this.b
x.as=this.c},
$S:0}
B.bzX.prototype={
$0(){var x=this.a
if(x.c!=null)x.l(new B.bzU(x))},
$S:0}
B.bzU.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bzS.prototype={
$0(){return this.a.Q=!1},
$S:0}
B.bzT.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bzY.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bzZ.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bA_.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bA1.prototype={
$1(d){var x,w,v=null,u=A.a([F.GH],y.u)
for(x=0;x<27;++x){w=F.qb[x]
u.push(A.c4(!1,v,v,v,!0,v,v,v,!0,v,v,v,v,v,v,new B.bA0(d,w),!1,v,v,v,v,v,v,A.d(w.a,v,v,v,v,v,v,v,v),v,v,v))}return A.cy(!0,A.ba(u,v,v,v,C.v,!1),C.M,!0)},
$S:32}
B.bA0.prototype={
$0(){A.O(this.a,!1).ar(this.b)
return null},
$S:0}
B.bA2.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.a},
$S:0};(function installTearOffs(){var x=a._instance_0u
var w
x(w=B.a3u.prototype,"gaEd","aEe",1)
x(w,"gaZO","ai1",1)
x(w=B.Y0.prototype,"gaC2","M_",0)
x(w,"gaVq","Gt",0)
x(w,"gaUO","Oo",0)})();(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.a3u,A.a3)
w(A.kA,[B.azW,B.bzW,B.bA1])
x(B.vn,A.K)
x(B.Y0,A.L)
w(A.qu,[B.bzV,B.bzX,B.bzU,B.bzS,B.bzT,B.bzY,B.bzZ,B.bA_,B.bA0,B.bA2])
x(B.akP,A.a5)
x(B.aqE,A.E4)})()
A.JT(b.typeUniverse,JSON.parse('{"vn":{"K":[],"f":[]},"Y0":{"L":["vn"]},"akP":{"a5":[],"f":[]},"aqE":{"aB":[]}}'))
var y=(function rtii(){var x=A.at
return{a:x("F<eR>"),u:x("F<f>"),h:x("bX"),C:x("+(o,a2,a2)"),w:x("o"),o:x("l5<a2>"),r:x("tp"),e:x("U"),q:x("a3?"),v:x("~")}})();(function constants(){var x=a.makeConstList
D.beX=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.cF,null,null,null,null,null,null,null,null)
D.a71=new A.c8(C.O,null,null,D.beX,null)
D.aad=new A.T(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.ae_=new A.bC(3e6)
D.b5V=new A.r(!0,C.as,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.biy=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.b5V,null,null,null,null,null,null,null,null)
D.aho=new E.h7(D.biy,C.ae,C.br,null,!1,null)
D.akO=new A.G(F.Ff,null,C.A,null,null,null)
D.amP=new A.G(C.F1,null,null,null,null,null)
D.aoA=new A.G(C.hi,null,C.as,null,null,null)
D.auE=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.at("F<o>"))
D.aLA=new A.dg([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.at("dg<z,o>"))
D.ank=new A.G(C.EQ,34,C.f,null,null,null)
D.aQO=new A.pr(null,0,null,null,null,null,D.ank,null)
D.aZG=new A.Q(290,290)
D.b1s=new A.r(!0,C.f,null,null,null,null,22,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b2P=new A.r(!0,C.f,null,null,null,null,16,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.baC=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.bhF=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.fR,null,null,null,null,null,null,null,null)
D.bif=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.cF,C.a8,null,null,null,null,null,null,null)})()};
(a=>{a["ySlCSoYaovE09GrVcAGh0D2A2JU="]=a.current})($__dart_deferred_initializers__);