((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,K,L,P,M,G,N,Q,I,B={
ctV(d){var x,w,v,u,t,s
if(d instanceof B.lp)return d
try{x=A.cU(d)
w=x.code
v=x.message
u=w==null?"failed":A.a0(w)
t=v==null?"":A.a0(v)
return new B.lp(u,t)}catch(s){u=A.n(d)
return new B.lp("failed",u)}},
ahu:function ahu(){this.b=this.a=null},
b2R:function b2R(d){this.a=d},
b2U:function b2U(){},
b2T:function b2T(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b2S:function b2S(d){this.a=d},
b2Y:function b2Y(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b2W:function b2W(d){this.a=d},
b2X:function b2X(d){this.a=d},
b2Z:function b2Z(d){this.a=d},
b30:function b30(d,e,f){this.a=d
this.b=e
this.c=f},
b3_:function b3_(d,e,f){this.a=d
this.b=e
this.c=f},
b2V:function b2V(){},
ctW(d,e){return new B.lp(d,e)},
Uk:function Uk(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
IN:function IN(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
IP:function IP(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
IO:function IO(d,e){this.a=d
this.b=e},
lp:function lp(d,e){this.a=d
this.b=e},
cgu(d){var x,w=$.cl5()
w=A.bG(d,w,"\u0627")
x=$.cl6()
w=A.bG(w,x,"\u064a")
x=$.clf()
w=A.bG(w,x,"\u0627")
x=$.cjC()
w=A.bG(w,x,"\u0627")
x=$.ckM()
w=A.bG(w,x,"\u0621")
x=$.cko()
w=A.bG(w,x,"\u0621")
x=$.cjD()
w=A.bG(w,x,"\u0627")
x=$.cjJ()
w=A.bG(w,x,"\u0621")
w=A.bG(w,"\u0649","\u064a")
w=A.bG(w,"\u0629","\u0647")
x=$.ckq()
w=A.bG(w,x,"")
x=$.ckP()
w=A.bG(w,x," ")
x=$.ckx()
w=A.bG(w,x," ")
x=$.c6B()
return C.c.O(A.bG(w,x," "))},
cyC(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kj(x,w)
for(u=0;u<x;++u)v[u]=u
t=A.ck(x,0,!1,w)
for(s=1;s<=l;++s,r=t,t=v,v=r){t[0]=s
for(w=s-1,u=1;u<=k;++u){q=u-1
p=d.charCodeAt(w)===e.charCodeAt(q)?0:1
o=v[u]+1
n=t[q]+1
m=v[q]+p
if(o<n)q=o<m?o:m
else q=n<m?n:m
t[u]=q}}return v[k]},
c0w(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aD("[\u0627\u0621]",!0,!1,!1)
w=A.bG(d,x,"")
x=A.aD("[\u0627\u0621]",!0,!1,!1)
v=A.bG(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cyC(d,e)/u
return s>=1?0.99:s},
E5(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tz(d,$.c6B()),w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.length===0)continue
t=B.cgu(u)
s=A.bG(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Rp(r.a+" "+u,r.b))}continue}q.push(new B.Rp(u,s))}return q},
cxk(d,e){var x,w,v,u,t=new B.bWc(),s=A.a([],y.s)
for(x=A.fL(e,0,A.iI(5,"count",y.S),A.ak(e).c),w=x.$ti,x=new A.c9(x,x.gM(0),w.i("c9<aY.E>")),w=w.i("aY.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.J6)&&t.$2(d,D.J6)?C.b.jR(d,5):d
return!t.$2(s,D.NK)&&t.$2(u,D.NK)?C.b.jR(u,4):u},
cfx(d,e){var x=B.E5(d),w=B.cgu(e),v=y.U
v=A.aa(new A.am(A.a(w.split(" "),y.s),new B.bYb(),v),v.i("Y.E"))
return new B.Hn(x,B.cwv(x,B.cxk(v,x)),w)},
cwv(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.K)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.ck(x,0,!1,s)
q=A.ck(x,0,!1,y.S)
p=A.ck(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c0w(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c0w(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c0w(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.iQ
else m=a2>=0.6?D.ug:D.uh
a1.push(new B.mG(o,x,s,m))
break
case 1:--o
a1.push(new B.mG(o,a4[o],null,D.ui))
break
case 2:--n
a1.push(new B.mG(null,null,a6[n],D.a33))
break
case 3:--o
a3=n-2
a1.push(new B.mG(o,a4[o],a6[a3]+" "+a6[n-1],D.iQ))
n=a3
break
default:x=o-1;--n
a1.push(new B.mG(x,a4[x],a6[n],D.iQ))
o-=2
a1.push(new B.mG(o,a4[o],a6[n],D.iQ))}}a4=y.e
a4=A.aa(new A.d7(a1,a4),a4.i("aY.E"))
return a4},
ng:function ng(d,e){this.a=d
this.b=e},
Rp:function Rp(d,e){this.a=d
this.b=e},
mG:function mG(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Hn:function Hn(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aU7:function aU7(d){this.a=d},
aU6:function aU6(){},
bWc:function bWc(){},
bYb:function bYb(){},
cm4(d,e,f){return new B.r2(d,e,f)},
czv(d){var x
A:{if("memorized"===d){x=D.f9
break A}if("learning"===d){x=D.oR
break A}x=D.oQ
break A}return x},
chp(d,e){return d>=1&&d<=114&&e>=1&&e<=H.cJ[d-1].a[1]},
ctX(){var x=y.S
return new B.ahv(A.C(x,y.u),A.aV(x))},
b33(d){var x=d.f9()
return C.c.df(C.j.j(A.bo(x)),4,"0")+"-"+C.c.df(C.j.j(A.bt(x)),2,"0")+"-"+C.c.df(C.j.j(A.bU(x)),2,"0")},
ccD(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cAS(),x),x.i("aY.E"))
return B.b33(A.dk(w[0],w[1],w[2]-1,12,0,0,0))},
c3F(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.C(p,y.u),n=A.aV(p),m=new B.ahv(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcK(),x=x.ga_(x),w=y.j;x.v();){v=x.gJ()
u=A.dS(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aP(t)>=3){v=C.j.aJ(u,1000)
s=C.j.a0(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=H.cJ[v-1].a[1])}if(v)continue
v=J.ba(t)
r=C.f.c2(A.d2(v.h(t,0)))
if(r<0||r>=3)continue
o.q(0,u,new B.r2(D.aIJ[r],C.f.c2(A.d2(v.h(t,1))),new A.b3(A.lN(C.f.c2(A.d2(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.ayx(q,y.o)
p=A.m7(x,new B.b32(),x.$ti.i("Y.E"),p)
n.A(0,new A.am(p,o.ga2J(),A.y(p).i("am<Y.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aL(d.h(0,"streak"))
p=p==null?null:C.f.c2(p)
p=m.d=p==null?0:p
o=A.aL(d.h(0,"best"))
o=o==null?null:C.f.c2(o)
m.e=o==null?p:o
return m},
axW(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.df(C.j.j(d),3,"0")+C.c.df(C.j.j(e),3,"0")+".mp3"},
En:function En(d,e){this.a=d
this.b=e},
r2:function r2(d,e,f){this.a=d
this.b=e
this.c=f},
ahv:function ahv(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b34:function b34(){},
b35:function b35(){},
b32:function b32(){},
Ui:function Ui(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
crt(){return new B.wk(null)},
cDa(d,e){var x,w,v,u,t={},s=H.cJ[e-1].a[1],r=$.LH().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.qR():v).a===D.f9}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.cU(u+4,1,s)
return A.ed(C.cS,new B.c_r(t,s,e),d,!0,null,null,!1,y.l)},
c5r(d){return A.df(0,0,0,0,0,C.j.cU(C.f.aw(6+d*1.2),25,90))},
c4p(d){return E.bs(C.j.aJ(d,60))+":"+C.c.df(E.bs(C.j.a0(d,60)),2,"\u0660")},
che(d){return A.ed(C.cS,new B.c0c($.LH()),d,!0,null,null,!1,y.H)},
Gt:function Gt(d,e){this.a=d
this.b=e},
Uj:function Uj(d,e,f,g,h){var _=this
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
_.T$=_.S$=0},
b36:function b36(d){this.a=d},
b37:function b37(d){this.a=d},
b38:function b38(d){this.a=d},
wk:function wk(d){this.a=d},
ZC:function ZC(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bFJ:function bFJ(d){this.a=d},
bFI:function bFI(d,e){this.a=d
this.b=e},
bFK:function bFK(d){this.a=d},
bFH:function bFH(d,e){this.a=d
this.b=e},
bFL:function bFL(){},
bFv:function bFv(){},
bFB:function bFB(d,e,f){this.a=d
this.b=e
this.c=f},
bFC:function bFC(){},
bFF:function bFF(d){this.a=d},
bFE:function bFE(){},
bFG:function bFG(d){this.a=d},
bFy:function bFy(d,e){this.a=d
this.b=e},
bFz:function bFz(d){this.a=d},
bFx:function bFx(){},
bFA:function bFA(d){this.a=d},
bFw:function bFw(d){this.a=d},
bFD:function bFD(d,e){this.a=d
this.b=e},
Gu:function Gu(d,e,f){this.c=d
this.d=e
this.a=f},
Wx:function Wx(d,e){this.c=d
this.a=e},
c_r:function c_r(d,e,f){this.a=d
this.b=e
this.c=f},
c_o:function c_o(d,e,f){this.a=d
this.b=e
this.c=f},
c_q:function c_q(d,e){this.a=d
this.b=e},
c_n:function c_n(d,e){this.a=d
this.b=e},
c_m:function c_m(d,e){this.a=d
this.b=e},
c_p:function c_p(d,e){this.a=d
this.b=e},
c_i:function c_i(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c_h:function c_h(d,e,f){this.a=d
this.b=e
this.c=f},
c_j:function c_j(d){this.a=d},
c_k:function c_k(d){this.a=d},
c_l:function c_l(d,e){this.a=d
this.b=e},
Dp:function Dp(d,e){this.a=d
this.b=e},
Cu:function Cu(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a1_:function a1_(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.at=_.as=_.Q=_.z=null
_.ax=0
_.c=_.a=_.ay=null},
bSF:function bSF(){},
bSV:function bSV(d,e){this.a=d
this.b=e},
bSZ:function bSZ(d){this.a=d},
bT_:function bT_(d){this.a=d},
bT0:function bT0(d,e,f){this.a=d
this.b=e
this.c=f},
bT2:function bT2(d){this.a=d},
bT3:function bT3(d){this.a=d},
bT1:function bT1(){},
bT5:function bT5(d){this.a=d},
bT4:function bT4(d){this.a=d},
bT6:function bT6(d,e){this.a=d
this.b=e},
bT8:function bT8(d){this.a=d},
bT9:function bT9(d){this.a=d},
bT7:function bT7(){},
bSU:function bSU(d,e){this.a=d
this.b=e},
bSW:function bSW(d,e,f){this.a=d
this.b=e
this.c=f},
bSN:function bSN(d){this.a=d},
bSO:function bSO(d){this.a=d},
bSM:function bSM(){},
bSP:function bSP(){},
bSQ:function bSQ(d,e){this.a=d
this.b=e},
bTe:function bTe(d){this.a=d},
bTf:function bTf(d){this.a=d},
bTg:function bTg(d,e){this.a=d
this.b=e},
bTd:function bTd(d){this.a=d},
bST:function bST(){},
bSS:function bSS(d){this.a=d},
bSR:function bSR(d,e){this.a=d
this.b=e},
bSY:function bSY(d){this.a=d},
bSX:function bSX(d){this.a=d},
bTa:function bTa(){},
bTb:function bTb(){},
bTc:function bTc(){},
bSG:function bSG(d,e,f){this.a=d
this.b=e
this.c=f},
bSH:function bSH(d){this.a=d},
bSJ:function bSJ(){},
bSI:function bSI(){},
bSK:function bSK(d){this.a=d},
bSL:function bSL(d){this.a=d},
CK:function CK(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
Ct:function Ct(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a0Z:function a0Z(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.Q=_.z=_.y=null
_.as=h
_.c=_.a=null},
bSo:function bSo(){},
bSx:function bSx(d,e){this.a=d
this.b=e},
bSy:function bSy(d){this.a=d},
bSw:function bSw(){},
bSA:function bSA(d){this.a=d},
bSz:function bSz(d,e){this.a=d
this.b=e},
bSB:function bSB(d,e){this.a=d
this.b=e},
bSs:function bSs(d,e){this.a=d
this.b=e},
bSt:function bSt(d,e,f){this.a=d
this.b=e
this.c=f},
bSu:function bSu(d,e,f){this.a=d
this.b=e
this.c=f},
bSp:function bSp(d,e,f){this.a=d
this.b=e
this.c=f},
bSq:function bSq(d,e,f){this.a=d
this.b=e
this.c=f},
bSr:function bSr(d,e){this.a=d
this.b=e},
bSv:function bSv(d){this.a=d},
bSC:function bSC(){},
bSD:function bSD(d,e){this.a=d
this.b=e},
bSE:function bSE(d,e){this.a=d
this.b=e},
Cs:function Cs(d){this.a=d},
a0Y:function a0Y(d){this.d=d
this.c=this.a=null},
bSf:function bSf(){},
bSm:function bSm(d){this.a=d},
bSn:function bSn(){},
bSl:function bSl(d,e){this.a=d
this.b=e},
bSk:function bSk(d,e,f){this.a=d
this.b=e
this.c=f},
bSj:function bSj(d,e,f){this.a=d
this.b=e
this.c=f},
bSi:function bSi(d){this.a=d},
bSg:function bSg(d){this.a=d},
bSh:function bSh(d){this.a=d},
c0c:function c0c(d){this.a=d},
c0b:function c0b(d){this.a=d},
c06:function c06(d,e){this.a=d
this.b=e},
c08:function c08(){},
c07:function c07(){},
c09:function c09(d,e){this.a=d
this.b=e},
c0a:function c0a(d,e){this.a=d
this.b=e},
aht:function aht(d){this.a=d},
b2Q:function b2Q(d){this.a=d}},D,R,O,H,E,F
J=c[1]
A=c[0]
C=c[2]
K=c[14]
L=c[18]
P=c[20]
M=c[31]
G=c[13]
N=c[22]
Q=c[10]
I=c[36]
B=a.updateHolder(c[8],B)
D=c[37]
R=c[29]
O=c[34]
H=c[27]
E=c[15]
F=c[17]
B.ahu.prototype={
qM(){var x=this,w=x.a
if(w!=null)return A.eb(w,y.m)
w=x.b
return w==null?x.b=new B.b2R(x).$0():w},
u_(d,e){return this.aLi(d,e,e)},
aLi(d,e,f){var x=0,w=A.k(f),v,u=2,t=[],s,r,q,p
var $async$u_=A.f(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$u_)
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
r=B.ctV(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$u_,w)},
o4(d,e){var x=A.em(d[e])
if(x==null)x=null
return x===!0},
Md(){var x=0,w=A.k(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$Md=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.qM(),$async$Md)
case 7:r=h.cU(g.db(e,"support",null,null,null,null))
q=s.o4(r,"worker")
p=s.o4(r,"wasm")
o=s.o4(r,"mic")
n=s.o4(r,"audio")
s.o4(r,"webgpu")
m=s.o4(r,"secure")
s.o4(r,"ios")
l=A.kJ(r.memory)
if(l==null)l=null
if(l==null)l=0
s.o4(r,"isolated")
k=A.kJ(r.cores)
if(k!=null)C.f.aw(k)
v=new B.Uk(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a2D
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Md,w)},
E2(){var x=0,w=A.k(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$E2=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.qM(),$async$E2)
case 8:x=7
return A.c(m.eF(l.cU(k.db(e,"storage",null,null,null,null)),y.A),$async$E2)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.aw(A.dI(r.quota))
p=C.f.aw(A.dI(r.usage))
v=new A.ars(q,p)
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
return A.j($async$E2,w)},
bgm(){var x=y.K
A.Ow(this.qM().bB(new B.b2U(),x),x)},
qL(d,e){var x=A.kJ(d[e])
x=x==null?null:C.f.aw(x)
return x==null?0:x},
bdN(d,e,f){return this.u_(new B.b2T(this,d,e,f),y.C)},
gaiW(){var x,w
try{x=A.my(b.G.sessionStorage)
return x}catch(w){return null}},
gaqj(){var x=A.em(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a7Z(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.em(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gaqj())return!1
l=A.em(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cU(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.a0(x.userAgent)
l=A.kJ(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.u(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aD("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.e(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aD("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.kJ(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.gaiW()
l=l==null?f:A.u(A.db(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dS(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.my(m.localStorage)
m=o
m=m==null?f:A.u(A.db(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dS(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
aoS(){var x,w,v,u,t,s,r=null
try{x=this.gaiW()
if(x!=null)A.db(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cU(x.location)
u=A.a0(v.hash)
t=A.a0(v.search)
s=A.bl(A.a0(A.cU(x.document).baseURI),0,r).a2("tutor/").j(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.db(v,"replace",s+t+x,r,r,r)},
bdw(){var x,w=null,v=b.G,u=A.cU(v.history),t=A.kJ(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.db(u,"back",w,w,w,w)
else{x=A.a0(A.cU(v.document).baseURI)
A.db(A.cU(v.location),"replace",A.bl(x,0,w).a2("./").j(0)+"#/",w,w,w)}},
a89(d,e,f,g,h){return this.u_(new B.b2Y(this,e,d,f,h,g),y.H)},
a8c(){return this.u_(new B.b2Z(this),y.D)},
a2m(){var x=null,w=this.a
if(w!=null)A.db(w,"cancelRecording",x,x,x,x)},
akh(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.qL(d,"ms")
w=A.kJ(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.IP(u,x,w,v.qL(d,"frames"),v.qL(d,"tokens"),v.o4(d,"retried"),v.qL(d,"encMs"),v.qL(d,"decMs"),v.qL(d,"featMs"))},
agN(d){var x={}
x.words=d
return x},
atq(d,e){return this.u_(new B.b30(this,d,e),y._)},
biw(d,e){return this.u_(new B.b3_(this,d,e),y._)},
Kk(d,e){return this.bgq(d,e)},
bgq(d,e){var x=0,w=A.k(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Kk=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.qM(),$async$Kk)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.ak(d).i("au<1,o>")
o=A.aa(new A.au(d,new B.b2V(),o),o.i("aY.E"))
x=11
return A.c(A.eF(A.cU(A.db(r,"play",o,e,null,null)),y.y),$async$Kk)
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
return A.j($async$Kk,w)},
LW(){var x=null,w=this.a
if(w!=null)A.db(w,"stopPlayback",x,x,x,x)},
a5G(d){var x=this.a
if(x!=null)A.db(x,"prefetch",d,null,null,null)}}
B.Uk.prototype={}
B.IN.prototype={
gmJ(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.IP.prototype={
gS2(){var x=this,w=C.f.am(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.IO.prototype={}
B.lp.prototype={
gil(){var x,w=this.a
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
$ibN:1}
B.ng.prototype={
R(){return"WordStatus."+this.b}}
B.Rp.prototype={}
B.mG.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Hn.prototype={
gLV(){var x,w=this,v=w.d
if(v===$){x=new B.aU7(w).$0()
w.d!==$&&A.ap()
w.d=x
v=x}return v},
gJ6(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.d===D.a33&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbeD(){return J.h2(this.gLV(),new B.aU6()).gM(0)},
gt3(){var x=this.a
return x.length!==0&&this.gbeD()===x.length&&this.gJ6().length===0}}
B.En.prototype={
R(){return"AyahStatus."+this.b}}
B.r2.prototype={}
B.ahv.prototype={
a5i(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.qR():x},
aXO(d){var x=this,w=B.b33(d),v=x.c
if(v===w)return
v=v!=null&&v===B.ccD(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
ao3(){var x=Date.now(),w=B.b33(new A.b3(x,0,!1))
x=this.c
return x===w||x===B.ccD(w)?this.d:0},
asu(d,e,f,g){var x=this,w=new A.b3(Date.now(),0,!1),v=x.a5i(d,e),u=g?C.j.cU(v.b+1,0,100):0,t=g&&u>=f?D.f9:D.oR,s=new B.r2(t,u,w.i4()),r=d*1000+e
x.a.q(0,r,s)
x.b.F(0,r)
x.aXO(w)
return s},
a59(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=H.cJ[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qR():s).a===D.f9)++u}return u},
bdu(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=H.cJ[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qR():s).a===D.oR)++u}return u},
gart(){var x=this.a,w=A.y(x).i("cd<2>")
return new A.am(new A.cd(x,w),new B.b34(),w.i("am<Y.E>")).gM(0)},
gax4(){var x=this.a,w=A.y(x).i("bF<1>")
w=A.m7(new A.bF(x,w),new B.b35(),w.i("Y.E"),y.S)
w=A.eS(w,A.y(w).i("Y.E"))
x=A.aa(w,A.y(w).c)
C.b.ma(x)
return x},
dA(){var x,w,v,u,t,s=this,r=y.N,q=A.C(r,y.L)
for(x=s.a,x=new A.eB(x,A.y(x).i("eB<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.q(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.aa(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
b9s(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Y)
for(x=this.b,x=A.b1o(x,300,A.y(x).c),x=new A.It(J.aC(x.a),x.b,A.y(x).i("It<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gJ()
s=C.j.aJ(t,1000)
t=C.j.a0(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.qR():q).a===D.f9?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.qR()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.qR():r).c.jL()],w,v))}return o},
be4(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.K)(d),++u){t=d[u]
s=A.ex(t.h(0,"surah"))*1000+A.ex(t.h(0,"ayah"))
r=w.h(0,C.j.aJ(s,1000)*1000+C.j.a0(s,1000))
if((r==null?$.qR():r).c.jL()===t.h(0,"updated_at"))v.K(0,s)}},
bec(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aC(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gJ()
if(!u.b(s))continue
r=A.aL(s.h(0,"surah"))
q=r==null?null:C.f.c2(r)
r=A.aL(s.h(0,"ayah"))
p=r==null?null:C.f.c2(r)
o=A.dW(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=H.cJ[q-1].a[1])
if(r)continue
n=B.czv(s.h(0,"status"))
if(n===D.oQ)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.aL(s.h(0,"perfect_count"))
l=l==null?null:C.f.c2(l)
v.q(0,r,new B.r2(n,C.j.cU(l==null?0:l,0,100),o.i4()))
w.K(0,r)
t=!0}return t}}
B.Ui.prototype={
Iz(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Ui(w,v,u,t,f==null?x.e:f)},
b7L(d){var x=null
return this.Iz(x,x,d,x,x)},
anz(d){var x=null
return this.Iz(x,d,x,x,x)},
b7P(d){var x=null
return this.Iz(x,x,x,x,d)},
b78(d){var x=null
return this.Iz(d,x,x,x,x)},
b7M(d){var x=null
return this.Iz(x,x,x,d,x)},
dA(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Gt.prototype={
R(){return"ModelState."+this.b}}
B.Uj.prototype={
vj(){var x=this.Q
return x==null?this.Q=new B.b36(this).$0():x},
ql(d){return this.avh(d)},
avh(d){var x=0,w=A.k(y.H),v=this
var $async$ql=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:v.b=d
v.a6()
x=2
return A.c(A.j5("mt.tutor.settings",C.au.iB(d.dA(),null)),$async$ql)
case 2:return A.i(null,w)}})
return A.j($async$ql,w)},
zl(){var x=0,w=A.k(y.H),v=this,u
var $async$zl=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:v.a6()
x=2
return A.c(A.j5("mt.tutor.progress",C.au.iB(v.c.dA(),null)),$async$zl)
case 2:u=v.as
if(u!=null)u.aD()
v.as=A.cS(C.y,v.gaC1())
return A.i(null,w)}})
return A.j($async$zl,w)},
LF(d,e,f){return this.aw3(d,e,f)},
aw3(d,e,f){var x=0,w=A.k(y.H),v=this
var $async$LF=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:v.z=new A.aO(d,e,f)
x=2
return A.c(A.j5("mt.tutor.last",C.au.iB(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$LF)
case 2:return A.i(null,w)}})
return A.j($async$LF,w)},
CL(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$CL=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.TV||n===D.jG){x=1
break}s.f=D.TV
s.y=null
s.a6()
u=4
n=A.mt().gf3().h(0,"tutor_device")
if(n==null)n="auto"
p=A.mt().gf3().h(0,"tutor_threads")
p=A.dS(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bdN(new B.b37(s),n,p),$async$CL)
case 7:s.x=e
s.f=D.jG
n=A.mt().gf3().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.E4().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a9(m)
if(n instanceof B.lp){q=n
s.f=D.aQ6
s.y=q
n=A.mt().gf3().h(0,"debug")
if(n==="1")A.E4().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a6()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$CL,w)},
wk(){var x=0,w=A.k(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wk=A.f(function(a0,a1){if(a0===1){t.push(a1)
x=u}for(;;)switch(x){case 0:if(r.at){x=1
break}q=null
try{k=$.B().b
k===$&&A.b()
k=k.ga3().e.a
q=(k==null?null:k.r)!=null}catch(d){x=1
break}if(!q){x=1
break}r.at=!0
u=4
k=$.B().b
k===$&&A.b()
p=k
x=7
return A.c(p.aQ("quran_tutor_progress").d6("surah, ayah, status, perfect_count, updated_at"),$async$wk)
case 7:o=a1
n=r.c.bec(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.b9s()
if(J.aP(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.mO(h.x,k,k))
x=11
return A.c(f.bi1("quran_tutor_save",!1,g,i),$async$wk)
case 11:r.c.be4(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.j5("mt.tutor.progress",C.au.iB(r.c.dA(),null)),$async$wk)
case 12:if(n)r.a6()
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
return A.j($async$wk,w)},
Ky(d){return this.bhG(d)},
bhG(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Ky=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c3F(t.c.dA()).dA()
y.f.a(p.h(0,"rows")).e8(0,new B.b38(d))
t.c=B.c3F(p)
x=2
return A.c(t.zl(),$async$Ky)
case 2:v=4
s=$.B().b
s===$&&A.b()
r=s.ga3().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.aC("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$Ky)
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
return A.j($async$Ky,w)}}
B.wk.prototype={
P(){var x=$.LH()
return new B.ZC(x,new A.ae(C.J,$.S()))}}
B.ZC.prototype={
X(){var x,w,v=this
v.Y()
x=v.d
x.ad(v.gog())
w=y.a
x.vj().bB(new B.bFJ(v),w)
G.aSz().bB(new B.bFK(v),w).fO(new B.bFL())
A.Ow(G.c30(),y.y)},
xs(){if(this.c!=null)this.k(new B.bFv())},
m(){var x,w=this
w.d.V(w.gog())
x=w.e
x.p$=$.S()
x.L$=0
w.a1()},
Pb(){var x=0,w=A.k(y.H),v,u=this,t,s
var $async$Pb=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.ql(s.b.b7L(!0)),$async$Pb)
case 3:t=s.a
t.bgm()
if(t.a7Z()){t.aoS()
x=1
break}s.CL()
case 1:return A.i(v,w)}})
return A.j($async$Pb,w)},
xt(d,e,f){return this.aVG(d,e,f)},
b35(d){return this.xt(d,null,null)},
aVG(d,e,f){var x=0,w=A.k(y.H),v,u=this,t,s,r
var $async$xt=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.Z(A.aT(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.a_(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cDa(s,d),$async$xt)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.LF(d,t.a,t.b),$async$xt)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.M(s,!1).az(A.ay(new B.bFB(u,d,t),null,r),r),$async$xt)
case 8:if(u.c!=null)u.k(new B.bFC())
case 1:return A.i(v,w)}})
return A.j($async$xt,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gaqj()&&!A.M(d,!1).uM())u.push(A.bT(x,x,x,x,C.xQ,x,x,t.gbdv(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bT(x,x,x,x,D.arP,x,x,new B.bFF(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bT(x,x,x,x,C.il,x,x,new B.bFG(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aEh
else w=t?this.aQF():this.aRf()
return K.x1(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aRf(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a2D
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b3B,C.a0],x)
for(t=0;t<4;++t){s=D.aGm[t]
u.push(new A.H(C.bt,A.A(A.a([A.b7(s.a,C.aq,p,18),C.K,new A.bS(1,C.ac,A.d(s.b,p,p,p,p,D.b9u,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bu2,C.I,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bs(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aJ,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bs(C.f.aw(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.I,A.d(q,p,p,p,p,A.bK(p,p,r?D.dT:C.cR,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.I,D.bt5],x))
x=A.a([new E.dA(u,C.a4,C.aQ,p,!0,p),new E.dA(A.I(s,C.q,C.d,C.e,0,C.l),C.a4,C.aQ,p,!1,p),D.bC0,C.I],x)
if(v!=null)x.push(new E.dA(A.d(v,p,p,p,p,D.ben,p,p,p),C.a4,C.aQ,p,!1,p))
else x.push(A.fs(D.aoQ,D.bk3,this.gaVY(),A.eA(C.v,C.af,D.b6w,p,p)))
x.push(C.a1)
x.push(D.a2y)
return x},
aQF(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.O(r.a.a),p=q.length===0,o=p?C.r6:G.ch7(q),n=t.z,m=A.R(v.ajB(C.du,E.bs(s.gart())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bs(s.ao3()),k=s.c,j=Date.now()
k=k===B.b33(new A.b3(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Gu(t,!1,u),A.A(A.a([m,C.K,A.R(v.ajB(C.kP,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.u],j)
if(n!=null){t=G.k6(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bs(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bs(m)+"\u2013"+E.bs(l)
k.push(new E.dA(A.A(A.a([D.aqY,C.X,A.R(A.I(A.a([D.bgk,A.d(t+" \u2014 "+m,u,u,u,u,C.bz,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),L.ne],j),C.h,C.d,C.e,0,u,u),C.a4,C.aQ,new B.bFy(v,n),!0,u))}t=C.i.ae(0.08)
k.push(A.aE(u,C.x,!1,u,!0,C.m,u,A.aF(),r,u,u,u,u,u,2,A.cO(u,new A.ch(4,A.v(14),C.N),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.tP,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qr,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bFz(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.dj,!0,C.t,u,C.E,u,u,u,u))
k.push(C.u)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bpg)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.K)(o),++x)t.push(v.Qo(o[x]))
C.b.A(k,t)}else{t=A.a([D.aTb,D.aTR,v.Qo(1)],j)
for(w=114;w>=78;--w)t.push(v.Qo(w))
t.push(C.I)
r=v.f
p=A.b7(r?C.Gi:C.qc,C.aq,u,u)
t.push(A.hJ(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.f1,u,u,u),new B.bFA(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Qo(w))
C.b.A(k,t)}k.push(C.a0)
k.push(D.Bp)
return k},
ajB(d,e,f){var x=null,w=y.p
return new E.dA(A.A(A.a([A.b7(d,C.v,x,x),C.K,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bz,x,x,x),A.d(f,1,C.L,x,x,C.a0V,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a4,C.M,x,!1,x)},
Qo(d){var x,w=null,v=this.d.c,u=H.cJ[d-1].a[1],t=v.a59(d),s=t/u,r=y.p,q=A.ao(A.ds(C.P,A.a([A.c1q(C.eJ,D.dr,w,w,w,w,w,3,s,w),A.d(E.bs(d),w,w,w,w,P.a1e,w,w,w)],r),C.m,C.bj,w),36,36),p=A.d(G.k6(d),w,w,w,w,D.b9e,w,w,w)
if(t===0)x=E.bs(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bs(t)+" \u0645\u0646 "+E.bs(u)
r=A.a([q,C.cF,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bK(w,w,t===u?D.dr:C.cR,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bs(C.f.aw(s*100))+"\u066a",w,w,w,w,D.a0N,w,w,w))
r.push(D.aoZ)
return new E.dA(A.A(r,C.h,C.d,C.e,0,w,w),C.pL,C.da,new B.bFD(this,d),!1,w)}}
B.Gu.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b2
return D.aSX
case 3:x=q.y
x=x==null?r:x.gil()
return new E.dA(A.I(A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":x,r,r,r,r,D.AB,r,r,r),C.I,new A.ze(C.a3o,!1,q.gbdM(),r,r,r,r,C.k,r,!1,r,!0,r,C.u0,r)],y.p),C.q,C.d,C.e,0,C.l),C.a4,C.aQ,r,!1,r)
case 0:case 1:w=q.w
v=q.r
q=w>0
u=q?C.f.cU(v/w,0,1):r
t=q&&v<w
q=A.d(t?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bs(C.f.aw(v/1e6))+" \u0645\u0646 "+E.bs(C.f.aw(w/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.ol,r,r,r)
x=A.v(8)
s=y.p
x=A.a([q,C.B,A.f5(x,A.pG(C.eJ,C.v,7,t?u:r,r),C.aC)],s)
if(!this.d)C.b.A(x,A.a([C.I,D.bkS],s))
return new E.dA(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aQ,r,!1,r)}}}
B.Wx.prototype={
t(d){var x=null,w=D.dT.ae(0.1),v=A.v(14),u=A.aH(D.dT.ae(0.4),1)
return A.D(x,A.A(A.a([D.aqC,C.K,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.AI,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.E(w,x,u,v,x,x,x,C.n),x,x,C.aQ,C.ad,x,x,x)}}
B.Dp.prototype={
R(){return"_Phase."+this.b}}
B.Cu.prototype={
P(){return new B.a1_($.LH(),D.lZ)}}
B.a1_.prototype={
gjo(){var x=this.e
return x===$?this.e=this.a.d:x},
gBk(){var x,w=this.a,v=w.f
w=w.c
x=this.gjo()
return G.LB(w,x,v.xD(w,x)).b},
X(){var x,w=this
w.Y()
x=w.d
x.ad(w.gog())
x.vj()
x.a.a5G(B.axW(w.a.c,w.gjo()))},
xs(){if(this.c!=null)this.k(new B.bSF())},
m(){var x,w=this,v=w.d
v.V(w.gog())
x=w.Q
if(x!=null)x.aD()
v=v.a
v.LW()
v.a2m()
w.a1()},
Z7(d){var x,w,v=this
if(v.f===D.ux)v.d.a.a2m()
x=v.d.a
x.LW()
w=v.Q
if(w!=null)w.aD()
v.k(new B.bSV(v,d))
x.a5G(B.axW(v.a.c,d))
w=v.a
if(d<w.e)x.a5G(B.axW(w.c,d+1))},
QF(d){return this.aS6(d)},
aS6(d){var x=0,w=A.k(y.H),v,u=this,t,s,r,q,p
var $async$QF=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:if(u.f===D.uw){u.d.a.LW()
u.k(new B.bSZ(u))
x=1
break}t=u.r!=null?D.iX:D.lZ
u.k(new B.bT_(u))
s=u.d
r=A.a([B.axW(u.a.c,u.gjo())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.Kk(r,q),$async$QF)
case 3:p=f
if(u.c==null||u.f!==D.uw){x=1
break}u.k(new B.bT0(u,t,p))
case 1:return A.i(v,w)}})
return A.j($async$QF,w)},
Px(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Px=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jG){x=1
break}p=l.a
p.LW()
r=B.E5(s.gBk()).length
s.k(new B.bT2(s))
o=s.Q
if(o!=null)o.aD()
s.Q=A.i0(C.eM,new B.bT3(s))
u=4
o=B.c5r(r)
n=A.df(0,0,0,350*r,0,0)
x=7
return A.c(p.a89(l.b.c,o,n,new B.bT4(s),new B.bT5(s)),$async$Px)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a9(k)
if(l instanceof B.lp){q=l
l=s.Q
if(l!=null)l.aD()
if(s.c!=null)s.k(new B.bT6(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Px,w)},
Bj(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Bj=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.ux){x=1
break}n=s.Q
if(n!=null)n.aD()
s.k(new B.bT8(s))
s.Q=A.i0(C.ig,new B.bT9(s))
m=new A.BY()
$.E8()
m.tA()
r=m
u=4
n=s.d.a
x=7
return A.c(n.a8c(),$async$Bj)
case 7:q=e
if(q.b<0.8){s.a1b("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(n.atq(q,B.E5(s.gBk()).length),$async$Bj)
case 8:p=e
s.ay=A.df(0,0,r.ga3J(),0,0,0)
n=A.mt().gf3().h(0,"debug")
if(n==="1"){A.E4().$1("[tutor] "+s.a.c+":"+s.gjo()+" audio="+C.f.am(q.b,1)+"s infer="+p.b+"ms total="+r.gC8()+"ms "+p.gS2()+" text="+p.a)
s.at="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.am(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.am(p.b/1000,2)+" \u062b\n"+p.gS2()+"\n"+p.a}s.ae_(p.a)
u=2
x=6
break
case 4:u=3
k=t.pop()
n=A.a9(k)
if(n instanceof B.lp){o=n
s.a1b(o.gil())}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Bj,w)},
a1b(d){var x=this,w=x.Q
if(w!=null)w.aD()
if(x.c==null)return
x.k(new B.bSU(x,d))},
ae_(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aD()
if(s.c==null)return
x=B.cfx(s.gBk(),d)
r.a=null
if(C.c.O(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjo()
t=x.gt3()
r.a=w.asu(v,u,q.b.a,t)
q.zl()}s.k(new B.bSW(r,s,x))},
Ne(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h
var $async$Ne=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:i=s.d
if(i.f!==D.jG){x=1
break}s.k(new B.bSN(s))
m=s.Q
if(m!=null)m.aD()
s.Q=A.i0(C.ig,new B.bSO(s))
l=new A.BY()
$.E8()
l.tA()
r=l
u=4
x=7
return A.c(i.a.biw(B.axW(s.a.c,s.gjo()),B.E5(s.gBk()).length),$async$Ne)
case 7:q=e
p="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.am(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.am(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.am(r.gC8()/1000,2)+" \u062b)\n"+q.gS2()+"\n"+q.a
A.E4().$1("[tutor-debug] "+s.a.c+":"+s.gjo()+" audio="+C.f.am(q.c,1)+"s infer="+q.b+"ms total="+r.gC8()+"ms "+q.gS2()+" text="+q.a)
s.ay=A.df(0,0,r.ga3J(),0,0,0)
s.ae_(q.a)
o=s.r
if(o!=null){i=o.gt3()
m=o.b
k=A.ak(m).i("am<1>")
m=A.aa(new A.am(m,new B.bSP(),k),k.i("Y.E"))
A.E4().$1("[tutor-debug] perfect="+i+" ops="+A.n(m))}s.k(new B.bSQ(s,p))
u=2
x=6
break
case 4:u=3
h=t.pop()
i=A.a9(h)
if(i instanceof B.lp){n=i
A.E4().$1("[tutor-debug] failed: "+A.n(n))
s.a1b(n.gil())}else throw h
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Ne,w)},
ga00(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.qR():v).a!==D.f9)return!1}return!0},
t(d){var x,w=this,v=null,u=w.d,t=u.c.a5i(w.a.c,w.gjo()),s=u.b,r=s.d&&!w.x&&w.f!==D.iX,q=G.k6(w.a.c),p=y.p,o=A.a([A.bT(v,v,v,v,C.il,v,v,new B.bTe(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aIy(),m=A.d("\u0622\u064a\u0629 "+E.bs(w.gjo()),v,v,v,v,N.om,v,v,v),l=E.bs(w.gjo()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.b_,A.d("("+l+" \u0645\u0646 "+E.bs(k.e-k.d+1)+")",v,v,v,v,F.aJ,v,v,v),C.by,w.aWD(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.u],p)
if(r)s.push(w.aQA())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.ux&&l!==D.oH}else l=!1
if(l)s.push(w.aGg(m))
else s.push(A.d(w.gBk()+" \ufd3f"+E.bs(w.gjo())+"\ufd3e",v,v,v,v,D.k4,C.a_,C.bg,v))}s=A.a([new B.Gu(u,!0,v),n,C.B,new E.dA(A.I(s,C.ag,C.d,C.e,0,C.l),D.ahS,C.aQ,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.iX)s.push(w.b4u(n))
if(w.r!=null&&w.f===D.iX&&w.ay!=null){x=C.f.aw(C.j.aJ(w.ay.a,1000)/100)
s.push(new A.H(C.bt,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bs(C.j.aJ(x,10))+"\u066b"+E.bs(C.j.a0(x,10)))+" \u062b",v,v,v,v,F.aJ,C.a_,v,v),v))}n=w.as
if(n!=null)s.push(new A.H(C.aQ,A.d(n,v,v,v,v,D.AB,v,v,v),v))
s.push(w.aGP())
s.push(C.a0)
s.push(A.ie(C.v,C.M,v,new B.bTf(w),D.bhY,D.bn7,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga00()
s.push(new E.dA(A.A(A.a([D.anw,C.X,A.R(A.I(A.a([D.boF,A.d(w.ga00()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aJ,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),L.ne],p),C.h,C.d,C.e,0,v,v),C.a4,C.aQ,new B.bTg(w,d),n,v))}n=A.mt().gf3().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dr(D.aoP,D.bmx,u.f===D.jG&&w.f!==D.oH?w.gaHy():v,v)],p)
n=w.at
if(n!=null)p.push(new A.H(C.ih,A.HP(n,F.aJ,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gmJ()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aJ,v,v,v))}C.b.A(s,p)}s.push(C.B)
s.push(D.Bp)
return K.x1(o,s,q)},
aIy(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b2
return A.ao(A.fu(new B.bSS(this),w,null,C.ae,new B.bST()),36,null)},
aWD(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.f9)return D.b3M
x=d.b
w=E.bs(x)
v=E.bs(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.bU:C.Gz
u.push(new A.H(D.aiy,A.b7(r,s?D.dr:C.fd,q,16),q))}return A.c3C(A.A(u,C.h,C.d,C.O,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aQA(){var x=null
return A.bA(!1,A.v(12),!0,A.D(x,D.ae0,C.k,x,x,new A.E(C.vx,x,x,A.v(12),x,x,x,C.n),x,x,x,D.ahr,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bSY(this),x,x,x,x,x,x,x)},
aGg(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.aG(d.gLV(),w)
A:{if(D.iQ===v){u=D.k4.ck(D.dr)
break A}if(D.ug===v){u=D.k4.a30(D.dT,C.iK,D.dT)
break A}if(D.uh===v){u=D.k4.a30(D.eI,C.iK,D.eI)
break A}u=D.k4.a30(C.fd,C.k1,C.cD)
break A}t=x[w]
r.push(new A.eX(t.a,s,s,C.bx,s,s,s,s,s,s,u))
r.push(O.As)}x=E.bs(this.gjo())
r.push(A.ek(s,s,s,s,s,s,s,s,s,D.k4.ck(C.aq),"\ufd3f"+x+"\ufd3e"))
return A.Iu(A.ek(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.a_,C.bg)},
b4u(d){var x,w,v,u,t,s,r=this.w
if(C.c.O(d.c).length===0)return D.bBn
if(d.gt3()){x=r==null
if((x?null:r.a)===D.f9&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.f9?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bs(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.CK(D.dr,C.bU,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gLV()
w=J.dE(x)
v=w.ir(x,new B.bTa()).gM(0)
u=w.ir(x,new B.bTb()).gM(0)
t=w.ir(x,new B.bTc()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bs(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bs(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bs(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJ6().length!==0)x.push(E.bs(d.gJ6().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eI:D.dT
x=C.b.aE(x," \u2022 ")
s=d.gJ6().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aE(d.gJ6(),"\u060c "):""
return new B.CK(w,C.n3,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aGP(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jG,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aJ(new A.b3(f,0,!1).dN(w).a,1e6)}v=C.j.aJ(B.c5r(B.E5(j.gBk()).length).a,1e6)
f=j.gb37()
w=96+26*j.y
u=D.eI.ae(0.25)
w=A.iT(i,A.a3H(C.P,A.D(i,D.ap1,C.k,i,i,D.a5Z,i,84,i,i,i,i,84),i,C.aR,new A.E(u,i,i,i,i,i,i,C.bZ),C.Ek,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cV)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c4p(x)+" / "+B.c4p(v),i,i,i,i,I.ok,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aJ,i,i,i),A.bf(D.bt4,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.ep((Date.now()-j.ax)/1000)
return new A.H(C.pI,A.I(A.a([C.vj,C.a0,D.blk,A.d(t<8?"\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643":"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bs(t)+" \u062b)",i,i,i,i,F.aJ,i,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.uw
r=j.r
f=r==null
w=!f
q=w&&r.gt3()
u=A.b7(s?D.xF:I.GN,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.eA(i,i,D.b6t,i,i)
u=A.R(new A.ze(C.a3o,!0,new B.bSG(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.X6(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.Ik[n]
p.push(new A.eg(m,i,A.d("\xd7"+E.bs(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.K,A.ou(new B.bSH(j),p,A.d5([h.b.b],o),!1,A.ka(i,i,i,new A.bq(new B.bSI(),l),i,i,i,i,new A.bq(new B.bSJ(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cO),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gaYv():i
u=A.b7(f?D.qh:C.n3,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cB,i,i,i)
p=q?C.ib:C.v
h=A.a([o,C.u,A.fs(u,f,h,A.eA(p,q?C.i:C.af,D.tt,i,i))],k)
if(w&&j.gjo()<j.a.e)C.b.A(h,A.a([C.B,q?A.fs(D.asc,D.brQ,new B.bSK(j),A.eA(D.dr,C.af,D.tt,i,i)):A.bf(D.bil,i,i,new B.bSL(j),i,i)],k))
if(w){f=j.gjo()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.H(C.jg,A.d(j.ga00()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,D.a1m,C.a_,i,i),i))
return A.I(h,C.ag,C.d,C.e,0,C.l)}}}
B.CK.prototype={
t(d){var x=this,w=null,v=x.c,u=v.ae(0.12),t=A.v(14),s=A.aH(v.ae(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b7(x.d,v,w,w),C.K,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bK(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.U,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bL,A.d(x.f,w,w,w,w,C.AI,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.E(u,w,s,t,w,w,w,C.n),w,w,C.aQ,C.ad,w,w,w)}}
B.Ct.prototype={
P(){var x=y.S
return new B.a0Z($.LH(),A.C(x,y.B),A.aV(x),A.C(x,y.N),A.eb(null,y.H))}}
B.a0Z.prototype={
X(){this.Y()
this.d.ad(this.gog())},
xs(){if(this.c!=null)this.k(new B.bSo())},
m(){var x,w=this,v=w.d
v.V(w.gog())
x=w.y
if(x!=null)x.aD()
v.a.a2m()
w.a1()},
HI(d){return this.b1v(d)},
b1v(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$HI=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.k(new B.bSx(t,d))
r=t.y
if(r!=null)r.aD()
t.y=A.i0(C.eM,new B.bSy(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c5r(B.E5(G.LB(q,d,p.xD(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.df(0,0,0,350*B.E5(G.LB(p,d,o.xD(p,d)).b).length,0,0)
x=6
return A.c(r.a.a89(r.b.c,q,p,new B.bSz(t,d),new B.bSA(t)),$async$HI)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a9(m)
if(r instanceof B.lp){s=r
r=t.y
if(r!=null)r.aD()
if(t.c!=null)t.k(new B.bSB(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$HI,w)},
Fd(d,e){return this.aJH(d,e)},
aJH(d,e){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$Fd=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aD()
s.k(new B.bSs(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a8c()
if(e&&n!=null)s.HI(n)
q=null
u=4
x=7
return A.c(r,$async$Fd)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a9(l)
if(o instanceof B.lp){p=o
s.k(new B.bSt(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.as=s.as.bB(new B.bSu(s,o,d),y.H)}case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Fd,w)},
gaUd(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aG(x)&&!v.n(0,x)&&!u.aG(x)&&x!==t.e)return x
return null},
aZk(){this.k(new B.bSv(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jG,o=s.e,n=s.gaUd(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("cd<2>")
x=new A.am(new A.cd(m,l),new B.bSC(),l.i("am<Y.E>")).gM(0)
l=G.k6(s.a.c)
m=y.p
q=A.a([new B.Gu(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bs(s.a.d)+" \u0644\u062d\u062f "+E.bs(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aJ,r,r,r),C.u],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b36(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.AB,r,r,r))
k=o==null
if(!k){j=E.bs(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aJ(new A.b3(v,0,!1).dN(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c4p(v),r,r,r,r,I.ok,C.a_,r,r)
j=A.f5(A.v(6),A.pG(C.eJ,D.eI,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b7(u?R.GG:D.xF,r,r,r)
C.b.A(q,A.a([v,C.I,j,C.u,A.fs(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cB,r,r,r),new B.bSD(s,o),A.eA(C.v,C.af,D.tt,r,r))],m))}else if(n!=null){j=p?new B.bSE(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bs(n)
q.push(A.fs(D.aq8,A.d(v,r,r,r,r,C.cB,r,r,r),j,A.eA(C.v,C.af,D.tt,r,r)))}if(s.r.a!==0&&k)q.push(D.aTl)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?D.dr:D.dT
v=k?C.mV:C.n3
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bs(x)
u=s.a
u=k+" \u0645\u0646 "+E.bs(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.CK(j,v,k,u,r),A.dr(D.as_,D.bst,s.gaZj(),r)],m))}q.push(C.u)
q.push(D.Bp)
return K.x1(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b36(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.apv
else if(l.r.n(0,d))x=M.tu
else if(i!=null)x=D.apM
else if(j!=null){w=j.gt3()?C.bU:D.am4
x=A.b7(w,j.gt3()?D.dr:D.dT,k,k)}else x=D.ao8
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bs(d),k,k,k,k,D.bdy,k,k,k),C.by,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.bcO,k,k,k))
if(j!=null&&!j.gt3()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gLV()
o=J.ba(p)
n=o.h(p,r)
A:{if(D.iQ===n){m=D.dr
break A}if(D.ug===n){m=D.dT
break A}if(D.uh===n){m=D.eI
break A}m=C.fd
break A}m=D.k4.b8n(m,o.h(p,r)===D.ui?C.k1:k,22)
C.b.A(t,A.a([new A.eX(q.a,k,k,C.bx,k,k,k,k,k,k,m),O.As],u))}w=A.a([C.aj,A.Iu(A.ek(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.a_,C.bg)],w)
if(C.c.O(j.c).length===0)w.push(D.bo3)
C.b.A(v,w)}return new E.dA(A.I(v,C.ag,C.d,C.e,0,C.l),C.bH,C.da,k,!1,k)}}
B.Cs.prototype={
P(){return new B.a0Y($.LH())}}
B.a0Y.prototype={
X(){this.Y()
var x=this.d
x.ad(this.gog())
x.vj()},
xs(){if(this.c!=null)this.k(new B.bSf())},
m(){this.d.V(this.gog())
this.a1()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gax4(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kN(o,0,new B.bSm(q))
v=C.b.kN(o,0,new B.bSn())
o=y.p
o=A.a([A.A(A.a([A.R(s.WZ(E.bs(q.gart()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.K,A.R(s.WZ(E.bs(q.ao3()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.K,A.R(s.WZ(E.bs(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.u,new E.dA(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bs(C.f.aw(w*100/v))+"\u066a",r,r,r,r,C.bz,r,r,r),C.I,A.f5(A.v(6),A.pG(C.eJ,D.dr,8,w/v,r),C.aC),C.aj,A.d(E.bs(w)+" \u0645\u0646 "+E.bs(v)+" \u0622\u064a\u0629",r,r,r,r,F.aJ,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a4,C.aQ,r,!1,r)],o)
if(p.length===0)o.push(D.aTy)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.K)(p),++t)o.push(s.b38(p[t]))
o.push(C.B)
u=$.B().b
u===$&&A.b()
u=u.ga3().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aJ,r,r,r))
return K.x1(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
WZ(d,e){var x=null
return new E.dA(A.I(A.a([A.d(d,x,x,x,x,D.bdg,x,x,x),A.d(e,x,x,x,x,C.a1q,C.a_,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a4,C.M,x,!1,x)},
b38(d){var x=null,w=this.d.c,v=H.cJ[d-1].a[1],u=w.a59(d),t=w.bdu(d),s=y.p,r=A.A(A.a([A.R(A.d(G.k6(d),x,x,x,x,C.bz,x,x,x),1),A.d(E.bs(C.f.aw(u*100/v))+"\u066a",x,x,x,x,D.beo,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.f5(A.v(6),A.pG(C.eJ,D.dr,7,u/v,x),C.aC),p=E.bs(u),o=E.bs(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bs(t):""
return new E.dA(A.I(A.a([r,C.I,q,C.aj,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aJ,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a4,C.aQ,new B.bSl(this,d),!1,x)},
Nh(d){return this.aHT(d)},
aHT(d){var x=0,w=A.k(y.H),v=this,u,t
var $async$Nh=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=H.cJ[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.ed(C.cS,new B.bSk(v,d,u),t,!0,null,null,!1,y.H),$async$Nh)
case 2:return A.i(null,w)}})
return A.j($async$Nh,w)}}
B.aht.prototype={
QE(d,e){var x=null,w=A.qp(x,x,x,x,x,x,x,x,x,x,x,D.b60,C.M,x,x,x,x,C.nK,x,x)
return A.bf(A.d(d,x,x,x,x,C.lF,x,x,x),x,x,new B.b2Q(e),x,w)},
t(d){var x=this,w=y.p
return new E.dA(A.I(A.a([D.brC,C.I,D.bt3,A.d1(C.aB,A.a([x.QE("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.QE("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aG,0,12),D.bhz,x.QE("tanzil.net","https://tanzil.net"),D.buD,x.QE("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a4,C.aQ,null,!1,null)}}
var z=a.updateTypes(["~()","aj<~>()","P(ng)","aj<IP>()","aj<IN>()","aj<IO>()","a7<ng>()","P(r2)","bD(om)","Cu(t)","Cs(t)","P(mG)","Ct(t)","P(Hn)"])
B.b2R.prototype={
$0(){var x=0,w=A.k(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.a0(A.cU(b.G.document).baseURI)
q=A.bl(r,0,null).a2("quran_tutor/tutor.js?v=2").j(0)
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
m=B.ctW("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:363}
B.b2U.prototype={
$1(d){var x=null
return A.bVL(A.db(d,"persist",x,x,x,x))},
$S:1091}
B.b2T.prototype={
$0(){var x=0,w=A.k(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.qM(),$async$$0)
case 4:x=3
return A.c(n.eF(m.cU(l.db(e,"loadModel",A.bWt(new B.b2S(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.u(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.u(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.qL(p,"ms")
r=q.o4(p,"cached")
A.u(p.backend)
v=new B.IN(o,t,s,r,q.qL(p,"threads"),q.o4(p,"isolated"),q.qL(p,"warmMs"))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+4}
B.b2S.prototype={
$2(d,e){this.a.$2(C.f.aw(d),C.f.aw(e))},
$S:1092}
B.b2Y.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t,s
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.qM(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aJ(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aJ(v.d.a,1000)
u.onLevel=A.fN(new B.b2W(v.e))
u.onAutoStop=A.fN(new B.b2X(v.f))
x=5
return A.c(A.eF(A.cU(A.db(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.b2W.prototype={
$1(d){return this.a.$1(d)},
$S:56}
B.b2X.prototype={
$1(d){return this.a.$1(d)},
$S:6}
B.b2Z.prototype={
$0(){var x=0,w=A.k(y.D),v,u=this,t,s,r,q,p,o
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.a
s=t.a
q=A
p=A
o=A
x=s==null?4:6
break
case 4:x=7
return A.c(t.qM(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eF(p.cU(o.db(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.IO(r,A.dI(r.seconds))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+5}
B.b30.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.qM(),$async$$0)
case 4:x=3
return A.c(q.eF(p.cU(o.db(e,"transcribe",t.audio,t.rate,s.agN(u.c),null)),y.m),$async$$0)
case 3:v=r.akh(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b3_.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.qM(),$async$$0)
case 4:x=3
return A.c(r.eF(q.cU(p.db(e,"transcribeUrl",u.b,t.agN(u.c),null,null)),y.m),$async$$0)
case 3:v=s.akh(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b2V.prototype={
$1(d){return d},
$S:33}
B.aU7.prototype={
$0(){var x,w,v,u,t=this.a,s=A.ck(t.a.length,D.ui,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aU6.prototype={
$1(d){return d===D.iQ},
$S:z+2}
B.bWc.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c0w(e[x],d[x])<0.75)return!1
return!0},
$S:1093}
B.bYb.prototype={
$1(d){return d.length!==0},
$S:11}
B.b34.prototype={
$1(d){return d.a===D.f9},
$S:z+7}
B.b35.prototype={
$1(d){return C.j.aJ(d,1000)},
$S:70}
B.b32.prototype={
$1(d){return C.f.c2(d)},
$S:1094}
B.b36.prototype={
$0(){var x=0,w=A.k(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.f(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.jB("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.au.h_(r,null))
j=A.aL(k.h(0,"n"))
j=j==null?null:C.f.c2(j)
j=C.j.cU(j==null?2:j,1,5)
i=C.b.n(D.Ik,k.h(0,"r"))?A.ex(k.h(0,"r")):1
h=A.em(k.h(0,"auto"))
g=A.em(k.h(0,"hide"))
k=A.em(k.h(0,"in"))
s.a.b=new B.Ui(j,i,h!==!1,g===!0,k===!0)}u=2
x=6
break
case 4:u=3
e=t.pop()
x=6
break
case 3:x=2
break
case 6:u=9
x=12
return A.c(A.jB("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.c3F(y.P.a(C.au.h_(q,null)))
u=2
x=11
break
case 9:u=8
d=t.pop()
x=11
break
case 8:x=2
break
case 11:u=14
x=17
return A.c(A.jB("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.au.h_(p,null))
n=C.f.c2(A.d2(J.aG(o,"s")))
m=C.f.c2(A.d2(J.aG(o,"f")))
l=C.f.c2(A.d2(J.aG(o,"t")))
if(B.chp(n,m)&&B.chp(n,l)&&m<=l)s.a.z=new A.aO(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a7Z()){k.a.aoS()
x=1
break}a1=k
x=18
return A.c(k.a.Md(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a6()
if(k.b.e)k.CL()
k.wk()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:119}
B.b37.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a6()},
$S:1095}
B.b38.prototype={
$2(d,e){return C.j.aJ(A.eO(A.n(d),null,null),1000)===this.a},
$S:1096}
B.bFJ.prototype={
$1(d){var x=0,w=A.k(y.a),v=this,u,t
var $async$$1=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.E2(),$async$$1)
case 2:t=f
if(u.c!=null)u.k(new B.bFI(u,t))
return A.i(null,w)}})
return A.j($async$$1,w)},
$S:1097}
B.bFI.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bFK.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bFH(x,d))},
$S:z+8}
B.bFH.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bFL.prototype={
$1(d){},
$S:23}
B.bFv.prototype={
$0(){},
$S:0}
B.bFB.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.Cu(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bFC.prototype={
$0(){},
$S:0}
B.bFF.prototype={
$0(){var x=y.z
return A.M(this.a,!1).az(A.ay(new B.bFE(),null,x),x)},
$S:0}
B.bFE.prototype={
$1(d){return D.bvZ},
$S:z+10}
B.bFG.prototype={
$0(){return B.che(this.a)},
$S:0}
B.bFy.prototype={
$0(){var x=this.b
return this.a.xt(x.a,x.b,x.c)},
$S:0}
B.bFz.prototype={
$1(d){return this.a.k(new B.bFx())},
$S:6}
B.bFx.prototype={
$0(){},
$S:0}
B.bFA.prototype={
$0(){var x=this.a
return x.k(new B.bFw(x))},
$S:0}
B.bFw.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bFD.prototype={
$0(){return this.a.b35(this.b)},
$S:0}
B.c_r.prototype={
$1(d){return new A.ju(new B.c_o(this.a,this.b,this.c),null)},
$S:55}
B.c_o.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c_q(u,e),s=this.a,r=new B.c_p(s,e),q=A.d(G.k6(this.c),v,v,v,v,C.og,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bs(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aJ,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bs(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bs(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.cU(w+4,1,u)))}u=A.a([q,C.aj,p,C.u,A.d1(C.aB,n,C.aG,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c_j(s)),C.a_v,t.$3("\u0644\u062d\u062f",s.c,new B.c_k(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aTq)
u.push(C.a1)
u.push(A.dG(D.bkN,new B.c_l(s,d),A.eA(C.v,C.af,D.b6q,v,v)))
return A.cu(!0,new A.H(C.EM,A.I(u,C.ag,C.d,C.O,0,C.l),v),C.M,!0)},
$S:252}
B.c_q.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.hX,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.cg(v,A.d("\u0622\u064a\u0629 "+E.bs(v),u,u,u,u,u,u,u,u),C.aw,u,w))
return A.R(A.I(A.a([t,Q.Fc(C.cS,!0,s,320,new B.c_n(this.b,f),D.beG,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1099}
B.c_n.prototype={
$1(d){return d==null?null:this.a.$1(new B.c_m(this.b,d))},
$S:48}
B.c_m.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c_p.prototype={
$3(d,e,f){var x=null
return A.c16(x,A.d(d,x,x,x,x,x,x,x,x),new B.c_i(this.a,this.b,e,f))},
$S:1100}
B.c_i.prototype={
$0(){var x=this
return x.b.$1(new B.c_h(x.a,x.c,x.d))},
$S:0}
B.c_h.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c_j.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c_k.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c_l.prototype={
$0(){var x=this.a
return A.M(this.b,!1).aj(new A.a_(x.b,x.c))},
$S:0}
B.bSF.prototype={
$0(){},
$S:0}
B.bSV.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.lZ
x.w=x.r=null
x.x=!1
x.ay=x.at=x.as=null},
$S:0}
B.bSZ.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.iX:D.lZ},
$S:0}
B.bT_.prototype={
$0(){var x=this.a
x.f=D.uw
x.as=null},
$S:0}
B.bT0.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bT2.prototype={
$0(){var x=this.a
x.f=D.ux
x.as=null
x.y=0
x.z=new A.b3(Date.now(),0,!1)
x.at=null},
$S:0}
B.bT3.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bT1())},
$S:31}
B.bT1.prototype={
$0(){},
$S:0}
B.bT5.prototype={
$1(d){return this.a.y=d},
$S:56}
B.bT4.prototype={
$1(d){return this.a.Bj()},
$S:6}
B.bT6.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.iX:D.lZ
x.as=this.b.gil()},
$S:0}
B.bT8.prototype={
$0(){var x=this.a
x.f=D.oH
x.ax=Date.now()},
$S:0}
B.bT9.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bT7())},
$S:31}
B.bT7.prototype={
$0(){},
$S:0}
B.bSU.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.iX:D.lZ
x.as=this.b},
$S:0}
B.bSW.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.iX
x.x=!1},
$S:0}
B.bSN.prototype={
$0(){var x=this.a
x.f=D.oH
x.ax=Date.now()
x.as=null},
$S:0}
B.bSO.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bSM())},
$S:31}
B.bSM.prototype={
$0(){},
$S:0}
B.bSP.prototype={
$1(d){return d.d!==D.iQ},
$S:z+11}
B.bSQ.prototype={
$0(){return this.a.at=this.b},
$S:0}
B.bTe.prototype={
$0(){return B.che(this.a)},
$S:0}
B.bTf.prototype={
$1(d){var x=this.a.d
return x.ql(x.b.anz(d))},
$S:3}
B.bTg.prototype={
$0(){var x=y.z
return A.M(this.b,!1).az(A.ay(new B.bTd(this.a),null,x),x)},
$S:0}
B.bTd.prototype={
$1(d){var x=this.a.a
return new B.Ct(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bST.prototype={
$2(d,e){return C.b_},
$S:20}
B.bSS.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a5i(s.c,r).a.a){case 2:s=D.dr
break
case 1:s=D.dT
break
case 0:s=C.ib
break
default:s=u}x=A.v(18)
w=t.f===D.oH?u:new B.bSR(t,r)
v=s.ae(0.25)
if(r===t.gjo())s=C.i
s=A.aH(s,r===t.gjo()?2:1)
return A.bA(!1,x,!0,A.D(C.P,A.d(E.bs(r),u,u,u,u,C.a0D,u,u,u),C.k,u,u,new A.E(v,u,s,u,u,u,u,C.bZ),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:64}
B.bSR.prototype={
$0(){return this.a.Z7(this.b)},
$S:0}
B.bSY.prototype={
$0(){var x=this.a
return x.k(new B.bSX(x))},
$S:0}
B.bSX.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bTa.prototype={
$1(d){return d===D.ug},
$S:z+2}
B.bTb.prototype={
$1(d){return d===D.uh},
$S:z+2}
B.bTc.prototype={
$1(d){return d===D.ui},
$S:z+2}
B.bSG.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.QF(x)},
$S:0}
B.bSH.prototype={
$1(d){var x=this.a.d
return x.ql(x.b.b7P(d.ga4(d)))},
$S:114}
B.bSJ.prototype={
$1(d){return d.n(0,C.a2)?C.af:C.i},
$S:4}
B.bSI.prototype={
$1(d){return d.n(0,C.a2)?C.v:C.a8},
$S:4}
B.bSK.prototype={
$0(){var x=this.a
return x.Z7(x.gjo()+1)},
$S:0}
B.bSL.prototype={
$0(){var x=this.a
return x.Z7(x.gjo()+1)},
$S:0}
B.bSo.prototype={
$0(){},
$S:0}
B.bSx.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.b3(Date.now(),0,!1)},
$S:0}
B.bSy.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bSw())},
$S:31}
B.bSw.prototype={
$0(){},
$S:0}
B.bSA.prototype={
$1(d){return this.a.x=d},
$S:56}
B.bSz.prototype={
$1(d){return this.a.Fd(this.b,!1)},
$S:6}
B.bSB.prototype={
$0(){var x=this.a
x.e=null
x.Q=this.b.gil()},
$S:0}
B.bSs.prototype={
$0(){var x=this.a
x.e=null
x.r.F(0,this.b)},
$S:0}
B.bSt.prototype={
$0(){var x=this.a,w=this.b
x.r.K(0,w)
x.w.q(0,w,this.c.gil())},
$S:0}
B.bSu.prototype={
$1(d){var x=0,w=A.k(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k,j,i,h
var $async$$1=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:v=3
o=s.a
n=o.d
m=s.c
l=o.a
k=l.f
l=l.c
x=6
return A.c(n.a.atq(s.b,B.E5(G.LB(l,m,k.xD(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cfx(G.LB(l,m,k.xD(l,m)).b,r.a)
if(C.c.O(q.c).length!==0){l=n.c
k=o.a.c
j=q.gt3()
l.asu(k,m,n.b.a,j)}n.zl()
if(o.c!=null)o.k(new B.bSp(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a9(h)
if(o instanceof B.lp){p=o
o=s.a
if(o.c!=null)o.k(new B.bSq(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.k(new B.bSr(o,s.c))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$1,w)},
$S:126}
B.bSp.prototype={
$0(){var x=this.c
this.a.f.q(0,this.b,x)
return x},
$S:0}
B.bSq.prototype={
$0(){var x=this.c.gil()
this.a.w.q(0,this.b,x)
return x},
$S:0}
B.bSr.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bSv.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)},
$S:0}
B.bSC.prototype={
$1(d){return d.gt3()},
$S:z+13}
B.bSD.prototype={
$0(){return this.a.Fd(this.b,!0)},
$S:0}
B.bSE.prototype={
$0(){return this.a.HI(this.b)},
$S:0}
B.bSf.prototype={
$0(){},
$S:0}
B.bSm.prototype={
$2(d,e){return d+this.a.a59(e)},
$S:113}
B.bSn.prototype={
$2(d,e){return d+H.cJ[e-1].a[1]},
$S:113}
B.bSl.prototype={
$0(){return this.a.Nh(this.b)},
$S:0}
B.bSk.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(G.k6(p),q,q,q,q,C.og,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.b8(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.qR():r).a.a){case 2:r=D.dr.ae(0.35)
break
case 1:r=D.dT.ae(0.35)
break
case 0:r=C.fO
break
default:r=q}m.push(A.D(C.P,A.d(E.bs(t),q,q,q,q,C.lA,q,q,q),C.k,q,q,new A.E(r,q,q,new A.cv(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cu(!0,new A.H(C.fV,A.I(A.a([o,C.aj,D.boY,C.u,new A.dx(D.a5R,A.f8(A.d1(C.aB,m,C.aG,6,6),q,C.r,q,q,q,C.w),q),C.a0,A.bf(D.bqE,q,q,new B.bSj(w,d,p),q,q)],n),C.ag,C.d,C.O,0,C.l),q),C.M,!0)},
$S:36}
B.bSj.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dm(null,null,!0,null,new B.bSi(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Ky(t),$async$$0)
case 5:if(u.e!=null)A.M(u,!1).e2()
case 3:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.bSi.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+G.k6(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dt(A.a([A.bf(C.el,x,x,new B.bSg(d),x,x),A.bf(C.ou,x,x,new B.bSh(d),x,x)],y.p),w,D.bsb)},
$S:14}
B.bSg.prototype={
$0(){A.M(this.a,!1).aj(!1)
return null},
$S:0}
B.bSh.prototype={
$0(){A.M(this.a,!1).aj(!0)
return null},
$S:0}
B.c0c.prototype={
$1(d){var x=this.a
return new A.la(new B.c0b(x),null,x,null)},
$S:1101}
B.c0b.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.eg(w,t,A.d(E.bs(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bhu,C.a0,D.br4,C.I,A.ou(new B.c06(s,r),q,A.d5([r.a],x),!1,A.ka(t,t,t,new A.bq(new B.c07(),v),t,t,t,t,new A.bq(new B.c08(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.ie(C.v,C.M,t,new B.c09(s,r),D.boe,D.bu6,r.c),A.ie(C.v,C.M,t,new B.c0a(s,r),t,D.bh3,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.aj,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gmJ(),t,t,t,t,F.aJ,t,C.bg,t)],u))
x.push(C.B)
x.push(D.a2y)
return A.cu(!0,A.f8(A.I(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.fV,t,t,C.w),C.M,!0)},
$S:1102}
B.c06.prototype={
$1(d){return this.a.ql(this.b.b7M(d.ga4(d)))},
$S:114}
B.c08.prototype={
$1(d){return d.n(0,C.a2)?C.af:C.i},
$S:4}
B.c07.prototype={
$1(d){return d.n(0,C.a2)?C.v:C.a8},
$S:4}
B.c09.prototype={
$1(d){return this.a.ql(this.b.b78(d))},
$S:3}
B.c0a.prototype={
$1(d){return this.a.ql(this.b.anz(d))},
$S:3}
B.b2Q.prototype={
$0(){return A.cz(A.bl(this.a,0,null),C.aT,null)},
$S:0};(function installTearOffs(){var x=a._instance_0u
x(B.ahu.prototype,"gbdv","bdw",0)
var w
x(w=B.Uj.prototype,"gbdM","CL",1)
x(w,"gaC1","wk",1)
x(w=B.ZC.prototype,"gog","xs",0)
x(w,"gaVY","Pb",1)
x(w=B.a1_.prototype,"gog","xs",0)
x(w,"gaYv","Px",1)
x(w,"gb37","Bj",1)
x(w,"gaHy","Ne",1)
x(w=B.a0Z.prototype,"gog","xs",0)
x(w,"gaZj","aZk",0)
x(B.a0Y.prototype,"gog","xs",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a5,[B.ahu,B.Uk,B.IN,B.IP,B.IO,B.lp,B.Rp,B.mG,B.Hn,B.r2,B.ahv,B.Ui])
x(A.kV,[B.b2R,B.b2T,B.b2Y,B.b2Z,B.b30,B.b3_,B.aU7,B.b36,B.bFI,B.bFH,B.bFv,B.bFC,B.bFF,B.bFG,B.bFy,B.bFx,B.bFA,B.bFw,B.bFD,B.c_m,B.c_i,B.c_h,B.c_l,B.bSF,B.bSV,B.bSZ,B.bT_,B.bT0,B.bT2,B.bT1,B.bT6,B.bT8,B.bT7,B.bSU,B.bSW,B.bSN,B.bSM,B.bSQ,B.bTe,B.bTg,B.bSR,B.bSY,B.bSX,B.bSG,B.bSK,B.bSL,B.bSo,B.bSx,B.bSw,B.bSB,B.bSs,B.bSt,B.bSp,B.bSq,B.bSr,B.bSv,B.bSD,B.bSE,B.bSf,B.bSl,B.bSj,B.bSg,B.bSh,B.b2Q])
x(A.ir,[B.b2U,B.b2W,B.b2X,B.b2V,B.aU6,B.bYb,B.b34,B.b35,B.b32,B.bFJ,B.bFK,B.bFL,B.bFB,B.bFE,B.bFz,B.c_r,B.c_q,B.c_n,B.c_p,B.c_j,B.c_k,B.bT3,B.bT5,B.bT4,B.bT9,B.bSO,B.bSP,B.bTf,B.bTd,B.bTa,B.bTb,B.bTc,B.bSH,B.bSJ,B.bSI,B.bSy,B.bSA,B.bSz,B.bSu,B.bSC,B.bSk,B.bSi,B.c0c,B.c06,B.c08,B.c07,B.c09,B.c0a])
x(A.pg,[B.b2S,B.bWc,B.b37,B.b38,B.c_o,B.bST,B.bSS,B.bSm,B.bSn,B.c0b])
x(A.JF,[B.ng,B.En,B.Gt,B.Dp])
w(B.Uj,A.i6)
x(A.L,[B.wk,B.Cu,B.Ct,B.Cs])
x(A.N,[B.ZC,B.a1_,B.a0Z,B.a0Y])
x(A.a4,[B.Gu,B.Wx,B.CK,B.aht])})()
A.oX(b.typeUniverse,JSON.parse('{"lp":{"bN":[]},"Cu":{"L":[],"l":[]},"Ct":{"L":[],"l":[]},"Cs":{"L":[],"l":[]},"Uj":{"aB":[]},"wk":{"L":[],"l":[]},"ZC":{"N":["wk"]},"Gu":{"a4":[],"l":[]},"Wx":{"a4":[],"l":[]},"a1_":{"N":["Cu"]},"CK":{"a4":[],"l":[]},"a0Z":{"N":["Ct"]},"a0Y":{"N":["Cs"]},"aht":{"a4":[],"l":[]}}'))
var y=(function rtii(){var x=A.ai
return{u:x("r2"),c:x("eg<x>"),r:x("cg<x>"),k:x("F<mG>"),n:x("F<eg<x>>"),I:x("F<cg<x>>"),R:x("F<hA>"),Y:x("F<aS<o,@>>"),d:x("F<Rp>"),s:x("F<o>"),p:x("F<l>"),t:x("F<x>"),m:x("bM"),j:x("a7<@>"),L:x("a7<x>"),P:x("aS<o,@>"),f:x("aS<@,@>"),x:x("au<o,x>"),a:x("bD"),K:x("a5"),B:x("Hn"),l:x("+(x,x)"),e:x("d7<mG>"),N:x("o"),C:x("IN"),D:x("IO"),X:x("Uk"),_:x("IP"),U:x("am<o>"),G:x("ng"),q:x("qI"),b:x("bq<U?>"),y:x("P"),i:x("a2"),z:x("@"),S:x("x"),A:x("bM?"),O:x("a5?"),M:x("+quota,usage(x,x)?"),o:x("fm"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.oQ=new B.En(0,"none")
D.oR=new B.En(1,"learning")
D.f9=new B.En(2,"memorized")
D.a5R=new A.az(0,1/0,0,320)
D.eI=new A.U(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a5Z=new A.E(D.eI,null,null,null,null,null,null,C.bZ)
D.dT=new A.U(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.dr=new A.U(1,0.20392156862745098,0.8274509803921568,0.6,C.p)
D.aqG=new A.G(C.GL,null,C.cD,null,null,null)
D.bsj=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.f1,null,null,null,null,null,null,null,null)
D.ba3=new A.r(!0,C.fd,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bp_=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.ba3,null,null,null,null,null,null,null,null)
D.aHp=x([D.aqG,C.I,D.bsj,D.bp_],y.p)
D.ae0=new A.fb(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aHp,null)
D.ahr=new A.X(0,26,0,26)
D.ahS=new A.X(14,12,14,14)
D.aiy=new A.X(3,0,0,0)
D.am4=new A.Q(63251,"MaterialIcons",null,!1)
D.qh=new A.Q(63677,"MaterialIcons",null,!1)
D.xF=new A.Q(983516,"MaterialIcons",null,!1)
D.amT=new A.Q(983209,"MaterialIcons",null,!1)
D.anw=new A.G(D.amT,28,C.v,null,null,null)
D.ao8=new A.G(C.Gp,null,C.ib,null,null,null)
D.alO=new A.Q(62961,"MaterialIcons",null,!1)
D.aoP=new A.G(D.alO,null,null,null,null,null)
D.am3=new A.Q(63199,"MaterialIcons",null,!1)
D.aoQ=new A.G(D.am3,null,null,null,null,null)
D.aoZ=new A.G(C.kO,null,C.fd,null,null,null)
D.ap1=new A.G(D.xF,44,C.i,null,null,null)
D.apv=new A.G(D.qh,null,D.eI,null,null,null)
D.apM=new A.G(C.mW,null,D.eI,null,null,null)
D.aq8=new A.G(D.qh,null,null,null,null,null)
D.aqC=new A.G(C.jo,20,D.dT,null,null,null)
D.aqY=new A.G(C.n1,30,C.v,null,null,null)
D.amo=new A.Q(63520,"MaterialIcons",null,!1)
D.arP=new A.G(D.amo,null,null,null,null,null)
D.as_=new A.G(C.n3,null,null,null,null,null)
D.alF=new A.Q(62842,"MaterialIcons",null,!0)
D.asc=new A.G(D.alF,null,null,null,null,null)
D.Ik=x([1,3,5],y.t)
D.J6=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aU_=new A.H(C.mM,C.mc,null)
D.aEh=x([D.aU_],y.p)
D.aYq=new A.a_(C.mY,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.aYe=new A.a_(D.qh,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.aYL=new A.a_(C.du,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.amC=new A.Q(63625,"MaterialIcons",null,!1)
D.aYX=new A.a_(D.amC,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aGm=x([D.aYq,D.aYe,D.aYL,D.aYX],A.ai("F<+(Q,o)>"))
D.aIJ=x([D.oQ,D.oR,D.f9],A.ai("F<En>"))
D.NK=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aQ5=new B.Gt(0,"idle")
D.TV=new B.Gt(1,"loading")
D.jG=new B.Gt(2,"ready")
D.aQ6=new B.Gt(3,"failed")
D.apt=new A.G(C.bU,18,D.dr,null,null,null)
D.a1m=new A.r(!0,C.aq,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.btg=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,D.a1m,null,null,null,null,null,null,null,null)
D.aD9=x([D.apt,C.b_,D.btg],y.p)
D.b3T=new A.er(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aD9,null)
D.aSX=new A.H(C.aQ,D.b3T,null)
D.aiw=new A.X(2,6,2,4)
D.b9K=new A.r(!0,C.v,null,null,null,null,14,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhs=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.b9K,null,null,null,null,null,null,null,null)
D.aTb=new A.H(D.aiw,D.bhs,null)
D.btF=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.f1,null,null,null,null,null,null,null,null)
D.aEB=x([M.tu,C.K,D.btF],y.p)
D.b3O=new A.er(C.ae,C.cm,C.e,C.h,null,C.l,null,0,D.aEB,null)
D.aTl=new A.H(C.pF,D.b3O,null)
D.AP=new A.r(!0,D.dT,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.btZ=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.AP,null,null,null,null,null,null,null,null)
D.aTq=new A.H(C.dU,D.btZ,null)
D.btb=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aJ,C.a_,null,null,null,null,null,null,null)
D.aTy=new A.H(C.C,D.btb,null)
D.ait=new A.X(2,0,2,8)
D.bpf=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aJ,null,null,null,null,null,null,null,null)
D.aTR=new A.H(D.ait,D.bpf,null)
D.ary=new A.G(C.kQ,30,C.v,null,null,null)
D.buE=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.AQ,null,null,null,null,null,null,null,null)
D.ajD=new A.bS(1,C.ac,D.buE,null)
D.aEQ=x([D.ary,C.X,D.ajD],y.p)
D.b3B=new A.er(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aEQ,null)
D.ar9=new A.G(C.du,18,D.dr,null,null,null)
D.a0N=new A.r(!0,D.dr,null,null,null,null,12,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bsU=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a0N,null,null,null,null,null,null,null,null)
D.aDA=x([D.ar9,C.bW,D.bsU],y.p)
D.b3M=new A.er(C.ae,C.d,C.O,C.h,null,C.l,null,0,D.aDA,null)
D.b60=new A.T(0,30)
D.tt=new A.T(1/0,54)
D.b6q=new A.T(1/0,48)
D.b6t=new A.T(1/0,50)
D.b6w=new A.T(1/0,52)
D.b9e=new A.r(!0,C.i,null,null,null,null,14.5,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b9u=new A.r(!0,C.i,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.AB=new A.r(!0,D.eI,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.k4=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bcO=new A.r(!0,D.eI,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bdg=new A.r(!0,C.v,null,null,null,null,24,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bdy=new A.r(!0,C.v,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.ben=new A.r(!0,D.dT,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beo=new A.r(!0,D.dr,null,null,null,null,null,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beG=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgk=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.hX,null,null,null,null,null,null,null,null)
D.bh3=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.dj,null,null,null,null,null,null,null,null)
D.bhu=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.og,null,null,null,null,null,null,null,null)
D.bhz=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aJ,null,null,null,null,null,null,null,null)
D.bhY=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aJ,null,null,null,null,null,null,null,null)
D.bil=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.f1,null,null,null,null,null,null,null,null)
D.bk3=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cB,null,null,null,null,null,null,null,null)
D.bkN=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bN,null,null,null,null,null,null,null,null)
D.bkS=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aJ,null,null,null,null,null,null,null,null)
D.blk=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.AU,null,null,null,null,null,null,null,null)
D.bmx=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bn7=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,I.ok,null,null,null,null,null,null,null,null)
D.bo3=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.AP,null,null,null,null,null,null,null,null)
D.boe=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aJ,null,null,null,null,null,null,null,null)
D.boF=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bz,null,null,null,null,null,null,null,null)
D.boY=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aJ,null,null,null,null,null,null,null,null)
D.bpg=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aJ,null,null,null,null,null,null,null,null)
D.bcu=new A.r(!0,D.eI,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bqE=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bcu,null,null,null,null,null,null,null,null)
D.br4=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,I.ok,null,null,null,null,null,null,null,null)
D.brC=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0e,null,null,null,null,null,null,null,null)
D.brQ=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cB,null,null,null,null,null,null,null,null)
D.bsb=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bst=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bt3=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aJ,null,null,null,null,null,null,null,null)
D.bt4=new A.m("\u062e\u0644\u0635\u062a",null,N.om,null,null,null,null,null,null,null,null)
D.bt5=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.AP,null,null,null,null,null,null,null,null)
D.bu2=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bz,null,null,null,null,null,null,null,null)
D.bu6=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.dj,null,null,null,null,null,null,null,null)
D.buD=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aJ,null,null,null,null,null,null,null,null)
D.a2y=new B.aht(null)
D.bvZ=new B.Cs(null)
D.bw_=new B.Ui(2,1,!0,!1,!1)
D.a2D=new B.Uk(!1,!1,!1,!1,!1,0)
D.iQ=new B.ng(0,"ok")
D.ug=new B.ng(1,"near")
D.uh=new B.ng(2,"wrong")
D.ui=new B.ng(3,"missing")
D.a33=new B.ng(4,"extra")
D.amj=new A.Q(63456,"MaterialIcons",null,!1)
D.bBn=new B.CK(D.dT,D.amj,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bC0=new B.Wx(!1,null)
D.Bp=new B.Wx(!0,null)
D.lZ=new B.Dp(0,"idle")
D.uw=new B.Dp(1,"playing")
D.ux=new B.Dp(2,"recording")
D.oH=new B.Dp(3,"thinking")
D.iX=new B.Dp(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cHo","ciN",()=>new B.ahu())
x($,"cKH","cl5",()=>A.aD("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cKI","cl6",()=>A.aD("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cKU","clf",()=>A.aD("\u0648\u0670",!0,!1,!1))
x($,"cKf","ckM",()=>A.aD("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cIA","cjC",()=>A.aD("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cJM","cko",()=>A.aD("[\u0654\u0655]",!0,!1,!1))
x($,"cIB","cjD",()=>A.aD("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cII","cjJ",()=>A.aD("[\u0624\u0626]",!0,!1,!1))
x($,"cJO","ckq",()=>A.aD("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cKk","ckP",()=>A.aD("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cJW","ckx",()=>A.aD("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cKF","c6B",()=>A.aD("\\s+",!0,!1,!1))
x($,"cEI","qR",()=>B.cm4(D.oQ,0,A.c1F(0,!0)))
x($,"cHp","LH",()=>new B.Uj($.ciN(),D.bw_,B.ctX(),D.aQ5,$.S()))})()};
(a=>{a["1bgWmKJgQ8ja9mwqZ1yswGqQ4vE="]=a.current})($__dart_deferred_initializers__);