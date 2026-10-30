((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,H,B={
Gl(d){var x,w,v
if(d==null)return null
try{x=A.dU(d)
w=isNaN(x)?null:x
return w}catch(v){return null}},
aFG:function aFG(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.r=_.f=_.e=!1
_.w=null},
aFI:function aFI(d){this.a=d},
aFJ:function aFJ(d){this.a=d},
aFH:function aFH(d){this.a=d},
cqD(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.Fq(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
Fq(d){var x=C.f.a3(d,360)
return x<0?x+360:x},
cqY(d,e){var x=B.Fq(d-e)
return x>=180?x-360:x},
cKK(d){var x,w,v,u,t,s=d.length
if(s<2)return 0
for(x=0,w=0,v=0;v<d.length;d.length===s||(0,A.K)(d),++v){u=d[v]*3.141592653589793/180
x+=Math.cos(u)
w+=Math.sin(u)}t=Math.sqrt(x*x+w*w)/d.length
if(t>=1)return 0
if(t<=1e-9)return 180
return Math.sqrt(-2*Math.log(t))*180/3.141592653589793},
aMF:function aMF(d){this.a=d
this.c=this.b=null},
zP:function zP(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
cBm(){return new B.x6(null)},
x6:function x6(d){this.a=d},
a0T:function a0T(d,e,f,g,h,i,j){var _=this
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
bMi:function bMi(d){this.a=d},
bMh:function bMh(d){this.a=d},
bMd:function bMd(){},
bMe:function bMe(d){this.a=d},
bMc:function bMc(){},
bM7:function bM7(d){this.a=d},
bM8:function bM8(d){this.a=d},
bM9:function bM9(d){this.a=d},
bMa:function bMa(d,e){this.a=d
this.b=e},
bMb:function bMb(d){this.a=d},
bMf:function bMf(d,e){this.a=d
this.b=e},
bMg:function bMg(d){this.a=d},
ZM:function ZM(d,e,f){this.c=d
this.d=e
this.a=f},
apM:function apM(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
avN:function avN(d){this.a=d},
anP:function anP(d,e){this.b=d
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
B.aFG.prototype={
k7(){var x=0,w=A.j(y.e),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$k7=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
n=b.G
r=A.ks(n.DeviceOrientationEvent)
if(r==null||r.requestPermission==null){n=A.ks(n.DeviceOrientationEvent)
v=n!=null
x=1
break}x=7
return A.c(A.eH(A.cU(A.cP(r,"requestPermission",null,null,null,null)),y.w),$async$k7)
case 7:q=e
p=q==="granted"
if(p)s.O9()
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
al3(){var x,w,v,u,t,s
try{u=b.G
x=A.ks(u.screen)
t=x
w=A.ks(t==null?null:t.orientation)
t=w
v=B.Gl(t==null?null:t.angle)
if(v!=null)return v
u=B.Gl(u.orientation)
if(u==null)u=0
return u}catch(s){return 0}},
aJz(d){var x,w,v,u,t,s,r,q,p,o,n=this,m="deviceorientationabsolute"
if(n.f)return
try{x=B.Gl(d.beta)
w=B.Gl(d.gamma)
v=B.Gl(d.webkitCompassHeading)
if(v!=null){n.w=new A.aP(Date.now(),0,!1)
n.a.E(0,new B.zP(B.Fq(v+n.al3()),B.Gl(d.webkitCompassAccuracy),x,w))
return}u=B.Gl(d.alpha)
if(u==null)return
r=A.q(d.type)
t=r==null?null:r
if(!J.k(t,m)){q=A.en(d.absolute)
if(q==null)q=null
p=q===!0}else p=!0
s=p
if(!s)return
if(J.k(t,m))n.r=!0
else if(n.r)return
n.w=new A.aP(Date.now(),0,!1)
n.a.E(0,new B.zP(B.Fq(360-u+n.al3()),null,x,w))}catch(o){}},
op(){var x,w,v,u=this,t=null,s="addEventListener"
if(u.e||u.f)return
u.e=!0
u.O9()
x=u.c=A.co5(new B.aFI(u))
w=b.G
v=A.ks(w.document)
if(v!=null)A.cP(v,s,"visibilitychange",x,t,t)
A.cP(w,s,"pageshow",x,t,t)
u.d=A.he(C.nc,new B.aFJ(u))},
O9(){var x,w,v=this,u=null,t="addEventListener"
if(v.f)return
v.ael()
x=v.b=A.fX(new B.aFH(v))
w=b.G
if("ondeviceorientationabsolute" in w)A.cP(w,t,"deviceorientationabsolute",x,u,u)
A.cP(w,t,"deviceorientation",x,u,u)},
ael(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.cP(x,v,"deviceorientationabsolute",u,w,w)
A.cP(x,v,"deviceorientation",u,w,w)
this.b=null},
m(){var x,w,v,u=this,t=null,s="removeEventListener"
if(u.f)return
u.f=!0
x=u.d
if(x!=null)x.au()
u.ael()
w=u.c
if(w!=null){x=b.G
v=A.ks(x.document)
if(v!=null)A.cP(v,s,"visibilitychange",w,t,t)
A.cP(x,s,"pageshow",w,t,t)}u.a.bA()}}
B.aMF.prototype={}
B.zP.prototype={}
B.x6.prototype={
N(){var x=$.csY().a,w=x[1],v=x[2]
x=x[0]
return new B.a0T(w,v,x+" (\u062a\u0642\u0631\u064a\u0628\u064a)",new B.aFG(new A.lN(null,null,y.o)),new B.aMF(0.2),A.a([],y.h),new A.aP(A.kB(0,0,!1),0,!1))}}
B.a0T.prototype={
W(){var x,w,v,u=this
u.Y()
x=A.ks(b.G.DeviceOrientationEvent)
u.ch=x!=null&&x.requestPermission!=null
w=u.w
v=w.a
u.z=new A.fx(v,A.y(v).i("fx<1>")).jt(u.gaYC())
w.op()
u.cx=A.cQ(D.ajv,new B.bMi(u))
u.b10()},
m(){var x=this,w=x.cx
if(w!=null)w.au()
w=x.cy
if(w!=null)w.au()
w=x.z
if(w!=null)w.au()
x.w.m()
x.a0()},
aYD(d){var x,w,v,u,t,s,r,q,p,o=this
if(o.c==null)return
x=o.y
w=d.a
x.push(w)
if(x.length>15)C.b.kA(x,0)
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
w=u}else v=s}w=B.Fq(Math.atan2(v,w)*180/3.141592653589793)
w.toString
q=Math.abs(B.cqY(B.cqD(o.d,o.e),w))<=5
if(q&&!o.CW)A.c9q(80)
v=o.Q
o.Q=w
o.CW=q
o.as=d.b
w=d.c
s=d.d
if(!(w!=null&&Math.abs(w)>35))w=s!=null&&Math.abs(s)>35
else w=!0
o.at=w
o.ax=x.length>=10&&B.cKK(x)>12
o.ay=o.ch=!1
p=new A.aP(Date.now(),0,!1)
if(v==null||p.dD(o.db).a>33e3){o.db=p
x=o.cy
if(x!=null)x.au()
o.cy=null
o.j(new B.bMd())}else if(o.cy==null)o.cy=A.cQ(C.FE,new B.bMe(o))},
NM(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$NM=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.w
x=3
return A.c(t.k7(),$async$NM)
case 3:s=e
if(u.c==null){x=1
break}if(s){u.j(new B.bM7(u))
t.op()}else{u.j(new B.bM8(u))
u.c.H(y.q).f.Z(A.aM(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))}case 1:return A.h(v,w)}})
return A.i($async$NM,w)},
By(d){return this.aWh(d)},
b10(){return this.By(!1)},
aWh(d){var x=0,w=A.j(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$By=A.e(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:r.j(new B.bM9(r))
u=4
x=d?7:9
break
case 7:x=10
return A.c(A.jQ(!0),$async$By)
case 10:x=8
break
case 9:x=11
return A.c(A.DR(),$async$By)
case 11:case 8:q=f
if(r.c==null||q==null){s=[1]
x=5
break}r.j(new B.bMa(r,q))
s.push(6)
x=5
break
case 4:u=3
n=t.pop()
o=r.c
if(o!=null&&d)o.H(y.q).f.Z(A.aM(null,null,null,null,null,C.m,null,A.d("\u0645\u0642\u062f\u0631\u0646\u0627\u0634 \u0646\u062d\u062f\u062f \u0645\u0643\u0627\u0646\u0643 \u2014 \u0627\u062e\u062a\u0627\u0631 \u0645\u062f\u064a\u0646\u062a\u0643 \u0645\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
if(r.c!=null)r.j(new B.bMb(r))
x=s.pop()
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$By,w)},
Qu(){var x=0,w=A.j(y.v),v,u=this,t,s
var $async$Qu=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(I.cqq(s),$async$Qu)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.j(new B.bMf(u,t))
case 1:return A.h(v,w)}})
return A.i($async$Qu,w)},
t(d){var x,w,v,u,t,s,r,q,p=this,o=null,n=B.cqD(p.d,p.e),m=p.Q,l=m==null,k=!l,j=k?B.cqY(n,m):0,i=k&&p.CW,h=p.as
if(h!=null)x=h<0||h>25
else x=!1
h=y.u
w=A.a([D.aqS,C.O,A.R(A.d(p.f,o,o,o,o,o,C.bA,o,o,o),1)],h)
if(p.r)w.push(L.u8)
else w.push(A.bP(o,o,o,o,D.avi,o,o,new B.bMg(p),o,o,o,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",o))
w.push(A.bd(D.bvk,o,o,o,p.gb0h(),o,o))
w=A.z(w,C.h,C.d,C.e,0,o,o)
v=l?0:m
v=A.bL(A.am(new B.apM(v,k?j:n,i,o),290,290),o,o)
u=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+(E.bq(C.j.a3(C.f.ak(B.Fq(n)),360))+"\xb0")+" \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",o,o,o,o,o,M.a1L,C.Z,o,o)
t=D.aBU[C.j.a3(C.f.aI(B.Fq(n)+22.5,45),8)]
s=p.d
r=p.e
q=Math.pow(Math.sin((21.4225-s)*3.141592653589793/180/2),2)+Math.cos(s*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-r)*3.141592653589793/180/2),2)
t=A.a([new E.dE(w,C.a5,C.aL,o,!1,o),C.G,v,C.a1,u,A.d("\u0646\u0627\u062d\u064a\u0629 "+t+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bq(C.f.ak(12742*Math.atan2(Math.sqrt(q),Math.sqrt(1-q))))+" \u0643\u0645",o,o,o,o,o,G.aO,C.Z,o,o)],h)
if(k){w=E.bq(C.j.a3(C.f.ak(B.Fq(m)),360))
v=p.as
v=v!=null&&v>=0?" \u2022 \u062f\u0642\u0629 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \xb1"+E.bq(C.f.ak(v))+"\xb0":""
t.push(A.d("\u0627\u062a\u062c\u0627\u0647 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u062f\u0644\u0648\u0642\u062a\u064a "+(w+"\xb0")+v,o,o,o,o,o,D.bf8,C.Z,o,o))}t.push(C.a4)
if(p.ch&&l)C.b.A(t,A.a([A.fq(D.atg,D.bnz,p.gaHc(),A.et(C.t,C.ah,o,o,o,o,o)),C.v],h))
if(k){l=i?"aligned":"turn "+C.f.ak(j)
if(i)h="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{h=Math.abs(j)
h=j>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bq(C.f.ak(h))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bq(C.f.ak(h))+"\xb0"}t.push(A.bE(o,o,o,new E.dE(A.d(h,o,o,o,o,o,A.bB(o,o,i?F.cU:C.i,o,o,o,o,o,o,o,o,16,o,o,C.R,o,o,!0,o,o,o,o,o,o,o,o),C.Z,o,o),C.a5,C.aL,o,i,o),!1,o,o,o,!1,o,!1,o,o,o,o,o,o,o,o,o,o,l,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,C.a_,o))}else if(p.ay&&!p.ch)t.push(D.ani)
else if(!p.ch)t.push(D.abn)
if(k&&p.at)t.push(D.bIT)
if(k)l=x||p.ax
else l=!1
if(l)t.push(D.bIS)
t.push(C.v)
t.push(D.bma)
return H.xW(o,t,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.ZM.prototype={
t(d){var x=null
return new E.dE(A.z(A.a([A.aX(this.c,C.t,x,22),C.Y,A.R(A.d(this.d,x,x,x,x,x,F.a1N,x,x,x),1)],y.u),C.h,C.d,C.e,0,x,x),C.a5,C.aL,x,!1,x)}}
B.apM.prototype={
t(d){var x,w=null,v=this.e,u=v?F.cU:C.t,t=A.akq(-this.c*3.141592653589793/180,A.ha(w,w,w,new B.avN(w),D.a0T)),s=this.d,r=C.f.ak(s)
r=A.bE(w,w,w,A.akq(s*3.141592653589793/180,A.ha(w,w,w,new B.anP(u,w),D.a0T)),!1,w,w,w,!1,w,!1,w,w,w,w,w,w,w,w,w,w,"qibla-arrow "+r,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,C.a_,w)
s=v?u:C.cT
x=A.aI(u,2)
return A.dz(C.P,A.a([t,r,D.aZI,A.E(w,A.aX(C.ft,v?C.ah:C.t,w,w),C.k,w,w,new A.F(s,w,x,w,w,w,w,C.bW),w,54,w,w,w,w,w,54)],y.u),C.m,C.bm,w)}}
B.avN.prototype={
aQ(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=null,i=e.jl(C.A),h=e.gfu()/2-18
$.ap()
x=A.be()
x.r=C.i.aa(0.06).gu()
d.h1(i,h,x)
x=A.be()
x.b=C.bR
x.r=C.ir.gu()
x.c=2
d.h1(i,h,x)
for(x=d.a,w=i.a,v=i.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a3(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=h-(s?14:7)
m=new A.mc(C.dA,C.cY,C.fM,C.hq,C.eh)
m.r=(s?C.i:C.eX).gu()
m.c=s?2.5:1.2
l=m.es()
x.drawLine.apply(x,[w+r*h,v+q*h,w+p*n,v+o*n,l])
l.delete()}for(x=D.aTE.gcP(),x=x.ga_(x),r=h-28;x.v();){q=x.gG()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.aeD:C.ao
k=new A.r3(new A.eP(q,j,j,C.bu,j,j,j,j,j,j,new A.r(!0,p,j,j,j,j,16,C.T,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j)),C.u,C.b6,new A.iC(1),j,j,j,j,C.bJ,j)
k.tt()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aQ(d,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gd_()/2))}},
fj(d){return!1}}
B.anP.prototype={
aQ(d,e){var x,w,v,u,t,s=e.jl(C.A),r=e.gfu()/2-18,q=s.a6(0,C.lS.aD(0,r+12)),p=$.ap(),o=A.be(),n=this.b
o.r=n.gu()
x=s.a6(0,C.lS.aD(0,34))
w=s.a6(0,C.lS.aD(0,r-6))
v=A.be()
v.r=n.gu()
v.c=5
v.d=C.kg
d.ln(x,w,v)
u=s.a6(0,C.lS.aD(0,r-14))
t=new A.cT(p.r,C.aE,null,null,A.a([],y.a))
t.aP(new A.h3(q.a,q.b))
t.aP(new A.dD(u.a6(0,C.hl.aD(0,11)).a,u.a6(0,C.hl.aD(0,11)).b))
t.aP(new A.dD(u.ag(0,C.hl.aD(0,11)).a,u.ag(0,C.hl.aD(0,11)).b))
t.aP(new A.nc())
d.hk(t,o)},
fj(d){return!d.b.l(0,this.b)}}
var z=a.updateTypes(["al<~>()","~(zP)"])
B.aFI.prototype={
$0(){var x,w,v=this.a
if(v.f)return
x=A.ks(b.G.document)
w=A.q(x==null?null:x.visibilityState)
if((w==null?null:w)==="visible")v.O9()},
$S:26}
B.aFJ.prototype={
$1(d){var x=this.a,w=x.w
if(w!=null&&new A.aP(Date.now(),0,!1).dD(w).a>3e6){x.w=new A.aP(Date.now(),0,!1)
x.O9()}},
$S:28}
B.aFH.prototype={
$1(d){return this.a.aJz(d)},
$S:6}
B.bMi.prototype={
$0(){var x=this.a
if(x.c!=null&&x.Q==null)x.j(new B.bMh(x))},
$S:0}
B.bMh.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bMd.prototype={
$0(){},
$S:0}
B.bMe.prototype={
$0(){var x=this.a
x.cy=null
x.db=new A.aP(Date.now(),0,!1)
if(x.c!=null)x.j(new B.bMc())},
$S:0}
B.bMc.prototype={
$0(){},
$S:0}
B.bM7.prototype={
$0(){return this.a.ch=!1},
$S:0}
B.bM8.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bM9.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bMa.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bMb.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bMf.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gn6()},
$S:0}
B.bMg.prototype={
$0(){return this.a.By(!0)},
$S:0};(function installTearOffs(){var x=a._instance_1u,w=a._instance_0u
var v
x(v=B.a0T.prototype,"gaYC","aYD",1)
w(v,"gaHc","NM",0)
w(v,"gb0h","Qu",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a6,[B.aFG,B.aMF,B.zP])
x(A.lk,[B.aFI,B.bMi,B.bMh,B.bMd,B.bMe,B.bMc,B.bM7,B.bM8,B.bM9,B.bMa,B.bMb,B.bMf,B.bMg])
x(A.iN,[B.aFJ,B.aFH])
w(B.x6,A.L)
w(B.a0T,A.N)
x(A.a3,[B.ZM,B.apM])
x(A.Gv,[B.avN,B.anP])})()
A.pv(b.typeUniverse,JSON.parse('{"x6":{"L":[],"l":[]},"a0T":{"N":["x6"]},"ZM":{"a3":[],"l":[]},"apM":{"a3":[],"l":[]},"avN":{"aD":[]},"anP":{"aD":[]}}'))
var y={a:A.ae("H<f6>"),u:A.ae("H<l>"),h:A.ae("H<a2>"),w:A.ae("o"),o:A.ae("lN<zP>"),q:A.ae("ps"),e:A.ae("M"),v:A.ae("~")};(function constants(){var x=a.makeConstList
D.bsg=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.aO,null,null,null,null,null,null,null,null)
D.abn=new A.ch(C.P,null,null,D.bsg,null)
D.aeD=new A.U(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.ajv=new A.bF(3e6)
D.biC=new A.r(!0,C.ao,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bwq=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.biC,null,null,null,null,null,null,null,null)
D.ani=new E.dE(D.bwq,C.a5,C.aL,null,!1,null)
D.aqS=new A.G(K.HV,null,C.t,null,null,null)
D.atg=new A.G(C.HF,null,null,null,null,null)
D.avi=new A.G(C.hc,null,C.ao,null,null,null)
D.aBU=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ae("H<o>"))
D.aTE=new A.d0([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ae("d0<x,o>"))
D.atQ=new A.G(C.yq,34,C.i,null,null,null)
D.aZI=new A.qD(null,0,null,null,null,null,D.atQ,null)
D.a0T=new A.W(290,290)
D.bf8=new A.r(!0,C.ao,null,null,null,null,13,null,null,null,null,null,1.8,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bma=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633 \u0648\u062c\u0631\u0627\u0628 \u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.aO,C.Z,null,null,null,null,null,null,null)
D.bnz=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.bvk=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.eS,null,null,null,null,null,null,null,null)
D.aox=new A.Q(62812,"MaterialIcons",null,!1)
D.bIS=new B.ZM(D.aox,"\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u062d\u062a\u0627\u062c\u0629 \u0645\u0639\u0627\u064a\u0631\u0629: \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0639\u0644\u0649 \u0634\u0643\u0644 8 \u0641\u064a \u0627\u0644\u0647\u0648\u0627 \u0643\u0627\u0645 \u0645\u0631\u0629",null)
D.aqm=new A.Q(985111,"MaterialIcons",null,!1)
D.bIT=new B.ZM(D.aqm,"\u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0641\u0631\u0648\u062f (\u0645\u0633\u0637\u0651\u062d \u0632\u064a \u0627\u0644\u0635\u064a\u0646\u064a\u0629) \u0639\u0634\u0627\u0646 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u064a\u0628\u0642\u0649 \u0645\u0638\u0628\u0648\u0637",null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cSL","csY",()=>A.cdV())})()};
(a=>{a["XZsjWKTectLX9JAOaPyOV7Eq5HY="]=a.current})($__dart_deferred_initializers__);