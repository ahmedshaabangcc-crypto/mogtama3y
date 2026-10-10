((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={a4J:function a4J(){this.a=$
this.b=null},aBi:function aBi(d){this.a=d},
coL(){return new B.w3(null)},
w3:function w3(d){this.a=d},
Z9:function Z9(d,e,f,g){var _=this
_.d=d
_.e=e
_.f=f
_.r=!1
_.w=g
_.y=_.x=null
_.as=_.Q=_.z=!1
_.c=_.a=_.at=null},
bDi:function bDi(d){this.a=d},
bDh:function bDh(d,e,f){this.a=d
this.b=e
this.c=f},
bDj:function bDj(d){this.a=d},
bDg:function bDg(d){this.a=d},
bDe:function bDe(d){this.a=d},
bDf:function bDf(d){this.a=d},
bDk:function bDk(d){this.a=d},
bDl:function bDl(d,e){this.a=d
this.b=e},
bDm:function bDm(d){this.a=d},
bDn:function bDn(d,e){this.a=d
this.b=e},
am8:function am8(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
arZ:function arZ(d,e,f){this.b=d
this.c=e
this.a=f},
ceu(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.a2w(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
a2w(d){var x=C.f.a0(d,360)
return x<0?x+360:x},
c3k(d,e){var x=B.a2w(d-e)
return x>180?x-360:x}},D,G,H,I,E,F
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[5],B)
D=c[21]
G=c[10]
H=c[23]
I=c[22]
E=c[12]
F=c[14]
B.a4J.prototype={
jI(){var x=0,w=A.k(y.e),v,u=2,t=[],s,r,q,p,o
var $async$jI=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
q=b.G
s=A.qz(q.DeviceOrientationEvent)
if(s==null||s.requestPermission==null){q=A.qz(q.DeviceOrientationEvent)
v=q!=null
x=1
break}x=7
return A.c(A.eM(A.d0(A.dO(s,"requestPermission",null,null,null,null)),y.w),$async$jI)
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
ai9(){var x,w,v,u,t,s,r
try{t=b.G
x=A.qz(t.screen)
s=x
w=A.qz(s==null?null:s.orientation)
s=w
v=s==null?null:s.angle
if(v!=null){t=A.dK(v)
return t}u=t.orientation
t=u==null?0:A.dK(u)
return t}catch(r){return 0}},
aTZ(d){var x,w,v,u,t,s,r,q=this
try{x=d.webkitCompassHeading
if(x!=null){t=q.a
t===$&&A.b()
t.F(0,B.a2w(A.dK(x)+q.ai9()))
return}w=d.alpha
if(w==null)return
s=A.u(d.type)
v=s==null?null:s
t=A.er(d.absolute)
if(t==null)t=null
u=t===!0
if(J.e(v,"deviceorientationabsolute")||u){t=q.a
t===$&&A.b()
t.F(0,B.a2w(360-A.dK(w)+q.ai9()))}}catch(r){}},
aFO(){var x,w,v=null,u="addEventListener"
if(this.b!=null)return
x=this.b=A.h1(new B.aBi(this))
w=b.G
A.dO(w,u,"deviceorientationabsolute",x,v,v)
A.dO(w,u,"deviceorientation",x,v,v)},
ajh(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.dO(x,v,"deviceorientationabsolute",u,w,w)
A.dO(x,v,"deviceorientation",u,w,w)
this.b=null}}
B.w3.prototype={
P(){var x,w=$.cgK().a,v=w[1],u=w[2]
w=w[0]
x=new B.a4J()
x.a=new A.lk(x.gaFN(),x.gb10(),y.o)
return new B.Z9(v,u,w+" (\u062a\u0642\u0631\u064a\u0628\u064a)",x)}}
B.Z9.prototype={
X(){var x,w,v=this
v.Y()
x=A.qz(b.G.DeviceOrientationEvent)
w=x!=null&&x.requestPermission!=null
v.Q=w
if(!w)v.afq()
v.H_()},
m(){var x=this,w=x.at
if(w!=null)w.aD()
w=x.x
if(w!=null)w.aD()
w=x.w
w.ajh()
w=w.a
w===$&&A.b()
w.bB()
x.a1()},
afq(){var x=this,w=x.x
if(w!=null)w.aD()
w=x.w.a
w===$&&A.b()
x.x=new A.fj(w,A.y(w).i("fj<1>")).jc(new B.bDi(x))
w=x.at
if(w!=null)w.aD()
x.at=A.cW(D.aga,new B.bDj(x))},
MD(){var x=0,w=A.k(y.v),v,u=this,t
var $async$MD=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:x=3
return A.c(u.w.jI(),$async$MD)
case 3:t=e
if(u.c==null){x=1
break}u.k(new B.bDe(u))
if(t)u.afq()
else{u.k(new B.bDf(u))
u.c.I(y.q).f.Z(A.aN(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))}case 1:return A.i(v,w)}})
return A.j($async$MD,w)},
H_(){var x=0,w=A.k(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$H_=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:r.k(new B.bDk(r))
u=4
x=7
return A.c(A.jX(),$async$H_)
case 7:q=e
if(r.c==null){s=[1]
x=5
break}r.k(new B.bDl(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null)o.I(y.q).f.Z(A.aN(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.k(new B.bDm(r))
x=s.pop()
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$H_,w)},
P9(){var x=0,w=A.k(y.v),v,u=this,t,s
var $async$P9=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(G.cej(s),$async$P9)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.k(new B.bDn(u,t))
case 1:return A.i(v,w)}})
return A.j($async$P9,w)},
t(d){var x,w,v,u,t,s,r=this,q=null,p=B.ceu(r.d,r.e),o=r.y,n=o!=null,m=n?B.c3k(p,o):0,l=y.u,k=A.a([D.anb,C.J,A.S(A.d(r.f,q,q,q,q,C.c7,q,q,q),1)],l)
if(r.r)k.push(I.tn)
else k.push(A.cb(q,q,q,D.arg,q,q,r.gaXo(),q,q,q,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",q))
k.push(A.br(D.boI,q,q,r.gaWL(),q,q))
k=A.B(k,C.i,C.d,C.e,0,q,q)
x=n?-o:0
x=A.bV(A.aq(new B.am8(x,p,r.as&&n,q),290,290),q,q)
w=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+E.bJ(C.f.am(p,0))+"\xb0 \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",q,q,q,q,D.b7S,C.a4,q,q)
v=D.axA[C.j.a0(C.f.aL(B.a2w(p)+22.5,45),8)]
u=r.d
t=r.e
s=Math.pow(Math.sin((21.4225-u)*3.141592653589793/180/2),2)+Math.cos(u*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-t)*3.141592653589793/180/2),2)
l=A.a([new E.eg(k,C.a7,C.aW,q,!1,q),C.K,x,C.a_,w,A.d("\u0646\u0627\u062d\u064a\u0629 "+v+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bJ(C.f.aw(12742*Math.atan2(Math.sqrt(s),Math.sqrt(1-s))))+" \u0643\u0645",q,q,q,q,F.b2,C.a4,q,q),C.a1],l)
if(r.Q)l.push(A.fX(D.apm,D.bhf,r.gaDC(),A.eS(C.A,C.aq,q,q)))
else if(n){k=r.as
if(k)x="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{x=Math.abs(m)
x=m>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bJ(C.f.aw(x))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bJ(C.f.aw(x))+"\xb0"}l.push(new E.eg(A.d(x,q,q,q,q,D.b9g,C.a4,q,q),C.a7,C.aW,q,k,q))}else if(r.z)l.push(D.ajH)
else l.push(D.a8x)
l.push(C.u)
l.push(D.bpn)
return E.wO(q,l,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.am8.prototype={
t(d){var x=null,w=this.e,v=A.b1O(this.c*3.141592653589793/180,A.hv(x,x,x,new B.arZ(this.d,w,x),D.b54)),u=w?C.A:C.dl,t=A.aF(C.A,2)
return A.dq(C.P,A.a([v,D.aUn,A.D(x,A.bb(C.fZ,w?C.aq:C.A,x,x),C.k,x,x,new A.E(u,x,t,x,x,x,x,C.c2),x,54,x,x,x,x,54)],y.u),C.m,C.bh,x)}}
B.arZ.prototype={
aR(a2,a3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=null,a0=a3.k5(C.y),a1=a3.gfs()/2-18
$.ap()
x=A.bl()
x.r=C.h.ah(0.06).gu()
a2.iO(a0,a1,x)
x=A.bl()
x.b=C.c5
x.r=C.ks.gu()
x.c=2
a2.iO(a0,a1,x)
for(x=a2.a,w=a0.a,v=a0.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a0(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=a1-(s?14:7)
m=new A.lE(C.di,C.d9,C.fy,C.h9,C.e7)
m.r=(s?C.h:C.fO).gu()
m.c=s?2.5:1.2
l=m.eG()
x.drawLine.apply(x,[w+r*a1,v+q*a1,w+p*n,v+o*n,l])
l.delete()}for(x=D.aOM.gcM(),x=x.ga_(x),r=a1-28;x.A();){q=x.gJ()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.abJ:C.ar
k=new A.qe(new A.eW(q,d,d,C.bw,d,d,d,d,d,d,new A.r(!0,p,d,d,d,d,16,C.U,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d)),C.t,C.bf,new A.ig(1),d,d,d,d,C.bF,d)
k.rP()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aR(a2,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gcO()/2))}t=(this.b-90)*3.141592653589793/180
x=Math.cos(t)
w=Math.sin(t)
j=new A.w(x,w)
i=new A.w(-w,x)
h=a0.a4(0,j.az(0,a1+12))
g=a0.a4(0,j.az(0,34))
x=$.ap()
f=A.bl()
w=(this.c?C.A:C.A.ah(0.9)).gu()
f.r=w
v=a0.a4(0,j.az(0,a1-6))
r=A.bl()
r.r=A.cC(w).gu()
r.c=5
r.d=C.jU
a2.l2(g,v,r)
e=new A.cI(x.r,C.aC,d,d,A.a([],y.a))
e.aO(new A.fP(h.a,h.b))
x=a1-14
e.aO(new A.dd(a0.a4(0,j.az(0,x)).a4(0,i.az(0,11)).a,a0.a4(0,j.az(0,x)).a4(0,i.az(0,11)).b))
e.aO(new A.dd(a0.a4(0,j.az(0,x)).ab(0,i.az(0,11)).a,a0.a4(0,j.az(0,x)).ab(0,i.az(0,11)).b))
e.aO(new A.mG())
a2.ho(e,f)},
fc(d){return d.b!==this.b||d.c!==this.c}}
var z=a.updateTypes(["ai<~>()","~()"])
B.aBi.prototype={
$1(d){return this.a.aTZ(d)},
$S:4}
B.bDi.prototype={
$1(d){var x,w,v,u=this.a
if(u.c==null)return
x=u.y
w=x==null?d:B.a2w(x+B.c3k(d,x)*0.35)
v=Math.abs(B.c3k(B.ceu(u.d,u.e),w))<4
if(v&&!u.as)A.bZm(80)
u.k(new B.bDh(u,w,v))},
$S:73}
B.bDh.prototype={
$0(){var x=this.a
x.y=this.b
x.as=this.c},
$S:0}
B.bDj.prototype={
$0(){var x=this.a
if(x.c!=null)x.k(new B.bDg(x))},
$S:0}
B.bDg.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bDe.prototype={
$0(){return this.a.Q=!1},
$S:0}
B.bDf.prototype={
$0(){return this.a.z=!0},
$S:0}
B.bDk.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bDl.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bDm.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bDn.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gmD()},
$S:0};(function installTearOffs(){var x=a._instance_0u
var w
x(w=B.a4J.prototype,"gaFN","aFO",1)
x(w,"gb10","ajh",1)
x(w=B.Z9.prototype,"gaDC","MD",0)
x(w,"gaXo","H_",0)
x(w,"gaWL","P9",0)})();(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.a4J,A.a4)
w(A.j4,[B.aBi,B.bDi])
x(B.w3,A.L)
x(B.Z9,A.O)
w(A.mH,[B.bDh,B.bDj,B.bDg,B.bDe,B.bDf,B.bDk,B.bDl,B.bDm,B.bDn])
x(B.am8,A.a5)
x(B.arZ,A.EQ)})()
A.xv(b.typeUniverse,JSON.parse('{"w3":{"L":[],"l":[]},"Z9":{"O":["w3"]},"am8":{"a5":[],"l":[]},"arZ":{"aB":[]}}'))
var y={a:A.ak("F<f5>"),u:A.ak("F<l>"),w:A.ak("o"),o:A.ak("lk<a2>"),q:A.ak("qv"),e:A.ak("P"),v:A.ak("~")};(function constants(){var x=a.makeConstList
D.blM=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,F.b2,null,null,null,null,null,null,null,null)
D.a8x=new A.cg(C.P,null,null,D.blM,null)
D.abJ=new A.V(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.aga=new A.bC(3e6)
D.bcm=new A.r(!0,C.ar,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bpI=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.bcm,null,null,null,null,null,null,null,null)
D.ajH=new E.eg(D.bpI,C.a7,C.aW,null,!1,null)
D.anb=new A.G(H.Gf,null,C.A,null,null,null)
D.apm=new A.G(C.G2,null,null,null,null,null)
D.arg=new A.G(C.hz,null,C.ar,null,null,null)
D.axA=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ak("F<o>"))
D.aOM=new A.cX([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ak("cX<x,o>"))
D.apU=new A.G(C.FQ,34,C.h,null,null,null)
D.aUn=new A.pQ(null,0,null,null,null,null,D.apU,null)
D.b54=new A.Q(290,290)
D.b7S=new A.r(!0,C.h,null,null,null,null,22,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b9g=new A.r(!0,C.h,null,null,null,null,16,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhf=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.boI=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.fB,null,null,null,null,null,null,null,null)
D.bpn=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,F.b2,C.a4,null,null,null,null,null,null,null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cFn","cgK",()=>A.c2E())})()};
(a=>{a["ek+F+J+y8FofQDfUhdqAb6IH5Jw="]=a.current})($__dart_deferred_initializers__);