((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,G,B={a59:function a59(){this.a=$
this.b=null},aBU:function aBU(d){this.a=d},
crl(){return new B.wi(null)},
wi:function wi(d){this.a=d},
ZA:function ZA(d,e,f,g){var _=this
_.d=d
_.e=e
_.f=f
_.r=!1
_.w=g
_.y=_.x=null
_.as=_.Q=_.z=!1
_.c=_.a=_.at=null},
bF2:function bF2(d){this.a=d},
bF1:function bF1(d,e,f){this.a=d
this.b=e
this.c=f},
bF3:function bF3(d){this.a=d},
bF0:function bF0(d){this.a=d},
bEZ:function bEZ(d){this.a=d},
bF_:function bF_(d){this.a=d},
bF4:function bF4(d){this.a=d},
bF5:function bF5(d,e){this.a=d
this.b=e},
bF6:function bF6(d){this.a=d},
bF7:function bF7(d,e){this.a=d
this.b=e},
amF:function amF(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
asA:function asA(d,e,f){this.b=d
this.c=e
this.a=f},
ch0(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.a2W(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
a2W(d){var x=C.f.a0(d,360)
return x<0?x+360:x},
c5D(d,e){var x=B.a2W(d-e)
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
B.a59.prototype={
jJ(){var x=0,w=A.k(y.e),v,u=2,t=[],s,r,q,p,o
var $async$jJ=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
q=b.G
s=A.my(q.DeviceOrientationEvent)
if(s==null||s.requestPermission==null){q=A.my(q.DeviceOrientationEvent)
v=q!=null
x=1
break}x=7
return A.c(A.eF(A.cU(A.db(s,"requestPermission",null,null,null,null)),y.w),$async$jJ)
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
return A.j($async$jJ,w)},
aix(){var x,w,v,u,t,s,r
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
aUE(d){var x,w,v,u,t,s,r,q=this
try{x=d.webkitCompassHeading
if(x!=null){t=q.a
t===$&&A.b()
t.F(0,B.a2W(A.dI(x)+q.aix()))
return}w=d.alpha
if(w==null)return
s=A.u(d.type)
v=s==null?null:s
t=A.em(d.absolute)
if(t==null)t=null
u=t===!0
if(J.e(v,"deviceorientationabsolute")||u){t=q.a
t===$&&A.b()
t.F(0,B.a2W(360-A.dI(w)+q.aix()))}}catch(r){}},
aGi(){var x,w,v=null,u="addEventListener"
if(this.b!=null)return
x=this.b=A.fN(new B.aBU(this))
w=b.G
A.db(w,u,"deviceorientationabsolute",x,v,v)
A.db(w,u,"deviceorientation",x,v,v)},
ajD(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.db(x,v,"deviceorientationabsolute",u,w,w)
A.db(x,v,"deviceorientation",u,w,w)
this.b=null}}
B.wi.prototype={
P(){var x,w=$.cjh().a,v=w[1],u=w[2]
w=w[0]
x=new B.a59()
x.a=new A.lq(x.gaGh(),x.gb1J(),y.o)
return new B.ZA(v,u,w+" (\u062a\u0642\u0631\u064a\u0628\u064a)",x)}}
B.ZA.prototype={
X(){var x,w,v=this
v.Y()
x=A.my(b.G.DeviceOrientationEvent)
w=x!=null&&x.requestPermission!=null
v.Q=w
if(!w)v.ahs()
v.H9()},
m(){var x=this,w=x.at
if(w!=null)w.aD()
w=x.x
if(w!=null)w.aD()
w=x.w
w.ajD()
w=w.a
w===$&&A.b()
w.bC()
x.a1()},
ahs(){var x=this,w=x.x
if(w!=null)w.aD()
w=x.w.a
w===$&&A.b()
x.x=new A.fj(w,A.y(w).i("fj<1>")).jd(new B.bF2(x))
w=x.at
if(w!=null)w.aD()
x.at=A.cS(D.agO,new B.bF3(x))},
MM(){var x=0,w=A.k(y.v),v,u=this,t
var $async$MM=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:x=3
return A.c(u.w.jJ(),$async$MM)
case 3:t=e
if(u.c==null){x=1
break}u.k(new B.bEZ(u))
if(t)u.ahs()
else{u.k(new B.bF_(u))
u.c.I(y.q).f.Z(A.aT(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))}case 1:return A.i(v,w)}})
return A.j($async$MM,w)},
H9(){var x=0,w=A.k(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$H9=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:r.k(new B.bF4(r))
u=4
x=7
return A.c(A.k1(),$async$H9)
case 7:q=e
if(r.c==null){s=[1]
x=5
break}r.k(new B.bF5(r,q))
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
if(r.c!=null)r.k(new B.bF6(r))
x=s.pop()
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$H9,w)},
Pj(){var x=0,w=A.k(y.v),v,u=this,t,s
var $async$Pj=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(H.cgQ(s),$async$Pj)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.k(new B.bF7(u,t))
case 1:return A.i(v,w)}})
return A.j($async$Pj,w)},
t(d){var x,w,v,u,t,s,r=this,q=null,p=B.ch0(r.d,r.e),o=r.y,n=o!=null,m=n?B.c5D(p,o):0,l=y.u,k=A.a([D.anV,C.K,A.R(A.d(r.f,q,q,q,q,C.bz,q,q,q),1)],l)
if(r.r)k.push(K.tu)
else k.push(A.bT(q,q,q,q,D.as7,q,q,r.gaY5(),q,q,q,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",q))
k.push(A.bf(D.bq1,q,q,r.gaXr(),q,q))
k=A.A(k,C.h,C.d,C.e,0,q,q)
x=n?-o:0
x=A.bO(A.ao(new B.amF(x,p,r.as&&n,q),290,290),q,q)
w=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+E.bs(C.f.am(p,0))+"\xb0 \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",q,q,q,q,L.a0f,C.a_,q,q)
v=D.ayu[C.j.a0(C.f.aJ(B.a2W(p)+22.5,45),8)]
u=r.d
t=r.e
s=Math.pow(Math.sin((21.4225-u)*3.141592653589793/180/2),2)+Math.cos(u*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-t)*3.141592653589793/180/2),2)
l=A.a([new E.dA(k,C.a4,C.aQ,q,!1,q),C.I,x,C.a0,w,A.d("\u0646\u0627\u062d\u064a\u0629 "+v+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bs(C.f.aw(12742*Math.atan2(Math.sqrt(s),Math.sqrt(1-s))))+" \u0643\u0645",q,q,q,q,F.aJ,C.a_,q,q),C.a1],l)
if(r.Q)l.push(A.fs(D.aqa,D.bis,r.gaE6(),A.eA(C.v,C.af,q,q,q)))
else if(n){k=r.as
if(k)x="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{x=Math.abs(m)
x=m>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bs(C.f.aw(x))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bs(C.f.aw(x))+"\xb0"}l.push(new E.dA(A.d(x,q,q,q,q,D.baq,C.a_,q,q),C.a4,C.aQ,q,k,q))}else if(r.z)l.push(D.ako)
else l.push(D.a94)
l.push(C.u)
l.push(D.bqH)
return G.x1(q,l,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.amF.prototype={
t(d){var x=null,w=this.e,v=A.b2G(this.c*3.141592653589793/180,A.hw(x,x,x,new B.asA(this.d,w,x),D.b69)),u=w?C.v:C.cS,t=A.aH(C.v,2)
return A.ds(C.P,A.a([v,D.aVp,A.D(x,A.b7(C.h0,w?C.af:C.v,x,x),C.k,x,x,new A.E(u,x,t,x,x,x,x,C.bZ),x,54,x,x,x,x,54)],y.u),C.m,C.bj,x)}}
B.asA.prototype={
aR(a2,a3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=null,a0=a3.k8(C.z),a1=a3.gfw()/2-18
$.aq()
x=A.bn()
x.r=C.i.ae(0.06).gu()
a2.iQ(a0,a1,x)
x=A.bn()
x.b=C.c6
x.r=C.ib.gu()
x.c=2
a2.iQ(a0,a1,x)
for(x=a2.a,w=a0.a,v=a0.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a0(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=a1-(s?14:7)
m=new A.lK(C.dp,C.df,C.fC,C.hb,C.e7)
m.r=(s?C.i:C.fd).gu()
m.c=s?2.5:1.2
l=m.eH()
x.drawLine.apply(x,[w+r*a1,v+q*a1,w+p*n,v+o*n,l])
l.delete()}for(x=D.aPL.gcK(),x=x.ga_(x),r=a1-28;x.v();){q=x.gJ()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.acj:C.aq
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
B.aBU.prototype={
$1(d){return this.a.aUE(d)},
$S:5}
B.bF2.prototype={
$1(d){var x,w,v,u=this.a
if(u.c==null)return
x=u.y
w=x==null?d:B.a2W(x+B.c5D(d,x)*0.35)
v=Math.abs(B.c5D(B.ch0(u.d,u.e),w))<4
if(v&&!u.as)A.c0v(80)
u.k(new B.bF1(u,w,v))},
$S:56}
B.bF1.prototype={
$0(){var x=this.a
x.y=this.b
x.as=this.c},
$S:0}
B.bF3.prototype={
$0(){var x=this.a
if(x.c!=null)x.k(new B.bF0(x))},
$S:0}
B.bF0.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bEZ.prototype={
$0(){return this.a.Q=!1},
$S:0}
B.bF_.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bF4.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bF5.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bF6.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bF7.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gmJ()},
$S:0};(function installTearOffs(){var x=a._instance_0u
var w
x(w=B.a59.prototype,"gaGh","aGi",1)
x(w,"gb1J","ajD",1)
x(w=B.ZA.prototype,"gaE6","MM",0)
x(w,"gaY5","H9",0)
x(w,"gaXr","Pj",0)})();(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.a59,A.a5)
w(A.ir,[B.aBU,B.bF2])
x(B.wi,A.L)
x(B.ZA,A.N)
w(A.kV,[B.bF1,B.bF3,B.bF0,B.bEZ,B.bF_,B.bF4,B.bF5,B.bF6,B.bF7])
x(B.amF,A.a4)
x(B.asA,A.F1)})()
A.oX(b.typeUniverse,JSON.parse('{"wi":{"L":[],"l":[]},"ZA":{"N":["wi"]},"amF":{"a4":[],"l":[]},"asA":{"aB":[]}}'))
var y={a:A.ai("F<f_>"),u:A.ai("F<l>"),w:A.ai("o"),o:A.ai("lq<a2>"),q:A.ai("qI"),e:A.ai("P"),v:A.ai("~")};(function constants(){var x=a.makeConstList
D.bn3=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,F.aJ,null,null,null,null,null,null,null,null)
D.a94=new A.cf(C.P,null,null,D.bn3,null)
D.acj=new A.U(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.agO=new A.bH(3e6)
D.bdw=new A.r(!0,C.aq,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.br2=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.bdw,null,null,null,null,null,null,null,null)
D.ako=new E.dA(D.br2,C.a4,C.aQ,null,!1,null)
D.anV=new A.G(I.Gx,null,C.v,null,null,null)
D.aqa=new A.G(C.Gj,null,null,null,null,null)
D.as7=new A.G(C.hA,null,C.aq,null,null,null)
D.ayu=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ai("F<o>"))
D.aPL=new A.cY([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ai("cY<x,o>"))
D.aqJ=new A.G(C.G7,34,C.i,null,null,null)
D.aVp=new A.pZ(null,0,null,null,null,null,D.aqJ,null)
D.b69=new A.T(290,290)
D.baq=new A.r(!0,C.i,null,null,null,null,16,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bis=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.bq1=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.eE,null,null,null,null,null,null,null,null)
D.bqH=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,F.aJ,C.a_,null,null,null,null,null,null,null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cIa","cjh",()=>A.c4U())})()};
(a=>{a["TrRXl1RANVZhRz8qW0vOmq/sNqQ="]=a.current})($__dart_deferred_initializers__);