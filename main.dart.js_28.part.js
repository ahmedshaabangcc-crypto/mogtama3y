((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,Q,H,G,N,R,K,B={
cAS(d){var x,w,v,u,t,s
if(d instanceof B.lE)return d
try{x=A.cS(d)
w=x.code
v=x.message
u=w==null?"failed":A.S(w)
t=v==null?"":A.S(v)
return new B.lE(u,t)}catch(s){u=A.n(d)
return new B.lE("failed",u)}},
ajq:function ajq(){this.b=this.a=null},
b5F:function b5F(d){this.a=d},
b5I:function b5I(){},
b5H:function b5H(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b5G:function b5G(d){this.a=d},
b5M:function b5M(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b5K:function b5K(d){this.a=d},
b5L:function b5L(d){this.a=d},
b5N:function b5N(d){this.a=d},
b5P:function b5P(d,e,f){this.a=d
this.b=e
this.c=f},
b5O:function b5O(d,e,f){this.a=d
this.b=e
this.c=f},
b5J:function b5J(){},
cAT(d,e){return new B.lE(d,e)},
VF:function VF(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
JP:function JP(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
JR:function JR(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
JQ:function JQ(d,e){this.a=d
this.b=e},
lE:function lE(d,e){this.a=d
this.b=e},
cn6(d){var x,w=$.crP()
w=A.bE(d,w,"\u0627")
x=$.crQ()
w=A.bE(w,x,"\u064a")
x=$.crZ()
w=A.bE(w,x,"\u0627")
x=$.cqk()
w=A.bE(w,x,"\u0627")
x=$.crv()
w=A.bE(w,x,"\u0621")
x=$.cr7()
w=A.bE(w,x,"\u0621")
x=$.cql()
w=A.bE(w,x,"\u0627")
x=$.cqr()
w=A.bE(w,x,"\u0621")
w=A.bE(w,"\u0649","\u064a")
w=A.bE(w,"\u0629","\u0647")
x=$.cr9()
w=A.bE(w,x,"")
x=$.cry()
w=A.bE(w,x," ")
x=$.crg()
w=A.bE(w,x," ")
x=$.ccN()
return C.c.O(A.bE(w,x," "))},
cFz(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
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
c6D(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aD("[\u0627\u0621]",!0,!1,!1)
w=A.bE(d,x,"")
x=A.aD("[\u0627\u0621]",!0,!1,!1)
v=A.bE(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cFz(d,e)/u
return s>=1?0.99:s},
EZ(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tZ(d,$.ccN()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.cn6(u)
s=A.bE(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.SK(r.a+" "+u,r.b))}continue}q.push(new B.SK(u,s))}return q},
cEe(d,e){var x,w,v,u,t=new B.c0D(),s=A.a([],y.s)
for(x=A.fw(e,0,A.ii(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.cb(x,x.gM(0),w.i("cb<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.Kk)&&t.$2(d,D.Kk)?C.b.jz(d,5):d
return!t.$2(s,D.OZ)&&t.$2(u,D.OZ)?C.b.jz(u,4):u},
cm2(d,e){var x=B.EZ(d),w=B.cn6(e),v=y.U
v=A.a9(new A.ag(A.a(w.split(" "),y.s),new B.c2K(),v),v.i("Z.E"))
return new B.It(x,B.cDp(x,B.cEe(v,x)),w)},
cDp(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.co(x,0,!1,s)
q=A.co(x,0,!1,y.S)
p=A.co(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c6D(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c6D(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c6D(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
else m=a2>=0.6?D.uL:D.uM
a1.push(new B.mW(o,x,s,m))
break
case 1:--o
a1.push(new B.mW(o,a4[o],null,D.uN))
break
case 2:--n
a1.push(new B.mW(null,null,a6[n],D.a4h))
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
SK:function SK(d,e){this.a=d
this.b=e},
mW:function mW(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
It:function It(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aWP:function aWP(d){this.a=d},
aWO:function aWO(){},
c0D:function c0D(){},
c2K:function c2K(){},
csO(d,e,f){return new B.rt(d,e,f)},
cGu(d){var x
A:{if("memorized"===d){x=D.fi
break A}if("learning"===d){x=D.pc
break A}x=D.pb
break A}return x},
co6(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cQ[d-1].a[1]},
cAU(){var x=y.S
return new B.ajr(A.B(x,y.u),A.aS(x))},
b5S(d){var x=d.ff()
return C.c.dq(C.j.k(A.br(x)),4,"0")+"-"+C.c.dq(C.j.k(A.bt(x)),2,"0")+"-"+C.c.dq(C.j.k(A.bW(x)),2,"0")},
ciY(d){var x=y.x,w=A.a9(new A.au(A.a(d.split("-"),y.s),A.cHU(),x),x.i("aW.E"))
return B.b5S(A.du(w[0],w[1],w[2]-1,12,0,0,0))},
c9N(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.B(p,y.u),n=A.aS(p),m=new B.ajr(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcN(),x=x.ga0(x),w=y.j;x.v();){v=x.gG()
u=A.dU(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aR(t)>=3){v=C.j.aH(u,1000)
s=C.j.a3(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cQ[v-1].a[1])}if(v)continue
v=J.bd(t)
r=C.f.bB(A.cN(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rt(D.aLh[r],C.f.bB(A.cN(v.h(t,1))),new A.aQ(A.ks(C.f.bB(A.cN(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aAK(q,y.o)
p=A.mr(x,new B.b5R(),x.$ti.i("Z.E"),p)
n.A(0,new A.ag(p,o.ga3Z(),A.y(p).i("ag<Z.E>")))}m.c=A.t(d.h(0,"last"))
p=A.ax(d.h(0,"streak"))
p=p==null?null:C.f.bB(p)
p=m.d=p==null?0:p
o=A.ax(d.h(0,"best"))
o=o==null?null:C.f.bB(o)
m.e=o==null?p:o
return m},
aA1(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dq(C.j.k(d),3,"0")+C.c.dq(C.j.k(e),3,"0")+".mp3"},
Fg:function Fg(d,e){this.a=d
this.b=e},
rt:function rt(d,e,f){this.a=d
this.b=e
this.c=f},
ajr:function ajr(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b5T:function b5T(){},
b5U:function b5U(){},
b5R:function b5R(){},
VD:function VD(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cym(){return new B.wW(null)},
cKk(d,e){var x,w,v,u,t={},s=I.cQ[e-1].a[1],r=$.MU().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.ri():v).a===D.fi}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.cZ(u+4,1,s)
return A.e_(C.cM,new B.c5g(t,s,e),d,!0,null,null,!1,y.l)},
cbz(d){return A.dp(0,0,0,0,0,C.j.cZ(C.f.ak(6+d*1.2),25,90))},
cau(d){return E.bq(C.j.aH(d,60))+":"+C.c.dq(E.bq(C.j.a3(d,60)),2,"\u0660")},
cnT(d){return A.e_(C.cM,new B.c6d($.MU()),d,!0,null,null,!1,y.H)},
MN(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl3()
break A}return x},
cLG(d,e,f){var x,w=new B.c6w(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
co1(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.am.f0(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.eI:r
q=s.a(J.av(x,"last"))
v=q==null?C.eI:q
u=new B.c6v()
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
a0=J.aR(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.k(J.av(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.k(J.av(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
Hq:function Hq(d,e){this.a=d
this.b=e},
VE:function VE(d,e,f,g,h){var _=this
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
b5V:function b5V(d){this.a=d},
b5W:function b5W(d){this.a=d},
b5X:function b5X(d){this.a=d},
wW:function wW(d){this.a=d},
a06:function a06(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bKl:function bKl(d){this.a=d},
bKk:function bKk(d,e){this.a=d
this.b=e},
bKm:function bKm(d){this.a=d},
bKj:function bKj(d,e){this.a=d
this.b=e},
bKn:function bKn(){},
bK7:function bK7(){},
bKd:function bKd(d,e,f){this.a=d
this.b=e
this.c=f},
bKe:function bKe(){},
bKh:function bKh(d){this.a=d},
bKg:function bKg(){},
bKi:function bKi(d){this.a=d},
bKa:function bKa(d,e){this.a=d
this.b=e},
bKb:function bKb(d){this.a=d},
bK9:function bK9(){},
bKc:function bKc(d){this.a=d},
bK8:function bK8(d){this.a=d},
bKf:function bKf(d,e){this.a=d
this.b=e},
Hr:function Hr(d,e,f){this.c=d
this.d=e
this.a=f},
XW:function XW(d,e){this.c=d
this.a=e},
c5g:function c5g(d,e,f){this.a=d
this.b=e
this.c=f},
c5d:function c5d(d,e,f){this.a=d
this.b=e
this.c=f},
c5f:function c5f(d,e){this.a=d
this.b=e},
c5c:function c5c(d,e){this.a=d
this.b=e},
c5b:function c5b(d,e){this.a=d
this.b=e},
c5e:function c5e(d,e){this.a=d
this.b=e},
c57:function c57(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c56:function c56(d,e,f){this.a=d
this.b=e
this.c=f},
c58:function c58(d){this.a=d},
c59:function c59(d){this.a=d},
c5a:function c5a(d,e){this.a=d
this.b=e},
Eg:function Eg(d,e){this.a=d
this.b=e},
Df:function Df(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2B:function a2B(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bXX:function bXX(){},
bYc:function bYc(d,e){this.a=d
this.b=e},
bYg:function bYg(d){this.a=d},
bYh:function bYh(d){this.a=d},
bYi:function bYi(d,e,f){this.a=d
this.b=e
this.c=f},
bYk:function bYk(d){this.a=d},
bYl:function bYl(d){this.a=d},
bYj:function bYj(){},
bYn:function bYn(d){this.a=d},
bYm:function bYm(d){this.a=d},
bYo:function bYo(d,e){this.a=d
this.b=e},
bYq:function bYq(d){this.a=d},
bYr:function bYr(d){this.a=d},
bYp:function bYp(){},
bYb:function bYb(d,e,f){this.a=d
this.b=e
this.c=f},
bYd:function bYd(d,e,f){this.a=d
this.b=e
this.c=f},
bY4:function bY4(d){this.a=d},
bY5:function bY5(d){this.a=d},
bY3:function bY3(){},
bY6:function bY6(){},
bY7:function bY7(d,e){this.a=d
this.b=e},
bYw:function bYw(d){this.a=d},
bYx:function bYx(d){this.a=d},
bYy:function bYy(d,e){this.a=d
this.b=e},
bYv:function bYv(d){this.a=d},
bYz:function bYz(d,e){this.a=d
this.b=e},
bYa:function bYa(){},
bY9:function bY9(d){this.a=d},
bY8:function bY8(d,e){this.a=d
this.b=e},
bYf:function bYf(d){this.a=d},
bYe:function bYe(d){this.a=d},
bYs:function bYs(){},
bYt:function bYt(){},
bYu:function bYu(){},
bXY:function bXY(d,e,f){this.a=d
this.b=e
this.c=f},
bXZ:function bXZ(d){this.a=d},
bY0:function bY0(){},
bY_:function bY_(){},
bY1:function bY1(d){this.a=d},
bY2:function bY2(d){this.a=d},
Dy:function Dy(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
De:function De(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2A:function a2A(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bXG:function bXG(){},
bXP:function bXP(d,e){this.a=d
this.b=e},
bXQ:function bXQ(d){this.a=d},
bXO:function bXO(){},
bXS:function bXS(d){this.a=d},
bXR:function bXR(d,e){this.a=d
this.b=e},
bXT:function bXT(d,e){this.a=d
this.b=e},
bXK:function bXK(d,e){this.a=d
this.b=e},
bXL:function bXL(d,e,f){this.a=d
this.b=e
this.c=f},
bXM:function bXM(d,e,f){this.a=d
this.b=e
this.c=f},
bXH:function bXH(d,e,f){this.a=d
this.b=e
this.c=f},
bXI:function bXI(d,e,f){this.a=d
this.b=e
this.c=f},
bXJ:function bXJ(d,e){this.a=d
this.b=e},
bXN:function bXN(d){this.a=d},
bXU:function bXU(){},
bXV:function bXV(d,e){this.a=d
this.b=e},
bXW:function bXW(d,e){this.a=d
this.b=e},
Dd:function Dd(d){this.a=d},
a2z:function a2z(d){this.d=d
this.c=this.a=null},
bXx:function bXx(){},
bXE:function bXE(d){this.a=d},
bXF:function bXF(){},
bXD:function bXD(d,e){this.a=d
this.b=e},
bXC:function bXC(d,e,f){this.a=d
this.b=e
this.c=f},
bXB:function bXB(d,e,f){this.a=d
this.b=e
this.c=f},
bXA:function bXA(d){this.a=d},
bXy:function bXy(d){this.a=d},
bXz:function bXz(d){this.a=d},
c6d:function c6d(d){this.a=d},
c6c:function c6c(d){this.a=d},
c67:function c67(d,e){this.a=d
this.b=e},
c69:function c69(){},
c68:function c68(){},
c6a:function c6a(d,e){this.a=d
this.b=e},
c6b:function c6b(d,e){this.a=d
this.b=e},
ajp:function ajp(d){this.a=d},
b5E:function b5E(d){this.a=d},
c6w:function c6w(){},
c6x:function c6x(){},
Dg:function Dg(d,e,f){this.c=d
this.d=e
this.a=f},
a2C:function a2C(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bYA:function bYA(d){this.a=d},
bYB:function bYB(d){this.a=d},
bYC:function bYC(d,e){this.a=d
this.b=e},
bYD:function bYD(d){this.a=d},
bYF:function bYF(d){this.a=d},
bYE:function bYE(d){this.a=d},
c6v:function c6v(){}},D,O,P,I,E,F
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
B.ajq.prototype={
ra(){var x=this,w=x.a
if(w!=null)return A.el(w,y.m)
w=x.b
return w==null?x.b=new B.b5F(x).$0():w},
uo(d,e){return this.aNQ(d,e,e)},
aNQ(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
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
r=B.cAS(s)
throw A.r(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$uo,w)},
oq(d,e){var x=A.eh(d[e])
if(x==null)x=null
return x===!0},
MX(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$MX=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.ra(),$async$MX)
case 7:r=h.cS(g.cM(e,"support",null,null,null,null))
q=s.oq(r,"worker")
p=s.oq(r,"wasm")
o=s.oq(r,"mic")
n=s.oq(r,"audio")
s.oq(r,"webgpu")
m=s.oq(r,"secure")
s.oq(r,"ios")
l=A.jQ(r.memory)
if(l==null)l=null
if(l==null)l=0
s.oq(r,"isolated")
k=A.jQ(r.cores)
if(k!=null)C.f.ak(k)
v=new B.VF(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a3R
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$MX,w)},
Eu(){var x=0,w=A.j(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Eu=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.ra(),$async$Eu)
case 8:x=7
return A.c(m.eF(l.cS(k.cM(e,"storage",null,null,null,null)),y.A),$async$Eu)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.ak(A.dQ(r.quota))
p=C.f.ak(A.dQ(r.usage))
v=new A.atw(q,p)
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
return A.i($async$Eu,w)},
bjY(){var x=y.K
A.PL(this.ra().bH(new B.b5I(),x),x)},
r9(d,e){var x=A.jQ(d[e])
x=x==null?null:C.f.ak(x)
return x==null?0:x},
bhj(d,e,f){return this.uo(new B.b5H(this,d,e,f),y.C)},
gakR(){var x,w
try{x=A.kj(b.G.sessionStorage)
return x}catch(w){return null}},
gasp(){var x=A.eh(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a9g(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.eh(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gasp())return!1
l=A.eh(m.isSecureContext)
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
if(!l.b.test(w))i=J.k(u,"MacIntel")&&v>1
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
l=this.gakR()
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
aqV(){var x,w,v,u,t,s,r=null
try{x=this.gakR()
if(x!=null)A.cM(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cS(x.location)
u=A.S(v.hash)
t=A.S(v.search)
s=A.by(A.S(A.cS(x.document).baseURI),0,r).a2("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cM(v,"replace",s+t+x,r,r,r)},
bh2(){var x,w=null,v=b.G,u=A.cS(v.history),t=A.jQ(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cM(u,"back",w,w,w,w)
else{x=A.S(A.cS(v.document).baseURI)
A.cM(A.cS(v.location),"replace",A.by(x,0,w).a2("./").k(0)+"#/",w,w,w)}},
a9s(d,e,f,g,h){return this.uo(new B.b5M(this,e,d,f,h,g),y.H)},
a9w(){return this.uo(new B.b5N(this),y.D)},
a3C(){var x=null,w=this.a
if(w!=null)A.cM(w,"cancelRecording",x,x,x,x)},
amh(d){var x,w,v=this,u=A.t(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.r9(d,"ms")
w=A.jQ(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.JR(u,x,w,v.r9(d,"frames"),v.r9(d,"tokens"),v.oq(d,"retried"),v.r9(d,"encMs"),v.r9(d,"decMs"),v.r9(d,"featMs"))},
aiF(d){var x={}
x.words=d
return x},
avu(d,e){return this.uo(new B.b5P(this,d,e),y._)},
bma(d,e){return this.uo(new B.b5O(this,d,e),y._)},
KZ(d,e){return this.bk3(d,e)},
bk3(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$KZ=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.ra(),$async$KZ)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.al(d).i("au<1,o>")
o=A.a9(new A.au(d,new B.b5J(),o),o.i("aW.E"))
x=11
return A.c(A.eF(A.cS(A.cM(r,"play",o,e,null,null)),y.y),$async$KZ)
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
return A.i($async$KZ,w)},
ME(){var x=null,w=this.a
if(w!=null)A.cM(w,"stopPlayback",x,x,x,x)},
Jr(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.S(A.cM(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
blj(){var x,w,v=null
try{x=this.a
if(x!=null)A.cM(x,"resetDevice",v,v,v,v)}catch(w){}},
a6V(d){var x=this.a
if(x!=null)A.cM(x,"prefetch",d,null,null,null)}}
B.VF.prototype={}
B.JP.prototype={
gn3(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.JR.prototype={
gT3(){var x=this,w=C.f.az(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.JQ.prototype={}
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
$ibO:1}
B.nE.prototype={
R(){return"WordStatus."+this.b}}
B.SK.prototype={}
B.mW.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.It.prototype={
gMC(){var x,w=this,v=w.d
if(v===$){x=new B.aWP(w).$0()
w.d!==$&&A.aq()
w.d=x
v=x}return v},
gJK(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a4h&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbia(){return J.h7(this.gMC(),new B.aWO()).gM(0)},
gts(){var x=this.a
return x.length!==0&&this.gbia()===x.length&&this.gJK().length===0}}
B.Fg.prototype={
R(){return"AyahStatus."+this.b}}
B.rt.prototype={}
B.ajr.prototype={
a6w(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.ri():x},
b_t(d){var x=this,w=B.b5S(d),v=x.c
if(v===w)return
v=v!=null&&v===B.ciY(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
aq6(){var x=Date.now(),w=B.b5S(new A.aQ(x,0,!1))
x=this.c
return x===w||x===B.ciY(w)?this.d:0},
auv(d,e,f,g){var x=this,w=new A.aQ(Date.now(),0,!1),v=x.a6w(d,e),u=g?C.j.cZ(v.b+1,0,100):0,t=g&&u>=f?D.fi:D.pc,s=new B.rt(t,u,w.hd()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.b_t(w)
return s},
a6n(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cQ[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.ri():s).a===D.fi)++u}return u},
bh0(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cQ[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.ri():s).a===D.pc)++u}return u},
gatw(){var x=this.a,w=A.y(x).i("c5<2>")
return new A.ag(new A.c5(x,w),new B.b5T(),w.i("ag<Z.E>")).gM(0)},
gaz9(){var x=this.a,w=A.y(x).i("bK<1>")
w=A.mr(new A.bK(x,w),new B.b5U(),w.i("Z.E"),y.S)
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
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
bcW(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b4e(x,300,A.y(x).c),x=new A.Jx(J.aw(x.a),x.b,A.y(x).i("Jx<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gG()
s=C.j.aH(t,1000)
t=C.j.a3(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.ri():q).a===D.fi?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.ri()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.ri():r).c.iT()],w,v))}return o},
bhB(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.L)(d),++u){t=d[u]
s=A.ey(t.h(0,"surah"))*1000+A.ey(t.h(0,"ayah"))
r=w.h(0,C.j.aH(s,1000)*1000+C.j.a3(s,1000))
if((r==null?$.ri():r).c.iT()===t.h(0,"updated_at"))v.K(0,s)}},
bhJ(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aw(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gG()
if(!u.b(s))continue
r=A.ax(s.h(0,"surah"))
q=r==null?null:C.f.bB(r)
r=A.ax(s.h(0,"ayah"))
p=r==null?null:C.f.bB(r)
o=A.dO(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cQ[q-1].a[1])
if(r)continue
n=B.cGu(s.h(0,"status"))
if(n===D.pb)continue
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
B.VD.prototype={
Ja(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.VD(w,v,u,t,f==null?x.e:f)},
bba(d){var x=null
return this.Ja(x,x,d,x,x)},
apC(d){var x=null
return this.Ja(x,d,x,x,x)},
bbe(d){var x=null
return this.Ja(x,x,x,x,d)},
bax(d){var x=null
return this.Ja(d,x,x,x,x)},
bbb(d){var x=null
return this.Ja(x,x,x,d,x)},
dr(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Hq.prototype={
R(){return"ModelState."+this.b}}
B.VE.prototype={
vF(){var x=this.Q
return x==null?this.Q=new B.b5V(this).$0():x},
qK(d){return this.axn(d)},
axn(d){var x=0,w=A.j(y.H),v=this
var $async$qK=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a5()
x=2
return A.c(A.ij("mt.tutor.settings",C.am.hk(d.dr(),null)),$async$qK)
case 2:return A.h(null,w)}})
return A.i($async$qK,w)},
zR(){var x=0,w=A.j(y.H),v=this,u
var $async$zR=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a5()
x=2
return A.c(A.ij("mt.tutor.progress",C.am.hk(v.c.dr(),null)),$async$zR)
case 2:u=v.as
if(u!=null)u.aA()
v.as=A.cR(C.x,v.gaEc())
return A.h(null,w)}})
return A.i($async$zR,w)},
Mm(d,e,f){return this.ay9(d,e,f)},
ay9(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$Mm=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.b_(d,e,f)
x=2
return A.c(A.ij("mt.tutor.last",C.am.hk(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Mm)
case 2:return A.h(null,w)}})
return A.i($async$Mm,w)},
Dd(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Dd=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.Vd||n===D.jU){x=1
break}s.f=D.Vd
s.y=null
s.a5()
u=4
n=A.lF().geI().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lF().geI().h(0,"tutor_threads")
p=A.dU(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bhj(new B.b5W(s),n,p),$async$Dd)
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
s.f=D.aSS
s.y=q
n=A.lF().geI().h(0,"debug")
if(n==="1")A.rd().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a5()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Dd,w)},
wC(){var x=0,w=A.j(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wC=A.e(function(a0,a1){if(a0===1){t.push(a1)
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
return A.c(p.aS("quran_tutor_progress").d6("surah, ayah, status, perfect_count, updated_at"),$async$wC)
case 7:o=a1
n=r.c.bhJ(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bcW()
if(J.aR(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.n3(h.x,k,k))
x=11
return A.c(f.blI("quran_tutor_save",!1,g,i),$async$wC)
case 11:r.c.bhB(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.ij("mt.tutor.progress",C.am.hk(r.c.dr(),null)),$async$wC)
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
return A.i($async$wC,w)},
Lf(d){return this.bll(d)},
bll(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Lf=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c9N(t.c.dr()).dr()
y.f.a(p.h(0,"rows")).ek(0,new B.b5X(d))
t.c=B.c9N(p)
x=2
return A.c(t.zR(),$async$Lf)
case 2:v=4
s=$.C().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.ar("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$Lf)
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
return A.i($async$Lf,w)}}
B.wW.prototype={
P(){var x=$.MU()
return new B.a06(x,new A.ah(C.L,$.X()))}}
B.a06.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.aa(v.goC())
w=y.a
x.vF().bH(new B.bKl(v),w)
H.aVh().bH(new B.bKm(v),w).fw(new B.bKn())
A.PL(H.c98(),y.y)},
xR(){if(this.c!=null)this.j(new B.bK7())},
m(){var x,w=this
w.d.T(w.goC())
x=w.e
x.q$=$.X()
x.L$=0
w.a_()},
Q3(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$Q3=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qK(s.b.bba(!0)),$async$Q3)
case 3:t=s.a
t.bjY()
if(t.a9g()){t.aqV()
x=1
break}s.Dd()
case 1:return A.h(v,w)}})
return A.i($async$Q3,w)},
xS(d,e,f){return this.aYk(d,e,f)},
b6f(d){return this.xS(d,null,null)},
aYk(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$xS=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.J(y.q).f.Z(A.aN(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.W(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cKk(s,d),$async$xS)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Mm(d,t.a,t.b),$async$xS)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.N(s,!1).aC(A.az(new B.bKd(u,d,t),null,r),r),$async$xS)
case 8:if(u.c!=null)u.j(new B.bKe())
case 1:return A.h(v,w)}})
return A.i($async$xS,w)},
u(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gasp()&&!A.N(d,!1).v9())u.push(A.bQ(x,x,x,x,C.yD,x,x,t.gbh1(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bQ(x,x,x,x,D.au6,x,x,new B.bKh(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bQ(x,x,x,x,C.iy,x,x,new B.bKi(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aGM
else w=t?this.aTd():this.aTP()
return L.xG(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aTP(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a3R
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b6I,C.a1],x)
for(t=0;t<4;++t){s=D.aIV[t]
u.push(new A.D(C.bt,A.A(A.a([A.b0(s.a,C.an,p,18),C.M,new A.bY(1,C.ah,A.d(s.b,p,p,p,p,p,G.a1p,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.by2,C.G,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bq(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,p,F.aM,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bq(C.f.ak(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.G,A.d(q,p,p,p,p,p,A.bC(p,p,r?D.dZ:C.cG,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.G,D.bx3],x))
x=A.a([new E.dC(u,C.a4,C.aJ,p,!0,p),new E.dC(A.I(s,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,p,!1,p),D.bGt,C.G],x)
if(v!=null)x.push(new E.dC(A.d(v,p,p,p,p,p,D.bhM,p,p,p),C.a4,C.aJ,p,!1,p))
else x.push(A.fp(D.aqZ,D.bnF,this.gaYB(),A.ev(C.v,C.ae,D.b9J,p,p,p,p)))
x.push(C.a5)
x.push(D.a3N)
return x},
aTd(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.O(r.a.a),p=q.length===0,o=p?C.rt:H.cnM(q),n=t.z,m=A.Q(v.alz(C.dz,E.bq(s.gatw())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bq(s.aq6()),k=s.c,j=Date.now()
k=k===B.b5S(new A.aQ(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Hr(t,!1,u),A.A(A.a([m,C.M,A.Q(v.alz(C.l7,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.t],j)
if(n!=null){t=H.kl(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bq(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bq(m)+"\u2013"+E.bq(l)
k.push(new E.dC(A.A(A.a([D.atc,C.Y,A.Q(A.I(A.a([D.bjK,A.d(t+" \u2014 "+m,u,u,u,u,u,C.bw,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nz],j),C.h,C.d,C.e,0,u,u),C.a4,C.aJ,new B.bKa(v,n),!0,u))}t=C.i.ad(0.08)
k.push(A.aH(u,C.y,!1,u,!0,C.m,u,A.aJ(),r,u,u,u,u,u,2,A.cH(u,new A.cj(4,A.v(14),C.O),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.ug,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qP,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bKb(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.cU,!0,C.u,u,C.E,u,u,u,u))
k.push(C.t)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bt1)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.Ro(o[x]))
C.b.A(k,t)}else{t=A.a([D.aW9,D.aWR,v.Ro(1)],j)
for(w=114;w>=78;--w)t.push(v.Ro(w))
t.push(C.G)
r=v.f
p=A.b0(r?C.yj:C.l6,C.an,u,u)
t.push(A.ff(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,u,C.fb,u,u,u),new B.bKc(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Ro(w))
C.b.A(k,t)}k.push(C.a1)
k.push(D.Cl)
return k},
alz(d,e,f){var x=null,w=y.p
return new E.dC(A.A(A.a([A.b0(d,C.v,x,x),C.M,A.Q(A.I(A.a([A.d(e,x,x,x,x,x,C.bw,x,x,x),A.d(f,x,1,C.N,x,x,C.a24,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a4,C.H,x,!1,x)},
Ro(d){var x,w=null,v=this.d.c,u=I.cQ[d-1].a[1],t=v.a6n(d),s=t/u,r=y.p,q=A.ao(A.dB(C.P,A.a([A.c7y(C.eU,G.cN,w,w,w,w,w,3,s,w),A.d(E.bq(d),w,w,w,w,w,Q.a2q,w,w,w)],r),C.m,C.bk,w),36,36),p=A.d(H.kl(d),w,w,w,w,w,D.bcB,w,w,w)
if(t===0)x=E.bq(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bq(t)+" \u0645\u0646 "+E.bq(u)
r=A.a([q,C.cF,A.Q(A.I(A.a([p,A.d(x,w,w,w,w,w,A.bC(w,w,t===u?G.cN:C.cG,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bq(C.f.ak(s*100))+"\u066a",w,w,w,w,w,D.a1V,w,w,w))
r.push(D.ar6)
return new E.dC(A.A(r,C.h,C.d,C.e,0,w,w),C.q7,C.d1,new B.bKf(this,d),!1,w)}}
B.Hr.prototype={
u(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aVU
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.MN(x),r,r,r,r,r,D.Bv,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.Dg(w,"model load",r))
x.push(C.G)
x.push(new A.zX(C.a4C,!1,q.gbhi(),r,r,r,r,C.k,r,!1,r,!0,r,C.uu,r))
return new E.dC(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.cZ(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bq(C.f.ak(u/1e6))+" \u0645\u0646 "+E.bq(C.f.ak(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,r,C.oF,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fb(x,A.q9(C.eU,C.v,7,s?t:r,r),C.az)],w)
if(!this.d)C.b.A(x,A.a([C.G,D.bov],w))
return new E.dC(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)}}}
B.XW.prototype={
u(d){var x=null,w=D.dZ.ad(0.1),v=A.v(14),u=A.aI(D.dZ.ad(0.4),1)
return A.F(x,A.A(A.a([D.asR,C.M,A.Q(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,x,C.BC,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.G(w,x,u,v,x,x,x,C.n),x,x,x,C.aJ,C.ac,x,x,x)}}
B.Eg.prototype={
R(){return"_Phase."+this.b}}
B.Df.prototype={
P(){return new B.a2B($.MU(),D.ml)}}
B.a2B.prototype={
gjd(){var x=this.e
return x===$?this.e=this.a.d:x},
gBN(){var x,w=this.a,v=w.f
w=w.c
x=this.gjd()
return H.ML(w,x,v.y3(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.aa(w.goC())
x.vF()
x.a.a6V(B.aA1(w.a.c,w.gjd()))},
xR(){if(this.c!=null)this.j(new B.bXX())},
m(){var x,w=this,v=w.d
v.T(w.goC())
x=w.Q
if(x!=null)x.aA()
v=v.a
v.ME()
v.a3C()
w.a_()},
a_d(d){var x,w,v=this
if(v.f===D.v1)v.d.a.a3C()
x=v.d.a
x.ME()
w=v.Q
if(w!=null)w.aA()
v.j(new B.bYc(v,d))
x.a6V(B.aA1(v.a.c,d))
w=v.a
if(d<w.e)x.a6V(B.aA1(w.c,d+1))},
RF(d){return this.aUG(d)},
aUG(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$RF=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.v0){u.d.a.ME()
u.j(new B.bYg(u))
x=1
break}t=u.r!=null?D.jc:D.ml
u.j(new B.bYh(u))
s=u.d
r=A.a([B.aA1(u.a.c,u.gjd())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.KZ(r,q),$async$RF)
case 3:p=f
if(u.c==null||u.f!==D.v0){x=1
break}u.j(new B.bYi(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$RF,w)},
Qt(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Qt=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jU){x=1
break}p=l.a
p.ME()
r=B.EZ(s.gBN()).length
s.j(new B.bYk(s))
o=s.Q
if(o!=null)o.aA()
s.Q=A.hD(C.eY,new B.bYl(s))
u=4
o=B.cbz(r)
n=A.dp(0,0,0,350*r,0,0)
x=7
return A.c(p.a9s(l.b.c,o,n,new B.bYm(s),new B.bYn(s)),$async$Qt)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lE){q=l
l=s.Q
if(l!=null)l.aA()
if(s.c!=null)s.j(new B.bYo(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Qt,w)},
BH(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$BH=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.v1){x=1
break}m=s.Q
if(m!=null)m.aA()
s.j(new B.bYq(s))
s.Q=A.hD(C.it,new B.bYr(s))
l=new A.CI()
$.F1()
l.ol()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a9w(),$async$BH)
case 7:q=e
if(q.b<0.8){s.b6e("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.avu(q,B.EZ(s.gBN()).length),$async$BH)
case 8:p=e
s.ch=A.dp(0,0,r.ga4X(),0,0,0)
k=A.lF().geI().h(0,"debug")
if(k==="1"){o=B.co1(m.Jr())
A.rd().$1("[tutor] "+s.a.c+":"+s.gjd()+" audio="+C.f.az(q.b,1)+"s infer="+p.b+"ms total="+r.gCA()+"ms "+p.gT3()+" text="+p.a)
A.rd().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.az(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(p.b/1000,2)+" \u062b\n"+p.gT3()+"\n"+A.n(o)+"\n"+p.a}s.afH(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lE){n=m
m=A.lF().geI().h(0,"debug")
if(m==="1")A.rd().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.Jr())
s.a2r(B.MN(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$BH,w)},
a2r(d,e){var x=this,w=x.Q
if(w!=null)w.aA()
if(x.c==null)return
x.j(new B.bYb(x,d,e))},
b6e(d){return this.a2r(d,null)},
afH(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aA()
if(s.c==null)return
x=B.cm2(s.gBN(),d)
r.a=null
if(C.c.O(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjd()
t=x.gts()
r.a=w.auv(v,u,q.b.a,t)
q.zR()}s.j(new B.bYd(r,s,x))},
O2(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$O2=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jU){x=1
break}s.j(new B.bY4(s))
l=s.Q
if(l!=null)l.aA()
s.Q=A.hD(C.it,new B.bY5(s))
k=new A.CI()
$.F1()
k.ol()
r=k
u=4
l=g.a
x=7
return A.c(l.bma(B.aA1(s.a.c,s.gjd()),B.EZ(s.gBN()).length),$async$O2)
case 7:q=e
p=B.co1(l.Jr())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.az(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.az(r.gCA()/1000,2)+" \u062b)\n"+q.gT3()+"\n"+A.n(p)+"\n"+q.a
A.rd().$1("[tutor-debug] "+s.a.c+":"+s.gjd()+" audio="+C.f.az(q.c,1)+"s infer="+q.b+"ms total="+r.gCA()+"ms "+q.gT3()+" text="+q.a)
A.rd().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dp(0,0,r.ga4X(),0,0,0)
s.afH(q.a)
n=s.r
if(n!=null){l=n.gts()
j=n.b
i=A.al(j).i("ag<1>")
j=A.a9(new A.ag(j,new B.bY6(),i),i.i("Z.E"))
A.rd().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.bY7(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lE){m=l
A.rd().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.Jr())
s.a2r(B.MN(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$O2,w)},
ga1a(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.ri():v).a!==D.fi)return!1}return!0},
u(d){var x,w=this,v=null,u=w.d,t=u.c.a6w(w.a.c,w.gjd()),s=u.b,r=s.d&&!w.x&&w.f!==D.jc,q=H.kl(w.a.c),p=y.p,o=A.a([A.bQ(v,v,v,v,C.iy,v,v,new B.bYw(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aL4(),m=A.d("\u0622\u064a\u0629 "+E.bq(w.gjd()),v,v,v,v,v,C.m2,v,v,v),l=E.bq(w.gjd()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.aY,A.d("("+l+" \u0645\u0646 "+E.bq(k.e-k.d+1)+")",v,v,v,v,v,F.aM,v,v,v),C.bE,w.aZi(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.t],p)
if(r)s.push(w.aT8())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.v1&&l!==D.p2}else l=!1
if(l)s.push(w.aII(m))
else s.push(A.d(w.gBN()+" \ufd3f"+E.bq(w.gjd())+"\ufd3e",v,v,v,v,v,D.kg,C.Z,C.bi,v))}s=A.a([new B.Hr(u,!0,v),n,C.B,new E.dC(A.I(s,C.ag,C.d,C.e,0,C.l),D.ajO,C.aJ,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.jc)s.push(w.b7J(n))
if(w.r!=null&&w.f===D.jc&&w.ch!=null){x=C.f.ak(C.j.aH(w.ch.a,1000)/100)
s.push(new A.D(C.bt,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bq(C.j.aH(x,10))+"\u066b"+E.bq(C.j.a3(x,10)))+" \u062b",v,v,v,v,v,F.aM,C.Z,v,v),v))}n=w.as
if(n!=null)s.push(new A.D(C.aJ,A.d(n,v,v,v,v,v,D.Bv,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.Dg(n,"check "+w.a.c+":"+w.gjd(),v))}s.push(w.aJi())
s.push(C.a1)
s.push(A.it(C.v,C.H,v,new B.bYx(w),D.blp,D.bqM,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga1a()
s.push(new E.dC(A.A(A.a([D.apz,C.Y,A.Q(A.I(A.a([D.bso,A.d(w.ga1a()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,v,F.aM,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nz],p),C.h,C.d,C.e,0,v,v),C.a4,C.aJ,new B.bYy(w,d),n,v))}n=A.lF().geI().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dk(D.aqY,D.bqd,u.f===D.jU&&w.f!==D.p2?w.gaK1():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.D(C.hN,A.xh(n,F.aM,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn3()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,v,F.aM,v,v,v))}p.push(A.bf(D.bry,v,v,v,new B.bYz(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.Cl)
return L.xG(o,s,q)},
aL4(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.ao(A.ft(new B.bY9(this),w,null,C.af,new B.bYa()),36,null)},
aZi(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fi)return D.b6U
x=d.b
w=E.bq(x)
v=E.bq(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c1:C.yo
u.push(new A.D(D.akx,A.b0(r,s?G.cN:C.eV,q,16),q))}return A.ajk(A.A(u,C.h,C.d,C.K,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aT8(){var x=null
return A.bv(!1,A.v(12),!0,A.F(x,D.afQ,C.k,x,x,new A.G(C.pD,x,x,A.v(12),x,x,x,C.n),x,x,x,x,D.ajm,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bYf(this),x,x,x,x,x,x,x)},
aII(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gMC(),w)
A:{if(D.j5===v){u=D.kg.ct(G.cN)
break A}if(D.uL===v){u=D.kg.a4f(D.dZ,C.fL,D.dZ)
break A}if(D.uM===v){u=D.kg.a4f(D.eT,C.fL,D.eT)
break A}u=D.kg.a4f(C.eV,C.j0,C.cc)
break A}t=x[w]
r.push(new A.eM(t.a,s,s,C.bs,s,s,s,s,s,s,u))
r.push(P.Bm)}x=E.bq(this.gjd())
r.push(A.es(s,s,s,s,s,s,s,s,s,D.kg.ct(C.an),"\ufd3f"+x+"\ufd3e"))
return A.CU(A.es(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Z,C.bi)},
b7J(d){var x,w,v,u,t,s,r=this.w
if(C.c.O(d.c).length===0)return D.bFQ
if(d.gts()){x=r==null
if((x?null:r.a)===D.fi&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fi?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bq(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.Dy(G.cN,C.c1,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMC()
w=J.dD(x)
v=w.iE(x,new B.bYs()).gM(0)
u=w.iE(x,new B.bYt()).gM(0)
t=w.iE(x,new B.bYu()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bq(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bq(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bq(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJK().length!==0)x.push(E.bq(d.gJK().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eT:D.dZ
x=C.b.aB(x," \u2022 ")
s=d.gJK().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aB(d.gJK(),"\u060c "):""
return new B.Dy(w,C.np,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aJi(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jU,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aH(new A.aQ(f,0,!1).dD(w).a,1e6)}v=C.j.aH(B.cbz(B.EZ(j.gBN()).length).a,1e6)
f=j.gb4O()
w=96+26*j.y
u=D.eT.ad(0.25)
w=A.iO(i,A.a5r(C.P,A.F(i,D.ara,C.k,i,i,D.a7F,i,84,i,i,i,i,i,84),i,C.aU,new A.G(u,i,i,i,i,i,i,C.bZ),C.Fh,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cR)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.cau(x)+" / "+B.cau(v),i,i,i,i,i,K.oE,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,i,F.aM,i,i,i),A.bf(D.bx2,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.eB((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bq(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bq(t)+" \u062b)"
return new A.D(C.q3,A.I(A.a([C.vR,C.a1,D.boX,A.d(h,i,i,i,i,i,F.aM,C.Z,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.v0
r=j.r
f=r==null
w=!f
q=w&&r.gts()
u=A.b0(s?C.nq:K.HR,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i,i)
o=A.ev(i,i,D.b9G,i,i,i,i)
u=A.Q(new A.zX(C.a4C,!0,new B.bXY(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Yx(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.Jx[n]
p.push(new A.eb(m,i,A.d("\xd7"+E.bq(m),i,i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.M,A.ns(new B.bXZ(j),p,A.da([h.b.b],o),!1,A.kp(i,i,i,new A.bh(new B.bY_(),l),i,i,i,i,new A.bh(new B.bY0(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cK),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb0j():i
u=A.b0(f?D.qD:C.np,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,i,C.ct,i,i,i)
p=q?C.ip:C.v
h=A.a([o,C.t,A.fp(u,f,h,A.ev(p,q?C.i:C.ae,D.tQ,i,i,i,i))],k)
if(w&&j.gjd()<j.a.e)C.b.A(h,A.a([C.B,q?A.fp(D.auv,D.bvK,new B.bY1(j),A.ev(G.cN,C.ae,D.tQ,i,i,i,i)):A.bf(D.blR,i,i,i,new B.bY2(j),i,i)],k))
if(w){f=j.gjd()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.D(C.iu,A.d(j.ga1a()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,i,K.up,C.Z,i,i),i))
return A.I(h,C.ag,C.d,C.e,0,C.l)}}}
B.Dy.prototype={
u(d){var x=this,w=null,v=x.c,u=v.ad(0.12),t=A.v(14),s=A.aI(v.ad(0.5),1),r=y.p
return A.F(w,A.A(A.a([A.b0(x.d,v,w,w),C.M,A.Q(A.I(A.a([A.d(x.e,w,w,w,w,w,A.bC(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.W,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bR,A.d(x.f,w,w,w,w,w,C.BC,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.G(u,w,s,t,w,w,w,C.n),w,w,w,C.aJ,C.ac,w,w,w)}}
B.De.prototype={
P(){var x=y.S
return new B.a2A($.MU(),A.B(x,y.B),A.aS(x),A.B(x,y.N),A.el(null,y.H))}}
B.a2A.prototype={
W(){this.Y()
this.d.aa(this.goC())},
xR(){if(this.c!=null)this.j(new B.bXG())},
m(){var x,w=this,v=w.d
v.T(w.goC())
x=w.y
if(x!=null)x.aA()
v.a.a3C()
w.a_()},
If(d){return this.b4z(d)},
b4z(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$If=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.bXP(t,d))
r=t.y
if(r!=null)r.aA()
t.y=A.hD(C.eY,new B.bXQ(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.cbz(B.EZ(H.ML(q,d,p.y3(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dp(0,0,0,350*B.EZ(H.ML(p,d,o.y3(p,d)).b).length,0,0)
x=6
return A.c(r.a.a9s(r.b.c,q,p,new B.bXR(t,d),new B.bXS(t)),$async$If)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lE){s=r
r=t.y
if(r!=null)r.aA()
if(t.c!=null)t.j(new B.bXT(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$If,w)},
FH(d,e){return this.aMe(d,e)},
aMe(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$FH=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aA()
s.j(new B.bXK(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a9w()
if(e&&n!=null)s.If(n)
q=null
u=4
x=7
return A.c(r,$async$FH)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lE){p=o
s.j(new B.bXL(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bH(new B.bXM(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$FH,w)},
gaWP(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b1e(){this.j(new B.bXN(this))},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jU,o=s.e,n=s.gaWP(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("c5<2>")
x=new A.ag(new A.c5(m,l),new B.bXU(),l.i("ag<Z.E>")).gM(0)
l=H.kl(s.a.c)
m=y.p
q=A.a([new B.Hr(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bq(s.a.d)+" \u0644\u062d\u062f "+E.bq(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,r,F.aM,r,r,r),C.t],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b6g(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,r,D.Bv,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.Dg(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bq(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aH(new A.aQ(v,0,!1).dD(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.cau(v),r,r,r,r,r,K.oE,C.Z,r,r)
j=A.fb(A.v(6),A.q9(C.eU,D.eT,6,s.x,r),C.az)
u=o<s.a.e
t=A.b0(u?O.HK:C.nq,r,r,r)
C.b.A(q,A.a([v,C.G,j,C.t,A.fp(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,r,C.ct,r,r,r),new B.bXV(s,o),A.ev(C.v,C.ae,D.tQ,r,r,r,r))],m))}else if(n!=null){j=p?new B.bXW(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bq(n)
q.push(A.fp(D.ask,A.d(v,r,r,r,r,r,C.ct,r,r,r),j,A.ev(C.v,C.ae,D.tQ,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aWk)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cN:D.dZ
v=k?C.ng:C.np
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bq(x)
u=s.a
u=k+" \u0645\u0646 "+E.bq(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.Dy(j,v,k,u,r),A.dk(D.aui,D.bwp,s.gb1d(),r)],m))}q.push(C.t)
q.push(D.Cl)
return L.xG(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b6g(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.arF
else if(l.r.n(0,d))x=N.tT
else if(i!=null)x=D.arX
else if(j!=null){w=j.gts()?C.c1:D.ao7
x=A.b0(w,j.gts()?G.cN:D.dZ,k,k)}else x=D.aqe
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bq(d),k,k,k,k,k,C.a2c,k,k,k),C.bE,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,k,D.a26,k,k,k))
if(j!=null&&!j.gts()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMC()
o=J.bd(p)
n=o.h(p,r)
A:{if(D.j5===n){m=G.cN
break A}if(D.uL===n){m=D.dZ
break A}if(D.uM===n){m=D.eT
break A}m=C.eV
break A}m=D.kg.bbQ(m,o.h(p,r)===D.uN?C.j0:k,22)
C.b.A(t,A.a([new A.eM(q.a,k,k,C.bs,k,k,k,k,k,k,m),P.Bm],u))}w=A.a([C.ak,A.CU(A.es(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Z,C.bi)],w)
if(C.c.O(j.c).length===0)w.push(D.brN)
C.b.A(v,w)}return new E.dC(A.I(v,C.ag,C.d,C.e,0,C.l),C.bN,C.d1,k,!1,k)}}
B.Dd.prototype={
P(){return new B.a2z($.MU())}}
B.a2z.prototype={
W(){this.Y()
var x=this.d
x.aa(this.goC())
x.vF()},
xR(){if(this.c!=null)this.j(new B.bXx())},
m(){this.d.T(this.goC())
this.a_()},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gaz9(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.j5(o,0,new B.bXE(q))
v=C.b.j5(o,0,new B.bXF())
o=y.p
o=A.a([A.A(A.a([A.Q(s.Y5(E.bq(q.gatw()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.M,A.Q(s.Y5(E.bq(q.aq6()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.M,A.Q(s.Y5(E.bq(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.t,new E.dC(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bq(C.f.ak(w*100/v))+"\u066a",r,r,r,r,r,C.bw,r,r,r),C.G,A.fb(A.v(6),A.q9(C.eU,G.cN,8,w/v,r),C.az),C.ak,A.d(E.bq(w)+" \u0645\u0646 "+E.bq(v)+" \u0622\u064a\u0629",r,r,r,r,r,F.aM,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)],o)
if(p.length===0)o.push(D.aWz)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b6i(p[t]))
o.push(C.B)
u=$.C().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,r,F.aM,r,r,r))
return L.xG(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
Y5(d,e){var x=null
return new E.dC(A.I(A.a([A.d(d,x,x,x,x,x,D.bgI,x,x,x),A.d(e,x,x,x,x,x,C.a2C,C.Z,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a4,C.H,x,!1,x)},
b6i(d){var x=null,w=this.d.c,v=I.cQ[d-1].a[1],u=w.a6n(d),t=w.bh0(d),s=y.p,r=A.A(A.a([A.Q(A.d(H.kl(d),x,x,x,x,x,C.bw,x,x,x),1),A.d(E.bq(C.f.ak(u*100/v))+"\u066a",x,x,x,x,x,D.bhN,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fb(A.v(6),A.q9(C.eU,G.cN,7,u/v,x),C.az),p=E.bq(u),o=E.bq(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bq(t):""
return new E.dC(A.I(A.a([r,C.G,q,C.ak,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,x,F.aM,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,new B.bXD(this,d),!1,x)},
O5(d){return this.aKn(d)},
aKn(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$O5=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cQ[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e_(C.cM,new B.bXC(v,d,u),t,!0,null,null,!1,y.H),$async$O5)
case 2:return A.h(null,w)}})
return A.i($async$O5,w)}}
B.ajp.prototype={
RE(d,e){var x=null,w=A.lD(x,x,x,x,x,x,x,x,x,x,x,D.b9f,C.H,x,x,x,x,C.jT,x,x)
return A.bf(A.d(d,x,x,x,x,x,C.m1,x,x,x),x,x,x,new B.b5E(e),x,w)},
u(d){var x=this,w=y.p
return new E.dC(A.I(A.a([D.bvv,C.G,D.bx1,A.cW(C.aw,A.a([x.RE("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.RE("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aE,0,12),D.bl1,x.RE("tanzil.net","https://tanzil.net"),D.byF,x.RE("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,null,!1,null)}}
B.Dg.prototype={
P(){return new B.a2C()}}
B.a2C.prototype={
gamn(){var x=this.a
return B.cLG(x.c,x.d,$.ccb().Jr())},
RH(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$RH=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.bYA(s))
v=3
r=A.c5D()
n=s.gamn()
m=y.N
q=A.B(m,m)
J.dX(q,"app","mogtama3y")
J.dX(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dX(q,"ua",m)}x=6
return A.c(A.a9Y(n,null,C.Gm,q),$async$RH)
case 6:if(s.c!=null)s.j(new B.bYB(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cd?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.bYC(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.bYD(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$RH,w)},
u(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bv(!1,t,!0,new A.D(C.kS,A.A(A.a([A.b0(u.d?C.yj:C.l6,C.cc,t,18),C.bJ,D.bxP],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bYF(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.F(t,A.xh(u.gamn(),D.bd_,t,C.A),C.k,t,t,new A.G(C.pD,t,t,x,t,t,t,C.n),t,t,t,D.ajp,C.ec,t,t,1/0))}if(u.f)s.push(D.blj)
else{x=A.lD(t,t,t,t,t,t,t,t,t,t,t,C.a0q,C.H,t,t,t,t,C.jT,t,t)
w=u.e
v=w?t:u.gb6h()
s.push(A.ff(w?C.a0F:D.atE,t,D.buq,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,t,D.a26,t,t,t))
return new A.D(C.aJ,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["ak<~>()","~()","O(nE)","ak<JR>()","ak<JP>()","ak<JQ>()","a7<nE>()","O(rt)","bG(oL)","Df(u)","Dd(u)","O(mW)","De(u)","O(It)"])
B.b5F.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.S(A.cS(b.G.document).baseURI)
q=A.by(r,0,null).a2("quran_tutor/tutor.js?v=3").k(0)
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
m=B.cAT("network",A.n(o))
throw A.r(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:309}
B.b5I.prototype={
$1(d){var x=null
return A.c0b(A.cM(d,"persist",x,x,x,x))},
$S:1119}
B.b5H.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.ra(),$async$$0)
case 4:x=3
return A.c(n.eF(m.cS(l.cM(e,"loadModel",A.c0U(new B.b5G(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.t(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.t(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.r9(p,"ms")
r=q.oq(p,"cached")
A.t(p.backend)
v=new B.JP(o,t,s,r,q.r9(p,"threads"),q.oq(p,"isolated"),q.r9(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b5G.prototype={
$2(d,e){this.a.$2(C.f.ak(d),C.f.ak(e))},
$S:1120}
B.b5M.prototype={
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
u.onLevel=A.fW(new B.b5K(v.e))
u.onAutoStop=A.fW(new B.b5L(v.f))
x=5
return A.c(A.eF(A.cS(A.cM(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b5K.prototype={
$1(d){return this.a.$1(d)},
$S:64}
B.b5L.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b5N.prototype={
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
return A.c(q.eF(p.cS(o.cM(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.JQ(r,A.dQ(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b5P.prototype={
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
return A.c(q.eF(p.cS(o.cM(e,"transcribe",t.audio,t.rate,s.aiF(u.c),null)),y.m),$async$$0)
case 3:v=r.amh(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b5O.prototype={
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
return A.c(r.eF(q.cS(p.cM(e,"transcribeUrl",u.b,t.aiF(u.c),null,null)),y.m),$async$$0)
case 3:v=s.amh(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b5J.prototype={
$1(d){return d},
$S:38}
B.aWP.prototype={
$0(){var x,w,v,u,t=this.a,s=A.co(t.a.length,D.uN,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aWO.prototype={
$1(d){return d===D.j5},
$S:z+2}
B.c0D.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c6D(e[x],d[x])<0.75)return!1
return!0},
$S:1121}
B.c2K.prototype={
$1(d){return d.length!==0},
$S:10}
B.b5T.prototype={
$1(d){return d.a===D.fi},
$S:z+7}
B.b5U.prototype={
$1(d){return C.j.aH(d,1000)},
$S:61}
B.b5R.prototype={
$1(d){return C.f.bB(d)},
$S:1122}
B.b5V.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iB("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.am.f0(r,null))
j=A.ax(k.h(0,"n"))
j=j==null?null:C.f.bB(j)
j=C.j.cZ(j==null?2:j,1,5)
i=C.b.n(D.Jx,k.h(0,"r"))?A.ey(k.h(0,"r")):1
h=A.eh(k.h(0,"auto"))
g=A.eh(k.h(0,"hide"))
k=A.eh(k.h(0,"in"))
s.a.b=new B.VD(j,i,h!==!1,g===!0,k===!0)}u=2
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
if(q!=null)s.a.c=B.c9N(y.P.a(C.am.f0(q,null)))
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
n=C.f.bB(A.cN(J.av(o,"s")))
m=C.f.bB(A.cN(J.av(o,"f")))
l=C.f.bB(A.cN(J.av(o,"t")))
if(B.co6(n,m)&&B.co6(n,l)&&m<=l)s.a.z=new A.b_(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a9g()){k.a.aqV()
x=1
break}a1=k
x=18
return A.c(k.a.MX(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a5()
if(k.b.e)k.Dd()
k.wC()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:111}
B.b5W.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a5()},
$S:1123}
B.b5X.prototype={
$2(d,e){return C.j.aH(A.eE(A.n(d),null,null),1000)===this.a},
$S:1124}
B.bKl.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.Eu(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bKk(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1125}
B.bKk.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bKm.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bKj(x,d))},
$S:z+8}
B.bKj.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bKn.prototype={
$1(d){},
$S:23}
B.bK7.prototype={
$0(){},
$S:0}
B.bKd.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.Df(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bKe.prototype={
$0(){},
$S:0}
B.bKh.prototype={
$0(){var x=y.z
return A.N(this.a,!1).aC(A.az(new B.bKg(),null,x),x)},
$S:0}
B.bKg.prototype={
$1(d){return D.bA0},
$S:z+10}
B.bKi.prototype={
$0(){return B.cnT(this.a)},
$S:0}
B.bKa.prototype={
$0(){var x=this.b
return this.a.xS(x.a,x.b,x.c)},
$S:0}
B.bKb.prototype={
$1(d){return this.a.j(new B.bK9())},
$S:5}
B.bK9.prototype={
$0(){},
$S:0}
B.bKc.prototype={
$0(){var x=this.a
return x.j(new B.bK8(x))},
$S:0}
B.bK8.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bKf.prototype={
$0(){return this.a.b6f(this.b)},
$S:0}
B.c5g.prototype={
$1(d){return new A.ja(new B.c5d(this.a,this.b,this.c),null)},
$S:58}
B.c5d.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c5f(u,e),s=this.a,r=new B.c5e(s,e),q=A.d(H.kl(this.c),v,v,v,v,v,C.oA,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bq(u)+" \u0622\u064a\u0629)",v,v,v,v,v,F.aM,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bq(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bq(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.cZ(w+4,1,u)))}u=A.a([q,C.ak,p,C.t,A.cW(C.aw,n,C.aE,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c58(s)),C.a0B,t.$3("\u0644\u062d\u062f",s.c,new B.c59(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aWp)
u.push(C.a5)
u.push(A.dF(D.boq,new B.c5a(s,d),A.ev(C.v,C.ae,D.b9D,v,v,v,v)))
return A.cw(!0,new A.D(C.FO,A.I(u,C.ag,C.d,C.K,0,C.l),v),C.H,!0)},
$S:392}
B.c5f.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,u,C.ia,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c7(v,A.d("\u0622\u064a\u0629 "+E.bq(v),u,u,u,u,u,u,u,u,u),C.aq,u,w))
return A.Q(A.I(A.a([t,R.G8(C.cM,!0,s,320,new B.c5c(this.b,f),D.bi3,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1127}
B.c5c.prototype={
$1(d){return d==null?null:this.a.$1(new B.c5b(this.b,d))},
$S:52}
B.c5b.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c5e.prototype={
$3(d,e,f){var x=null
return A.c7e(x,A.d(d,x,x,x,x,x,x,x,x,x),new B.c57(this.a,this.b,e,f))},
$S:1128}
B.c57.prototype={
$0(){var x=this
return x.b.$1(new B.c56(x.a,x.c,x.d))},
$S:0}
B.c56.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c58.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c59.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c5a.prototype={
$0(){var x=this.a
return A.N(this.b,!1).af(new A.W(x.b,x.c))},
$S:0}
B.bXX.prototype={
$0(){},
$S:0}
B.bYc.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.ml
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bYg.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.jc:D.ml},
$S:0}
B.bYh.prototype={
$0(){var x=this.a
x.f=D.v0
x.as=null},
$S:0}
B.bYi.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bYk.prototype={
$0(){var x=this.a
x.f=D.v1
x.as=null
x.y=0
x.z=new A.aQ(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bYl.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bYj())},
$S:31}
B.bYj.prototype={
$0(){},
$S:0}
B.bYn.prototype={
$1(d){return this.a.y=d},
$S:64}
B.bYm.prototype={
$1(d){return this.a.BH()},
$S:5}
B.bYo.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.jc:D.ml
x=this.b
w.as=B.MN(x)
w.at=x},
$S:0}
B.bYq.prototype={
$0(){var x=this.a
x.f=D.p2
x.ay=Date.now()},
$S:0}
B.bYr.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bYp())},
$S:31}
B.bYp.prototype={
$0(){},
$S:0}
B.bYb.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.jc:D.ml
x.as=this.b
x.at=this.c},
$S:0}
B.bYd.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.jc
x.x=!1},
$S:0}
B.bY4.prototype={
$0(){var x=this.a
x.f=D.p2
x.ay=Date.now()
x.as=null},
$S:0}
B.bY5.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bY3())},
$S:31}
B.bY3.prototype={
$0(){},
$S:0}
B.bY6.prototype={
$1(d){return d.d!==D.j5},
$S:z+11}
B.bY7.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bYw.prototype={
$0(){return B.cnT(this.a)},
$S:0}
B.bYx.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.apC(d))},
$S:3}
B.bYy.prototype={
$0(){var x=y.z
return A.N(this.b,!1).aC(A.az(new B.bYv(this.a),null,x),x)},
$S:0}
B.bYv.prototype={
$1(d){var x=this.a.a
return new B.De(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bYz.prototype={
$0(){this.a.d.a.blj()
this.b.J(y.q).f.Z(D.baJ)},
$S:0}
B.bYa.prototype={
$2(d,e){return C.aY},
$S:17}
B.bY9.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a6w(s.c,r).a.a){case 2:s=G.cN
break
case 1:s=D.dZ
break
case 0:s=C.ip
break
default:s=u}x=A.v(18)
w=t.f===D.p2?u:new B.bY8(t,r)
v=s.ad(0.25)
if(r===t.gjd())s=C.i
s=A.aI(s,r===t.gjd()?2:1)
return A.bv(!1,x,!0,A.F(C.P,A.d(E.bq(r),u,u,u,u,u,C.a1L,u,u,u),C.k,u,u,new A.G(v,u,s,u,u,u,u,C.bZ),u,u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:67}
B.bY8.prototype={
$0(){return this.a.a_d(this.b)},
$S:0}
B.bYf.prototype={
$0(){var x=this.a
return x.j(new B.bYe(x))},
$S:0}
B.bYe.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bYs.prototype={
$1(d){return d===D.uL},
$S:z+2}
B.bYt.prototype={
$1(d){return d===D.uM},
$S:z+2}
B.bYu.prototype={
$1(d){return d===D.uN},
$S:z+2}
B.bXY.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.RF(x)},
$S:0}
B.bXZ.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.bbe(d.ga1(d)))},
$S:102}
B.bY0.prototype={
$1(d){return d.n(0,C.T)?C.ae:C.i},
$S:4}
B.bY_.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.bY1.prototype={
$0(){var x=this.a
return x.a_d(x.gjd()+1)},
$S:0}
B.bY2.prototype={
$0(){var x=this.a
return x.a_d(x.gjd()+1)},
$S:0}
B.bXG.prototype={
$0(){},
$S:0}
B.bXP.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aQ(Date.now(),0,!1)},
$S:0}
B.bXQ.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bXO())},
$S:31}
B.bXO.prototype={
$0(){},
$S:0}
B.bXS.prototype={
$1(d){return this.a.x=d},
$S:64}
B.bXR.prototype={
$1(d){return this.a.FH(this.b,!1)},
$S:5}
B.bXT.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.MN(x)
w.as=x},
$S:0}
B.bXK.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.bXL.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.MN(x))
w.as=x},
$S:0}
B.bXM.prototype={
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
return A.c(n.a.avu(s.b,B.EZ(H.ML(l,m,k.y3(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cm2(H.ML(l,m,k.y3(l,m)).b,r.a)
if(C.c.O(q.c).length!==0){l=n.c
k=o.a.c
j=q.gts()
l.auv(k,m,n.b.a,j)}n.zR()
if(o.c!=null)o.j(new B.bXH(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lE){p=o
o=s.a
if(o.c!=null)o.j(new B.bXI(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.bXJ(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:138}
B.bXH.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.bXI.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.MN(w))
x.as=w},
$S:0}
B.bXJ.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bXN.prototype={
$0(){var x=this.a
x.f.ao(0)
x.w.ao(0)
x.as=null},
$S:0}
B.bXU.prototype={
$1(d){return d.gts()},
$S:z+13}
B.bXV.prototype={
$0(){return this.a.FH(this.b,!0)},
$S:0}
B.bXW.prototype={
$0(){return this.a.If(this.b)},
$S:0}
B.bXx.prototype={
$0(){},
$S:0}
B.bXE.prototype={
$2(d,e){return d+this.a.a6n(e)},
$S:104}
B.bXF.prototype={
$2(d,e){return d+I.cQ[e-1].a[1]},
$S:104}
B.bXD.prototype={
$0(){return this.a.O5(this.b)},
$S:0}
B.bXC.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kl(p),q,q,q,q,q,C.oA,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.bc(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.ri():r).a.a){case 2:r=G.cN.ad(0.35)
break
case 1:r=D.dZ.ad(0.35)
break
case 0:r=C.fX
break
default:r=q}m.push(A.F(C.P,A.d(E.bq(t),q,q,q,q,q,C.kf,q,q,q),C.k,q,q,new A.G(r,q,q,new A.cG(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,q,38))}return A.cw(!0,new A.D(C.h2,A.I(A.a([o,C.ak,D.bsH,C.t,new A.dt(D.a7w,A.f6(A.cW(C.aw,m,C.aE,6,6),q,C.r,q,q,q,C.w),q),C.a1,A.bf(D.buu,q,q,q,new B.bXB(w,d,p),q,q)],n),C.ag,C.d,C.K,0,C.l),q),C.H,!0)},
$S:35}
B.bXB.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dn(null,null,!0,null,new B.bXA(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Lf(t),$async$$0)
case 5:if(u.e!=null)A.N(u,!1).e4()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.bXA.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kl(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x,x)
return A.ds(A.a([A.bf(C.eq,x,x,x,new B.bXy(d),x,x),A.bf(C.oP,x,x,x,new B.bXz(d),x,x)],y.p),w,D.bw6)},
$S:14}
B.bXy.prototype={
$0(){A.N(this.a,!1).af(!1)
return null},
$S:0}
B.bXz.prototype={
$0(){A.N(this.a,!1).af(!0)
return null},
$S:0}
B.c6d.prototype={
$1(d){var x=this.a
return new A.kE(new B.c6c(x),null,x,null)},
$S:1129}
B.c6c.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.eb(w,t,A.d(E.bq(w),t,t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bkY,C.a1,D.buW,C.G,A.ns(new B.c67(s,r),q,A.da([r.a],x),!1,A.kp(t,t,t,new A.bh(new B.c68(),v),t,t,t,t,new A.bh(new B.c69(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.it(C.v,C.H,t,new B.c6a(s,r),D.brY,D.by6,r.c),A.it(C.v,C.H,t,new B.c6b(s,r),t,D.bks,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ak,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn3(),t,t,t,t,t,F.aM,t,C.bi,t)],u))
x.push(C.B)
x.push(D.a3N)
return A.cw(!0,A.f6(A.I(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.h2,t,t,C.w),C.H,!0)},
$S:1130}
B.c67.prototype={
$1(d){return this.a.qK(this.b.bbb(d.ga1(d)))},
$S:102}
B.c69.prototype={
$1(d){return d.n(0,C.T)?C.ae:C.i},
$S:4}
B.c68.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.c6a.prototype={
$1(d){return this.a.qK(this.b.bax(d))},
$S:3}
B.c6b.prototype={
$1(d){return this.a.qK(this.b.apC(d))},
$S:3}
B.b5E.prototype={
$0(){return A.cu(A.by(this.a,0,null),C.aP,null)},
$S:0}
B.c6w.prototype={
$1(d){var x,w=A.aD("https?://",!0,!1,!1)
w=A.bE(d,w,"")
x=A.aD("www\\.",!0,!1,!1)
return A.uV(A.bE(w,x,"www[.]"),A.aD("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c6x(),null)},
$S:38}
B.c6x.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:56}
B.bYA.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bYB.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bYC.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bYD.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bYF.prototype={
$0(){var x=this.a
return x.j(new B.bYE(x))},
$S:0}
B.bYE.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c6v.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:230};(function installTearOffs(){var x=a._instance_0u
x(B.ajq.prototype,"gbh1","bh2",1)
var w
x(w=B.VE.prototype,"gbhi","Dd",0)
x(w,"gaEc","wC",0)
x(w=B.a06.prototype,"goC","xR",1)
x(w,"gaYB","Q3",0)
x(w=B.a2B.prototype,"goC","xR",1)
x(w,"gb0j","Qt",0)
x(w,"gb4O","BH",0)
x(w,"gaK1","O2",0)
x(w=B.a2A.prototype,"goC","xR",1)
x(w,"gb1d","b1e",1)
x(B.a2z.prototype,"goC","xR",1)
x(B.a2C.prototype,"gb6h","RH",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.ajq,B.VF,B.JP,B.JR,B.JQ,B.lE,B.SK,B.mW,B.It,B.rt,B.ajr,B.VD])
x(A.ld,[B.b5F,B.b5H,B.b5M,B.b5N,B.b5P,B.b5O,B.aWP,B.b5V,B.bKk,B.bKj,B.bK7,B.bKe,B.bKh,B.bKi,B.bKa,B.bK9,B.bKc,B.bK8,B.bKf,B.c5b,B.c57,B.c56,B.c5a,B.bXX,B.bYc,B.bYg,B.bYh,B.bYi,B.bYk,B.bYj,B.bYo,B.bYq,B.bYp,B.bYb,B.bYd,B.bY4,B.bY3,B.bY7,B.bYw,B.bYy,B.bYz,B.bY8,B.bYf,B.bYe,B.bXY,B.bY1,B.bY2,B.bXG,B.bXP,B.bXO,B.bXT,B.bXK,B.bXL,B.bXH,B.bXI,B.bXJ,B.bXN,B.bXV,B.bXW,B.bXx,B.bXD,B.bXB,B.bXy,B.bXz,B.b5E,B.bYA,B.bYB,B.bYC,B.bYD,B.bYF,B.bYE])
x(A.iF,[B.b5I,B.b5K,B.b5L,B.b5J,B.aWO,B.c2K,B.b5T,B.b5U,B.b5R,B.bKl,B.bKm,B.bKn,B.bKd,B.bKg,B.bKb,B.c5g,B.c5f,B.c5c,B.c5e,B.c58,B.c59,B.bYl,B.bYn,B.bYm,B.bYr,B.bY5,B.bY6,B.bYx,B.bYv,B.bYs,B.bYt,B.bYu,B.bXZ,B.bY0,B.bY_,B.bXQ,B.bXS,B.bXR,B.bXM,B.bXU,B.bXC,B.bXA,B.c6d,B.c67,B.c69,B.c68,B.c6a,B.c6b,B.c6w,B.c6x,B.c6v])
x(A.o9,[B.b5G,B.c0D,B.b5W,B.b5X,B.c5d,B.bYa,B.bY9,B.bXE,B.bXF,B.c6c])
x(A.DP,[B.nE,B.Fg,B.Hq,B.Eg])
w(B.VE,A.i2)
x(A.K,[B.wW,B.Df,B.De,B.Dd,B.Dg])
x(A.M,[B.a06,B.a2B,B.a2A,B.a2z,B.a2C])
x(A.a3,[B.Hr,B.XW,B.Dy,B.ajp])})()
A.pl(b.typeUniverse,JSON.parse('{"lE":{"bO":[]},"Df":{"K":[],"l":[]},"De":{"K":[],"l":[]},"Dd":{"K":[],"l":[]},"Dg":{"K":[],"l":[]},"VE":{"aC":[]},"wW":{"K":[],"l":[]},"a06":{"M":["wW"]},"Hr":{"a3":[],"l":[]},"XW":{"a3":[],"l":[]},"a2B":{"M":["Df"]},"Dy":{"a3":[],"l":[]},"a2A":{"M":["De"]},"a2z":{"M":["Dd"]},"ajp":{"a3":[],"l":[]},"a2C":{"M":["Dg"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rt"),c:x("eb<x>"),r:x("c7<x>"),k:x("H<mW>"),n:x("H<eb<x>>"),I:x("H<c7<x>>"),R:x("H<hO>"),Z:x("H<aK<o,@>>"),d:x("H<SK>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bP"),j:x("a7<@>"),L:x("a7<x>"),P:x("aK<o,@>"),f:x("aK<@,@>"),x:x("au<o,x>"),a:x("bG"),K:x("a4"),B:x("It"),l:x("+(x,x)"),e:x("db<mW>"),N:x("o"),C:x("JP"),D:x("JQ"),X:x("VF"),_:x("JR"),U:x("ag<o>"),G:x("nE"),q:x("pi"),b:x("bh<T?>"),y:x("O"),i:x("a2"),z:x("@"),S:x("x"),A:x("bP?"),Y:x("aK<@,@>?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("eV"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.pb=new B.Fg(0,"none")
D.pc=new B.Fg(1,"learning")
D.fi=new B.Fg(2,"memorized")
D.a7w=new A.aE(0,1/0,0,320)
D.eT=new A.T(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a7F=new A.G(D.eT,null,null,null,null,null,null,C.bZ)
D.dZ=new A.T(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.asU=new A.E(C.yv,null,C.cc,null,null,null)
D.bwf=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.fb,null,null,null,null,null,null,null,null)
D.bdt=new A.q(!0,C.eV,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bsJ=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bdt,null,null,null,null,null,null,null,null)
D.aJW=x([D.asU,C.G,D.bwf,D.bsJ],y.p)
D.afQ=new A.fh(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aJW,null)
D.ajm=new A.U(0,26,0,26)
D.ajp=new A.U(0,4,0,6)
D.ajO=new A.U(14,12,14,14)
D.akx=new A.U(3,0,0,0)
D.ao7=new A.R(63251,"MaterialIcons",null,!1)
D.qD=new A.R(63677,"MaterialIcons",null,!1)
D.aoX=new A.R(983209,"MaterialIcons",null,!1)
D.apz=new A.E(D.aoX,28,C.v,null,null,null)
D.aqe=new A.E(C.Hr,null,C.ip,null,null,null)
D.anQ=new A.R(62961,"MaterialIcons",null,!1)
D.aqY=new A.E(D.anQ,null,null,null,null,null)
D.ao5=new A.R(63199,"MaterialIcons",null,!1)
D.aqZ=new A.E(D.ao5,null,null,null,null,null)
D.ar6=new A.E(C.l5,null,C.eV,null,null,null)
D.ara=new A.E(C.nq,44,C.i,null,null,null)
D.arF=new A.E(D.qD,null,D.eT,null,null,null)
D.arX=new A.E(C.nh,null,D.eT,null,null,null)
D.ask=new A.E(D.qD,null,null,null,null,null)
D.asR=new A.E(C.hR,20,D.dZ,null,null,null)
D.atc=new A.E(C.nn,30,C.v,null,null,null)
D.atE=new A.E(C.la,16,C.v,null,null,null)
D.au6=new A.E(C.Ho,null,null,null,null,null)
D.aui=new A.E(C.np,null,null,null,null,null)
D.anH=new A.R(62842,"MaterialIcons",null,!0)
D.auv=new A.E(D.anH,null,null,null,null,null)
D.Jx=x([1,3,5],y.t)
D.Kk=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aX0=new A.D(C.kT,C.my,null)
D.aGM=x([D.aX0],y.p)
D.b0t=new A.W(C.nj,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b0g=new A.W(D.qD,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b0O=new A.W(C.dz,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.aoH=new A.R(63625,"MaterialIcons",null,!1)
D.b11=new A.W(D.aoH,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aIV=x([D.b0t,D.b0g,D.b0O,D.b11],A.ae("H<+(R,o)>"))
D.aLh=x([D.pb,D.pc,D.fi],A.ae("H<Fg>"))
D.OZ=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aSR=new B.Hq(0,"idle")
D.Vd=new B.Hq(1,"loading")
D.jU=new B.Hq(2,"ready")
D.aSS=new B.Hq(3,"failed")
D.arD=new A.E(C.c1,18,G.cN,null,null,null)
D.bxe=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.up,null,null,null,null,null,null,null,null)
D.aFG=x([D.arD,C.aY,D.bxe],y.p)
D.b71=new A.er(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aFG,null)
D.aVU=new A.D(C.aJ,D.b71,null)
D.akv=new A.U(2,6,2,4)
D.bd9=new A.q(!0,C.v,null,null,null,null,14,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bkV=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bd9,null,null,null,null,null,null,null,null)
D.aW9=new A.D(D.akv,D.bkV,null)
D.bxD=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.fb,null,null,null,null,null,null,null,null)
D.aH5=x([N.tT,C.M,D.bxD],y.p)
D.b6W=new A.er(C.af,C.cp,C.e,C.h,null,C.l,null,0,D.aH5,null)
D.aWk=new A.D(C.kR,D.b6W,null)
D.BK=new A.q(!0,D.dZ,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bxZ=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.BK,null,null,null,null,null,null,null,null)
D.aWp=new A.D(C.dy,D.bxZ,null)
D.bx9=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aM,C.Z,null,null,null,null,null,null,null)
D.aWz=new A.D(C.C,D.bx9,null)
D.aks=new A.U(2,0,2,8)
D.bt0=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aM,null,null,null,null,null,null,null,null)
D.aWR=new A.D(D.aks,D.bt0,null)
D.atO=new A.E(C.l8,30,C.v,null,null,null)
D.byG=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.BL,null,null,null,null,null,null,null,null)
D.alD=new A.bY(1,C.ah,D.byG,null)
D.aHk=x([D.atO,C.Y,D.alD],y.p)
D.b6I=new A.er(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aHk,null)
D.ato=new A.E(C.dz,18,G.cN,null,null,null)
D.a1V=new A.q(!0,G.cN,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bwR=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a1V,null,null,null,null,null,null,null,null)
D.aG6=x([D.ato,C.bJ,D.bwR],y.p)
D.b6U=new A.er(C.af,C.d,C.K,C.h,null,C.l,null,0,D.aG6,null)
D.b9f=new A.V(0,30)
D.tQ=new A.V(1/0,54)
D.b9D=new A.V(1/0,48)
D.b9G=new A.V(1/0,50)
D.b9J=new A.V(1/0,52)
D.buE=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.baJ=new A.d_(D.buE,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.bcB=new A.q(!0,C.i,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bd_=new A.q(!0,C.an,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.Bv=new A.q(!0,D.eT,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.kg=new A.q(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a26=new A.q(!0,D.eT,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgI=new A.q(!0,C.v,null,null,null,null,24,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhM=new A.q(!0,D.dZ,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhN=new A.q(!0,G.cN,null,null,null,null,null,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bi3=new A.q(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjK=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.ia,null,null,null,null,null,null,null,null)
D.bks=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.cU,null,null,null,null,null,null,null,null)
D.bkY=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oA,null,null,null,null,null,null,null,null)
D.bl1=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aM,null,null,null,null,null,null,null,null)
D.bek=new A.q(!0,G.cN,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.blj=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bek,null,null,null,null,null,null,null,null)
D.blp=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aM,null,null,null,null,null,null,null,null)
D.blR=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.fb,null,null,null,null,null,null,null,null)
D.bnF=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.ct,null,null,null,null,null,null,null,null)
D.boq=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bC,null,null,null,null,null,null,null,null)
D.bov=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aM,null,null,null,null,null,null,null,null)
D.boX=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.BP,null,null,null,null,null,null,null,null)
D.bqd=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bqM=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oE,null,null,null,null,null,null,null,null)
D.bry=new A.m("reset safe mode / WebGPU ban",null,O.a1r,null,null,null,null,null,null,null,null)
D.brN=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.BK,null,null,null,null,null,null,null,null)
D.brY=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aM,null,null,null,null,null,null,null,null)
D.bso=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bw,null,null,null,null,null,null,null,null)
D.bsH=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aM,null,null,null,null,null,null,null,null)
D.bt1=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aM,null,null,null,null,null,null,null,null)
D.buq=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a2v,null,null,null,null,null,null,null,null)
D.bfW=new A.q(!0,D.eT,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.buu=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bfW,null,null,null,null,null,null,null,null)
D.buW=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oE,null,null,null,null,null,null,null,null)
D.bvv=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a1m,null,null,null,null,null,null,null,null)
D.bvK=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.ct,null,null,null,null,null,null,null,null)
D.bw6=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bwp=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bx1=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aM,null,null,null,null,null,null,null,null)
D.bx2=new A.m("\u062e\u0644\u0635\u062a",null,C.m2,null,null,null,null,null,null,null,null)
D.bx3=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.BK,null,null,null,null,null,null,null,null)
D.bh0=new A.q(!0,C.cG,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.fL,null,null,null,null,null,null,null,null)
D.bxP=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bh0,null,null,null,null,null,null,null,null)
D.by2=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bw,null,null,null,null,null,null,null,null)
D.by6=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.cU,null,null,null,null,null,null,null,null)
D.byF=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aM,null,null,null,null,null,null,null,null)
D.a3N=new B.ajp(null)
D.bA0=new B.Dd(null)
D.bA1=new B.VD(2,1,!0,!1,!1)
D.a3R=new B.VF(!1,!1,!1,!1,!1,0)
D.j5=new B.nE(0,"ok")
D.uL=new B.nE(1,"near")
D.uM=new B.nE(2,"wrong")
D.uN=new B.nE(3,"missing")
D.a4h=new B.nE(4,"extra")
D.aom=new A.R(63456,"MaterialIcons",null,!1)
D.bFQ=new B.Dy(D.dZ,D.aom,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bGt=new B.XW(!1,null)
D.Cl=new B.XW(!0,null)
D.ml=new B.Eg(0,"idle")
D.v0=new B.Eg(1,"playing")
D.v1=new B.Eg(2,"recording")
D.p2=new B.Eg(3,"thinking")
D.jc=new B.Eg(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cOF","ccb",()=>new B.ajq())
x($,"cS6","crP",()=>A.aD("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cS7","crQ",()=>A.aD("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cSj","crZ",()=>A.aD("\u0648\u0670",!0,!1,!1))
x($,"cRF","crv",()=>A.aD("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cPX","cqk",()=>A.aD("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cRb","cr7",()=>A.aD("[\u0654\u0655]",!0,!1,!1))
x($,"cPY","cql",()=>A.aD("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cQ4","cqr",()=>A.aD("[\u0624\u0626]",!0,!1,!1))
x($,"cRd","cr9",()=>A.aD("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cRK","cry",()=>A.aD("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cRl","crg",()=>A.aD("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cS4","ccN",()=>A.aD("\\s+",!0,!1,!1))
x($,"cLZ","ri",()=>B.csO(D.pb,0,A.c7N(0,!0)))
x($,"cOG","MU",()=>new B.VE($.ccb(),D.bA1,B.cAU(),D.aSR,$.X()))})()};
(a=>{a["d4dICOTssHGVcKBcrZNKGIBJEkU="]=a.current})($__dart_deferred_initializers__);