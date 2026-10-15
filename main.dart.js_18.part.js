((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,H,B={
FF(d){var x,w,v
if(d==null)return null
try{x=A.dN(d)
w=isNaN(x)?null:x
return w}catch(v){return null}},
aDL:function aDL(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.r=_.f=_.e=!1
_.w=null},
aDN:function aDN(d){this.a=d},
aDO:function aDO(d){this.a=d},
aDM:function aDM(d){this.a=d},
cmb(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.EM(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
EM(d){var x=C.f.a2(d,360)
return x<0?x+360:x},
cmw(d,e){var x=B.EM(d-e)
return x>=180?x-360:x},
cFV(d){var x,w,v,u,t,s=d.length
if(s<2)return 0
for(x=0,w=0,v=0;v<d.length;d.length===s||(0,A.L)(d),++v){u=d[v]*3.141592653589793/180
x+=Math.cos(u)
w+=Math.sin(u)}t=Math.sqrt(x*x+w*w)/d.length
if(t>=1)return 0
if(t<=1e-9)return 180
return Math.sqrt(-2*Math.log(t))*180/3.141592653589793},
aKz:function aKz(d){this.a=d
this.c=this.b=null},
zn:function zn(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
cwD(){return new B.wP(null)},
wP:function wP(d){this.a=d},
a_Q:function a_Q(d,e,f,g,h,i,j){var _=this
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
bIG:function bIG(d){this.a=d},
bIF:function bIF(d){this.a=d},
bIB:function bIB(){},
bIC:function bIC(d){this.a=d},
bIA:function bIA(){},
bIv:function bIv(d){this.a=d},
bIw:function bIw(d){this.a=d},
bIx:function bIx(d){this.a=d},
bIy:function bIy(d,e){this.a=d
this.b=e},
bIz:function bIz(d){this.a=d},
bID:function bID(d,e){this.a=d
this.b=e},
bIE:function bIE(d){this.a=d},
YK:function YK(d,e,f){this.c=d
this.d=e
this.a=f},
aok:function aok(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
auj:function auj(d){this.a=d},
amo:function amo(d,e){this.b=d
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
B.aDL.prototype={
jZ(){var x=0,w=A.j(y.e),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$jZ=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
n=b.G
r=A.kj(n.DeviceOrientationEvent)
if(r==null||r.requestPermission==null){n=A.kj(n.DeviceOrientationEvent)
v=n!=null
x=1
break}x=7
return A.c(A.eF(A.d3(A.cU(r,"requestPermission",null,null,null,null)),y.w),$async$jZ)
case 7:q=e
p=q==="granted"
if(p)s.NL()
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
ak1(){var x,w,v,u,t,s
try{u=b.G
x=A.kj(u.screen)
t=x
w=A.kj(t==null?null:t.orientation)
t=w
v=B.FF(t==null?null:t.angle)
if(v!=null)return v
u=B.FF(u.orientation)
if(u==null)u=0
return u}catch(s){return 0}},
aI4(d){var x,w,v,u,t,s,r,q,p,o,n=this,m="deviceorientationabsolute"
if(n.f)return
try{x=B.FF(d.beta)
w=B.FF(d.gamma)
v=B.FF(d.webkitCompassHeading)
if(v!=null){n.w=new A.aR(Date.now(),0,!1)
n.a.E(0,new B.zn(B.EM(v+n.ak1()),B.FF(d.webkitCompassAccuracy),x,w))
return}u=B.FF(d.alpha)
if(u==null)return
r=A.u(d.type)
t=r==null?null:r
if(!J.k(t,m)){q=A.eg(d.absolute)
if(q==null)q=null
p=q===!0}else p=!0
s=p
if(!s)return
if(J.k(t,m))n.r=!0
else if(n.r)return
n.w=new A.aR(Date.now(),0,!1)
n.a.E(0,new B.zn(B.EM(360-u+n.ak1()),null,x,w))}catch(o){}},
om(){var x,w,v,u=this,t=null,s="addEventListener"
if(u.e||u.f)return
u.e=!0
u.NL()
x=u.c=A.cjG(new B.aDN(u))
w=b.G
v=A.kj(w.document)
if(v!=null)A.cU(v,s,"visibilitychange",x,t,t)
A.cU(w,s,"pageshow",x,t,t)
u.d=A.hD(C.mY,new B.aDO(u))},
NL(){var x,w,v=this,u=null,t="addEventListener"
if(v.f)return
v.adt()
x=v.b=A.fV(new B.aDM(v))
w=b.G
if("ondeviceorientationabsolute" in w)A.cU(w,t,"deviceorientationabsolute",x,u,u)
A.cU(w,t,"deviceorientation",x,u,u)},
adt(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.cU(x,v,"deviceorientationabsolute",u,w,w)
A.cU(x,v,"deviceorientation",u,w,w)
this.b=null},
m(){var x,w,v,u=this,t=null,s="removeEventListener"
if(u.f)return
u.f=!0
x=u.d
if(x!=null)x.aC()
u.adt()
w=u.c
if(w!=null){x=b.G
v=A.kj(x.document)
if(v!=null)A.cU(v,s,"visibilitychange",w,t,t)
A.cU(x,s,"pageshow",w,t,t)}u.a.bH()}}
B.aKz.prototype={}
B.zn.prototype={}
B.wP.prototype={
O(){var x=$.cov().a,w=x[1],v=x[2]
x=x[0]
return new B.a_Q(w,v,x+" (\u062a\u0642\u0631\u064a\u0628\u064a)",new B.aDL(new A.lG(null,null,y.o)),new B.aKz(0.2),A.a([],y.h),new A.aR(A.ks(0,0,!1),0,!1))}}
B.a_Q.prototype={
W(){var x,w,v,u=this
u.Y()
x=A.kj(b.G.DeviceOrientationEvent)
u.ch=x!=null&&x.requestPermission!=null
w=u.w
v=w.a
u.z=new A.fw(v,A.y(v).i("fw<1>")).jq(u.gaWR())
w.om()
u.cx=A.cR(D.aic,new B.bIG(u))
u.b_5()},
m(){var x=this,w=x.cx
if(w!=null)w.aC()
w=x.cy
if(w!=null)w.aC()
w=x.z
if(w!=null)w.aC()
x.w.m()
x.a0()},
aWS(d){var x,w,v,u,t,s,r,q,p,o=this
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
w=u}else v=s}w=B.EM(Math.atan2(v,w)*180/3.141592653589793)
w.toString
q=Math.abs(B.cmw(B.cmb(o.d,o.e),w))<=5
if(q&&!o.CW)A.c59(80)
v=o.Q
o.Q=w
o.CW=q
o.as=d.b
w=d.c
s=d.d
if(!(w!=null&&Math.abs(w)>35))w=s!=null&&Math.abs(s)>35
else w=!0
o.at=w
o.ax=x.length>=10&&B.cFV(x)>12
o.ay=o.ch=!1
p=new A.aR(Date.now(),0,!1)
if(v==null||p.dG(o.db).a>33e3){o.db=p
x=o.cy
if(x!=null)x.aC()
o.cy=null
o.j(new B.bIB())}else if(o.cy==null)o.cy=A.cR(C.F4,new B.bIC(o))},
Np(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$Np=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.w
x=3
return A.c(t.jZ(),$async$Np)
case 3:s=e
if(u.c==null){x=1
break}if(s){u.j(new B.bIv(u))
t.om()}else{u.j(new B.bIw(u))
u.c.J(y.q).f.Z(A.aO(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))}case 1:return A.h(v,w)}})
return A.i($async$Np,w)},
Be(d){return this.aUy(d)},
b_5(){return this.Be(!1)},
aUy(d){var x=0,w=A.j(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$Be=A.e(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:r.j(new B.bIx(r))
u=4
x=d?7:9
break
case 7:x=10
return A.c(A.jL(!0),$async$Be)
case 10:x=8
break
case 9:x=11
return A.c(A.Dh(),$async$Be)
case 11:case 8:q=f
if(r.c==null||q==null){s=[1]
x=5
break}r.j(new B.bIy(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null&&d)o.J(y.q).f.Z(A.aO(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.j(new B.bIz(r))
x=s.pop()
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Be,w)},
Q0(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$Q0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(I.cm_(s),$async$Q0)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.j(new B.bID(u,t))
case 1:return A.h(v,w)}})
return A.i($async$Q0,w)},
u(d){var x,w,v,u,t,s,r,q,p=this,o=null,n=B.cmb(p.d,p.e),m=p.Q,l=m==null,k=!l,j=k?B.cmw(n,m):0,i=k&&p.CW,h=p.as
if(h!=null)x=h<0||h>25
else x=!1
h=y.u
w=A.a([D.apr,C.N,A.R(A.d(p.f,o,o,o,o,C.bw,o,o,o),1)],h)
if(p.r)w.push(L.tN)
else w.push(A.bQ(o,o,o,o,D.atR,o,o,new B.bIE(p),o,o,o,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",o))
w.push(A.bh(D.bsY,o,o,o,p.gaZn(),o,o))
w=A.A(w,C.h,C.d,C.e,0,o,o)
v=l?0:m
v=A.bN(A.ao(new B.aok(v,k?j:n,i,o),290,290),o,o)
u=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+(E.bp(C.j.a2(C.f.ak(B.EM(n)),360))+"\xb0")+" \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",o,o,o,o,M.a0X,C.a0,o,o)
t=D.aAk[C.j.a2(C.f.aH(B.EM(n)+22.5,45),8)]
s=p.d
r=p.e
q=Math.pow(Math.sin((21.4225-s)*3.141592653589793/180/2),2)+Math.cos(s*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-r)*3.141592653589793/180/2),2)
t=A.a([new E.dz(w,C.a4,C.aO,o,!1,o),C.F,v,C.a1,u,A.d("\u0646\u0627\u062d\u064a\u0629 "+t+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bp(C.f.ak(12742*Math.atan2(Math.sqrt(q),Math.sqrt(1-q))))+" \u0643\u0645",o,o,o,o,G.aL,C.a0,o,o)],h)
if(k){w=E.bp(C.j.a2(C.f.ak(B.EM(m)),360))
v=p.as
v=v!=null&&v>=0?" \u2022 \u062f\u0642\u0629 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \xb1"+E.bp(C.f.ak(v))+"\xb0":""
t.push(A.d("\u0627\u062a\u062c\u0627\u0647 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u062f\u0644\u0648\u0642\u062a\u064a "+(w+"\xb0")+v,o,o,o,o,D.bcM,C.a0,o,o))}t.push(C.a5)
if(p.ch&&l)C.b.A(t,A.a([A.fn(D.arN,D.blb,p.gaFM(),A.eA(C.v,C.ae,o,o,o,o,o)),C.t],h))
if(k){l=i?"aligned":"turn "+C.f.ak(j)
if(i)h="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{h=Math.abs(j)
h=j>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bp(C.f.ak(h))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bp(C.f.ak(h))+"\xb0"}t.push(A.bI(o,o,o,new E.dz(A.d(h,o,o,o,o,A.bK(o,o,i?F.cM:C.i,o,o,o,o,o,o,o,o,16,o,o,C.S,o,o,!0,o,o,o,o,o,o,o,o),C.a0,o,o),C.a4,C.aO,o,i,o),!1,o,o,o,!1,o,!1,o,o,o,o,o,o,o,o,o,o,l,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,C.a_,o))}else if(p.ay&&!p.ch)t.push(D.alO)
else if(!p.ch)t.push(D.aam)
if(k&&p.at)t.push(D.bG7)
if(k)l=x||p.ax
else l=!1
if(l)t.push(D.bG6)
t.push(C.t)
t.push(D.bjJ)
return H.xB(o,t,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.YK.prototype={
u(d){var x=null
return new E.dz(A.A(A.a([A.b0(this.c,C.v,x,22),C.Y,A.R(A.d(this.d,x,x,x,x,F.a1_,x,x,x),1)],y.u),C.h,C.d,C.e,0,x,x),C.a4,C.aO,x,!1,x)}}
B.aok.prototype={
u(d){var x,w=null,v=this.e,u=v?F.cM:C.v,t=A.aj_(-this.c*3.141592653589793/180,A.h8(w,w,w,new B.auj(w),D.a05)),s=this.d,r=C.f.ak(s)
r=A.bI(w,w,w,A.aj_(s*3.141592653589793/180,A.h8(w,w,w,new B.amo(u,w),D.a05)),!1,w,w,w,!1,w,!1,w,w,w,w,w,w,w,w,w,w,"qibla-arrow "+r,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,C.a_,w)
s=v?u:C.cL
x=A.aH(u,2)
return A.dA(C.P,A.a([t,r,D.aXI,A.D(w,A.b0(C.fp,v?C.ae:C.v,w,w),C.k,w,w,new A.G(s,w,x,w,w,w,w,C.bY),w,54,w,w,w,w,54)],y.u),C.m,C.bk,w)}}
B.auj.prototype={
aQ(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=null,i=e.ji(C.z),h=e.gfq()/2-18
$.ap()
x=A.bg()
x.r=C.i.ad(0.06).gt()
d.h_(i,h,x)
x=A.bg()
x.b=C.bV
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
m=new A.m3(C.dt,C.cQ,C.fK,C.hl,C.ea)
m.r=(s?C.i:C.eS).gt()
m.c=s?2.5:1.2
l=m.eR()
x.drawLine.apply(x,[w+r*h,v+q*h,w+p*n,v+o*n,l])
l.delete()}for(x=D.aRS.gcN(),x=x.ga_(x),r=h-28;x.v();){q=x.gI()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.adC:C.am
k=new A.qQ(new A.eL(q,j,j,C.br,j,j,j,j,j,j,new A.q(!0,p,j,j,j,j,16,C.W,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j)),C.u,C.bi,new A.iv(1),j,j,j,j,C.bL,j)
k.th()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aQ(d,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gcW()/2))}},
fh(d){return!1}}
B.amo.prototype={
aQ(d,e){var x,w,v,u,t,s=e.ji(C.z),r=e.gfq()/2-18,q=s.a6(0,C.lF.aE(0,r+12)),p=$.ap(),o=A.bg(),n=this.b
o.r=n.gt()
x=s.a6(0,C.lF.aE(0,34))
w=s.a6(0,C.lF.aE(0,r-6))
v=A.bg()
v.r=n.gt()
v.c=5
v.d=C.k6
d.le(x,w,v)
u=s.a6(0,C.lF.aE(0,r-14))
t=new A.cL(p.r,C.aD,null,null,A.a([],y.a))
t.aP(new A.h0(q.a,q.b))
t.aP(new A.dq(u.a6(0,C.hh.aE(0,11)).a,u.a6(0,C.hh.aE(0,11)).b))
t.aP(new A.dq(u.ae(0,C.hh.aE(0,11)).a,u.ae(0,C.hh.aE(0,11)).b))
t.aP(new A.n1())
d.hj(t,o)},
fh(d){return!d.b.l(0,this.b)}}
var z=a.updateTypes(["ai<~>()","~(zn)"])
B.aDN.prototype={
$0(){var x,w,v=this.a
if(v.f)return
x=A.kj(b.G.document)
w=A.u(x==null?null:x.visibilityState)
if((w==null?null:w)==="visible")v.NL()},
$S:23}
B.aDO.prototype={
$1(d){var x=this.a,w=x.w
if(w!=null&&new A.aR(Date.now(),0,!1).dG(w).a>3e6){x.w=new A.aR(Date.now(),0,!1)
x.NL()}},
$S:31}
B.aDM.prototype={
$1(d){return this.a.aI4(d)},
$S:6}
B.bIG.prototype={
$0(){var x=this.a
if(x.c!=null&&x.Q==null)x.j(new B.bIF(x))},
$S:0}
B.bIF.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bIB.prototype={
$0(){},
$S:0}
B.bIC.prototype={
$0(){var x=this.a
x.cy=null
x.db=new A.aR(Date.now(),0,!1)
if(x.c!=null)x.j(new B.bIA())},
$S:0}
B.bIA.prototype={
$0(){},
$S:0}
B.bIv.prototype={
$0(){return this.a.ch=!1},
$S:0}
B.bIw.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bIx.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bIy.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bIz.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bID.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gn3()},
$S:0}
B.bIE.prototype={
$0(){return this.a.Be(!0)},
$S:0};(function installTearOffs(){var x=a._instance_1u,w=a._instance_0u
var v
x(v=B.a_Q.prototype,"gaWR","aWS",1)
w(v,"gaFM","Np",0)
w(v,"gaZn","Q0",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aDL,B.aKz,B.zn])
x(A.lb,[B.aDN,B.bIG,B.bIF,B.bIB,B.bIC,B.bIA,B.bIv,B.bIw,B.bIx,B.bIy,B.bIz,B.bID,B.bIE])
x(A.iE,[B.aDO,B.aDM])
w(B.wP,A.K)
w(B.a_Q,A.M)
x(A.a3,[B.YK,B.aok])
x(A.FP,[B.auj,B.amo])})()
A.pi(b.typeUniverse,JSON.parse('{"wP":{"K":[],"l":[]},"a_Q":{"M":["wP"]},"YK":{"a3":[],"l":[]},"aok":{"a3":[],"l":[]},"auj":{"aA":[]},"amo":{"aA":[]}}'))
var y={a:A.ae("H<f4>"),u:A.ae("H<l>"),h:A.ae("H<a2>"),w:A.ae("o"),o:A.ae("lG<zn>"),q:A.ae("pf"),e:A.ae("N"),v:A.ae("~")};(function constants(){var x=a.makeConstList
D.bpV=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.aL,null,null,null,null,null,null,null,null)
D.aam=new A.ce(C.P,null,null,D.bpV,null)
D.adC=new A.S(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.aic=new A.bF(3e6)
D.bg9=new A.q(!0,C.am,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bu3=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.bg9,null,null,null,null,null,null,null,null)
D.alO=new E.dz(D.bu3,C.a4,C.aO,null,!1,null)
D.apr=new A.E(K.Hf,null,C.v,null,null,null)
D.arN=new A.E(C.H1,null,null,null,null,null)
D.atR=new A.E(C.h8,null,C.am,null,null,null)
D.aAk=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ae("H<o>"))
D.aRS=new A.cZ([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ae("cZ<x,o>"))
D.asn=new A.E(C.xW,34,C.i,null,null,null)
D.aXI=new A.qp(null,0,null,null,null,null,D.asn,null)
D.a05=new A.T(290,290)
D.bcM=new A.q(!0,C.am,null,null,null,null,13,null,null,null,null,null,1.8,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjJ=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633 \u0648\u062c\u0631\u0627\u0628 \u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.aL,C.a0,null,null,null,null,null,null,null)
D.blb=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.bsY=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.eL,null,null,null,null,null,null,null,null)
D.an4=new A.Q(62812,"MaterialIcons",null,!1)
D.bG6=new B.YK(D.an4,"\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u062d\u062a\u0627\u062c\u0629 \u0645\u0639\u0627\u064a\u0631\u0629: \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0639\u0644\u0649 \u0634\u0643\u0644 8 \u0641\u064a \u0627\u0644\u0647\u0648\u0627 \u0643\u0627\u0645 \u0645\u0631\u0629",null)
D.aoX=new A.Q(985111,"MaterialIcons",null,!1)
D.bG7=new B.YK(D.aoX,"\u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0641\u0631\u0648\u062f (\u0645\u0633\u0637\u0651\u062d \u0632\u064a \u0627\u0644\u0635\u064a\u0646\u064a\u0629) \u0639\u0634\u0627\u0646 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u064a\u0628\u0642\u0649 \u0645\u0638\u0628\u0648\u0637",null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cNQ","cov",()=>A.c9x())})()};
(a=>{a["19FkFR0m+NzhfZVUH0YXoZvSb6o="]=a.current})($__dart_deferred_initializers__);