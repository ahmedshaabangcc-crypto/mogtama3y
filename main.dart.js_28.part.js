((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,Q,H,G,N,R,K,B={
cBv(d){var x,w,v,u,t,s
if(d instanceof B.lE)return d
try{x=A.cS(d)
w=x.code
v=x.message
u=w==null?"failed":A.S(w)
t=v==null?"":A.S(v)
return new B.lE(u,t)}catch(s){u=A.n(d)
return new B.lE("failed",u)}},
ajB:function ajB(){this.b=this.a=null},
b5V:function b5V(d){this.a=d},
b5Y:function b5Y(){},
b5X:function b5X(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b5W:function b5W(d){this.a=d},
b61:function b61(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b6_:function b6_(d){this.a=d},
b60:function b60(d){this.a=d},
b62:function b62(d){this.a=d},
b64:function b64(d,e,f){this.a=d
this.b=e
this.c=f},
b63:function b63(d,e,f){this.a=d
this.b=e
this.c=f},
b5Z:function b5Z(){},
cBw(d,e){return new B.lE(d,e)},
VK:function VK(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
JV:function JV(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
JX:function JX(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
JW:function JW(d,e){this.a=d
this.b=e},
lE:function lE(d,e){this.a=d
this.b=e},
cnE(d){var x,w=$.csm()
w=A.bF(d,w,"\u0627")
x=$.csn()
w=A.bF(w,x,"\u064a")
x=$.csw()
w=A.bF(w,x,"\u0627")
x=$.cqS()
w=A.bF(w,x,"\u0627")
x=$.cs2()
w=A.bF(w,x,"\u0621")
x=$.crF()
w=A.bF(w,x,"\u0621")
x=$.cqT()
w=A.bF(w,x,"\u0627")
x=$.cqZ()
w=A.bF(w,x,"\u0621")
w=A.bF(w,"\u0649","\u064a")
w=A.bF(w,"\u0629","\u0647")
x=$.crH()
w=A.bF(w,x,"")
x=$.cs5()
w=A.bF(w,x," ")
x=$.crO()
w=A.bF(w,x," ")
x=$.cdj()
return C.c.N(A.bF(w,x," "))},
cGd(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kC(x,w)
for(u=0;u<x;++u)v[u]=u
t=A.co(x,0,!1,w)
for(s=1;s<=l;++s,r=t,t=v,v=r){t[0]=s
for(w=s-1,u=1;u<=k;++u){q=u-1
p=d.charCodeAt(w)===e.charCodeAt(q)?0:1
o=v[u]+1
n=t[q]+1
m=v[q]+p
if(o<n)q=o<m?o:m
else q=n<m?n:m
t[u]=q}}return v[k]},
c7a(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aD("[\u0627\u0621]",!0,!1,!1)
w=A.bF(d,x,"")
x=A.aD("[\u0627\u0621]",!0,!1,!1)
v=A.bF(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cGd(d,e)/u
return s>=1?0.99:s},
F4(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.u0(d,$.cdj()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.cnE(u)
s=A.bF(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.SQ(r.a+" "+u,r.b))}continue}q.push(new B.SQ(u,s))}return q},
cET(d,e){var x,w,v,u,t=new B.c1a(),s=A.a([],y.s)
for(x=A.fw(e,0,A.ii(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.cb(x,x.gM(0),w.i("cb<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.Kp)&&t.$2(d,D.Kp)?C.b.jz(d,5):d
return!t.$2(s,D.P3)&&t.$2(u,D.P3)?C.b.jz(u,4):u},
cmA(d,e){var x=B.F4(d),w=B.cnE(e),v=y.U
v=A.a9(new A.ag(A.a(w.split(" "),y.s),new B.c3h(),v),v.i("Z.E"))
return new B.Iz(x,B.cE3(x,B.cET(v,x)),w)},
cE3(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.co(x,0,!1,s)
q=A.co(x,0,!1,y.S)
p=A.co(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c7a(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c7a(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c7a(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.j5
else m=a2>=0.6?D.uO:D.uP
a1.push(new B.mW(o,x,s,m))
break
case 1:--o
a1.push(new B.mW(o,a4[o],null,D.uQ))
break
case 2:--n
a1.push(new B.mW(null,null,a6[n],D.a4o))
break
case 3:--o
a3=n-2
a1.push(new B.mW(o,a4[o],a6[a3]+" "+a6[n-1],D.j5))
n=a3
break
default:x=o-1;--n
a1.push(new B.mW(x,a4[x],a6[n],D.j5))
o-=2
a1.push(new B.mW(o,a4[o],a6[n],D.j5))}}a4=y.e
a4=A.a9(new A.db(a1,a4),a4.i("aW.E"))
return a4},
nE:function nE(d,e){this.a=d
this.b=e},
SQ:function SQ(d,e){this.a=d
this.b=e},
mW:function mW(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Iz:function Iz(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aX5:function aX5(d){this.a=d},
aX4:function aX4(){},
c1a:function c1a(){},
c3h:function c3h(){},
ctl(d,e,f){return new B.rt(d,e,f)},
cH8(d){var x
A:{if("memorized"===d){x=D.fj
break A}if("learning"===d){x=D.pd
break A}x=D.pc
break A}return x},
coE(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cR[d-1].a[1]},
cBx(){var x=y.S
return new B.ajC(A.B(x,y.u),A.aS(x))},
b67(d){var x=d.ff()
return C.c.dq(C.j.k(A.br(x)),4,"0")+"-"+C.c.dq(C.j.k(A.bt(x)),2,"0")+"-"+C.c.dq(C.j.k(A.bW(x)),2,"0")},
cjv(d){var x=y.x,w=A.a9(new A.av(A.a(d.split("-"),y.s),A.cIy(),x),x.i("aW.E"))
return B.b67(A.du(w[0],w[1],w[2]-1,12,0,0,0))},
caj(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.B(p,y.u),n=A.aS(p),m=new B.ajC(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcN(),x=x.ga0(x),w=y.j;x.v();){v=x.gG()
u=A.dU(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aR(t)>=3){v=C.j.aH(u,1000)
s=C.j.a3(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cR[v-1].a[1])}if(v)continue
v=J.bd(t)
r=C.f.bB(A.cN(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rt(D.aLo[r],C.f.bB(A.cN(v.h(t,1))),new A.aQ(A.ks(C.f.bB(A.cN(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aAW(q,y.o)
p=A.mr(x,new B.b66(),x.$ti.i("Z.E"),p)
n.A(0,new A.ag(p,o.ga44(),A.y(p).i("ag<Z.E>")))}m.c=A.t(d.h(0,"last"))
p=A.ax(d.h(0,"streak"))
p=p==null?null:C.f.bB(p)
p=m.d=p==null?0:p
o=A.ax(d.h(0,"best"))
o=o==null?null:C.f.bB(o)
m.e=o==null?p:o
return m},
aAc(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dq(C.j.k(d),3,"0")+C.c.dq(C.j.k(e),3,"0")+".mp3"},
Fm:function Fm(d,e){this.a=d
this.b=e},
rt:function rt(d,e,f){this.a=d
this.b=e
this.c=f},
ajC:function ajC(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b68:function b68(){},
b69:function b69(){},
b66:function b66(){},
VI:function VI(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cz_(){return new B.wX(null)},
cKZ(d,e){var x,w,v,u,t={},s=I.cR[e-1].a[1],r=$.MZ().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.ri():v).a===D.fj}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.cZ(u+4,1,s)
return A.e_(C.cN,new B.c5O(t,s,e),d,!0,null,null,!1,y.l)},
cc5(d){return A.dr(0,0,0,0,0,C.j.cZ(C.f.ak(6+d*1.2),25,90))},
cb0(d){return E.bq(C.j.aH(d,60))+":"+C.c.dq(E.bq(C.j.a3(d,60)),2,"\u0660")},
coq(d){return A.e_(C.cN,new B.c6L($.MZ()),d,!0,null,null,!1,y.H)},
MS(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl3()
break A}return x},
cMk(d,e,f){var x,w=new B.c73(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
coz(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.am.f0(a4,null))
s=y.Y
r=s.a(J.au(x,"rec"))
w=r==null?C.ek:r
q=s.a(J.au(x,"last"))
v=q==null?C.ek:q
u=new B.c72()
s=J.au(v,"recovered")
t=A.n(s==null?"":s)
s=A.n(u.$1(J.au(w,"wall")))
p=A.n(u.$1(J.au(w,"source")))
o=A.n(u.$1(J.au(w,"ctxRate")))
n=A.n(u.$1(J.au(w,"pcmPeak")))
m=A.n(u.$1(J.au(w,"ctxState")))
l=A.n(u.$1(J.au(w,"stopMs")))
k=A.n(u.$1(J.au(v,"prepMs")))
j=A.n(u.$1(J.au(v,"ms")))
i=A.n(u.$1(J.au(v,"featMs")))
h=A.n(u.$1(J.au(v,"encMs")))
g=A.n(u.$1(J.au(v,"decMs")))
f=A.n(u.$1(J.au(v,"wallMs")))
e=A.n(u.$1(J.au(v,"backend")))
d=A.n(u.$1(J.au(v,"threads")))
a0=J.aR(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.e(J.au(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.e(J.au(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
Hw:function Hw(d,e){this.a=d
this.b=e},
VJ:function VJ(d,e,f,g,h){var _=this
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
b6a:function b6a(d){this.a=d},
b6b:function b6b(d){this.a=d},
b6c:function b6c(d){this.a=d},
wX:function wX(d){this.a=d},
a0c:function a0c(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bKT:function bKT(d){this.a=d},
bKS:function bKS(d,e){this.a=d
this.b=e},
bKU:function bKU(d){this.a=d},
bKR:function bKR(d,e){this.a=d
this.b=e},
bKV:function bKV(){},
bKF:function bKF(){},
bKL:function bKL(d,e,f){this.a=d
this.b=e
this.c=f},
bKM:function bKM(){},
bKP:function bKP(d){this.a=d},
bKO:function bKO(){},
bKQ:function bKQ(d){this.a=d},
bKI:function bKI(d,e){this.a=d
this.b=e},
bKJ:function bKJ(d){this.a=d},
bKH:function bKH(){},
bKK:function bKK(d){this.a=d},
bKG:function bKG(d){this.a=d},
bKN:function bKN(d,e){this.a=d
this.b=e},
Hx:function Hx(d,e,f){this.c=d
this.d=e
this.a=f},
Y0:function Y0(d,e){this.c=d
this.a=e},
c5O:function c5O(d,e,f){this.a=d
this.b=e
this.c=f},
c5L:function c5L(d,e,f){this.a=d
this.b=e
this.c=f},
c5N:function c5N(d,e){this.a=d
this.b=e},
c5K:function c5K(d,e){this.a=d
this.b=e},
c5J:function c5J(d,e){this.a=d
this.b=e},
c5M:function c5M(d,e){this.a=d
this.b=e},
c5F:function c5F(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c5E:function c5E(d,e,f){this.a=d
this.b=e
this.c=f},
c5G:function c5G(d){this.a=d},
c5H:function c5H(d){this.a=d},
c5I:function c5I(d,e){this.a=d
this.b=e},
Em:function Em(d,e){this.a=d
this.b=e},
Dj:function Dj(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2I:function a2I(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bYu:function bYu(){},
bYK:function bYK(d,e){this.a=d
this.b=e},
bYO:function bYO(d){this.a=d},
bYP:function bYP(d){this.a=d},
bYQ:function bYQ(d,e,f){this.a=d
this.b=e
this.c=f},
bYS:function bYS(d){this.a=d},
bYT:function bYT(d){this.a=d},
bYR:function bYR(){},
bYV:function bYV(d){this.a=d},
bYU:function bYU(d){this.a=d},
bYW:function bYW(d,e){this.a=d
this.b=e},
bYY:function bYY(d){this.a=d},
bYZ:function bYZ(d){this.a=d},
bYX:function bYX(){},
bYJ:function bYJ(d,e,f){this.a=d
this.b=e
this.c=f},
bYL:function bYL(d,e,f){this.a=d
this.b=e
this.c=f},
bYC:function bYC(d){this.a=d},
bYD:function bYD(d){this.a=d},
bYB:function bYB(){},
bYE:function bYE(){},
bYF:function bYF(d,e){this.a=d
this.b=e},
bZ3:function bZ3(d){this.a=d},
bZ4:function bZ4(d){this.a=d},
bZ5:function bZ5(d,e){this.a=d
this.b=e},
bZ2:function bZ2(d){this.a=d},
bZ6:function bZ6(d,e){this.a=d
this.b=e},
bYI:function bYI(){},
bYH:function bYH(d){this.a=d},
bYG:function bYG(d,e){this.a=d
this.b=e},
bYN:function bYN(d){this.a=d},
bYM:function bYM(d){this.a=d},
bZ_:function bZ_(){},
bZ0:function bZ0(){},
bZ1:function bZ1(){},
bYv:function bYv(d,e,f){this.a=d
this.b=e
this.c=f},
bYw:function bYw(d){this.a=d},
bYy:function bYy(){},
bYx:function bYx(){},
bYz:function bYz(d){this.a=d},
bYA:function bYA(d){this.a=d},
DC:function DC(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
Di:function Di(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2H:function a2H(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bYd:function bYd(){},
bYm:function bYm(d,e){this.a=d
this.b=e},
bYn:function bYn(d){this.a=d},
bYl:function bYl(){},
bYp:function bYp(d){this.a=d},
bYo:function bYo(d,e){this.a=d
this.b=e},
bYq:function bYq(d,e){this.a=d
this.b=e},
bYh:function bYh(d,e){this.a=d
this.b=e},
bYi:function bYi(d,e,f){this.a=d
this.b=e
this.c=f},
bYj:function bYj(d,e,f){this.a=d
this.b=e
this.c=f},
bYe:function bYe(d,e,f){this.a=d
this.b=e
this.c=f},
bYf:function bYf(d,e,f){this.a=d
this.b=e
this.c=f},
bYg:function bYg(d,e){this.a=d
this.b=e},
bYk:function bYk(d){this.a=d},
bYr:function bYr(){},
bYs:function bYs(d,e){this.a=d
this.b=e},
bYt:function bYt(d,e){this.a=d
this.b=e},
Dh:function Dh(d){this.a=d},
a2G:function a2G(d){this.d=d
this.c=this.a=null},
bY4:function bY4(){},
bYb:function bYb(d){this.a=d},
bYc:function bYc(){},
bYa:function bYa(d,e){this.a=d
this.b=e},
bY9:function bY9(d,e,f){this.a=d
this.b=e
this.c=f},
bY8:function bY8(d,e,f){this.a=d
this.b=e
this.c=f},
bY7:function bY7(d){this.a=d},
bY5:function bY5(d){this.a=d},
bY6:function bY6(d){this.a=d},
c6L:function c6L(d){this.a=d},
c6K:function c6K(d){this.a=d},
c6F:function c6F(d,e){this.a=d
this.b=e},
c6H:function c6H(){},
c6G:function c6G(){},
c6I:function c6I(d,e){this.a=d
this.b=e},
c6J:function c6J(d,e){this.a=d
this.b=e},
ajA:function ajA(d){this.a=d},
b5U:function b5U(d){this.a=d},
c73:function c73(){},
c74:function c74(){},
Dk:function Dk(d,e,f){this.c=d
this.d=e
this.a=f},
a2J:function a2J(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bZ7:function bZ7(d){this.a=d},
bZ8:function bZ8(d){this.a=d},
bZ9:function bZ9(d,e){this.a=d
this.b=e},
bZa:function bZa(d){this.a=d},
bZc:function bZc(d){this.a=d},
bZb:function bZb(d){this.a=d},
c72:function c72(){}},D,O,P,I,E,F
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
B.ajB.prototype={
ra(){var x=this,w=x.a
if(w!=null)return A.em(w,y.m)
w=x.b
return w==null?x.b=new B.b5V(x).$0():w},
ut(d,e){return this.aNV(d,e,e)},
aNV(d,e,f){var x=0,w=A.k(f),v,u=2,t=[],s,r,q,p
var $async$ut=A.f(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$ut)
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
r=B.cBv(s)
throw A.r(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$ut,w)},
or(d,e){var x=A.ei(d[e])
if(x==null)x=null
return x===!0},
N0(){var x=0,w=A.k(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$N0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.ra(),$async$N0)
case 7:r=h.cS(g.cM(e,"support",null,null,null,null))
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
v=new B.VK(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a3Y
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$N0,w)},
Ey(){var x=0,w=A.k(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Ey=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.ra(),$async$Ey)
case 8:x=7
return A.c(m.eF(l.cS(k.cM(e,"storage",null,null,null,null)),y.A),$async$Ey)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.ak(A.dQ(r.quota))
p=C.f.ak(A.dQ(r.usage))
v=new A.atH(q,p)
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
return A.j($async$Ey,w)},
bkb(){var x=y.K
A.PQ(this.ra().bH(new B.b5Y(),x),x)},
r9(d,e){var x=A.jQ(d[e])
x=x==null?null:C.f.ak(x)
return x==null?0:x},
bhx(d,e,f){return this.ut(new B.b5X(this,d,e,f),y.C)},
gakX(){var x,w
try{x=A.kj(b.G.sessionStorage)
return x}catch(w){return null}},
gasu(){var x=A.ei(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a9m(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.ei(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gasu())return!1
l=A.ei(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cS(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.S(x.userAgent)
l=A.jQ(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.t(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aD("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.e(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aD("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.jQ(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.gakX()
l=l==null?f:A.t(A.cM(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dU(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.kj(m.localStorage)
m=o
m=m==null?f:A.t(A.cM(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dU(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
ar_(){var x,w,v,u,t,s,r=null
try{x=this.gakX()
if(x!=null)A.cM(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cS(x.location)
u=A.S(v.hash)
t=A.S(v.search)
s=A.bx(A.S(A.cS(x.document).baseURI),0,r).a2("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cM(v,"replace",s+t+x,r,r,r)},
bhg(){var x,w=null,v=b.G,u=A.cS(v.history),t=A.jQ(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cM(u,"back",w,w,w,w)
else{x=A.S(A.cS(v.document).baseURI)
A.cM(A.cS(v.location),"replace",A.bx(x,0,w).a2("./").k(0)+"#/",w,w,w)}},
a9y(d,e,f,g,h){return this.ut(new B.b61(this,e,d,f,h,g),y.H)},
a9C(){return this.ut(new B.b62(this),y.D)},
a3I(){var x=null,w=this.a
if(w!=null)A.cM(w,"cancelRecording",x,x,x,x)},
amm(d){var x,w,v=this,u=A.t(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.r9(d,"ms")
w=A.jQ(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.JX(u,x,w,v.r9(d,"frames"),v.r9(d,"tokens"),v.or(d,"retried"),v.r9(d,"encMs"),v.r9(d,"decMs"),v.r9(d,"featMs"))},
aiL(d){var x={}
x.words=d
return x},
avz(d,e){return this.ut(new B.b64(this,d,e),y._)},
bmo(d,e){return this.ut(new B.b63(this,d,e),y._)},
L2(d,e){return this.bkh(d,e)},
bkh(d,e){var x=0,w=A.k(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$L2=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.ra(),$async$L2)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.al(d).i("av<1,o>")
o=A.a9(new A.av(d,new B.b5Z(),o),o.i("aW.E"))
x=11
return A.c(A.eF(A.cS(A.cM(r,"play",o,e,null,null)),y.y),$async$L2)
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
return A.j($async$L2,w)},
MI(){var x=null,w=this.a
if(w!=null)A.cM(w,"stopPlayback",x,x,x,x)},
Jv(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.S(A.cM(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
blx(){var x,w,v=null
try{x=this.a
if(x!=null)A.cM(x,"resetDevice",v,v,v,v)}catch(w){}},
a70(d){var x=this.a
if(x!=null)A.cM(x,"prefetch",d,null,null,null)}}
B.VK.prototype={}
B.JV.prototype={
gn4(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.JX.prototype={
gT7(){var x=this,w=C.f.az(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.JW.prototype={}
B.lE.prototype={
gl3(){var x,w=this.a
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
$ibL:1}
B.nE.prototype={
R(){return"WordStatus."+this.b}}
B.SQ.prototype={}
B.mW.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Iz.prototype={
gMG(){var x,w=this,v=w.d
if(v===$){x=new B.aX5(w).$0()
w.d!==$&&A.aq()
w.d=x
v=x}return v},
gJO(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a4o&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbip(){return J.h7(this.gMG(),new B.aX4()).gM(0)},
gtu(){var x=this.a
return x.length!==0&&this.gbip()===x.length&&this.gJO().length===0}}
B.Fm.prototype={
R(){return"AyahStatus."+this.b}}
B.rt.prototype={}
B.ajC.prototype={
a6C(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.ri():x},
b_G(d){var x=this,w=B.b67(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cjv(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
aqb(){var x=Date.now(),w=B.b67(new A.aQ(x,0,!1))
x=this.c
return x===w||x===B.cjv(w)?this.d:0},
auA(d,e,f,g){var x=this,w=new A.aQ(Date.now(),0,!1),v=x.a6C(d,e),u=g?C.j.cZ(v.b+1,0,100):0,t=g&&u>=f?D.fj:D.pd,s=new B.rt(t,u,w.hd()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.b_G(w)
return s},
a6t(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cR[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.ri():s).a===D.fj)++u}return u},
bhe(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cR[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.ri():s).a===D.pd)++u}return u},
gatB(){var x=this.a,w=A.y(x).i("c5<2>")
return new A.ag(new A.c5(x,w),new B.b68(),w.i("ag<Z.E>")).gM(0)},
gaze(){var x=this.a,w=A.y(x).i("bK<1>")
w=A.mr(new A.bK(x,w),new B.b69(),w.i("Z.E"),y.S)
w=A.eQ(w,A.y(w).i("Z.E"))
x=A.a9(w,A.y(w).c)
C.b.lD(x)
return x},
dr(){var x,w,v,u,t,s=this,r=y.N,q=A.B(r,y.L)
for(x=s.a,x=new A.ew(x,A.y(x).i("ew<1,2>")).ga0(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.a9(x,A.y(x).c)
return A.I(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
bd9(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b4u(x,300,A.y(x).c),x=new A.JD(J.aw(x.a),x.b,A.y(x).i("JD<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gG()
s=C.j.aH(t,1000)
t=C.j.a3(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.ri():q).a===D.fj?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.ri()
r=u.h(0,r)
o.push(A.I(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.ri():r).c.iV()],w,v))}return o},
bhP(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.L)(d),++u){t=d[u]
s=A.ey(t.h(0,"surah"))*1000+A.ey(t.h(0,"ayah"))
r=w.h(0,C.j.aH(s,1000)*1000+C.j.a3(s,1000))
if((r==null?$.ri():r).c.iV()===t.h(0,"updated_at"))v.K(0,s)}},
bhX(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aw(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gG()
if(!u.b(s))continue
r=A.ax(s.h(0,"surah"))
q=r==null?null:C.f.bB(r)
r=A.ax(s.h(0,"ayah"))
p=r==null?null:C.f.bB(r)
o=A.dO(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cR[q-1].a[1])
if(r)continue
n=B.cH8(s.h(0,"status"))
if(n===D.pc)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.ax(s.h(0,"perfect_count"))
l=l==null?null:C.f.bB(l)
v.p(0,r,new B.rt(n,C.j.cZ(l==null?0:l,0,100),o.hd()))
w.K(0,r)
t=!0}return t}}
B.VI.prototype={
Je(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.VI(w,v,u,t,f==null?x.e:f)},
bbo(d){var x=null
return this.Je(x,x,d,x,x)},
apH(d){var x=null
return this.Je(x,d,x,x,x)},
bbs(d){var x=null
return this.Je(x,x,x,x,d)},
baL(d){var x=null
return this.Je(d,x,x,x,x)},
bbp(d){var x=null
return this.Je(x,x,x,d,x)},
dr(){var x=this
return A.I(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Hw.prototype={
R(){return"ModelState."+this.b}}
B.VJ.prototype={
vJ(){var x=this.Q
return x==null?this.Q=new B.b6a(this).$0():x},
qK(d){return this.axs(d)},
axs(d){var x=0,w=A.k(y.H),v=this
var $async$qK=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:v.b=d
v.a5()
x=2
return A.c(A.ij("mt.tutor.settings",C.am.hk(d.dr(),null)),$async$qK)
case 2:return A.i(null,w)}})
return A.j($async$qK,w)},
zU(){var x=0,w=A.k(y.H),v=this,u
var $async$zU=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:v.a5()
x=2
return A.c(A.ij("mt.tutor.progress",C.am.hk(v.c.dr(),null)),$async$zU)
case 2:u=v.as
if(u!=null)u.aB()
v.as=A.cR(C.x,v.gaEh())
return A.i(null,w)}})
return A.j($async$zU,w)},
Mq(d,e,f){return this.aye(d,e,f)},
aye(d,e,f){var x=0,w=A.k(y.H),v=this
var $async$Mq=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:v.z=new A.aX(d,e,f)
x=2
return A.c(A.ij("mt.tutor.last",C.am.hk(A.I(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Mq)
case 2:return A.i(null,w)}})
return A.j($async$Mq,w)},
Dh(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Dh=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.Vi||n===D.jU){x=1
break}s.f=D.Vi
s.y=null
s.a5()
u=4
n=A.lF().geI().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lF().geI().h(0,"tutor_threads")
p=A.dU(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bhx(new B.b6b(s),n,p),$async$Dh)
case 7:s.x=e
s.f=D.jU
n=A.lF().geI().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.rd().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a8(m)
if(n instanceof B.lE){q=n
s.f=D.aSZ
s.y=q
n=A.lF().geI().h(0,"debug")
if(n==="1")A.rd().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a5()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Dh,w)},
wG(){var x=0,w=A.k(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wG=A.f(function(a0,a1){if(a0===1){t.push(a1)
x=u}for(;;)switch(x){case 0:if(r.at){x=1
break}q=null
try{k=$.C().b
k===$&&A.b()
k=k.ga4().e.a
q=(k==null?null:k.r)!=null}catch(d){x=1
break}if(!q){x=1
break}r.at=!0
u=4
k=$.C().b
k===$&&A.b()
p=k
x=7
return A.c(p.aS("quran_tutor_progress").d6("surah, ayah, status, perfect_count, updated_at"),$async$wG)
case 7:o=a1
n=r.c.bhX(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bd9()
if(J.aR(l)===0){x=10
break}h=p
g=A.I(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.n3(h.x,k,k))
x=11
return A.c(f.blW("quran_tutor_save",!1,g,i),$async$wG)
case 11:r.c.bhP(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.ij("mt.tutor.progress",C.am.hk(r.c.dr(),null)),$async$wG)
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
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$wG,w)},
Lj(d){return this.blz(d)},
blz(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Lj=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.caj(t.c.dr()).dr()
y.f.a(p.h(0,"rows")).ek(0,new B.b6c(d))
t.c=B.caj(p)
x=2
return A.c(t.zU(),$async$Lj)
case 2:v=4
s=$.C().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.ar("quran_tutor_reset",A.I(["p_surah",d],y.N,r),r),$async$Lj)
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
return A.j($async$Lj,w)}}
B.wX.prototype={
P(){var x=$.MZ()
return new B.a0c(x,new A.ah(C.K,$.X()))}}
B.a0c.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.aa(v.goD())
w=y.a
x.vJ().bH(new B.bKT(v),w)
H.aVy().bH(new B.bKU(v),w).fw(new B.bKV())
A.PQ(H.c9F(),y.y)},
xU(){if(this.c!=null)this.j(new B.bKF())},
m(){var x,w=this
w.d.T(w.goD())
x=w.e
x.q$=$.X()
x.L$=0
w.a_()},
Q7(){var x=0,w=A.k(y.H),v,u=this,t,s
var $async$Q7=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qK(s.b.bbo(!0)),$async$Q7)
case 3:t=s.a
t.bkb()
if(t.a9m()){t.ar_()
x=1
break}s.Dh()
case 1:return A.i(v,w)}})
return A.j($async$Q7,w)},
xV(d,e,f){return this.aYs(d,e,f)},
b6s(d){return this.xV(d,null,null)},
aYs(d,e,f){var x=0,w=A.k(y.H),v,u=this,t,s,r
var $async$xV=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.J(y.q).f.Z(A.aP(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.W(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cKZ(s,d),$async$xV)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Mq(d,t.a,t.b),$async$xV)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.N(s,!1).aA(A.ay(new B.bKL(u,d,t),null,r),r),$async$xV)
case 8:if(u.c!=null)u.j(new B.bKM())
case 1:return A.i(v,w)}})
return A.j($async$xV,w)},
u(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gasu()&&!A.N(d,!1).vd())u.push(A.bQ(x,x,x,x,C.yI,x,x,t.gbhf(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bQ(x,x,x,x,D.auc,x,x,new B.bKP(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bQ(x,x,x,x,C.iy,x,x,new B.bKQ(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aGT
else w=t?this.aTi():this.aTU()
return L.xH(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aTU(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a3Y
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b6T,C.a1],x)
for(t=0;t<4;++t){s=D.aJ1[t]
u.push(new A.D(C.br,A.A(A.a([A.b_(s.a,C.an,p,18),C.M,new A.bZ(1,C.ah,A.d(s.b,p,p,p,p,p,G.a1u,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.J(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.byf,C.G,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bq(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,p,F.aM,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bq(C.f.ak(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.G,A.d(q,p,p,p,p,p,A.bB(p,p,r?D.e_:C.cH,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.G,D.bxg],x))
x=A.a([new E.dD(u,C.a4,C.aJ,p,!0,p),new E.dD(A.J(s,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,p,!1,p),D.bGJ,C.G],x)
if(v!=null)x.push(new E.dD(A.d(v,p,p,p,p,p,D.bhY,p,p,p),C.a4,C.aJ,p,!1,p))
else x.push(A.fp(D.ar3,D.bnS,this.gaYK(),A.ev(C.v,C.ae,D.b9U,p,p,p,p)))
x.push(C.a5)
x.push(D.a3U)
return x},
aTi(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.N(r.a.a),p=q.length===0,o=p?C.rw:H.coj(q),n=t.z,m=A.R(v.alE(C.dj,E.bq(s.gatB())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bq(s.aqb()),k=s.c,j=Date.now()
k=k===B.b67(new A.aQ(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Hx(t,!1,u),A.A(A.a([m,C.M,A.R(v.alE(C.lb,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.u],j)
if(n!=null){t=H.kl(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bq(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bq(m)+"\u2013"+E.bq(l)
k.push(new E.dD(A.A(A.a([D.ati,C.Y,A.R(A.J(A.a([D.bjW,A.d(t+" \u2014 "+m,u,u,u,u,u,C.bw,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nz],j),C.h,C.d,C.e,0,u,u),C.a4,C.aJ,new B.bKI(v,n),!0,u))}t=C.i.ad(0.08)
k.push(A.aH(u,C.y,!1,u,!0,C.m,u,A.aI(),r,u,u,u,u,u,2,A.cH(u,new A.ck(4,A.v(14),C.O),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.uk,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qS,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bKJ(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.cV,!0,C.t,u,C.E,u,u,u,u))
k.push(C.u)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bte)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.Rs(o[x]))
C.b.A(k,t)}else{t=A.a([D.aWg,D.aWY,v.Rs(1)],j)
for(w=114;w>=78;--w)t.push(v.Rs(w))
t.push(C.G)
r=v.f
p=A.b_(r?C.yn:C.l9,C.an,u,u)
t.push(A.ff(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,u,C.fc,u,u,u),new B.bKK(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Rs(w))
C.b.A(k,t)}k.push(C.a1)
k.push(D.Cr)
return k},
alE(d,e,f){var x=null,w=y.p
return new E.dD(A.A(A.a([A.b_(d,C.v,x,x),C.M,A.R(A.J(A.a([A.d(e,x,x,x,x,x,C.bw,x,x,x),A.d(f,x,1,C.N,x,x,C.a29,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a4,C.H,x,!1,x)},
Rs(d){var x,w=null,v=this.d.c,u=I.cR[d-1].a[1],t=v.a6t(d),s=t/u,r=y.p,q=A.ao(A.dC(C.P,A.a([A.c84(C.eU,G.cO,w,w,w,w,w,3,s,w),A.d(E.bq(d),w,w,w,w,w,Q.a2v,w,w,w)],r),C.m,C.bk,w),36,36),p=A.d(H.kl(d),w,w,w,w,w,D.bcM,w,w,w)
if(t===0)x=E.bq(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bq(t)+" \u0645\u0646 "+E.bq(u)
r=A.a([q,C.cG,A.R(A.J(A.a([p,A.d(x,w,w,w,w,w,A.bB(w,w,t===u?G.cO:C.cH,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bq(C.f.ak(s*100))+"\u066a",w,w,w,w,w,D.a2_,w,w,w))
r.push(D.arb)
return new E.dD(A.A(r,C.h,C.d,C.e,0,w,w),C.q8,C.d1,new B.bKN(this,d),!1,w)}}
B.Hx.prototype={
u(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aW0
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.MS(x),r,r,r,r,r,D.BA,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.Dk(w,"model load",r))
x.push(C.G)
x.push(new A.zY(C.a4J,!1,q.gbhw(),r,r,r,r,C.k,r,!1,r,!0,r,C.oN,r))
return new E.dD(A.J(x,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.cZ(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bq(C.f.ak(u/1e6))+" \u0645\u0646 "+E.bq(C.f.ak(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,r,C.oF,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fb(x,A.qa(C.eU,C.v,7,s?t:r,r),C.az)],w)
if(!this.d)C.b.A(x,A.a([C.G,D.boH],w))
return new E.dD(A.J(x,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)}}}
B.Y0.prototype={
u(d){var x=null,w=D.e_.ad(0.1),v=A.v(14),u=A.aJ(D.e_.ad(0.4),1)
return A.F(x,A.A(A.a([D.asX,C.M,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,x,C.BH,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.G(w,x,u,v,x,x,x,C.n),x,x,x,C.aJ,C.ac,x,x,x)}}
B.Em.prototype={
R(){return"_Phase."+this.b}}
B.Dj.prototype={
P(){return new B.a2I($.MZ(),D.mo)}}
B.a2I.prototype={
gje(){var x=this.e
return x===$?this.e=this.a.d:x},
gBR(){var x,w=this.a,v=w.f
w=w.c
x=this.gje()
return H.MQ(w,x,v.y6(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.aa(w.goD())
x.vJ()
x.a.a70(B.aAc(w.a.c,w.gje()))},
xU(){if(this.c!=null)this.j(new B.bYu())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.Q
if(x!=null)x.aB()
v=v.a
v.MI()
v.a3I()
w.a_()},
a_i(d){var x,w,v=this
if(v.f===D.v4)v.d.a.a3I()
x=v.d.a
x.MI()
w=v.Q
if(w!=null)w.aB()
v.j(new B.bYK(v,d))
x.a70(B.aAc(v.a.c,d))
w=v.a
if(d<w.e)x.a70(B.aAc(w.c,d+1))},
RK(d){return this.aUL(d)},
aUL(d){var x=0,w=A.k(y.H),v,u=this,t,s,r,q,p
var $async$RK=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:if(u.f===D.v3){u.d.a.MI()
u.j(new B.bYO(u))
x=1
break}t=u.r!=null?D.jc:D.mo
u.j(new B.bYP(u))
s=u.d
r=A.a([B.aAc(u.a.c,u.gje())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.L2(r,q),$async$RK)
case 3:p=f
if(u.c==null||u.f!==D.v3){x=1
break}u.j(new B.bYQ(u,t,p))
case 1:return A.i(v,w)}})
return A.j($async$RK,w)},
Qx(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Qx=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jU){x=1
break}p=l.a
p.MI()
r=B.F4(s.gBR()).length
s.j(new B.bYS(s))
o=s.Q
if(o!=null)o.aB()
s.Q=A.hD(C.eY,new B.bYT(s))
u=4
o=B.cc5(r)
n=A.dr(0,0,0,350*r,0,0)
x=7
return A.c(p.a9y(l.b.c,o,n,new B.bYU(s),new B.bYV(s)),$async$Qx)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lE){q=l
l=s.Q
if(l!=null)l.aB()
if(s.c!=null)s.j(new B.bYW(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Qx,w)},
BL(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$BL=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.v4){x=1
break}m=s.Q
if(m!=null)m.aB()
s.j(new B.bYY(s))
s.Q=A.hD(C.it,new B.bYZ(s))
l=new A.CM()
$.F7()
l.om()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a9C(),$async$BL)
case 7:q=e
if(q.b<0.8){s.b6r("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.avz(q,B.F4(s.gBR()).length),$async$BL)
case 8:p=e
s.ch=A.dr(0,0,r.ga52(),0,0,0)
k=A.lF().geI().h(0,"debug")
if(k==="1"){o=B.coz(m.Jv())
A.rd().$1("[tutor] "+s.a.c+":"+s.gje()+" audio="+C.f.az(q.b,1)+"s infer="+p.b+"ms total="+r.gCE()+"ms "+p.gT7()+" text="+p.a)
A.rd().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.az(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(p.b/1000,2)+" \u062b\n"+p.gT7()+"\n"+A.n(o)+"\n"+p.a}s.afM(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lE){n=m
m=A.lF().geI().h(0,"debug")
if(m==="1")A.rd().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.Jv())
s.a2x(B.MS(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$BL,w)},
a2x(d,e){var x=this,w=x.Q
if(w!=null)w.aB()
if(x.c==null)return
x.j(new B.bYJ(x,d,e))},
b6r(d){return this.a2x(d,null)},
afM(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aB()
if(s.c==null)return
x=B.cmA(s.gBR(),d)
r.a=null
if(C.c.N(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gje()
t=x.gtu()
r.a=w.auA(v,u,q.b.a,t)
q.zU()}s.j(new B.bYL(r,s,x))},
O6(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$O6=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jU){x=1
break}s.j(new B.bYC(s))
l=s.Q
if(l!=null)l.aB()
s.Q=A.hD(C.it,new B.bYD(s))
k=new A.CM()
$.F7()
k.om()
r=k
u=4
l=g.a
x=7
return A.c(l.bmo(B.aAc(s.a.c,s.gje()),B.F4(s.gBR()).length),$async$O6)
case 7:q=e
p=B.coz(l.Jv())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.az(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.az(r.gCE()/1000,2)+" \u062b)\n"+q.gT7()+"\n"+A.n(p)+"\n"+q.a
A.rd().$1("[tutor-debug] "+s.a.c+":"+s.gje()+" audio="+C.f.az(q.c,1)+"s infer="+q.b+"ms total="+r.gCE()+"ms "+q.gT7()+" text="+q.a)
A.rd().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dr(0,0,r.ga52(),0,0,0)
s.afM(q.a)
n=s.r
if(n!=null){l=n.gtu()
j=n.b
i=A.al(j).i("ag<1>")
j=A.a9(new A.ag(j,new B.bYE(),i),i.i("Z.E"))
A.rd().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.bYF(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lE){m=l
A.rd().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.Jv())
s.a2x(B.MS(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$O6,w)},
ga1f(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.ri():v).a!==D.fj)return!1}return!0},
u(d){var x,w=this,v=null,u=w.d,t=u.c.a6C(w.a.c,w.gje()),s=u.b,r=s.d&&!w.x&&w.f!==D.jc,q=H.kl(w.a.c),p=y.p,o=A.a([A.bQ(v,v,v,v,C.iy,v,v,new B.bZ3(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aL9(),m=A.d("\u0622\u064a\u0629 "+E.bq(w.gje()),v,v,v,v,v,C.m6,v,v,v),l=E.bq(w.gje()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.aY,A.d("("+l+" \u0645\u0646 "+E.bq(k.e-k.d+1)+")",v,v,v,v,v,F.aM,v,v,v),C.bE,w.aZv(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.u],p)
if(r)s.push(w.aTd())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.v4&&l!==D.p3}else l=!1
if(l)s.push(w.aIN(m))
else s.push(A.d(w.gBR()+" \ufd3f"+E.bq(w.gje())+"\ufd3e",v,v,v,v,v,D.kg,C.Z,C.bi,v))}s=A.a([new B.Hx(u,!0,v),n,C.B,new E.dD(A.J(s,C.ag,C.d,C.e,0,C.l),D.ajV,C.aJ,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.jc)s.push(w.b7W(n))
if(w.r!=null&&w.f===D.jc&&w.ch!=null){x=C.f.ak(C.j.aH(w.ch.a,1000)/100)
s.push(new A.D(C.br,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bq(C.j.aH(x,10))+"\u066b"+E.bq(C.j.a3(x,10)))+" \u062b",v,v,v,v,v,F.aM,C.Z,v,v),v))}n=w.as
if(n!=null)s.push(new A.D(C.aJ,A.d(n,v,v,v,v,v,D.BA,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.Dk(n,"check "+w.a.c+":"+w.gje(),v))}s.push(w.aJn())
s.push(C.a1)
s.push(A.it(C.v,C.H,v,new B.bZ4(w),D.blC,D.bqX,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga1f()
s.push(new E.dD(A.A(A.a([D.apE,C.Y,A.R(A.J(A.a([D.bsB,A.d(w.ga1f()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,v,F.aM,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nz],p),C.h,C.d,C.e,0,v,v),C.a4,C.aJ,new B.bZ5(w,d),n,v))}n=A.lF().geI().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.de(D.ar2,D.bqp,u.f===D.jU&&w.f!==D.p3?w.gaK6():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.D(C.hN,A.xi(n,F.aM,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn4()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,v,F.aM,v,v,v))}p.push(A.bf(D.brK,v,v,v,new B.bZ6(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.Cr)
return L.xH(o,s,q)},
aL9(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.ao(A.ft(new B.bYH(this),w,null,C.af,new B.bYI()),36,null)},
aZv(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fj)return D.b74
x=d.b
w=E.bq(x)
v=E.bq(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c1:C.qJ
u.push(new A.D(D.akE,A.b_(r,s?G.cO:C.eV,q,16),q))}return A.ajv(A.A(u,C.h,C.d,C.L,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aTd(){var x=null
return A.bv(!1,A.v(12),!0,A.F(x,D.afX,C.k,x,x,new A.G(C.pE,x,x,A.v(12),x,x,x,C.n),x,x,x,x,D.ajt,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bYN(this),x,x,x,x,x,x,x)},
aIN(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.au(d.gMG(),w)
A:{if(D.j5===v){u=D.kg.ct(G.cO)
break A}if(D.uO===v){u=D.kg.a4l(D.e_,C.fM,D.e_)
break A}if(D.uP===v){u=D.kg.a4l(D.eT,C.fM,D.eT)
break A}u=D.kg.a4l(C.eV,C.j0,C.cc)
break A}t=x[w]
r.push(new A.eM(t.a,s,s,C.bt,s,s,s,s,s,s,u))
r.push(P.Bs)}x=E.bq(this.gje())
r.push(A.es(s,s,s,s,s,s,s,s,s,D.kg.ct(C.an),"\ufd3f"+x+"\ufd3e"))
return A.CY(A.es(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Z,C.bi)},
b7W(d){var x,w,v,u,t,s,r=this.w
if(C.c.N(d.c).length===0)return D.bG5
if(d.gtu()){x=r==null
if((x?null:r.a)===D.fj&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fj?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bq(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.DC(G.cO,C.c1,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMG()
w=J.dE(x)
v=w.iE(x,new B.bZ_()).gM(0)
u=w.iE(x,new B.bZ0()).gM(0)
t=w.iE(x,new B.bZ1()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bq(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bq(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bq(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJO().length!==0)x.push(E.bq(d.gJO().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eT:D.e_
x=C.b.aC(x," \u2022 ")
s=d.gJO().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aC(d.gJO(),"\u060c "):""
return new B.DC(w,C.np,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aJn(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jU,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aH(new A.aQ(f,0,!1).dD(w).a,1e6)}v=C.j.aH(B.cc5(B.F4(j.gBR()).length).a,1e6)
f=j.gb50()
w=96+26*j.y
u=D.eT.ad(0.25)
w=A.iO(i,A.a5y(C.P,A.F(i,D.arf,C.k,i,i,D.a7M,i,84,i,i,i,i,i,84),i,C.aU,new A.G(u,i,i,i,i,i,i,C.bZ),C.Fm,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cS)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.cb0(x)+" / "+B.cb0(v),i,i,i,i,i,K.oE,i,i,i)
return A.J(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,i,F.aM,i,i,i),A.bf(D.bxf,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.eB((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bq(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bq(t)+" \u062b)"
return new A.D(C.q4,A.J(A.a([C.vW,C.a1,D.bp8,A.d(h,i,i,i,i,i,F.aM,C.Z,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.v3
r=j.r
f=r==null
w=!f
q=w&&r.gtu()
u=A.b_(s?C.nq:K.HW,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i,i)
o=A.ev(i,i,D.b9R,i,i,i,i)
u=A.R(new A.zY(C.a4J,!0,new B.bYv(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.YC(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.JC[n]
p.push(new A.eb(m,i,A.d("\xd7"+E.bq(m),i,i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.M,A.ns(new B.bYw(j),p,A.da([h.b.b],o),!1,A.kp(i,i,i,new A.bh(new B.bYx(),l),i,i,i,i,new A.bh(new B.bYy(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cL),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb0w():i
u=A.b_(f?D.qF:C.np,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,i,C.cm,i,i,i)
p=q?C.ip:C.v
h=A.a([o,C.u,A.fp(u,f,h,A.ev(p,q?C.i:C.ae,D.tT,i,i,i,i))],k)
if(w&&j.gje()<j.a.e)C.b.A(h,A.a([C.B,q?A.fp(D.auB,D.bvX,new B.bYz(j),A.ev(G.cO,C.ae,D.tT,i,i,i,i)):A.bf(D.bm3,i,i,i,new B.bYA(j),i,i)],k))
if(w){f=j.gje()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.D(C.iu,A.d(j.ga1f()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,i,K.ut,C.Z,i,i),i))
return A.J(h,C.ag,C.d,C.e,0,C.l)}}}
B.DC.prototype={
u(d){var x=this,w=null,v=x.c,u=v.ad(0.12),t=A.v(14),s=A.aJ(v.ad(0.5),1),r=y.p
return A.F(w,A.A(A.a([A.b_(x.d,v,w,w),C.M,A.R(A.J(A.a([A.d(x.e,w,w,w,w,w,A.bB(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.V,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bR,A.d(x.f,w,w,w,w,w,C.BH,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.G(u,w,s,t,w,w,w,C.n),w,w,w,C.aJ,C.ac,w,w,w)}}
B.Di.prototype={
P(){var x=y.S
return new B.a2H($.MZ(),A.B(x,y.B),A.aS(x),A.B(x,y.N),A.em(null,y.H))}}
B.a2H.prototype={
W(){this.Y()
this.d.aa(this.goD())},
xU(){if(this.c!=null)this.j(new B.bYd())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.y
if(x!=null)x.aB()
v.a.a3I()
w.a_()},
Ij(d){return this.b4M(d)},
b4M(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$Ij=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.bYm(t,d))
r=t.y
if(r!=null)r.aB()
t.y=A.hD(C.eY,new B.bYn(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.cc5(B.F4(H.MQ(q,d,p.y6(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dr(0,0,0,350*B.F4(H.MQ(p,d,o.y6(p,d)).b).length,0,0)
x=6
return A.c(r.a.a9y(r.b.c,q,p,new B.bYo(t,d),new B.bYp(t)),$async$Ij)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lE){s=r
r=t.y
if(r!=null)r.aB()
if(t.c!=null)t.j(new B.bYq(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$Ij,w)},
FL(d,e){return this.aMj(d,e)},
aMj(d,e){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$FL=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aB()
s.j(new B.bYh(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a9C()
if(e&&n!=null)s.Ij(n)
q=null
u=4
x=7
return A.c(r,$async$FL)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lE){p=o
s.j(new B.bYi(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bH(new B.bYj(s,o,d),y.H)}case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$FL,w)},
gaWV(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b1r(){this.j(new B.bYk(this))},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jU,o=s.e,n=s.gaWV(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("c5<2>")
x=new A.ag(new A.c5(m,l),new B.bYr(),l.i("ag<Z.E>")).gM(0)
l=H.kl(s.a.c)
m=y.p
q=A.a([new B.Hx(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bq(s.a.d)+" \u0644\u062d\u062f "+E.bq(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,r,F.aM,r,r,r),C.u],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b6t(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,r,D.BA,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.Dk(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bq(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aH(new A.aQ(v,0,!1).dD(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.cb0(v),r,r,r,r,r,K.oE,C.Z,r,r)
j=A.fb(A.v(6),A.qa(C.eU,D.eT,6,s.x,r),C.az)
u=o<s.a.e
t=A.b_(u?O.HP:C.nq,r,r,r)
C.b.A(q,A.a([v,C.G,j,C.u,A.fp(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,r,C.cm,r,r,r),new B.bYs(s,o),A.ev(C.v,C.ae,D.tT,r,r,r,r))],m))}else if(n!=null){j=p?new B.bYt(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bq(n)
q.push(A.fp(D.asq,A.d(v,r,r,r,r,r,C.cm,r,r,r),j,A.ev(C.v,C.ae,D.tT,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aWr)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cO:D.e_
v=k?C.ni:C.np
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bq(x)
u=s.a
u=k+" \u0645\u0646 "+E.bq(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.DC(j,v,k,u,r),A.de(D.auo,D.bwC,s.gb1q(),r)],m))}q.push(C.u)
q.push(D.Cr)
return L.xH(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b6t(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.arK
else if(l.r.n(0,d))x=N.tW
else if(i!=null)x=D.as1
else if(j!=null){w=j.gtu()?C.c1:D.aod
x=A.b_(w,j.gtu()?G.cO:D.e_,k,k)}else x=D.aqj
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bq(d),k,k,k,k,k,C.a2h,k,k,k),C.bE,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,k,D.a2b,k,k,k))
if(j!=null&&!j.gtu()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMG()
o=J.bd(p)
n=o.h(p,r)
A:{if(D.j5===n){m=G.cO
break A}if(D.uO===n){m=D.e_
break A}if(D.uP===n){m=D.eT
break A}m=C.eV
break A}m=D.kg.bc3(m,o.h(p,r)===D.uQ?C.j0:k,22)
C.b.A(t,A.a([new A.eM(q.a,k,k,C.bt,k,k,k,k,k,k,m),P.Bs],u))}w=A.a([C.ak,A.CY(A.es(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Z,C.bi)],w)
if(C.c.N(j.c).length===0)w.push(D.brZ)
C.b.A(v,w)}return new E.dD(A.J(v,C.ag,C.d,C.e,0,C.l),C.bN,C.d1,k,!1,k)}}
B.Dh.prototype={
P(){return new B.a2G($.MZ())}}
B.a2G.prototype={
W(){this.Y()
var x=this.d
x.aa(this.goD())
x.vJ()},
xU(){if(this.c!=null)this.j(new B.bY4())},
m(){this.d.T(this.goD())
this.a_()},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gaze(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.j6(o,0,new B.bYb(q))
v=C.b.j6(o,0,new B.bYc())
o=y.p
o=A.a([A.A(A.a([A.R(s.Y9(E.bq(q.gatB()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.M,A.R(s.Y9(E.bq(q.aqb()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.M,A.R(s.Y9(E.bq(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.u,new E.dD(A.J(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bq(C.f.ak(w*100/v))+"\u066a",r,r,r,r,r,C.bw,r,r,r),C.G,A.fb(A.v(6),A.qa(C.eU,G.cO,8,w/v,r),C.az),C.ak,A.d(E.bq(w)+" \u0645\u0646 "+E.bq(v)+" \u0622\u064a\u0629",r,r,r,r,r,F.aM,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)],o)
if(p.length===0)o.push(D.aWG)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b6v(p[t]))
o.push(C.B)
u=$.C().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,r,F.aM,r,r,r))
return L.xH(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
Y9(d,e){var x=null
return new E.dD(A.J(A.a([A.d(d,x,x,x,x,x,D.bgU,x,x,x),A.d(e,x,x,x,x,x,C.a2H,C.Z,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a4,C.H,x,!1,x)},
b6v(d){var x=null,w=this.d.c,v=I.cR[d-1].a[1],u=w.a6t(d),t=w.bhe(d),s=y.p,r=A.A(A.a([A.R(A.d(H.kl(d),x,x,x,x,x,C.bw,x,x,x),1),A.d(E.bq(C.f.ak(u*100/v))+"\u066a",x,x,x,x,x,D.bhZ,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fb(A.v(6),A.qa(C.eU,G.cO,7,u/v,x),C.az),p=E.bq(u),o=E.bq(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bq(t):""
return new E.dD(A.J(A.a([r,C.G,q,C.ak,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,x,F.aM,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,new B.bYa(this,d),!1,x)},
O9(d){return this.aKs(d)},
aKs(d){var x=0,w=A.k(y.H),v=this,u,t
var $async$O9=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=I.cR[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e_(C.cN,new B.bY9(v,d,u),t,!0,null,null,!1,y.H),$async$O9)
case 2:return A.i(null,w)}})
return A.j($async$O9,w)}}
B.ajA.prototype={
RJ(d,e){var x=null,w=A.lD(x,x,x,x,x,x,x,x,x,x,x,D.b9q,C.H,x,x,x,x,C.jT,x,x)
return A.bf(A.d(d,x,x,x,x,x,C.m5,x,x,x),x,x,x,new B.b5U(e),x,w)},
u(d){var x=this,w=y.p
return new E.dD(A.J(A.a([D.bvI,C.G,D.bxe,A.cW(C.aw,A.a([x.RJ("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.RJ("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aE,0,12),D.ble,x.RJ("tanzil.net","https://tanzil.net"),D.byS,x.RJ("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,null,!1,null)}}
B.Dk.prototype={
P(){return new B.a2J()}}
B.a2J.prototype={
gams(){var x=this.a
return B.cMk(x.c,x.d,$.ccI().Jv())},
RL(){var x=0,w=A.k(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$RL=A.f(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.bZ7(s))
v=3
r=A.c6a()
n=s.gams()
m=y.N
q=A.B(m,m)
J.dX(q,"app","mogtama3y")
J.dX(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dX(q,"ua",m)}x=6
return A.c(A.aa4(n,null,C.Gr,q),$async$RL)
case 6:if(s.c!=null)s.j(new B.bZ8(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cd?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.bZ9(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.bZa(s))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$RL,w)},
u(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bv(!1,t,!0,new A.D(C.kU,A.A(A.a([A.b_(u.d?C.yn:C.l9,C.cc,t,18),C.bL,D.by1],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bZc(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.F(t,A.xi(u.gams(),D.bda,t,C.A),C.k,t,t,new A.G(C.pE,t,t,x,t,t,t,C.n),t,t,t,D.ajw,C.ed,t,t,1/0))}if(u.f)s.push(D.blw)
else{x=A.lD(t,t,t,t,t,t,t,t,t,t,t,C.a0v,C.H,t,t,t,t,C.jT,t,t)
w=u.e
v=w?t:u.gb6u()
s.push(A.ff(w?C.a0K:D.atK,t,D.buD,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,t,D.a2b,t,t,t))
return new A.D(C.aJ,A.J(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["ak<~>()","~()","O(nE)","ak<JX>()","ak<JV>()","ak<JW>()","a7<nE>()","O(rt)","bC(oM)","Dj(u)","Dh(u)","O(mW)","Di(u)","O(Iz)"])
B.b5V.prototype={
$0(){var x=0,w=A.k(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.S(A.cS(b.G.document).baseURI)
q=A.bx(r,0,null).a2("quran_tutor/tutor.js?v=3").k(0)
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
m=B.cBw("network",A.n(o))
throw A.r(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:400}
B.b5Y.prototype={
$1(d){var x=null
return A.c0J(A.cM(d,"persist",x,x,x,x))},
$S:1121}
B.b5X.prototype={
$0(){var x=0,w=A.k(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.ra(),$async$$0)
case 4:x=3
return A.c(n.eF(m.cS(l.cM(e,"loadModel",A.c1r(new B.b5W(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.t(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.t(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.r9(p,"ms")
r=q.or(p,"cached")
A.t(p.backend)
v=new B.JV(o,t,s,r,q.r9(p,"threads"),q.or(p,"isolated"),q.r9(p,"warmMs"))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+4}
B.b5W.prototype={
$2(d,e){this.a.$2(C.f.ak(d),C.f.ak(e))},
$S:1122}
B.b61.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t,s
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
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
u.onLevel=A.fW(new B.b6_(v.e))
u.onAutoStop=A.fW(new B.b60(v.f))
x=5
return A.c(A.eF(A.cS(A.cM(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.b6_.prototype={
$1(d){return this.a.$1(d)},
$S:67}
B.b60.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b62.prototype={
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
return A.c(t.ra(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eF(p.cS(o.cM(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.JW(r,A.dQ(r.seconds))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+5}
B.b64.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.ra(),$async$$0)
case 4:x=3
return A.c(q.eF(p.cS(o.cM(e,"transcribe",t.audio,t.rate,s.aiL(u.c),null)),y.m),$async$$0)
case 3:v=r.amm(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b63.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.ra(),$async$$0)
case 4:x=3
return A.c(r.eF(q.cS(p.cM(e,"transcribeUrl",u.b,t.aiL(u.c),null,null)),y.m),$async$$0)
case 3:v=s.amm(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b5Z.prototype={
$1(d){return d},
$S:39}
B.aX5.prototype={
$0(){var x,w,v,u,t=this.a,s=A.co(t.a.length,D.uQ,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aX4.prototype={
$1(d){return d===D.j5},
$S:z+2}
B.c1a.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c7a(e[x],d[x])<0.75)return!1
return!0},
$S:1123}
B.c3h.prototype={
$1(d){return d.length!==0},
$S:10}
B.b68.prototype={
$1(d){return d.a===D.fj},
$S:z+7}
B.b69.prototype={
$1(d){return C.j.aH(d,1000)},
$S:59}
B.b66.prototype={
$1(d){return C.f.bB(d)},
$S:1124}
B.b6a.prototype={
$0(){var x=0,w=A.k(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.f(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iB("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.am.f0(r,null))
j=A.ax(k.h(0,"n"))
j=j==null?null:C.f.bB(j)
j=C.j.cZ(j==null?2:j,1,5)
i=C.b.n(D.JC,k.h(0,"r"))?A.ey(k.h(0,"r")):1
h=A.ei(k.h(0,"auto"))
g=A.ei(k.h(0,"hide"))
k=A.ei(k.h(0,"in"))
s.a.b=new B.VI(j,i,h!==!1,g===!0,k===!0)}u=2
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
return A.c(A.iB("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.caj(y.P.a(C.am.f0(q,null)))
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
return A.c(A.iB("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.am.f0(p,null))
n=C.f.bB(A.cN(J.au(o,"s")))
m=C.f.bB(A.cN(J.au(o,"f")))
l=C.f.bB(A.cN(J.au(o,"t")))
if(B.coE(n,m)&&B.coE(n,l)&&m<=l)s.a.z=new A.aX(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a9m()){k.a.ar_()
x=1
break}a1=k
x=18
return A.c(k.a.N0(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a5()
if(k.b.e)k.Dh()
k.wG()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:108}
B.b6b.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a5()},
$S:1125}
B.b6c.prototype={
$2(d,e){return C.j.aH(A.eE(A.n(d),null,null),1000)===this.a},
$S:1126}
B.bKT.prototype={
$1(d){var x=0,w=A.k(y.a),v=this,u,t
var $async$$1=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.Ey(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bKS(u,t))
return A.i(null,w)}})
return A.j($async$$1,w)},
$S:1127}
B.bKS.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bKU.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bKR(x,d))},
$S:z+8}
B.bKR.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bKV.prototype={
$1(d){},
$S:23}
B.bKF.prototype={
$0(){},
$S:0}
B.bKL.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.Dj(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bKM.prototype={
$0(){},
$S:0}
B.bKP.prototype={
$0(){var x=y.z
return A.N(this.a,!1).aA(A.ay(new B.bKO(),null,x),x)},
$S:0}
B.bKO.prototype={
$1(d){return D.bAd},
$S:z+10}
B.bKQ.prototype={
$0(){return B.coq(this.a)},
$S:0}
B.bKI.prototype={
$0(){var x=this.b
return this.a.xV(x.a,x.b,x.c)},
$S:0}
B.bKJ.prototype={
$1(d){return this.a.j(new B.bKH())},
$S:5}
B.bKH.prototype={
$0(){},
$S:0}
B.bKK.prototype={
$0(){var x=this.a
return x.j(new B.bKG(x))},
$S:0}
B.bKG.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bKN.prototype={
$0(){return this.a.b6s(this.b)},
$S:0}
B.c5O.prototype={
$1(d){return new A.ja(new B.c5L(this.a,this.b,this.c),null)},
$S:57}
B.c5L.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c5N(u,e),s=this.a,r=new B.c5M(s,e),q=A.d(H.kl(this.c),v,v,v,v,v,C.oA,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bq(u)+" \u0622\u064a\u0629)",v,v,v,v,v,F.aM,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bq(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bq(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.cZ(w+4,1,u)))}u=A.a([q,C.ak,p,C.u,A.cW(C.aw,n,C.aE,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c5G(s)),C.a0G,t.$3("\u0644\u062d\u062f",s.c,new B.c5H(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aWw)
u.push(C.a5)
u.push(A.dA(D.boC,new B.c5I(s,d),A.ev(C.v,C.ae,D.b9O,v,v,v,v)))
return A.cw(!0,new A.D(C.FT,A.J(u,C.ag,C.d,C.L,0,C.l),v),C.H,!0)},
$S:391}
B.c5N.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,u,C.ia,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c7(v,A.d("\u0622\u064a\u0629 "+E.bq(v),u,u,u,u,u,u,u,u,u),C.aq,u,w))
return A.R(A.J(A.a([t,R.Gf(C.cN,!0,s,320,new B.c5K(this.b,f),D.bif,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1129}
B.c5K.prototype={
$1(d){return d==null?null:this.a.$1(new B.c5J(this.b,d))},
$S:52}
B.c5J.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c5M.prototype={
$3(d,e,f){var x=null
return A.c7L(x,A.d(d,x,x,x,x,x,x,x,x,x),new B.c5F(this.a,this.b,e,f))},
$S:1130}
B.c5F.prototype={
$0(){var x=this
return x.b.$1(new B.c5E(x.a,x.c,x.d))},
$S:0}
B.c5E.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c5G.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c5H.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c5I.prototype={
$0(){var x=this.a
return A.N(this.b,!1).af(new A.W(x.b,x.c))},
$S:0}
B.bYu.prototype={
$0(){},
$S:0}
B.bYK.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mo
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bYO.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.jc:D.mo},
$S:0}
B.bYP.prototype={
$0(){var x=this.a
x.f=D.v3
x.as=null},
$S:0}
B.bYQ.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bYS.prototype={
$0(){var x=this.a
x.f=D.v4
x.as=null
x.y=0
x.z=new A.aQ(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bYT.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bYR())},
$S:30}
B.bYR.prototype={
$0(){},
$S:0}
B.bYV.prototype={
$1(d){return this.a.y=d},
$S:67}
B.bYU.prototype={
$1(d){return this.a.BL()},
$S:5}
B.bYW.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.jc:D.mo
x=this.b
w.as=B.MS(x)
w.at=x},
$S:0}
B.bYY.prototype={
$0(){var x=this.a
x.f=D.p3
x.ay=Date.now()},
$S:0}
B.bYZ.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bYX())},
$S:30}
B.bYX.prototype={
$0(){},
$S:0}
B.bYJ.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.jc:D.mo
x.as=this.b
x.at=this.c},
$S:0}
B.bYL.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.jc
x.x=!1},
$S:0}
B.bYC.prototype={
$0(){var x=this.a
x.f=D.p3
x.ay=Date.now()
x.as=null},
$S:0}
B.bYD.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bYB())},
$S:30}
B.bYB.prototype={
$0(){},
$S:0}
B.bYE.prototype={
$1(d){return d.d!==D.j5},
$S:z+11}
B.bYF.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bZ3.prototype={
$0(){return B.coq(this.a)},
$S:0}
B.bZ4.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.apH(d))},
$S:3}
B.bZ5.prototype={
$0(){var x=y.z
return A.N(this.b,!1).aA(A.ay(new B.bZ2(this.a),null,x),x)},
$S:0}
B.bZ2.prototype={
$1(d){var x=this.a.a
return new B.Di(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bZ6.prototype={
$0(){this.a.d.a.blx()
this.b.J(y.q).f.Z(D.baU)},
$S:0}
B.bYI.prototype={
$2(d,e){return C.aY},
$S:17}
B.bYH.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a6C(s.c,r).a.a){case 2:s=G.cO
break
case 1:s=D.e_
break
case 0:s=C.ip
break
default:s=u}x=A.v(18)
w=t.f===D.p3?u:new B.bYG(t,r)
v=s.ad(0.25)
if(r===t.gje())s=C.i
s=A.aJ(s,r===t.gje()?2:1)
return A.bv(!1,x,!0,A.F(C.P,A.d(E.bq(r),u,u,u,u,u,C.a1Q,u,u,u),C.k,u,u,new A.G(v,u,s,u,u,u,u,C.bZ),u,u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:66}
B.bYG.prototype={
$0(){return this.a.a_i(this.b)},
$S:0}
B.bYN.prototype={
$0(){var x=this.a
return x.j(new B.bYM(x))},
$S:0}
B.bYM.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bZ_.prototype={
$1(d){return d===D.uO},
$S:z+2}
B.bZ0.prototype={
$1(d){return d===D.uP},
$S:z+2}
B.bZ1.prototype={
$1(d){return d===D.uQ},
$S:z+2}
B.bYv.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.RK(x)},
$S:0}
B.bYw.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.bbs(d.ga1(d)))},
$S:105}
B.bYy.prototype={
$1(d){return d.n(0,C.T)?C.ae:C.i},
$S:4}
B.bYx.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.bYz.prototype={
$0(){var x=this.a
return x.a_i(x.gje()+1)},
$S:0}
B.bYA.prototype={
$0(){var x=this.a
return x.a_i(x.gje()+1)},
$S:0}
B.bYd.prototype={
$0(){},
$S:0}
B.bYm.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aQ(Date.now(),0,!1)},
$S:0}
B.bYn.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bYl())},
$S:30}
B.bYl.prototype={
$0(){},
$S:0}
B.bYp.prototype={
$1(d){return this.a.x=d},
$S:67}
B.bYo.prototype={
$1(d){return this.a.FL(this.b,!1)},
$S:5}
B.bYq.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.MS(x)
w.as=x},
$S:0}
B.bYh.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.bYi.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.MS(x))
w.as=x},
$S:0}
B.bYj.prototype={
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
return A.c(n.a.avz(s.b,B.F4(H.MQ(l,m,k.y6(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cmA(H.MQ(l,m,k.y6(l,m)).b,r.a)
if(C.c.N(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtu()
l.auA(k,m,n.b.a,j)}n.zU()
if(o.c!=null)o.j(new B.bYe(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lE){p=o
o=s.a
if(o.c!=null)o.j(new B.bYf(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.bYg(o,s.c))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$1,w)},
$S:154}
B.bYe.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.bYf.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.MS(w))
x.as=w},
$S:0}
B.bYg.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bYk.prototype={
$0(){var x=this.a
x.f.ao(0)
x.w.ao(0)
x.as=null},
$S:0}
B.bYr.prototype={
$1(d){return d.gtu()},
$S:z+13}
B.bYs.prototype={
$0(){return this.a.FL(this.b,!0)},
$S:0}
B.bYt.prototype={
$0(){return this.a.Ij(this.b)},
$S:0}
B.bY4.prototype={
$0(){},
$S:0}
B.bYb.prototype={
$2(d,e){return d+this.a.a6t(e)},
$S:109}
B.bYc.prototype={
$2(d,e){return d+I.cR[e-1].a[1]},
$S:109}
B.bYa.prototype={
$0(){return this.a.O9(this.b)},
$S:0}
B.bY9.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kl(p),q,q,q,q,q,C.oA,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.bc(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.ri():r).a.a){case 2:r=G.cO.ad(0.35)
break
case 1:r=D.e_.ad(0.35)
break
case 0:r=C.fX
break
default:r=q}m.push(A.F(C.P,A.d(E.bq(t),q,q,q,q,q,C.kf,q,q,q),C.k,q,q,new A.G(r,q,q,new A.cG(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,q,38))}return A.cw(!0,new A.D(C.h2,A.J(A.a([o,C.ak,D.bsU,C.u,new A.dq(D.a7D,A.f7(A.cW(C.aw,m,C.aE,6,6),q,C.r,q,q,q,C.w),q),C.a1,A.bf(D.buH,q,q,q,new B.bY8(w,d,p),q,q)],n),C.ag,C.d,C.L,0,C.l),q),C.H,!0)},
$S:36}
B.bY8.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dj(null,null,!0,null,new B.bY7(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Lj(t),$async$$0)
case 5:if(u.e!=null)A.N(u,!1).e4()
case 3:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.bY7.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kl(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x,x)
return A.dp(A.a([A.bf(C.es,x,x,x,new B.bY5(d),x,x),A.bf(C.oQ,x,x,x,new B.bY6(d),x,x)],y.p),w,D.bwj)},
$S:14}
B.bY5.prototype={
$0(){A.N(this.a,!1).af(!1)
return null},
$S:0}
B.bY6.prototype={
$0(){A.N(this.a,!1).af(!0)
return null},
$S:0}
B.c6L.prototype={
$1(d){var x=this.a
return new A.kE(new B.c6K(x),null,x,null)},
$S:1131}
B.c6K.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.eb(w,t,A.d(E.bq(w),t,t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bla,C.a1,D.bv8,C.G,A.ns(new B.c6F(s,r),q,A.da([r.a],x),!1,A.kp(t,t,t,new A.bh(new B.c6G(),v),t,t,t,t,new A.bh(new B.c6H(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.it(C.v,C.H,t,new B.c6I(s,r),D.bs9,D.byj,r.c),A.it(C.v,C.H,t,new B.c6J(s,r),t,D.bkF,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ak,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn4(),t,t,t,t,t,F.aM,t,C.bi,t)],u))
x.push(C.B)
x.push(D.a3U)
return A.cw(!0,A.f7(A.J(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.h2,t,t,C.w),C.H,!0)},
$S:1132}
B.c6F.prototype={
$1(d){return this.a.qK(this.b.bbp(d.ga1(d)))},
$S:105}
B.c6H.prototype={
$1(d){return d.n(0,C.T)?C.ae:C.i},
$S:4}
B.c6G.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.c6I.prototype={
$1(d){return this.a.qK(this.b.baL(d))},
$S:3}
B.c6J.prototype={
$1(d){return this.a.qK(this.b.apH(d))},
$S:3}
B.b5U.prototype={
$0(){return A.ct(A.bx(this.a,0,null),C.aP,null)},
$S:0}
B.c73.prototype={
$1(d){var x,w=A.aD("https?://",!0,!1,!1)
w=A.bF(d,w,"")
x=A.aD("www\\.",!0,!1,!1)
return A.uW(A.bF(w,x,"www[.]"),A.aD("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c74(),null)},
$S:39}
B.c74.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:56}
B.bZ7.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bZ8.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bZ9.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bZa.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bZc.prototype={
$0(){var x=this.a
return x.j(new B.bZb(x))},
$S:0}
B.bZb.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c72.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:188};(function installTearOffs(){var x=a._instance_0u
x(B.ajB.prototype,"gbhf","bhg",1)
var w
x(w=B.VJ.prototype,"gbhw","Dh",0)
x(w,"gaEh","wG",0)
x(w=B.a0c.prototype,"goD","xU",1)
x(w,"gaYK","Q7",0)
x(w=B.a2I.prototype,"goD","xU",1)
x(w,"gb0w","Qx",0)
x(w,"gb50","BL",0)
x(w,"gaK6","O6",0)
x(w=B.a2H.prototype,"goD","xU",1)
x(w,"gb1q","b1r",1)
x(B.a2G.prototype,"goD","xU",1)
x(B.a2J.prototype,"gb6u","RL",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.ajB,B.VK,B.JV,B.JX,B.JW,B.lE,B.SQ,B.mW,B.Iz,B.rt,B.ajC,B.VI])
x(A.ld,[B.b5V,B.b5X,B.b61,B.b62,B.b64,B.b63,B.aX5,B.b6a,B.bKS,B.bKR,B.bKF,B.bKM,B.bKP,B.bKQ,B.bKI,B.bKH,B.bKK,B.bKG,B.bKN,B.c5J,B.c5F,B.c5E,B.c5I,B.bYu,B.bYK,B.bYO,B.bYP,B.bYQ,B.bYS,B.bYR,B.bYW,B.bYY,B.bYX,B.bYJ,B.bYL,B.bYC,B.bYB,B.bYF,B.bZ3,B.bZ5,B.bZ6,B.bYG,B.bYN,B.bYM,B.bYv,B.bYz,B.bYA,B.bYd,B.bYm,B.bYl,B.bYq,B.bYh,B.bYi,B.bYe,B.bYf,B.bYg,B.bYk,B.bYs,B.bYt,B.bY4,B.bYa,B.bY8,B.bY5,B.bY6,B.b5U,B.bZ7,B.bZ8,B.bZ9,B.bZa,B.bZc,B.bZb])
x(A.iF,[B.b5Y,B.b6_,B.b60,B.b5Z,B.aX4,B.c3h,B.b68,B.b69,B.b66,B.bKT,B.bKU,B.bKV,B.bKL,B.bKO,B.bKJ,B.c5O,B.c5N,B.c5K,B.c5M,B.c5G,B.c5H,B.bYT,B.bYV,B.bYU,B.bYZ,B.bYD,B.bYE,B.bZ4,B.bZ2,B.bZ_,B.bZ0,B.bZ1,B.bYw,B.bYy,B.bYx,B.bYn,B.bYp,B.bYo,B.bYj,B.bYr,B.bY9,B.bY7,B.c6L,B.c6F,B.c6H,B.c6G,B.c6I,B.c6J,B.c73,B.c74,B.c72])
x(A.o9,[B.b5W,B.c1a,B.b6b,B.b6c,B.c5L,B.bYI,B.bYH,B.bYb,B.bYc,B.c6K])
x(A.DU,[B.nE,B.Fm,B.Hw,B.Em])
w(B.VJ,A.i2)
x(A.K,[B.wX,B.Dj,B.Di,B.Dh,B.Dk])
x(A.M,[B.a0c,B.a2I,B.a2H,B.a2G,B.a2J])
x(A.a3,[B.Hx,B.Y0,B.DC,B.ajA])})()
A.pm(b.typeUniverse,JSON.parse('{"lE":{"bL":[]},"Dj":{"K":[],"l":[]},"Di":{"K":[],"l":[]},"Dh":{"K":[],"l":[]},"Dk":{"K":[],"l":[]},"VJ":{"aC":[]},"wX":{"K":[],"l":[]},"a0c":{"M":["wX"]},"Hx":{"a3":[],"l":[]},"Y0":{"a3":[],"l":[]},"a2I":{"M":["Dj"]},"DC":{"a3":[],"l":[]},"a2H":{"M":["Di"]},"a2G":{"M":["Dh"]},"ajA":{"a3":[],"l":[]},"a2J":{"M":["Dk"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rt"),c:x("eb<x>"),r:x("c7<x>"),k:x("H<mW>"),n:x("H<eb<x>>"),I:x("H<c7<x>>"),R:x("H<hO>"),Z:x("H<aK<o,@>>"),d:x("H<SQ>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bP"),j:x("a7<@>"),L:x("a7<x>"),P:x("aK<o,@>"),f:x("aK<@,@>"),x:x("av<o,x>"),a:x("bC"),K:x("a4"),B:x("Iz"),l:x("+(x,x)"),e:x("db<mW>"),N:x("o"),C:x("JV"),D:x("JW"),X:x("VK"),_:x("JX"),U:x("ag<o>"),G:x("nE"),q:x("pj"),b:x("bh<T?>"),y:x("O"),i:x("a2"),z:x("@"),S:x("x"),A:x("bP?"),Y:x("aK<@,@>?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("eV"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.pc=new B.Fm(0,"none")
D.pd=new B.Fm(1,"learning")
D.fj=new B.Fm(2,"memorized")
D.a7D=new A.aE(0,1/0,0,320)
D.eT=new A.T(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a7M=new A.G(D.eT,null,null,null,null,null,null,C.bZ)
D.e_=new A.T(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.at_=new A.E(C.yA,null,C.cc,null,null,null)
D.bws=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.fc,null,null,null,null,null,null,null,null)
D.bdE=new A.q(!0,C.eV,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bsW=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bdE,null,null,null,null,null,null,null,null)
D.aK2=x([D.at_,C.G,D.bws,D.bsW],y.p)
D.afX=new A.fh(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aK2,null)
D.ajt=new A.U(0,26,0,26)
D.ajw=new A.U(0,4,0,6)
D.ajV=new A.U(14,12,14,14)
D.akE=new A.U(3,0,0,0)
D.aod=new A.Q(63251,"MaterialIcons",null,!1)
D.qF=new A.Q(63677,"MaterialIcons",null,!1)
D.ap1=new A.Q(983209,"MaterialIcons",null,!1)
D.apE=new A.E(D.ap1,28,C.v,null,null,null)
D.aqj=new A.E(C.Hy,null,C.ip,null,null,null)
D.anX=new A.Q(62961,"MaterialIcons",null,!1)
D.ar2=new A.E(D.anX,null,null,null,null,null)
D.aob=new A.Q(63199,"MaterialIcons",null,!1)
D.ar3=new A.E(D.aob,null,null,null,null,null)
D.arb=new A.E(C.l7,null,C.eV,null,null,null)
D.arf=new A.E(C.nq,44,C.i,null,null,null)
D.arK=new A.E(D.qF,null,D.eT,null,null,null)
D.as1=new A.E(C.l8,null,D.eT,null,null,null)
D.asq=new A.E(D.qF,null,null,null,null,null)
D.asX=new A.E(C.hR,20,D.e_,null,null,null)
D.ati=new A.E(C.nn,30,C.v,null,null,null)
D.atK=new A.E(C.le,16,C.v,null,null,null)
D.auc=new A.E(C.Hu,null,null,null,null,null)
D.auo=new A.E(C.np,null,null,null,null,null)
D.anO=new A.Q(62842,"MaterialIcons",null,!0)
D.auB=new A.E(D.anO,null,null,null,null,null)
D.JC=x([1,3,5],y.t)
D.Kp=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aX7=new A.D(C.kV,C.mB,null)
D.aGT=x([D.aX7],y.p)
D.b0B=new A.W(C.nk,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b0o=new A.W(D.qF,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b0W=new A.W(C.dj,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.b19=new A.W(C.Hx,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aJ1=x([D.b0B,D.b0o,D.b0W,D.b19],A.ae("H<+(Q,o)>"))
D.aLo=x([D.pc,D.pd,D.fj],A.ae("H<Fm>"))
D.P3=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aSY=new B.Hw(0,"idle")
D.Vi=new B.Hw(1,"loading")
D.jU=new B.Hw(2,"ready")
D.aSZ=new B.Hw(3,"failed")
D.arI=new A.E(C.c1,18,G.cO,null,null,null)
D.bxr=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.ut,null,null,null,null,null,null,null,null)
D.aFN=x([D.arI,C.aY,D.bxr],y.p)
D.b7c=new A.er(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aFN,null)
D.aW0=new A.D(C.aJ,D.b7c,null)
D.akC=new A.U(2,6,2,4)
D.bdk=new A.q(!0,C.v,null,null,null,null,14,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bl7=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bdk,null,null,null,null,null,null,null,null)
D.aWg=new A.D(D.akC,D.bl7,null)
D.bxQ=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.fc,null,null,null,null,null,null,null,null)
D.aHc=x([N.tW,C.M,D.bxQ],y.p)
D.b76=new A.er(C.af,C.cq,C.e,C.h,null,C.l,null,0,D.aHc,null)
D.aWr=new A.D(C.kS,D.b76,null)
D.BP=new A.q(!0,D.e_,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.byb=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.BP,null,null,null,null,null,null,null,null)
D.aWw=new A.D(C.dz,D.byb,null)
D.bxm=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aM,C.Z,null,null,null,null,null,null,null)
D.aWG=new A.D(C.C,D.bxm,null)
D.akz=new A.U(2,0,2,8)
D.btd=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aM,null,null,null,null,null,null,null,null)
D.aWY=new A.D(D.akz,D.btd,null)
D.atU=new A.E(C.lc,30,C.v,null,null,null)
D.byT=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.BQ,null,null,null,null,null,null,null,null)
D.alK=new A.bZ(1,C.ah,D.byT,null)
D.aHr=x([D.atU,C.Y,D.alK],y.p)
D.b6T=new A.er(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aHr,null)
D.atu=new A.E(C.dj,18,G.cO,null,null,null)
D.a2_=new A.q(!0,G.cO,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bx3=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a2_,null,null,null,null,null,null,null,null)
D.aGd=x([D.atu,C.bL,D.bx3],y.p)
D.b74=new A.er(C.af,C.d,C.L,C.h,null,C.l,null,0,D.aGd,null)
D.b9q=new A.V(0,30)
D.tT=new A.V(1/0,54)
D.b9O=new A.V(1/0,48)
D.b9R=new A.V(1/0,50)
D.b9U=new A.V(1/0,52)
D.buR=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.baU=new A.d_(D.buR,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.bcM=new A.q(!0,C.i,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bda=new A.q(!0,C.an,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.BA=new A.q(!0,D.eT,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.kg=new A.q(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a2b=new A.q(!0,D.eT,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgU=new A.q(!0,C.v,null,null,null,null,24,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhY=new A.q(!0,D.e_,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhZ=new A.q(!0,G.cO,null,null,null,null,null,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bif=new A.q(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjW=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.ia,null,null,null,null,null,null,null,null)
D.bkF=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.cV,null,null,null,null,null,null,null,null)
D.bla=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oA,null,null,null,null,null,null,null,null)
D.ble=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aM,null,null,null,null,null,null,null,null)
D.bew=new A.q(!0,G.cO,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.blw=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bew,null,null,null,null,null,null,null,null)
D.blC=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aM,null,null,null,null,null,null,null,null)
D.bm3=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.fc,null,null,null,null,null,null,null,null)
D.bnS=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cm,null,null,null,null,null,null,null,null)
D.boC=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bC,null,null,null,null,null,null,null,null)
D.boH=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aM,null,null,null,null,null,null,null,null)
D.bp8=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.BU,null,null,null,null,null,null,null,null)
D.bqp=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bqX=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oE,null,null,null,null,null,null,null,null)
D.brK=new A.m("reset safe mode / WebGPU ban",null,O.a1w,null,null,null,null,null,null,null,null)
D.brZ=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.BP,null,null,null,null,null,null,null,null)
D.bs9=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aM,null,null,null,null,null,null,null,null)
D.bsB=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bw,null,null,null,null,null,null,null,null)
D.bsU=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aM,null,null,null,null,null,null,null,null)
D.bte=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aM,null,null,null,null,null,null,null,null)
D.buD=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a2A,null,null,null,null,null,null,null,null)
D.bg7=new A.q(!0,D.eT,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.buH=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bg7,null,null,null,null,null,null,null,null)
D.bv8=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oE,null,null,null,null,null,null,null,null)
D.bvI=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a1r,null,null,null,null,null,null,null,null)
D.bvX=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cm,null,null,null,null,null,null,null,null)
D.bwj=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bwC=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bxe=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aM,null,null,null,null,null,null,null,null)
D.bxf=new A.m("\u062e\u0644\u0635\u062a",null,C.m6,null,null,null,null,null,null,null,null)
D.bxg=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.BP,null,null,null,null,null,null,null,null)
D.bhc=new A.q(!0,C.cH,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.fM,null,null,null,null,null,null,null,null)
D.by1=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bhc,null,null,null,null,null,null,null,null)
D.byf=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bw,null,null,null,null,null,null,null,null)
D.byj=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.cV,null,null,null,null,null,null,null,null)
D.byS=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aM,null,null,null,null,null,null,null,null)
D.a3U=new B.ajA(null)
D.bAd=new B.Dh(null)
D.bAe=new B.VI(2,1,!0,!1,!1)
D.a3Y=new B.VK(!1,!1,!1,!1,!1,0)
D.j5=new B.nE(0,"ok")
D.uO=new B.nE(1,"near")
D.uP=new B.nE(2,"wrong")
D.uQ=new B.nE(3,"missing")
D.a4o=new B.nE(4,"extra")
D.aos=new A.Q(63456,"MaterialIcons",null,!1)
D.bG5=new B.DC(D.e_,D.aos,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bGJ=new B.Y0(!1,null)
D.Cr=new B.Y0(!0,null)
D.mo=new B.Em(0,"idle")
D.v3=new B.Em(1,"playing")
D.v4=new B.Em(2,"recording")
D.p3=new B.Em(3,"thinking")
D.jc=new B.Em(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cPj","ccI",()=>new B.ajB())
x($,"cSL","csm",()=>A.aD("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cSM","csn",()=>A.aD("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cSY","csw",()=>A.aD("\u0648\u0670",!0,!1,!1))
x($,"cSj","cs2",()=>A.aD("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cQB","cqS",()=>A.aD("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cRQ","crF",()=>A.aD("[\u0654\u0655]",!0,!1,!1))
x($,"cQC","cqT",()=>A.aD("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cQJ","cqZ",()=>A.aD("[\u0624\u0626]",!0,!1,!1))
x($,"cRS","crH",()=>A.aD("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cSo","cs5",()=>A.aD("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cS_","crO",()=>A.aD("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cSJ","cdj",()=>A.aD("\\s+",!0,!1,!1))
x($,"cMD","ri",()=>B.ctl(D.pc,0,A.c8j(0,!0)))
x($,"cPk","MZ",()=>new B.VJ($.ccI(),D.bAe,B.cBx(),D.aSY,$.X()))})()};
(a=>{a["L883FxfwzxvgLNFjDq2Xhbq2o2o="]=a.current})($__dart_deferred_initializers__);