((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,P,H,G,N,Q,K,B={
cFp(d){var x,w,v,u,t,s
if(d instanceof B.lN)return d
try{x=A.cW(d)
w=x.code
v=x.message
u=w==null?"failed":A.S(w)
t=v==null?"":A.S(v)
return new B.lN(u,t)}catch(s){u=A.n(d)
return new B.lN("failed",u)}},
akM:function akM(){this.b=this.a=null},
b7M:function b7M(d){this.a=d},
b7P:function b7P(){},
b7O:function b7O(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b7N:function b7N(d){this.a=d},
b7T:function b7T(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b7R:function b7R(d){this.a=d},
b7S:function b7S(d){this.a=d},
b7U:function b7U(d){this.a=d},
b7W:function b7W(d,e,f){this.a=d
this.b=e
this.c=f},
b7V:function b7V(d,e,f){this.a=d
this.b=e
this.c=f},
b7Q:function b7Q(){},
cFq(d,e){return new B.lN(d,e)},
Wu:function Wu(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
Kz:function Kz(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
KB:function KB(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
KA:function KA(d,e){this.a=d
this.b=e},
lN:function lN(d,e){this.a=d
this.b=e},
crq(d){var x,w=$.cwa()
w=A.bF(d,w,"\u0627")
x=$.cwb()
w=A.bF(w,x,"\u064a")
x=$.cwk()
w=A.bF(w,x,"\u0627")
x=$.cuF()
w=A.bF(w,x,"\u0627")
x=$.cvR()
w=A.bF(w,x,"\u0621")
x=$.cvt()
w=A.bF(w,x,"\u0621")
x=$.cuG()
w=A.bF(w,x,"\u0627")
x=$.cuM()
w=A.bF(w,x,"\u0621")
w=A.bF(w,"\u0649","\u064a")
w=A.bF(w,"\u0629","\u0647")
x=$.cvv()
w=A.bF(w,x,"")
x=$.cvU()
w=A.bF(w,x," ")
x=$.cvC()
w=A.bF(w,x," ")
x=$.ch0()
return C.c.N(A.bF(w,x," "))},
cK8(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kb(x,w)
for(u=0;u<x;++u)v[u]=u
t=A.cb(x,0,!1,w)
for(s=1;s<=l;++s,r=t,t=v,v=r){t[0]=s
for(w=s-1,u=1;u<=k;++u){q=u-1
p=d.charCodeAt(w)===e.charCodeAt(q)?0:1
o=v[u]+1
n=t[q]+1
m=v[q]+p
if(o<n)q=o<m?o:m
else q=n<m?n:m
t[u]=q}}return v[k]},
caN(d,e){var x,w,v,u,t,s
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
s=1-B.cK8(d,e)/u
return s>=1?0.99:s},
FB(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.uc(d,$.ch0()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.crq(u)
s=A.bF(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.TA(r.a+" "+u,r.b))}continue}q.push(new B.TA(u,s))}return q},
cIO(d,e){var x,w,v,u,t=new B.c4w(),s=A.a([],y.s)
for(x=A.fj(e,0,A.iq(5,"count",y.S),A.aj(e).c),w=x.$ti,x=new A.ch(x,x.gM(0),w.i("ch<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.KW)&&t.$2(d,D.KW)?C.b.jB(d,5):d
return!t.$2(s,D.PE)&&t.$2(u,D.PE)?C.b.jB(u,4):u},
cql(d,e){var x=B.FB(d),w=B.crq(e),v=y.U
v=A.a9(new A.ai(A.a(w.split(" "),y.s),new B.c6D(),v),v.i("Y.E"))
return new B.Jb(x,B.cHZ(x,B.cIO(v,x)),w)},
cHZ(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.cb(x,0,!1,s)
q=A.cb(x,0,!1,y.S)
p=A.cb(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.caN(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.caN(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.caN(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.jc
else m=a2>=0.6?D.v8:D.v9
a1.push(new B.n9(o,x,s,m))
break
case 1:--o
a1.push(new B.n9(o,a4[o],null,D.va))
break
case 2:--n
a1.push(new B.n9(null,null,a6[n],D.a56))
break
case 3:--o
a3=n-2
a1.push(new B.n9(o,a4[o],a6[a3]+" "+a6[n-1],D.jc))
n=a3
break
default:x=o-1;--n
a1.push(new B.n9(x,a4[x],a6[n],D.jc))
o-=2
a1.push(new B.n9(o,a4[o],a6[n],D.jc))}}a4=y.e
a4=A.a9(new A.d6(a1,a4),a4.i("aW.E"))
return a4},
nO:function nO(d,e){this.a=d
this.b=e},
TA:function TA(d,e){this.a=d
this.b=e},
n9:function n9(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Jb:function Jb(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aYM:function aYM(d){this.a=d},
aYL:function aYL(){},
c4w:function c4w(){},
c6D:function c6D(){},
cxb(d,e,f){return new B.rK(d,e,f)},
cL3(d){var x
A:{if("memorized"===d){x=D.fn
break A}if("learning"===d){x=D.pz
break A}x=D.py
break A}return x},
csq(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cW[d-1].a[1]},
cFr(){var x=y.S
return new B.akN(A.D(x,y.u),A.aN(x))},
b7Z(d){var x=d.eP()
return C.c.dt(C.j.k(A.br(x)),4,"0")+"-"+C.c.dt(C.j.k(A.bt(x)),2,"0")+"-"+C.c.dt(C.j.k(A.c_(x)),2,"0")},
cne(d){var x=y.x,w=A.a9(new A.av(A.a(d.split("-"),y.s),A.cMu(),x),x.i("aW.E"))
return B.b7Z(A.dz(w[0],w[1],w[2]-1,12,0,0,0))},
ce_(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.D(p,y.u),n=A.aN(p),m=new B.akN(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcN(),x=x.ga_(x),w=y.j;x.v();){v=x.gG()
u=A.dX(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aQ(t)>=3){v=C.j.aI(u,1000)
s=C.j.a3(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cW[v-1].a[1])}if(v)continue
v=J.bb(t)
r=C.f.bB(A.cT(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rK(D.aNN[r],C.f.bB(A.cT(v.h(t,1))),new A.aR(A.kE(C.f.bB(A.cT(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aCc(q,y.o)
p=A.mA(x,new B.b7Y(),x.$ti.i("Y.E"),p)
n.A(0,new A.ai(p,o.ga4I(),A.y(p).i("ai<Y.E>")))}m.c=A.q(d.h(0,"last"))
p=A.ar(d.h(0,"streak"))
p=p==null?null:C.f.bB(p)
p=m.d=p==null?0:p
o=A.ar(d.h(0,"best"))
o=o==null?null:C.f.bB(o)
m.e=o==null?p:o
return m},
aBt(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dt(C.j.k(d),3,"0")+C.c.dt(C.j.k(e),3,"0")+".mp3"},
FV:function FV(d,e){this.a=d
this.b=e},
rK:function rK(d,e,f){this.a=d
this.b=e
this.c=f},
akN:function akN(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b8_:function b8_(){},
b80:function b80(){},
b7Y:function b7Y(){},
Ws:function Ws(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cCT(){return new B.xd(null)},
cOV(d,e){var x,w,v,u,t={},s=I.cW[e-1].a[1],r=$.NG().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.rz():v).a===D.fn}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d1(u+4,1,s)
return A.e4(C.cT,new B.c9q(t,s,e),d,!0,null,null,!1,y.l)},
cfN(d){return A.du(0,0,0,0,0,C.j.d1(C.f.al(6+d*1.2),25,90))},
ceH(d){return E.bq(C.j.aI(d,60))+":"+C.c.dt(E.bq(C.j.a3(d,60)),2,"\u0660")},
csc(d){return A.e4(C.cT,new B.can($.NG()),d,!0,null,null,!1,y.H)},
Nz(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl9()
break A}return x},
cQg(d,e,f){var x,w=new B.caG(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
csl(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.ap.f4(a4,null))
s=y.Y
r=s.a(J.as(x,"rec"))
w=r==null?C.cO:r
q=s.a(J.as(x,"last"))
v=q==null?C.cO:q
u=new B.caF()
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
a0=J.aQ(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.k(J.as(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.k(J.as(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
I8:function I8(d,e){this.a=d
this.b=e},
Wt:function Wt(d,e,f,g,h){var _=this
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
b81:function b81(d){this.a=d},
b82:function b82(d){this.a=d},
b83:function b83(d){this.a=d},
xd:function xd(d){this.a=d},
a17:function a17(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bO3:function bO3(d){this.a=d},
bO2:function bO2(d,e){this.a=d
this.b=e},
bO4:function bO4(d){this.a=d},
bO1:function bO1(d,e){this.a=d
this.b=e},
bO5:function bO5(){},
bNQ:function bNQ(){},
bNW:function bNW(d,e,f){this.a=d
this.b=e
this.c=f},
bNX:function bNX(){},
bO_:function bO_(d){this.a=d},
bNZ:function bNZ(){},
bO0:function bO0(d){this.a=d},
bNT:function bNT(d,e){this.a=d
this.b=e},
bNU:function bNU(d){this.a=d},
bNS:function bNS(){},
bNV:function bNV(d){this.a=d},
bNR:function bNR(d){this.a=d},
bNY:function bNY(d,e){this.a=d
this.b=e},
I9:function I9(d,e,f){this.c=d
this.d=e
this.a=f},
YT:function YT(d,e){this.c=d
this.a=e},
c9q:function c9q(d,e,f){this.a=d
this.b=e
this.c=f},
c9n:function c9n(d,e,f){this.a=d
this.b=e
this.c=f},
c9p:function c9p(d,e){this.a=d
this.b=e},
c9m:function c9m(d,e){this.a=d
this.b=e},
c9l:function c9l(d,e){this.a=d
this.b=e},
c9o:function c9o(d,e){this.a=d
this.b=e},
c9h:function c9h(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c9g:function c9g(d,e,f){this.a=d
this.b=e
this.c=f},
c9i:function c9i(d){this.a=d},
c9j:function c9j(d){this.a=d},
c9k:function c9k(d,e){this.a=d
this.b=e},
ER:function ER(d,e){this.a=d
this.b=e},
DO:function DO(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a3G:function a3G(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
c0R:function c0R(){},
c16:function c16(d,e){this.a=d
this.b=e},
c1a:function c1a(d){this.a=d},
c1b:function c1b(d){this.a=d},
c1c:function c1c(d,e,f){this.a=d
this.b=e
this.c=f},
c1e:function c1e(d){this.a=d},
c1f:function c1f(d){this.a=d},
c1d:function c1d(){},
c1h:function c1h(d){this.a=d},
c1g:function c1g(d){this.a=d},
c1i:function c1i(d,e){this.a=d
this.b=e},
c1k:function c1k(d){this.a=d},
c1l:function c1l(d){this.a=d},
c1j:function c1j(){},
c15:function c15(d,e,f){this.a=d
this.b=e
this.c=f},
c17:function c17(d,e,f){this.a=d
this.b=e
this.c=f},
c0Z:function c0Z(d){this.a=d},
c1_:function c1_(d){this.a=d},
c0Y:function c0Y(){},
c10:function c10(){},
c11:function c11(d,e){this.a=d
this.b=e},
c1q:function c1q(d){this.a=d},
c1r:function c1r(d){this.a=d},
c1s:function c1s(d,e){this.a=d
this.b=e},
c1p:function c1p(d){this.a=d},
c1t:function c1t(d,e){this.a=d
this.b=e},
c14:function c14(){},
c13:function c13(d){this.a=d},
c12:function c12(d,e){this.a=d
this.b=e},
c19:function c19(d){this.a=d},
c18:function c18(d){this.a=d},
c1m:function c1m(){},
c1n:function c1n(){},
c1o:function c1o(){},
c0S:function c0S(d,e,f){this.a=d
this.b=e
this.c=f},
c0T:function c0T(d){this.a=d},
c0V:function c0V(){},
c0U:function c0U(){},
c0W:function c0W(d){this.a=d},
c0X:function c0X(d){this.a=d},
E6:function E6(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
DN:function DN(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a3F:function a3F(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
c0A:function c0A(){},
c0J:function c0J(d,e){this.a=d
this.b=e},
c0K:function c0K(d){this.a=d},
c0I:function c0I(){},
c0M:function c0M(d){this.a=d},
c0L:function c0L(d,e){this.a=d
this.b=e},
c0N:function c0N(d,e){this.a=d
this.b=e},
c0E:function c0E(d,e){this.a=d
this.b=e},
c0F:function c0F(d,e,f){this.a=d
this.b=e
this.c=f},
c0G:function c0G(d,e,f){this.a=d
this.b=e
this.c=f},
c0B:function c0B(d,e,f){this.a=d
this.b=e
this.c=f},
c0C:function c0C(d,e,f){this.a=d
this.b=e
this.c=f},
c0D:function c0D(d,e){this.a=d
this.b=e},
c0H:function c0H(d){this.a=d},
c0O:function c0O(){},
c0P:function c0P(d,e){this.a=d
this.b=e},
c0Q:function c0Q(d,e){this.a=d
this.b=e},
DM:function DM(d){this.a=d},
a3E:function a3E(d){this.d=d
this.c=this.a=null},
c0r:function c0r(){},
c0y:function c0y(d){this.a=d},
c0z:function c0z(){},
c0x:function c0x(d,e){this.a=d
this.b=e},
c0w:function c0w(d,e,f){this.a=d
this.b=e
this.c=f},
c0v:function c0v(d,e,f){this.a=d
this.b=e
this.c=f},
c0u:function c0u(d){this.a=d},
c0s:function c0s(d){this.a=d},
c0t:function c0t(d){this.a=d},
can:function can(d){this.a=d},
cam:function cam(d){this.a=d},
cah:function cah(d,e){this.a=d
this.b=e},
caj:function caj(){},
cai:function cai(){},
cak:function cak(d,e){this.a=d
this.b=e},
cal:function cal(d,e){this.a=d
this.b=e},
akL:function akL(d){this.a=d},
b7L:function b7L(d){this.a=d},
caG:function caG(){},
caH:function caH(){},
DP:function DP(d,e,f){this.c=d
this.d=e
this.a=f},
a3H:function a3H(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
c1u:function c1u(d){this.a=d},
c1v:function c1v(d){this.a=d},
c1w:function c1w(d,e){this.a=d
this.b=e},
c1x:function c1x(d){this.a=d},
c1z:function c1z(d){this.a=d},
c1y:function c1y(d){this.a=d},
caF:function caF(){}},D,R,O,I,E,F
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
B.akM.prototype={
ri(){var x=this,w=x.a
if(w!=null)return A.et(w,y.m)
w=x.b
return w==null?x.b=new B.b7M(x).$0():w},
uE(d,e){return this.aP4(d,e,e)},
aP4(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
var $async$uE=A.e(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$uE)
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
r=B.cFp(s)
throw A.t(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$uE,w)},
ou(d,e){var x=A.eq(d[e])
if(x==null)x=null
return x===!0},
Nj(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$Nj=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.ri(),$async$Nj)
case 7:r=h.cW(g.cR(e,"support",null,null,null,null))
q=s.ou(r,"worker")
p=s.ou(r,"wasm")
o=s.ou(r,"mic")
n=s.ou(r,"audio")
s.ou(r,"webgpu")
m=s.ou(r,"secure")
s.ou(r,"ios")
l=A.jZ(r.memory)
if(l==null)l=null
if(l==null)l=0
s.ou(r,"isolated")
k=A.jZ(r.cores)
if(k!=null)C.f.al(k)
v=new B.Wu(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a4G
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Nj,w)},
EO(){var x=0,w=A.j(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$EO=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.ri(),$async$EO)
case 8:x=7
return A.c(m.eK(l.cW(k.cR(e,"storage",null,null,null,null)),y.A),$async$EO)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.al(A.dV(r.quota))
p=C.f.al(A.dV(r.usage))
v=new A.auU(q,p)
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
return A.i($async$EO,w)},
blP(){var x=y.K
A.Qw(this.ri().bJ(new B.b7P(),x),x)},
rh(d,e){var x=A.jZ(d[e])
x=x==null?null:C.f.al(x)
return x==null?0:x},
bjc(d,e,f){return this.uE(new B.b7O(this,d,e,f),y.C)},
galL(){var x,w
try{x=A.kv(b.G.sessionStorage)
return x}catch(w){return null}},
gatm(){var x=A.eq(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
aa_(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.eq(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gatm())return!1
l=A.eq(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cW(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.S(x.userAgent)
l=A.jZ(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.q(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aD("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.k(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aD("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.jZ(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.galL()
l=l==null?f:A.q(A.cR(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dX(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.kv(m.localStorage)
m=o
m=m==null?f:A.q(A.cR(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dX(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
arT(){var x,w,v,u,t,s,r=null
try{x=this.galL()
if(x!=null)A.cR(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cW(x.location)
u=A.S(v.hash)
t=A.S(v.search)
s=A.bu(A.S(A.cW(x.document).baseURI),0,r).a2("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cR(v,"replace",s+t+x,r,r,r)},
biV(){var x,w=null,v=b.G,u=A.cW(v.history),t=A.jZ(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cR(u,"back",w,w,w,w)
else{x=A.S(A.cW(v.document).baseURI)
A.cR(A.cW(v.location),"replace",A.bu(x,0,w).a2("./").k(0)+"#/",w,w,w)}},
aab(d,e,f,g,h){return this.uE(new B.b7T(this,e,d,f,h,g),y.H)},
aaf(){return this.uE(new B.b7U(this),y.D)},
a4l(){var x=null,w=this.a
if(w!=null)A.cR(w,"cancelRecording",x,x,x,x)},
ana(d){var x,w,v=this,u=A.q(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.rh(d,"ms")
w=A.jZ(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.KB(u,x,w,v.rh(d,"frames"),v.rh(d,"tokens"),v.ou(d,"retried"),v.rh(d,"encMs"),v.rh(d,"decMs"),v.rh(d,"featMs"))},
aju(d){var x={}
x.words=d
return x},
awt(d,e){return this.uE(new B.b7W(this,d,e),y._)},
bo0(d,e){return this.uE(new B.b7V(this,d,e),y._)},
Ln(d,e){return this.blV(d,e)},
blV(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Ln=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.ri(),$async$Ln)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.aj(d).i("av<1,o>")
o=A.a9(new A.av(d,new B.b7Q(),o),o.i("aW.E"))
x=11
return A.c(A.eK(A.cW(A.cR(r,"play",o,e,null,null)),y.y),$async$Ln)
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
return A.i($async$Ln,w)},
N0(){var x=null,w=this.a
if(w!=null)A.cR(w,"stopPlayback",x,x,x,x)},
JR(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.S(A.cR(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bna(){var x,w,v=null
try{x=this.a
if(x!=null)A.cR(x,"resetDevice",v,v,v,v)}catch(w){}},
a7B(d){var x=this.a
if(x!=null)A.cR(x,"prefetch",d,null,null,null)}}
B.Wu.prototype={}
B.Kz.prototype={
gn7(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.KB.prototype={
gTC(){var x=this,w=C.f.aB(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.KA.prototype={}
B.lN.prototype={
gl9(){var x,w=this.a
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
$ibM:1}
B.nO.prototype={
S(){return"WordStatus."+this.b}}
B.TA.prototype={}
B.n9.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Jb.prototype={
gMZ(){var x,w=this,v=w.d
if(v===$){x=new B.aYM(w).$0()
w.d!==$&&A.aq()
w.d=x
v=x}return v},
gKa(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a56&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbk3(){return J.h0(this.gMZ(),new B.aYL()).gM(0)},
gtF(){var x=this.a
return x.length!==0&&this.gbk3()===x.length&&this.gKa().length===0}}
B.FV.prototype={
S(){return"AyahStatus."+this.b}}
B.rK.prototype={}
B.akN.prototype={
a7c(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.rz():x},
b14(d){var x=this,w=B.b7Z(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cne(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
ar2(){var x=Date.now(),w=B.b7Z(new A.aR(x,0,!1))
x=this.c
return x===w||x===B.cne(w)?this.d:0},
avu(d,e,f,g){var x=this,w=new A.aR(Date.now(),0,!1),v=x.a7c(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.fn:D.pz,s=new B.rK(t,u,w.h6()),r=d*1000+e
x.a.p(0,r,s)
x.b.D(0,r)
x.b14(w)
return s},
a74(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cW[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rz():s).a===D.fn)++u}return u},
biT(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cW[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rz():s).a===D.pz)++u}return u},
gaut(){var x=this.a,w=A.y(x).i("c4<2>")
return new A.ai(new A.c4(x,w),new B.b8_(),w.i("ai<Y.E>")).gM(0)},
gaA6(){var x=this.a,w=A.y(x).i("bO<1>")
w=A.mA(new A.bO(x,w),new B.b80(),w.i("Y.E"),y.S)
w=A.eH(w,A.y(w).i("Y.E"))
x=A.a9(w,A.y(w).c)
C.b.lf(x)
return x},
du(){var x,w,v,u,t,s=this,r=y.N,q=A.D(r,y.L)
for(x=s.a,x=new A.eB(x,A.y(x).i("eB<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.a9(x,A.y(x).c)
return A.I(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
beL(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b6l(x,300,A.y(x).c),x=new A.Kf(J.at(x.a),x.b,A.y(x).i("Kf<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gG()
s=C.j.aI(t,1000)
t=C.j.a3(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.rz():q).a===D.fn?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.rz()
r=u.h(0,r)
o.push(A.I(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.rz():r).c.iG()],w,v))}return o},
bju(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.L)(d),++u){t=d[u]
s=A.ez(t.h(0,"surah"))*1000+A.ez(t.h(0,"ayah"))
r=w.h(0,C.j.aI(s,1000)*1000+C.j.a3(s,1000))
if((r==null?$.rz():r).c.iG()===t.h(0,"updated_at"))v.K(0,s)}},
bjC(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.at(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gG()
if(!u.b(s))continue
r=A.ar(s.h(0,"surah"))
q=r==null?null:C.f.bB(r)
r=A.ar(s.h(0,"ayah"))
p=r==null?null:C.f.bB(r)
o=A.dF(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cW[q-1].a[1])
if(r)continue
n=B.cL3(s.h(0,"status"))
if(n===D.py)continue
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
v.p(0,r,new B.rK(n,C.j.d1(l==null?0:l,0,100),o.h6()))
w.K(0,r)
t=!0}return t}}
B.Ws.prototype={
JA(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Ws(w,v,u,t,f==null?x.e:f)},
bcY(d){var x=null
return this.JA(x,x,d,x,x)},
aqy(d){var x=null
return this.JA(x,d,x,x,x)},
bd1(d){var x=null
return this.JA(x,x,x,x,d)},
bck(d){var x=null
return this.JA(d,x,x,x,x)},
bcZ(d){var x=null
return this.JA(x,x,x,d,x)},
du(){var x=this
return A.I(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.I8.prototype={
S(){return"ModelState."+this.b}}
B.Wt.prototype={
vQ(){var x=this.Q
return x==null?this.Q=new B.b81(this).$0():x},
qS(d){return this.ayj(d)},
ayj(d){var x=0,w=A.j(y.H),v=this
var $async$qS=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a5()
x=2
return A.c(A.ir("mt.tutor.settings",C.ap.hl(d.du(),null)),$async$qS)
case 2:return A.h(null,w)}})
return A.i($async$qS,w)},
A6(){var x=0,w=A.j(y.H),v=this,u
var $async$A6=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a5()
x=2
return A.c(A.ir("mt.tutor.progress",C.ap.hl(v.c.du(),null)),$async$A6)
case 2:u=v.as
if(u!=null)u.av()
v.as=A.cS(C.x,v.gaFb())
return A.h(null,w)}})
return A.i($async$A6,w)},
MJ(d,e,f){return this.az6(d,e,f)},
az6(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$MJ=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.aZ(d,e,f)
x=2
return A.c(A.ir("mt.tutor.last",C.ap.hl(A.I(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$MJ)
case 2:return A.h(null,w)}})
return A.i($async$MJ,w)},
Dw(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Dw=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.VY||n===D.k8){x=1
break}s.f=D.VY
s.y=null
s.a5()
u=4
n=A.lO().geK().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lO().geK().h(0,"tutor_threads")
p=A.dX(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bjc(new B.b82(s),n,p),$async$Dw)
case 7:s.x=e
s.f=D.k8
n=A.lO().geK().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.ru().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a8(m)
if(n instanceof B.lN){q=n
s.f=D.aVE
s.y=q
n=A.lO().geK().h(0,"debug")
if(n==="1")A.ru().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a5()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Dw,w)},
wN(){var x=0,w=A.j(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wN=A.e(function(a0,a1){if(a0===1){t.push(a1)
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
return A.c(p.aQ("quran_tutor_progress").d9("surah, ayah, status, perfect_count, updated_at"),$async$wN)
case 7:o=a1
n=r.c.bjC(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.beL()
if(J.aQ(l)===0){x=10
break}h=p
g=A.I(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.nh(h.x,k,k))
x=11
return A.c(f.bnz("quran_tutor_save",!1,g,i),$async$wN)
case 11:r.c.bju(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.ir("mt.tutor.progress",C.ap.hl(r.c.du(),null)),$async$wN)
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
return A.i($async$wN,w)},
LE(d){return this.bnc(d)},
bnc(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$LE=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.ce_(t.c.du()).du()
y.f.a(p.h(0,"rows")).en(0,new B.b83(d))
t.c=B.ce_(p)
x=2
return A.c(t.A6(),$async$LE)
case 2:v=4
s=$.C().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.aq("quran_tutor_reset",A.I(["p_surah",d],y.N,r),r),$async$LE)
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
return A.i($async$LE,w)}}
B.xd.prototype={
O(){var x=$.NG()
return new B.a17(x,new A.ag(C.G,$.V()))}}
B.a17.prototype={
W(){var x,w,v=this
v.Z()
x=v.d
x.ac(v.goG())
w=y.a
x.vQ().bJ(new B.bO3(v),w)
H.aXe().bJ(new B.bO4(v),w).fB(new B.bO5())
A.Qw(H.cdl(),y.y)},
y5(){if(this.c!=null)this.j(new B.bNQ())},
m(){var x,w=this
w.d.U(w.goG())
x=w.e
x.q$=$.V()
x.L$=0
w.a0()},
Qv(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$Qv=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qS(s.b.bcY(!0)),$async$Qv)
case 3:t=s.a
t.blP()
if(t.aa_()){t.arT()
x=1
break}s.Dw()
case 1:return A.h(v,w)}})
return A.i($async$Qv,w)},
y6(d,e,f){return this.aZK(d,e,f)},
b7Z(d){return this.y6(d,null,null)},
aZK(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$y6=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.H(y.q).f.Y(A.aE(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.W(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cOV(s,d),$async$y6)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.MJ(d,t.a,t.b),$async$y6)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aD(A.aH(new B.bNW(u,d,t),null,r),r),$async$y6)
case 8:if(u.c!=null)u.j(new B.bNX())
case 1:return A.h(v,w)}})
return A.i($async$y6,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gatm()&&!A.O(d,!1).vn())u.push(A.bP(x,x,x,x,C.z3,x,x,t.gbiU(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bP(x,x,x,x,D.avz,x,x,new B.bO_(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bP(x,x,x,x,C.iB,x,x,new B.bO0(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aIW
else w=t?this.aUv():this.aV6()
return L.y_(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aV6(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a4G
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b9Q,C.V],x)
for(t=0;t<4;++t){s=D.aLf[t]
u.push(new A.z(C.bu,A.A(A.a([A.aX(s.a,C.ao,p,18),C.O,new A.bX(1,C.af,A.d(s.b,p,p,p,p,p,G.a2c,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.J(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bDf,C.J,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bq(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,p,F.aP,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bq(C.f.al(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.J,A.d(q,p,p,p,p,p,A.bB(p,p,r?D.e3:C.cN,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.J,D.bCg],x))
x=A.a([new E.dG(u,C.a7,C.aM,p,!0,p),new E.dG(A.J(s,C.q,C.d,C.e,0,C.l),C.a7,C.aM,p,!1,p),D.bM0,C.J],x)
if(v!=null)x.push(new E.dG(A.d(v,p,p,p,p,p,D.bmJ,p,p,p),C.a7,C.aM,p,!1,p))
else x.push(A.fs(D.asm,D.bsH,this.gb_2(),A.el(C.w,C.ah,D.bcS,p,p,p,p)))
x.push(C.a5)
x.push(D.a4C)
return x},
aUv(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.N(r.a.a),p=q.length===0,o=p?C.rU:H.cs5(q),n=t.z,m=A.Q(v.amr(C.d8,E.bq(s.gaut())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bq(s.ar2()),k=s.c,j=Date.now()
k=k===B.b7Z(new A.aR(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.I9(t,!1,u),A.A(A.a([m,C.O,A.Q(v.amr(C.ls,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.v],j)
if(n!=null){t=H.kx(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bq(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bq(m)+"\u2013"+E.bq(l)
k.push(new E.dG(A.A(A.a([D.auF,C.a_,A.Q(A.J(A.a([D.boH,A.d(t+" \u2014 "+m,u,u,u,u,u,C.bA,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nW],j),C.h,C.d,C.e,0,u,u),C.a7,C.aM,new B.bNT(v,n),!0,u))}t=C.i.a9(0.08)
k.push(A.az(u,C.o,!1,u,!0,C.m,u,A.aB(),r,u,u,u,u,u,2,A.cK(u,new A.cp(4,A.v(14),C.L),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.uG,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.rf,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bNU(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.d_,!0,C.u,u,C.E,u,u,u,u))
k.push(C.v)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bya)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.RU(o[x]))
C.b.A(k,t)}else{t=A.a([D.aZ1,D.aZN,v.RU(1)],j)
for(w=114;w>=78;--w)t.push(v.RU(w))
t.push(C.J)
r=v.f
p=A.aX(r?C.yJ:C.lq,C.ao,u,u)
t.push(A.f8(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,u,C.ff,u,u,u),new B.bNV(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.RU(w))
C.b.A(k,t)}k.push(C.V)
k.push(D.CQ)
return k},
amr(d,e,f){var x=null,w=y.p
return new E.dG(A.A(A.a([A.aX(d,C.w,x,x),C.O,A.Q(A.J(A.a([A.d(e,x,x,x,x,x,C.bA,x,x,x),A.d(f,x,1,C.N,x,x,C.a2R,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a7,C.H,x,!1,x)},
RU(d){var x,w=null,v=this.d.c,u=I.cW[d-1].a[1],t=v.a74(d),s=t/u,r=y.p,q=A.am(A.dA(C.P,A.a([A.cbH(C.eC,G.cU,w,w,w,w,w,3,s,w),A.d(E.bq(d),w,w,w,w,w,P.a3d,w,w,w)],r),C.m,C.bn,w),36,36),p=A.d(H.kx(d),w,w,w,w,w,D.bhs,w,w,w)
if(t===0)x=E.bq(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bq(t)+" \u0645\u0646 "+E.bq(u)
r=A.a([q,C.cx,A.Q(A.J(A.a([p,A.d(x,w,w,w,w,w,A.bB(w,w,t===u?G.cU:C.cN,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bq(C.f.al(s*100))+"\u066a",w,w,w,w,w,D.a2H,w,w,w))
r.push(D.asu)
return new E.dG(A.A(r,C.h,C.d,C.e,0,w,w),C.qw,C.d6,new B.bNY(this,d),!1,w)}}
B.I9.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aYM
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.Nz(x),r,r,r,r,r,D.C_,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.DP(w,"model load",r))
x.push(C.J)
x.push(A.cj8(C.mr,r,q.gbjb()))
return new E.dG(A.J(x,C.q,C.d,C.e,0,C.l),C.a7,C.aM,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bq(C.f.al(u/1e6))+" \u0645\u0646 "+E.bq(C.f.al(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,r,C.p1,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fd(x,A.qn(C.eC,C.w,7,s?t:r,r),C.aB)],w)
if(!this.d)C.b.A(x,A.a([C.J,D.btz],w))
return new E.dG(A.J(x,C.q,C.d,C.e,0,C.l),C.a7,C.aM,r,!1,r)}}}
B.YT.prototype={
t(d){var x=null,w=D.e3.a9(0.1),v=A.v(14),u=A.aK(D.e3.a9(0.4),1)
return A.E(x,A.A(A.a([D.aui,C.O,A.Q(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,x,C.C6,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.G(w,x,u,v,x,x,x,C.n),x,x,x,C.aM,C.ad,x,x,x)}}
B.ER.prototype={
S(){return"_Phase."+this.b}}
B.DO.prototype={
O(){return new B.a3G($.NG(),D.mJ)}}
B.a3G.prototype={
gjg(){var x=this.e
return x===$?this.e=this.a.d:x},
gC5(){var x,w=this.a,v=w.f
w=w.c
x=this.gjg()
return H.Nx(w,x,v.yh(w,x)).b},
W(){var x,w=this
w.Z()
x=w.d
x.ac(w.goG())
x.vQ()
x.a.a7B(B.aBt(w.a.c,w.gjg()))},
y5(){if(this.c!=null)this.j(new B.c0R())},
m(){var x,w=this,v=w.d
v.U(w.goG())
x=w.Q
if(x!=null)x.av()
v=v.a
v.N0()
v.a4l()
w.a0()},
a_V(d){var x,w,v=this
if(v.f===D.vp)v.d.a.a4l()
x=v.d.a
x.N0()
w=v.Q
if(w!=null)w.av()
v.j(new B.c16(v,d))
x.a7B(B.aBt(v.a.c,d))
w=v.a
if(d<w.e)x.a7B(B.aBt(w.c,d+1))},
Sa(d){return this.aVZ(d)},
aVZ(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$Sa=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.vo){u.d.a.N0()
u.j(new B.c1a(u))
x=1
break}t=u.r!=null?D.jj:D.mJ
u.j(new B.c1b(u))
s=u.d
r=A.a([B.aBt(u.a.c,u.gjg())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.Ln(r,q),$async$Sa)
case 3:p=f
if(u.c==null||u.f!==D.vo){x=1
break}u.j(new B.c1c(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$Sa,w)},
QV(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$QV=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.k8){x=1
break}p=l.a
p.N0()
r=B.FB(s.gC5()).length
s.j(new B.c1e(s))
o=s.Q
if(o!=null)o.av()
s.Q=A.hf(C.f_,new B.c1f(s))
u=4
o=B.cfN(r)
n=A.du(0,0,0,350*r,0,0)
x=7
return A.c(p.aab(l.b.c,o,n,new B.c1g(s),new B.c1h(s)),$async$QV)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lN){q=l
l=s.Q
if(l!=null)l.av()
if(s.c!=null)s.j(new B.c1i(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$QV,w)},
C_(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$C_=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.vp){x=1
break}m=s.Q
if(m!=null)m.av()
s.j(new B.c1k(s))
s.Q=A.hf(C.iv,new B.c1l(s))
l=new A.Df()
$.FE()
l.op()
r=l
u=4
m=s.d.a
x=7
return A.c(m.aaf(),$async$C_)
case 7:q=e
if(q.b<0.8){s.b7Y("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.awt(q,B.FB(s.gC5()).length),$async$C_)
case 8:p=e
s.ch=A.du(0,0,r.ga5E(),0,0,0)
k=A.lO().geK().h(0,"debug")
if(k==="1"){o=B.csl(m.JR())
A.ru().$1("[tutor] "+s.a.c+":"+s.gjg()+" audio="+C.f.aB(q.b,1)+"s infer="+p.b+"ms total="+r.gCS()+"ms "+p.gTC()+" text="+p.a)
A.ru().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.aB(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aB(p.b/1000,2)+" \u062b\n"+p.gTC()+"\n"+A.n(o)+"\n"+p.a}s.agt(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lN){n=m
m=A.lO().geK().h(0,"debug")
if(m==="1")A.ru().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.JR())
s.a3b(B.Nz(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$C_,w)},
a3b(d,e){var x=this,w=x.Q
if(w!=null)w.av()
if(x.c==null)return
x.j(new B.c15(x,d,e))},
b7Y(d){return this.a3b(d,null)},
agt(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.av()
if(s.c==null)return
x=B.cql(s.gC5(),d)
r.a=null
if(C.c.N(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjg()
t=x.gtF()
r.a=w.avu(v,u,q.b.a,t)
q.A6()}s.j(new B.c17(r,s,x))},
Ov(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$Ov=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.k8){x=1
break}s.j(new B.c0Z(s))
l=s.Q
if(l!=null)l.av()
s.Q=A.hf(C.iv,new B.c1_(s))
k=new A.Df()
$.FE()
k.op()
r=k
u=4
l=g.a
x=7
return A.c(l.bo0(B.aBt(s.a.c,s.gjg()),B.FB(s.gC5()).length),$async$Ov)
case 7:q=e
p=B.csl(l.JR())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.aB(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aB(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.aB(r.gCS()/1000,2)+" \u062b)\n"+q.gTC()+"\n"+A.n(p)+"\n"+q.a
A.ru().$1("[tutor-debug] "+s.a.c+":"+s.gjg()+" audio="+C.f.aB(q.c,1)+"s infer="+q.b+"ms total="+r.gCS()+"ms "+q.gTC()+" text="+q.a)
A.ru().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.du(0,0,r.ga5E(),0,0,0)
s.agt(q.a)
n=s.r
if(n!=null){l=n.gtF()
j=n.b
i=A.aj(j).i("ai<1>")
j=A.a9(new A.ai(j,new B.c10(),i),i.i("Y.E"))
A.ru().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.c11(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lN){m=l
A.ru().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.JR())
s.a3b(B.Nz(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Ov,w)},
ga1U(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.rz():v).a!==D.fn)return!1}return!0},
t(d){var x,w=this,v=null,u=w.d,t=u.c.a7c(w.a.c,w.gjg()),s=u.b,r=s.d&&!w.x&&w.f!==D.jj,q=H.kx(w.a.c),p=y.p,o=A.a([A.bP(v,v,v,v,C.iB,v,v,new B.c1q(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aMd(),m=A.d("\u0622\u064a\u0629 "+E.bq(w.gjg()),v,v,v,v,v,C.mp,v,v,v),l=E.bq(w.gjg()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.aV,A.d("("+l+" \u0645\u0646 "+E.bq(k.e-k.d+1)+")",v,v,v,v,v,F.aP,v,v,v),C.bD,w.b_Q(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.v],p)
if(r)s.push(w.aUq())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.vp&&l!==D.pp}else l=!1
if(l)s.push(w.aJR(m))
else s.push(A.d(w.gC5()+" \ufd3f"+E.bq(w.gjg())+"\ufd3e",v,v,v,v,v,D.ky,C.Y,C.b8,v))}s=A.a([new B.I9(u,!0,v),n,C.B,new E.dG(A.J(s,C.ac,C.d,C.e,0,C.l),D.alb,C.aM,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.jj)s.push(w.b9s(n))
if(w.r!=null&&w.f===D.jj&&w.ch!=null){x=C.f.al(C.j.aI(w.ch.a,1000)/100)
s.push(new A.z(C.bu,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bq(C.j.aI(x,10))+"\u066b"+E.bq(C.j.a3(x,10)))+" \u062b",v,v,v,v,v,F.aP,C.Y,v,v),v))}n=w.as
if(n!=null)s.push(new A.z(C.aM,A.d(n,v,v,v,v,v,D.C_,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.DP(n,"check "+w.a.c+":"+w.gjg(),v))}s.push(w.aKr())
s.push(C.V)
s.push(A.iB(C.w,C.H,v,new B.c1r(w),D.bqq,D.bvT,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga1U()
s.push(new E.dG(A.A(A.a([D.aqW,C.a_,A.Q(A.J(A.a([D.bxx,A.d(w.ga1U()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,v,F.aP,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nW],p),C.h,C.d,C.e,0,v,v),C.a7,C.aM,new B.c1s(w,d),n,v))}n=A.lO().geK().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dg(D.asl,D.bvk,u.f===D.k8&&w.f!==D.pp?w.gaLa():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.z(C.hQ,A.qR(n,F.aP,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn7()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,v,F.aP,v,v,v))}p.push(A.b2(D.bwG,v,v,v,new B.c1t(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.CQ)
return L.y_(o,s,q)},
aMd(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.am(A.fn(new B.c13(this),w,null,C.ae,new B.c14()),36,null)},
b_Q(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fn)return D.ba2
x=d.b
w=E.bq(x)
v=E.bq(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c2:C.r4
u.push(new A.z(D.alV,A.aX(r,s?G.cU:C.eY,q,16),q))}return A.Kt(A.A(u,C.h,C.d,C.I,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aUq(){var x=null
return A.bv(!1,A.v(12),!0,A.E(x,D.agV,C.k,x,x,new A.G(C.q0,x,x,A.v(12),x,x,x,C.n),x,x,x,x,D.akJ,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.c19(this),x,x,x,x,x,x,x)},
aJR(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.as(d.gMZ(),w)
A:{if(D.jc===v){u=D.ky.cv(G.cU)
break A}if(D.v8===v){u=D.ky.a4Y(D.e3,C.fO,D.e3)
break A}if(D.v9===v){u=D.ky.a4Y(D.eW,C.fO,D.eW)
break A}u=D.ky.a4Y(C.eY,C.j6,C.c9)
break A}t=x[w]
r.push(new A.eT(t.a,s,s,C.bv,s,s,s,s,s,s,u))
r.push(O.BR)}x=E.bq(this.gjg())
r.push(A.ew(s,s,s,s,s,s,s,s,s,D.ky.cv(C.ao),"\ufd3f"+x+"\ufd3e"))
return A.Ds(A.ew(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Y,C.b8)},
b9s(d){var x,w,v,u,t,s,r=this.w
if(C.c.N(d.c).length===0)return D.bLn
if(d.gtF()){x=r==null
if((x?null:r.a)===D.fn&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fn?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bq(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.E6(G.cU,C.c2,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMZ()
w=J.dJ(x)
v=w.io(x,new B.c1m()).gM(0)
u=w.io(x,new B.c1n()).gM(0)
t=w.io(x,new B.c1o()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bq(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bq(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bq(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gKa().length!==0)x.push(E.bq(d.gKa().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eW:D.e3
x=C.b.au(x," \u2022 ")
s=d.gKa().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.au(d.gKa(),"\u060c "):""
return new B.E6(w,C.nM,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aKr(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.k8,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aI(new A.aR(f,0,!1).dE(w).a,1e6)}v=C.j.aI(B.cfN(B.FB(j.gC5()).length).a,1e6)
f=j.gb6x()
w=96+26*j.y
u=D.eW.a9(0.25)
w=A.hU(i,A.a6z(C.P,A.E(i,D.asy,C.k,i,i,D.a8D,i,84,i,i,i,i,i,84),i,C.aU,new A.G(u,i,i,i,i,i,i,C.bX),C.FM,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cv)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.ceH(x)+" / "+B.ceH(v),i,i,i,i,i,K.p0,i,i,i)
return A.J(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,i,F.aP,i,i,i),A.b2(D.bCf,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.eE((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bq(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bq(t)+" \u062b)"
return new A.z(C.qr,A.J(A.a([C.wh,C.V,D.bu1,A.d(h,i,i,i,i,i,F.aP,C.Y,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.vo
r=j.r
f=r==null
w=!f
q=w&&r.gtF()
u=A.aX(s?C.nN:K.Io,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i,i)
o=A.el(i,i,D.bcP,i,i,i,i)
u=A.Q(new A.Am(C.a5r,!0,new B.c0S(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Zw(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.K8[n]
p.push(new A.eg(m,i,A.d("\xd7"+E.bq(m),i,i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.O,A.nE(new B.c0T(j),p,A.dh([h.b.b],o),!1,A.kB(i,i,i,new A.bg(new B.c0U(),l),i,i,i,i,new A.bg(new B.c0V(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cR),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb1V():i
u=A.aX(f?D.r_:C.nM,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,i,C.cq,i,i,i)
p=q?C.is:C.w
h=A.a([o,C.v,A.fs(u,f,h,A.el(p,q?C.i:C.ah,D.ug,i,i,i,i))],k)
if(w&&j.gjg()<j.a.e)C.b.A(h,A.a([C.B,q?A.fs(D.avW,D.bAV,new B.c0W(j),A.el(G.cU,C.ah,D.ug,i,i,i,i)):A.b2(D.bqR,i,i,i,new B.c0X(j),i,i)],k))
if(w){f=j.gjg()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.z(C.hR,A.d(j.ga1U()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,i,K.uO,C.Y,i,i),i))
return A.J(h,C.ac,C.d,C.e,0,C.l)}}}
B.E6.prototype={
t(d){var x=this,w=null,v=x.c,u=v.a9(0.12),t=A.v(14),s=A.aK(v.a9(0.5),1),r=y.p
return A.E(w,A.A(A.a([A.aX(x.d,v,w,w),C.O,A.Q(A.J(A.a([A.d(x.e,w,w,w,w,w,A.bB(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.T,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bN,A.d(x.f,w,w,w,w,w,C.C6,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.G(u,w,s,t,w,w,w,C.n),w,w,w,C.aM,C.ad,w,w,w)}}
B.DN.prototype={
O(){var x=y.S
return new B.a3F($.NG(),A.D(x,y.B),A.aN(x),A.D(x,y.N),A.et(null,y.H))}}
B.a3F.prototype={
W(){this.Z()
this.d.ac(this.goG())},
y5(){if(this.c!=null)this.j(new B.c0A())},
m(){var x,w=this,v=w.d
v.U(w.goG())
x=w.y
if(x!=null)x.av()
v.a.a4l()
w.a0()},
IG(d){return this.b6g(d)},
b6g(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$IG=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.c0J(t,d))
r=t.y
if(r!=null)r.av()
t.y=A.hf(C.f_,new B.c0K(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.cfN(B.FB(H.Nx(q,d,p.yh(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.du(0,0,0,350*B.FB(H.Nx(p,d,o.yh(p,d)).b).length,0,0)
x=6
return A.c(r.a.aab(r.b.c,q,p,new B.c0L(t,d),new B.c0M(t)),$async$IG)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lN){s=r
r=t.y
if(r!=null)r.av()
if(t.c!=null)t.j(new B.c0N(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$IG,w)},
G2(d,e){return this.aNt(d,e)},
aNt(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$G2=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.av()
s.j(new B.c0E(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.aaf()
if(e&&n!=null)s.IG(n)
q=null
u=4
x=7
return A.c(r,$async$G2)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lN){p=o
s.j(new B.c0F(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bJ(new B.c0G(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$G2,w)},
gaYc(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b2Q(){this.j(new B.c0H(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.k8,o=s.e,n=s.gaYc(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("c4<2>")
x=new A.ai(new A.c4(m,l),new B.c0O(),l.i("ai<Y.E>")).gM(0)
l=H.kx(s.a.c)
m=y.p
q=A.a([new B.I9(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bq(s.a.d)+" \u0644\u062d\u062f "+E.bq(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,r,F.aP,r,r,r),C.v],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b8_(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,r,D.C_,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.DP(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bq(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aI(new A.aR(v,0,!1).dE(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.ceH(v),r,r,r,r,r,K.p0,C.Y,r,r)
j=A.fd(A.v(6),A.qn(C.eC,D.eW,6,s.x,r),C.aB)
u=o<s.a.e
t=A.aX(u?R.Ii:C.nN,r,r,r)
C.b.A(q,A.a([v,C.J,j,C.v,A.fs(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,r,C.cq,r,r,r),new B.c0P(s,o),A.el(C.w,C.ah,D.ug,r,r,r,r))],m))}else if(n!=null){j=p?new B.c0Q(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bq(n)
q.push(A.fs(D.atL,A.d(v,r,r,r,r,r,C.cq,r,r,r),j,A.el(C.w,C.ah,D.ug,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aZe)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cU:D.e3
v=k?C.nE:C.nM
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bq(x)
u=s.a
u=k+" \u0645\u0646 "+E.bq(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.E6(j,v,k,u,r),A.dg(D.avJ,D.bBA,s.gb2P(),r)],m))}q.push(C.v)
q.push(D.CQ)
return L.y_(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b8_(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.at3
else if(l.r.n(0,d))x=N.uj
else if(i!=null)x=D.atm
else if(j!=null){w=j.gtF()?C.c2:D.apt
x=A.aX(w,j.gtF()?G.cU:D.e3,k,k)}else x=D.arD
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bq(d),k,k,k,k,k,C.a2Z,k,k,k),C.bD,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,k,D.a2T,k,k,k))
if(j!=null&&!j.gtF()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMZ()
o=J.bb(p)
n=o.h(p,r)
A:{if(D.jc===n){m=G.cU
break A}if(D.v8===n){m=D.e3
break A}if(D.v9===n){m=D.eW
break A}m=C.eY
break A}m=D.ky.bdD(m,o.h(p,r)===D.va?C.j6:k,22)
C.b.A(t,A.a([new A.eT(q.a,k,k,C.bv,k,k,k,k,k,k,m),O.BR],u))}w=A.a([C.aj,A.Ds(A.ew(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Y,C.b8)],w)
if(C.c.N(j.c).length===0)w.push(D.bwV)
C.b.A(v,w)}return new E.dG(A.J(v,C.ac,C.d,C.e,0,C.l),C.bP,C.d6,k,!1,k)}}
B.DM.prototype={
O(){return new B.a3E($.NG())}}
B.a3E.prototype={
W(){this.Z()
var x=this.d
x.ac(this.goG())
x.vQ()},
y5(){if(this.c!=null)this.j(new B.c0r())},
m(){this.d.U(this.goG())
this.a0()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gaA6(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.i1(o,0,new B.c0y(q))
v=C.b.i1(o,0,new B.c0z())
o=y.p
o=A.a([A.A(A.a([A.Q(s.YM(E.bq(q.gaut()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.O,A.Q(s.YM(E.bq(q.ar2()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.O,A.Q(s.YM(E.bq(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.v,new E.dG(A.J(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bq(C.f.al(w*100/v))+"\u066a",r,r,r,r,r,C.bA,r,r,r),C.J,A.fd(A.v(6),A.qn(C.eC,G.cU,8,w/v,r),C.aB),C.aj,A.d(E.bq(w)+" \u0645\u0646 "+E.bq(v)+" \u0622\u064a\u0629",r,r,r,r,r,F.aP,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a7,C.aM,r,!1,r)],o)
if(p.length===0)o.push(D.aZu)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b81(p[t]))
o.push(C.B)
u=$.C().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,r,F.aP,r,r,r))
return L.y_(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
YM(d,e){var x=null
return new E.dG(A.J(A.a([A.d(d,x,x,x,x,x,D.blG,x,x,x),A.d(e,x,x,x,x,x,C.a3q,C.Y,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a7,C.H,x,!1,x)},
b81(d){var x=null,w=this.d.c,v=I.cW[d-1].a[1],u=w.a74(d),t=w.biT(d),s=y.p,r=A.A(A.a([A.Q(A.d(H.kx(d),x,x,x,x,x,C.bA,x,x,x),1),A.d(E.bq(C.f.al(u*100/v))+"\u066a",x,x,x,x,x,D.bmK,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fd(A.v(6),A.qn(C.eC,G.cU,7,u/v,x),C.aB),p=E.bq(u),o=E.bq(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bq(t):""
return new E.dG(A.J(A.a([r,C.J,q,C.aj,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,x,F.aP,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a7,C.aM,new B.c0x(this,d),!1,x)},
Oy(d){return this.aLw(d)},
aLw(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$Oy=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cW[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e4(C.cT,new B.c0w(v,d,u),t,!0,null,null,!1,y.H),$async$Oy)
case 2:return A.h(null,w)}})
return A.i($async$Oy,w)}}
B.akL.prototype={
S9(d,e){var x=null,w=A.jQ(x,x,x,x,x,x,x,x,x,x,x,D.bco,C.H,x,x,x,x,C.k7,x,x)
return A.b2(A.d(d,x,x,x,x,x,C.mo,x,x,x),x,x,x,new B.b7L(e),x,w)},
t(d){var x=this,w=y.p
return new E.dG(A.J(A.a([D.bAF,C.J,D.bCe,A.cI(C.aq,A.a([x.S9("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.S9("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aw,0,12),D.bq1,x.S9("tanzil.net","https://tanzil.net"),D.bDU,x.S9("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a7,C.aM,null,!1,null)}}
B.DP.prototype={
O(){return new B.a3H()}}
B.a3H.prototype={
gang(){var x=this.a
return B.cQg(x.c,x.d,$.cgp().JR())},
Sb(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$Sb=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.c1u(s))
v=3
r=A.c9N()
n=s.gang()
m=y.N
q=A.D(m,m)
J.e_(q,"app","mogtama3y")
J.e_(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.e_(q,"ua",m)}x=6
return A.c(A.abc(n,null,C.GT,q),$async$Sb)
case 6:if(s.c!=null)s.j(new B.c1v(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.c9?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.c1w(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.c1x(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Sb,w)},
t(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bv(!1,t,!0,new A.z(C.lb,A.A(A.a([A.aX(u.d?C.yJ:C.lq,C.c9,t,18),C.bM,D.bD2],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.c1z(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.E(t,A.qR(u.gang(),D.bhT,t,C.z),C.k,t,t,new A.G(C.q0,t,t,x,t,t,t,C.n),t,t,t,D.akM,C.eg,t,t,1/0))}if(u.f)s.push(D.bqk)
else{x=A.jQ(t,t,t,t,t,t,t,t,t,t,t,C.a1e,C.H,t,t,t,t,C.k7,t,t)
w=u.e
v=w?t:u.gb80()
s.push(A.f8(w?C.a1s:D.av7,t,D.bzD,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,t,D.a2T,t,t,t))
return new A.z(C.aM,A.J(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["al<~>()","~()","M(nO)","al<KB>()","al<Kz>()","al<KA>()","a6<nO>()","M(rK)","bH(oV)","DO(u)","DM(u)","M(n9)","DN(u)","M(Jb)"])
B.b7M.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.S(A.cW(b.G.document).baseURI)
q=A.bu(r,0,null).a2("quran_tutor/tutor.js?v=3").k(0)
x=7
return A.c(A.eK(import(q),y.m),$async$$0)
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
m=B.cFq("network",A.n(o))
throw A.t(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:314}
B.b7P.prototype={
$1(d){var x=null
return A.c44(A.cR(d,"persist",x,x,x,x))},
$S:1162}
B.b7O.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.ri(),$async$$0)
case 4:x=3
return A.c(n.eK(m.cW(l.cR(e,"loadModel",A.c4N(new B.b7N(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.q(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.q(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.rh(p,"ms")
r=q.ou(p,"cached")
A.q(p.backend)
v=new B.Kz(o,t,s,r,q.rh(p,"threads"),q.ou(p,"isolated"),q.rh(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b7N.prototype={
$2(d,e){this.a.$2(C.f.al(d),C.f.al(e))},
$S:1163}
B.b7T.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.ri(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aI(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aI(v.d.a,1000)
u.onLevel=A.fY(new B.b7R(v.e))
u.onAutoStop=A.fY(new B.b7S(v.f))
x=5
return A.c(A.eK(A.cW(A.cR(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b7R.prototype={
$1(d){return this.a.$1(d)},
$S:67}
B.b7S.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b7U.prototype={
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
return A.c(t.ri(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eK(p.cW(o.cR(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.KA(r,A.dV(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b7W.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.ri(),$async$$0)
case 4:x=3
return A.c(q.eK(p.cW(o.cR(e,"transcribe",t.audio,t.rate,s.aju(u.c),null)),y.m),$async$$0)
case 3:v=r.ana(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b7V.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.ri(),$async$$0)
case 4:x=3
return A.c(r.eK(q.cW(p.cR(e,"transcribeUrl",u.b,t.aju(u.c),null,null)),y.m),$async$$0)
case 3:v=s.ana(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b7Q.prototype={
$1(d){return d},
$S:35}
B.aYM.prototype={
$0(){var x,w,v,u,t=this.a,s=A.cb(t.a.length,D.va,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aYL.prototype={
$1(d){return d===D.jc},
$S:z+2}
B.c4w.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.caN(e[x],d[x])<0.75)return!1
return!0},
$S:1164}
B.c6D.prototype={
$1(d){return d.length!==0},
$S:10}
B.b8_.prototype={
$1(d){return d.a===D.fn},
$S:z+7}
B.b80.prototype={
$1(d){return C.j.aI(d,1000)},
$S:59}
B.b7Y.prototype={
$1(d){return C.f.bB(d)},
$S:1165}
B.b81.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iK("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.ap.f4(r,null))
j=A.ar(k.h(0,"n"))
j=j==null?null:C.f.bB(j)
j=C.j.d1(j==null?2:j,1,5)
i=C.b.n(D.K8,k.h(0,"r"))?A.ez(k.h(0,"r")):1
h=A.eq(k.h(0,"auto"))
g=A.eq(k.h(0,"hide"))
k=A.eq(k.h(0,"in"))
s.a.b=new B.Ws(j,i,h!==!1,g===!0,k===!0)}u=2
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
return A.c(A.iK("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.ce_(y.P.a(C.ap.f4(q,null)))
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
return A.c(A.iK("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.ap.f4(p,null))
n=C.f.bB(A.cT(J.as(o,"s")))
m=C.f.bB(A.cT(J.as(o,"f")))
l=C.f.bB(A.cT(J.as(o,"t")))
if(B.csq(n,m)&&B.csq(n,l)&&m<=l)s.a.z=new A.aZ(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.aa_()){k.a.arT()
x=1
break}a1=k
x=18
return A.c(k.a.Nj(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a5()
if(k.b.e)k.Dw()
k.wN()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:113}
B.b82.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a5()},
$S:1166}
B.b83.prototype={
$2(d,e){return C.j.aI(A.eJ(A.n(d),null,null),1000)===this.a},
$S:1167}
B.bO3.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.EO(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bO2(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1168}
B.bO2.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bO4.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bO1(x,d))},
$S:z+8}
B.bO1.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bO5.prototype={
$1(d){},
$S:25}
B.bNQ.prototype={
$0(){},
$S:0}
B.bNW.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.DO(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bNX.prototype={
$0(){},
$S:0}
B.bO_.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aD(A.aH(new B.bNZ(),null,x),x)},
$S:0}
B.bNZ.prototype={
$1(d){return D.bFi},
$S:z+10}
B.bO0.prototype={
$0(){return B.csc(this.a)},
$S:0}
B.bNT.prototype={
$0(){var x=this.b
return this.a.y6(x.a,x.b,x.c)},
$S:0}
B.bNU.prototype={
$1(d){return this.a.j(new B.bNS())},
$S:5}
B.bNS.prototype={
$0(){},
$S:0}
B.bNV.prototype={
$0(){var x=this.a
return x.j(new B.bNR(x))},
$S:0}
B.bNR.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bNY.prototype={
$0(){return this.a.b7Z(this.b)},
$S:0}
B.c9q.prototype={
$1(d){return new A.ji(new B.c9n(this.a,this.b,this.c),null)},
$S:56}
B.c9n.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c9p(u,e),s=this.a,r=new B.c9o(s,e),q=A.d(H.kx(this.c),v,v,v,v,v,C.oX,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bq(u)+" \u0622\u064a\u0629)",v,v,v,v,v,F.aP,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bq(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bq(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.aj,p,C.v,A.cI(C.aq,n,C.aw,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c9i(s)),C.a1p,t.$3("\u0644\u062d\u062f",s.c,new B.c9j(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aZj)
u.push(C.a5)
u.push(A.dd(D.btt,v,new B.c9k(s,d),A.el(C.w,C.ah,D.bcM,v,v,v,v)))
return A.cv(!0,new A.z(C.Gk,A.J(u,C.ac,C.d,C.I,0,C.l),v),C.H,!0)},
$S:286}
B.c9p.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,u,C.ic,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c6(v,A.d("\u0622\u064a\u0629 "+E.bq(v),u,u,u,u,u,u,u,u,u),C.ak,u,w))
return A.Q(A.J(A.a([t,Q.GR(C.cT,!0,s,320,new B.c9m(this.b,f),D.bn0,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1170}
B.c9m.prototype={
$1(d){return d==null?null:this.a.$1(new B.c9l(this.b,d))},
$S:51}
B.c9l.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c9o.prototype={
$3(d,e,f){var x=null
return A.aCl(x,A.d(d,x,x,x,x,x,x,x,x,x),new B.c9h(this.a,this.b,e,f))},
$S:1171}
B.c9h.prototype={
$0(){var x=this
return x.b.$1(new B.c9g(x.a,x.c,x.d))},
$S:0}
B.c9g.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c9i.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c9j.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c9k.prototype={
$0(){var x=this.a
return A.O(this.b,!1).ad(new A.W(x.b,x.c))},
$S:0}
B.c0R.prototype={
$0(){},
$S:0}
B.c16.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mJ
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.c1a.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.jj:D.mJ},
$S:0}
B.c1b.prototype={
$0(){var x=this.a
x.f=D.vo
x.as=null},
$S:0}
B.c1c.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.c1e.prototype={
$0(){var x=this.a
x.f=D.vp
x.as=null
x.y=0
x.z=new A.aR(Date.now(),0,!1)
x.ax=null},
$S:0}
B.c1f.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c1d())},
$S:27}
B.c1d.prototype={
$0(){},
$S:0}
B.c1h.prototype={
$1(d){return this.a.y=d},
$S:67}
B.c1g.prototype={
$1(d){return this.a.C_()},
$S:5}
B.c1i.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.jj:D.mJ
x=this.b
w.as=B.Nz(x)
w.at=x},
$S:0}
B.c1k.prototype={
$0(){var x=this.a
x.f=D.pp
x.ay=Date.now()},
$S:0}
B.c1l.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c1j())},
$S:27}
B.c1j.prototype={
$0(){},
$S:0}
B.c15.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.jj:D.mJ
x.as=this.b
x.at=this.c},
$S:0}
B.c17.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.jj
x.x=!1},
$S:0}
B.c0Z.prototype={
$0(){var x=this.a
x.f=D.pp
x.ay=Date.now()
x.as=null},
$S:0}
B.c1_.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c0Y())},
$S:27}
B.c0Y.prototype={
$0(){},
$S:0}
B.c10.prototype={
$1(d){return d.d!==D.jc},
$S:z+11}
B.c11.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.c1q.prototype={
$0(){return B.csc(this.a)},
$S:0}
B.c1r.prototype={
$1(d){var x=this.a.d
return x.qS(x.b.aqy(d))},
$S:3}
B.c1s.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aD(A.aH(new B.c1p(this.a),null,x),x)},
$S:0}
B.c1p.prototype={
$1(d){var x=this.a.a
return new B.DN(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.c1t.prototype={
$0(){this.a.d.a.bna()
this.b.H(y.q).f.Y(D.bdW)},
$S:0}
B.c14.prototype={
$2(d,e){return C.aV},
$S:18}
B.c13.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a7c(s.c,r).a.a){case 2:s=G.cU
break
case 1:s=D.e3
break
case 0:s=C.is
break
default:s=u}x=A.v(18)
w=t.f===D.pp?u:new B.c12(t,r)
v=s.a9(0.25)
if(r===t.gjg())s=C.i
s=A.aK(s,r===t.gjg()?2:1)
return A.bv(!1,x,!0,A.E(C.P,A.d(E.bq(r),u,u,u,u,u,C.a2x,u,u,u),C.k,u,u,new A.G(v,u,s,u,u,u,u,C.bX),u,u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:68}
B.c12.prototype={
$0(){return this.a.a_V(this.b)},
$S:0}
B.c19.prototype={
$0(){var x=this.a
return x.j(new B.c18(x))},
$S:0}
B.c18.prototype={
$0(){return this.a.x=!0},
$S:0}
B.c1m.prototype={
$1(d){return d===D.v8},
$S:z+2}
B.c1n.prototype={
$1(d){return d===D.v9},
$S:z+2}
B.c1o.prototype={
$1(d){return d===D.va},
$S:z+2}
B.c0S.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Sa(x)},
$S:0}
B.c0T.prototype={
$1(d){var x=this.a.d
return x.qS(x.b.bd1(d.ga1(d)))},
$S:115}
B.c0V.prototype={
$1(d){return d.n(0,C.U)?C.ah:C.i},
$S:4}
B.c0U.prototype={
$1(d){return d.n(0,C.U)?C.w:C.a8},
$S:4}
B.c0W.prototype={
$0(){var x=this.a
return x.a_V(x.gjg()+1)},
$S:0}
B.c0X.prototype={
$0(){var x=this.a
return x.a_V(x.gjg()+1)},
$S:0}
B.c0A.prototype={
$0(){},
$S:0}
B.c0J.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aR(Date.now(),0,!1)},
$S:0}
B.c0K.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c0I())},
$S:27}
B.c0I.prototype={
$0(){},
$S:0}
B.c0M.prototype={
$1(d){return this.a.x=d},
$S:67}
B.c0L.prototype={
$1(d){return this.a.G2(this.b,!1)},
$S:5}
B.c0N.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.Nz(x)
w.as=x},
$S:0}
B.c0E.prototype={
$0(){var x=this.a
x.e=null
x.r.D(0,this.b)},
$S:0}
B.c0F.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.Nz(x))
w.as=x},
$S:0}
B.c0G.prototype={
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
return A.c(n.a.awt(s.b,B.FB(H.Nx(l,m,k.yh(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cql(H.Nx(l,m,k.yh(l,m)).b,r.a)
if(C.c.N(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtF()
l.avu(k,m,n.b.a,j)}n.A6()
if(o.c!=null)o.j(new B.c0B(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lN){p=o
o=s.a
if(o.c!=null)o.j(new B.c0C(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.c0D(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:148}
B.c0B.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.c0C.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.Nz(w))
x.as=w},
$S:0}
B.c0D.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.c0H.prototype={
$0(){var x=this.a
x.f.ao(0)
x.w.ao(0)
x.as=null},
$S:0}
B.c0O.prototype={
$1(d){return d.gtF()},
$S:z+13}
B.c0P.prototype={
$0(){return this.a.G2(this.b,!0)},
$S:0}
B.c0Q.prototype={
$0(){return this.a.IG(this.b)},
$S:0}
B.c0r.prototype={
$0(){},
$S:0}
B.c0y.prototype={
$2(d,e){return d+this.a.a74(e)},
$S:116}
B.c0z.prototype={
$2(d,e){return d+I.cW[e-1].a[1]},
$S:116}
B.c0x.prototype={
$0(){return this.a.Oy(this.b)},
$S:0}
B.c0w.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kx(p),q,q,q,q,q,C.oX,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.b9(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.rz():r).a.a){case 2:r=G.cU.a9(0.35)
break
case 1:r=D.e3.a9(0.35)
break
case 0:r=C.h1
break
default:r=q}m.push(A.E(C.P,A.d(E.bq(t),q,q,q,q,q,C.kw,q,q,q),C.k,q,q,new A.G(r,q,q,new A.cE(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,q,38))}return A.cv(!0,new A.z(C.h7,A.J(A.a([o,C.aj,D.bxQ,C.v,new A.dm(D.a8t,A.f2(A.cI(C.aq,m,C.aw,6,6),q,C.r,q,q,q,C.y),q),C.V,A.b2(D.bzG,q,q,q,new B.c0v(w,d,p),q,q)],n),C.ac,C.d,C.I,0,C.l),q),C.H,!0)},
$S:37}
B.c0v.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.da(null,null,!0,null,new B.c0u(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.LE(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e5()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.c0u.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kx(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x,x)
return A.di(A.a([A.b2(C.ev,x,x,x,new B.c0s(d),x,x),A.b2(C.pc,x,x,x,new B.c0t(d),x,x)],y.p),w,D.bBi)},
$S:14}
B.c0s.prototype={
$0(){A.O(this.a,!1).ad(!1)
return null},
$S:0}
B.c0t.prototype={
$0(){A.O(this.a,!1).ad(!0)
return null},
$S:0}
B.can.prototype={
$1(d){var x=this.a
return new A.kO(new B.cam(x),null,x,null)},
$S:1172}
B.cam.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.eg(w,t,A.d(E.bq(w),t,t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bpX,C.V,D.bA5,C.J,A.nE(new B.cah(s,r),q,A.dh([r.a],x),!1,A.kB(t,t,t,new A.bg(new B.cai(),v),t,t,t,t,new A.bg(new B.caj(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.iB(C.w,C.H,t,new B.cak(s,r),D.bx5,D.bDj,r.c),A.iB(C.w,C.H,t,new B.cal(s,r),t,D.bpp,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.aj,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn7(),t,t,t,t,t,F.aP,t,C.b8,t)],u))
x.push(C.B)
x.push(D.a4C)
return A.cv(!0,A.f2(A.J(x,C.ac,C.d,C.e,0,C.l),t,C.r,C.h7,t,t,C.y),C.H,!0)},
$S:1173}
B.cah.prototype={
$1(d){return this.a.qS(this.b.bcZ(d.ga1(d)))},
$S:115}
B.caj.prototype={
$1(d){return d.n(0,C.U)?C.ah:C.i},
$S:4}
B.cai.prototype={
$1(d){return d.n(0,C.U)?C.w:C.a8},
$S:4}
B.cak.prototype={
$1(d){return this.a.qS(this.b.bck(d))},
$S:3}
B.cal.prototype={
$1(d){return this.a.qS(this.b.aqy(d))},
$S:3}
B.b7L.prototype={
$0(){return A.cn(A.bu(this.a,0,null),C.aK,null)},
$S:0}
B.caG.prototype={
$1(d){var x,w=A.aD("https?://",!0,!1,!1)
w=A.bF(d,w,"")
x=A.aD("www\\.",!0,!1,!1)
return A.vc(A.bF(w,x,"www[.]"),A.aD("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.caH(),null)},
$S:35}
B.caH.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:57}
B.c1u.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.c1v.prototype={
$0(){return this.a.f=!0},
$S:0}
B.c1w.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.c1x.prototype={
$0(){return this.a.e=!1},
$S:0}
B.c1z.prototype={
$0(){var x=this.a
return x.j(new B.c1y(x))},
$S:0}
B.c1y.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.caF.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:179};(function installTearOffs(){var x=a._instance_0u
x(B.akM.prototype,"gbiU","biV",1)
var w
x(w=B.Wt.prototype,"gbjb","Dw",0)
x(w,"gaFb","wN",0)
x(w=B.a17.prototype,"goG","y5",1)
x(w,"gb_2","Qv",0)
x(w=B.a3G.prototype,"goG","y5",1)
x(w,"gb1V","QV",0)
x(w,"gb6x","C_",0)
x(w,"gaLa","Ov",0)
x(w=B.a3F.prototype,"goG","y5",1)
x(w,"gb2P","b2Q",1)
x(B.a3E.prototype,"goG","y5",1)
x(B.a3H.prototype,"gb80","Sb",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a7,[B.akM,B.Wu,B.Kz,B.KB,B.KA,B.lN,B.TA,B.n9,B.Jb,B.rK,B.akN,B.Ws])
x(A.lm,[B.b7M,B.b7O,B.b7T,B.b7U,B.b7W,B.b7V,B.aYM,B.b81,B.bO2,B.bO1,B.bNQ,B.bNX,B.bO_,B.bO0,B.bNT,B.bNS,B.bNV,B.bNR,B.bNY,B.c9l,B.c9h,B.c9g,B.c9k,B.c0R,B.c16,B.c1a,B.c1b,B.c1c,B.c1e,B.c1d,B.c1i,B.c1k,B.c1j,B.c15,B.c17,B.c0Z,B.c0Y,B.c11,B.c1q,B.c1s,B.c1t,B.c12,B.c19,B.c18,B.c0S,B.c0W,B.c0X,B.c0A,B.c0J,B.c0I,B.c0N,B.c0E,B.c0F,B.c0B,B.c0C,B.c0D,B.c0H,B.c0P,B.c0Q,B.c0r,B.c0x,B.c0v,B.c0s,B.c0t,B.b7L,B.c1u,B.c1v,B.c1w,B.c1x,B.c1z,B.c1y])
x(A.iP,[B.b7P,B.b7R,B.b7S,B.b7Q,B.aYL,B.c6D,B.b8_,B.b80,B.b7Y,B.bO3,B.bO4,B.bO5,B.bNW,B.bNZ,B.bNU,B.c9q,B.c9p,B.c9m,B.c9o,B.c9i,B.c9j,B.c1f,B.c1h,B.c1g,B.c1l,B.c1_,B.c10,B.c1r,B.c1p,B.c1m,B.c1n,B.c1o,B.c0T,B.c0V,B.c0U,B.c0K,B.c0M,B.c0L,B.c0G,B.c0O,B.c0w,B.c0u,B.can,B.cah,B.caj,B.cai,B.cak,B.cal,B.caG,B.caH,B.caF])
x(A.oh,[B.b7N,B.c4w,B.b82,B.b83,B.c9n,B.c14,B.c13,B.c0y,B.c0z,B.cam])
x(A.Eo,[B.nO,B.FV,B.I8,B.ER])
w(B.Wt,A.i9)
x(A.K,[B.xd,B.DO,B.DN,B.DM,B.DP])
x(A.N,[B.a17,B.a3G,B.a3F,B.a3E,B.a3H])
x(A.a3,[B.I9,B.YT,B.E6,B.akL])})()
A.px(b.typeUniverse,JSON.parse('{"lN":{"bM":[]},"DO":{"K":[],"l":[]},"DN":{"K":[],"l":[]},"DM":{"K":[],"l":[]},"DP":{"K":[],"l":[]},"Wt":{"aI":[]},"xd":{"K":[],"l":[]},"a17":{"N":["xd"]},"I9":{"a3":[],"l":[]},"YT":{"a3":[],"l":[]},"a3G":{"N":["DO"]},"E6":{"a3":[],"l":[]},"a3F":{"N":["DN"]},"a3E":{"N":["DM"]},"akL":{"a3":[],"l":[]},"a3H":{"N":["DP"]}}'))
var y=(function rtii(){var x=A.af
return{u:x("rK"),c:x("eg<x>"),r:x("c6<x>"),k:x("H<n9>"),n:x("H<eg<x>>"),I:x("H<c6<x>>"),R:x("H<hV>"),Z:x("H<aA<o,@>>"),d:x("H<TA>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bT"),j:x("a6<@>"),L:x("a6<x>"),P:x("aA<o,@>"),f:x("aA<@,@>"),x:x("av<o,x>"),a:x("bH"),K:x("a7"),B:x("Jb"),l:x("+(x,x)"),e:x("d6<n9>"),N:x("o"),C:x("Kz"),D:x("KA"),X:x("Wu"),_:x("KB"),U:x("ai<o>"),G:x("nO"),q:x("pu"),b:x("bg<U?>"),y:x("M"),i:x("a2"),z:x("@"),S:x("x"),A:x("bT?"),Y:x("aA<@,@>?"),O:x("a7?"),M:x("+quota,usage(x,x)?"),o:x("dK"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.py=new B.FV(0,"none")
D.pz=new B.FV(1,"learning")
D.fn=new B.FV(2,"memorized")
D.a8t=new A.aC(0,1/0,0,320)
D.eW=new A.U(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.t)
D.a8D=new A.G(D.eW,null,null,null,null,null,null,C.bX)
D.e3=new A.U(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.t)
D.aul=new A.F(C.yU,null,C.c9,null,null,null)
D.bBq=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.ff,null,null,null,null,null,null,null,null)
D.bim=new A.r(!0,C.eY,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bxS=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bim,null,null,null,null,null,null,null,null)
D.aMl=x([D.aul,C.J,D.bBq,D.bxS],y.p)
D.agV=new A.fk(C.y,C.d,C.e,C.h,null,C.l,null,0,D.aMl,null)
D.akJ=new A.T(0,26,0,26)
D.akM=new A.T(0,4,0,6)
D.alb=new A.T(14,12,14,14)
D.alV=new A.T(3,0,0,0)
D.apt=new A.R(63251,"MaterialIcons",null,!1)
D.r_=new A.R(63677,"MaterialIcons",null,!1)
D.aqh=new A.R(983209,"MaterialIcons",null,!1)
D.aqW=new A.F(D.aqh,28,C.w,null,null,null)
D.arD=new A.F(C.I1,null,C.is,null,null,null)
D.apc=new A.R(62961,"MaterialIcons",null,!1)
D.asl=new A.F(D.apc,null,null,null,null,null)
D.apr=new A.R(63199,"MaterialIcons",null,!1)
D.asm=new A.F(D.apr,null,null,null,null,null)
D.asu=new A.F(C.jO,null,C.eY,null,null,null)
D.asy=new A.F(C.nN,44,C.i,null,null,null)
D.at3=new A.F(D.r_,null,D.eW,null,null,null)
D.atm=new A.F(C.lp,null,D.eW,null,null,null)
D.atL=new A.F(D.r_,null,null,null,null,null)
D.aui=new A.F(C.hU,20,D.e3,null,null,null)
D.auF=new A.F(C.nK,30,C.w,null,null,null)
D.av7=new A.F(C.lv,16,C.w,null,null,null)
D.avz=new A.F(C.HY,null,null,null,null,null)
D.avJ=new A.F(C.nM,null,null,null,null,null)
D.avW=new A.F(C.HL,null,null,null,null,null)
D.K8=x([1,3,5],y.t)
D.KW=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aZY=new A.z(C.iy,C.mV,null)
D.aIW=x([D.aZY],y.p)
D.b3v=new A.W(C.nG,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b3i=new A.W(D.r_,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b3Q=new A.W(C.d8,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.b43=new A.W(C.I0,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aLf=x([D.b3v,D.b3i,D.b3Q,D.b43],A.af("H<+(R,o)>"))
D.aNN=x([D.py,D.pz,D.fn],A.af("H<FV>"))
D.PE=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aVD=new B.I8(0,"idle")
D.VY=new B.I8(1,"loading")
D.k8=new B.I8(2,"ready")
D.aVE=new B.I8(3,"failed")
D.at1=new A.F(C.c2,18,G.cU,null,null,null)
D.bCr=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uO,null,null,null,null,null,null,null,null)
D.aHK=x([D.at1,C.aV,D.bCr],y.p)
D.baa=new A.ec(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aHK,null)
D.aYM=new A.z(C.aM,D.baa,null)
D.alT=new A.T(2,6,2,4)
D.bi2=new A.r(!0,C.w,null,null,null,null,14,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bpT=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bi2,null,null,null,null,null,null,null,null)
D.aZ1=new A.z(D.alT,D.bpT,null)
D.bCR=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.ff,null,null,null,null,null,null,null,null)
D.aJi=x([N.uj,C.O,D.bCR],y.p)
D.ba4=new A.ec(C.ae,C.cf,C.e,C.h,null,C.l,null,0,D.aJi,null)
D.aZe=new A.z(C.la,D.ba4,null)
D.Ce=new A.r(!0,D.e3,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bDb=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Ce,null,null,null,null,null,null,null,null)
D.aZj=new A.z(C.dp,D.bDb,null)
D.bCm=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aP,C.Y,null,null,null,null,null,null,null)
D.aZu=new A.z(C.C,D.bCm,null)
D.alQ=new A.T(2,0,2,8)
D.by9=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aP,null,null,null,null,null,null,null,null)
D.aZN=new A.z(D.alQ,D.by9,null)
D.avg=new A.F(C.lt,30,C.w,null,null,null)
D.bDV=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Cf,null,null,null,null,null,null,null,null)
D.an1=new A.bX(1,C.af,D.bDV,null)
D.aJy=x([D.avg,C.a_,D.an1],y.p)
D.b9Q=new A.ec(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aJy,null)
D.auS=new A.F(C.d8,18,G.cU,null,null,null)
D.a2H=new A.r(!0,G.cU,null,null,null,null,12,C.R,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bC4=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a2H,null,null,null,null,null,null,null,null)
D.aIc=x([D.auS,C.bM,D.bC4],y.p)
D.ba2=new A.ec(C.ae,C.d,C.I,C.h,null,C.l,null,0,D.aIc,null)
D.bco=new A.X(0,30)
D.ug=new A.X(1/0,54)
D.bcM=new A.X(1/0,48)
D.bcP=new A.X(1/0,50)
D.bcS=new A.X(1/0,52)
D.bzQ=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.bdW=new A.cV(D.bzQ,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.bhs=new A.r(!0,C.i,null,null,null,null,14.5,C.R,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhT=new A.r(!0,C.ao,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.C_=new A.r(!0,D.eW,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.ky=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a2T=new A.r(!0,D.eW,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.blG=new A.r(!0,C.w,null,null,null,null,24,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmJ=new A.r(!0,D.e3,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmK=new A.r(!0,G.cU,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bn0=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.boH=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.ic,null,null,null,null,null,null,null,null)
D.bpp=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.d_,null,null,null,null,null,null,null,null)
D.bpX=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oX,null,null,null,null,null,null,null,null)
D.bq1=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aP,null,null,null,null,null,null,null,null)
D.bje=new A.r(!0,G.cU,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bqk=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bje,null,null,null,null,null,null,null,null)
D.bqq=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aP,null,null,null,null,null,null,null,null)
D.bqR=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.ff,null,null,null,null,null,null,null,null)
D.bsH=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cq,null,null,null,null,null,null,null,null)
D.btt=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bE,null,null,null,null,null,null,null,null)
D.btz=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aP,null,null,null,null,null,null,null,null)
D.bu1=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.uP,null,null,null,null,null,null,null,null)
D.bvk=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bvT=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.p0,null,null,null,null,null,null,null,null)
D.bwG=new A.m("reset safe mode / WebGPU ban",null,C.BT,null,null,null,null,null,null,null,null)
D.bwV=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Ce,null,null,null,null,null,null,null,null)
D.bx5=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aP,null,null,null,null,null,null,null,null)
D.bxx=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bA,null,null,null,null,null,null,null,null)
D.bxQ=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aP,null,null,null,null,null,null,null,null)
D.bya=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aP,null,null,null,null,null,null,null,null)
D.bzD=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a3j,null,null,null,null,null,null,null,null)
D.bkS=new A.r(!0,D.eW,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bzG=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bkS,null,null,null,null,null,null,null,null)
D.bA5=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.p0,null,null,null,null,null,null,null,null)
D.bAF=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a29,null,null,null,null,null,null,null,null)
D.bAV=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cq,null,null,null,null,null,null,null,null)
D.bBi=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bBA=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bCe=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aP,null,null,null,null,null,null,null,null)
D.bCf=new A.m("\u062e\u0644\u0635\u062a",null,C.mp,null,null,null,null,null,null,null,null)
D.bCg=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Ce,null,null,null,null,null,null,null,null)
D.blZ=new A.r(!0,C.cN,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.fO,null,null,null,null,null,null,null,null)
D.bD2=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.blZ,null,null,null,null,null,null,null,null)
D.bDf=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bA,null,null,null,null,null,null,null,null)
D.bDj=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.d_,null,null,null,null,null,null,null,null)
D.bDU=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aP,null,null,null,null,null,null,null,null)
D.a4C=new B.akL(null)
D.bFi=new B.DM(null)
D.bFj=new B.Ws(2,1,!0,!1,!1)
D.a4G=new B.Wu(!1,!1,!1,!1,!1,0)
D.jc=new B.nO(0,"ok")
D.v8=new B.nO(1,"near")
D.v9=new B.nO(2,"wrong")
D.va=new B.nO(3,"missing")
D.a56=new B.nO(4,"extra")
D.apI=new A.R(63456,"MaterialIcons",null,!1)
D.bLn=new B.E6(D.e3,D.apI,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bM0=new B.YT(!1,null)
D.CQ=new B.YT(!0,null)
D.mJ=new B.ER(0,"idle")
D.vo=new B.ER(1,"playing")
D.vp=new B.ER(2,"recording")
D.pp=new B.ER(3,"thinking")
D.jj=new B.ER(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cTg","cgp",()=>new B.akM())
x($,"cWK","cwa",()=>A.aD("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cWL","cwb",()=>A.aD("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cWX","cwk",()=>A.aD("\u0648\u0670",!0,!1,!1))
x($,"cWi","cvR",()=>A.aD("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cUy","cuF",()=>A.aD("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cVO","cvt",()=>A.aD("[\u0654\u0655]",!0,!1,!1))
x($,"cUz","cuG",()=>A.aD("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cUG","cuM",()=>A.aD("[\u0624\u0626]",!0,!1,!1))
x($,"cVQ","cvv",()=>A.aD("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cWn","cvU",()=>A.aD("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cVY","cvC",()=>A.aD("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cWI","ch0",()=>A.aD("\\s+",!0,!1,!1))
x($,"cQz","rz",()=>B.cxb(D.py,0,A.cbX(0,!0)))
x($,"cTh","NG",()=>new B.Wt($.cgp(),D.bFj,B.cFr(),D.aVD,$.V()))})()};
(a=>{a["a+nB8G9UQYYf3Iqu2k/BWMN12tU="]=a.current})($__dart_deferred_initializers__);