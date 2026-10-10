((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={a46:function a46(){this.a=$
this.b=null},aAz:function aAz(d){this.a=d},
clG(){return new B.vC(null)},
vC:function vC(d){this.a=d},
Yz:function Yz(d,e,f){var _=this
_.d=d
_.e=e
_.f="\u0627\u0644\u0642\u0627\u0647\u0631\u0629 (\u062a\u0642\u0631\u064a\u0628\u064a)"
_.r=!1
_.w=f
_.y=_.x=null
_.as=_.Q=_.z=!1
_.c=_.a=_.at=null},
bB1:function bB1(d){this.a=d},
bB0:function bB0(d,e,f){this.a=d
this.b=e
this.c=f},
bB2:function bB2(d){this.a=d},
bB_:function bB_(d){this.a=d},
bAY:function bAY(d){this.a=d},
bAZ:function bAZ(d){this.a=d},
bB3:function bB3(d){this.a=d},
bB4:function bB4(d,e){this.a=d
this.b=e},
bB5:function bB5(d){this.a=d},
bB7:function bB7(){},
bB6:function bB6(d,e){this.a=d
this.b=e},
bB8:function bB8(d,e){this.a=d
this.b=e},
alp:function alp(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
arf:function arf(d,e,f){this.b=d
this.c=e
this.a=f},
cbz(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.a1V(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
a1V(d){var x=C.f.a3(d,360)
return x<0?x+360:x},
c0A(d,e){var x=B.a1V(d-e)
return x>180?x-360:x}},D,F,H,E,G
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[5],B)
D=c[22]
F=c[21]
H=c[23]
E=c[12]
G=c[14]
B.a46.prototype={
jH(){var x=0,w=A.k(y.e),v,u=2,t=[],s,r,q,p,o
var $async$jH=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
q=b.G
s=A.x8(q.DeviceOrientationEvent)
if(s==null||s.requestPermission==null){q=A.x8(q.DeviceOrientationEvent)
v=q!=null
x=1
break}x=7
return A.c(A.eF(A.fH(s,"requestPermission",null,null,y.h),y.w),$async$jH)
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
return A.j($async$jH,w)},
ahE(){var x,w,v,u,t,s,r
try{t=b.G
x=A.x8(t.screen)
s=x
w=A.x8(s==null?null:s.orientation)
s=w
v=s==null?null:s.angle
if(v!=null){t=A.dB(v)
return t}u=t.orientation
t=u==null?0:A.dB(u)
return t}catch(r){return 0}},
aTd(d){var x,w,v,u,t,s,r,q=this
try{x=d.webkitCompassHeading
if(x!=null){t=q.a
t===$&&A.b()
t.F(0,B.a1V(A.dB(x)+q.ahE()))
return}w=d.alpha
if(w==null)return
s=A.v(d.type)
v=s==null?null:s
t=A.et(d.absolute)
if(t==null)t=null
u=t===!0
if(J.e(v,"deviceorientationabsolute")||u){t=q.a
t===$&&A.b()
t.F(0,B.a1V(360-A.dB(w)+q.ahE()))}}catch(r){}},
aF8(){var x,w,v,u="addEventListener"
if(this.b!=null)return
x=this.b=A.fW(new B.aAz(this))
w=b.G
v=y.q
A.fH(w,u,"deviceorientationabsolute",x,v)
A.fH(w,u,"deviceorientation",x,v)},
aiN(){var x,w,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
w=y.q
A.fH(x,v,"deviceorientationabsolute",u,w)
A.fH(x,v,"deviceorientation",u,w)
this.b=null}}
B.vC.prototype={
O(){var x=C.b.ga5(F.qF),w=C.b.ga5(F.qF),v=new B.a46()
v.a=new A.l9(v.gaF7(),v.gb00(),y.o)
return new B.Yz(x.b,w.c,v)}}
B.Yz.prototype={
X(){var x,w,v=this
v.Y()
x=A.x8(b.G.DeviceOrientationEvent)
w=x!=null&&x.requestPermission!=null
v.Q=w
if(!w)v.af0()
v.GJ()},
m(){var x=this,w=x.at
if(w!=null)w.aC()
w=x.x
if(w!=null)w.aC()
w=x.w
w.aiN()
w=w.a
w===$&&A.b()
w.bB()
x.a0()},
af0(){var x=this,w=x.x
if(w!=null)w.aC()
w=x.w.a
w===$&&A.b()
x.x=new A.fb(w,A.x(w).i("fb<1>")).ja(new B.bB1(x))
w=x.at
if(w!=null)w.aC()
x.at=A.cT(D.aeR,new B.bB2(x))},
Mq(){var x=0,w=A.k(y.v),v,u=this,t
var $async$Mq=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:x=3
return A.c(u.w.jH(),$async$Mq)
case 3:t=e
if(u.c==null){x=1
break}u.l(new B.bAY(u))
if(t)u.af0()
else{u.l(new B.bAZ(u))
u.c.I(y.r).f.a_(A.aS(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))}case 1:return A.i(v,w)}})
return A.j($async$Mq,w)},
GJ(){var x=0,w=A.k(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$GJ=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:r.l(new B.bB3(r))
u=4
x=7
return A.c(A.jP(),$async$GJ)
case 7:q=e
if(r.c==null){s=[1]
x=5
break}r.l(new B.bB4(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null)o.I(y.r).f.a_(A.aS(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.l(new B.bB5(r))
x=s.pop()
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$GJ,w)},
OS(){var x=0,w=A.k(y.v),v,u=this,t,s
var $async$OS=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(A.ef(null,new B.bB7(),s,!1,null,null,y.C),$async$OS)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.l(new B.bB8(u,t))
case 1:return A.i(v,w)}})
return A.j($async$OS,w)},
t(d){var x,w,v,u,t,s,r=this,q=null,p=B.cbz(r.d,r.e),o=r.y,n=o!=null,m=n?B.c0A(p,o):0,l=y.u,k=A.a([D.alN,C.I,A.V(A.d(r.f,q,q,q,q,C.c5,q,q,q),1)],l)
if(r.r)k.push(H.td)
else k.push(A.cb(q,q,q,D.apP,q,q,r.gaWz(),q,q,q,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",q))
k.push(A.bt(D.bjH,q,q,r.gaVW(),q,q))
k=A.A(k,C.i,C.d,C.e,0,q,q)
x=n?-o:0
x=A.bT(A.ao(new B.alp(x,p,r.as&&n,q),290,290),q,q)
w=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+E.bK(C.f.av(p,0))+"\xb0 \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",q,q,q,q,D.b36,C.a5,q,q)
v=D.avU[C.k.a3(C.f.aR(B.a1V(p)+22.5,45),8)]
u=r.d
t=r.e
s=Math.pow(Math.sin((21.4225-u)*3.141592653589793/180/2),2)+Math.cos(u*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-t)*3.141592653589793/180/2),2)
l=A.a([new E.e8(k,C.a6,C.aU,q,!1,q),C.M,x,C.a0,w,A.d("\u0646\u0627\u062d\u064a\u0629 "+v+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bK(C.f.aA(12742*Math.atan2(Math.sqrt(s),Math.sqrt(1-s))))+" \u0643\u0645",q,q,q,q,G.b9,C.a5,q,q),C.a3],l)
if(r.Q)l.push(A.hb(D.anX,D.bcr,r.gaCW(),A.eY(C.A,C.aq,q,q)))
else if(n){k=r.as
if(k)x="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{x=Math.abs(m)
x=m>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bK(C.f.aA(x))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bK(C.f.aA(x))+"\xb0"}l.push(new E.e8(A.d(x,q,q,q,q,D.b4x,C.a5,q,q),C.a6,C.aU,q,k,q))}else if(r.z)l.push(D.aii)
else l.push(D.a7U)
l.push(C.u)
l.push(D.bki)
return E.wj(q,l,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.alp.prototype={
t(d){var x=null,w=this.e,v=A.b0L(this.c*3.141592653589793/180,A.hq(x,x,x,new B.arf(this.d,w,x),D.b0k)),u=w?C.A:C.di,t=A.aC(C.A,2)
return A.dm(C.N,A.a([v,D.aSj,A.C(x,A.bd(C.fQ,w?C.aq:C.A,x,x),C.j,x,x,new A.E(u,x,t,x,x,x,x,C.bZ),x,54,x,x,x,x,54)],y.u),C.m,C.be,x)}}
B.arf.prototype={
aQ(a2,a3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=null,a0=a3.k0(C.x),a1=a3.gfp()/2-18
$.an()
x=A.bk()
x.r=C.h.ak(0.06).gu()
a2.iK(a0,a1,x)
x=A.bk()
x.b=C.c2
x.r=C.kk.gu()
x.c=2
a2.iK(a0,a1,x)
for(x=a2.a,w=a0.a,v=a0.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.k.a3(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=a1-(s?14:7)
m=new A.lt(C.df,C.d5,C.fr,C.h_,C.e3)
m.r=(s?C.h:C.fF).gu()
m.c=s?2.5:1.2
l=m.eF()
x.drawLine.apply(x,[w+r*a1,v+q*a1,w+p*n,v+o*n,l])
l.delete()}for(x=D.aMX.gcQ(),x=x.gZ(x),r=a1-28;x.v();){q=x.gN()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.ab5:C.ar
k=new A.pY(new A.eP(q,d,d,C.bt,d,d,d,d,d,d,new A.r(!0,p,d,d,d,d,16,C.U,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d)),C.t,C.bf,new A.i9(1),d,d,d,d,C.bD,d)
k.rH()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aQ(a2,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gcN()/2))}t=(this.b-90)*3.141592653589793/180
x=Math.cos(t)
w=Math.sin(t)
j=new A.w(x,w)
i=new A.w(-w,x)
h=a0.a1(0,j.aw(0,a1+12))
g=a0.a1(0,j.aw(0,34))
x=$.an()
f=A.bk()
w=(this.c?C.A:C.A.ak(0.9)).gu()
f.r=w
v=a0.a1(0,j.aw(0,a1-6))
r=A.bk()
r.r=A.cy(w).gu()
r.c=5
r.d=C.jK
a2.kZ(g,v,r)
e=new A.cE(x.r,C.aB,d,d,A.a([],y.a))
e.aN(new A.fJ(h.a,h.b))
x=a1-14
e.aN(new A.d9(a0.a1(0,j.aw(0,x)).a1(0,i.aw(0,11)).a,a0.a1(0,j.aw(0,x)).a1(0,i.aw(0,11)).b))
e.aN(new A.d9(a0.a1(0,j.aw(0,x)).ab(0,i.aw(0,11)).a,a0.a1(0,j.aw(0,x)).ab(0,i.aw(0,11)).b))
e.aN(new A.ms())
a2.hl(e,f)},
f8(d){return d.b!==this.b||d.c!==this.c}}
var z=a.updateTypes(["aj<~>()","~()"])
B.aAz.prototype={
$1(d){return this.a.aTd(d)},
$S:4}
B.bB1.prototype={
$1(d){var x,w,v,u=this.a
if(u.c==null)return
x=u.y
w=x==null?d:B.a1V(x+B.c0A(d,x)*0.35)
v=Math.abs(B.c0A(B.cbz(u.d,u.e),w))<4
if(v&&!u.as)A.bWG(80)
u.l(new B.bB0(u,w,v))},
$S:73}
B.bB0.prototype={
$0(){var x=this.a
x.y=this.b
x.as=this.c},
$S:0}
B.bB2.prototype={
$0(){var x=this.a
if(x.c!=null)x.l(new B.bB_(x))},
$S:0}
B.bB_.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bAY.prototype={
$0(){return this.a.Q=!1},
$S:0}
B.bAZ.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bB3.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bB4.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bB5.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bB7.prototype={
$1(d){var x,w,v=null,u=A.a([F.Hm],y.u)
for(x=0;x<27;++x){w=F.qF[x]
u.push(A.c7(!1,v,v,v,!0,v,v,v,!0,v,v,v,v,v,v,new B.bB6(d,w),!1,v,v,v,v,v,v,A.d(w.a,v,v,v,v,v,v,v,v),v,v,v))}return A.cv(!0,A.ba(u,v,v,v,C.v,!1),C.K,!0)},
$S:32}
B.bB6.prototype={
$0(){A.O(this.a,!1).ao(this.b)
return null},
$S:0}
B.bB8.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.a},
$S:0};(function installTearOffs(){var x=a._instance_0u
var w
x(w=B.a46.prototype,"gaF7","aF8",1)
x(w,"gb00","aiN",1)
x(w=B.Yz.prototype,"gaCW","Mq",0)
x(w,"gaWz","GJ",0)
x(w,"gaVW","OS",0)})();(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.a46,A.a3)
w(A.ju,[B.aAz,B.bB1,B.bB7])
x(B.vC,A.L)
x(B.Yz,A.N)
w(A.nn,[B.bB0,B.bB2,B.bB_,B.bAY,B.bAZ,B.bB3,B.bB4,B.bB5,B.bB6,B.bB8])
x(B.alp,A.a5)
x(B.arf,A.En)})()
A.D7(b.typeUniverse,JSON.parse('{"vC":{"L":[],"l":[]},"Yz":{"N":["vC"]},"alp":{"a5":[],"l":[]},"arf":{"aB":[]}}'))
var y=(function rtii(){var x=A.as
return{a:x("G<eZ>"),u:x("G<l>"),h:x("bP"),C:x("+(o,a1,a1)"),w:x("o"),o:x("l9<a1>"),r:x("qd"),e:x("Q"),q:x("a3?"),v:x("~")}})();(function constants(){var x=a.makeConstList
D.bgS=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.b9,null,null,null,null,null,null,null,null)
D.a7U=new A.ce(C.N,null,null,D.bgS,null)
D.ab5=new A.U(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.aeR=new A.bA(3e6)
D.b7C=new A.r(!0,C.ar,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bkB=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.b7C,null,null,null,null,null,null,null,null)
D.aii=new E.e8(D.bkB,C.a6,C.aU,null,!1,null)
D.alN=new A.F(F.FT,null,C.A,null,null,null)
D.anX=new A.F(C.FE,null,null,null,null,null)
D.apP=new A.F(C.hq,null,C.ar,null,null,null)
D.avU=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.as("G<o>"))
D.aMX=new A.di([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.as("di<y,o>"))
D.aou=new A.F(C.Fr,34,C.h,null,null,null)
D.aSj=new A.pz(null,0,null,null,null,null,D.aou,null)
D.b0k=new A.P(290,290)
D.b36=new A.r(!0,C.h,null,null,null,null,22,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b4x=new A.r(!0,C.h,null,null,null,null,16,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bcr=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.bjH=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.h0,null,null,null,null,null,null,null,null)
D.bki=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.b9,C.a5,null,null,null,null,null,null,null)})()};
(a=>{a["Q5AS2kwzqBaAmFel+OYDvLP6/wE="]=a.current})($__dart_deferred_initializers__);