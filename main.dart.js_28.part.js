((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,Q,H,G,N,R,K,B={
cxR(d){var x,w,v,u,t,s
if(d instanceof B.lD)return d
try{x=A.d1(d)
w=x.code
v=x.message
u=w==null?"failed":A.a_(w)
t=v==null?"":A.a_(v)
return new B.lD(u,t)}catch(s){u=A.n(d)
return new B.lD("failed",u)}},
aiS:function aiS(){this.b=this.a=null},
b4D:function b4D(d){this.a=d},
b4G:function b4G(){},
b4F:function b4F(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b4E:function b4E(d){this.a=d},
b4K:function b4K(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b4I:function b4I(d){this.a=d},
b4J:function b4J(d){this.a=d},
b4L:function b4L(d){this.a=d},
b4N:function b4N(d,e,f){this.a=d
this.b=e
this.c=f},
b4M:function b4M(d,e,f){this.a=d
this.b=e
this.c=f},
b4H:function b4H(){},
cxS(d,e){return new B.lD(d,e)},
Vj:function Vj(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
JA:function JA(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
JC:function JC(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
JB:function JB(d,e){this.a=d
this.b=e},
lD:function lD(d,e){this.a=d
this.b=e},
ckh(d){var x,w=$.coZ()
w=A.bK(d,w,"\u0627")
x=$.cp_()
w=A.bK(w,x,"\u064a")
x=$.cp8()
w=A.bK(w,x,"\u0627")
x=$.cnu()
w=A.bK(w,x,"\u0627")
x=$.coF()
w=A.bK(w,x,"\u0621")
x=$.coh()
w=A.bK(w,x,"\u0621")
x=$.cnv()
w=A.bK(w,x,"\u0627")
x=$.cnB()
w=A.bK(w,x,"\u0621")
w=A.bK(w,"\u0649","\u064a")
w=A.bK(w,"\u0629","\u0647")
x=$.coj()
w=A.bK(w,x,"")
x=$.coI()
w=A.bK(w,x," ")
x=$.coq()
w=A.bK(w,x," ")
x=$.ca0()
return C.c.P(A.bK(w,x," "))},
cCx(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
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
c3S(d,e){var x,w,v,u,t,s
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
s=1-B.cCx(d,e)/u
return s>=1?0.99:s},
EJ(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tV(d,$.ca0()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.ckh(u)
s=A.bK(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Sq(r.a+" "+u,r.b))}continue}q.push(new B.Sq(u,s))}return q},
cBd(d,e){var x,w,v,u,t=new B.bZi(),s=A.a([],y.s)
for(x=A.fS(e,0,A.iV(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.cb(x,x.gL(0),w.i("cb<aY.E>")),w=w.i("aY.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.JM)&&t.$2(d,D.JM)?C.b.jy(d,5):d
return!t.$2(s,D.Op)&&t.$2(u,D.Op)?C.b.jy(u,4):u},
cje(d,e){var x=B.EJ(d),w=B.ckh(e),v=y.U
v=A.aa(new A.aj(A.a(w.split(" "),y.s),new B.c0o(),v),v.i("Z.E"))
return new B.Id(x,B.cAo(x,B.cBd(v,x)),w)},
cAo(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.cl(x,0,!1,s)
q=A.cl(x,0,!1,y.S)
p=A.cl(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c3S(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c3S(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c3S(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.j1
else m=a2>=0.6?D.uA:D.uB
a1.push(new B.mT(o,x,s,m))
break
case 1:--o
a1.push(new B.mT(o,a4[o],null,D.uC))
break
case 2:--n
a1.push(new B.mT(null,null,a6[n],D.a3E))
break
case 3:--o
a3=n-2
a1.push(new B.mT(o,a4[o],a6[a3]+" "+a6[n-1],D.j1))
n=a3
break
default:x=o-1;--n
a1.push(new B.mT(x,a4[x],a6[n],D.j1))
o-=2
a1.push(new B.mT(o,a4[o],a6[n],D.j1))}}a4=y.e
a4=A.aa(new A.d6(a1,a4),a4.i("aY.E"))
return a4},
nw:function nw(d,e){this.a=d
this.b=e},
Sq:function Sq(d,e){this.a=d
this.b=e},
mT:function mT(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Id:function Id(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aVT:function aVT(d){this.a=d},
aVS:function aVS(){},
bZi:function bZi(){},
c0o:function c0o(){},
cpY(d,e,f){return new B.rp(d,e,f)},
cDs(d){var x
A:{if("memorized"===d){x=D.ff
break A}if("learning"===d){x=D.p3
break A}x=D.p2
break A}return x},
clf(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cN[d-1].a[1]},
cxT(){var x=y.S
return new B.aiT(A.B(x,y.u),A.aU(x))},
b4Q(d){var x=d.fl()
return C.c.dn(C.j.j(A.bq(x)),4,"0")+"-"+C.c.dn(C.j.j(A.bs(x)),2,"0")+"-"+C.c.dn(C.j.j(A.bV(x)),2,"0")},
cg8(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cET(),x),x.i("aY.E"))
return B.b4Q(A.dq(w[0],w[1],w[2]-1,12,0,0,0))},
c7_(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.B(p,y.u),n=A.aU(p),m=new B.aiT(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcP(),x=x.ga0(x),w=y.j;x.v();){v=x.gJ()
u=A.dR(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aO(t)>=3){v=C.j.aH(u,1000)
s=C.j.a2(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cN[v-1].a[1])}if(v)continue
v=J.be(t)
r=C.f.ca(A.cR(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rp(D.aJW[r],C.f.ca(A.cR(v.h(t,1))),new A.aV(A.ks(C.f.ca(A.cR(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aA5(q,y.o)
p=A.mo(x,new B.b4P(),x.$ti.i("Z.E"),p)
n.A(0,new A.aj(p,o.ga3A(),A.y(p).i("aj<Z.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aH(d.h(0,"streak"))
p=p==null?null:C.f.ca(p)
p=m.d=p==null?0:p
o=A.aH(d.h(0,"best"))
o=o==null?null:C.f.ca(o)
m.e=o==null?p:o
return m},
azq(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dn(C.j.j(d),3,"0")+C.c.dn(C.j.j(e),3,"0")+".mp3"},
F1:function F1(d,e){this.a=d
this.b=e},
rp:function rp(d,e,f){this.a=d
this.b=e
this.c=f},
aiT:function aiT(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b4R:function b4R(){},
b4S:function b4S(){},
b4P:function b4P(){},
Vh:function Vh(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cvn(){return new B.wP(null)},
cHf(d,e){var x,w,v,u,t={},s=I.cN[e-1].a[1],r=$.ME().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.re():v).a===D.ff}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d1(u+4,1,s)
return A.e7(C.cK,new B.c2I(t,s,e),d,!0,null,null,!1,y.l)},
c8M(d){return A.dl(0,0,0,0,0,C.j.d1(C.f.al(6+d*1.2),25,90))},
c7H(d){return E.bp(C.j.aH(d,60))+":"+C.c.dn(E.bp(C.j.a2(d,60)),2,"\u0660")},
cl1(d){return A.e7(C.cK,new B.c3w($.ME()),d,!0,null,null,!1,y.H)},
Mx(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl2()
break A}return x},
cIz(d,e,f){var x,w=new B.c3M(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
cla(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.aq.fz(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.hd:r
q=s.a(J.av(x,"last"))
v=q==null?C.hd:q
u=new B.c3L()
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
a0=J.aO(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.l(J.av(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.l(J.av(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
Hd:function Hd(d,e){this.a=d
this.b=e},
Vi:function Vi(d,e,f,g,h){var _=this
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
b4T:function b4T(d){this.a=d},
b4U:function b4U(d){this.a=d},
b4V:function b4V(d){this.a=d},
wP:function wP(d){this.a=d},
a_J:function a_J(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bIk:function bIk(d){this.a=d},
bIj:function bIj(d,e){this.a=d
this.b=e},
bIl:function bIl(d){this.a=d},
bIi:function bIi(d,e){this.a=d
this.b=e},
bIm:function bIm(){},
bI6:function bI6(){},
bIc:function bIc(d,e,f){this.a=d
this.b=e
this.c=f},
bId:function bId(){},
bIg:function bIg(d){this.a=d},
bIf:function bIf(){},
bIh:function bIh(d){this.a=d},
bI9:function bI9(d,e){this.a=d
this.b=e},
bIa:function bIa(d){this.a=d},
bI8:function bI8(){},
bIb:function bIb(d){this.a=d},
bI7:function bI7(d){this.a=d},
bIe:function bIe(d,e){this.a=d
this.b=e},
He:function He(d,e,f){this.c=d
this.d=e
this.a=f},
Xz:function Xz(d,e){this.c=d
this.a=e},
c2I:function c2I(d,e,f){this.a=d
this.b=e
this.c=f},
c2F:function c2F(d,e,f){this.a=d
this.b=e
this.c=f},
c2H:function c2H(d,e){this.a=d
this.b=e},
c2E:function c2E(d,e){this.a=d
this.b=e},
c2D:function c2D(d,e){this.a=d
this.b=e},
c2G:function c2G(d,e){this.a=d
this.b=e},
c2z:function c2z(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c2y:function c2y(d,e,f){this.a=d
this.b=e
this.c=f},
c2A:function c2A(d){this.a=d},
c2B:function c2B(d){this.a=d},
c2C:function c2C(d,e){this.a=d
this.b=e},
E0:function E0(d,e){this.a=d
this.b=e},
D1:function D1(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2a:function a2a(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bVC:function bVC(){},
bVS:function bVS(d,e){this.a=d
this.b=e},
bVW:function bVW(d){this.a=d},
bVX:function bVX(d){this.a=d},
bVY:function bVY(d,e,f){this.a=d
this.b=e
this.c=f},
bW_:function bW_(d){this.a=d},
bW0:function bW0(d){this.a=d},
bVZ:function bVZ(){},
bW2:function bW2(d){this.a=d},
bW1:function bW1(d){this.a=d},
bW3:function bW3(d,e){this.a=d
this.b=e},
bW5:function bW5(d){this.a=d},
bW6:function bW6(d){this.a=d},
bW4:function bW4(){},
bVR:function bVR(d,e,f){this.a=d
this.b=e
this.c=f},
bVT:function bVT(d,e,f){this.a=d
this.b=e
this.c=f},
bVK:function bVK(d){this.a=d},
bVL:function bVL(d){this.a=d},
bVJ:function bVJ(){},
bVM:function bVM(){},
bVN:function bVN(d,e){this.a=d
this.b=e},
bWb:function bWb(d){this.a=d},
bWc:function bWc(d){this.a=d},
bWd:function bWd(d,e){this.a=d
this.b=e},
bWa:function bWa(d){this.a=d},
bWe:function bWe(d,e){this.a=d
this.b=e},
bVQ:function bVQ(){},
bVP:function bVP(d){this.a=d},
bVO:function bVO(d,e){this.a=d
this.b=e},
bVV:function bVV(d){this.a=d},
bVU:function bVU(d){this.a=d},
bW7:function bW7(){},
bW8:function bW8(){},
bW9:function bW9(){},
bVD:function bVD(d,e,f){this.a=d
this.b=e
this.c=f},
bVE:function bVE(d){this.a=d},
bVG:function bVG(){},
bVF:function bVF(){},
bVH:function bVH(d){this.a=d},
bVI:function bVI(d){this.a=d},
Dj:function Dj(d,e,f,g,h){var _=this
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
a29:function a29(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bVl:function bVl(){},
bVu:function bVu(d,e){this.a=d
this.b=e},
bVv:function bVv(d){this.a=d},
bVt:function bVt(){},
bVx:function bVx(d){this.a=d},
bVw:function bVw(d,e){this.a=d
this.b=e},
bVy:function bVy(d,e){this.a=d
this.b=e},
bVp:function bVp(d,e){this.a=d
this.b=e},
bVq:function bVq(d,e,f){this.a=d
this.b=e
this.c=f},
bVr:function bVr(d,e,f){this.a=d
this.b=e
this.c=f},
bVm:function bVm(d,e,f){this.a=d
this.b=e
this.c=f},
bVn:function bVn(d,e,f){this.a=d
this.b=e
this.c=f},
bVo:function bVo(d,e){this.a=d
this.b=e},
bVs:function bVs(d){this.a=d},
bVz:function bVz(){},
bVA:function bVA(d,e){this.a=d
this.b=e},
bVB:function bVB(d,e){this.a=d
this.b=e},
D_:function D_(d){this.a=d},
a28:function a28(d){this.d=d
this.c=this.a=null},
bVc:function bVc(){},
bVj:function bVj(d){this.a=d},
bVk:function bVk(){},
bVi:function bVi(d,e){this.a=d
this.b=e},
bVh:function bVh(d,e,f){this.a=d
this.b=e
this.c=f},
bVg:function bVg(d,e,f){this.a=d
this.b=e
this.c=f},
bVf:function bVf(d){this.a=d},
bVd:function bVd(d){this.a=d},
bVe:function bVe(d){this.a=d},
c3w:function c3w(d){this.a=d},
c3v:function c3v(d){this.a=d},
c3q:function c3q(d,e){this.a=d
this.b=e},
c3s:function c3s(){},
c3r:function c3r(){},
c3t:function c3t(d,e){this.a=d
this.b=e},
c3u:function c3u(d,e){this.a=d
this.b=e},
aiR:function aiR(d){this.a=d},
b4C:function b4C(d){this.a=d},
c3M:function c3M(){},
c3N:function c3N(){},
D2:function D2(d,e,f){this.c=d
this.d=e
this.a=f},
a2b:function a2b(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bWf:function bWf(d){this.a=d},
bWg:function bWg(d){this.a=d},
bWh:function bWh(d,e){this.a=d
this.b=e},
bWi:function bWi(d){this.a=d},
bWk:function bWk(d){this.a=d},
bWj:function bWj(d){this.a=d},
c3L:function c3L(){}},D,O,P,I,E,F
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
B.aiS.prototype={
r6(){var x=this,w=x.a
if(w!=null)return A.eh(w,y.m)
w=x.b
return w==null?x.b=new B.b4D(x).$0():w},
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
r=B.cxR(s)
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
v=new B.Vj(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a3d
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
v=new A.asW(q,p)
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
A.Pt(this.r6().bG(new B.b4G(),x),x)},
r5(d,e){var x=A.jO(d[e])
x=x==null?null:C.f.al(x)
return x==null?0:x},
bgb(d,e,f){return this.um(new B.b4F(this,d,e,f),y.C)},
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
a92(d,e,f,g,h){return this.um(new B.b4K(this,e,d,f,h,g),y.H)},
a95(){return this.um(new B.b4L(this),y.D)},
a3d(){var x=null,w=this.a
if(w!=null)A.cT(w,"cancelRecording",x,x,x,x)},
alG(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.r5(d,"ms")
w=A.jO(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.JC(u,x,w,v.r5(d,"frames"),v.r5(d,"tokens"),v.or(d,"retried"),v.r5(d,"encMs"),v.r5(d,"decMs"),v.r5(d,"featMs"))},
ai4(d){var x={}
x.words=d
return x},
auM(d,e){return this.um(new B.b4N(this,d,e),y._)},
bl1(d,e){return this.um(new B.b4M(this,d,e),y._)},
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
o=A.aa(new A.au(d,new B.b4H(),o),o.i("aY.E"))
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
B.Vj.prototype={}
B.JA.prototype={
gn1(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.JC.prototype={
gSK(){var x=this,w=C.f.aw(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.JB.prototype={}
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
B.Sq.prototype={}
B.mT.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Id.prototype={
gMo(){var x,w=this,v=w.d
if(v===$){x=new B.aVT(w).$0()
w.d!==$&&A.an()
w.d=x
v=x}return v},
gJw(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a3E&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbh2(){return J.hd(this.gMo(),new B.aVS()).gL(0)},
gtn(){var x=this.a
return x.length!==0&&this.gbh2()===x.length&&this.gJw().length===0}}
B.F1.prototype={
R(){return"AyahStatus."+this.b}}
B.rp.prototype={}
B.aiT.prototype={
a65(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.re():x},
aZy(d){var x=this,w=B.b4Q(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cg8(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
apu(){var x=Date.now(),w=B.b4Q(new A.aV(x,0,!1))
x=this.c
return x===w||x===B.cg8(w)?this.d:0},
atP(d,e,f,g){var x=this,w=new A.aV(Date.now(),0,!1),v=x.a65(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.ff:D.p3,s=new B.rp(t,u,w.hd()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.aZy(w)
return s},
a5X(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cN[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.re():s).a===D.ff)++u}return u},
bfT(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cN[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.re():s).a===D.p3)++u}return u},
gasT(){var x=this.a,w=A.y(x).i("ce<2>")
return new A.aj(new A.ce(x,w),new B.b4R(),w.i("aj<Z.E>")).gL(0)},
gayq(){var x=this.a,w=A.y(x).i("bI<1>")
w=A.mo(new A.bI(x,w),new B.b4S(),w.i("Z.E"),y.S)
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
for(x=this.b,x=A.b3b(x,300,A.y(x).c),x=new A.Jh(J.aD(x.a),x.b,A.y(x).i("Jh<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gJ()
s=C.j.aH(t,1000)
t=C.j.a2(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.re():q).a===D.ff?"memorized":"learning"
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
n=B.cDs(s.h(0,"status"))
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
B.Vh.prototype={
IX(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Vh(w,v,u,t,f==null?x.e:f)},
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
B.Hd.prototype={
R(){return"ModelState."+this.b}}
B.Vi.prototype={
vC(){var x=this.Q
return x==null?this.Q=new B.b4T(this).$0():x},
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
v.as=A.cM(C.x,v.gaDs())
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
if(n===D.UB||n===D.jS){x=1
break}s.f=D.UB
s.y=null
s.a3()
u=4
n=A.lE().geP().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lE().geP().h(0,"tutor_threads")
p=A.dR(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bgb(new B.b4U(s),n,p),$async$D7)
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
s.f=D.aRn
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
if(J.aO(l)===0){x=10
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
x=v}for(;;)switch(x){case 0:p=B.c7_(t.c.dE()).dE()
y.f.a(p.h(0,"rows")).eh(0,new B.b4V(d))
t.c=B.c7_(p)
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
O(){var x=$.ME()
return new B.a_J(x,new A.ai(C.O,$.W()))}}
B.a_J.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goC())
w=y.a
x.vC().bG(new B.bIk(v),w)
H.aUl().bG(new B.bIl(v),w).fv(new B.bIm())
A.Pt(H.c6l(),y.y)},
xI(){if(this.c!=null)this.k(new B.bI6())},
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
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.Z(A.aN(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.V(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cHf(s,d),$async$xJ)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.M8(d,t.a,t.b),$async$xJ)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aB(A.aA(new B.bIc(u,d,t),null,r),r),$async$xJ)
case 8:if(u.c!=null)u.k(new B.bId())
case 1:return A.h(v,w)}})
return A.i($async$xJ,w)},
u(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.garL()&&!A.O(d,!1).v6())u.push(A.bR(x,x,x,x,C.yd,x,x,t.gbfU(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bR(x,x,x,x,D.at7,x,x,new B.bIg(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bR(x,x,x,x,C.iv,x,x,new B.bIh(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aFv
else w=t?this.aSi():this.aSU()
return L.xz(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aSU(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a3d
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b5_,C.a3],x)
for(t=0;t<4;++t){s=D.aHz[t]
u.push(new A.F(C.bs,A.A(A.a([A.b0(s.a,C.am,p,18),C.L,new A.bX(1,C.ad,A.d(s.b,p,p,p,p,G.a0P,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bvI,C.J,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bp(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aK,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bp(C.f.al(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.J,A.d(q,p,p,p,p,A.bJ(p,p,r?D.dW:C.cG,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.J,D.buJ],x))
x=A.a([new E.dx(u,C.a5,C.aM,p,!0,p),new E.dx(A.I(s,C.q,C.d,C.e,0,C.l),C.a5,C.aM,p,!1,p),D.bDM,C.J],x)
if(v!=null)x.push(new E.dx(A.d(v,p,p,p,p,D.bfS,p,p,p),C.a5,C.aM,p,!1,p))
else x.push(A.fn(D.aq3,D.blC,this.gaXJ(),A.ey(C.v,C.ac,D.b7Y,p,p,p,p)))
x.push(C.a4)
x.push(D.a39)
return x},
aSi(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.P(r.a.a),p=q.length===0,o=p?C.rl:H.ckV(q),n=t.z,m=A.R(v.akY(C.dw,E.bp(s.gasT())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bp(s.apu()),k=s.c,j=Date.now()
k=k===B.b4Q(new A.aV(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.He(t,!1,u),A.A(A.a([m,C.L,A.R(v.akY(C.l4,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.t],j)
if(n!=null){t=H.kl(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bp(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bp(m)+"\u2013"+E.bp(l)
k.push(new E.dx(A.A(A.a([D.ase,C.Y,A.R(A.I(A.a([D.bhP,A.d(t+" \u2014 "+m,u,u,u,u,C.bt,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nv],j),C.h,C.d,C.e,0,u,u),C.a5,C.aM,new B.bI9(v,n),!0,u))}t=C.i.ae(0.08)
k.push(A.aI(u,C.y,!1,u,!0,C.m,u,A.aL(),r,u,u,u,u,u,2,A.cF(u,new A.ci(4,A.v(14),C.K),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.u6,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qH,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bIa(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.cR,!0,C.u,u,C.E,u,u,u,u))
k.push(C.t)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bqV)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.R3(o[x]))
C.b.A(k,t)}else{t=A.a([D.aUu,D.aV9,v.R3(1)],j)
for(w=114;w>=78;--w)t.push(v.R3(w))
t.push(C.J)
r=v.f
p=A.b0(r?C.xW:C.l3,C.am,u,u)
t.push(A.h1(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.f9,u,u,u),new B.bIb(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.R3(w))
C.b.A(k,t)}k.push(C.a3)
k.push(D.BU)
return k},
akY(d,e,f){var x=null,w=y.p
return new E.dx(A.A(A.a([A.b0(d,C.v,x,x),C.L,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bt,x,x,x),A.d(f,1,C.N,x,x,C.a1t,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a5,C.I,x,!1,x)},
R3(d){var x,w=null,v=this.d.c,u=I.cN[d-1].a[1],t=v.a5X(d),s=t/u,r=y.p,q=A.aq(A.dz(C.P,A.a([A.c4M(C.eR,G.cL,w,w,w,w,w,3,s,w),A.d(E.bp(d),w,w,w,w,Q.a1Q,w,w,w)],r),C.m,C.bj,w),36,36),p=A.d(H.kl(d),w,w,w,w,D.baJ,w,w,w)
if(t===0)x=E.bp(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bp(t)+" \u0645\u0646 "+E.bp(u)
r=A.a([q,C.cD,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bJ(w,w,t===u?G.cL:C.cG,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bp(C.f.al(s*100))+"\u066a",w,w,w,w,D.a1k,w,w,w))
r.push(D.aqc)
return new E.dx(A.A(r,C.h,C.d,C.e,0,w,w),C.q_,C.cY,new B.bIe(this,d),!1,w)}}
B.He.prototype={
u(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aUf
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.Mx(x),r,r,r,r,D.B4,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.D2(w,"model load",r))
x.push(C.J)
x.push(new A.zM(C.a3Z,!1,q.gbga(),r,r,r,r,C.k,r,!1,r,!0,r,C.uj,r))
return new E.dx(A.I(x,C.q,C.d,C.e,0,C.l),C.a5,C.aM,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bp(C.f.al(u/1e6))+" \u0645\u0646 "+E.bp(C.f.al(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.oz,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fd(x,A.q4(C.eR,C.v,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.J,D.bmr],w))
return new E.dx(A.I(x,C.q,C.d,C.e,0,C.l),C.a5,C.aM,r,!1,r)}}}
B.Xz.prototype={
u(d){var x=null,w=D.dW.ae(0.1),v=A.v(14),u=A.aG(D.dW.ae(0.4),1)
return A.D(x,A.A(A.a([D.arT,C.L,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.Bb,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.G(w,x,u,v,x,x,x,C.n),x,x,C.aM,C.ae,x,x,x)}}
B.E0.prototype={
R(){return"_Phase."+this.b}}
B.D1.prototype={
O(){return new B.a2a($.ME(),D.mh)}}
B.a2a.prototype={
gjb(){var x=this.e
return x===$?this.e=this.a.d:x},
gBG(){var x,w=this.a,v=w.f
w=w.c
x=this.gjb()
return H.Mv(w,x,v.xT(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.ac(w.goC())
x.vC()
x.a.a6u(B.azq(w.a.c,w.gjb()))},
xI(){if(this.c!=null)this.k(new B.bVC())},
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
v.k(new B.bVS(v,d))
x.a6u(B.azq(v.a.c,d))
w=v.a
if(d<w.e)x.a6u(B.azq(w.c,d+1))},
Rl(d){return this.aTL(d)},
aTL(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$Rl=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.uR){u.d.a.Mq()
u.k(new B.bVW(u))
x=1
break}t=u.r!=null?D.j8:D.mh
u.k(new B.bVX(u))
s=u.d
r=A.a([B.azq(u.a.c,u.gjb())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.KL(r,q),$async$Rl)
case 3:p=f
if(u.c==null||u.f!==D.uR){x=1
break}u.k(new B.bVY(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$Rl,w)},
Qb(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Qb=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jS){x=1
break}p=l.a
p.Mq()
r=B.EJ(s.gBG()).length
s.k(new B.bW_(s))
o=s.Q
if(o!=null)o.az()
s.Q=A.hC(C.eV,new B.bW0(s))
u=4
o=B.c8M(r)
n=A.dl(0,0,0,350*r,0,0)
x=7
return A.c(p.a92(l.b.c,o,n,new B.bW1(s),new B.bW2(s)),$async$Qb)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lD){q=l
l=s.Q
if(l!=null)l.az()
if(s.c!=null)s.k(new B.bW3(s,q))}else throw k
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
s.k(new B.bW5(s))
s.Q=A.hC(C.iq,new B.bW6(s))
l=new A.Cu()
$.EM()
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
return A.c(m.auM(q,B.EJ(s.gBG()).length),$async$Bz)
case 8:p=e
s.ch=A.dl(0,0,r.ga4x(),0,0,0)
k=A.lE().geP().h(0,"debug")
if(k==="1"){o=B.cla(m.Jd())
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
s.a22(B.Mx(n),n)}else throw i
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
x.k(new B.bVR(x,d,e))},
b58(d){return this.a22(d,null)},
afa(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.az()
if(s.c==null)return
x=B.cje(s.gBG(),d)
r.a=null
if(C.c.P(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjb()
t=x.gtn()
r.a=w.atP(v,u,q.b.a,t)
q.zI()}s.k(new B.bVT(r,s,x))},
NN(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$NN=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jS){x=1
break}s.k(new B.bVK(s))
l=s.Q
if(l!=null)l.az()
s.Q=A.hC(C.iq,new B.bVL(s))
k=new A.Cu()
$.EM()
k.om()
r=k
u=4
l=g.a
x=7
return A.c(l.bl1(B.azq(s.a.c,s.gjb()),B.EJ(s.gBG()).length),$async$NN)
case 7:q=e
p=B.cla(l.Jd())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.aw(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aw(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.aw(r.gCt()/1000,2)+" \u062b)\n"+q.gSK()+"\n"+A.n(p)+"\n"+q.a
A.ra().$1("[tutor-debug] "+s.a.c+":"+s.gjb()+" audio="+C.f.aw(q.c,1)+"s infer="+q.b+"ms total="+r.gCt()+"ms "+q.gSK()+" text="+q.a)
A.ra().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dl(0,0,r.ga4x(),0,0,0)
s.afa(q.a)
n=s.r
if(n!=null){l=n.gtn()
j=n.b
i=A.al(j).i("aj<1>")
j=A.aa(new A.aj(j,new B.bVM(),i),i.i("Z.E"))
A.ra().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.k(new B.bVN(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lD){m=l
A.ra().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.Jd())
s.a22(B.Mx(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$NN,w)},
ga0Q(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.re():v).a!==D.ff)return!1}return!0},
u(d){var x,w=this,v=null,u=w.d,t=u.c.a65(w.a.c,w.gjb()),s=u.b,r=s.d&&!w.x&&w.f!==D.j8,q=H.kl(w.a.c),p=y.p,o=A.a([A.bR(v,v,v,v,C.iv,v,v,new B.bWb(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aK9(),m=A.d("\u0622\u064a\u0629 "+E.bp(w.gjb()),v,v,v,v,C.m_,v,v,v),l=E.bp(w.gjb()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.b1,A.d("("+l+" \u0645\u0646 "+E.bp(k.e-k.d+1)+")",v,v,v,v,F.aK,v,v,v),C.bz,w.aYo(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.t],p)
if(r)s.push(w.aSd())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.uS&&l!==D.oU}else l=!1
if(l)s.push(w.aHQ(m))
else s.push(A.d(w.gBG()+" \ufd3f"+E.bp(w.gjb())+"\ufd3e",v,v,v,v,D.kf,C.a0,C.bh,v))}s=A.a([new B.He(u,!0,v),n,C.B,new E.dx(A.I(s,C.ag,C.d,C.e,0,C.l),D.aj_,C.aM,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.j8)s.push(w.b6D(n))
if(w.r!=null&&w.f===D.j8&&w.ch!=null){x=C.f.al(C.j.aH(w.ch.a,1000)/100)
s.push(new A.F(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bp(C.j.aH(x,10))+"\u066b"+E.bp(C.j.a2(x,10)))+" \u062b",v,v,v,v,F.aK,C.a0,v,v),v))}n=w.as
if(n!=null)s.push(new A.F(C.aM,A.d(n,v,v,v,v,D.B4,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.D2(n,"check "+w.a.c+":"+w.gjb(),v))}s.push(w.aIn())
s.push(C.a3)
s.push(A.iq(C.v,C.I,v,new B.bWc(w),D.bjt,D.boI,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga0Q()
s.push(new E.dx(A.A(A.a([D.aoH,C.Y,A.R(A.I(A.a([D.bqj,A.d(w.ga0Q()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aK,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nv],p),C.h,C.d,C.e,0,v,v),C.a5,C.aM,new B.bWd(w,d),n,v))}n=A.lE().geP().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dy(D.aq2,D.bo7,u.f===D.jS&&w.f!==D.oU?w.gaJ6():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.F(C.ir,A.xa(n,F.aK,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn1()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aK,v,v,v))}p.push(A.bh(D.bpt,v,v,v,new B.bWe(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.BU)
return L.xz(o,s,q)},
aK9(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.aq(A.fB(new B.bVP(this),w,null,C.af,new B.bVQ()),36,null)},
aYo(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.ff)return D.b5a
x=d.b
w=E.bp(x)
v=E.bp(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.bV:C.Ha
u.push(new A.F(D.ajG,A.b0(r,s?G.cL:C.eS,q,16),q))}return A.aiM(A.A(u,C.h,C.d,C.M,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aSd(){var x=null
return A.bv(!1,A.v(12),!0,A.D(x,D.af4,C.k,x,x,new A.G(C.pu,x,x,A.v(12),x,x,x,C.n),x,x,x,D.aiy,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bVV(this),x,x,x,x,x,x,x)},
aHQ(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gMo(),w)
A:{if(D.j1===v){u=D.kf.ct(G.cL)
break A}if(D.uA===v){u=D.kf.a3R(D.dW,C.i1,D.dW)
break A}if(D.uB===v){u=D.kf.a3R(D.eQ,C.i1,D.eQ)
break A}u=D.kf.a3R(C.eS,C.kb,C.cg)
break A}t=x[w]
r.push(new A.f3(t.a,s,s,C.by,s,s,s,s,s,s,u))
r.push(P.AW)}x=E.bp(this.gjb())
r.push(A.en(s,s,s,s,s,s,s,s,s,D.kf.ct(C.am),"\ufd3f"+x+"\ufd3e"))
return A.Ji(A.en(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.a0,C.bh)},
b6D(d){var x,w,v,u,t,s,r=this.w
if(C.c.P(d.c).length===0)return D.bD8
if(d.gtn()){x=r==null
if((x?null:r.a)===D.ff&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.ff?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bp(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.Dj(G.cL,C.bV,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMo()
w=J.dD(x)
v=w.iE(x,new B.bW7()).gL(0)
u=w.iE(x,new B.bW8()).gL(0)
t=w.iE(x,new B.bW9()).gL(0)
x=A.a([],y.s)
if(u>0)x.push(E.bp(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bp(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bp(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJw().length!==0)x.push(E.bp(d.gJw().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eQ:D.dW
x=C.b.aE(x," \u2022 ")
s=d.gJw().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aE(d.gJw(),"\u060c "):""
return new B.Dj(w,C.nl,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aIn(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jS,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aH(new A.aV(f,0,!1).dK(w).a,1e6)}v=C.j.aH(B.c8M(B.EJ(j.gBG()).length).a,1e6)
f=j.gb3J()
w=96+26*j.y
u=D.eQ.ae(0.25)
w=A.iL(i,A.a4Y(C.P,A.D(i,D.aqf,C.k,i,i,D.a7_,i,84,i,i,i,i,84),i,C.aT,new A.G(u,i,i,i,i,i,i,C.c_),C.ER,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cO)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c7H(x)+" / "+B.c7H(v),i,i,i,i,K.oy,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aK,i,i,i),A.bh(D.buI,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.ey((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bp(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bp(t)+" \u062b)"
return new A.F(C.pW,A.I(A.a([C.vF,C.a3,D.bmU,A.d(h,i,i,i,i,F.aK,C.a0,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.uR
r=j.r
f=r==null
w=!f
q=w&&r.gtn()
u=A.b0(s?C.nm:K.Ho,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.ey(i,i,D.b7V,i,i,i,i)
u=A.R(new A.zM(C.a3Z,!0,new B.bVD(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Ya(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.IZ[n]
p.push(new A.ek(m,i,A.d("\xd7"+E.bp(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.L,A.oN(new B.bVE(j),p,A.de([h.b.b],o),!1,A.kp(i,i,i,new A.bd(new B.bVF(),l),i,i,i,i,new A.bd(new B.bVG(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cJ),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb_o():i
u=A.b0(f?D.qv:C.nl,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cE,i,i,i)
p=q?C.il:C.v
h=A.a([o,C.t,A.fn(u,f,h,A.ey(p,q?C.i:C.ac,D.tI,i,i,i,i))],k)
if(w&&j.gjb()<j.a.e)C.b.A(h,A.a([C.B,q?A.fn(D.atv,D.btt,new B.bVH(j),A.ey(G.cL,C.ac,D.tI,i,i,i,i)):A.bh(D.bjT,i,i,i,new B.bVI(j),i,i)],k))
if(w){f=j.gjb()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.F(C.js,A.d(j.ga0Q()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,K.ud,C.a0,i,i),i))
return A.I(h,C.ag,C.d,C.e,0,C.l)}}}
B.Dj.prototype={
u(d){var x=this,w=null,v=x.c,u=v.ae(0.12),t=A.v(14),s=A.aG(v.ae(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b0(x.d,v,w,w),C.L,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bJ(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.V,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bM,A.d(x.f,w,w,w,w,C.Bb,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.G(u,w,s,t,w,w,w,C.n),w,w,C.aM,C.ae,w,w,w)}}
B.D0.prototype={
O(){var x=y.S
return new B.a29($.ME(),A.B(x,y.B),A.aU(x),A.B(x,y.N),A.eh(null,y.H))}}
B.a29.prototype={
W(){this.Y()
this.d.ac(this.goC())},
xI(){if(this.c!=null)this.k(new B.bVl())},
m(){var x,w=this,v=w.d
v.T(w.goC())
x=w.y
if(x!=null)x.az()
v.a.a3d()
w.a_()},
I1(d){return this.b3v(d)},
b3v(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$I1=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.k(new B.bVu(t,d))
r=t.y
if(r!=null)r.az()
t.y=A.hC(C.eV,new B.bVv(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c8M(B.EJ(H.Mv(q,d,p.xT(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dl(0,0,0,350*B.EJ(H.Mv(p,d,o.xT(p,d)).b).length,0,0)
x=6
return A.c(r.a.a92(r.b.c,q,p,new B.bVw(t,d),new B.bVx(t)),$async$I1)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lD){s=r
r=t.y
if(r!=null)r.az()
if(t.c!=null)t.k(new B.bVy(t,s))}else throw m
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
s.k(new B.bVp(s,d))
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
s.k(new B.bVq(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bG(new B.bVr(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Fx,w)},
gaVU(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b0e(){this.k(new B.bVs(this))},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jS,o=s.e,n=s.gaVU(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("ce<2>")
x=new A.aj(new A.ce(m,l),new B.bVz(),l.i("aj<Z.E>")).gL(0)
l=H.kl(s.a.c)
m=y.p
q=A.a([new B.He(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bp(s.a.d)+" \u0644\u062d\u062f "+E.bp(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aK,r,r,r),C.t],m)
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
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c7H(v),r,r,r,r,K.oy,C.a0,r,r)
j=A.fd(A.v(6),A.q4(C.eR,D.eQ,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b0(u?O.Hh:C.nm,r,r,r)
C.b.A(q,A.a([v,C.J,j,C.t,A.fn(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cE,r,r,r),new B.bVA(s,o),A.ey(C.v,C.ac,D.tI,r,r,r,r))],m))}else if(n!=null){j=p?new B.bVB(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bp(n)
q.push(A.fn(D.arn,A.d(v,r,r,r,r,C.cE,r,r,r),j,A.ey(C.v,C.ac,D.tI,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aUE)
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
C.b.A(q,A.a([new B.Dj(j,v,k,u,r),A.dy(D.ati,D.bu6,s.gb0d(),r)],m))}q.push(C.t)
q.push(D.BU)
return L.xz(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b5a(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.aqK
else if(l.r.n(0,d))x=N.tL
else if(i!=null)x=D.ar0
else if(j!=null){w=j.gtn()?C.bV:D.ane
x=A.b0(w,j.gtn()?G.cL:D.dW,k,k)}else x=D.apk
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bp(d),k,k,k,k,D.bf4,k,k,k),C.bz,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.a1v,k,k,k))
if(j!=null&&!j.gtn()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMo()
o=J.be(p)
n=o.h(p,r)
A:{if(D.j1===n){m=G.cL
break A}if(D.uA===n){m=D.dW
break A}if(D.uB===n){m=D.eQ
break A}m=C.eS
break A}m=D.kf.baI(m,o.h(p,r)===D.uC?C.kb:k,22)
C.b.A(t,A.a([new A.f3(q.a,k,k,C.by,k,k,k,k,k,k,m),P.AW],u))}w=A.a([C.ah,A.Ji(A.en(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.a0,C.bh)],w)
if(C.c.P(j.c).length===0)w.push(D.bpI)
C.b.A(v,w)}return new E.dx(A.I(v,C.ag,C.d,C.e,0,C.l),C.bJ,C.cY,k,!1,k)}}
B.D_.prototype={
O(){return new B.a28($.ME())}}
B.a28.prototype={
W(){this.Y()
var x=this.d
x.ac(this.goC())
x.vC()},
xI(){if(this.c!=null)this.k(new B.bVc())},
m(){this.d.T(this.goC())
this.a_()},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gayq(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kZ(o,0,new B.bVj(q))
v=C.b.kZ(o,0,new B.bVk())
o=y.p
o=A.a([A.A(A.a([A.R(s.XN(E.bp(q.gasT()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.L,A.R(s.XN(E.bp(q.apu()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.L,A.R(s.XN(E.bp(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.t,new E.dx(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bp(C.f.al(w*100/v))+"\u066a",r,r,r,r,C.bt,r,r,r),C.J,A.fd(A.v(6),A.q4(C.eR,G.cL,8,w/v,r),C.aC),C.ah,A.d(E.bp(w)+" \u0645\u0646 "+E.bp(v)+" \u0622\u064a\u0629",r,r,r,r,F.aK,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a5,C.aM,r,!1,r)],o)
if(p.length===0)o.push(D.aUS)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b5c(p[t]))
o.push(C.B)
u=$.C().b
u===$&&A.b()
u=u.ga5().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aK,r,r,r))
return L.xz(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
XN(d,e){var x=null
return new E.dx(A.I(A.a([A.d(d,x,x,x,x,D.beN,x,x,x),A.d(e,x,x,x,x,C.a21,C.a0,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a5,C.I,x,!1,x)},
b5c(d){var x=null,w=this.d.c,v=I.cN[d-1].a[1],u=w.a5X(d),t=w.bfT(d),s=y.p,r=A.A(A.a([A.R(A.d(H.kl(d),x,x,x,x,C.bt,x,x,x),1),A.d(E.bp(C.f.al(u*100/v))+"\u066a",x,x,x,x,D.bfT,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fd(A.v(6),A.q4(C.eR,G.cL,7,u/v,x),C.aC),p=E.bp(u),o=E.bp(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bp(t):""
return new E.dx(A.I(A.a([r,C.J,q,C.ah,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aK,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a5,C.aM,new B.bVi(this,d),!1,x)},
NQ(d){return this.aJs(d)},
aJs(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$NQ=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cN[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e7(C.cK,new B.bVh(v,d,u),t,!0,null,null,!1,y.H),$async$NQ)
case 2:return A.h(null,w)}})
return A.i($async$NQ,w)}}
B.aiR.prototype={
Rk(d,e){var x=null,w=A.no(x,x,x,x,x,x,x,x,x,x,x,D.b7u,C.I,x,x,x,x,C.jR,x,x)
return A.bh(A.d(d,x,x,x,x,C.lZ,x,x,x),x,x,x,new B.b4C(e),x,w)},
u(d){var x=this,w=y.p
return new E.dx(A.I(A.a([D.btf,C.J,D.buH,A.d5(C.ax,A.a([x.Rk("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Rk("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aF,0,12),D.bj4,x.Rk("tanzil.net","https://tanzil.net"),D.bwi,x.Rk("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a5,C.aM,null,!1,null)}}
B.D2.prototype={
O(){return new B.a2b()}}
B.a2b.prototype={
galM(){var x=this.a
return B.cIz(x.c,x.d,$.c9p().Jd())},
Rm(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$Rm=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.k(new B.bWf(s))
v=3
r=A.c2W()
n=s.galM()
m=y.N
q=A.B(m,m)
J.dX(q,"app","mogtama3y")
J.dX(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dX(q,"ua",m)}x=6
return A.c(A.a9r(n,null,C.FV,q),$async$Rm)
case 6:if(s.c!=null)s.k(new B.bWg(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cn?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.k(new B.bWh(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.k(new B.bWi(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Rm,w)},
u(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bv(!1,t,!0,new A.F(C.pX,A.A(A.a([A.b0(u.d?C.xW:C.l3,C.cg,t,18),C.bG,D.bvt],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bWk(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.D(t,A.xa(u.galM(),D.bb5,t,C.A),C.k,t,t,new A.G(C.pu,t,t,x,t,t,t,C.n),t,t,D.aiB,C.e9,t,t,1/0))}if(u.f)s.push(D.bjm)
else{x=A.no(t,t,t,t,t,t,t,t,t,t,t,C.a_P,C.I,t,t,t,t,C.jR,t,t)
w=u.e
v=w?t:u.gb5b()
s.push(A.h1(w?C.a03:D.asG,D.bse,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,D.a1v,t,t,t))
return new A.F(C.aM,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["ak<~>()","~()","N(nw)","ak<JC>()","ak<JA>()","ak<JB>()","a7<nw>()","N(rp)","bD(oE)","D1(t)","D_(t)","N(mT)","D0(t)","N(Id)"])
B.b4D.prototype={
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
m=B.cxS("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:306}
B.b4G.prototype={
$1(d){var x=null
return A.bYR(A.cT(d,"persist",x,x,x,x))},
$S:1106}
B.b4F.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.r6(),$async$$0)
case 4:x=3
return A.c(n.eD(m.d1(l.cT(e,"loadModel",A.bZz(new B.b4E(u.b)),u.c,u.d,null)),y.m),$async$$0)
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
v=new B.JA(o,t,s,r,q.r5(p,"threads"),q.or(p,"isolated"),q.r5(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b4E.prototype={
$2(d,e){this.a.$2(C.f.al(d),C.f.al(e))},
$S:1107}
B.b4K.prototype={
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
u.onLevel=A.fU(new B.b4I(v.e))
u.onAutoStop=A.fU(new B.b4J(v.f))
x=5
return A.c(A.eD(A.d1(A.cT(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b4I.prototype={
$1(d){return this.a.$1(d)},
$S:63}
B.b4J.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b4L.prototype={
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
v=new B.JB(r,A.dW(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b4N.prototype={
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
B.b4M.prototype={
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
B.b4H.prototype={
$1(d){return d},
$S:39}
B.aVT.prototype={
$0(){var x,w,v,u,t=this.a,s=A.cl(t.a.length,D.uC,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aVS.prototype={
$1(d){return d===D.j1},
$S:z+2}
B.bZi.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c3S(e[x],d[x])<0.75)return!1
return!0},
$S:1108}
B.c0o.prototype={
$1(d){return d.length!==0},
$S:11}
B.b4R.prototype={
$1(d){return d.a===D.ff},
$S:z+7}
B.b4S.prototype={
$1(d){return C.j.aH(d,1000)},
$S:58}
B.b4P.prototype={
$1(d){return C.f.ca(d)},
$S:1109}
B.b4T.prototype={
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
i=C.b.n(D.IZ,k.h(0,"r"))?A.eB(k.h(0,"r")):1
h=A.ef(k.h(0,"auto"))
g=A.ef(k.h(0,"hide"))
k=A.ef(k.h(0,"in"))
s.a.b=new B.Vh(j,i,h!==!1,g===!0,k===!0)}u=2
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
if(q!=null)s.a.c=B.c7_(y.P.a(C.aq.fz(q,null)))
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
if(B.clf(n,m)&&B.clf(n,l)&&m<=l)s.a.z=new A.b_(n,m,l)}u=2
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
B.b4U.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a3()},
$S:1110}
B.b4V.prototype={
$2(d,e){return C.j.aH(A.eC(A.n(d),null,null),1000)===this.a},
$S:1111}
B.bIk.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.En(),$async$$1)
case 2:t=f
if(u.c!=null)u.k(new B.bIj(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1112}
B.bIj.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bIl.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bIi(x,d))},
$S:z+8}
B.bIi.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bIm.prototype={
$1(d){},
$S:24}
B.bI6.prototype={
$0(){},
$S:0}
B.bIc.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.D1(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bId.prototype={
$0(){},
$S:0}
B.bIg.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aB(A.aA(new B.bIf(),null,x),x)},
$S:0}
B.bIf.prototype={
$1(d){return D.bxE},
$S:z+10}
B.bIh.prototype={
$0(){return B.cl1(this.a)},
$S:0}
B.bI9.prototype={
$0(){var x=this.b
return this.a.xJ(x.a,x.b,x.c)},
$S:0}
B.bIa.prototype={
$1(d){return this.a.k(new B.bI8())},
$S:5}
B.bI8.prototype={
$0(){},
$S:0}
B.bIb.prototype={
$0(){var x=this.a
return x.k(new B.bI7(x))},
$S:0}
B.bI7.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bIe.prototype={
$0(){return this.a.b59(this.b)},
$S:0}
B.c2I.prototype={
$1(d){return new A.jH(new B.c2F(this.a,this.b,this.c),null)},
$S:57}
B.c2F.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c2H(u,e),s=this.a,r=new B.c2G(s,e),q=A.d(H.kl(this.c),v,v,v,v,C.ou,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bp(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aK,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bp(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bp(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.ah,p,C.t,A.d5(C.ax,n,C.aF,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c2A(s)),C.a0_,t.$3("\u0644\u062d\u062f",s.c,new B.c2B(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aUJ)
u.push(C.a4)
u.push(A.dF(D.bmm,new B.c2C(s,d),A.ey(C.v,C.ac,D.b7S,v,v,v,v)))
return A.ct(!0,new A.F(C.Fm,A.I(u,C.ag,C.d,C.M,0,C.l),v),C.I,!0)},
$S:387}
B.c2H.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.i5,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c9(v,A.d("\u0622\u064a\u0629 "+E.bp(v),u,u,u,u,u,u,u,u),C.au,u,w))
return A.R(A.I(A.a([t,R.FU(C.cK,!0,s,320,new B.c2E(this.b,f),D.bga,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1114}
B.c2E.prototype={
$1(d){return d==null?null:this.a.$1(new B.c2D(this.b,d))},
$S:51}
B.c2D.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c2G.prototype={
$3(d,e,f){var x=null
return A.c4s(x,A.d(d,x,x,x,x,x,x,x,x),new B.c2z(this.a,this.b,e,f))},
$S:1115}
B.c2z.prototype={
$0(){var x=this
return x.b.$1(new B.c2y(x.a,x.c,x.d))},
$S:0}
B.c2y.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c2A.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c2B.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c2C.prototype={
$0(){var x=this.a
return A.O(this.b,!1).aj(new A.V(x.b,x.c))},
$S:0}
B.bVC.prototype={
$0(){},
$S:0}
B.bVS.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mh
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bVW.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.j8:D.mh},
$S:0}
B.bVX.prototype={
$0(){var x=this.a
x.f=D.uR
x.as=null},
$S:0}
B.bVY.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bW_.prototype={
$0(){var x=this.a
x.f=D.uS
x.as=null
x.y=0
x.z=new A.aV(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bW0.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bVZ())},
$S:31}
B.bVZ.prototype={
$0(){},
$S:0}
B.bW2.prototype={
$1(d){return this.a.y=d},
$S:63}
B.bW1.prototype={
$1(d){return this.a.Bz()},
$S:5}
B.bW3.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.j8:D.mh
x=this.b
w.as=B.Mx(x)
w.at=x},
$S:0}
B.bW5.prototype={
$0(){var x=this.a
x.f=D.oU
x.ay=Date.now()},
$S:0}
B.bW6.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bW4())},
$S:31}
B.bW4.prototype={
$0(){},
$S:0}
B.bVR.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.j8:D.mh
x.as=this.b
x.at=this.c},
$S:0}
B.bVT.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.j8
x.x=!1},
$S:0}
B.bVK.prototype={
$0(){var x=this.a
x.f=D.oU
x.ay=Date.now()
x.as=null},
$S:0}
B.bVL.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bVJ())},
$S:31}
B.bVJ.prototype={
$0(){},
$S:0}
B.bVM.prototype={
$1(d){return d.d!==D.j1},
$S:z+11}
B.bVN.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bWb.prototype={
$0(){return B.cl1(this.a)},
$S:0}
B.bWc.prototype={
$1(d){var x=this.a.d
return x.qJ(x.b.ap_(d))},
$S:3}
B.bWd.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aB(A.aA(new B.bWa(this.a),null,x),x)},
$S:0}
B.bWa.prototype={
$1(d){var x=this.a.a
return new B.D0(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bWe.prototype={
$0(){this.a.d.a.bka()
this.b.I(y.q).f.Z(D.b8V)},
$S:0}
B.bVQ.prototype={
$2(d,e){return C.b1},
$S:19}
B.bVP.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a65(s.c,r).a.a){case 2:s=G.cL
break
case 1:s=D.dW
break
case 0:s=C.il
break
default:s=u}x=A.v(18)
w=t.f===D.oU?u:new B.bVO(t,r)
v=s.ae(0.25)
if(r===t.gjb())s=C.i
s=A.aG(s,r===t.gjb()?2:1)
return A.bv(!1,x,!0,A.D(C.P,A.d(E.bp(r),u,u,u,u,C.a1a,u,u,u),C.k,u,u,new A.G(v,u,s,u,u,u,u,C.c_),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:66}
B.bVO.prototype={
$0(){return this.a.ZV(this.b)},
$S:0}
B.bVV.prototype={
$0(){var x=this.a
return x.k(new B.bVU(x))},
$S:0}
B.bVU.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bW7.prototype={
$1(d){return d===D.uA},
$S:z+2}
B.bW8.prototype={
$1(d){return d===D.uB},
$S:z+2}
B.bW9.prototype={
$1(d){return d===D.uC},
$S:z+2}
B.bVD.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Rl(x)},
$S:0}
B.bVE.prototype={
$1(d){var x=this.a.d
return x.qJ(x.b.ba6(d.ga4(d)))},
$S:103}
B.bVG.prototype={
$1(d){return d.n(0,C.T)?C.ac:C.i},
$S:4}
B.bVF.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.bVH.prototype={
$0(){var x=this.a
return x.ZV(x.gjb()+1)},
$S:0}
B.bVI.prototype={
$0(){var x=this.a
return x.ZV(x.gjb()+1)},
$S:0}
B.bVl.prototype={
$0(){},
$S:0}
B.bVu.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aV(Date.now(),0,!1)},
$S:0}
B.bVv.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bVt())},
$S:31}
B.bVt.prototype={
$0(){},
$S:0}
B.bVx.prototype={
$1(d){return this.a.x=d},
$S:63}
B.bVw.prototype={
$1(d){return this.a.Fx(this.b,!1)},
$S:5}
B.bVy.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.Mx(x)
w.as=x},
$S:0}
B.bVp.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.bVq.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.Mx(x))
w.as=x},
$S:0}
B.bVr.prototype={
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
return A.c(n.a.auM(s.b,B.EJ(H.Mv(l,m,k.xT(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cje(H.Mv(l,m,k.xT(l,m)).b,r.a)
if(C.c.P(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtn()
l.atP(k,m,n.b.a,j)}n.zI()
if(o.c!=null)o.k(new B.bVm(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lD){p=o
o=s.a
if(o.c!=null)o.k(new B.bVn(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.k(new B.bVo(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:140}
B.bVm.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.bVn.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.Mx(w))
x.as=w},
$S:0}
B.bVo.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bVs.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)
x.as=null},
$S:0}
B.bVz.prototype={
$1(d){return d.gtn()},
$S:z+13}
B.bVA.prototype={
$0(){return this.a.Fx(this.b,!0)},
$S:0}
B.bVB.prototype={
$0(){return this.a.I1(this.b)},
$S:0}
B.bVc.prototype={
$0(){},
$S:0}
B.bVj.prototype={
$2(d,e){return d+this.a.a5X(e)},
$S:117}
B.bVk.prototype={
$2(d,e){return d+I.cN[e-1].a[1]},
$S:117}
B.bVi.prototype={
$0(){return this.a.NQ(this.b)},
$S:0}
B.bVh.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kl(p),q,q,q,q,C.ou,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.ba(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.re():r).a.a){case 2:r=G.cL.ae(0.35)
break
case 1:r=D.dW.ae(0.35)
break
case 0:r=C.fT
break
default:r=q}m.push(A.D(C.P,A.d(E.bp(t),q,q,q,q,C.ke,q,q,q),C.k,q,q,new A.G(r,q,q,new A.cy(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.ct(!0,new A.F(C.fZ,A.I(A.a([o,C.ah,D.bqC,C.t,new A.dB(D.a6S,A.fh(A.d5(C.ax,m,C.aF,6,6),q,C.r,q,q,q,C.w),q),C.a3,A.bh(D.bsh,q,q,q,new B.bVg(w,d,p),q,q)],n),C.ag,C.d,C.M,0,C.l),q),C.I,!0)},
$S:35}
B.bVg.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.ds(null,null,!0,null,new B.bVf(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.L1(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e4()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.bVf.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kl(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dA(A.a([A.bh(C.ep,x,x,x,new B.bVd(d),x,x),A.bh(C.oH,x,x,x,new B.bVe(d),x,x)],y.p),w,D.btP)},
$S:14}
B.bVd.prototype={
$0(){A.O(this.a,!1).aj(!1)
return null},
$S:0}
B.bVe.prototype={
$0(){A.O(this.a,!1).aj(!0)
return null},
$S:0}
B.c3w.prototype={
$1(d){var x=this.a
return new A.kD(new B.c3v(x),null,x,null)},
$S:1116}
B.c3v.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.ek(w,t,A.d(E.bp(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bj_,C.a3,D.bsI,C.J,A.oN(new B.c3q(s,r),q,A.de([r.a],x),!1,A.kp(t,t,t,new A.bd(new B.c3r(),v),t,t,t,t,new A.bd(new B.c3s(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.iq(C.v,C.I,t,new B.c3t(s,r),D.bpT,D.bvM,r.c),A.iq(C.v,C.I,t,new B.c3u(s,r),t,D.bix,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ah,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn1(),t,t,t,t,F.aK,t,C.bh,t)],u))
x.push(C.B)
x.push(D.a39)
return A.ct(!0,A.fh(A.I(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.fZ,t,t,C.w),C.I,!0)},
$S:1117}
B.c3q.prototype={
$1(d){return this.a.qJ(this.b.ba3(d.ga4(d)))},
$S:103}
B.c3s.prototype={
$1(d){return d.n(0,C.T)?C.ac:C.i},
$S:4}
B.c3r.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.c3t.prototype={
$1(d){return this.a.qJ(this.b.b9p(d))},
$S:3}
B.c3u.prototype={
$1(d){return this.a.qJ(this.b.ap_(d))},
$S:3}
B.b4C.prototype={
$0(){return A.cC(A.bB(this.a,0,null),C.aU,null)},
$S:0}
B.c3M.prototype={
$1(d){var x,w=A.aF("https?://",!0,!1,!1)
w=A.bK(d,w,"")
x=A.aF("www\\.",!0,!1,!1)
return A.uR(A.bK(w,x,"www[.]"),A.aF("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c3N(),null)},
$S:39}
B.c3N.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:56}
B.bWf.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bWg.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bWh.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bWi.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bWk.prototype={
$0(){var x=this.a
return x.k(new B.bWj(x))},
$S:0}
B.bWj.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c3L.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:224};(function installTearOffs(){var x=a._instance_0u
x(B.aiS.prototype,"gbfU","bfV",1)
var w
x(w=B.Vi.prototype,"gbga","D7",0)
x(w,"gaDs","wz",0)
x(w=B.a_J.prototype,"goC","xI",1)
x(w,"gaXJ","PN",0)
x(w=B.a2a.prototype,"goC","xI",1)
x(w,"gb_o","Qb",0)
x(w,"gb3J","Bz",0)
x(w,"gaJ6","NN",0)
x(w=B.a29.prototype,"goC","xI",1)
x(w,"gb0d","b0e",1)
x(B.a28.prototype,"goC","xI",1)
x(B.a2b.prototype,"gb5b","Rm",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aiS,B.Vj,B.JA,B.JC,B.JB,B.lD,B.Sq,B.mT,B.Id,B.rp,B.aiT,B.Vh])
x(A.lb,[B.b4D,B.b4F,B.b4K,B.b4L,B.b4N,B.b4M,B.aVT,B.b4T,B.bIj,B.bIi,B.bI6,B.bId,B.bIg,B.bIh,B.bI9,B.bI8,B.bIb,B.bI7,B.bIe,B.c2D,B.c2z,B.c2y,B.c2C,B.bVC,B.bVS,B.bVW,B.bVX,B.bVY,B.bW_,B.bVZ,B.bW3,B.bW5,B.bW4,B.bVR,B.bVT,B.bVK,B.bVJ,B.bVN,B.bWb,B.bWd,B.bWe,B.bVO,B.bVV,B.bVU,B.bVD,B.bVH,B.bVI,B.bVl,B.bVu,B.bVt,B.bVy,B.bVp,B.bVq,B.bVm,B.bVn,B.bVo,B.bVs,B.bVA,B.bVB,B.bVc,B.bVi,B.bVg,B.bVd,B.bVe,B.b4C,B.bWf,B.bWg,B.bWh,B.bWi,B.bWk,B.bWj])
x(A.iC,[B.b4G,B.b4I,B.b4J,B.b4H,B.aVS,B.c0o,B.b4R,B.b4S,B.b4P,B.bIk,B.bIl,B.bIm,B.bIc,B.bIf,B.bIa,B.c2I,B.c2H,B.c2E,B.c2G,B.c2A,B.c2B,B.bW0,B.bW2,B.bW1,B.bW6,B.bVL,B.bVM,B.bWc,B.bWa,B.bW7,B.bW8,B.bW9,B.bVE,B.bVG,B.bVF,B.bVv,B.bVx,B.bVw,B.bVr,B.bVz,B.bVh,B.bVf,B.c3w,B.c3q,B.c3s,B.c3r,B.c3t,B.c3u,B.c3M,B.c3N,B.c3L])
x(A.o_,[B.b4E,B.bZi,B.b4U,B.b4V,B.c2F,B.bVQ,B.bVP,B.bVj,B.bVk,B.c3v])
x(A.DA,[B.nw,B.F1,B.Hd,B.E0])
w(B.Vi,A.i1)
x(A.K,[B.wP,B.D1,B.D0,B.D_,B.D2])
x(A.M,[B.a_J,B.a2a,B.a29,B.a28,B.a2b])
x(A.a3,[B.He,B.Xz,B.Dj,B.aiR])})()
A.pg(b.typeUniverse,JSON.parse('{"lD":{"bO":[]},"D1":{"K":[],"k":[]},"D0":{"K":[],"k":[]},"D_":{"K":[],"k":[]},"D2":{"K":[],"k":[]},"Vi":{"az":[]},"wP":{"K":[],"k":[]},"a_J":{"M":["wP"]},"He":{"a3":[],"k":[]},"Xz":{"a3":[],"k":[]},"a2a":{"M":["D1"]},"Dj":{"a3":[],"k":[]},"a29":{"M":["D0"]},"a28":{"M":["D_"]},"aiR":{"a3":[],"k":[]},"a2b":{"M":["D2"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rp"),c:x("ek<x>"),r:x("c9<x>"),k:x("E<mT>"),n:x("E<ek<x>>"),I:x("E<c9<x>>"),R:x("E<hN>"),Z:x("E<aQ<o,@>>"),d:x("E<Sq>"),s:x("E<o>"),p:x("E<k>"),t:x("E<x>"),m:x("bN"),j:x("a7<@>"),L:x("a7<x>"),P:x("aQ<o,@>"),f:x("aQ<@,@>"),x:x("au<o,x>"),a:x("bD"),K:x("a4"),B:x("Id"),l:x("+(x,x)"),e:x("d6<mT>"),N:x("o"),C:x("JA"),D:x("JB"),X:x("Vj"),_:x("JC"),U:x("aj<o>"),G:x("nw"),q:x("pd"),b:x("bd<S?>"),y:x("N"),i:x("a2"),z:x("@"),S:x("x"),A:x("bN?"),Y:x("aQ<@,@>?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("fx"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.p2=new B.F1(0,"none")
D.p3=new B.F1(1,"learning")
D.ff=new B.F1(2,"memorized")
D.a6S=new A.aB(0,1/0,0,320)
D.eQ=new A.S(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a7_=new A.G(D.eQ,null,null,null,null,null,null,C.c_)
D.dW=new A.S(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.arX=new A.H(C.Hm,null,C.cg,null,null,null)
D.btX=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.f9,null,null,null,null,null,null,null,null)
D.bby=new A.r(!0,C.eS,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bqE=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bby,null,null,null,null,null,null,null,null)
D.aIB=x([D.arX,C.J,D.btX,D.bqE],y.p)
D.af4=new A.fm(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aIB,null)
D.aiy=new A.X(0,26,0,26)
D.aiB=new A.X(0,4,0,6)
D.aj_=new A.X(14,12,14,14)
D.ajG=new A.X(3,0,0,0)
D.ane=new A.Q(63251,"MaterialIcons",null,!1)
D.qv=new A.Q(63677,"MaterialIcons",null,!1)
D.ao2=new A.Q(983209,"MaterialIcons",null,!1)
D.aoH=new A.H(D.ao2,28,C.v,null,null,null)
D.apk=new A.H(C.H_,null,C.il,null,null,null)
D.amY=new A.Q(62961,"MaterialIcons",null,!1)
D.aq2=new A.H(D.amY,null,null,null,null,null)
D.and=new A.Q(63199,"MaterialIcons",null,!1)
D.aq3=new A.H(D.and,null,null,null,null,null)
D.aqc=new A.H(C.l2,null,C.eS,null,null,null)
D.aqf=new A.H(C.nm,44,C.i,null,null,null)
D.aqK=new A.H(D.qv,null,D.eQ,null,null,null)
D.ar0=new A.H(C.nd,null,D.eQ,null,null,null)
D.arn=new A.H(D.qv,null,null,null,null,null)
D.arT=new A.H(C.jz,20,D.dW,null,null,null)
D.ase=new A.H(C.nj,30,C.v,null,null,null)
D.asG=new A.H(C.l7,16,C.v,null,null,null)
D.any=new A.Q(63520,"MaterialIcons",null,!1)
D.at7=new A.H(D.any,null,null,null,null,null)
D.ati=new A.H(C.nl,null,null,null,null,null)
D.amP=new A.Q(62842,"MaterialIcons",null,!0)
D.atv=new A.H(D.amP,null,null,null,null,null)
D.IZ=x([1,3,5],y.t)
D.JM=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aVi=new A.F(C.n3,C.mu,null)
D.aFv=x([D.aVi],y.p)
D.aZK=new A.V(C.nf,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.aZy=new A.V(D.qv,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b_4=new A.V(C.dw,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.anN=new A.Q(63625,"MaterialIcons",null,!1)
D.b_h=new A.V(D.anN,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aHz=x([D.aZK,D.aZy,D.b_4,D.b_h],A.ae("E<+(Q,o)>"))
D.aJW=x([D.p2,D.p3,D.ff],A.ae("E<F1>"))
D.Op=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aRm=new B.Hd(0,"idle")
D.UB=new B.Hd(1,"loading")
D.jS=new B.Hd(2,"ready")
D.aRn=new B.Hd(3,"failed")
D.aqI=new A.H(C.bV,18,G.cL,null,null,null)
D.buU=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.ud,null,null,null,null,null,null,null,null)
D.aEo=x([D.aqI,C.b1,D.buU],y.p)
D.b5h=new A.et(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aEo,null)
D.aUf=new A.F(C.aM,D.b5h,null)
D.ajE=new A.X(2,6,2,4)
D.bbe=new A.r(!0,C.v,null,null,null,null,14,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.biY=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bbe,null,null,null,null,null,null,null,null)
D.aUu=new A.F(D.ajE,D.biY,null)
D.bvi=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.f9,null,null,null,null,null,null,null,null)
D.aFP=x([N.tL,C.L,D.bvi],y.p)
D.b5c=new A.et(C.af,C.cq,C.e,C.h,null,C.l,null,0,D.aFP,null)
D.aUE=new A.F(C.pU,D.b5c,null)
D.Bj=new A.r(!0,D.dW,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bvE=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Bj,null,null,null,null,null,null,null,null)
D.aUJ=new A.F(C.dX,D.bvE,null)
D.buP=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aK,C.a0,null,null,null,null,null,null,null)
D.aUS=new A.F(C.C,D.buP,null)
D.ajB=new A.X(2,0,2,8)
D.bqU=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aK,null,null,null,null,null,null,null,null)
D.aV9=new A.F(D.ajB,D.bqU,null)
D.asQ=new A.H(C.l5,30,C.v,null,null,null)
D.bwj=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Bk,null,null,null,null,null,null,null,null)
D.akL=new A.bX(1,C.ad,D.bwj,null)
D.aG3=x([D.asQ,C.Y,D.akL],y.p)
D.b5_=new A.et(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aG3,null)
D.asq=new A.H(C.dw,18,G.cL,null,null,null)
D.a1k=new A.r(!0,G.cL,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bux=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a1k,null,null,null,null,null,null,null,null)
D.aEP=x([D.asq,C.bG,D.bux],y.p)
D.b5a=new A.et(C.af,C.d,C.M,C.h,null,C.l,null,0,D.aEP,null)
D.b7u=new A.T(0,30)
D.tI=new A.T(1/0,54)
D.b7S=new A.T(1/0,48)
D.b7V=new A.T(1/0,50)
D.b7Y=new A.T(1/0,52)
D.bsr=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.b8V=new A.da(D.bsr,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.baJ=new A.r(!0,C.i,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bb5=new A.r(!0,C.am,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.B4=new A.r(!0,D.eQ,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.kf=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a1v=new A.r(!0,D.eQ,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beN=new A.r(!0,C.v,null,null,null,null,24,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bf4=new A.r(!0,C.v,null,null,null,null,null,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bfS=new A.r(!0,D.dW,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bfT=new A.r(!0,G.cL,null,null,null,null,null,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bga=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhP=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.i5,null,null,null,null,null,null,null,null)
D.bix=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.cR,null,null,null,null,null,null,null,null)
D.bj_=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.ou,null,null,null,null,null,null,null,null)
D.bj4=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aK,null,null,null,null,null,null,null,null)
D.bcp=new A.r(!0,G.cL,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjm=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bcp,null,null,null,null,null,null,null,null)
D.bjt=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aK,null,null,null,null,null,null,null,null)
D.bjT=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.f9,null,null,null,null,null,null,null,null)
D.blC=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cE,null,null,null,null,null,null,null,null)
D.bmm=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bP,null,null,null,null,null,null,null,null)
D.bmr=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aK,null,null,null,null,null,null,null,null)
D.bmU=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.Bo,null,null,null,null,null,null,null,null)
D.bo7=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.boI=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oy,null,null,null,null,null,null,null,null)
D.bpt=new A.m("reset safe mode / WebGPU ban",null,O.a0R,null,null,null,null,null,null,null,null)
D.bpI=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Bj,null,null,null,null,null,null,null,null)
D.bpT=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aK,null,null,null,null,null,null,null,null)
D.bqj=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bt,null,null,null,null,null,null,null,null)
D.bqC=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.bqV=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.bse=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a1V,null,null,null,null,null,null,null,null)
D.be1=new A.r(!0,D.eQ,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bsh=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.be1,null,null,null,null,null,null,null,null)
D.bsI=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oy,null,null,null,null,null,null,null,null)
D.btf=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0K,null,null,null,null,null,null,null,null)
D.btt=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cE,null,null,null,null,null,null,null,null)
D.btP=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bu6=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.buH=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aK,null,null,null,null,null,null,null,null)
D.buI=new A.m("\u062e\u0644\u0635\u062a",null,C.m_,null,null,null,null,null,null,null,null)
D.buJ=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Bj,null,null,null,null,null,null,null,null)
D.bf6=new A.r(!0,C.cG,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.i1,null,null,null,null,null,null,null,null)
D.bvt=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bf6,null,null,null,null,null,null,null,null)
D.bvI=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bt,null,null,null,null,null,null,null,null)
D.bvM=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.cR,null,null,null,null,null,null,null,null)
D.bwi=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aK,null,null,null,null,null,null,null,null)
D.a39=new B.aiR(null)
D.bxE=new B.D_(null)
D.bxF=new B.Vh(2,1,!0,!1,!1)
D.a3d=new B.Vj(!1,!1,!1,!1,!1,0)
D.j1=new B.nw(0,"ok")
D.uA=new B.nw(1,"near")
D.uB=new B.nw(2,"wrong")
D.uC=new B.nw(3,"missing")
D.a3E=new B.nw(4,"extra")
D.ant=new A.Q(63456,"MaterialIcons",null,!1)
D.bD8=new B.Dj(D.dW,D.ant,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bDM=new B.Xz(!1,null)
D.BU=new B.Xz(!0,null)
D.mh=new B.E0(0,"idle")
D.uR=new B.E0(1,"playing")
D.uS=new B.E0(2,"recording")
D.oU=new B.E0(3,"thinking")
D.j8=new B.E0(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cLx","c9p",()=>new B.aiS())
x($,"cOZ","coZ",()=>A.aF("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cP_","cp_",()=>A.aF("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cPb","cp8",()=>A.aF("\u0648\u0670",!0,!1,!1))
x($,"cOx","coF",()=>A.aF("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cMP","cnu",()=>A.aF("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cO3","coh",()=>A.aF("[\u0654\u0655]",!0,!1,!1))
x($,"cMQ","cnv",()=>A.aF("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cMX","cnB",()=>A.aF("[\u0624\u0626]",!0,!1,!1))
x($,"cO5","coj",()=>A.aF("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cOC","coI",()=>A.aF("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cOd","coq",()=>A.aF("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cOX","ca0",()=>A.aF("\\s+",!0,!1,!1))
x($,"cIQ","re",()=>B.cpY(D.p2,0,A.c50(0,!0)))
x($,"cLy","ME",()=>new B.Vi($.c9p(),D.bxF,B.cxT(),D.aRm,$.W()))})()};
(a=>{a["XTp7PX8Yy19Q0VahDEMJXVtRsxg="]=a.current})($__dart_deferred_initializers__);