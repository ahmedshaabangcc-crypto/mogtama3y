((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,O,M,P,N,G,I,B={
cpm(d){var x,w,v,u,t,s
if(d instanceof B.l8)return d
try{x=A.eF(d)
w=x.code
v=x.message
u=w==null?"failed":A.a0(w)
t=v==null?"":A.a0(v)
return new B.l8(u,t)}catch(s){u=A.n(d)
return new B.l8("failed",u)}},
b1b:function b1b(){this.b=this.a=null},
b1c:function b1c(d){this.a=d},
b1f:function b1f(){},
b1e:function b1e(d,e,f){this.a=d
this.b=e
this.c=f},
b1d:function b1d(d){this.a=d},
b1j:function b1j(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
b1h:function b1h(d){this.a=d},
b1i:function b1i(d){this.a=d},
b1k:function b1k(d){this.a=d},
b1m:function b1m(d,e){this.a=d
this.b=e},
b1l:function b1l(d,e){this.a=d
this.b=e},
b1g:function b1g(){},
cpn(d,e){return new B.l8(d,e)},
Tt:function Tt(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
I6:function I6(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
I8:function I8(d,e,f){this.a=d
this.b=e
this.c=f},
I7:function I7(d,e){this.a=d
this.b=e},
l8:function l8(d,e){this.a=d
this.b=e},
ccd(d){var x,w=$.cgF()
w=A.bR(d,w,"\u0627")
x=$.cgG()
w=A.bR(w,x,"\u064a")
x=$.cgP()
w=A.bR(w,x,"\u0627")
x=$.cfc()
w=A.bR(w,x,"\u0627")
x=$.cgl()
w=A.bR(w,x,"\u0621")
x=$.cfY()
w=A.bR(w,x,"\u0621")
x=$.cfd()
w=A.bR(w,x,"\u0627")
x=$.cfj()
w=A.bR(w,x,"\u0621")
w=A.bR(w,"\u0649","\u064a")
w=A.bR(w,"\u0629","\u0647")
x=$.cg_()
w=A.bR(w,x,"")
x=$.cgo()
w=A.bR(w,x," ")
x=$.cg6()
w=A.bR(w,x," ")
x=$.c2y()
return C.c.P(A.bR(w,x," "))},
ctY(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.k8(x,w)
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
bXK(d,e){var x,w,v,u,t,s
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
s=1-B.ctY(d,e)/u
return s>=1?0.99:s},
bX2(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.vW(d,$.c2y()),w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.length===0)continue
t=B.ccd(u)
s=A.bR(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Qy(r.a+" "+u,r.b))}continue}q.push(new B.Qy(u,s))}return q},
csL(d,e){var x,w,v,u,t=new B.bT1(),s=A.a([],y.s)
for(x=A.h3(e,0,A.jr(5,"count",y.S),A.ak(e).c),w=x.$ti,x=new A.cb(x,x.gM(0),w.i("cb<aY.E>")),w=w.i("aY.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.It)&&t.$2(d,D.It)?C.b.jN(d,5):d
return!t.$2(s,D.N2)&&t.$2(u,D.N2)?C.b.jN(u,4):u},
cbh(d,e){var x=B.bX2(d),w=B.ccd(e),v=y.U
v=A.ab(new A.ao(A.a(w.split(" "),y.s),new B.bUW(),v),v.i("Y.E"))
return new B.GI(x,B.crW(x,B.csL(v,x)),w)},
crW(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.K)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.ch(x,0,!1,s)
q=A.ch(x,0,!1,y.S)
p=A.ch(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.bXK(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.bXK(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.bXK(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
else m=a2>=0.6?D.u_:D.u0
a1.push(new B.mm(o,x,s,m))
break
case 1:--o
a1.push(new B.mm(o,a4[o],null,D.u1))
break
case 2:--n
a1.push(new B.mm(null,null,a6[n],D.a29))
break
case 3:--o
a3=n-2
a1.push(new B.mm(o,a4[o],a6[a3]+" "+a6[n-1],D.iF))
n=a3
break
default:x=o-1;--n
a1.push(new B.mm(x,a4[x],a6[n],D.iF))
o-=2
a1.push(new B.mm(o,a4[o],a6[n],D.iF))}}a4=y.e
a4=A.ab(new A.d6(a1,a4),a4.i("aY.E"))
return a4},
mW:function mW(d,e){this.a=d
this.b=e},
Qy:function Qy(d,e){this.a=d
this.b=e},
mm:function mm(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
GI:function GI(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aSr:function aSr(d){this.a=d},
aSq:function aSq(){},
bT1:function bT1(){},
bUW:function bUW(){},
chE(d,e,f){return new B.qz(d,e,f)},
cuQ(d){var x
A:{if("memorized"===d){x=D.f0
break A}if("learning"===d){x=D.oy
break A}x=D.ox
break A}return x},
cd_(d,e){return d>=1&&d<=114&&e>=1&&e<=H.dp[d-1].a[1]},
cpo(){var x=y.S
return new B.agr(A.D(x,y.u),A.aU(x))},
b1p(d){var x=d.f5()
return C.c.dw(C.j.j(A.bp(x)),4,"0")+"-"+C.c.dw(C.j.j(A.bq(x)),2,"0")+"-"+C.c.dw(C.j.j(A.bU(x)),2,"0")},
c8p(d){var x=y.x,w=A.ab(new A.au(A.a(d.split("-"),y.s),A.cwb(),x),x.i("aY.E"))
return B.b1p(A.dc(w[0],w[1],w[2]-1,12,0,0,0))},
c_M(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.D(p,y.u),n=A.aU(p),m=new B.agr(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcM(),x=x.ga_(x),w=y.j;x.v();){v=x.gK()
u=A.em(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aT(t)>=3){v=C.j.aO(u,1000)
s=C.j.a2(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=H.dp[v-1].a[1])}if(v)continue
v=J.b6(t)
r=C.f.co(A.de(v.h(t,0)))
if(r<0||r>=3)continue
o.q(0,u,new B.qz(D.aGo[r],C.f.co(A.de(v.h(t,1))),new A.bh(A.lw(C.f.co(A.de(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.axm(q,y.o)
p=A.lS(x,new B.b1o(),x.$ti.i("Y.E"),p)
n.A(0,new A.ao(p,o.ga29(),A.y(p).i("ao<Y.E>")))}m.c=A.v(d.h(0,"last"))
p=A.aS(d.h(0,"streak"))
p=p==null?null:C.f.co(p)
p=m.d=p==null?0:p
o=A.aS(d.h(0,"best"))
o=o==null?null:C.f.co(o)
m.e=o==null?p:o
return m},
awK(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dw(C.j.j(d),3,"0")+C.c.dw(C.j.j(e),3,"0")+".mp3"},
DL:function DL(d,e){this.a=d
this.b=e},
qz:function qz(d,e,f){this.a=d
this.b=e
this.c=f},
agr:function agr(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b1q:function b1q(){},
b1r:function b1r(){},
b1o:function b1o(){},
Tr:function Tr(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cmW(){return new B.vF(null)},
cyl(d,e){var x,w,v,u,t={},s=H.dp[e-1].a[1],r=$.KU().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.qo():v).a===D.f0}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.da(u+4,1,s)
return A.eh(C.di,new B.bWV(t,s,e),d,!0,null,null,y.l)},
c1t(d){return A.dY(0,0,0,0,0,C.j.da(C.f.aA(6+d*1.2),25,90))},
c0x(d){return E.bK(C.j.aO(d,60))+":"+C.c.dw(E.bK(C.j.a2(d,60)),2,"\u0660")},
ccR(d){return A.eh(C.di,new B.bXr($.KU()),d,!0,null,null,y.H)},
FP:function FP(d,e){this.a=d
this.b=e},
Ts:function Ts(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=null
_.e=!1
_.f=g
_.w=_.r=0
_.as=_.Q=_.z=_.y=_.x=null
_.at=!1
_.L$=0
_.p$=h
_.U$=_.S$=0},
b1s:function b1s(d){this.a=d},
b1t:function b1t(d){this.a=d},
b1u:function b1u(d){this.a=d},
vF:function vF(d){this.a=d},
YI:function YI(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bCM:function bCM(d){this.a=d},
bCL:function bCL(d,e){this.a=d
this.b=e},
bCN:function bCN(d){this.a=d},
bCK:function bCK(d,e){this.a=d
this.b=e},
bCO:function bCO(){},
bCy:function bCy(){},
bCE:function bCE(d,e,f){this.a=d
this.b=e
this.c=f},
bCF:function bCF(){},
bCI:function bCI(d){this.a=d},
bCH:function bCH(){},
bCJ:function bCJ(d){this.a=d},
bCB:function bCB(d,e){this.a=d
this.b=e},
bCC:function bCC(d){this.a=d},
bCA:function bCA(){},
bCD:function bCD(d){this.a=d},
bCz:function bCz(d){this.a=d},
bCG:function bCG(d,e){this.a=d
this.b=e},
FQ:function FQ(d,e,f){this.c=d
this.d=e
this.a=f},
VG:function VG(d,e){this.c=d
this.a=e},
bWV:function bWV(d,e,f){this.a=d
this.b=e
this.c=f},
bWS:function bWS(d,e,f){this.a=d
this.b=e
this.c=f},
bWU:function bWU(d,e){this.a=d
this.b=e},
bWR:function bWR(d,e){this.a=d
this.b=e},
bWQ:function bWQ(d,e){this.a=d
this.b=e},
bWT:function bWT(d,e){this.a=d
this.b=e},
bWM:function bWM(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
bWL:function bWL(d,e,f){this.a=d
this.b=e
this.c=f},
bWN:function bWN(d){this.a=d},
bWO:function bWO(d){this.a=d},
bWP:function bWP(d,e){this.a=d
this.b=e},
CP:function CP(d,e){this.a=d
this.b=e},
BV:function BV(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a05:function a05(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.at=_.as=_.Q=_.z=null
_.ax=0
_.c=_.a=null},
bPw:function bPw(){},
bPM:function bPM(d,e){this.a=d
this.b=e},
bPQ:function bPQ(d){this.a=d},
bPR:function bPR(d){this.a=d},
bPS:function bPS(d,e,f){this.a=d
this.b=e
this.c=f},
bPU:function bPU(d){this.a=d},
bPV:function bPV(d){this.a=d},
bPT:function bPT(){},
bPX:function bPX(d){this.a=d},
bPW:function bPW(d){this.a=d},
bPY:function bPY(d,e){this.a=d
this.b=e},
bQ_:function bQ_(d){this.a=d},
bQ0:function bQ0(d){this.a=d},
bPZ:function bPZ(){},
bPL:function bPL(d,e){this.a=d
this.b=e},
bPN:function bPN(d,e,f){this.a=d
this.b=e
this.c=f},
bPE:function bPE(d){this.a=d},
bPF:function bPF(d){this.a=d},
bPD:function bPD(){},
bPG:function bPG(){},
bPH:function bPH(d,e){this.a=d
this.b=e},
bQ5:function bQ5(d){this.a=d},
bQ6:function bQ6(d){this.a=d},
bQ7:function bQ7(d,e){this.a=d
this.b=e},
bQ4:function bQ4(d){this.a=d},
bPK:function bPK(){},
bPJ:function bPJ(d){this.a=d},
bPI:function bPI(d,e){this.a=d
this.b=e},
bPP:function bPP(d){this.a=d},
bPO:function bPO(d){this.a=d},
bQ1:function bQ1(){},
bQ2:function bQ2(){},
bQ3:function bQ3(){},
bPx:function bPx(d,e,f){this.a=d
this.b=e
this.c=f},
bPy:function bPy(d){this.a=d},
bPA:function bPA(){},
bPz:function bPz(){},
bPB:function bPB(d){this.a=d},
bPC:function bPC(d){this.a=d},
Ca:function Ca(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
BU:function BU(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a04:function a04(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.Q=_.z=_.y=null
_.as=h
_.c=_.a=null},
bPf:function bPf(){},
bPo:function bPo(d,e){this.a=d
this.b=e},
bPp:function bPp(d){this.a=d},
bPn:function bPn(){},
bPr:function bPr(d){this.a=d},
bPq:function bPq(d,e){this.a=d
this.b=e},
bPs:function bPs(d,e){this.a=d
this.b=e},
bPj:function bPj(d,e){this.a=d
this.b=e},
bPk:function bPk(d,e,f){this.a=d
this.b=e
this.c=f},
bPl:function bPl(d,e,f){this.a=d
this.b=e
this.c=f},
bPg:function bPg(d,e,f){this.a=d
this.b=e
this.c=f},
bPh:function bPh(d,e,f){this.a=d
this.b=e
this.c=f},
bPi:function bPi(d,e){this.a=d
this.b=e},
bPm:function bPm(d){this.a=d},
bPt:function bPt(){},
bPu:function bPu(d,e){this.a=d
this.b=e},
bPv:function bPv(d,e){this.a=d
this.b=e},
BT:function BT(d){this.a=d},
a03:function a03(d){this.d=d
this.c=this.a=null},
bP6:function bP6(){},
bPd:function bPd(d){this.a=d},
bPe:function bPe(){},
bPc:function bPc(d,e){this.a=d
this.b=e},
bPb:function bPb(d,e,f){this.a=d
this.b=e
this.c=f},
bPa:function bPa(d,e,f){this.a=d
this.b=e
this.c=f},
bP9:function bP9(d){this.a=d},
bP7:function bP7(d){this.a=d},
bP8:function bP8(d){this.a=d},
bXr:function bXr(d){this.a=d},
bXq:function bXq(d){this.a=d},
bXl:function bXl(d,e){this.a=d
this.b=e},
bXn:function bXn(){},
bXm:function bXm(){},
bXo:function bXo(d,e){this.a=d
this.b=e},
bXp:function bXp(d,e){this.a=d
this.b=e},
agq:function agq(d){this.a=d},
b1a:function b1a(d){this.a=d}},D,H,K,E,F
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
B.b1b.prototype={
qC(){var x=this,w=x.a
if(w!=null)return A.ee(w,y.m)
w=x.b
return w==null?x.b=new B.b1c(x).$0():w},
tP(d,e){return this.aKe(d,e,e)},
aKe(d,e,f){var x=0,w=A.k(f),v,u=2,t=[],s,r,q,p
var $async$tP=A.f(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$tP)
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
r=B.cpm(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$tP,w)},
wi(d,e){var x=A.eu(d[e])
if(x==null)x=null
return x===!0},
LY(){var x=0,w=A.k(y.O),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$LY=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
i=A
x=7
return A.c(s.qC(),$async$LY)
case 7:r=i.fJ(e,"support",null,null,y.m)
q=s.wi(r,"worker")
p=s.wi(r,"wasm")
o=s.wi(r,"mic")
n=s.wi(r,"audio")
s.wi(r,"webgpu")
m=s.wi(r,"secure")
s.wi(r,"ios")
l=A.tK(r.memory)
if(l==null)l=null
if(l==null)l=0
v=new B.Tt(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
j=t.pop()
v=D.a1K
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$LY,w)},
DL(){var x=0,w=A.k(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$DL=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
x=8
return A.c(s.qC(),$async$DL)
case 8:x=7
return A.c(m.eG(l.fJ(e,"storage",null,null,y.m),y.A),$async$DL)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.aA(A.dD(r.quota))
p=C.f.aA(A.dD(r.usage))
v=new A.aqg(q,p)
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
return A.j($async$DL,w)},
beJ(){var x=y.K
A.NJ(this.qC().bD(new B.b1f(),x),x)},
bcb(d,e){return this.tP(new B.b1e(this,d,e),y.C)},
a7x(d,e,f,g){return this.tP(new B.b1j(this,e,d,g,f),y.H)},
a7A(){return this.tP(new B.b1k(this),y.D)},
a1N(){var x=this.a
if(x!=null)A.fJ(x,"cancelRecording",null,null,y.X)},
ajA(d){var x,w,v=A.v(d.text)
if(v==null)v=null
if(v==null)v=""
x=A.tK(d.ms)
x=x==null?null:C.f.aA(x)
if(x==null)x=0
w=A.tK(d.seconds)
if(w==null)w=null
return new B.I8(v,x,w==null?0:w)},
asu(d){return this.tP(new B.b1m(this,d),y._)},
bgQ(d){return this.tP(new B.b1l(this,d),y._)},
K3(d,e){return this.beN(d,e)},
beN(d,e){var x=0,w=A.k(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$K3=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.qC(),$async$K3)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.ak(d).i("au<1,o>")
o=A.ab(new A.au(d,new B.b1g(),o),o.i("aY.E"))
x=11
return A.c(A.eG(A.fJ(r,"play",o,e,y.m),y.y),$async$K3)
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
return A.j($async$K3,w)},
LF(){var x=this.a
if(x!=null)A.fJ(x,"stopPlayback",null,null,y.X)},
a55(d){var x=this.a
if(x!=null)A.fJ(x,"prefetch",d,null,y.X)}}
B.Tt.prototype={}
B.I6.prototype={}
B.I8.prototype={}
B.I7.prototype={}
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
B.mW.prototype={
R(){return"WordStatus."+this.b}}
B.Qy.prototype={}
B.mm.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.GI.prototype={
gLE(){var x,w=this,v=w.d
if(v===$){x=new B.aSr(w).$0()
w.d!==$&&A.am()
w.d=x
v=x}return v},
gIP(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.d===D.a29&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbd0(){return J.fZ(this.gLE(),new B.aSq()).gM(0)},
grU(){var x=this.a
return x.length!==0&&this.gbd0()===x.length&&this.gIP().length===0}}
B.DL.prototype={
R(){return"AyahStatus."+this.b}}
B.qz.prototype={}
B.agr.prototype={
a4I(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.qo():x},
aWt(d){var x=this,w=B.b1p(d),v=x.c
if(v===w)return
v=v!=null&&v===B.c8p(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
anm(){var x=Date.now(),w=B.b1p(new A.bh(x,0,!1))
x=this.c
return x===w||x===B.c8p(w)?this.d:0},
arC(d,e,f,g){var x=this,w=new A.bh(Date.now(),0,!1),v=x.a4I(d,e),u=g?C.j.da(v.b+1,0,100):0,t=g&&u>=f?D.f0:D.oy,s=new B.qz(t,u,w.kO()),r=d*1000+e
x.a.q(0,r,s)
x.b.F(0,r)
x.aWt(w)
return s},
a4z(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=H.dp[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qo():s).a===D.f0)++u}return u},
bbV(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=H.dp[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qo():s).a===D.oy)++u}return u},
gaqA(){var x=this.a,w=A.y(x).i("c8<2>")
return new A.ao(new A.c8(x,w),new B.b1q(),w.i("ao<Y.E>")).gM(0)},
gaw5(){var x=this.a,w=A.y(x).i("bF<1>")
w=A.lS(new A.bF(x,w),new B.b1r(),w.i("Y.E"),y.S)
w=A.eN(w,A.y(w).i("Y.E"))
x=A.ab(w,A.y(w).c)
C.b.mV(x)
return x},
dW(){var x,w,v,u,t,s=this,r=y.N,q=A.D(r,y.L)
for(x=s.a,x=new A.er(x,A.y(x).i("er<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.q(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.ab(x,A.y(x).c)
return A.I(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
b7T(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Y)
for(x=this.b,x=A.b_I(x,300,A.y(x).c),x=new A.HO(J.aL(x.a),x.b,A.y(x).i("HO<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gK()
s=C.j.aO(t,1000)
t=C.j.a2(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.qo():q).a===D.f0?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.qo()
r=u.h(0,r)
o.push(A.I(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.qo():r).c.lc()],w,v))}return o},
bct(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.K)(d),++u){t=d[u]
s=A.ev(t.h(0,"surah"))*1000+A.ev(t.h(0,"ayah"))
r=w.h(0,C.j.aO(s,1000)*1000+C.j.a2(s,1000))
if((r==null?$.qo():r).c.lc()===t.h(0,"updated_at"))v.J(0,s)}},
bcB(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aL(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gK()
if(!u.b(s))continue
r=A.aS(s.h(0,"surah"))
q=r==null?null:C.f.co(r)
r=A.aS(s.h(0,"ayah"))
p=r==null?null:C.f.co(r)
o=A.dW(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=H.dp[q-1].a[1])
if(r)continue
n=B.cuQ(s.h(0,"status"))
if(n===D.ox)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.aS(s.h(0,"perfect_count"))
l=l==null?null:C.f.co(l)
v.q(0,r,new B.qz(n,C.j.da(l==null?0:l,0,100),o.kO()))
w.J(0,r)
t=!0}return t}}
B.Tr.prototype={
Ig(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Tr(w,v,u,t,f==null?x.e:f)},
b6b(d){var x=null
return this.Ig(x,x,d,x,x)},
amS(d){var x=null
return this.Ig(x,d,x,x,x)},
b6f(d){var x=null
return this.Ig(x,x,x,x,d)},
b5B(d){var x=null
return this.Ig(d,x,x,x,x)},
b6c(d){var x=null
return this.Ig(x,x,x,d,x)},
dW(){var x=this
return A.I(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.FP.prototype={
R(){return"ModelState."+this.b}}
B.Ts.prototype={
v6(){var x=this.Q
return x==null?this.Q=new B.b1s(this).$0():x},
qc(d){return this.auk(d)},
auk(d){var x=0,w=A.k(y.H),v=this
var $async$qc=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:v.b=d
v.ad()
x=2
return A.c(K.oG("mt.tutor.settings",C.aN.lF(d.dW(),null)),$async$qc)
case 2:return A.i(null,w)}})
return A.j($async$qc,w)},
z7(){var x=0,w=A.k(y.H),v=this,u
var $async$z7=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:v.ad()
x=2
return A.c(K.oG("mt.tutor.progress",C.aN.lF(v.c.dW(),null)),$async$z7)
case 2:u=v.as
if(u!=null)u.aD()
v.as=A.cT(C.x,v.gaB1())
return A.i(null,w)}})
return A.j($async$z7,w)},
Lo(d,e,f){return this.av6(d,e,f)},
av6(d,e,f){var x=0,w=A.k(y.H),v=this
var $async$Lo=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:v.z=new A.aP(d,e,f)
x=2
return A.c(K.oG("mt.tutor.last",C.aN.lF(A.I(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Lo)
case 2:return A.i(null,w)}})
return A.j($async$Lo,w)},
Cu(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o
var $async$Cu=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:p=s.f
if(p===D.Tb||p===D.jt){x=1
break}s.f=D.Tb
s.y=null
s.ad()
u=4
p=A.mT().gfm().h(0,"tutor_device")
if(p==null)p="auto"
x=7
return A.c(s.a.bcb(new B.b1t(s),p),$async$Cu)
case 7:s.x=e
s.f=D.jt
p=A.mT().gfm().h(0,"debug")
if(p==="1"){p=s.x
A.Du().$1("[tutor] model ready: "+p.a+" "+p.b+" in "+p.c+" ms (cached before: "+p.d+")")}u=2
x=6
break
case 4:u=3
o=t.pop()
p=A.a9(o)
if(p instanceof B.l8){r=p
s.f=D.aNC
s.y=r
p=A.mT().gfm().h(0,"debug")
if(p==="1")A.Du().$1("[tutor] model failed: "+A.n(r))}else throw o
x=6
break
case 3:x=2
break
case 6:s.ad()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Cu,w)},
w8(){var x=0,w=A.k(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$w8=A.f(function(a0,a1){if(a0===1){t.push(a1)
x=u}for(;;)switch(x){case 0:if(r.at){x=1
break}q=null
try{k=$.A().b
k===$&&A.b()
k=k.ga4().e.a
q=(k==null?null:k.r)!=null}catch(d){x=1
break}if(!q){x=1
break}r.at=!0
u=4
k=$.A().b
k===$&&A.b()
p=k
x=7
return A.c(p.aQ("quran_tutor_progress").d4("surah, ayah, status, perfect_count, updated_at"),$async$w8)
case 7:o=a1
n=r.c.bcB(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.b7T()
if(J.aT(l)===0){x=10
break}h=p
g=A.I(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.mu(h.x,k,k))
x=11
return A.c(f.bgl("quran_tutor_save",!1,g,i),$async$w8)
case 11:r.c.bct(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(K.oG("mt.tutor.progress",C.aN.lF(r.c.dW(),null)),$async$w8)
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
return A.j($async$w8,w)},
Kh(d){return this.bg2(d)},
bg2(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Kh=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c_M(t.c.dW()).dW()
y.f.a(p.h(0,"rows")).eh(0,new B.b1u(d))
t.c=B.c_M(p)
x=2
return A.c(t.z7(),$async$Kh)
case 2:v=4
s=$.A().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.aB("quran_tutor_reset",A.I(["p_surah",d],y.N,r),r),$async$Kh)
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
return A.j($async$Kh,w)}}
B.vF.prototype={
O(){var x=$.KU()
return new B.YI(x,new A.af(C.J,$.R()))}}
B.YI.prototype={
X(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.gnV())
w=y.a
x.v6().bD(new B.bCM(v),w)
G.aQT().bD(new B.bCN(v),w).fJ(new B.bCO())
A.NJ(G.c_8(),y.y)},
wj(){if(this.c!=null)this.l(new B.bCy())},
m(){var x,w=this
w.d.V(w.gnV())
x=w.e
x.p$=$.R()
x.L$=0
w.a0()},
OR(){var x=0,w=A.k(y.H),v=this,u
var $async$OR=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.d
x=2
return A.c(u.qc(u.b.b6b(!0)),$async$OR)
case 2:u.a.beJ()
u.Cu()
return A.i(null,w)}})
return A.j($async$OR,w)},
xe(d,e,f){return this.aUo(d,e,f)},
b1C(d){return this.xe(d,null,null)},
aUo(d,e,f){var x=0,w=A.k(y.H),v,u=this,t,s,r
var $async$xe=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.Z(A.aO(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.a4(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cyl(s,d),$async$xe)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Lo(d,t.a,t.b),$async$xe)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.M(s,!1).aC(A.ay(new B.bCE(u,d,t),null,r),r),$async$xe)
case 8:if(u.c!=null)u.l(new B.bCF())
case 1:return A.i(v,w)}})
return A.j($async$xe,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=v.e
if(t)u.push(A.cd(x,x,x,D.apL,x,x,new B.bCI(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.cd(x,x,x,C.ia,x,x,new B.bCJ(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aBX
else w=t?this.aPC():this.aQc()
return E.wk(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aQc(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a1K
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.aZd,C.a0],x)
for(t=0;t<4;++t){s=D.aE2[t]
u.push(new A.H(C.bB,A.B(A.a([A.bb(s.a,C.ar,p,18),C.I,new A.bM(1,C.ac,A.d(s.b,p,p,p,p,D.b4_,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.J(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.boa,C.L,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bK(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.b9,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bK(C.f.aA(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.L,A.d(q,p,p,p,p,A.bQ(p,p,r?D.dN:C.dh,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.L,D.bnd],x))
x=A.a([new E.e8(u,C.a6,C.aU,p,!0,p),new E.e8(A.J(s,C.q,C.d,C.e,0,C.l),C.a6,C.aU,p,!1,p),D.buy,C.L],x)
if(v!=null)x.push(new E.e8(A.d(v,p,p,p,p,D.b8V,p,p,p),C.a6,C.aU,p,!1,p))
else x.push(A.h_(D.amQ,D.bev,this.gaUF(),A.eT(C.A,C.aq,D.b18,p)))
x.push(C.a3)
x.push(D.a1F)
return x},
aPC(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.P(r.a.a),p=q.length===0,o=p?C.qU:G.ccM(q),n=t.z,m=A.T(v.aiT(C.dm,E.bK(s.gaqA())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bK(s.anm()),k=s.c,j=Date.now()
k=k===B.b1p(new A.bh(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.FQ(t,!1,u),A.B(A.a([m,C.I,A.T(v.aiT(C.kD,l+" \u064a\u0648\u0645",k),1)],j),C.i,C.d,C.e,0,u,u),C.u],j)
if(n!=null){t=G.jV(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bK(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bK(m)+"\u2013"+E.bK(l)
k.push(new E.e8(A.B(A.a([D.aoV,C.Z,A.T(A.J(A.a([D.baS,A.d(t+" \u2014 "+m,u,u,u,u,C.c5,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),L.mW],j),C.i,C.d,C.e,0,u,u),C.a6,C.aU,new B.bCB(v,n),!0,u))}t=C.h.al(0.08)
k.push(A.aF(u,C.w,!1,u,!0,C.m,u,A.aG(),r,u,u,u,u,u,2,A.d8(u,new A.ce(4,A.u(14),C.M),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.A3,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.xs,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bCC(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.dK,!0,C.t,u,C.E,u,u,u,u))
k.push(C.u)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bjB)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.K)(o),++x)t.push(v.PZ(o[x]))
C.b.A(k,t)}else{t=A.a([D.aQz,D.aRc,v.PZ(1)],j)
for(w=114;w>=78;--w)t.push(v.PZ(w))
t.push(C.L)
r=v.f
p=A.bb(r?C.FM:C.pY,C.ar,u,u)
t.push(A.ix(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.hM,u,u,u),new B.bCD(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.PZ(w))
C.b.A(k,t)}k.push(C.a0)
k.push(D.AQ)
return k},
aiT(d,e,f){var x=null,w=y.p
return new E.e8(A.B(A.a([A.bb(d,C.A,x,x),C.I,A.T(A.J(A.a([A.d(e,x,x,x,x,C.c5,x,x,x),A.d(f,1,C.P,x,x,C.a05,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.i,C.d,C.e,0,x,x),C.a6,C.K,x,!1,x)},
PZ(d){var x,w=null,v=this.d.c,u=H.dp[d-1].a[1],t=v.a4z(d),s=t/u,r=y.p,q=A.ap(A.dp(C.N,A.a([A.bYD(C.fF,D.dj,w,w,w,w,w,3,s,w),A.d(E.bK(d),w,w,w,w,O.a0o,w,w,w)],r),C.m,C.bf,w),36,36),p=A.d(G.jV(d),w,w,w,w,D.b3K,w,w,w)
if(t===0)x=E.bK(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bK(t)+" \u0645\u0646 "+E.bK(u)
r=A.a([q,C.cy,A.T(A.J(A.a([p,A.d(x,w,w,w,w,A.bQ(w,w,t===u?D.dj:C.dh,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bK(C.f.aA(s*100))+"\u066a",w,w,w,w,D.a_Y,w,w,w))
r.push(D.amZ)
return new E.e8(A.B(r,C.i,C.d,C.e,0,w,w),C.pv,C.dA,new B.bCG(this,d),!1,w)}}
B.FQ.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.bn
return D.aQl
case 3:x=q.y
x=x==null?r:x.gih()
return new E.e8(A.J(A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":x,r,r,r,r,D.zZ,r,r,r),C.L,new A.yC(C.a2t,!1,q.gbca(),r,r,r,r,C.k,r,!1,r,!0,r,C.Ar,r)],y.p),C.q,C.d,C.e,0,C.l),C.a6,C.aU,r,!1,r)
case 0:case 1:w=q.w
v=q.r
q=w>0
u=q?C.f.da(v/w,0,1):r
t=q&&v<w
q=A.d(t?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bK(C.f.aA(v/1e6))+" \u0645\u0646 "+E.bK(C.f.aA(w/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.o1,r,r,r)
x=A.u(8)
s=y.p
x=A.a([q,C.B,A.eY(x,A.rg(C.fF,C.A,7,t?u:r,r),C.aB)],s)
if(!this.d)C.b.A(x,A.a([C.L,D.bfj],s))
return new E.e8(A.J(x,C.q,C.d,C.e,0,C.l),C.a6,C.aU,r,!1,r)}}}
B.VG.prototype={
t(d){var x=null,w=D.dN.al(0.1),v=A.u(14),u=A.aC(D.dN.al(0.4),1)
return A.C(x,A.B(A.a([D.aoz,C.I,A.T(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.A7,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.E(w,x,u,v,x,x,x,C.n),x,x,C.aU,C.ad,x,x,x)}}
B.CP.prototype={
R(){return"_Phase."+this.b}}
B.BV.prototype={
O(){return new B.a05($.KU(),D.lO)}}
B.a05.prototype={
gjl(){var x=this.e
return x===$?this.e=this.a.d:x},
gQg(){var x,w=this.a,v=w.f
w=w.c
x=this.gjl()
return G.awY(w,x,v.I0(w,x)).b},
X(){var x,w=this
w.Y()
x=w.d
x.ac(w.gnV())
x.v6()
x.a.a55(B.awK(w.a.c,w.gjl()))},
wj(){if(this.c!=null)this.l(new B.bPw())},
m(){var x,w=this,v=w.d
v.V(w.gnV())
x=w.Q
if(x!=null)x.aD()
v=v.a
v.LF()
v.a1N()
w.a0()},
YA(d){var x,w,v=this
if(v.f===D.ug)v.d.a.a1N()
x=v.d.a
x.LF()
w=v.Q
if(w!=null)w.aD()
v.l(new B.bPM(v,d))
x.a55(B.awK(v.a.c,d))
w=v.a
if(d<w.e)x.a55(B.awK(w.c,d+1))},
Qf(d){return this.aR0(d)},
aR0(d){var x=0,w=A.k(y.H),v,u=this,t,s,r,q,p
var $async$Qf=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:if(u.f===D.uf){u.d.a.LF()
u.l(new B.bPQ(u))
x=1
break}t=u.r!=null?D.k_:D.lO
u.l(new B.bPR(u))
s=u.d
r=A.a([B.awK(u.a.c,u.gjl())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.K3(r,q),$async$Qf)
case 3:p=f
if(u.c==null||u.f!==D.uf){x=1
break}u.l(new B.bPS(u,t,p))
case 1:return A.i(v,w)}})
return A.j($async$Qf,w)},
Pb(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$Pb=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:m=s.d
if(m.f!==D.jt){x=1
break}p=m.a
p.LF()
r=B.bX2(s.gQg()).length
s.l(new B.bPU(s))
o=s.Q
if(o!=null)o.aD()
s.Q=A.hU(C.eG,new B.bPV(s))
u=4
o=B.c1t(r)
x=7
return A.c(p.a7x(m.b.c,o,new B.bPW(s),new B.bPX(s)),$async$Pb)
case 7:u=2
x=6
break
case 4:u=3
l=t.pop()
m=A.a9(l)
if(m instanceof B.l8){q=m
m=s.Q
if(m!=null)m.aD()
if(s.c!=null)s.l(new B.bPY(s,q))}else throw l
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Pb,w)},
B3(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$B3=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.ug){x=1
break}o=s.Q
if(o!=null)o.aD()
s.l(new B.bQ_(s))
s.Q=A.hU(C.i6,new B.bQ0(s))
u=4
o=s.d.a
x=7
return A.c(o.a7A(),$async$B3)
case 7:r=e
if(r.b<0.8){s.a0C("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(o.asu(r),$async$B3)
case 8:q=e
o=A.mT().gfm().h(0,"debug")
if(o==="1")A.Du().$1("[tutor] "+s.a.c+":"+s.gjl()+" audio="+C.f.av(r.b,1)+"s infer="+q.b+"ms text="+q.a)
s.adl(q.a)
u=2
x=6
break
case 4:u=3
m=t.pop()
o=A.a9(m)
if(o instanceof B.l8){p=o
s.a0C(p.gih())}else throw m
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$B3,w)},
a0C(d){var x=this,w=x.Q
if(w!=null)w.aD()
if(x.c==null)return
x.l(new B.bPL(x,d))},
adl(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aD()
if(s.c==null)return
x=B.cbh(s.gQg(),d)
r.a=null
if(C.c.P(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjl()
t=x.grU()
r.a=w.arC(v,u,q.b.a,t)
q.z7()}s.l(new B.bPN(r,s,x))},
MY(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h
var $async$MY=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:i=s.d
if(i.f!==D.jt){x=1
break}s.l(new B.bPE(s))
m=s.Q
if(m!=null)m.aD()
s.Q=A.hU(C.i6,new B.bPF(s))
l=new A.Hy()
$.KT()
l.vX()
r=l
u=4
x=7
return A.c(i.a.bgQ(B.awK(s.a.c,s.gjl())),$async$MY)
case 7:q=e
p="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.av(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.av(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.av(r.gIG()/1000,2)+" \u062b)\n"+q.a
A.Du().$1("[tutor-debug] "+s.a.c+":"+s.gjl()+" audio="+C.f.av(q.c,1)+"s infer="+q.b+"ms total="+r.gIG()+"ms text="+q.a)
s.adl(q.a)
o=s.r
if(o!=null){i=o.grU()
m=o.b
k=A.ak(m).i("ao<1>")
m=A.ab(new A.ao(m,new B.bPG(),k),k.i("Y.E"))
A.Du().$1("[tutor-debug] perfect="+i+" ops="+A.n(m))}s.l(new B.bPH(s,p))
u=2
x=6
break
case 4:u=3
h=t.pop()
i=A.a9(h)
if(i instanceof B.l8){n=i
A.Du().$1("[tutor-debug] failed: "+A.n(n))
s.a0C(n.gih())}else throw h
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$MY,w)},
ga_p(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.qo():v).a!==D.f0)return!1}return!0},
t(d){var x=this,w=null,v=x.d,u=v.c.a4I(x.a.c,x.gjl()),t=v.b,s=t.d&&!x.x&&x.f!==D.k_,r=G.jV(x.a.c),q=y.p,p=A.a([A.cd(w,w,w,C.ia,w,w,new B.bQ5(d),w,w,w,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",w)],q),o=x.aHw(),n=A.d("\u0622\u064a\u0629 "+E.bK(x.gjl()),w,w,w,w,N.A8,w,w,w),m=E.bK(x.gjl()-x.a.d+1),l=x.a
t=A.a([A.B(A.a([n,C.b4,A.d("("+m+" \u0645\u0646 "+E.bK(l.e-l.d+1)+")",w,w,w,w,F.b9,w,w,w),C.bz,x.aVj(u,t.a)],q),C.i,C.d,C.e,0,w,w),C.u],q)
if(s)t.push(x.aPx())
else{n=x.r
if(n!=null){m=x.f
m=m!==D.ug&&m!==D.oo}else m=!1
if(m)t.push(x.aFe(n))
else t.push(A.d(x.gQg()+" \ufd3f"+E.bK(x.gjl())+"\ufd3e",w,w,w,w,D.jR,C.a4,C.bg,w))}t=A.a([new B.FQ(v,!0,w),o,C.B,new E.e8(A.J(t,C.ai,C.d,C.e,0,C.l),D.ag2,C.aU,w,!1,w)],q)
o=x.r
if(o!=null&&x.f===D.k_)t.push(x.b30(o))
o=x.as
if(o!=null)t.push(new A.H(C.aU,A.d(o,w,w,w,w,D.zZ,w,w,w),w))
t.push(x.aFN())
t.push(C.a0)
t.push(A.i7(C.A,C.K,w,new B.bQ6(x),D.bcq,D.bhv,v.b.d))
o=x.a
if(o.e>o.d){o=x.ga_p()
t.push(new E.e8(A.B(A.a([D.aly,C.Z,A.T(A.J(A.a([D.bj_,A.d(x.ga_p()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",w,w,w,w,F.b9,w,w,w)],q),C.q,C.d,C.e,0,C.l),1),L.mW],q),C.i,C.d,C.e,0,w,w),C.a6,C.aU,new B.bQ7(x,d),o,w))}o=A.mT().gfm().h(0,"debug")
if(o==="1"){q=A.a([C.B,A.dn(D.amP,D.bgY,v.f===D.jt&&x.f!==D.oo?x.gaGw():w,w)],q)
o=x.at
if(o!=null)q.push(new A.H(C.j4,A.H9(o,F.b9,w),w))
v=v.x
if(v!=null)q.push(A.d("model: "+v.a+" "+v.b+", load "+v.c+" ms",w,w,w,w,F.b9,w,w,w))
C.b.A(t,q)}t.push(C.B)
t.push(D.AQ)
return E.wk(p,t,r)},
aHw(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.bn
return A.ap(A.fm(new B.bPJ(this),w,null,C.af,new B.bPK()),36,null)},
aVj(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.f0)return D.aZn
x=d.b
w=E.bK(x)
v=E.bK(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c1:C.G1
u.push(new A.H(D.agG,A.bb(r,s?D.dj:C.fG,q,16),q))}return A.c_J(A.B(u,C.i,C.d,C.Q,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aPx(){var x=null
return A.bA(!1,A.u(12),!0,A.C(x,D.acW,C.k,x,x,new A.E(C.vf,x,x,A.u(12),x,x,x,C.n),x,x,x,D.afG,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bPP(this),x,x,x,x,x,x,x)},
aFe(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.aR(d.gLE(),w)
A:{if(D.iF===v){u=D.jR.ci(D.dj)
break A}if(D.u_===v){u=D.jR.a2r(D.dN,C.jN,D.dN)
break A}if(D.u0===v){u=D.jR.a2r(D.eD,C.jN,D.eD)
break A}u=D.jR.a2r(C.fG,C.jO,C.dy)
break A}t=x[w]
r.push(new A.eQ(t.a,s,s,C.bu,s,s,s,s,s,s,u))
r.push(H.zQ)}x=E.bK(this.gjl())
r.push(A.ea(s,s,s,s,s,s,s,s,s,D.jR.ci(C.ar),"\ufd3f"+x+"\ufd3e"))
return A.HP(A.ea(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.a4,C.bg)},
b30(d){var x,w,v,u,t,s,r=this.w
if(C.c.P(d.c).length===0)return D.btW
if(d.grU()){x=r==null
if((x?null:r.a)===D.f0&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.f0?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bK(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.Ca(D.dj,C.c1,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gLE()
w=J.dy(x)
v=w.il(x,new B.bQ1()).gM(0)
u=w.il(x,new B.bQ2()).gM(0)
t=w.il(x,new B.bQ3()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bK(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bK(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bK(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gIP().length!==0)x.push(E.bK(d.gIP().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eD:D.dN
x=C.b.aG(x," \u2022 ")
s=d.gIP().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aG(d.gIP(),"\u060c "):""
return new B.Ca(w,C.mM,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aFN(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jt,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aO(new A.bh(f,0,!1).ec(w).a,1e6)}v=C.j.aO(B.c1t(B.bX2(j.gQg()).length).a,1e6)
f=j.gb1E()
w=96+26*j.y
u=D.eD.al(0.25)
w=A.iL(i,A.a2L(C.N,A.C(i,D.an1,C.k,i,i,D.a52,i,84,i,i,i,i,84),i,C.aO,new A.E(u,i,i,i,i,i,i,C.c_),C.DL,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cO)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c0x(x)+" / "+B.c0x(v),i,i,i,i,I.o0,i,i,i)
return A.J(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u062a\u064a\u0646 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.b9,i,i,i),A.br(D.bnc,i,i,f,i,i)],y.p),C.i,C.d,C.e,0,C.l)
case 3:t=C.f.es((Date.now()-j.ax)/1000)
return new A.H(C.pq,A.J(A.a([C.v1,C.a0,D.bfK,A.d(t<8?"\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643":"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bK(t)+" \u062b)",i,i,i,i,F.b9,i,i,i)],y.p),C.i,C.d,C.e,0,C.l),i)
default:s=f===D.uf
r=j.r
f=r==null
w=!f
q=w&&r.grU()
u=A.bb(s?D.xh:I.Gc,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.eT(i,i,D.b15,i)
u=A.T(new A.yC(C.a2t,!0,new B.bPx(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Wd(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.HH[n]
p.push(new A.ew(m,i,A.d("\xd7"+E.bK(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.B(A.a([u,C.I,A.pJ(new B.bPy(j),p,A.d2([h.b.b],o),!1,A.k_(i,i,i,new A.bn(new B.bPz(),l),i,i,i,i,new A.bn(new B.bPA(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.dW),o)],k),C.i,C.d,C.e,0,i,i)
h=g&&!s?j.gaXa():i
u=A.bb(f?D.q2:C.mM,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cA,i,i,i)
p=q?C.kk:C.A
h=A.a([o,C.u,A.h_(u,f,h,A.eT(p,q?C.h:C.aq,D.tg,i))],k)
if(w&&j.gjl()<j.a.e)C.b.A(h,A.a([C.B,q?A.h_(D.aq6,D.bm2,new B.bPB(j),A.eT(D.dj,C.aq,D.tg,i)):A.br(D.bcP,i,i,new B.bPC(j),i,i)],k))
if(w){f=j.gjl()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.H(C.j5,A.d(j.ga_p()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,D.a0v,C.a4,i,i),i))
return A.J(h,C.ai,C.d,C.e,0,C.l)}}}
B.Ca.prototype={
t(d){var x=this,w=null,v=x.c,u=v.al(0.12),t=A.u(14),s=A.aC(v.al(0.5),1),r=y.p
return A.C(w,A.B(A.a([A.bb(x.d,v,w,w),C.I,A.T(A.J(A.a([A.d(x.e,w,w,w,w,A.bQ(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.U,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bI,A.d(x.f,w,w,w,w,C.A7,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.E(u,w,s,t,w,w,w,C.n),w,w,C.aU,C.ad,w,w,w)}}
B.BU.prototype={
O(){var x=y.S
return new B.a04($.KU(),A.D(x,y.B),A.aU(x),A.D(x,y.N),A.ee(null,y.H))}}
B.a04.prototype={
X(){this.Y()
this.d.ac(this.gnV())},
wj(){if(this.c!=null)this.l(new B.bPf())},
m(){var x,w=this,v=w.d
v.V(w.gnV())
x=w.y
if(x!=null)x.aD()
v.a.a1N()
w.a0()},
Hq(d){return this.b00(d)},
b00(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o,n
var $async$Hq=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.l(new B.bPo(t,d))
r=t.y
if(r!=null)r.aD()
t.y=A.hU(C.eG,new B.bPp(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c1t(B.bX2(G.awY(q,d,p.I0(q,d)).b).length)
x=6
return A.c(r.a.a7x(r.b.c,q,new B.bPq(t,d),new B.bPr(t)),$async$Hq)
case 6:v=1
x=5
break
case 3:v=2
n=u.pop()
r=A.a9(n)
if(r instanceof B.l8){s=r
r=t.y
if(r!=null)r.aD()
if(t.c!=null)t.l(new B.bPs(t,s))}else throw n
x=5
break
case 2:x=1
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$Hq,w)},
EV(d,e){return this.aID(d,e)},
aID(d,e){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$EV=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aD()
s.l(new B.bPj(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a7A()
if(e&&n!=null)s.Hq(n)
q=null
u=4
x=7
return A.c(r,$async$EV)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a9(l)
if(o instanceof B.l8){p=o
s.l(new B.bPk(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.as=s.as.bD(new B.bPl(s,o,d),y.H)}case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$EV,w)},
gaSZ(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aE(x)&&!v.n(0,x)&&!u.aE(x)&&x!==t.e)return x
return null},
aXZ(){this.l(new B.bPm(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jt,o=s.e,n=s.gaSZ(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("c8<2>")
x=new A.ao(new A.c8(m,l),new B.bPt(),l.i("ao<Y.E>")).gM(0)
l=G.jV(s.a.c)
m=y.p
q=A.a([new B.FQ(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bK(s.a.d)+" \u0644\u062d\u062f "+E.bK(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.b9,r,r,r),C.u],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b1D(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.zZ,r,r,r))
k=o==null
if(!k){j=E.bK(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aO(new A.bh(v,0,!1).ec(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c0x(v),r,r,r,r,I.o0,C.a4,r,r)
j=A.eY(A.u(6),A.rg(C.fF,D.eD,6,s.x,r),C.aB)
u=o<s.a.e
t=A.bb(u?D.al_:D.xh,r,r,r)
C.b.A(q,A.a([v,C.L,j,C.u,A.h_(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cA,r,r,r),new B.bPu(s,o),A.eT(C.A,C.aq,D.tg,r))],m))}else if(n!=null){j=p?new B.bPv(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bK(n)
q.push(A.h_(D.ao6,A.d(v,r,r,r,r,C.cA,r,r,r),j,A.eT(C.A,C.aq,D.tg,r)))}if(s.r.a!==0&&k)q.push(D.aQJ)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?D.dj:D.dN
v=k?C.mG:C.mM
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bK(x)
u=s.a
u=k+" \u0645\u0646 "+E.bK(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.Ca(j,v,k,u,r),A.dn(D.apV,D.bmD,s.gaXY(),r)],m))}q.push(C.u)
q.push(D.AQ)
return E.wk(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b1D(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.ant
else if(l.r.n(0,d))x=M.th
else if(i!=null)x=D.anK
else if(j!=null){w=j.grU()?C.c1:D.ak9
x=A.bb(w,j.grU()?D.dj:D.dN,k,k)}else x=D.ama
w=y.p
v=A.a([A.B(A.a([A.d("\u0622\u064a\u0629 "+E.bK(d),k,k,k,k,D.b86,k,k,k),C.bz,x],w),C.i,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.b7l,k,k,k))
if(j!=null&&!j.grU()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gLE()
o=J.b6(p)
n=o.h(p,r)
A:{if(D.iF===n){m=D.dj
break A}if(D.u_===n){m=D.dN
break A}if(D.u0===n){m=D.eD
break A}m=C.fG
break A}m=D.jR.b6O(m,o.h(p,r)===D.u1?C.jO:k,22)
C.b.A(t,A.a([new A.eQ(q.a,k,k,C.bu,k,k,k,k,k,k,m),H.zQ],u))}w=A.a([C.am,A.HP(A.ea(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.a4,C.bg)],w)
if(C.c.P(j.c).length===0)w.push(D.biq)
C.b.A(v,w)}return new E.e8(A.J(v,C.ai,C.d,C.e,0,C.l),C.bL,C.dA,k,!1,k)}}
B.BT.prototype={
O(){return new B.a03($.KU())}}
B.a03.prototype={
X(){this.Y()
var x=this.d
x.ac(this.gnV())
x.v6()},
wj(){if(this.c!=null)this.l(new B.bP6())},
m(){this.d.V(this.gnV())
this.a0()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gaw5(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kI(o,0,new B.bPd(q))
v=C.b.kI(o,0,new B.bPe())
o=y.p
o=A.a([A.B(A.a([A.T(s.Wu(E.bK(q.gaqA()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.I,A.T(s.Wu(E.bK(q.anm()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.I,A.T(s.Wu(E.bK(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.i,C.d,C.e,0,r,r),C.u,new E.e8(A.J(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bK(C.f.aA(w*100/v))+"\u066a",r,r,r,r,C.c5,r,r,r),C.L,A.eY(A.u(6),A.rg(C.fF,D.dj,8,w/v,r),C.aB),C.am,A.d(E.bK(w)+" \u0645\u0646 "+E.bK(v)+" \u0622\u064a\u0629",r,r,r,r,F.b9,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a6,C.aU,r,!1,r)],o)
if(p.length===0)o.push(D.aQW)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.K)(p),++t)o.push(s.b1F(p[t]))
o.push(C.B)
u=$.A().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.b9,r,r,r))
return E.wk(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
Wu(d,e){var x=null
return new E.e8(A.J(A.a([A.d(d,x,x,x,x,D.b7O,x,x,x),A.d(e,x,x,x,x,C.a0z,C.a4,x,x)],y.p),C.i,C.d,C.e,0,C.l),C.a6,C.K,x,!1,x)},
b1F(d){var x=null,w=this.d.c,v=H.dp[d-1].a[1],u=w.a4z(d),t=w.bbV(d),s=y.p,r=A.B(A.a([A.T(A.d(G.jV(d),x,x,x,x,C.c5,x,x,x),1),A.d(E.bK(C.f.aA(u*100/v))+"\u066a",x,x,x,x,D.b8W,x,x,x)],s),C.i,C.d,C.e,0,x,x),q=A.eY(A.u(6),A.rg(C.fF,D.dj,7,u/v,x),C.aB),p=E.bK(u),o=E.bK(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bK(t):""
return new E.e8(A.J(A.a([r,C.L,q,C.am,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.b9,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a6,C.aU,new B.bPc(this,d),!1,x)},
N0(d){return this.aGR(d)},
aGR(d){var x=0,w=A.k(y.H),v=this,u,t
var $async$N0=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=H.dp[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.eh(C.di,new B.bPb(v,d,u),t,!0,null,null,y.H),$async$N0)
case 2:return A.i(null,w)}})
return A.j($async$N0,w)}}
B.agq.prototype={
Qe(d,e){var x=null,w=A.t5(x,x,x,x,x,x,x,x,x,x,x,D.b0C,C.K,x,x,x,x,C.nr,x,x)
return A.br(A.d(d,x,x,x,x,C.o3,x,x,x),x,x,new B.b1a(e),x,w)},
t(d){var x=this,w=y.p
return new E.e8(A.J(A.a([D.blP,C.L,D.bnb,A.d0(C.az,A.a([x.Qe("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Qe("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aG,0,12),D.bc1,x.Qe("tanzil.net","https://tanzil.net"),D.boK,x.Qe("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a6,C.aU,null,!1,null)}}
var z=a.updateTypes(["aj<~>()","~()","Q(mW)","aj<I8>()","aj<I6>()","aj<I7>()","a7<mW>()","Q(qz)","bD(o0)","BV(t)","BT(t)","Q(mm)","BU(t)","Q(GI)"])
B.b1c.prototype={
$0(){var x=0,w=A.k(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.a0(A.eF(b.G.document).baseURI)
q=A.bw(r,0,null).a3("quran_tutor/tutor.js?v=1").j(0)
x=7
return A.c(A.eG(import(q),y.m),$async$$0)
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
m=B.cpn("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:382}
B.b1f.prototype={
$1(d){return A.fJ(d,"persist",null,null,y.K)},
$S:1075}
B.b1e.prototype={
$0(){var x=0,w=A.k(y.C),v,u=this,t,s,r,q,p,o,n
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:q=y.m
o=A
n=A
x=4
return A.c(u.a.qC(),$async$$0)
case 4:x=3
return A.c(o.eG(n.fJ(e,"loadModel",A.bTh(new B.b1d(u.b)),u.c,q),q),$async$$0)
case 3:p=e
q=A.v(p.device)
if(q==null)q=null
if(q==null)q=""
t=A.v(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=A.tK(p.ms)
s=s==null?null:C.f.aA(s)
if(s==null)s=0
r=A.eu(p.cached)
if(r==null)r=null
v=new B.I6(q,t,s,r===!0)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+4}
B.b1d.prototype={
$2(d,e){this.a.$2(C.f.aA(d),C.f.aA(e))},
$S:1076}
B.b1j.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t,s
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.qC(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aO(v.b.a,1000)
u.autoStop=v.c
u.onLevel=A.fW(new B.b1h(v.d))
u.onAutoStop=A.fW(new B.b1i(v.e))
x=5
return A.c(A.eG(A.fJ(s,"startRecording",u,null,y.m),y.X),$async$$0)
case 5:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.b1h.prototype={
$1(d){return this.a.$1(d)},
$S:71}
B.b1i.prototype={
$1(d){return this.a.$1(d)},
$S:6}
B.b1k.prototype={
$0(){var x=0,w=A.k(y.D),v,u=this,t,s,r
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.a
r=s.a
x=r==null?3:4
break
case 3:x=5
return A.c(s.qC(),$async$$0)
case 5:r=e
case 4:s=y.m
x=6
return A.c(A.eG(A.fJ(r,"stopRecording",null,null,s),s),$async$$0)
case 6:t=e
v=new B.I7(t,A.dD(t.seconds))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+5}
B.b1m.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=y.m
q=s
p=A
o=A
x=4
return A.c(s.qC(),$async$$0)
case 4:x=3
return A.c(p.eG(o.fJ(e,"transcribe",t.audio,t.rate,r),r),$async$$0)
case 3:v=q.ajA(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b1l.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.a
s=y.m
r=t
q=A
p=A
x=4
return A.c(t.qC(),$async$$0)
case 4:x=3
return A.c(q.eG(p.fJ(e,"transcribeUrl",u.b,null,s),s),$async$$0)
case 3:v=r.ajA(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b1g.prototype={
$1(d){return d},
$S:37}
B.aSr.prototype={
$0(){var x,w,v,u,t=this.a,s=A.ch(t.a.length,D.u1,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aSq.prototype={
$1(d){return d===D.iF},
$S:z+2}
B.bT1.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.bXK(e[x],d[x])<0.75)return!1
return!0},
$S:1077}
B.bUW.prototype={
$1(d){return d.length!==0},
$S:11}
B.b1q.prototype={
$1(d){return d.a===D.f0},
$S:z+7}
B.b1r.prototype={
$1(d){return C.j.aO(d,1000)},
$S:59}
B.b1o.prototype={
$1(d){return C.f.co(d)},
$S:1078}
B.b1s.prototype={
$0(){var x=0,w=A.k(y.a),v=1,u=[],t=this,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0
var $async$$0=A.f(function(a1,a2){if(a1===1){u.push(a2)
x=v}for(;;)switch(x){case 0:v=3
x=6
return A.c(A.ql("mt.tutor.settings"),$async$$0)
case 6:s=a2
if(s!=null){l=y.P.a(C.aN.jt(s,null))
k=A.aS(l.h(0,"n"))
k=k==null?null:C.f.co(k)
k=C.j.da(k==null?2:k,1,5)
j=C.b.n(D.HH,l.h(0,"r"))?A.ev(l.h(0,"r")):1
i=A.eu(l.h(0,"auto"))
h=A.eu(l.h(0,"hide"))
l=A.eu(l.h(0,"in"))
t.a.b=new B.Tr(k,j,i!==!1,h===!0,l===!0)}v=1
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
return A.c(A.ql("mt.tutor.progress"),$async$$0)
case 11:r=a2
if(r!=null)t.a.c=B.c_M(y.P.a(C.aN.jt(r,null)))
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
return A.c(A.ql("mt.tutor.last"),$async$$0)
case 16:q=a2
if(q!=null){p=y.P.a(C.aN.jt(q,null))
o=C.f.co(A.de(J.aR(p,"s")))
n=C.f.co(A.de(J.aR(p,"f")))
m=C.f.co(A.de(J.aR(p,"t")))
if(B.cd_(o,n)&&B.cd_(o,m)&&n<=m)t.a.z=new A.aP(o,n,m)}v=1
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
return A.c(l.a.LY(),$async$$0)
case 17:a0.d=a2
l.e=!0
l.ad()
if(l.b.e)l.Cu()
l.w8()
return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$0,w)},
$S:146}
B.b1t.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.ad()},
$S:1079}
B.b1u.prototype={
$2(d,e){return C.j.aO(A.eX(A.n(d),null,null),1000)===this.a},
$S:1080}
B.bCM.prototype={
$1(d){var x=0,w=A.k(y.a),v=this,u,t
var $async$$1=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.DL(),$async$$1)
case 2:t=f
if(u.c!=null)u.l(new B.bCL(u,t))
return A.i(null,w)}})
return A.j($async$$1,w)},
$S:1081}
B.bCL.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bCN.prototype={
$1(d){var x=this.a
if(x.c!=null)x.l(new B.bCK(x,d))},
$S:z+8}
B.bCK.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bCO.prototype={
$1(d){},
$S:23}
B.bCy.prototype={
$0(){},
$S:0}
B.bCE.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.BV(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bCF.prototype={
$0(){},
$S:0}
B.bCI.prototype={
$0(){var x=y.z
return A.M(this.a,!1).aC(A.ay(new B.bCH(),null,x),x)},
$S:0}
B.bCH.prototype={
$1(d){return D.bq3},
$S:z+10}
B.bCJ.prototype={
$0(){return B.ccR(this.a)},
$S:0}
B.bCB.prototype={
$0(){var x=this.b
return this.a.xe(x.a,x.b,x.c)},
$S:0}
B.bCC.prototype={
$1(d){return this.a.l(new B.bCA())},
$S:6}
B.bCA.prototype={
$0(){},
$S:0}
B.bCD.prototype={
$0(){var x=this.a
return x.l(new B.bCz(x))},
$S:0}
B.bCz.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bCG.prototype={
$0(){return this.a.b1C(this.b)},
$S:0}
B.bWV.prototype={
$1(d){return new A.jk(new B.bWS(this.a,this.b,this.c),null)},
$S:56}
B.bWS.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.bWU(u,e),s=this.a,r=new B.bWT(s,e),q=A.d(G.jV(this.c),v,v,v,v,C.nX,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bK(u)+" \u0622\u064a\u0629)",v,v,v,v,F.b9,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bK(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bK(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.da(w+4,1,u)))}u=A.a([q,C.am,p,C.u,A.d0(C.az,n,C.aG,6,8),C.B,A.B(A.a([t.$3("\u0645\u0646",s.b,new B.bWN(s)),C.ZG,t.$3("\u0644\u062d\u062f",s.c,new B.bWO(s))],o),C.i,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aQO)
u.push(C.a3)
u.push(A.dH(D.bfe,new B.bWP(s,d),A.eT(C.A,C.aq,D.b12,v)))
return A.cw(!0,new A.H(C.Eg,A.J(u,C.ai,C.d,C.Q,0,C.l),v),C.K,!0)},
$S:370}
B.bWU.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.hP,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.cm(v,A.d("\u0622\u064a\u0629 "+E.bK(v),u,u,u,u,u,u,u,u),C.aA,u,w))
return A.T(A.J(A.a([t,P.EA(C.di,!0,s,320,new B.bWR(this.b,f),D.b9c,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1082}
B.bWR.prototype={
$1(d){return d==null?null:this.a.$1(new B.bWQ(this.b,d))},
$S:48}
B.bWQ.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.bWT.prototype={
$3(d,e,f){var x=null
return A.bYj(x,A.d(d,x,x,x,x,x,x,x,x),new B.bWM(this.a,this.b,e,f))},
$S:1083}
B.bWM.prototype={
$0(){var x=this
return x.b.$1(new B.bWL(x.a,x.c,x.d))},
$S:0}
B.bWL.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.bWN.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.bWO.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.bWP.prototype={
$0(){var x=this.a
return A.M(this.b,!1).ak(new A.a4(x.b,x.c))},
$S:0}
B.bPw.prototype={
$0(){},
$S:0}
B.bPM.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.lO
x.w=x.r=null
x.x=!1
x.at=x.as=null},
$S:0}
B.bPQ.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.k_:D.lO},
$S:0}
B.bPR.prototype={
$0(){var x=this.a
x.f=D.uf
x.as=null},
$S:0}
B.bPS.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bPU.prototype={
$0(){var x=this.a
x.f=D.ug
x.as=null
x.y=0
x.z=new A.bh(Date.now(),0,!1)
x.at=null},
$S:0}
B.bPV.prototype={
$1(d){var x=this.a
if(x.c!=null)x.l(new B.bPT())},
$S:31}
B.bPT.prototype={
$0(){},
$S:0}
B.bPX.prototype={
$1(d){return this.a.y=d},
$S:71}
B.bPW.prototype={
$1(d){return this.a.B3()},
$S:6}
B.bPY.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.k_:D.lO
x.as=this.b.gih()},
$S:0}
B.bQ_.prototype={
$0(){var x=this.a
x.f=D.oo
x.ax=Date.now()},
$S:0}
B.bQ0.prototype={
$1(d){var x=this.a
if(x.c!=null)x.l(new B.bPZ())},
$S:31}
B.bPZ.prototype={
$0(){},
$S:0}
B.bPL.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.k_:D.lO
x.as=this.b},
$S:0}
B.bPN.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.k_
x.x=!1},
$S:0}
B.bPE.prototype={
$0(){var x=this.a
x.f=D.oo
x.ax=Date.now()
x.as=null},
$S:0}
B.bPF.prototype={
$1(d){var x=this.a
if(x.c!=null)x.l(new B.bPD())},
$S:31}
B.bPD.prototype={
$0(){},
$S:0}
B.bPG.prototype={
$1(d){return d.d!==D.iF},
$S:z+11}
B.bPH.prototype={
$0(){return this.a.at=this.b},
$S:0}
B.bQ5.prototype={
$0(){return B.ccR(this.a)},
$S:0}
B.bQ6.prototype={
$1(d){var x=this.a.d
return x.qc(x.b.amS(d))},
$S:3}
B.bQ7.prototype={
$0(){var x=y.z
return A.M(this.b,!1).aC(A.ay(new B.bQ4(this.a),null,x),x)},
$S:0}
B.bQ4.prototype={
$1(d){var x=this.a.a
return new B.BU(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bPK.prototype={
$2(d,e){return C.b4},
$S:19}
B.bPJ.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a4I(s.c,r).a.a){case 2:s=D.dj
break
case 1:s=D.dN
break
case 0:s=C.kk
break
default:s=u}x=A.u(18)
w=t.f===D.oo?u:new B.bPI(t,r)
v=s.al(0.25)
if(r===t.gjl())s=C.h
s=A.aC(s,r===t.gjl()?2:1)
return A.bA(!1,x,!0,A.C(C.N,A.d(E.bK(r),u,u,u,u,C.a_O,u,u,u),C.k,u,u,new A.E(v,u,s,u,u,u,u,C.c_),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:67}
B.bPI.prototype={
$0(){return this.a.YA(this.b)},
$S:0}
B.bPP.prototype={
$0(){var x=this.a
return x.l(new B.bPO(x))},
$S:0}
B.bPO.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bQ1.prototype={
$1(d){return d===D.u_},
$S:z+2}
B.bQ2.prototype={
$1(d){return d===D.u0},
$S:z+2}
B.bQ3.prototype={
$1(d){return d===D.u1},
$S:z+2}
B.bPx.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Qf(x)},
$S:0}
B.bPy.prototype={
$1(d){var x=this.a.d
return x.qc(x.b.b6f(d.ga5(d)))},
$S:138}
B.bPA.prototype={
$1(d){return d.n(0,C.a_)?C.aq:C.h},
$S:5}
B.bPz.prototype={
$1(d){return d.n(0,C.a_)?C.A:C.a8},
$S:5}
B.bPB.prototype={
$0(){var x=this.a
return x.YA(x.gjl()+1)},
$S:0}
B.bPC.prototype={
$0(){var x=this.a
return x.YA(x.gjl()+1)},
$S:0}
B.bPf.prototype={
$0(){},
$S:0}
B.bPo.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.bh(Date.now(),0,!1)},
$S:0}
B.bPp.prototype={
$1(d){var x=this.a
if(x.c!=null)x.l(new B.bPn())},
$S:31}
B.bPn.prototype={
$0(){},
$S:0}
B.bPr.prototype={
$1(d){return this.a.x=d},
$S:71}
B.bPq.prototype={
$1(d){return this.a.EV(this.b,!1)},
$S:6}
B.bPs.prototype={
$0(){var x=this.a
x.e=null
x.Q=this.b.gih()},
$S:0}
B.bPj.prototype={
$0(){var x=this.a
x.e=null
x.r.F(0,this.b)},
$S:0}
B.bPk.prototype={
$0(){var x=this.a,w=this.b
x.r.J(0,w)
x.w.q(0,w,this.c.gih())},
$S:0}
B.bPl.prototype={
$1(d){var x=0,w=A.k(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k,j,i,h
var $async$$1=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:v=3
o=s.a
n=o.d
x=6
return A.c(n.a.asu(s.b),$async$$1)
case 6:r=f
m=s.c
l=o.a
k=l.f
l=l.c
q=B.cbh(G.awY(l,m,k.I0(l,m)).b,r.a)
if(C.c.P(q.c).length!==0){l=n.c
k=o.a.c
j=q.grU()
l.arC(k,m,n.b.a,j)}n.z7()
if(o.c!=null)o.l(new B.bPg(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a9(h)
if(o instanceof B.l8){p=o
o=s.a
if(o.c!=null)o.l(new B.bPh(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.l(new B.bPi(o,s.c))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$1,w)},
$S:142}
B.bPg.prototype={
$0(){var x=this.c
this.a.f.q(0,this.b,x)
return x},
$S:0}
B.bPh.prototype={
$0(){var x=this.c.gih()
this.a.w.q(0,this.b,x)
return x},
$S:0}
B.bPi.prototype={
$0(){return this.a.r.J(0,this.b)},
$S:0}
B.bPm.prototype={
$0(){var x=this.a
x.f.ap(0)
x.w.ap(0)},
$S:0}
B.bPt.prototype={
$1(d){return d.grU()},
$S:z+13}
B.bPu.prototype={
$0(){return this.a.EV(this.b,!0)},
$S:0}
B.bPv.prototype={
$0(){return this.a.Hq(this.b)},
$S:0}
B.bP6.prototype={
$0(){},
$S:0}
B.bPd.prototype={
$2(d,e){return d+this.a.a4z(e)},
$S:102}
B.bPe.prototype={
$2(d,e){return d+H.dp[e-1].a[1]},
$S:102}
B.bPc.prototype={
$0(){return this.a.N0(this.b)},
$S:0}
B.bPb.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(G.jV(p),q,q,q,q,C.nX,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.b5(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.qo():r).a.a){case 2:r=D.dj.al(0.35)
break
case 1:r=D.dN.al(0.35)
break
case 0:r=C.fD
break
default:r=q}m.push(A.C(C.N,A.d(E.bK(t),q,q,q,q,C.ls,q,q,q),C.k,q,q,new A.E(r,q,q,new A.cr(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cw(!0,new A.H(C.ho,A.J(A.a([o,C.am,D.bji,C.u,new A.dw(D.a4V,A.fB(A.d0(C.az,m,C.aG,6,6),q,C.r,q,q,q,C.v),q),C.a0,A.br(D.bkV,q,q,new B.bPa(w,d,p),q,q)],n),C.ai,C.d,C.Q,0,C.l),q),C.K,!0)},
$S:32}
B.bPa.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.di(null,null,!0,null,new B.bP9(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Kh(t),$async$$0)
case 5:if(u.e!=null)A.M(u,!1).e9()
case 3:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.bP9.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+G.jV(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.du(A.a([A.br(C.eg,x,x,new B.bP7(d),x,x),A.br(C.ob,x,x,new B.bP8(d),x,x)],y.p),w,D.bmm)},
$S:14}
B.bP7.prototype={
$0(){A.M(this.a,!1).ak(!1)
return null},
$S:0}
B.bP8.prototype={
$0(){A.M(this.a,!1).ak(!0)
return null},
$S:0}
B.bXr.prototype={
$1(d){var x=this.a
return new A.lQ(new B.bXq(x),null,x,null)},
$S:1084}
B.bXq.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.b,r=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)r.push(new A.ew(w,u,A.d(E.bK(w),u,u,u,u,u,u,u,u),x))
x=y.S
v=y.b
return A.cw(!0,A.fB(A.J(A.a([D.bbY,C.a0,D.blj,C.L,A.pJ(new B.bXl(t,s),r,A.d2([s.a],x),!1,A.k_(u,u,u,new A.bn(new B.bXm(),v),u,u,u,u,new A.bn(new B.bXn(),v),u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u),x),C.B,A.i7(C.A,C.K,u,new B.bXo(t,s),D.bgW,D.boe,s.c),A.i7(C.A,C.K,u,new B.bXp(t,s),u,D.bby,s.d),C.B,D.a1F],y.p),C.ai,C.d,C.e,0,C.l),u,C.r,C.ho,u,u,C.v),C.K,!0)},
$S:1085}
B.bXl.prototype={
$1(d){return this.a.qc(this.b.b6c(d.ga5(d)))},
$S:138}
B.bXn.prototype={
$1(d){return d.n(0,C.a_)?C.aq:C.h},
$S:5}
B.bXm.prototype={
$1(d){return d.n(0,C.a_)?C.A:C.a8},
$S:5}
B.bXo.prototype={
$1(d){return this.a.qc(this.b.b5B(d))},
$S:3}
B.bXp.prototype={
$1(d){return this.a.qc(this.b.amS(d))},
$S:3}
B.b1a.prototype={
$0(){return A.cA(A.bw(this.a,0,null),C.aV,null)},
$S:0};(function installTearOffs(){var x=a._instance_0u
var w
x(w=B.Ts.prototype,"gbca","Cu",0)
x(w,"gaB1","w8",0)
x(w=B.YI.prototype,"gnV","wj",1)
x(w,"gaUF","OR",0)
x(w=B.a05.prototype,"gnV","wj",1)
x(w,"gaXa","Pb",0)
x(w,"gb1E","B3",0)
x(w,"gaGw","MY",0)
x(w=B.a04.prototype,"gnV","wj",1)
x(w,"gaXY","aXZ",1)
x(B.a03.prototype,"gnV","wj",1)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a3,[B.b1b,B.Tt,B.I6,B.I8,B.I7,B.l8,B.Qy,B.mm,B.GI,B.qz,B.agr,B.Tr])
x(A.np,[B.b1c,B.b1e,B.b1j,B.b1k,B.b1m,B.b1l,B.aSr,B.b1s,B.bCL,B.bCK,B.bCy,B.bCF,B.bCI,B.bCJ,B.bCB,B.bCA,B.bCD,B.bCz,B.bCG,B.bWQ,B.bWM,B.bWL,B.bWP,B.bPw,B.bPM,B.bPQ,B.bPR,B.bPS,B.bPU,B.bPT,B.bPY,B.bQ_,B.bPZ,B.bPL,B.bPN,B.bPE,B.bPD,B.bPH,B.bQ5,B.bQ7,B.bPI,B.bPP,B.bPO,B.bPx,B.bPB,B.bPC,B.bPf,B.bPo,B.bPn,B.bPs,B.bPj,B.bPk,B.bPg,B.bPh,B.bPi,B.bPm,B.bPu,B.bPv,B.bP6,B.bPc,B.bPa,B.bP7,B.bP8,B.b1a])
x(A.jv,[B.b1f,B.b1h,B.b1i,B.b1g,B.aSq,B.bUW,B.b1q,B.b1r,B.b1o,B.bCM,B.bCN,B.bCO,B.bCE,B.bCH,B.bCC,B.bWV,B.bWU,B.bWR,B.bWT,B.bWN,B.bWO,B.bPV,B.bPX,B.bPW,B.bQ0,B.bPF,B.bPG,B.bQ6,B.bQ4,B.bQ1,B.bQ2,B.bQ3,B.bPy,B.bPA,B.bPz,B.bPp,B.bPr,B.bPq,B.bPl,B.bPt,B.bPb,B.bP9,B.bXr,B.bXl,B.bXn,B.bXm,B.bXo,B.bXp])
x(A.y8,[B.b1d,B.bT1,B.b1t,B.b1u,B.bWS,B.bPK,B.bPJ,B.bPd,B.bPe,B.bXq])
x(A.W5,[B.mW,B.DL,B.FP,B.CP])
w(B.Ts,A.iE)
x(A.L,[B.vF,B.BV,B.BU,B.BT])
x(A.N,[B.YI,B.a05,B.a04,B.a03])
x(A.a5,[B.FQ,B.VG,B.Ca,B.agq])})()
A.Da(b.typeUniverse,JSON.parse('{"l8":{"bI":[]},"BV":{"L":[],"l":[]},"BU":{"L":[],"l":[]},"BT":{"L":[],"l":[]},"Ts":{"aB":[]},"vF":{"L":[],"l":[]},"YI":{"N":["vF"]},"FQ":{"a5":[],"l":[]},"VG":{"a5":[],"l":[]},"a05":{"N":["BV"]},"Ca":{"a5":[],"l":[]},"a04":{"N":["BU"]},"a03":{"N":["BT"]},"agq":{"a5":[],"l":[]}}'))
var y=(function rtii(){var x=A.as
return{u:x("qz"),c:x("ew<x>"),r:x("cm<x>"),k:x("G<mm>"),n:x("G<ew<x>>"),I:x("G<cm<x>>"),R:x("G<hv>"),Y:x("G<aN<o,@>>"),d:x("G<Qy>"),s:x("G<o>"),p:x("G<l>"),t:x("G<x>"),m:x("bP"),j:x("a7<@>"),L:x("a7<x>"),P:x("aN<o,@>"),f:x("aN<@,@>"),x:x("au<o,x>"),a:x("bD"),K:x("a3"),B:x("GI"),l:x("+(x,x)"),e:x("d6<mm>"),N:x("o"),C:x("I6"),D:x("I7"),O:x("Tt"),_:x("I8"),U:x("ao<o>"),G:x("mW"),q:x("qe"),b:x("bn<V?>"),y:x("Q"),i:x("a1"),z:x("@"),S:x("x"),A:x("bP?"),X:x("a3?"),M:x("+quota,usage(x,x)?"),o:x("fg"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.ox=new B.DL(0,"none")
D.oy=new B.DL(1,"learning")
D.f0=new B.DL(2,"memorized")
D.a4V=new A.az(0,1/0,0,320)
D.eD=new A.V(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a52=new A.E(D.eD,null,null,null,null,null,null,C.c_)
D.dN=new A.V(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.dj=new A.V(1,0.20392156862745098,0.8274509803921568,0.6,C.p)
D.aoD=new A.F(C.Ga,null,C.dy,null,null,null)
D.bmu=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.hM,null,null,null,null,null,null,null,null)
D.b4A=new A.r(!0,C.fG,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjk=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.b4A,null,null,null,null,null,null,null,null)
D.aF5=x([D.aoD,C.L,D.bmu,D.bjk],y.p)
D.acW=new A.f5(C.v,C.d,C.e,C.i,null,C.l,null,0,D.aF5,null)
D.bxi=new A.bB(25e6)
D.afG=new A.Z(0,26,0,26)
D.ag2=new A.Z(14,12,14,14)
D.agG=new A.Z(3,0,0,0)
D.ak9=new A.U(63251,"MaterialIcons",null,!1)
D.q2=new A.U(63677,"MaterialIcons",null,!1)
D.al_=new A.U(983443,"MaterialIcons",null,!1)
D.xh=new A.U(983516,"MaterialIcons",null,!1)
D.akT=new A.U(983209,"MaterialIcons",null,!1)
D.aly=new A.F(D.akT,28,C.A,null,null,null)
D.ama=new A.F(C.FT,null,C.kk,null,null,null)
D.ajT=new A.U(62961,"MaterialIcons",null,!1)
D.amP=new A.F(D.ajT,null,null,null,null,null)
D.ak8=new A.U(63199,"MaterialIcons",null,!1)
D.amQ=new A.F(D.ak8,null,null,null,null,null)
D.amZ=new A.F(C.kC,null,C.fG,null,null,null)
D.an1=new A.F(D.xh,44,C.h,null,null,null)
D.ant=new A.F(D.q2,null,D.eD,null,null,null)
D.anK=new A.F(C.pX,null,D.eD,null,null,null)
D.ao6=new A.F(D.q2,null,null,null,null,null)
D.aoz=new A.F(C.jd,20,D.dN,null,null,null)
D.aoV=new A.F(C.q4,30,C.A,null,null,null)
D.akp=new A.U(63520,"MaterialIcons",null,!1)
D.apL=new A.F(D.akp,null,null,null,null,null)
D.apV=new A.F(C.mM,null,null,null,null,null)
D.ajK=new A.U(62842,"MaterialIcons",null,!0)
D.aq6=new A.F(D.ajK,null,null,null,null,null)
D.HH=x([1,3,5],y.t)
D.It=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aRl=new A.H(C.mx,C.oM,null)
D.aBX=x([D.aRl],y.p)
D.aVd=new A.a4(C.x8,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.aV2=new A.a4(D.q2,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.aVu=new A.a4(C.dm,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.akD=new A.U(63625,"MaterialIcons",null,!1)
D.aVE=new A.a4(D.akD,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aE2=x([D.aVd,D.aV2,D.aVu,D.aVE],A.as("G<+(U,o)>"))
D.aGo=x([D.ox,D.oy,D.f0],A.as("G<DL>"))
D.N2=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aNB=new B.FP(0,"idle")
D.Tb=new B.FP(1,"loading")
D.jt=new B.FP(2,"ready")
D.aNC=new B.FP(3,"failed")
D.ans=new A.F(C.c1,18,D.dj,null,null,null)
D.a0v=new A.r(!0,C.ar,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bnp=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,D.a0v,null,null,null,null,null,null,null,null)
D.aAP=x([D.ans,C.b4,D.bnp],y.p)
D.aZu=new A.en(C.af,C.d,C.e,C.i,null,C.l,null,0,D.aAP,null)
D.aQl=new A.H(C.aU,D.aZu,null)
D.agD=new A.Z(2,6,2,4)
D.b4e=new A.r(!0,C.A,null,null,null,null,14,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bbW=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.b4e,null,null,null,null,null,null,null,null)
D.aQz=new A.H(D.agD,D.bbW,null)
D.bnN=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.hM,null,null,null,null,null,null,null,null)
D.aCg=x([M.th,C.I,D.bnN],y.p)
D.aZp=new A.en(C.af,C.cE,C.e,C.i,null,C.l,null,0,D.aCg,null)
D.aQJ=new A.H(C.DZ,D.aZp,null)
D.Af=new A.r(!0,D.dN,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bo6=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Af,null,null,null,null,null,null,null,null)
D.aQO=new A.H(C.dO,D.bo6,null)
D.bnj=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.b9,C.a4,null,null,null,null,null,null,null)
D.aQW=new A.H(C.C,D.bnj,null)
D.agA=new A.Z(2,0,2,8)
D.bjA=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.b9,null,null,null,null,null,null,null,null)
D.aRc=new A.H(D.agA,D.bjA,null)
D.apu=new A.F(C.kE,30,C.A,null,null,null)
D.boL=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Ag,null,null,null,null,null,null,null,null)
D.ahL=new A.bM(1,C.ac,D.boL,null)
D.aCv=x([D.apu,C.Z,D.ahL],y.p)
D.aZd=new A.en(C.af,C.d,C.e,C.i,null,C.l,null,0,D.aCv,null)
D.ap6=new A.F(C.dm,18,D.dj,null,null,null)
D.a_Y=new A.r(!0,D.dj,null,null,null,null,12,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bn2=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a_Y,null,null,null,null,null,null,null,null)
D.aBf=x([D.ap6,C.bX,D.bn2],y.p)
D.aZn=new A.en(C.af,C.d,C.Q,C.i,null,C.l,null,0,D.aBf,null)
D.b0C=new A.P(0,30)
D.tg=new A.P(1/0,54)
D.b12=new A.P(1/0,48)
D.b15=new A.P(1/0,50)
D.b18=new A.P(1/0,52)
D.b3K=new A.r(!0,C.h,null,null,null,null,14.5,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b4_=new A.r(!0,C.h,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.zZ=new A.r(!0,D.eD,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.jR=new A.r(!0,C.h,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b7l=new A.r(!0,D.eD,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b7O=new A.r(!0,C.A,null,null,null,null,24,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b86=new A.r(!0,C.A,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b8V=new A.r(!0,D.dN,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b8W=new A.r(!0,D.dj,null,null,null,null,null,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b9c=new A.r(!0,C.h,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.baS=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.hP,null,null,null,null,null,null,null,null)
D.bby=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.dK,null,null,null,null,null,null,null,null)
D.bbY=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.nX,null,null,null,null,null,null,null,null)
D.bc1=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.b9,null,null,null,null,null,null,null,null)
D.bcq=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.b9,null,null,null,null,null,null,null,null)
D.bcP=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.hM,null,null,null,null,null,null,null,null)
D.bev=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cA,null,null,null,null,null,null,null,null)
D.bfe=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bJ,null,null,null,null,null,null,null,null)
D.bfj=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.b9,null,null,null,null,null,null,null,null)
D.bfK=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.Ak,null,null,null,null,null,null,null,null)
D.bgW=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u062a\u064a\u0646 \u0633\u0643\u0648\u062a",null,F.b9,null,null,null,null,null,null,null,null)
D.bgY=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bhv=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,I.o0,null,null,null,null,null,null,null,null)
D.biq=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Af,null,null,null,null,null,null,null,null)
D.bj_=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.c5,null,null,null,null,null,null,null,null)
D.bji=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.b9,null,null,null,null,null,null,null,null)
D.bjB=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.b9,null,null,null,null,null,null,null,null)
D.b71=new A.r(!0,D.eD,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bkV=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.b71,null,null,null,null,null,null,null,null)
D.blj=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,I.o0,null,null,null,null,null,null,null,null)
D.blP=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a_r,null,null,null,null,null,null,null,null)
D.bm2=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cA,null,null,null,null,null,null,null,null)
D.bmm=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bmD=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bnb=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.b9,null,null,null,null,null,null,null,null)
D.bnc=new A.m("\u062e\u0644\u0635\u062a",null,N.A8,null,null,null,null,null,null,null,null)
D.bnd=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Af,null,null,null,null,null,null,null,null)
D.boa=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.c5,null,null,null,null,null,null,null,null)
D.boe=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.dK,null,null,null,null,null,null,null,null)
D.boK=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.b9,null,null,null,null,null,null,null,null)
D.a1F=new B.agq(null)
D.bq3=new B.BT(null)
D.bq4=new B.Tr(2,1,!0,!1,!1)
D.a1K=new B.Tt(!1,!1,!1,!1,!1,0)
D.iF=new B.mW(0,"ok")
D.u_=new B.mW(1,"near")
D.u0=new B.mW(2,"wrong")
D.u1=new B.mW(3,"missing")
D.a29=new B.mW(4,"extra")
D.akl=new A.U(63456,"MaterialIcons",null,!1)
D.btW=new B.Ca(D.dN,D.akl,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.buy=new B.VG(!1,null)
D.AQ=new B.VG(!0,null)
D.lO=new B.CP(0,"idle")
D.uf=new B.CP(1,"playing")
D.ug=new B.CP(2,"recording")
D.oo=new B.CP(3,"thinking")
D.k_=new B.CP(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cCm","ceo",()=>new B.b1b())
x($,"cFB","cgF",()=>A.aW("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cFC","cgG",()=>A.aW("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cFO","cgP",()=>A.aW("\u0648\u0670",!0,!1,!1))
x($,"cF9","cgl",()=>A.aW("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cDw","cfc",()=>A.aW("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cEG","cfY",()=>A.aW("[\u0654\u0655]",!0,!1,!1))
x($,"cDx","cfd",()=>A.aW("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cDE","cfj",()=>A.aW("[\u0624\u0626]",!0,!1,!1))
x($,"cEI","cg_",()=>A.aW("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cFe","cgo",()=>A.aW("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cEQ","cg6",()=>A.aW("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cFz","c2y",()=>A.aW("\\s+",!0,!1,!1))
x($,"czK","qo",()=>B.chE(D.ox,0,A.ciW(0,!0)))
x($,"cCn","KU",()=>new B.Ts($.ceo(),D.bq4,B.cpo(),D.aNB,$.R()))})()};
(a=>{a["3SmfVJ1NqacJUUnIdgPpmQaYhkQ="]=a.current})($__dart_deferred_initializers__);