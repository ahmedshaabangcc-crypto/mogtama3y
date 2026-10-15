((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,Q,H,G,N,R,K,B={
czr(d){var x,w,v,u,t,s
if(d instanceof B.lE)return d
try{x=A.d3(d)
w=x.code
v=x.message
u=w==null?"failed":A.Y(w)
t=v==null?"":A.Y(v)
return new B.lE(u,t)}catch(s){u=A.n(d)
return new B.lE("failed",u)}},
aj5:function aj5(){this.b=this.a=null},
b51:function b51(d){this.a=d},
b54:function b54(){},
b53:function b53(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b52:function b52(d){this.a=d},
b58:function b58(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b56:function b56(d){this.a=d},
b57:function b57(d){this.a=d},
b59:function b59(d){this.a=d},
b5b:function b5b(d,e,f){this.a=d
this.b=e
this.c=f},
b5a:function b5a(d,e,f){this.a=d
this.b=e
this.c=f},
b55:function b55(){},
czs(d,e){return new B.lE(d,e)},
Vr:function Vr(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
JF:function JF(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
JH:function JH(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
JG:function JG(d,e){this.a=d
this.b=e},
lE:function lE(d,e){this.a=d
this.b=e},
clP(d){var x,w=$.cqx()
w=A.bD(d,w,"\u0627")
x=$.cqy()
w=A.bD(w,x,"\u064a")
x=$.cqH()
w=A.bD(w,x,"\u0627")
x=$.cp2()
w=A.bD(w,x,"\u0627")
x=$.cqd()
w=A.bD(w,x,"\u0621")
x=$.cpQ()
w=A.bD(w,x,"\u0621")
x=$.cp3()
w=A.bD(w,x,"\u0627")
x=$.cp9()
w=A.bD(w,x,"\u0621")
w=A.bD(w,"\u0649","\u064a")
w=A.bD(w,"\u0629","\u0647")
x=$.cpS()
w=A.bD(w,x,"")
x=$.cqg()
w=A.bD(w,x," ")
x=$.cpZ()
w=A.bD(w,x," ")
x=$.cbt()
return C.c.O(A.bD(w,x," "))},
cE8(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kB(x,w)
for(u=0;u<x;++u)v[u]=u
t=A.cn(x,0,!1,w)
for(s=1;s<=l;++s,r=t,t=v,v=r){t[0]=s
for(w=s-1,u=1;u<=k;++u){q=u-1
p=d.charCodeAt(w)===e.charCodeAt(q)?0:1
o=v[u]+1
n=t[q]+1
m=v[q]+p
if(o<n)q=o<m?o:m
else q=n<m?n:m
t[u]=q}}return v[k]},
c5l(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aC("[\u0627\u0621]",!0,!1,!1)
w=A.bD(d,x,"")
x=A.aC("[\u0627\u0621]",!0,!1,!1)
v=A.bD(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cE8(d,e)/u
return s>=1?0.99:s},
EP(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tY(d,$.cbt()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.clP(u)
s=A.bD(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Sy(r.a+" "+u,r.b))}continue}q.push(new B.Sy(u,s))}return q},
cCO(d,e){var x,w,v,u,t=new B.c_z(),s=A.a([],y.s)
for(x=A.fu(e,0,A.ih(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.ca(x,x.gM(0),w.i("ca<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.JX)&&t.$2(d,D.JX)?C.b.jy(d,5):d
return!t.$2(s,D.OA)&&t.$2(u,D.OA)?C.b.jy(u,4):u},
ckL(d,e){var x=B.EP(d),w=B.clP(e),v=y.U
v=A.aa(new A.ak(A.a(w.split(" "),y.s),new B.c1F(),v),v.i("a_.E"))
return new B.Ij(x,B.cBZ(x,B.cCO(v,x)),w)},
cBZ(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.cn(x,0,!1,s)
q=A.cn(x,0,!1,y.S)
p=A.cn(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c5l(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c5l(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c5l(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.j2
else m=a2>=0.6?D.uG:D.uH
a1.push(new B.mV(o,x,s,m))
break
case 1:--o
a1.push(new B.mV(o,a4[o],null,D.uI))
break
case 2:--n
a1.push(new B.mV(null,null,a6[n],D.a3U))
break
case 3:--o
a3=n-2
a1.push(new B.mV(o,a4[o],a6[a3]+" "+a6[n-1],D.j2))
n=a3
break
default:x=o-1;--n
a1.push(new B.mV(x,a4[x],a6[n],D.j2))
o-=2
a1.push(new B.mV(o,a4[o],a6[n],D.j2))}}a4=y.e
a4=A.aa(new A.d8(a1,a4),a4.i("aW.E"))
return a4},
nz:function nz(d,e){this.a=d
this.b=e},
Sy:function Sy(d,e){this.a=d
this.b=e},
mV:function mV(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Ij:function Ij(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aWh:function aWh(d){this.a=d},
aWg:function aWg(){},
c_z:function c_z(){},
c1F:function c1F(){},
crw(d,e,f){return new B.rr(d,e,f)},
cF3(d){var x
A:{if("memorized"===d){x=D.fh
break A}if("learning"===d){x=D.p8
break A}x=D.p7
break A}return x},
cmO(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cO[d-1].a[1]},
czt(){var x=y.S
return new B.aj6(A.C(x,y.u),A.aS(x))},
b5e(d){var x=d.ff()
return C.c.dq(C.j.k(A.br(x)),4,"0")+"-"+C.c.dq(C.j.k(A.bt(x)),2,"0")+"-"+C.c.dq(C.j.k(A.bW(x)),2,"0")},
chF(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cGt(),x),x.i("aW.E"))
return B.b5e(A.ds(w[0],w[1],w[2]-1,12,0,0,0))},
c8u(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.C(p,y.u),n=A.aS(p),m=new B.aj6(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcN(),x=x.ga_(x),w=y.j;x.v();){v=x.gI()
u=A.dT(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aP(t)>=3){v=C.j.aH(u,1000)
s=C.j.a2(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cO[v-1].a[1])}if(v)continue
v=J.bf(t)
r=C.f.bW(A.cS(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rr(D.aKM[r],C.f.bW(A.cS(v.h(t,1))),new A.aR(A.ks(C.f.bW(A.cS(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aAm(q,y.o)
p=A.mp(x,new B.b5d(),x.$ti.i("a_.E"),p)
n.A(0,new A.ak(p,o.ga3K(),A.y(p).i("ak<a_.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aE(d.h(0,"streak"))
p=p==null?null:C.f.bW(p)
p=m.d=p==null?0:p
o=A.aE(d.h(0,"best"))
o=o==null?null:C.f.bW(o)
m.e=o==null?p:o
return m},
azF(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dq(C.j.k(d),3,"0")+C.c.dq(C.j.k(e),3,"0")+".mp3"},
F7:function F7(d,e){this.a=d
this.b=e},
rr:function rr(d,e,f){this.a=d
this.b=e
this.c=f},
aj6:function aj6(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b5f:function b5f(){},
b5g:function b5g(){},
b5d:function b5d(){},
Vp:function Vp(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cwY(){return new B.wR(null)},
cIT(d,e){var x,w,v,u,t={},s=I.cO[e-1].a[1],r=$.MJ().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.rg():v).a===D.fh}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d1(u+4,1,s)
return A.e2(C.cL,new B.c4b(t,s,e),d,!0,null,null,!1,y.l)},
caf(d){return A.dn(0,0,0,0,0,C.j.d1(C.f.ak(6+d*1.2),25,90))},
c9b(d){return E.bq(C.j.aH(d,60))+":"+C.c.dq(E.bq(C.j.a2(d,60)),2,"\u0660")},
cmA(d){return A.e2(C.cL,new B.c5_($.MJ()),d,!0,null,null,!1,y.H)},
MC(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl2()
break A}return x},
cKd(d,e,f){var x,w=new B.c5f(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
cmJ(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.ap.fb(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.f5:r
q=s.a(J.av(x,"last"))
v=q==null?C.f5:q
u=new B.c5e()
s=J.av(v,"recovered")
t=A.n(s==null?"":s)
s=A.n(u.$1(J.av(w,"wall")))
p=A.n(u.$1(J.av(w,"source")))
o=A.n(u.$1(J.av(w,"ctxRate")))
n=A.n(u.$1(J.av(w,"pcmPeak")))
m=A.n(u.$1(J.av(w,"ctxState")))
l=A.n(u.$1(J.av(w,"stopMs")))
k=A.n(u.$1(J.av(v,"prepMs")))
j=A.n(u.$1(J.av(v,"ms")))
i=A.n(u.$1(J.av(v,"featMs")))
h=A.n(u.$1(J.av(v,"encMs")))
g=A.n(u.$1(J.av(v,"decMs")))
f=A.n(u.$1(J.av(v,"wallMs")))
e=A.n(u.$1(J.av(v,"backend")))
d=A.n(u.$1(J.av(v,"threads")))
a0=J.aP(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.k(J.av(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.k(J.av(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
Hj:function Hj(d,e){this.a=d
this.b=e},
Vq:function Vq(d,e,f,g,h){var _=this
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
_.U$=_.S$=0},
b5h:function b5h(d){this.a=d},
b5i:function b5i(d){this.a=d},
b5j:function b5j(d){this.a=d},
wR:function wR(d){this.a=d},
a_T:function a_T(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bJs:function bJs(d){this.a=d},
bJr:function bJr(d,e){this.a=d
this.b=e},
bJt:function bJt(d){this.a=d},
bJq:function bJq(d,e){this.a=d
this.b=e},
bJu:function bJu(){},
bJe:function bJe(){},
bJk:function bJk(d,e,f){this.a=d
this.b=e
this.c=f},
bJl:function bJl(){},
bJo:function bJo(d){this.a=d},
bJn:function bJn(){},
bJp:function bJp(d){this.a=d},
bJh:function bJh(d,e){this.a=d
this.b=e},
bJi:function bJi(d){this.a=d},
bJg:function bJg(){},
bJj:function bJj(d){this.a=d},
bJf:function bJf(d){this.a=d},
bJm:function bJm(d,e){this.a=d
this.b=e},
Hk:function Hk(d,e,f){this.c=d
this.d=e
this.a=f},
XJ:function XJ(d,e){this.c=d
this.a=e},
c4b:function c4b(d,e,f){this.a=d
this.b=e
this.c=f},
c48:function c48(d,e,f){this.a=d
this.b=e
this.c=f},
c4a:function c4a(d,e){this.a=d
this.b=e},
c47:function c47(d,e){this.a=d
this.b=e},
c46:function c46(d,e){this.a=d
this.b=e},
c49:function c49(d,e){this.a=d
this.b=e},
c42:function c42(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c41:function c41(d,e,f){this.a=d
this.b=e
this.c=f},
c43:function c43(d){this.a=d},
c44:function c44(d){this.a=d},
c45:function c45(d,e){this.a=d
this.b=e},
E6:function E6(d,e){this.a=d
this.b=e},
D6:function D6(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2l:function a2l(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bWT:function bWT(){},
bX8:function bX8(d,e){this.a=d
this.b=e},
bXc:function bXc(d){this.a=d},
bXd:function bXd(d){this.a=d},
bXe:function bXe(d,e,f){this.a=d
this.b=e
this.c=f},
bXg:function bXg(d){this.a=d},
bXh:function bXh(d){this.a=d},
bXf:function bXf(){},
bXj:function bXj(d){this.a=d},
bXi:function bXi(d){this.a=d},
bXk:function bXk(d,e){this.a=d
this.b=e},
bXm:function bXm(d){this.a=d},
bXn:function bXn(d){this.a=d},
bXl:function bXl(){},
bX7:function bX7(d,e,f){this.a=d
this.b=e
this.c=f},
bX9:function bX9(d,e,f){this.a=d
this.b=e
this.c=f},
bX0:function bX0(d){this.a=d},
bX1:function bX1(d){this.a=d},
bX_:function bX_(){},
bX2:function bX2(){},
bX3:function bX3(d,e){this.a=d
this.b=e},
bXs:function bXs(d){this.a=d},
bXt:function bXt(d){this.a=d},
bXu:function bXu(d,e){this.a=d
this.b=e},
bXr:function bXr(d){this.a=d},
bXv:function bXv(d,e){this.a=d
this.b=e},
bX6:function bX6(){},
bX5:function bX5(d){this.a=d},
bX4:function bX4(d,e){this.a=d
this.b=e},
bXb:function bXb(d){this.a=d},
bXa:function bXa(d){this.a=d},
bXo:function bXo(){},
bXp:function bXp(){},
bXq:function bXq(){},
bWU:function bWU(d,e,f){this.a=d
this.b=e
this.c=f},
bWV:function bWV(d){this.a=d},
bWX:function bWX(){},
bWW:function bWW(){},
bWY:function bWY(d){this.a=d},
bWZ:function bWZ(d){this.a=d},
Dp:function Dp(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
D5:function D5(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2k:function a2k(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bWC:function bWC(){},
bWL:function bWL(d,e){this.a=d
this.b=e},
bWM:function bWM(d){this.a=d},
bWK:function bWK(){},
bWO:function bWO(d){this.a=d},
bWN:function bWN(d,e){this.a=d
this.b=e},
bWP:function bWP(d,e){this.a=d
this.b=e},
bWG:function bWG(d,e){this.a=d
this.b=e},
bWH:function bWH(d,e,f){this.a=d
this.b=e
this.c=f},
bWI:function bWI(d,e,f){this.a=d
this.b=e
this.c=f},
bWD:function bWD(d,e,f){this.a=d
this.b=e
this.c=f},
bWE:function bWE(d,e,f){this.a=d
this.b=e
this.c=f},
bWF:function bWF(d,e){this.a=d
this.b=e},
bWJ:function bWJ(d){this.a=d},
bWQ:function bWQ(){},
bWR:function bWR(d,e){this.a=d
this.b=e},
bWS:function bWS(d,e){this.a=d
this.b=e},
D4:function D4(d){this.a=d},
a2j:function a2j(d){this.d=d
this.c=this.a=null},
bWt:function bWt(){},
bWA:function bWA(d){this.a=d},
bWB:function bWB(){},
bWz:function bWz(d,e){this.a=d
this.b=e},
bWy:function bWy(d,e,f){this.a=d
this.b=e
this.c=f},
bWx:function bWx(d,e,f){this.a=d
this.b=e
this.c=f},
bWw:function bWw(d){this.a=d},
bWu:function bWu(d){this.a=d},
bWv:function bWv(d){this.a=d},
c5_:function c5_(d){this.a=d},
c4Z:function c4Z(d){this.a=d},
c4U:function c4U(d,e){this.a=d
this.b=e},
c4W:function c4W(){},
c4V:function c4V(){},
c4X:function c4X(d,e){this.a=d
this.b=e},
c4Y:function c4Y(d,e){this.a=d
this.b=e},
aj4:function aj4(d){this.a=d},
b50:function b50(d){this.a=d},
c5f:function c5f(){},
c5g:function c5g(){},
D7:function D7(d,e,f){this.c=d
this.d=e
this.a=f},
a2m:function a2m(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bXw:function bXw(d){this.a=d},
bXx:function bXx(d){this.a=d},
bXy:function bXy(d,e){this.a=d
this.b=e},
bXz:function bXz(d){this.a=d},
bXB:function bXB(d){this.a=d},
bXA:function bXA(d){this.a=d},
c5e:function c5e(){}},D,O,P,I,E,F
J=c[1]
A=c[0]
C=c[2]
L=c[15]
M=c[19]
Q=c[21]
H=c[13]
G=c[32]
N=c[31]
R=c[10]
K=c[37]
B=a.updateHolder(c[8],B)
D=c[38]
O=c[29]
P=c[35]
I=c[27]
E=c[16]
F=c[18]
B.aj5.prototype={
ra(){var x=this,w=x.a
if(w!=null)return A.ei(w,y.m)
w=x.b
return w==null?x.b=new B.b51(x).$0():w},
uo(d,e){return this.aNd(d,e,e)},
aNd(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
var $async$uo=A.e(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$uo)
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
r=B.czr(s)
throw A.r(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$uo,w)},
or(d,e){var x=A.eg(d[e])
if(x==null)x=null
return x===!0},
MP(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$MP=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.ra(),$async$MP)
case 7:r=h.d3(g.cU(e,"support",null,null,null,null))
q=s.or(r,"worker")
p=s.or(r,"wasm")
o=s.or(r,"mic")
n=s.or(r,"audio")
s.or(r,"webgpu")
m=s.or(r,"secure")
s.or(r,"ios")
l=A.jQ(r.memory)
if(l==null)l=null
if(l==null)l=0
s.or(r,"isolated")
k=A.jQ(r.cores)
if(k!=null)C.f.ak(k)
v=new B.Vr(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a3t
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$MP,w)},
Eq(){var x=0,w=A.j(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Eq=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.ra(),$async$Eq)
case 8:x=7
return A.c(m.eF(l.d3(k.cU(e,"storage",null,null,null,null)),y.A),$async$Eq)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.ak(A.dN(r.quota))
p=C.f.ak(A.dN(r.usage))
v=new A.ata(q,p)
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
return A.i($async$Eq,w)},
bjc(){var x=y.K
A.Pz(this.ra().bG(new B.b54(),x),x)},
r9(d,e){var x=A.jQ(d[e])
x=x==null?null:C.f.ak(x)
return x==null?0:x},
bgy(d,e,f){return this.uo(new B.b53(this,d,e,f),y.C)},
gaku(){var x,w
try{x=A.kj(b.G.sessionStorage)
return x}catch(w){return null}},
garY(){var x=A.eg(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a90(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.eg(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.garY())return!1
l=A.eg(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.d3(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.Y(x.userAgent)
l=A.jQ(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.u(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aC("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.k(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aC("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.jQ(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.gaku()
l=l==null?f:A.u(A.cU(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dT(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.kj(m.localStorage)
m=o
m=m==null?f:A.u(A.cU(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dT(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
aqv(){var x,w,v,u,t,s,r=null
try{x=this.gaku()
if(x!=null)A.cU(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.d3(x.location)
u=A.Y(v.hash)
t=A.Y(v.search)
s=A.bz(A.Y(A.d3(x.document).baseURI),0,r).a1("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cU(v,"replace",s+t+x,r,r,r)},
bgh(){var x,w=null,v=b.G,u=A.d3(v.history),t=A.jQ(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cU(u,"back",w,w,w,w)
else{x=A.Y(A.d3(v.document).baseURI)
A.cU(A.d3(v.location),"replace",A.bz(x,0,w).a1("./").k(0)+"#/",w,w,w)}},
a9c(d,e,f,g,h){return this.uo(new B.b58(this,e,d,f,h,g),y.H)},
a9f(){return this.uo(new B.b59(this),y.D)},
a3n(){var x=null,w=this.a
if(w!=null)A.cU(w,"cancelRecording",x,x,x,x)},
alS(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.r9(d,"ms")
w=A.jQ(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.JH(u,x,w,v.r9(d,"frames"),v.r9(d,"tokens"),v.or(d,"retried"),v.r9(d,"encMs"),v.r9(d,"decMs"),v.r9(d,"featMs"))},
aih(d){var x={}
x.words=d
return x},
av_(d,e){return this.uo(new B.b5b(this,d,e),y._)},
blp(d,e){return this.uo(new B.b5a(this,d,e),y._)},
KR(d,e){return this.bji(d,e)},
bji(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$KR=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.ra(),$async$KR)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.al(d).i("au<1,o>")
o=A.aa(new A.au(d,new B.b55(),o),o.i("aW.E"))
x=11
return A.c(A.eF(A.d3(A.cU(r,"play",o,e,null,null)),y.y),$async$KR)
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
return A.i($async$KR,w)},
Mw(){var x=null,w=this.a
if(w!=null)A.cU(w,"stopPlayback",x,x,x,x)},
Jj(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.Y(A.cU(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bky(){var x,w,v=null
try{x=this.a
if(x!=null)A.cU(x,"resetDevice",v,v,v,v)}catch(w){}},
a6E(d){var x=this.a
if(x!=null)A.cU(x,"prefetch",d,null,null,null)}}
B.Vr.prototype={}
B.JF.prototype={
gn3(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.JH.prototype={
gST(){var x=this,w=C.f.az(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.JG.prototype={}
B.lE.prototype={
gl2(){var x,w=this.a
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
$ibP:1}
B.nz.prototype={
R(){return"WordStatus."+this.b}}
B.Sy.prototype={}
B.mV.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Ij.prototype={
gMu(){var x,w=this,v=w.d
if(v===$){x=new B.aWh(w).$0()
w.d!==$&&A.ap()
w.d=x
v=x}return v},
gJC(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a3U&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbhp(){return J.h6(this.gMu(),new B.aWg()).gM(0)},
gts(){var x=this.a
return x.length!==0&&this.gbhp()===x.length&&this.gJC().length===0}}
B.F7.prototype={
R(){return"AyahStatus."+this.b}}
B.rr.prototype={}
B.aj6.prototype={
a6f(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.rg():x},
aZS(d){var x=this,w=B.b5e(d),v=x.c
if(v===w)return
v=v!=null&&v===B.chF(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
apH(){var x=Date.now(),w=B.b5e(new A.aR(x,0,!1))
x=this.c
return x===w||x===B.chF(w)?this.d:0},
au2(d,e,f,g){var x=this,w=new A.aR(Date.now(),0,!1),v=x.a6f(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.fh:D.p8,s=new B.rr(t,u,w.hd()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.aZS(w)
return s},
a66(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cO[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rg():s).a===D.fh)++u}return u},
bgf(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cO[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rg():s).a===D.p8)++u}return u},
gat5(){var x=this.a,w=A.y(x).i("cf<2>")
return new A.ak(new A.cf(x,w),new B.b5f(),w.i("ak<a_.E>")).gM(0)},
gayE(){var x=this.a,w=A.y(x).i("bK<1>")
w=A.mp(new A.bK(x,w),new B.b5g(),w.i("a_.E"),y.S)
w=A.eQ(w,A.y(w).i("a_.E"))
x=A.aa(w,A.y(w).c)
C.b.mt(x)
return x},
dw(){var x,w,v,u,t,s=this,r=y.N,q=A.C(r,y.L)
for(x=s.a,x=new A.eu(x,A.y(x).i("eu<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.aa(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
bca(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b3A(x,300,A.y(x).c),x=new A.Jn(J.aB(x.a),x.b,A.y(x).i("Jn<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gI()
s=C.j.aH(t,1000)
t=C.j.a2(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.rg():q).a===D.fh?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.rg()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.rg():r).c.j7()],w,v))}return o},
bgQ(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.L)(d),++u){t=d[u]
s=A.eD(t.h(0,"surah"))*1000+A.eD(t.h(0,"ayah"))
r=w.h(0,C.j.aH(s,1000)*1000+C.j.a2(s,1000))
if((r==null?$.rg():r).c.j7()===t.h(0,"updated_at"))v.K(0,s)}},
bgY(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aB(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gI()
if(!u.b(s))continue
r=A.aE(s.h(0,"surah"))
q=r==null?null:C.f.bW(r)
r=A.aE(s.h(0,"ayah"))
p=r==null?null:C.f.bW(r)
o=A.dQ(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cO[q-1].a[1])
if(r)continue
n=B.cF3(s.h(0,"status"))
if(n===D.p7)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.aE(s.h(0,"perfect_count"))
l=l==null?null:C.f.bW(l)
v.p(0,r,new B.rr(n,C.j.d1(l==null?0:l,0,100),o.hd()))
w.K(0,r)
t=!0}return t}}
B.Vp.prototype={
J2(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Vp(w,v,u,t,f==null?x.e:f)},
bap(d){var x=null
return this.J2(x,x,d,x,x)},
apc(d){var x=null
return this.J2(x,d,x,x,x)},
bat(d){var x=null
return this.J2(x,x,x,x,d)},
b9M(d){var x=null
return this.J2(d,x,x,x,x)},
baq(d){var x=null
return this.J2(x,x,x,d,x)},
dw(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Hj.prototype={
R(){return"ModelState."+this.b}}
B.Vq.prototype={
vD(){var x=this.Q
return x==null?this.Q=new B.b5h(this).$0():x},
qK(d){return this.awS(d)},
awS(d){var x=0,w=A.j(y.H),v=this
var $async$qK=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a4()
x=2
return A.c(A.ii("mt.tutor.settings",C.ap.i8(d.dw(),null)),$async$qK)
case 2:return A.h(null,w)}})
return A.i($async$qK,w)},
zL(){var x=0,w=A.j(y.H),v=this,u
var $async$zL=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a4()
x=2
return A.c(A.ii("mt.tutor.progress",C.ap.i8(v.c.dw(),null)),$async$zL)
case 2:u=v.as
if(u!=null)u.aB()
v.as=A.cO(C.x,v.gaDG())
return A.h(null,w)}})
return A.i($async$zL,w)},
Me(d,e,f){return this.axE(d,e,f)},
axE(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$Me=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.b_(d,e,f)
x=2
return A.c(A.ii("mt.tutor.last",C.ap.i8(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Me)
case 2:return A.h(null,w)}})
return A.i($async$Me,w)},
Da(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Da=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.UP||n===D.jS){x=1
break}s.f=D.UP
s.y=null
s.a4()
u=4
n=A.lF().geK().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lF().geK().h(0,"tutor_threads")
p=A.dT(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bgy(new B.b5i(s),n,p),$async$Da)
case 7:s.x=e
s.f=D.jS
n=A.lF().geK().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.rc().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a8(m)
if(n instanceof B.lE){q=n
s.f=D.aSl
s.y=q
n=A.lF().geK().h(0,"debug")
if(n==="1")A.rc().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a4()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Da,w)},
wA(){var x=0,w=A.j(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wA=A.e(function(a0,a1){if(a0===1){t.push(a1)
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
return A.c(p.aS("quran_tutor_progress").da("surah, ayah, status, perfect_count, updated_at"),$async$wA)
case 7:o=a1
n=r.c.bgY(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bca()
if(J.aP(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.n2(h.x,k,k))
x=11
return A.c(f.bkW("quran_tutor_save",!1,g,i),$async$wA)
case 11:r.c.bgQ(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.ii("mt.tutor.progress",C.ap.i8(r.c.dw(),null)),$async$wA)
case 12:if(n)r.a4()
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
return A.i($async$wA,w)},
L7(d){return this.bkA(d)},
bkA(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$L7=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c8u(t.c.dw()).dw()
y.f.a(p.h(0,"rows")).ej(0,new B.b5j(d))
t.c=B.c8u(p)
x=2
return A.c(t.zL(),$async$L7)
case 2:v=4
s=$.B().b
s===$&&A.b()
r=s.ga3().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.ar("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$L7)
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
return A.i($async$L7,w)}}
B.wR.prototype={
P(){var x=$.MJ()
return new B.a_T(x,new A.ag(C.K,$.V()))}}
B.a_T.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goD())
w=y.a
x.vD().bG(new B.bJs(v),w)
H.aUK().bG(new B.bJt(v),w).fw(new B.bJu())
A.Pz(H.c7Q(),y.y)},
xL(){if(this.c!=null)this.j(new B.bJe())},
m(){var x,w=this
w.d.T(w.goD())
x=w.e
x.q$=$.V()
x.L$=0
w.a0()},
PV(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$PV=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qK(s.b.bap(!0)),$async$PV)
case 3:t=s.a
t.bjc()
if(t.a90()){t.aqv()
x=1
break}s.Da()
case 1:return A.h(v,w)}})
return A.i($async$PV,w)},
xM(d,e,f){return this.aXL(d,e,f)},
b5w(d){return this.xM(d,null,null)},
aXL(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$xM=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.J(y.q).f.Z(A.aL(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.U(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cIT(s,d),$async$xM)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Me(d,t.a,t.b),$async$xM)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aA(A.ax(new B.bJk(u,d,t),null,r),r),$async$xM)
case 8:if(u.c!=null)u.j(new B.bJl())
case 1:return A.h(v,w)}})
return A.i($async$xM,w)},
u(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.garY()&&!A.O(d,!1).v7())u.push(A.bQ(x,x,x,x,C.ym,x,x,t.gbgg(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bQ(x,x,x,x,D.atB,x,x,new B.bJo(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bQ(x,x,x,x,C.ix,x,x,new B.bJp(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aGi
else w=t?this.aSC():this.aTd()
return L.xB(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aTd(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a3t
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b6b,C.a1],x)
for(t=0;t<4;++t){s=D.aIp[t]
u.push(new A.F(C.bs,A.A(A.a([A.b0(s.a,C.am,p,18),C.M,new A.bU(1,C.ad,A.d(s.b,p,p,p,p,G.a12,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bxl,C.F,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bq(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aL,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bq(C.f.ak(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.F,A.d(q,p,p,p,p,A.bJ(p,p,r?D.dX:C.cG,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.F,D.bwn],x))
x=A.a([new E.dz(u,C.a4,C.aO,p,!0,p),new E.dz(A.I(s,C.q,C.d,C.e,0,C.l),C.a4,C.aO,p,!1,p),D.bFC,C.F],x)
if(v!=null)x.push(new E.dz(A.d(v,p,p,p,p,D.bh9,p,p,p),C.a4,C.aO,p,!1,p))
else x.push(A.fn(D.aqt,D.bn0,this.gaY2(),A.eA(C.v,C.ae,D.b9b,p,p,p,p)))
x.push(C.a5)
x.push(D.a3p)
return x},
aSC(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.O(r.a.a),p=q.length===0,o=p?C.ro:H.cmt(q),n=t.z,m=A.R(v.al9(C.dw,E.bq(s.gat5())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bq(s.apH()),k=s.c,j=Date.now()
k=k===B.b5e(new A.aR(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Hk(t,!1,u),A.A(A.a([m,C.M,A.R(v.al9(C.l6,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.t],j)
if(n!=null){t=H.kl(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bq(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bq(m)+"\u2013"+E.bq(l)
k.push(new E.dz(A.A(A.a([D.asI,C.Y,A.R(A.I(A.a([D.bj6,A.d(t+" \u2014 "+m,u,u,u,u,C.bw,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nz],j),C.h,C.d,C.e,0,u,u),C.a4,C.aO,new B.bJh(v,n),!0,u))}t=C.i.ad(0.08)
k.push(A.aH(u,C.y,!1,u,!0,C.m,u,A.aI(),r,u,u,u,u,u,2,A.cG(u,new A.cj(4,A.v(14),C.N),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.ua,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qK,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bJi(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.cS,!0,C.u,u,C.E,u,u,u,u))
k.push(C.t)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bso)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.Rd(o[x]))
C.b.A(k,t)}else{t=A.a([D.aVB,D.aWh,v.Rd(1)],j)
for(w=114;w>=78;--w)t.push(v.Rd(w))
t.push(C.F)
r=v.f
p=A.b0(r?C.y2:C.l5,C.am,u,u)
t.push(A.fH(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.fa,u,u,u),new B.bJj(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Rd(w))
C.b.A(k,t)}k.push(C.a1)
k.push(D.C3)
return k},
al9(d,e,f){var x=null,w=y.p
return new E.dz(A.A(A.a([A.b0(d,C.v,x,x),C.M,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bw,x,x,x),A.d(f,1,C.O,x,x,C.a1I,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a4,C.J,x,!1,x)},
Rd(d){var x,w=null,v=this.d.c,u=I.cO[d-1].a[1],t=v.a66(d),s=t/u,r=y.p,q=A.ao(A.dA(C.P,A.a([A.c6g(C.eS,G.cM,w,w,w,w,w,3,s,w),A.d(E.bq(d),w,w,w,w,Q.a23,w,w,w)],r),C.m,C.bk,w),36,36),p=A.d(H.kl(d),w,w,w,w,D.bc_,w,w,w)
if(t===0)x=E.bq(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bq(t)+" \u0645\u0646 "+E.bq(u)
r=A.a([q,C.cE,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bJ(w,w,t===u?G.cM:C.cG,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bq(C.f.ak(s*100))+"\u066a",w,w,w,w,D.a1y,w,w,w))
r.push(D.aqB)
return new E.dz(A.A(r,C.h,C.d,C.e,0,w,w),C.q2,C.d_,new B.bJm(this,d),!1,w)}}
B.Hk.prototype={
u(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b1
return D.aVm
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.MC(x),r,r,r,r,D.Be,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.D7(w,"model load",r))
x.push(C.F)
x.push(new A.zP(C.a4e,!1,q.gbgx(),r,r,r,r,C.k,r,!1,r,!0,r,C.up,r))
return new E.dz(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aO,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bq(C.f.ak(u/1e6))+" \u0645\u0646 "+E.bq(C.f.ak(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.oF,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.ff(x,A.q6(C.eS,C.v,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.F,D.bnR],w))
return new E.dz(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aO,r,!1,r)}}}
B.XJ.prototype={
u(d){var x=null,w=D.dX.ad(0.1),v=A.v(14),u=A.aJ(D.dX.ad(0.4),1)
return A.D(x,A.A(A.a([D.asl,C.M,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.Bk,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.G(w,x,u,v,x,x,x,C.n),x,x,C.aO,C.ac,x,x,x)}}
B.E6.prototype={
R(){return"_Phase."+this.b}}
B.D6.prototype={
P(){return new B.a2l($.MJ(),D.mk)}}
B.a2l.prototype={
gjc(){var x=this.e
return x===$?this.e=this.a.d:x},
gBJ(){var x,w=this.a,v=w.f
w=w.c
x=this.gjc()
return H.MA(w,x,v.xW(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.ac(w.goD())
x.vD()
x.a.a6E(B.azF(w.a.c,w.gjc()))},
xL(){if(this.c!=null)this.j(new B.bWT())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.Q
if(x!=null)x.aB()
v=v.a
v.Mw()
v.a3n()
w.a0()},
a_2(d){var x,w,v=this
if(v.f===D.uY)v.d.a.a3n()
x=v.d.a
x.Mw()
w=v.Q
if(w!=null)w.aB()
v.j(new B.bX8(v,d))
x.a6E(B.azF(v.a.c,d))
w=v.a
if(d<w.e)x.a6E(B.azF(w.c,d+1))},
Ru(d){return this.aU4(d)},
aU4(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$Ru=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.uX){u.d.a.Mw()
u.j(new B.bXc(u))
x=1
break}t=u.r!=null?D.j9:D.mk
u.j(new B.bXd(u))
s=u.d
r=A.a([B.azF(u.a.c,u.gjc())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.KR(r,q),$async$Ru)
case 3:p=f
if(u.c==null||u.f!==D.uX){x=1
break}u.j(new B.bXe(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$Ru,w)},
Qj(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Qj=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jS){x=1
break}p=l.a
p.Mw()
r=B.EP(s.gBJ()).length
s.j(new B.bXg(s))
o=s.Q
if(o!=null)o.aB()
s.Q=A.hD(C.eW,new B.bXh(s))
u=4
o=B.caf(r)
n=A.dn(0,0,0,350*r,0,0)
x=7
return A.c(p.a9c(l.b.c,o,n,new B.bXi(s),new B.bXj(s)),$async$Qj)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lE){q=l
l=s.Q
if(l!=null)l.aB()
if(s.c!=null)s.j(new B.bXk(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Qj,w)},
BC(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$BC=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.uY){x=1
break}m=s.Q
if(m!=null)m.aB()
s.j(new B.bXm(s))
s.Q=A.hD(C.ir,new B.bXn(s))
l=new A.Cy()
$.ES()
l.om()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a9f(),$async$BC)
case 7:q=e
if(q.b<0.8){s.b5v("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.av_(q,B.EP(s.gBJ()).length),$async$BC)
case 8:p=e
s.ch=A.dn(0,0,r.ga4H(),0,0,0)
k=A.lF().geK().h(0,"debug")
if(k==="1"){o=B.cmJ(m.Jj())
A.rc().$1("[tutor] "+s.a.c+":"+s.gjc()+" audio="+C.f.az(q.b,1)+"s infer="+p.b+"ms total="+r.gCw()+"ms "+p.gST()+" text="+p.a)
A.rc().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.az(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(p.b/1000,2)+" \u062b\n"+p.gST()+"\n"+A.n(o)+"\n"+p.a}s.afm(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lE){n=m
m=A.lF().geK().h(0,"debug")
if(m==="1")A.rc().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.Jj())
s.a2c(B.MC(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$BC,w)},
a2c(d,e){var x=this,w=x.Q
if(w!=null)w.aB()
if(x.c==null)return
x.j(new B.bX7(x,d,e))},
b5v(d){return this.a2c(d,null)},
afm(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aB()
if(s.c==null)return
x=B.ckL(s.gBJ(),d)
r.a=null
if(C.c.O(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjc()
t=x.gts()
r.a=w.au2(v,u,q.b.a,t)
q.zL()}s.j(new B.bX9(r,s,x))},
NV(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$NV=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jS){x=1
break}s.j(new B.bX0(s))
l=s.Q
if(l!=null)l.aB()
s.Q=A.hD(C.ir,new B.bX1(s))
k=new A.Cy()
$.ES()
k.om()
r=k
u=4
l=g.a
x=7
return A.c(l.blp(B.azF(s.a.c,s.gjc()),B.EP(s.gBJ()).length),$async$NV)
case 7:q=e
p=B.cmJ(l.Jj())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.az(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.az(r.gCw()/1000,2)+" \u062b)\n"+q.gST()+"\n"+A.n(p)+"\n"+q.a
A.rc().$1("[tutor-debug] "+s.a.c+":"+s.gjc()+" audio="+C.f.az(q.c,1)+"s infer="+q.b+"ms total="+r.gCw()+"ms "+q.gST()+" text="+q.a)
A.rc().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dn(0,0,r.ga4H(),0,0,0)
s.afm(q.a)
n=s.r
if(n!=null){l=n.gts()
j=n.b
i=A.al(j).i("ak<1>")
j=A.aa(new A.ak(j,new B.bX2(),i),i.i("a_.E"))
A.rc().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.bX3(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lE){m=l
A.rc().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.Jj())
s.a2c(B.MC(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$NV,w)},
ga0Z(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.rg():v).a!==D.fh)return!1}return!0},
u(d){var x,w=this,v=null,u=w.d,t=u.c.a6f(w.a.c,w.gjc()),s=u.b,r=s.d&&!w.x&&w.f!==D.j9,q=H.kl(w.a.c),p=y.p,o=A.a([A.bQ(v,v,v,v,C.ix,v,v,new B.bXs(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aKs(),m=A.d("\u0622\u064a\u0629 "+E.bq(w.gjc()),v,v,v,v,C.m1,v,v,v),l=E.bq(w.gjc()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.aX,A.d("("+l+" \u0645\u0646 "+E.bq(k.e-k.d+1)+")",v,v,v,v,F.aL,v,v,v),C.bB,w.aYI(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.t],p)
if(r)s.push(w.aSx())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.uY&&l!==D.oZ}else l=!1
if(l)s.push(w.aI7(m))
else s.push(A.d(w.gBJ()+" \ufd3f"+E.bq(w.gjc())+"\ufd3e",v,v,v,v,D.kf,C.Z,C.bi,v))}s=A.a([new B.Hk(u,!0,v),n,C.B,new E.dz(A.I(s,C.ag,C.d,C.e,0,C.l),D.aji,C.aO,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.j9)s.push(w.b7_(n))
if(w.r!=null&&w.f===D.j9&&w.ch!=null){x=C.f.ak(C.j.aH(w.ch.a,1000)/100)
s.push(new A.F(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bq(C.j.aH(x,10))+"\u066b"+E.bq(C.j.a2(x,10)))+" \u062b",v,v,v,v,F.aL,C.Z,v,v),v))}n=w.as
if(n!=null)s.push(new A.F(C.aO,A.d(n,v,v,v,v,D.Be,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.D7(n,"check "+w.a.c+":"+w.gjc(),v))}s.push(w.aIG())
s.push(C.a1)
s.push(A.is(C.v,C.J,v,new B.bXt(w),D.bkQ,D.bq7,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga0Z()
s.push(new E.dz(A.A(A.a([D.ap4,C.Y,A.R(A.I(A.a([D.brL,A.d(w.ga0Z()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aL,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nz],p),C.h,C.d,C.e,0,v,v),C.a4,C.aO,new B.bXu(w,d),n,v))}n=A.lF().geK().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dj(D.aqs,D.bpy,u.f===D.jS&&w.f!==D.oZ?w.gaJp():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.F(C.is,A.xc(n,F.aL,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn3()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aL,v,v,v))}p.push(A.bh(D.bqV,v,v,v,new B.bXv(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.C3)
return L.xB(o,s,q)},
aKs(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b1
return A.ao(A.fr(new B.bX5(this),w,null,C.af,new B.bX6()),36,null)},
aYI(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fh)return D.b6n
x=d.b
w=E.bq(x)
v=E.bq(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.bV:C.y7
u.push(new A.F(D.ak_,A.b0(r,s?G.cM:C.eT,q,16),q))}return A.aj_(A.A(u,C.h,C.d,C.L,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aSx(){var x=null
return A.bw(!1,A.v(12),!0,A.D(x,D.afo,C.k,x,x,new A.G(C.pz,x,x,A.v(12),x,x,x,C.n),x,x,x,D.aiR,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bXb(this),x,x,x,x,x,x,x)},
aI7(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gMu(),w)
A:{if(D.j2===v){u=D.kf.ct(G.cM)
break A}if(D.uG===v){u=D.kf.a40(D.dX,C.hm,D.dX)
break A}if(D.uH===v){u=D.kf.a40(D.eR,C.hm,D.eR)
break A}u=D.kf.a40(C.eT,C.kb,C.cc)
break A}t=x[w]
r.push(new A.eL(t.a,s,s,C.br,s,s,s,s,s,s,u))
r.push(P.B6)}x=E.bq(this.gjc())
r.push(A.eq(s,s,s,s,s,s,s,s,s,D.kf.ct(C.am),"\ufd3f"+x+"\ufd3e"))
return A.CL(A.eq(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Z,C.bi)},
b7_(d){var x,w,v,u,t,s,r=this.w
if(C.c.O(d.c).length===0)return D.bEZ
if(d.gts()){x=r==null
if((x?null:r.a)===D.fh&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fh?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bq(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.Dp(G.cM,C.bV,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMu()
w=J.dB(x)
v=w.iE(x,new B.bXo()).gM(0)
u=w.iE(x,new B.bXp()).gM(0)
t=w.iE(x,new B.bXq()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bq(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bq(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bq(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJC().length!==0)x.push(E.bq(d.gJC().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eR:D.dX
x=C.b.aC(x," \u2022 ")
s=d.gJC().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aC(d.gJC(),"\u060c "):""
return new B.Dp(w,C.np,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aIG(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jS,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aH(new A.aR(f,0,!1).dG(w).a,1e6)}v=C.j.aH(B.caf(B.EP(j.gBJ()).length).a,1e6)
f=j.gb44()
w=96+26*j.y
u=D.eR.ad(0.25)
w=A.iN(i,A.a5a(C.P,A.D(i,D.aqE,C.k,i,i,D.a7h,i,84,i,i,i,i,84),i,C.aU,new A.G(u,i,i,i,i,i,i,C.c_),C.F_,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cP)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c9b(x)+" / "+B.c9b(v),i,i,i,i,K.oE,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aL,i,i,i),A.bh(D.bwm,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.ey((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bq(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bq(t)+" \u062b)"
return new A.F(C.q_,A.I(A.a([C.vL,C.a1,D.boj,A.d(h,i,i,i,i,F.aL,C.Z,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.uX
r=j.r
f=r==null
w=!f
q=w&&r.gts()
u=A.b0(s?C.nq:K.Hx,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.eA(i,i,D.b98,i,i,i,i)
u=A.R(new A.zP(C.a4e,!0,new B.bWU(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Yk(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.J9[n]
p.push(new A.em(m,i,A.d("\xd7"+E.bq(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.M,A.oP(new B.bWV(j),p,A.db([h.b.b],o),!1,A.kp(i,i,i,new A.be(new B.bWW(),l),i,i,i,i,new A.be(new B.bWX(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cJ),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb_I():i
u=A.b0(f?D.qy:C.np,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cF,i,i,i)
p=q?C.im:C.v
h=A.a([o,C.t,A.fn(u,f,h,A.eA(p,q?C.i:C.ae,D.tL,i,i,i,i))],k)
if(w&&j.gjc()<j.a.e)C.b.A(h,A.a([C.B,q?A.fn(D.au0,D.bv3,new B.bWY(j),A.eA(G.cM,C.ae,D.tL,i,i,i,i)):A.bh(D.blf,i,i,i,new B.bWZ(j),i,i)],k))
if(w){f=j.gjc()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.F(C.jt,A.d(j.ga0Z()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,K.uj,C.Z,i,i),i))
return A.I(h,C.ag,C.d,C.e,0,C.l)}}}
B.Dp.prototype={
u(d){var x=this,w=null,v=x.c,u=v.ad(0.12),t=A.v(14),s=A.aJ(v.ad(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b0(x.d,v,w,w),C.M,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bJ(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.W,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bP,A.d(x.f,w,w,w,w,C.Bk,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.G(u,w,s,t,w,w,w,C.n),w,w,C.aO,C.ac,w,w,w)}}
B.D5.prototype={
P(){var x=y.S
return new B.a2k($.MJ(),A.C(x,y.B),A.aS(x),A.C(x,y.N),A.ei(null,y.H))}}
B.a2k.prototype={
W(){this.Y()
this.d.ac(this.goD())},
xL(){if(this.c!=null)this.j(new B.bWC())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.y
if(x!=null)x.aB()
v.a.a3n()
w.a0()},
I7(d){return this.b3R(d)},
b3R(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$I7=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.bWL(t,d))
r=t.y
if(r!=null)r.aB()
t.y=A.hD(C.eW,new B.bWM(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.caf(B.EP(H.MA(q,d,p.xW(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dn(0,0,0,350*B.EP(H.MA(p,d,o.xW(p,d)).b).length,0,0)
x=6
return A.c(r.a.a9c(r.b.c,q,p,new B.bWN(t,d),new B.bWO(t)),$async$I7)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lE){s=r
r=t.y
if(r!=null)r.aB()
if(t.c!=null)t.j(new B.bWP(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$I7,w)},
FC(d,e){return this.aLC(d,e)},
aLC(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$FC=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aB()
s.j(new B.bWG(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a9f()
if(e&&n!=null)s.I7(n)
q=null
u=4
x=7
return A.c(r,$async$FC)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lE){p=o
s.j(new B.bWH(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bG(new B.bWI(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$FC,w)},
gaWd(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b0z(){this.j(new B.bWJ(this))},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jS,o=s.e,n=s.gaWd(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("cf<2>")
x=new A.ak(new A.cf(m,l),new B.bWQ(),l.i("ak<a_.E>")).gM(0)
l=H.kl(s.a.c)
m=y.p
q=A.a([new B.Hk(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bq(s.a.d)+" \u0644\u062d\u062f "+E.bq(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aL,r,r,r),C.t],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b5x(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.Be,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.D7(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bq(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aH(new A.aR(v,0,!1).dG(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c9b(v),r,r,r,r,K.oE,C.Z,r,r)
j=A.ff(A.v(6),A.q6(C.eS,D.eR,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b0(u?O.Hq:C.nq,r,r,r)
C.b.A(q,A.a([v,C.F,j,C.t,A.fn(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cF,r,r,r),new B.bWR(s,o),A.eA(C.v,C.ae,D.tL,r,r,r,r))],m))}else if(n!=null){j=p?new B.bWS(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bq(n)
q.push(A.fn(D.arO,A.d(v,r,r,r,r,C.cF,r,r,r),j,A.eA(C.v,C.ae,D.tL,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aVM)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cM:D.dX
v=k?C.ng:C.np
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bq(x)
u=s.a
u=k+" \u0645\u0646 "+E.bq(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.Dp(j,v,k,u,r),A.dj(D.atN,D.bvJ,s.gb0y(),r)],m))}q.push(C.t)
q.push(D.C3)
return L.xB(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b5x(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.ar9
else if(l.r.n(0,d))x=N.tO
else if(i!=null)x=D.arq
else if(j!=null){w=j.gts()?C.bV:D.anB
x=A.b0(w,j.gts()?G.cM:D.dX,k,k)}else x=D.apK
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bq(d),k,k,k,k,D.bgm,k,k,k),C.bB,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.a1K,k,k,k))
if(j!=null&&!j.gts()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMu()
o=J.bf(p)
n=o.h(p,r)
A:{if(D.j2===n){m=G.cM
break A}if(D.uG===n){m=D.dX
break A}if(D.uH===n){m=D.eR
break A}m=C.eT
break A}m=D.kf.bb4(m,o.h(p,r)===D.uI?C.kb:k,22)
C.b.A(t,A.a([new A.eL(q.a,k,k,C.br,k,k,k,k,k,k,m),P.B6],u))}w=A.a([C.ai,A.CL(A.eq(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Z,C.bi)],w)
if(C.c.O(j.c).length===0)w.push(D.br9)
C.b.A(v,w)}return new E.dz(A.I(v,C.ag,C.d,C.e,0,C.l),C.bM,C.d_,k,!1,k)}}
B.D4.prototype={
P(){return new B.a2j($.MJ())}}
B.a2j.prototype={
W(){this.Y()
var x=this.d
x.ac(this.goD())
x.vD()},
xL(){if(this.c!=null)this.j(new B.bWt())},
m(){this.d.T(this.goD())
this.a0()},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gayE(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kZ(o,0,new B.bWA(q))
v=C.b.kZ(o,0,new B.bWB())
o=y.p
o=A.a([A.A(A.a([A.R(s.XW(E.bq(q.gat5()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.M,A.R(s.XW(E.bq(q.apH()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.M,A.R(s.XW(E.bq(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.t,new E.dz(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bq(C.f.ak(w*100/v))+"\u066a",r,r,r,r,C.bw,r,r,r),C.F,A.ff(A.v(6),A.q6(C.eS,G.cM,8,w/v,r),C.aC),C.ai,A.d(E.bq(w)+" \u0645\u0646 "+E.bq(v)+" \u0622\u064a\u0629",r,r,r,r,F.aL,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a4,C.aO,r,!1,r)],o)
if(p.length===0)o.push(D.aW_)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b5z(p[t]))
o.push(C.B)
u=$.B().b
u===$&&A.b()
u=u.ga3().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aL,r,r,r))
return L.xB(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
XW(d,e){var x=null
return new E.dz(A.I(A.a([A.d(d,x,x,x,x,D.bg4,x,x,x),A.d(e,x,x,x,x,C.a2f,C.Z,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a4,C.J,x,!1,x)},
b5z(d){var x=null,w=this.d.c,v=I.cO[d-1].a[1],u=w.a66(d),t=w.bgf(d),s=y.p,r=A.A(A.a([A.R(A.d(H.kl(d),x,x,x,x,C.bw,x,x,x),1),A.d(E.bq(C.f.ak(u*100/v))+"\u066a",x,x,x,x,D.bha,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.ff(A.v(6),A.q6(C.eS,G.cM,7,u/v,x),C.aC),p=E.bq(u),o=E.bq(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bq(t):""
return new E.dz(A.I(A.a([r,C.F,q,C.ai,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aL,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a4,C.aO,new B.bWz(this,d),!1,x)},
NY(d){return this.aJL(d)},
aJL(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$NY=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cO[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e2(C.cL,new B.bWy(v,d,u),t,!0,null,null,!1,y.H),$async$NY)
case 2:return A.h(null,w)}})
return A.i($async$NY,w)}}
B.aj4.prototype={
Rt(d,e){var x=null,w=A.mI(x,x,x,x,x,x,x,x,x,x,x,D.b8I,C.J,x,x,x,x,C.jR,x,x)
return A.bh(A.d(d,x,x,x,x,C.m0,x,x,x),x,x,x,new B.b50(e),x,w)},
u(d){var x=this,w=y.p
return new E.dz(A.I(A.a([D.buP,C.F,D.bwl,A.cX(C.aw,A.a([x.Rt("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Rt("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aE,0,12),D.bkr,x.Rt("tanzil.net","https://tanzil.net"),D.bxX,x.Rt("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a4,C.aO,null,!1,null)}}
B.D7.prototype={
P(){return new B.a2m()}}
B.a2m.prototype={
galY(){var x=this.a
return B.cKd(x.c,x.d,$.caS().Jj())},
Rv(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$Rv=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.bXw(s))
v=3
r=A.c4p()
n=s.galY()
m=y.N
q=A.C(m,m)
J.dW(q,"app","mogtama3y")
J.dW(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dW(q,"ua",m)}x=6
return A.c(A.a9E(n,null,C.G4,q),$async$Rv)
case 6:if(s.c!=null)s.j(new B.bXx(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cg?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.bXy(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.bXz(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Rv,w)},
u(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bw(!1,t,!0,new A.F(C.kR,A.A(A.a([A.b0(u.d?C.y2:C.l5,C.cc,t,18),C.bJ,D.bx7],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bXB(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.D(t,A.xc(u.galY(),D.bco,t,C.z),C.k,t,t,new A.G(C.pz,t,t,x,t,t,t,C.n),t,t,D.aiU,C.e9,t,t,1/0))}if(u.f)s.push(D.bkJ)
else{x=A.mI(t,t,t,t,t,t,t,t,t,t,t,C.a02,C.J,t,t,t,t,C.jR,t,t)
w=u.e
v=w?t:u.gb5y()
s.push(A.fH(w?C.a0h:D.at9,t,D.btM,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,D.a1K,t,t,t))
return new A.F(C.aO,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["ai<~>()","~()","N(nz)","ai<JH>()","ai<JF>()","ai<JG>()","a7<nz>()","N(rr)","bE(oG)","D6(t)","D4(t)","N(mV)","D5(t)","N(Ij)"])
B.b51.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.Y(A.d3(b.G.document).baseURI)
q=A.bz(r,0,null).a1("quran_tutor/tutor.js?v=3").k(0)
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
o=A.a8(l)
s.a.b=null
m=B.czs("network",A.n(o))
throw A.r(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:306}
B.b54.prototype={
$1(d){var x=null
return A.c_7(A.cU(d,"persist",x,x,x,x))},
$S:1114}
B.b53.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.ra(),$async$$0)
case 4:x=3
return A.c(n.eF(m.d3(l.cU(e,"loadModel",A.c_Q(new B.b52(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.u(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.u(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.r9(p,"ms")
r=q.or(p,"cached")
A.u(p.backend)
v=new B.JF(o,t,s,r,q.r9(p,"threads"),q.or(p,"isolated"),q.r9(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b52.prototype={
$2(d,e){this.a.$2(C.f.ak(d),C.f.ak(e))},
$S:1115}
B.b58.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.ra(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aH(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aH(v.d.a,1000)
u.onLevel=A.fV(new B.b56(v.e))
u.onAutoStop=A.fV(new B.b57(v.f))
x=5
return A.c(A.eF(A.d3(A.cU(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b56.prototype={
$1(d){return this.a.$1(d)},
$S:70}
B.b57.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b59.prototype={
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
return A.c(t.ra(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eF(p.d3(o.cU(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.JG(r,A.dN(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b5b.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.ra(),$async$$0)
case 4:x=3
return A.c(q.eF(p.d3(o.cU(e,"transcribe",t.audio,t.rate,s.aih(u.c),null)),y.m),$async$$0)
case 3:v=r.alS(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b5a.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.ra(),$async$$0)
case 4:x=3
return A.c(r.eF(q.d3(p.cU(e,"transcribeUrl",u.b,t.aih(u.c),null,null)),y.m),$async$$0)
case 3:v=s.alS(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b55.prototype={
$1(d){return d},
$S:37}
B.aWh.prototype={
$0(){var x,w,v,u,t=this.a,s=A.cn(t.a.length,D.uI,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aWg.prototype={
$1(d){return d===D.j2},
$S:z+2}
B.c_z.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c5l(e[x],d[x])<0.75)return!1
return!0},
$S:1116}
B.c1F.prototype={
$1(d){return d.length!==0},
$S:11}
B.b5f.prototype={
$1(d){return d.a===D.fh},
$S:z+7}
B.b5g.prototype={
$1(d){return C.j.aH(d,1000)},
$S:59}
B.b5d.prototype={
$1(d){return C.f.bW(d)},
$S:1117}
B.b5h.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iA("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.ap.fb(r,null))
j=A.aE(k.h(0,"n"))
j=j==null?null:C.f.bW(j)
j=C.j.d1(j==null?2:j,1,5)
i=C.b.n(D.J9,k.h(0,"r"))?A.eD(k.h(0,"r")):1
h=A.eg(k.h(0,"auto"))
g=A.eg(k.h(0,"hide"))
k=A.eg(k.h(0,"in"))
s.a.b=new B.Vp(j,i,h!==!1,g===!0,k===!0)}u=2
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
return A.c(A.iA("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.c8u(y.P.a(C.ap.fb(q,null)))
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
return A.c(A.iA("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.ap.fb(p,null))
n=C.f.bW(A.cS(J.av(o,"s")))
m=C.f.bW(A.cS(J.av(o,"f")))
l=C.f.bW(A.cS(J.av(o,"t")))
if(B.cmO(n,m)&&B.cmO(n,l)&&m<=l)s.a.z=new A.b_(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a90()){k.a.aqv()
x=1
break}a1=k
x=18
return A.c(k.a.MP(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a4()
if(k.b.e)k.Da()
k.wA()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:102}
B.b5i.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a4()},
$S:1118}
B.b5j.prototype={
$2(d,e){return C.j.aH(A.eE(A.n(d),null,null),1000)===this.a},
$S:1119}
B.bJs.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.Eq(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bJr(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1120}
B.bJr.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bJt.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bJq(x,d))},
$S:z+8}
B.bJq.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bJu.prototype={
$1(d){},
$S:24}
B.bJe.prototype={
$0(){},
$S:0}
B.bJk.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.D6(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bJl.prototype={
$0(){},
$S:0}
B.bJo.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aA(A.ax(new B.bJn(),null,x),x)},
$S:0}
B.bJn.prototype={
$1(d){return D.bzk},
$S:z+10}
B.bJp.prototype={
$0(){return B.cmA(this.a)},
$S:0}
B.bJh.prototype={
$0(){var x=this.b
return this.a.xM(x.a,x.b,x.c)},
$S:0}
B.bJi.prototype={
$1(d){return this.a.j(new B.bJg())},
$S:5}
B.bJg.prototype={
$0(){},
$S:0}
B.bJj.prototype={
$0(){var x=this.a
return x.j(new B.bJf(x))},
$S:0}
B.bJf.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bJm.prototype={
$0(){return this.a.b5w(this.b)},
$S:0}
B.c4b.prototype={
$1(d){return new A.j9(new B.c48(this.a,this.b,this.c),null)},
$S:57}
B.c48.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c4a(u,e),s=this.a,r=new B.c49(s,e),q=A.d(H.kl(this.c),v,v,v,v,C.oA,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bq(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aL,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bq(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bq(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.ai,p,C.t,A.cX(C.aw,n,C.aE,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c43(s)),C.a0d,t.$3("\u0644\u062d\u062f",s.c,new B.c44(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aVR)
u.push(C.a5)
u.push(A.dH(D.bnM,new B.c45(s,d),A.eA(C.v,C.ae,D.b95,v,v,v,v)))
return A.cu(!0,new A.F(C.Fw,A.I(u,C.ag,C.d,C.L,0,C.l),v),C.J,!0)},
$S:389}
B.c4a.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.i7,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c7(v,A.d("\u0622\u064a\u0629 "+E.bq(v),u,u,u,u,u,u,u,u),C.ar,u,w))
return A.R(A.I(A.a([t,R.G_(C.cL,!0,s,320,new B.c47(this.b,f),D.bhs,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1122}
B.c47.prototype={
$1(d){return d==null?null:this.a.$1(new B.c46(this.b,d))},
$S:49}
B.c46.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c49.prototype={
$3(d,e,f){var x=null
return A.c5X(x,A.d(d,x,x,x,x,x,x,x,x),new B.c42(this.a,this.b,e,f))},
$S:1123}
B.c42.prototype={
$0(){var x=this
return x.b.$1(new B.c41(x.a,x.c,x.d))},
$S:0}
B.c41.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c43.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c44.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c45.prototype={
$0(){var x=this.a
return A.O(this.b,!1).af(new A.U(x.b,x.c))},
$S:0}
B.bWT.prototype={
$0(){},
$S:0}
B.bX8.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mk
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bXc.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.j9:D.mk},
$S:0}
B.bXd.prototype={
$0(){var x=this.a
x.f=D.uX
x.as=null},
$S:0}
B.bXe.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bXg.prototype={
$0(){var x=this.a
x.f=D.uY
x.as=null
x.y=0
x.z=new A.aR(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bXh.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bXf())},
$S:31}
B.bXf.prototype={
$0(){},
$S:0}
B.bXj.prototype={
$1(d){return this.a.y=d},
$S:70}
B.bXi.prototype={
$1(d){return this.a.BC()},
$S:5}
B.bXk.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.j9:D.mk
x=this.b
w.as=B.MC(x)
w.at=x},
$S:0}
B.bXm.prototype={
$0(){var x=this.a
x.f=D.oZ
x.ay=Date.now()},
$S:0}
B.bXn.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bXl())},
$S:31}
B.bXl.prototype={
$0(){},
$S:0}
B.bX7.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.j9:D.mk
x.as=this.b
x.at=this.c},
$S:0}
B.bX9.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.j9
x.x=!1},
$S:0}
B.bX0.prototype={
$0(){var x=this.a
x.f=D.oZ
x.ay=Date.now()
x.as=null},
$S:0}
B.bX1.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bX_())},
$S:31}
B.bX_.prototype={
$0(){},
$S:0}
B.bX2.prototype={
$1(d){return d.d!==D.j2},
$S:z+11}
B.bX3.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bXs.prototype={
$0(){return B.cmA(this.a)},
$S:0}
B.bXt.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.apc(d))},
$S:3}
B.bXu.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aA(A.ax(new B.bXr(this.a),null,x),x)},
$S:0}
B.bXr.prototype={
$1(d){var x=this.a.a
return new B.D5(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bXv.prototype={
$0(){this.a.d.a.bky()
this.b.J(y.q).f.Z(D.baa)},
$S:0}
B.bX6.prototype={
$2(d,e){return C.aX},
$S:17}
B.bX5.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a6f(s.c,r).a.a){case 2:s=G.cM
break
case 1:s=D.dX
break
case 0:s=C.im
break
default:s=u}x=A.v(18)
w=t.f===D.oZ?u:new B.bX4(t,r)
v=s.ad(0.25)
if(r===t.gjc())s=C.i
s=A.aJ(s,r===t.gjc()?2:1)
return A.bw(!1,x,!0,A.D(C.P,A.d(E.bq(r),u,u,u,u,C.a1o,u,u,u),C.k,u,u,new A.G(v,u,s,u,u,u,u,C.c_),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:62}
B.bX4.prototype={
$0(){return this.a.a_2(this.b)},
$S:0}
B.bXb.prototype={
$0(){var x=this.a
return x.j(new B.bXa(x))},
$S:0}
B.bXa.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bXo.prototype={
$1(d){return d===D.uG},
$S:z+2}
B.bXp.prototype={
$1(d){return d===D.uH},
$S:z+2}
B.bXq.prototype={
$1(d){return d===D.uI},
$S:z+2}
B.bWU.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Ru(x)},
$S:0}
B.bWV.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.bat(d.ga5(d)))},
$S:118}
B.bWX.prototype={
$1(d){return d.n(0,C.T)?C.ae:C.i},
$S:4}
B.bWW.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.bWY.prototype={
$0(){var x=this.a
return x.a_2(x.gjc()+1)},
$S:0}
B.bWZ.prototype={
$0(){var x=this.a
return x.a_2(x.gjc()+1)},
$S:0}
B.bWC.prototype={
$0(){},
$S:0}
B.bWL.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aR(Date.now(),0,!1)},
$S:0}
B.bWM.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bWK())},
$S:31}
B.bWK.prototype={
$0(){},
$S:0}
B.bWO.prototype={
$1(d){return this.a.x=d},
$S:70}
B.bWN.prototype={
$1(d){return this.a.FC(this.b,!1)},
$S:5}
B.bWP.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.MC(x)
w.as=x},
$S:0}
B.bWG.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.bWH.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.MC(x))
w.as=x},
$S:0}
B.bWI.prototype={
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
return A.c(n.a.av_(s.b,B.EP(H.MA(l,m,k.xW(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.ckL(H.MA(l,m,k.xW(l,m)).b,r.a)
if(C.c.O(q.c).length!==0){l=n.c
k=o.a.c
j=q.gts()
l.au2(k,m,n.b.a,j)}n.zL()
if(o.c!=null)o.j(new B.bWD(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lE){p=o
o=s.a
if(o.c!=null)o.j(new B.bWE(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.bWF(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:147}
B.bWD.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.bWE.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.MC(w))
x.as=w},
$S:0}
B.bWF.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bWJ.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)
x.as=null},
$S:0}
B.bWQ.prototype={
$1(d){return d.gts()},
$S:z+13}
B.bWR.prototype={
$0(){return this.a.FC(this.b,!0)},
$S:0}
B.bWS.prototype={
$0(){return this.a.I7(this.b)},
$S:0}
B.bWt.prototype={
$0(){},
$S:0}
B.bWA.prototype={
$2(d,e){return d+this.a.a66(e)},
$S:117}
B.bWB.prototype={
$2(d,e){return d+I.cO[e-1].a[1]},
$S:117}
B.bWz.prototype={
$0(){return this.a.NY(this.b)},
$S:0}
B.bWy.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kl(p),q,q,q,q,C.oA,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.ba(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.rg():r).a.a){case 2:r=G.cM.ad(0.35)
break
case 1:r=D.dX.ad(0.35)
break
case 0:r=C.fW
break
default:r=q}m.push(A.D(C.P,A.d(E.bq(t),q,q,q,q,C.ke,q,q,q),C.k,q,q,new A.G(r,q,q,new A.cz(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cu(!0,new A.F(C.h1,A.I(A.a([o,C.ai,D.bs3,C.t,new A.dD(D.a79,A.f5(A.cX(C.aw,m,C.aE,6,6),q,C.r,q,q,q,C.w),q),C.a1,A.bh(D.btQ,q,q,q,new B.bWx(w,d,p),q,q)],n),C.ag,C.d,C.L,0,C.l),q),C.J,!0)},
$S:36}
B.bWx.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dm(null,null,!0,null,new B.bWw(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.L7(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e5()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.bWw.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kl(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dw(A.a([A.bh(C.eq,x,x,x,new B.bWu(d),x,x),A.bh(C.oM,x,x,x,new B.bWv(d),x,x)],y.p),w,D.bvp)},
$S:14}
B.bWu.prototype={
$0(){A.O(this.a,!1).af(!1)
return null},
$S:0}
B.bWv.prototype={
$0(){A.O(this.a,!1).af(!0)
return null},
$S:0}
B.c5_.prototype={
$1(d){var x=this.a
return new A.kD(new B.c4Z(x),null,x,null)},
$S:1124}
B.c4Z.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.em(w,t,A.d(E.bq(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bkl,C.a1,D.bug,C.F,A.oP(new B.c4U(s,r),q,A.db([r.a],x),!1,A.kp(t,t,t,new A.be(new B.c4V(),v),t,t,t,t,new A.be(new B.c4W(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.is(C.v,C.J,t,new B.c4X(s,r),D.brk,D.bxp,r.c),A.is(C.v,C.J,t,new B.c4Y(s,r),t,D.bjQ,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ai,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn3(),t,t,t,t,F.aL,t,C.bi,t)],u))
x.push(C.B)
x.push(D.a3p)
return A.cu(!0,A.f5(A.I(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.h1,t,t,C.w),C.J,!0)},
$S:1125}
B.c4U.prototype={
$1(d){return this.a.qK(this.b.baq(d.ga5(d)))},
$S:118}
B.c4W.prototype={
$1(d){return d.n(0,C.T)?C.ae:C.i},
$S:4}
B.c4V.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.c4X.prototype={
$1(d){return this.a.qK(this.b.b9M(d))},
$S:3}
B.c4Y.prototype={
$1(d){return this.a.qK(this.b.apc(d))},
$S:3}
B.b50.prototype={
$0(){return A.cw(A.bz(this.a,0,null),C.aR,null)},
$S:0}
B.c5f.prototype={
$1(d){var x,w=A.aC("https?://",!0,!1,!1)
w=A.bD(d,w,"")
x=A.aC("www\\.",!0,!1,!1)
return A.uS(A.bD(w,x,"www[.]"),A.aC("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c5g(),null)},
$S:37}
B.c5g.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:58}
B.bXw.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bXx.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bXy.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bXz.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bXB.prototype={
$0(){var x=this.a
return x.j(new B.bXA(x))},
$S:0}
B.bXA.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c5e.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:203};(function installTearOffs(){var x=a._instance_0u
x(B.aj5.prototype,"gbgg","bgh",1)
var w
x(w=B.Vq.prototype,"gbgx","Da",0)
x(w,"gaDG","wA",0)
x(w=B.a_T.prototype,"goD","xL",1)
x(w,"gaY2","PV",0)
x(w=B.a2l.prototype,"goD","xL",1)
x(w,"gb_I","Qj",0)
x(w,"gb44","BC",0)
x(w,"gaJp","NV",0)
x(w=B.a2k.prototype,"goD","xL",1)
x(w,"gb0y","b0z",1)
x(B.a2j.prototype,"goD","xL",1)
x(B.a2m.prototype,"gb5y","Rv",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aj5,B.Vr,B.JF,B.JH,B.JG,B.lE,B.Sy,B.mV,B.Ij,B.rr,B.aj6,B.Vp])
x(A.lb,[B.b51,B.b53,B.b58,B.b59,B.b5b,B.b5a,B.aWh,B.b5h,B.bJr,B.bJq,B.bJe,B.bJl,B.bJo,B.bJp,B.bJh,B.bJg,B.bJj,B.bJf,B.bJm,B.c46,B.c42,B.c41,B.c45,B.bWT,B.bX8,B.bXc,B.bXd,B.bXe,B.bXg,B.bXf,B.bXk,B.bXm,B.bXl,B.bX7,B.bX9,B.bX0,B.bX_,B.bX3,B.bXs,B.bXu,B.bXv,B.bX4,B.bXb,B.bXa,B.bWU,B.bWY,B.bWZ,B.bWC,B.bWL,B.bWK,B.bWP,B.bWG,B.bWH,B.bWD,B.bWE,B.bWF,B.bWJ,B.bWR,B.bWS,B.bWt,B.bWz,B.bWx,B.bWu,B.bWv,B.b50,B.bXw,B.bXx,B.bXy,B.bXz,B.bXB,B.bXA])
x(A.iE,[B.b54,B.b56,B.b57,B.b55,B.aWg,B.c1F,B.b5f,B.b5g,B.b5d,B.bJs,B.bJt,B.bJu,B.bJk,B.bJn,B.bJi,B.c4b,B.c4a,B.c47,B.c49,B.c43,B.c44,B.bXh,B.bXj,B.bXi,B.bXn,B.bX1,B.bX2,B.bXt,B.bXr,B.bXo,B.bXp,B.bXq,B.bWV,B.bWX,B.bWW,B.bWM,B.bWO,B.bWN,B.bWI,B.bWQ,B.bWy,B.bWw,B.c5_,B.c4U,B.c4W,B.c4V,B.c4X,B.c4Y,B.c5f,B.c5g,B.c5e])
x(A.o3,[B.b52,B.c_z,B.b5i,B.b5j,B.c48,B.bX6,B.bX5,B.bWA,B.bWB,B.c4Z])
x(A.DG,[B.nz,B.F7,B.Hj,B.E6])
w(B.Vq,A.i1)
x(A.K,[B.wR,B.D6,B.D5,B.D4,B.D7])
x(A.M,[B.a_T,B.a2l,B.a2k,B.a2j,B.a2m])
x(A.a3,[B.Hk,B.XJ,B.Dp,B.aj4])})()
A.pi(b.typeUniverse,JSON.parse('{"lE":{"bP":[]},"D6":{"K":[],"l":[]},"D5":{"K":[],"l":[]},"D4":{"K":[],"l":[]},"D7":{"K":[],"l":[]},"Vq":{"aA":[]},"wR":{"K":[],"l":[]},"a_T":{"M":["wR"]},"Hk":{"a3":[],"l":[]},"XJ":{"a3":[],"l":[]},"a2l":{"M":["D6"]},"Dp":{"a3":[],"l":[]},"a2k":{"M":["D5"]},"a2j":{"M":["D4"]},"aj4":{"a3":[],"l":[]},"a2m":{"M":["D7"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rr"),c:x("em<x>"),r:x("c7<x>"),k:x("H<mV>"),n:x("H<em<x>>"),I:x("H<c7<x>>"),R:x("H<hO>"),Z:x("H<aQ<o,@>>"),d:x("H<Sy>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bO"),j:x("a7<@>"),L:x("a7<x>"),P:x("aQ<o,@>"),f:x("aQ<@,@>"),x:x("au<o,x>"),a:x("bE"),K:x("a4"),B:x("Ij"),l:x("+(x,x)"),e:x("d8<mV>"),N:x("o"),C:x("JF"),D:x("JG"),X:x("Vr"),_:x("JH"),U:x("ak<o>"),G:x("nz"),q:x("pf"),b:x("be<S?>"),y:x("N"),i:x("a2"),z:x("@"),S:x("x"),A:x("bO?"),Y:x("aQ<@,@>?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("fz"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.p7=new B.F7(0,"none")
D.p8=new B.F7(1,"learning")
D.fh=new B.F7(2,"memorized")
D.a79=new A.aD(0,1/0,0,320)
D.eR=new A.S(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a7h=new A.G(D.eR,null,null,null,null,null,null,C.c_)
D.dX=new A.S(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.asp=new A.E(C.ye,null,C.cc,null,null,null)
D.bvz=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.fa,null,null,null,null,null,null,null,null)
D.bcR=new A.q(!0,C.eT,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bs5=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bcR,null,null,null,null,null,null,null,null)
D.aJr=x([D.asp,C.F,D.bvz,D.bs5],y.p)
D.afo=new A.fm(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aJr,null)
D.aiR=new A.W(0,26,0,26)
D.aiU=new A.W(0,4,0,6)
D.aji=new A.W(14,12,14,14)
D.ak_=new A.W(3,0,0,0)
D.anB=new A.Q(63251,"MaterialIcons",null,!1)
D.qy=new A.Q(63677,"MaterialIcons",null,!1)
D.aoq=new A.Q(983209,"MaterialIcons",null,!1)
D.ap4=new A.E(D.aoq,28,C.v,null,null,null)
D.apK=new A.E(C.H8,null,C.im,null,null,null)
D.anj=new A.Q(62961,"MaterialIcons",null,!1)
D.aqs=new A.E(D.anj,null,null,null,null,null)
D.anz=new A.Q(63199,"MaterialIcons",null,!1)
D.aqt=new A.E(D.anz,null,null,null,null,null)
D.aqB=new A.E(C.l4,null,C.eT,null,null,null)
D.aqE=new A.E(C.nq,44,C.i,null,null,null)
D.ar9=new A.E(D.qy,null,D.eR,null,null,null)
D.arq=new A.E(C.nh,null,D.eR,null,null,null)
D.arO=new A.E(D.qy,null,null,null,null,null)
D.asl=new A.E(C.iw,20,D.dX,null,null,null)
D.asI=new A.E(C.nn,30,C.v,null,null,null)
D.at9=new A.E(C.l9,16,C.v,null,null,null)
D.anV=new A.Q(63520,"MaterialIcons",null,!1)
D.atB=new A.E(D.anV,null,null,null,null,null)
D.atN=new A.E(C.np,null,null,null,null,null)
D.ana=new A.Q(62842,"MaterialIcons",null,!0)
D.au0=new A.E(D.ana,null,null,null,null,null)
D.J9=x([1,3,5],y.t)
D.JX=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aWr=new A.F(C.kS,C.mx,null)
D.aGi=x([D.aWr],y.p)
D.b_V=new A.U(C.nj,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b_I=new A.U(D.qy,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b0f=new A.U(C.dw,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.aoa=new A.Q(63625,"MaterialIcons",null,!1)
D.b0t=new A.U(D.aoa,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aIp=x([D.b_V,D.b_I,D.b0f,D.b0t],A.ae("H<+(Q,o)>"))
D.aKM=x([D.p7,D.p8,D.fh],A.ae("H<F7>"))
D.OA=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aSk=new B.Hj(0,"idle")
D.UP=new B.Hj(1,"loading")
D.jS=new B.Hj(2,"ready")
D.aSl=new B.Hj(3,"failed")
D.ar7=new A.E(C.bV,18,G.cM,null,null,null)
D.bwy=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uj,null,null,null,null,null,null,null,null)
D.aFc=x([D.ar7,C.aX,D.bwy],y.p)
D.b6v=new A.ej(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aFc,null)
D.aVm=new A.F(C.aO,D.b6v,null)
D.ajY=new A.W(2,6,2,4)
D.bcx=new A.q(!0,C.v,null,null,null,null,14,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bki=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bcx,null,null,null,null,null,null,null,null)
D.aVB=new A.F(D.ajY,D.bki,null)
D.bwX=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.fa,null,null,null,null,null,null,null,null)
D.aGC=x([N.tO,C.M,D.bwX],y.p)
D.b6p=new A.ej(C.af,C.cq,C.e,C.h,null,C.l,null,0,D.aGC,null)
D.aVM=new A.F(C.n_,D.b6p,null)
D.Bs=new A.q(!0,D.dX,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bxh=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Bs,null,null,null,null,null,null,null,null)
D.aVR=new A.F(C.dJ,D.bxh,null)
D.bwt=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aL,C.Z,null,null,null,null,null,null,null)
D.aW_=new A.F(C.C,D.bwt,null)
D.ajV=new A.W(2,0,2,8)
D.bsn=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aL,null,null,null,null,null,null,null,null)
D.aWh=new A.F(D.ajV,D.bsn,null)
D.atj=new A.E(C.l7,30,C.v,null,null,null)
D.bxY=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Bt,null,null,null,null,null,null,null,null)
D.al6=new A.bU(1,C.ad,D.bxY,null)
D.aGR=x([D.atj,C.Y,D.al6],y.p)
D.b6b=new A.ej(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aGR,null)
D.asU=new A.E(C.dw,18,G.cM,null,null,null)
D.a1y=new A.q(!0,G.cM,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bwa=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a1y,null,null,null,null,null,null,null,null)
D.aFD=x([D.asU,C.bJ,D.bwa],y.p)
D.b6n=new A.ej(C.af,C.d,C.L,C.h,null,C.l,null,0,D.aFD,null)
D.b8I=new A.T(0,30)
D.tL=new A.T(1/0,54)
D.b95=new A.T(1/0,48)
D.b98=new A.T(1/0,50)
D.b9b=new A.T(1/0,52)
D.bu_=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.baa=new A.d7(D.bu_,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.bc_=new A.q(!0,C.i,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bco=new A.q(!0,C.am,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.Be=new A.q(!0,D.eR,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.kf=new A.q(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a1K=new A.q(!0,D.eR,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bg4=new A.q(!0,C.v,null,null,null,null,24,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgm=new A.q(!0,C.v,null,null,null,null,null,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bh9=new A.q(!0,D.dX,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bha=new A.q(!0,G.cM,null,null,null,null,null,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhs=new A.q(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bj6=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.i7,null,null,null,null,null,null,null,null)
D.bjQ=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.cS,null,null,null,null,null,null,null,null)
D.bkl=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oA,null,null,null,null,null,null,null,null)
D.bkr=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aL,null,null,null,null,null,null,null,null)
D.bdI=new A.q(!0,G.cM,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bkJ=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bdI,null,null,null,null,null,null,null,null)
D.bkQ=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aL,null,null,null,null,null,null,null,null)
D.blf=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.fa,null,null,null,null,null,null,null,null)
D.bn0=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cF,null,null,null,null,null,null,null,null)
D.bnM=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bF,null,null,null,null,null,null,null,null)
D.bnR=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aL,null,null,null,null,null,null,null,null)
D.boj=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.Bx,null,null,null,null,null,null,null,null)
D.bpy=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bq7=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oE,null,null,null,null,null,null,null,null)
D.bqV=new A.m("reset safe mode / WebGPU ban",null,O.a14,null,null,null,null,null,null,null,null)
D.br9=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Bs,null,null,null,null,null,null,null,null)
D.brk=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aL,null,null,null,null,null,null,null,null)
D.brL=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bw,null,null,null,null,null,null,null,null)
D.bs3=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aL,null,null,null,null,null,null,null,null)
D.bso=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aL,null,null,null,null,null,null,null,null)
D.btM=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a28,null,null,null,null,null,null,null,null)
D.bfj=new A.q(!0,D.eR,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.btQ=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bfj,null,null,null,null,null,null,null,null)
D.bug=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oE,null,null,null,null,null,null,null,null)
D.buP=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0Y,null,null,null,null,null,null,null,null)
D.bv3=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cF,null,null,null,null,null,null,null,null)
D.bvp=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bvJ=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bwl=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aL,null,null,null,null,null,null,null,null)
D.bwm=new A.m("\u062e\u0644\u0635\u062a",null,C.m1,null,null,null,null,null,null,null,null)
D.bwn=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Bs,null,null,null,null,null,null,null,null)
D.bgo=new A.q(!0,C.cG,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.hm,null,null,null,null,null,null,null,null)
D.bx7=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bgo,null,null,null,null,null,null,null,null)
D.bxl=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bw,null,null,null,null,null,null,null,null)
D.bxp=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.cS,null,null,null,null,null,null,null,null)
D.bxX=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aL,null,null,null,null,null,null,null,null)
D.a3p=new B.aj4(null)
D.bzk=new B.D4(null)
D.bzl=new B.Vp(2,1,!0,!1,!1)
D.a3t=new B.Vr(!1,!1,!1,!1,!1,0)
D.j2=new B.nz(0,"ok")
D.uG=new B.nz(1,"near")
D.uH=new B.nz(2,"wrong")
D.uI=new B.nz(3,"missing")
D.a3U=new B.nz(4,"extra")
D.anQ=new A.Q(63456,"MaterialIcons",null,!1)
D.bEZ=new B.Dp(D.dX,D.anQ,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bFC=new B.XJ(!1,null)
D.C3=new B.XJ(!0,null)
D.mk=new B.E6(0,"idle")
D.uX=new B.E6(1,"playing")
D.uY=new B.E6(2,"recording")
D.oZ=new B.E6(3,"thinking")
D.j9=new B.E6(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cNb","caS",()=>new B.aj5())
x($,"cQD","cqx",()=>A.aC("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cQE","cqy",()=>A.aC("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cQQ","cqH",()=>A.aC("\u0648\u0670",!0,!1,!1))
x($,"cQb","cqd",()=>A.aC("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cOt","cp2",()=>A.aC("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cPI","cpQ",()=>A.aC("[\u0654\u0655]",!0,!1,!1))
x($,"cOu","cp3",()=>A.aC("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cOB","cp9",()=>A.aC("[\u0624\u0626]",!0,!1,!1))
x($,"cPK","cpS",()=>A.aC("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cQg","cqg",()=>A.aC("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cPS","cpZ",()=>A.aC("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cQB","cbt",()=>A.aC("\\s+",!0,!1,!1))
x($,"cKu","rg",()=>B.crw(D.p7,0,A.c6v(0,!0)))
x($,"cNc","MJ",()=>new B.Vq($.caS(),D.bzl,B.czt(),D.aSk,$.V()))})()};
(a=>{a["GhLGhpTC3ZxtvQqp/k0QMSpXx+8="]=a.current})($__dart_deferred_initializers__);