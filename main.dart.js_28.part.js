((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,Q,H,G,N,R,K,B={
cxT(d){var x,w,v,u,t,s
if(d instanceof B.lD)return d
try{x=A.d1(d)
w=x.code
v=x.message
u=w==null?"failed":A.a_(w)
t=v==null?"":A.a_(v)
return new B.lD(u,t)}catch(s){u=A.n(d)
return new B.lD("failed",u)}},
aiT:function aiT(){this.b=this.a=null},
b4F:function b4F(d){this.a=d},
b4I:function b4I(){},
b4H:function b4H(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b4G:function b4G(d){this.a=d},
b4M:function b4M(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b4K:function b4K(d){this.a=d},
b4L:function b4L(d){this.a=d},
b4N:function b4N(d){this.a=d},
b4P:function b4P(d,e,f){this.a=d
this.b=e
this.c=f},
b4O:function b4O(d,e,f){this.a=d
this.b=e
this.c=f},
b4J:function b4J(){},
cxU(d,e){return new B.lD(d,e)},
Vk:function Vk(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
JB:function JB(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
JD:function JD(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
JC:function JC(d,e){this.a=d
this.b=e},
lD:function lD(d,e){this.a=d
this.b=e},
ckj(d){var x,w=$.cp0()
w=A.bK(d,w,"\u0627")
x=$.cp1()
w=A.bK(w,x,"\u064a")
x=$.cpa()
w=A.bK(w,x,"\u0627")
x=$.cnw()
w=A.bK(w,x,"\u0627")
x=$.coH()
w=A.bK(w,x,"\u0621")
x=$.coj()
w=A.bK(w,x,"\u0621")
x=$.cnx()
w=A.bK(w,x,"\u0627")
x=$.cnD()
w=A.bK(w,x,"\u0621")
w=A.bK(w,"\u0649","\u064a")
w=A.bK(w,"\u0629","\u0647")
x=$.col()
w=A.bK(w,x,"")
x=$.coK()
w=A.bK(w,x," ")
x=$.cos()
w=A.bK(w,x," ")
x=$.ca2()
return C.c.P(A.bK(w,x," "))},
cCz(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kB(x,w)
for(u=0;u<x;++u)v[u]=u
t=A.cl(x,0,!1,w)
for(s=1;s<=l;++s,r=t,t=v,v=r){t[0]=s
for(w=s-1,u=1;u<=k;++u){q=u-1
p=d.charCodeAt(w)===e.charCodeAt(q)?0:1
o=v[u]+1
n=t[q]+1
m=v[q]+p
if(o<n)q=o<m?o:m
else q=n<m?n:m
t[u]=q}}return v[k]},
c3U(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aF("[\u0627\u0621]",!0,!1,!1)
w=A.bK(d,x,"")
x=A.aF("[\u0627\u0621]",!0,!1,!1)
v=A.bK(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cCz(d,e)/u
return s>=1?0.99:s},
EK(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tV(d,$.ca2()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.ckj(u)
s=A.bK(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Sr(r.a+" "+u,r.b))}continue}q.push(new B.Sr(u,s))}return q},
cBf(d,e){var x,w,v,u,t=new B.bZk(),s=A.a([],y.s)
for(x=A.fS(e,0,A.iV(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.cb(x,x.gL(0),w.i("cb<aY.E>")),w=w.i("aY.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.JN)&&t.$2(d,D.JN)?C.b.jy(d,5):d
return!t.$2(s,D.Oq)&&t.$2(u,D.Oq)?C.b.jy(u,4):u},
cjg(d,e){var x=B.EK(d),w=B.ckj(e),v=y.U
v=A.aa(new A.aj(A.a(w.split(" "),y.s),new B.c0q(),v),v.i("Z.E"))
return new B.Ie(x,B.cAq(x,B.cBf(v,x)),w)},
cAq(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.cl(x,0,!1,s)
q=A.cl(x,0,!1,y.S)
p=A.cl(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c3U(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c3U(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c3U(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
else m=a2>=0.6?D.uA:D.uB
a1.push(new B.mT(o,x,s,m))
break
case 1:--o
a1.push(new B.mT(o,a4[o],null,D.uC))
break
case 2:--n
a1.push(new B.mT(null,null,a6[n],D.a3F))
break
case 3:--o
a3=n-2
a1.push(new B.mT(o,a4[o],a6[a3]+" "+a6[n-1],D.j2))
n=a3
break
default:x=o-1;--n
a1.push(new B.mT(x,a4[x],a6[n],D.j2))
o-=2
a1.push(new B.mT(o,a4[o],a6[n],D.j2))}}a4=y.e
a4=A.aa(new A.d6(a1,a4),a4.i("aY.E"))
return a4},
nw:function nw(d,e){this.a=d
this.b=e},
Sr:function Sr(d,e){this.a=d
this.b=e},
mT:function mT(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Ie:function Ie(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aVV:function aVV(d){this.a=d},
aVU:function aVU(){},
bZk:function bZk(){},
c0q:function c0q(){},
cq_(d,e,f){return new B.rp(d,e,f)},
cDu(d){var x
A:{if("memorized"===d){x=D.fg
break A}if("learning"===d){x=D.p3
break A}x=D.p2
break A}return x},
clh(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cN[d-1].a[1]},
cxV(){var x=y.S
return new B.aiU(A.B(x,y.u),A.aU(x))},
b4S(d){var x=d.fl()
return C.c.dn(C.j.j(A.bq(x)),4,"0")+"-"+C.c.dn(C.j.j(A.bs(x)),2,"0")+"-"+C.c.dn(C.j.j(A.bV(x)),2,"0")},
cga(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cEV(),x),x.i("aY.E"))
return B.b4S(A.dq(w[0],w[1],w[2]-1,12,0,0,0))},
c71(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.B(p,y.u),n=A.aU(p),m=new B.aiU(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcP(),x=x.ga0(x),w=y.j;x.v();){v=x.gJ()
u=A.dR(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aP(t)>=3){v=C.j.aH(u,1000)
s=C.j.a2(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cN[v-1].a[1])}if(v)continue
v=J.be(t)
r=C.f.ca(A.cR(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rp(D.aK0[r],C.f.ca(A.cR(v.h(t,1))),new A.aV(A.ks(C.f.ca(A.cR(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aA7(q,y.o)
p=A.mo(x,new B.b4R(),x.$ti.i("Z.E"),p)
n.A(0,new A.aj(p,o.ga3A(),A.y(p).i("aj<Z.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aH(d.h(0,"streak"))
p=p==null?null:C.f.ca(p)
p=m.d=p==null?0:p
o=A.aH(d.h(0,"best"))
o=o==null?null:C.f.ca(o)
m.e=o==null?p:o
return m},
azs(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dn(C.j.j(d),3,"0")+C.c.dn(C.j.j(e),3,"0")+".mp3"},
F2:function F2(d,e){this.a=d
this.b=e},
rp:function rp(d,e,f){this.a=d
this.b=e
this.c=f},
aiU:function aiU(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b4T:function b4T(){},
b4U:function b4U(){},
b4R:function b4R(){},
Vi:function Vi(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cvp(){return new B.wP(null)},
cHh(d,e){var x,w,v,u,t={},s=I.cN[e-1].a[1],r=$.MF().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.re():v).a===D.fg}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d1(u+4,1,s)
return A.e7(C.cK,new B.c2K(t,s,e),d,!0,null,null,!1,y.l)},
c8O(d){return A.dl(0,0,0,0,0,C.j.d1(C.f.al(6+d*1.2),25,90))},
c7J(d){return E.bp(C.j.aH(d,60))+":"+C.c.dn(E.bp(C.j.a2(d,60)),2,"\u0660")},
cl3(d){return A.e7(C.cK,new B.c3y($.MF()),d,!0,null,null,!1,y.H)},
My(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl2()
break A}return x},
cIB(d,e,f){var x,w=new B.c3O(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
clc(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.aq.fz(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.hd:r
q=s.a(J.av(x,"last"))
v=q==null?C.hd:q
u=new B.c3N()
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
a1=J.l(J.av(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.l(J.av(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
He:function He(d,e){this.a=d
this.b=e},
Vj:function Vj(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=null
_.e=!1
_.f=g
_.w=_.r=0
_.as=_.Q=_.z=_.y=_.x=null
_.at=!1
_.M$=0
_.q$=h
_.U$=_.S$=0},
b4V:function b4V(d){this.a=d},
b4W:function b4W(d){this.a=d},
b4X:function b4X(d){this.a=d},
wP:function wP(d){this.a=d},
a_K:function a_K(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bIm:function bIm(d){this.a=d},
bIl:function bIl(d,e){this.a=d
this.b=e},
bIn:function bIn(d){this.a=d},
bIk:function bIk(d,e){this.a=d
this.b=e},
bIo:function bIo(){},
bI8:function bI8(){},
bIe:function bIe(d,e,f){this.a=d
this.b=e
this.c=f},
bIf:function bIf(){},
bIi:function bIi(d){this.a=d},
bIh:function bIh(){},
bIj:function bIj(d){this.a=d},
bIb:function bIb(d,e){this.a=d
this.b=e},
bIc:function bIc(d){this.a=d},
bIa:function bIa(){},
bId:function bId(d){this.a=d},
bI9:function bI9(d){this.a=d},
bIg:function bIg(d,e){this.a=d
this.b=e},
Hf:function Hf(d,e,f){this.c=d
this.d=e
this.a=f},
XA:function XA(d,e){this.c=d
this.a=e},
c2K:function c2K(d,e,f){this.a=d
this.b=e
this.c=f},
c2H:function c2H(d,e,f){this.a=d
this.b=e
this.c=f},
c2J:function c2J(d,e){this.a=d
this.b=e},
c2G:function c2G(d,e){this.a=d
this.b=e},
c2F:function c2F(d,e){this.a=d
this.b=e},
c2I:function c2I(d,e){this.a=d
this.b=e},
c2B:function c2B(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c2A:function c2A(d,e,f){this.a=d
this.b=e
this.c=f},
c2C:function c2C(d){this.a=d},
c2D:function c2D(d){this.a=d},
c2E:function c2E(d,e){this.a=d
this.b=e},
E1:function E1(d,e){this.a=d
this.b=e},
D1:function D1(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2b:function a2b(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bVE:function bVE(){},
bVU:function bVU(d,e){this.a=d
this.b=e},
bVY:function bVY(d){this.a=d},
bVZ:function bVZ(d){this.a=d},
bW_:function bW_(d,e,f){this.a=d
this.b=e
this.c=f},
bW1:function bW1(d){this.a=d},
bW2:function bW2(d){this.a=d},
bW0:function bW0(){},
bW4:function bW4(d){this.a=d},
bW3:function bW3(d){this.a=d},
bW5:function bW5(d,e){this.a=d
this.b=e},
bW7:function bW7(d){this.a=d},
bW8:function bW8(d){this.a=d},
bW6:function bW6(){},
bVT:function bVT(d,e,f){this.a=d
this.b=e
this.c=f},
bVV:function bVV(d,e,f){this.a=d
this.b=e
this.c=f},
bVM:function bVM(d){this.a=d},
bVN:function bVN(d){this.a=d},
bVL:function bVL(){},
bVO:function bVO(){},
bVP:function bVP(d,e){this.a=d
this.b=e},
bWd:function bWd(d){this.a=d},
bWe:function bWe(d){this.a=d},
bWf:function bWf(d,e){this.a=d
this.b=e},
bWc:function bWc(d){this.a=d},
bWg:function bWg(d,e){this.a=d
this.b=e},
bVS:function bVS(){},
bVR:function bVR(d){this.a=d},
bVQ:function bVQ(d,e){this.a=d
this.b=e},
bVX:function bVX(d){this.a=d},
bVW:function bVW(d){this.a=d},
bW9:function bW9(){},
bWa:function bWa(){},
bWb:function bWb(){},
bVF:function bVF(d,e,f){this.a=d
this.b=e
this.c=f},
bVG:function bVG(d){this.a=d},
bVI:function bVI(){},
bVH:function bVH(){},
bVJ:function bVJ(d){this.a=d},
bVK:function bVK(d){this.a=d},
Dk:function Dk(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
D0:function D0(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2a:function a2a(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bVn:function bVn(){},
bVw:function bVw(d,e){this.a=d
this.b=e},
bVx:function bVx(d){this.a=d},
bVv:function bVv(){},
bVz:function bVz(d){this.a=d},
bVy:function bVy(d,e){this.a=d
this.b=e},
bVA:function bVA(d,e){this.a=d
this.b=e},
bVr:function bVr(d,e){this.a=d
this.b=e},
bVs:function bVs(d,e,f){this.a=d
this.b=e
this.c=f},
bVt:function bVt(d,e,f){this.a=d
this.b=e
this.c=f},
bVo:function bVo(d,e,f){this.a=d
this.b=e
this.c=f},
bVp:function bVp(d,e,f){this.a=d
this.b=e
this.c=f},
bVq:function bVq(d,e){this.a=d
this.b=e},
bVu:function bVu(d){this.a=d},
bVB:function bVB(){},
bVC:function bVC(d,e){this.a=d
this.b=e},
bVD:function bVD(d,e){this.a=d
this.b=e},
D_:function D_(d){this.a=d},
a29:function a29(d){this.d=d
this.c=this.a=null},
bVe:function bVe(){},
bVl:function bVl(d){this.a=d},
bVm:function bVm(){},
bVk:function bVk(d,e){this.a=d
this.b=e},
bVj:function bVj(d,e,f){this.a=d
this.b=e
this.c=f},
bVi:function bVi(d,e,f){this.a=d
this.b=e
this.c=f},
bVh:function bVh(d){this.a=d},
bVf:function bVf(d){this.a=d},
bVg:function bVg(d){this.a=d},
c3y:function c3y(d){this.a=d},
c3x:function c3x(d){this.a=d},
c3s:function c3s(d,e){this.a=d
this.b=e},
c3u:function c3u(){},
c3t:function c3t(){},
c3v:function c3v(d,e){this.a=d
this.b=e},
c3w:function c3w(d,e){this.a=d
this.b=e},
aiS:function aiS(d){this.a=d},
b4E:function b4E(d){this.a=d},
c3O:function c3O(){},
c3P:function c3P(){},
D2:function D2(d,e,f){this.c=d
this.d=e
this.a=f},
a2c:function a2c(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bWh:function bWh(d){this.a=d},
bWi:function bWi(d){this.a=d},
bWj:function bWj(d,e){this.a=d
this.b=e},
bWk:function bWk(d){this.a=d},
bWm:function bWm(d){this.a=d},
bWl:function bWl(d){this.a=d},
c3N:function c3N(){}},D,O,P,I,E,F
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
B.aiT.prototype={
r6(){var x=this,w=x.a
if(w!=null)return A.eh(w,y.m)
w=x.b
return w==null?x.b=new B.b4F(x).$0():w},
um(d,e){return this.aMU(d,e,e)},
aMU(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
var $async$um=A.e(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$um)
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
r=B.cxT(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$um,w)},
or(d,e){var x=A.ef(d[e])
if(x==null)x=null
return x===!0},
MJ(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$MJ=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.r6(),$async$MJ)
case 7:r=h.d1(g.cT(e,"support",null,null,null,null))
q=s.or(r,"worker")
p=s.or(r,"wasm")
o=s.or(r,"mic")
n=s.or(r,"audio")
s.or(r,"webgpu")
m=s.or(r,"secure")
s.or(r,"ios")
l=A.jO(r.memory)
if(l==null)l=null
if(l==null)l=0
s.or(r,"isolated")
k=A.jO(r.cores)
if(k!=null)C.f.al(k)
v=new B.Vk(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a3e
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$MJ,w)},
En(){var x=0,w=A.j(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$En=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.r6(),$async$En)
case 8:x=7
return A.c(m.eD(l.d1(k.cT(e,"storage",null,null,null,null)),y.A),$async$En)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.al(A.dW(r.quota))
p=C.f.al(A.dW(r.usage))
v=new A.asY(q,p)
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
return A.i($async$En,w)},
biP(){var x=y.K
A.Pu(this.r6().bG(new B.b4I(),x),x)},
r5(d,e){var x=A.jO(d[e])
x=x==null?null:C.f.al(x)
return x==null?0:x},
bgb(d,e,f){return this.um(new B.b4H(this,d,e,f),y.C)},
gaki(){var x,w
try{x=A.kj(b.G.sessionStorage)
return x}catch(w){return null}},
garL(){var x=A.ef(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a8R(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.ef(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.garL())return!1
l=A.ef(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.d1(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.a_(x.userAgent)
l=A.jO(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.u(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aF("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.l(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aF("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.jO(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.gaki()
l=l==null?f:A.u(A.cT(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dR(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.kj(m.localStorage)
m=o
m=m==null?f:A.u(A.cT(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dR(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
aqi(){var x,w,v,u,t,s,r=null
try{x=this.gaki()
if(x!=null)A.cT(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.d1(x.location)
u=A.a_(v.hash)
t=A.a_(v.search)
s=A.bB(A.a_(A.d1(x.document).baseURI),0,r).a1("tutor/").j(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cT(v,"replace",s+t+x,r,r,r)},
bfV(){var x,w=null,v=b.G,u=A.d1(v.history),t=A.jO(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cT(u,"back",w,w,w,w)
else{x=A.a_(A.d1(v.document).baseURI)
A.cT(A.d1(v.location),"replace",A.bB(x,0,w).a1("./").j(0)+"#/",w,w,w)}},
a92(d,e,f,g,h){return this.um(new B.b4M(this,e,d,f,h,g),y.H)},
a95(){return this.um(new B.b4N(this),y.D)},
a3d(){var x=null,w=this.a
if(w!=null)A.cT(w,"cancelRecording",x,x,x,x)},
alG(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.r5(d,"ms")
w=A.jO(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.JD(u,x,w,v.r5(d,"frames"),v.r5(d,"tokens"),v.or(d,"retried"),v.r5(d,"encMs"),v.r5(d,"decMs"),v.r5(d,"featMs"))},
ai4(d){var x={}
x.words=d
return x},
auM(d,e){return this.um(new B.b4P(this,d,e),y._)},
bl1(d,e){return this.um(new B.b4O(this,d,e),y._)},
KL(d,e){return this.biV(d,e)},
biV(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$KL=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.r6(),$async$KL)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.al(d).i("au<1,o>")
o=A.aa(new A.au(d,new B.b4J(),o),o.i("aY.E"))
x=11
return A.c(A.eD(A.d1(A.cT(r,"play",o,e,null,null)),y.y),$async$KL)
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
return A.i($async$KL,w)},
Mq(){var x=null,w=this.a
if(w!=null)A.cT(w,"stopPlayback",x,x,x,x)},
Jd(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.a_(A.cT(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bka(){var x,w,v=null
try{x=this.a
if(x!=null)A.cT(x,"resetDevice",v,v,v,v)}catch(w){}},
a6u(d){var x=this.a
if(x!=null)A.cT(x,"prefetch",d,null,null,null)}}
B.Vk.prototype={}
B.JB.prototype={
gn1(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.JD.prototype={
gSK(){var x=this,w=C.f.aw(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.JC.prototype={}
B.lD.prototype={
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
j(d){return"TutorError("+this.a+": "+this.b+")"},
$ibO:1}
B.nw.prototype={
R(){return"WordStatus."+this.b}}
B.Sr.prototype={}
B.mT.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Ie.prototype={
gMo(){var x,w=this,v=w.d
if(v===$){x=new B.aVV(w).$0()
w.d!==$&&A.an()
w.d=x
v=x}return v},
gJw(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a3F&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbh2(){return J.hd(this.gMo(),new B.aVU()).gL(0)},
gtn(){var x=this.a
return x.length!==0&&this.gbh2()===x.length&&this.gJw().length===0}}
B.F2.prototype={
R(){return"AyahStatus."+this.b}}
B.rp.prototype={}
B.aiU.prototype={
a65(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.re():x},
aZy(d){var x=this,w=B.b4S(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cga(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
apu(){var x=Date.now(),w=B.b4S(new A.aV(x,0,!1))
x=this.c
return x===w||x===B.cga(w)?this.d:0},
atP(d,e,f,g){var x=this,w=new A.aV(Date.now(),0,!1),v=x.a65(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.fg:D.p3,s=new B.rp(t,u,w.hd()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.aZy(w)
return s},
a5X(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cN[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.re():s).a===D.fg)++u}return u},
bfT(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cN[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.re():s).a===D.p3)++u}return u},
gasT(){var x=this.a,w=A.y(x).i("ce<2>")
return new A.aj(new A.ce(x,w),new B.b4T(),w.i("aj<Z.E>")).gL(0)},
gayq(){var x=this.a,w=A.y(x).i("bI<1>")
w=A.mo(new A.bI(x,w),new B.b4U(),w.i("Z.E"),y.S)
w=A.eP(w,A.y(w).i("Z.E"))
x=A.aa(w,A.y(w).c)
C.b.mr(x)
return x},
dE(){var x,w,v,u,t,s=this,r=y.N,q=A.B(r,y.L)
for(x=s.a,x=new A.eG(x,A.y(x).i("eG<1,2>")).ga0(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.aa(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
bbO(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b3d(x,300,A.y(x).c),x=new A.Ji(J.aD(x.a),x.b,A.y(x).i("Ji<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gJ()
s=C.j.aH(t,1000)
t=C.j.a2(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.re():q).a===D.fg?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.re()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.re():r).c.jt()],w,v))}return o},
bgt(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.L)(d),++u){t=d[u]
s=A.eB(t.h(0,"surah"))*1000+A.eB(t.h(0,"ayah"))
r=w.h(0,C.j.aH(s,1000)*1000+C.j.a2(s,1000))
if((r==null?$.re():r).c.jt()===t.h(0,"updated_at"))v.K(0,s)}},
bgB(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aD(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gJ()
if(!u.b(s))continue
r=A.aH(s.h(0,"surah"))
q=r==null?null:C.f.ca(r)
r=A.aH(s.h(0,"ayah"))
p=r==null?null:C.f.ca(r)
o=A.e_(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cN[q-1].a[1])
if(r)continue
n=B.cDu(s.h(0,"status"))
if(n===D.p2)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.aH(s.h(0,"perfect_count"))
l=l==null?null:C.f.ca(l)
v.p(0,r,new B.rp(n,C.j.d1(l==null?0:l,0,100),o.hd()))
w.K(0,r)
t=!0}return t}}
B.Vi.prototype={
IX(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Vi(w,v,u,t,f==null?x.e:f)},
ba2(d){var x=null
return this.IX(x,x,d,x,x)},
ap_(d){var x=null
return this.IX(x,d,x,x,x)},
ba6(d){var x=null
return this.IX(x,x,x,x,d)},
b9p(d){var x=null
return this.IX(d,x,x,x,x)},
ba3(d){var x=null
return this.IX(x,x,x,d,x)},
dE(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.He.prototype={
R(){return"ModelState."+this.b}}
B.Vj.prototype={
vC(){var x=this.Q
return x==null?this.Q=new B.b4V(this).$0():x},
qJ(d){return this.awE(d)},
awE(d){var x=0,w=A.j(y.H),v=this
var $async$qJ=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a3()
x=2
return A.c(A.iy("mt.tutor.settings",C.aq.is(d.dE(),null)),$async$qJ)
case 2:return A.h(null,w)}})
return A.i($async$qJ,w)},
zI(){var x=0,w=A.j(y.H),v=this,u
var $async$zI=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a3()
x=2
return A.c(A.iy("mt.tutor.progress",C.aq.is(v.c.dE(),null)),$async$zI)
case 2:u=v.as
if(u!=null)u.az()
v.as=A.cO(C.x,v.gaDs())
return A.h(null,w)}})
return A.i($async$zI,w)},
M8(d,e,f){return this.axq(d,e,f)},
axq(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$M8=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.b_(d,e,f)
x=2
return A.c(A.iy("mt.tutor.last",C.aq.is(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$M8)
case 2:return A.h(null,w)}})
return A.i($async$M8,w)},
D7(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$D7=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.UC||n===D.jS){x=1
break}s.f=D.UC
s.y=null
s.a3()
u=4
n=A.lE().geP().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lE().geP().h(0,"tutor_threads")
p=A.dR(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bgb(new B.b4W(s),n,p),$async$D7)
case 7:s.x=e
s.f=D.jS
n=A.lE().geP().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.ra().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a8(m)
if(n instanceof B.lD){q=n
s.f=D.aRt
s.y=q
n=A.lE().geP().h(0,"debug")
if(n==="1")A.ra().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a3()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$D7,w)},
wz(){var x=0,w=A.j(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wz=A.e(function(a0,a1){if(a0===1){t.push(a1)
x=u}for(;;)switch(x){case 0:if(r.at){x=1
break}q=null
try{k=$.C().b
k===$&&A.b()
k=k.ga5().e.a
q=(k==null?null:k.r)!=null}catch(d){x=1
break}if(!q){x=1
break}r.at=!0
u=4
k=$.C().b
k===$&&A.b()
p=k
x=7
return A.c(p.aS("quran_tutor_progress").da("surah, ayah, status, perfect_count, updated_at"),$async$wz)
case 7:o=a1
n=r.c.bgB(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bbO()
if(J.aP(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.n0(h.x,k,k))
x=11
return A.c(f.bky("quran_tutor_save",!1,g,i),$async$wz)
case 11:r.c.bgt(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.iy("mt.tutor.progress",C.aq.is(r.c.dE(),null)),$async$wz)
case 12:if(n)r.a3()
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
L1(d){return this.bkc(d)},
bkc(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$L1=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c71(t.c.dE()).dE()
y.f.a(p.h(0,"rows")).eh(0,new B.b4X(d))
t.c=B.c71(p)
x=2
return A.c(t.zI(),$async$L1)
case 2:v=4
s=$.C().b
s===$&&A.b()
r=s.ga5().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.aA("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$L1)
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
return A.i($async$L1,w)}}
B.wP.prototype={
O(){var x=$.MF()
return new B.a_K(x,new A.ai(C.O,$.W()))}}
B.a_K.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goC())
w=y.a
x.vC().bG(new B.bIm(v),w)
H.aUn().bG(new B.bIn(v),w).fv(new B.bIo())
A.Pu(H.c6n(),y.y)},
xI(){if(this.c!=null)this.k(new B.bI8())},
m(){var x,w=this
w.d.T(w.goC())
x=w.e
x.q$=$.W()
x.M$=0
w.a_()},
PN(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$PN=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qJ(s.b.ba2(!0)),$async$PN)
case 3:t=s.a
t.biP()
if(t.a8R()){t.aqi()
x=1
break}s.D7()
case 1:return A.h(v,w)}})
return A.i($async$PN,w)},
xJ(d,e,f){return this.aXr(d,e,f)},
b59(d){return this.xJ(d,null,null)},
aXr(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$xJ=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.Z(A.aO(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.V(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cHh(s,d),$async$xJ)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.M8(d,t.a,t.b),$async$xJ)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aB(A.aA(new B.bIe(u,d,t),null,r),r),$async$xJ)
case 8:if(u.c!=null)u.k(new B.bIf())
case 1:return A.h(v,w)}})
return A.i($async$xJ,w)},
u(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.garL()&&!A.O(d,!1).v6())u.push(A.bR(x,x,x,x,C.yd,x,x,t.gbfU(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bR(x,x,x,x,D.ata,x,x,new B.bIi(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bR(x,x,x,x,C.iw,x,x,new B.bIj(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aFA
else w=t?this.aSi():this.aSU()
return L.xz(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aSU(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a3e
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b56,C.a4],x)
for(t=0;t<4;++t){s=D.aHF[t]
u.push(new A.E(C.bs,A.A(A.a([A.b0(s.a,C.am,p,18),C.L,new A.bX(1,C.ad,A.d(s.b,p,p,p,p,G.a0Q,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bvQ,C.J,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bp(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aK,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bp(C.f.al(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.J,A.d(q,p,p,p,p,A.bJ(p,p,r?D.dW:C.cG,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.J,D.buR],x))
x=A.a([new E.dx(u,C.a3,C.aM,p,!0,p),new E.dx(A.I(s,C.q,C.d,C.e,0,C.l),C.a3,C.aM,p,!1,p),D.bDZ,C.J],x)
if(v!=null)x.push(new E.dx(A.d(v,p,p,p,p,D.bg0,p,p,p),C.a3,C.aM,p,!1,p))
else x.push(A.fn(D.aq6,D.blK,this.gaXJ(),A.ey(C.u,C.ac,D.b85,p,p,p,p)))
x.push(C.a5)
x.push(D.a3a)
return x},
aSi(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.P(r.a.a),p=q.length===0,o=p?C.rl:H.ckX(q),n=t.z,m=A.R(v.akY(C.dw,E.bp(s.gasT())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bp(s.apu()),k=s.c,j=Date.now()
k=k===B.b4S(new A.aV(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Hf(t,!1,u),A.A(A.a([m,C.L,A.R(v.akY(C.l4,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.t],j)
if(n!=null){t=H.kl(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bp(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bp(m)+"\u2013"+E.bp(l)
k.push(new E.dx(A.A(A.a([D.ash,C.Y,A.R(A.I(A.a([D.bhY,A.d(t+" \u2014 "+m,u,u,u,u,C.bt,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nv],j),C.h,C.d,C.e,0,u,u),C.a3,C.aM,new B.bIb(v,n),!0,u))}t=C.i.ae(0.08)
k.push(A.aI(u,C.y,!1,u,!0,C.m,u,A.aM(),r,u,u,u,u,u,2,A.cG(u,new A.ci(4,A.v(14),C.K),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.u6,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qH,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bIc(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.cR,!0,C.v,u,C.E,u,u,u,u))
k.push(C.t)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.br2)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.R3(o[x]))
C.b.A(k,t)}else{t=A.a([D.aUA,D.aVg,v.R3(1)],j)
for(w=114;w>=78;--w)t.push(v.R3(w))
t.push(C.J)
r=v.f
p=A.b0(r?C.xW:C.l3,C.am,u,u)
t.push(A.h1(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.f9,u,u,u),new B.bId(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.R3(w))
C.b.A(k,t)}k.push(C.a4)
k.push(D.BV)
return k},
akY(d,e,f){var x=null,w=y.p
return new E.dx(A.A(A.a([A.b0(d,C.u,x,x),C.L,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bt,x,x,x),A.d(f,1,C.N,x,x,C.a1u,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a3,C.I,x,!1,x)},
R3(d){var x,w=null,v=this.d.c,u=I.cN[d-1].a[1],t=v.a5X(d),s=t/u,r=y.p,q=A.aq(A.dz(C.P,A.a([A.c4O(C.eR,G.cL,w,w,w,w,w,3,s,w),A.d(E.bp(d),w,w,w,w,Q.a1R,w,w,w)],r),C.m,C.bj,w),36,36),p=A.d(H.kl(d),w,w,w,w,D.baS,w,w,w)
if(t===0)x=E.bp(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bp(t)+" \u0645\u0646 "+E.bp(u)
r=A.a([q,C.cD,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bJ(w,w,t===u?G.cL:C.cG,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bp(C.f.al(s*100))+"\u066a",w,w,w,w,D.a1l,w,w,w))
r.push(D.aqf)
return new E.dx(A.A(r,C.h,C.d,C.e,0,w,w),C.q_,C.cY,new B.bIg(this,d),!1,w)}}
B.Hf.prototype={
u(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aUl
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.My(x),r,r,r,r,D.B4,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.D2(w,"model load",r))
x.push(C.J)
x.push(new A.zM(C.a4_,!1,q.gbga(),r,r,r,r,C.k,r,!1,r,!0,r,C.uj,r))
return new E.dx(A.I(x,C.q,C.d,C.e,0,C.l),C.a3,C.aM,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bp(C.f.al(u/1e6))+" \u0645\u0646 "+E.bp(C.f.al(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.oz,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fd(x,A.q4(C.eR,C.u,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.J,D.bmz],w))
return new E.dx(A.I(x,C.q,C.d,C.e,0,C.l),C.a3,C.aM,r,!1,r)}}}
B.XA.prototype={
u(d){var x=null,w=D.dW.ae(0.1),v=A.v(14),u=A.aG(D.dW.ae(0.4),1)
return A.D(x,A.A(A.a([D.arW,C.L,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.Bb,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.F(w,x,u,v,x,x,x,C.n),x,x,C.aM,C.ae,x,x,x)}}
B.E1.prototype={
R(){return"_Phase."+this.b}}
B.D1.prototype={
O(){return new B.a2b($.MF(),D.mh)}}
B.a2b.prototype={
gjb(){var x=this.e
return x===$?this.e=this.a.d:x},
gBG(){var x,w=this.a,v=w.f
w=w.c
x=this.gjb()
return H.Mw(w,x,v.xT(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.ac(w.goC())
x.vC()
x.a.a6u(B.azs(w.a.c,w.gjb()))},
xI(){if(this.c!=null)this.k(new B.bVE())},
m(){var x,w=this,v=w.d
v.T(w.goC())
x=w.Q
if(x!=null)x.az()
v=v.a
v.Mq()
v.a3d()
w.a_()},
ZV(d){var x,w,v=this
if(v.f===D.uS)v.d.a.a3d()
x=v.d.a
x.Mq()
w=v.Q
if(w!=null)w.az()
v.k(new B.bVU(v,d))
x.a6u(B.azs(v.a.c,d))
w=v.a
if(d<w.e)x.a6u(B.azs(w.c,d+1))},
Rl(d){return this.aTL(d)},
aTL(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$Rl=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.uR){u.d.a.Mq()
u.k(new B.bVY(u))
x=1
break}t=u.r!=null?D.j9:D.mh
u.k(new B.bVZ(u))
s=u.d
r=A.a([B.azs(u.a.c,u.gjb())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.KL(r,q),$async$Rl)
case 3:p=f
if(u.c==null||u.f!==D.uR){x=1
break}u.k(new B.bW_(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$Rl,w)},
Qb(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Qb=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jS){x=1
break}p=l.a
p.Mq()
r=B.EK(s.gBG()).length
s.k(new B.bW1(s))
o=s.Q
if(o!=null)o.az()
s.Q=A.hD(C.eV,new B.bW2(s))
u=4
o=B.c8O(r)
n=A.dl(0,0,0,350*r,0,0)
x=7
return A.c(p.a92(l.b.c,o,n,new B.bW3(s),new B.bW4(s)),$async$Qb)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lD){q=l
l=s.Q
if(l!=null)l.az()
if(s.c!=null)s.k(new B.bW5(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Qb,w)},
Bz(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$Bz=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.uS){x=1
break}m=s.Q
if(m!=null)m.az()
s.k(new B.bW7(s))
s.Q=A.hD(C.iq,new B.bW8(s))
l=new A.Cu()
$.EN()
l.om()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a95(),$async$Bz)
case 7:q=e
if(q.b<0.8){s.b58("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.auM(q,B.EK(s.gBG()).length),$async$Bz)
case 8:p=e
s.ch=A.dl(0,0,r.ga4x(),0,0,0)
k=A.lE().geP().h(0,"debug")
if(k==="1"){o=B.clc(m.Jd())
A.ra().$1("[tutor] "+s.a.c+":"+s.gjb()+" audio="+C.f.aw(q.b,1)+"s infer="+p.b+"ms total="+r.gCt()+"ms "+p.gSK()+" text="+p.a)
A.ra().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.aw(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aw(p.b/1000,2)+" \u062b\n"+p.gSK()+"\n"+A.n(o)+"\n"+p.a}s.afa(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lD){n=m
m=A.lE().geP().h(0,"debug")
if(m==="1")A.ra().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.Jd())
s.a22(B.My(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Bz,w)},
a22(d,e){var x=this,w=x.Q
if(w!=null)w.az()
if(x.c==null)return
x.k(new B.bVT(x,d,e))},
b58(d){return this.a22(d,null)},
afa(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.az()
if(s.c==null)return
x=B.cjg(s.gBG(),d)
r.a=null
if(C.c.P(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjb()
t=x.gtn()
r.a=w.atP(v,u,q.b.a,t)
q.zI()}s.k(new B.bVV(r,s,x))},
NN(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$NN=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jS){x=1
break}s.k(new B.bVM(s))
l=s.Q
if(l!=null)l.az()
s.Q=A.hD(C.iq,new B.bVN(s))
k=new A.Cu()
$.EN()
k.om()
r=k
u=4
l=g.a
x=7
return A.c(l.bl1(B.azs(s.a.c,s.gjb()),B.EK(s.gBG()).length),$async$NN)
case 7:q=e
p=B.clc(l.Jd())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.aw(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aw(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.aw(r.gCt()/1000,2)+" \u062b)\n"+q.gSK()+"\n"+A.n(p)+"\n"+q.a
A.ra().$1("[tutor-debug] "+s.a.c+":"+s.gjb()+" audio="+C.f.aw(q.c,1)+"s infer="+q.b+"ms total="+r.gCt()+"ms "+q.gSK()+" text="+q.a)
A.ra().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dl(0,0,r.ga4x(),0,0,0)
s.afa(q.a)
n=s.r
if(n!=null){l=n.gtn()
j=n.b
i=A.al(j).i("aj<1>")
j=A.aa(new A.aj(j,new B.bVO(),i),i.i("Z.E"))
A.ra().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.k(new B.bVP(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lD){m=l
A.ra().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.Jd())
s.a22(B.My(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$NN,w)},
ga0Q(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.re():v).a!==D.fg)return!1}return!0},
u(d){var x,w=this,v=null,u=w.d,t=u.c.a65(w.a.c,w.gjb()),s=u.b,r=s.d&&!w.x&&w.f!==D.j9,q=H.kl(w.a.c),p=y.p,o=A.a([A.bR(v,v,v,v,C.iw,v,v,new B.bWd(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aK9(),m=A.d("\u0622\u064a\u0629 "+E.bp(w.gjb()),v,v,v,v,C.m_,v,v,v),l=E.bp(w.gjb()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.b1,A.d("("+l+" \u0645\u0646 "+E.bp(k.e-k.d+1)+")",v,v,v,v,F.aK,v,v,v),C.bz,w.aYo(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.t],p)
if(r)s.push(w.aSd())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.uS&&l!==D.oU}else l=!1
if(l)s.push(w.aHQ(m))
else s.push(A.d(w.gBG()+" \ufd3f"+E.bp(w.gjb())+"\ufd3e",v,v,v,v,D.kf,C.a0,C.bh,v))}s=A.a([new B.Hf(u,!0,v),n,C.B,new E.dx(A.I(s,C.ag,C.d,C.e,0,C.l),D.aj1,C.aM,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.j9)s.push(w.b6D(n))
if(w.r!=null&&w.f===D.j9&&w.ch!=null){x=C.f.al(C.j.aH(w.ch.a,1000)/100)
s.push(new A.E(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bp(C.j.aH(x,10))+"\u066b"+E.bp(C.j.a2(x,10)))+" \u062b",v,v,v,v,F.aK,C.a0,v,v),v))}n=w.as
if(n!=null)s.push(new A.E(C.aM,A.d(n,v,v,v,v,D.B4,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.D2(n,"check "+w.a.c+":"+w.gjb(),v))}s.push(w.aIn())
s.push(C.a4)
s.push(A.iq(C.u,C.I,v,new B.bWe(w),D.bjC,D.boQ,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga0Q()
s.push(new E.dx(A.A(A.a([D.aoJ,C.Y,A.R(A.I(A.a([D.bqr,A.d(w.ga0Q()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aK,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nv],p),C.h,C.d,C.e,0,v,v),C.a3,C.aM,new B.bWf(w,d),n,v))}n=A.lE().geP().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dy(D.aq5,D.bof,u.f===D.jS&&w.f!==D.oU?w.gaJ6():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.E(C.ir,A.xa(n,F.aK,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn1()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aK,v,v,v))}p.push(A.bh(D.bpB,v,v,v,new B.bWg(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.BV)
return L.xz(o,s,q)},
aK9(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.aq(A.fB(new B.bVR(this),w,null,C.af,new B.bVS()),36,null)},
aYo(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fg)return D.b5i
x=d.b
w=E.bp(x)
v=E.bp(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.bV:C.Hb
u.push(new A.E(D.ajI,A.b0(r,s?G.cL:C.eS,q,16),q))}return A.aiN(A.A(u,C.h,C.d,C.M,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aSd(){var x=null
return A.bv(!1,A.v(12),!0,A.D(x,D.af6,C.k,x,x,new A.F(C.pu,x,x,A.v(12),x,x,x,C.n),x,x,x,D.aiA,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bVX(this),x,x,x,x,x,x,x)},
aHQ(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gMo(),w)
A:{if(D.j2===v){u=D.kf.ct(G.cL)
break A}if(D.uA===v){u=D.kf.a3R(D.dW,C.i1,D.dW)
break A}if(D.uB===v){u=D.kf.a3R(D.eQ,C.i1,D.eQ)
break A}u=D.kf.a3R(C.eS,C.kb,C.cg)
break A}t=x[w]
r.push(new A.f3(t.a,s,s,C.by,s,s,s,s,s,s,u))
r.push(P.AW)}x=E.bp(this.gjb())
r.push(A.eo(s,s,s,s,s,s,s,s,s,D.kf.ct(C.am),"\ufd3f"+x+"\ufd3e"))
return A.Jj(A.eo(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.a0,C.bh)},
b6D(d){var x,w,v,u,t,s,r=this.w
if(C.c.P(d.c).length===0)return D.bDl
if(d.gtn()){x=r==null
if((x?null:r.a)===D.fg&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fg?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bp(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.Dk(G.cL,C.bV,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMo()
w=J.dE(x)
v=w.iE(x,new B.bW9()).gL(0)
u=w.iE(x,new B.bWa()).gL(0)
t=w.iE(x,new B.bWb()).gL(0)
x=A.a([],y.s)
if(u>0)x.push(E.bp(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bp(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bp(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJw().length!==0)x.push(E.bp(d.gJw().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eQ:D.dW
x=C.b.aE(x," \u2022 ")
s=d.gJw().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aE(d.gJw(),"\u060c "):""
return new B.Dk(w,C.nl,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aIn(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jS,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aH(new A.aV(f,0,!1).dK(w).a,1e6)}v=C.j.aH(B.c8O(B.EK(j.gBG()).length).a,1e6)
f=j.gb3J()
w=96+26*j.y
u=D.eQ.ae(0.25)
w=A.iL(i,A.a4Z(C.P,A.D(i,D.aqi,C.k,i,i,D.a71,i,84,i,i,i,i,84),i,C.aT,new A.F(u,i,i,i,i,i,i,C.c_),C.ES,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cO)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c7J(x)+" / "+B.c7J(v),i,i,i,i,K.oy,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aK,i,i,i),A.bh(D.buQ,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.ey((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bp(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bp(t)+" \u062b)"
return new A.E(C.pW,A.I(A.a([C.vF,C.a4,D.bn1,A.d(h,i,i,i,i,F.aK,C.a0,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.uR
r=j.r
f=r==null
w=!f
q=w&&r.gtn()
u=A.b0(s?C.nm:K.Hp,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.ey(i,i,D.b82,i,i,i,i)
u=A.R(new A.zM(C.a4_,!0,new B.bVF(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Yb(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.J_[n]
p.push(new A.ek(m,i,A.d("\xd7"+E.bp(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.L,A.oN(new B.bVG(j),p,A.de([h.b.b],o),!1,A.kp(i,i,i,new A.bd(new B.bVH(),l),i,i,i,i,new A.bd(new B.bVI(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cJ),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb_o():i
u=A.b0(f?D.qv:C.nl,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cE,i,i,i)
p=q?C.il:C.u
h=A.a([o,C.t,A.fn(u,f,h,A.ey(p,q?C.i:C.ac,D.tI,i,i,i,i))],k)
if(w&&j.gjb()<j.a.e)C.b.A(h,A.a([C.B,q?A.fn(D.aty,D.btB,new B.bVJ(j),A.ey(G.cL,C.ac,D.tI,i,i,i,i)):A.bh(D.bk1,i,i,i,new B.bVK(j),i,i)],k))
if(w){f=j.gjb()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.E(C.jt,A.d(j.ga0Q()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,K.ud,C.a0,i,i),i))
return A.I(h,C.ag,C.d,C.e,0,C.l)}}}
B.Dk.prototype={
u(d){var x=this,w=null,v=x.c,u=v.ae(0.12),t=A.v(14),s=A.aG(v.ae(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b0(x.d,v,w,w),C.L,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bJ(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.V,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bM,A.d(x.f,w,w,w,w,C.Bb,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.F(u,w,s,t,w,w,w,C.n),w,w,C.aM,C.ae,w,w,w)}}
B.D0.prototype={
O(){var x=y.S
return new B.a2a($.MF(),A.B(x,y.B),A.aU(x),A.B(x,y.N),A.eh(null,y.H))}}
B.a2a.prototype={
W(){this.Y()
this.d.ac(this.goC())},
xI(){if(this.c!=null)this.k(new B.bVn())},
m(){var x,w=this,v=w.d
v.T(w.goC())
x=w.y
if(x!=null)x.az()
v.a.a3d()
w.a_()},
I1(d){return this.b3v(d)},
b3v(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$I1=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.k(new B.bVw(t,d))
r=t.y
if(r!=null)r.az()
t.y=A.hD(C.eV,new B.bVx(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c8O(B.EK(H.Mw(q,d,p.xT(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dl(0,0,0,350*B.EK(H.Mw(p,d,o.xT(p,d)).b).length,0,0)
x=6
return A.c(r.a.a92(r.b.c,q,p,new B.bVy(t,d),new B.bVz(t)),$async$I1)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lD){s=r
r=t.y
if(r!=null)r.az()
if(t.c!=null)t.k(new B.bVA(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$I1,w)},
Fx(d,e){return this.aLi(d,e)},
aLi(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$Fx=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.az()
s.k(new B.bVr(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a95()
if(e&&n!=null)s.I1(n)
q=null
u=4
x=7
return A.c(r,$async$Fx)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lD){p=o
s.k(new B.bVs(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bG(new B.bVt(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Fx,w)},
gaVU(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b0e(){this.k(new B.bVu(this))},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jS,o=s.e,n=s.gaVU(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("ce<2>")
x=new A.aj(new A.ce(m,l),new B.bVB(),l.i("aj<Z.E>")).gL(0)
l=H.kl(s.a.c)
m=y.p
q=A.a([new B.Hf(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bp(s.a.d)+" \u0644\u062d\u062f "+E.bp(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aK,r,r,r),C.t],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b5a(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.B4,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.D2(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bp(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aH(new A.aV(v,0,!1).dK(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c7J(v),r,r,r,r,K.oy,C.a0,r,r)
j=A.fd(A.v(6),A.q4(C.eR,D.eQ,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b0(u?O.Hi:C.nm,r,r,r)
C.b.A(q,A.a([v,C.J,j,C.t,A.fn(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cE,r,r,r),new B.bVC(s,o),A.ey(C.u,C.ac,D.tI,r,r,r,r))],m))}else if(n!=null){j=p?new B.bVD(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bp(n)
q.push(A.fn(D.arq,A.d(v,r,r,r,r,C.cE,r,r,r),j,A.ey(C.u,C.ac,D.tI,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aUK)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cL:D.dW
v=k?C.nc:C.nl
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bp(x)
u=s.a
u=k+" \u0645\u0646 "+E.bp(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.Dk(j,v,k,u,r),A.dy(D.atl,D.bue,s.gb0d(),r)],m))}q.push(C.t)
q.push(D.BV)
return L.xz(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b5a(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.aqN
else if(l.r.n(0,d))x=N.tL
else if(i!=null)x=D.ar3
else if(j!=null){w=j.gtn()?C.bV:D.ang
x=A.b0(w,j.gtn()?G.cL:D.dW,k,k)}else x=D.apn
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bp(d),k,k,k,k,D.bfd,k,k,k),C.bz,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.a1w,k,k,k))
if(j!=null&&!j.gtn()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMo()
o=J.be(p)
n=o.h(p,r)
A:{if(D.j2===n){m=G.cL
break A}if(D.uA===n){m=D.dW
break A}if(D.uB===n){m=D.eQ
break A}m=C.eS
break A}m=D.kf.baI(m,o.h(p,r)===D.uC?C.kb:k,22)
C.b.A(t,A.a([new A.f3(q.a,k,k,C.by,k,k,k,k,k,k,m),P.AW],u))}w=A.a([C.ah,A.Jj(A.eo(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.a0,C.bh)],w)
if(C.c.P(j.c).length===0)w.push(D.bpQ)
C.b.A(v,w)}return new E.dx(A.I(v,C.ag,C.d,C.e,0,C.l),C.bJ,C.cY,k,!1,k)}}
B.D_.prototype={
O(){return new B.a29($.MF())}}
B.a29.prototype={
W(){this.Y()
var x=this.d
x.ac(this.goC())
x.vC()},
xI(){if(this.c!=null)this.k(new B.bVe())},
m(){this.d.T(this.goC())
this.a_()},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gayq(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kZ(o,0,new B.bVl(q))
v=C.b.kZ(o,0,new B.bVm())
o=y.p
o=A.a([A.A(A.a([A.R(s.XN(E.bp(q.gasT()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.L,A.R(s.XN(E.bp(q.apu()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.L,A.R(s.XN(E.bp(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.t,new E.dx(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bp(C.f.al(w*100/v))+"\u066a",r,r,r,r,C.bt,r,r,r),C.J,A.fd(A.v(6),A.q4(C.eR,G.cL,8,w/v,r),C.aC),C.ah,A.d(E.bp(w)+" \u0645\u0646 "+E.bp(v)+" \u0622\u064a\u0629",r,r,r,r,F.aK,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a3,C.aM,r,!1,r)],o)
if(p.length===0)o.push(D.aUY)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b5c(p[t]))
o.push(C.B)
u=$.C().b
u===$&&A.b()
u=u.ga5().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aK,r,r,r))
return L.xz(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
XN(d,e){var x=null
return new E.dx(A.I(A.a([A.d(d,x,x,x,x,D.beW,x,x,x),A.d(e,x,x,x,x,C.a22,C.a0,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a3,C.I,x,!1,x)},
b5c(d){var x=null,w=this.d.c,v=I.cN[d-1].a[1],u=w.a5X(d),t=w.bfT(d),s=y.p,r=A.A(A.a([A.R(A.d(H.kl(d),x,x,x,x,C.bt,x,x,x),1),A.d(E.bp(C.f.al(u*100/v))+"\u066a",x,x,x,x,D.bg1,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fd(A.v(6),A.q4(C.eR,G.cL,7,u/v,x),C.aC),p=E.bp(u),o=E.bp(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bp(t):""
return new E.dx(A.I(A.a([r,C.J,q,C.ah,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aK,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a3,C.aM,new B.bVk(this,d),!1,x)},
NQ(d){return this.aJs(d)},
aJs(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$NQ=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cN[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e7(C.cK,new B.bVj(v,d,u),t,!0,null,null,!1,y.H),$async$NQ)
case 2:return A.h(null,w)}})
return A.i($async$NQ,w)}}
B.aiS.prototype={
Rk(d,e){var x=null,w=A.no(x,x,x,x,x,x,x,x,x,x,x,D.b7C,C.I,x,x,x,x,C.jR,x,x)
return A.bh(A.d(d,x,x,x,x,C.lZ,x,x,x),x,x,x,new B.b4E(e),x,w)},
u(d){var x=this,w=y.p
return new E.dx(A.I(A.a([D.btn,C.J,D.buP,A.d5(C.ax,A.a([x.Rk("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Rk("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aF,0,12),D.bjd,x.Rk("tanzil.net","https://tanzil.net"),D.bwq,x.Rk("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a3,C.aM,null,!1,null)}}
B.D2.prototype={
O(){return new B.a2c()}}
B.a2c.prototype={
galM(){var x=this.a
return B.cIB(x.c,x.d,$.c9r().Jd())},
Rm(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$Rm=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.k(new B.bWh(s))
v=3
r=A.c2Y()
n=s.galM()
m=y.N
q=A.B(m,m)
J.dX(q,"app","mogtama3y")
J.dX(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dX(q,"ua",m)}x=6
return A.c(A.a9s(n,null,C.FW,q),$async$Rm)
case 6:if(s.c!=null)s.k(new B.bWi(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cn?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.k(new B.bWj(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.k(new B.bWk(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Rm,w)},
u(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bv(!1,t,!0,new A.E(C.pX,A.A(A.a([A.b0(u.d?C.xW:C.l3,C.cg,t,18),C.bG,D.bvB],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bWm(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.D(t,A.xa(u.galM(),D.bbe,t,C.A),C.k,t,t,new A.F(C.pu,t,t,x,t,t,t,C.n),t,t,D.aiD,C.e9,t,t,1/0))}if(u.f)s.push(D.bjv)
else{x=A.no(t,t,t,t,t,t,t,t,t,t,t,C.a_Q,C.I,t,t,t,t,C.jR,t,t)
w=u.e
v=w?t:u.gb5b()
s.push(A.h1(w?C.a04:D.asJ,D.bsm,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,D.a1w,t,t,t))
return new A.E(C.aM,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["ak<~>()","~()","N(nw)","ak<JD>()","ak<JB>()","ak<JC>()","a7<nw>()","N(rp)","bD(oE)","D1(t)","D_(t)","N(mT)","D0(t)","N(Ie)"])
B.b4F.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.a_(A.d1(b.G.document).baseURI)
q=A.bB(r,0,null).a1("quran_tutor/tutor.js?v=3").j(0)
x=7
return A.c(A.eD(import(q),y.m),$async$$0)
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
m=B.cxU("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:306}
B.b4I.prototype={
$1(d){var x=null
return A.bYT(A.cT(d,"persist",x,x,x,x))},
$S:1106}
B.b4H.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.r6(),$async$$0)
case 4:x=3
return A.c(n.eD(m.d1(l.cT(e,"loadModel",A.bZB(new B.b4G(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.u(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.u(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.r5(p,"ms")
r=q.or(p,"cached")
A.u(p.backend)
v=new B.JB(o,t,s,r,q.r5(p,"threads"),q.or(p,"isolated"),q.r5(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b4G.prototype={
$2(d,e){this.a.$2(C.f.al(d),C.f.al(e))},
$S:1107}
B.b4M.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.r6(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aH(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aH(v.d.a,1000)
u.onLevel=A.fU(new B.b4K(v.e))
u.onAutoStop=A.fU(new B.b4L(v.f))
x=5
return A.c(A.eD(A.d1(A.cT(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b4K.prototype={
$1(d){return this.a.$1(d)},
$S:63}
B.b4L.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b4N.prototype={
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
return A.c(t.r6(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eD(p.d1(o.cT(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.JC(r,A.dW(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b4P.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.r6(),$async$$0)
case 4:x=3
return A.c(q.eD(p.d1(o.cT(e,"transcribe",t.audio,t.rate,s.ai4(u.c),null)),y.m),$async$$0)
case 3:v=r.alG(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b4O.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.r6(),$async$$0)
case 4:x=3
return A.c(r.eD(q.d1(p.cT(e,"transcribeUrl",u.b,t.ai4(u.c),null,null)),y.m),$async$$0)
case 3:v=s.alG(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b4J.prototype={
$1(d){return d},
$S:39}
B.aVV.prototype={
$0(){var x,w,v,u,t=this.a,s=A.cl(t.a.length,D.uC,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aVU.prototype={
$1(d){return d===D.j2},
$S:z+2}
B.bZk.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c3U(e[x],d[x])<0.75)return!1
return!0},
$S:1108}
B.c0q.prototype={
$1(d){return d.length!==0},
$S:11}
B.b4T.prototype={
$1(d){return d.a===D.fg},
$S:z+7}
B.b4U.prototype={
$1(d){return C.j.aH(d,1000)},
$S:58}
B.b4R.prototype={
$1(d){return C.f.ca(d)},
$S:1109}
B.b4V.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iW("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.aq.fz(r,null))
j=A.aH(k.h(0,"n"))
j=j==null?null:C.f.ca(j)
j=C.j.d1(j==null?2:j,1,5)
i=C.b.n(D.J_,k.h(0,"r"))?A.eB(k.h(0,"r")):1
h=A.ef(k.h(0,"auto"))
g=A.ef(k.h(0,"hide"))
k=A.ef(k.h(0,"in"))
s.a.b=new B.Vi(j,i,h!==!1,g===!0,k===!0)}u=2
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
return A.c(A.iW("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.c71(y.P.a(C.aq.fz(q,null)))
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
return A.c(A.iW("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.aq.fz(p,null))
n=C.f.ca(A.cR(J.av(o,"s")))
m=C.f.ca(A.cR(J.av(o,"f")))
l=C.f.ca(A.cR(J.av(o,"t")))
if(B.clh(n,m)&&B.clh(n,l)&&m<=l)s.a.z=new A.b_(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a8R()){k.a.aqi()
x=1
break}a1=k
x=18
return A.c(k.a.MJ(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a3()
if(k.b.e)k.D7()
k.wz()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:114}
B.b4W.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a3()},
$S:1110}
B.b4X.prototype={
$2(d,e){return C.j.aH(A.eC(A.n(d),null,null),1000)===this.a},
$S:1111}
B.bIm.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.En(),$async$$1)
case 2:t=f
if(u.c!=null)u.k(new B.bIl(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1112}
B.bIl.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bIn.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bIk(x,d))},
$S:z+8}
B.bIk.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bIo.prototype={
$1(d){},
$S:24}
B.bI8.prototype={
$0(){},
$S:0}
B.bIe.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.D1(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bIf.prototype={
$0(){},
$S:0}
B.bIi.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aB(A.aA(new B.bIh(),null,x),x)},
$S:0}
B.bIh.prototype={
$1(d){return D.bxN},
$S:z+10}
B.bIj.prototype={
$0(){return B.cl3(this.a)},
$S:0}
B.bIb.prototype={
$0(){var x=this.b
return this.a.xJ(x.a,x.b,x.c)},
$S:0}
B.bIc.prototype={
$1(d){return this.a.k(new B.bIa())},
$S:5}
B.bIa.prototype={
$0(){},
$S:0}
B.bId.prototype={
$0(){var x=this.a
return x.k(new B.bI9(x))},
$S:0}
B.bI9.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bIg.prototype={
$0(){return this.a.b59(this.b)},
$S:0}
B.c2K.prototype={
$1(d){return new A.jH(new B.c2H(this.a,this.b,this.c),null)},
$S:57}
B.c2H.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c2J(u,e),s=this.a,r=new B.c2I(s,e),q=A.d(H.kl(this.c),v,v,v,v,C.ou,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bp(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aK,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bp(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bp(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.ah,p,C.t,A.d5(C.ax,n,C.aF,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c2C(s)),C.a00,t.$3("\u0644\u062d\u062f",s.c,new B.c2D(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aUP)
u.push(C.a5)
u.push(A.dG(D.bmu,new B.c2E(s,d),A.ey(C.u,C.ac,D.b8_,v,v,v,v)))
return A.cu(!0,new A.E(C.Fn,A.I(u,C.ag,C.d,C.M,0,C.l),v),C.I,!0)},
$S:387}
B.c2J.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.i5,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c9(v,A.d("\u0622\u064a\u0629 "+E.bp(v),u,u,u,u,u,u,u,u),C.au,u,w))
return A.R(A.I(A.a([t,R.FV(C.cK,!0,s,320,new B.c2G(this.b,f),D.bgj,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1114}
B.c2G.prototype={
$1(d){return d==null?null:this.a.$1(new B.c2F(this.b,d))},
$S:51}
B.c2F.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c2I.prototype={
$3(d,e,f){var x=null
return A.c4u(x,A.d(d,x,x,x,x,x,x,x,x),new B.c2B(this.a,this.b,e,f))},
$S:1115}
B.c2B.prototype={
$0(){var x=this
return x.b.$1(new B.c2A(x.a,x.c,x.d))},
$S:0}
B.c2A.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c2C.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c2D.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c2E.prototype={
$0(){var x=this.a
return A.O(this.b,!1).aj(new A.V(x.b,x.c))},
$S:0}
B.bVE.prototype={
$0(){},
$S:0}
B.bVU.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mh
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bVY.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.j9:D.mh},
$S:0}
B.bVZ.prototype={
$0(){var x=this.a
x.f=D.uR
x.as=null},
$S:0}
B.bW_.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bW1.prototype={
$0(){var x=this.a
x.f=D.uS
x.as=null
x.y=0
x.z=new A.aV(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bW2.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bW0())},
$S:31}
B.bW0.prototype={
$0(){},
$S:0}
B.bW4.prototype={
$1(d){return this.a.y=d},
$S:63}
B.bW3.prototype={
$1(d){return this.a.Bz()},
$S:5}
B.bW5.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.j9:D.mh
x=this.b
w.as=B.My(x)
w.at=x},
$S:0}
B.bW7.prototype={
$0(){var x=this.a
x.f=D.oU
x.ay=Date.now()},
$S:0}
B.bW8.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bW6())},
$S:31}
B.bW6.prototype={
$0(){},
$S:0}
B.bVT.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.j9:D.mh
x.as=this.b
x.at=this.c},
$S:0}
B.bVV.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.j9
x.x=!1},
$S:0}
B.bVM.prototype={
$0(){var x=this.a
x.f=D.oU
x.ay=Date.now()
x.as=null},
$S:0}
B.bVN.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bVL())},
$S:31}
B.bVL.prototype={
$0(){},
$S:0}
B.bVO.prototype={
$1(d){return d.d!==D.j2},
$S:z+11}
B.bVP.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bWd.prototype={
$0(){return B.cl3(this.a)},
$S:0}
B.bWe.prototype={
$1(d){var x=this.a.d
return x.qJ(x.b.ap_(d))},
$S:3}
B.bWf.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aB(A.aA(new B.bWc(this.a),null,x),x)},
$S:0}
B.bWc.prototype={
$1(d){var x=this.a.a
return new B.D0(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bWg.prototype={
$0(){this.a.d.a.bka()
this.b.I(y.q).f.Z(D.b92)},
$S:0}
B.bVS.prototype={
$2(d,e){return C.b1},
$S:19}
B.bVR.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a65(s.c,r).a.a){case 2:s=G.cL
break
case 1:s=D.dW
break
case 0:s=C.il
break
default:s=u}x=A.v(18)
w=t.f===D.oU?u:new B.bVQ(t,r)
v=s.ae(0.25)
if(r===t.gjb())s=C.i
s=A.aG(s,r===t.gjb()?2:1)
return A.bv(!1,x,!0,A.D(C.P,A.d(E.bp(r),u,u,u,u,C.a1b,u,u,u),C.k,u,u,new A.F(v,u,s,u,u,u,u,C.c_),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:66}
B.bVQ.prototype={
$0(){return this.a.ZV(this.b)},
$S:0}
B.bVX.prototype={
$0(){var x=this.a
return x.k(new B.bVW(x))},
$S:0}
B.bVW.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bW9.prototype={
$1(d){return d===D.uA},
$S:z+2}
B.bWa.prototype={
$1(d){return d===D.uB},
$S:z+2}
B.bWb.prototype={
$1(d){return d===D.uC},
$S:z+2}
B.bVF.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Rl(x)},
$S:0}
B.bVG.prototype={
$1(d){var x=this.a.d
return x.qJ(x.b.ba6(d.ga4(d)))},
$S:103}
B.bVI.prototype={
$1(d){return d.n(0,C.T)?C.ac:C.i},
$S:4}
B.bVH.prototype={
$1(d){return d.n(0,C.T)?C.u:C.a7},
$S:4}
B.bVJ.prototype={
$0(){var x=this.a
return x.ZV(x.gjb()+1)},
$S:0}
B.bVK.prototype={
$0(){var x=this.a
return x.ZV(x.gjb()+1)},
$S:0}
B.bVn.prototype={
$0(){},
$S:0}
B.bVw.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aV(Date.now(),0,!1)},
$S:0}
B.bVx.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bVv())},
$S:31}
B.bVv.prototype={
$0(){},
$S:0}
B.bVz.prototype={
$1(d){return this.a.x=d},
$S:63}
B.bVy.prototype={
$1(d){return this.a.Fx(this.b,!1)},
$S:5}
B.bVA.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.My(x)
w.as=x},
$S:0}
B.bVr.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.bVs.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.My(x))
w.as=x},
$S:0}
B.bVt.prototype={
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
return A.c(n.a.auM(s.b,B.EK(H.Mw(l,m,k.xT(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cjg(H.Mw(l,m,k.xT(l,m)).b,r.a)
if(C.c.P(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtn()
l.atP(k,m,n.b.a,j)}n.zI()
if(o.c!=null)o.k(new B.bVo(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lD){p=o
o=s.a
if(o.c!=null)o.k(new B.bVp(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.k(new B.bVq(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:140}
B.bVo.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.bVp.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.My(w))
x.as=w},
$S:0}
B.bVq.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bVu.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)
x.as=null},
$S:0}
B.bVB.prototype={
$1(d){return d.gtn()},
$S:z+13}
B.bVC.prototype={
$0(){return this.a.Fx(this.b,!0)},
$S:0}
B.bVD.prototype={
$0(){return this.a.I1(this.b)},
$S:0}
B.bVe.prototype={
$0(){},
$S:0}
B.bVl.prototype={
$2(d,e){return d+this.a.a5X(e)},
$S:117}
B.bVm.prototype={
$2(d,e){return d+I.cN[e-1].a[1]},
$S:117}
B.bVk.prototype={
$0(){return this.a.NQ(this.b)},
$S:0}
B.bVj.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kl(p),q,q,q,q,C.ou,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.ba(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.re():r).a.a){case 2:r=G.cL.ae(0.35)
break
case 1:r=D.dW.ae(0.35)
break
case 0:r=C.fT
break
default:r=q}m.push(A.D(C.P,A.d(E.bp(t),q,q,q,q,C.ke,q,q,q),C.k,q,q,new A.F(r,q,q,new A.cz(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cu(!0,new A.E(C.fZ,A.I(A.a([o,C.ah,D.bqK,C.t,new A.dC(D.a6U,A.fh(A.d5(C.ax,m,C.aF,6,6),q,C.r,q,q,q,C.w),q),C.a4,A.bh(D.bsp,q,q,q,new B.bVi(w,d,p),q,q)],n),C.ag,C.d,C.M,0,C.l),q),C.I,!0)},
$S:35}
B.bVi.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.ds(null,null,!0,null,new B.bVh(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.L1(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e4()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.bVh.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kl(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dB(A.a([A.bh(C.ep,x,x,x,new B.bVf(d),x,x),A.bh(C.oH,x,x,x,new B.bVg(d),x,x)],y.p),w,D.btX)},
$S:14}
B.bVf.prototype={
$0(){A.O(this.a,!1).aj(!1)
return null},
$S:0}
B.bVg.prototype={
$0(){A.O(this.a,!1).aj(!0)
return null},
$S:0}
B.c3y.prototype={
$1(d){var x=this.a
return new A.kD(new B.c3x(x),null,x,null)},
$S:1116}
B.c3x.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.ek(w,t,A.d(E.bp(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bj8,C.a4,D.bsQ,C.J,A.oN(new B.c3s(s,r),q,A.de([r.a],x),!1,A.kp(t,t,t,new A.bd(new B.c3t(),v),t,t,t,t,new A.bd(new B.c3u(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.iq(C.u,C.I,t,new B.c3v(s,r),D.bq0,D.bvU,r.c),A.iq(C.u,C.I,t,new B.c3w(s,r),t,D.biG,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ah,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn1(),t,t,t,t,F.aK,t,C.bh,t)],u))
x.push(C.B)
x.push(D.a3a)
return A.cu(!0,A.fh(A.I(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.fZ,t,t,C.w),C.I,!0)},
$S:1117}
B.c3s.prototype={
$1(d){return this.a.qJ(this.b.ba3(d.ga4(d)))},
$S:103}
B.c3u.prototype={
$1(d){return d.n(0,C.T)?C.ac:C.i},
$S:4}
B.c3t.prototype={
$1(d){return d.n(0,C.T)?C.u:C.a7},
$S:4}
B.c3v.prototype={
$1(d){return this.a.qJ(this.b.b9p(d))},
$S:3}
B.c3w.prototype={
$1(d){return this.a.qJ(this.b.ap_(d))},
$S:3}
B.b4E.prototype={
$0(){return A.cD(A.bB(this.a,0,null),C.aU,null)},
$S:0}
B.c3O.prototype={
$1(d){var x,w=A.aF("https?://",!0,!1,!1)
w=A.bK(d,w,"")
x=A.aF("www\\.",!0,!1,!1)
return A.uR(A.bK(w,x,"www[.]"),A.aF("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c3P(),null)},
$S:39}
B.c3P.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:56}
B.bWh.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bWi.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bWj.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bWk.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bWm.prototype={
$0(){var x=this.a
return x.k(new B.bWl(x))},
$S:0}
B.bWl.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c3N.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:224};(function installTearOffs(){var x=a._instance_0u
x(B.aiT.prototype,"gbfU","bfV",1)
var w
x(w=B.Vj.prototype,"gbga","D7",0)
x(w,"gaDs","wz",0)
x(w=B.a_K.prototype,"goC","xI",1)
x(w,"gaXJ","PN",0)
x(w=B.a2b.prototype,"goC","xI",1)
x(w,"gb_o","Qb",0)
x(w,"gb3J","Bz",0)
x(w,"gaJ6","NN",0)
x(w=B.a2a.prototype,"goC","xI",1)
x(w,"gb0d","b0e",1)
x(B.a29.prototype,"goC","xI",1)
x(B.a2c.prototype,"gb5b","Rm",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aiT,B.Vk,B.JB,B.JD,B.JC,B.lD,B.Sr,B.mT,B.Ie,B.rp,B.aiU,B.Vi])
x(A.lb,[B.b4F,B.b4H,B.b4M,B.b4N,B.b4P,B.b4O,B.aVV,B.b4V,B.bIl,B.bIk,B.bI8,B.bIf,B.bIi,B.bIj,B.bIb,B.bIa,B.bId,B.bI9,B.bIg,B.c2F,B.c2B,B.c2A,B.c2E,B.bVE,B.bVU,B.bVY,B.bVZ,B.bW_,B.bW1,B.bW0,B.bW5,B.bW7,B.bW6,B.bVT,B.bVV,B.bVM,B.bVL,B.bVP,B.bWd,B.bWf,B.bWg,B.bVQ,B.bVX,B.bVW,B.bVF,B.bVJ,B.bVK,B.bVn,B.bVw,B.bVv,B.bVA,B.bVr,B.bVs,B.bVo,B.bVp,B.bVq,B.bVu,B.bVC,B.bVD,B.bVe,B.bVk,B.bVi,B.bVf,B.bVg,B.b4E,B.bWh,B.bWi,B.bWj,B.bWk,B.bWm,B.bWl])
x(A.iC,[B.b4I,B.b4K,B.b4L,B.b4J,B.aVU,B.c0q,B.b4T,B.b4U,B.b4R,B.bIm,B.bIn,B.bIo,B.bIe,B.bIh,B.bIc,B.c2K,B.c2J,B.c2G,B.c2I,B.c2C,B.c2D,B.bW2,B.bW4,B.bW3,B.bW8,B.bVN,B.bVO,B.bWe,B.bWc,B.bW9,B.bWa,B.bWb,B.bVG,B.bVI,B.bVH,B.bVx,B.bVz,B.bVy,B.bVt,B.bVB,B.bVj,B.bVh,B.c3y,B.c3s,B.c3u,B.c3t,B.c3v,B.c3w,B.c3O,B.c3P,B.c3N])
x(A.o_,[B.b4G,B.bZk,B.b4W,B.b4X,B.c2H,B.bVS,B.bVR,B.bVl,B.bVm,B.c3x])
x(A.DB,[B.nw,B.F2,B.He,B.E1])
w(B.Vj,A.i1)
x(A.K,[B.wP,B.D1,B.D0,B.D_,B.D2])
x(A.M,[B.a_K,B.a2b,B.a2a,B.a29,B.a2c])
x(A.a3,[B.Hf,B.XA,B.Dk,B.aiS])})()
A.pg(b.typeUniverse,JSON.parse('{"lD":{"bO":[]},"D1":{"K":[],"k":[]},"D0":{"K":[],"k":[]},"D_":{"K":[],"k":[]},"D2":{"K":[],"k":[]},"Vj":{"az":[]},"wP":{"K":[],"k":[]},"a_K":{"M":["wP"]},"Hf":{"a3":[],"k":[]},"XA":{"a3":[],"k":[]},"a2b":{"M":["D1"]},"Dk":{"a3":[],"k":[]},"a2a":{"M":["D0"]},"a29":{"M":["D_"]},"aiS":{"a3":[],"k":[]},"a2c":{"M":["D2"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rp"),c:x("ek<x>"),r:x("c9<x>"),k:x("G<mT>"),n:x("G<ek<x>>"),I:x("G<c9<x>>"),R:x("G<hO>"),Z:x("G<aQ<o,@>>"),d:x("G<Sr>"),s:x("G<o>"),p:x("G<k>"),t:x("G<x>"),m:x("bN"),j:x("a7<@>"),L:x("a7<x>"),P:x("aQ<o,@>"),f:x("aQ<@,@>"),x:x("au<o,x>"),a:x("bD"),K:x("a4"),B:x("Ie"),l:x("+(x,x)"),e:x("d6<mT>"),N:x("o"),C:x("JB"),D:x("JC"),X:x("Vk"),_:x("JD"),U:x("aj<o>"),G:x("nw"),q:x("pd"),b:x("bd<S?>"),y:x("N"),i:x("a2"),z:x("@"),S:x("x"),A:x("bN?"),Y:x("aQ<@,@>?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("fx"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.p2=new B.F2(0,"none")
D.p3=new B.F2(1,"learning")
D.fg=new B.F2(2,"memorized")
D.a6U=new A.aB(0,1/0,0,320)
D.eQ=new A.S(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a71=new A.F(D.eQ,null,null,null,null,null,null,C.c_)
D.dW=new A.S(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.as_=new A.H(C.Hn,null,C.cg,null,null,null)
D.bu4=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.f9,null,null,null,null,null,null,null,null)
D.bbH=new A.r(!0,C.eS,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bqM=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bbH,null,null,null,null,null,null,null,null)
D.aIG=x([D.as_,C.J,D.bu4,D.bqM],y.p)
D.af6=new A.fm(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aIG,null)
D.aiA=new A.X(0,26,0,26)
D.aiD=new A.X(0,4,0,6)
D.aj1=new A.X(14,12,14,14)
D.ajI=new A.X(3,0,0,0)
D.ang=new A.Q(63251,"MaterialIcons",null,!1)
D.qv=new A.Q(63677,"MaterialIcons",null,!1)
D.ao4=new A.Q(983209,"MaterialIcons",null,!1)
D.aoJ=new A.H(D.ao4,28,C.u,null,null,null)
D.apn=new A.H(C.H0,null,C.il,null,null,null)
D.an_=new A.Q(62961,"MaterialIcons",null,!1)
D.aq5=new A.H(D.an_,null,null,null,null,null)
D.anf=new A.Q(63199,"MaterialIcons",null,!1)
D.aq6=new A.H(D.anf,null,null,null,null,null)
D.aqf=new A.H(C.l2,null,C.eS,null,null,null)
D.aqi=new A.H(C.nm,44,C.i,null,null,null)
D.aqN=new A.H(D.qv,null,D.eQ,null,null,null)
D.ar3=new A.H(C.nd,null,D.eQ,null,null,null)
D.arq=new A.H(D.qv,null,null,null,null,null)
D.arW=new A.H(C.iv,20,D.dW,null,null,null)
D.ash=new A.H(C.nj,30,C.u,null,null,null)
D.asJ=new A.H(C.l7,16,C.u,null,null,null)
D.anA=new A.Q(63520,"MaterialIcons",null,!1)
D.ata=new A.H(D.anA,null,null,null,null,null)
D.atl=new A.H(C.nl,null,null,null,null,null)
D.amR=new A.Q(62842,"MaterialIcons",null,!0)
D.aty=new A.H(D.amR,null,null,null,null,null)
D.J_=x([1,3,5],y.t)
D.JN=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aVp=new A.E(C.n3,C.mu,null)
D.aFA=x([D.aVp],y.p)
D.aZR=new A.V(C.nf,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.aZF=new A.V(D.qv,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b_b=new A.V(C.dw,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.anP=new A.Q(63625,"MaterialIcons",null,!1)
D.b_o=new A.V(D.anP,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aHF=x([D.aZR,D.aZF,D.b_b,D.b_o],A.ae("G<+(Q,o)>"))
D.aK0=x([D.p2,D.p3,D.fg],A.ae("G<F2>"))
D.Oq=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aRs=new B.He(0,"idle")
D.UC=new B.He(1,"loading")
D.jS=new B.He(2,"ready")
D.aRt=new B.He(3,"failed")
D.aqL=new A.H(C.bV,18,G.cL,null,null,null)
D.bv1=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.ud,null,null,null,null,null,null,null,null)
D.aEu=x([D.aqL,C.b1,D.bv1],y.p)
D.b5p=new A.en(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aEu,null)
D.aUl=new A.E(C.aM,D.b5p,null)
D.ajG=new A.X(2,6,2,4)
D.bbn=new A.r(!0,C.u,null,null,null,null,14,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bj6=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bbn,null,null,null,null,null,null,null,null)
D.aUA=new A.E(D.ajG,D.bj6,null)
D.bvq=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.f9,null,null,null,null,null,null,null,null)
D.aFU=x([N.tL,C.L,D.bvq],y.p)
D.b5k=new A.en(C.af,C.cq,C.e,C.h,null,C.l,null,0,D.aFU,null)
D.aUK=new A.E(C.pU,D.b5k,null)
D.Bj=new A.r(!0,D.dW,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bvM=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Bj,null,null,null,null,null,null,null,null)
D.aUP=new A.E(C.dX,D.bvM,null)
D.buX=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aK,C.a0,null,null,null,null,null,null,null)
D.aUY=new A.E(C.C,D.buX,null)
D.ajD=new A.X(2,0,2,8)
D.br1=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aK,null,null,null,null,null,null,null,null)
D.aVg=new A.E(D.ajD,D.br1,null)
D.asT=new A.H(C.l5,30,C.u,null,null,null)
D.bwr=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Bk,null,null,null,null,null,null,null,null)
D.akN=new A.bX(1,C.ad,D.bwr,null)
D.aG8=x([D.asT,C.Y,D.akN],y.p)
D.b56=new A.en(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aG8,null)
D.ast=new A.H(C.dw,18,G.cL,null,null,null)
D.a1l=new A.r(!0,G.cL,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.buF=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a1l,null,null,null,null,null,null,null,null)
D.aEV=x([D.ast,C.bG,D.buF],y.p)
D.b5i=new A.en(C.af,C.d,C.M,C.h,null,C.l,null,0,D.aEV,null)
D.b7C=new A.T(0,30)
D.tI=new A.T(1/0,54)
D.b8_=new A.T(1/0,48)
D.b82=new A.T(1/0,50)
D.b85=new A.T(1/0,52)
D.bsz=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.b92=new A.da(D.bsz,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.baS=new A.r(!0,C.i,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bbe=new A.r(!0,C.am,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.B4=new A.r(!0,D.eQ,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.kf=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a1w=new A.r(!0,D.eQ,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beW=new A.r(!0,C.u,null,null,null,null,24,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bfd=new A.r(!0,C.u,null,null,null,null,null,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bg0=new A.r(!0,D.dW,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bg1=new A.r(!0,G.cL,null,null,null,null,null,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgj=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhY=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.i5,null,null,null,null,null,null,null,null)
D.biG=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.cR,null,null,null,null,null,null,null,null)
D.bj8=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.ou,null,null,null,null,null,null,null,null)
D.bjd=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aK,null,null,null,null,null,null,null,null)
D.bcy=new A.r(!0,G.cL,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjv=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bcy,null,null,null,null,null,null,null,null)
D.bjC=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aK,null,null,null,null,null,null,null,null)
D.bk1=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.f9,null,null,null,null,null,null,null,null)
D.blK=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cE,null,null,null,null,null,null,null,null)
D.bmu=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bP,null,null,null,null,null,null,null,null)
D.bmz=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aK,null,null,null,null,null,null,null,null)
D.bn1=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.Bo,null,null,null,null,null,null,null,null)
D.bof=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.boQ=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oy,null,null,null,null,null,null,null,null)
D.bpB=new A.m("reset safe mode / WebGPU ban",null,O.a0S,null,null,null,null,null,null,null,null)
D.bpQ=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Bj,null,null,null,null,null,null,null,null)
D.bq0=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aK,null,null,null,null,null,null,null,null)
D.bqr=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bt,null,null,null,null,null,null,null,null)
D.bqK=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.br2=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.bsm=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a1W,null,null,null,null,null,null,null,null)
D.bea=new A.r(!0,D.eQ,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bsp=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bea,null,null,null,null,null,null,null,null)
D.bsQ=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oy,null,null,null,null,null,null,null,null)
D.btn=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0L,null,null,null,null,null,null,null,null)
D.btB=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cE,null,null,null,null,null,null,null,null)
D.btX=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bue=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.buP=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aK,null,null,null,null,null,null,null,null)
D.buQ=new A.m("\u062e\u0644\u0635\u062a",null,C.m_,null,null,null,null,null,null,null,null)
D.buR=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Bj,null,null,null,null,null,null,null,null)
D.bff=new A.r(!0,C.cG,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.i1,null,null,null,null,null,null,null,null)
D.bvB=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bff,null,null,null,null,null,null,null,null)
D.bvQ=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bt,null,null,null,null,null,null,null,null)
D.bvU=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.cR,null,null,null,null,null,null,null,null)
D.bwq=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aK,null,null,null,null,null,null,null,null)
D.a3a=new B.aiS(null)
D.bxN=new B.D_(null)
D.bxO=new B.Vi(2,1,!0,!1,!1)
D.a3e=new B.Vk(!1,!1,!1,!1,!1,0)
D.j2=new B.nw(0,"ok")
D.uA=new B.nw(1,"near")
D.uB=new B.nw(2,"wrong")
D.uC=new B.nw(3,"missing")
D.a3F=new B.nw(4,"extra")
D.anv=new A.Q(63456,"MaterialIcons",null,!1)
D.bDl=new B.Dk(D.dW,D.anv,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bDZ=new B.XA(!1,null)
D.BV=new B.XA(!0,null)
D.mh=new B.E1(0,"idle")
D.uR=new B.E1(1,"playing")
D.uS=new B.E1(2,"recording")
D.oU=new B.E1(3,"thinking")
D.j9=new B.E1(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cLz","c9r",()=>new B.aiT())
x($,"cP0","cp0",()=>A.aF("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cP1","cp1",()=>A.aF("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cPd","cpa",()=>A.aF("\u0648\u0670",!0,!1,!1))
x($,"cOz","coH",()=>A.aF("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cMR","cnw",()=>A.aF("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cO5","coj",()=>A.aF("[\u0654\u0655]",!0,!1,!1))
x($,"cMS","cnx",()=>A.aF("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cMZ","cnD",()=>A.aF("[\u0624\u0626]",!0,!1,!1))
x($,"cO7","col",()=>A.aF("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cOE","coK",()=>A.aF("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cOf","cos",()=>A.aF("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cOZ","ca2",()=>A.aF("\\s+",!0,!1,!1))
x($,"cIS","re",()=>B.cq_(D.p2,0,A.c52(0,!0)))
x($,"cLA","MF",()=>new B.Vj($.c9r(),D.bxO,B.cxV(),D.aRs,$.W()))})()};
(a=>{a["lwcRwVDZU56oJCJKDQIwXWDoIaQ="]=a.current})($__dart_deferred_initializers__);