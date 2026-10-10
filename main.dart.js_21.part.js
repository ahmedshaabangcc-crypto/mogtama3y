((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,O,M,P,N,G,I,B={
coe(d){var x,w,v,u,t,s
if(d instanceof B.l8)return d
try{x=A.eE(d)
w=x.code
v=x.message
u=w==null?"failed":A.a0(w)
t=v==null?"":A.a0(v)
return new B.l8(u,t)}catch(s){u=A.n(d)
return new B.l8("failed",u)}},
b0W:function b0W(){this.b=this.a=null},
b0X:function b0X(d){this.a=d},
b1_:function b1_(){},
b0Z:function b0Z(d,e,f){this.a=d
this.b=e
this.c=f},
b0Y:function b0Y(d){this.a=d},
b13:function b13(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
b11:function b11(d){this.a=d},
b12:function b12(d){this.a=d},
b14:function b14(d){this.a=d},
b16:function b16(d,e){this.a=d
this.b=e},
b15:function b15(d,e){this.a=d
this.b=e},
b10:function b10(){},
cof(d,e){return new B.l8(d,e)},
To:function To(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
I2:function I2(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
I4:function I4(d,e,f){this.a=d
this.b=e
this.c=f},
I3:function I3(d,e){this.a=d
this.b=e},
l8:function l8(d,e){this.a=d
this.b=e},
cb6(d){var x,w=$.cfy()
w=A.bR(d,w,"\u0627")
x=$.cfz()
w=A.bR(w,x,"\u064a")
x=$.cfI()
w=A.bR(w,x,"\u0627")
x=$.ce5()
w=A.bR(w,x,"\u0627")
x=$.cfe()
w=A.bR(w,x,"\u0621")
x=$.ceR()
w=A.bR(w,x,"\u0621")
x=$.ce6()
w=A.bR(w,x,"\u0627")
x=$.cec()
w=A.bR(w,x,"\u0621")
w=A.bR(w,"\u0649","\u064a")
w=A.bR(w,"\u0629","\u0647")
x=$.ceT()
w=A.bR(w,x,"")
x=$.cfh()
w=A.bR(w,x," ")
x=$.cf_()
w=A.bR(w,x," ")
x=$.c1v()
return C.c.R(A.bR(w,x," "))},
csQ(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.k7(x,w)
for(u=0;u<x;++u)v[u]=u
t=A.ch(x,0,!1,w)
for(s=1;s<=l;++s,r=t,t=v,v=r){t[0]=s
for(w=s-1,u=1;u<=k;++u){q=u-1
p=d.charCodeAt(w)===e.charCodeAt(q)?0:1
o=v[u]+1
n=t[q]+1
m=v[q]+p
if(o<n)q=o<m?o:m
else q=n<m?n:m
t[u]=q}}return v[k]},
bWH(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aW("[\u0627\u0621]",!0,!1,!1)
w=A.bR(d,x,"")
x=A.aW("[\u0627\u0621]",!0,!1,!1)
v=A.bR(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.csQ(d,e)/u
return s>=1?0.99:s},
bW_(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.vT(d,$.c1v()),w=x.length,v=0;v<x.length;x.length===w||(0,A.J)(x),++v){u=x[v]
if(u.length===0)continue
t=B.cb6(u)
s=A.bR(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Qt(r.a+" "+u,r.b))}continue}q.push(new B.Qt(u,s))}return q},
crD(d,e){var x,w,v,u,t=new B.bS_(),s=A.a([],y.s)
for(x=A.h0(e,0,A.jq(5,"count",y.S),A.ak(e).c),w=x.$ti,x=new A.cg(x,x.gL(0),w.i("cg<aY.E>")),w=w.i("aY.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.Il)&&t.$2(d,D.Il)?C.b.jN(d,5):d
return!t.$2(s,D.MU)&&t.$2(u,D.MU)?C.b.jN(u,4):u},
cad(d,e){var x=B.bW_(d),w=B.cb6(e),v=y.U
v=A.ab(new A.ap(A.a(w.split(" "),y.s),new B.bTU(),v),v.i("Y.E"))
return new B.GE(x,B.cqO(x,B.crD(v,x)),w)},
cqO(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.J)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.ch(x,0,!1,s)
q=A.ch(x,0,!1,y.S)
p=A.ch(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.bWH(a4[o],a6[n])
for(o=1;o<=v;++o){x=o*t
r[x]=o
q[x]=1}for(n=1;n<=u;++n){r[n]=n
q[n]=2}for(o=1;o<=v;++o)for(x=o*t,s=o>=2,m=o-1,l=m*t,k=m*u,j=o-2,i=j*t,n=1;n<=u;++n){h=l+n
g=r[h-1]+(1-p[k+n-1])
f=r[h]+1
if(f<g){g=f
e=1}else e=0
d=x+n
a0=r[d-1]+1
if(a0<g){g=a0
e=2}if(n>=2&&r[h-2]<g&&B.bWH(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.bWH(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
e=4}r[d]=g
q[d]=e}a1=A.a([],y.k)
n=u
o=v
for(;;){x=o>0
if(!(x||n>0))break
if(x&&n>0)e=q[o*t+n]
else e=x?1:2
switch(e){case 0:--o
a2=p[o*u+n-1]
x=a4[o];--n
s=a6[n]
if(a2>=1)m=D.iF
else m=a2>=0.6?D.tV:D.tW
a1.push(new B.ml(o,x,s,m))
break
case 1:--o
a1.push(new B.ml(o,a4[o],null,D.tX))
break
case 2:--n
a1.push(new B.ml(null,null,a6[n],D.a2_))
break
case 3:--o
a3=n-2
a1.push(new B.ml(o,a4[o],a6[a3]+" "+a6[n-1],D.iF))
n=a3
break
default:x=o-1;--n
a1.push(new B.ml(x,a4[x],a6[n],D.iF))
o-=2
a1.push(new B.ml(o,a4[o],a6[n],D.iF))}}a4=y.e
a4=A.ab(new A.d6(a1,a4),a4.i("aY.E"))
return a4},
mU:function mU(d,e){this.a=d
this.b=e},
Qt:function Qt(d,e){this.a=d
this.b=e},
ml:function ml(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
GE:function GE(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aSb:function aSb(d){this.a=d},
aSa:function aSa(){},
bS_:function bS_(){},
bTU:function bTU(){},
cgx(d,e,f){return new B.qy(d,e,f)},
ctI(d){var x
A:{if("memorized"===d){x=D.f0
break A}if("learning"===d){x=D.ow
break A}x=D.ov
break A}return x},
cbT(d,e){return d>=1&&d<=114&&e>=1&&e<=H.dp[d-1].a[1]},
cog(){var x=y.S
return new B.agh(A.B(x,y.u),A.aU(x))},
b19(d){var x=d.fO()
return C.c.dA(C.k.j(A.bv(x)),4,"0")+"-"+C.c.dA(C.k.j(A.bz(x)),2,"0")+"-"+C.c.dA(C.k.j(A.c9(x)),2,"0")},
c7l(d){var x=y.x,w=A.ab(new A.au(A.a(d.split("-"),y.s),A.cv2(),x),x.i("aY.E"))
return B.b19(A.dZ(w[0],w[1],w[2]-1,12,0,0,0))},
bZJ(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.B(p,y.u),n=A.aU(p),m=new B.agh(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcQ(),x=x.gZ(x),w=y.j;x.v();){v=x.gN()
u=A.el(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aT(t)>=3){v=C.k.aR(u,1000)
s=C.k.a3(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=H.dp[v-1].a[1])}if(v)continue
v=J.b7(t)
r=C.f.cu(A.dd(v.h(t,0)))
if(r<0||r>=3)continue
o.q(0,u,new B.qy(D.aG2[r],C.f.cu(A.dd(v.h(t,1))),new A.bq(A.lw(C.f.cu(A.dd(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.axb(q,y.o)
p=A.lS(x,new B.b18(),x.$ti.i("Y.E"),p)
n.A(0,new A.ap(p,o.ga21(),A.x(p).i("ap<Y.E>")))}m.c=A.v(d.h(0,"last"))
p=A.aR(d.h(0,"streak"))
p=p==null?null:C.f.cu(p)
p=m.d=p==null?0:p
o=A.aR(d.h(0,"best"))
o=o==null?null:C.f.cu(o)
m.e=o==null?p:o
return m},
awz(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dA(C.k.j(d),3,"0")+C.c.dA(C.k.j(e),3,"0")+".mp3"},
DI:function DI(d,e){this.a=d
this.b=e},
qy:function qy(d,e,f){this.a=d
this.b=e
this.c=f},
agh:function agh(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b1a:function b1a(){},
b1b:function b1b(){},
b18:function b18(){},
Tm:function Tm(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
clO(){return new B.vE(null)},
cxa(d,e){var x,w,v,u,t={},s=H.dp[e-1].a[1],r=$.KQ().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.qn():v).a===D.f0}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.k.dd(u+4,1,s)
return A.ef(C.di,new B.bVS(t,s,e),d,!0,null,null,y.l)},
c0q(d){return A.e0(0,0,0,0,0,C.k.dd(C.f.aA(6+d*1.2),25,90))},
c_u(d){return E.bK(C.k.aR(d,60))+":"+C.c.dA(E.bK(C.k.a3(d,60)),2,"\u0660")},
cbK(d){return A.ef(C.di,new B.bWo($.KQ()),d,!0,null,null,y.H)},
FL:function FL(d,e){this.a=d
this.b=e},
Tn:function Tn(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=null
_.e=!1
_.f=g
_.w=_.r=0
_.as=_.Q=_.z=_.y=_.x=null
_.at=!1
_.K$=0
_.p$=h
_.U$=_.S$=0},
b1c:function b1c(d){this.a=d},
b1d:function b1d(d){this.a=d},
b1e:function b1e(d){this.a=d},
vE:function vE(d){this.a=d},
YB:function YB(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bBK:function bBK(d){this.a=d},
bBJ:function bBJ(d,e){this.a=d
this.b=e},
bBL:function bBL(d){this.a=d},
bBI:function bBI(d,e){this.a=d
this.b=e},
bBM:function bBM(){},
bBw:function bBw(){},
bBC:function bBC(d,e,f){this.a=d
this.b=e
this.c=f},
bBD:function bBD(){},
bBG:function bBG(d){this.a=d},
bBF:function bBF(){},
bBH:function bBH(d){this.a=d},
bBz:function bBz(d,e){this.a=d
this.b=e},
bBA:function bBA(d){this.a=d},
bBy:function bBy(){},
bBB:function bBB(d){this.a=d},
bBx:function bBx(d){this.a=d},
bBE:function bBE(d,e){this.a=d
this.b=e},
FM:function FM(d,e,f){this.c=d
this.d=e
this.a=f},
VB:function VB(d,e){this.c=d
this.a=e},
bVS:function bVS(d,e,f){this.a=d
this.b=e
this.c=f},
bVP:function bVP(d,e,f){this.a=d
this.b=e
this.c=f},
bVR:function bVR(d,e){this.a=d
this.b=e},
bVO:function bVO(d,e){this.a=d
this.b=e},
bVN:function bVN(d,e){this.a=d
this.b=e},
bVQ:function bVQ(d,e){this.a=d
this.b=e},
bVJ:function bVJ(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
bVI:function bVI(d,e,f){this.a=d
this.b=e
this.c=f},
bVK:function bVK(d){this.a=d},
bVL:function bVL(d){this.a=d},
bVM:function bVM(d,e){this.a=d
this.b=e},
CM:function CM(d,e){this.a=d
this.b=e},
BS:function BS(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a_Z:function a_Z(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.at=_.as=_.Q=_.z=null
_.ax=0
_.c=_.a=null},
bOu:function bOu(){},
bOK:function bOK(d,e){this.a=d
this.b=e},
bOO:function bOO(d){this.a=d},
bOP:function bOP(d){this.a=d},
bOQ:function bOQ(d,e,f){this.a=d
this.b=e
this.c=f},
bOS:function bOS(d){this.a=d},
bOT:function bOT(d){this.a=d},
bOR:function bOR(){},
bOV:function bOV(d){this.a=d},
bOU:function bOU(d){this.a=d},
bOW:function bOW(d,e){this.a=d
this.b=e},
bOY:function bOY(d){this.a=d},
bOZ:function bOZ(d){this.a=d},
bOX:function bOX(){},
bOJ:function bOJ(d,e){this.a=d
this.b=e},
bOL:function bOL(d,e,f){this.a=d
this.b=e
this.c=f},
bOC:function bOC(d){this.a=d},
bOD:function bOD(d){this.a=d},
bOB:function bOB(){},
bOE:function bOE(){},
bOF:function bOF(d,e){this.a=d
this.b=e},
bP3:function bP3(d){this.a=d},
bP4:function bP4(d){this.a=d},
bP5:function bP5(d,e){this.a=d
this.b=e},
bP2:function bP2(d){this.a=d},
bOI:function bOI(){},
bOH:function bOH(d){this.a=d},
bOG:function bOG(d,e){this.a=d
this.b=e},
bON:function bON(d){this.a=d},
bOM:function bOM(d){this.a=d},
bP_:function bP_(){},
bP0:function bP0(){},
bP1:function bP1(){},
bOv:function bOv(d,e,f){this.a=d
this.b=e
this.c=f},
bOw:function bOw(d){this.a=d},
bOy:function bOy(){},
bOx:function bOx(){},
bOz:function bOz(d){this.a=d},
bOA:function bOA(d){this.a=d},
C7:function C7(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
BR:function BR(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a_Y:function a_Y(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.Q=_.z=_.y=null
_.as=h
_.c=_.a=null},
bOd:function bOd(){},
bOm:function bOm(d,e){this.a=d
this.b=e},
bOn:function bOn(d){this.a=d},
bOl:function bOl(){},
bOp:function bOp(d){this.a=d},
bOo:function bOo(d,e){this.a=d
this.b=e},
bOq:function bOq(d,e){this.a=d
this.b=e},
bOh:function bOh(d,e){this.a=d
this.b=e},
bOi:function bOi(d,e,f){this.a=d
this.b=e
this.c=f},
bOj:function bOj(d,e,f){this.a=d
this.b=e
this.c=f},
bOe:function bOe(d,e,f){this.a=d
this.b=e
this.c=f},
bOf:function bOf(d,e,f){this.a=d
this.b=e
this.c=f},
bOg:function bOg(d,e){this.a=d
this.b=e},
bOk:function bOk(d){this.a=d},
bOr:function bOr(){},
bOs:function bOs(d,e){this.a=d
this.b=e},
bOt:function bOt(d,e){this.a=d
this.b=e},
BQ:function BQ(d){this.a=d},
a_X:function a_X(d){this.d=d
this.c=this.a=null},
bO4:function bO4(){},
bOb:function bOb(d){this.a=d},
bOc:function bOc(){},
bOa:function bOa(d,e){this.a=d
this.b=e},
bO9:function bO9(d,e,f){this.a=d
this.b=e
this.c=f},
bO8:function bO8(d,e,f){this.a=d
this.b=e
this.c=f},
bO7:function bO7(d){this.a=d},
bO5:function bO5(d){this.a=d},
bO6:function bO6(d){this.a=d},
bWo:function bWo(d){this.a=d},
bWn:function bWn(d){this.a=d},
bWi:function bWi(d,e){this.a=d
this.b=e},
bWk:function bWk(){},
bWj:function bWj(){},
bWl:function bWl(d,e){this.a=d
this.b=e},
bWm:function bWm(d,e){this.a=d
this.b=e},
agg:function agg(d){this.a=d},
b0V:function b0V(d){this.a=d}},D,H,K,E,F
J=c[1]
A=c[0]
C=c[2]
L=c[15]
O=c[16]
M=c[23]
P=c[9]
N=c[18]
G=c[10]
I=c[27]
B=a.updateHolder(c[8],B)
D=c[28]
H=c[25]
K=c[11]
E=c[12]
F=c[14]
B.b0W.prototype={
qB(){var x=this,w=x.a
if(w!=null)return A.ed(w,y.m)
w=x.b
return w==null?x.b=new B.b0X(x).$0():w},
tN(d,e){return this.aK4(d,e,e)},
aK4(d,e,f){var x=0,w=A.k(f),v,u=2,t=[],s,r,q,p
var $async$tN=A.f(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$tN)
case 7:r=h
v=r
x=1
break
u=2
x=6
break
case 4:u=3
p=t.pop()
s=A.a9(p)
r=B.coe(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$tN,w)},
wf(d,e){var x=A.et(d[e])
if(x==null)x=null
return x===!0},
LS(){var x=0,w=A.k(y.O),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$LS=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
i=A
x=7
return A.c(s.qB(),$async$LS)
case 7:r=i.fH(e,"support",null,null,y.m)
q=s.wf(r,"worker")
p=s.wf(r,"wasm")
o=s.wf(r,"mic")
n=s.wf(r,"audio")
s.wf(r,"webgpu")
m=s.wf(r,"secure")
s.wf(r,"ios")
l=A.tJ(r.memory)
if(l==null)l=null
if(l==null)l=0
v=new B.To(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
j=t.pop()
v=D.a1A
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$LS,w)},
DG(){var x=0,w=A.k(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$DG=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
x=8
return A.c(s.qB(),$async$DG)
case 8:x=7
return A.c(m.eF(l.fH(e,"storage",null,null,y.m),y.A),$async$DG)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.aA(A.dB(r.quota))
p=C.f.aA(A.dB(r.usage))
v=new A.aq6(q,p)
x=1
break
u=2
x=6
break
case 4:u=3
n=t.pop()
v=null
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$DG,w)},
bev(){var x=y.K
A.NF(this.qB().bD(new B.b1_(),x),x)},
bbY(d,e){return this.tN(new B.b0Z(this,d,e),y.C)},
a7p(d,e,f,g){return this.tN(new B.b13(this,e,d,g,f),y.H)},
a7s(){return this.tN(new B.b14(this),y.D)},
a1F(){var x=this.a
if(x!=null)A.fH(x,"cancelRecording",null,null,y.X)},
ajs(d){var x,w,v=A.v(d.text)
if(v==null)v=null
if(v==null)v=""
x=A.tJ(d.ms)
x=x==null?null:C.f.aA(x)
if(x==null)x=0
w=A.tJ(d.seconds)
if(w==null)w=null
return new B.I4(v,x,w==null?0:w)},
asm(d){return this.tN(new B.b16(this,d),y._)},
bgC(d){return this.tN(new B.b15(this,d),y._)},
JY(d,e){return this.bez(d,e)},
bez(d,e){var x=0,w=A.k(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$JY=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.qB(),$async$JY)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.ak(d).i("au<1,o>")
o=A.ab(new A.au(d,new B.b10(),o),o.i("aY.E"))
x=11
return A.c(A.eF(A.fH(r,"play",o,e,y.m),y.y),$async$JY)
case 11:q=g
v=q
x=1
break
u=2
x=6
break
case 4:u=3
m=t.pop()
v=!1
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$JY,w)},
Lz(){var x=this.a
if(x!=null)A.fH(x,"stopPlayback",null,null,y.X)},
a4Y(d){var x=this.a
if(x!=null)A.fH(x,"prefetch",d,null,y.X)}}
B.To.prototype={}
B.I2.prototype={}
B.I4.prototype={}
B.I3.prototype={}
B.l8.prototype={
gih(){var x,w=this.a
A:{if("mic_denied"===w){x="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0645\u0634 \u0633\u0627\u0645\u062d \u0644\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643. \u0627\u0641\u062a\u062d \u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u0648\u0642\u0639 (\u0639\u0644\u0627\u0645\u0629 \u0627\u0644\u0642\u0641\u0644 \u062c\u0646\u0628 \u0627\u0644\u0639\u0646\u0648\u0627\u0646) \u0648\u0627\u0633\u0645\u062d \u0628\u0627\u0644\u0645\u064a\u0643\u0631\u0648\u0641\u0648\u0646\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
break A}if("no_mic"===w){x="\u0645\u0634 \u0644\u0627\u0642\u064a\u064a\u0646 \u0645\u0627\u064a\u0643 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647."
break A}if("mic_busy"===w){x="\u0627\u0644\u0645\u0627\u064a\u0643 \u0645\u0634\u063a\u0648\u0644 \u0641\u064a \u062a\u0637\u0628\u064a\u0642 \u062a\u0627\u0646\u064a (\u0645\u0643\u0627\u0644\u0645\u0629 \u0623\u0648 \u062a\u0633\u062c\u064a\u0644) \u2014 \u0627\u0642\u0641\u0644\u0647 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
break A}if("insecure"===w){x="\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https."
break A}if("unsupported"===w){x="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0623\u0648 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome \u0623\u0648 Safari."
break A}if("network"===w){x="\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
break A}if("memory"===w){x="\u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629 \u0644\u0644\u0645\u062d\u0641\u0651\u0638. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
break A}if("decode"===w){x="\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0642\u0631\u0627 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u2014 \u062c\u0631\u0651\u0628 \u062a\u0633\u062c\u0651\u0644 \u062a\u0627\u0646\u064a."
break A}x="\u062d\u0635\u0644\u062a \u0645\u0634\u0643\u0644\u0629 \u0641\u064a \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
break A}return x},
j(d){return"TutorError("+this.a+": "+this.b+")"},
$ibI:1}
B.mU.prototype={
P(){return"WordStatus."+this.b}}
B.Qt.prototype={}
B.ml.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.GE.prototype={
gLy(){var x,w=this,v=w.d
if(v===$){x=new B.aSb(w).$0()
w.d!==$&&A.am()
w.d=x
v=x}return v},
gIJ(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.J)(x),++v){u=x[v]
if(u.d===D.a2_&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbcN(){return J.fY(this.gLy(),new B.aSa()).gL(0)},
grS(){var x=this.a
return x.length!==0&&this.gbcN()===x.length&&this.gIJ().length===0}}
B.DI.prototype={
P(){return"AyahStatus."+this.b}}
B.qy.prototype={}
B.agh.prototype={
a4A(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.qn():x},
aWh(d){var x=this,w=B.b19(d),v=x.c
if(v===w)return
v=v!=null&&v===B.c7l(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
ane(){var x=Date.now(),w=B.b19(new A.bq(x,0,!1))
x=this.c
return x===w||x===B.c7l(w)?this.d:0},
aru(d,e,f,g){var x=this,w=new A.bq(Date.now(),0,!1),v=x.a4A(d,e),u=g?C.k.dd(v.b+1,0,100):0,t=g&&u>=f?D.f0:D.ow,s=new B.qy(t,u,w.lb()),r=d*1000+e
x.a.q(0,r,s)
x.b.F(0,r)
x.aWh(w)
return s},
a4r(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=H.dp[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qn():s).a===D.f0)++u}return u},
bbH(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=H.dp[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qn():s).a===D.ow)++u}return u},
gaqs(){var x=this.a,w=A.x(x).i("c6<2>")
return new A.ap(new A.c6(x,w),new B.b1a(),w.i("ap<Y.E>")).gL(0)},
gavY(){var x=this.a,w=A.x(x).i("bF<1>")
w=A.lS(new A.bF(x,w),new B.b1b(),w.i("Y.E"),y.S)
w=A.eM(w,A.x(w).i("Y.E"))
x=A.ab(w,A.x(w).c)
C.b.mU(x)
return x},
dW(){var x,w,v,u,t,s=this,r=y.N,q=A.B(r,y.L)
for(x=s.a,x=new A.eq(x,A.x(x).i("eq<1,2>")).gZ(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.q(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.ab(x,A.x(x).c)
return A.K(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
b7F(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Y)
for(x=this.b,x=A.b_s(x,300,A.x(x).c),x=new A.HK(J.aL(x.a),x.b,A.x(x).i("HK<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gN()
s=C.k.aR(t,1000)
t=C.k.a3(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.qn():q).a===D.f0?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.qn()
r=u.h(0,r)
o.push(A.K(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.qn():r).c.lT()],w,v))}return o},
bcf(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.J)(d),++u){t=d[u]
s=A.eu(t.h(0,"surah"))*1000+A.eu(t.h(0,"ayah"))
r=w.h(0,C.k.aR(s,1000)*1000+C.k.a3(s,1000))
if((r==null?$.qn():r).c.lT()===t.h(0,"updated_at"))v.J(0,s)}},
bcn(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aL(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gN()
if(!u.b(s))continue
r=A.aR(s.h(0,"surah"))
q=r==null?null:C.f.cu(r)
r=A.aR(s.h(0,"ayah"))
p=r==null?null:C.f.cu(r)
o=A.e6(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=H.dp[q-1].a[1])
if(r)continue
n=B.ctI(s.h(0,"status"))
if(n===D.ov)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.aR(s.h(0,"perfect_count"))
l=l==null?null:C.f.cu(l)
v.q(0,r,new B.qy(n,C.k.dd(l==null?0:l,0,100),o.lb()))
w.J(0,r)
t=!0}return t}}
B.Tm.prototype={
Ia(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Tm(w,v,u,t,f==null?x.e:f)},
b5Y(d){var x=null
return this.Ia(x,x,d,x,x)},
amK(d){var x=null
return this.Ia(x,d,x,x,x)},
b61(d){var x=null
return this.Ia(x,x,x,x,d)},
b5n(d){var x=null
return this.Ia(d,x,x,x,x)},
b5Z(d){var x=null
return this.Ia(x,x,x,d,x)},
dW(){var x=this
return A.K(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.FL.prototype={
P(){return"ModelState."+this.b}}
B.Tn.prototype={
v4(){var x=this.Q
return x==null?this.Q=new B.b1c(this).$0():x},
qb(d){return this.auc(d)},
auc(d){var x=0,w=A.k(y.H),v=this
var $async$qb=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:v.b=d
v.ad()
x=2
return A.c(K.oG("mt.tutor.settings",C.aM.lD(d.dW(),null)),$async$qb)
case 2:return A.i(null,w)}})
return A.j($async$qb,w)},
z3(){var x=0,w=A.k(y.H),v=this,u
var $async$z3=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:v.ad()
x=2
return A.c(K.oG("mt.tutor.progress",C.aM.lD(v.c.dW(),null)),$async$z3)
case 2:u=v.as
if(u!=null)u.aC()
v.as=A.cT(C.y,v.gaAU())
return A.i(null,w)}})
return A.j($async$z3,w)},
Li(d,e,f){return this.auZ(d,e,f)},
auZ(d,e,f){var x=0,w=A.k(y.H),v=this
var $async$Li=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:v.z=new A.aO(d,e,f)
x=2
return A.c(K.oG("mt.tutor.last",C.aM.lD(A.K(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Li)
case 2:return A.i(null,w)}})
return A.j($async$Li,w)},
Cp(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o
var $async$Cp=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:p=s.f
if(p===D.T_||p===D.jt){x=1
break}s.f=D.T_
s.y=null
s.ad()
u=4
p=A.om().gfl().h(0,"tutor_device")
if(p==null)p="auto"
x=7
return A.c(s.a.bbY(new B.b1d(s),p),$async$Cp)
case 7:s.x=e
s.f=D.jt
p=A.om().gfl().h(0,"debug")
if(p==="1"){p=s.x
A.Dr().$1("[tutor] model ready: "+p.a+" "+p.b+" in "+p.c+" ms (cached before: "+p.d+")")}u=2
x=6
break
case 4:u=3
o=t.pop()
p=A.a9(o)
if(p instanceof B.l8){r=p
s.f=D.aNg
s.y=r
p=A.om().gfl().h(0,"debug")
if(p==="1")A.Dr().$1("[tutor] model failed: "+A.n(r))}else throw o
x=6
break
case 3:x=2
break
case 6:s.ad()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Cp,w)},
w5(){var x=0,w=A.k(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$w5=A.f(function(a0,a1){if(a0===1){t.push(a1)
x=u}for(;;)switch(x){case 0:if(r.at){x=1
break}q=null
try{k=$.D().b
k===$&&A.b()
k=k.ga4().e.a
q=(k==null?null:k.r)!=null}catch(d){x=1
break}if(!q){x=1
break}r.at=!0
u=4
k=$.D().b
k===$&&A.b()
p=k
x=7
return A.c(p.aP("quran_tutor_progress").d4("surah, ayah, status, perfect_count, updated_at"),$async$w5)
case 7:o=a1
n=r.c.bcn(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.b7F()
if(J.aT(l)===0){x=10
break}h=p
g=A.K(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.mt(h.x,k,k))
x=11
return A.c(f.bg7("quran_tutor_save",!1,g,i),$async$w5)
case 11:r.c.bcf(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(K.oG("mt.tutor.progress",C.aM.lD(r.c.dW(),null)),$async$w5)
case 12:if(n)r.ad()
s.push(6)
x=5
break
case 4:u=3
e=t.pop()
s.push(6)
x=5
break
case 3:s=[2]
case 5:u=2
r.at=!1
x=s.pop()
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$w5,w)},
Kb(d){return this.bfP(d)},
bfP(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Kb=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.bZJ(t.c.dW()).dW()
y.f.a(p.h(0,"rows")).eg(0,new B.b1e(d))
t.c=B.bZJ(p)
x=2
return A.c(t.z3(),$async$Kb)
case 2:v=4
s=$.D().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.aD("quran_tutor_reset",A.K(["p_surah",d],y.N,r),r),$async$Kb)
case 9:case 8:v=1
x=6
break
case 4:v=3
o=u.pop()
x=6
break
case 3:x=1
break
case 6:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$Kb,w)}}
B.vE.prototype={
O(){var x=$.KQ()
return new B.YB(x,new A.af(C.J,$.S()))}}
B.YB.prototype={
X(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.gnT())
w=y.a
x.v4().bD(new B.bBK(v),w)
G.aQD().bD(new B.bBL(v),w).fV(new B.bBM())
A.NF(G.bZ5(),y.y)},
wg(){if(this.c!=null)this.l(new B.bBw())},
m(){var x,w=this
w.d.V(w.gnT())
x=w.e
x.p$=$.S()
x.K$=0
w.a0()},
OK(){var x=0,w=A.k(y.H),v=this,u
var $async$OK=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.d
x=2
return A.c(u.qb(u.b.b5Y(!0)),$async$OK)
case 2:u.a.bev()
u.Cp()
return A.i(null,w)}})
return A.j($async$OK,w)},
xa(d,e,f){return this.aUd(d,e,f)},
b1o(d){return this.xa(d,null,null)},
aUd(d,e,f){var x=0,w=A.k(y.H),v,u=this,t,s,r
var $async$xa=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.a_(A.aS(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.a4(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cxa(s,d),$async$xa)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Li(d,t.a,t.b),$async$xa)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aB(A.aA(new B.bBC(u,d,t),null,r),r),$async$xa)
case 8:if(u.c!=null)u.l(new B.bBD())
case 1:return A.i(v,w)}})
return A.j($async$xa,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=v.e
if(t)u.push(A.cb(x,x,x,D.apy,x,x,new B.bBG(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.cb(x,x,x,C.i9,x,x,new B.bBH(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aBC
else w=t?this.aPs():this.aQ2()
return E.wj(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aQ2(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a1A
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.aYN,C.a0],x)
for(t=0;t<4;++t){s=D.aDI[t]
u.push(new A.H(C.bE,A.A(A.a([A.bd(s.a,C.ar,p,18),C.I,new A.bM(1,C.ac,A.d(s.b,p,p,p,p,D.b3z,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bnt,C.M,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bK(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.b9,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bK(C.f.aA(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.M,A.d(q,p,p,p,p,A.bQ(p,p,r?D.dL:C.dh,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.M,D.bmx],x))
x=A.a([new E.e8(u,C.a6,C.aU,p,!0,p),new E.e8(A.I(s,C.q,C.d,C.e,0,C.l),C.a6,C.aU,p,!1,p),D.btP,C.M],x)
if(v!=null)x.push(new E.e8(A.d(v,p,p,p,p,D.b8s,p,p,p),C.a6,C.aU,p,!1,p))
else x.push(A.hb(D.amE,D.be_,this.gaUt(),A.eY(C.A,C.aq,D.b0I,p)))
x.push(C.a3)
x.push(D.a1v)
return x},
aPs(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.R(r.a.a),p=q.length===0,o=p?C.qR:G.cbF(q),n=t.z,m=A.V(v.aiL(C.dm,E.bK(s.gaqs())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bK(s.ane()),k=s.c,j=Date.now()
k=k===B.b19(new A.bq(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.FM(t,!1,u),A.A(A.a([m,C.I,A.V(v.aiL(C.kD,l+" \u064a\u0648\u0645",k),1)],j),C.i,C.d,C.e,0,u,u),C.u],j)
if(n!=null){t=G.jU(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bK(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bK(m)+"\u2013"+E.bK(l)
k.push(new E.e8(A.A(A.a([D.aoJ,C.Y,A.V(A.I(A.a([D.bap,A.d(t+" \u2014 "+m,u,u,u,u,C.c5,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),L.mW],j),C.i,C.d,C.e,0,u,u),C.a6,C.aU,new B.bBz(v,n),!0,u))}t=C.h.ak(0.08)
k.push(A.aG(u,C.w,!1,u,!0,C.m,u,A.aJ(),r,u,u,u,u,u,2,A.d8(u,new A.cc(4,A.u(14),C.L),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.zY,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.xl,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bBA(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.dI,!0,C.t,u,C.E,u,u,u,u))
k.push(C.u)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.biZ)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.J)(o),++x)t.push(v.PS(o[x]))
C.b.A(k,t)}else{t=A.a([D.aQ9,D.aQM,v.PS(1)],j)
for(w=114;w>=78;--w)t.push(v.PS(w))
t.push(C.M)
r=v.f
p=A.bd(r?C.FD:C.pW,C.ar,u,u)
t.push(A.ix(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.hM,u,u,u),new B.bBB(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.PS(w))
C.b.A(k,t)}k.push(C.a0)
k.push(D.AJ)
return k},
aiL(d,e,f){var x=null,w=y.p
return new E.e8(A.A(A.a([A.bd(d,C.A,x,x),C.I,A.V(A.I(A.a([A.d(e,x,x,x,x,C.c5,x,x,x),A.d(f,1,C.Q,x,x,C.a_W,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.i,C.d,C.e,0,x,x),C.a6,C.K,x,!1,x)},
PS(d){var x,w=null,v=this.d.c,u=H.dp[d-1].a[1],t=v.a4r(d),s=t/u,r=y.p,q=A.ao(A.dm(C.N,A.a([A.bXA(C.fE,D.dj,w,w,w,w,w,3,s,w),A.d(E.bK(d),w,w,w,w,O.a0e,w,w,w)],r),C.m,C.be,w),36,36),p=A.d(G.jU(d),w,w,w,w,D.b3j,w,w,w)
if(t===0)x=E.bK(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bK(t)+" \u0645\u0646 "+E.bK(u)
r=A.a([q,C.cw,A.V(A.I(A.a([p,A.d(x,w,w,w,w,A.bQ(w,w,t===u?D.dj:C.dh,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bK(C.f.aA(s*100))+"\u066a",w,w,w,w,D.a_N,w,w,w))
r.push(D.amN)
return new E.e8(A.A(r,C.i,C.d,C.e,0,w,w),C.pt,C.dA,new B.bBE(this,d),!1,w)}}
B.FM.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.bn
return D.aPX
case 3:x=q.y
x=x==null?r:x.gih()
return new E.e8(A.I(A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":x,r,r,r,r,D.zT,r,r,r),C.M,new A.yA(C.a2j,!1,q.gbbX(),r,r,r,r,C.j,r,!1,r,!0,r,C.Al,r)],y.p),C.q,C.d,C.e,0,C.l),C.a6,C.aU,r,!1,r)
case 0:case 1:w=q.w
v=q.r
q=w>0
u=q?C.f.dd(v/w,0,1):r
t=q&&v<w
q=A.d(t?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bK(C.f.aA(v/1e6))+" \u0645\u0646 "+E.bK(C.f.aA(w/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.o0,r,r,r)
x=A.u(8)
s=y.p
x=A.a([q,C.B,A.eW(x,A.rf(C.fE,C.A,7,t?u:r,r),C.az)],s)
if(!this.d)C.b.A(x,A.a([C.M,D.beN],s))
return new E.e8(A.I(x,C.q,C.d,C.e,0,C.l),C.a6,C.aU,r,!1,r)}}}
B.VB.prototype={
t(d){var x=null,w=D.dL.ak(0.1),v=A.u(14),u=A.aC(D.dL.ak(0.4),1)
return A.C(x,A.A(A.a([D.aon,C.I,A.V(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.A1,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.j,x,x,new A.E(w,x,u,v,x,x,x,C.n),x,x,C.aU,C.ad,x,x,x)}}
B.CM.prototype={
P(){return"_Phase."+this.b}}
B.BS.prototype={
O(){return new B.a_Z($.KQ(),D.lO)}}
B.a_Z.prototype={
gjl(){var x=this.e
return x===$?this.e=this.a.d:x},
gQ9(){var x,w=this.a,v=w.f
w=w.c
x=this.gjl()
return G.awN(w,x,v.HV(w,x)).b},
X(){var x,w=this
w.Y()
x=w.d
x.ac(w.gnT())
x.v4()
x.a.a4Y(B.awz(w.a.c,w.gjl()))},
wg(){if(this.c!=null)this.l(new B.bOu())},
m(){var x,w=this,v=w.d
v.V(w.gnT())
x=w.Q
if(x!=null)x.aC()
v=v.a
v.Lz()
v.a1F()
w.a0()},
Yt(d){var x,w,v=this
if(v.f===D.ub)v.d.a.a1F()
x=v.d.a
x.Lz()
w=v.Q
if(w!=null)w.aC()
v.l(new B.bOK(v,d))
x.a4Y(B.awz(v.a.c,d))
w=v.a
if(d<w.e)x.a4Y(B.awz(w.c,d+1))},
Q8(d){return this.aQR(d)},
aQR(d){var x=0,w=A.k(y.H),v,u=this,t,s,r,q,p
var $async$Q8=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:if(u.f===D.ua){u.d.a.Lz()
u.l(new B.bOO(u))
x=1
break}t=u.r!=null?D.k_:D.lO
u.l(new B.bOP(u))
s=u.d
r=A.a([B.awz(u.a.c,u.gjl())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.JY(r,q),$async$Q8)
case 3:p=f
if(u.c==null||u.f!==D.ua){x=1
break}u.l(new B.bOQ(u,t,p))
case 1:return A.i(v,w)}})
return A.j($async$Q8,w)},
P4(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$P4=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:m=s.d
if(m.f!==D.jt){x=1
break}p=m.a
p.Lz()
r=B.bW_(s.gQ9()).length
s.l(new B.bOS(s))
o=s.Q
if(o!=null)o.aC()
s.Q=A.hU(C.eG,new B.bOT(s))
u=4
o=B.c0q(r)
x=7
return A.c(p.a7p(m.b.c,o,new B.bOU(s),new B.bOV(s)),$async$P4)
case 7:u=2
x=6
break
case 4:u=3
l=t.pop()
m=A.a9(l)
if(m instanceof B.l8){q=m
m=s.Q
if(m!=null)m.aC()
if(s.c!=null)s.l(new B.bOW(s,q))}else throw l
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$P4,w)},
AY(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$AY=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.ub){x=1
break}o=s.Q
if(o!=null)o.aC()
s.l(new B.bOY(s))
s.Q=A.hU(C.i5,new B.bOZ(s))
u=4
o=s.d.a
x=7
return A.c(o.a7s(),$async$AY)
case 7:r=e
if(r.b<0.8){s.a0u("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(o.asm(r),$async$AY)
case 8:q=e
o=A.om().gfl().h(0,"debug")
if(o==="1")A.Dr().$1("[tutor] "+s.a.c+":"+s.gjl()+" audio="+C.f.av(r.b,1)+"s infer="+q.b+"ms text="+q.a)
s.adc(q.a)
u=2
x=6
break
case 4:u=3
m=t.pop()
o=A.a9(m)
if(o instanceof B.l8){p=o
s.a0u(p.gih())}else throw m
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$AY,w)},
a0u(d){var x=this,w=x.Q
if(w!=null)w.aC()
if(x.c==null)return
x.l(new B.bOJ(x,d))},
adc(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aC()
if(s.c==null)return
x=B.cad(s.gQ9(),d)
r.a=null
if(C.c.R(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjl()
t=x.grS()
r.a=w.aru(v,u,q.b.a,t)
q.z3()}s.l(new B.bOL(r,s,x))},
MS(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h
var $async$MS=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:i=s.d
if(i.f!==D.jt){x=1
break}s.l(new B.bOC(s))
m=s.Q
if(m!=null)m.aC()
s.Q=A.hU(C.i5,new B.bOD(s))
l=new A.Hu()
$.KP()
l.vU()
r=l
u=4
x=7
return A.c(i.a.bgC(B.awz(s.a.c,s.gjl())),$async$MS)
case 7:q=e
p="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.av(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.av(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.av(r.gIA()/1000,2)+" \u062b)\n"+q.a
A.Dr().$1("[tutor-debug] "+s.a.c+":"+s.gjl()+" audio="+C.f.av(q.c,1)+"s infer="+q.b+"ms total="+r.gIA()+"ms text="+q.a)
s.adc(q.a)
o=s.r
if(o!=null){i=o.grS()
m=o.b
k=A.ak(m).i("ap<1>")
m=A.ab(new A.ap(m,new B.bOE(),k),k.i("Y.E"))
A.Dr().$1("[tutor-debug] perfect="+i+" ops="+A.n(m))}s.l(new B.bOF(s,p))
u=2
x=6
break
case 4:u=3
h=t.pop()
i=A.a9(h)
if(i instanceof B.l8){n=i
A.Dr().$1("[tutor-debug] failed: "+A.n(n))
s.a0u(n.gih())}else throw h
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$MS,w)},
ga_h(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.qn():v).a!==D.f0)return!1}return!0},
t(d){var x=this,w=null,v=x.d,u=v.c.a4A(x.a.c,x.gjl()),t=v.b,s=t.d&&!x.x&&x.f!==D.k_,r=G.jU(x.a.c),q=y.p,p=A.a([A.cb(w,w,w,C.i9,w,w,new B.bP3(d),w,w,w,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",w)],q),o=x.aHn(),n=A.d("\u0622\u064a\u0629 "+E.bK(x.gjl()),w,w,w,w,N.A2,w,w,w),m=E.bK(x.gjl()-x.a.d+1),l=x.a
t=A.a([A.A(A.a([n,C.b6,A.d("("+m+" \u0645\u0646 "+E.bK(l.e-l.d+1)+")",w,w,w,w,F.b9,w,w,w),C.bB,x.aV7(u,t.a)],q),C.i,C.d,C.e,0,w,w),C.u],q)
if(s)t.push(x.aPn())
else{n=x.r
if(n!=null){m=x.f
m=m!==D.ub&&m!==D.om}else m=!1
if(m)t.push(x.aF6(n))
else t.push(A.d(x.gQ9()+" \ufd3f"+E.bK(x.gjl())+"\ufd3e",w,w,w,w,D.jR,C.a5,C.bf,w))}t=A.a([new B.FM(v,!0,w),o,C.B,new E.e8(A.I(t,C.ak,C.d,C.e,0,C.l),D.afQ,C.aU,w,!1,w)],q)
o=x.r
if(o!=null&&x.f===D.k_)t.push(x.b2N(o))
o=x.as
if(o!=null)t.push(new A.H(C.aU,A.d(o,w,w,w,w,D.zT,w,w,w),w))
t.push(x.aFE())
t.push(C.a0)
t.push(A.iv(C.A,C.K,w,new B.bP4(x),D.bbX,D.bgW,v.b.d))
o=x.a
if(o.e>o.d){o=x.ga_h()
t.push(new E.e8(A.A(A.a([D.alo,C.Y,A.V(A.I(A.a([D.bio,A.d(x.ga_h()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",w,w,w,w,F.b9,w,w,w)],q),C.q,C.d,C.e,0,C.l),1),L.mW],q),C.i,C.d,C.e,0,w,w),C.a6,C.aU,new B.bP5(x,d),o,w))}o=A.om().gfl().h(0,"debug")
if(o==="1"){q=A.a([C.B,A.dl(D.amD,D.bgq,v.f===D.jt&&x.f!==D.om?x.gaGn():w,w)],q)
o=x.at
if(o!=null)q.push(new A.H(C.j4,A.H5(o,F.b9,w),w))
v=v.x
if(v!=null)q.push(A.d("model: "+v.a+" "+v.b+", load "+v.c+" ms",w,w,w,w,F.b9,w,w,w))
C.b.A(t,q)}t.push(C.B)
t.push(D.AJ)
return E.wj(p,t,r)},
aHn(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.bn
return A.ao(A.fk(new B.bOH(this),w,null,C.af,new B.bOI()),36,null)},
aV7(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.f0)return D.aYX
x=d.b
w=E.bK(x)
v=E.bK(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c0:C.FV
u.push(new A.H(D.agu,A.bd(r,s?D.dj:C.fF,q,16),q))}return A.bZG(A.A(u,C.i,C.d,C.P,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aPn(){var x=null
return A.bB(!1,A.u(12),!0,A.C(x,D.acJ,C.j,x,x,new A.E(C.va,x,x,A.u(12),x,x,x,C.n),x,x,x,D.aft,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bON(this),x,x,x,x,x,x,x)},
aF6(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.aP(d.gLy(),w)
A:{if(D.iF===v){u=D.jR.ci(D.dj)
break A}if(D.tV===v){u=D.jR.a2j(D.dL,C.jN,D.dL)
break A}if(D.tW===v){u=D.jR.a2j(D.eD,C.jN,D.eD)
break A}u=D.jR.a2j(C.fF,C.jO,C.dy)
break A}t=x[w]
r.push(new A.eP(t.a,s,s,C.bt,s,s,s,s,s,s,u))
r.push(H.zL)}x=E.bK(this.gjl())
r.push(A.ea(s,s,s,s,s,s,s,s,s,D.jR.ci(C.ar),"\ufd3f"+x+"\ufd3e"))
return A.HL(A.ea(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.a5,C.bf)},
b2N(d){var x,w,v,u,t,s,r=this.w
if(C.c.R(d.c).length===0)return D.btc
if(d.grS()){x=r==null
if((x?null:r.a)===D.f0&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.f0?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bK(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.C7(D.dj,C.c0,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gLy()
w=J.dD(x)
v=w.iT(x,new B.bP_()).gL(0)
u=w.iT(x,new B.bP0()).gL(0)
t=w.iT(x,new B.bP1()).gL(0)
x=A.a([],y.s)
if(u>0)x.push(E.bK(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bK(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bK(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gIJ().length!==0)x.push(E.bK(d.gIJ().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eD:D.dL
x=C.b.aH(x," \u2022 ")
s=d.gIJ().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aH(d.gIJ(),"\u060c "):""
return new B.C7(w,C.mM,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aFE(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jt,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.k.aR(new A.bq(f,0,!1).eC(w).a,1e6)}v=C.k.aR(B.c0q(B.bW_(j.gQ9()).length).a,1e6)
f=j.gb1q()
w=96+26*j.y
u=D.eD.ak(0.25)
w=A.iL(i,A.a2E(C.N,A.C(i,D.amQ,C.j,i,i,D.a4T,i,84,i,i,i,i,84),i,C.aO,new A.E(u,i,i,i,i,i,i,C.bZ),C.DE,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cO)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c_u(x)+" / "+B.c_u(v),i,i,i,i,I.o_,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u062a\u064a\u0646 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.b9,i,i,i),A.bt(D.bmw,i,i,f,i,i)],y.p),C.i,C.d,C.e,0,C.l)
case 3:t=C.f.er((Date.now()-j.ax)/1000)
return new A.H(C.po,A.I(A.a([C.uX,C.a0,D.bfd,A.d(t<8?"\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643":"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bK(t)+" \u062b)",i,i,i,i,F.b9,i,i,i)],y.p),C.i,C.d,C.e,0,C.l),i)
default:s=f===D.ua
r=j.r
f=r==null
w=!f
q=w&&r.grS()
u=A.bd(s?D.xa:I.G4,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.eY(i,i,D.b0F,i)
u=A.V(new A.yA(C.a2j,!0,new B.bOv(j,r,q),i,i,i,o,C.j,i,!1,i,!0,i,new A.W8(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.Hz[n]
p.push(new A.eK(m,i,A.d("\xd7"+E.bK(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.I,A.rN(new B.bOw(j),p,A.d5([h.b.b],o),!1,A.jZ(i,i,i,new A.bm(new B.bOx(),l),i,i,i,i,new A.bm(new B.bOy(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.dW),o)],k),C.i,C.d,C.e,0,i,i)
h=g&&!s?j.gaWZ():i
u=A.bd(f?D.q_:C.mM,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cy,i,i,i)
p=q?C.kk:C.A
h=A.a([o,C.u,A.hb(u,f,h,A.eY(p,q?C.h:C.aq,D.tc,i))],k)
if(w&&j.gjl()<j.a.e)C.b.A(h,A.a([C.B,q?A.hb(D.apU,D.blm,new B.bOz(j),A.eY(D.dj,C.aq,D.tc,i)):A.bt(D.bcl,i,i,new B.bOA(j),i,i)],k))
if(w){f=j.gjl()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.H(C.j5,A.d(j.ga_h()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,D.a0l,C.a5,i,i),i))
return A.I(h,C.ak,C.d,C.e,0,C.l)}}}
B.C7.prototype={
t(d){var x=this,w=null,v=x.c,u=v.ak(0.12),t=A.u(14),s=A.aC(v.ak(0.5),1),r=y.p
return A.C(w,A.A(A.a([A.bd(x.d,v,w,w),C.I,A.V(A.I(A.a([A.d(x.e,w,w,w,w,A.bQ(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.U,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bI,A.d(x.f,w,w,w,w,C.A1,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.j,w,w,new A.E(u,w,s,t,w,w,w,C.n),w,w,C.aU,C.ad,w,w,w)}}
B.BR.prototype={
O(){var x=y.S
return new B.a_Y($.KQ(),A.B(x,y.B),A.aU(x),A.B(x,y.N),A.ed(null,y.H))}}
B.a_Y.prototype={
X(){this.Y()
this.d.ac(this.gnT())},
wg(){if(this.c!=null)this.l(new B.bOd())},
m(){var x,w=this,v=w.d
v.V(w.gnT())
x=w.y
if(x!=null)x.aC()
v.a.a1F()
w.a0()},
Hk(d){return this.b_N(d)},
b_N(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o,n
var $async$Hk=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.l(new B.bOm(t,d))
r=t.y
if(r!=null)r.aC()
t.y=A.hU(C.eG,new B.bOn(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c0q(B.bW_(G.awN(q,d,p.HV(q,d)).b).length)
x=6
return A.c(r.a.a7p(r.b.c,q,new B.bOo(t,d),new B.bOp(t)),$async$Hk)
case 6:v=1
x=5
break
case 3:v=2
n=u.pop()
r=A.a9(n)
if(r instanceof B.l8){s=r
r=t.y
if(r!=null)r.aC()
if(t.c!=null)t.l(new B.bOq(t,s))}else throw n
x=5
break
case 2:x=1
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$Hk,w)},
EQ(d,e){return this.aIt(d,e)},
aIt(d,e){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$EQ=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aC()
s.l(new B.bOh(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a7s()
if(e&&n!=null)s.Hk(n)
q=null
u=4
x=7
return A.c(r,$async$EQ)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a9(l)
if(o instanceof B.l8){p=o
s.l(new B.bOi(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.as=s.as.bD(new B.bOj(s,o,d),y.H)}case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$EQ,w)},
gaSO(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aE(x)&&!v.n(0,x)&&!u.aE(x)&&x!==t.e)return x
return null},
aXN(){this.l(new B.bOk(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jt,o=s.e,n=s.gaSO(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.x(m).i("c6<2>")
x=new A.ap(new A.c6(m,l),new B.bOr(),l.i("ap<Y.E>")).gL(0)
l=G.jU(s.a.c)
m=y.p
q=A.a([new B.FM(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bK(s.a.d)+" \u0644\u062d\u062f "+E.bK(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.b9,r,r,r),C.u],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b1p(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.zT,r,r,r))
k=o==null
if(!k){j=E.bK(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.k.aR(new A.bq(v,0,!1).eC(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c_u(v),r,r,r,r,I.o_,C.a5,r,r)
j=A.eW(A.u(6),A.rf(C.fE,D.eD,6,s.x,r),C.az)
u=o<s.a.e
t=A.bd(u?D.akQ:D.xa,r,r,r)
C.b.A(q,A.a([v,C.M,j,C.u,A.hb(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cy,r,r,r),new B.bOs(s,o),A.eY(C.A,C.aq,D.tc,r))],m))}else if(n!=null){j=p?new B.bOt(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bK(n)
q.push(A.hb(D.anV,A.d(v,r,r,r,r,C.cy,r,r,r),j,A.eY(C.A,C.aq,D.tc,r)))}if(s.r.a!==0&&k)q.push(D.aQj)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?D.dj:D.dL
v=k?C.mG:C.mM
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bK(x)
u=s.a
u=k+" \u0645\u0646 "+E.bK(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.C7(j,v,k,u,r),A.dl(D.apI,D.blX,s.gaXM(),r)],m))}q.push(C.u)
q.push(D.AJ)
return E.wj(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b1p(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.anh
else if(l.r.n(0,d))x=M.td
else if(i!=null)x=D.any
else if(j!=null){w=j.grS()?C.c0:D.ajZ
x=A.bd(w,j.grS()?D.dj:D.dL,k,k)}else x=D.am_
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bK(d),k,k,k,k,D.b7E,k,k,k),C.bB,x],w),C.i,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.b6V,k,k,k))
if(j!=null&&!j.grS()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gLy()
o=J.b7(p)
n=o.h(p,r)
A:{if(D.iF===n){m=D.dj
break A}if(D.tV===n){m=D.dL
break A}if(D.tW===n){m=D.eD
break A}m=C.fF
break A}m=D.jR.b6A(m,o.h(p,r)===D.tX?C.jO:k,22)
C.b.A(t,A.a([new A.eP(q.a,k,k,C.bt,k,k,k,k,k,k,m),H.zL],u))}w=A.a([C.an,A.HL(A.ea(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.a5,C.bf)],w)
if(C.c.R(j.c).length===0)w.push(D.bhQ)
C.b.A(v,w)}return new E.e8(A.I(v,C.ak,C.d,C.e,0,C.l),C.bK,C.dA,k,!1,k)}}
B.BQ.prototype={
O(){return new B.a_X($.KQ())}}
B.a_X.prototype={
X(){this.Y()
var x=this.d
x.ac(this.gnT())
x.v4()},
wg(){if(this.c!=null)this.l(new B.bO4())},
m(){this.d.V(this.gnT())
this.a0()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gavY(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kI(o,0,new B.bOb(q))
v=C.b.kI(o,0,new B.bOc())
o=y.p
o=A.a([A.A(A.a([A.V(s.Wn(E.bK(q.gaqs()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.I,A.V(s.Wn(E.bK(q.ane()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.I,A.V(s.Wn(E.bK(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.i,C.d,C.e,0,r,r),C.u,new E.e8(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bK(C.f.aA(w*100/v))+"\u066a",r,r,r,r,C.c5,r,r,r),C.M,A.eW(A.u(6),A.rf(C.fE,D.dj,8,w/v,r),C.az),C.an,A.d(E.bK(w)+" \u0645\u0646 "+E.bK(v)+" \u0622\u064a\u0629",r,r,r,r,F.b9,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a6,C.aU,r,!1,r)],o)
if(p.length===0)o.push(D.aQv)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.J)(p),++t)o.push(s.b1r(p[t]))
o.push(C.B)
u=$.D().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.b9,r,r,r))
return E.wj(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
Wn(d,e){var x=null
return new E.e8(A.I(A.a([A.d(d,x,x,x,x,D.b7m,x,x,x),A.d(e,x,x,x,x,C.a0q,C.a5,x,x)],y.p),C.i,C.d,C.e,0,C.l),C.a6,C.K,x,!1,x)},
b1r(d){var x=null,w=this.d.c,v=H.dp[d-1].a[1],u=w.a4r(d),t=w.bbH(d),s=y.p,r=A.A(A.a([A.V(A.d(G.jU(d),x,x,x,x,C.c5,x,x,x),1),A.d(E.bK(C.f.aA(u*100/v))+"\u066a",x,x,x,x,D.b8t,x,x,x)],s),C.i,C.d,C.e,0,x,x),q=A.eW(A.u(6),A.rf(C.fE,D.dj,7,u/v,x),C.az),p=E.bK(u),o=E.bK(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bK(t):""
return new E.e8(A.I(A.a([r,C.M,q,C.an,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.b9,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a6,C.aU,new B.bOa(this,d),!1,x)},
MV(d){return this.aGI(d)},
aGI(d){var x=0,w=A.k(y.H),v=this,u,t
var $async$MV=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=H.dp[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.ef(C.di,new B.bO9(v,d,u),t,!0,null,null,y.H),$async$MV)
case 2:return A.i(null,w)}})
return A.j($async$MV,w)}}
B.agg.prototype={
Q7(d,e){var x=null,w=A.t5(x,x,x,x,x,x,x,x,x,x,x,D.b0b,C.K,x,x,x,x,C.nq,x,x)
return A.bt(A.d(d,x,x,x,x,C.tx,x,x,x),x,x,new B.b0V(e),x,w)},
t(d){var x=this,w=y.p
return new E.e8(A.I(A.a([D.bl8,C.M,D.bmv,A.d0(C.aA,A.a([x.Q7("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Q7("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aH,0,12),D.bby,x.Q7("tanzil.net","https://tanzil.net"),D.bo2,x.Q7("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a6,C.aU,null,!1,null)}}
var z=a.updateTypes(["aj<~>()","~()","Q(mU)","aj<I4>()","aj<I2>()","aj<I3>()","a7<mU>()","Q(qy)","bD(o_)","BS(t)","BQ(t)","Q(ml)","BR(t)","Q(GE)"])
B.b0X.prototype={
$0(){var x=0,w=A.k(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.a0(A.eE(b.G.document).baseURI)
q=A.bs(r,0,null).a2("quran_tutor/tutor.js?v=1").j(0)
x=7
return A.c(A.eF(import(q),y.m),$async$$0)
case 7:p=e
s.a.a=p
v=p
x=1
break
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a9(l)
s.a.b=null
m=B.cof("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:382}
B.b1_.prototype={
$1(d){return A.fH(d,"persist",null,null,y.K)},
$S:1073}
B.b0Z.prototype={
$0(){var x=0,w=A.k(y.C),v,u=this,t,s,r,q,p,o,n
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:q=y.m
o=A
n=A
x=4
return A.c(u.a.qB(),$async$$0)
case 4:x=3
return A.c(o.eF(n.fH(e,"loadModel",A.bSf(new B.b0Y(u.b)),u.c,q),q),$async$$0)
case 3:p=e
q=A.v(p.device)
if(q==null)q=null
if(q==null)q=""
t=A.v(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=A.tJ(p.ms)
s=s==null?null:C.f.aA(s)
if(s==null)s=0
r=A.et(p.cached)
if(r==null)r=null
v=new B.I2(q,t,s,r===!0)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+4}
B.b0Y.prototype={
$2(d,e){this.a.$2(C.f.aA(d),C.f.aA(e))},
$S:1074}
B.b13.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t,s
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.qB(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.k.aR(v.b.a,1000)
u.autoStop=v.c
u.onLevel=A.fW(new B.b11(v.d))
u.onAutoStop=A.fW(new B.b12(v.e))
x=5
return A.c(A.eF(A.fH(s,"startRecording",u,null,y.m),y.X),$async$$0)
case 5:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.b11.prototype={
$1(d){return this.a.$1(d)},
$S:73}
B.b12.prototype={
$1(d){return this.a.$1(d)},
$S:6}
B.b14.prototype={
$0(){var x=0,w=A.k(y.D),v,u=this,t,s,r
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.a
r=s.a
x=r==null?3:4
break
case 3:x=5
return A.c(s.qB(),$async$$0)
case 5:r=e
case 4:s=y.m
x=6
return A.c(A.eF(A.fH(r,"stopRecording",null,null,s),s),$async$$0)
case 6:t=e
v=new B.I3(t,A.dB(t.seconds))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+5}
B.b16.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=y.m
q=s
p=A
o=A
x=4
return A.c(s.qB(),$async$$0)
case 4:x=3
return A.c(p.eF(o.fH(e,"transcribe",t.audio,t.rate,r),r),$async$$0)
case 3:v=q.ajs(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b15.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.a
s=y.m
r=t
q=A
p=A
x=4
return A.c(t.qB(),$async$$0)
case 4:x=3
return A.c(q.eF(p.fH(e,"transcribeUrl",u.b,null,s),s),$async$$0)
case 3:v=r.ajs(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b10.prototype={
$1(d){return d},
$S:37}
B.aSb.prototype={
$0(){var x,w,v,u,t=this.a,s=A.ch(t.a.length,D.tX,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aSa.prototype={
$1(d){return d===D.iF},
$S:z+2}
B.bS_.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.bWH(e[x],d[x])<0.75)return!1
return!0},
$S:1075}
B.bTU.prototype={
$1(d){return d.length!==0},
$S:11}
B.b1a.prototype={
$1(d){return d.a===D.f0},
$S:z+7}
B.b1b.prototype={
$1(d){return C.k.aR(d,1000)},
$S:65}
B.b18.prototype={
$1(d){return C.f.cu(d)},
$S:1076}
B.b1c.prototype={
$0(){var x=0,w=A.k(y.a),v=1,u=[],t=this,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0
var $async$$0=A.f(function(a1,a2){if(a1===1){u.push(a2)
x=v}for(;;)switch(x){case 0:v=3
x=6
return A.c(A.qk("mt.tutor.settings"),$async$$0)
case 6:s=a2
if(s!=null){l=y.P.a(C.aM.jt(s,null))
k=A.aR(l.h(0,"n"))
k=k==null?null:C.f.cu(k)
k=C.k.dd(k==null?2:k,1,5)
j=C.b.n(D.Hz,l.h(0,"r"))?A.eu(l.h(0,"r")):1
i=A.et(l.h(0,"auto"))
h=A.et(l.h(0,"hide"))
l=A.et(l.h(0,"in"))
t.a.b=new B.Tm(k,j,i!==!1,h===!0,l===!0)}v=1
x=5
break
case 3:v=2
f=u.pop()
x=5
break
case 2:x=1
break
case 5:v=8
x=11
return A.c(A.qk("mt.tutor.progress"),$async$$0)
case 11:r=a2
if(r!=null)t.a.c=B.bZJ(y.P.a(C.aM.jt(r,null)))
v=1
x=10
break
case 8:v=7
e=u.pop()
x=10
break
case 7:x=1
break
case 10:v=13
x=16
return A.c(A.qk("mt.tutor.last"),$async$$0)
case 16:q=a2
if(q!=null){p=y.P.a(C.aM.jt(q,null))
o=C.f.cu(A.dd(J.aP(p,"s")))
n=C.f.cu(A.dd(J.aP(p,"f")))
m=C.f.cu(A.dd(J.aP(p,"t")))
if(B.cbT(o,n)&&B.cbT(o,m)&&n<=m)t.a.z=new A.aO(o,n,m)}v=1
x=15
break
case 13:v=12
d=u.pop()
x=15
break
case 12:x=1
break
case 15:l=t.a
a0=l
x=17
return A.c(l.a.LS(),$async$$0)
case 17:a0.d=a2
l.e=!0
l.ad()
if(l.b.e)l.Cp()
l.w5()
return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$0,w)},
$S:139}
B.b1d.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.ad()},
$S:1077}
B.b1e.prototype={
$2(d,e){return C.k.aR(A.eV(A.n(d),null,null),1000)===this.a},
$S:1078}
B.bBK.prototype={
$1(d){var x=0,w=A.k(y.a),v=this,u,t
var $async$$1=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.DG(),$async$$1)
case 2:t=f
if(u.c!=null)u.l(new B.bBJ(u,t))
return A.i(null,w)}})
return A.j($async$$1,w)},
$S:1079}
B.bBJ.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bBL.prototype={
$1(d){var x=this.a
if(x.c!=null)x.l(new B.bBI(x,d))},
$S:z+8}
B.bBI.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bBM.prototype={
$1(d){},
$S:23}
B.bBw.prototype={
$0(){},
$S:0}
B.bBC.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.BS(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bBD.prototype={
$0(){},
$S:0}
B.bBG.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aB(A.aA(new B.bBF(),null,x),x)},
$S:0}
B.bBF.prototype={
$1(d){return D.bpk},
$S:z+10}
B.bBH.prototype={
$0(){return B.cbK(this.a)},
$S:0}
B.bBz.prototype={
$0(){var x=this.b
return this.a.xa(x.a,x.b,x.c)},
$S:0}
B.bBA.prototype={
$1(d){return this.a.l(new B.bBy())},
$S:6}
B.bBy.prototype={
$0(){},
$S:0}
B.bBB.prototype={
$0(){var x=this.a
return x.l(new B.bBx(x))},
$S:0}
B.bBx.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bBE.prototype={
$0(){return this.a.b1o(this.b)},
$S:0}
B.bVS.prototype={
$1(d){return new A.jJ(new B.bVP(this.a,this.b,this.c),null)},
$S:59}
B.bVP.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.bVR(u,e),s=this.a,r=new B.bVQ(s,e),q=A.d(G.jU(this.c),v,v,v,v,C.nW,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bK(u)+" \u0622\u064a\u0629)",v,v,v,v,F.b9,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bK(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bK(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.k.dd(w+4,1,u)))}u=A.a([q,C.an,p,C.u,A.d0(C.aA,n,C.aH,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.bVK(s)),C.Zu,t.$3("\u0644\u062d\u062f",s.c,new B.bVL(s))],o),C.i,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aQo)
u.push(C.a3)
u.push(A.dO(D.beI,new B.bVM(s,d),A.eY(C.A,C.aq,D.b0C,v)))
return A.cv(!0,new A.H(C.E8,A.I(u,C.ak,C.d,C.P,0,C.l),v),C.K,!0)},
$S:370}
B.bVR.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.hP,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.cz(v,A.d("\u0622\u064a\u0629 "+E.bK(v),u,u,u,u,u,u,u,u),C.aE,u,w))
return A.V(A.I(A.a([t,P.Ex(C.di,!0,s,320,new B.bVO(this.b,f),D.b8K,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1080}
B.bVO.prototype={
$1(d){return d==null?null:this.a.$1(new B.bVN(this.b,d))},
$S:54}
B.bVN.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.bVQ.prototype={
$3(d,e,f){var x=null
return A.bXg(x,A.d(d,x,x,x,x,x,x,x,x),new B.bVJ(this.a,this.b,e,f))},
$S:1081}
B.bVJ.prototype={
$0(){var x=this
return x.b.$1(new B.bVI(x.a,x.c,x.d))},
$S:0}
B.bVI.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.bVK.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.bVL.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.bVM.prototype={
$0(){var x=this.a
return A.O(this.b,!1).ao(new A.a4(x.b,x.c))},
$S:0}
B.bOu.prototype={
$0(){},
$S:0}
B.bOK.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.lO
x.w=x.r=null
x.x=!1
x.at=x.as=null},
$S:0}
B.bOO.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.k_:D.lO},
$S:0}
B.bOP.prototype={
$0(){var x=this.a
x.f=D.ua
x.as=null},
$S:0}
B.bOQ.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bOS.prototype={
$0(){var x=this.a
x.f=D.ub
x.as=null
x.y=0
x.z=new A.bq(Date.now(),0,!1)
x.at=null},
$S:0}
B.bOT.prototype={
$1(d){var x=this.a
if(x.c!=null)x.l(new B.bOR())},
$S:31}
B.bOR.prototype={
$0(){},
$S:0}
B.bOV.prototype={
$1(d){return this.a.y=d},
$S:73}
B.bOU.prototype={
$1(d){return this.a.AY()},
$S:6}
B.bOW.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.k_:D.lO
x.as=this.b.gih()},
$S:0}
B.bOY.prototype={
$0(){var x=this.a
x.f=D.om
x.ax=Date.now()},
$S:0}
B.bOZ.prototype={
$1(d){var x=this.a
if(x.c!=null)x.l(new B.bOX())},
$S:31}
B.bOX.prototype={
$0(){},
$S:0}
B.bOJ.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.k_:D.lO
x.as=this.b},
$S:0}
B.bOL.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.k_
x.x=!1},
$S:0}
B.bOC.prototype={
$0(){var x=this.a
x.f=D.om
x.ax=Date.now()
x.as=null},
$S:0}
B.bOD.prototype={
$1(d){var x=this.a
if(x.c!=null)x.l(new B.bOB())},
$S:31}
B.bOB.prototype={
$0(){},
$S:0}
B.bOE.prototype={
$1(d){return d.d!==D.iF},
$S:z+11}
B.bOF.prototype={
$0(){return this.a.at=this.b},
$S:0}
B.bP3.prototype={
$0(){return B.cbK(this.a)},
$S:0}
B.bP4.prototype={
$1(d){var x=this.a.d
return x.qb(x.b.amK(d))},
$S:3}
B.bP5.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aB(A.aA(new B.bP2(this.a),null,x),x)},
$S:0}
B.bP2.prototype={
$1(d){var x=this.a.a
return new B.BR(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bOI.prototype={
$2(d,e){return C.b6},
$S:19}
B.bOH.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a4A(s.c,r).a.a){case 2:s=D.dj
break
case 1:s=D.dL
break
case 0:s=C.kk
break
default:s=u}x=A.u(18)
w=t.f===D.om?u:new B.bOG(t,r)
v=s.ak(0.25)
if(r===t.gjl())s=C.h
s=A.aC(s,r===t.gjl()?2:1)
return A.bB(!1,x,!0,A.C(C.N,A.d(E.bK(r),u,u,u,u,C.a_D,u,u,u),C.j,u,u,new A.E(v,u,s,u,u,u,u,C.bZ),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:57}
B.bOG.prototype={
$0(){return this.a.Yt(this.b)},
$S:0}
B.bON.prototype={
$0(){var x=this.a
return x.l(new B.bOM(x))},
$S:0}
B.bOM.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bP_.prototype={
$1(d){return d===D.tV},
$S:z+2}
B.bP0.prototype={
$1(d){return d===D.tW},
$S:z+2}
B.bP1.prototype={
$1(d){return d===D.tX},
$S:z+2}
B.bOv.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Q8(x)},
$S:0}
B.bOw.prototype={
$1(d){var x=this.a.d
return x.qb(x.b.b61(d.ga5(d)))},
$S:145}
B.bOy.prototype={
$1(d){return d.n(0,C.a_)?C.aq:C.h},
$S:5}
B.bOx.prototype={
$1(d){return d.n(0,C.a_)?C.A:C.a8},
$S:5}
B.bOz.prototype={
$0(){var x=this.a
return x.Yt(x.gjl()+1)},
$S:0}
B.bOA.prototype={
$0(){var x=this.a
return x.Yt(x.gjl()+1)},
$S:0}
B.bOd.prototype={
$0(){},
$S:0}
B.bOm.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.bq(Date.now(),0,!1)},
$S:0}
B.bOn.prototype={
$1(d){var x=this.a
if(x.c!=null)x.l(new B.bOl())},
$S:31}
B.bOl.prototype={
$0(){},
$S:0}
B.bOp.prototype={
$1(d){return this.a.x=d},
$S:73}
B.bOo.prototype={
$1(d){return this.a.EQ(this.b,!1)},
$S:6}
B.bOq.prototype={
$0(){var x=this.a
x.e=null
x.Q=this.b.gih()},
$S:0}
B.bOh.prototype={
$0(){var x=this.a
x.e=null
x.r.F(0,this.b)},
$S:0}
B.bOi.prototype={
$0(){var x=this.a,w=this.b
x.r.J(0,w)
x.w.q(0,w,this.c.gih())},
$S:0}
B.bOj.prototype={
$1(d){var x=0,w=A.k(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k,j,i,h
var $async$$1=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:v=3
o=s.a
n=o.d
x=6
return A.c(n.a.asm(s.b),$async$$1)
case 6:r=f
m=s.c
l=o.a
k=l.f
l=l.c
q=B.cad(G.awN(l,m,k.HV(l,m)).b,r.a)
if(C.c.R(q.c).length!==0){l=n.c
k=o.a.c
j=q.grS()
l.aru(k,m,n.b.a,j)}n.z3()
if(o.c!=null)o.l(new B.bOe(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a9(h)
if(o instanceof B.l8){p=o
o=s.a
if(o.c!=null)o.l(new B.bOf(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.l(new B.bOg(o,s.c))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$1,w)},
$S:118}
B.bOe.prototype={
$0(){var x=this.c
this.a.f.q(0,this.b,x)
return x},
$S:0}
B.bOf.prototype={
$0(){var x=this.c.gih()
this.a.w.q(0,this.b,x)
return x},
$S:0}
B.bOg.prototype={
$0(){return this.a.r.J(0,this.b)},
$S:0}
B.bOk.prototype={
$0(){var x=this.a
x.f.ap(0)
x.w.ap(0)},
$S:0}
B.bOr.prototype={
$1(d){return d.grS()},
$S:z+13}
B.bOs.prototype={
$0(){return this.a.EQ(this.b,!0)},
$S:0}
B.bOt.prototype={
$0(){return this.a.Hk(this.b)},
$S:0}
B.bO4.prototype={
$0(){},
$S:0}
B.bOb.prototype={
$2(d,e){return d+this.a.a4r(e)},
$S:106}
B.bOc.prototype={
$2(d,e){return d+H.dp[e-1].a[1]},
$S:106}
B.bOa.prototype={
$0(){return this.a.MV(this.b)},
$S:0}
B.bO9.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(G.jU(p),q,q,q,q,C.nW,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.b5(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.qn():r).a.a){case 2:r=D.dj.ak(0.35)
break
case 1:r=D.dL.ak(0.35)
break
case 0:r=C.fC
break
default:r=q}m.push(A.C(C.N,A.d(E.bK(t),q,q,q,q,C.ls,q,q,q),C.j,q,q,new A.E(r,q,q,new A.co(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cv(!0,new A.H(C.ho,A.I(A.a([o,C.an,D.biH,C.u,new A.dt(D.a4L,A.fK(A.d0(C.aA,m,C.aH,6,6),q,C.r,q,q,q,C.v),q),C.a0,A.bt(D.bkf,q,q,new B.bO8(w,d,p),q,q)],n),C.ak,C.d,C.P,0,C.l),q),C.K,!0)},
$S:32}
B.bO8.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dr(null,null,!0,null,new B.bO7(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Kb(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e8()
case 3:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.bO7.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+G.jU(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dy(A.a([A.bt(C.eg,x,x,new B.bO5(d),x,x),A.bt(C.o9,x,x,new B.bO6(d),x,x)],y.p),w,D.blG)},
$S:14}
B.bO5.prototype={
$0(){A.O(this.a,!1).ao(!1)
return null},
$S:0}
B.bO6.prototype={
$0(){A.O(this.a,!1).ao(!0)
return null},
$S:0}
B.bWo.prototype={
$1(d){var x=this.a
return new A.lQ(new B.bWn(x),null,x,null)},
$S:1082}
B.bWn.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.b,r=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)r.push(new A.eK(w,u,A.d(E.bK(w),u,u,u,u,u,u,u,u),x))
x=y.S
v=y.b
return A.cv(!0,A.fK(A.I(A.a([D.bbu,C.a0,D.bkD,C.M,A.rN(new B.bWi(t,s),r,A.d5([s.a],x),!1,A.jZ(u,u,u,new A.bm(new B.bWj(),v),u,u,u,u,new A.bm(new B.bWk(),v),u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u),x),C.B,A.iv(C.A,C.K,u,new B.bWl(t,s),D.bgo,D.bnx,s.c),A.iv(C.A,C.K,u,new B.bWm(t,s),u,D.bb5,s.d),C.B,D.a1v],y.p),C.ak,C.d,C.e,0,C.l),u,C.r,C.ho,u,u,C.v),C.K,!0)},
$S:1083}
B.bWi.prototype={
$1(d){return this.a.qb(this.b.b5Z(d.ga5(d)))},
$S:145}
B.bWk.prototype={
$1(d){return d.n(0,C.a_)?C.aq:C.h},
$S:5}
B.bWj.prototype={
$1(d){return d.n(0,C.a_)?C.A:C.a8},
$S:5}
B.bWl.prototype={
$1(d){return this.a.qb(this.b.b5n(d))},
$S:3}
B.bWm.prototype={
$1(d){return this.a.qb(this.b.amK(d))},
$S:3}
B.b0V.prototype={
$0(){return A.cB(A.bs(this.a,0,null),C.aV,null)},
$S:0};(function installTearOffs(){var x=a._instance_0u
var w
x(w=B.Tn.prototype,"gbbX","Cp",0)
x(w,"gaAU","w5",0)
x(w=B.YB.prototype,"gnT","wg",1)
x(w,"gaUt","OK",0)
x(w=B.a_Z.prototype,"gnT","wg",1)
x(w,"gaWZ","P4",0)
x(w,"gb1q","AY",0)
x(w,"gaGn","MS",0)
x(w=B.a_Y.prototype,"gnT","wg",1)
x(w,"gaXM","aXN",1)
x(B.a_X.prototype,"gnT","wg",1)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a3,[B.b0W,B.To,B.I2,B.I4,B.I3,B.l8,B.Qt,B.ml,B.GE,B.qy,B.agh,B.Tm])
x(A.nn,[B.b0X,B.b0Z,B.b13,B.b14,B.b16,B.b15,B.aSb,B.b1c,B.bBJ,B.bBI,B.bBw,B.bBD,B.bBG,B.bBH,B.bBz,B.bBy,B.bBB,B.bBx,B.bBE,B.bVN,B.bVJ,B.bVI,B.bVM,B.bOu,B.bOK,B.bOO,B.bOP,B.bOQ,B.bOS,B.bOR,B.bOW,B.bOY,B.bOX,B.bOJ,B.bOL,B.bOC,B.bOB,B.bOF,B.bP3,B.bP5,B.bOG,B.bON,B.bOM,B.bOv,B.bOz,B.bOA,B.bOd,B.bOm,B.bOl,B.bOq,B.bOh,B.bOi,B.bOe,B.bOf,B.bOg,B.bOk,B.bOs,B.bOt,B.bO4,B.bOa,B.bO8,B.bO5,B.bO6,B.b0V])
x(A.ju,[B.b1_,B.b11,B.b12,B.b10,B.aSa,B.bTU,B.b1a,B.b1b,B.b18,B.bBK,B.bBL,B.bBM,B.bBC,B.bBF,B.bBA,B.bVS,B.bVR,B.bVO,B.bVQ,B.bVK,B.bVL,B.bOT,B.bOV,B.bOU,B.bOZ,B.bOD,B.bOE,B.bP4,B.bP2,B.bP_,B.bP0,B.bP1,B.bOw,B.bOy,B.bOx,B.bOn,B.bOp,B.bOo,B.bOj,B.bOr,B.bO9,B.bO7,B.bWo,B.bWi,B.bWk,B.bWj,B.bWl,B.bWm])
x(A.y6,[B.b0Y,B.bS_,B.b1d,B.b1e,B.bVP,B.bOI,B.bOH,B.bOb,B.bOc,B.bWn])
x(A.W0,[B.mU,B.DI,B.FL,B.CM])
w(B.Tn,A.iE)
x(A.L,[B.vE,B.BS,B.BR,B.BQ])
x(A.N,[B.YB,B.a_Z,B.a_Y,B.a_X])
x(A.a5,[B.FM,B.VB,B.C7,B.agg])})()
A.D7(b.typeUniverse,JSON.parse('{"l8":{"bI":[]},"BS":{"L":[],"l":[]},"BR":{"L":[],"l":[]},"BQ":{"L":[],"l":[]},"Tn":{"aB":[]},"vE":{"L":[],"l":[]},"YB":{"N":["vE"]},"FM":{"a5":[],"l":[]},"VB":{"a5":[],"l":[]},"a_Z":{"N":["BS"]},"C7":{"a5":[],"l":[]},"a_Y":{"N":["BR"]},"a_X":{"N":["BQ"]},"agg":{"a5":[],"l":[]}}'))
var y=(function rtii(){var x=A.as
return{u:x("qy"),c:x("eK<y>"),r:x("cz<y>"),k:x("G<ml>"),n:x("G<eK<y>>"),I:x("G<cz<y>>"),R:x("G<hu>"),Y:x("G<aQ<o,@>>"),d:x("G<Qt>"),s:x("G<o>"),p:x("G<l>"),t:x("G<y>"),m:x("bP"),j:x("a7<@>"),L:x("a7<y>"),P:x("aQ<o,@>"),f:x("aQ<@,@>"),x:x("au<o,y>"),a:x("bD"),K:x("a3"),B:x("GE"),l:x("+(y,y)"),e:x("d6<ml>"),N:x("o"),C:x("I2"),D:x("I3"),O:x("To"),_:x("I4"),U:x("ap<o>"),G:x("mU"),q:x("qd"),b:x("bm<U?>"),y:x("Q"),i:x("a1"),z:x("@"),S:x("y"),A:x("bP?"),X:x("a3?"),M:x("+quota,usage(y,y)?"),o:x("fe"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.ov=new B.DI(0,"none")
D.ow=new B.DI(1,"learning")
D.f0=new B.DI(2,"memorized")
D.a4L=new A.ay(0,1/0,0,320)
D.eD=new A.U(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a4T=new A.E(D.eD,null,null,null,null,null,null,C.bZ)
D.dL=new A.U(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.dj=new A.U(1,0.20392156862745098,0.8274509803921568,0.6,C.p)
D.aor=new A.F(C.G2,null,C.dy,null,null,null)
D.blO=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.hM,null,null,null,null,null,null,null,null)
D.b49=new A.r(!0,C.fF,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.biJ=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.b49,null,null,null,null,null,null,null,null)
D.aEL=x([D.aor,C.M,D.blO,D.biJ],y.p)
D.acJ=new A.f2(C.v,C.d,C.e,C.i,null,C.l,null,0,D.aEL,null)
D.bwz=new A.bA(25e6)
D.aft=new A.Z(0,26,0,26)
D.afQ=new A.Z(14,12,14,14)
D.agu=new A.Z(3,0,0,0)
D.ajZ=new A.T(63251,"MaterialIcons",null,!1)
D.q_=new A.T(63677,"MaterialIcons",null,!1)
D.akQ=new A.T(983443,"MaterialIcons",null,!1)
D.xa=new A.T(983516,"MaterialIcons",null,!1)
D.akJ=new A.T(983209,"MaterialIcons",null,!1)
D.alo=new A.F(D.akJ,28,C.A,null,null,null)
D.am_=new A.F(C.FM,null,C.kk,null,null,null)
D.ajI=new A.T(62961,"MaterialIcons",null,!1)
D.amD=new A.F(D.ajI,null,null,null,null,null)
D.ajY=new A.T(63199,"MaterialIcons",null,!1)
D.amE=new A.F(D.ajY,null,null,null,null,null)
D.amN=new A.F(C.kC,null,C.fF,null,null,null)
D.amQ=new A.F(D.xa,44,C.h,null,null,null)
D.anh=new A.F(D.q_,null,D.eD,null,null,null)
D.any=new A.F(C.pV,null,D.eD,null,null,null)
D.anV=new A.F(D.q_,null,null,null,null,null)
D.aon=new A.F(C.jd,20,D.dL,null,null,null)
D.aoJ=new A.F(C.q1,30,C.A,null,null,null)
D.akf=new A.T(63520,"MaterialIcons",null,!1)
D.apy=new A.F(D.akf,null,null,null,null,null)
D.apI=new A.F(C.mM,null,null,null,null,null)
D.ajz=new A.T(62842,"MaterialIcons",null,!0)
D.apU=new A.F(D.ajz,null,null,null,null,null)
D.Hz=x([1,3,5],y.t)
D.Il=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aQV=new A.H(C.mx,C.oK,null)
D.aBC=x([D.aQV],y.p)
D.ak9=new A.T(63450,"MaterialIcons",null,!1)
D.aUN=new A.a4(D.ak9,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.aUC=new A.a4(D.q_,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.aV3=new A.a4(C.dm,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.akt=new A.T(63625,"MaterialIcons",null,!1)
D.aVd=new A.a4(D.akt,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aDI=x([D.aUN,D.aUC,D.aV3,D.aVd],A.as("G<+(T,o)>"))
D.aG2=x([D.ov,D.ow,D.f0],A.as("G<DI>"))
D.MU=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aNf=new B.FL(0,"idle")
D.T_=new B.FL(1,"loading")
D.jt=new B.FL(2,"ready")
D.aNg=new B.FL(3,"failed")
D.ang=new A.F(C.c0,18,D.dj,null,null,null)
D.a0l=new A.r(!0,C.ar,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmJ=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,D.a0l,null,null,null,null,null,null,null,null)
D.aAu=x([D.ang,C.b6,D.bmJ],y.p)
D.aZ3=new A.em(C.af,C.d,C.e,C.i,null,C.l,null,0,D.aAu,null)
D.aPX=new A.H(C.aU,D.aZ3,null)
D.agr=new A.Z(2,6,2,4)
D.b3O=new A.r(!0,C.A,null,null,null,null,14,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bbs=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.b3O,null,null,null,null,null,null,null,null)
D.aQ9=new A.H(D.agr,D.bbs,null)
D.bn6=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.hM,null,null,null,null,null,null,null,null)
D.aBW=x([M.td,C.I,D.bn6],y.p)
D.aYZ=new A.em(C.af,C.cD,C.e,C.i,null,C.l,null,0,D.aBW,null)
D.aQj=new A.H(C.DS,D.aYZ,null)
D.A9=new A.r(!0,D.dL,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bnp=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.A9,null,null,null,null,null,null,null,null)
D.aQo=new A.H(C.dM,D.bnp,null)
D.bmD=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.b9,C.a5,null,null,null,null,null,null,null)
D.aQv=new A.H(C.C,D.bmD,null)
D.ago=new A.Z(2,0,2,8)
D.biY=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.b9,null,null,null,null,null,null,null,null)
D.aQM=new A.H(D.ago,D.biY,null)
D.aph=new A.F(C.kE,30,C.A,null,null,null)
D.bo3=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Aa,null,null,null,null,null,null,null,null)
D.ahA=new A.bM(1,C.ac,D.bo3,null)
D.aCa=x([D.aph,C.Y,D.ahA],y.p)
D.aYN=new A.em(C.af,C.d,C.e,C.i,null,C.l,null,0,D.aCa,null)
D.aoV=new A.F(C.dm,18,D.dj,null,null,null)
D.a_N=new A.r(!0,D.dj,null,null,null,null,12,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmm=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a_N,null,null,null,null,null,null,null,null)
D.aAV=x([D.aoV,C.bX,D.bmm],y.p)
D.aYX=new A.em(C.af,C.d,C.P,C.i,null,C.l,null,0,D.aAV,null)
D.b0b=new A.P(0,30)
D.tc=new A.P(1/0,54)
D.b0C=new A.P(1/0,48)
D.b0F=new A.P(1/0,50)
D.b0I=new A.P(1/0,52)
D.b3j=new A.r(!0,C.h,null,null,null,null,14.5,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b3z=new A.r(!0,C.h,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.zT=new A.r(!0,D.eD,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.jR=new A.r(!0,C.h,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b6V=new A.r(!0,D.eD,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b7m=new A.r(!0,C.A,null,null,null,null,24,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b7E=new A.r(!0,C.A,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b8s=new A.r(!0,D.dL,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b8t=new A.r(!0,D.dj,null,null,null,null,null,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b8K=new A.r(!0,C.h,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bap=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.hP,null,null,null,null,null,null,null,null)
D.bb5=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.dI,null,null,null,null,null,null,null,null)
D.bbu=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.nW,null,null,null,null,null,null,null,null)
D.bby=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.b9,null,null,null,null,null,null,null,null)
D.bbX=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.b9,null,null,null,null,null,null,null,null)
D.bcl=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.hM,null,null,null,null,null,null,null,null)
D.be_=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cy,null,null,null,null,null,null,null,null)
D.beI=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bR,null,null,null,null,null,null,null,null)
D.beN=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.b9,null,null,null,null,null,null,null,null)
D.bfd=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.Ad,null,null,null,null,null,null,null,null)
D.bgo=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u062a\u064a\u0646 \u0633\u0643\u0648\u062a",null,F.b9,null,null,null,null,null,null,null,null)
D.bgq=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bgW=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,I.o_,null,null,null,null,null,null,null,null)
D.bhQ=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.A9,null,null,null,null,null,null,null,null)
D.bio=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.c5,null,null,null,null,null,null,null,null)
D.biH=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.b9,null,null,null,null,null,null,null,null)
D.biZ=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.b9,null,null,null,null,null,null,null,null)
D.b6B=new A.r(!0,D.eD,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bkf=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.b6B,null,null,null,null,null,null,null,null)
D.bkD=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,I.o_,null,null,null,null,null,null,null,null)
D.bl8=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a_f,null,null,null,null,null,null,null,null)
D.blm=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cy,null,null,null,null,null,null,null,null)
D.blG=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.blX=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bmv=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.b9,null,null,null,null,null,null,null,null)
D.bmw=new A.m("\u062e\u0644\u0635\u062a",null,N.A2,null,null,null,null,null,null,null,null)
D.bmx=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.A9,null,null,null,null,null,null,null,null)
D.bnt=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.c5,null,null,null,null,null,null,null,null)
D.bnx=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.dI,null,null,null,null,null,null,null,null)
D.bo2=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.b9,null,null,null,null,null,null,null,null)
D.a1v=new B.agg(null)
D.bpk=new B.BQ(null)
D.bpl=new B.Tm(2,1,!0,!1,!1)
D.a1A=new B.To(!1,!1,!1,!1,!1,0)
D.iF=new B.mU(0,"ok")
D.tV=new B.mU(1,"near")
D.tW=new B.mU(2,"wrong")
D.tX=new B.mU(3,"missing")
D.a2_=new B.mU(4,"extra")
D.akb=new A.T(63456,"MaterialIcons",null,!1)
D.btc=new B.C7(D.dL,D.akb,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.btP=new B.VB(!1,null)
D.AJ=new B.VB(!0,null)
D.lO=new B.CM(0,"idle")
D.ua=new B.CM(1,"playing")
D.ub=new B.CM(2,"recording")
D.om=new B.CM(3,"thinking")
D.k_=new B.CM(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cBb","cdh",()=>new B.b0W())
x($,"cEq","cfy",()=>A.aW("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cEr","cfz",()=>A.aW("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cED","cfI",()=>A.aW("\u0648\u0670",!0,!1,!1))
x($,"cDZ","cfe",()=>A.aW("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cCl","ce5",()=>A.aW("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cDv","ceR",()=>A.aW("[\u0654\u0655]",!0,!1,!1))
x($,"cCm","ce6",()=>A.aW("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cCt","cec",()=>A.aW("[\u0624\u0626]",!0,!1,!1))
x($,"cDx","ceT",()=>A.aW("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cE3","cfh",()=>A.aW("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cDF","cf_",()=>A.aW("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cEo","c1v",()=>A.aW("\\s+",!0,!1,!1))
x($,"cyz","qn",()=>B.cgx(D.ov,0,A.chP(0,!0)))
x($,"cBc","KQ",()=>new B.Tn($.cdh(),D.bpl,B.cog(),D.aNf,$.S()))})()};
(a=>{a["Qaiyn0mTEc2HJioV5TxWlUVuQos="]=a.current})($__dart_deferred_initializers__);