((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,G,B={a5c:function a5c(){this.a=$
this.b=null},aBY:function aBY(d){this.a=d},
crA(){return new B.wk(null)},
wk:function wk(d){this.a=d},
ZC:function ZC(d,e,f,g){var _=this
_.d=d
_.e=e
_.f=f
_.r=!1
_.w=g
_.y=_.x=null
_.as=_.Q=_.z=!1
_.c=_.a=_.at=null},
bF5:function bF5(d){this.a=d},
bF4:function bF4(d,e,f){this.a=d
this.b=e
this.c=f},
bF6:function bF6(d){this.a=d},
bF3:function bF3(d){this.a=d},
bF1:function bF1(d){this.a=d},
bF2:function bF2(d){this.a=d},
bF7:function bF7(d){this.a=d},
bF8:function bF8(d,e){this.a=d
this.b=e},
bF9:function bF9(d){this.a=d},
bFa:function bFa(d,e){this.a=d
this.b=e},
amJ:function amJ(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
asE:function asE(d,e,f){this.b=d
this.c=e
this.a=f},
che(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.a2Z(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
a2Z(d){var x=C.f.a0(d,360)
return x<0?x+360:x},
c5Q(d,e){var x=B.a2Z(d-e)
return x>180?x-360:x}},D,H,I,K,L,E,F
J=c[1]
A=c[0]
C=c[2]
G=c[14]
B=a.updateHolder(c[5],B)
D=c[30]
H=c[12]
I=c[32]
K=c[31]
L=c[28]
E=c[15]
F=c[17]
B.a5c.prototype={
jI(){var x=0,w=A.k(y.e),v,u=2,t=[],s,r,q,p,o
var $async$jI=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
q=b.G
s=A.my(q.DeviceOrientationEvent)
if(s==null||s.requestPermission==null){q=A.my(q.DeviceOrientationEvent)
v=q!=null
x=1
break}x=7
return A.c(A.eF(A.cU(A.d0(s,"requestPermission",null,null,null,null)),y.w),$async$jI)
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
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$jI,w)},
aiz(){var x,w,v,u,t,s,r
try{t=b.G
x=A.my(t.screen)
s=x
w=A.my(s==null?null:s.orientation)
s=w
v=s==null?null:s.angle
if(v!=null){t=A.dI(v)
return t}u=t.orientation
t=u==null?0:A.dI(u)
return t}catch(r){return 0}},
aUH(d){var x,w,v,u,t,s,r,q=this
try{x=d.webkitCompassHeading
if(x!=null){t=q.a
t===$&&A.b()
t.F(0,B.a2Z(A.dI(x)+q.aiz()))
return}w=d.alpha
if(w==null)return
s=A.u(d.type)
v=s==null?null:s
t=A.em(d.absolute)
if(t==null)t=null
u=t===!0
if(J.e(v,"deviceorientationabsolute")||u){t=q.a
t===$&&A.b()
t.F(0,B.a2Z(360-A.dI(w)+q.aiz()))}}catch(r){}},
aGl(){var x,w,v=null,u="addEventListener"
if(this.b!=null)return
x=this.b=A.fN(new B.aBY(this))
w=b.G
A.d0(w,u,"deviceorientationabsolute",x,v,v)
A.d0(w,u,"deviceorientation",x,v,v)},
ajF(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.d0(x,v,"deviceorientationabsolute",u,w,w)
A.d0(x,v,"deviceorientation",u,w,w)
this.b=null}}
B.wk.prototype={
P(){var x,w=$.cjw().a,v=w[1],u=w[2]
w=w[0]
x=new B.a5c()
x.a=new A.lr(x.gaGk(),x.gb1M(),y.o)
return new B.ZC(v,u,w+" (\u062a\u0642\u0631\u064a\u0628\u064a)",x)}}
B.ZC.prototype={
X(){var x,w,v=this
v.Y()
x=A.my(b.G.DeviceOrientationEvent)
w=x!=null&&x.requestPermission!=null
v.Q=w
if(!w)v.ahu()
v.H9()},
m(){var x=this,w=x.at
if(w!=null)w.aD()
w=x.x
if(w!=null)w.aD()
w=x.w
w.ajF()
w=w.a
w===$&&A.b()
w.bC()
x.a1()},
ahu(){var x=this,w=x.x
if(w!=null)w.aD()
w=x.w.a
w===$&&A.b()
x.x=new A.fj(w,A.y(w).i("fj<1>")).jd(new B.bF5(x))
w=x.at
if(w!=null)w.aD()
x.at=A.cS(D.agT,new B.bF6(x))},
MN(){var x=0,w=A.k(y.v),v,u=this,t
var $async$MN=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:x=3
return A.c(u.w.jI(),$async$MN)
case 3:t=e
if(u.c==null){x=1
break}u.k(new B.bF1(u))
if(t)u.ahu()
else{u.k(new B.bF2(u))
u.c.I(y.q).f.Z(A.aT(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))}case 1:return A.i(v,w)}})
return A.j($async$MN,w)},
H9(){var x=0,w=A.k(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$H9=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:r.k(new B.bF7(r))
u=4
x=7
return A.c(A.k1(),$async$H9)
case 7:q=e
if(r.c==null){s=[1]
x=5
break}r.k(new B.bF8(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null)o.I(y.q).f.Z(A.aT(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.k(new B.bF9(r))
x=s.pop()
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$H9,w)},
Pk(){var x=0,w=A.k(y.v),v,u=this,t,s
var $async$Pk=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(H.ch3(s),$async$Pk)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.k(new B.bFa(u,t))
case 1:return A.i(v,w)}})
return A.j($async$Pk,w)},
t(d){var x,w,v,u,t,s,r=this,q=null,p=B.che(r.d,r.e),o=r.y,n=o!=null,m=n?B.c5Q(p,o):0,l=y.u,k=A.a([D.ao_,C.K,A.R(A.d(r.f,q,q,q,q,C.bz,q,q,q),1)],l)
if(r.r)k.push(K.tw)
else k.push(A.bT(q,q,q,q,D.asd,q,q,r.gaY8(),q,q,q,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",q))
k.push(A.be(D.bqa,q,q,r.gaXu(),q,q))
k=A.A(k,C.h,C.d,C.e,0,q,q)
x=n?-o:0
x=A.bO(A.ao(new B.amJ(x,p,r.as&&n,q),290,290),q,q)
w=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+E.br(C.f.am(p,0))+"\xb0 \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",q,q,q,q,L.a0h,C.Z,q,q)
v=D.ayA[C.j.a0(C.f.aJ(B.a2Z(p)+22.5,45),8)]
u=r.d
t=r.e
s=Math.pow(Math.sin((21.4225-u)*3.141592653589793/180/2),2)+Math.cos(u*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-t)*3.141592653589793/180/2),2)
l=A.a([new E.dA(k,C.a4,C.aN,q,!1,q),C.I,x,C.a0,w,A.d("\u0646\u0627\u062d\u064a\u0629 "+v+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.br(C.f.aw(12742*Math.atan2(Math.sqrt(s),Math.sqrt(1-s))))+" \u0643\u0645",q,q,q,q,F.aJ,C.Z,q,q),C.a1],l)
if(r.Q)l.push(A.fs(D.aqf,D.biA,r.gaE9(),A.eA(C.v,C.af,q,q,q)))
else if(n){k=r.as
if(k)x="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{x=Math.abs(m)
x=m>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.br(C.f.aw(x))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.br(C.f.aw(x))+"\xb0"}l.push(new E.dA(A.d(x,q,q,q,q,D.bax,C.Z,q,q),C.a4,C.aN,q,k,q))}else if(r.z)l.push(D.akt)
else l.push(D.a99)
l.push(C.u)
l.push(D.bqR)
return G.x3(q,l,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.amJ.prototype={
t(d){var x=null,w=this.e,v=A.b2J(this.c*3.141592653589793/180,A.hx(x,x,x,new B.asE(this.d,w,x),D.b6g)),u=w?C.v:C.cS,t=A.aH(C.v,2)
return A.ds(C.P,A.a([v,D.aVv,A.D(x,A.b4(C.h0,w?C.af:C.v,x,x),C.k,x,x,new A.E(u,x,t,x,x,x,x,C.bZ),x,54,x,x,x,x,54)],y.u),C.m,C.bj,x)}}
B.asE.prototype={
aR(a2,a3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=null,a0=a3.k7(C.z),a1=a3.gfw()/2-18
$.aq()
x=A.bn()
x.r=C.i.ae(0.06).gu()
a2.iP(a0,a1,x)
x=A.bn()
x.b=C.c6
x.r=C.id.gu()
x.c=2
a2.iP(a0,a1,x)
for(x=a2.a,w=a0.a,v=a0.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a0(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=a1-(s?14:7)
m=new A.lL(C.dq,C.dg,C.fC,C.hc,C.e8)
m.r=(s?C.i:C.fd).gu()
m.c=s?2.5:1.2
l=m.eH()
x.drawLine.apply(x,[w+r*a1,v+q*a1,w+p*n,v+o*n,l])
l.delete()}for(x=D.aPR.gcK(),x=x.ga_(x),r=a1-28;x.v();){q=x.gJ()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.aco:C.aq
k=new A.qr(new A.eX(q,d,d,C.bx,d,d,d,d,d,d,new A.r(!0,p,d,d,d,d,16,C.U,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d)),C.t,C.bg,new A.ii(1),d,d,d,d,C.bG,d)
k.rT()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aR(a2,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gcO()/2))}t=(this.b-90)*3.141592653589793/180
x=Math.cos(t)
w=Math.sin(t)
j=new A.w(x,w)
i=new A.w(-w,x)
h=a0.a5(0,j.aA(0,a1+12))
g=a0.a5(0,j.aA(0,34))
x=$.aq()
f=A.bn()
w=(this.c?C.v:C.v.ae(0.9)).gu()
f.r=w
v=a0.a5(0,j.aA(0,a1-6))
r=A.bn()
r.r=A.cC(w).gu()
r.c=5
r.d=C.jZ
a2.l5(g,v,r)
e=new A.cI(x.r,C.aD,d,d,A.a([],y.a))
e.aO(new A.fT(h.a,h.b))
x=a1-14
e.aO(new A.dg(a0.a5(0,j.aA(0,x)).a5(0,i.aA(0,11)).a,a0.a5(0,j.aA(0,x)).a5(0,i.aA(0,11)).b))
e.aO(new A.dg(a0.a5(0,j.aA(0,x)).ac(0,i.aA(0,11)).a,a0.a5(0,j.aA(0,x)).ac(0,i.aA(0,11)).b))
e.aO(new A.mN())
a2.hq(e,f)},
fd(d){return d.b!==this.b||d.c!==this.c}}
var z=a.updateTypes(["aj<~>()","~()"])
B.aBY.prototype={
$1(d){return this.a.aUH(d)},
$S:5}
B.bF5.prototype={
$1(d){var x,w,v,u=this.a
if(u.c==null)return
x=u.y
w=x==null?d:B.a2Z(x+B.c5Q(d,x)*0.35)
v=Math.abs(B.c5Q(B.che(u.d,u.e),w))<4
if(v&&!u.as)A.c0I(80)
u.k(new B.bF4(u,w,v))},
$S:58}
B.bF4.prototype={
$0(){var x=this.a
x.y=this.b
x.as=this.c},
$S:0}
B.bF6.prototype={
$0(){var x=this.a
if(x.c!=null)x.k(new B.bF3(x))},
$S:0}
B.bF3.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bF1.prototype={
$0(){return this.a.Q=!1},
$S:0}
B.bF2.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bF7.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bF8.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bF9.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bFa.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gmJ()},
$S:0};(function installTearOffs(){var x=a._instance_0u
var w
x(w=B.a5c.prototype,"gaGk","aGl",1)
x(w,"gb1M","ajF",1)
x(w=B.ZC.prototype,"gaE9","MN",0)
x(w,"gaY8","H9",0)
x(w,"gaXu","Pk",0)})();(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.a5c,A.a5)
w(A.ir,[B.aBY,B.bF5])
x(B.wk,A.L)
x(B.ZC,A.M)
w(A.kV,[B.bF4,B.bF6,B.bF3,B.bF1,B.bF2,B.bF7,B.bF8,B.bF9,B.bFa])
x(B.amJ,A.a4)
x(B.asE,A.F3)})()
A.oY(b.typeUniverse,JSON.parse('{"wk":{"L":[],"l":[]},"ZC":{"M":["wk"]},"amJ":{"a4":[],"l":[]},"asE":{"aC":[]}}'))
var y={a:A.ai("F<f_>"),u:A.ai("F<l>"),w:A.ai("o"),o:A.ai("lr<a2>"),q:A.ai("qI"),e:A.ai("P"),v:A.ai("~")};(function constants(){var x=a.makeConstList
D.bnb=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,F.aJ,null,null,null,null,null,null,null,null)
D.a99=new A.cf(C.P,null,null,D.bnb,null)
D.aco=new A.U(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.agT=new A.bH(3e6)
D.bdD=new A.r(!0,C.aq,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.brd=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.bdD,null,null,null,null,null,null,null,null)
D.akt=new E.dA(D.brd,C.a4,C.aN,null,!1,null)
D.ao_=new A.G(I.Gy,null,C.v,null,null,null)
D.aqf=new A.G(C.Gk,null,null,null,null,null)
D.asd=new A.G(C.hB,null,C.aq,null,null,null)
D.ayA=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ai("F<o>"))
D.aPR=new A.cY([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ai("cY<x,o>"))
D.aqO=new A.G(C.G9,34,C.i,null,null,null)
D.aVv=new A.q_(null,0,null,null,null,null,D.aqO,null)
D.b6g=new A.T(290,290)
D.bax=new A.r(!0,C.i,null,null,null,null,16,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.biA=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.bqa=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.eE,null,null,null,null,null,null,null,null)
D.bqR=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,F.aJ,C.Z,null,null,null,null,null,null,null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cIp","cjw",()=>A.c56())})()};
(a=>{a["ivDjilo7aXWvVfdEkqwIcJGViDk="]=a.current})($__dart_deferred_initializers__);