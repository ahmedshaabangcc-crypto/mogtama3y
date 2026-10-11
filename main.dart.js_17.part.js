((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,H,B={
F0(d){var x,w,v
if(d==null)return null
try{x=A.dT(d)
w=isNaN(x)?null:x
return w}catch(v){return null}},
aCb:function aCb(d){var _=this
_.a=d
_.d=_.c=_.b=null
_.r=_.f=_.e=!1
_.w=null},
aCd:function aCd(d){this.a=d},
aCe:function aCe(d){this.a=d},
aCc:function aCc(d){this.a=d},
chy(d,e){var x=d*3.141592653589793/180,w=(39.8262-e)*3.141592653589793/180
return B.E9(Math.atan2(Math.sin(w)*Math.cos(0.37389315900848524),Math.cos(x)*Math.sin(0.37389315900848524)-Math.sin(x)*Math.cos(0.37389315900848524)*Math.cos(w))*180/3.141592653589793)},
E9(d){var x=C.f.a0(d,360)
return x<0?x+360:x},
chU(d,e){var x=B.E9(d-e)
return x>=180?x-360:x},
cB6(d){var x,w,v,u,t,s=d.length
if(s<2)return 0
for(x=0,w=0,v=0;v<d.length;d.length===s||(0,A.K)(d),++v){u=d[v]*3.141592653589793/180
x+=Math.cos(u)
w+=Math.sin(u)}t=Math.sqrt(x*x+w*w)/d.length
if(t>=1)return 0
if(t<=1e-9)return 180
return Math.sqrt(-2*Math.log(t))*180/3.141592653589793},
aIQ:function aIQ(d){this.a=d
this.c=this.b=null},
yT:function yT(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
crV(){return new B.wo(null)},
wo:function wo(d){this.a=d},
ZL:function ZL(d,e,f,g,h,i,j){var _=this
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
bFt:function bFt(d){this.a=d},
bFs:function bFs(d){this.a=d},
bFp:function bFp(){},
bFq:function bFq(d){this.a=d},
bFo:function bFo(){},
bFj:function bFj(d){this.a=d},
bFk:function bFk(d){this.a=d},
bFl:function bFl(d){this.a=d},
bFm:function bFm(d,e){this.a=d
this.b=e},
bFn:function bFn(d){this.a=d},
bFr:function bFr(d,e){this.a=d
this.b=e},
XG:function XG(d,e,f){this.c=d
this.d=e
this.a=f},
amV:function amV(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
asP:function asP(d){this.a=d},
al_:function al_(d,e){this.b=d
this.a=e}},D,I,K,F,L,M,E,G
J=c[1]
A=c[0]
C=c[2]
H=c[15]
B=a.updateHolder(c[5],B)
D=c[31]
I=c[12]
K=c[34]
F=c[33]
L=c[32]
M=c[29]
E=c[16]
G=c[18]
B.aCb.prototype={
jJ(){var x=0,w=A.k(y.e),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$jJ=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
n=b.G
r=A.k5(n.DeviceOrientationEvent)
if(r==null||r.requestPermission==null){n=A.k5(n.DeviceOrientationEvent)
v=n!=null
x=1
break}x=7
return A.c(A.eF(A.cV(A.cM(r,"requestPermission",null,null,null,null)),y.w),$async$jJ)
case 7:q=e
p=q==="granted"
if(p)s.N8()
v=p
x=1
break
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a9(l)
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
return A.j($async$jJ,w)},
aiB(){var x,w,v,u,t,s
try{u=b.G
x=A.k5(u.screen)
t=x
w=A.k5(t==null?null:t.orientation)
t=w
v=B.F0(t==null?null:t.angle)
if(v!=null)return v
u=B.F0(u.orientation)
if(u==null)u=0
return u}catch(s){return 0}},
aUG(d){var x,w,v,u,t,s,r,q,p,o,n=this,m="deviceorientationabsolute"
if(n.f)return
try{x=B.F0(d.beta)
w=B.F0(d.gamma)
v=B.F0(d.webkitCompassHeading)
if(v!=null){n.w=new A.aY(Date.now(),0,!1)
n.a.F(0,new B.yT(B.E9(v+n.aiB()),B.F0(d.webkitCompassAccuracy),x,w))
return}u=B.F0(d.alpha)
if(u==null)return
r=A.u(d.type)
t=r==null?null:r
if(!J.f(t,m)){q=A.em(d.absolute)
if(q==null)q=null
p=q===!0}else p=!0
s=p
if(!s)return
if(J.f(t,m))n.r=!0
else if(n.r)return
n.w=new A.aY(Date.now(),0,!1)
n.a.F(0,new B.yT(B.E9(360-u+n.aiB()),null,x,w))}catch(o){}},
o1(){var x,w,v,u=this,t=null,s="addEventListener"
if(u.e||u.f)return
u.e=!0
u.N8()
x=u.c=A.cfe(new B.aCd(u))
w=b.G
v=A.k5(w.document)
if(v!=null)A.cM(v,s,"visibilitychange",x,t,t)
A.cM(w,s,"pageshow",x,t,t)
u.d=A.hK(C.pI,new B.aCe(u))},
N8(){var x,w,v=this,u=null,t="addEventListener"
if(v.f)return
v.ach()
x=v.b=A.fN(new B.aCc(v))
w=b.G
if("ondeviceorientationabsolute" in w)A.cM(w,t,"deviceorientationabsolute",x,u,u)
A.cM(w,t,"deviceorientation",x,u,u)},
ach(){var x,w=null,v="removeEventListener",u=this.b
if(u==null)return
x=b.G
A.cM(x,v,"deviceorientationabsolute",u,w,w)
A.cM(x,v,"deviceorientation",u,w,w)
this.b=null},
m(){var x,w,v,u=this,t=null,s="removeEventListener"
if(u.f)return
u.f=!0
x=u.d
if(x!=null)x.aD()
u.ach()
w=u.c
if(w!=null){x=b.G
v=A.k5(x.document)
if(v!=null)A.cM(v,s,"visibilitychange",w,t,t)
A.cM(x,s,"pageshow",w,t,t)}u.a.bC()}}
B.aIQ.prototype={}
B.yT.prototype={}
B.wo.prototype={
P(){var x=$.cjR().a,w=x[1],v=x[2]
x=x[0]
return new B.ZL(w,v,x+" (\u062a\u0642\u0631\u064a\u0628\u064a)",new B.aCb(new A.lt(null,null,y.o)),new B.aIQ(0.2),A.a([],y.h),new A.aY(A.l_(0,0,!1),0,!1))}}
B.ZL.prototype={
X(){var x,w,v,u=this
u.Y()
x=A.k5(b.G.DeviceOrientationEvent)
u.ch=x!=null&&x.requestPermission!=null
w=u.w
v=w.a
u.z=new A.fj(v,A.y(v).i("fj<1>")).jd(u.gaUY())
w.o1()
u.cx=A.cO(D.agX,new B.bFt(u))
u.H9()},
m(){var x=this,w=x.cx
if(w!=null)w.aD()
w=x.cy
if(w!=null)w.aD()
w=x.z
if(w!=null)w.aD()
x.w.m()
x.a1()},
aUZ(d){var x,w,v,u,t,s,r,q,p,o=this
if(o.c==null)return
x=o.y
w=d.a
x.push(w)
if(x.length>15)C.b.kk(x,0)
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
w=u}else v=s}w=B.E9(Math.atan2(v,w)*180/3.141592653589793)
w.toString
q=Math.abs(B.chU(B.chy(o.d,o.e),w))<=5
if(q&&!o.CW)A.c1_(80)
v=o.Q
o.Q=w
o.CW=q
o.as=d.b
w=d.c
s=d.d
if(!(w!=null&&Math.abs(w)>35))w=s!=null&&Math.abs(s)>35
else w=!0
o.at=w
o.ax=x.length>=10&&B.cB6(x)>12
o.ay=o.ch=!1
p=new A.aY(Date.now(),0,!1)
if(v==null||p.dF(o.db).a>33e3){o.db=p
x=o.cy
if(x!=null)x.aD()
o.cy=null
o.k(new B.bFp())}else if(o.cy==null)o.cy=A.cO(C.Es,new B.bFq(o))},
MN(){var x=0,w=A.k(y.v),v,u=this,t,s
var $async$MN=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.w
x=3
return A.c(t.jJ(),$async$MN)
case 3:s=e
if(u.c==null){x=1
break}if(s){u.k(new B.bFj(u))
t.o1()}else{u.k(new B.bFk(u))
u.c.I(y.q).f.Z(A.aT(null,null,null,null,null,C.m,null,A.d("\u0645\u0646 \u063a\u064a\u0631 \u0625\u0630\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0647\u0646\u0648\u0631\u064a\u0643 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0628\u0627\u0644\u062f\u0631\u062c\u0627\u062a \u0628\u0633",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))}case 1:return A.i(v,w)}})
return A.j($async$MN,w)},
H9(){var x=0,w=A.k(y.v),v,u=2,t=[],s=[],r=this,q,p,o,n
var $async$H9=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:r.k(new B.bFl(r))
u=4
x=7
return A.c(A.k1(),$async$H9)
case 7:q=e
if(r.c==null){s=[1]
x=5
break}r.k(new B.bFm(r,q))
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
if(r.c!=null)r.k(new B.bFn(r))
x=s.pop()
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$H9,w)},
Pl(){var x=0,w=A.k(y.v),v,u=this,t,s
var $async$Pl=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.c
s.toString
x=3
return A.c(I.chn(s),$async$Pl)
case 3:t=e
if(t==null||u.c==null){x=1
break}u.k(new B.bFr(u,t))
case 1:return A.i(v,w)}})
return A.j($async$Pl,w)},
t(d){var x,w,v,u,t,s,r,q,p=this,o=null,n=B.chy(p.d,p.e),m=p.Q,l=m==null,k=!l,j=k?B.chU(n,m):0,i=k&&p.CW,h=p.as
if(h!=null)x=h<0||h>25
else x=!1
h=y.u
w=A.a([D.ao4,C.K,A.R(A.d(p.f,o,o,o,o,C.bz,o,o,o),1)],h)
if(p.r)w.push(L.tA)
else w.push(A.bU(o,o,o,o,D.asi,o,o,p.gaYa(),o,o,o,"\u062d\u062f\u0651\u062f \u0645\u0643\u0627\u0646\u064a",o))
w.push(A.be(D.bqi,o,o,p.gaXw(),o,o))
w=A.A(w,C.h,C.d,C.e,0,o,o)
v=l?0:m
v=A.bO(A.ao(new B.amV(v,k?j:n,i,o),290,290),o,o)
u=A.d("\u0627\u0644\u0642\u0628\u0644\u0629 \u0639\u0644\u0649 "+(E.bm(C.j.a0(C.f.aw(B.E9(n)),360))+"\xb0")+" \u0645\u0646 \u0627\u0644\u0634\u0645\u0627\u0644",o,o,o,o,M.a0l,C.Y,o,o)
t=D.ayF[C.j.a0(C.f.aJ(B.E9(n)+22.5,45),8)]
s=p.d
r=p.e
q=Math.pow(Math.sin((21.4225-s)*3.141592653589793/180/2),2)+Math.cos(s*3.141592653589793/180)*Math.cos(0.37389315900848524)*Math.pow(Math.sin((39.8262-r)*3.141592653589793/180/2),2)
t=A.a([new E.dv(w,C.a3,C.aJ,o,!1,o),C.I,v,C.a0,u,A.d("\u0646\u0627\u062d\u064a\u0629 "+t+" \u2022 \u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0644\u0644\u0643\u0639\u0628\u0629 \u062d\u0648\u0627\u0644\u064a "+E.bm(C.f.aw(12742*Math.atan2(Math.sqrt(q),Math.sqrt(1-q))))+" \u0643\u0645",o,o,o,o,G.aK,C.Y,o,o)],h)
if(k){w=E.bm(C.j.a0(C.f.aw(B.E9(m)),360))
v=p.as
v=v!=null&&v>=0?" \u2022 \u062f\u0642\u0629 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \xb1"+E.bm(C.f.aw(v))+"\xb0":""
t.push(A.d("\u0627\u062a\u062c\u0627\u0647 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u062f\u0644\u0648\u0642\u062a\u064a "+(w+"\xb0")+v,o,o,o,o,D.bam,C.Y,o,o))}t.push(C.a1)
if(p.ch&&l)C.b.A(t,A.a([A.ft(D.aqk,D.biI,p.gaEa(),A.eA(C.v,C.af,o,o,o)),C.u],h))
if(k){l=i?"aligned":"turn "+C.f.aw(j)
if(i)h="\u062a\u0645\u0627\u0645! \u0625\u0646\u062a \u062f\u0644\u0648\u0642\u062a\u064a \u0645\u062a\u0648\u062c\u0651\u0647 \u0644\u0644\u0642\u0628\u0644\u0629 \u2713"
else{h=Math.abs(j)
h=j>0?"\u0644\u0641\u0651 \u064a\u0645\u064a\u0646 "+E.bm(C.f.aw(h))+"\xb0":"\u0644\u0641\u0651 \u0634\u0645\u0627\u0644 "+E.bm(C.f.aw(h))+"\xb0"}t.push(A.bQ(o,o,o,new E.dv(A.d(h,o,o,o,o,A.bI(o,o,i?F.cJ:C.i,o,o,o,o,o,o,o,o,16,o,o,C.T,o,o,!0,o,o,o,o,o,o,o,o),C.Y,o,o),C.a3,C.aJ,o,i,o),!1,o,o,o,!1,o,!1,o,o,o,o,o,o,o,o,o,o,l,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,C.a4,o))}else if(p.ay&&!p.ch)t.push(D.akx)
else if(!p.ch)t.push(D.a9e)
if(k&&p.at)t.push(D.bD4)
if(k)l=x||p.ax
else l=!1
if(l)t.push(D.bD3)
t.push(C.u)
t.push(D.bhm)
return H.x8(o,t,"\u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629")}}
B.XG.prototype={
t(d){var x=null
return new E.dv(A.A(A.a([A.b4(this.c,C.v,x,22),C.X,A.R(A.d(this.d,x,x,x,x,F.a0q,x,x,x),1)],y.u),C.h,C.d,C.e,0,x,x),C.a3,C.aJ,x,!1,x)}}
B.amV.prototype={
t(d){var x,w=null,v=this.e,u=v?F.cJ:C.v,t=A.ahD(-this.c*3.141592653589793/180,A.hi(w,w,w,new B.asP(w),D.a_u)),s=this.d,r=C.f.aw(s)
r=A.bQ(w,w,w,A.ahD(s*3.141592653589793/180,A.hi(w,w,w,new B.al_(u,w),D.a_u)),!1,w,w,w,!1,w,!1,w,w,w,w,w,w,w,w,w,w,"qibla-arrow "+r,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,C.a4,w)
s=v?u:C.cU
x=A.aH(u,2)
return A.ds(C.P,A.a([t,r,D.aVB,A.D(w,A.b4(C.h1,v?C.af:C.v,w,w),C.k,w,w,new A.E(s,w,x,w,w,w,w,C.bZ),w,54,w,w,w,w,54)],y.u),C.m,C.bj,w)}}
B.asP.prototype={
aQ(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=null,i=e.ju(C.z),h=e.gfe()/2-18
$.aq()
x=A.bo()
x.r=C.i.ae(0.06).gu()
d.iP(i,h,x)
x=A.bo()
x.b=C.c6
x.r=C.ig.gu()
x.c=2
d.iP(i,h,x)
for(x=d.a,w=i.a,v=i.b,u=0;u<360;u+=10){t=(u-90)*3.141592653589793/180
s=C.j.a0(u,90)===0
r=Math.cos(t)
q=Math.sin(t)
p=Math.cos(t)
o=Math.sin(t)
n=h-(s?14:7)
m=new A.lN(C.dr,C.dh,C.fE,C.he,C.e9)
m.r=(s?C.i:C.eL).gu()
m.c=s?2.5:1.2
l=m.eH()
x.drawLine.apply(x,[w+r*h,v+q*h,w+p*n,v+o*n,l])
l.delete()}for(x=D.aPX.gcK(),x=x.ga_(x),r=h-28;x.v();){q=x.gJ()
p=q.a
t=(p-90)*3.141592653589793/180
q=q.b
p=p===0?D.act:C.ap
k=new A.qs(new A.eX(q,j,j,C.bx,j,j,j,j,j,j,new A.r(!0,p,j,j,j,j,16,C.U,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j)),C.t,C.bg,new A.ii(1),j,j,j,j,C.bH,j)
k.rU()
q=Math.cos(t)
p=Math.sin(t)
o=k.b
k.aQ(d,new A.w(w+q*r-o.c/2,v+p*r-o.a.c.gcO()/2))}},
f4(d){return!1}}
B.al_.prototype={
aQ(d,e){var x,w,v,u,t,s=e.ju(C.z),r=e.gfe()/2-18,q=s.a5(0,C.ll.aC(0,r+12)),p=$.aq(),o=A.bo(),n=this.b
o.r=n.gu()
x=s.a5(0,C.ll.aC(0,34))
w=s.a5(0,C.ll.aC(0,r-6))
v=A.bo()
v.r=n.gu()
v.c=5
v.d=C.k0
d.l5(x,w,v)
u=s.a5(0,C.ll.aC(0,r-14))
t=new A.cI(p.r,C.aD,null,null,A.a([],y.a))
t.aO(new A.fT(q.a,q.b))
t.aO(new A.dh(u.a5(0,C.ha.aC(0,11)).a,u.a5(0,C.ha.aC(0,11)).b))
t.aO(new A.dh(u.ad(0,C.ha.aC(0,11)).a,u.ad(0,C.ha.aC(0,11)).b))
t.aO(new A.mN())
d.hq(t,o)},
f4(d){return!d.b.l(0,this.b)}}
var z=a.updateTypes(["aj<~>()","~(yT)"])
B.aCd.prototype={
$0(){var x,w,v=this.a
if(v.f)return
x=A.k5(b.G.document)
w=A.u(x==null?null:x.visibilityState)
if((w==null?null:w)==="visible")v.N8()},
$S:24}
B.aCe.prototype={
$1(d){var x=this.a,w=x.w
if(w!=null&&new A.aY(Date.now(),0,!1).dF(w).a>3e6){x.w=new A.aY(Date.now(),0,!1)
x.N8()}},
$S:31}
B.aCc.prototype={
$1(d){return this.a.aUG(d)},
$S:5}
B.bFt.prototype={
$0(){var x=this.a
if(x.c!=null&&x.Q==null)x.k(new B.bFs(x))},
$S:0}
B.bFs.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bFp.prototype={
$0(){},
$S:0}
B.bFq.prototype={
$0(){var x=this.a
x.cy=null
x.db=new A.aY(Date.now(),0,!1)
if(x.c!=null)x.k(new B.bFo())},
$S:0}
B.bFo.prototype={
$0(){},
$S:0}
B.bFj.prototype={
$0(){return this.a.ch=!1},
$S:0}
B.bFk.prototype={
$0(){return this.a.ay=!0},
$S:0}
B.bFl.prototype={
$0(){return this.a.r=!0},
$S:0}
B.bFm.prototype={
$0(){var x=this.a,w=this.b
x.d=w.a
x.e=w.b
x.f="\u0645\u0643\u0627\u0646\u0643 \u0627\u0644\u062d\u0627\u0644\u064a"},
$S:0}
B.bFn.prototype={
$0(){return this.a.r=!1},
$S:0}
B.bFr.prototype={
$0(){var x=this.a,w=this.b
x.d=w.b
x.e=w.c
x.f=w.gmJ()},
$S:0};(function installTearOffs(){var x=a._instance_1u,w=a._instance_0u
var v
x(v=B.ZL.prototype,"gaUY","aUZ",1)
w(v,"gaEa","MN",0)
w(v,"gaYa","H9",0)
w(v,"gaXw","Pl",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a5,[B.aCb,B.aIQ,B.yT])
x(A.kW,[B.aCd,B.bFt,B.bFs,B.bFp,B.bFq,B.bFo,B.bFj,B.bFk,B.bFl,B.bFm,B.bFn,B.bFr])
x(A.ir,[B.aCe,B.aCc])
w(B.wo,A.L)
w(B.ZL,A.M)
x(A.a3,[B.XG,B.amV])
x(A.F8,[B.asP,B.al_])})()
A.oZ(b.typeUniverse,JSON.parse('{"wo":{"L":[],"l":[]},"ZL":{"M":["wo"]},"XG":{"a3":[],"l":[]},"amV":{"a3":[],"l":[]},"asP":{"aC":[]},"al_":{"aC":[]}}'))
var y={a:A.ae("F<f_>"),u:A.ae("F<l>"),h:A.ae("F<a2>"),w:A.ae("o"),o:A.ae("lt<yT>"),q:A.ae("oW"),e:A.ae("P"),v:A.ae("~")};(function constants(){var x=a.makeConstList
D.bnj=new A.m("\u0628\u0646\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0627\u0644\u0628\u0648\u0635\u0644\u0629\u2026",null,G.aK,null,null,null,null,null,null,null,null)
D.a9e=new A.cf(C.P,null,null,D.bnj,null)
D.act=new A.U(1,1,0.4196078431372549,0.4196078431372549,C.p)
D.agX=new A.bF(3e6)
D.bdK=new A.r(!0,C.ap,null,null,null,null,13,null,null,null,null,null,1.7,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.brk=new A.m("\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u0634 \u0645\u062a\u0627\u062d\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u0623\u0648 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647. \u062d\u0637 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0648\u062c\u0651\u0647 \u062d\u0631\u0641 \xab\u0634\xbb (\u0627\u0644\u0634\u0645\u0627\u0644) \u0646\u0627\u062d\u064a\u0629 \u0627\u0644\u0634\u0645\u0627\u0644 \u2014 \u062a\u0642\u062f\u0631 \u062a\u0639\u0631\u0641\u0647 \u0645\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u062e\u0631\u0627\u0626\u0637 \u0623\u0648 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u2014 \u0648\u0627\u0644\u0633\u0647\u0645 \u0627\u0644\u062f\u0647\u0628\u064a \u0647\u064a\u0628\u0642\u0649 \u0627\u062a\u062c\u0627\u0647 \u0627\u0644\u0642\u0628\u0644\u0629.",null,D.bdK,null,null,null,null,null,null,null,null)
D.akx=new E.dv(D.brk,C.a3,C.aJ,null,!1,null)
D.ao4=new A.G(K.GC,null,C.v,null,null,null)
D.aqk=new A.G(C.Go,null,null,null,null,null)
D.asi=new A.G(C.hD,null,C.ap,null,null,null)
D.ayF=x(["\u0627\u0644\u0634\u0645\u0627\u0644","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u0634\u0631\u0642","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u0634\u0631\u0642\u064a","\u0627\u0644\u062c\u0646\u0648\u0628","\u0627\u0644\u062c\u0646\u0648\u0628 \u0627\u0644\u063a\u0631\u0628\u064a","\u0627\u0644\u063a\u0631\u0628","\u0627\u0644\u0634\u0645\u0627\u0644 \u0627\u0644\u063a\u0631\u0628\u064a"],A.ae("F<o>"))
D.aPX=new A.cZ([0,"\u0634",90,"\u0642",180,"\u062c",270,"\u063a"],A.ae("cZ<x,o>"))
D.aqT=new A.G(C.Gd,34,C.i,null,null,null)
D.aVB=new A.q0(null,0,null,null,null,null,D.aqT,null)
D.a_u=new A.T(290,290)
D.bam=new A.r(!0,C.ap,null,null,null,null,13,null,null,null,null,null,1.8,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhm=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0633\u0637\u0651\u062d \u0648\u0628\u0639\u064a\u062f \u0639\u0646 \u0627\u0644\u062d\u062f\u064a\u062f \u0648\u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633 \u0648\u062c\u0631\u0627\u0628 \u0627\u0644\u0645\u063a\u0646\u0627\u0637\u064a\u0633. \u0644\u0648 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u0645\u0634 \u062b\u0627\u0628\u062a \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0641\u064a \u0634\u0643\u0644 \u0631\u0642\u0645 8 \u0643\u0627\u0645 \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u062a\u062a\u0638\u0628\u0637.",null,G.aK,C.Y,null,null,null,null,null,null,null)
D.biI=new A.m("\u0634\u063a\u0651\u0644 \u0627\u0644\u0628\u0648\u0635\u0644\u0629",null,null,null,null,null,null,null,null,null,null)
D.bqi=new A.m("\u0645\u062f\u064a\u0646\u0629 \u062a\u0627\u0646\u064a\u0629",null,C.eF,null,null,null,null,null,null,null,null)
D.alM=new A.Q(62812,"MaterialIcons",null,!1)
D.bD3=new B.XG(D.alM,"\u0627\u0644\u0628\u0648\u0635\u0644\u0629 \u0645\u062d\u062a\u0627\u062c\u0629 \u0645\u0639\u0627\u064a\u0631\u0629: \u062d\u0631\u0651\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0639\u0644\u0649 \u0634\u0643\u0644 8 \u0641\u064a \u0627\u0644\u0647\u0648\u0627 \u0643\u0627\u0645 \u0645\u0631\u0629",null)
D.anC=new A.Q(985111,"MaterialIcons",null,!1)
D.bD4=new B.XG(D.anC,"\u0627\u0645\u0633\u0643 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0641\u0631\u0648\u062f (\u0645\u0633\u0637\u0651\u062d \u0632\u064a \u0627\u0644\u0635\u064a\u0646\u064a\u0629) \u0639\u0634\u0627\u0646 \u0627\u0644\u0627\u062a\u062c\u0627\u0647 \u064a\u0628\u0642\u0649 \u0645\u0638\u0628\u0648\u0637",null)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cIM","cjR",()=>A.c5p())})()};
(a=>{a["RdOYlB4SlNvbbLpZJRegTtQNmT8="]=a.current})($__dart_deferred_initializers__);