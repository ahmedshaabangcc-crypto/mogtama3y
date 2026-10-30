((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,H,B={
FV(d){var x,w,v
if(d==null)return null
try{x=A.dQ(d)
w=isNaN(x)?null:x
return w}catch(v){return null}},
aEs:function aEs(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.r=_.f=_.e=!1
_.w=null},
aEu:function aEu(d){this.a=d},
aEv:function aEv(d){this.a=d},
aEt:function aEt(d){this.a=d},
cod(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.F1(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
F1(d){var x=C.f.a3(d,360)
return x<0?x+360:x},
coy(d,e){var x=B.F1(d-e)
return x>=180?x-360:x},
cIc(d){var x,w,v,u,t,s=d.length
if(s<2)return 0
for(x=0,w=0,v=0;v<d.length;d.length===s||(0,A.L)(d),++v){u=d[v]*3.141592653589793/180
x+=Math.cos(u)
w+=Math.sin(u)}t=Math.sqrt(x*x+w*w)/d.length
if(t>=1)return 0
if(t<=1e-9)return 180
return Math.sqrt(-2*Math.log(t))*180/3.141592653589793},
aLh:function aLh(d){this.a=d
this.c=this.b=null},
zw:function zw(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
cyS(){return new B.wV(null)},
wV:function wV(d){this.a=d},
a0a:function a0a(d,e,f,g,h,i,j){var _=this
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
bKh:function bKh(d){this.a=d},
bKg:function bKg(d){this.a=d},
bKc:function bKc(){},
bKd:function bKd(d){this.a=d},
bKb:function bKb(){},
bK6:function bK6(d){this.a=d},
bK7:function bK7(d){this.a=d},
bK8:function bK8(d){this.a=d},
bK9:function bK9(d,e){this.a=d
this.b=e},
bKa:function bKa(d){this.a=d},
bKe:function bKe(d,e){this.a=d
this.b=e},
bKf:function bKf(d){this.a=d},
Z3:function Z3(d,e,f){this.c=d
this.d=e
this.a=f},
aoS:function aoS(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
auQ:function auQ(d){this.a=d},
amV:function amV(d,e){this.b=d
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
B.aEs.prototype={
k_(){var x=0,w=A.k(y.e),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$k_=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
n=b.G
r=A.kj(n.DeviceOrientationEvent)
if(r==null||r.requestPermission==null){n=A.kj(n.DeviceOrientationEvent)
v=n!=null
x=1
break}x=7
return A.c(A.eF(A.cS(A.cM(r,"requestPermission",null,null,null,null)),y.w),$async$k_)
case 7:q=e
p=q==="granted"
if(p)s.NZ()
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
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$k_,w)},
akx(){var x,w,v,u,t,s
try{u=b.G
x=A.kj(u.screen)
t=x
w=A.kj(t==null?null:t.orientation)
t=w
v=B.FV(t==null?null:t.angle)
if(v!=null)return v
u=B.FV(u.orientation)
if(u==null)u=0
return u}catch(s){return 0}},
aIO(d){var x,w,v,u,t,s,r,q,p,o,n=this,m="deviceorientationabsolute"
if(n.f)return
try{x=B.FV(d.beta)
w=B.FV(d.gamma)
v=B.FV(d.webkitCompassHeading)
if(v!=null){n.w=new A.aQ(Date.now(),0,!1)
n.a.E(0,new B.zw(B.F1(v+n.akx()),B.FV(d.webkitCompassAccuracy),x,w))
return}u=B.FV(d.alpha)
if(u==null)return
r=A.t(d.type)
t=r==null?null:r
if(!J.e(t,m)){q=A.ei(d.absolute)
if(q==null)q=null
p=q===!0}else p=!0
s=p
if(!s)return
if(J.e(t,m))n.r=!0
else if(n.r)return
n.w=new A.aQ(Date.now(),0,!1)
n.a.E(0,new B.zw(B.F1(360-u+n.akx()),null,x,w))}catch(o){}},
om(){var x,w,v,u=this,t=null,s="addEventListener"
if(u.e||u.f)return
u.e=!0
u.NZ()
x=u.c=A.clI(new B.aEu(u))
w=b.G
v=A.kj(w.document)
if(v!=null)A.cM(v,s,"visibilitychange",x,t,t)
A.cM(w,s,"pageshow",x,t,t)
u.d=A.hD(C.n2,new B.aEv(u))},
NZ(){var x,w,v=this,u=null,t="addEventListener"
if(v.f)return
v.adW()
x=v.b=A.fW(new B.aEt(v))
w=b.G
if("ondeviceorientationabsolute" in w)A.cM(w,t,"deviceorientationabsolute",x,u,u)
A.cM(w,t,"deviceorientation",x,u,u)},
adW(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.cM(x,v,"deviceorientationabsolute",u,w,w)
A.cM(x,v,"deviceorientation",u,w,w)
this.b=null},
m(){var x,w,v,u=this,t=null,s="removeEventListener"
if(u.f)return
u.f=!0
x=u.d
if(x!=null)x.aB()
u.adW()
w=u.c
if(w!=null){x=b.G
v=A.kj(x.document)
if(v!=null)A.cM(v,s,"visibilitychange",w,t,t)
A.cM(x,s,"pageshow",w,t,t)}u.a.bI()}}
B.aLh.prototype={}
B.zw.prototype={}
B.wV.prototype={
P(){var x=$.cqx().a,w=x[1],v=x[2]
x=x[0]
return new B.a0a(w,v,x+" (\u062a\u0642\u0631\u064a\u0628\u064a)",new B.aEs(new A.lG(null,null,y.o)),new B.aLh(0.2),A.a([],y.h),new A.aQ(A.ks(0,0,!1),0,!1))}}
B.a0a.prototype={
W(){var x,w,v,u=this
u.Y()
x=A.kj(b.G.DeviceOrientationEvent)
u.ch=x!=null&&x.requestPermission!=null
w=u.w
v=w.a
u.z=new A.fy(v,A.y(v).i("fy<1>")).jr(u.gaXD())
w.om()
u.cx=A.cR(D.aiP,new B.bKh(u))
u.b00()},
m(){var x=this,w=x.cx
if(w!=null)w.aB()
w=x.cy
if(w!=null)w.aB()
w=x.z
if(w!=null)w.aB()
x.w.m()
x.a_()},
aXE(d){var x,w,v,u,t,s,r,q,p,o=this
if(o.c==null)return
x=o.y
w=d.a
x.push(w)
if(x.length>15)C.b.kw(x,0)
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
w=u}else v=s}w=B.F1(Math.atan2(v,w)*180/3.141592653589793)
w.toString
q=Math.abs(B.coy(B.cod(o.d,o.e),w))<=5
if(q&&!o.CW)A.c79(80)
v=o.Q
o.Q=w
o.CW=q
o.as=d.b
w=d.c
s=d.d
if(!(w!=null&&Math.abs(w)>35))w=s!=null&&Math.abs(s)>35
else w=!0
o.at=w
o.ax=x.length>=10&&B.cIc(x)>12
o.ay=o.ch=!1
p=new A.aQ(Date.now(),0,!1)
if(v==null||p.dD(o.db).a>33e3){o.db=p
x=o.cy
if(x!=null)x.aB()
o.cy=null
o.j(new B.bKc())}else if(o.cy==null)o.cy=A.cR(C.Fr,new B.bKd(o))},
NC(){var x=0,w=A.k(y.v),v,u=this,t,s
var $async$NC=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.w
x=3
return A.c(t.k_(),$async$NC)
case 3:s=e
if(u.c==null){x=1
break}if(s){u.j(new B.bK6(u))
t.om()}else{u.j(new B.bK7(u))
u.c.J(y.q).f.Z(A.aP(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))}case 1:return A.i(v,w)}})
return A.j($async$NC,w)},
Bo(d){return this.aVk(d)},
b00(){return this.Bo(!1)},
aVk(d){var x=0,w=A.k(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$Bo=A.f(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:r.j(new B.bK8(r))
u=4
x=d?7:9
break
case 7:x=10
return A.c(A.jL(!0),$async$Bo)
case 10:x=8
break
case 9:x=11
return A.c(A.Du(),$async$Bo)
case 11:case 8:q=f
if(r.c==null||q==null){s=[1]
x=5
break}r.j(new B.bK9(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null&&d)o.J(y.q).f.Z(A.aP(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.j(new B.bKa(r))
x=s.pop()
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Bo,w)},
Qi(){var x=0,w=A.k(y.v),v,u=this,t,s
var $async$Qi=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(I.co0(s),$async$Qi)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.j(new B.bKe(u,t))
case 1:return A.i(v,w)}})
return A.j($async$Qi,w)},
u(d){var x,w,v,u,t,s,r,q,p=this,o=null,n=B.cod(p.d,p.e),m=p.Q,l=m==null,k=!l,j=k?B.coy(n,m):0,i=k&&p.CW,h=p.as
if(h!=null)x=h<0||h>25
else x=!1
h=y.u
w=A.a([D.aq4,C.M,A.R(A.d(p.f,o,o,o,o,o,C.bw,o,o,o),1)],h)
if(p.r)w.push(L.tW)
else w.push(A.bQ(o,o,o,o,D.aux,o,o,new B.bKf(p),o,o,o,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",o))
w.push(A.bf(D.btZ,o,o,o,p.gb_h(),o,o))
w=A.A(w,C.h,C.d,C.e,0,o,o)
v=l?0:m
v=A.bO(A.ao(new B.aoS(v,k?j:n,i,o),290,290),o,o)
u=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+(E.bq(C.j.a3(C.f.ak(B.F1(n)),360))+"\xb0")+" \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",o,o,o,o,o,M.a1s,C.Z,o,o)
t=D.aB3[C.j.a3(C.f.aH(B.F1(n)+22.5,45),8)]
s=p.d
r=p.e
q=Math.pow(Math.sin((21.4225-s)*3.141592653589793/180/2),2)+Math.cos(s*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-r)*3.141592653589793/180/2),2)
t=A.a([new E.dD(w,C.a4,C.aJ,o,!1,o),C.G,v,C.a1,u,A.d("\u0646\u0627\u062d\u064a\u0629 "+t+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bq(C.f.ak(12742*Math.atan2(Math.sqrt(q),Math.sqrt(1-q))))+" \u0643\u0645",o,o,o,o,o,G.aM,C.Z,o,o)],h)
if(k){w=E.bq(C.j.a3(C.f.ak(B.F1(m)),360))
v=p.as
v=v!=null&&v>=0?" \u2022 \u062f\u0642\u0629 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \xb1"+E.bq(C.f.ak(v))+"\xb0":""
t.push(A.d("\u0627\u062a\u062c\u0627\u0647 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u062f\u0644\u0648\u0642\u062a\u064a "+(w+"\xb0")+v,o,o,o,o,o,D.bdJ,C.Z,o,o))}t.push(C.a5)
if(p.ch&&l)C.b.A(t,A.a([A.fp(D.ast,D.bma,p.gaGr(),A.ev(C.v,C.ae,o,o,o,o,o)),C.u],h))
if(k){l=i?"aligned":"turn "+C.f.ak(j)
if(i)h="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{h=Math.abs(j)
h=j>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bq(C.f.ak(h))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bq(C.f.ak(h))+"\xb0"}t.push(A.bJ(o,o,o,new E.dD(A.d(h,o,o,o,o,o,A.bB(o,o,i?F.cO:C.i,o,o,o,o,o,o,o,o,16,o,o,C.S,o,o,!0,o,o,o,o,o,o,o,o),C.Z,o,o),C.a4,C.aJ,o,i,o),!1,o,o,o,!1,o,!1,o,o,o,o,o,o,o,o,o,o,l,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,C.a0,o))}else if(p.ay&&!p.ch)t.push(D.amu)
else if(!p.ch)t.push(D.aaV)
if(k&&p.at)t.push(D.bHr)
if(k)l=x||p.ax
else l=!1
if(l)t.push(D.bHq)
t.push(C.u)
t.push(D.bkK)
return H.xH(o,t,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.Z3.prototype={
u(d){var x=null
return new E.dD(A.A(A.a([A.b_(this.c,C.v,x,22),C.Y,A.R(A.d(this.d,x,x,x,x,x,F.a1u,x,x,x),1)],y.u),C.h,C.d,C.e,0,x,x),C.a4,C.aJ,x,!1,x)}}
B.aoS.prototype={
u(d){var x,w=null,v=this.e,u=v?F.cO:C.v,t=A.ajw(-this.c*3.141592653589793/180,A.h9(w,w,w,new B.auQ(w),D.a0A)),s=this.d,r=C.f.ak(s)
r=A.bJ(w,w,w,A.ajw(s*3.141592653589793/180,A.h9(w,w,w,new B.amV(u,w),D.a0A)),!1,w,w,w,!1,w,!1,w,w,w,w,w,w,w,w,w,w,"qibla-arrow "+r,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,C.a0,w)
s=v?u:C.cN
x=A.aJ(u,2)
return A.dC(C.P,A.a([t,r,D.aYy,A.F(w,A.b_(C.fr,v?C.ae:C.v,w,w),C.k,w,w,new A.G(s,w,x,w,w,w,w,C.bZ),w,54,w,w,w,w,w,54)],y.u),C.m,C.bk,w)}}
B.auQ.prototype={
aQ(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=null,i=e.jj(C.z),h=e.gfq()/2-18
$.ap()
x=A.bb()
x.r=C.i.ad(0.06).gt()
d.h0(i,h,x)
x=A.bb()
x.b=C.bP
x.r=C.ip.gt()
x.c=2
d.h0(i,h,x)
for(x=d.a,w=i.a,v=i.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a3(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=h-(s?14:7)
m=new A.m4(C.dw,C.cT,C.fL,C.hn,C.ee)
m.r=(s?C.i:C.eV).gt()
m.c=s?2.5:1.2
l=m.eo()
x.drawLine.apply(x,[w+r*h,v+q*h,w+p*n,v+o*n,l])
l.delete()}for(x=D.aSD.gcN(),x=x.ga0(x),r=h-28;x.v();){q=x.gG()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.aea:C.an
k=new A.qS(new A.eM(q,j,j,C.bt,j,j,j,j,j,j,new A.q(!0,p,j,j,j,j,16,C.V,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j)),C.t,C.bi,new A.iw(1),j,j,j,j,C.bM,j)
k.ti()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aQ(d,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gcW()/2))}},
fh(d){return!1}}
B.amV.prototype={
aQ(d,e){var x,w,v,u,t,s=e.jj(C.z),r=e.gfq()/2-18,q=s.a6(0,C.lK.aE(0,r+12)),p=$.ap(),o=A.bb(),n=this.b
o.r=n.gt()
x=s.a6(0,C.lK.aE(0,34))
w=s.a6(0,C.lK.aE(0,r-6))
v=A.bb()
v.r=n.gt()
v.c=5
v.d=C.k9
d.lg(x,w,v)
u=s.a6(0,C.lK.aE(0,r-14))
t=new A.cP(p.r,C.aD,null,null,A.a([],y.a))
t.aO(new A.h2(q.a,q.b))
t.aO(new A.dB(u.a6(0,C.hi.aE(0,11)).a,u.a6(0,C.hi.aE(0,11)).b))
t.aO(new A.dB(u.ae(0,C.hi.aE(0,11)).a,u.ae(0,C.hi.aE(0,11)).b))
t.aO(new A.n2())
d.hj(t,o)},
fh(d){return!d.b.l(0,this.b)}}
var z=a.updateTypes(["ak<~>()","~(zw)"])
B.aEu.prototype={
$0(){var x,w,v=this.a
if(v.f)return
x=A.kj(b.G.document)
w=A.t(x==null?null:x.visibilityState)
if((w==null?null:w)==="visible")v.NZ()},
$S:25}
B.aEv.prototype={
$1(d){var x=this.a,w=x.w
if(w!=null&&new A.aQ(Date.now(),0,!1).dD(w).a>3e6){x.w=new A.aQ(Date.now(),0,!1)
x.NZ()}},
$S:30}
B.aEt.prototype={
$1(d){return this.a.aIO(d)},
$S:6}
B.bKh.prototype={
$0(){var x=this.a
if(x.c!=null&&x.Q==null)x.j(new B.bKg(x))},
$S:0}
B.bKg.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bKc.prototype={
$0(){},
$S:0}
B.bKd.prototype={
$0(){var x=this.a
x.cy=null
x.db=new A.aQ(Date.now(),0,!1)
if(x.c!=null)x.j(new B.bKb())},
$S:0}
B.bKb.prototype={
$0(){},
$S:0}
B.bK6.prototype={
$0(){return this.a.ch=!1},
$S:0}
B.bK7.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bK8.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bK9.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bKa.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bKe.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gn4()},
$S:0}
B.bKf.prototype={
$0(){return this.a.Bo(!0)},
$S:0};(function installTearOffs(){var x=a._instance_1u,w=a._instance_0u
var v
x(v=B.a0a.prototype,"gaXD","aXE",1)
w(v,"gaGr","NC",0)
w(v,"gb_h","Qi",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aEs,B.aLh,B.zw])
x(A.ld,[B.aEu,B.bKh,B.bKg,B.bKc,B.bKd,B.bKb,B.bK6,B.bK7,B.bK8,B.bK9,B.bKa,B.bKe,B.bKf])
x(A.iF,[B.aEv,B.aEt])
w(B.wV,A.K)
w(B.a0a,A.M)
x(A.a3,[B.Z3,B.aoS])
x(A.G4,[B.auQ,B.amV])})()
A.pm(b.typeUniverse,JSON.parse('{"wV":{"K":[],"l":[]},"a0a":{"M":["wV"]},"Z3":{"a3":[],"l":[]},"aoS":{"a3":[],"l":[]},"auQ":{"aC":[]},"amV":{"aC":[]}}'))
var y={a:A.ae("H<f6>"),u:A.ae("H<l>"),h:A.ae("H<a2>"),w:A.ae("o"),o:A.ae("lG<zw>"),q:A.ae("pj"),e:A.ae("O"),v:A.ae("~")};(function constants(){var x=a.makeConstList
D.bqU=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.aM,null,null,null,null,null,null,null,null)
D.aaV=new A.ch(C.P,null,null,D.bqU,null)
D.aea=new A.T(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.aiP=new A.bG(3e6)
D.bh9=new A.q(!0,C.an,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bv6=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.bh9,null,null,null,null,null,null,null,null)
D.amu=new E.dD(D.bv6,C.a4,C.aJ,null,!1,null)
D.aq4=new A.E(K.HF,null,C.v,null,null,null)
D.ast=new A.E(C.Hq,null,null,null,null,null)
D.aux=new A.E(C.h9,null,C.an,null,null,null)
D.aB3=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ae("H<o>"))
D.aSD=new A.d1([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ae("d1<x,o>"))
D.at2=new A.E(C.yg,34,C.i,null,null,null)
D.aYy=new A.qs(null,0,null,null,null,null,D.at2,null)
D.a0A=new A.V(290,290)
D.bdJ=new A.q(!0,C.an,null,null,null,null,13,null,null,null,null,null,1.8,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bkK=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633 \u0648\u062c\u0631\u0627\u0628 \u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.aM,C.Z,null,null,null,null,null,null,null)
D.bma=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.btZ=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.eP,null,null,null,null,null,null,null,null)
D.anL=new A.Q(62812,"MaterialIcons",null,!1)
D.bHq=new B.Z3(D.anL,"\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u062d\u062a\u0627\u062c\u0629 \u0645\u0639\u0627\u064a\u0631\u0629: \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0639\u0644\u0649 \u0634\u0643\u0644 8 \u0641\u064a \u0627\u0644\u0647\u0648\u0627 \u0643\u0627\u0645 \u0645\u0631\u0629",null)
D.apA=new A.Q(985111,"MaterialIcons",null,!1)
D.bHr=new B.Z3(D.apA,"\u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0641\u0631\u0648\u062f (\u0645\u0633\u0637\u0651\u062d \u0632\u064a \u0627\u0644\u0635\u064a\u0646\u064a\u0629) \u0639\u0634\u0627\u0646 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u064a\u0628\u0642\u0649 \u0645\u0638\u0628\u0648\u0637",null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cQb","cqx",()=>A.cby())})()};
(a=>{a["KdBupVz3StnfBaCUMmhgEbkyk48="]=a.current})($__dart_deferred_initializers__);