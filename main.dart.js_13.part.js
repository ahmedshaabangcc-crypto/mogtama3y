((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={a4d:function a4d(){this.a=$
this.b=null},aAK:function aAK(d){this.a=d},
cmO(){return new B.vD(null)},
vD:function vD(d){this.a=d},
YG:function YG(d,e,f){var _=this
_.d=d
_.e=e
_.f="\u0627\u0644\u0642\u0627\u0647\u0631\u0629 (\u062a\u0642\u0631\u064a\u0628\u064a)"
_.r=!1
_.w=f
_.y=_.x=null
_.as=_.Q=_.z=!1
_.c=_.a=_.at=null},
bC3:function bC3(d){this.a=d},
bC2:function bC2(d,e,f){this.a=d
this.b=e
this.c=f},
bC4:function bC4(d){this.a=d},
bC1:function bC1(d){this.a=d},
bC_:function bC_(d){this.a=d},
bC0:function bC0(d){this.a=d},
bC5:function bC5(d){this.a=d},
bC6:function bC6(d,e){this.a=d
this.b=e},
bC7:function bC7(d){this.a=d},
bC9:function bC9(){},
bC8:function bC8(d,e){this.a=d
this.b=e},
bCa:function bCa(d,e){this.a=d
this.b=e},
alz:function alz(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
arp:function arp(d,e,f){this.b=d
this.c=e
this.a=f},
ccG(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.a22(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
a22(d){var x=C.f.a2(d,360)
return x<0?x+360:x},
c1D(d,e){var x=B.a22(d-e)
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
B.a4d.prototype={
jH(){var x=0,w=A.k(y.e),v,u=2,t=[],s,r,q,p,o
var $async$jH=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
q=b.G
s=A.x8(q.DeviceOrientationEvent)
if(s==null||s.requestPermission==null){q=A.x8(q.DeviceOrientationEvent)
v=q!=null
x=1
break}x=7
return A.c(A.eG(A.fJ(s,"requestPermission",null,null,y.h),y.w),$async$jH)
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
ahM(){var x,w,v,u,t,s,r
try{t=b.G
x=A.x8(t.screen)
s=x
w=A.x8(s==null?null:s.orientation)
s=w
v=s==null?null:s.angle
if(v!=null){t=A.dD(v)
return t}u=t.orientation
t=u==null?0:A.dD(u)
return t}catch(r){return 0}},
aTo(d){var x,w,v,u,t,s,r,q=this
try{x=d.webkitCompassHeading
if(x!=null){t=q.a
t===$&&A.b()
t.F(0,B.a22(A.dD(x)+q.ahM()))
return}w=d.alpha
if(w==null)return
s=A.v(d.type)
v=s==null?null:s
t=A.eu(d.absolute)
if(t==null)t=null
u=t===!0
if(J.e(v,"deviceorientationabsolute")||u){t=q.a
t===$&&A.b()
t.F(0,B.a22(360-A.dD(w)+q.ahM()))}}catch(r){}},
aFg(){var x,w,v,u="addEventListener"
if(this.b!=null)return
x=this.b=A.fW(new B.aAK(this))
w=b.G
v=y.q
A.fJ(w,u,"deviceorientationabsolute",x,v)
A.fJ(w,u,"deviceorientation",x,v)},
aiV(){var x,w,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
w=y.q
A.fJ(x,v,"deviceorientationabsolute",u,w)
A.fJ(x,v,"deviceorientation",u,w)
this.b=null}}
B.vD.prototype={
O(){var x=C.b.ga5(F.qI),w=C.b.ga5(F.qI),v=new B.a4d()
v.a=new A.l9(v.gaFf(),v.gb0e(),y.o)
return new B.YG(x.b,w.c,v)}}
B.YG.prototype={
X(){var x,w,v=this
v.Y()
x=A.x8(b.G.DeviceOrientationEvent)
w=x!=null&&x.requestPermission!=null
v.Q=w
if(!w)v.af7()
v.GP()},
m(){var x=this,w=x.at
if(w!=null)w.aD()
w=x.x
if(w!=null)w.aD()
w=x.w
w.aiV()
w=w.a
w===$&&A.b()
w.bB()
x.a0()},
af7(){var x=this,w=x.x
if(w!=null)w.aD()
w=x.w.a
w===$&&A.b()
x.x=new A.fd(w,A.y(w).i("fd<1>")).ja(new B.bC3(x))
w=x.at
if(w!=null)w.aD()
x.at=A.cT(D.af2,new B.bC4(x))},
Mw(){var x=0,w=A.k(y.v),v,u=this,t
var $async$Mw=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:x=3
return A.c(u.w.jH(),$async$Mw)
case 3:t=e
if(u.c==null){x=1
break}u.l(new B.bC_(u))
if(t)u.af7()
else{u.l(new B.bC0(u))
u.c.I(y.r).f.Z(A.aO(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))}case 1:return A.i(v,w)}})
return A.j($async$Mw,w)},
GP(){var x=0,w=A.k(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$GP=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:r.l(new B.bC5(r))
u=4
x=7
return A.c(A.jQ(),$async$GP)
case 7:q=e
if(r.c==null){s=[1]
x=5
break}r.l(new B.bC6(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null)o.I(y.r).f.Z(A.aO(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.l(new B.bC7(r))
x=s.pop()
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$GP,w)},
OZ(){var x=0,w=A.k(y.v),v,u=this,t,s
var $async$OZ=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(A.eh(null,new B.bC9(),s,!1,null,null,y.C),$async$OZ)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.l(new B.bCa(u,t))
case 1:return A.i(v,w)}})
return A.j($async$OZ,w)},
t(d){var x,w,v,u,t,s,r=this,q=null,p=B.ccG(r.d,r.e),o=r.y,n=o!=null,m=n?B.c1D(p,o):0,l=y.u,k=A.a([D.alY,C.I,A.T(A.d(r.f,q,q,q,q,C.c5,q,q,q),1)],l)
if(r.r)k.push(H.th)
else k.push(A.cd(q,q,q,D.aq1,q,q,r.gaWL(),q,q,q,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",q))
k.push(A.br(D.bkk,q,q,r.gaW7(),q,q))
k=A.B(k,C.i,C.d,C.e,0,q,q)
x=n?-o:0
x=A.bT(A.ap(new B.alz(x,p,r.as&&n,q),290,290),q,q)
w=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+E.bK(C.f.av(p,0))+"\xb0 \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",q,q,q,q,D.b3x,C.a4,q,q)
v=D.awe[C.j.a2(C.f.aO(B.a22(p)+22.5,45),8)]
u=r.d
t=r.e
s=Math.pow(Math.sin((21.4225-u)*3.141592653589793/180/2),2)+Math.cos(u*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-t)*3.141592653589793/180/2),2)
l=A.a([new E.e8(k,C.a6,C.aU,q,!1,q),C.L,x,C.a0,w,A.d("\u0646\u0627\u062d\u064a\u0629 "+v+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bK(C.f.aA(12742*Math.atan2(Math.sqrt(s),Math.sqrt(1-s))))+" \u0643\u0645",q,q,q,q,G.b9,C.a4,q,q),C.a3],l)
if(r.Q)l.push(A.h_(D.ao8,D.bcV,r.gaD3(),A.eT(C.A,C.aq,q,q)))
else if(n){k=r.as
if(k)x="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{x=Math.abs(m)
x=m>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bK(C.f.aA(x))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bK(C.f.aA(x))+"\xb0"}l.push(new E.e8(A.d(x,q,q,q,q,D.b4Y,C.a4,q,q),C.a6,C.aU,q,k,q))}else if(r.z)l.push(D.ait)
else l.push(D.a86)
l.push(C.u)
l.push(D.bkY)
return E.wk(q,l,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.alz.prototype={
t(d){var x=null,w=this.e,v=A.b10(this.c*3.141592653589793/180,A.hr(x,x,x,new B.arp(this.d,w,x),D.b0L)),u=w?C.A:C.di,t=A.aC(C.A,2)
return A.dp(C.N,A.a([v,D.aSK,A.C(x,A.bb(C.fR,w?C.aq:C.A,x,x),C.k,x,x,new A.E(u,x,t,x,x,x,x,C.c_),x,54,x,x,x,x,54)],y.u),C.m,C.bf,x)}}
B.arp.prototype={
aR(a2,a3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=null,a0=a3.k0(C.y),a1=a3.gfq()/2-18
$.an()
x=A.bl()
x.r=C.h.al(0.06).gu()
a2.iL(a0,a1,x)
x=A.bl()
x.b=C.c3
x.r=C.kk.gu()
x.c=2
a2.iL(a0,a1,x)
for(x=a2.a,w=a0.a,v=a0.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a2(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=a1-(s?14:7)
m=new A.lt(C.df,C.d5,C.fr,C.h0,C.e3)
m.r=(s?C.h:C.fG).gu()
m.c=s?2.5:1.2
l=m.eF()
x.drawLine.apply(x,[w+r*a1,v+q*a1,w+p*n,v+o*n,l])
l.delete()}for(x=D.aNi.gcM(),x=x.ga_(x),r=a1-28;x.v();){q=x.gK()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.abi:C.ar
k=new A.pZ(new A.eQ(q,d,d,C.bu,d,d,d,d,d,d,new A.r(!0,p,d,d,d,d,16,C.U,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d)),C.t,C.bg,new A.ia(1),d,d,d,d,C.bE,d)
k.rJ()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aR(a2,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gcO()/2))}t=(this.b-90)*3.141592653589793/180
x=Math.cos(t)
w=Math.sin(t)
j=new A.w(x,w)
i=new A.w(-w,x)
h=a0.a1(0,j.aw(0,a1+12))
g=a0.a1(0,j.aw(0,34))
x=$.an()
f=A.bl()
w=(this.c?C.A:C.A.al(0.9)).gu()
f.r=w
v=a0.a1(0,j.aw(0,a1-6))
r=A.bl()
r.r=A.cz(w).gu()
r.c=5
r.d=C.jK
a2.l_(g,v,r)
e=new A.cE(x.r,C.aC,d,d,A.a([],y.a))
e.aN(new A.fL(h.a,h.b))
x=a1-14
e.aN(new A.d9(a0.a1(0,j.aw(0,x)).a1(0,i.aw(0,11)).a,a0.a1(0,j.aw(0,x)).a1(0,i.aw(0,11)).b))
e.aN(new A.d9(a0.a1(0,j.aw(0,x)).ab(0,i.aw(0,11)).a,a0.a1(0,j.aw(0,x)).ab(0,i.aw(0,11)).b))
e.aN(new A.mt())
a2.hn(e,f)},
f9(d){return d.b!==this.b||d.c!==this.c}}
var z=a.updateTypes(["aj<~>()","~()"])
B.aAK.prototype={
$1(d){return this.a.aTo(d)},
$S:4}
B.bC3.prototype={
$1(d){var x,w,v,u=this.a
if(u.c==null)return
x=u.y
w=x==null?d:B.a22(x+B.c1D(d,x)*0.35)
v=Math.abs(B.c1D(B.ccG(u.d,u.e),w))<4
if(v&&!u.as)A.bXJ(80)
u.l(new B.bC2(u,w,v))},
$S:71}
B.bC2.prototype={
$0(){var x=this.a
x.y=this.b
x.as=this.c},
$S:0}
B.bC4.prototype={
$0(){var x=this.a
if(x.c!=null)x.l(new B.bC1(x))},
$S:0}
B.bC1.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bC_.prototype={
$0(){return this.a.Q=!1},
$S:0}
B.bC0.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bC5.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bC6.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bC7.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bC9.prototype={
$1(d){var x,w,v=null,u=A.a([F.Hu],y.u)
for(x=0;x<27;++x){w=F.qI[x]
u.push(A.c5(!1,v,v,v,!0,v,v,v,!0,v,v,v,v,v,v,new B.bC8(d,w),!1,v,v,v,v,v,v,A.d(w.a,v,v,v,v,v,v,v,v),v,v,v))}return A.cw(!0,A.b9(u,v,v,v,C.v,!1),C.K,!0)},
$S:32}
B.bC8.prototype={
$0(){A.M(this.a,!1).ak(this.b)
return null},
$S:0}
B.bCa.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.a},
$S:0};(function installTearOffs(){var x=a._instance_0u
var w
x(w=B.a4d.prototype,"gaFf","aFg",1)
x(w,"gb0e","aiV",1)
x(w=B.YG.prototype,"gaD3","Mw",0)
x(w,"gaWL","GP",0)
x(w,"gaW7","OZ",0)})();(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.a4d,A.a3)
w(A.jv,[B.aAK,B.bC3,B.bC9])
x(B.vD,A.L)
x(B.YG,A.N)
w(A.np,[B.bC2,B.bC4,B.bC1,B.bC_,B.bC0,B.bC5,B.bC6,B.bC7,B.bC8,B.bCa])
x(B.alz,A.a5)
x(B.arp,A.Eq)})()
A.Da(b.typeUniverse,JSON.parse('{"vD":{"L":[],"l":[]},"YG":{"N":["vD"]},"alz":{"a5":[],"l":[]},"arp":{"aB":[]}}'))
var y=(function rtii(){var x=A.as
return{a:x("G<f0>"),u:x("G<l>"),h:x("bP"),C:x("+(o,a1,a1)"),w:x("o"),o:x("l9<a1>"),r:x("qe"),e:x("Q"),q:x("a3?"),v:x("~")}})();(function constants(){var x=a.makeConstList
D.bhr=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.b9,null,null,null,null,null,null,null,null)
D.a86=new A.cc(C.N,null,null,D.bhr,null)
D.abi=new A.V(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.af2=new A.bB(3e6)
D.b84=new A.r(!0,C.ar,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.blh=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.b84,null,null,null,null,null,null,null,null)
D.ait=new E.e8(D.blh,C.a6,C.aU,null,!1,null)
D.alY=new A.F(F.G_,null,C.A,null,null,null)
D.ao8=new A.F(C.FN,null,null,null,null,null)
D.aq1=new A.F(C.hq,null,C.ar,null,null,null)
D.awe=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.as("G<o>"))
D.aNi=new A.dh([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.as("dh<x,o>"))
D.aoG=new A.F(C.FA,34,C.h,null,null,null)
D.aSK=new A.pz(null,0,null,null,null,null,D.aoG,null)
D.b0L=new A.P(290,290)
D.b3x=new A.r(!0,C.h,null,null,null,null,22,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b4Y=new A.r(!0,C.h,null,null,null,null,16,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bcV=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.bkk=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.h1,null,null,null,null,null,null,null,null)
D.bkY=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.b9,C.a4,null,null,null,null,null,null,null)})()};
(a=>{a["EVWE1g85MCrhRyALkWZ6iuOxFIo="]=a.current})($__dart_deferred_initializers__);