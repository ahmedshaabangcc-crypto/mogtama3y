((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,Q,H,G,N,R,K,B={
cBE(d){var x,w,v,u,t,s
if(d instanceof B.lE)return d
try{x=A.cS(d)
w=x.code
v=x.message
u=w==null?"failed":A.S(w)
t=v==null?"":A.S(v)
return new B.lE(u,t)}catch(s){u=A.n(d)
return new B.lE("failed",u)}},
ajE:function ajE(){this.b=this.a=null},
b5Z:function b5Z(d){this.a=d},
b61:function b61(){},
b60:function b60(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b6_:function b6_(d){this.a=d},
b65:function b65(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b63:function b63(d){this.a=d},
b64:function b64(d){this.a=d},
b66:function b66(d){this.a=d},
b68:function b68(d,e,f){this.a=d
this.b=e
this.c=f},
b67:function b67(d,e,f){this.a=d
this.b=e
this.c=f},
b62:function b62(){},
cBF(d,e){return new B.lE(d,e)},
VL:function VL(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
JW:function JW(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
JY:function JY(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
JX:function JX(d,e){this.a=d
this.b=e},
lE:function lE(d,e){this.a=d
this.b=e},
cnM(d){var x,w=$.csu()
w=A.bF(d,w,"\u0627")
x=$.csv()
w=A.bF(w,x,"\u064a")
x=$.csE()
w=A.bF(w,x,"\u0627")
x=$.cr_()
w=A.bF(w,x,"\u0627")
x=$.csa()
w=A.bF(w,x,"\u0621")
x=$.crN()
w=A.bF(w,x,"\u0621")
x=$.cr0()
w=A.bF(w,x,"\u0627")
x=$.cr6()
w=A.bF(w,x,"\u0621")
w=A.bF(w,"\u0649","\u064a")
w=A.bF(w,"\u0629","\u0647")
x=$.crP()
w=A.bF(w,x,"")
x=$.csd()
w=A.bF(w,x," ")
x=$.crW()
w=A.bF(w,x," ")
x=$.cdq()
return C.c.N(A.bF(w,x," "))},
cGm(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
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
c7h(d,e){var x,w,v,u,t,s
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
s=1-B.cGm(d,e)/u
return s>=1?0.99:s},
F4(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.u1(d,$.cdq()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.cnM(u)
s=A.bF(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.SR(r.a+" "+u,r.b))}continue}q.push(new B.SR(u,s))}return q},
cF1(d,e){var x,w,v,u,t=new B.c1h(),s=A.a([],y.s)
for(x=A.fw(e,0,A.ii(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.cb(x,x.gM(0),w.i("cb<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.Kp)&&t.$2(d,D.Kp)?C.b.jz(d,5):d
return!t.$2(s,D.P3)&&t.$2(u,D.P3)?C.b.jz(u,4):u},
cmI(d,e){var x=B.F4(d),w=B.cnM(e),v=y.U
v=A.a9(new A.ag(A.a(w.split(" "),y.s),new B.c3o(),v),v.i("Z.E"))
return new B.Iz(x,B.cEc(x,B.cF1(v,x)),w)},
cEc(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.co(x,0,!1,s)
q=A.co(x,0,!1,y.S)
p=A.co(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c7h(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c7h(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c7h(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
else m=a2>=0.6?D.uP:D.uQ
a1.push(new B.mW(o,x,s,m))
break
case 1:--o
a1.push(new B.mW(o,a4[o],null,D.uR))
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
SR:function SR(d,e){this.a=d
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
aX9:function aX9(d){this.a=d},
aX8:function aX8(){},
c1h:function c1h(){},
c3o:function c3o(){},
ctu(d,e,f){return new B.rt(d,e,f)},
cHh(d){var x
A:{if("memorized"===d){x=D.fk
break A}if("learning"===d){x=D.pe
break A}x=D.pd
break A}return x},
coM(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cR[d-1].a[1]},
cBG(){var x=y.S
return new B.ajF(A.B(x,y.u),A.aS(x))},
b6b(d){var x=d.ff()
return C.c.dq(C.j.k(A.br(x)),4,"0")+"-"+C.c.dq(C.j.k(A.bt(x)),2,"0")+"-"+C.c.dq(C.j.k(A.bW(x)),2,"0")},
cjD(d){var x=y.x,w=A.a9(new A.av(A.a(d.split("-"),y.s),A.cIH(),x),x.i("aW.E"))
return B.b6b(A.dv(w[0],w[1],w[2]-1,12,0,0,0))},
caq(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.B(p,y.u),n=A.aS(p),m=new B.ajF(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcN(),x=x.ga0(x),w=y.j;x.v();){v=x.gG()
u=A.dU(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aR(t)>=3){v=C.j.aH(u,1000)
s=C.j.a3(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cR[v-1].a[1])}if(v)continue
v=J.bd(t)
r=C.f.bA(A.cN(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rt(D.aLq[r],C.f.bA(A.cN(v.h(t,1))),new A.aQ(A.ks(C.f.bA(A.cN(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aAZ(q,y.o)
p=A.mr(x,new B.b6a(),x.$ti.i("Z.E"),p)
n.A(0,new A.ag(p,o.ga47(),A.y(p).i("ag<Z.E>")))}m.c=A.t(d.h(0,"last"))
p=A.aw(d.h(0,"streak"))
p=p==null?null:C.f.bA(p)
p=m.d=p==null?0:p
o=A.aw(d.h(0,"best"))
o=o==null?null:C.f.bA(o)
m.e=o==null?p:o
return m},
aAf(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dq(C.j.k(d),3,"0")+C.c.dq(C.j.k(e),3,"0")+".mp3"},
Fm:function Fm(d,e){this.a=d
this.b=e},
rt:function rt(d,e,f){this.a=d
this.b=e
this.c=f},
ajF:function ajF(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b6c:function b6c(){},
b6d:function b6d(){},
b6a:function b6a(){},
VJ:function VJ(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cz8(){return new B.wY(null)},
cL7(d,e){var x,w,v,u,t={},s=I.cR[e-1].a[1],r=$.N_().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.ri():v).a===D.fk}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.cZ(u+4,1,s)
return A.e_(C.cN,new B.c5V(t,s,e),d,!0,null,null,!1,y.l)},
ccc(d){return A.dr(0,0,0,0,0,C.j.cZ(C.f.aj(6+d*1.2),25,90))},
cb7(d){return E.bq(C.j.aH(d,60))+":"+C.c.dq(E.bq(C.j.a3(d,60)),2,"\u0660")},
coy(d){return A.e_(C.cN,new B.c6S($.N_()),d,!0,null,null,!1,y.H)},
MT(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl3()
break A}return x},
cMt(d,e,f){var x,w=new B.c7a(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
coH(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.am.f0(a4,null))
s=y.Y
r=s.a(J.as(x,"rec"))
w=r==null?C.e2:r
q=s.a(J.as(x,"last"))
v=q==null?C.e2:q
u=new B.c79()
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
a0=J.aR(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.f(J.as(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.f(J.as(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
Hw:function Hw(d,e){this.a=d
this.b=e},
VK:function VK(d,e,f,g,h){var _=this
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
b6e:function b6e(d){this.a=d},
b6f:function b6f(d){this.a=d},
b6g:function b6g(d){this.a=d},
wY:function wY(d){this.a=d},
a0d:function a0d(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bKX:function bKX(d){this.a=d},
bKW:function bKW(d,e){this.a=d
this.b=e},
bKY:function bKY(d){this.a=d},
bKV:function bKV(d,e){this.a=d
this.b=e},
bKZ:function bKZ(){},
bKJ:function bKJ(){},
bKP:function bKP(d,e,f){this.a=d
this.b=e
this.c=f},
bKQ:function bKQ(){},
bKT:function bKT(d){this.a=d},
bKS:function bKS(){},
bKU:function bKU(d){this.a=d},
bKM:function bKM(d,e){this.a=d
this.b=e},
bKN:function bKN(d){this.a=d},
bKL:function bKL(){},
bKO:function bKO(d){this.a=d},
bKK:function bKK(d){this.a=d},
bKR:function bKR(d,e){this.a=d
this.b=e},
Hx:function Hx(d,e,f){this.c=d
this.d=e
this.a=f},
Y1:function Y1(d,e){this.c=d
this.a=e},
c5V:function c5V(d,e,f){this.a=d
this.b=e
this.c=f},
c5S:function c5S(d,e,f){this.a=d
this.b=e
this.c=f},
c5U:function c5U(d,e){this.a=d
this.b=e},
c5R:function c5R(d,e){this.a=d
this.b=e},
c5Q:function c5Q(d,e){this.a=d
this.b=e},
c5T:function c5T(d,e){this.a=d
this.b=e},
c5M:function c5M(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c5L:function c5L(d,e,f){this.a=d
this.b=e
this.c=f},
c5N:function c5N(d){this.a=d},
c5O:function c5O(d){this.a=d},
c5P:function c5P(d,e){this.a=d
this.b=e},
Em:function Em(d,e){this.a=d
this.b=e},
Dj:function Dj(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2J:function a2J(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bYB:function bYB(){},
bYR:function bYR(d,e){this.a=d
this.b=e},
bYV:function bYV(d){this.a=d},
bYW:function bYW(d){this.a=d},
bYX:function bYX(d,e,f){this.a=d
this.b=e
this.c=f},
bYZ:function bYZ(d){this.a=d},
bZ_:function bZ_(d){this.a=d},
bYY:function bYY(){},
bZ1:function bZ1(d){this.a=d},
bZ0:function bZ0(d){this.a=d},
bZ2:function bZ2(d,e){this.a=d
this.b=e},
bZ4:function bZ4(d){this.a=d},
bZ5:function bZ5(d){this.a=d},
bZ3:function bZ3(){},
bYQ:function bYQ(d,e,f){this.a=d
this.b=e
this.c=f},
bYS:function bYS(d,e,f){this.a=d
this.b=e
this.c=f},
bYJ:function bYJ(d){this.a=d},
bYK:function bYK(d){this.a=d},
bYI:function bYI(){},
bYL:function bYL(){},
bYM:function bYM(d,e){this.a=d
this.b=e},
bZa:function bZa(d){this.a=d},
bZb:function bZb(d){this.a=d},
bZc:function bZc(d,e){this.a=d
this.b=e},
bZ9:function bZ9(d){this.a=d},
bZd:function bZd(d,e){this.a=d
this.b=e},
bYP:function bYP(){},
bYO:function bYO(d){this.a=d},
bYN:function bYN(d,e){this.a=d
this.b=e},
bYU:function bYU(d){this.a=d},
bYT:function bYT(d){this.a=d},
bZ6:function bZ6(){},
bZ7:function bZ7(){},
bZ8:function bZ8(){},
bYC:function bYC(d,e,f){this.a=d
this.b=e
this.c=f},
bYD:function bYD(d){this.a=d},
bYF:function bYF(){},
bYE:function bYE(){},
bYG:function bYG(d){this.a=d},
bYH:function bYH(d){this.a=d},
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
a2I:function a2I(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bYk:function bYk(){},
bYt:function bYt(d,e){this.a=d
this.b=e},
bYu:function bYu(d){this.a=d},
bYs:function bYs(){},
bYw:function bYw(d){this.a=d},
bYv:function bYv(d,e){this.a=d
this.b=e},
bYx:function bYx(d,e){this.a=d
this.b=e},
bYo:function bYo(d,e){this.a=d
this.b=e},
bYp:function bYp(d,e,f){this.a=d
this.b=e
this.c=f},
bYq:function bYq(d,e,f){this.a=d
this.b=e
this.c=f},
bYl:function bYl(d,e,f){this.a=d
this.b=e
this.c=f},
bYm:function bYm(d,e,f){this.a=d
this.b=e
this.c=f},
bYn:function bYn(d,e){this.a=d
this.b=e},
bYr:function bYr(d){this.a=d},
bYy:function bYy(){},
bYz:function bYz(d,e){this.a=d
this.b=e},
bYA:function bYA(d,e){this.a=d
this.b=e},
Dh:function Dh(d){this.a=d},
a2H:function a2H(d){this.d=d
this.c=this.a=null},
bYb:function bYb(){},
bYi:function bYi(d){this.a=d},
bYj:function bYj(){},
bYh:function bYh(d,e){this.a=d
this.b=e},
bYg:function bYg(d,e,f){this.a=d
this.b=e
this.c=f},
bYf:function bYf(d,e,f){this.a=d
this.b=e
this.c=f},
bYe:function bYe(d){this.a=d},
bYc:function bYc(d){this.a=d},
bYd:function bYd(d){this.a=d},
c6S:function c6S(d){this.a=d},
c6R:function c6R(d){this.a=d},
c6M:function c6M(d,e){this.a=d
this.b=e},
c6O:function c6O(){},
c6N:function c6N(){},
c6P:function c6P(d,e){this.a=d
this.b=e},
c6Q:function c6Q(d,e){this.a=d
this.b=e},
ajD:function ajD(d){this.a=d},
b5Y:function b5Y(d){this.a=d},
c7a:function c7a(){},
c7b:function c7b(){},
Dk:function Dk(d,e,f){this.c=d
this.d=e
this.a=f},
a2K:function a2K(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bZe:function bZe(d){this.a=d},
bZf:function bZf(d){this.a=d},
bZg:function bZg(d,e){this.a=d
this.b=e},
bZh:function bZh(d){this.a=d},
bZj:function bZj(d){this.a=d},
bZi:function bZi(d){this.a=d},
c79:function c79(){}},D,O,P,I,E,F
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
B.ajE.prototype={
ra(){var x=this,w=x.a
if(w!=null)return A.em(w,y.m)
w=x.b
return w==null?x.b=new B.b5Z(x).$0():w},
uu(d,e){return this.aNX(d,e,e)},
aNX(d,e,f){var x=0,w=A.k(f),v,u=2,t=[],s,r,q,p
var $async$uu=A.e(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$uu)
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
r=B.cBE(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$uu,w)},
or(d,e){var x=A.ei(d[e])
if(x==null)x=null
return x===!0},
N1(){var x=0,w=A.k(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$N1=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.ra(),$async$N1)
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
if(k!=null)C.f.aj(k)
v=new B.VL(q,p,o,n,m,l)
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
return A.j($async$N1,w)},
Ey(){var x=0,w=A.k(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Ey=A.e(function(d,e){if(d===1){t.push(e)
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
break}q=C.f.aj(A.dQ(r.quota))
p=C.f.aj(A.dQ(r.usage))
v=new A.atK(q,p)
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
bke(){var x=y.K
A.PR(this.ra().bH(new B.b61(),x),x)},
r9(d,e){var x=A.jQ(d[e])
x=x==null?null:C.f.aj(x)
return x==null?0:x},
bhA(d,e,f){return this.uu(new B.b60(this,d,e,f),y.C)},
gakZ(){var x,w
try{x=A.kj(b.G.sessionStorage)
return x}catch(w){return null}},
gasw(){var x=A.ei(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a9o(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.ei(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gasw())return!1
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
if(!l.b.test(w))i=J.f(u,"MacIntel")&&v>1
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
l=this.gakZ()
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
ar1(){var x,w,v,u,t,s,r=null
try{x=this.gakZ()
if(x!=null)A.cM(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cS(x.location)
u=A.S(v.hash)
t=A.S(v.search)
s=A.bx(A.S(A.cS(x.document).baseURI),0,r).a2("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cM(v,"replace",s+t+x,r,r,r)},
bhj(){var x,w=null,v=b.G,u=A.cS(v.history),t=A.jQ(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cM(u,"back",w,w,w,w)
else{x=A.S(A.cS(v.document).baseURI)
A.cM(A.cS(v.location),"replace",A.bx(x,0,w).a2("./").k(0)+"#/",w,w,w)}},
a9A(d,e,f,g,h){return this.uu(new B.b65(this,e,d,f,h,g),y.H)},
a9E(){return this.uu(new B.b66(this),y.D)},
a3L(){var x=null,w=this.a
if(w!=null)A.cM(w,"cancelRecording",x,x,x,x)},
amo(d){var x,w,v=this,u=A.t(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.r9(d,"ms")
w=A.jQ(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.JY(u,x,w,v.r9(d,"frames"),v.r9(d,"tokens"),v.or(d,"retried"),v.r9(d,"encMs"),v.r9(d,"decMs"),v.r9(d,"featMs"))},
aiN(d){var x={}
x.words=d
return x},
avB(d,e){return this.uu(new B.b68(this,d,e),y._)},
bmr(d,e){return this.uu(new B.b67(this,d,e),y._)},
L3(d,e){return this.bkk(d,e)},
bkk(d,e){var x=0,w=A.k(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$L3=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.ra(),$async$L3)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.al(d).i("av<1,o>")
o=A.a9(new A.av(d,new B.b62(),o),o.i("aW.E"))
x=11
return A.c(A.eF(A.cS(A.cM(r,"play",o,e,null,null)),y.y),$async$L3)
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
return A.j($async$L3,w)},
MJ(){var x=null,w=this.a
if(w!=null)A.cM(w,"stopPlayback",x,x,x,x)},
Jw(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.S(A.cM(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
blA(){var x,w,v=null
try{x=this.a
if(x!=null)A.cM(x,"resetDevice",v,v,v,v)}catch(w){}},
a72(d){var x=this.a
if(x!=null)A.cM(x,"prefetch",d,null,null,null)}}
B.VL.prototype={}
B.JW.prototype={
gn4(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.JY.prototype={
gT9(){var x=this,w=C.f.az(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.JX.prototype={}
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
$ibH:1}
B.nE.prototype={
R(){return"WordStatus."+this.b}}
B.SR.prototype={}
B.mW.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Iz.prototype={
gMH(){var x,w=this,v=w.d
if(v===$){x=new B.aX9(w).$0()
w.d!==$&&A.aq()
w.d=x
v=x}return v},
gJP(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a4o&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbis(){return J.h7(this.gMH(),new B.aX8()).gM(0)},
gtv(){var x=this.a
return x.length!==0&&this.gbis()===x.length&&this.gJP().length===0}}
B.Fm.prototype={
R(){return"AyahStatus."+this.b}}
B.rt.prototype={}
B.ajF.prototype={
a6E(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.ri():x},
b_J(d){var x=this,w=B.b6b(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cjD(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
aqd(){var x=Date.now(),w=B.b6b(new A.aQ(x,0,!1))
x=this.c
return x===w||x===B.cjD(w)?this.d:0},
auC(d,e,f,g){var x=this,w=new A.aQ(Date.now(),0,!1),v=x.a6E(d,e),u=g?C.j.cZ(v.b+1,0,100):0,t=g&&u>=f?D.fk:D.pe,s=new B.rt(t,u,w.h5()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.b_J(w)
return s},
a6w(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cR[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.ri():s).a===D.fk)++u}return u},
bhh(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cR[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.ri():s).a===D.pe)++u}return u},
gatD(){var x=this.a,w=A.y(x).i("c5<2>")
return new A.ag(new A.c5(x,w),new B.b6c(),w.i("ag<Z.E>")).gM(0)},
gazg(){var x=this.a,w=A.y(x).i("bL<1>")
w=A.mr(new A.bL(x,w),new B.b6d(),w.i("Z.E"),y.S)
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
bdc(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b4y(x,300,A.y(x).c),x=new A.JD(J.ax(x.a),x.b,A.y(x).i("JD<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gG()
s=C.j.aH(t,1000)
t=C.j.a3(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.ri():q).a===D.fk?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.ri()
r=u.h(0,r)
o.push(A.I(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.ri():r).c.iC()],w,v))}return o},
bhS(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.L)(d),++u){t=d[u]
s=A.ey(t.h(0,"surah"))*1000+A.ey(t.h(0,"ayah"))
r=w.h(0,C.j.aH(s,1000)*1000+C.j.a3(s,1000))
if((r==null?$.ri():r).c.iC()===t.h(0,"updated_at"))v.K(0,s)}},
bi_(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.ax(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gG()
if(!u.b(s))continue
r=A.aw(s.h(0,"surah"))
q=r==null?null:C.f.bA(r)
r=A.aw(s.h(0,"ayah"))
p=r==null?null:C.f.bA(r)
o=A.dO(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cR[q-1].a[1])
if(r)continue
n=B.cHh(s.h(0,"status"))
if(n===D.pd)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.aw(s.h(0,"perfect_count"))
l=l==null?null:C.f.bA(l)
v.p(0,r,new B.rt(n,C.j.cZ(l==null?0:l,0,100),o.h5()))
w.K(0,r)
t=!0}return t}}
B.VJ.prototype={
Jf(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.VJ(w,v,u,t,f==null?x.e:f)},
bbr(d){var x=null
return this.Jf(x,x,d,x,x)},
apJ(d){var x=null
return this.Jf(x,d,x,x,x)},
bbv(d){var x=null
return this.Jf(x,x,x,x,d)},
baO(d){var x=null
return this.Jf(d,x,x,x,x)},
bbs(d){var x=null
return this.Jf(x,x,x,d,x)},
dr(){var x=this
return A.I(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Hw.prototype={
R(){return"ModelState."+this.b}}
B.VK.prototype={
vJ(){var x=this.Q
return x==null?this.Q=new B.b6e(this).$0():x},
qK(d){return this.axu(d)},
axu(d){var x=0,w=A.k(y.H),v=this
var $async$qK=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:v.b=d
v.a5()
x=2
return A.c(A.ij("mt.tutor.settings",C.am.hk(d.dr(),null)),$async$qK)
case 2:return A.i(null,w)}})
return A.j($async$qK,w)},
zU(){var x=0,w=A.k(y.H),v=this,u
var $async$zU=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:v.a5()
x=2
return A.c(A.ij("mt.tutor.progress",C.am.hk(v.c.dr(),null)),$async$zU)
case 2:u=v.as
if(u!=null)u.aB()
v.as=A.cR(C.x,v.gaEj())
return A.i(null,w)}})
return A.j($async$zU,w)},
Mr(d,e,f){return this.ayg(d,e,f)},
ayg(d,e,f){var x=0,w=A.k(y.H),v=this
var $async$Mr=A.e(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:v.z=new A.aX(d,e,f)
x=2
return A.c(A.ij("mt.tutor.last",C.am.hk(A.I(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Mr)
case 2:return A.i(null,w)}})
return A.j($async$Mr,w)},
Dh(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Dh=A.e(function(d,e){if(d===1){t.push(e)
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
return A.c(s.a.bhA(new B.b6f(s),n,p),$async$Dh)
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
s.f=D.aT0
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
var $async$wG=A.e(function(a0,a1){if(a0===1){t.push(a1)
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
return A.c(p.aR("quran_tutor_progress").d5("surah, ayah, status, perfect_count, updated_at"),$async$wG)
case 7:o=a1
n=r.c.bi_(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bdc()
if(J.aR(l)===0){x=10
break}h=p
g=A.I(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.n3(h.x,k,k))
x=11
return A.c(f.blZ("quran_tutor_save",!1,g,i),$async$wG)
case 11:r.c.bhS(l)
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
Lk(d){return this.blC(d)},
blC(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Lk=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.caq(t.c.dr()).dr()
y.f.a(p.h(0,"rows")).ek(0,new B.b6g(d))
t.c=B.caq(p)
x=2
return A.c(t.zU(),$async$Lk)
case 2:v=4
s=$.C().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.ar("quran_tutor_reset",A.I(["p_surah",d],y.N,r),r),$async$Lk)
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
return A.j($async$Lk,w)}}
B.wY.prototype={
P(){var x=$.N_()
return new B.a0d(x,new A.ah(C.K,$.X()))}}
B.a0d.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.aa(v.goD())
w=y.a
x.vJ().bH(new B.bKX(v),w)
H.aVC().bH(new B.bKY(v),w).fw(new B.bKZ())
A.PR(H.c9M(),y.y)},
xU(){if(this.c!=null)this.j(new B.bKJ())},
m(){var x,w=this
w.d.T(w.goD())
x=w.e
x.q$=$.X()
x.L$=0
w.a_()},
Q9(){var x=0,w=A.k(y.H),v,u=this,t,s
var $async$Q9=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qK(s.b.bbr(!0)),$async$Q9)
case 3:t=s.a
t.bke()
if(t.a9o()){t.ar1()
x=1
break}s.Dh()
case 1:return A.i(v,w)}})
return A.j($async$Q9,w)},
xV(d,e,f){return this.aYu(d,e,f)},
b6v(d){return this.xV(d,null,null)},
aYu(d,e,f){var x=0,w=A.k(y.H),v,u=this,t,s,r
var $async$xV=A.e(function(g,h){if(g===1)return A.h(h,w)
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
return A.c(B.cL7(s,d),$async$xV)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Mr(d,t.a,t.b),$async$xV)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.N(s,!1).aA(A.ay(new B.bKP(u,d,t),null,r),r),$async$xV)
case 8:if(u.c!=null)u.j(new B.bKQ())
case 1:return A.i(v,w)}})
return A.j($async$xV,w)},
u(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gasw()&&!A.N(d,!1).vd())u.push(A.bQ(x,x,x,x,C.yJ,x,x,t.gbhi(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bQ(x,x,x,x,D.aud,x,x,new B.bKT(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bQ(x,x,x,x,C.iy,x,x,new B.bKU(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aGV
else w=t?this.aTk():this.aTW()
return L.xI(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aTW(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a3Y
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b6W,C.a1],x)
for(t=0;t<4;++t){s=D.aJ3[t]
u.push(new A.D(C.br,A.A(A.a([A.b_(s.a,C.an,p,18),C.N,new A.bZ(1,C.ah,A.d(s.b,p,p,p,p,p,G.a1u,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.J(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.byo,C.G,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bq(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,p,F.aM,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bq(C.f.aj(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.G,A.d(q,p,p,p,p,p,A.bB(p,p,r?D.e_:C.cH,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.G,D.bxp],x))
x=A.a([new E.dD(u,C.a4,C.aJ,p,!0,p),new E.dD(A.J(s,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,p,!1,p),D.bGU,C.G],x)
if(v!=null)x.push(new E.dD(A.d(v,p,p,p,p,p,D.bi3,p,p,p),C.a4,C.aJ,p,!1,p))
else x.push(A.fp(D.ar4,D.bnZ,this.gaYM(),A.ev(C.v,C.af,D.b9Y,p,p,p,p)))
x.push(C.a5)
x.push(D.a3U)
return x},
aTk(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.N(r.a.a),p=q.length===0,o=p?C.rx:H.cor(q),n=t.z,m=A.R(v.alG(C.dj,E.bq(s.gatD())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bq(s.aqd()),k=s.c,j=Date.now()
k=k===B.b6b(new A.aQ(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Hx(t,!1,u),A.A(A.a([m,C.N,A.R(v.alG(C.lc,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.u],j)
if(n!=null){t=H.kl(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bq(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bq(m)+"\u2013"+E.bq(l)
k.push(new E.dD(A.A(A.a([D.atj,C.Z,A.R(A.J(A.a([D.bk1,A.d(t+" \u2014 "+m,u,u,u,u,u,C.bw,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nA],j),C.h,C.d,C.e,0,u,u),C.a4,C.aJ,new B.bKM(v,n),!0,u))}t=C.i.ad(0.08)
k.push(A.aH(u,C.y,!1,u,!0,C.m,u,A.aI(),r,u,u,u,u,u,2,A.cH(u,new A.ck(4,A.v(14),C.M),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.ul,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qT,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bKN(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.cV,!0,C.t,u,C.E,u,u,u,u))
k.push(C.u)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.btl)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.Ru(o[x]))
C.b.A(k,t)}else{t=A.a([D.aWi,D.aX0,v.Ru(1)],j)
for(w=114;w>=78;--w)t.push(v.Ru(w))
t.push(C.G)
r=v.f
p=A.b_(r?C.yo:C.la,C.an,u,u)
t.push(A.ff(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,u,C.fd,u,u,u),new B.bKO(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Ru(w))
C.b.A(k,t)}k.push(C.a1)
k.push(D.Cs)
return k},
alG(d,e,f){var x=null,w=y.p
return new E.dD(A.A(A.a([A.b_(d,C.v,x,x),C.N,A.R(A.J(A.a([A.d(e,x,x,x,x,x,C.bw,x,x,x),A.d(f,x,1,C.O,x,x,C.a29,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a4,C.H,x,!1,x)},
Ru(d){var x,w=null,v=this.d.c,u=I.cR[d-1].a[1],t=v.a6w(d),s=t/u,r=y.p,q=A.an(A.dC(C.P,A.a([A.c8b(C.eU,G.cO,w,w,w,w,w,3,s,w),A.d(E.bq(d),w,w,w,w,w,Q.a2v,w,w,w)],r),C.m,C.bk,w),36,36),p=A.d(H.kl(d),w,w,w,w,w,D.bcR,w,w,w)
if(t===0)x=E.bq(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bq(t)+" \u0645\u0646 "+E.bq(u)
r=A.a([q,C.cG,A.R(A.J(A.a([p,A.d(x,w,w,w,w,w,A.bB(w,w,t===u?G.cO:C.cH,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bq(C.f.aj(s*100))+"\u066a",w,w,w,w,w,D.a2_,w,w,w))
r.push(D.arc)
return new E.dD(A.A(r,C.h,C.d,C.e,0,w,w),C.qa,C.d1,new B.bKR(this,d),!1,w)}}
B.Hx.prototype={
u(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aW2
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.MT(x),r,r,r,r,r,D.BB,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.Dk(w,"model load",r))
x.push(C.G)
x.push(new A.zZ(C.a4J,!1,q.gbhz(),r,r,r,r,C.k,r,!1,r,!0,r,C.oO,r))
return new E.dD(A.J(x,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.cZ(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bq(C.f.aj(u/1e6))+" \u0645\u0646 "+E.bq(C.f.aj(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,r,C.oG,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fb(x,A.qa(C.eU,C.v,7,s?t:r,r),C.aA)],w)
if(!this.d)C.b.A(x,A.a([C.G,D.boO],w))
return new E.dD(A.J(x,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)}}}
B.Y1.prototype={
u(d){var x=null,w=D.e_.ad(0.1),v=A.v(14),u=A.aJ(D.e_.ad(0.4),1)
return A.F(x,A.A(A.a([D.asY,C.N,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,x,C.BI,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.G(w,x,u,v,x,x,x,C.n),x,x,x,C.aJ,C.ac,x,x,x)}}
B.Em.prototype={
R(){return"_Phase."+this.b}}
B.Dj.prototype={
P(){return new B.a2J($.N_(),D.mp)}}
B.a2J.prototype={
gje(){var x=this.e
return x===$?this.e=this.a.d:x},
gBR(){var x,w=this.a,v=w.f
w=w.c
x=this.gje()
return H.MR(w,x,v.y6(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.aa(w.goD())
x.vJ()
x.a.a72(B.aAf(w.a.c,w.gje()))},
xU(){if(this.c!=null)this.j(new B.bYB())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.Q
if(x!=null)x.aB()
v=v.a
v.MJ()
v.a3L()
w.a_()},
a_l(d){var x,w,v=this
if(v.f===D.v5)v.d.a.a3L()
x=v.d.a
x.MJ()
w=v.Q
if(w!=null)w.aB()
v.j(new B.bYR(v,d))
x.a72(B.aAf(v.a.c,d))
w=v.a
if(d<w.e)x.a72(B.aAf(w.c,d+1))},
RM(d){return this.aUN(d)},
aUN(d){var x=0,w=A.k(y.H),v,u=this,t,s,r,q,p
var $async$RM=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:if(u.f===D.v4){u.d.a.MJ()
u.j(new B.bYV(u))
x=1
break}t=u.r!=null?D.jc:D.mp
u.j(new B.bYW(u))
s=u.d
r=A.a([B.aAf(u.a.c,u.gje())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.L3(r,q),$async$RM)
case 3:p=f
if(u.c==null||u.f!==D.v4){x=1
break}u.j(new B.bYX(u,t,p))
case 1:return A.i(v,w)}})
return A.j($async$RM,w)},
Qz(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Qz=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jU){x=1
break}p=l.a
p.MJ()
r=B.F4(s.gBR()).length
s.j(new B.bYZ(s))
o=s.Q
if(o!=null)o.aB()
s.Q=A.hD(C.eY,new B.bZ_(s))
u=4
o=B.ccc(r)
n=A.dr(0,0,0,350*r,0,0)
x=7
return A.c(p.a9A(l.b.c,o,n,new B.bZ0(s),new B.bZ1(s)),$async$Qz)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lE){q=l
l=s.Q
if(l!=null)l.aB()
if(s.c!=null)s.j(new B.bZ2(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Qz,w)},
BL(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$BL=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.v5){x=1
break}m=s.Q
if(m!=null)m.aB()
s.j(new B.bZ4(s))
s.Q=A.hD(C.iu,new B.bZ5(s))
l=new A.CM()
$.F7()
l.om()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a9E(),$async$BL)
case 7:q=e
if(q.b<0.8){s.b6u("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.avB(q,B.F4(s.gBR()).length),$async$BL)
case 8:p=e
s.ch=A.dr(0,0,r.ga55(),0,0,0)
k=A.lF().geI().h(0,"debug")
if(k==="1"){o=B.coH(m.Jw())
A.rd().$1("[tutor] "+s.a.c+":"+s.gje()+" audio="+C.f.az(q.b,1)+"s infer="+p.b+"ms total="+r.gCE()+"ms "+p.gT9()+" text="+p.a)
A.rd().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.az(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(p.b/1000,2)+" \u062b\n"+p.gT9()+"\n"+A.n(o)+"\n"+p.a}s.afO(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lE){n=m
m=A.lF().geI().h(0,"debug")
if(m==="1")A.rd().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.Jw())
s.a2A(B.MT(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$BL,w)},
a2A(d,e){var x=this,w=x.Q
if(w!=null)w.aB()
if(x.c==null)return
x.j(new B.bYQ(x,d,e))},
b6u(d){return this.a2A(d,null)},
afO(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aB()
if(s.c==null)return
x=B.cmI(s.gBR(),d)
r.a=null
if(C.c.N(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gje()
t=x.gtv()
r.a=w.auC(v,u,q.b.a,t)
q.zU()}s.j(new B.bYS(r,s,x))},
O8(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$O8=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jU){x=1
break}s.j(new B.bYJ(s))
l=s.Q
if(l!=null)l.aB()
s.Q=A.hD(C.iu,new B.bYK(s))
k=new A.CM()
$.F7()
k.om()
r=k
u=4
l=g.a
x=7
return A.c(l.bmr(B.aAf(s.a.c,s.gje()),B.F4(s.gBR()).length),$async$O8)
case 7:q=e
p=B.coH(l.Jw())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.az(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.az(r.gCE()/1000,2)+" \u062b)\n"+q.gT9()+"\n"+A.n(p)+"\n"+q.a
A.rd().$1("[tutor-debug] "+s.a.c+":"+s.gje()+" audio="+C.f.az(q.c,1)+"s infer="+q.b+"ms total="+r.gCE()+"ms "+q.gT9()+" text="+q.a)
A.rd().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dr(0,0,r.ga55(),0,0,0)
s.afO(q.a)
n=s.r
if(n!=null){l=n.gtv()
j=n.b
i=A.al(j).i("ag<1>")
j=A.a9(new A.ag(j,new B.bYL(),i),i.i("Z.E"))
A.rd().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.bYM(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lE){m=l
A.rd().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.Jw())
s.a2A(B.MT(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$O8,w)},
ga1i(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.ri():v).a!==D.fk)return!1}return!0},
u(d){var x,w=this,v=null,u=w.d,t=u.c.a6E(w.a.c,w.gje()),s=u.b,r=s.d&&!w.x&&w.f!==D.jc,q=H.kl(w.a.c),p=y.p,o=A.a([A.bQ(v,v,v,v,C.iy,v,v,new B.bZa(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aLb(),m=A.d("\u0622\u064a\u0629 "+E.bq(w.gje()),v,v,v,v,v,C.m7,v,v,v),l=E.bq(w.gje()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.aY,A.d("("+l+" \u0645\u0646 "+E.bq(k.e-k.d+1)+")",v,v,v,v,v,F.aM,v,v,v),C.bE,w.aZy(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.u],p)
if(r)s.push(w.aTf())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.v5&&l!==D.p4}else l=!1
if(l)s.push(w.aIP(m))
else s.push(A.d(w.gBR()+" \ufd3f"+E.bq(w.gje())+"\ufd3e",v,v,v,v,v,D.kg,C.Y,C.bi,v))}s=A.a([new B.Hx(u,!0,v),n,C.B,new E.dD(A.J(s,C.ag,C.d,C.e,0,C.l),D.ajV,C.aJ,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.jc)s.push(w.b7Z(n))
if(w.r!=null&&w.f===D.jc&&w.ch!=null){x=C.f.aj(C.j.aH(w.ch.a,1000)/100)
s.push(new A.D(C.br,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bq(C.j.aH(x,10))+"\u066b"+E.bq(C.j.a3(x,10)))+" \u062b",v,v,v,v,v,F.aM,C.Y,v,v),v))}n=w.as
if(n!=null)s.push(new A.D(C.aJ,A.d(n,v,v,v,v,v,D.BB,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.Dk(n,"check "+w.a.c+":"+w.gje(),v))}s.push(w.aJp())
s.push(C.a1)
s.push(A.it(C.v,C.H,v,new B.bZb(w),D.blJ,D.br3,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga1i()
s.push(new E.dD(A.A(A.a([D.apE,C.Z,A.R(A.J(A.a([D.bsI,A.d(w.ga1i()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,v,F.aM,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nA],p),C.h,C.d,C.e,0,v,v),C.a4,C.aJ,new B.bZc(w,d),n,v))}n=A.lF().geI().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.de(D.ar3,D.bqw,u.f===D.jU&&w.f!==D.p4?w.gaK8():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.D(C.hN,A.xj(n,F.aM,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn4()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,v,F.aM,v,v,v))}p.push(A.bf(D.brR,v,v,v,new B.bZd(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.Cs)
return L.xI(o,s,q)},
aLb(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.an(A.ft(new B.bYO(this),w,null,C.ae,new B.bYP()),36,null)},
aZy(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fk)return D.b78
x=d.b
w=E.bq(x)
v=E.bq(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c1:C.qK
u.push(new A.D(D.akE,A.b_(r,s?G.cO:C.eV,q,16),q))}return A.ajy(A.A(u,C.h,C.d,C.L,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aTf(){var x=null
return A.bv(!1,A.v(12),!0,A.F(x,D.afX,C.k,x,x,new A.G(C.pF,x,x,A.v(12),x,x,x,C.n),x,x,x,x,D.ajt,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bYU(this),x,x,x,x,x,x,x)},
aIP(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.as(d.gMH(),w)
A:{if(D.j5===v){u=D.kg.ct(G.cO)
break A}if(D.uP===v){u=D.kg.a4o(D.e_,C.fM,D.e_)
break A}if(D.uQ===v){u=D.kg.a4o(D.eT,C.fM,D.eT)
break A}u=D.kg.a4o(C.eV,C.j0,C.cc)
break A}t=x[w]
r.push(new A.eM(t.a,s,s,C.bt,s,s,s,s,s,s,u))
r.push(P.Bt)}x=E.bq(this.gje())
r.push(A.es(s,s,s,s,s,s,s,s,s,D.kg.ct(C.an),"\ufd3f"+x+"\ufd3e"))
return A.CY(A.es(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Y,C.bi)},
b7Z(d){var x,w,v,u,t,s,r=this.w
if(C.c.N(d.c).length===0)return D.bGg
if(d.gtv()){x=r==null
if((x?null:r.a)===D.fk&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fk?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bq(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.DC(G.cO,C.c1,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMH()
w=J.dE(x)
v=w.iF(x,new B.bZ6()).gM(0)
u=w.iF(x,new B.bZ7()).gM(0)
t=w.iF(x,new B.bZ8()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bq(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bq(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bq(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJP().length!==0)x.push(E.bq(d.gJP().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eT:D.e_
x=C.b.aC(x," \u2022 ")
s=d.gJP().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aC(d.gJP(),"\u060c "):""
return new B.DC(w,C.nq,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aJp(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jU,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aH(new A.aQ(f,0,!1).dD(w).a,1e6)}v=C.j.aH(B.ccc(B.F4(j.gBR()).length).a,1e6)
f=j.gb53()
w=96+26*j.y
u=D.eT.ad(0.25)
w=A.iO(i,A.a5B(C.P,A.F(i,D.arg,C.k,i,i,D.a7M,i,84,i,i,i,i,i,84),i,C.aU,new A.G(u,i,i,i,i,i,i,C.bZ),C.Fn,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cS)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.cb7(x)+" / "+B.cb7(v),i,i,i,i,i,K.oF,i,i,i)
return A.J(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,i,F.aM,i,i,i),A.bf(D.bxo,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.eB((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bq(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bq(t)+" \u062b)"
return new A.D(C.q5,A.J(A.a([C.vX,C.a1,D.bpf,A.d(h,i,i,i,i,i,F.aM,C.Y,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.v4
r=j.r
f=r==null
w=!f
q=w&&r.gtv()
u=A.b_(s?C.nr:K.HW,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i,i)
o=A.ev(i,i,D.b9V,i,i,i,i)
u=A.R(new A.zZ(C.a4J,!0,new B.bYC(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.YD(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.JC[n]
p.push(new A.eb(m,i,A.d("\xd7"+E.bq(m),i,i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.N,A.ns(new B.bYD(j),p,A.da([h.b.b],o),!1,A.kp(i,i,i,new A.bh(new B.bYE(),l),i,i,i,i,new A.bh(new B.bYF(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cL),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb0z():i
u=A.b_(f?D.qG:C.nq,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,i,C.cm,i,i,i)
p=q?C.iq:C.v
h=A.a([o,C.u,A.fp(u,f,h,A.ev(p,q?C.i:C.af,D.tU,i,i,i,i))],k)
if(w&&j.gje()<j.a.e)C.b.A(h,A.a([C.B,q?A.fp(D.auC,D.bw4,new B.bYG(j),A.ev(G.cO,C.af,D.tU,i,i,i,i)):A.bf(D.bma,i,i,i,new B.bYH(j),i,i)],k))
if(w){f=j.gje()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.D(C.hO,A.d(j.ga1i()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,i,K.uu,C.Y,i,i),i))
return A.J(h,C.ag,C.d,C.e,0,C.l)}}}
B.DC.prototype={
u(d){var x=this,w=null,v=x.c,u=v.ad(0.12),t=A.v(14),s=A.aJ(v.ad(0.5),1),r=y.p
return A.F(w,A.A(A.a([A.b_(x.d,v,w,w),C.N,A.R(A.J(A.a([A.d(x.e,w,w,w,w,w,A.bB(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.V,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bR,A.d(x.f,w,w,w,w,w,C.BI,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.G(u,w,s,t,w,w,w,C.n),w,w,w,C.aJ,C.ac,w,w,w)}}
B.Di.prototype={
P(){var x=y.S
return new B.a2I($.N_(),A.B(x,y.B),A.aS(x),A.B(x,y.N),A.em(null,y.H))}}
B.a2I.prototype={
W(){this.Y()
this.d.aa(this.goD())},
xU(){if(this.c!=null)this.j(new B.bYk())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.y
if(x!=null)x.aB()
v.a.a3L()
w.a_()},
Ik(d){return this.b4P(d)},
b4P(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$Ik=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.bYt(t,d))
r=t.y
if(r!=null)r.aB()
t.y=A.hD(C.eY,new B.bYu(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.ccc(B.F4(H.MR(q,d,p.y6(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dr(0,0,0,350*B.F4(H.MR(p,d,o.y6(p,d)).b).length,0,0)
x=6
return A.c(r.a.a9A(r.b.c,q,p,new B.bYv(t,d),new B.bYw(t)),$async$Ik)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lE){s=r
r=t.y
if(r!=null)r.aB()
if(t.c!=null)t.j(new B.bYx(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$Ik,w)},
FL(d,e){return this.aMl(d,e)},
aMl(d,e){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$FL=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aB()
s.j(new B.bYo(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a9E()
if(e&&n!=null)s.Ik(n)
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
s.j(new B.bYp(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bH(new B.bYq(s,o,d),y.H)}case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$FL,w)},
gaWX(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b1u(){this.j(new B.bYr(this))},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jU,o=s.e,n=s.gaWX(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("c5<2>")
x=new A.ag(new A.c5(m,l),new B.bYy(),l.i("ag<Z.E>")).gM(0)
l=H.kl(s.a.c)
m=y.p
q=A.a([new B.Hx(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bq(s.a.d)+" \u0644\u062d\u062f "+E.bq(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,r,F.aM,r,r,r),C.u],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b6w(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,r,D.BB,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.Dk(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bq(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aH(new A.aQ(v,0,!1).dD(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.cb7(v),r,r,r,r,r,K.oF,C.Y,r,r)
j=A.fb(A.v(6),A.qa(C.eU,D.eT,6,s.x,r),C.aA)
u=o<s.a.e
t=A.b_(u?O.HP:C.nr,r,r,r)
C.b.A(q,A.a([v,C.G,j,C.u,A.fp(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,r,C.cm,r,r,r),new B.bYz(s,o),A.ev(C.v,C.af,D.tU,r,r,r,r))],m))}else if(n!=null){j=p?new B.bYA(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bq(n)
q.push(A.fp(D.asr,A.d(v,r,r,r,r,r,C.cm,r,r,r),j,A.ev(C.v,C.af,D.tU,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aWt)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cO:D.e_
v=k?C.nj:C.nq
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bq(x)
u=s.a
u=k+" \u0645\u0646 "+E.bq(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.DC(j,v,k,u,r),A.de(D.aup,D.bwL,s.gb1t(),r)],m))}q.push(C.u)
q.push(D.Cs)
return L.xI(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b6w(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.arL
else if(l.r.n(0,d))x=N.tX
else if(i!=null)x=D.as2
else if(j!=null){w=j.gtv()?C.c1:D.aod
x=A.b_(w,j.gtv()?G.cO:D.e_,k,k)}else x=D.aqk
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bq(d),k,k,k,k,k,C.a2h,k,k,k),C.bE,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,k,D.a2b,k,k,k))
if(j!=null&&!j.gtv()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMH()
o=J.bd(p)
n=o.h(p,r)
A:{if(D.j5===n){m=G.cO
break A}if(D.uP===n){m=D.e_
break A}if(D.uQ===n){m=D.eT
break A}m=C.eV
break A}m=D.kg.bc6(m,o.h(p,r)===D.uR?C.j0:k,22)
C.b.A(t,A.a([new A.eM(q.a,k,k,C.bt,k,k,k,k,k,k,m),P.Bt],u))}w=A.a([C.ak,A.CY(A.es(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Y,C.bi)],w)
if(C.c.N(j.c).length===0)w.push(D.bs5)
C.b.A(v,w)}return new E.dD(A.J(v,C.ag,C.d,C.e,0,C.l),C.bN,C.d1,k,!1,k)}}
B.Dh.prototype={
P(){return new B.a2H($.N_())}}
B.a2H.prototype={
W(){this.Y()
var x=this.d
x.aa(this.goD())
x.vJ()},
xU(){if(this.c!=null)this.j(new B.bYb())},
m(){this.d.T(this.goD())
this.a_()},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gazg(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.j6(o,0,new B.bYi(q))
v=C.b.j6(o,0,new B.bYj())
o=y.p
o=A.a([A.A(A.a([A.R(s.Yc(E.bq(q.gatD()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.N,A.R(s.Yc(E.bq(q.aqd()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.N,A.R(s.Yc(E.bq(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.u,new E.dD(A.J(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bq(C.f.aj(w*100/v))+"\u066a",r,r,r,r,r,C.bw,r,r,r),C.G,A.fb(A.v(6),A.qa(C.eU,G.cO,8,w/v,r),C.aA),C.ak,A.d(E.bq(w)+" \u0645\u0646 "+E.bq(v)+" \u0622\u064a\u0629",r,r,r,r,r,F.aM,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)],o)
if(p.length===0)o.push(D.aWJ)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b6y(p[t]))
o.push(C.B)
u=$.C().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,r,F.aM,r,r,r))
return L.xI(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
Yc(d,e){var x=null
return new E.dD(A.J(A.a([A.d(d,x,x,x,x,x,D.bh_,x,x,x),A.d(e,x,x,x,x,x,C.a2H,C.Y,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a4,C.H,x,!1,x)},
b6y(d){var x=null,w=this.d.c,v=I.cR[d-1].a[1],u=w.a6w(d),t=w.bhh(d),s=y.p,r=A.A(A.a([A.R(A.d(H.kl(d),x,x,x,x,x,C.bw,x,x,x),1),A.d(E.bq(C.f.aj(u*100/v))+"\u066a",x,x,x,x,x,D.bi4,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fb(A.v(6),A.qa(C.eU,G.cO,7,u/v,x),C.aA),p=E.bq(u),o=E.bq(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bq(t):""
return new E.dD(A.J(A.a([r,C.G,q,C.ak,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,x,F.aM,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,new B.bYh(this,d),!1,x)},
Ob(d){return this.aKu(d)},
aKu(d){var x=0,w=A.k(y.H),v=this,u,t
var $async$Ob=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=I.cR[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e_(C.cN,new B.bYg(v,d,u),t,!0,null,null,!1,y.H),$async$Ob)
case 2:return A.i(null,w)}})
return A.j($async$Ob,w)}}
B.ajD.prototype={
RL(d,e){var x=null,w=A.lD(x,x,x,x,x,x,x,x,x,x,x,D.b9u,C.H,x,x,x,x,C.jT,x,x)
return A.bf(A.d(d,x,x,x,x,x,C.m6,x,x,x),x,x,x,new B.b5Y(e),x,w)},
u(d){var x=this,w=y.p
return new E.dD(A.J(A.a([D.bvQ,C.G,D.bxn,A.cX(C.aw,A.a([x.RL("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.RL("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aE,0,12),D.bll,x.RL("tanzil.net","https://tanzil.net"),D.bz0,x.RL("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,null,!1,null)}}
B.Dk.prototype={
P(){return new B.a2K()}}
B.a2K.prototype={
gamu(){var x=this.a
return B.cMt(x.c,x.d,$.ccP().Jw())},
RN(){var x=0,w=A.k(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$RN=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.bZe(s))
v=3
r=A.c6h()
n=s.gamu()
m=y.N
q=A.B(m,m)
J.dX(q,"app","mogtama3y")
J.dX(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dX(q,"ua",m)}x=6
return A.c(A.aa7(n,null,C.Gs,q),$async$RN)
case 6:if(s.c!=null)s.j(new B.bZf(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.ce?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.bZg(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.bZh(s))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$RN,w)},
u(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bv(!1,t,!0,new A.D(C.kU,A.A(A.a([A.b_(u.d?C.yo:C.la,C.cc,t,18),C.bL,D.bya],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bZj(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.F(t,A.xj(u.gamu(),D.bdf,t,C.A),C.k,t,t,new A.G(C.pF,t,t,x,t,t,t,C.n),t,t,t,D.ajw,C.ee,t,t,1/0))}if(u.f)s.push(D.blD)
else{x=A.lD(t,t,t,t,t,t,t,t,t,t,t,C.a0v,C.H,t,t,t,t,C.jT,t,t)
w=u.e
v=w?t:u.gb6x()
s.push(A.ff(w?C.a0K:D.atL,t,D.buK,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,t,D.a2b,t,t,t))
return new A.D(C.aJ,A.J(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["ak<~>()","~()","O(nE)","ak<JY>()","ak<JW>()","ak<JX>()","a7<nE>()","O(rt)","bC(oM)","Dj(u)","Dh(u)","O(mW)","Di(u)","O(Iz)"])
B.b5Z.prototype={
$0(){var x=0,w=A.k(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
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
m=B.cBF("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:400}
B.b61.prototype={
$1(d){var x=null
return A.c0Q(A.cM(d,"persist",x,x,x,x))},
$S:1121}
B.b60.prototype={
$0(){var x=0,w=A.k(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.ra(),$async$$0)
case 4:x=3
return A.c(n.eF(m.cS(l.cM(e,"loadModel",A.c1y(new B.b6_(u.b)),u.c,u.d,null)),y.m),$async$$0)
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
v=new B.JW(o,t,s,r,q.r9(p,"threads"),q.or(p,"isolated"),q.r9(p,"warmMs"))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+4}
B.b6_.prototype={
$2(d,e){this.a.$2(C.f.aj(d),C.f.aj(e))},
$S:1122}
B.b65.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
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
u.onLevel=A.fW(new B.b63(v.e))
u.onAutoStop=A.fW(new B.b64(v.f))
x=5
return A.c(A.eF(A.cS(A.cM(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.b63.prototype={
$1(d){return this.a.$1(d)},
$S:67}
B.b64.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b66.prototype={
$0(){var x=0,w=A.k(y.D),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
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
v=new B.JX(r,A.dQ(r.seconds))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+5}
B.b68.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.ra(),$async$$0)
case 4:x=3
return A.c(q.eF(p.cS(o.cM(e,"transcribe",t.audio,t.rate,s.aiN(u.c),null)),y.m),$async$$0)
case 3:v=r.amo(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b67.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.ra(),$async$$0)
case 4:x=3
return A.c(r.eF(q.cS(p.cM(e,"transcribeUrl",u.b,t.aiN(u.c),null,null)),y.m),$async$$0)
case 3:v=s.amo(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b62.prototype={
$1(d){return d},
$S:39}
B.aX9.prototype={
$0(){var x,w,v,u,t=this.a,s=A.co(t.a.length,D.uR,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aX8.prototype={
$1(d){return d===D.j5},
$S:z+2}
B.c1h.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c7h(e[x],d[x])<0.75)return!1
return!0},
$S:1123}
B.c3o.prototype={
$1(d){return d.length!==0},
$S:10}
B.b6c.prototype={
$1(d){return d.a===D.fk},
$S:z+7}
B.b6d.prototype={
$1(d){return C.j.aH(d,1000)},
$S:59}
B.b6a.prototype={
$1(d){return C.f.bA(d)},
$S:1124}
B.b6e.prototype={
$0(){var x=0,w=A.k(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iB("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.am.f0(r,null))
j=A.aw(k.h(0,"n"))
j=j==null?null:C.f.bA(j)
j=C.j.cZ(j==null?2:j,1,5)
i=C.b.n(D.JC,k.h(0,"r"))?A.ey(k.h(0,"r")):1
h=A.ei(k.h(0,"auto"))
g=A.ei(k.h(0,"hide"))
k=A.ei(k.h(0,"in"))
s.a.b=new B.VJ(j,i,h!==!1,g===!0,k===!0)}u=2
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
if(q!=null)s.a.c=B.caq(y.P.a(C.am.f0(q,null)))
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
n=C.f.bA(A.cN(J.as(o,"s")))
m=C.f.bA(A.cN(J.as(o,"f")))
l=C.f.bA(A.cN(J.as(o,"t")))
if(B.coM(n,m)&&B.coM(n,l)&&m<=l)s.a.z=new A.aX(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a9o()){k.a.ar1()
x=1
break}a1=k
x=18
return A.c(k.a.N1(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a5()
if(k.b.e)k.Dh()
k.wG()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:108}
B.b6f.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a5()},
$S:1125}
B.b6g.prototype={
$2(d,e){return C.j.aH(A.eE(A.n(d),null,null),1000)===this.a},
$S:1126}
B.bKX.prototype={
$1(d){var x=0,w=A.k(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.Ey(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bKW(u,t))
return A.i(null,w)}})
return A.j($async$$1,w)},
$S:1127}
B.bKW.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bKY.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bKV(x,d))},
$S:z+8}
B.bKV.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bKZ.prototype={
$1(d){},
$S:23}
B.bKJ.prototype={
$0(){},
$S:0}
B.bKP.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.Dj(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bKQ.prototype={
$0(){},
$S:0}
B.bKT.prototype={
$0(){var x=y.z
return A.N(this.a,!1).aA(A.ay(new B.bKS(),null,x),x)},
$S:0}
B.bKS.prototype={
$1(d){return D.bAn},
$S:z+10}
B.bKU.prototype={
$0(){return B.coy(this.a)},
$S:0}
B.bKM.prototype={
$0(){var x=this.b
return this.a.xV(x.a,x.b,x.c)},
$S:0}
B.bKN.prototype={
$1(d){return this.a.j(new B.bKL())},
$S:5}
B.bKL.prototype={
$0(){},
$S:0}
B.bKO.prototype={
$0(){var x=this.a
return x.j(new B.bKK(x))},
$S:0}
B.bKK.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bKR.prototype={
$0(){return this.a.b6v(this.b)},
$S:0}
B.c5V.prototype={
$1(d){return new A.ja(new B.c5S(this.a,this.b,this.c),null)},
$S:57}
B.c5S.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c5U(u,e),s=this.a,r=new B.c5T(s,e),q=A.d(H.kl(this.c),v,v,v,v,v,C.oB,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bq(u)+" \u0622\u064a\u0629)",v,v,v,v,v,F.aM,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bq(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bq(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.cZ(w+4,1,u)))}u=A.a([q,C.ak,p,C.u,A.cX(C.aw,n,C.aE,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c5N(s)),C.a0G,t.$3("\u0644\u062d\u062f",s.c,new B.c5O(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aWy)
u.push(C.a5)
u.push(A.dA(D.boJ,new B.c5P(s,d),A.ev(C.v,C.af,D.b9S,v,v,v,v)))
return A.cw(!0,new A.D(C.FU,A.J(u,C.ag,C.d,C.L,0,C.l),v),C.H,!0)},
$S:391}
B.c5U.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,u,C.ib,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c7(v,A.d("\u0622\u064a\u0629 "+E.bq(v),u,u,u,u,u,u,u,u,u),C.aq,u,w))
return A.R(A.J(A.a([t,R.Gf(C.cN,!0,s,320,new B.c5R(this.b,f),D.bil,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1129}
B.c5R.prototype={
$1(d){return d==null?null:this.a.$1(new B.c5Q(this.b,d))},
$S:52}
B.c5Q.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c5T.prototype={
$3(d,e,f){var x=null
return A.c7S(x,A.d(d,x,x,x,x,x,x,x,x,x),new B.c5M(this.a,this.b,e,f))},
$S:1130}
B.c5M.prototype={
$0(){var x=this
return x.b.$1(new B.c5L(x.a,x.c,x.d))},
$S:0}
B.c5L.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c5N.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c5O.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c5P.prototype={
$0(){var x=this.a
return A.N(this.b,!1).af(new A.W(x.b,x.c))},
$S:0}
B.bYB.prototype={
$0(){},
$S:0}
B.bYR.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mp
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bYV.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.jc:D.mp},
$S:0}
B.bYW.prototype={
$0(){var x=this.a
x.f=D.v4
x.as=null},
$S:0}
B.bYX.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bYZ.prototype={
$0(){var x=this.a
x.f=D.v5
x.as=null
x.y=0
x.z=new A.aQ(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bZ_.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bYY())},
$S:30}
B.bYY.prototype={
$0(){},
$S:0}
B.bZ1.prototype={
$1(d){return this.a.y=d},
$S:67}
B.bZ0.prototype={
$1(d){return this.a.BL()},
$S:5}
B.bZ2.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.jc:D.mp
x=this.b
w.as=B.MT(x)
w.at=x},
$S:0}
B.bZ4.prototype={
$0(){var x=this.a
x.f=D.p4
x.ay=Date.now()},
$S:0}
B.bZ5.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bZ3())},
$S:30}
B.bZ3.prototype={
$0(){},
$S:0}
B.bYQ.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.jc:D.mp
x.as=this.b
x.at=this.c},
$S:0}
B.bYS.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.jc
x.x=!1},
$S:0}
B.bYJ.prototype={
$0(){var x=this.a
x.f=D.p4
x.ay=Date.now()
x.as=null},
$S:0}
B.bYK.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bYI())},
$S:30}
B.bYI.prototype={
$0(){},
$S:0}
B.bYL.prototype={
$1(d){return d.d!==D.j5},
$S:z+11}
B.bYM.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bZa.prototype={
$0(){return B.coy(this.a)},
$S:0}
B.bZb.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.apJ(d))},
$S:3}
B.bZc.prototype={
$0(){var x=y.z
return A.N(this.b,!1).aA(A.ay(new B.bZ9(this.a),null,x),x)},
$S:0}
B.bZ9.prototype={
$1(d){var x=this.a.a
return new B.Di(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bZd.prototype={
$0(){this.a.d.a.blA()
this.b.J(y.q).f.Z(D.baZ)},
$S:0}
B.bYP.prototype={
$2(d,e){return C.aY},
$S:17}
B.bYO.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a6E(s.c,r).a.a){case 2:s=G.cO
break
case 1:s=D.e_
break
case 0:s=C.iq
break
default:s=u}x=A.v(18)
w=t.f===D.p4?u:new B.bYN(t,r)
v=s.ad(0.25)
if(r===t.gje())s=C.i
s=A.aJ(s,r===t.gje()?2:1)
return A.bv(!1,x,!0,A.F(C.P,A.d(E.bq(r),u,u,u,u,u,C.a1Q,u,u,u),C.k,u,u,new A.G(v,u,s,u,u,u,u,C.bZ),u,u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:66}
B.bYN.prototype={
$0(){return this.a.a_l(this.b)},
$S:0}
B.bYU.prototype={
$0(){var x=this.a
return x.j(new B.bYT(x))},
$S:0}
B.bYT.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bZ6.prototype={
$1(d){return d===D.uP},
$S:z+2}
B.bZ7.prototype={
$1(d){return d===D.uQ},
$S:z+2}
B.bZ8.prototype={
$1(d){return d===D.uR},
$S:z+2}
B.bYC.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.RM(x)},
$S:0}
B.bYD.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.bbv(d.ga1(d)))},
$S:105}
B.bYF.prototype={
$1(d){return d.n(0,C.T)?C.af:C.i},
$S:4}
B.bYE.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.bYG.prototype={
$0(){var x=this.a
return x.a_l(x.gje()+1)},
$S:0}
B.bYH.prototype={
$0(){var x=this.a
return x.a_l(x.gje()+1)},
$S:0}
B.bYk.prototype={
$0(){},
$S:0}
B.bYt.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aQ(Date.now(),0,!1)},
$S:0}
B.bYu.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bYs())},
$S:30}
B.bYs.prototype={
$0(){},
$S:0}
B.bYw.prototype={
$1(d){return this.a.x=d},
$S:67}
B.bYv.prototype={
$1(d){return this.a.FL(this.b,!1)},
$S:5}
B.bYx.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.MT(x)
w.as=x},
$S:0}
B.bYo.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.bYp.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.MT(x))
w.as=x},
$S:0}
B.bYq.prototype={
$1(d){var x=0,w=A.k(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k,j,i,h
var $async$$1=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:v=3
o=s.a
n=o.d
m=s.c
l=o.a
k=l.f
l=l.c
x=6
return A.c(n.a.avB(s.b,B.F4(H.MR(l,m,k.y6(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cmI(H.MR(l,m,k.y6(l,m)).b,r.a)
if(C.c.N(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtv()
l.auC(k,m,n.b.a,j)}n.zU()
if(o.c!=null)o.j(new B.bYl(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lE){p=o
o=s.a
if(o.c!=null)o.j(new B.bYm(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.bYn(o,s.c))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$1,w)},
$S:154}
B.bYl.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.bYm.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.MT(w))
x.as=w},
$S:0}
B.bYn.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bYr.prototype={
$0(){var x=this.a
x.f.ao(0)
x.w.ao(0)
x.as=null},
$S:0}
B.bYy.prototype={
$1(d){return d.gtv()},
$S:z+13}
B.bYz.prototype={
$0(){return this.a.FL(this.b,!0)},
$S:0}
B.bYA.prototype={
$0(){return this.a.Ik(this.b)},
$S:0}
B.bYb.prototype={
$0(){},
$S:0}
B.bYi.prototype={
$2(d,e){return d+this.a.a6w(e)},
$S:109}
B.bYj.prototype={
$2(d,e){return d+I.cR[e-1].a[1]},
$S:109}
B.bYh.prototype={
$0(){return this.a.Ob(this.b)},
$S:0}
B.bYg.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kl(p),q,q,q,q,q,C.oB,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.bc(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.ri():r).a.a){case 2:r=G.cO.ad(0.35)
break
case 1:r=D.e_.ad(0.35)
break
case 0:r=C.fY
break
default:r=q}m.push(A.F(C.P,A.d(E.bq(t),q,q,q,q,q,C.kf,q,q,q),C.k,q,q,new A.G(r,q,q,new A.cG(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,q,38))}return A.cw(!0,new A.D(C.h3,A.J(A.a([o,C.ak,D.bt0,C.u,new A.dq(D.a7D,A.f7(A.cX(C.aw,m,C.aE,6,6),q,C.r,q,q,q,C.w),q),C.a1,A.bf(D.buO,q,q,q,new B.bYf(w,d,p),q,q)],n),C.ag,C.d,C.L,0,C.l),q),C.H,!0)},
$S:36}
B.bYf.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dj(null,null,!0,null,new B.bYe(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Lk(t),$async$$0)
case 5:if(u.e!=null)A.N(u,!1).e4()
case 3:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.bYe.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kl(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x,x)
return A.dp(A.a([A.bf(C.es,x,x,x,new B.bYc(d),x,x),A.bf(C.oR,x,x,x,new B.bYd(d),x,x)],y.p),w,D.bws)},
$S:14}
B.bYc.prototype={
$0(){A.N(this.a,!1).af(!1)
return null},
$S:0}
B.bYd.prototype={
$0(){A.N(this.a,!1).af(!0)
return null},
$S:0}
B.c6S.prototype={
$1(d){var x=this.a
return new A.kE(new B.c6R(x),null,x,null)},
$S:1131}
B.c6R.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.eb(w,t,A.d(E.bq(w),t,t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.blh,C.a1,D.bvf,C.G,A.ns(new B.c6M(s,r),q,A.da([r.a],x),!1,A.kp(t,t,t,new A.bh(new B.c6N(),v),t,t,t,t,new A.bh(new B.c6O(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.it(C.v,C.H,t,new B.c6P(s,r),D.bsg,D.bys,r.c),A.it(C.v,C.H,t,new B.c6Q(s,r),t,D.bkL,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ak,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn4(),t,t,t,t,t,F.aM,t,C.bi,t)],u))
x.push(C.B)
x.push(D.a3U)
return A.cw(!0,A.f7(A.J(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.h3,t,t,C.w),C.H,!0)},
$S:1132}
B.c6M.prototype={
$1(d){return this.a.qK(this.b.bbs(d.ga1(d)))},
$S:105}
B.c6O.prototype={
$1(d){return d.n(0,C.T)?C.af:C.i},
$S:4}
B.c6N.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.c6P.prototype={
$1(d){return this.a.qK(this.b.baO(d))},
$S:3}
B.c6Q.prototype={
$1(d){return this.a.qK(this.b.apJ(d))},
$S:3}
B.b5Y.prototype={
$0(){return A.cq(A.bx(this.a,0,null),C.aP,null)},
$S:0}
B.c7a.prototype={
$1(d){var x,w=A.aD("https?://",!0,!1,!1)
w=A.bF(d,w,"")
x=A.aD("www\\.",!0,!1,!1)
return A.uW(A.bF(w,x,"www[.]"),A.aD("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c7b(),null)},
$S:39}
B.c7b.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:56}
B.bZe.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bZf.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bZg.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bZh.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bZj.prototype={
$0(){var x=this.a
return x.j(new B.bZi(x))},
$S:0}
B.bZi.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c79.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:188};(function installTearOffs(){var x=a._instance_0u
x(B.ajE.prototype,"gbhi","bhj",1)
var w
x(w=B.VK.prototype,"gbhz","Dh",0)
x(w,"gaEj","wG",0)
x(w=B.a0d.prototype,"goD","xU",1)
x(w,"gaYM","Q9",0)
x(w=B.a2J.prototype,"goD","xU",1)
x(w,"gb0z","Qz",0)
x(w,"gb53","BL",0)
x(w,"gaK8","O8",0)
x(w=B.a2I.prototype,"goD","xU",1)
x(w,"gb1t","b1u",1)
x(B.a2H.prototype,"goD","xU",1)
x(B.a2K.prototype,"gb6x","RN",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.ajE,B.VL,B.JW,B.JY,B.JX,B.lE,B.SR,B.mW,B.Iz,B.rt,B.ajF,B.VJ])
x(A.ld,[B.b5Z,B.b60,B.b65,B.b66,B.b68,B.b67,B.aX9,B.b6e,B.bKW,B.bKV,B.bKJ,B.bKQ,B.bKT,B.bKU,B.bKM,B.bKL,B.bKO,B.bKK,B.bKR,B.c5Q,B.c5M,B.c5L,B.c5P,B.bYB,B.bYR,B.bYV,B.bYW,B.bYX,B.bYZ,B.bYY,B.bZ2,B.bZ4,B.bZ3,B.bYQ,B.bYS,B.bYJ,B.bYI,B.bYM,B.bZa,B.bZc,B.bZd,B.bYN,B.bYU,B.bYT,B.bYC,B.bYG,B.bYH,B.bYk,B.bYt,B.bYs,B.bYx,B.bYo,B.bYp,B.bYl,B.bYm,B.bYn,B.bYr,B.bYz,B.bYA,B.bYb,B.bYh,B.bYf,B.bYc,B.bYd,B.b5Y,B.bZe,B.bZf,B.bZg,B.bZh,B.bZj,B.bZi])
x(A.iF,[B.b61,B.b63,B.b64,B.b62,B.aX8,B.c3o,B.b6c,B.b6d,B.b6a,B.bKX,B.bKY,B.bKZ,B.bKP,B.bKS,B.bKN,B.c5V,B.c5U,B.c5R,B.c5T,B.c5N,B.c5O,B.bZ_,B.bZ1,B.bZ0,B.bZ5,B.bYK,B.bYL,B.bZb,B.bZ9,B.bZ6,B.bZ7,B.bZ8,B.bYD,B.bYF,B.bYE,B.bYu,B.bYw,B.bYv,B.bYq,B.bYy,B.bYg,B.bYe,B.c6S,B.c6M,B.c6O,B.c6N,B.c6P,B.c6Q,B.c7a,B.c7b,B.c79])
x(A.o9,[B.b6_,B.c1h,B.b6f,B.b6g,B.c5S,B.bYP,B.bYO,B.bYi,B.bYj,B.c6R])
x(A.DU,[B.nE,B.Fm,B.Hw,B.Em])
w(B.VK,A.i2)
x(A.K,[B.wY,B.Dj,B.Di,B.Dh,B.Dk])
x(A.M,[B.a0d,B.a2J,B.a2I,B.a2H,B.a2K])
x(A.a3,[B.Hx,B.Y1,B.DC,B.ajD])})()
A.pm(b.typeUniverse,JSON.parse('{"lE":{"bH":[]},"Dj":{"K":[],"l":[]},"Di":{"K":[],"l":[]},"Dh":{"K":[],"l":[]},"Dk":{"K":[],"l":[]},"VK":{"aC":[]},"wY":{"K":[],"l":[]},"a0d":{"M":["wY"]},"Hx":{"a3":[],"l":[]},"Y1":{"a3":[],"l":[]},"a2J":{"M":["Dj"]},"DC":{"a3":[],"l":[]},"a2I":{"M":["Di"]},"a2H":{"M":["Dh"]},"ajD":{"a3":[],"l":[]},"a2K":{"M":["Dk"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rt"),c:x("eb<x>"),r:x("c7<x>"),k:x("H<mW>"),n:x("H<eb<x>>"),I:x("H<c7<x>>"),R:x("H<hO>"),Z:x("H<aK<o,@>>"),d:x("H<SR>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bP"),j:x("a7<@>"),L:x("a7<x>"),P:x("aK<o,@>"),f:x("aK<@,@>"),x:x("av<o,x>"),a:x("bC"),K:x("a4"),B:x("Iz"),l:x("+(x,x)"),e:x("db<mW>"),N:x("o"),C:x("JW"),D:x("JX"),X:x("VL"),_:x("JY"),U:x("ag<o>"),G:x("nE"),q:x("pj"),b:x("bh<T?>"),y:x("O"),i:x("a2"),z:x("@"),S:x("x"),A:x("bP?"),Y:x("aK<@,@>?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("eV"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.pd=new B.Fm(0,"none")
D.pe=new B.Fm(1,"learning")
D.fk=new B.Fm(2,"memorized")
D.a7D=new A.aE(0,1/0,0,320)
D.eT=new A.T(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a7M=new A.G(D.eT,null,null,null,null,null,null,C.bZ)
D.e_=new A.T(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.at0=new A.E(C.yB,null,C.cc,null,null,null)
D.bwB=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.fd,null,null,null,null,null,null,null,null)
D.bdJ=new A.r(!0,C.eV,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bt2=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bdJ,null,null,null,null,null,null,null,null)
D.aK4=x([D.at0,C.G,D.bwB,D.bt2],y.p)
D.afX=new A.fh(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aK4,null)
D.ajt=new A.U(0,26,0,26)
D.ajw=new A.U(0,4,0,6)
D.ajV=new A.U(14,12,14,14)
D.akE=new A.U(3,0,0,0)
D.aod=new A.Q(63251,"MaterialIcons",null,!1)
D.qG=new A.Q(63677,"MaterialIcons",null,!1)
D.ap1=new A.Q(983209,"MaterialIcons",null,!1)
D.apE=new A.E(D.ap1,28,C.v,null,null,null)
D.aqk=new A.E(C.Hy,null,C.iq,null,null,null)
D.anX=new A.Q(62961,"MaterialIcons",null,!1)
D.ar3=new A.E(D.anX,null,null,null,null,null)
D.aob=new A.Q(63199,"MaterialIcons",null,!1)
D.ar4=new A.E(D.aob,null,null,null,null,null)
D.arc=new A.E(C.l8,null,C.eV,null,null,null)
D.arg=new A.E(C.nr,44,C.i,null,null,null)
D.arL=new A.E(D.qG,null,D.eT,null,null,null)
D.as2=new A.E(C.l9,null,D.eT,null,null,null)
D.asr=new A.E(D.qG,null,null,null,null,null)
D.asY=new A.E(C.hS,20,D.e_,null,null,null)
D.atj=new A.E(C.no,30,C.v,null,null,null)
D.atL=new A.E(C.lf,16,C.v,null,null,null)
D.aud=new A.E(C.Hu,null,null,null,null,null)
D.aup=new A.E(C.nq,null,null,null,null,null)
D.anO=new A.Q(62842,"MaterialIcons",null,!0)
D.auC=new A.E(D.anO,null,null,null,null,null)
D.JC=x([1,3,5],y.t)
D.Kp=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aXa=new A.D(C.kV,C.mC,null)
D.aGV=x([D.aXa],y.p)
D.b0E=new A.W(C.nl,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b0r=new A.W(D.qG,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b0Z=new A.W(C.dj,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.b1c=new A.W(C.Hx,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aJ3=x([D.b0E,D.b0r,D.b0Z,D.b1c],A.ae("H<+(Q,o)>"))
D.aLq=x([D.pd,D.pe,D.fk],A.ae("H<Fm>"))
D.P3=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aT_=new B.Hw(0,"idle")
D.Vi=new B.Hw(1,"loading")
D.jU=new B.Hw(2,"ready")
D.aT0=new B.Hw(3,"failed")
D.arJ=new A.E(C.c1,18,G.cO,null,null,null)
D.bxA=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uu,null,null,null,null,null,null,null,null)
D.aFP=x([D.arJ,C.aY,D.bxA],y.p)
D.b7g=new A.en(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aFP,null)
D.aW2=new A.D(C.aJ,D.b7g,null)
D.akC=new A.U(2,6,2,4)
D.bdp=new A.r(!0,C.v,null,null,null,null,14,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bld=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bdp,null,null,null,null,null,null,null,null)
D.aWi=new A.D(D.akC,D.bld,null)
D.bxZ=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.fd,null,null,null,null,null,null,null,null)
D.aHe=x([N.tX,C.N,D.bxZ],y.p)
D.b7a=new A.en(C.ae,C.cq,C.e,C.h,null,C.l,null,0,D.aHe,null)
D.aWt=new A.D(C.kS,D.b7a,null)
D.BQ=new A.r(!0,D.e_,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.byk=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.BQ,null,null,null,null,null,null,null,null)
D.aWy=new A.D(C.dB,D.byk,null)
D.bxv=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aM,C.Y,null,null,null,null,null,null,null)
D.aWJ=new A.D(C.C,D.bxv,null)
D.akz=new A.U(2,0,2,8)
D.btk=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aM,null,null,null,null,null,null,null,null)
D.aX0=new A.D(D.akz,D.btk,null)
D.atV=new A.E(C.ld,30,C.v,null,null,null)
D.bz1=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.BR,null,null,null,null,null,null,null,null)
D.alK=new A.bZ(1,C.ah,D.bz1,null)
D.aHt=x([D.atV,C.Z,D.alK],y.p)
D.b6W=new A.en(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aHt,null)
D.atv=new A.E(C.dj,18,G.cO,null,null,null)
D.a2_=new A.r(!0,G.cO,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bxc=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a2_,null,null,null,null,null,null,null,null)
D.aGf=x([D.atv,C.bL,D.bxc],y.p)
D.b78=new A.en(C.ae,C.d,C.L,C.h,null,C.l,null,0,D.aGf,null)
D.b9u=new A.V(0,30)
D.tU=new A.V(1/0,54)
D.b9S=new A.V(1/0,48)
D.b9V=new A.V(1/0,50)
D.b9Y=new A.V(1/0,52)
D.buY=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.baZ=new A.cW(D.buY,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.bcR=new A.r(!0,C.i,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bdf=new A.r(!0,C.an,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.BB=new A.r(!0,D.eT,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.kg=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a2b=new A.r(!0,D.eT,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bh_=new A.r(!0,C.v,null,null,null,null,24,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bi3=new A.r(!0,D.e_,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bi4=new A.r(!0,G.cO,null,null,null,null,null,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bil=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bk1=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.ib,null,null,null,null,null,null,null,null)
D.bkL=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.cV,null,null,null,null,null,null,null,null)
D.blh=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oB,null,null,null,null,null,null,null,null)
D.bll=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aM,null,null,null,null,null,null,null,null)
D.beB=new A.r(!0,G.cO,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.blD=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.beB,null,null,null,null,null,null,null,null)
D.blJ=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aM,null,null,null,null,null,null,null,null)
D.bma=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.fd,null,null,null,null,null,null,null,null)
D.bnZ=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cm,null,null,null,null,null,null,null,null)
D.boJ=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bC,null,null,null,null,null,null,null,null)
D.boO=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aM,null,null,null,null,null,null,null,null)
D.bpf=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.BV,null,null,null,null,null,null,null,null)
D.bqw=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.br3=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oF,null,null,null,null,null,null,null,null)
D.brR=new A.m("reset safe mode / WebGPU ban",null,O.a1w,null,null,null,null,null,null,null,null)
D.bs5=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.BQ,null,null,null,null,null,null,null,null)
D.bsg=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aM,null,null,null,null,null,null,null,null)
D.bsI=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bw,null,null,null,null,null,null,null,null)
D.bt0=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aM,null,null,null,null,null,null,null,null)
D.btl=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aM,null,null,null,null,null,null,null,null)
D.buK=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a2A,null,null,null,null,null,null,null,null)
D.bgc=new A.r(!0,D.eT,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.buO=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bgc,null,null,null,null,null,null,null,null)
D.bvf=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oF,null,null,null,null,null,null,null,null)
D.bvQ=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a1r,null,null,null,null,null,null,null,null)
D.bw4=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cm,null,null,null,null,null,null,null,null)
D.bws=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bwL=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bxn=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aM,null,null,null,null,null,null,null,null)
D.bxo=new A.m("\u062e\u0644\u0635\u062a",null,C.m7,null,null,null,null,null,null,null,null)
D.bxp=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.BQ,null,null,null,null,null,null,null,null)
D.bhi=new A.r(!0,C.cH,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.fM,null,null,null,null,null,null,null,null)
D.bya=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bhi,null,null,null,null,null,null,null,null)
D.byo=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bw,null,null,null,null,null,null,null,null)
D.bys=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.cV,null,null,null,null,null,null,null,null)
D.bz0=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aM,null,null,null,null,null,null,null,null)
D.a3U=new B.ajD(null)
D.bAn=new B.Dh(null)
D.bAo=new B.VJ(2,1,!0,!1,!1)
D.a3Y=new B.VL(!1,!1,!1,!1,!1,0)
D.j5=new B.nE(0,"ok")
D.uP=new B.nE(1,"near")
D.uQ=new B.nE(2,"wrong")
D.uR=new B.nE(3,"missing")
D.a4o=new B.nE(4,"extra")
D.aos=new A.Q(63456,"MaterialIcons",null,!1)
D.bGg=new B.DC(D.e_,D.aos,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bGU=new B.Y1(!1,null)
D.Cs=new B.Y1(!0,null)
D.mp=new B.Em(0,"idle")
D.v4=new B.Em(1,"playing")
D.v5=new B.Em(2,"recording")
D.p4=new B.Em(3,"thinking")
D.jc=new B.Em(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cPs","ccP",()=>new B.ajE())
x($,"cSU","csu",()=>A.aD("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cSV","csv",()=>A.aD("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cT6","csE",()=>A.aD("\u0648\u0670",!0,!1,!1))
x($,"cSs","csa",()=>A.aD("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cQK","cr_",()=>A.aD("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cRZ","crN",()=>A.aD("[\u0654\u0655]",!0,!1,!1))
x($,"cQL","cr0",()=>A.aD("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cQS","cr6",()=>A.aD("[\u0624\u0626]",!0,!1,!1))
x($,"cS0","crP",()=>A.aD("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cSx","csd",()=>A.aD("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cS8","crW",()=>A.aD("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cSS","cdq",()=>A.aD("\\s+",!0,!1,!1))
x($,"cMM","ri",()=>B.ctu(D.pd,0,A.c8q(0,!0)))
x($,"cPt","N_",()=>new B.VK($.ccP(),D.bAo,B.cBG(),D.aT_,$.X()))})()};
(a=>{a["1K7TRlzbHakD6GepFQvRSUAV4vo="]=a.current})($__dart_deferred_initializers__);