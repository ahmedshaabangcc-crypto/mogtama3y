((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,N,K,O,L,G,I,B={
crj(d){var x,w,v,u,t,s
if(d instanceof B.lj)return d
try{x=A.d0(d)
w=x.code
v=x.message
u=w==null?"failed":A.a_(w)
t=v==null?"":A.a_(v)
return new B.lj(u,t)}catch(s){u=A.n(d)
return new B.lj("failed",u)}},
agZ:function agZ(){this.b=this.a=null},
b1Z:function b1Z(d){this.a=d},
b21:function b21(){},
b20:function b20(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b2_:function b2_(d){this.a=d},
b25:function b25(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b23:function b23(d){this.a=d},
b24:function b24(d){this.a=d},
b26:function b26(d){this.a=d},
b28:function b28(d,e,f){this.a=d
this.b=e
this.c=f},
b27:function b27(d,e,f){this.a=d
this.b=e
this.c=f},
b22:function b22(){},
crk(d,e){return new B.lj(d,e)},
TT:function TT(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
Iv:function Iv(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
Ix:function Ix(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
Iw:function Iw(d,e){this.a=d
this.b=e},
lj:function lj(d,e){this.a=d
this.b=e},
ce_(d){var x,w=$.ciy()
w=A.bS(d,w,"\u0627")
x=$.ciz()
w=A.bS(w,x,"\u064a")
x=$.ciI()
w=A.bS(w,x,"\u0627")
x=$.ch4()
w=A.bS(w,x,"\u0627")
x=$.cie()
w=A.bS(w,x,"\u0621")
x=$.chR()
w=A.bS(w,x,"\u0621")
x=$.ch5()
w=A.bS(w,x,"\u0627")
x=$.chb()
w=A.bS(w,x,"\u0621")
w=A.bS(w,"\u0649","\u064a")
w=A.bS(w,"\u0629","\u0647")
x=$.chT()
w=A.bS(w,x,"")
x=$.cih()
w=A.bS(w,x," ")
x=$.ci_()
w=A.bS(w,x," ")
x=$.c4h()
return C.c.O(A.bS(w,x," "))},
cw_(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kf(x,w)
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
bZn(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aJ("[\u0627\u0621]",!0,!1,!1)
w=A.bS(d,x,"")
x=A.aJ("[\u0627\u0621]",!0,!1,!1)
v=A.bS(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cw_(d,e)/u
return s>=1?0.99:s},
DU(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.w3(d,$.c4h()),w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.length===0)continue
t=B.ce_(u)
s=A.bS(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.QZ(r.a+" "+u,r.b))}continue}q.push(new B.QZ(u,s))}return q},
cuI(d,e){var x,w,v,u,t=new B.bUk(),s=A.a([],y.s)
for(x=A.fR(e,0,A.iF(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.cf(x,x.gM(0),w.i("cf<aZ.E>")),w=w.i("aZ.E");x.A();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.IH)&&t.$2(d,D.IH)?C.b.jO(d,5):d
return!t.$2(s,D.Nh)&&t.$2(u,D.Nh)?C.b.jO(u,4):u},
cd3(d,e){var x=B.DU(d),w=B.ce_(e),v=y.U
v=A.aa(new A.am(A.a(w.split(" "),y.s),new B.bWi(),v),v.i("X.E"))
return new B.H7(x,B.ctT(x,B.cuI(v,x)),w)},
ctT(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.K)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.ck(x,0,!1,s)
q=A.ck(x,0,!1,y.S)
p=A.ck(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.bZn(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.bZn(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.bZn(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.iN
else m=a2>=0.6?D.u6:D.u7
a1.push(new B.mz(o,x,s,m))
break
case 1:--o
a1.push(new B.mz(o,a4[o],null,D.u8))
break
case 2:--n
a1.push(new B.mz(null,null,a6[n],D.a2y))
break
case 3:--o
a3=n-2
a1.push(new B.mz(o,a4[o],a6[a3]+" "+a6[n-1],D.iN))
n=a3
break
default:x=o-1;--n
a1.push(new B.mz(x,a4[x],a6[n],D.iN))
o-=2
a1.push(new B.mz(o,a4[o],a6[n],D.iN))}}a4=y.e
a4=A.aa(new A.dc(a1,a4),a4.i("aZ.E"))
return a4},
na:function na(d,e){this.a=d
this.b=e},
QZ:function QZ(d,e){this.a=d
this.b=e},
mz:function mz(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
H7:function H7(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aTe:function aTe(d){this.a=d},
aTd:function aTd(){},
bUk:function bUk(){},
bWi:function bWi(){},
cjx(d,e,f){return new B.qR(d,e,f)},
cwT(d){var x
A:{if("memorized"===d){x=D.f6
break A}if("learning"===d){x=D.oH
break A}x=D.oG
break A}return x},
ceS(d,e){return d>=1&&d<=114&&e>=1&&e<=H.ds[d-1].a[1]},
crl(){var x=y.S
return new B.ah_(A.C(x,y.u),A.aV(x))},
b2b(d){var x=d.f8()
return C.c.dl(C.j.j(A.bm(x)),4,"0")+"-"+C.c.dl(C.j.j(A.bq(x)),2,"0")+"-"+C.c.dl(C.j.j(A.bQ(x)),2,"0")},
cab(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cye(),x),x.i("aZ.E"))
return B.b2b(A.dg(w[0],w[1],w[2]-1,12,0,0,0))},
c1r(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.C(p,y.u),n=A.aV(p),m=new B.ah_(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcM(),x=x.ga_(x),w=y.j;x.A();){v=x.gJ()
u=A.e7(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aT(t)>=3){v=C.j.aL(u,1000)
s=C.j.a0(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=H.ds[v-1].a[1])}if(v)continue
v=J.b7(t)
r=C.f.co(A.dj(v.h(t,0)))
if(r<0||r>=3)continue
o.q(0,u,new B.qR(D.aHO[r],C.f.co(A.dj(v.h(t,1))),new A.ba(A.lH(C.f.co(A.dj(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.axW(q,y.o)
p=A.m1(x,new B.b2a(),x.$ti.i("X.E"),p)
n.v(0,new A.am(p,o.ga2o(),A.y(p).i("am<X.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aP(d.h(0,"streak"))
p=p==null?null:C.f.co(p)
p=m.d=p==null?0:p
o=A.aP(d.h(0,"best"))
o=o==null?null:C.f.co(o)
m.e=o==null?p:o
return m},
axj(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dl(C.j.j(d),3,"0")+C.c.dl(C.j.j(e),3,"0")+".mp3"},
Eb:function Eb(d,e){this.a=d
this.b=e},
qR:function qR(d,e,f){this.a=d
this.b=e
this.c=f},
ah_:function ah_(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b2c:function b2c(){},
b2d:function b2d(){},
b2a:function b2a(){},
TR:function TR(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
coT(){return new B.w5(null)},
cAr(d,e){var x,w,v,u,t={},s=H.ds[e-1].a[1],r=$.Lj().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.qF():v).a===D.f6}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.dc(u+4,1,s)
return A.el(C.dl,new B.bYo(t,s,e),d,!0,null,null,!1,y.l)},
c3a(d){return A.dl(0,0,0,0,0,C.j.dc(C.f.aw(6+d*1.2),25,90))},
c2b(d){return E.bJ(C.j.aL(d,60))+":"+C.c.dl(E.bJ(C.j.a0(d,60)),2,"\u0660")},
ceH(d){return A.el(C.dl,new B.bZ4($.Lj()),d,!0,null,null,!1,y.H)},
Gd:function Gd(d,e){this.a=d
this.b=e},
TS:function TS(d,e,f,g,h){var _=this
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
b2e:function b2e(d){this.a=d},
b2f:function b2f(d){this.a=d},
b2g:function b2g(d){this.a=d},
w5:function w5(d){this.a=d},
Zb:function Zb(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bDZ:function bDZ(d){this.a=d},
bDY:function bDY(d,e){this.a=d
this.b=e},
bE_:function bE_(d){this.a=d},
bDX:function bDX(d,e){this.a=d
this.b=e},
bE0:function bE0(){},
bDL:function bDL(){},
bDR:function bDR(d,e,f){this.a=d
this.b=e
this.c=f},
bDS:function bDS(){},
bDV:function bDV(d){this.a=d},
bDU:function bDU(){},
bDW:function bDW(d){this.a=d},
bDO:function bDO(d,e){this.a=d
this.b=e},
bDP:function bDP(d){this.a=d},
bDN:function bDN(){},
bDQ:function bDQ(d){this.a=d},
bDM:function bDM(d){this.a=d},
bDT:function bDT(d,e){this.a=d
this.b=e},
Ge:function Ge(d,e,f){this.c=d
this.d=e
this.a=f},
W5:function W5(d,e){this.c=d
this.a=e},
bYo:function bYo(d,e,f){this.a=d
this.b=e
this.c=f},
bYl:function bYl(d,e,f){this.a=d
this.b=e
this.c=f},
bYn:function bYn(d,e){this.a=d
this.b=e},
bYk:function bYk(d,e){this.a=d
this.b=e},
bYj:function bYj(d,e){this.a=d
this.b=e},
bYm:function bYm(d,e){this.a=d
this.b=e},
bYf:function bYf(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
bYe:function bYe(d,e,f){this.a=d
this.b=e
this.c=f},
bYg:function bYg(d){this.a=d},
bYh:function bYh(d){this.a=d},
bYi:function bYi(d,e){this.a=d
this.b=e},
Dd:function Dd(d,e){this.a=d
this.b=e},
Ci:function Ci(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a0z:function a0z(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.at=_.as=_.Q=_.z=null
_.ax=0
_.c=_.a=_.ay=null},
bQO:function bQO(){},
bR3:function bR3(d,e){this.a=d
this.b=e},
bR7:function bR7(d){this.a=d},
bR8:function bR8(d){this.a=d},
bR9:function bR9(d,e,f){this.a=d
this.b=e
this.c=f},
bRb:function bRb(d){this.a=d},
bRc:function bRc(d){this.a=d},
bRa:function bRa(){},
bRe:function bRe(d){this.a=d},
bRd:function bRd(d){this.a=d},
bRf:function bRf(d,e){this.a=d
this.b=e},
bRh:function bRh(d){this.a=d},
bRi:function bRi(d){this.a=d},
bRg:function bRg(){},
bR2:function bR2(d,e){this.a=d
this.b=e},
bR4:function bR4(d,e,f){this.a=d
this.b=e
this.c=f},
bQW:function bQW(d){this.a=d},
bQX:function bQX(d){this.a=d},
bQV:function bQV(){},
bQY:function bQY(){},
bQZ:function bQZ(d,e){this.a=d
this.b=e},
bRn:function bRn(d){this.a=d},
bRo:function bRo(d){this.a=d},
bRp:function bRp(d,e){this.a=d
this.b=e},
bRm:function bRm(d){this.a=d},
bR1:function bR1(){},
bR0:function bR0(d){this.a=d},
bR_:function bR_(d,e){this.a=d
this.b=e},
bR6:function bR6(d){this.a=d},
bR5:function bR5(d){this.a=d},
bRj:function bRj(){},
bRk:function bRk(){},
bRl:function bRl(){},
bQP:function bQP(d,e,f){this.a=d
this.b=e
this.c=f},
bQQ:function bQQ(d){this.a=d},
bQS:function bQS(){},
bQR:function bQR(){},
bQT:function bQT(d){this.a=d},
bQU:function bQU(d){this.a=d},
Cy:function Cy(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
Ch:function Ch(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a0y:function a0y(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.Q=_.z=_.y=null
_.as=h
_.c=_.a=null},
bQx:function bQx(){},
bQG:function bQG(d,e){this.a=d
this.b=e},
bQH:function bQH(d){this.a=d},
bQF:function bQF(){},
bQJ:function bQJ(d){this.a=d},
bQI:function bQI(d,e){this.a=d
this.b=e},
bQK:function bQK(d,e){this.a=d
this.b=e},
bQB:function bQB(d,e){this.a=d
this.b=e},
bQC:function bQC(d,e,f){this.a=d
this.b=e
this.c=f},
bQD:function bQD(d,e,f){this.a=d
this.b=e
this.c=f},
bQy:function bQy(d,e,f){this.a=d
this.b=e
this.c=f},
bQz:function bQz(d,e,f){this.a=d
this.b=e
this.c=f},
bQA:function bQA(d,e){this.a=d
this.b=e},
bQE:function bQE(d){this.a=d},
bQL:function bQL(){},
bQM:function bQM(d,e){this.a=d
this.b=e},
bQN:function bQN(d,e){this.a=d
this.b=e},
Cg:function Cg(d){this.a=d},
a0x:function a0x(d){this.d=d
this.c=this.a=null},
bQo:function bQo(){},
bQv:function bQv(d){this.a=d},
bQw:function bQw(){},
bQu:function bQu(d,e){this.a=d
this.b=e},
bQt:function bQt(d,e,f){this.a=d
this.b=e
this.c=f},
bQs:function bQs(d,e,f){this.a=d
this.b=e
this.c=f},
bQr:function bQr(d){this.a=d},
bQp:function bQp(d){this.a=d},
bQq:function bQq(d){this.a=d},
bZ4:function bZ4(d){this.a=d},
bZ3:function bZ3(d){this.a=d},
bYZ:function bYZ(d,e){this.a=d
this.b=e},
bZ0:function bZ0(){},
bZ_:function bZ_(){},
bZ1:function bZ1(d,e){this.a=d
this.b=e},
bZ2:function bZ2(d,e){this.a=d
this.b=e},
agY:function agY(d){this.a=d},
b1Y:function b1Y(d){this.a=d}},D,H,E,F,M
J=c[1]
A=c[0]
C=c[2]
N=c[16]
K=c[22]
O=c[9]
L=c[18]
G=c[11]
I=c[27]
B=a.updateHolder(c[8],B)
D=c[28]
H=c[25]
E=c[12]
F=c[14]
M=c[15]
B.agZ.prototype={
qJ(){var x=this,w=x.a
if(w!=null)return A.en(w,y.m)
w=x.b
return w==null?x.b=new B.b1Z(x).$0():w},
tW(d,e){return this.aKM(d,e,e)},
aKM(d,e,f){var x=0,w=A.k(f),v,u=2,t=[],s,r,q,p
var $async$tW=A.f(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$tW)
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
r=B.crj(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$tW,w)},
nZ(d,e){var x=A.er(d[e])
if(x==null)x=null
return x===!0},
M4(){var x=0,w=A.k(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$M4=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.qJ(),$async$M4)
case 7:r=h.d0(g.dO(e,"support",null,null,null,null))
q=s.nZ(r,"worker")
p=s.nZ(r,"wasm")
o=s.nZ(r,"mic")
n=s.nZ(r,"audio")
s.nZ(r,"webgpu")
m=s.nZ(r,"secure")
s.nZ(r,"ios")
l=A.no(r.memory)
if(l==null)l=null
if(l==null)l=0
s.nZ(r,"isolated")
k=A.no(r.cores)
if(k!=null)C.f.aw(k)
v=new B.TT(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a27
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$M4,w)},
DV(){var x=0,w=A.k(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$DV=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.qJ(),$async$DV)
case 8:x=7
return A.c(m.eM(l.d0(k.dO(e,"storage",null,null,null,null)),y.A),$async$DV)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.aw(A.dK(r.quota))
p=C.f.aw(A.dK(r.usage))
v=new A.aqR(q,p)
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
return A.j($async$DV,w)},
bfy(){var x=y.K
A.O8(this.qJ().bD(new B.b21(),x),x)},
qI(d,e){var x=A.no(d[e])
x=x==null?null:C.f.aw(x)
return x==null?0:x},
bd_(d,e,f){return this.tW(new B.b20(this,d,e,f),y.C)},
gaiA(){var x,w
try{x=A.qz(b.G.sessionStorage)
return x}catch(w){return null}},
gapX(){var x=A.er(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a7E(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.er(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gapX())return!1
l=A.er(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.d0(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.a_(x.userAgent)
l=A.no(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.u(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aJ("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.e(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aJ("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.no(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.gaiA()
l=l==null?f:A.u(A.dO(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.e7(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.qz(m.localStorage)
m=o
m=m==null?f:A.u(A.dO(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.e7(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
aow(){var x,w,v,u,t,s,r=null
try{x=this.gaiA()
if(x!=null)A.dO(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.d0(x.location)
u=A.a_(v.hash)
t=A.a_(v.search)
s=A.bs(A.a_(A.d0(x.document).baseURI),0,r).a3("tutor/").j(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.dO(v,"replace",s+t+x,r,r,r)},
bcJ(){var x,w=null,v=b.G,u=A.d0(v.history),t=A.no(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.dO(u,"back",w,w,w,w)
else{x=A.a_(A.d0(v.document).baseURI)
A.dO(A.d0(v.location),"replace",A.bs(x,0,w).a3("./").j(0)+"#/",w,w,w)}},
a7O(d,e,f,g,h){return this.tW(new B.b25(this,e,d,f,h,g),y.H)},
a7R(){return this.tW(new B.b26(this),y.D)},
a21(){var x=null,w=this.a
if(w!=null)A.dO(w,"cancelRecording",x,x,x,x)},
ajW(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.qI(d,"ms")
w=A.no(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.Ix(u,x,w,v.qI(d,"frames"),v.qI(d,"tokens"),v.nZ(d,"retried"),v.qI(d,"encMs"),v.qI(d,"decMs"),v.qI(d,"featMs"))},
agr(d){var x={}
x.words=d
return x},
at_(d,e){return this.tW(new B.b28(this,d,e),y._)},
bhE(d,e){return this.tW(new B.b27(this,d,e),y._)},
Ka(d,e){return this.bfC(d,e)},
bfC(d,e){var x=0,w=A.k(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Ka=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.qJ(),$async$Ka)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.al(d).i("au<1,o>")
o=A.aa(new A.au(d,new B.b22(),o),o.i("aZ.E"))
x=11
return A.c(A.eM(A.d0(A.dO(r,"play",o,e,null,null)),y.y),$async$Ka)
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
return A.j($async$Ka,w)},
LM(){var x=null,w=this.a
if(w!=null)A.dO(w,"stopPlayback",x,x,x,x)},
a5m(d){var x=this.a
if(x!=null)A.dO(x,"prefetch",d,null,null,null)}}
B.TT.prototype={}
B.Iv.prototype={
gmD(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.Ix.prototype={
gRP(){var x=this,w=C.f.am(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.Iw.prototype={}
B.lj.prototype={
gij(){var x,w=this.a
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
$ibK:1}
B.na.prototype={
R(){return"WordStatus."+this.b}}
B.QZ.prototype={}
B.mz.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.H7.prototype={
gLL(){var x,w=this,v=w.d
if(v===$){x=new B.aTe(w).$0()
w.d!==$&&A.ao()
w.d=x
v=x}return v},
gIX(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.d===D.a2y&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbdP(){return J.hc(this.gLL(),new B.aTd()).gM(0)},
gt_(){var x=this.a
return x.length!==0&&this.gbdP()===x.length&&this.gIX().length===0}}
B.Eb.prototype={
R(){return"AyahStatus."+this.b}}
B.qR.prototype={}
B.ah_.prototype={
a4Z(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.qF():x},
aX6(d){var x=this,w=B.b2b(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cab(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
anI(){var x=Date.now(),w=B.b2b(new A.ba(x,0,!1))
x=this.c
return x===w||x===B.cab(w)?this.d:0},
as6(d,e,f,g){var x=this,w=new A.ba(Date.now(),0,!1),v=x.a4Z(d,e),u=g?C.j.dc(v.b+1,0,100):0,t=g&&u>=f?D.f6:D.oH,s=new B.qR(t,u,w.i1()),r=d*1000+e
x.a.q(0,r,s)
x.b.F(0,r)
x.aX6(w)
return s},
a4Q(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=H.ds[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qF():s).a===D.f6)++u}return u},
bcH(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=H.ds[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qF():s).a===D.oH)++u}return u},
gar4(){var x=this.a,w=A.y(x).i("cc<2>")
return new A.am(new A.cc(x,w),new B.b2c(),w.i("am<X.E>")).gM(0)},
gawD(){var x=this.a,w=A.y(x).i("bG<1>")
w=A.m1(new A.bG(x,w),new B.b2d(),w.i("X.E"),y.S)
w=A.eT(w,A.y(w).i("X.E"))
x=A.aa(w,A.y(w).c)
C.b.mZ(x)
return x},
dJ(){var x,w,v,u,t,s=this,r=y.N,q=A.C(r,y.L)
for(x=s.a,x=new A.ey(x,A.y(x).i("ey<1,2>")).ga_(0),w=y.t;x.A();){v=x.d
u=v.a
t=v.b
q.q(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.aa(x,A.y(x).c)
return A.I(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
b8F(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Y)
for(x=this.b,x=A.b0v(x,300,A.y(x).c),x=new A.Ic(J.aE(x.a),x.b,A.y(x).i("Ic<1>")),w=y.N,v=y.z,u=this.a;x.A();){t=x.gJ()
s=C.j.aL(t,1000)
t=C.j.a0(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.qF():q).a===D.f6?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.qF()
r=u.h(0,r)
o.push(A.I(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.qF():r).c.kR()],w,v))}return o},
bdh(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.K)(d),++u){t=d[u]
s=A.eC(t.h(0,"surah"))*1000+A.eC(t.h(0,"ayah"))
r=w.h(0,C.j.aL(s,1000)*1000+C.j.a0(s,1000))
if((r==null?$.qF():r).c.kR()===t.h(0,"updated_at"))v.K(0,s)}},
bdp(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aE(d),w=this.b,v=this.a,u=y.f,t=!1;x.A();){s=x.gJ()
if(!u.b(s))continue
r=A.aP(s.h(0,"surah"))
q=r==null?null:C.f.co(r)
r=A.aP(s.h(0,"ayah"))
p=r==null?null:C.f.co(r)
o=A.dV(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=H.ds[q-1].a[1])
if(r)continue
n=B.cwT(s.h(0,"status"))
if(n===D.oG)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.aP(s.h(0,"perfect_count"))
l=l==null?null:C.f.co(l)
v.q(0,r,new B.qR(n,C.j.dc(l==null?0:l,0,100),o.i1()))
w.K(0,r)
t=!0}return t}}
B.TR.prototype={
Ip(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.TR(w,v,u,t,f==null?x.e:f)},
b6Z(d){var x=null
return this.Ip(x,x,d,x,x)},
and(d){var x=null
return this.Ip(x,d,x,x,x)},
b72(d){var x=null
return this.Ip(x,x,x,x,d)},
b6m(d){var x=null
return this.Ip(d,x,x,x,x)},
b7_(d){var x=null
return this.Ip(x,x,x,d,x)},
dJ(){var x=this
return A.I(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Gd.prototype={
R(){return"ModelState."+this.b}}
B.TS.prototype={
ve(){var x=this.Q
return x==null?this.Q=new B.b2e(this).$0():x},
qi(d){return this.auQ(d)},
auQ(d){var x=0,w=A.k(y.H),v=this
var $async$qi=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:v.b=d
v.ad()
x=2
return A.c(A.ms("mt.tutor.settings",C.aF.kE(d.dJ(),null)),$async$qi)
case 2:return A.i(null,w)}})
return A.j($async$qi,w)},
zf(){var x=0,w=A.k(y.H),v=this,u
var $async$zf=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:v.ad()
x=2
return A.c(A.ms("mt.tutor.progress",C.aF.kE(v.c.dJ(),null)),$async$zf)
case 2:u=v.as
if(u!=null)u.aD()
v.as=A.cW(C.x,v.gaBz())
return A.i(null,w)}})
return A.j($async$zf,w)},
Lv(d,e,f){return this.avD(d,e,f)},
avD(d,e,f){var x=0,w=A.k(y.H),v=this
var $async$Lv=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:v.z=new A.aS(d,e,f)
x=2
return A.c(A.ms("mt.tutor.last",C.aF.kE(A.I(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Lv)
case 2:return A.i(null,w)}})
return A.j($async$Lv,w)},
CF(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$CF=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.Tt||n===D.jC){x=1
break}s.f=D.Tt
s.y=null
s.ad()
u=4
n=A.mm().gf7().h(0,"tutor_device")
if(n==null)n="auto"
p=A.mm().gf7().h(0,"tutor_threads")
p=A.e7(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bd_(new B.b2f(s),n,p),$async$CF)
case 7:s.x=e
s.f=D.jC
n=A.mm().gf7().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.DT().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a9(m)
if(n instanceof B.lj){q=n
s.f=D.aP7
s.y=q
n=A.mm().gf7().h(0,"debug")
if(n==="1")A.DT().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.ad()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$CF,w)},
wf(){var x=0,w=A.k(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wf=A.f(function(a0,a1){if(a0===1){t.push(a1)
x=u}for(;;)switch(x){case 0:if(r.at){x=1
break}q=null
try{k=$.A().b
k===$&&A.b()
k=k.ga2().e.a
q=(k==null?null:k.r)!=null}catch(d){x=1
break}if(!q){x=1
break}r.at=!0
u=4
k=$.A().b
k===$&&A.b()
p=k
x=7
return A.c(p.aQ("quran_tutor_progress").d5("surah, ayah, status, perfect_count, updated_at"),$async$wf)
case 7:o=a1
n=r.c.bdp(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.b8F()
if(J.aT(l)===0){x=10
break}h=p
g=A.I(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.v(0,A.mI(h.x,k,k))
x=11
return A.c(f.bha("quran_tutor_save",!1,g,i),$async$wf)
case 11:r.c.bdh(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.ms("mt.tutor.progress",C.aF.kE(r.c.dJ(),null)),$async$wf)
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
return A.j($async$wf,w)},
Ko(d){return this.bgS(d)},
bgS(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Ko=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c1r(t.c.dJ()).dJ()
y.f.a(p.h(0,"rows")).eh(0,new B.b2g(d))
t.c=B.c1r(p)
x=2
return A.c(t.zf(),$async$Ko)
case 2:v=4
s=$.A().b
s===$&&A.b()
r=s.ga2().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.aB("quran_tutor_reset",A.I(["p_surah",d],y.N,r),r),$async$Ko)
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
return A.j($async$Ko,w)}}
B.w5.prototype={
P(){var x=$.Lj()
return new B.Zb(x,new A.ae(C.I,$.R()))}}
B.Zb.prototype={
X(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goa())
w=y.a
x.ve().bD(new B.bDZ(v),w)
G.aRG().bD(new B.bE_(v),w).fM(new B.bE0())
A.O8(G.c0O(),y.y)},
xl(){if(this.c!=null)this.k(new B.bDL())},
m(){var x,w=this
w.d.V(w.goa())
x=w.e
x.p$=$.R()
x.L$=0
w.a1()},
P1(){var x=0,w=A.k(y.H),v,u=this,t,s
var $async$P1=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qi(s.b.b6Z(!0)),$async$P1)
case 3:t=s.a
t.bfy()
if(t.a7E()){t.aow()
x=1
break}s.CF()
case 1:return A.i(v,w)}})
return A.j($async$P1,w)},
xm(d,e,f){return this.aV0(d,e,f)},
b2n(d){return this.xm(d,null,null)},
aV0(d,e,f){var x=0,w=A.k(y.H),v,u=this,t,s,r
var $async$xm=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.Z(A.aN(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.Z(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cAr(s,d),$async$xm)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Lv(d,t.a,t.b),$async$xm)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.M(s,!1).aC(A.ay(new B.bDR(u,d,t),null,r),r),$async$xm)
case 8:if(u.c!=null)u.k(new B.bDS())
case 1:return A.i(v,w)}})
return A.j($async$xm,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gapX()&&!A.M(d,!1).uH())u.push(A.cb(x,x,x,C.xC,x,x,t.gbcI(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.cb(x,x,x,D.aqZ,x,x,new B.bDV(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.cb(x,x,x,C.ii,x,x,new B.bDW(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aDl
else w=t?this.aQ7():this.aQI()
return E.wO(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aQI(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a27
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b2w,C.a_],x)
for(t=0;t<4;++t){s=D.aFr[t]
u.push(new A.H(C.bx,A.B(A.a([A.bb(s.a,C.ar,p,18),C.J,new A.bT(1,C.ac,A.d(s.b,p,p,p,p,D.b8k,p,p,p),p)],x),C.r,C.d,C.e,0,p,p),p))}u=A.J(u,C.r,C.d,C.e,0,C.l)
s=A.a([D.bsD,C.K,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bJ(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.b2,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bJ(C.f.aw(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.v(s,A.a([C.K,A.d(q,p,p,p,p,A.bL(p,p,r?D.dS:C.d3,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.v(s,A.a([C.K,D.brH],x))
x=A.a([new E.eg(u,C.a7,C.aW,p,!0,p),new E.eg(A.J(s,C.r,C.d,C.e,0,C.l),C.a7,C.aW,p,!1,p),D.bAz,C.K],x)
if(v!=null)x.push(new E.eg(A.d(v,p,p,p,p,D.bdd,p,p,p),C.a7,C.aW,p,!1,p))
else x.push(A.fX(D.ao4,D.biQ,this.gaVh(),A.eS(C.A,C.aq,D.b5r,p)))
x.push(C.a1)
x.push(D.a22)
return x},
aQ7(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.O(r.a.a),p=q.length===0,o=p?C.r0:G.ceB(q),n=t.z,m=A.S(v.ajf(C.dq,E.bJ(s.gar4())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bJ(s.anI()),k=s.c,j=Date.now()
k=k===B.b2b(new A.ba(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Ge(t,!1,u),A.B(A.a([m,C.J,A.S(v.ajf(C.kL,l+" \u064a\u0648\u0645",k),1)],j),C.i,C.d,C.e,0,u,u),C.u],j)
if(n!=null){t=G.k1(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bJ(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bJ(m)+"\u2013"+E.bJ(l)
k.push(new E.eg(A.B(A.a([D.aq8,C.Y,A.S(A.J(A.a([D.bf9,A.d(t+" \u2014 "+m,u,u,u,u,C.c7,u,u,u)],j),C.r,C.d,C.e,0,C.l),1),M.n4],j),C.i,C.d,C.e,0,u,u),C.a7,C.aW,new B.bDO(v,n),!0,u))}t=C.h.ah(0.08)
k.push(A.aC(u,C.w,!1,u,!0,C.m,u,A.aD(),r,u,u,u,u,u,2,A.cV(u,new A.ch(4,A.v(14),C.M),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.Aj,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.xD,u,u,u,u,u,u,u,u,u,u,u,u),C.q,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bDP(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.dM,!0,C.t,u,C.E,u,u,u,u))
k.push(C.u)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bnY)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.K)(o),++x)t.push(v.Qb(o[x]))
C.b.v(k,t)}else{t=A.a([D.aSc,D.aSQ,v.Qb(1)],j)
for(w=114;w>=78;--w)t.push(v.Qb(w))
t.push(C.K)
r=v.f
p=A.bb(r?C.G1:C.q5,C.ar,u,u)
t.push(A.ie(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.hU,u,u,u),new B.bDQ(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Qb(w))
C.b.v(k,t)}k.push(C.a_)
k.push(D.B5)
return k},
ajf(d,e,f){var x=null,w=y.p
return new E.eg(A.B(A.a([A.bb(d,C.A,x,x),C.J,A.S(A.J(A.a([A.d(e,x,x,x,x,C.c7,x,x,x),A.d(f,1,C.O,x,x,C.a0p,x,x,x)],w),C.r,C.d,C.e,0,C.l),1)],w),C.i,C.d,C.e,0,x,x),C.a7,C.L,x,!1,x)},
Qb(d){var x,w=null,v=this.d.c,u=H.ds[d-1].a[1],t=v.a4Q(d),s=t/u,r=y.p,q=A.aq(A.dq(C.P,A.a([A.c_h(C.fN,D.dm,w,w,w,w,w,3,s,w),A.d(E.bJ(d),w,w,w,w,N.a0J,w,w,w)],r),C.m,C.bh,w),36,36),p=A.d(G.k1(d),w,w,w,w,D.b84,w,w,w)
if(t===0)x=E.bJ(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bJ(t)+" \u0645\u0646 "+E.bJ(u)
r=A.a([q,C.cC,A.S(A.J(A.a([p,A.d(x,w,w,w,w,A.bL(w,w,t===u?D.dm:C.d3,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.r,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bJ(C.f.aw(s*100))+"\u066a",w,w,w,w,D.a0h,w,w,w))
r.push(D.aod)
return new E.eg(A.B(r,C.i,C.d,C.e,0,w,w),C.pD,C.dC,new B.bDT(this,d),!1,w)}}
B.Ge.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.bo
return D.aRY
case 3:x=q.y
x=x==null?r:x.gij()
return new E.eg(A.J(A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":x,r,r,r,r,D.Ae,r,r,r),C.K,new A.z2(C.a2S,!1,q.gbcZ(),r,r,r,r,C.k,r,!1,r,!0,r,C.AG,r)],y.p),C.r,C.d,C.e,0,C.l),C.a7,C.aW,r,!1,r)
case 0:case 1:w=q.w
v=q.r
q=w>0
u=q?C.f.dc(v/w,0,1):r
t=q&&v<w
q=A.d(t?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bJ(C.f.aw(v/1e6))+" \u0645\u0646 "+E.bJ(C.f.aw(w/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.oa,r,r,r)
x=A.v(8)
s=y.p
x=A.a([q,C.B,A.f3(x,A.rA(C.fN,C.A,7,t?u:r,r),C.aB)],s)
if(!this.d)C.b.v(x,A.a([C.K,D.bjE],s))
return new E.eg(A.J(x,C.r,C.d,C.e,0,C.l),C.a7,C.aW,r,!1,r)}}}
B.W5.prototype={
t(d){var x=null,w=D.dS.ah(0.1),v=A.v(14),u=A.aF(D.dS.ah(0.4),1)
return A.D(x,A.B(A.a([D.apN,C.J,A.S(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.Am,x,x,x),1)],y.p),C.r,C.d,C.e,0,x,x),C.k,x,x,new A.E(w,x,u,v,x,x,x,C.n),x,x,C.aW,C.ad,x,x,x)}}
B.Dd.prototype={
R(){return"_Phase."+this.b}}
B.Ci.prototype={
P(){return new B.a0z($.Lj(),D.lV)}}
B.a0z.prototype={
gjn(){var x=this.e
return x===$?this.e=this.a.d:x},
gBd(){var x,w=this.a,v=w.f
w=w.c
x=this.gjn()
return G.Ld(w,x,v.xx(w,x)).b},
X(){var x,w=this
w.Y()
x=w.d
x.ac(w.goa())
x.ve()
x.a.a5m(B.axj(w.a.c,w.gjn()))},
xl(){if(this.c!=null)this.k(new B.bQO())},
m(){var x,w=this,v=w.d
v.V(w.goa())
x=w.Q
if(x!=null)x.aD()
v=v.a
v.LM()
v.a21()
w.a1()},
YP(d){var x,w,v=this
if(v.f===D.un)v.d.a.a21()
x=v.d.a
x.LM()
w=v.Q
if(w!=null)w.aD()
v.k(new B.bR3(v,d))
x.a5m(B.axj(v.a.c,d))
w=v.a
if(d<w.e)x.a5m(B.axj(w.c,d+1))},
Qs(d){return this.aRx(d)},
aRx(d){var x=0,w=A.k(y.H),v,u=this,t,s,r,q,p
var $async$Qs=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:if(u.f===D.um){u.d.a.LM()
u.k(new B.bR7(u))
x=1
break}t=u.r!=null?D.iU:D.lV
u.k(new B.bR8(u))
s=u.d
r=A.a([B.axj(u.a.c,u.gjn())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.Ka(r,q),$async$Qs)
case 3:p=f
if(u.c==null||u.f!==D.um){x=1
break}u.k(new B.bR9(u,t,p))
case 1:return A.i(v,w)}})
return A.j($async$Qs,w)},
Pm(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Pm=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jC){x=1
break}p=l.a
p.LM()
r=B.DU(s.gBd()).length
s.k(new B.bRb(s))
o=s.Q
if(o!=null)o.aD()
s.Q=A.hZ(C.eK,new B.bRc(s))
u=4
o=B.c3a(r)
n=A.dl(0,0,0,350*r,0,0)
x=7
return A.c(p.a7O(l.b.c,o,n,new B.bRd(s),new B.bRe(s)),$async$Pm)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a9(k)
if(l instanceof B.lj){q=l
l=s.Q
if(l!=null)l.aD()
if(s.c!=null)s.k(new B.bRf(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Pm,w)},
Bc(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Bc=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.un){x=1
break}n=s.Q
if(n!=null)n.aD()
s.k(new B.bRh(s))
s.Q=A.hZ(C.ie,new B.bRi(s))
m=new A.BM()
$.DX()
m.tw()
r=m
u=4
n=s.d.a
x=7
return A.c(n.a7R(),$async$Bc)
case 7:q=e
if(q.b<0.8){s.a0R("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(n.at_(q,B.DU(s.gBd()).length),$async$Bc)
case 8:p=e
s.ay=A.dl(0,0,r.ga3p(),0,0,0)
n=A.mm().gf7().h(0,"debug")
if(n==="1"){A.DT().$1("[tutor] "+s.a.c+":"+s.gjn()+" audio="+C.f.am(q.b,1)+"s infer="+p.b+"ms total="+r.gC1()+"ms "+p.gRP()+" text="+p.a)
s.at="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.am(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.am(p.b/1000,2)+" \u062b\n"+p.gRP()+"\n"+p.a}s.adF(p.a)
u=2
x=6
break
case 4:u=3
k=t.pop()
n=A.a9(k)
if(n instanceof B.lj){o=n
s.a0R(o.gij())}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Bc,w)},
a0R(d){var x=this,w=x.Q
if(w!=null)w.aD()
if(x.c==null)return
x.k(new B.bR2(x,d))},
adF(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aD()
if(s.c==null)return
x=B.cd3(s.gBd(),d)
r.a=null
if(C.c.O(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjn()
t=x.gt_()
r.a=w.as6(v,u,q.b.a,t)
q.zf()}s.k(new B.bR4(r,s,x))},
N5(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h
var $async$N5=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:i=s.d
if(i.f!==D.jC){x=1
break}s.k(new B.bQW(s))
m=s.Q
if(m!=null)m.aD()
s.Q=A.hZ(C.ie,new B.bQX(s))
l=new A.BM()
$.DX()
l.tw()
r=l
u=4
x=7
return A.c(i.a.bhE(B.axj(s.a.c,s.gjn()),B.DU(s.gBd()).length),$async$N5)
case 7:q=e
p="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.am(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.am(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.am(r.gC1()/1000,2)+" \u062b)\n"+q.gRP()+"\n"+q.a
A.DT().$1("[tutor-debug] "+s.a.c+":"+s.gjn()+" audio="+C.f.am(q.c,1)+"s infer="+q.b+"ms total="+r.gC1()+"ms "+q.gRP()+" text="+q.a)
s.ay=A.dl(0,0,r.ga3p(),0,0,0)
s.adF(q.a)
o=s.r
if(o!=null){i=o.gt_()
m=o.b
k=A.al(m).i("am<1>")
m=A.aa(new A.am(m,new B.bQY(),k),k.i("X.E"))
A.DT().$1("[tutor-debug] perfect="+i+" ops="+A.n(m))}s.k(new B.bQZ(s,p))
u=2
x=6
break
case 4:u=3
h=t.pop()
i=A.a9(h)
if(i instanceof B.lj){n=i
A.DT().$1("[tutor-debug] failed: "+A.n(n))
s.a0R(n.gij())}else throw h
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$N5,w)},
ga_G(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.qF():v).a!==D.f6)return!1}return!0},
t(d){var x,w=this,v=null,u=w.d,t=u.c.a4Z(w.a.c,w.gjn()),s=u.b,r=s.d&&!w.x&&w.f!==D.iU,q=G.k1(w.a.c),p=y.p,o=A.a([A.cb(v,v,v,C.ii,v,v,new B.bRn(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aI3(),m=A.d("\u0622\u064a\u0629 "+E.bJ(w.gjn()),v,v,v,v,L.An,v,v,v),l=E.bJ(w.gjn()-w.a.d+1),k=w.a
s=A.a([A.B(A.a([m,C.b0,A.d("("+l+" \u0645\u0646 "+E.bJ(k.e-k.d+1)+")",v,v,v,v,F.b2,v,v,v),C.bB,w.aVX(t,s.a)],p),C.i,C.d,C.e,0,v,v),C.u],p)
if(r)s.push(w.aQ2())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.un&&l!==D.ox}else l=!1
if(l)s.push(w.aFM(m))
else s.push(A.d(w.gBd()+" \ufd3f"+E.bJ(w.gjn())+"\ufd3e",v,v,v,v,D.k_,C.a4,C.bf,v))}s=A.a([new B.Ge(u,!0,v),n,C.B,new E.eg(A.J(s,C.ah,C.d,C.e,0,C.l),D.ahb,C.aW,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.iU)s.push(w.b3L(n))
if(w.r!=null&&w.f===D.iU&&w.ay!=null){x=C.f.aw(C.j.aL(w.ay.a,1000)/100)
s.push(new A.H(C.bx,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bJ(C.j.aL(x,10))+"\u066b"+E.bJ(C.j.a0(x,10)))+" \u062b",v,v,v,v,F.b2,C.a4,v,v),v))}n=w.as
if(n!=null)s.push(new A.H(C.aW,A.d(n,v,v,v,v,D.Ae,v,v,v),v))
s.push(w.aGk())
s.push(C.a_)
s.push(A.ib(C.A,C.L,v,new B.bRo(w),D.bgM,D.blQ,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga_G()
s.push(new E.eg(A.B(A.a([D.amN,C.Y,A.S(A.J(A.a([D.bnm,A.d(w.ga_G()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.b2,v,v,v)],p),C.r,C.d,C.e,0,C.l),1),M.n4],p),C.i,C.d,C.e,0,v,v),C.a7,C.aW,new B.bRp(w,d),n,v))}n=A.mm().gf7().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dp(D.ao3,D.bli,u.f===D.jC&&w.f!==D.ox?w.gaH3():v,v)],p)
n=w.at
if(n!=null)p.push(new A.H(C.jd,A.Hz(n,F.b2,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gmD()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.b2,v,v,v))}C.b.v(s,p)}s.push(C.B)
s.push(D.B5)
return E.wO(o,s,q)},
aI3(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.bo
return A.aq(A.fs(new B.bR0(this),w,null,C.ae,new B.bR1()),36,null)},
aVX(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.f6)return D.b2H
x=d.b
w=E.bJ(x)
v=E.bJ(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.bS:C.Gh
u.push(new A.H(D.ahR,A.bb(r,s?D.dm:C.fO,q,16),q))}return A.c1o(A.B(u,C.i,C.d,C.N,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aQ2(){var x=null
return A.bz(!1,A.v(12),!0,A.D(x,D.adm,C.k,x,x,new A.E(C.vn,x,x,A.v(12),x,x,x,C.n),x,x,x,D.agO,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bR6(this),x,x,x,x,x,x,x)},
aFM(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.aH(d.gLL(),w)
A:{if(D.iN===v){u=D.k_.ci(D.dm)
break A}if(D.u6===v){u=D.k_.a2H(D.dS,C.iH,D.dS)
break A}if(D.u7===v){u=D.k_.a2H(D.eH,C.iH,D.eH)
break A}u=D.k_.a2H(C.fO,C.jX,C.dj)
break A}t=x[w]
r.push(new A.eW(t.a,s,s,C.bw,s,s,s,s,s,s,u))
r.push(H.A6)}x=E.bJ(this.gjn())
r.push(A.ei(s,s,s,s,s,s,s,s,s,D.k_.ci(C.ar),"\ufd3f"+x+"\ufd3e"))
return A.Id(A.ei(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.a4,C.bf)},
b3L(d){var x,w,v,u,t,s,r=this.w
if(C.c.O(d.c).length===0)return D.bzW
if(d.gt_()){x=r==null
if((x?null:r.a)===D.f6&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.f6?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bJ(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.Cy(D.dm,C.bS,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gLL()
w=J.dB(x)
v=w.ip(x,new B.bRj()).gM(0)
u=w.ip(x,new B.bRk()).gM(0)
t=w.ip(x,new B.bRl()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bJ(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bJ(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bJ(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gIX().length!==0)x.push(E.bJ(d.gIX().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eH:D.dS
x=C.b.aE(x," \u2022 ")
s=d.gIX().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aE(d.gIX(),"\u060c "):""
return new B.Cy(w,C.mU,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aGk(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jC,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aL(new A.ba(f,0,!1).e_(w).a,1e6)}v=C.j.aL(B.c3a(B.DU(j.gBd()).length).a,1e6)
f=j.gb2p()
w=96+26*j.y
u=D.eH.ah(0.25)
w=A.iQ(i,A.a3g(C.P,A.D(i,D.aog,C.k,i,i,D.a5r,i,84,i,i,i,i,84),i,C.aP,new A.E(u,i,i,i,i,i,i,C.c2),C.E0,i,w,i,w),C.q,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cQ)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c2b(x)+" / "+B.c2b(v),i,i,i,i,I.o9,i,i,i)
return A.J(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.b2,i,i,i),A.br(D.brG,i,i,f,i,i)],y.p),C.i,C.d,C.e,0,C.l)
case 3:t=C.f.eu((Date.now()-j.ax)/1000)
return new A.H(C.pz,A.J(A.a([C.v9,C.a_,D.bk5,A.d(t<8?"\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643":"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bJ(t)+" \u062b)",i,i,i,i,F.b2,i,i,i)],y.p),C.i,C.d,C.e,0,C.l),i)
default:s=f===D.um
r=j.r
f=r==null
w=!f
q=w&&r.gt_()
u=A.bb(s?D.xr:I.Gs,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.eS(i,i,D.b5o,i)
u=A.S(new A.z2(C.a2S,!0,new B.bQP(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.WG(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.HV[n]
p.push(new A.ed(m,i,A.d("\xd7"+E.bJ(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.B(A.a([u,C.J,A.op(new B.bQQ(j),p,A.d3([h.b.b],o),!1,A.k6(i,i,i,new A.bo(new B.bQR(),l),i,i,i,i,new A.bo(new B.bQS(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.dO),o)],k),C.i,C.d,C.e,0,i,i)
h=g&&!s?j.gaXO():i
u=A.bb(f?D.qa:C.mU,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cz,i,i,i)
p=q?C.ks:C.A
h=A.a([o,C.u,A.fX(u,f,h,A.eS(p,q?C.h:C.aq,D.tm,i))],k)
if(w&&j.gjn()<j.a.e)C.b.v(h,A.a([C.B,q?A.fX(D.arl,D.bqu,new B.bQT(j),A.eS(D.dm,C.aq,D.tm,i)):A.br(D.bh9,i,i,new B.bQU(j),i,i)],k))
if(w){f=j.gjn()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.H(C.je,A.d(j.ga_G()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,D.a0R,C.a4,i,i),i))
return A.J(h,C.ah,C.d,C.e,0,C.l)}}}
B.Cy.prototype={
t(d){var x=this,w=null,v=x.c,u=v.ah(0.12),t=A.v(14),s=A.aF(v.ah(0.5),1),r=y.p
return A.D(w,A.B(A.a([A.bb(x.d,v,w,w),C.J,A.S(A.J(A.a([A.d(x.e,w,w,w,w,A.bL(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.U,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bJ,A.d(x.f,w,w,w,w,C.Am,w,w,w)],r),C.r,C.d,C.e,0,C.l),1)],r),C.r,C.d,C.e,0,w,w),C.k,w,w,new A.E(u,w,s,t,w,w,w,C.n),w,w,C.aW,C.ad,w,w,w)}}
B.Ch.prototype={
P(){var x=y.S
return new B.a0y($.Lj(),A.C(x,y.B),A.aV(x),A.C(x,y.N),A.en(null,y.H))}}
B.a0y.prototype={
X(){this.Y()
this.d.ac(this.goa())},
xl(){if(this.c!=null)this.k(new B.bQx())},
m(){var x,w=this,v=w.d
v.V(w.goa())
x=w.y
if(x!=null)x.aD()
v.a.a21()
w.a1()},
Hy(d){return this.b0N(d)},
b0N(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$Hy=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.k(new B.bQG(t,d))
r=t.y
if(r!=null)r.aD()
t.y=A.hZ(C.eK,new B.bQH(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c3a(B.DU(G.Ld(q,d,p.xx(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dl(0,0,0,350*B.DU(G.Ld(p,d,o.xx(p,d)).b).length,0,0)
x=6
return A.c(r.a.a7O(r.b.c,q,p,new B.bQI(t,d),new B.bQJ(t)),$async$Hy)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a9(m)
if(r instanceof B.lj){s=r
r=t.y
if(r!=null)r.aD()
if(t.c!=null)t.k(new B.bQK(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$Hy,w)},
F4(d,e){return this.aJb(d,e)},
aJb(d,e){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$F4=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aD()
s.k(new B.bQB(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a7R()
if(e&&n!=null)s.Hy(n)
q=null
u=4
x=7
return A.c(r,$async$F4)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a9(l)
if(o instanceof B.lj){p=o
s.k(new B.bQC(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.as=s.as.bD(new B.bQD(s,o,d),y.H)}case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$F4,w)},
gaTz(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aG(x)&&!v.n(0,x)&&!u.aG(x)&&x!==t.e)return x
return null},
aYC(){this.k(new B.bQE(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jC,o=s.e,n=s.gaTz(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("cc<2>")
x=new A.am(new A.cc(m,l),new B.bQL(),l.i("am<X.E>")).gM(0)
l=G.k1(s.a.c)
m=y.p
q=A.a([new B.Ge(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bJ(s.a.d)+" \u0644\u062d\u062f "+E.bJ(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.b2,r,r,r),C.u],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b2o(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.Ae,r,r,r))
k=o==null
if(!k){j=E.bJ(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aL(new A.ba(v,0,!1).e_(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c2b(v),r,r,r,r,I.o9,C.a4,r,r)
j=A.f3(A.v(6),A.rA(C.fN,D.eH,6,s.x,r),C.aB)
u=o<s.a.e
t=A.bb(u?D.ame:D.xr,r,r,r)
C.b.v(q,A.a([v,C.K,j,C.u,A.fX(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cz,r,r,r),new B.bQM(s,o),A.eS(C.A,C.aq,D.tm,r))],m))}else if(n!=null){j=p?new B.bQN(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bJ(n)
q.push(A.fX(D.apk,A.d(v,r,r,r,r,C.cz,r,r,r),j,A.eS(C.A,C.aq,D.tm,r)))}if(s.r.a!==0&&k)q.push(D.aSm)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?D.dm:D.dS
v=k?C.mO:C.mU
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bJ(x)
u=s.a
u=k+" \u0645\u0646 "+E.bJ(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.v(q,A.a([new B.Cy(j,v,k,u,r),A.dp(D.ar8,D.br6,s.gaYB(),r)],m))}q.push(C.u)
q.push(D.B5)
return E.wO(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b2o(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.aoI
else if(l.r.n(0,d))x=K.tn
else if(i!=null)x=D.aoZ
else if(j!=null){w=j.gt_()?C.bS:D.aln
x=A.bb(w,j.gt_()?D.dm:D.dS,k,k)}else x=D.ano
w=y.p
v=A.a([A.B(A.a([A.d("\u0622\u064a\u0629 "+E.bJ(d),k,k,k,k,D.bco,k,k,k),C.bB,x],w),C.i,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.bbE,k,k,k))
if(j!=null&&!j.gt_()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gLL()
o=J.b7(p)
n=o.h(p,r)
A:{if(D.iN===n){m=D.dm
break A}if(D.u6===n){m=D.dS
break A}if(D.u7===n){m=D.eH
break A}m=C.fO
break A}m=D.k_.b7B(m,o.h(p,r)===D.u8?C.jX:k,22)
C.b.v(t,A.a([new A.eW(q.a,k,k,C.bw,k,k,k,k,k,k,m),H.A6],u))}w=A.a([C.aj,A.Id(A.ei(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.a4,C.bf)],w)
if(C.c.O(j.c).length===0)w.push(D.bmL)
C.b.v(v,w)}return new E.eg(A.J(v,C.ah,C.d,C.e,0,C.l),C.bN,C.dC,k,!1,k)}}
B.Cg.prototype={
P(){return new B.a0x($.Lj())}}
B.a0x.prototype={
X(){this.Y()
var x=this.d
x.ac(this.goa())
x.ve()},
xl(){if(this.c!=null)this.k(new B.bQo())},
m(){this.d.V(this.goa())
this.a1()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gawD(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kK(o,0,new B.bQv(q))
v=C.b.kK(o,0,new B.bQw())
o=y.p
o=A.a([A.B(A.a([A.S(s.WI(E.bJ(q.gar4()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.J,A.S(s.WI(E.bJ(q.anI()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.J,A.S(s.WI(E.bJ(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.i,C.d,C.e,0,r,r),C.u,new E.eg(A.J(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bJ(C.f.aw(w*100/v))+"\u066a",r,r,r,r,C.c7,r,r,r),C.K,A.f3(A.v(6),A.rA(C.fN,D.dm,8,w/v,r),C.aB),C.aj,A.d(E.bJ(w)+" \u0645\u0646 "+E.bJ(v)+" \u0622\u064a\u0629",r,r,r,r,F.b2,r,r,r)],o),C.r,C.d,C.e,0,C.l),C.a7,C.aW,r,!1,r)],o)
if(p.length===0)o.push(D.aSz)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.K)(p),++t)o.push(s.b2q(p[t]))
o.push(C.B)
u=$.A().b
u===$&&A.b()
u=u.ga2().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.b2,r,r,r))
return E.wO(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
WI(d,e){var x=null
return new E.eg(A.J(A.a([A.d(d,x,x,x,x,D.bc6,x,x,x),A.d(e,x,x,x,x,C.a0V,C.a4,x,x)],y.p),C.i,C.d,C.e,0,C.l),C.a7,C.L,x,!1,x)},
b2q(d){var x=null,w=this.d.c,v=H.ds[d-1].a[1],u=w.a4Q(d),t=w.bcH(d),s=y.p,r=A.B(A.a([A.S(A.d(G.k1(d),x,x,x,x,C.c7,x,x,x),1),A.d(E.bJ(C.f.aw(u*100/v))+"\u066a",x,x,x,x,D.bde,x,x,x)],s),C.i,C.d,C.e,0,x,x),q=A.f3(A.v(6),A.rA(C.fN,D.dm,7,u/v,x),C.aB),p=E.bJ(u),o=E.bJ(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bJ(t):""
return new E.eg(A.J(A.a([r,C.K,q,C.aj,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.b2,x,x,x)],s),C.r,C.d,C.e,0,C.l),C.a7,C.aW,new B.bQu(this,d),!1,x)},
N8(d){return this.aHo(d)},
aHo(d){var x=0,w=A.k(y.H),v=this,u,t
var $async$N8=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=H.ds[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.el(C.dl,new B.bQt(v,d,u),t,!0,null,null,!1,y.H),$async$N8)
case 2:return A.i(null,w)}})
return A.j($async$N8,w)}}
B.agY.prototype={
Qr(d,e){var x=null,w=A.ts(x,x,x,x,x,x,x,x,x,x,x,D.b4W,C.L,x,x,x,x,C.nA,x,x)
return A.br(A.d(d,x,x,x,x,C.ob,x,x,x),x,x,new B.b1Y(e),x,w)},
t(d){var x=this,w=y.p
return new E.eg(A.J(A.a([D.bqg,C.K,D.brF,A.d7(C.aA,A.a([x.Qr("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Qr("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aH,0,12),D.bgn,x.Qr("tanzil.net","https://tanzil.net"),D.btc,x.Qr("everyayah.com","https://everyayah.com")],w),C.r,C.d,C.e,0,C.l),C.a7,C.aW,null,!1,null)}}
var z=a.updateTypes(["~()","ai<~>()","P(na)","ai<Ix>()","ai<Iv>()","ai<Iw>()","a7<na>()","P(qR)","bE(og)","Ci(t)","Cg(t)","P(mz)","Ch(t)","P(H7)"])
B.b1Z.prototype={
$0(){var x=0,w=A.k(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.a_(A.d0(b.G.document).baseURI)
q=A.bs(r,0,null).a3("quran_tutor/tutor.js?v=2").j(0)
x=7
return A.c(A.eM(import(q),y.m),$async$$0)
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
m=B.crk("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:384}
B.b21.prototype={
$1(d){var x=null
return A.bTU(A.dO(d,"persist",x,x,x,x))},
$S:1088}
B.b20.prototype={
$0(){var x=0,w=A.k(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.qJ(),$async$$0)
case 4:x=3
return A.c(n.eM(m.d0(l.dO(e,"loadModel",A.bUB(new B.b2_(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.u(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.u(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.qI(p,"ms")
r=q.nZ(p,"cached")
A.u(p.backend)
v=new B.Iv(o,t,s,r,q.qI(p,"threads"),q.nZ(p,"isolated"),q.qI(p,"warmMs"))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+4}
B.b2_.prototype={
$2(d,e){this.a.$2(C.f.aw(d),C.f.aw(e))},
$S:1089}
B.b25.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t,s
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.qJ(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aL(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aL(v.d.a,1000)
u.onLevel=A.h1(new B.b23(v.e))
u.onAutoStop=A.h1(new B.b24(v.f))
x=5
return A.c(A.eM(A.d0(A.dO(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.b23.prototype={
$1(d){return this.a.$1(d)},
$S:73}
B.b24.prototype={
$1(d){return this.a.$1(d)},
$S:6}
B.b26.prototype={
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
return A.c(t.qJ(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eM(p.d0(o.dO(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.Iw(r,A.dK(r.seconds))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+5}
B.b28.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.qJ(),$async$$0)
case 4:x=3
return A.c(q.eM(p.d0(o.dO(e,"transcribe",t.audio,t.rate,s.agr(u.c),null)),y.m),$async$$0)
case 3:v=r.ajW(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b27.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.qJ(),$async$$0)
case 4:x=3
return A.c(r.eM(q.d0(p.dO(e,"transcribeUrl",u.b,t.agr(u.c),null,null)),y.m),$async$$0)
case 3:v=s.ajW(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b22.prototype={
$1(d){return d},
$S:37}
B.aTe.prototype={
$0(){var x,w,v,u,t=this.a,s=A.ck(t.a.length,D.u8,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aTd.prototype={
$1(d){return d===D.iN},
$S:z+2}
B.bUk.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.bZn(e[x],d[x])<0.75)return!1
return!0},
$S:1090}
B.bWi.prototype={
$1(d){return d.length!==0},
$S:11}
B.b2c.prototype={
$1(d){return d.a===D.f6},
$S:z+7}
B.b2d.prototype={
$1(d){return C.j.aL(d,1000)},
$S:64}
B.b2a.prototype={
$1(d){return C.f.co(d)},
$S:1091}
B.b2e.prototype={
$0(){var x=0,w=A.k(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.f(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.nv("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.aF.iy(r,null))
j=A.aP(k.h(0,"n"))
j=j==null?null:C.f.co(j)
j=C.j.dc(j==null?2:j,1,5)
i=C.b.n(D.HV,k.h(0,"r"))?A.eC(k.h(0,"r")):1
h=A.er(k.h(0,"auto"))
g=A.er(k.h(0,"hide"))
k=A.er(k.h(0,"in"))
s.a.b=new B.TR(j,i,h!==!1,g===!0,k===!0)}u=2
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
return A.c(A.nv("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.c1r(y.P.a(C.aF.iy(q,null)))
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
return A.c(A.nv("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.aF.iy(p,null))
n=C.f.co(A.dj(J.aH(o,"s")))
m=C.f.co(A.dj(J.aH(o,"f")))
l=C.f.co(A.dj(J.aH(o,"t")))
if(B.ceS(n,m)&&B.ceS(n,l)&&m<=l)s.a.z=new A.aS(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a7E()){k.a.aow()
x=1
break}a1=k
x=18
return A.c(k.a.M4(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.ad()
if(k.b.e)k.CF()
k.wf()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:128}
B.b2f.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.ad()},
$S:1092}
B.b2g.prototype={
$2(d,e){return C.j.aL(A.eY(A.n(d),null,null),1000)===this.a},
$S:1093}
B.bDZ.prototype={
$1(d){var x=0,w=A.k(y.a),v=this,u,t
var $async$$1=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.DV(),$async$$1)
case 2:t=f
if(u.c!=null)u.k(new B.bDY(u,t))
return A.i(null,w)}})
return A.j($async$$1,w)},
$S:1094}
B.bDY.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bE_.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bDX(x,d))},
$S:z+8}
B.bDX.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bE0.prototype={
$1(d){},
$S:24}
B.bDL.prototype={
$0(){},
$S:0}
B.bDR.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.Ci(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bDS.prototype={
$0(){},
$S:0}
B.bDV.prototype={
$0(){var x=y.z
return A.M(this.a,!1).aC(A.ay(new B.bDU(),null,x),x)},
$S:0}
B.bDU.prototype={
$1(d){return D.bux},
$S:z+10}
B.bDW.prototype={
$0(){return B.ceH(this.a)},
$S:0}
B.bDO.prototype={
$0(){var x=this.b
return this.a.xm(x.a,x.b,x.c)},
$S:0}
B.bDP.prototype={
$1(d){return this.a.k(new B.bDN())},
$S:6}
B.bDN.prototype={
$0(){},
$S:0}
B.bDQ.prototype={
$0(){var x=this.a
return x.k(new B.bDM(x))},
$S:0}
B.bDM.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bDT.prototype={
$0(){return this.a.b2n(this.b)},
$S:0}
B.bYo.prototype={
$1(d){return new A.jr(new B.bYl(this.a,this.b,this.c),null)},
$S:57}
B.bYl.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.bYn(u,e),s=this.a,r=new B.bYm(s,e),q=A.d(G.k1(this.c),v,v,v,v,C.o5,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bJ(u)+" \u0622\u064a\u0629)",v,v,v,v,F.b2,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bJ(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bJ(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.dc(w+4,1,u)))}u=A.a([q,C.aj,p,C.u,A.d7(C.aA,n,C.aH,6,8),C.B,A.B(A.a([t.$3("\u0645\u0646",s.b,new B.bYg(s)),C.a_0,t.$3("\u0644\u062d\u062f",s.c,new B.bYh(s))],o),C.i,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aSr)
u.push(C.a1)
u.push(A.dG(D.bjz,new B.bYi(s,d),A.eS(C.A,C.aq,D.b5l,v)))
return A.cw(!0,new A.H(C.Ev,A.J(u,C.ah,C.d,C.N,0,C.l),v),C.L,!0)},
$S:373}
B.bYn.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.hX,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.ce(v,A.d("\u0622\u064a\u0629 "+E.bJ(v),u,u,u,u,u,u,u,u),C.av,u,w))
return A.S(A.J(A.a([t,O.F_(C.dl,!0,s,320,new B.bYk(this.b,f),D.bdv,e,y.S)],y.p),C.r,C.d,C.e,0,C.l),1)},
$S:1095}
B.bYk.prototype={
$1(d){return d==null?null:this.a.$1(new B.bYj(this.b,d))},
$S:50}
B.bYj.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.bYm.prototype={
$3(d,e,f){var x=null
return A.bZY(x,A.d(d,x,x,x,x,x,x,x,x),new B.bYf(this.a,this.b,e,f))},
$S:1096}
B.bYf.prototype={
$0(){var x=this
return x.b.$1(new B.bYe(x.a,x.c,x.d))},
$S:0}
B.bYe.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.bYg.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.bYh.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.bYi.prototype={
$0(){var x=this.a
return A.M(this.b,!1).al(new A.Z(x.b,x.c))},
$S:0}
B.bQO.prototype={
$0(){},
$S:0}
B.bR3.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.lV
x.w=x.r=null
x.x=!1
x.ay=x.at=x.as=null},
$S:0}
B.bR7.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.iU:D.lV},
$S:0}
B.bR8.prototype={
$0(){var x=this.a
x.f=D.um
x.as=null},
$S:0}
B.bR9.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bRb.prototype={
$0(){var x=this.a
x.f=D.un
x.as=null
x.y=0
x.z=new A.ba(Date.now(),0,!1)
x.at=null},
$S:0}
B.bRc.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bRa())},
$S:31}
B.bRa.prototype={
$0(){},
$S:0}
B.bRe.prototype={
$1(d){return this.a.y=d},
$S:73}
B.bRd.prototype={
$1(d){return this.a.Bc()},
$S:6}
B.bRf.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.iU:D.lV
x.as=this.b.gij()},
$S:0}
B.bRh.prototype={
$0(){var x=this.a
x.f=D.ox
x.ax=Date.now()},
$S:0}
B.bRi.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bRg())},
$S:31}
B.bRg.prototype={
$0(){},
$S:0}
B.bR2.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.iU:D.lV
x.as=this.b},
$S:0}
B.bR4.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.iU
x.x=!1},
$S:0}
B.bQW.prototype={
$0(){var x=this.a
x.f=D.ox
x.ax=Date.now()
x.as=null},
$S:0}
B.bQX.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bQV())},
$S:31}
B.bQV.prototype={
$0(){},
$S:0}
B.bQY.prototype={
$1(d){return d.d!==D.iN},
$S:z+11}
B.bQZ.prototype={
$0(){return this.a.at=this.b},
$S:0}
B.bRn.prototype={
$0(){return B.ceH(this.a)},
$S:0}
B.bRo.prototype={
$1(d){var x=this.a.d
return x.qi(x.b.and(d))},
$S:3}
B.bRp.prototype={
$0(){var x=y.z
return A.M(this.b,!1).aC(A.ay(new B.bRm(this.a),null,x),x)},
$S:0}
B.bRm.prototype={
$1(d){var x=this.a.a
return new B.Ch(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bR1.prototype={
$2(d,e){return C.b0},
$S:19}
B.bR0.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a4Z(s.c,r).a.a){case 2:s=D.dm
break
case 1:s=D.dS
break
case 0:s=C.ks
break
default:s=u}x=A.v(18)
w=t.f===D.ox?u:new B.bR_(t,r)
v=s.ah(0.25)
if(r===t.gjn())s=C.h
s=A.aF(s,r===t.gjn()?2:1)
return A.bz(!1,x,!0,A.D(C.P,A.d(E.bJ(r),u,u,u,u,C.a07,u,u,u),C.k,u,u,new A.E(v,u,s,u,u,u,u,C.c2),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:66}
B.bR_.prototype={
$0(){return this.a.YP(this.b)},
$S:0}
B.bR6.prototype={
$0(){var x=this.a
return x.k(new B.bR5(x))},
$S:0}
B.bR5.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bRj.prototype={
$1(d){return d===D.u6},
$S:z+2}
B.bRk.prototype={
$1(d){return d===D.u7},
$S:z+2}
B.bRl.prototype={
$1(d){return d===D.u8},
$S:z+2}
B.bQP.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Qs(x)},
$S:0}
B.bQQ.prototype={
$1(d){var x=this.a.d
return x.qi(x.b.b72(d.ga5(d)))},
$S:115}
B.bQS.prototype={
$1(d){return d.n(0,C.a0)?C.aq:C.h},
$S:5}
B.bQR.prototype={
$1(d){return d.n(0,C.a0)?C.A:C.a8},
$S:5}
B.bQT.prototype={
$0(){var x=this.a
return x.YP(x.gjn()+1)},
$S:0}
B.bQU.prototype={
$0(){var x=this.a
return x.YP(x.gjn()+1)},
$S:0}
B.bQx.prototype={
$0(){},
$S:0}
B.bQG.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.ba(Date.now(),0,!1)},
$S:0}
B.bQH.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bQF())},
$S:31}
B.bQF.prototype={
$0(){},
$S:0}
B.bQJ.prototype={
$1(d){return this.a.x=d},
$S:73}
B.bQI.prototype={
$1(d){return this.a.F4(this.b,!1)},
$S:6}
B.bQK.prototype={
$0(){var x=this.a
x.e=null
x.Q=this.b.gij()},
$S:0}
B.bQB.prototype={
$0(){var x=this.a
x.e=null
x.r.F(0,this.b)},
$S:0}
B.bQC.prototype={
$0(){var x=this.a,w=this.b
x.r.K(0,w)
x.w.q(0,w,this.c.gij())},
$S:0}
B.bQD.prototype={
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
return A.c(n.a.at_(s.b,B.DU(G.Ld(l,m,k.xx(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cd3(G.Ld(l,m,k.xx(l,m)).b,r.a)
if(C.c.O(q.c).length!==0){l=n.c
k=o.a.c
j=q.gt_()
l.as6(k,m,n.b.a,j)}n.zf()
if(o.c!=null)o.k(new B.bQy(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a9(h)
if(o instanceof B.lj){p=o
o=s.a
if(o.c!=null)o.k(new B.bQz(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.k(new B.bQA(o,s.c))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$1,w)},
$S:132}
B.bQy.prototype={
$0(){var x=this.c
this.a.f.q(0,this.b,x)
return x},
$S:0}
B.bQz.prototype={
$0(){var x=this.c.gij()
this.a.w.q(0,this.b,x)
return x},
$S:0}
B.bQA.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bQE.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)},
$S:0}
B.bQL.prototype={
$1(d){return d.gt_()},
$S:z+13}
B.bQM.prototype={
$0(){return this.a.F4(this.b,!0)},
$S:0}
B.bQN.prototype={
$0(){return this.a.Hy(this.b)},
$S:0}
B.bQo.prototype={
$0(){},
$S:0}
B.bQv.prototype={
$2(d,e){return d+this.a.a4Q(e)},
$S:114}
B.bQw.prototype={
$2(d,e){return d+H.ds[e-1].a[1]},
$S:114}
B.bQu.prototype={
$0(){return this.a.N8(this.b)},
$S:0}
B.bQt.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(G.k1(p),q,q,q,q,C.o5,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.b6(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.qF():r).a.a){case 2:r=D.dm.ah(0.35)
break
case 1:r=D.dS.ah(0.35)
break
case 0:r=C.fL
break
default:r=q}m.push(A.D(C.P,A.d(E.bJ(t),q,q,q,q,C.ly,q,q,q),C.k,q,q,new A.E(r,q,q,new A.ct(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cw(!0,new A.H(C.hx,A.J(A.a([o,C.aj,D.bnF,C.u,new A.dD(D.a5j,A.fh(A.d7(C.aA,m,C.aH,6,6),q,C.q,q,q,q,C.v),q),C.a_,A.br(D.bpk,q,q,new B.bQs(w,d,p),q,q)],n),C.ah,C.d,C.N,0,C.l),q),C.L,!0)},
$S:36}
B.bQs.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dm(null,null,!0,null,new B.bQr(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Ko(t),$async$$0)
case 5:if(u.e!=null)A.M(u,!1).e7()
case 3:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.bQr.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+G.k1(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dv(A.a([A.br(C.el,x,x,new B.bQp(d),x,x),A.br(C.ok,x,x,new B.bQq(d),x,x)],y.p),w,D.bqP)},
$S:14}
B.bQp.prototype={
$0(){A.M(this.a,!1).al(!1)
return null},
$S:0}
B.bQq.prototype={
$0(){A.M(this.a,!1).al(!0)
return null},
$S:0}
B.bZ4.prototype={
$1(d){var x=this.a
return new A.l3(new B.bZ3(x),null,x,null)},
$S:1097}
B.bZ3.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.ed(w,t,A.d(E.bJ(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bgj,C.a_,D.bpK,C.K,A.op(new B.bYZ(s,r),q,A.d3([r.a],x),!1,A.k6(t,t,t,new A.bo(new B.bZ_(),v),t,t,t,t,new A.bo(new B.bZ0(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.ib(C.A,C.L,t,new B.bZ1(s,r),D.bmW,D.bsH,r.c),A.ib(C.A,C.L,t,new B.bZ2(s,r),t,D.bfT,r.d)],u)
s=s.x
if(s!=null)C.b.v(x,A.a([C.aj,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gmD(),t,t,t,t,F.b2,t,C.bf,t)],u))
x.push(C.B)
x.push(D.a22)
return A.cw(!0,A.fh(A.J(x,C.ah,C.d,C.e,0,C.l),t,C.q,C.hx,t,t,C.v),C.L,!0)},
$S:1098}
B.bYZ.prototype={
$1(d){return this.a.qi(this.b.b7_(d.ga5(d)))},
$S:115}
B.bZ0.prototype={
$1(d){return d.n(0,C.a0)?C.aq:C.h},
$S:5}
B.bZ_.prototype={
$1(d){return d.n(0,C.a0)?C.A:C.a8},
$S:5}
B.bZ1.prototype={
$1(d){return this.a.qi(this.b.b6m(d))},
$S:3}
B.bZ2.prototype={
$1(d){return this.a.qi(this.b.and(d))},
$S:3}
B.b1Y.prototype={
$0(){return A.cB(A.bs(this.a,0,null),C.aT,null)},
$S:0};(function installTearOffs(){var x=a._instance_0u
x(B.agZ.prototype,"gbcI","bcJ",0)
var w
x(w=B.TS.prototype,"gbcZ","CF",1)
x(w,"gaBz","wf",1)
x(w=B.Zb.prototype,"goa","xl",0)
x(w,"gaVh","P1",1)
x(w=B.a0z.prototype,"goa","xl",0)
x(w,"gaXO","Pm",1)
x(w,"gb2p","Bc",1)
x(w,"gaH3","N5",1)
x(w=B.a0y.prototype,"goa","xl",0)
x(w,"gaYB","aYC",0)
x(B.a0x.prototype,"goa","xl",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.agZ,B.TT,B.Iv,B.Ix,B.Iw,B.lj,B.QZ,B.mz,B.H7,B.qR,B.ah_,B.TR])
x(A.mH,[B.b1Z,B.b20,B.b25,B.b26,B.b28,B.b27,B.aTe,B.b2e,B.bDY,B.bDX,B.bDL,B.bDS,B.bDV,B.bDW,B.bDO,B.bDN,B.bDQ,B.bDM,B.bDT,B.bYj,B.bYf,B.bYe,B.bYi,B.bQO,B.bR3,B.bR7,B.bR8,B.bR9,B.bRb,B.bRa,B.bRf,B.bRh,B.bRg,B.bR2,B.bR4,B.bQW,B.bQV,B.bQZ,B.bRn,B.bRp,B.bR_,B.bR6,B.bR5,B.bQP,B.bQT,B.bQU,B.bQx,B.bQG,B.bQF,B.bQK,B.bQB,B.bQC,B.bQy,B.bQz,B.bQA,B.bQE,B.bQM,B.bQN,B.bQo,B.bQu,B.bQs,B.bQp,B.bQq,B.b1Y])
x(A.j4,[B.b21,B.b23,B.b24,B.b22,B.aTd,B.bWi,B.b2c,B.b2d,B.b2a,B.bDZ,B.bE_,B.bE0,B.bDR,B.bDU,B.bDP,B.bYo,B.bYn,B.bYk,B.bYm,B.bYg,B.bYh,B.bRc,B.bRe,B.bRd,B.bRi,B.bQX,B.bQY,B.bRo,B.bRm,B.bRj,B.bRk,B.bRl,B.bQQ,B.bQS,B.bQR,B.bQH,B.bQJ,B.bQI,B.bQD,B.bQL,B.bQt,B.bQr,B.bZ4,B.bYZ,B.bZ0,B.bZ_,B.bZ1,B.bZ2])
x(A.uM,[B.b2_,B.bUk,B.b2f,B.b2g,B.bYl,B.bR1,B.bR0,B.bQv,B.bQw,B.bZ3])
x(A.Wv,[B.na,B.Eb,B.Gd,B.Dd])
w(B.TS,A.io)
x(A.L,[B.w5,B.Ci,B.Ch,B.Cg])
x(A.O,[B.Zb,B.a0z,B.a0y,B.a0x])
x(A.a5,[B.Ge,B.W5,B.Cy,B.agY])})()
A.xv(b.typeUniverse,JSON.parse('{"lj":{"bK":[]},"Ci":{"L":[],"l":[]},"Ch":{"L":[],"l":[]},"Cg":{"L":[],"l":[]},"TS":{"aB":[]},"w5":{"L":[],"l":[]},"Zb":{"O":["w5"]},"Ge":{"a5":[],"l":[]},"W5":{"a5":[],"l":[]},"a0z":{"O":["Ci"]},"Cy":{"a5":[],"l":[]},"a0y":{"O":["Ch"]},"a0x":{"O":["Cg"]},"agY":{"a5":[],"l":[]}}'))
var y=(function rtii(){var x=A.ak
return{u:x("qR"),c:x("ed<x>"),r:x("ce<x>"),k:x("F<mz>"),n:x("F<ed<x>>"),I:x("F<ce<x>>"),R:x("F<hz>"),Y:x("F<aR<o,@>>"),d:x("F<QZ>"),s:x("F<o>"),p:x("F<l>"),t:x("F<x>"),m:x("bP"),j:x("a7<@>"),L:x("a7<x>"),P:x("aR<o,@>"),f:x("aR<@,@>"),x:x("au<o,x>"),a:x("bE"),K:x("a4"),B:x("H7"),l:x("+(x,x)"),e:x("dc<mz>"),N:x("o"),C:x("Iv"),D:x("Iw"),X:x("TT"),_:x("Ix"),U:x("am<o>"),G:x("na"),q:x("qv"),b:x("bo<V?>"),y:x("P"),i:x("a2"),z:x("@"),S:x("x"),A:x("bP?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("fm"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.oG=new B.Eb(0,"none")
D.oH=new B.Eb(1,"learning")
D.f6=new B.Eb(2,"memorized")
D.a5j=new A.az(0,1/0,0,320)
D.eH=new A.V(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a5r=new A.E(D.eH,null,null,null,null,null,null,C.c2)
D.dS=new A.V(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.dm=new A.V(1,0.20392156862745098,0.8274509803921568,0.6,C.p)
D.apR=new A.G(C.Gq,null,C.dj,null,null,null)
D.bqX=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.hU,null,null,null,null,null,null,null,null)
D.b8U=new A.r(!0,C.fO,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bnH=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.b8U,null,null,null,null,null,null,null,null)
D.aGu=x([D.apR,C.K,D.bqX,D.bnH],y.p)
D.adm=new A.fa(C.v,C.d,C.e,C.i,null,C.l,null,0,D.aGu,null)
D.agO=new A.a0(0,26,0,26)
D.ahb=new A.a0(14,12,14,14)
D.ahR=new A.a0(3,0,0,0)
D.aln=new A.T(63251,"MaterialIcons",null,!1)
D.qa=new A.T(63677,"MaterialIcons",null,!1)
D.ame=new A.T(983443,"MaterialIcons",null,!1)
D.xr=new A.T(983516,"MaterialIcons",null,!1)
D.am7=new A.T(983209,"MaterialIcons",null,!1)
D.amN=new A.G(D.am7,28,C.A,null,null,null)
D.ano=new A.G(C.G8,null,C.ks,null,null,null)
D.al6=new A.T(62961,"MaterialIcons",null,!1)
D.ao3=new A.G(D.al6,null,null,null,null,null)
D.alm=new A.T(63199,"MaterialIcons",null,!1)
D.ao4=new A.G(D.alm,null,null,null,null,null)
D.aod=new A.G(C.kK,null,C.fO,null,null,null)
D.aog=new A.G(D.xr,44,C.h,null,null,null)
D.aoI=new A.G(D.qa,null,D.eH,null,null,null)
D.aoZ=new A.G(C.q4,null,D.eH,null,null,null)
D.apk=new A.G(D.qa,null,null,null,null,null)
D.apN=new A.G(C.jn,20,D.dS,null,null,null)
D.aq8=new A.G(C.qc,30,C.A,null,null,null)
D.alE=new A.T(63520,"MaterialIcons",null,!1)
D.aqZ=new A.G(D.alE,null,null,null,null,null)
D.ar8=new A.G(C.mU,null,null,null,null,null)
D.akY=new A.T(62842,"MaterialIcons",null,!0)
D.arl=new A.G(D.akY,null,null,null,null,null)
D.HV=x([1,3,5],y.t)
D.IH=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aSZ=new A.H(C.mF,C.oV,null)
D.aDl=x([D.aSZ],y.p)
D.aXo=new A.Z(C.xi,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.aXc=new A.Z(D.qa,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.aXJ=new A.Z(C.dq,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.alS=new A.T(63625,"MaterialIcons",null,!1)
D.aXV=new A.Z(D.alS,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aFr=x([D.aXo,D.aXc,D.aXJ,D.aXV],A.ak("F<+(T,o)>"))
D.aHO=x([D.oG,D.oH,D.f6],A.ak("F<Eb>"))
D.Nh=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aP6=new B.Gd(0,"idle")
D.Tt=new B.Gd(1,"loading")
D.jC=new B.Gd(2,"ready")
D.aP7=new B.Gd(3,"failed")
D.aoH=new A.G(C.bS,18,D.dm,null,null,null)
D.a0R=new A.r(!0,C.ar,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.brS=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,D.a0R,null,null,null,null,null,null,null,null)
D.aCd=x([D.aoH,C.b0,D.brS],y.p)
D.b2O=new A.ep(C.ae,C.d,C.e,C.i,null,C.l,null,0,D.aCd,null)
D.aRY=new A.H(C.aW,D.b2O,null)
D.ahO=new A.a0(2,6,2,4)
D.b8z=new A.r(!0,C.A,null,null,null,null,14,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgh=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.b8z,null,null,null,null,null,null,null,null)
D.aSc=new A.H(D.ahO,D.bgh,null)
D.bsf=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.hU,null,null,null,null,null,null,null,null)
D.aDF=x([K.tn,C.J,D.bsf],y.p)
D.b2J=new A.ep(C.ae,C.cH,C.e,C.i,null,C.l,null,0,D.aDF,null)
D.aSm=new A.H(C.Ee,D.b2J,null)
D.Au=new A.r(!0,D.dS,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bsz=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Au,null,null,null,null,null,null,null,null)
D.aSr=new A.H(C.dT,D.bsz,null)
D.brN=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.b2,C.a4,null,null,null,null,null,null,null)
D.aSz=new A.H(C.C,D.brN,null)
D.ahL=new A.a0(2,0,2,8)
D.bnX=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.b2,null,null,null,null,null,null,null,null)
D.aSQ=new A.H(D.ahL,D.bnX,null)
D.aqI=new A.G(C.kM,30,C.A,null,null,null)
D.btd=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Av,null,null,null,null,null,null,null,null)
D.aiW=new A.bT(1,C.ac,D.btd,null)
D.aDU=x([D.aqI,C.Y,D.aiW],y.p)
D.b2w=new A.ep(C.ae,C.d,C.e,C.i,null,C.l,null,0,D.aDU,null)
D.aqk=new A.G(C.dq,18,D.dm,null,null,null)
D.a0h=new A.r(!0,D.dm,null,null,null,null,12,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.brw=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a0h,null,null,null,null,null,null,null,null)
D.aCE=x([D.aqk,C.bU,D.brw],y.p)
D.b2H=new A.ep(C.ae,C.d,C.N,C.i,null,C.l,null,0,D.aCE,null)
D.b4W=new A.Q(0,30)
D.tm=new A.Q(1/0,54)
D.b5l=new A.Q(1/0,48)
D.b5o=new A.Q(1/0,50)
D.b5r=new A.Q(1/0,52)
D.b84=new A.r(!0,C.h,null,null,null,null,14.5,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b8k=new A.r(!0,C.h,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.Ae=new A.r(!0,D.eH,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.k_=new A.r(!0,C.h,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bbE=new A.r(!0,D.eH,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bc6=new A.r(!0,C.A,null,null,null,null,24,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bco=new A.r(!0,C.A,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bdd=new A.r(!0,D.dS,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bde=new A.r(!0,D.dm,null,null,null,null,null,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bdv=new A.r(!0,C.h,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bf9=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.hX,null,null,null,null,null,null,null,null)
D.bfT=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.dM,null,null,null,null,null,null,null,null)
D.bgj=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.o5,null,null,null,null,null,null,null,null)
D.bgn=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.b2,null,null,null,null,null,null,null,null)
D.bgM=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.b2,null,null,null,null,null,null,null,null)
D.bh9=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.hU,null,null,null,null,null,null,null,null)
D.biQ=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cz,null,null,null,null,null,null,null,null)
D.bjz=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bL,null,null,null,null,null,null,null,null)
D.bjE=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.b2,null,null,null,null,null,null,null,null)
D.bk5=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.Az,null,null,null,null,null,null,null,null)
D.bli=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.blQ=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,I.o9,null,null,null,null,null,null,null,null)
D.bmL=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Au,null,null,null,null,null,null,null,null)
D.bmW=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.b2,null,null,null,null,null,null,null,null)
D.bnm=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.c7,null,null,null,null,null,null,null,null)
D.bnF=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.b2,null,null,null,null,null,null,null,null)
D.bnY=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.b2,null,null,null,null,null,null,null,null)
D.bbk=new A.r(!0,D.eH,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bpk=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bbk,null,null,null,null,null,null,null,null)
D.bpK=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,I.o9,null,null,null,null,null,null,null,null)
D.bqg=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a_K,null,null,null,null,null,null,null,null)
D.bqu=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cz,null,null,null,null,null,null,null,null)
D.bqP=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.br6=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.brF=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.b2,null,null,null,null,null,null,null,null)
D.brG=new A.m("\u062e\u0644\u0635\u062a",null,L.An,null,null,null,null,null,null,null,null)
D.brH=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Au,null,null,null,null,null,null,null,null)
D.bsD=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.c7,null,null,null,null,null,null,null,null)
D.bsH=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.dM,null,null,null,null,null,null,null,null)
D.btc=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.b2,null,null,null,null,null,null,null,null)
D.a22=new B.agY(null)
D.bux=new B.Cg(null)
D.buy=new B.TR(2,1,!0,!1,!1)
D.a27=new B.TT(!1,!1,!1,!1,!1,0)
D.iN=new B.na(0,"ok")
D.u6=new B.na(1,"near")
D.u7=new B.na(2,"wrong")
D.u8=new B.na(3,"missing")
D.a2y=new B.na(4,"extra")
D.alA=new A.T(63456,"MaterialIcons",null,!1)
D.bzW=new B.Cy(D.dS,D.alA,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bAz=new B.W5(!1,null)
D.B5=new B.W5(!0,null)
D.lV=new B.Dd(0,"idle")
D.um=new B.Dd(1,"playing")
D.un=new B.Dd(2,"recording")
D.ox=new B.Dd(3,"thinking")
D.iU=new B.Dd(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cEB","cgf",()=>new B.agZ())
x($,"cHT","ciy",()=>A.aJ("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cHU","ciz",()=>A.aJ("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cI5","ciI",()=>A.aJ("\u0648\u0670",!0,!1,!1))
x($,"cHr","cie",()=>A.aJ("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cFN","ch4",()=>A.aJ("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cGY","chR",()=>A.aJ("[\u0654\u0655]",!0,!1,!1))
x($,"cFO","ch5",()=>A.aJ("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cFV","chb",()=>A.aJ("[\u0624\u0626]",!0,!1,!1))
x($,"cH_","chT",()=>A.aJ("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cHw","cih",()=>A.aJ("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cH7","ci_",()=>A.aJ("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cHR","c4h",()=>A.aJ("\\s+",!0,!1,!1))
x($,"cBW","qF",()=>B.cjx(D.oG,0,A.ckP(0,!0)))
x($,"cEC","Lj",()=>new B.TS($.cgf(),D.buy,B.crl(),D.aP6,$.R()))})()};
(a=>{a["dTs6O4BsjB5QBFX6hPPiIt8o4JQ="]=a.current})($__dart_deferred_initializers__);