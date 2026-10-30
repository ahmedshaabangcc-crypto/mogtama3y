((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,P,H,G,N,Q,K,B={
cE1(d){var x,w,v,u,t,s
if(d instanceof B.lL)return d
try{x=A.cU(d)
w=x.code
v=x.message
u=w==null?"failed":A.S(w)
t=v==null?"":A.S(v)
return new B.lL(u,t)}catch(s){u=A.n(d)
return new B.lL("failed",u)}},
akv:function akv(){this.b=this.a=null},
b7t:function b7t(d){this.a=d},
b7w:function b7w(){},
b7v:function b7v(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b7u:function b7u(d){this.a=d},
b7A:function b7A(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b7y:function b7y(d){this.a=d},
b7z:function b7z(d){this.a=d},
b7B:function b7B(d){this.a=d},
b7D:function b7D(d,e,f){this.a=d
this.b=e
this.c=f},
b7C:function b7C(d,e,f){this.a=d
this.b=e
this.c=f},
b7x:function b7x(){},
cE2(d,e){return new B.lL(d,e)},
Wm:function Wm(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
Kq:function Kq(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
Ks:function Ks(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
Kr:function Kr(d,e){this.a=d
this.b=e},
lL:function lL(d,e){this.a=d
this.b=e},
cq3(d){var x,w=$.cuN()
w=A.bJ(d,w,"\u0627")
x=$.cuO()
w=A.bJ(w,x,"\u064a")
x=$.cuX()
w=A.bJ(w,x,"\u0627")
x=$.cti()
w=A.bJ(w,x,"\u0627")
x=$.cut()
w=A.bJ(w,x,"\u0621")
x=$.cu5()
w=A.bJ(w,x,"\u0621")
x=$.ctj()
w=A.bJ(w,x,"\u0627")
x=$.ctp()
w=A.bJ(w,x,"\u0621")
w=A.bJ(w,"\u0649","\u064a")
w=A.bJ(w,"\u0629","\u0647")
x=$.cu7()
w=A.bJ(w,x,"")
x=$.cuw()
w=A.bJ(w,x," ")
x=$.cue()
w=A.bJ(w,x," ")
x=$.cfG()
return C.c.O(A.bJ(w,x," "))},
cIL(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.k8(x,w)
for(u=0;u<x;++u)v[u]=u
t=A.c8(x,0,!1,w)
for(s=1;s<=l;++s,r=t,t=v,v=r){t[0]=s
for(w=s-1,u=1;u<=k;++u){q=u-1
p=d.charCodeAt(w)===e.charCodeAt(q)?0:1
o=v[u]+1
n=t[q]+1
m=v[q]+p
if(o<n)q=o<m?o:m
else q=n<m?n:m
t[u]=q}}return v[k]},
c9r(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aE("[\u0627\u0621]",!0,!1,!1)
w=A.bJ(d,x,"")
x=A.aE("[\u0627\u0621]",!0,!1,!1)
v=A.bJ(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cIL(d,e)/u
return s>=1?0.99:s},
Ft(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.ua(d,$.cfG()),w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.length===0)continue
t=B.cq3(u)
s=A.bJ(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Ts(r.a+" "+u,r.b))}continue}q.push(new B.Ts(u,s))}return q},
cHq(d,e){var x,w,v,u,t=new B.c3c(),s=A.a([],y.s)
for(x=A.ff(e,0,A.ip(5,"count",y.S),A.aj(e).c),w=x.$ti,x=new A.cd(x,x.gM(0),w.i("cd<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.KE)&&t.$2(d,D.KE)?C.b.jB(d,5):d
return!t.$2(s,D.Pi)&&t.$2(u,D.Pi)?C.b.jB(u,4):u},
coZ(d,e){var x=B.Ft(d),w=B.cq3(e),v=y.U
v=A.a9(new A.ah(A.a(w.split(" "),y.s),new B.c5j(),v),v.i("Y.E"))
return new B.J2(x,B.cGB(x,B.cHq(v,x)),w)},
cGB(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.K)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.c8(x,0,!1,s)
q=A.c8(x,0,!1,y.S)
p=A.c8(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c9r(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c9r(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c9r(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.j7
else m=a2>=0.6?D.v0:D.v1
a1.push(new B.n5(o,x,s,m))
break
case 1:--o
a1.push(new B.n5(o,a4[o],null,D.v2))
break
case 2:--n
a1.push(new B.n5(null,null,a6[n],D.a4H))
break
case 3:--o
a3=n-2
a1.push(new B.n5(o,a4[o],a6[a3]+" "+a6[n-1],D.j7))
n=a3
break
default:x=o-1;--n
a1.push(new B.n5(x,a4[x],a6[n],D.j7))
o-=2
a1.push(new B.n5(o,a4[o],a6[n],D.j7))}}a4=y.e
a4=A.a9(new A.d5(a1,a4),a4.i("aW.E"))
return a4},
nM:function nM(d,e){this.a=d
this.b=e},
Ts:function Ts(d,e){this.a=d
this.b=e},
n5:function n5(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
J2:function J2(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aYs:function aYs(d){this.a=d},
aYr:function aYr(){},
c3c:function c3c(){},
c5j:function c5j(){},
cvO(d,e,f){return new B.rE(d,e,f)},
cJG(d){var x
A:{if("memorized"===d){x=D.fm
break A}if("learning"===d){x=D.po
break A}x=D.pn
break A}return x},
cr3(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cW[d-1].a[1]},
cE3(){var x=y.S
return new B.akw(A.C(x,y.u),A.aT(x))},
b7G(d){var x=d.f0()
return C.c.dt(C.j.k(A.br(x)),4,"0")+"-"+C.c.dt(C.j.k(A.bt(x)),2,"0")+"-"+C.c.dt(C.j.k(A.bY(x)),2,"0")},
clS(d){var x=y.x,w=A.a9(new A.au(A.a(d.split("-"),y.s),A.cL6(),x),x.i("aW.E"))
return B.b7G(A.dx(w[0],w[1],w[2]-1,12,0,0,0))},
ccF(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.C(p,y.u),n=A.aT(p),m=new B.akw(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcP(),x=x.ga_(x),w=y.j;x.v();){v=x.gG()
u=A.dW(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aO(t)>=3){v=C.j.aI(u,1000)
s=C.j.a3(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cW[v-1].a[1])}if(v)continue
v=J.bc(t)
r=C.f.bB(A.cS(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rE(D.aMl[r],C.f.bB(A.cS(v.h(t,1))),new A.aP(A.kB(C.f.bB(A.cS(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aBX(q,y.o)
p=A.my(x,new B.b7F(),x.$ti.i("Y.E"),p)
n.A(0,new A.ah(p,o.ga4t(),A.y(p).i("ah<Y.E>")))}m.c=A.q(d.h(0,"last"))
p=A.ar(d.h(0,"streak"))
p=p==null?null:C.f.bB(p)
p=m.d=p==null?0:p
o=A.ar(d.h(0,"best"))
o=o==null?null:C.f.bB(o)
m.e=o==null?p:o
return m},
aBd(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dt(C.j.k(d),3,"0")+C.c.dt(C.j.k(e),3,"0")+".mp3"},
FN:function FN(d,e){this.a=d
this.b=e},
rE:function rE(d,e,f){this.a=d
this.b=e
this.c=f},
akw:function akw(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b7H:function b7H(){},
b7I:function b7I(){},
b7F:function b7F(){},
Wk:function Wk(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cBu(){return new B.x8(null)},
cNx(d,e){var x,w,v,u,t={},s=I.cW[e-1].a[1],r=$.Nx().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.rt():v).a===D.fm}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d1(u+4,1,s)
return A.e2(C.cT,new B.c84(t,s,e),d,!0,null,null,!1,y.l)},
ces(d){return A.ds(0,0,0,0,0,C.j.d1(C.f.ak(6+d*1.2),25,90))},
cdm(d){return E.bq(C.j.aI(d,60))+":"+C.c.dt(E.bq(C.j.a3(d,60)),2,"\u0660")},
cqQ(d){return A.e2(C.cT,new B.c91($.Nx()),d,!0,null,null,!1,y.H)},
Nq(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl8()
break A}return x},
cOT(d,e,f){var x,w=new B.c9k(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
cqZ(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.ap.f3(a4,null))
s=y.Y
r=s.a(J.as(x,"rec"))
w=r==null?C.cN:r
q=s.a(J.as(x,"last"))
v=q==null?C.cN:q
u=new B.c9j()
s=J.as(v,"recovered")
t=A.n(s==null?"":s)
s=A.n(u.$1(J.as(w,"wall")))
p=A.n(u.$1(J.as(w,"source")))
o=A.n(u.$1(J.as(w,"ctxRate")))
n=A.n(u.$1(J.as(w,"pcmPeak")))
m=A.n(u.$1(J.as(w,"ctxState")))
l=A.n(u.$1(J.as(w,"stopMs")))
k=A.n(u.$1(J.as(v,"prepMs")))
j=A.n(u.$1(J.as(v,"ms")))
i=A.n(u.$1(J.as(v,"featMs")))
h=A.n(u.$1(J.as(v,"encMs")))
g=A.n(u.$1(J.as(v,"decMs")))
f=A.n(u.$1(J.as(v,"wallMs")))
e=A.n(u.$1(J.as(v,"backend")))
d=A.n(u.$1(J.as(v,"threads")))
a0=J.aO(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.k(J.as(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.k(J.as(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
I_:function I_(d,e){this.a=d
this.b=e},
Wl:function Wl(d,e,f,g,h){var _=this
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
_.q$=h
_.T$=_.R$=0},
b7J:function b7J(d){this.a=d},
b7K:function b7K(d){this.a=d},
b7L:function b7L(d){this.a=d},
x8:function x8(d){this.a=d},
a0V:function a0V(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bMU:function bMU(d){this.a=d},
bMT:function bMT(d,e){this.a=d
this.b=e},
bMV:function bMV(d){this.a=d},
bMS:function bMS(d,e){this.a=d
this.b=e},
bMW:function bMW(){},
bMG:function bMG(){},
bMM:function bMM(d,e,f){this.a=d
this.b=e
this.c=f},
bMN:function bMN(){},
bMQ:function bMQ(d){this.a=d},
bMP:function bMP(){},
bMR:function bMR(d){this.a=d},
bMJ:function bMJ(d,e){this.a=d
this.b=e},
bMK:function bMK(d){this.a=d},
bMI:function bMI(){},
bML:function bML(d){this.a=d},
bMH:function bMH(d){this.a=d},
bMO:function bMO(d,e){this.a=d
this.b=e},
I0:function I0(d,e,f){this.c=d
this.d=e
this.a=f},
YH:function YH(d,e){this.c=d
this.a=e},
c84:function c84(d,e,f){this.a=d
this.b=e
this.c=f},
c81:function c81(d,e,f){this.a=d
this.b=e
this.c=f},
c83:function c83(d,e){this.a=d
this.b=e},
c80:function c80(d,e){this.a=d
this.b=e},
c8_:function c8_(d,e){this.a=d
this.b=e},
c82:function c82(d,e){this.a=d
this.b=e},
c7W:function c7W(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c7V:function c7V(d,e,f){this.a=d
this.b=e
this.c=f},
c7X:function c7X(d){this.a=d},
c7Y:function c7Y(d){this.a=d},
c7Z:function c7Z(d,e){this.a=d
this.b=e},
EJ:function EJ(d,e){this.a=d
this.b=e},
DG:function DG(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a3s:function a3s(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
c_x:function c_x(){},
c_N:function c_N(d,e){this.a=d
this.b=e},
c_R:function c_R(d){this.a=d},
c_S:function c_S(d){this.a=d},
c_T:function c_T(d,e,f){this.a=d
this.b=e
this.c=f},
c_V:function c_V(d){this.a=d},
c_W:function c_W(d){this.a=d},
c_U:function c_U(){},
c_Y:function c_Y(d){this.a=d},
c_X:function c_X(d){this.a=d},
c_Z:function c_Z(d,e){this.a=d
this.b=e},
c00:function c00(d){this.a=d},
c01:function c01(d){this.a=d},
c0_:function c0_(){},
c_M:function c_M(d,e,f){this.a=d
this.b=e
this.c=f},
c_O:function c_O(d,e,f){this.a=d
this.b=e
this.c=f},
c_F:function c_F(d){this.a=d},
c_G:function c_G(d){this.a=d},
c_E:function c_E(){},
c_H:function c_H(){},
c_I:function c_I(d,e){this.a=d
this.b=e},
c06:function c06(d){this.a=d},
c07:function c07(d){this.a=d},
c08:function c08(d,e){this.a=d
this.b=e},
c05:function c05(d){this.a=d},
c09:function c09(d,e){this.a=d
this.b=e},
c_L:function c_L(){},
c_K:function c_K(d){this.a=d},
c_J:function c_J(d,e){this.a=d
this.b=e},
c_Q:function c_Q(d){this.a=d},
c_P:function c_P(d){this.a=d},
c02:function c02(){},
c03:function c03(){},
c04:function c04(){},
c_y:function c_y(d,e,f){this.a=d
this.b=e
this.c=f},
c_z:function c_z(d){this.a=d},
c_B:function c_B(){},
c_A:function c_A(){},
c_C:function c_C(d){this.a=d},
c_D:function c_D(d){this.a=d},
DZ:function DZ(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
DF:function DF(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a3r:function a3r(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
c_g:function c_g(){},
c_p:function c_p(d,e){this.a=d
this.b=e},
c_q:function c_q(d){this.a=d},
c_o:function c_o(){},
c_s:function c_s(d){this.a=d},
c_r:function c_r(d,e){this.a=d
this.b=e},
c_t:function c_t(d,e){this.a=d
this.b=e},
c_k:function c_k(d,e){this.a=d
this.b=e},
c_l:function c_l(d,e,f){this.a=d
this.b=e
this.c=f},
c_m:function c_m(d,e,f){this.a=d
this.b=e
this.c=f},
c_h:function c_h(d,e,f){this.a=d
this.b=e
this.c=f},
c_i:function c_i(d,e,f){this.a=d
this.b=e
this.c=f},
c_j:function c_j(d,e){this.a=d
this.b=e},
c_n:function c_n(d){this.a=d},
c_u:function c_u(){},
c_v:function c_v(d,e){this.a=d
this.b=e},
c_w:function c_w(d,e){this.a=d
this.b=e},
DE:function DE(d){this.a=d},
a3q:function a3q(d){this.d=d
this.c=this.a=null},
c_7:function c_7(){},
c_e:function c_e(d){this.a=d},
c_f:function c_f(){},
c_d:function c_d(d,e){this.a=d
this.b=e},
c_c:function c_c(d,e,f){this.a=d
this.b=e
this.c=f},
c_b:function c_b(d,e,f){this.a=d
this.b=e
this.c=f},
c_a:function c_a(d){this.a=d},
c_8:function c_8(d){this.a=d},
c_9:function c_9(d){this.a=d},
c91:function c91(d){this.a=d},
c90:function c90(d){this.a=d},
c8W:function c8W(d,e){this.a=d
this.b=e},
c8Y:function c8Y(){},
c8X:function c8X(){},
c8Z:function c8Z(d,e){this.a=d
this.b=e},
c9_:function c9_(d,e){this.a=d
this.b=e},
aku:function aku(d){this.a=d},
b7s:function b7s(d){this.a=d},
c9k:function c9k(){},
c9l:function c9l(){},
DH:function DH(d,e,f){this.c=d
this.d=e
this.a=f},
a3t:function a3t(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
c0a:function c0a(d){this.a=d},
c0b:function c0b(d){this.a=d},
c0c:function c0c(d,e){this.a=d
this.b=e},
c0d:function c0d(d){this.a=d},
c0f:function c0f(d){this.a=d},
c0e:function c0e(d){this.a=d},
c9j:function c9j(){}},D,R,O,I,E,F
J=c[1]
A=c[0]
C=c[2]
L=c[15]
M=c[19]
P=c[21]
H=c[13]
G=c[32]
N=c[31]
Q=c[10]
K=c[37]
B=a.updateHolder(c[8],B)
D=c[38]
R=c[29]
O=c[35]
I=c[27]
E=c[16]
F=c[18]
B.akv.prototype={
rh(){var x=this,w=x.a
if(w!=null)return A.eq(w,y.m)
w=x.b
return w==null?x.b=new B.b7t(x).$0():w},
uD(d,e){return this.aOM(d,e,e)},
aOM(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
var $async$uD=A.e(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$uD)
case 7:r=h
v=r
x=1
break
u=2
x=6
break
case 4:u=3
p=t.pop()
s=A.a8(p)
r=B.cE1(s)
throw A.t(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$uD,w)},
ou(d,e){var x=A.en(d[e])
if(x==null)x=null
return x===!0},
Na(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$Na=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.rh(),$async$Na)
case 7:r=h.cU(g.cP(e,"support",null,null,null,null))
q=s.ou(r,"worker")
p=s.ou(r,"wasm")
o=s.ou(r,"mic")
n=s.ou(r,"audio")
s.ou(r,"webgpu")
m=s.ou(r,"secure")
s.ou(r,"ios")
l=A.jV(r.memory)
if(l==null)l=null
if(l==null)l=0
s.ou(r,"isolated")
k=A.jV(r.cores)
if(k!=null)C.f.ak(k)
v=new B.Wm(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a4g
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Na,w)},
EJ(){var x=0,w=A.j(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$EJ=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.rh(),$async$EJ)
case 8:x=7
return A.c(m.eH(l.cU(k.cP(e,"storage",null,null,null,null)),y.A),$async$EJ)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.ak(A.dU(r.quota))
p=C.f.ak(A.dU(r.usage))
v=new A.auE(q,p)
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
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$EJ,w)},
blk(){var x=y.K
A.Qo(this.rh().bJ(new B.b7w(),x),x)},
rg(d,e){var x=A.jV(d[e])
x=x==null?null:C.f.ak(x)
return x==null?0:x},
biI(d,e,f){return this.uD(new B.b7v(this,d,e,f),y.C)},
galw(){var x,w
try{x=A.ks(b.G.sessionStorage)
return x}catch(w){return null}},
gat7(){var x=A.en(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a9L(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.en(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gat7())return!1
l=A.en(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cU(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.S(x.userAgent)
l=A.jV(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.q(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aE("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.k(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aE("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.jV(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.galw()
l=l==null?f:A.q(A.cP(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dW(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.ks(m.localStorage)
m=o
m=m==null?f:A.q(A.cP(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dW(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
arE(){var x,w,v,u,t,s,r=null
try{x=this.galw()
if(x!=null)A.cP(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cU(x.location)
u=A.S(v.hash)
t=A.S(v.search)
s=A.bx(A.S(A.cU(x.document).baseURI),0,r).a2("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cP(v,"replace",s+t+x,r,r,r)},
biq(){var x,w=null,v=b.G,u=A.cU(v.history),t=A.jV(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cP(u,"back",w,w,w,w)
else{x=A.S(A.cU(v.document).baseURI)
A.cP(A.cU(v.location),"replace",A.bx(x,0,w).a2("./").k(0)+"#/",w,w,w)}},
a9X(d,e,f,g,h){return this.uD(new B.b7A(this,e,d,f,h,g),y.H)},
aa0(){return this.uD(new B.b7B(this),y.D)},
a46(){var x=null,w=this.a
if(w!=null)A.cP(w,"cancelRecording",x,x,x,x)},
amW(d){var x,w,v=this,u=A.q(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.rg(d,"ms")
w=A.jV(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.Ks(u,x,w,v.rg(d,"frames"),v.rg(d,"tokens"),v.ou(d,"retried"),v.rg(d,"encMs"),v.rg(d,"decMs"),v.rg(d,"featMs"))},
ajf(d){var x={}
x.words=d
return x},
awe(d,e){return this.uD(new B.b7D(this,d,e),y._)},
bnw(d,e){return this.uD(new B.b7C(this,d,e),y._)},
Le(d,e){return this.blq(d,e)},
blq(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Le=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.rh(),$async$Le)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.aj(d).i("au<1,o>")
o=A.a9(new A.au(d,new B.b7x(),o),o.i("aW.E"))
x=11
return A.c(A.eH(A.cU(A.cP(r,"play",o,e,null,null)),y.y),$async$Le)
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
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Le,w)},
MS(){var x=null,w=this.a
if(w!=null)A.cP(w,"stopPlayback",x,x,x,x)},
JI(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.S(A.cP(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bmG(){var x,w,v=null
try{x=this.a
if(x!=null)A.cP(x,"resetDevice",v,v,v,v)}catch(w){}},
a7m(d){var x=this.a
if(x!=null)A.cP(x,"prefetch",d,null,null,null)}}
B.Wm.prototype={}
B.Kq.prototype={
gn6(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.Ks.prototype={
gTm(){var x=this,w=C.f.aA(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.Kr.prototype={}
B.lL.prototype={
gl8(){var x,w=this.a
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
k(d){return"TutorError("+this.a+": "+this.b+")"},
$ibK:1}
B.nM.prototype={
S(){return"WordStatus."+this.b}}
B.Ts.prototype={}
B.n5.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.J2.prototype={
gMQ(){var x,w=this,v=w.d
if(v===$){x=new B.aYs(w).$0()
w.d!==$&&A.aq()
w.d=x
v=x}return v},
gK1(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.d===D.a4H&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbjz(){return J.h8(this.gMQ(),new B.aYr()).gM(0)},
gtE(){var x=this.a
return x.length!==0&&this.gbjz()===x.length&&this.gK1().length===0}}
B.FN.prototype={
S(){return"AyahStatus."+this.b}}
B.rE.prototype={}
B.akw.prototype={
a6Y(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.rt():x},
b0G(d){var x=this,w=B.b7G(d),v=x.c
if(v===w)return
v=v!=null&&v===B.clS(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
aqO(){var x=Date.now(),w=B.b7G(new A.aP(x,0,!1))
x=this.c
return x===w||x===B.clS(w)?this.d:0},
avf(d,e,f,g){var x=this,w=new A.aP(Date.now(),0,!1),v=x.a6Y(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.fm:D.po,s=new B.rE(t,u,w.h6()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.b0G(w)
return s},
a6Q(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cW[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rt():s).a===D.fm)++u}return u},
bio(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cW[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rt():s).a===D.po)++u}return u},
gaue(){var x=this.a,w=A.y(x).i("c3<2>")
return new A.ah(new A.c3(x,w),new B.b7H(),w.i("ah<Y.E>")).gM(0)},
gazS(){var x=this.a,w=A.y(x).i("bM<1>")
w=A.my(new A.bM(x,w),new B.b7I(),w.i("Y.E"),y.S)
w=A.eT(w,A.y(w).i("Y.E"))
x=A.a9(w,A.y(w).c)
C.b.lG(x)
return x},
du(){var x,w,v,u,t,s=this,r=y.N,q=A.C(r,y.L)
for(x=s.a,x=new A.eA(x,A.y(x).i("eA<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.a9(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
beg(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b62(x,300,A.y(x).c),x=new A.K6(J.av(x.a),x.b,A.y(x).i("K6<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gG()
s=C.j.aI(t,1000)
t=C.j.a3(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.rt():q).a===D.fm?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.rt()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.rt():r).c.iG()],w,v))}return o},
bj_(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.K)(d),++u){t=d[u]
s=A.ey(t.h(0,"surah"))*1000+A.ey(t.h(0,"ayah"))
r=w.h(0,C.j.aI(s,1000)*1000+C.j.a3(s,1000))
if((r==null?$.rt():r).c.iG()===t.h(0,"updated_at"))v.K(0,s)}},
bj7(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.av(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gG()
if(!u.b(s))continue
r=A.ar(s.h(0,"surah"))
q=r==null?null:C.f.bB(r)
r=A.ar(s.h(0,"ayah"))
p=r==null?null:C.f.bB(r)
o=A.dJ(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cW[q-1].a[1])
if(r)continue
n=B.cJG(s.h(0,"status"))
if(n===D.pn)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.ar(s.h(0,"perfect_count"))
l=l==null?null:C.f.bB(l)
v.p(0,r,new B.rE(n,C.j.d1(l==null?0:l,0,100),o.h6()))
w.K(0,r)
t=!0}return t}}
B.Wk.prototype={
Jr(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Wk(w,v,u,t,f==null?x.e:f)},
bct(d){var x=null
return this.Jr(x,x,d,x,x)},
aqj(d){var x=null
return this.Jr(x,d,x,x,x)},
bcx(d){var x=null
return this.Jr(x,x,x,x,d)},
bbQ(d){var x=null
return this.Jr(d,x,x,x,x)},
bcu(d){var x=null
return this.Jr(x,x,x,d,x)},
du(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.I_.prototype={
S(){return"ModelState."+this.b}}
B.Wl.prototype={
vO(){var x=this.Q
return x==null?this.Q=new B.b7J(this).$0():x},
qQ(d){return this.ay4(d)},
ay4(d){var x=0,w=A.j(y.H),v=this
var $async$qQ=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a5()
x=2
return A.c(A.iq("mt.tutor.settings",C.ap.hl(d.du(),null)),$async$qQ)
case 2:return A.h(null,w)}})
return A.i($async$qQ,w)},
A2(){var x=0,w=A.j(y.H),v=this,u
var $async$A2=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a5()
x=2
return A.c(A.iq("mt.tutor.progress",C.ap.hl(v.c.du(),null)),$async$A2)
case 2:u=v.as
if(u!=null)u.au()
v.as=A.cQ(C.x,v.gaEX())
return A.h(null,w)}})
return A.i($async$A2,w)},
MA(d,e,f){return this.ayS(d,e,f)},
ayS(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$MA=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.aZ(d,e,f)
x=2
return A.c(A.iq("mt.tutor.last",C.ap.hl(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$MA)
case 2:return A.h(null,w)}})
return A.i($async$MA,w)},
Dr(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Dr=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.Vy||n===D.k0){x=1
break}s.f=D.Vy
s.y=null
s.a5()
u=4
n=A.lM().geK().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lM().geK().h(0,"tutor_threads")
p=A.dW(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.biI(new B.b7K(s),n,p),$async$Dr)
case 7:s.x=e
s.f=D.k0
n=A.lM().geK().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.ro().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a8(m)
if(n instanceof B.lL){q=n
s.f=D.aU0
s.y=q
n=A.lM().geK().h(0,"debug")
if(n==="1")A.ro().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a5()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Dr,w)},
wL(){var x=0,w=A.j(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wL=A.e(function(a0,a1){if(a0===1){t.push(a1)
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
return A.c(p.aS("quran_tutor_progress").d9("surah, ayah, status, perfect_count, updated_at"),$async$wL)
case 7:o=a1
n=r.c.bj7(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.beg()
if(J.aO(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.nd(h.x,k,k))
x=11
return A.c(f.bn4("quran_tutor_save",!1,g,i),$async$wL)
case 11:r.c.bj_(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.iq("mt.tutor.progress",C.ap.hl(r.c.du(),null)),$async$wL)
case 12:if(n)r.a5()
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
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$wL,w)},
Lv(d){return this.bmI(d)},
bmI(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Lv=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.ccF(t.c.du()).du()
y.f.a(p.h(0,"rows")).en(0,new B.b7L(d))
t.c=B.ccF(p)
x=2
return A.c(t.A2(),$async$Lv)
case 2:v=4
s=$.D().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.ar("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$Lv)
case 9:case 8:v=1
x=6
break
case 4:v=3
o=u.pop()
x=6
break
case 3:x=1
break
case 6:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Lv,w)}}
B.x8.prototype={
N(){var x=$.Nx()
return new B.a0V(x,new A.ai(C.L,$.X()))}}
B.a0V.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goG())
w=y.a
x.vO().bJ(new B.bMU(v),w)
H.aWV().bJ(new B.bMV(v),w).fB(new B.bMW())
A.Qo(H.cc0(),y.y)},
y_(){if(this.c!=null)this.j(new B.bMG())},
m(){var x,w=this
w.d.U(w.goG())
x=w.e
x.q$=$.X()
x.L$=0
w.a0()},
Qj(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$Qj=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qQ(s.b.bct(!0)),$async$Qj)
case 3:t=s.a
t.blk()
if(t.a9L()){t.arE()
x=1
break}s.Dr()
case 1:return A.h(v,w)}})
return A.i($async$Qj,w)},
y0(d,e,f){return this.aZr(d,e,f)},
b7u(d){return this.y0(d,null,null)},
aZr(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$y0=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.H(y.q).f.Z(A.aM(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.V(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cNx(s,d),$async$y0)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.MA(d,t.a,t.b),$async$y0)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aE(A.aF(new B.bMM(u,d,t),null,r),r),$async$y0)
case 8:if(u.c!=null)u.j(new B.bMN())
case 1:return A.h(v,w)}})
return A.i($async$y0,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gat7()&&!A.O(d,!1).vl())u.push(A.bP(x,x,x,x,C.yV,x,x,t.gbip(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bP(x,x,x,x,D.av_,x,x,new B.bMQ(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bP(x,x,x,x,C.iz,x,x,new B.bMR(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aHM
else w=t?this.aUc():this.aUO()
return L.xW(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aUO(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a4g
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b88,C.a1],x)
for(t=0;t<4;++t){s=D.aJW[t]
u.push(new A.B(C.bs,A.z(A.a([A.aX(s.a,C.ao,p,18),C.O,new A.bV(1,C.af,A.d(s.b,p,p,p,p,p,G.a1N,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bzy,C.G,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bq(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,p,F.aO,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bq(C.f.ak(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.G,A.d(q,p,p,p,p,p,A.bB(p,p,r?D.e3:C.cM,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.G,D.byz],x))
x=A.a([new E.dE(u,C.a5,C.aL,p,!0,p),new E.dE(A.I(s,C.q,C.d,C.e,0,C.l),C.a5,C.aL,p,!1,p),D.bIa,C.G],x)
if(v!=null)x.push(new E.dE(A.d(v,p,p,p,p,p,D.bjp,p,p,p),C.a5,C.aL,p,!1,p))
else x.push(A.fq(D.arR,D.bpg,this.gaZJ(),A.et(C.t,C.ah,D.bba,p,p,p,p)))
x.push(C.a4)
x.push(D.a4c)
return x},
aUc(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.O(r.a.a),p=q.length===0,o=p?C.rK:H.cqJ(q),n=t.z,m=A.R(v.amc(C.d8,E.bq(s.gaue())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bq(s.aqO()),k=s.c,j=Date.now()
k=k===B.b7G(new A.aP(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.I0(t,!1,u),A.z(A.a([m,C.O,A.R(v.amc(C.li,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.v],j)
if(n!=null){t=H.ku(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bq(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bq(m)+"\u2013"+E.bq(l)
k.push(new E.dE(A.z(A.a([D.au5,C.Y,A.R(A.I(A.a([D.bln,A.d(t+" \u2014 "+m,u,u,u,u,u,C.bA,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nK],j),C.h,C.d,C.e,0,u,u),C.a5,C.aL,new B.bMJ(v,n),!0,u))}t=C.i.aa(0.08)
k.push(A.aH(u,C.y,!1,u,!0,C.m,u,A.aJ(),r,u,u,u,u,u,2,A.cI(u,new A.cm(4,A.v(14),C.K),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.ux,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.r5,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bMK(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.d_,!0,C.u,u,C.E,u,u,u,u))
k.push(C.v)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.buB)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.K)(o),++x)t.push(v.RE(o[x]))
C.b.A(k,t)}else{t=A.a([D.aXm,D.aY5,v.RE(1)],j)
for(w=114;w>=78;--w)t.push(v.RE(w))
t.push(C.G)
r=v.f
p=A.aX(r?C.yy:C.lg,C.ao,u,u)
t.push(A.fg(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,u,C.fe,u,u,u),new B.bML(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.RE(w))
C.b.A(k,t)}k.push(C.a1)
k.push(D.CD)
return k},
amc(d,e,f){var x=null,w=y.p
return new E.dE(A.z(A.a([A.aX(d,C.t,x,x),C.O,A.R(A.I(A.a([A.d(e,x,x,x,x,x,C.bA,x,x,x),A.d(f,x,1,C.N,x,x,C.a2r,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a5,C.I,x,!1,x)},
RE(d){var x,w=null,v=this.d.c,u=I.cW[d-1].a[1],t=v.a6Q(d),s=t/u,r=y.p,q=A.am(A.dz(C.P,A.a([A.cam(C.eC,G.cU,w,w,w,w,w,3,s,w),A.d(E.bq(d),w,w,w,w,w,P.a2O,w,w,w)],r),C.m,C.bm,w),36,36),p=A.d(H.ku(d),w,w,w,w,w,D.be9,w,w,w)
if(t===0)x=E.bq(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bq(t)+" \u0645\u0646 "+E.bq(u)
r=A.a([q,C.cv,A.R(A.I(A.a([p,A.d(x,w,w,w,w,w,A.bB(w,w,t===u?G.cU:C.cM,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bq(C.f.ak(s*100))+"\u066a",w,w,w,w,w,D.a2h,w,w,w))
r.push(D.arZ)
return new E.dE(A.z(r,C.h,C.d,C.e,0,w,w),C.ql,C.d6,new B.bMO(this,d),!1,w)}}
B.I0.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aX6
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.Nq(x),r,r,r,r,r,D.BO,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.DH(w,"model load",r))
x.push(C.G)
x.push(new A.Ag(C.a51,!1,q.gbiH(),r,r,r,r,C.k,r,!1,r,!0,r,C.mg,r))
return new E.dE(A.I(x,C.q,C.d,C.e,0,C.l),C.a5,C.aL,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bq(C.f.ak(u/1e6))+" \u0645\u0646 "+E.bq(C.f.ak(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,r,C.oR,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fa(x,A.qk(C.eC,C.t,7,s?t:r,r),C.aB)],w)
if(!this.d)C.b.A(x,A.a([C.G,D.bq5],w))
return new E.dE(A.I(x,C.q,C.d,C.e,0,C.l),C.a5,C.aL,r,!1,r)}}}
B.YH.prototype={
t(d){var x=null,w=D.e3.aa(0.1),v=A.v(14),u=A.aI(D.e3.aa(0.4),1)
return A.E(x,A.z(A.a([D.atK,C.O,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,x,C.BV,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.F(w,x,u,v,x,x,x,C.n),x,x,x,C.aL,C.ae,x,x,x)}}
B.EJ.prototype={
S(){return"_Phase."+this.b}}
B.DG.prototype={
N(){return new B.a3s($.Nx(),D.my)}}
B.a3s.prototype={
gjg(){var x=this.e
return x===$?this.e=this.a.d:x},
gC0(){var x,w=this.a,v=w.f
w=w.c
x=this.gjg()
return H.No(w,x,v.yd(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.ac(w.goG())
x.vO()
x.a.a7m(B.aBd(w.a.c,w.gjg()))},
y_(){if(this.c!=null)this.j(new B.c_x())},
m(){var x,w=this,v=w.d
v.U(w.goG())
x=w.Q
if(x!=null)x.au()
v=v.a
v.MS()
v.a46()
w.a0()},
a_F(d){var x,w,v=this
if(v.f===D.vh)v.d.a.a46()
x=v.d.a
x.MS()
w=v.Q
if(w!=null)w.au()
v.j(new B.c_N(v,d))
x.a7m(B.aBd(v.a.c,d))
w=v.a
if(d<w.e)x.a7m(B.aBd(w.c,d+1))},
RW(d){return this.aVG(d)},
aVG(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$RW=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.vg){u.d.a.MS()
u.j(new B.c_R(u))
x=1
break}t=u.r!=null?D.je:D.my
u.j(new B.c_S(u))
s=u.d
r=A.a([B.aBd(u.a.c,u.gjg())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.Le(r,q),$async$RW)
case 3:p=f
if(u.c==null||u.f!==D.vg){x=1
break}u.j(new B.c_T(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$RW,w)},
QJ(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$QJ=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.k0){x=1
break}p=l.a
p.MS()
r=B.Ft(s.gC0()).length
s.j(new B.c_V(s))
o=s.Q
if(o!=null)o.au()
s.Q=A.he(C.eZ,new B.c_W(s))
u=4
o=B.ces(r)
n=A.ds(0,0,0,350*r,0,0)
x=7
return A.c(p.a9X(l.b.c,o,n,new B.c_X(s),new B.c_Y(s)),$async$QJ)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lL){q=l
l=s.Q
if(l!=null)l.au()
if(s.c!=null)s.j(new B.c_Z(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$QJ,w)},
BV(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$BV=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.vh){x=1
break}m=s.Q
if(m!=null)m.au()
s.j(new B.c00(s))
s.Q=A.he(C.iu,new B.c01(s))
l=new A.D7()
$.Fw()
l.op()
r=l
u=4
m=s.d.a
x=7
return A.c(m.aa0(),$async$BV)
case 7:q=e
if(q.b<0.8){s.b7t("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.awe(q,B.Ft(s.gC0()).length),$async$BV)
case 8:p=e
s.ch=A.ds(0,0,r.ga5p(),0,0,0)
k=A.lM().geK().h(0,"debug")
if(k==="1"){o=B.cqZ(m.JI())
A.ro().$1("[tutor] "+s.a.c+":"+s.gjg()+" audio="+C.f.aA(q.b,1)+"s infer="+p.b+"ms total="+r.gCN()+"ms "+p.gTm()+" text="+p.a)
A.ro().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.aA(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aA(p.b/1000,2)+" \u062b\n"+p.gTm()+"\n"+A.n(o)+"\n"+p.a}s.age(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lL){n=m
m=A.lM().geK().h(0,"debug")
if(m==="1")A.ro().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.JI())
s.a2W(B.Nq(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$BV,w)},
a2W(d,e){var x=this,w=x.Q
if(w!=null)w.au()
if(x.c==null)return
x.j(new B.c_M(x,d,e))},
b7t(d){return this.a2W(d,null)},
age(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.au()
if(s.c==null)return
x=B.coZ(s.gC0(),d)
r.a=null
if(C.c.O(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjg()
t=x.gtE()
r.a=w.avf(v,u,q.b.a,t)
q.A2()}s.j(new B.c_O(r,s,x))},
Oj(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$Oj=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.k0){x=1
break}s.j(new B.c_F(s))
l=s.Q
if(l!=null)l.au()
s.Q=A.he(C.iu,new B.c_G(s))
k=new A.D7()
$.Fw()
k.op()
r=k
u=4
l=g.a
x=7
return A.c(l.bnw(B.aBd(s.a.c,s.gjg()),B.Ft(s.gC0()).length),$async$Oj)
case 7:q=e
p=B.cqZ(l.JI())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.aA(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aA(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.aA(r.gCN()/1000,2)+" \u062b)\n"+q.gTm()+"\n"+A.n(p)+"\n"+q.a
A.ro().$1("[tutor-debug] "+s.a.c+":"+s.gjg()+" audio="+C.f.aA(q.c,1)+"s infer="+q.b+"ms total="+r.gCN()+"ms "+q.gTm()+" text="+q.a)
A.ro().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.ds(0,0,r.ga5p(),0,0,0)
s.age(q.a)
n=s.r
if(n!=null){l=n.gtE()
j=n.b
i=A.aj(j).i("ah<1>")
j=A.a9(new A.ah(j,new B.c_H(),i),i.i("Y.E"))
A.ro().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.c_I(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lL){m=l
A.ro().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.JI())
s.a2W(B.Nq(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Oj,w)},
ga1E(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.rt():v).a!==D.fm)return!1}return!0},
t(d){var x,w=this,v=null,u=w.d,t=u.c.a6Y(w.a.c,w.gjg()),s=u.b,r=s.d&&!w.x&&w.f!==D.je,q=H.ku(w.a.c),p=y.p,o=A.a([A.bP(v,v,v,v,C.iz,v,v,new B.c06(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aLV(),m=A.d("\u0622\u064a\u0629 "+E.bq(w.gjg()),v,v,v,v,v,C.md,v,v,v),l=E.bq(w.gjg()-w.a.d+1),k=w.a
s=A.a([A.z(A.a([m,C.aV,A.d("("+l+" \u0645\u0646 "+E.bq(k.e-k.d+1)+")",v,v,v,v,v,F.aO,v,v,v),C.bD,w.b_v(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.v],p)
if(r)s.push(w.aU7())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.vh&&l!==D.pe}else l=!1
if(l)s.push(w.aJy(m))
else s.push(A.d(w.gC0()+" \ufd3f"+E.bq(w.gjg())+"\ufd3e",v,v,v,v,v,D.ko,C.Z,C.b6,v))}s=A.a([new B.I0(u,!0,v),n,C.B,new E.dE(A.I(s,C.ad,C.d,C.e,0,C.l),D.akF,C.aL,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.je)s.push(w.b8Y(n))
if(w.r!=null&&w.f===D.je&&w.ch!=null){x=C.f.ak(C.j.aI(w.ch.a,1000)/100)
s.push(new A.B(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bq(C.j.aI(x,10))+"\u066b"+E.bq(C.j.a3(x,10)))+" \u062b",v,v,v,v,v,F.aO,C.Z,v,v),v))}n=w.as
if(n!=null)s.push(new A.B(C.aL,A.d(n,v,v,v,v,v,D.BO,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.DH(n,"check "+w.a.c+":"+w.gjg(),v))}s.push(w.aK8())
s.push(C.a1)
s.push(A.iz(C.t,C.I,v,new B.c07(w),D.bn1,D.bsj,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga1E()
s.push(new E.dE(A.z(A.a([D.aqq,C.Y,A.R(A.I(A.a([D.btY,A.d(w.ga1E()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,v,F.aO,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nK],p),C.h,C.d,C.e,0,v,v),C.a5,C.aL,new B.c08(w,d),n,v))}n=A.lM().geK().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.df(D.arQ,D.brM,u.f===D.k0&&w.f!==D.pe?w.gaKS():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.B(C.hP,A.xv(n,F.aO,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn6()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,v,F.aO,v,v,v))}p.push(A.bd(D.bt6,v,v,v,new B.c09(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.CD)
return L.xW(o,s,q)},
aLV(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.am(A.ft(new B.c_K(this),w,null,C.ac,new B.c_L()),36,null)},
b_v(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fm)return D.b8l
x=d.b
w=E.bq(x)
v=E.bq(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c1:C.qV
u.push(new A.B(D.alp,A.aX(r,s?G.cU:C.eX,q,16),q))}return A.Kk(A.z(u,C.h,C.d,C.J,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aU7(){var x=null
return A.bu(!1,A.v(12),!0,A.E(x,D.agq,C.k,x,x,new A.F(C.pQ,x,x,A.v(12),x,x,x,C.n),x,x,x,x,D.akc,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.c_Q(this),x,x,x,x,x,x,x)},
aJy(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.as(d.gMQ(),w)
A:{if(D.j7===v){u=D.ko.cv(G.cU)
break A}if(D.v0===v){u=D.ko.a4J(D.e3,C.fN,D.e3)
break A}if(D.v1===v){u=D.ko.a4J(D.eW,C.fN,D.eW)
break A}u=D.ko.a4J(C.eX,C.j2,C.c8)
break A}t=x[w]
r.push(new A.eP(t.a,s,s,C.bu,s,s,s,s,s,s,u))
r.push(O.BF)}x=E.bq(this.gjg())
r.push(A.ev(s,s,s,s,s,s,s,s,s,D.ko.cv(C.ao),"\ufd3f"+x+"\ufd3e"))
return A.Dk(A.ev(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Z,C.b6)},
b8Y(d){var x,w,v,u,t,s,r=this.w
if(C.c.O(d.c).length===0)return D.bHx
if(d.gtE()){x=r==null
if((x?null:r.a)===D.fm&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fm?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bq(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.DZ(G.cU,C.c1,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMQ()
w=J.dG(x)
v=w.io(x,new B.c02()).gM(0)
u=w.io(x,new B.c03()).gM(0)
t=w.io(x,new B.c04()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bq(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bq(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bq(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gK1().length!==0)x.push(E.bq(d.gK1().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eW:D.e3
x=C.b.aB(x," \u2022 ")
s=d.gK1().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aB(d.gK1(),"\u060c "):""
return new B.DZ(w,C.nB,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aK8(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.k0,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aI(new A.aP(f,0,!1).dD(w).a,1e6)}v=C.j.aI(B.ces(B.Ft(j.gC0()).length).a,1e6)
f=j.gb62()
w=96+26*j.y
u=D.eW.aa(0.25)
w=A.hS(i,A.a6k(C.P,A.E(i,D.as2,C.k,i,i,D.a8b,i,84,i,i,i,i,i,84),i,C.aU,new A.F(u,i,i,i,i,i,i,C.bW),C.Fz,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.ct)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.cdm(x)+" / "+B.cdm(v),i,i,i,i,i,K.oQ,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,i,F.aO,i,i,i),A.bd(D.byy,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.eD((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bq(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bq(t)+" \u062b)"
return new A.B(C.qg,A.I(A.a([C.w8,C.a1,D.bqy,A.d(h,i,i,i,i,i,F.aO,C.Z,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.vg
r=j.r
f=r==null
w=!f
q=w&&r.gtE()
u=A.aX(s?C.nC:K.Ia,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i,i)
o=A.et(i,i,D.bb7,i,i,i,i)
u=A.R(new A.Ag(C.a51,!0,new B.c_y(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Zk(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.JR[n]
p.push(new A.ee(m,i,A.d("\xd7"+E.bq(m),i,i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.z(A.a([u,C.O,A.nC(new B.c_z(j),p,A.dd([h.b.b],o),!1,A.ky(i,i,i,new A.bg(new B.c_A(),l),i,i,i,i,new A.bg(new B.c_B(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cR),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb1w():i
u=A.aX(f?D.qR:C.nB,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,i,C.co,i,i,i)
p=q?C.ir:C.t
h=A.a([o,C.v,A.fq(u,f,h,A.et(p,q?C.i:C.ah,D.u5,i,i,i,i))],k)
if(w&&j.gjg()<j.a.e)C.b.A(h,A.a([C.B,q?A.fq(D.avm,D.bxg,new B.c_C(j),A.et(G.cU,C.ah,D.u5,i,i,i,i)):A.bd(D.bns,i,i,i,new B.c_D(j),i,i)],k))
if(w){f=j.gjg()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.B(C.hQ,A.d(j.ga1E()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,i,K.uF,C.Z,i,i),i))
return A.I(h,C.ad,C.d,C.e,0,C.l)}}}
B.DZ.prototype={
t(d){var x=this,w=null,v=x.c,u=v.aa(0.12),t=A.v(14),s=A.aI(v.aa(0.5),1),r=y.p
return A.E(w,A.z(A.a([A.aX(x.d,v,w,w),C.O,A.R(A.I(A.a([A.d(x.e,w,w,w,w,w,A.bB(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.T,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bN,A.d(x.f,w,w,w,w,w,C.BV,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.F(u,w,s,t,w,w,w,C.n),w,w,w,C.aL,C.ae,w,w,w)}}
B.DF.prototype={
N(){var x=y.S
return new B.a3r($.Nx(),A.C(x,y.B),A.aT(x),A.C(x,y.N),A.eq(null,y.H))}}
B.a3r.prototype={
W(){this.Y()
this.d.ac(this.goG())},
y_(){if(this.c!=null)this.j(new B.c_g())},
m(){var x,w=this,v=w.d
v.U(w.goG())
x=w.y
if(x!=null)x.au()
v.a.a46()
w.a0()},
Ix(d){return this.b5O(d)},
b5O(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$Ix=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.c_p(t,d))
r=t.y
if(r!=null)r.au()
t.y=A.he(C.eZ,new B.c_q(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.ces(B.Ft(H.No(q,d,p.yd(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.ds(0,0,0,350*B.Ft(H.No(p,d,o.yd(p,d)).b).length,0,0)
x=6
return A.c(r.a.a9X(r.b.c,q,p,new B.c_r(t,d),new B.c_s(t)),$async$Ix)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lL){s=r
r=t.y
if(r!=null)r.au()
if(t.c!=null)t.j(new B.c_t(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Ix,w)},
FX(d,e){return this.aNa(d,e)},
aNa(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$FX=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.au()
s.j(new B.c_k(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.aa0()
if(e&&n!=null)s.Ix(n)
q=null
u=4
x=7
return A.c(r,$async$FX)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lL){p=o
s.j(new B.c_l(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bJ(new B.c_m(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$FX,w)},
gaXU(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b2r(){this.j(new B.c_n(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.k0,o=s.e,n=s.gaXU(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("c3<2>")
x=new A.ah(new A.c3(m,l),new B.c_u(),l.i("ah<Y.E>")).gM(0)
l=H.ku(s.a.c)
m=y.p
q=A.a([new B.I0(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bq(s.a.d)+" \u0644\u062d\u062f "+E.bq(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,r,F.aO,r,r,r),C.v],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b7v(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,r,D.BO,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.DH(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bq(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aI(new A.aP(v,0,!1).dD(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.cdm(v),r,r,r,r,r,K.oQ,C.Z,r,r)
j=A.fa(A.v(6),A.qk(C.eC,D.eW,6,s.x,r),C.aB)
u=o<s.a.e
t=A.aX(u?R.I4:C.nC,r,r,r)
C.b.A(q,A.a([v,C.G,j,C.v,A.fq(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,r,C.co,r,r,r),new B.c_v(s,o),A.et(C.t,C.ah,D.u5,r,r,r,r))],m))}else if(n!=null){j=p?new B.c_w(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bq(n)
q.push(A.fq(D.atd,A.d(v,r,r,r,r,r,C.co,r,r,r),j,A.et(C.t,C.ah,D.u5,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aXy)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cU:D.e3
v=k?C.nt:C.nB
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bq(x)
u=s.a
u=k+" \u0645\u0646 "+E.bq(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.DZ(j,v,k,u,r),A.df(D.av9,D.bxW,s.gb2q(),r)],m))}q.push(C.v)
q.push(D.CD)
return L.xW(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b7v(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.asy
else if(l.r.n(0,d))x=N.u8
else if(i!=null)x=D.asQ
else if(j!=null){w=j.gtE()?C.c1:D.aoZ
x=A.aX(w,j.gtE()?G.cU:D.e3,k,k)}else x=D.ar7
w=y.p
v=A.a([A.z(A.a([A.d("\u0622\u064a\u0629 "+E.bq(d),k,k,k,k,k,C.a2z,k,k,k),C.bD,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,k,D.a2t,k,k,k))
if(j!=null&&!j.gtE()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMQ()
o=J.bc(p)
n=o.h(p,r)
A:{if(D.j7===n){m=G.cU
break A}if(D.v0===n){m=D.e3
break A}if(D.v1===n){m=D.eW
break A}m=C.eX
break A}m=D.ko.bd8(m,o.h(p,r)===D.v2?C.j2:k,22)
C.b.A(t,A.a([new A.eP(q.a,k,k,C.bu,k,k,k,k,k,k,m),O.BF],u))}w=A.a([C.aj,A.Dk(A.ev(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Z,C.b6)],w)
if(C.c.O(j.c).length===0)w.push(D.btl)
C.b.A(v,w)}return new E.dE(A.I(v,C.ad,C.d,C.e,0,C.l),C.bP,C.d6,k,!1,k)}}
B.DE.prototype={
N(){return new B.a3q($.Nx())}}
B.a3q.prototype={
W(){this.Y()
var x=this.d
x.ac(this.goG())
x.vO()},
y_(){if(this.c!=null)this.j(new B.c_7())},
m(){this.d.U(this.goG())
this.a0()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gazS(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.i0(o,0,new B.c_e(q))
v=C.b.i0(o,0,new B.c_f())
o=y.p
o=A.a([A.z(A.a([A.R(s.Yw(E.bq(q.gaue()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.O,A.R(s.Yw(E.bq(q.aqO()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.O,A.R(s.Yw(E.bq(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.v,new E.dE(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bq(C.f.ak(w*100/v))+"\u066a",r,r,r,r,r,C.bA,r,r,r),C.G,A.fa(A.v(6),A.qk(C.eC,G.cU,8,w/v,r),C.aB),C.aj,A.d(E.bq(w)+" \u0645\u0646 "+E.bq(v)+" \u0622\u064a\u0629",r,r,r,r,r,F.aO,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a5,C.aL,r,!1,r)],o)
if(p.length===0)o.push(D.aXO)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.K)(p),++t)o.push(s.b7x(p[t]))
o.push(C.B)
u=$.D().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,r,F.aO,r,r,r))
return L.xW(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
Yw(d,e){var x=null
return new E.dE(A.I(A.a([A.d(d,x,x,x,x,x,D.bim,x,x,x),A.d(e,x,x,x,x,x,C.a30,C.Z,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a5,C.I,x,!1,x)},
b7x(d){var x=null,w=this.d.c,v=I.cW[d-1].a[1],u=w.a6Q(d),t=w.bio(d),s=y.p,r=A.z(A.a([A.R(A.d(H.ku(d),x,x,x,x,x,C.bA,x,x,x),1),A.d(E.bq(C.f.ak(u*100/v))+"\u066a",x,x,x,x,x,D.bjq,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fa(A.v(6),A.qk(C.eC,G.cU,7,u/v,x),C.aB),p=E.bq(u),o=E.bq(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bq(t):""
return new E.dE(A.I(A.a([r,C.G,q,C.aj,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,x,F.aO,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a5,C.aL,new B.c_d(this,d),!1,x)},
Om(d){return this.aLd(d)},
aLd(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$Om=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cW[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e2(C.cT,new B.c_c(v,d,u),t,!0,null,null,!1,y.H),$async$Om)
case 2:return A.h(null,w)}})
return A.i($async$Om,w)}}
B.aku.prototype={
RV(d,e){var x=null,w=A.kZ(x,x,x,x,x,x,x,x,x,x,x,D.baH,C.I,x,x,x,x,C.k_,x,x)
return A.bd(A.d(d,x,x,x,x,x,C.mc,x,x,x),x,x,x,new B.b7s(e),x,w)},
t(d){var x=this,w=y.p
return new E.dE(A.I(A.a([D.bx1,C.G,D.byx,A.cR(C.au,A.a([x.RV("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.RV("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aC,0,12),D.bmE,x.RV("tanzil.net","https://tanzil.net"),D.bAa,x.RV("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a5,C.aL,null,!1,null)}}
B.DH.prototype={
N(){return new B.a3t()}}
B.a3t.prototype={
gan1(){var x=this.a
return B.cOT(x.c,x.d,$.cf4().JI())},
RX(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$RX=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.c0a(s))
v=3
r=A.c8r()
n=s.gan1()
m=y.N
q=A.C(m,m)
J.dZ(q,"app","mogtama3y")
J.dZ(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dZ(q,"ua",m)}x=6
return A.c(A.aaX(n,null,C.GF,q),$async$RX)
case 6:if(s.c!=null)s.j(new B.c0b(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cg?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.c0c(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.c0d(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$RX,w)},
t(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bu(!1,t,!0,new A.B(C.l2,A.z(A.a([A.aX(u.d?C.yy:C.lg,C.c8,t,18),C.bM,D.bzl],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.c0f(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.E(t,A.xv(u.gan1(),D.beA,t,C.z),C.k,t,t,new A.F(C.pQ,t,t,x,t,t,t,C.n),t,t,t,D.akf,C.eg,t,t,1/0))}if(u.f)s.push(D.bmW)
else{x=A.kZ(t,t,t,t,t,t,t,t,t,t,t,C.a0O,C.I,t,t,t,t,C.k_,t,t)
w=u.e
v=w?t:u.gb7w()
s.push(A.fg(w?C.a11:D.auy,t,D.bw_,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,t,D.a2t,t,t,t))
return new A.B(C.aL,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["al<~>()","~()","M(nM)","al<Ks>()","al<Kq>()","al<Kr>()","a7<nM>()","M(rE)","bG(oT)","DG(u)","DE(u)","M(n5)","DF(u)","M(J2)"])
B.b7t.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.S(A.cU(b.G.document).baseURI)
q=A.bx(r,0,null).a2("quran_tutor/tutor.js?v=3").k(0)
x=7
return A.c(A.eH(import(q),y.m),$async$$0)
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
o=A.a8(l)
s.a.b=null
m=B.cE2("network",A.n(o))
throw A.t(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:313}
B.b7w.prototype={
$1(d){var x=null
return A.c2L(A.cP(d,"persist",x,x,x,x))},
$S:1153}
B.b7v.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.rh(),$async$$0)
case 4:x=3
return A.c(n.eH(m.cU(l.cP(e,"loadModel",A.c3t(new B.b7u(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.q(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.q(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.rg(p,"ms")
r=q.ou(p,"cached")
A.q(p.backend)
v=new B.Kq(o,t,s,r,q.rg(p,"threads"),q.ou(p,"isolated"),q.rg(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b7u.prototype={
$2(d,e){this.a.$2(C.f.ak(d),C.f.ak(e))},
$S:1154}
B.b7A.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.rh(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aI(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aI(v.d.a,1000)
u.onLevel=A.fX(new B.b7y(v.e))
u.onAutoStop=A.fX(new B.b7z(v.f))
x=5
return A.c(A.eH(A.cU(A.cP(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b7y.prototype={
$1(d){return this.a.$1(d)},
$S:71}
B.b7z.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b7B.prototype={
$0(){var x=0,w=A.j(y.D),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.a
s=t.a
q=A
p=A
o=A
x=s==null?4:6
break
case 4:x=7
return A.c(t.rh(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eH(p.cU(o.cP(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.Kr(r,A.dU(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b7D.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.rh(),$async$$0)
case 4:x=3
return A.c(q.eH(p.cU(o.cP(e,"transcribe",t.audio,t.rate,s.ajf(u.c),null)),y.m),$async$$0)
case 3:v=r.amW(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b7C.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.rh(),$async$$0)
case 4:x=3
return A.c(r.eH(q.cU(p.cP(e,"transcribeUrl",u.b,t.ajf(u.c),null,null)),y.m),$async$$0)
case 3:v=s.amW(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b7x.prototype={
$1(d){return d},
$S:40}
B.aYs.prototype={
$0(){var x,w,v,u,t=this.a,s=A.c8(t.a.length,D.v2,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aYr.prototype={
$1(d){return d===D.j7},
$S:z+2}
B.c3c.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c9r(e[x],d[x])<0.75)return!1
return!0},
$S:1155}
B.c5j.prototype={
$1(d){return d.length!==0},
$S:10}
B.b7H.prototype={
$1(d){return d.a===D.fm},
$S:z+7}
B.b7I.prototype={
$1(d){return C.j.aI(d,1000)},
$S:59}
B.b7F.prototype={
$1(d){return C.f.bB(d)},
$S:1156}
B.b7J.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iI("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.ap.f3(r,null))
j=A.ar(k.h(0,"n"))
j=j==null?null:C.f.bB(j)
j=C.j.d1(j==null?2:j,1,5)
i=C.b.n(D.JR,k.h(0,"r"))?A.ey(k.h(0,"r")):1
h=A.en(k.h(0,"auto"))
g=A.en(k.h(0,"hide"))
k=A.en(k.h(0,"in"))
s.a.b=new B.Wk(j,i,h!==!1,g===!0,k===!0)}u=2
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
return A.c(A.iI("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.ccF(y.P.a(C.ap.f3(q,null)))
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
return A.c(A.iI("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.ap.f3(p,null))
n=C.f.bB(A.cS(J.as(o,"s")))
m=C.f.bB(A.cS(J.as(o,"f")))
l=C.f.bB(A.cS(J.as(o,"t")))
if(B.cr3(n,m)&&B.cr3(n,l)&&m<=l)s.a.z=new A.aZ(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a9L()){k.a.arE()
x=1
break}a1=k
x=18
return A.c(k.a.Na(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a5()
if(k.b.e)k.Dr()
k.wL()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:112}
B.b7K.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a5()},
$S:1157}
B.b7L.prototype={
$2(d,e){return C.j.aI(A.eG(A.n(d),null,null),1000)===this.a},
$S:1158}
B.bMU.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.EJ(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bMT(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1159}
B.bMT.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bMV.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bMS(x,d))},
$S:z+8}
B.bMS.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bMW.prototype={
$1(d){},
$S:24}
B.bMG.prototype={
$0(){},
$S:0}
B.bMM.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.DG(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bMN.prototype={
$0(){},
$S:0}
B.bMQ.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aE(A.aF(new B.bMP(),null,x),x)},
$S:0}
B.bMP.prototype={
$1(d){return D.bBz},
$S:z+10}
B.bMR.prototype={
$0(){return B.cqQ(this.a)},
$S:0}
B.bMJ.prototype={
$0(){var x=this.b
return this.a.y0(x.a,x.b,x.c)},
$S:0}
B.bMK.prototype={
$1(d){return this.a.j(new B.bMI())},
$S:5}
B.bMI.prototype={
$0(){},
$S:0}
B.bML.prototype={
$0(){var x=this.a
return x.j(new B.bMH(x))},
$S:0}
B.bMH.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bMO.prototype={
$0(){return this.a.b7u(this.b)},
$S:0}
B.c84.prototype={
$1(d){return new A.je(new B.c81(this.a,this.b,this.c),null)},
$S:57}
B.c81.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c83(u,e),s=this.a,r=new B.c82(s,e),q=A.d(H.ku(this.c),v,v,v,v,v,C.oM,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bq(u)+" \u0622\u064a\u0629)",v,v,v,v,v,F.aO,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bq(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bq(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.aj,p,C.v,A.cR(C.au,n,C.aC,6,8),C.B,A.z(A.a([t.$3("\u0645\u0646",s.b,new B.c7X(s)),C.a0Z,t.$3("\u0644\u062d\u062f",s.c,new B.c7Y(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aXD)
u.push(C.a4)
u.push(A.dy(D.bq0,new B.c7Z(s,d),A.et(C.t,C.ah,D.bb4,v,v,v,v)))
return A.cx(!0,new A.B(C.G6,A.I(u,C.ad,C.d,C.J,0,C.l),v),C.I,!0)},
$S:405}
B.c83.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,u,C.ic,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c7(v,A.d("\u0622\u064a\u0629 "+E.bq(v),u,u,u,u,u,u,u,u,u),C.an,u,w))
return A.R(A.I(A.a([t,Q.GJ(C.cT,!0,s,320,new B.c80(this.b,f),D.bjH,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1161}
B.c80.prototype={
$1(d){return d==null?null:this.a.$1(new B.c8_(this.b,d))},
$S:51}
B.c8_.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c82.prototype={
$3(d,e,f){var x=null
return A.ca1(x,A.d(d,x,x,x,x,x,x,x,x,x),new B.c7W(this.a,this.b,e,f))},
$S:1162}
B.c7W.prototype={
$0(){var x=this
return x.b.$1(new B.c7V(x.a,x.c,x.d))},
$S:0}
B.c7V.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c7X.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c7Y.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c7Z.prototype={
$0(){var x=this.a
return A.O(this.b,!1).af(new A.V(x.b,x.c))},
$S:0}
B.c_x.prototype={
$0(){},
$S:0}
B.c_N.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.my
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.c_R.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.je:D.my},
$S:0}
B.c_S.prototype={
$0(){var x=this.a
x.f=D.vg
x.as=null},
$S:0}
B.c_T.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.c_V.prototype={
$0(){var x=this.a
x.f=D.vh
x.as=null
x.y=0
x.z=new A.aP(Date.now(),0,!1)
x.ax=null},
$S:0}
B.c_W.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c_U())},
$S:28}
B.c_U.prototype={
$0(){},
$S:0}
B.c_Y.prototype={
$1(d){return this.a.y=d},
$S:71}
B.c_X.prototype={
$1(d){return this.a.BV()},
$S:5}
B.c_Z.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.je:D.my
x=this.b
w.as=B.Nq(x)
w.at=x},
$S:0}
B.c00.prototype={
$0(){var x=this.a
x.f=D.pe
x.ay=Date.now()},
$S:0}
B.c01.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c0_())},
$S:28}
B.c0_.prototype={
$0(){},
$S:0}
B.c_M.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.je:D.my
x.as=this.b
x.at=this.c},
$S:0}
B.c_O.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.je
x.x=!1},
$S:0}
B.c_F.prototype={
$0(){var x=this.a
x.f=D.pe
x.ay=Date.now()
x.as=null},
$S:0}
B.c_G.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c_E())},
$S:28}
B.c_E.prototype={
$0(){},
$S:0}
B.c_H.prototype={
$1(d){return d.d!==D.j7},
$S:z+11}
B.c_I.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.c06.prototype={
$0(){return B.cqQ(this.a)},
$S:0}
B.c07.prototype={
$1(d){var x=this.a.d
return x.qQ(x.b.aqj(d))},
$S:3}
B.c08.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aE(A.aF(new B.c05(this.a),null,x),x)},
$S:0}
B.c05.prototype={
$1(d){var x=this.a.a
return new B.DF(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.c09.prototype={
$0(){this.a.d.a.bmG()
this.b.H(y.q).f.Z(D.bcc)},
$S:0}
B.c_L.prototype={
$2(d,e){return C.aV},
$S:17}
B.c_K.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a6Y(s.c,r).a.a){case 2:s=G.cU
break
case 1:s=D.e3
break
case 0:s=C.ir
break
default:s=u}x=A.v(18)
w=t.f===D.pe?u:new B.c_J(t,r)
v=s.aa(0.25)
if(r===t.gjg())s=C.i
s=A.aI(s,r===t.gjg()?2:1)
return A.bu(!1,x,!0,A.E(C.P,A.d(E.bq(r),u,u,u,u,u,C.a27,u,u,u),C.k,u,u,new A.F(v,u,s,u,u,u,u,C.bW),u,u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:69}
B.c_J.prototype={
$0(){return this.a.a_F(this.b)},
$S:0}
B.c_Q.prototype={
$0(){var x=this.a
return x.j(new B.c_P(x))},
$S:0}
B.c_P.prototype={
$0(){return this.a.x=!0},
$S:0}
B.c02.prototype={
$1(d){return d===D.v0},
$S:z+2}
B.c03.prototype={
$1(d){return d===D.v1},
$S:z+2}
B.c04.prototype={
$1(d){return d===D.v2},
$S:z+2}
B.c_y.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.RW(x)},
$S:0}
B.c_z.prototype={
$1(d){var x=this.a.d
return x.qQ(x.b.bcx(d.ga1(d)))},
$S:115}
B.c_B.prototype={
$1(d){return d.n(0,C.U)?C.ah:C.i},
$S:4}
B.c_A.prototype={
$1(d){return d.n(0,C.U)?C.t:C.a7},
$S:4}
B.c_C.prototype={
$0(){var x=this.a
return x.a_F(x.gjg()+1)},
$S:0}
B.c_D.prototype={
$0(){var x=this.a
return x.a_F(x.gjg()+1)},
$S:0}
B.c_g.prototype={
$0(){},
$S:0}
B.c_p.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aP(Date.now(),0,!1)},
$S:0}
B.c_q.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c_o())},
$S:28}
B.c_o.prototype={
$0(){},
$S:0}
B.c_s.prototype={
$1(d){return this.a.x=d},
$S:71}
B.c_r.prototype={
$1(d){return this.a.FX(this.b,!1)},
$S:5}
B.c_t.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.Nq(x)
w.as=x},
$S:0}
B.c_k.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.c_l.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.Nq(x))
w.as=x},
$S:0}
B.c_m.prototype={
$1(d){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k,j,i,h
var $async$$1=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:v=3
o=s.a
n=o.d
m=s.c
l=o.a
k=l.f
l=l.c
x=6
return A.c(n.a.awe(s.b,B.Ft(H.No(l,m,k.yd(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.coZ(H.No(l,m,k.yd(l,m)).b,r.a)
if(C.c.O(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtE()
l.avf(k,m,n.b.a,j)}n.A2()
if(o.c!=null)o.j(new B.c_h(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lL){p=o
o=s.a
if(o.c!=null)o.j(new B.c_i(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.c_j(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:150}
B.c_h.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.c_i.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.Nq(w))
x.as=w},
$S:0}
B.c_j.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.c_n.prototype={
$0(){var x=this.a
x.f.ao(0)
x.w.ao(0)
x.as=null},
$S:0}
B.c_u.prototype={
$1(d){return d.gtE()},
$S:z+13}
B.c_v.prototype={
$0(){return this.a.FX(this.b,!0)},
$S:0}
B.c_w.prototype={
$0(){return this.a.Ix(this.b)},
$S:0}
B.c_7.prototype={
$0(){},
$S:0}
B.c_e.prototype={
$2(d,e){return d+this.a.a6Q(e)},
$S:114}
B.c_f.prototype={
$2(d,e){return d+I.cW[e-1].a[1]},
$S:114}
B.c_d.prototype={
$0(){return this.a.Om(this.b)},
$S:0}
B.c_c.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.ku(p),q,q,q,q,q,C.oM,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.ba(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.rt():r).a.a){case 2:r=G.cU.aa(0.35)
break
case 1:r=D.e3.aa(0.35)
break
case 0:r=C.h0
break
default:r=q}m.push(A.E(C.P,A.d(E.bq(t),q,q,q,q,q,C.km,q,q,q),C.k,q,q,new A.F(r,q,q,new A.cD(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,q,38))}return A.cx(!0,new A.B(C.h6,A.I(A.a([o,C.aj,D.bug,C.v,new A.dl(D.a81,A.f1(A.cR(C.au,m,C.aC,6,6),q,C.r,q,q,q,C.w),q),C.a1,A.bd(D.bw2,q,q,q,new B.c_b(w,d,p),q,q)],n),C.ad,C.d,C.J,0,C.l),q),C.I,!0)},
$S:35}
B.c_b.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.di(null,null,!0,null,new B.c_a(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Lv(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e5()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.c_a.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.ku(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x,x)
return A.dr(A.a([A.bd(C.ev,x,x,x,new B.c_8(d),x,x),A.bd(C.p1,x,x,x,new B.c_9(d),x,x)],y.p),w,D.bxE)},
$S:14}
B.c_8.prototype={
$0(){A.O(this.a,!1).af(!1)
return null},
$S:0}
B.c_9.prototype={
$0(){A.O(this.a,!1).af(!0)
return null},
$S:0}
B.c91.prototype={
$1(d){var x=this.a
return new A.kL(new B.c90(x),null,x,null)},
$S:1163}
B.c90.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.ee(w,t,A.d(E.bq(w),t,t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bmA,C.a1,D.bws,C.G,A.nC(new B.c8W(s,r),q,A.dd([r.a],x),!1,A.ky(t,t,t,new A.bg(new B.c8X(),v),t,t,t,t,new A.bg(new B.c8Y(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.iz(C.t,C.I,t,new B.c8Z(s,r),D.btw,D.bzC,r.c),A.iz(C.t,C.I,t,new B.c9_(s,r),t,D.bm5,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.aj,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn6(),t,t,t,t,t,F.aO,t,C.b6,t)],u))
x.push(C.B)
x.push(D.a4c)
return A.cx(!0,A.f1(A.I(x,C.ad,C.d,C.e,0,C.l),t,C.r,C.h6,t,t,C.w),C.I,!0)},
$S:1164}
B.c8W.prototype={
$1(d){return this.a.qQ(this.b.bcu(d.ga1(d)))},
$S:115}
B.c8Y.prototype={
$1(d){return d.n(0,C.U)?C.ah:C.i},
$S:4}
B.c8X.prototype={
$1(d){return d.n(0,C.U)?C.t:C.a7},
$S:4}
B.c8Z.prototype={
$1(d){return this.a.qQ(this.b.bbQ(d))},
$S:3}
B.c9_.prototype={
$1(d){return this.a.qQ(this.b.aqj(d))},
$S:3}
B.b7s.prototype={
$0(){return A.cp(A.bx(this.a,0,null),C.aM,null)},
$S:0}
B.c9k.prototype={
$1(d){var x,w=A.aE("https?://",!0,!1,!1)
w=A.bJ(d,w,"")
x=A.aE("www\\.",!0,!1,!1)
return A.v8(A.bJ(w,x,"www[.]"),A.aE("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c9l(),null)},
$S:40}
B.c9l.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:58}
B.c0a.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.c0b.prototype={
$0(){return this.a.f=!0},
$S:0}
B.c0c.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.c0d.prototype={
$0(){return this.a.e=!1},
$S:0}
B.c0f.prototype={
$0(){var x=this.a
return x.j(new B.c0e(x))},
$S:0}
B.c0e.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c9j.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:230};(function installTearOffs(){var x=a._instance_0u
x(B.akv.prototype,"gbip","biq",1)
var w
x(w=B.Wl.prototype,"gbiH","Dr",0)
x(w,"gaEX","wL",0)
x(w=B.a0V.prototype,"goG","y_",1)
x(w,"gaZJ","Qj",0)
x(w=B.a3s.prototype,"goG","y_",1)
x(w,"gb1w","QJ",0)
x(w,"gb62","BV",0)
x(w,"gaKS","Oj",0)
x(w=B.a3r.prototype,"goG","y_",1)
x(w,"gb2q","b2r",1)
x(B.a3q.prototype,"goG","y_",1)
x(B.a3t.prototype,"gb7w","RX",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a6,[B.akv,B.Wm,B.Kq,B.Ks,B.Kr,B.lL,B.Ts,B.n5,B.J2,B.rE,B.akw,B.Wk])
x(A.lk,[B.b7t,B.b7v,B.b7A,B.b7B,B.b7D,B.b7C,B.aYs,B.b7J,B.bMT,B.bMS,B.bMG,B.bMN,B.bMQ,B.bMR,B.bMJ,B.bMI,B.bML,B.bMH,B.bMO,B.c8_,B.c7W,B.c7V,B.c7Z,B.c_x,B.c_N,B.c_R,B.c_S,B.c_T,B.c_V,B.c_U,B.c_Z,B.c00,B.c0_,B.c_M,B.c_O,B.c_F,B.c_E,B.c_I,B.c06,B.c08,B.c09,B.c_J,B.c_Q,B.c_P,B.c_y,B.c_C,B.c_D,B.c_g,B.c_p,B.c_o,B.c_t,B.c_k,B.c_l,B.c_h,B.c_i,B.c_j,B.c_n,B.c_v,B.c_w,B.c_7,B.c_d,B.c_b,B.c_8,B.c_9,B.b7s,B.c0a,B.c0b,B.c0c,B.c0d,B.c0f,B.c0e])
x(A.iN,[B.b7w,B.b7y,B.b7z,B.b7x,B.aYr,B.c5j,B.b7H,B.b7I,B.b7F,B.bMU,B.bMV,B.bMW,B.bMM,B.bMP,B.bMK,B.c84,B.c83,B.c80,B.c82,B.c7X,B.c7Y,B.c_W,B.c_Y,B.c_X,B.c01,B.c_G,B.c_H,B.c07,B.c05,B.c02,B.c03,B.c04,B.c_z,B.c_B,B.c_A,B.c_q,B.c_s,B.c_r,B.c_m,B.c_u,B.c_c,B.c_a,B.c91,B.c8W,B.c8Y,B.c8X,B.c8Z,B.c9_,B.c9k,B.c9l,B.c9j])
x(A.og,[B.b7u,B.c3c,B.b7K,B.b7L,B.c81,B.c_L,B.c_K,B.c_e,B.c_f,B.c90])
x(A.Eg,[B.nM,B.FN,B.I_,B.EJ])
w(B.Wl,A.i7)
x(A.L,[B.x8,B.DG,B.DF,B.DE,B.DH])
x(A.N,[B.a0V,B.a3s,B.a3r,B.a3q,B.a3t])
x(A.a3,[B.I0,B.YH,B.DZ,B.aku])})()
A.pv(b.typeUniverse,JSON.parse('{"lL":{"bK":[]},"DG":{"L":[],"l":[]},"DF":{"L":[],"l":[]},"DE":{"L":[],"l":[]},"DH":{"L":[],"l":[]},"Wl":{"aD":[]},"x8":{"L":[],"l":[]},"a0V":{"N":["x8"]},"I0":{"a3":[],"l":[]},"YH":{"a3":[],"l":[]},"a3s":{"N":["DG"]},"DZ":{"a3":[],"l":[]},"a3r":{"N":["DF"]},"a3q":{"N":["DE"]},"aku":{"a3":[],"l":[]},"a3t":{"N":["DH"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rE"),c:x("ee<x>"),r:x("c7<x>"),k:x("H<n5>"),n:x("H<ee<x>>"),I:x("H<c7<x>>"),R:x("H<hT>"),Z:x("H<aA<o,@>>"),d:x("H<Ts>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bR"),j:x("a7<@>"),L:x("a7<x>"),P:x("aA<o,@>"),f:x("aA<@,@>"),x:x("au<o,x>"),a:x("bG"),K:x("a6"),B:x("J2"),l:x("+(x,x)"),e:x("d5<n5>"),N:x("o"),C:x("Kq"),D:x("Kr"),X:x("Wm"),_:x("Ks"),U:x("ah<o>"),G:x("nM"),q:x("ps"),b:x("bg<U?>"),y:x("M"),i:x("a2"),z:x("@"),S:x("x"),A:x("bR?"),Y:x("aA<@,@>?"),O:x("a6?"),M:x("+quota,usage(x,x)?"),o:x("dI"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.pn=new B.FN(0,"none")
D.po=new B.FN(1,"learning")
D.fm=new B.FN(2,"memorized")
D.a81=new A.az(0,1/0,0,320)
D.eW=new A.U(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a8b=new A.F(D.eW,null,null,null,null,null,null,C.bW)
D.e3=new A.U(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.atN=new A.G(C.yK,null,C.c8,null,null,null)
D.bxM=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.fe,null,null,null,null,null,null,null,null)
D.bf3=new A.r(!0,C.eX,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bui=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bf3,null,null,null,null,null,null,null,null)
D.aL_=x([D.atN,C.G,D.bxM,D.bui],y.p)
D.agq=new A.fi(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aL_,null)
D.akc=new A.T(0,26,0,26)
D.akf=new A.T(0,4,0,6)
D.akF=new A.T(14,12,14,14)
D.alp=new A.T(3,0,0,0)
D.aoZ=new A.Q(63251,"MaterialIcons",null,!1)
D.qR=new A.Q(63677,"MaterialIcons",null,!1)
D.apN=new A.Q(983209,"MaterialIcons",null,!1)
D.aqq=new A.G(D.apN,28,C.t,null,null,null)
D.ar7=new A.G(C.HO,null,C.ir,null,null,null)
D.aoI=new A.Q(62961,"MaterialIcons",null,!1)
D.arQ=new A.G(D.aoI,null,null,null,null,null)
D.aoX=new A.Q(63199,"MaterialIcons",null,!1)
D.arR=new A.G(D.aoX,null,null,null,null,null)
D.arZ=new A.G(C.jH,null,C.eX,null,null,null)
D.as2=new A.G(C.nC,44,C.i,null,null,null)
D.asy=new A.G(D.qR,null,D.eW,null,null,null)
D.asQ=new A.G(C.lf,null,D.eW,null,null,null)
D.atd=new A.G(D.qR,null,null,null,null,null)
D.atK=new A.G(C.hU,20,D.e3,null,null,null)
D.au5=new A.G(C.nz,30,C.t,null,null,null)
D.auy=new A.G(C.ll,16,C.t,null,null,null)
D.av_=new A.G(C.HK,null,null,null,null,null)
D.av9=new A.G(C.nB,null,null,null,null,null)
D.avm=new A.G(C.Hx,null,null,null,null,null)
D.JR=x([1,3,5],y.t)
D.KE=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aYg=new A.B(C.iw,C.mK,null)
D.aHM=x([D.aYg],y.p)
D.b1O=new A.V(C.nv,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b1B=new A.V(D.qR,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b28=new A.V(C.d8,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.b2m=new A.V(C.HN,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aJW=x([D.b1O,D.b1B,D.b28,D.b2m],A.ae("H<+(Q,o)>"))
D.aMl=x([D.pn,D.po,D.fm],A.ae("H<FN>"))
D.Pi=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aU_=new B.I_(0,"idle")
D.Vy=new B.I_(1,"loading")
D.k0=new B.I_(2,"ready")
D.aU0=new B.I_(3,"failed")
D.asw=new A.G(C.c1,18,G.cU,null,null,null)
D.byK=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uF,null,null,null,null,null,null,null,null)
D.aGG=x([D.asw,C.aV,D.byK],y.p)
D.b8t=new A.ea(C.ac,C.d,C.e,C.h,null,C.l,null,0,D.aGG,null)
D.aX6=new A.B(C.aL,D.b8t,null)
D.aln=new A.T(2,6,2,4)
D.beK=new A.r(!0,C.t,null,null,null,null,14,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmw=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.beK,null,null,null,null,null,null,null,null)
D.aXm=new A.B(D.aln,D.bmw,null)
D.bz9=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.fe,null,null,null,null,null,null,null,null)
D.aI5=x([N.u8,C.O,D.bz9],y.p)
D.b8n=new A.ea(C.ac,C.cf,C.e,C.h,null,C.l,null,0,D.aI5,null)
D.aXy=new A.B(C.l1,D.b8n,null)
D.C2=new A.r(!0,D.e3,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bzu=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.C2,null,null,null,null,null,null,null,null)
D.aXD=new A.B(C.dD,D.bzu,null)
D.byF=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aO,C.Z,null,null,null,null,null,null,null)
D.aXO=new A.B(C.C,D.byF,null)
D.alk=new A.T(2,0,2,8)
D.buA=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aO,null,null,null,null,null,null,null,null)
D.aY5=new A.B(D.alk,D.buA,null)
D.auH=new A.G(C.lj,30,C.t,null,null,null)
D.bAb=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.C3,null,null,null,null,null,null,null,null)
D.amw=new A.bV(1,C.af,D.bAb,null)
D.aIl=x([D.auH,C.Y,D.amw],y.p)
D.b88=new A.ea(C.ac,C.d,C.e,C.h,null,C.l,null,0,D.aIl,null)
D.aui=new A.G(C.d8,18,G.cU,null,null,null)
D.a2h=new A.r(!0,G.cU,null,null,null,null,12,C.R,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.byn=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a2h,null,null,null,null,null,null,null,null)
D.aH6=x([D.aui,C.bM,D.byn],y.p)
D.b8l=new A.ea(C.ac,C.d,C.J,C.h,null,C.l,null,0,D.aH6,null)
D.baH=new A.W(0,30)
D.u5=new A.W(1/0,54)
D.bb4=new A.W(1/0,48)
D.bb7=new A.W(1/0,50)
D.bba=new A.W(1/0,52)
D.bwc=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.bcc=new A.cX(D.bwc,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.be9=new A.r(!0,C.i,null,null,null,null,14.5,C.R,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beA=new A.r(!0,C.ao,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.BO=new A.r(!0,D.eW,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.ko=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a2t=new A.r(!0,D.eW,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bim=new A.r(!0,C.t,null,null,null,null,24,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjp=new A.r(!0,D.e3,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjq=new A.r(!0,G.cU,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjH=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bln=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.ic,null,null,null,null,null,null,null,null)
D.bm5=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.d_,null,null,null,null,null,null,null,null)
D.bmA=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oM,null,null,null,null,null,null,null,null)
D.bmE=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aO,null,null,null,null,null,null,null,null)
D.bfW=new A.r(!0,G.cU,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmW=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bfW,null,null,null,null,null,null,null,null)
D.bn1=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aO,null,null,null,null,null,null,null,null)
D.bns=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.fe,null,null,null,null,null,null,null,null)
D.bpg=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.co,null,null,null,null,null,null,null,null)
D.bq0=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bF,null,null,null,null,null,null,null,null)
D.bq5=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aO,null,null,null,null,null,null,null,null)
D.bqy=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.uG,null,null,null,null,null,null,null,null)
D.brM=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bsj=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oQ,null,null,null,null,null,null,null,null)
D.bt6=new A.m("reset safe mode / WebGPU ban",null,C.BH,null,null,null,null,null,null,null,null)
D.btl=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.C2,null,null,null,null,null,null,null,null)
D.btw=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aO,null,null,null,null,null,null,null,null)
D.btY=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bA,null,null,null,null,null,null,null,null)
D.bug=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aO,null,null,null,null,null,null,null,null)
D.buB=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aO,null,null,null,null,null,null,null,null)
D.bw_=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a2U,null,null,null,null,null,null,null,null)
D.bhy=new A.r(!0,D.eW,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bw2=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bhy,null,null,null,null,null,null,null,null)
D.bws=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oQ,null,null,null,null,null,null,null,null)
D.bx1=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a1K,null,null,null,null,null,null,null,null)
D.bxg=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.co,null,null,null,null,null,null,null,null)
D.bxE=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bxW=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.byx=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aO,null,null,null,null,null,null,null,null)
D.byy=new A.m("\u062e\u0644\u0635\u062a",null,C.md,null,null,null,null,null,null,null,null)
D.byz=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.C2,null,null,null,null,null,null,null,null)
D.biF=new A.r(!0,C.cM,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.fN,null,null,null,null,null,null,null,null)
D.bzl=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.biF,null,null,null,null,null,null,null,null)
D.bzy=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bA,null,null,null,null,null,null,null,null)
D.bzC=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.d_,null,null,null,null,null,null,null,null)
D.bAa=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aO,null,null,null,null,null,null,null,null)
D.a4c=new B.aku(null)
D.bBz=new B.DE(null)
D.bBA=new B.Wk(2,1,!0,!1,!1)
D.a4g=new B.Wm(!1,!1,!1,!1,!1,0)
D.j7=new B.nM(0,"ok")
D.v0=new B.nM(1,"near")
D.v1=new B.nM(2,"wrong")
D.v2=new B.nM(3,"missing")
D.a4H=new B.nM(4,"extra")
D.apd=new A.Q(63456,"MaterialIcons",null,!1)
D.bHx=new B.DZ(D.e3,D.apd,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bIa=new B.YH(!1,null)
D.CD=new B.YH(!0,null)
D.my=new B.EJ(0,"idle")
D.vg=new B.EJ(1,"playing")
D.vh=new B.EJ(2,"recording")
D.pe=new B.EJ(3,"thinking")
D.je=new B.EJ(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cRT","cf4",()=>new B.akv())
x($,"cVl","cuN",()=>A.aE("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cVm","cuO",()=>A.aE("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cVy","cuX",()=>A.aE("\u0648\u0670",!0,!1,!1))
x($,"cUU","cut",()=>A.aE("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cTa","cti",()=>A.aE("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cUp","cu5",()=>A.aE("[\u0654\u0655]",!0,!1,!1))
x($,"cTb","ctj",()=>A.aE("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cTi","ctp",()=>A.aE("[\u0624\u0626]",!0,!1,!1))
x($,"cUr","cu7",()=>A.aE("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cUZ","cuw",()=>A.aE("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cUz","cue",()=>A.aE("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cVj","cfG",()=>A.aE("\\s+",!0,!1,!1))
x($,"cPb","rt",()=>B.cvO(D.pn,0,A.caC(0,!0)))
x($,"cRU","Nx",()=>new B.Wl($.cf4(),D.bBA,B.cE3(),D.aU_,$.X()))})()};
(a=>{a["moR4ieY3D1/2Y04sJuH8EeKtAVc="]=a.current})($__dart_deferred_initializers__);