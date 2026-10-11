((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,R,G,H,N,O,S,K,B={
cuu(d){var x,w,v,u,t,s
if(d instanceof B.lr)return d
try{x=A.cV(d)
w=x.code
v=x.message
u=w==null?"failed":A.a0(w)
t=v==null?"":A.a0(v)
return new B.lr(u,t)}catch(s){u=A.n(d)
return new B.lr("failed",u)}},
ahI:function ahI(){this.b=this.a=null},
b3a:function b3a(d){this.a=d},
b3d:function b3d(){},
b3c:function b3c(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b3b:function b3b(d){this.a=d},
b3h:function b3h(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b3f:function b3f(d){this.a=d},
b3g:function b3g(d){this.a=d},
b3i:function b3i(d){this.a=d},
b3k:function b3k(d,e,f){this.a=d
this.b=e
this.c=f},
b3j:function b3j(d,e,f){this.a=d
this.b=e
this.c=f},
b3e:function b3e(){},
cuv(d,e){return new B.lr(d,e)},
Us:function Us(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
IU:function IU(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
IW:function IW(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
IV:function IV(d,e){this.a=d
this.b=e},
lr:function lr(d,e){this.a=d
this.b=e},
ch2(d){var x,w=$.clF()
w=A.bB(d,w,"\u0627")
x=$.clG()
w=A.bB(w,x,"\u064a")
x=$.clP()
w=A.bB(w,x,"\u0627")
x=$.ckb()
w=A.bB(w,x,"\u0627")
x=$.cll()
w=A.bB(w,x,"\u0621")
x=$.ckY()
w=A.bB(w,x,"\u0621")
x=$.ckc()
w=A.bB(w,x,"\u0627")
x=$.cki()
w=A.bB(w,x,"\u0621")
w=A.bB(w,"\u0649","\u064a")
w=A.bB(w,"\u0629","\u0647")
x=$.cl_()
w=A.bB(w,x,"")
x=$.clo()
w=A.bB(w,x," ")
x=$.cl6()
w=A.bB(w,x," ")
x=$.c76()
return C.c.O(A.bB(w,x," "))},
czb(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kk(x,w)
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
c10(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aB("[\u0627\u0621]",!0,!1,!1)
w=A.bB(d,x,"")
x=A.aB("[\u0627\u0621]",!0,!1,!1)
v=A.bB(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.czb(d,e)/u
return s>=1?0.99:s},
Eb(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tA(d,$.c76()),w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.length===0)continue
t=B.ch2(u)
s=A.bB(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Rx(r.a+" "+u,r.b))}continue}q.push(new B.Rx(u,s))}return q},
cxU(d,e){var x,w,v,u,t=new B.bWF(),s=A.a([],y.s)
for(x=A.fL(e,0,A.iJ(5,"count",y.S),A.ak(e).c),w=x.$ti,x=new A.c9(x,x.gM(0),w.i("c9<aZ.E>")),w=w.i("aZ.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.Jb)&&t.$2(d,D.Jb)?C.b.jR(d,5):d
return!t.$2(s,D.NP)&&t.$2(u,D.NP)?C.b.jR(u,4):u},
cg5(d,e){var x=B.Eb(d),w=B.ch2(e),v=y.U
v=A.aa(new A.am(A.a(w.split(" "),y.s),new B.bYE(),v),v.i("Y.E"))
return new B.Hv(x,B.cx4(x,B.cxU(v,x)),w)},
cx4(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.K)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.ck(x,0,!1,s)
q=A.ck(x,0,!1,y.S)
p=A.ck(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c10(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c10(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c10(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.iS
else m=a2>=0.6?D.um:D.un
a1.push(new B.mG(o,x,s,m))
break
case 1:--o
a1.push(new B.mG(o,a4[o],null,D.uo))
break
case 2:--n
a1.push(new B.mG(null,null,a6[n],D.a3d))
break
case 3:--o
a3=n-2
a1.push(new B.mG(o,a4[o],a6[a3]+" "+a6[n-1],D.iS))
n=a3
break
default:x=o-1;--n
a1.push(new B.mG(x,a4[x],a6[n],D.iS))
o-=2
a1.push(new B.mG(o,a4[o],a6[n],D.iS))}}a4=y.e
a4=A.aa(new A.d8(a1,a4),a4.i("aZ.E"))
return a4},
ng:function ng(d,e){this.a=d
this.b=e},
Rx:function Rx(d,e){this.a=d
this.b=e},
mG:function mG(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Hv:function Hv(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aUs:function aUs(d){this.a=d},
aUr:function aUr(){},
bWF:function bWF(){},
bYE:function bYE(){},
cmE(d,e,f){return new B.r3(d,e,f)},
cA4(d){var x
A:{if("memorized"===d){x=D.fb
break A}if("learning"===d){x=D.oU
break A}x=D.oT
break A}return x},
ci_(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cL[d-1].a[1]},
cuw(){var x=y.S
return new B.ahJ(A.C(x,y.u),A.aV(x))},
b3n(d){var x=d.fa()
return C.c.df(C.j.j(A.bp(x)),4,"0")+"-"+C.c.df(C.j.j(A.bt(x)),2,"0")+"-"+C.c.df(C.j.j(A.bV(x)),2,"0")},
cda(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cBs(),x),x.i("aZ.E"))
return B.b3n(A.dl(w[0],w[1],w[2]-1,12,0,0,0))},
c4a(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.C(p,y.u),n=A.aV(p),m=new B.ahJ(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcK(),x=x.ga_(x),w=y.j;x.v();){v=x.gJ()
u=A.dR(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aM(t)>=3){v=C.j.aJ(u,1000)
s=C.j.a0(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cL[v-1].a[1])}if(v)continue
v=J.ba(t)
r=C.f.c2(A.d3(v.h(t,0)))
if(r<0||r>=3)continue
o.q(0,u,new B.r3(D.aIV[r],C.f.c2(A.d3(v.h(t,1))),new A.aY(A.l_(C.f.c2(A.d3(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.ayP(q,y.o)
p=A.m9(x,new B.b3m(),x.$ti.i("Y.E"),p)
n.A(0,new A.am(p,o.ga2M(),A.y(p).i("am<Y.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aL(d.h(0,"streak"))
p=p==null?null:C.f.c2(p)
p=m.d=p==null?0:p
o=A.aL(d.h(0,"best"))
o=o==null?null:C.f.c2(o)
m.e=o==null?p:o
return m},
ayb(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.df(C.j.j(d),3,"0")+C.c.df(C.j.j(e),3,"0")+".mp3"},
Et:function Et(d,e){this.a=d
this.b=e},
r3:function r3(d,e,f){this.a=d
this.b=e
this.c=f},
ahJ:function ahJ(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b3o:function b3o(){},
b3p:function b3p(){},
b3m:function b3m(){},
Uq:function Uq(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cs2(){return new B.wq(null)},
cDL(d,e){var x,w,v,u,t={},s=I.cL[e-1].a[1],r=$.LP().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.qS():v).a===D.fb}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.cU(u+4,1,s)
return A.ee(C.cU,new B.c_T(t,s,e),d,!0,null,null,!1,y.l)},
c5Y(d){return A.df(0,0,0,0,0,C.j.cU(C.f.aw(6+d*1.2),25,90))},
c4V(d){return E.bm(C.j.aJ(d,60))+":"+C.c.df(E.bm(C.j.a0(d,60)),2,"\u0660")},
chN(d){return A.ee(C.cU,new B.c0E($.LP()),d,!0,null,null,!1,y.H)},
LK(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gkR()
break A}return x},
cF2(d,e,f){var x,w=new B.c0U(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
chV(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.as.fB(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.h9:r
q=s.a(J.av(x,"last"))
v=q==null?C.h9:q
u=new B.c0T()
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
a0=J.aM(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.f(J.av(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.f(J.av(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
GB:function GB(d,e){this.a=d
this.b=e},
Ur:function Ur(d,e,f,g,h){var _=this
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
b3q:function b3q(d){this.a=d},
b3r:function b3r(d){this.a=d},
b3s:function b3s(d){this.a=d},
wq:function wq(d){this.a=d},
ZN:function ZN(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bG4:function bG4(d){this.a=d},
bG3:function bG3(d,e){this.a=d
this.b=e},
bG5:function bG5(d){this.a=d},
bG2:function bG2(d,e){this.a=d
this.b=e},
bG6:function bG6(){},
bFR:function bFR(){},
bFX:function bFX(d,e,f){this.a=d
this.b=e
this.c=f},
bFY:function bFY(){},
bG0:function bG0(d){this.a=d},
bG_:function bG_(){},
bG1:function bG1(d){this.a=d},
bFU:function bFU(d,e){this.a=d
this.b=e},
bFV:function bFV(d){this.a=d},
bFT:function bFT(){},
bFW:function bFW(d){this.a=d},
bFS:function bFS(d){this.a=d},
bFZ:function bFZ(d,e){this.a=d
this.b=e},
GC:function GC(d,e,f){this.c=d
this.d=e
this.a=f},
WF:function WF(d,e){this.c=d
this.a=e},
c_T:function c_T(d,e,f){this.a=d
this.b=e
this.c=f},
c_Q:function c_Q(d,e,f){this.a=d
this.b=e
this.c=f},
c_S:function c_S(d,e){this.a=d
this.b=e},
c_P:function c_P(d,e){this.a=d
this.b=e},
c_O:function c_O(d,e){this.a=d
this.b=e},
c_R:function c_R(d,e){this.a=d
this.b=e},
c_K:function c_K(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c_J:function c_J(d,e,f){this.a=d
this.b=e
this.c=f},
c_L:function c_L(d){this.a=d},
c_M:function c_M(d){this.a=d},
c_N:function c_N(d,e){this.a=d
this.b=e},
Dv:function Dv(d,e){this.a=d
this.b=e},
Cz:function Cz(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a1a:function a1a(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bT0:function bT0(){},
bTg:function bTg(d,e){this.a=d
this.b=e},
bTk:function bTk(d){this.a=d},
bTl:function bTl(d){this.a=d},
bTm:function bTm(d,e,f){this.a=d
this.b=e
this.c=f},
bTo:function bTo(d){this.a=d},
bTp:function bTp(d){this.a=d},
bTn:function bTn(){},
bTr:function bTr(d){this.a=d},
bTq:function bTq(d){this.a=d},
bTs:function bTs(d,e){this.a=d
this.b=e},
bTu:function bTu(d){this.a=d},
bTv:function bTv(d){this.a=d},
bTt:function bTt(){},
bTf:function bTf(d,e,f){this.a=d
this.b=e
this.c=f},
bTh:function bTh(d,e,f){this.a=d
this.b=e
this.c=f},
bT8:function bT8(d){this.a=d},
bT9:function bT9(d){this.a=d},
bT7:function bT7(){},
bTa:function bTa(){},
bTb:function bTb(d,e){this.a=d
this.b=e},
bTA:function bTA(d){this.a=d},
bTB:function bTB(d){this.a=d},
bTC:function bTC(d,e){this.a=d
this.b=e},
bTz:function bTz(d){this.a=d},
bTD:function bTD(d,e){this.a=d
this.b=e},
bTe:function bTe(){},
bTd:function bTd(d){this.a=d},
bTc:function bTc(d,e){this.a=d
this.b=e},
bTj:function bTj(d){this.a=d},
bTi:function bTi(d){this.a=d},
bTw:function bTw(){},
bTx:function bTx(){},
bTy:function bTy(){},
bT1:function bT1(d,e,f){this.a=d
this.b=e
this.c=f},
bT2:function bT2(d){this.a=d},
bT4:function bT4(){},
bT3:function bT3(){},
bT5:function bT5(d){this.a=d},
bT6:function bT6(d){this.a=d},
CQ:function CQ(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
Cy:function Cy(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a19:function a19(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bSK:function bSK(){},
bST:function bST(d,e){this.a=d
this.b=e},
bSU:function bSU(d){this.a=d},
bSS:function bSS(){},
bSW:function bSW(d){this.a=d},
bSV:function bSV(d,e){this.a=d
this.b=e},
bSX:function bSX(d,e){this.a=d
this.b=e},
bSO:function bSO(d,e){this.a=d
this.b=e},
bSP:function bSP(d,e,f){this.a=d
this.b=e
this.c=f},
bSQ:function bSQ(d,e,f){this.a=d
this.b=e
this.c=f},
bSL:function bSL(d,e,f){this.a=d
this.b=e
this.c=f},
bSM:function bSM(d,e,f){this.a=d
this.b=e
this.c=f},
bSN:function bSN(d,e){this.a=d
this.b=e},
bSR:function bSR(d){this.a=d},
bSY:function bSY(){},
bSZ:function bSZ(d,e){this.a=d
this.b=e},
bT_:function bT_(d,e){this.a=d
this.b=e},
Cx:function Cx(d){this.a=d},
a18:function a18(d){this.d=d
this.c=this.a=null},
bSB:function bSB(){},
bSI:function bSI(d){this.a=d},
bSJ:function bSJ(){},
bSH:function bSH(d,e){this.a=d
this.b=e},
bSG:function bSG(d,e,f){this.a=d
this.b=e
this.c=f},
bSF:function bSF(d,e,f){this.a=d
this.b=e
this.c=f},
bSE:function bSE(d){this.a=d},
bSC:function bSC(d){this.a=d},
bSD:function bSD(d){this.a=d},
c0E:function c0E(d){this.a=d},
c0D:function c0D(d){this.a=d},
c0y:function c0y(d,e){this.a=d
this.b=e},
c0A:function c0A(){},
c0z:function c0z(){},
c0B:function c0B(d,e){this.a=d
this.b=e},
c0C:function c0C(d,e){this.a=d
this.b=e},
ahH:function ahH(d){this.a=d},
b39:function b39(d){this.a=d},
c0U:function c0U(){},
c0V:function c0V(){},
CA:function CA(d,e,f){this.c=d
this.d=e
this.a=f},
a1b:function a1b(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bTE:function bTE(d){this.a=d},
bTF:function bTF(d){this.a=d},
bTG:function bTG(d,e){this.a=d
this.b=e},
bTH:function bTH(d){this.a=d},
bTJ:function bTJ(d){this.a=d},
bTI:function bTI(d){this.a=d},
c0T:function c0T(){}},D,P,Q,I,E,F
J=c[1]
A=c[0]
C=c[2]
L=c[15]
M=c[19]
R=c[21]
G=c[33]
H=c[13]
N=c[32]
O=c[23]
S=c[10]
K=c[38]
B=a.updateHolder(c[8],B)
D=c[39]
P=c[30]
Q=c[36]
I=c[28]
E=c[16]
F=c[18]
B.ahI.prototype={
qN(){var x=this,w=x.a
if(w!=null)return A.ec(w,y.m)
w=x.b
return w==null?x.b=new B.b3a(x).$0():w},
u_(d,e){return this.aLk(d,e,e)},
aLk(d,e,f){var x=0,w=A.k(f),v,u=2,t=[],s,r,q,p
var $async$u_=A.e(function(g,h){if(g===1){t.push(h)
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
r=B.cuu(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$u_,w)},
o5(d,e){var x=A.em(d[e])
if(x==null)x=null
return x===!0},
Me(){var x=0,w=A.k(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$Me=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.qN(),$async$Me)
case 7:r=h.cV(g.cM(e,"support",null,null,null,null))
q=s.o5(r,"worker")
p=s.o5(r,"wasm")
o=s.o5(r,"mic")
n=s.o5(r,"audio")
s.o5(r,"webgpu")
m=s.o5(r,"secure")
s.o5(r,"ios")
l=A.kK(r.memory)
if(l==null)l=null
if(l==null)l=0
s.o5(r,"isolated")
k=A.kK(r.cores)
if(k!=null)C.f.aw(k)
v=new B.Us(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a2N
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Me,w)},
E3(){var x=0,w=A.k(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$E3=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.qN(),$async$E3)
case 8:x=7
return A.c(m.eF(l.cV(k.cM(e,"storage",null,null,null,null)),y.A),$async$E3)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.aw(A.dT(r.quota))
p=C.f.aw(A.dT(r.usage))
v=new A.arH(q,p)
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
return A.j($async$E3,w)},
bgs(){var x=y.K
A.OE(this.qN().bB(new B.b3d(),x),x)},
qM(d,e){var x=A.kK(d[e])
x=x==null?null:C.f.aw(x)
return x==null?0:x},
bdT(d,e,f){return this.u_(new B.b3c(this,d,e,f),y.C)},
gaj_(){var x,w
try{x=A.k5(b.G.sessionStorage)
return x}catch(w){return null}},
gaqn(){var x=A.em(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a81(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.em(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gaqn())return!1
l=A.em(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cV(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.a0(x.userAgent)
l=A.kK(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.u(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aB("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.f(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aB("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.kK(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.gaj_()
l=l==null?f:A.u(A.cM(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dR(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.k5(m.localStorage)
m=o
m=m==null?f:A.u(A.cM(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dR(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
aoW(){var x,w,v,u,t,s,r=null
try{x=this.gaj_()
if(x!=null)A.cM(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cV(x.location)
u=A.a0(v.hash)
t=A.a0(v.search)
s=A.bi(A.a0(A.cV(x.document).baseURI),0,r).a2("tutor/").j(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cM(v,"replace",s+t+x,r,r,r)},
bdC(){var x,w=null,v=b.G,u=A.cV(v.history),t=A.kK(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cM(u,"back",w,w,w,w)
else{x=A.a0(A.cV(v.document).baseURI)
A.cM(A.cV(v.location),"replace",A.bi(x,0,w).a2("./").j(0)+"#/",w,w,w)}},
a8c(d,e,f,g,h){return this.u_(new B.b3h(this,e,d,f,h,g),y.H)},
a8f(){return this.u_(new B.b3i(this),y.D)},
a2p(){var x=null,w=this.a
if(w!=null)A.cM(w,"cancelRecording",x,x,x,x)},
akk(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.qM(d,"ms")
w=A.kK(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.IW(u,x,w,v.qM(d,"frames"),v.qM(d,"tokens"),v.o5(d,"retried"),v.qM(d,"encMs"),v.qM(d,"decMs"),v.qM(d,"featMs"))},
agS(d){var x={}
x.words=d
return x},
atu(d,e){return this.u_(new B.b3k(this,d,e),y._)},
biD(d,e){return this.u_(new B.b3j(this,d,e),y._)},
Kl(d,e){return this.bgw(d,e)},
bgw(d,e){var x=0,w=A.k(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Kl=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.qN(),$async$Kl)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.ak(d).i("au<1,o>")
o=A.aa(new A.au(d,new B.b3e(),o),o.i("aZ.E"))
x=11
return A.c(A.eF(A.cV(A.cM(r,"play",o,e,null,null)),y.y),$async$Kl)
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
return A.j($async$Kl,w)},
LX(){var x=null,w=this.a
if(w!=null)A.cM(w,"stopPlayback",x,x,x,x)},
IQ(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.a0(A.cM(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bhL(){var x,w,v=null
try{x=this.a
if(x!=null)A.cM(x,"resetDevice",v,v,v,v)}catch(w){}},
a5J(d){var x=this.a
if(x!=null)A.cM(x,"prefetch",d,null,null,null)}}
B.Us.prototype={}
B.IU.prototype={
gmJ(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.IW.prototype={
gS5(){var x=this,w=C.f.an(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.IV.prototype={}
B.lr.prototype={
gkR(){var x,w=this.a
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
B.Rx.prototype={}
B.mG.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Hv.prototype={
gLW(){var x,w=this,v=w.d
if(v===$){x=new B.aUs(w).$0()
w.d!==$&&A.ap()
w.d=x
v=x}return v},
gJ7(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.d===D.a3d&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbeJ(){return J.h2(this.gLW(),new B.aUr()).gM(0)},
gt4(){var x=this.a
return x.length!==0&&this.gbeJ()===x.length&&this.gJ7().length===0}}
B.Et.prototype={
R(){return"AyahStatus."+this.b}}
B.r3.prototype={}
B.ahJ.prototype={
a5l(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.qS():x},
aXT(d){var x=this,w=B.b3n(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cda(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
ao7(){var x=Date.now(),w=B.b3n(new A.aY(x,0,!1))
x=this.c
return x===w||x===B.cda(w)?this.d:0},
asy(d,e,f,g){var x=this,w=new A.aY(Date.now(),0,!1),v=x.a5l(d,e),u=g?C.j.cU(v.b+1,0,100):0,t=g&&u>=f?D.fb:D.oU,s=new B.r3(t,u,w.i4()),r=d*1000+e
x.a.q(0,r,s)
x.b.F(0,r)
x.aXT(w)
return s},
a5c(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cL[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qS():s).a===D.fb)++u}return u},
bdA(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cL[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qS():s).a===D.oU)++u}return u},
garx(){var x=this.a,w=A.y(x).i("cd<2>")
return new A.am(new A.cd(x,w),new B.b3o(),w.i("am<Y.E>")).gM(0)},
gax8(){var x=this.a,w=A.y(x).i("bH<1>")
w=A.m9(new A.bH(x,w),new B.b3p(),w.i("Y.E"),y.S)
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
b9y(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b1J(x,300,A.y(x).c),x=new A.IA(J.aE(x.a),x.b,A.y(x).i("IA<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gJ()
s=C.j.aJ(t,1000)
t=C.j.a0(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.qS():q).a===D.fb?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.qS()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.qS():r).c.jL()],w,v))}return o},
bea(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.K)(d),++u){t=d[u]
s=A.ex(t.h(0,"surah"))*1000+A.ex(t.h(0,"ayah"))
r=w.h(0,C.j.aJ(s,1000)*1000+C.j.a0(s,1000))
if((r==null?$.qS():r).c.jL()===t.h(0,"updated_at"))v.K(0,s)}},
bei(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aE(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gJ()
if(!u.b(s))continue
r=A.aL(s.h(0,"surah"))
q=r==null?null:C.f.c2(r)
r=A.aL(s.h(0,"ayah"))
p=r==null?null:C.f.c2(r)
o=A.dW(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cL[q-1].a[1])
if(r)continue
n=B.cA4(s.h(0,"status"))
if(n===D.oT)continue
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
v.q(0,r,new B.r3(n,C.j.cU(l==null?0:l,0,100),o.i4()))
w.K(0,r)
t=!0}return t}}
B.Uq.prototype={
Iz(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Uq(w,v,u,t,f==null?x.e:f)},
b7R(d){var x=null
return this.Iz(x,x,d,x,x)},
anD(d){var x=null
return this.Iz(x,d,x,x,x)},
b7V(d){var x=null
return this.Iz(x,x,x,x,d)},
b7e(d){var x=null
return this.Iz(d,x,x,x,x)},
b7S(d){var x=null
return this.Iz(x,x,x,d,x)},
dA(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.GB.prototype={
R(){return"ModelState."+this.b}}
B.Ur.prototype={
vj(){var x=this.Q
return x==null?this.Q=new B.b3q(this).$0():x},
qm(d){return this.avl(d)},
avl(d){var x=0,w=A.k(y.H),v=this
var $async$qm=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:v.b=d
v.a6()
x=2
return A.c(A.j5("mt.tutor.settings",C.as.iB(d.dA(),null)),$async$qm)
case 2:return A.i(null,w)}})
return A.j($async$qm,w)},
zl(){var x=0,w=A.k(y.H),v=this,u
var $async$zl=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:v.a6()
x=2
return A.c(A.j5("mt.tutor.progress",C.as.iB(v.c.dA(),null)),$async$zl)
case 2:u=v.as
if(u!=null)u.aD()
v.as=A.cO(C.y,v.gaC5())
return A.i(null,w)}})
return A.j($async$zl,w)},
LG(d,e,f){return this.aw7(d,e,f)},
aw7(d,e,f){var x=0,w=A.k(y.H),v=this
var $async$LG=A.e(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:v.z=new A.aQ(d,e,f)
x=2
return A.c(A.j5("mt.tutor.last",C.as.iB(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$LG)
case 2:return A.i(null,w)}})
return A.j($async$LG,w)},
CM(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$CM=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.U_||n===D.jI){x=1
break}s.f=D.U_
s.y=null
s.a6()
u=4
n=A.ls().geV().h(0,"tutor_device")
if(n==null)n="auto"
p=A.ls().geV().h(0,"tutor_threads")
p=A.dR(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bdT(new B.b3r(s),n,p),$async$CM)
case 7:s.x=e
s.f=D.jI
n=A.ls().geV().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.qP().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a9(m)
if(n instanceof B.lr){q=n
s.f=D.aQi
s.y=q
n=A.ls().geV().h(0,"debug")
if(n==="1")A.qP().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a6()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$CM,w)},
wk(){var x=0,w=A.k(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wk=A.e(function(a0,a1){if(a0===1){t.push(a1)
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
return A.c(p.aR("quran_tutor_progress").d6("surah, ayah, status, perfect_count, updated_at"),$async$wk)
case 7:o=a1
n=r.c.bei(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.b9y()
if(J.aM(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.mO(h.x,k,k))
x=11
return A.c(f.bi8("quran_tutor_save",!1,g,i),$async$wk)
case 11:r.c.bea(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.j5("mt.tutor.progress",C.as.iB(r.c.dA(),null)),$async$wk)
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
Kz(d){return this.bhN(d)},
bhN(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Kz=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c4a(t.c.dA()).dA()
y.f.a(p.h(0,"rows")).e8(0,new B.b3s(d))
t.c=B.c4a(p)
x=2
return A.c(t.zl(),$async$Kz)
case 2:v=4
s=$.B().b
s===$&&A.b()
r=s.ga3().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.aB("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$Kz)
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
return A.j($async$Kz,w)}}
B.wq.prototype={
P(){var x=$.LP()
return new B.ZN(x,new A.af(C.J,$.S()))}}
B.ZN.prototype={
X(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goh())
w=y.a
x.vj().bB(new B.bG4(v),w)
H.aSU().bB(new B.bG5(v),w).fP(new B.bG6())
A.OE(H.c3w(),y.y)},
xs(){if(this.c!=null)this.k(new B.bFR())},
m(){var x,w=this
w.d.V(w.goh())
x=w.e
x.p$=$.S()
x.L$=0
w.a1()},
Pd(){var x=0,w=A.k(y.H),v,u=this,t,s
var $async$Pd=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qm(s.b.b7R(!0)),$async$Pd)
case 3:t=s.a
t.bgs()
if(t.a81()){t.aoW()
x=1
break}s.CM()
case 1:return A.i(v,w)}})
return A.j($async$Pd,w)},
xt(d,e,f){return this.aVL(d,e,f)},
b3b(d){return this.xt(d,null,null)},
aVL(d,e,f){var x=0,w=A.k(y.H),v,u=this,t,s,r
var $async$xt=A.e(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.Z(A.aT(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.Z(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cDL(s,d),$async$xt)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.LG(d,t.a,t.b),$async$xt)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.N(s,!1).az(A.az(new B.bFX(u,d,t),null,r),r),$async$xt)
case 8:if(u.c!=null)u.k(new B.bFY())
case 1:return A.i(v,w)}})
return A.j($async$xt,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gaqn()&&!A.N(d,!1).uM())u.push(A.bU(x,x,x,x,C.xT,x,x,t.gbdB(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bU(x,x,x,x,D.as_,x,x,new B.bG0(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bU(x,x,x,x,C.iq,x,x,new B.bG1(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aEt
else w=t?this.aQH():this.aRh()
return L.x8(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aRh(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a2N
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b3P,C.a0],x)
for(t=0;t<4;++t){s=D.aGy[t]
u.push(new A.H(C.bs,A.A(A.a([A.b4(s.a,C.ap,p,18),C.K,new A.bT(1,C.ac,A.d(s.b,p,p,p,p,G.a0q,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bul,C.I,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bm(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aK,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bm(C.f.aw(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.I,A.d(q,p,p,p,p,A.bI(p,p,r?D.dU:C.cI,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.I,D.btn],x))
x=A.a([new E.dv(u,C.a3,C.aJ,p,!0,p),new E.dv(A.I(s,C.q,C.d,C.e,0,C.l),C.a3,C.aJ,p,!1,p),D.bCj,C.I],x)
if(v!=null)x.push(new E.dv(A.d(v,p,p,p,p,D.beC,p,p,p),C.a3,C.aJ,p,!1,p))
else x.push(A.ft(D.ap_,D.bkj,this.gaW2(),A.eA(C.v,C.af,D.b6K,p,p)))
x.push(C.a1)
x.push(D.a2I)
return x},
aQH(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.O(r.a.a),p=q.length===0,o=p?C.rc:H.chG(q),n=t.z,m=A.R(v.ajF(C.dv,E.bm(s.garx())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bm(s.ao7()),k=s.c,j=Date.now()
k=k===B.b3n(new A.aY(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.GC(t,!1,u),A.A(A.a([m,C.K,A.R(v.ajF(C.kR,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.u],j)
if(n!=null){t=H.k7(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bm(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bm(m)+"\u2013"+E.bm(l)
k.push(new E.dv(A.A(A.a([D.ar7,C.X,A.R(A.I(A.a([D.bgy,A.d(t+" \u2014 "+m,u,u,u,u,C.bz,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.ni],j),C.h,C.d,C.e,0,u,u),C.a3,C.aJ,new B.bFU(v,n),!0,u))}t=C.i.ae(0.08)
k.push(A.aF(u,C.x,!1,u,!0,C.m,u,A.aG(),r,u,u,u,u,u,2,A.cQ(u,new A.ch(4,A.v(14),C.N),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.tV,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qx,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bFV(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.dl,!0,C.t,u,C.E,u,u,u,u))
k.push(C.u)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bpx)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.K)(o),++x)t.push(v.Qq(o[x]))
C.b.A(k,t)}else{t=A.a([D.aTn,D.aU2,v.Qq(1)],j)
for(w=114;w>=78;--w)t.push(v.Qq(w))
t.push(C.I)
r=v.f
p=A.b4(r?C.xy:C.n0,C.ap,u,u)
t.push(A.hp(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.f3,u,u,u),new B.bFW(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Qq(w))
C.b.A(k,t)}k.push(C.a0)
k.push(D.Bs)
return k},
ajF(d,e,f){var x=null,w=y.p
return new E.dv(A.A(A.a([A.b4(d,C.v,x,x),C.K,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bz,x,x,x),A.d(f,1,C.M,x,x,C.a12,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a3,C.L,x,!1,x)},
Qq(d){var x,w=null,v=this.d.c,u=I.cL[d-1].a[1],t=v.a5c(d),s=t/u,r=y.p,q=A.ao(A.ds(C.P,A.a([A.c1V(C.eK,G.cJ,w,w,w,w,w,3,s,w),A.d(E.bm(d),w,w,w,w,R.a1n,w,w,w)],r),C.m,C.bj,w),36,36),p=A.d(H.k7(d),w,w,w,w,D.b9t,w,w,w)
if(t===0)x=E.bm(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bm(t)+" \u0645\u0646 "+E.bm(u)
r=A.a([q,C.cF,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bI(w,w,t===u?G.cJ:C.cI,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bm(C.f.aw(s*100))+"\u066a",w,w,w,w,D.a0V,w,w,w))
r.push(D.ap8)
return new E.dv(A.A(r,C.h,C.d,C.e,0,w,w),C.pS,C.db,new B.bFZ(this,d),!1,w)}}
B.GC.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b2
return D.aT8
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.LK(x),r,r,r,r,D.AE,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.CA(w,"model load",r))
x.push(C.I)
x.push(new A.zj(C.a3y,!1,q.gbdS(),r,r,r,r,C.k,r,!1,r,!0,r,C.u6,r))
return new E.dv(A.I(x,C.q,C.d,C.e,0,C.l),C.a3,C.aJ,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.cU(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bm(C.f.aw(u/1e6))+" \u0645\u0646 "+E.bm(C.f.aw(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.oo,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.f5(x,A.pI(C.eK,C.v,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.I,D.bl7],w))
return new E.dv(A.I(x,C.q,C.d,C.e,0,C.l),C.a3,C.aJ,r,!1,r)}}}
B.WF.prototype={
t(d){var x=null,w=D.dU.ae(0.1),v=A.v(14),u=A.aH(D.dU.ae(0.4),1)
return A.D(x,A.A(A.a([D.aqM,C.K,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.AL,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.E(w,x,u,v,x,x,x,C.n),x,x,C.aJ,C.ad,x,x,x)}}
B.Dv.prototype={
R(){return"_Phase."+this.b}}
B.Cz.prototype={
P(){return new B.a1a($.LP(),D.m2)}}
B.a1a.prototype={
gj_(){var x=this.e
return x===$?this.e=this.a.d:x},
gBl(){var x,w=this.a,v=w.f
w=w.c
x=this.gj_()
return H.LI(w,x,v.xD(w,x)).b},
X(){var x,w=this
w.Y()
x=w.d
x.ac(w.goh())
x.vj()
x.a.a5J(B.ayb(w.a.c,w.gj_()))},
xs(){if(this.c!=null)this.k(new B.bT0())},
m(){var x,w=this,v=w.d
v.V(w.goh())
x=w.Q
if(x!=null)x.aD()
v=v.a
v.LX()
v.a2p()
w.a1()},
Za(d){var x,w,v=this
if(v.f===D.uD)v.d.a.a2p()
x=v.d.a
x.LX()
w=v.Q
if(w!=null)w.aD()
v.k(new B.bTg(v,d))
x.a5J(B.ayb(v.a.c,d))
w=v.a
if(d<w.e)x.a5J(B.ayb(w.c,d+1))},
QH(d){return this.aS8(d)},
aS8(d){var x=0,w=A.k(y.H),v,u=this,t,s,r,q,p
var $async$QH=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:if(u.f===D.uC){u.d.a.LX()
u.k(new B.bTk(u))
x=1
break}t=u.r!=null?D.iZ:D.m2
u.k(new B.bTl(u))
s=u.d
r=A.a([B.ayb(u.a.c,u.gj_())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.Kl(r,q),$async$QH)
case 3:p=f
if(u.c==null||u.f!==D.uC){x=1
break}u.k(new B.bTm(u,t,p))
case 1:return A.i(v,w)}})
return A.j($async$QH,w)},
Pz(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Pz=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jI){x=1
break}p=l.a
p.LX()
r=B.Eb(s.gBl()).length
s.k(new B.bTo(s))
o=s.Q
if(o!=null)o.aD()
s.Q=A.hK(C.eO,new B.bTp(s))
u=4
o=B.c5Y(r)
n=A.df(0,0,0,350*r,0,0)
x=7
return A.c(p.a8c(l.b.c,o,n,new B.bTq(s),new B.bTr(s)),$async$Pz)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a9(k)
if(l instanceof B.lr){q=l
l=s.Q
if(l!=null)l.aD()
if(s.c!=null)s.k(new B.bTs(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Pz,w)},
Be(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$Be=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.uD){x=1
break}m=s.Q
if(m!=null)m.aD()
s.k(new B.bTu(s))
s.Q=A.hK(C.ik,new B.bTv(s))
l=new A.C2()
$.Ee()
l.o1()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a8f(),$async$Be)
case 7:q=e
if(q.b<0.8){s.b3a("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.atu(q,B.Eb(s.gBl()).length),$async$Be)
case 8:p=e
s.ch=A.df(0,0,r.ga3M(),0,0,0)
k=A.ls().geV().h(0,"debug")
if(k==="1"){o=B.chV(m.IQ())
A.qP().$1("[tutor] "+s.a.c+":"+s.gj_()+" audio="+C.f.an(q.b,1)+"s infer="+p.b+"ms total="+r.gC9()+"ms "+p.gS5()+" text="+p.a)
A.qP().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.an(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.an(p.b/1000,2)+" \u062b\n"+p.gS5()+"\n"+A.n(o)+"\n"+p.a}s.ae3(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a9(i)
if(m instanceof B.lr){n=m
m=A.ls().geV().h(0,"debug")
if(m==="1")A.qP().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.IQ())
s.a1e(B.LK(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Be,w)},
a1e(d,e){var x=this,w=x.Q
if(w!=null)w.aD()
if(x.c==null)return
x.k(new B.bTf(x,d,e))},
b3a(d){return this.a1e(d,null)},
ae3(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aD()
if(s.c==null)return
x=B.cg5(s.gBl(),d)
r.a=null
if(C.c.O(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gj_()
t=x.gt4()
r.a=w.asy(v,u,q.b.a,t)
q.zl()}s.k(new B.bTh(r,s,x))},
Ng(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$Ng=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jI){x=1
break}s.k(new B.bT8(s))
l=s.Q
if(l!=null)l.aD()
s.Q=A.hK(C.ik,new B.bT9(s))
k=new A.C2()
$.Ee()
k.o1()
r=k
u=4
l=g.a
x=7
return A.c(l.biD(B.ayb(s.a.c,s.gj_()),B.Eb(s.gBl()).length),$async$Ng)
case 7:q=e
p=B.chV(l.IQ())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.an(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.an(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.an(r.gC9()/1000,2)+" \u062b)\n"+q.gS5()+"\n"+A.n(p)+"\n"+q.a
A.qP().$1("[tutor-debug] "+s.a.c+":"+s.gj_()+" audio="+C.f.an(q.c,1)+"s infer="+q.b+"ms total="+r.gC9()+"ms "+q.gS5()+" text="+q.a)
A.qP().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.df(0,0,r.ga3M(),0,0,0)
s.ae3(q.a)
n=s.r
if(n!=null){l=n.gt4()
j=n.b
i=A.ak(j).i("am<1>")
j=A.aa(new A.am(j,new B.bTa(),i),i.i("Y.E"))
A.qP().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.k(new B.bTb(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a9(f)
if(l instanceof B.lr){m=l
A.qP().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.IQ())
s.a1e(B.LK(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Ng,w)},
ga03(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.qS():v).a!==D.fb)return!1}return!0},
t(d){var x,w=this,v=null,u=w.d,t=u.c.a5l(w.a.c,w.gj_()),s=u.b,r=s.d&&!w.x&&w.f!==D.iZ,q=H.k7(w.a.c),p=y.p,o=A.a([A.bU(v,v,v,v,C.iq,v,v,new B.bTA(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aIA(),m=A.d("\u0622\u064a\u0629 "+E.bm(w.gj_()),v,v,v,v,O.op,v,v,v),l=E.bm(w.gj_()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.b_,A.d("("+l+" \u0645\u0646 "+E.bm(k.e-k.d+1)+")",v,v,v,v,F.aK,v,v,v),C.by,w.aWI(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.u],p)
if(r)s.push(w.aQC())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.uD&&l!==D.oK}else l=!1
if(l)s.push(w.aGk(m))
else s.push(A.d(w.gBl()+" \ufd3f"+E.bm(w.gj_())+"\ufd3e",v,v,v,v,D.k6,C.Y,C.bg,v))}s=A.a([new B.GC(u,!0,v),n,C.B,new E.dv(A.I(s,C.ag,C.d,C.e,0,C.l),D.ai1,C.aJ,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.iZ)s.push(w.b4A(n))
if(w.r!=null&&w.f===D.iZ&&w.ch!=null){x=C.f.aw(C.j.aJ(w.ch.a,1000)/100)
s.push(new A.H(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bm(C.j.aJ(x,10))+"\u066b"+E.bm(C.j.a0(x,10)))+" \u062b",v,v,v,v,F.aK,C.Y,v,v),v))}n=w.as
if(n!=null)s.push(new A.H(C.aJ,A.d(n,v,v,v,v,D.AE,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.CA(n,"check "+w.a.c+":"+w.gj_(),v))}s.push(w.aGR())
s.push(C.a0)
s.push(A.ie(C.v,C.L,v,new B.bTB(w),D.bid,D.bnn,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga03()
s.push(new E.dv(A.A(A.a([D.anG,C.X,A.R(A.I(A.a([D.boW,A.d(w.ga03()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aK,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.ni],p),C.h,C.d,C.e,0,v,v),C.a3,C.aJ,new B.bTC(w,d),n,v))}n=A.ls().geV().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dr(D.aoZ,D.bmN,u.f===D.jI&&w.f!==D.oK?w.gaHA():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.H(C.il,A.wM(n,F.aK,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gmJ()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aK,v,v,v))}p.push(A.be(D.bo6,v,v,new B.bTD(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.Bs)
return L.x8(o,s,q)},
aIA(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b2
return A.ao(A.fv(new B.bTd(this),w,null,C.ae,new B.bTe()),36,null)},
aWI(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fb)return D.b4_
x=d.b
w=E.bm(x)
v=E.bm(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.bV:C.GE
u.push(new A.H(D.aiI,A.b4(r,s?G.cJ:C.eL,q,16),q))}return A.c47(A.A(u,C.h,C.d,C.O,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aQC(){var x=null
return A.bz(!1,A.v(12),!0,A.D(x,D.aea,C.k,x,x,new A.E(C.pl,x,x,A.v(12),x,x,x,C.n),x,x,x,D.ahA,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bTj(this),x,x,x,x,x,x,x)},
aGk(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gLW(),w)
A:{if(D.iS===v){u=D.k6.ck(G.cJ)
break A}if(D.um===v){u=D.k6.a33(D.dU,C.hY,D.dU)
break A}if(D.un===v){u=D.k6.a33(D.eJ,C.hY,D.eJ)
break A}u=D.k6.a33(C.eL,C.k3,C.cw)
break A}t=x[w]
r.push(new A.eX(t.a,s,s,C.bx,s,s,s,s,s,s,u))
r.push(Q.Av)}x=E.bm(this.gj_())
r.push(A.ek(s,s,s,s,s,s,s,s,s,D.k6.ck(C.ap),"\ufd3f"+x+"\ufd3e"))
return A.IB(A.ek(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Y,C.bg)},
b4A(d){var x,w,v,u,t,s,r=this.w
if(C.c.O(d.c).length===0)return D.bBG
if(d.gt4()){x=r==null
if((x?null:r.a)===D.fb&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fb?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bm(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.CQ(G.cJ,C.bV,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gLW()
w=J.dE(x)
v=w.ir(x,new B.bTw()).gM(0)
u=w.ir(x,new B.bTx()).gM(0)
t=w.ir(x,new B.bTy()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bm(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bm(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bm(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJ7().length!==0)x.push(E.bm(d.gJ7().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eJ:D.dU
x=C.b.aE(x," \u2022 ")
s=d.gJ7().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aE(d.gJ7(),"\u060c "):""
return new B.CQ(w,C.n8,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aGR(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jI,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aJ(new A.aY(f,0,!1).dF(w).a,1e6)}v=C.j.aJ(B.c5Y(B.Eb(j.gBl()).length).a,1e6)
f=j.gb1O()
w=96+26*j.y
u=D.eJ.ae(0.25)
w=A.iA(i,A.a3S(C.P,A.D(i,D.apb,C.k,i,i,D.a68,i,84,i,i,i,i,84),i,C.aR,new A.E(u,i,i,i,i,i,i,C.bZ),C.En,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cM)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c4V(x)+" / "+B.c4V(v),i,i,i,i,K.on,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aK,i,i,i),A.be(D.btm,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.ep((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bm(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bm(t)+" \u062b)"
return new A.H(C.pO,A.I(A.a([C.vp,C.a0,D.blA,A.d(h,i,i,i,i,F.aK,C.Y,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.uC
r=j.r
f=r==null
w=!f
q=w&&r.gt4()
u=A.b4(s?D.xI:K.GS,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.eA(i,i,D.b6H,i,i)
u=A.R(new A.zj(C.a3y,!0,new B.bT1(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Xf(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.Ip[n]
p.push(new A.eg(m,i,A.d("\xd7"+E.bm(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.K,A.ou(new B.bT2(j),p,A.d6([h.b.b],o),!1,A.kb(i,i,i,new A.br(new B.bT3(),l),i,i,i,i,new A.br(new B.bT4(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cR),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gaYA():i
u=A.b4(f?D.qn:C.n8,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cC,i,i,i)
p=q?C.ig:C.v
h=A.a([o,C.u,A.ft(u,f,h,A.eA(p,q?C.i:C.af,D.tz,i,i))],k)
if(w&&j.gj_()<j.a.e)C.b.A(h,A.a([C.B,q?A.ft(D.asn,D.bs7,new B.bT5(j),A.eA(G.cJ,C.af,D.tz,i,i)):A.be(D.biB,i,i,new B.bT6(j),i,i)],k))
if(w){f=j.gj_()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.H(C.ji,A.d(j.ga03()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,D.a1w,C.Y,i,i),i))
return A.I(h,C.ag,C.d,C.e,0,C.l)}}}
B.CQ.prototype={
t(d){var x=this,w=null,v=x.c,u=v.ae(0.12),t=A.v(14),s=A.aH(v.ae(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b4(x.d,v,w,w),C.K,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bI(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.U,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bL,A.d(x.f,w,w,w,w,C.AL,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.E(u,w,s,t,w,w,w,C.n),w,w,C.aJ,C.ad,w,w,w)}}
B.Cy.prototype={
P(){var x=y.S
return new B.a19($.LP(),A.C(x,y.B),A.aV(x),A.C(x,y.N),A.ec(null,y.H))}}
B.a19.prototype={
X(){this.Y()
this.d.ac(this.goh())},
xs(){if(this.c!=null)this.k(new B.bSK())},
m(){var x,w=this,v=w.d
v.V(w.goh())
x=w.y
if(x!=null)x.aD()
v.a.a2p()
w.a1()},
HI(d){return this.b1A(d)},
b1A(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$HI=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.k(new B.bST(t,d))
r=t.y
if(r!=null)r.aD()
t.y=A.hK(C.eO,new B.bSU(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c5Y(B.Eb(H.LI(q,d,p.xD(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.df(0,0,0,350*B.Eb(H.LI(p,d,o.xD(p,d)).b).length,0,0)
x=6
return A.c(r.a.a8c(r.b.c,q,p,new B.bSV(t,d),new B.bSW(t)),$async$HI)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a9(m)
if(r instanceof B.lr){s=r
r=t.y
if(r!=null)r.aD()
if(t.c!=null)t.k(new B.bSX(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$HI,w)},
Fd(d,e){return this.aJJ(d,e)},
aJJ(d,e){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$Fd=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aD()
s.k(new B.bSO(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a8f()
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
if(o instanceof B.lr){p=o
s.k(new B.bSP(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bB(new B.bSQ(s,o,d),y.H)}case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Fd,w)},
gaUf(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aG(x)&&!v.n(0,x)&&!u.aG(x)&&x!==t.e)return x
return null},
aZp(){this.k(new B.bSR(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jI,o=s.e,n=s.gaUf(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("cd<2>")
x=new A.am(new A.cd(m,l),new B.bSY(),l.i("am<Y.E>")).gM(0)
l=H.k7(s.a.c)
m=y.p
q=A.a([new B.GC(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bm(s.a.d)+" \u0644\u062d\u062f "+E.bm(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aK,r,r,r),C.u],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b3c(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.AE,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.CA(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bm(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aJ(new A.aY(v,0,!1).dF(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c4V(v),r,r,r,r,K.on,C.Y,r,r)
j=A.f5(A.v(6),A.pI(C.eK,D.eJ,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b4(u?P.GL:D.xI,r,r,r)
C.b.A(q,A.a([v,C.I,j,C.u,A.ft(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cC,r,r,r),new B.bSZ(s,o),A.eA(C.v,C.af,D.tz,r,r))],m))}else if(n!=null){j=p?new B.bT_(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bm(n)
q.push(A.ft(D.aqi,A.d(v,r,r,r,r,C.cC,r,r,r),j,A.eA(C.v,C.af,D.tz,r,r)))}if(s.r.a!==0&&k)q.push(D.aTx)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cJ:D.dU
v=k?C.mZ:C.n8
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bm(x)
u=s.a
u=k+" \u0645\u0646 "+E.bm(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.CQ(j,v,k,u,r),A.dr(D.asa,D.bsL,s.gaZo(),r)],m))}q.push(C.u)
q.push(D.Bs)
return L.x8(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b3c(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.apF
else if(l.r.n(0,d))x=N.tA
else if(i!=null)x=D.apW
else if(j!=null){w=j.gt4()?C.bV:D.ame
x=A.b4(w,j.gt4()?G.cJ:D.dU,k,k)}else x=D.aoi
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bm(d),k,k,k,k,D.bdM,k,k,k),C.by,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.a14,k,k,k))
if(j!=null&&!j.gt4()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gLW()
o=J.ba(p)
n=o.h(p,r)
A:{if(D.iS===n){m=G.cJ
break A}if(D.um===n){m=D.dU
break A}if(D.un===n){m=D.eJ
break A}m=C.eL
break A}m=D.k6.b8t(m,o.h(p,r)===D.uo?C.k3:k,22)
C.b.A(t,A.a([new A.eX(q.a,k,k,C.bx,k,k,k,k,k,k,m),Q.Av],u))}w=A.a([C.aj,A.IB(A.ek(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Y,C.bg)],w)
if(C.c.O(j.c).length===0)w.push(D.bok)
C.b.A(v,w)}return new E.dv(A.I(v,C.ag,C.d,C.e,0,C.l),C.bI,C.db,k,!1,k)}}
B.Cx.prototype={
P(){return new B.a18($.LP())}}
B.a18.prototype={
X(){this.Y()
var x=this.d
x.ac(this.goh())
x.vj()},
xs(){if(this.c!=null)this.k(new B.bSB())},
m(){this.d.V(this.goh())
this.a1()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gax8(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kN(o,0,new B.bSI(q))
v=C.b.kN(o,0,new B.bSJ())
o=y.p
o=A.a([A.A(A.a([A.R(s.X1(E.bm(q.garx()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.K,A.R(s.X1(E.bm(q.ao7()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.K,A.R(s.X1(E.bm(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.u,new E.dv(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bm(C.f.aw(w*100/v))+"\u066a",r,r,r,r,C.bz,r,r,r),C.I,A.f5(A.v(6),A.pI(C.eK,G.cJ,8,w/v,r),C.aC),C.aj,A.d(E.bm(w)+" \u0645\u0646 "+E.bm(v)+" \u0622\u064a\u0629",r,r,r,r,F.aK,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a3,C.aJ,r,!1,r)],o)
if(p.length===0)o.push(D.aTK)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.K)(p),++t)o.push(s.b3e(p[t]))
o.push(C.B)
u=$.B().b
u===$&&A.b()
u=u.ga3().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aK,r,r,r))
return L.x8(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
X1(d,e){var x=null
return new E.dv(A.I(A.a([A.d(d,x,x,x,x,D.bdu,x,x,x),A.d(e,x,x,x,x,C.a1A,C.Y,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a3,C.L,x,!1,x)},
b3e(d){var x=null,w=this.d.c,v=I.cL[d-1].a[1],u=w.a5c(d),t=w.bdA(d),s=y.p,r=A.A(A.a([A.R(A.d(H.k7(d),x,x,x,x,C.bz,x,x,x),1),A.d(E.bm(C.f.aw(u*100/v))+"\u066a",x,x,x,x,D.beD,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.f5(A.v(6),A.pI(C.eK,G.cJ,7,u/v,x),C.aC),p=E.bm(u),o=E.bm(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bm(t):""
return new E.dv(A.I(A.a([r,C.I,q,C.aj,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aK,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a3,C.aJ,new B.bSH(this,d),!1,x)},
Nj(d){return this.aHV(d)},
aHV(d){var x=0,w=A.k(y.H),v=this,u,t
var $async$Nj=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=I.cL[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.ee(C.cU,new B.bSG(v,d,u),t,!0,null,null,!1,y.H),$async$Nj)
case 2:return A.i(null,w)}})
return A.j($async$Nj,w)}}
B.ahH.prototype={
QG(d,e){var x=null,w=A.oB(x,x,x,x,x,x,x,x,x,x,x,D.b6e,C.L,x,x,x,x,C.ld,x,x)
return A.be(A.d(d,x,x,x,x,C.lJ,x,x,x),x,x,new B.b39(e),x,w)},
t(d){var x=this,w=y.p
return new E.dv(A.I(A.a([D.brU,C.I,D.btl,A.d2(C.aB,A.a([x.QG("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.QG("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aG,0,12),D.bhO,x.QG("tanzil.net","https://tanzil.net"),D.buW,x.QG("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a3,C.aJ,null,!1,null)}}
B.CA.prototype={
P(){return new B.a1b()}}
B.a1b.prototype={
gakq(){var x=this.a
return B.cF2(x.c,x.d,$.c6y().IQ())},
QI(){var x=0,w=A.k(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$QI=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.k(new B.bTE(s))
v=3
r=A.chz()
n=s.gakq()
m=y.N
q=A.C(m,m)
J.dX(q,"app","mogtama3y")
J.dX(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dX(q,"ua",m)}x=6
return A.c(A.a8j(n,null,C.Fp,q),$async$QI)
case 6:if(s.c!=null)s.k(new B.bTF(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a9(k)
o=p instanceof A.cm?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.k(new B.bTG(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.k(new B.bTH(s))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$QI,w)},
t(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bz(!1,t,!0,new A.H(C.pP,A.A(A.a([A.b4(u.d?C.xy:C.n0,C.cw,t,18),C.bQ,D.bu6],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bTJ(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.D(t,A.wM(u.gakq(),D.b9Q,t,C.A),C.k,t,t,new A.E(C.pl,t,t,x,t,t,t,C.n),t,t,D.ahE,C.e8,t,t,1/0))}if(u.f)s.push(D.bi5)
else{x=A.oB(t,t,t,t,t,t,t,t,t,t,t,D.b6f,C.L,t,t,t,t,C.ld,t,t)
w=u.e
v=w?t:u.gb3d()
s.push(A.hp(w?C.a_E:D.arz,D.bqS,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,D.a14,t,t,t))
return new A.H(C.aJ,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["aj<~>()","~()","P(ng)","aj<IW>()","aj<IU>()","aj<IV>()","a7<ng>()","P(r3)","bE(om)","Cz(t)","Cx(t)","P(mG)","Cy(t)","P(Hv)"])
B.b3a.prototype={
$0(){var x=0,w=A.k(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.a0(A.cV(b.G.document).baseURI)
q=A.bi(r,0,null).a2("quran_tutor/tutor.js?v=3").j(0)
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
m=B.cuv("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:359}
B.b3d.prototype={
$1(d){var x=null
return A.bWd(A.cM(d,"persist",x,x,x,x))},
$S:1091}
B.b3c.prototype={
$0(){var x=0,w=A.k(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.qN(),$async$$0)
case 4:x=3
return A.c(n.eF(m.cV(l.cM(e,"loadModel",A.bWW(new B.b3b(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.u(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.u(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.qM(p,"ms")
r=q.o5(p,"cached")
A.u(p.backend)
v=new B.IU(o,t,s,r,q.qM(p,"threads"),q.o5(p,"isolated"),q.qM(p,"warmMs"))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+4}
B.b3b.prototype={
$2(d,e){this.a.$2(C.f.aw(d),C.f.aw(e))},
$S:1092}
B.b3h.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.qN(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aJ(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aJ(v.d.a,1000)
u.onLevel=A.fN(new B.b3f(v.e))
u.onAutoStop=A.fN(new B.b3g(v.f))
x=5
return A.c(A.eF(A.cV(A.cM(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.b3f.prototype={
$1(d){return this.a.$1(d)},
$S:62}
B.b3g.prototype={
$1(d){return this.a.$1(d)},
$S:6}
B.b3i.prototype={
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
return A.c(t.qN(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eF(p.cV(o.cM(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.IV(r,A.dT(r.seconds))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+5}
B.b3k.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.qN(),$async$$0)
case 4:x=3
return A.c(q.eF(p.cV(o.cM(e,"transcribe",t.audio,t.rate,s.agS(u.c),null)),y.m),$async$$0)
case 3:v=r.akk(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b3j.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.qN(),$async$$0)
case 4:x=3
return A.c(r.eF(q.cV(p.cM(e,"transcribeUrl",u.b,t.agS(u.c),null,null)),y.m),$async$$0)
case 3:v=s.akk(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b3e.prototype={
$1(d){return d},
$S:32}
B.aUs.prototype={
$0(){var x,w,v,u,t=this.a,s=A.ck(t.a.length,D.uo,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aUr.prototype={
$1(d){return d===D.iS},
$S:z+2}
B.bWF.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c10(e[x],d[x])<0.75)return!1
return!0},
$S:1093}
B.bYE.prototype={
$1(d){return d.length!==0},
$S:11}
B.b3o.prototype={
$1(d){return d.a===D.fb},
$S:z+7}
B.b3p.prototype={
$1(d){return C.j.aJ(d,1000)},
$S:67}
B.b3m.prototype={
$1(d){return C.f.c2(d)},
$S:1094}
B.b3q.prototype={
$0(){var x=0,w=A.k(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.jB("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.as.fB(r,null))
j=A.aL(k.h(0,"n"))
j=j==null?null:C.f.c2(j)
j=C.j.cU(j==null?2:j,1,5)
i=C.b.n(D.Ip,k.h(0,"r"))?A.ex(k.h(0,"r")):1
h=A.em(k.h(0,"auto"))
g=A.em(k.h(0,"hide"))
k=A.em(k.h(0,"in"))
s.a.b=new B.Uq(j,i,h!==!1,g===!0,k===!0)}u=2
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
if(q!=null)s.a.c=B.c4a(y.P.a(C.as.fB(q,null)))
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
if(p!=null){o=y.P.a(C.as.fB(p,null))
n=C.f.c2(A.d3(J.av(o,"s")))
m=C.f.c2(A.d3(J.av(o,"f")))
l=C.f.c2(A.d3(J.av(o,"t")))
if(B.ci_(n,m)&&B.ci_(n,l)&&m<=l)s.a.z=new A.aQ(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a81()){k.a.aoW()
x=1
break}a1=k
x=18
return A.c(k.a.Me(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a6()
if(k.b.e)k.CM()
k.wk()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:108}
B.b3r.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a6()},
$S:1095}
B.b3s.prototype={
$2(d,e){return C.j.aJ(A.eO(A.n(d),null,null),1000)===this.a},
$S:1096}
B.bG4.prototype={
$1(d){var x=0,w=A.k(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.E3(),$async$$1)
case 2:t=f
if(u.c!=null)u.k(new B.bG3(u,t))
return A.i(null,w)}})
return A.j($async$$1,w)},
$S:1097}
B.bG3.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bG5.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bG2(x,d))},
$S:z+8}
B.bG2.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bG6.prototype={
$1(d){},
$S:23}
B.bFR.prototype={
$0(){},
$S:0}
B.bFX.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.Cz(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bFY.prototype={
$0(){},
$S:0}
B.bG0.prototype={
$0(){var x=y.z
return A.N(this.a,!1).az(A.az(new B.bG_(),null,x),x)},
$S:0}
B.bG_.prototype={
$1(d){return D.bwh},
$S:z+10}
B.bG1.prototype={
$0(){return B.chN(this.a)},
$S:0}
B.bFU.prototype={
$0(){var x=this.b
return this.a.xt(x.a,x.b,x.c)},
$S:0}
B.bFV.prototype={
$1(d){return this.a.k(new B.bFT())},
$S:6}
B.bFT.prototype={
$0(){},
$S:0}
B.bFW.prototype={
$0(){var x=this.a
return x.k(new B.bFS(x))},
$S:0}
B.bFS.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bFZ.prototype={
$0(){return this.a.b3b(this.b)},
$S:0}
B.c_T.prototype={
$1(d){return new A.ju(new B.c_Q(this.a,this.b,this.c),null)},
$S:56}
B.c_Q.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c_S(u,e),s=this.a,r=new B.c_R(s,e),q=A.d(H.k7(this.c),v,v,v,v,C.oj,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bm(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aK,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bm(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bm(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.cU(w+4,1,u)))}u=A.a([q,C.aj,p,C.u,A.d2(C.aB,n,C.aG,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c_L(s)),C.a_A,t.$3("\u0644\u062d\u062f",s.c,new B.c_M(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aTC)
u.push(C.a1)
u.push(A.dG(D.bl2,new B.c_N(s,d),A.eA(C.v,C.af,D.b6E,v,v)))
return A.cu(!0,new A.H(C.ER,A.I(u,C.ag,C.d,C.O,0,C.l),v),C.L,!0)},
$S:252}
B.c_S.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.i0,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.cg(v,A.d("\u0622\u064a\u0629 "+E.bm(v),u,u,u,u,u,u,u,u),C.aw,u,w))
return A.R(A.I(A.a([t,S.Fj(C.cU,!0,s,320,new B.c_P(this.b,f),D.beV,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1099}
B.c_P.prototype={
$1(d){return d==null?null:this.a.$1(new B.c_O(this.b,d))},
$S:48}
B.c_O.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c_R.prototype={
$3(d,e,f){var x=null
return A.c1B(x,A.d(d,x,x,x,x,x,x,x,x),new B.c_K(this.a,this.b,e,f))},
$S:1100}
B.c_K.prototype={
$0(){var x=this
return x.b.$1(new B.c_J(x.a,x.c,x.d))},
$S:0}
B.c_J.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c_L.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c_M.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c_N.prototype={
$0(){var x=this.a
return A.N(this.b,!1).aj(new A.Z(x.b,x.c))},
$S:0}
B.bT0.prototype={
$0(){},
$S:0}
B.bTg.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.m2
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bTk.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.iZ:D.m2},
$S:0}
B.bTl.prototype={
$0(){var x=this.a
x.f=D.uC
x.as=null},
$S:0}
B.bTm.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bTo.prototype={
$0(){var x=this.a
x.f=D.uD
x.as=null
x.y=0
x.z=new A.aY(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bTp.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bTn())},
$S:31}
B.bTn.prototype={
$0(){},
$S:0}
B.bTr.prototype={
$1(d){return this.a.y=d},
$S:62}
B.bTq.prototype={
$1(d){return this.a.Be()},
$S:6}
B.bTs.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.iZ:D.m2
x=this.b
w.as=B.LK(x)
w.at=x},
$S:0}
B.bTu.prototype={
$0(){var x=this.a
x.f=D.oK
x.ay=Date.now()},
$S:0}
B.bTv.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bTt())},
$S:31}
B.bTt.prototype={
$0(){},
$S:0}
B.bTf.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.iZ:D.m2
x.as=this.b
x.at=this.c},
$S:0}
B.bTh.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.iZ
x.x=!1},
$S:0}
B.bT8.prototype={
$0(){var x=this.a
x.f=D.oK
x.ay=Date.now()
x.as=null},
$S:0}
B.bT9.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bT7())},
$S:31}
B.bT7.prototype={
$0(){},
$S:0}
B.bTa.prototype={
$1(d){return d.d!==D.iS},
$S:z+11}
B.bTb.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bTA.prototype={
$0(){return B.chN(this.a)},
$S:0}
B.bTB.prototype={
$1(d){var x=this.a.d
return x.qm(x.b.anD(d))},
$S:3}
B.bTC.prototype={
$0(){var x=y.z
return A.N(this.b,!1).az(A.az(new B.bTz(this.a),null,x),x)},
$S:0}
B.bTz.prototype={
$1(d){var x=this.a.a
return new B.Cy(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bTD.prototype={
$0(){this.a.d.a.bhL()
this.b.I(y.q).f.Z(D.b7G)},
$S:0}
B.bTe.prototype={
$2(d,e){return C.b_},
$S:20}
B.bTd.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a5l(s.c,r).a.a){case 2:s=G.cJ
break
case 1:s=D.dU
break
case 0:s=C.ig
break
default:s=u}x=A.v(18)
w=t.f===D.oK?u:new B.bTc(t,r)
v=s.ae(0.25)
if(r===t.gj_())s=C.i
s=A.aH(s,r===t.gj_()?2:1)
return A.bz(!1,x,!0,A.D(C.P,A.d(E.bm(r),u,u,u,u,C.a0L,u,u,u),C.k,u,u,new A.E(v,u,s,u,u,u,u,C.bZ),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:61}
B.bTc.prototype={
$0(){return this.a.Za(this.b)},
$S:0}
B.bTj.prototype={
$0(){var x=this.a
return x.k(new B.bTi(x))},
$S:0}
B.bTi.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bTw.prototype={
$1(d){return d===D.um},
$S:z+2}
B.bTx.prototype={
$1(d){return d===D.un},
$S:z+2}
B.bTy.prototype={
$1(d){return d===D.uo},
$S:z+2}
B.bT1.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.QH(x)},
$S:0}
B.bT2.prototype={
$1(d){var x=this.a.d
return x.qm(x.b.b7V(d.ga4(d)))},
$S:113}
B.bT4.prototype={
$1(d){return d.n(0,C.a2)?C.af:C.i},
$S:4}
B.bT3.prototype={
$1(d){return d.n(0,C.a2)?C.v:C.a8},
$S:4}
B.bT5.prototype={
$0(){var x=this.a
return x.Za(x.gj_()+1)},
$S:0}
B.bT6.prototype={
$0(){var x=this.a
return x.Za(x.gj_()+1)},
$S:0}
B.bSK.prototype={
$0(){},
$S:0}
B.bST.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aY(Date.now(),0,!1)},
$S:0}
B.bSU.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bSS())},
$S:31}
B.bSS.prototype={
$0(){},
$S:0}
B.bSW.prototype={
$1(d){return this.a.x=d},
$S:62}
B.bSV.prototype={
$1(d){return this.a.Fd(this.b,!1)},
$S:6}
B.bSX.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.LK(x)
w.as=x},
$S:0}
B.bSO.prototype={
$0(){var x=this.a
x.e=null
x.r.F(0,this.b)},
$S:0}
B.bSP.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.q(0,v,B.LK(x))
w.as=x},
$S:0}
B.bSQ.prototype={
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
return A.c(n.a.atu(s.b,B.Eb(H.LI(l,m,k.xD(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cg5(H.LI(l,m,k.xD(l,m)).b,r.a)
if(C.c.O(q.c).length!==0){l=n.c
k=o.a.c
j=q.gt4()
l.asy(k,m,n.b.a,j)}n.zl()
if(o.c!=null)o.k(new B.bSL(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a9(h)
if(o instanceof B.lr){p=o
o=s.a
if(o.c!=null)o.k(new B.bSM(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.k(new B.bSN(o,s.c))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$1,w)},
$S:126}
B.bSL.prototype={
$0(){var x=this.c
this.a.f.q(0,this.b,x)
return x},
$S:0}
B.bSM.prototype={
$0(){var x=this.a,w=this.c
x.w.q(0,this.b,B.LK(w))
x.as=w},
$S:0}
B.bSN.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bSR.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)
x.as=null},
$S:0}
B.bSY.prototype={
$1(d){return d.gt4()},
$S:z+13}
B.bSZ.prototype={
$0(){return this.a.Fd(this.b,!0)},
$S:0}
B.bT_.prototype={
$0(){return this.a.HI(this.b)},
$S:0}
B.bSB.prototype={
$0(){},
$S:0}
B.bSI.prototype={
$2(d,e){return d+this.a.a5c(e)},
$S:112}
B.bSJ.prototype={
$2(d,e){return d+I.cL[e-1].a[1]},
$S:112}
B.bSH.prototype={
$0(){return this.a.Nj(this.b)},
$S:0}
B.bSG.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.k7(p),q,q,q,q,C.oj,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.b8(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.qS():r).a.a){case 2:r=G.cJ.ae(0.35)
break
case 1:r=D.dU.ae(0.35)
break
case 0:r=C.fQ
break
default:r=q}m.push(A.D(C.P,A.d(E.bm(t),q,q,q,q,C.lE,q,q,q),C.k,q,q,new A.E(r,q,q,new A.cv(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cu(!0,new A.H(C.fW,A.I(A.a([o,C.aj,D.bpe,C.u,new A.dy(D.a60,A.f8(A.d2(C.aB,m,C.aG,6,6),q,C.r,q,q,q,C.w),q),C.a0,A.be(D.bqW,q,q,new B.bSF(w,d,p),q,q)],n),C.ag,C.d,C.O,0,C.l),q),C.L,!0)},
$S:37}
B.bSF.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dn(null,null,!0,null,new B.bSE(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Kz(t),$async$$0)
case 5:if(u.e!=null)A.N(u,!1).e2()
case 3:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.bSE.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.k7(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dt(A.a([A.be(C.en,x,x,new B.bSC(d),x,x),A.be(C.ox,x,x,new B.bSD(d),x,x)],y.p),w,D.bst)},
$S:14}
B.bSC.prototype={
$0(){A.N(this.a,!1).aj(!1)
return null},
$S:0}
B.bSD.prototype={
$0(){A.N(this.a,!1).aj(!0)
return null},
$S:0}
B.c0E.prototype={
$1(d){var x=this.a
return new A.lc(new B.c0D(x),null,x,null)},
$S:1101}
B.c0D.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.eg(w,t,A.d(E.bm(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bhJ,C.a0,D.brm,C.I,A.ou(new B.c0y(s,r),q,A.d6([r.a],x),!1,A.kb(t,t,t,new A.br(new B.c0z(),v),t,t,t,t,new A.br(new B.c0A(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.ie(C.v,C.L,t,new B.c0B(s,r),D.bov,D.bup,r.c),A.ie(C.v,C.L,t,new B.c0C(s,r),t,D.bhh,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.aj,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gmJ(),t,t,t,t,F.aK,t,C.bg,t)],u))
x.push(C.B)
x.push(D.a2I)
return A.cu(!0,A.f8(A.I(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.fW,t,t,C.w),C.L,!0)},
$S:1102}
B.c0y.prototype={
$1(d){return this.a.qm(this.b.b7S(d.ga4(d)))},
$S:113}
B.c0A.prototype={
$1(d){return d.n(0,C.a2)?C.af:C.i},
$S:4}
B.c0z.prototype={
$1(d){return d.n(0,C.a2)?C.v:C.a8},
$S:4}
B.c0B.prototype={
$1(d){return this.a.qm(this.b.b7e(d))},
$S:3}
B.c0C.prototype={
$1(d){return this.a.qm(this.b.anD(d))},
$S:3}
B.b39.prototype={
$0(){return A.cz(A.bi(this.a,0,null),C.aT,null)},
$S:0}
B.c0U.prototype={
$1(d){var x,w=A.aB("https?://",!0,!1,!1)
w=A.bB(d,w,"")
x=A.aB("www\\.",!0,!1,!1)
return A.ux(A.bB(w,x,"www[.]"),A.aB("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c0V(),null)},
$S:32}
B.c0V.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:54}
B.bTE.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bTF.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bTG.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bTH.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bTJ.prototype={
$0(){var x=this.a
return x.k(new B.bTI(x))},
$S:0}
B.bTI.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c0T.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:195};(function installTearOffs(){var x=a._instance_0u
x(B.ahI.prototype,"gbdB","bdC",1)
var w
x(w=B.Ur.prototype,"gbdS","CM",0)
x(w,"gaC5","wk",0)
x(w=B.ZN.prototype,"goh","xs",1)
x(w,"gaW2","Pd",0)
x(w=B.a1a.prototype,"goh","xs",1)
x(w,"gaYA","Pz",0)
x(w,"gb1O","Be",0)
x(w,"gaHA","Ng",0)
x(w=B.a19.prototype,"goh","xs",1)
x(w,"gaZo","aZp",1)
x(B.a18.prototype,"goh","xs",1)
x(B.a1b.prototype,"gb3d","QI",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a5,[B.ahI,B.Us,B.IU,B.IW,B.IV,B.lr,B.Rx,B.mG,B.Hv,B.r3,B.ahJ,B.Uq])
x(A.kW,[B.b3a,B.b3c,B.b3h,B.b3i,B.b3k,B.b3j,B.aUs,B.b3q,B.bG3,B.bG2,B.bFR,B.bFY,B.bG0,B.bG1,B.bFU,B.bFT,B.bFW,B.bFS,B.bFZ,B.c_O,B.c_K,B.c_J,B.c_N,B.bT0,B.bTg,B.bTk,B.bTl,B.bTm,B.bTo,B.bTn,B.bTs,B.bTu,B.bTt,B.bTf,B.bTh,B.bT8,B.bT7,B.bTb,B.bTA,B.bTC,B.bTD,B.bTc,B.bTj,B.bTi,B.bT1,B.bT5,B.bT6,B.bSK,B.bST,B.bSS,B.bSX,B.bSO,B.bSP,B.bSL,B.bSM,B.bSN,B.bSR,B.bSZ,B.bT_,B.bSB,B.bSH,B.bSF,B.bSC,B.bSD,B.b39,B.bTE,B.bTF,B.bTG,B.bTH,B.bTJ,B.bTI])
x(A.ir,[B.b3d,B.b3f,B.b3g,B.b3e,B.aUr,B.bYE,B.b3o,B.b3p,B.b3m,B.bG4,B.bG5,B.bG6,B.bFX,B.bG_,B.bFV,B.c_T,B.c_S,B.c_P,B.c_R,B.c_L,B.c_M,B.bTp,B.bTr,B.bTq,B.bTv,B.bT9,B.bTa,B.bTB,B.bTz,B.bTw,B.bTx,B.bTy,B.bT2,B.bT4,B.bT3,B.bSU,B.bSW,B.bSV,B.bSQ,B.bSY,B.bSG,B.bSE,B.c0E,B.c0y,B.c0A,B.c0z,B.c0B,B.c0C,B.c0U,B.c0V,B.c0T])
x(A.pi,[B.b3b,B.bWF,B.b3r,B.b3s,B.c_Q,B.bTe,B.bTd,B.bSI,B.bSJ,B.c0D])
x(A.JM,[B.ng,B.Et,B.GB,B.Dv])
w(B.Ur,A.i7)
x(A.L,[B.wq,B.Cz,B.Cy,B.Cx,B.CA])
x(A.M,[B.ZN,B.a1a,B.a19,B.a18,B.a1b])
x(A.a3,[B.GC,B.WF,B.CQ,B.ahH])})()
A.oZ(b.typeUniverse,JSON.parse('{"lr":{"bN":[]},"Cz":{"L":[],"l":[]},"Cy":{"L":[],"l":[]},"Cx":{"L":[],"l":[]},"CA":{"L":[],"l":[]},"Ur":{"aC":[]},"wq":{"L":[],"l":[]},"ZN":{"M":["wq"]},"GC":{"a3":[],"l":[]},"WF":{"a3":[],"l":[]},"a1a":{"M":["Cz"]},"CQ":{"a3":[],"l":[]},"a19":{"M":["Cy"]},"a18":{"M":["Cx"]},"ahH":{"a3":[],"l":[]},"a1b":{"M":["CA"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("r3"),c:x("eg<x>"),r:x("cg<x>"),k:x("F<mG>"),n:x("F<eg<x>>"),I:x("F<cg<x>>"),R:x("F<hB>"),Z:x("F<aP<o,@>>"),d:x("F<Rx>"),s:x("F<o>"),p:x("F<l>"),t:x("F<x>"),m:x("bM"),j:x("a7<@>"),L:x("a7<x>"),P:x("aP<o,@>"),f:x("aP<@,@>"),x:x("au<o,x>"),a:x("bE"),K:x("a5"),B:x("Hv"),l:x("+(x,x)"),e:x("d8<mG>"),N:x("o"),C:x("IU"),D:x("IV"),X:x("Us"),_:x("IW"),U:x("am<o>"),G:x("ng"),q:x("oW"),b:x("br<U?>"),y:x("P"),i:x("a2"),z:x("@"),S:x("x"),A:x("bM?"),Y:x("aP<@,@>?"),O:x("a5?"),M:x("+quota,usage(x,x)?"),o:x("fm"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.oT=new B.Et(0,"none")
D.oU=new B.Et(1,"learning")
D.fb=new B.Et(2,"memorized")
D.a60=new A.aA(0,1/0,0,320)
D.eJ=new A.U(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a68=new A.E(D.eJ,null,null,null,null,null,null,C.bZ)
D.dU=new A.U(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.aqQ=new A.G(C.GQ,null,C.cw,null,null,null)
D.bsB=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.f3,null,null,null,null,null,null,null,null)
D.bah=new A.r(!0,C.eL,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bpg=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bah,null,null,null,null,null,null,null,null)
D.aHB=x([D.aqQ,C.I,D.bsB,D.bpg],y.p)
D.aea=new A.fb(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aHB,null)
D.ahA=new A.X(0,26,0,26)
D.ahE=new A.X(0,4,0,6)
D.ai1=new A.X(14,12,14,14)
D.aiI=new A.X(3,0,0,0)
D.ame=new A.Q(63251,"MaterialIcons",null,!1)
D.qn=new A.Q(63677,"MaterialIcons",null,!1)
D.xI=new A.Q(983516,"MaterialIcons",null,!1)
D.an2=new A.Q(983209,"MaterialIcons",null,!1)
D.anG=new A.G(D.an2,28,C.v,null,null,null)
D.aoi=new A.G(C.Gu,null,C.ig,null,null,null)
D.alY=new A.Q(62961,"MaterialIcons",null,!1)
D.aoZ=new A.G(D.alY,null,null,null,null,null)
D.amd=new A.Q(63199,"MaterialIcons",null,!1)
D.ap_=new A.G(D.amd,null,null,null,null,null)
D.ap8=new A.G(C.kQ,null,C.eL,null,null,null)
D.apb=new A.G(D.xI,44,C.i,null,null,null)
D.apF=new A.G(D.qn,null,D.eJ,null,null,null)
D.apW=new A.G(C.n_,null,D.eJ,null,null,null)
D.aqi=new A.G(D.qn,null,null,null,null,null)
D.aqM=new A.G(C.jq,20,D.dU,null,null,null)
D.ar7=new A.G(C.n6,30,C.v,null,null,null)
D.arz=new A.G(C.kU,16,C.v,null,null,null)
D.amy=new A.Q(63520,"MaterialIcons",null,!1)
D.as_=new A.G(D.amy,null,null,null,null,null)
D.asa=new A.G(C.n8,null,null,null,null,null)
D.alP=new A.Q(62842,"MaterialIcons",null,!0)
D.asn=new A.G(D.alP,null,null,null,null,null)
D.Ip=x([1,3,5],y.t)
D.Jb=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aUb=new A.H(C.mQ,C.mg,null)
D.aEt=x([D.aUb],y.p)
D.aYE=new A.Z(C.n2,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.aYs=new A.Z(D.qn,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.aYZ=new A.Z(C.dv,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.amM=new A.Q(63625,"MaterialIcons",null,!1)
D.aZa=new A.Z(D.amM,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aGy=x([D.aYE,D.aYs,D.aYZ,D.aZa],A.ae("F<+(Q,o)>"))
D.aIV=x([D.oT,D.oU,D.fb],A.ae("F<Et>"))
D.NP=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aQh=new B.GB(0,"idle")
D.U_=new B.GB(1,"loading")
D.jI=new B.GB(2,"ready")
D.aQi=new B.GB(3,"failed")
D.apD=new A.G(C.bV,18,G.cJ,null,null,null)
D.a1w=new A.r(!0,C.ap,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bty=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,D.a1w,null,null,null,null,null,null,null,null)
D.aDl=x([D.apD,C.b_,D.bty],y.p)
D.b46=new A.er(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aDl,null)
D.aT8=new A.H(C.aJ,D.b46,null)
D.aiG=new A.X(2,6,2,4)
D.b9Y=new A.r(!0,C.v,null,null,null,null,14,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhH=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.b9Y,null,null,null,null,null,null,null,null)
D.aTn=new A.H(D.aiG,D.bhH,null)
D.btX=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.f3,null,null,null,null,null,null,null,null)
D.aEN=x([N.tA,C.K,D.btX],y.p)
D.b41=new A.er(C.ae,C.cm,C.e,C.h,null,C.l,null,0,D.aEN,null)
D.aTx=new A.H(C.pL,D.b41,null)
D.AS=new A.r(!0,D.dU,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.buh=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.AS,null,null,null,null,null,null,null,null)
D.aTC=new A.H(C.dV,D.buh,null)
D.btt=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aK,C.Y,null,null,null,null,null,null,null)
D.aTK=new A.H(C.C,D.btt,null)
D.aiD=new A.X(2,0,2,8)
D.bpw=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aK,null,null,null,null,null,null,null,null)
D.aU2=new A.H(D.aiD,D.bpw,null)
D.arJ=new A.G(C.kS,30,C.v,null,null,null)
D.buX=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.AT,null,null,null,null,null,null,null,null)
D.ajN=new A.bT(1,C.ac,D.buX,null)
D.aF1=x([D.arJ,C.X,D.ajN],y.p)
D.b3P=new A.er(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aF1,null)
D.arj=new A.G(C.dv,18,G.cJ,null,null,null)
D.a0V=new A.r(!0,G.cJ,null,null,null,null,12,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.btb=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a0V,null,null,null,null,null,null,null,null)
D.aDM=x([D.arj,C.bQ,D.btb],y.p)
D.b4_=new A.er(C.ae,C.d,C.O,C.h,null,C.l,null,0,D.aDM,null)
D.b6e=new A.T(0,30)
D.b6f=new A.T(0,34)
D.tz=new A.T(1/0,54)
D.b6E=new A.T(1/0,48)
D.b6H=new A.T(1/0,50)
D.b6K=new A.T(1/0,52)
D.br5=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.b7G=new A.d9(D.br5,null,null,null,null,null,null,null,null,null,null,null,null,C.y,!1,null,null,null,C.m,null)
D.b9t=new A.r(!0,C.i,null,null,null,null,14.5,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b9Q=new A.r(!0,C.ap,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.AE=new A.r(!0,D.eJ,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.k6=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a14=new A.r(!0,D.eJ,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bdu=new A.r(!0,C.v,null,null,null,null,24,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bdM=new A.r(!0,C.v,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beC=new A.r(!0,D.dU,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beD=new A.r(!0,G.cJ,null,null,null,null,null,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beV=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgy=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.i0,null,null,null,null,null,null,null,null)
D.bhh=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.dl,null,null,null,null,null,null,null,null)
D.bhJ=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oj,null,null,null,null,null,null,null,null)
D.bhO=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aK,null,null,null,null,null,null,null,null)
D.bb6=new A.r(!0,G.cJ,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bi5=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bb6,null,null,null,null,null,null,null,null)
D.bid=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aK,null,null,null,null,null,null,null,null)
D.biB=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.f3,null,null,null,null,null,null,null,null)
D.bkj=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cC,null,null,null,null,null,null,null,null)
D.bl2=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bN,null,null,null,null,null,null,null,null)
D.bl7=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aK,null,null,null,null,null,null,null,null)
D.blA=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.AX,null,null,null,null,null,null,null,null)
D.bmN=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bnn=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.on,null,null,null,null,null,null,null,null)
D.bo6=new A.m("reset safe mode / WebGPU ban",null,P.a0s,null,null,null,null,null,null,null,null)
D.bok=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.AS,null,null,null,null,null,null,null,null)
D.bov=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aK,null,null,null,null,null,null,null,null)
D.boW=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bz,null,null,null,null,null,null,null,null)
D.bpe=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.bpx=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.bqS=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a1s,null,null,null,null,null,null,null,null)
D.bcJ=new A.r(!0,D.eJ,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bqW=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bcJ,null,null,null,null,null,null,null,null)
D.brm=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.on,null,null,null,null,null,null,null,null)
D.brU=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0k,null,null,null,null,null,null,null,null)
D.bs7=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cC,null,null,null,null,null,null,null,null)
D.bst=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bsL=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.btl=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aK,null,null,null,null,null,null,null,null)
D.btm=new A.m("\u062e\u0644\u0635\u062a",null,O.op,null,null,null,null,null,null,null,null)
D.btn=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.AS,null,null,null,null,null,null,null,null)
D.bdO=new A.r(!0,C.cI,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.hY,null,null,null,null,null,null,null,null)
D.bu6=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bdO,null,null,null,null,null,null,null,null)
D.bul=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bz,null,null,null,null,null,null,null,null)
D.bup=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.dl,null,null,null,null,null,null,null,null)
D.buW=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aK,null,null,null,null,null,null,null,null)
D.a2I=new B.ahH(null)
D.bwh=new B.Cx(null)
D.bwi=new B.Uq(2,1,!0,!1,!1)
D.a2N=new B.Us(!1,!1,!1,!1,!1,0)
D.iS=new B.ng(0,"ok")
D.um=new B.ng(1,"near")
D.un=new B.ng(2,"wrong")
D.uo=new B.ng(3,"missing")
D.a3d=new B.ng(4,"extra")
D.amt=new A.Q(63456,"MaterialIcons",null,!1)
D.bBG=new B.CQ(D.dU,D.amt,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bCj=new B.WF(!1,null)
D.Bs=new B.WF(!0,null)
D.m2=new B.Dv(0,"idle")
D.uC=new B.Dv(1,"playing")
D.uD=new B.Dv(2,"recording")
D.oK=new B.Dv(3,"thinking")
D.iZ=new B.Dv(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cI_","c6y",()=>new B.ahI())
x($,"cLi","clF",()=>A.aB("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cLj","clG",()=>A.aB("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cLv","clP",()=>A.aB("\u0648\u0670",!0,!1,!1))
x($,"cKR","cll",()=>A.aB("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cJb","ckb",()=>A.aB("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cKn","ckY",()=>A.aB("[\u0654\u0655]",!0,!1,!1))
x($,"cJc","ckc",()=>A.aB("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cJj","cki",()=>A.aB("[\u0624\u0626]",!0,!1,!1))
x($,"cKp","cl_",()=>A.aB("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cKW","clo",()=>A.aB("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cKx","cl6",()=>A.aB("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cLg","c76",()=>A.aB("\\s+",!0,!1,!1))
x($,"cFi","qS",()=>B.cmE(D.oT,0,A.c29(0,!0)))
x($,"cI0","LP",()=>new B.Ur($.c6y(),D.bwi,B.cuw(),D.aQh,$.S()))})()};
(a=>{a["8IF4BChyFXAcB3ozrQsRjkEqwPI="]=a.current})($__dart_deferred_initializers__);