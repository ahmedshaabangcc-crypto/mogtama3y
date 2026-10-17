((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,Q,H,G,N,R,K,B={
czs(d){var x,w,v,u,t,s
if(d instanceof B.lE)return d
try{x=A.cO(d)
w=x.code
v=x.message
u=w==null?"failed":A.X(w)
t=v==null?"":A.X(v)
return new B.lE(u,t)}catch(s){u=A.n(d)
return new B.lE("failed",u)}},
aj7:function aj7(){this.b=this.a=null},
b56:function b56(d){this.a=d},
b59:function b59(){},
b58:function b58(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b57:function b57(d){this.a=d},
b5d:function b5d(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b5b:function b5b(d){this.a=d},
b5c:function b5c(d){this.a=d},
b5e:function b5e(d){this.a=d},
b5g:function b5g(d,e,f){this.a=d
this.b=e
this.c=f},
b5f:function b5f(d,e,f){this.a=d
this.b=e
this.c=f},
b5a:function b5a(){},
czt(d,e){return new B.lE(d,e)},
Vu:function Vu(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
JH:function JH(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
JJ:function JJ(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
JI:function JI(d,e){this.a=d
this.b=e},
lE:function lE(d,e){this.a=d
this.b=e},
clQ(d){var x,w=$.cqx()
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
x=$.cbu()
return C.c.P(A.bD(w,x," "))},
cE9(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
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
c5m(d,e){var x,w,v,u,t,s
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
s=1-B.cE9(d,e)/u
return s>=1?0.99:s},
ER(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tY(d,$.cbu()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.clQ(u)
s=A.bD(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.SA(r.a+" "+u,r.b))}continue}q.push(new B.SA(u,s))}return q},
cCP(d,e){var x,w,v,u,t=new B.c_x(),s=A.a([],y.s)
for(x=A.fu(e,0,A.ih(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.ca(x,x.gM(0),w.i("ca<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.JY)&&t.$2(d,D.JY)?C.b.jy(d,5):d
return!t.$2(s,D.OB)&&t.$2(u,D.OB)?C.b.jy(u,4):u},
ckM(d,e){var x=B.ER(d),w=B.clQ(e),v=y.U
v=A.aa(new A.ak(A.a(w.split(" "),y.s),new B.c1D(),v),v.i("a_.E"))
return new B.Il(x,B.cC_(x,B.cCP(v,x)),w)},
cC_(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.cn(x,0,!1,s)
q=A.cn(x,0,!1,y.S)
p=A.cn(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c5m(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c5m(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c5m(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
a4=A.aa(new A.d9(a1,a4),a4.i("aW.E"))
return a4},
nA:function nA(d,e){this.a=d
this.b=e},
SA:function SA(d,e){this.a=d
this.b=e},
mV:function mV(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Il:function Il(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aWk:function aWk(d){this.a=d},
aWj:function aWj(){},
c_x:function c_x(){},
c1D:function c1D(){},
crw(d,e,f){return new B.rq(d,e,f)},
cF4(d){var x
A:{if("memorized"===d){x=D.fh
break A}if("learning"===d){x=D.p8
break A}x=D.p7
break A}return x},
cmP(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cO[d-1].a[1]},
czu(){var x=y.S
return new B.aj8(A.B(x,y.u),A.aS(x))},
b5j(d){var x=d.ff()
return C.c.dq(C.j.k(A.bq(x)),4,"0")+"-"+C.c.dq(C.j.k(A.bt(x)),2,"0")+"-"+C.c.dq(C.j.k(A.bW(x)),2,"0")},
chG(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cGu(),x),x.i("aW.E"))
return B.b5j(A.dr(w[0],w[1],w[2]-1,12,0,0,0))},
c8v(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.B(p,y.u),n=A.aS(p),m=new B.aj8(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcN(),x=x.ga_(x),w=y.j;x.v();){v=x.gI()
u=A.dT(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aQ(t)>=3){v=C.j.aH(u,1000)
s=C.j.a2(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cO[v-1].a[1])}if(v)continue
v=J.bg(t)
r=C.f.bW(A.cU(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rq(D.aKM[r],C.f.bW(A.cU(v.h(t,1))),new A.aR(A.ks(C.f.bW(A.cU(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aAq(q,y.o)
p=A.mp(x,new B.b5i(),x.$ti.i("a_.E"),p)
n.A(0,new A.ak(p,o.ga3G(),A.y(p).i("ak<a_.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aE(d.h(0,"streak"))
p=p==null?null:C.f.bW(p)
p=m.d=p==null?0:p
o=A.aE(d.h(0,"best"))
o=o==null?null:C.f.bW(o)
m.e=o==null?p:o
return m},
azJ(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dq(C.j.k(d),3,"0")+C.c.dq(C.j.k(e),3,"0")+".mp3"},
F9:function F9(d,e){this.a=d
this.b=e},
rq:function rq(d,e,f){this.a=d
this.b=e
this.c=f},
aj8:function aj8(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b5k:function b5k(){},
b5l:function b5l(){},
b5i:function b5i(){},
Vs:function Vs(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cwY(){return new B.wS(null)},
cIU(d,e){var x,w,v,u,t={},s=I.cO[e-1].a[1],r=$.ML().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.rf():v).a===D.fh}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d1(u+4,1,s)
return A.e_(C.cL,new B.c49(t,s,e),d,!0,null,null,!1,y.l)},
cag(d){return A.dn(0,0,0,0,0,C.j.d1(C.f.ak(6+d*1.2),25,90))},
c9c(d){return E.bp(C.j.aH(d,60))+":"+C.c.dq(E.bp(C.j.a2(d,60)),2,"\u0660")},
cmB(d){return A.e_(C.cL,new B.c50($.ML()),d,!0,null,null,!1,y.H)},
ME(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl2()
break A}return x},
cKe(d,e,f){var x,w=new B.c5g(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
cmK(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.am.fb(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.f4:r
q=s.a(J.av(x,"last"))
v=q==null?C.f4:q
u=new B.c5f()
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
a0=J.aQ(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.k(J.av(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.k(J.av(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
Hk:function Hk(d,e){this.a=d
this.b=e},
Vt:function Vt(d,e,f,g,h){var _=this
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
b5m:function b5m(d){this.a=d},
b5n:function b5n(d){this.a=d},
b5o:function b5o(d){this.a=d},
wS:function wS(d){this.a=d},
a_V:function a_V(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bJn:function bJn(d){this.a=d},
bJm:function bJm(d,e){this.a=d
this.b=e},
bJo:function bJo(d){this.a=d},
bJl:function bJl(d,e){this.a=d
this.b=e},
bJp:function bJp(){},
bJ9:function bJ9(){},
bJf:function bJf(d,e,f){this.a=d
this.b=e
this.c=f},
bJg:function bJg(){},
bJj:function bJj(d){this.a=d},
bJi:function bJi(){},
bJk:function bJk(d){this.a=d},
bJc:function bJc(d,e){this.a=d
this.b=e},
bJd:function bJd(d){this.a=d},
bJb:function bJb(){},
bJe:function bJe(d){this.a=d},
bJa:function bJa(d){this.a=d},
bJh:function bJh(d,e){this.a=d
this.b=e},
Hl:function Hl(d,e,f){this.c=d
this.d=e
this.a=f},
XL:function XL(d,e){this.c=d
this.a=e},
c49:function c49(d,e,f){this.a=d
this.b=e
this.c=f},
c46:function c46(d,e,f){this.a=d
this.b=e
this.c=f},
c48:function c48(d,e){this.a=d
this.b=e},
c45:function c45(d,e){this.a=d
this.b=e},
c44:function c44(d,e){this.a=d
this.b=e},
c47:function c47(d,e){this.a=d
this.b=e},
c40:function c40(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c4_:function c4_(d,e,f){this.a=d
this.b=e
this.c=f},
c41:function c41(d){this.a=d},
c42:function c42(d){this.a=d},
c43:function c43(d,e){this.a=d
this.b=e},
E8:function E8(d,e){this.a=d
this.b=e},
D8:function D8(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2n:function a2n(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bWR:function bWR(){},
bX6:function bX6(d,e){this.a=d
this.b=e},
bXa:function bXa(d){this.a=d},
bXb:function bXb(d){this.a=d},
bXc:function bXc(d,e,f){this.a=d
this.b=e
this.c=f},
bXe:function bXe(d){this.a=d},
bXf:function bXf(d){this.a=d},
bXd:function bXd(){},
bXh:function bXh(d){this.a=d},
bXg:function bXg(d){this.a=d},
bXi:function bXi(d,e){this.a=d
this.b=e},
bXk:function bXk(d){this.a=d},
bXl:function bXl(d){this.a=d},
bXj:function bXj(){},
bX5:function bX5(d,e,f){this.a=d
this.b=e
this.c=f},
bX7:function bX7(d,e,f){this.a=d
this.b=e
this.c=f},
bWZ:function bWZ(d){this.a=d},
bX_:function bX_(d){this.a=d},
bWY:function bWY(){},
bX0:function bX0(){},
bX1:function bX1(d,e){this.a=d
this.b=e},
bXq:function bXq(d){this.a=d},
bXr:function bXr(d){this.a=d},
bXs:function bXs(d,e){this.a=d
this.b=e},
bXp:function bXp(d){this.a=d},
bXt:function bXt(d,e){this.a=d
this.b=e},
bX4:function bX4(){},
bX3:function bX3(d){this.a=d},
bX2:function bX2(d,e){this.a=d
this.b=e},
bX9:function bX9(d){this.a=d},
bX8:function bX8(d){this.a=d},
bXm:function bXm(){},
bXn:function bXn(){},
bXo:function bXo(){},
bWS:function bWS(d,e,f){this.a=d
this.b=e
this.c=f},
bWT:function bWT(d){this.a=d},
bWV:function bWV(){},
bWU:function bWU(){},
bWW:function bWW(d){this.a=d},
bWX:function bWX(d){this.a=d},
Dr:function Dr(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
D7:function D7(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2m:function a2m(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bWA:function bWA(){},
bWJ:function bWJ(d,e){this.a=d
this.b=e},
bWK:function bWK(d){this.a=d},
bWI:function bWI(){},
bWM:function bWM(d){this.a=d},
bWL:function bWL(d,e){this.a=d
this.b=e},
bWN:function bWN(d,e){this.a=d
this.b=e},
bWE:function bWE(d,e){this.a=d
this.b=e},
bWF:function bWF(d,e,f){this.a=d
this.b=e
this.c=f},
bWG:function bWG(d,e,f){this.a=d
this.b=e
this.c=f},
bWB:function bWB(d,e,f){this.a=d
this.b=e
this.c=f},
bWC:function bWC(d,e,f){this.a=d
this.b=e
this.c=f},
bWD:function bWD(d,e){this.a=d
this.b=e},
bWH:function bWH(d){this.a=d},
bWO:function bWO(){},
bWP:function bWP(d,e){this.a=d
this.b=e},
bWQ:function bWQ(d,e){this.a=d
this.b=e},
D6:function D6(d){this.a=d},
a2l:function a2l(d){this.d=d
this.c=this.a=null},
bWr:function bWr(){},
bWy:function bWy(d){this.a=d},
bWz:function bWz(){},
bWx:function bWx(d,e){this.a=d
this.b=e},
bWw:function bWw(d,e,f){this.a=d
this.b=e
this.c=f},
bWv:function bWv(d,e,f){this.a=d
this.b=e
this.c=f},
bWu:function bWu(d){this.a=d},
bWs:function bWs(d){this.a=d},
bWt:function bWt(d){this.a=d},
c50:function c50(d){this.a=d},
c5_:function c5_(d){this.a=d},
c4V:function c4V(d,e){this.a=d
this.b=e},
c4X:function c4X(){},
c4W:function c4W(){},
c4Y:function c4Y(d,e){this.a=d
this.b=e},
c4Z:function c4Z(d,e){this.a=d
this.b=e},
aj6:function aj6(d){this.a=d},
b55:function b55(d){this.a=d},
c5g:function c5g(){},
c5h:function c5h(){},
D9:function D9(d,e,f){this.c=d
this.d=e
this.a=f},
a2o:function a2o(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bXu:function bXu(d){this.a=d},
bXv:function bXv(d){this.a=d},
bXw:function bXw(d,e){this.a=d
this.b=e},
bXx:function bXx(d){this.a=d},
bXz:function bXz(d){this.a=d},
bXy:function bXy(d){this.a=d},
c5f:function c5f(){}},D,O,P,I,E,F
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
B.aj7.prototype={
ra(){var x=this,w=x.a
if(w!=null)return A.ej(w,y.m)
w=x.b
return w==null?x.b=new B.b56(x).$0():w},
un(d,e){return this.aNb(d,e,e)},
aNb(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
var $async$un=A.e(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$un)
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
r=B.czs(s)
throw A.r(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$un,w)},
or(d,e){var x=A.eg(d[e])
if(x==null)x=null
return x===!0},
MO(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$MO=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.ra(),$async$MO)
case 7:r=h.cO(g.cJ(e,"support",null,null,null,null))
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
v=new B.Vu(q,p,o,n,m,l)
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
return A.i($async$MO,w)},
Ep(){var x=0,w=A.j(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Ep=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.ra(),$async$Ep)
case 8:x=7
return A.c(m.eF(l.cO(k.cJ(e,"storage",null,null,null,null)),y.A),$async$Ep)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.ak(A.dN(r.quota))
p=C.f.ak(A.dN(r.usage))
v=new A.atd(q,p)
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
return A.i($async$Ep,w)},
bj7(){var x=y.K
A.PA(this.ra().bG(new B.b59(),x),x)},
r9(d,e){var x=A.jQ(d[e])
x=x==null?null:C.f.ak(x)
return x==null?0:x},
bgt(d,e,f){return this.un(new B.b58(this,d,e,f),y.C)},
gaks(){var x,w
try{x=A.kj(b.G.sessionStorage)
return x}catch(w){return null}},
garW(){var x=A.eg(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a8Y(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.eg(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.garW())return!1
l=A.eg(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cO(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.X(x.userAgent)
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
l=this.gaks()
l=l==null?f:A.u(A.cJ(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dT(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.kj(m.localStorage)
m=o
m=m==null?f:A.u(A.cJ(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dT(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
aqt(){var x,w,v,u,t,s,r=null
try{x=this.gaks()
if(x!=null)A.cJ(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cO(x.location)
u=A.X(v.hash)
t=A.X(v.search)
s=A.bz(A.X(A.cO(x.document).baseURI),0,r).a1("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cJ(v,"replace",s+t+x,r,r,r)},
bgc(){var x,w=null,v=b.G,u=A.cO(v.history),t=A.jQ(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cJ(u,"back",w,w,w,w)
else{x=A.X(A.cO(v.document).baseURI)
A.cJ(A.cO(v.location),"replace",A.bz(x,0,w).a1("./").k(0)+"#/",w,w,w)}},
a99(d,e,f,g,h){return this.un(new B.b5d(this,e,d,f,h,g),y.H)},
a9c(){return this.un(new B.b5e(this),y.D)},
a3j(){var x=null,w=this.a
if(w!=null)A.cJ(w,"cancelRecording",x,x,x,x)},
alQ(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.r9(d,"ms")
w=A.jQ(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.JJ(u,x,w,v.r9(d,"frames"),v.r9(d,"tokens"),v.or(d,"retried"),v.r9(d,"encMs"),v.r9(d,"decMs"),v.r9(d,"featMs"))},
aif(d){var x={}
x.words=d
return x},
auZ(d,e){return this.un(new B.b5g(this,d,e),y._)},
blk(d,e){return this.un(new B.b5f(this,d,e),y._)},
KQ(d,e){return this.bjd(d,e)},
bjd(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$KQ=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.ra(),$async$KQ)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.al(d).i("au<1,o>")
o=A.aa(new A.au(d,new B.b5a(),o),o.i("aW.E"))
x=11
return A.c(A.eF(A.cO(A.cJ(r,"play",o,e,null,null)),y.y),$async$KQ)
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
return A.i($async$KQ,w)},
Mv(){var x=null,w=this.a
if(w!=null)A.cJ(w,"stopPlayback",x,x,x,x)},
Ji(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.X(A.cJ(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bkt(){var x,w,v=null
try{x=this.a
if(x!=null)A.cJ(x,"resetDevice",v,v,v,v)}catch(w){}},
a6B(d){var x=this.a
if(x!=null)A.cJ(x,"prefetch",d,null,null,null)}}
B.Vu.prototype={}
B.JH.prototype={
gn3(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.JJ.prototype={
gSR(){var x=this,w=C.f.az(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.JI.prototype={}
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
B.nA.prototype={
R(){return"WordStatus."+this.b}}
B.SA.prototype={}
B.mV.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Il.prototype={
gMt(){var x,w=this,v=w.d
if(v===$){x=new B.aWk(w).$0()
w.d!==$&&A.aq()
w.d=x
v=x}return v},
gJB(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a3U&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbhk(){return J.h6(this.gMt(),new B.aWj()).gM(0)},
gts(){var x=this.a
return x.length!==0&&this.gbhk()===x.length&&this.gJB().length===0}}
B.F9.prototype={
R(){return"AyahStatus."+this.b}}
B.rq.prototype={}
B.aj8.prototype={
a6c(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.rf():x},
aZN(d){var x=this,w=B.b5j(d),v=x.c
if(v===w)return
v=v!=null&&v===B.chG(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
apF(){var x=Date.now(),w=B.b5j(new A.aR(x,0,!1))
x=this.c
return x===w||x===B.chG(w)?this.d:0},
au0(d,e,f,g){var x=this,w=new A.aR(Date.now(),0,!1),v=x.a6c(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.fh:D.p8,s=new B.rq(t,u,w.hd()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.aZN(w)
return s},
a63(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cO[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rf():s).a===D.fh)++u}return u},
bga(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cO[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rf():s).a===D.p8)++u}return u},
gat3(){var x=this.a,w=A.y(x).i("cf<2>")
return new A.ak(new A.cf(x,w),new B.b5k(),w.i("ak<a_.E>")).gM(0)},
gayD(){var x=this.a,w=A.y(x).i("bJ<1>")
w=A.mp(new A.bJ(x,w),new B.b5l(),w.i("a_.E"),y.S)
w=A.eQ(w,A.y(w).i("a_.E"))
x=A.aa(w,A.y(w).c)
C.b.mt(x)
return x},
dt(){var x,w,v,u,t,s=this,r=y.N,q=A.B(r,y.L)
for(x=s.a,x=new A.eu(x,A.y(x).i("eu<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.aa(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
bc5(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b3F(x,300,A.y(x).c),x=new A.Jp(J.aB(x.a),x.b,A.y(x).i("Jp<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gI()
s=C.j.aH(t,1000)
t=C.j.a2(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.rf():q).a===D.fh?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.rf()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.rf():r).c.j7()],w,v))}return o},
bgL(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.L)(d),++u){t=d[u]
s=A.eD(t.h(0,"surah"))*1000+A.eD(t.h(0,"ayah"))
r=w.h(0,C.j.aH(s,1000)*1000+C.j.a2(s,1000))
if((r==null?$.rf():r).c.j7()===t.h(0,"updated_at"))v.K(0,s)}},
bgT(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
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
n=B.cF4(s.h(0,"status"))
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
v.p(0,r,new B.rq(n,C.j.d1(l==null?0:l,0,100),o.hd()))
w.K(0,r)
t=!0}return t}}
B.Vs.prototype={
J1(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Vs(w,v,u,t,f==null?x.e:f)},
bak(d){var x=null
return this.J1(x,x,d,x,x)},
apa(d){var x=null
return this.J1(x,d,x,x,x)},
bao(d){var x=null
return this.J1(x,x,x,x,d)},
b9H(d){var x=null
return this.J1(d,x,x,x,x)},
bal(d){var x=null
return this.J1(x,x,x,d,x)},
dt(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Hk.prototype={
R(){return"ModelState."+this.b}}
B.Vt.prototype={
vC(){var x=this.Q
return x==null?this.Q=new B.b5m(this).$0():x},
qK(d){return this.awR(d)},
awR(d){var x=0,w=A.j(y.H),v=this
var $async$qK=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a4()
x=2
return A.c(A.ii("mt.tutor.settings",C.am.hB(d.dt(),null)),$async$qK)
case 2:return A.h(null,w)}})
return A.i($async$qK,w)},
zL(){var x=0,w=A.j(y.H),v=this,u
var $async$zL=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a4()
x=2
return A.c(A.ii("mt.tutor.progress",C.am.hB(v.c.dt(),null)),$async$zL)
case 2:u=v.as
if(u!=null)u.aC()
v.as=A.cT(C.x,v.gaDF())
return A.h(null,w)}})
return A.i($async$zL,w)},
Md(d,e,f){return this.axD(d,e,f)},
axD(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$Md=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.b_(d,e,f)
x=2
return A.c(A.ii("mt.tutor.last",C.am.hB(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Md)
case 2:return A.h(null,w)}})
return A.i($async$Md,w)},
D9(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$D9=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.UQ||n===D.jR){x=1
break}s.f=D.UQ
s.y=null
s.a4()
u=4
n=A.lF().geL().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lF().geL().h(0,"tutor_threads")
p=A.dT(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bgt(new B.b5n(s),n,p),$async$D9)
case 7:s.x=e
s.f=D.jR
n=A.lF().geL().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.rb().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a8(m)
if(n instanceof B.lE){q=n
s.f=D.aSl
s.y=q
n=A.lF().geL().h(0,"debug")
if(n==="1")A.rb().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a4()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$D9,w)},
wz(){var x=0,w=A.j(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wz=A.e(function(a0,a1){if(a0===1){t.push(a1)
x=u}for(;;)switch(x){case 0:if(r.at){x=1
break}q=null
try{k=$.C().b
k===$&&A.b()
k=k.ga3().e.a
q=(k==null?null:k.r)!=null}catch(d){x=1
break}if(!q){x=1
break}r.at=!0
u=4
k=$.C().b
k===$&&A.b()
p=k
x=7
return A.c(p.aS("quran_tutor_progress").d6("surah, ayah, status, perfect_count, updated_at"),$async$wz)
case 7:o=a1
n=r.c.bgT(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bc5()
if(J.aQ(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.n2(h.x,k,k))
x=11
return A.c(f.bkR("quran_tutor_save",!1,g,i),$async$wz)
case 11:r.c.bgL(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.ii("mt.tutor.progress",C.am.hB(r.c.dt(),null)),$async$wz)
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
return A.i($async$wz,w)},
L6(d){return this.bkv(d)},
bkv(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$L6=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c8v(t.c.dt()).dt()
y.f.a(p.h(0,"rows")).ej(0,new B.b5o(d))
t.c=B.c8v(p)
x=2
return A.c(t.zL(),$async$L6)
case 2:v=4
s=$.C().b
s===$&&A.b()
r=s.ga3().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.aw("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$L6)
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
return A.i($async$L6,w)}}
B.wS.prototype={
O(){var x=$.ML()
return new B.a_V(x,new A.ah(C.L,$.Y()))}}
B.a_V.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goD())
w=y.a
x.vC().bG(new B.bJn(v),w)
H.aUN().bG(new B.bJo(v),w).fv(new B.bJp())
A.PA(H.c7R(),y.y)},
xL(){if(this.c!=null)this.j(new B.bJ9())},
m(){var x,w=this
w.d.T(w.goD())
x=w.e
x.q$=$.Y()
x.L$=0
w.a0()},
PS(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$PS=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qK(s.b.bak(!0)),$async$PS)
case 3:t=s.a
t.bj7()
if(t.a8Y()){t.aqt()
x=1
break}s.D9()
case 1:return A.h(v,w)}})
return A.i($async$PS,w)},
xM(d,e,f){return this.aXG(d,e,f)},
b5r(d){return this.xM(d,null,null)},
aXG(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$xM=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.J(y.q).f.Z(A.aO(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.W(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cIU(s,d),$async$xM)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Md(d,t.a,t.b),$async$xM)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aA(A.ax(new B.bJf(u,d,t),null,r),r),$async$xM)
case 8:if(u.c!=null)u.j(new B.bJg())
case 1:return A.h(v,w)}})
return A.i($async$xM,w)},
u(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.garW()&&!A.O(d,!1).v6())u.push(A.bQ(x,x,x,x,C.yo,x,x,t.gbgb(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bQ(x,x,x,x,D.atC,x,x,new B.bJj(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bQ(x,x,x,x,C.iw,x,x,new B.bJk(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aGg
else w=t?this.aSz():this.aTa()
return L.xC(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aTa(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a3t
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b68,C.a1],x)
for(t=0;t<4;++t){s=D.aIo[t]
u.push(new A.F(C.bs,A.A(A.a([A.b0(s.a,C.an,p,18),C.N,new A.bU(1,C.ad,A.d(s.b,p,p,p,p,G.a11,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bxo,C.F,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bp(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aL,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bp(C.f.ak(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.F,A.d(q,p,p,p,p,A.bK(p,p,r?D.dY:C.cG,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.F,D.bwp],x))
x=A.a([new E.dz(u,C.a4,C.aO,p,!0,p),new E.dz(A.I(s,C.q,C.d,C.e,0,C.l),C.a4,C.aO,p,!1,p),D.bFE,C.F],x)
if(v!=null)x.push(new E.dz(A.d(v,p,p,p,p,D.bha,p,p,p),C.a4,C.aO,p,!1,p))
else x.push(A.fn(D.aqv,D.bn2,this.gaXY(),A.eA(C.v,C.ae,D.b99,p,p,p,p)))
x.push(C.a5)
x.push(D.a3p)
return x},
aSz(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.P(r.a.a),p=q.length===0,o=p?C.ro:H.cmu(q),n=t.z,m=A.R(v.al7(C.dx,E.bp(s.gat3())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bp(s.apF()),k=s.c,j=Date.now()
k=k===B.b5j(new A.aR(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Hl(t,!1,u),A.A(A.a([m,C.N,A.R(v.al7(C.l6,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.t],j)
if(n!=null){t=H.kl(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bp(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bp(m)+"\u2013"+E.bp(l)
k.push(new E.dz(A.A(A.a([D.asJ,C.Y,A.R(A.I(A.a([D.bj7,A.d(t+" \u2014 "+m,u,u,u,u,C.bw,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nz],j),C.h,C.d,C.e,0,u,u),C.a4,C.aO,new B.bJc(v,n),!0,u))}t=C.i.ad(0.08)
k.push(A.aI(u,C.y,!1,u,!0,C.m,u,A.aK(),r,u,u,u,u,u,2,A.cG(u,new A.ci(4,A.v(14),C.M),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.ua,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qK,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bJd(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.cT,!0,C.u,u,C.E,u,u,u,u))
k.push(C.t)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bsp)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.Rb(o[x]))
C.b.A(k,t)}else{t=A.a([D.aVB,D.aWi,v.Rb(1)],j)
for(w=114;w>=78;--w)t.push(v.Rb(w))
t.push(C.F)
r=v.f
p=A.b0(r?C.y4:C.l5,C.an,u,u)
t.push(A.fv(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.fa,u,u,u),new B.bJe(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Rb(w))
C.b.A(k,t)}k.push(C.a1)
k.push(D.C5)
return k},
al7(d,e,f){var x=null,w=y.p
return new E.dz(A.A(A.a([A.b0(d,C.v,x,x),C.N,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bw,x,x,x),A.d(f,1,C.O,x,x,C.a1H,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a4,C.J,x,!1,x)},
Rb(d){var x,w=null,v=this.d.c,u=I.cO[d-1].a[1],t=v.a63(d),s=t/u,r=y.p,q=A.ap(A.dA(C.P,A.a([A.c6h(C.eR,G.cM,w,w,w,w,w,3,s,w),A.d(E.bp(d),w,w,w,w,Q.a23,w,w,w)],r),C.m,C.bk,w),36,36),p=A.d(H.kl(d),w,w,w,w,D.bc_,w,w,w)
if(t===0)x=E.bp(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bp(t)+" \u0645\u0646 "+E.bp(u)
r=A.a([q,C.cF,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bK(w,w,t===u?G.cM:C.cG,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bp(C.f.ak(s*100))+"\u066a",w,w,w,w,D.a1x,w,w,w))
r.push(D.aqD)
return new E.dz(A.A(r,C.h,C.d,C.e,0,w,w),C.q2,C.d0,new B.bJh(this,d),!1,w)}}
B.Hl.prototype={
u(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b1
return D.aVm
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.ME(x),r,r,r,r,D.Bg,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.D9(w,"model load",r))
x.push(C.F)
x.push(new A.zQ(C.a4e,!1,q.gbgs(),r,r,r,r,C.k,r,!1,r,!0,r,C.up,r))
return new E.dz(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aO,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bp(C.f.ak(u/1e6))+" \u0645\u0646 "+E.bp(C.f.ak(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.oF,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.ff(x,A.q7(C.eR,C.v,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.F,D.bnT],w))
return new E.dz(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aO,r,!1,r)}}}
B.XL.prototype={
u(d){var x=null,w=D.dY.ad(0.1),v=A.v(14),u=A.aH(D.dY.ad(0.4),1)
return A.D(x,A.A(A.a([D.asm,C.N,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.Bm,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.G(w,x,u,v,x,x,x,C.n),x,x,C.aO,C.ac,x,x,x)}}
B.E8.prototype={
R(){return"_Phase."+this.b}}
B.D8.prototype={
O(){return new B.a2n($.ML(),D.mk)}}
B.a2n.prototype={
gjc(){var x=this.e
return x===$?this.e=this.a.d:x},
gBI(){var x,w=this.a,v=w.f
w=w.c
x=this.gjc()
return H.MC(w,x,v.xW(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.ac(w.goD())
x.vC()
x.a.a6B(B.azJ(w.a.c,w.gjc()))},
xL(){if(this.c!=null)this.j(new B.bWR())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.Q
if(x!=null)x.aC()
v=v.a
v.Mv()
v.a3j()
w.a0()},
ZZ(d){var x,w,v=this
if(v.f===D.uY)v.d.a.a3j()
x=v.d.a
x.Mv()
w=v.Q
if(w!=null)w.aC()
v.j(new B.bX6(v,d))
x.a6B(B.azJ(v.a.c,d))
w=v.a
if(d<w.e)x.a6B(B.azJ(w.c,d+1))},
Rs(d){return this.aU1(d)},
aU1(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$Rs=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.uX){u.d.a.Mv()
u.j(new B.bXa(u))
x=1
break}t=u.r!=null?D.j9:D.mk
u.j(new B.bXb(u))
s=u.d
r=A.a([B.azJ(u.a.c,u.gjc())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.KQ(r,q),$async$Rs)
case 3:p=f
if(u.c==null||u.f!==D.uX){x=1
break}u.j(new B.bXc(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$Rs,w)},
Qg(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Qg=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jR){x=1
break}p=l.a
p.Mv()
r=B.ER(s.gBI()).length
s.j(new B.bXe(s))
o=s.Q
if(o!=null)o.aC()
s.Q=A.hD(C.eV,new B.bXf(s))
u=4
o=B.cag(r)
n=A.dn(0,0,0,350*r,0,0)
x=7
return A.c(p.a99(l.b.c,o,n,new B.bXg(s),new B.bXh(s)),$async$Qg)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lE){q=l
l=s.Q
if(l!=null)l.aC()
if(s.c!=null)s.j(new B.bXi(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Qg,w)},
BB(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$BB=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.uY){x=1
break}m=s.Q
if(m!=null)m.aC()
s.j(new B.bXk(s))
s.Q=A.hD(C.iq,new B.bXl(s))
l=new A.CA()
$.EU()
l.om()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a9c(),$async$BB)
case 7:q=e
if(q.b<0.8){s.b5q("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.auZ(q,B.ER(s.gBI()).length),$async$BB)
case 8:p=e
s.ch=A.dn(0,0,r.ga4E(),0,0,0)
k=A.lF().geL().h(0,"debug")
if(k==="1"){o=B.cmK(m.Ji())
A.rb().$1("[tutor] "+s.a.c+":"+s.gjc()+" audio="+C.f.az(q.b,1)+"s infer="+p.b+"ms total="+r.gCv()+"ms "+p.gSR()+" text="+p.a)
A.rb().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.az(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(p.b/1000,2)+" \u062b\n"+p.gSR()+"\n"+A.n(o)+"\n"+p.a}s.afk(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lE){n=m
m=A.lF().geL().h(0,"debug")
if(m==="1")A.rb().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.Ji())
s.a28(B.ME(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$BB,w)},
a28(d,e){var x=this,w=x.Q
if(w!=null)w.aC()
if(x.c==null)return
x.j(new B.bX5(x,d,e))},
b5q(d){return this.a28(d,null)},
afk(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aC()
if(s.c==null)return
x=B.ckM(s.gBI(),d)
r.a=null
if(C.c.P(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjc()
t=x.gts()
r.a=w.au0(v,u,q.b.a,t)
q.zL()}s.j(new B.bX7(r,s,x))},
NT(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$NT=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jR){x=1
break}s.j(new B.bWZ(s))
l=s.Q
if(l!=null)l.aC()
s.Q=A.hD(C.iq,new B.bX_(s))
k=new A.CA()
$.EU()
k.om()
r=k
u=4
l=g.a
x=7
return A.c(l.blk(B.azJ(s.a.c,s.gjc()),B.ER(s.gBI()).length),$async$NT)
case 7:q=e
p=B.cmK(l.Ji())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.az(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.az(r.gCv()/1000,2)+" \u062b)\n"+q.gSR()+"\n"+A.n(p)+"\n"+q.a
A.rb().$1("[tutor-debug] "+s.a.c+":"+s.gjc()+" audio="+C.f.az(q.c,1)+"s infer="+q.b+"ms total="+r.gCv()+"ms "+q.gSR()+" text="+q.a)
A.rb().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dn(0,0,r.ga4E(),0,0,0)
s.afk(q.a)
n=s.r
if(n!=null){l=n.gts()
j=n.b
i=A.al(j).i("ak<1>")
j=A.aa(new A.ak(j,new B.bX0(),i),i.i("a_.E"))
A.rb().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.bX1(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lE){m=l
A.rb().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.Ji())
s.a28(B.ME(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$NT,w)},
ga0V(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.rf():v).a!==D.fh)return!1}return!0},
u(d){var x,w=this,v=null,u=w.d,t=u.c.a6c(w.a.c,w.gjc()),s=u.b,r=s.d&&!w.x&&w.f!==D.j9,q=H.kl(w.a.c),p=y.p,o=A.a([A.bQ(v,v,v,v,C.iw,v,v,new B.bXq(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aKq(),m=A.d("\u0622\u064a\u0629 "+E.bp(w.gjc()),v,v,v,v,C.m1,v,v,v),l=E.bp(w.gjc()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.aX,A.d("("+l+" \u0645\u0646 "+E.bp(k.e-k.d+1)+")",v,v,v,v,F.aL,v,v,v),C.bB,w.aYD(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.t],p)
if(r)s.push(w.aSu())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.uY&&l!==D.oZ}else l=!1
if(l)s.push(w.aI5(m))
else s.push(A.d(w.gBI()+" \ufd3f"+E.bp(w.gjc())+"\ufd3e",v,v,v,v,D.ke,C.a0,C.bi,v))}s=A.a([new B.Hl(u,!0,v),n,C.B,new E.dz(A.I(s,C.ah,C.d,C.e,0,C.l),D.aji,C.aO,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.j9)s.push(w.b6V(n))
if(w.r!=null&&w.f===D.j9&&w.ch!=null){x=C.f.ak(C.j.aH(w.ch.a,1000)/100)
s.push(new A.F(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bp(C.j.aH(x,10))+"\u066b"+E.bp(C.j.a2(x,10)))+" \u062b",v,v,v,v,F.aL,C.a0,v,v),v))}n=w.as
if(n!=null)s.push(new A.F(C.aO,A.d(n,v,v,v,v,D.Bg,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.D9(n,"check "+w.a.c+":"+w.gjc(),v))}s.push(w.aIE())
s.push(C.a1)
s.push(A.is(C.v,C.J,v,new B.bXr(w),D.bkQ,D.bq9,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga0V()
s.push(new E.dz(A.A(A.a([D.ap5,C.Y,A.R(A.I(A.a([D.brM,A.d(w.ga0V()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aL,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nz],p),C.h,C.d,C.e,0,v,v),C.a4,C.aO,new B.bXs(w,d),n,v))}n=A.lF().geL().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dj(D.aqu,D.bpA,u.f===D.jR&&w.f!==D.oZ?w.gaJn():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.F(C.ir,A.xd(n,F.aL,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn3()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aL,v,v,v))}p.push(A.bh(D.bqW,v,v,v,new B.bXt(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.C5)
return L.xC(o,s,q)},
aKq(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b1
return A.ap(A.fr(new B.bX3(this),w,null,C.af,new B.bX4()),36,null)},
aYD(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fh)return D.b6k
x=d.b
w=E.bp(x)
v=E.bp(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c1:C.y9
u.push(new A.F(D.ak1,A.b0(r,s?G.cM:C.eS,q,16),q))}return A.aj1(A.A(u,C.h,C.d,C.K,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aSu(){var x=null
return A.bw(!1,A.v(12),!0,A.D(x,D.afp,C.k,x,x,new A.G(C.pz,x,x,A.v(12),x,x,x,C.n),x,x,x,D.aiS,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bX9(this),x,x,x,x,x,x,x)},
aI5(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gMt(),w)
A:{if(D.j2===v){u=D.ke.ct(G.cM)
break A}if(D.uG===v){u=D.ke.a3X(D.dY,C.fK,D.dY)
break A}if(D.uH===v){u=D.ke.a3X(D.eQ,C.fK,D.eQ)
break A}u=D.ke.a3X(C.eS,C.ka,C.cc)
break A}t=x[w]
r.push(new A.eL(t.a,s,s,C.br,s,s,s,s,s,s,u))
r.push(P.B8)}x=E.bp(this.gjc())
r.push(A.eq(s,s,s,s,s,s,s,s,s,D.ke.ct(C.an),"\ufd3f"+x+"\ufd3e"))
return A.CN(A.eq(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.a0,C.bi)},
b6V(d){var x,w,v,u,t,s,r=this.w
if(C.c.P(d.c).length===0)return D.bF0
if(d.gts()){x=r==null
if((x?null:r.a)===D.fh&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fh?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bp(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.Dr(G.cM,C.c1,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMt()
w=J.dB(x)
v=w.iE(x,new B.bXm()).gM(0)
u=w.iE(x,new B.bXn()).gM(0)
t=w.iE(x,new B.bXo()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bp(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bp(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bp(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJB().length!==0)x.push(E.bp(d.gJB().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eQ:D.dY
x=C.b.aB(x," \u2022 ")
s=d.gJB().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aB(d.gJB(),"\u060c "):""
return new B.Dr(w,C.np,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aIE(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jR,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aH(new A.aR(f,0,!1).dG(w).a,1e6)}v=C.j.aH(B.cag(B.ER(j.gBI()).length).a,1e6)
f=j.gb4_()
w=96+26*j.y
u=D.eQ.ad(0.25)
w=A.iN(i,A.a5c(C.P,A.D(i,D.aqG,C.k,i,i,D.a7h,i,84,i,i,i,i,84),i,C.aU,new A.G(u,i,i,i,i,i,i,C.bY),C.F0,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cQ)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c9c(x)+" / "+B.c9c(v),i,i,i,i,K.oE,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aL,i,i,i),A.bh(D.bwo,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.ez((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bp(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bp(t)+" \u062b)"
return new A.F(C.pZ,A.I(A.a([C.vM,C.a1,D.bok,A.d(h,i,i,i,i,F.aL,C.a0,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.uX
r=j.r
f=r==null
w=!f
q=w&&r.gts()
u=A.b0(s?C.nq:K.Hy,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.eA(i,i,D.b96,i,i,i,i)
u=A.R(new A.zQ(C.a4e,!0,new B.bWS(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Ym(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.Ja[n]
p.push(new A.em(m,i,A.d("\xd7"+E.bp(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.N,A.oO(new B.bWT(j),p,A.db([h.b.b],o),!1,A.kp(i,i,i,new A.bf(new B.bWU(),l),i,i,i,i,new A.bf(new B.bWV(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cJ),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb_D():i
u=A.b0(f?D.qy:C.np,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.ct,i,i,i)
p=q?C.il:C.v
h=A.a([o,C.t,A.fn(u,f,h,A.eA(p,q?C.i:C.ae,D.tL,i,i,i,i))],k)
if(w&&j.gjc()<j.a.e)C.b.A(h,A.a([C.B,q?A.fn(D.au1,D.bv5,new B.bWW(j),A.eA(G.cM,C.ae,D.tL,i,i,i,i)):A.bh(D.blf,i,i,i,new B.bWX(j),i,i)],k))
if(w){f=j.gjc()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.F(C.jt,A.d(j.ga0V()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,K.uj,C.a0,i,i),i))
return A.I(h,C.ah,C.d,C.e,0,C.l)}}}
B.Dr.prototype={
u(d){var x=this,w=null,v=x.c,u=v.ad(0.12),t=A.v(14),s=A.aH(v.ad(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b0(x.d,v,w,w),C.N,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bK(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.W,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bQ,A.d(x.f,w,w,w,w,C.Bm,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.G(u,w,s,t,w,w,w,C.n),w,w,C.aO,C.ac,w,w,w)}}
B.D7.prototype={
O(){var x=y.S
return new B.a2m($.ML(),A.B(x,y.B),A.aS(x),A.B(x,y.N),A.ej(null,y.H))}}
B.a2m.prototype={
W(){this.Y()
this.d.ac(this.goD())},
xL(){if(this.c!=null)this.j(new B.bWA())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.y
if(x!=null)x.aC()
v.a.a3j()
w.a0()},
I6(d){return this.b3L(d)},
b3L(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$I6=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.bWJ(t,d))
r=t.y
if(r!=null)r.aC()
t.y=A.hD(C.eV,new B.bWK(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.cag(B.ER(H.MC(q,d,p.xW(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dn(0,0,0,350*B.ER(H.MC(p,d,o.xW(p,d)).b).length,0,0)
x=6
return A.c(r.a.a99(r.b.c,q,p,new B.bWL(t,d),new B.bWM(t)),$async$I6)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lE){s=r
r=t.y
if(r!=null)r.aC()
if(t.c!=null)t.j(new B.bWN(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$I6,w)},
FB(d,e){return this.aLA(d,e)},
aLA(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$FB=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aC()
s.j(new B.bWE(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a9c()
if(e&&n!=null)s.I6(n)
q=null
u=4
x=7
return A.c(r,$async$FB)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lE){p=o
s.j(new B.bWF(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bG(new B.bWG(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$FB,w)},
gaWa(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b0u(){this.j(new B.bWH(this))},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jR,o=s.e,n=s.gaWa(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("cf<2>")
x=new A.ak(new A.cf(m,l),new B.bWO(),l.i("ak<a_.E>")).gM(0)
l=H.kl(s.a.c)
m=y.p
q=A.a([new B.Hl(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bp(s.a.d)+" \u0644\u062d\u062f "+E.bp(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aL,r,r,r),C.t],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b5s(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.Bg,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.D9(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bp(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aH(new A.aR(v,0,!1).dG(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c9c(v),r,r,r,r,K.oE,C.a0,r,r)
j=A.ff(A.v(6),A.q7(C.eR,D.eQ,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b0(u?O.Hr:C.nq,r,r,r)
C.b.A(q,A.a([v,C.F,j,C.t,A.fn(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.ct,r,r,r),new B.bWP(s,o),A.eA(C.v,C.ae,D.tL,r,r,r,r))],m))}else if(n!=null){j=p?new B.bWQ(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bp(n)
q.push(A.fn(D.arQ,A.d(v,r,r,r,r,C.ct,r,r,r),j,A.eA(C.v,C.ae,D.tL,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aVM)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cM:D.dY
v=k?C.ng:C.np
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bp(x)
u=s.a
u=k+" \u0645\u0646 "+E.bp(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.Dr(j,v,k,u,r),A.dj(D.atO,D.bvL,s.gb0t(),r)],m))}q.push(C.t)
q.push(D.C5)
return L.xC(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b5s(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.arb
else if(l.r.n(0,d))x=N.tO
else if(i!=null)x=D.ars
else if(j!=null){w=j.gts()?C.c1:D.anE
x=A.b0(w,j.gts()?G.cM:D.dY,k,k)}else x=D.apL
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bp(d),k,k,k,k,D.bgn,k,k,k),C.bB,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.a1J,k,k,k))
if(j!=null&&!j.gts()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMt()
o=J.bg(p)
n=o.h(p,r)
A:{if(D.j2===n){m=G.cM
break A}if(D.uG===n){m=D.dY
break A}if(D.uH===n){m=D.eQ
break A}m=C.eS
break A}m=D.ke.bb_(m,o.h(p,r)===D.uI?C.ka:k,22)
C.b.A(t,A.a([new A.eL(q.a,k,k,C.br,k,k,k,k,k,k,m),P.B8],u))}w=A.a([C.ai,A.CN(A.eq(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.a0,C.bi)],w)
if(C.c.P(j.c).length===0)w.push(D.bra)
C.b.A(v,w)}return new E.dz(A.I(v,C.ah,C.d,C.e,0,C.l),C.bM,C.d0,k,!1,k)}}
B.D6.prototype={
O(){return new B.a2l($.ML())}}
B.a2l.prototype={
W(){this.Y()
var x=this.d
x.ac(this.goD())
x.vC()},
xL(){if(this.c!=null)this.j(new B.bWr())},
m(){this.d.T(this.goD())
this.a0()},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gayD(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kq(o,0,new B.bWy(q))
v=C.b.kq(o,0,new B.bWz())
o=y.p
o=A.a([A.A(A.a([A.R(s.XS(E.bp(q.gat3()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.N,A.R(s.XS(E.bp(q.apF()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.N,A.R(s.XS(E.bp(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.t,new E.dz(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bp(C.f.ak(w*100/v))+"\u066a",r,r,r,r,C.bw,r,r,r),C.F,A.ff(A.v(6),A.q7(C.eR,G.cM,8,w/v,r),C.aC),C.ai,A.d(E.bp(w)+" \u0645\u0646 "+E.bp(v)+" \u0622\u064a\u0629",r,r,r,r,F.aL,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a4,C.aO,r,!1,r)],o)
if(p.length===0)o.push(D.aW0)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b5u(p[t]))
o.push(C.B)
u=$.C().b
u===$&&A.b()
u=u.ga3().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aL,r,r,r))
return L.xC(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
XS(d,e){var x=null
return new E.dz(A.I(A.a([A.d(d,x,x,x,x,D.bg5,x,x,x),A.d(e,x,x,x,x,C.a2f,C.a0,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a4,C.J,x,!1,x)},
b5u(d){var x=null,w=this.d.c,v=I.cO[d-1].a[1],u=w.a63(d),t=w.bga(d),s=y.p,r=A.A(A.a([A.R(A.d(H.kl(d),x,x,x,x,C.bw,x,x,x),1),A.d(E.bp(C.f.ak(u*100/v))+"\u066a",x,x,x,x,D.bhb,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.ff(A.v(6),A.q7(C.eR,G.cM,7,u/v,x),C.aC),p=E.bp(u),o=E.bp(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bp(t):""
return new E.dz(A.I(A.a([r,C.F,q,C.ai,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aL,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a4,C.aO,new B.bWx(this,d),!1,x)},
NW(d){return this.aJJ(d)},
aJJ(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$NW=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cO[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e_(C.cL,new B.bWw(v,d,u),t,!0,null,null,!1,y.H),$async$NW)
case 2:return A.h(null,w)}})
return A.i($async$NW,w)}}
B.aj6.prototype={
Rr(d,e){var x=null,w=A.mI(x,x,x,x,x,x,x,x,x,x,x,D.b8G,C.J,x,x,x,x,C.jQ,x,x)
return A.bh(A.d(d,x,x,x,x,C.m0,x,x,x),x,x,x,new B.b55(e),x,w)},
u(d){var x=this,w=y.p
return new E.dz(A.I(A.a([D.buR,C.F,D.bwn,A.cY(C.aw,A.a([x.Rr("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Rr("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aE,0,12),D.bkr,x.Rr("tanzil.net","https://tanzil.net"),D.by_,x.Rr("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a4,C.aO,null,!1,null)}}
B.D9.prototype={
O(){return new B.a2o()}}
B.a2o.prototype={
galW(){var x=this.a
return B.cKe(x.c,x.d,$.caT().Ji())},
Rt(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$Rt=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.bXu(s))
v=3
r=A.c4q()
n=s.galW()
m=y.N
q=A.B(m,m)
J.dW(q,"app","mogtama3y")
J.dW(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dW(q,"ua",m)}x=6
return A.c(A.a9G(n,null,C.G5,q),$async$Rt)
case 6:if(s.c!=null)s.j(new B.bXv(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cj?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.bXw(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.bXx(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Rt,w)},
u(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bw(!1,t,!0,new A.F(C.kQ,A.A(A.a([A.b0(u.d?C.y4:C.l5,C.cc,t,18),C.bJ,D.bxa],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bXz(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.D(t,A.xd(u.galW(),D.bco,t,C.A),C.k,t,t,new A.G(C.pz,t,t,x,t,t,t,C.n),t,t,D.aiV,C.ea,t,t,1/0))}if(u.f)s.push(D.bkJ)
else{x=A.mI(t,t,t,t,t,t,t,t,t,t,t,C.a02,C.J,t,t,t,t,C.jQ,t,t)
w=u.e
v=w?t:u.gb5t()
s.push(A.fv(w?C.a0h:D.ata,t,D.btO,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,D.a1J,t,t,t))
return new A.F(C.aO,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["ai<~>()","~()","N(nA)","ai<JJ>()","ai<JH>()","ai<JI>()","a7<nA>()","N(rq)","bE(oG)","D8(t)","D6(t)","N(mV)","D7(t)","N(Il)"])
B.b56.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.X(A.cO(b.G.document).baseURI)
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
m=B.czt("network",A.n(o))
throw A.r(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:307}
B.b59.prototype={
$1(d){var x=null
return A.c_5(A.cJ(d,"persist",x,x,x,x))},
$S:1114}
B.b58.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.ra(),$async$$0)
case 4:x=3
return A.c(n.eF(m.cO(l.cJ(e,"loadModel",A.c_O(new B.b57(u.b)),u.c,u.d,null)),y.m),$async$$0)
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
v=new B.JH(o,t,s,r,q.r9(p,"threads"),q.or(p,"isolated"),q.r9(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b57.prototype={
$2(d,e){this.a.$2(C.f.ak(d),C.f.ak(e))},
$S:1115}
B.b5d.prototype={
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
u.onLevel=A.fV(new B.b5b(v.e))
u.onAutoStop=A.fV(new B.b5c(v.f))
x=5
return A.c(A.eF(A.cO(A.cJ(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b5b.prototype={
$1(d){return this.a.$1(d)},
$S:70}
B.b5c.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b5e.prototype={
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
return A.c(q.eF(p.cO(o.cJ(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.JI(r,A.dN(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b5g.prototype={
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
return A.c(q.eF(p.cO(o.cJ(e,"transcribe",t.audio,t.rate,s.aif(u.c),null)),y.m),$async$$0)
case 3:v=r.alQ(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b5f.prototype={
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
return A.c(r.eF(q.cO(p.cJ(e,"transcribeUrl",u.b,t.aif(u.c),null,null)),y.m),$async$$0)
case 3:v=s.alQ(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b5a.prototype={
$1(d){return d},
$S:37}
B.aWk.prototype={
$0(){var x,w,v,u,t=this.a,s=A.cn(t.a.length,D.uI,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aWj.prototype={
$1(d){return d===D.j2},
$S:z+2}
B.c_x.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c5m(e[x],d[x])<0.75)return!1
return!0},
$S:1116}
B.c1D.prototype={
$1(d){return d.length!==0},
$S:9}
B.b5k.prototype={
$1(d){return d.a===D.fh},
$S:z+7}
B.b5l.prototype={
$1(d){return C.j.aH(d,1000)},
$S:59}
B.b5i.prototype={
$1(d){return C.f.bW(d)},
$S:1117}
B.b5m.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iA("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.am.fb(r,null))
j=A.aE(k.h(0,"n"))
j=j==null?null:C.f.bW(j)
j=C.j.d1(j==null?2:j,1,5)
i=C.b.n(D.Ja,k.h(0,"r"))?A.eD(k.h(0,"r")):1
h=A.eg(k.h(0,"auto"))
g=A.eg(k.h(0,"hide"))
k=A.eg(k.h(0,"in"))
s.a.b=new B.Vs(j,i,h!==!1,g===!0,k===!0)}u=2
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
if(q!=null)s.a.c=B.c8v(y.P.a(C.am.fb(q,null)))
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
if(p!=null){o=y.P.a(C.am.fb(p,null))
n=C.f.bW(A.cU(J.av(o,"s")))
m=C.f.bW(A.cU(J.av(o,"f")))
l=C.f.bW(A.cU(J.av(o,"t")))
if(B.cmP(n,m)&&B.cmP(n,l)&&m<=l)s.a.z=new A.b_(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a8Y()){k.a.aqt()
x=1
break}a1=k
x=18
return A.c(k.a.MO(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a4()
if(k.b.e)k.D9()
k.wz()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:102}
B.b5n.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a4()},
$S:1118}
B.b5o.prototype={
$2(d,e){return C.j.aH(A.eE(A.n(d),null,null),1000)===this.a},
$S:1119}
B.bJn.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.Ep(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bJm(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1120}
B.bJm.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bJo.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bJl(x,d))},
$S:z+8}
B.bJl.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bJp.prototype={
$1(d){},
$S:24}
B.bJ9.prototype={
$0(){},
$S:0}
B.bJf.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.D8(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bJg.prototype={
$0(){},
$S:0}
B.bJj.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aA(A.ax(new B.bJi(),null,x),x)},
$S:0}
B.bJi.prototype={
$1(d){return D.bzm},
$S:z+10}
B.bJk.prototype={
$0(){return B.cmB(this.a)},
$S:0}
B.bJc.prototype={
$0(){var x=this.b
return this.a.xM(x.a,x.b,x.c)},
$S:0}
B.bJd.prototype={
$1(d){return this.a.j(new B.bJb())},
$S:5}
B.bJb.prototype={
$0(){},
$S:0}
B.bJe.prototype={
$0(){var x=this.a
return x.j(new B.bJa(x))},
$S:0}
B.bJa.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bJh.prototype={
$0(){return this.a.b5r(this.b)},
$S:0}
B.c49.prototype={
$1(d){return new A.j9(new B.c46(this.a,this.b,this.c),null)},
$S:57}
B.c46.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c48(u,e),s=this.a,r=new B.c47(s,e),q=A.d(H.kl(this.c),v,v,v,v,C.oA,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bp(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aL,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bp(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bp(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.ai,p,C.t,A.cY(C.aw,n,C.aE,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c41(s)),C.a0d,t.$3("\u0644\u062d\u062f",s.c,new B.c42(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aVR)
u.push(C.a5)
u.push(A.dH(D.bnO,new B.c43(s,d),A.eA(C.v,C.ae,D.b93,v,v,v,v)))
return A.cu(!0,new A.F(C.Fx,A.I(u,C.ah,C.d,C.K,0,C.l),v),C.J,!0)},
$S:391}
B.c48.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.i7,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c7(v,A.d("\u0622\u064a\u0629 "+E.bp(v),u,u,u,u,u,u,u,u),C.ar,u,w))
return A.R(A.I(A.a([t,R.G1(C.cL,!0,s,320,new B.c45(this.b,f),D.bhs,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1122}
B.c45.prototype={
$1(d){return d==null?null:this.a.$1(new B.c44(this.b,d))},
$S:49}
B.c44.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c47.prototype={
$3(d,e,f){var x=null
return A.c5Y(x,A.d(d,x,x,x,x,x,x,x,x),new B.c40(this.a,this.b,e,f))},
$S:1123}
B.c40.prototype={
$0(){var x=this
return x.b.$1(new B.c4_(x.a,x.c,x.d))},
$S:0}
B.c4_.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c41.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c42.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c43.prototype={
$0(){var x=this.a
return A.O(this.b,!1).af(new A.W(x.b,x.c))},
$S:0}
B.bWR.prototype={
$0(){},
$S:0}
B.bX6.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mk
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bXa.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.j9:D.mk},
$S:0}
B.bXb.prototype={
$0(){var x=this.a
x.f=D.uX
x.as=null},
$S:0}
B.bXc.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bXe.prototype={
$0(){var x=this.a
x.f=D.uY
x.as=null
x.y=0
x.z=new A.aR(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bXf.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bXd())},
$S:31}
B.bXd.prototype={
$0(){},
$S:0}
B.bXh.prototype={
$1(d){return this.a.y=d},
$S:70}
B.bXg.prototype={
$1(d){return this.a.BB()},
$S:5}
B.bXi.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.j9:D.mk
x=this.b
w.as=B.ME(x)
w.at=x},
$S:0}
B.bXk.prototype={
$0(){var x=this.a
x.f=D.oZ
x.ay=Date.now()},
$S:0}
B.bXl.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bXj())},
$S:31}
B.bXj.prototype={
$0(){},
$S:0}
B.bX5.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.j9:D.mk
x.as=this.b
x.at=this.c},
$S:0}
B.bX7.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.j9
x.x=!1},
$S:0}
B.bWZ.prototype={
$0(){var x=this.a
x.f=D.oZ
x.ay=Date.now()
x.as=null},
$S:0}
B.bX_.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bWY())},
$S:31}
B.bWY.prototype={
$0(){},
$S:0}
B.bX0.prototype={
$1(d){return d.d!==D.j2},
$S:z+11}
B.bX1.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bXq.prototype={
$0(){return B.cmB(this.a)},
$S:0}
B.bXr.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.apa(d))},
$S:3}
B.bXs.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aA(A.ax(new B.bXp(this.a),null,x),x)},
$S:0}
B.bXp.prototype={
$1(d){var x=this.a.a
return new B.D7(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bXt.prototype={
$0(){this.a.d.a.bkt()
this.b.J(y.q).f.Z(D.ba9)},
$S:0}
B.bX4.prototype={
$2(d,e){return C.aX},
$S:17}
B.bX3.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a6c(s.c,r).a.a){case 2:s=G.cM
break
case 1:s=D.dY
break
case 0:s=C.il
break
default:s=u}x=A.v(18)
w=t.f===D.oZ?u:new B.bX2(t,r)
v=s.ad(0.25)
if(r===t.gjc())s=C.i
s=A.aH(s,r===t.gjc()?2:1)
return A.bw(!1,x,!0,A.D(C.P,A.d(E.bp(r),u,u,u,u,C.a1n,u,u,u),C.k,u,u,new A.G(v,u,s,u,u,u,u,C.bY),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:62}
B.bX2.prototype={
$0(){return this.a.ZZ(this.b)},
$S:0}
B.bX9.prototype={
$0(){var x=this.a
return x.j(new B.bX8(x))},
$S:0}
B.bX8.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bXm.prototype={
$1(d){return d===D.uG},
$S:z+2}
B.bXn.prototype={
$1(d){return d===D.uH},
$S:z+2}
B.bXo.prototype={
$1(d){return d===D.uI},
$S:z+2}
B.bWS.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Rs(x)},
$S:0}
B.bWT.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.bao(d.ga5(d)))},
$S:117}
B.bWV.prototype={
$1(d){return d.n(0,C.T)?C.ae:C.i},
$S:4}
B.bWU.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.bWW.prototype={
$0(){var x=this.a
return x.ZZ(x.gjc()+1)},
$S:0}
B.bWX.prototype={
$0(){var x=this.a
return x.ZZ(x.gjc()+1)},
$S:0}
B.bWA.prototype={
$0(){},
$S:0}
B.bWJ.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aR(Date.now(),0,!1)},
$S:0}
B.bWK.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bWI())},
$S:31}
B.bWI.prototype={
$0(){},
$S:0}
B.bWM.prototype={
$1(d){return this.a.x=d},
$S:70}
B.bWL.prototype={
$1(d){return this.a.FB(this.b,!1)},
$S:5}
B.bWN.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.ME(x)
w.as=x},
$S:0}
B.bWE.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.bWF.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.ME(x))
w.as=x},
$S:0}
B.bWG.prototype={
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
return A.c(n.a.auZ(s.b,B.ER(H.MC(l,m,k.xW(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.ckM(H.MC(l,m,k.xW(l,m)).b,r.a)
if(C.c.P(q.c).length!==0){l=n.c
k=o.a.c
j=q.gts()
l.au0(k,m,n.b.a,j)}n.zL()
if(o.c!=null)o.j(new B.bWB(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lE){p=o
o=s.a
if(o.c!=null)o.j(new B.bWC(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.bWD(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:148}
B.bWB.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.bWC.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.ME(w))
x.as=w},
$S:0}
B.bWD.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bWH.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)
x.as=null},
$S:0}
B.bWO.prototype={
$1(d){return d.gts()},
$S:z+13}
B.bWP.prototype={
$0(){return this.a.FB(this.b,!0)},
$S:0}
B.bWQ.prototype={
$0(){return this.a.I6(this.b)},
$S:0}
B.bWr.prototype={
$0(){},
$S:0}
B.bWy.prototype={
$2(d,e){return d+this.a.a63(e)},
$S:116}
B.bWz.prototype={
$2(d,e){return d+I.cO[e-1].a[1]},
$S:116}
B.bWx.prototype={
$0(){return this.a.NW(this.b)},
$S:0}
B.bWw.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kl(p),q,q,q,q,C.oA,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.ba(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.rf():r).a.a){case 2:r=G.cM.ad(0.35)
break
case 1:r=D.dY.ad(0.35)
break
case 0:r=C.fX
break
default:r=q}m.push(A.D(C.P,A.d(E.bp(t),q,q,q,q,C.kd,q,q,q),C.k,q,q,new A.G(r,q,q,new A.cz(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cu(!0,new A.F(C.h2,A.I(A.a([o,C.ai,D.bs4,C.t,new A.dD(D.a79,A.f5(A.cY(C.aw,m,C.aE,6,6),q,C.r,q,q,q,C.w),q),C.a1,A.bh(D.btS,q,q,q,new B.bWv(w,d,p),q,q)],n),C.ah,C.d,C.K,0,C.l),q),C.J,!0)},
$S:36}
B.bWv.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dm(null,null,!0,null,new B.bWu(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.L6(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e5()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.bWu.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kl(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.du(A.a([A.bh(C.ep,x,x,x,new B.bWs(d),x,x),A.bh(C.oM,x,x,x,new B.bWt(d),x,x)],y.p),w,D.bvr)},
$S:14}
B.bWs.prototype={
$0(){A.O(this.a,!1).af(!1)
return null},
$S:0}
B.bWt.prototype={
$0(){A.O(this.a,!1).af(!0)
return null},
$S:0}
B.c50.prototype={
$1(d){var x=this.a
return new A.kD(new B.c5_(x),null,x,null)},
$S:1124}
B.c5_.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.em(w,t,A.d(E.bp(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bkl,C.a1,D.bui,C.F,A.oO(new B.c4V(s,r),q,A.db([r.a],x),!1,A.kp(t,t,t,new A.bf(new B.c4W(),v),t,t,t,t,new A.bf(new B.c4X(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.is(C.v,C.J,t,new B.c4Y(s,r),D.brl,D.bxs,r.c),A.is(C.v,C.J,t,new B.c4Z(s,r),t,D.bjQ,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ai,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn3(),t,t,t,t,F.aL,t,C.bi,t)],u))
x.push(C.B)
x.push(D.a3p)
return A.cu(!0,A.f5(A.I(x,C.ah,C.d,C.e,0,C.l),t,C.r,C.h2,t,t,C.w),C.J,!0)},
$S:1125}
B.c4V.prototype={
$1(d){return this.a.qK(this.b.bal(d.ga5(d)))},
$S:117}
B.c4X.prototype={
$1(d){return d.n(0,C.T)?C.ae:C.i},
$S:4}
B.c4W.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.c4Y.prototype={
$1(d){return this.a.qK(this.b.b9H(d))},
$S:3}
B.c4Z.prototype={
$1(d){return this.a.qK(this.b.apa(d))},
$S:3}
B.b55.prototype={
$0(){return A.cv(A.bz(this.a,0,null),C.aR,null)},
$S:0}
B.c5g.prototype={
$1(d){var x,w=A.aC("https?://",!0,!1,!1)
w=A.bD(d,w,"")
x=A.aC("www\\.",!0,!1,!1)
return A.uS(A.bD(w,x,"www[.]"),A.aC("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c5h(),null)},
$S:37}
B.c5h.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:58}
B.bXu.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bXv.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bXw.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bXx.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bXz.prototype={
$0(){var x=this.a
return x.j(new B.bXy(x))},
$S:0}
B.bXy.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c5f.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:203};(function installTearOffs(){var x=a._instance_0u
x(B.aj7.prototype,"gbgb","bgc",1)
var w
x(w=B.Vt.prototype,"gbgs","D9",0)
x(w,"gaDF","wz",0)
x(w=B.a_V.prototype,"goD","xL",1)
x(w,"gaXY","PS",0)
x(w=B.a2n.prototype,"goD","xL",1)
x(w,"gb_D","Qg",0)
x(w,"gb4_","BB",0)
x(w,"gaJn","NT",0)
x(w=B.a2m.prototype,"goD","xL",1)
x(w,"gb0t","b0u",1)
x(B.a2l.prototype,"goD","xL",1)
x(B.a2o.prototype,"gb5t","Rt",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aj7,B.Vu,B.JH,B.JJ,B.JI,B.lE,B.SA,B.mV,B.Il,B.rq,B.aj8,B.Vs])
x(A.lb,[B.b56,B.b58,B.b5d,B.b5e,B.b5g,B.b5f,B.aWk,B.b5m,B.bJm,B.bJl,B.bJ9,B.bJg,B.bJj,B.bJk,B.bJc,B.bJb,B.bJe,B.bJa,B.bJh,B.c44,B.c40,B.c4_,B.c43,B.bWR,B.bX6,B.bXa,B.bXb,B.bXc,B.bXe,B.bXd,B.bXi,B.bXk,B.bXj,B.bX5,B.bX7,B.bWZ,B.bWY,B.bX1,B.bXq,B.bXs,B.bXt,B.bX2,B.bX9,B.bX8,B.bWS,B.bWW,B.bWX,B.bWA,B.bWJ,B.bWI,B.bWN,B.bWE,B.bWF,B.bWB,B.bWC,B.bWD,B.bWH,B.bWP,B.bWQ,B.bWr,B.bWx,B.bWv,B.bWs,B.bWt,B.b55,B.bXu,B.bXv,B.bXw,B.bXx,B.bXz,B.bXy])
x(A.iE,[B.b59,B.b5b,B.b5c,B.b5a,B.aWj,B.c1D,B.b5k,B.b5l,B.b5i,B.bJn,B.bJo,B.bJp,B.bJf,B.bJi,B.bJd,B.c49,B.c48,B.c45,B.c47,B.c41,B.c42,B.bXf,B.bXh,B.bXg,B.bXl,B.bX_,B.bX0,B.bXr,B.bXp,B.bXm,B.bXn,B.bXo,B.bWT,B.bWV,B.bWU,B.bWK,B.bWM,B.bWL,B.bWG,B.bWO,B.bWw,B.bWu,B.c50,B.c4V,B.c4X,B.c4W,B.c4Y,B.c4Z,B.c5g,B.c5h,B.c5f])
x(A.o4,[B.b57,B.c_x,B.b5n,B.b5o,B.c46,B.bX4,B.bX3,B.bWy,B.bWz,B.c5_])
x(A.DI,[B.nA,B.F9,B.Hk,B.E8])
w(B.Vt,A.i1)
x(A.K,[B.wS,B.D8,B.D7,B.D6,B.D9])
x(A.M,[B.a_V,B.a2n,B.a2m,B.a2l,B.a2o])
x(A.a3,[B.Hl,B.XL,B.Dr,B.aj6])})()
A.pi(b.typeUniverse,JSON.parse('{"lE":{"bP":[]},"D8":{"K":[],"l":[]},"D7":{"K":[],"l":[]},"D6":{"K":[],"l":[]},"D9":{"K":[],"l":[]},"Vt":{"aA":[]},"wS":{"K":[],"l":[]},"a_V":{"M":["wS"]},"Hl":{"a3":[],"l":[]},"XL":{"a3":[],"l":[]},"a2n":{"M":["D8"]},"Dr":{"a3":[],"l":[]},"a2m":{"M":["D7"]},"a2l":{"M":["D6"]},"aj6":{"a3":[],"l":[]},"a2o":{"M":["D9"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rq"),c:x("em<x>"),r:x("c7<x>"),k:x("H<mV>"),n:x("H<em<x>>"),I:x("H<c7<x>>"),R:x("H<hO>"),Z:x("H<aP<o,@>>"),d:x("H<SA>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bO"),j:x("a7<@>"),L:x("a7<x>"),P:x("aP<o,@>"),f:x("aP<@,@>"),x:x("au<o,x>"),a:x("bE"),K:x("a4"),B:x("Il"),l:x("+(x,x)"),e:x("d9<mV>"),N:x("o"),C:x("JH"),D:x("JI"),X:x("Vu"),_:x("JJ"),U:x("ak<o>"),G:x("nA"),q:x("pf"),b:x("bf<S?>"),y:x("N"),i:x("a2"),z:x("@"),S:x("x"),A:x("bO?"),Y:x("aP<@,@>?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("fA"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.p7=new B.F9(0,"none")
D.p8=new B.F9(1,"learning")
D.fh=new B.F9(2,"memorized")
D.a79=new A.aD(0,1/0,0,320)
D.eQ=new A.S(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a7h=new A.G(D.eQ,null,null,null,null,null,null,C.bY)
D.dY=new A.S(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.asq=new A.E(C.yg,null,C.cc,null,null,null)
D.bvB=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.fa,null,null,null,null,null,null,null,null)
D.bcS=new A.q(!0,C.eS,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bs6=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bcS,null,null,null,null,null,null,null,null)
D.aJq=x([D.asq,C.F,D.bvB,D.bs6],y.p)
D.afp=new A.fg(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aJq,null)
D.aiS=new A.U(0,26,0,26)
D.aiV=new A.U(0,4,0,6)
D.aji=new A.U(14,12,14,14)
D.ak1=new A.U(3,0,0,0)
D.anE=new A.Q(63251,"MaterialIcons",null,!1)
D.qy=new A.Q(63677,"MaterialIcons",null,!1)
D.aos=new A.Q(983209,"MaterialIcons",null,!1)
D.ap5=new A.E(D.aos,28,C.v,null,null,null)
D.apL=new A.E(C.H9,null,C.il,null,null,null)
D.anm=new A.Q(62961,"MaterialIcons",null,!1)
D.aqu=new A.E(D.anm,null,null,null,null,null)
D.anC=new A.Q(63199,"MaterialIcons",null,!1)
D.aqv=new A.E(D.anC,null,null,null,null,null)
D.aqD=new A.E(C.l4,null,C.eS,null,null,null)
D.aqG=new A.E(C.nq,44,C.i,null,null,null)
D.arb=new A.E(D.qy,null,D.eQ,null,null,null)
D.ars=new A.E(C.nh,null,D.eQ,null,null,null)
D.arQ=new A.E(D.qy,null,null,null,null,null)
D.asm=new A.E(C.iv,20,D.dY,null,null,null)
D.asJ=new A.E(C.nn,30,C.v,null,null,null)
D.ata=new A.E(C.l9,16,C.v,null,null,null)
D.atC=new A.E(C.H6,null,null,null,null,null)
D.atO=new A.E(C.np,null,null,null,null,null)
D.and=new A.Q(62842,"MaterialIcons",null,!0)
D.au1=new A.E(D.and,null,null,null,null,null)
D.Ja=x([1,3,5],y.t)
D.JY=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aWs=new A.F(C.kR,C.mx,null)
D.aGg=x([D.aWs],y.p)
D.b_U=new A.W(C.nj,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b_H=new A.W(D.qy,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b0e=new A.W(C.dx,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.aoc=new A.Q(63625,"MaterialIcons",null,!1)
D.b0s=new A.W(D.aoc,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aIo=x([D.b_U,D.b_H,D.b0e,D.b0s],A.ae("H<+(Q,o)>"))
D.aKM=x([D.p7,D.p8,D.fh],A.ae("H<F9>"))
D.OB=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aSk=new B.Hk(0,"idle")
D.UQ=new B.Hk(1,"loading")
D.jR=new B.Hk(2,"ready")
D.aSl=new B.Hk(3,"failed")
D.ar9=new A.E(C.c1,18,G.cM,null,null,null)
D.bwA=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uj,null,null,null,null,null,null,null,null)
D.aFa=x([D.ar9,C.aX,D.bwA],y.p)
D.b6s=new A.ek(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aFa,null)
D.aVm=new A.F(C.aO,D.b6s,null)
D.ak_=new A.U(2,6,2,4)
D.bcy=new A.q(!0,C.v,null,null,null,null,14,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bki=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bcy,null,null,null,null,null,null,null,null)
D.aVB=new A.F(D.ak_,D.bki,null)
D.bwZ=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.fa,null,null,null,null,null,null,null,null)
D.aGA=x([N.tO,C.N,D.bwZ],y.p)
D.b6m=new A.ek(C.af,C.cp,C.e,C.h,null,C.l,null,0,D.aGA,null)
D.aVM=new A.F(C.n0,D.b6m,null)
D.Bu=new A.q(!0,D.dY,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bxk=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Bu,null,null,null,null,null,null,null,null)
D.aVR=new A.F(C.dK,D.bxk,null)
D.bwv=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aL,C.a0,null,null,null,null,null,null,null)
D.aW0=new A.F(C.C,D.bwv,null)
D.ajX=new A.U(2,0,2,8)
D.bso=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aL,null,null,null,null,null,null,null,null)
D.aWi=new A.F(D.ajX,D.bso,null)
D.atk=new A.E(C.l7,30,C.v,null,null,null)
D.by0=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Bv,null,null,null,null,null,null,null,null)
D.al8=new A.bU(1,C.ad,D.by0,null)
D.aGP=x([D.atk,C.Y,D.al8],y.p)
D.b68=new A.ek(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aGP,null)
D.asV=new A.E(C.dx,18,G.cM,null,null,null)
D.a1x=new A.q(!0,G.cM,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bwc=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a1x,null,null,null,null,null,null,null,null)
D.aFB=x([D.asV,C.bJ,D.bwc],y.p)
D.b6k=new A.ek(C.af,C.d,C.K,C.h,null,C.l,null,0,D.aFB,null)
D.b8G=new A.T(0,30)
D.tL=new A.T(1/0,54)
D.b93=new A.T(1/0,48)
D.b96=new A.T(1/0,50)
D.b99=new A.T(1/0,52)
D.bu1=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.ba9=new A.d8(D.bu1,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.bc_=new A.q(!0,C.i,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bco=new A.q(!0,C.an,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.Bg=new A.q(!0,D.eQ,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.ke=new A.q(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a1J=new A.q(!0,D.eQ,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bg5=new A.q(!0,C.v,null,null,null,null,24,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgn=new A.q(!0,C.v,null,null,null,null,null,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bha=new A.q(!0,D.dY,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhb=new A.q(!0,G.cM,null,null,null,null,null,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhs=new A.q(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bj7=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.i7,null,null,null,null,null,null,null,null)
D.bjQ=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.cT,null,null,null,null,null,null,null,null)
D.bkl=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oA,null,null,null,null,null,null,null,null)
D.bkr=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aL,null,null,null,null,null,null,null,null)
D.bdJ=new A.q(!0,G.cM,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bkJ=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bdJ,null,null,null,null,null,null,null,null)
D.bkQ=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aL,null,null,null,null,null,null,null,null)
D.blf=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.fa,null,null,null,null,null,null,null,null)
D.bn2=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.ct,null,null,null,null,null,null,null,null)
D.bnO=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bF,null,null,null,null,null,null,null,null)
D.bnT=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aL,null,null,null,null,null,null,null,null)
D.bok=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.Bz,null,null,null,null,null,null,null,null)
D.bpA=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bq9=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oE,null,null,null,null,null,null,null,null)
D.bqW=new A.m("reset safe mode / WebGPU ban",null,O.a13,null,null,null,null,null,null,null,null)
D.bra=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Bu,null,null,null,null,null,null,null,null)
D.brl=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aL,null,null,null,null,null,null,null,null)
D.brM=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bw,null,null,null,null,null,null,null,null)
D.bs4=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aL,null,null,null,null,null,null,null,null)
D.bsp=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aL,null,null,null,null,null,null,null,null)
D.btO=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a28,null,null,null,null,null,null,null,null)
D.bfj=new A.q(!0,D.eQ,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.btS=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bfj,null,null,null,null,null,null,null,null)
D.bui=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oE,null,null,null,null,null,null,null,null)
D.buR=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0Y,null,null,null,null,null,null,null,null)
D.bv5=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.ct,null,null,null,null,null,null,null,null)
D.bvr=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bvL=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bwn=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aL,null,null,null,null,null,null,null,null)
D.bwo=new A.m("\u062e\u0644\u0635\u062a",null,C.m1,null,null,null,null,null,null,null,null)
D.bwp=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Bu,null,null,null,null,null,null,null,null)
D.bgp=new A.q(!0,C.cG,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.fK,null,null,null,null,null,null,null,null)
D.bxa=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bgp,null,null,null,null,null,null,null,null)
D.bxo=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bw,null,null,null,null,null,null,null,null)
D.bxs=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.cT,null,null,null,null,null,null,null,null)
D.by_=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aL,null,null,null,null,null,null,null,null)
D.a3p=new B.aj6(null)
D.bzm=new B.D6(null)
D.bzn=new B.Vs(2,1,!0,!1,!1)
D.a3t=new B.Vu(!1,!1,!1,!1,!1,0)
D.j2=new B.nA(0,"ok")
D.uG=new B.nA(1,"near")
D.uH=new B.nA(2,"wrong")
D.uI=new B.nA(3,"missing")
D.a3U=new B.nA(4,"extra")
D.anT=new A.Q(63456,"MaterialIcons",null,!1)
D.bF0=new B.Dr(D.dY,D.anT,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bFE=new B.XL(!1,null)
D.C5=new B.XL(!0,null)
D.mk=new B.E8(0,"idle")
D.uX=new B.E8(1,"playing")
D.uY=new B.E8(2,"recording")
D.oZ=new B.E8(3,"thinking")
D.j9=new B.E8(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cNb","caT",()=>new B.aj7())
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
x($,"cQB","cbu",()=>A.aC("\\s+",!0,!1,!1))
x($,"cKv","rf",()=>B.crw(D.p7,0,A.c6w(0,!0)))
x($,"cNc","ML",()=>new B.Vt($.caT(),D.bzn,B.czu(),D.aSk,$.Y()))})()};
(a=>{a["5n8mCArCj2zMqv6cxu8PDRc8Ohc="]=a.current})($__dart_deferred_initializers__);