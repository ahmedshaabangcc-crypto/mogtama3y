((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,Q,H,G,N,R,K,B={
cxk(d){var x,w,v,u,t,s
if(d instanceof B.lw)return d
try{x=A.cZ(d)
w=x.code
v=x.message
u=w==null?"failed":A.a_(w)
t=v==null?"":A.a_(v)
return new B.lw(u,t)}catch(s){u=A.n(d)
return new B.lw("failed",u)}},
aiL:function aiL(){this.b=this.a=null},
b4x:function b4x(d){this.a=d},
b4A:function b4A(){},
b4z:function b4z(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b4y:function b4y(d){this.a=d},
b4E:function b4E(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b4C:function b4C(d){this.a=d},
b4D:function b4D(d){this.a=d},
b4F:function b4F(d){this.a=d},
b4H:function b4H(d,e,f){this.a=d
this.b=e
this.c=f},
b4G:function b4G(d,e,f){this.a=d
this.b=e
this.c=f},
b4B:function b4B(){},
cxl(d,e){return new B.lw(d,e)},
Vd:function Vd(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
Jv:function Jv(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
Jx:function Jx(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
Jw:function Jw(d,e){this.a=d
this.b=e},
lw:function lw(d,e){this.a=d
this.b=e},
cjK(d){var x,w=$.cos()
w=A.bJ(d,w,"\u0627")
x=$.cot()
w=A.bJ(w,x,"\u064a")
x=$.coC()
w=A.bJ(w,x,"\u0627")
x=$.cmY()
w=A.bJ(w,x,"\u0627")
x=$.co8()
w=A.bJ(w,x,"\u0621")
x=$.cnL()
w=A.bJ(w,x,"\u0621")
x=$.cmZ()
w=A.bJ(w,x,"\u0627")
x=$.cn4()
w=A.bJ(w,x,"\u0621")
w=A.bJ(w,"\u0649","\u064a")
w=A.bJ(w,"\u0629","\u0647")
x=$.cnN()
w=A.bJ(w,x,"")
x=$.cob()
w=A.bJ(w,x," ")
x=$.cnU()
w=A.bJ(w,x," ")
x=$.c9y()
return C.c.P(A.bJ(w,x," "))},
cC_(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kt(x,w)
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
c3q(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aF("[\u0627\u0621]",!0,!1,!1)
w=A.bJ(d,x,"")
x=A.aF("[\u0627\u0621]",!0,!1,!1)
v=A.bJ(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cC_(d,e)/u
return s>=1?0.99:s},
ED(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tV(d,$.c9y()),w=x.length,v=0;v<x.length;x.length===w||(0,A.M)(x),++v){u=x[v]
if(u.length===0)continue
t=B.cjK(u)
s=A.bJ(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Sk(r.a+" "+u,r.b))}continue}q.push(new B.Sk(u,s))}return q},
cAH(d,e){var x,w,v,u,t=new B.bYU(),s=A.a([],y.s)
for(x=A.fN(e,0,A.iO(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.ca(x,x.gL(0),w.i("ca<aZ.E>")),w=w.i("aZ.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.JK)&&t.$2(d,D.JK)?C.b.k6(d,5):d
return!t.$2(s,D.On)&&t.$2(u,D.On)?C.b.k6(u,4):u},
ciH(d,e){var x=B.ED(d),w=B.cjK(e),v=y.U
v=A.aa(new A.aj(A.a(w.split(" "),y.s),new B.c_Y(),v),v.i("Z.E"))
return new B.I8(x,B.czS(x,B.cAH(v,x)),w)},
czS(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.M)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.cl(x,0,!1,s)
q=A.cl(x,0,!1,y.S)
p=A.cl(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c3q(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c3q(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c3q(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
else m=a2>=0.6?D.uz:D.uA
a1.push(new B.mM(o,x,s,m))
break
case 1:--o
a1.push(new B.mM(o,a4[o],null,D.uB))
break
case 2:--n
a1.push(new B.mM(null,null,a6[n],D.a3P))
break
case 3:--o
a3=n-2
a1.push(new B.mM(o,a4[o],a6[a3]+" "+a6[n-1],D.j1))
n=a3
break
default:x=o-1;--n
a1.push(new B.mM(x,a4[x],a6[n],D.j1))
o-=2
a1.push(new B.mM(o,a4[o],a6[n],D.j1))}}a4=y.e
a4=A.aa(new A.d3(a1,a4),a4.i("aZ.E"))
return a4},
no:function no(d,e){this.a=d
this.b=e},
Sk:function Sk(d,e){this.a=d
this.b=e},
mM:function mM(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
I8:function I8(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aVM:function aVM(d){this.a=d},
aVL:function aVL(){},
bYU:function bYU(){},
c_Y:function c_Y(){},
cpr(d,e,f){return new B.rk(d,e,f)},
cCU(d){var x
A:{if("memorized"===d){x=D.ff
break A}if("learning"===d){x=D.p2
break A}x=D.p1
break A}return x},
ckJ(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cN[d-1].a[1]},
cxm(){var x=y.S
return new B.aiM(A.B(x,y.u),A.aV(x))},
b4K(d){var x=d.fl()
return C.c.dq(C.j.j(A.bq(x)),4,"0")+"-"+C.c.dq(C.j.j(A.bs(x)),2,"0")+"-"+C.c.dq(C.j.j(A.bV(x)),2,"0")},
cfG(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cEj(),x),x.i("aZ.E"))
return B.b4K(A.dm(w[0],w[1],w[2]-1,12,0,0,0))},
c6y(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.B(p,y.u),n=A.aV(p),m=new B.aiM(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcQ(),x=x.ga0(x),w=y.j;x.v();){v=x.gJ()
u=A.dO(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aO(t)>=3){v=C.j.aH(u,1000)
s=C.j.a2(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cN[v-1].a[1])}if(v)continue
v=J.be(t)
r=C.f.c7(A.d8(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rk(D.aKb[r],C.f.c7(A.d8(v.h(t,1))),new A.aW(A.kl(C.f.c7(A.d8(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aA0(q,y.o)
p=A.mg(x,new B.b4J(),x.$ti.i("Z.E"),p)
n.A(0,new A.aj(p,o.ga3x(),A.y(p).i("aj<Z.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aM(d.h(0,"streak"))
p=p==null?null:C.f.c7(p)
p=m.d=p==null?0:p
o=A.aM(d.h(0,"best"))
o=o==null?null:C.f.c7(o)
m.e=o==null?p:o
return m},
azl(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dq(C.j.j(d),3,"0")+C.c.dq(C.j.j(e),3,"0")+".mp3"},
EX:function EX(d,e){this.a=d
this.b=e},
rk:function rk(d,e,f){this.a=d
this.b=e
this.c=f},
aiM:function aiM(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b4L:function b4L(){},
b4M:function b4M(){},
b4J:function b4J(){},
Vb:function Vb(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cuR(){return new B.wK(null)},
cGG(d,e){var x,w,v,u,t={},s=I.cN[e-1].a[1],r=$.Mz().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.r8():v).a===D.ff}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d2(u+4,1,s)
return A.e4(C.cK,new B.c2g(t,s,e),d,!0,null,null,!1,y.l)},
c8k(d){return A.di(0,0,0,0,0,C.j.d2(C.f.am(6+d*1.2),25,90))},
c7f(d){return E.bp(C.j.aH(d,60))+":"+C.c.dq(E.bp(C.j.a2(d,60)),2,"\u0660")},
ckv(d){return A.e4(C.cK,new B.c34($.Mz()),d,!0,null,null,!1,y.H)},
Ms(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl2()
break A}return x},
cI_(d,e,f){var x,w=new B.c3k(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
ckE(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.aq.fz(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.hd:r
q=s.a(J.av(x,"last"))
v=q==null?C.hd:q
u=new B.c3j()
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
H8:function H8(d,e){this.a=d
this.b=e},
Vc:function Vc(d,e,f,g,h){var _=this
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
b4N:function b4N(d){this.a=d},
b4O:function b4O(d){this.a=d},
b4P:function b4P(d){this.a=d},
wK:function wK(d){this.a=d},
a_D:function a_D(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bI1:function bI1(d){this.a=d},
bI0:function bI0(d,e){this.a=d
this.b=e},
bI2:function bI2(d){this.a=d},
bI_:function bI_(d,e){this.a=d
this.b=e},
bI3:function bI3(){},
bHO:function bHO(){},
bHU:function bHU(d,e,f){this.a=d
this.b=e
this.c=f},
bHV:function bHV(){},
bHY:function bHY(d){this.a=d},
bHX:function bHX(){},
bHZ:function bHZ(d){this.a=d},
bHR:function bHR(d,e){this.a=d
this.b=e},
bHS:function bHS(d){this.a=d},
bHQ:function bHQ(){},
bHT:function bHT(d){this.a=d},
bHP:function bHP(d){this.a=d},
bHW:function bHW(d,e){this.a=d
this.b=e},
H9:function H9(d,e,f){this.c=d
this.d=e
this.a=f},
Xt:function Xt(d,e){this.c=d
this.a=e},
c2g:function c2g(d,e,f){this.a=d
this.b=e
this.c=f},
c2d:function c2d(d,e,f){this.a=d
this.b=e
this.c=f},
c2f:function c2f(d,e){this.a=d
this.b=e},
c2c:function c2c(d,e){this.a=d
this.b=e},
c2b:function c2b(d,e){this.a=d
this.b=e},
c2e:function c2e(d,e){this.a=d
this.b=e},
c27:function c27(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c26:function c26(d,e,f){this.a=d
this.b=e
this.c=f},
c28:function c28(d){this.a=d},
c29:function c29(d){this.a=d},
c2a:function c2a(d,e){this.a=d
this.b=e},
DU:function DU(d,e){this.a=d
this.b=e},
CU:function CU(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a24:function a24(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bVf:function bVf(){},
bVv:function bVv(d,e){this.a=d
this.b=e},
bVz:function bVz(d){this.a=d},
bVA:function bVA(d){this.a=d},
bVB:function bVB(d,e,f){this.a=d
this.b=e
this.c=f},
bVD:function bVD(d){this.a=d},
bVE:function bVE(d){this.a=d},
bVC:function bVC(){},
bVG:function bVG(d){this.a=d},
bVF:function bVF(d){this.a=d},
bVH:function bVH(d,e){this.a=d
this.b=e},
bVJ:function bVJ(d){this.a=d},
bVK:function bVK(d){this.a=d},
bVI:function bVI(){},
bVu:function bVu(d,e,f){this.a=d
this.b=e
this.c=f},
bVw:function bVw(d,e,f){this.a=d
this.b=e
this.c=f},
bVn:function bVn(d){this.a=d},
bVo:function bVo(d){this.a=d},
bVm:function bVm(){},
bVp:function bVp(){},
bVq:function bVq(d,e){this.a=d
this.b=e},
bVP:function bVP(d){this.a=d},
bVQ:function bVQ(d){this.a=d},
bVR:function bVR(d,e){this.a=d
this.b=e},
bVO:function bVO(d){this.a=d},
bVS:function bVS(d,e){this.a=d
this.b=e},
bVt:function bVt(){},
bVs:function bVs(d){this.a=d},
bVr:function bVr(d,e){this.a=d
this.b=e},
bVy:function bVy(d){this.a=d},
bVx:function bVx(d){this.a=d},
bVL:function bVL(){},
bVM:function bVM(){},
bVN:function bVN(){},
bVg:function bVg(d,e,f){this.a=d
this.b=e
this.c=f},
bVh:function bVh(d){this.a=d},
bVj:function bVj(){},
bVi:function bVi(){},
bVk:function bVk(d){this.a=d},
bVl:function bVl(d){this.a=d},
Dc:function Dc(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
CT:function CT(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a23:function a23(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bUZ:function bUZ(){},
bV7:function bV7(d,e){this.a=d
this.b=e},
bV8:function bV8(d){this.a=d},
bV6:function bV6(){},
bVa:function bVa(d){this.a=d},
bV9:function bV9(d,e){this.a=d
this.b=e},
bVb:function bVb(d,e){this.a=d
this.b=e},
bV2:function bV2(d,e){this.a=d
this.b=e},
bV3:function bV3(d,e,f){this.a=d
this.b=e
this.c=f},
bV4:function bV4(d,e,f){this.a=d
this.b=e
this.c=f},
bV_:function bV_(d,e,f){this.a=d
this.b=e
this.c=f},
bV0:function bV0(d,e,f){this.a=d
this.b=e
this.c=f},
bV1:function bV1(d,e){this.a=d
this.b=e},
bV5:function bV5(d){this.a=d},
bVc:function bVc(){},
bVd:function bVd(d,e){this.a=d
this.b=e},
bVe:function bVe(d,e){this.a=d
this.b=e},
CS:function CS(d){this.a=d},
a22:function a22(d){this.d=d
this.c=this.a=null},
bUQ:function bUQ(){},
bUX:function bUX(d){this.a=d},
bUY:function bUY(){},
bUW:function bUW(d,e){this.a=d
this.b=e},
bUV:function bUV(d,e,f){this.a=d
this.b=e
this.c=f},
bUU:function bUU(d,e,f){this.a=d
this.b=e
this.c=f},
bUT:function bUT(d){this.a=d},
bUR:function bUR(d){this.a=d},
bUS:function bUS(d){this.a=d},
c34:function c34(d){this.a=d},
c33:function c33(d){this.a=d},
c2Z:function c2Z(d,e){this.a=d
this.b=e},
c30:function c30(){},
c3_:function c3_(){},
c31:function c31(d,e){this.a=d
this.b=e},
c32:function c32(d,e){this.a=d
this.b=e},
aiK:function aiK(d){this.a=d},
b4w:function b4w(d){this.a=d},
c3k:function c3k(){},
c3l:function c3l(){},
CV:function CV(d,e,f){this.c=d
this.d=e
this.a=f},
a25:function a25(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bVT:function bVT(d){this.a=d},
bVU:function bVU(d){this.a=d},
bVV:function bVV(d,e){this.a=d
this.b=e},
bVW:function bVW(d){this.a=d},
bVY:function bVY(d){this.a=d},
bVX:function bVX(d){this.a=d},
c3j:function c3j(){}},D,O,P,I,E,F
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
B.aiL.prototype={
r4(){var x=this,w=x.a
if(w!=null)return A.ee(w,y.m)
w=x.b
return w==null?x.b=new B.b4x(x).$0():w},
um(d,e){return this.aMR(d,e,e)},
aMR(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
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
r=B.cxk(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$um,w)},
oq(d,e){var x=A.ec(d[e])
if(x==null)x=null
return x===!0},
MH(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$MH=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.r4(),$async$MH)
case 7:r=h.cZ(g.cQ(e,"support",null,null,null,null))
q=s.oq(r,"worker")
p=s.oq(r,"wasm")
o=s.oq(r,"mic")
n=s.oq(r,"audio")
s.oq(r,"webgpu")
m=s.oq(r,"secure")
s.oq(r,"ios")
l=A.jI(r.memory)
if(l==null)l=null
if(l==null)l=0
s.oq(r,"isolated")
k=A.jI(r.cores)
if(k!=null)C.f.am(k)
v=new B.Vd(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a3o
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$MH,w)},
El(){var x=0,w=A.j(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$El=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.r4(),$async$El)
case 8:x=7
return A.c(m.eA(l.cZ(k.cQ(e,"storage",null,null,null,null)),y.A),$async$El)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.am(A.dT(r.quota))
p=C.f.am(A.dT(r.usage))
v=new A.asP(q,p)
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
return A.i($async$El,w)},
biL(){var x=y.K
A.Pn(this.r4().bG(new B.b4A(),x),x)},
r3(d,e){var x=A.jI(d[e])
x=x==null?null:C.f.am(x)
return x==null?0:x},
bg7(d,e,f){return this.um(new B.b4z(this,d,e,f),y.C)},
gakf(){var x,w
try{x=A.kc(b.G.sessionStorage)
return x}catch(w){return null}},
garI(){var x=A.ec(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a8P(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.ec(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.garI())return!1
l=A.ec(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cZ(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.a_(x.userAgent)
l=A.jI(x.maxTouchPoints)
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
l=A.jI(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.gakf()
l=l==null?f:A.u(A.cQ(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dO(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.kc(m.localStorage)
m=o
m=m==null?f:A.u(A.cQ(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dO(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
aqf(){var x,w,v,u,t,s,r=null
try{x=this.gakf()
if(x!=null)A.cQ(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cZ(x.location)
u=A.a_(v.hash)
t=A.a_(v.search)
s=A.bB(A.a_(A.cZ(x.document).baseURI),0,r).a1("tutor/").j(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cQ(v,"replace",s+t+x,r,r,r)},
bfR(){var x,w=null,v=b.G,u=A.cZ(v.history),t=A.jI(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cQ(u,"back",w,w,w,w)
else{x=A.a_(A.cZ(v.document).baseURI)
A.cQ(A.cZ(v.location),"replace",A.bB(x,0,w).a1("./").j(0)+"#/",w,w,w)}},
a90(d,e,f,g,h){return this.um(new B.b4E(this,e,d,f,h,g),y.H)},
a93(){return this.um(new B.b4F(this),y.D)},
a3a(){var x=null,w=this.a
if(w!=null)A.cQ(w,"cancelRecording",x,x,x,x)},
alD(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.r3(d,"ms")
w=A.jI(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.Jx(u,x,w,v.r3(d,"frames"),v.r3(d,"tokens"),v.oq(d,"retried"),v.r3(d,"encMs"),v.r3(d,"decMs"),v.r3(d,"featMs"))},
ai0(d){var x={}
x.words=d
return x},
auJ(d,e){return this.um(new B.b4H(this,d,e),y._)},
bkY(d,e){return this.um(new B.b4G(this,d,e),y._)},
KJ(d,e){return this.biR(d,e)},
biR(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$KJ=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.r4(),$async$KJ)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.al(d).i("au<1,o>")
o=A.aa(new A.au(d,new B.b4B(),o),o.i("aZ.E"))
x=11
return A.c(A.eA(A.cZ(A.cQ(r,"play",o,e,null,null)),y.y),$async$KJ)
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
return A.i($async$KJ,w)},
Mo(){var x=null,w=this.a
if(w!=null)A.cQ(w,"stopPlayback",x,x,x,x)},
Jb(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.a_(A.cQ(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bk6(){var x,w,v=null
try{x=this.a
if(x!=null)A.cQ(x,"resetDevice",v,v,v,v)}catch(w){}},
a6s(d){var x=this.a
if(x!=null)A.cQ(x,"prefetch",d,null,null,null)}}
B.Vd.prototype={}
B.Jv.prototype={
gn0(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.Jx.prototype={
gSH(){var x=this,w=C.f.ao(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.Jw.prototype={}
B.lw.prototype={
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
B.no.prototype={
R(){return"WordStatus."+this.b}}
B.Sk.prototype={}
B.mM.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.I8.prototype={
gMm(){var x,w=this,v=w.d
if(v===$){x=new B.aVM(w).$0()
w.d!==$&&A.an()
w.d=x
v=x}return v},
gJu(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.M)(x),++v){u=x[v]
if(u.d===D.a3P&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbgZ(){return J.h8(this.gMm(),new B.aVL()).gL(0)},
gtn(){var x=this.a
return x.length!==0&&this.gbgZ()===x.length&&this.gJu().length===0}}
B.EX.prototype={
R(){return"AyahStatus."+this.b}}
B.rk.prototype={}
B.aiM.prototype={
a63(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.r8():x},
aZv(d){var x=this,w=B.b4K(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cfG(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
apr(){var x=Date.now(),w=B.b4K(new A.aW(x,0,!1))
x=this.c
return x===w||x===B.cfG(w)?this.d:0},
atM(d,e,f,g){var x=this,w=new A.aW(Date.now(),0,!1),v=x.a63(d,e),u=g?C.j.d2(v.b+1,0,100):0,t=g&&u>=f?D.ff:D.p2,s=new B.rk(t,u,w.hd()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.aZv(w)
return s},
a5V(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cN[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.r8():s).a===D.ff)++u}return u},
bfP(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cN[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.r8():s).a===D.p2)++u}return u},
gasQ(){var x=this.a,w=A.y(x).i("cd<2>")
return new A.aj(new A.cd(x,w),new B.b4L(),w.i("aj<Z.E>")).gL(0)},
gayn(){var x=this.a,w=A.y(x).i("bI<1>")
w=A.mg(new A.bI(x,w),new B.b4M(),w.i("Z.E"),y.S)
w=A.eL(w,A.y(w).i("Z.E"))
x=A.aa(w,A.y(w).c)
C.b.mq(x)
return x},
dF(){var x,w,v,u,t,s=this,r=y.N,q=A.B(r,y.L)
for(x=s.a,x=new A.eD(x,A.y(x).i("eD<1,2>")).ga0(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.aa(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
bbK(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b34(x,300,A.y(x).c),x=new A.Jc(J.aD(x.a),x.b,A.y(x).i("Jc<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gJ()
s=C.j.aH(t,1000)
t=C.j.a2(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.r8():q).a===D.ff?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.r8()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.r8():r).c.js()],w,v))}return o},
bgp(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.M)(d),++u){t=d[u]
s=A.ey(t.h(0,"surah"))*1000+A.ey(t.h(0,"ayah"))
r=w.h(0,C.j.aH(s,1000)*1000+C.j.a2(s,1000))
if((r==null?$.r8():r).c.js()===t.h(0,"updated_at"))v.K(0,s)}},
bgx(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aD(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gJ()
if(!u.b(s))continue
r=A.aM(s.h(0,"surah"))
q=r==null?null:C.f.c7(r)
r=A.aM(s.h(0,"ayah"))
p=r==null?null:C.f.c7(r)
o=A.dW(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cN[q-1].a[1])
if(r)continue
n=B.cCU(s.h(0,"status"))
if(n===D.p1)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.aM(s.h(0,"perfect_count"))
l=l==null?null:C.f.c7(l)
v.p(0,r,new B.rk(n,C.j.d2(l==null?0:l,0,100),o.hd()))
w.K(0,r)
t=!0}return t}}
B.Vb.prototype={
IV(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Vb(w,v,u,t,f==null?x.e:f)},
b9Z(d){var x=null
return this.IV(x,x,d,x,x)},
aoX(d){var x=null
return this.IV(x,d,x,x,x)},
ba2(d){var x=null
return this.IV(x,x,x,x,d)},
b9l(d){var x=null
return this.IV(d,x,x,x,x)},
ba_(d){var x=null
return this.IV(x,x,x,d,x)},
dF(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.H8.prototype={
R(){return"ModelState."+this.b}}
B.Vc.prototype={
vC(){var x=this.Q
return x==null?this.Q=new B.b4N(this).$0():x},
qF(d){return this.awB(d)},
awB(d){var x=0,w=A.j(y.H),v=this
var $async$qF=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a3()
x=2
return A.c(A.iP("mt.tutor.settings",C.aq.is(d.dF(),null)),$async$qF)
case 2:return A.h(null,w)}})
return A.i($async$qF,w)},
zG(){var x=0,w=A.j(y.H),v=this,u
var $async$zG=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a3()
x=2
return A.c(A.iP("mt.tutor.progress",C.aq.is(v.c.dF(),null)),$async$zG)
case 2:u=v.as
if(u!=null)u.az()
v.as=A.cL(C.x,v.gaDp())
return A.h(null,w)}})
return A.i($async$zG,w)},
M6(d,e,f){return this.axn(d,e,f)},
axn(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$M6=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.aR(d,e,f)
x=2
return A.c(A.iP("mt.tutor.last",C.aq.is(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$M6)
case 2:return A.h(null,w)}})
return A.i($async$M6,w)},
D5(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$D5=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.Uy||n===D.jS){x=1
break}s.f=D.Uy
s.y=null
s.a3()
u=4
n=A.lx().geP().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lx().geP().h(0,"tutor_threads")
p=A.dO(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bg7(new B.b4O(s),n,p),$async$D5)
case 7:s.x=e
s.f=D.jS
n=A.lx().geP().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.r4().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a8(m)
if(n instanceof B.lw){q=n
s.f=D.aRC
s.y=q
n=A.lx().geP().h(0,"debug")
if(n==="1")A.r4().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a3()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$D5,w)},
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
return A.c(p.aR("quran_tutor_progress").dc("surah, ayah, status, perfect_count, updated_at"),$async$wz)
case 7:o=a1
n=r.c.bgx(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bbK()
if(J.aO(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.mU(h.x,k,k))
x=11
return A.c(f.bku("quran_tutor_save",!1,g,i),$async$wz)
case 11:r.c.bgp(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.iP("mt.tutor.progress",C.aq.is(r.c.dF(),null)),$async$wz)
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
L_(d){return this.bk8(d)},
bk8(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$L_=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c6y(t.c.dF()).dF()
y.f.a(p.h(0,"rows")).ei(0,new B.b4P(d))
t.c=B.c6y(p)
x=2
return A.c(t.zG(),$async$L_)
case 2:v=4
s=$.C().b
s===$&&A.b()
r=s.ga5().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.aA("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$L_)
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
return A.i($async$L_,w)}}
B.wK.prototype={
O(){var x=$.Mz()
return new B.a_D(x,new A.ai(C.O,$.V()))}}
B.a_D.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goC())
w=y.a
x.vC().bG(new B.bI1(v),w)
H.aUe().bG(new B.bI2(v),w).fv(new B.bI3())
A.Pn(H.c5U(),y.y)},
xH(){if(this.c!=null)this.k(new B.bHO())},
m(){var x,w=this
w.d.T(w.goC())
x=w.e
x.q$=$.V()
x.M$=0
w.a_()},
PK(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$PK=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qF(s.b.b9Z(!0)),$async$PK)
case 3:t=s.a
t.biL()
if(t.a8P()){t.aqf()
x=1
break}s.D5()
case 1:return A.h(v,w)}})
return A.i($async$PK,w)},
xI(d,e,f){return this.aXo(d,e,f)},
b55(d){return this.xI(d,null,null)},
aXo(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$xI=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.Z(A.aN(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.W(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cGG(s,d),$async$xI)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.M6(d,t.a,t.b),$async$xI)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aB(A.aA(new B.bHU(u,d,t),null,r),r),$async$xI)
case 8:if(u.c!=null)u.k(new B.bHV())
case 1:return A.h(v,w)}})
return A.i($async$xI,w)},
u(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.garI()&&!A.O(d,!1).v6())u.push(A.bR(x,x,x,x,C.yb,x,x,t.gbfQ(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bR(x,x,x,x,D.atj,x,x,new B.bHY(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bR(x,x,x,x,C.iv,x,x,new B.bHZ(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aFL
else w=t?this.aSf():this.aSR()
return L.xu(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aSR(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a3o
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b5b,C.a3],x)
for(t=0;t<4;++t){s=D.aHQ[t]
u.push(new A.H(C.bs,A.A(A.a([A.b0(s.a,C.am,p,18),C.L,new A.bX(1,C.ad,A.d(s.b,p,p,p,p,G.a0Z,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bvU,C.J,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bp(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aK,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bp(C.f.am(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.J,A.d(q,p,p,p,p,A.bK(p,p,r?D.dW:C.cG,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.J,D.buV],x))
x=A.a([new E.du(u,C.a5,C.aM,p,!0,p),new E.du(A.I(s,C.q,C.d,C.e,0,C.l),C.a5,C.aM,p,!1,p),D.bDY,C.J],x)
if(v!=null)x.push(new E.du(A.d(v,p,p,p,p,D.bg1,p,p,p),C.a5,C.aM,p,!1,p))
else x.push(A.fj(D.aqe,D.blN,this.gaXG(),A.ev(C.v,C.ac,D.b88,p,p,p,p)))
x.push(C.a4)
x.push(D.a3j)
return x},
aSf(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.P(r.a.a),p=q.length===0,o=p?C.rk:H.ckn(q),n=t.z,m=A.R(v.akV(C.dw,E.bp(s.gasQ())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bp(s.apr()),k=s.c,j=Date.now()
k=k===B.b4K(new A.aW(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.H9(t,!1,u),A.A(A.a([m,C.L,A.R(v.akV(C.l4,l+" \u064a\u0648\u0645",k),1)],j),C.i,C.d,C.e,0,u,u),C.t],j)
if(n!=null){t=H.ke(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bp(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bp(m)+"\u2013"+E.bp(l)
k.push(new E.du(A.A(A.a([D.asq,C.Y,A.R(A.I(A.a([D.bhZ,A.d(t+" \u2014 "+m,u,u,u,u,C.bt,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nv],j),C.i,C.d,C.e,0,u,u),C.a5,C.aM,new B.bHR(v,n),!0,u))}t=C.h.ae(0.08)
k.push(A.aH(u,C.y,!1,u,!0,C.m,u,A.aK(),r,u,u,u,u,u,2,A.cO(u,new A.ci(4,A.v(14),C.K),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.u5,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qG,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bHS(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.cR,!0,C.u,u,C.E,u,u,u,u))
k.push(C.t)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.br4)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.M)(o),++x)t.push(v.R0(o[x]))
C.b.A(k,t)}else{t=A.a([D.aUH,D.aVn,v.R0(1)],j)
for(w=114;w>=78;--w)t.push(v.R0(w))
t.push(C.J)
r=v.f
p=A.b0(r?C.xU:C.l3,C.am,u,u)
t.push(A.fX(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.f8,u,u,u),new B.bHT(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.R0(w))
C.b.A(k,t)}k.push(C.a3)
k.push(D.BS)
return k},
akV(d,e,f){var x=null,w=y.p
return new E.du(A.A(A.a([A.b0(d,C.v,x,x),C.L,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bt,x,x,x),A.d(f,1,C.N,x,x,C.a1D,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.i,C.d,C.e,0,x,x),C.a5,C.I,x,!1,x)},
R0(d){var x,w=null,v=this.d.c,u=I.cN[d-1].a[1],t=v.a5V(d),s=t/u,r=y.p,q=A.aq(A.dw(C.P,A.a([A.c4k(C.eQ,G.cL,w,w,w,w,w,3,s,w),A.d(E.bp(d),w,w,w,w,Q.a2_,w,w,w)],r),C.m,C.bj,w),36,36),p=A.d(H.ke(d),w,w,w,w,D.baU,w,w,w)
if(t===0)x=E.bp(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bp(t)+" \u0645\u0646 "+E.bp(u)
r=A.a([q,C.cD,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bK(w,w,t===u?G.cL:C.cG,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bp(C.f.am(s*100))+"\u066a",w,w,w,w,D.a1u,w,w,w))
r.push(D.aqn)
return new E.du(A.A(r,C.i,C.d,C.e,0,w,w),C.pZ,C.cY,new B.bHW(this,d),!1,w)}}
B.H9.prototype={
u(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aUs
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.Ms(x),r,r,r,r,D.B3,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.CV(w,"model load",r))
x.push(C.J)
x.push(new A.zF(C.a49,!1,q.gbg6(),r,r,r,r,C.k,r,!1,r,!0,r,C.ui,r))
return new E.du(A.I(x,C.q,C.d,C.e,0,C.l),C.a5,C.aM,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d2(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bp(C.f.am(u/1e6))+" \u0645\u0646 "+E.bp(C.f.am(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.oy,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.f9(x,A.pZ(C.eQ,C.v,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.J,D.bmC],w))
return new E.du(A.I(x,C.q,C.d,C.e,0,C.l),C.a5,C.aM,r,!1,r)}}}
B.Xt.prototype={
u(d){var x=null,w=D.dW.ae(0.1),v=A.v(14),u=A.aG(D.dW.ae(0.4),1)
return A.D(x,A.A(A.a([D.as4,C.L,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.Ba,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.F(w,x,u,v,x,x,x,C.n),x,x,C.aM,C.ae,x,x,x)}}
B.DU.prototype={
R(){return"_Phase."+this.b}}
B.CU.prototype={
O(){return new B.a24($.Mz(),D.mh)}}
B.a24.prototype={
gja(){var x=this.e
return x===$?this.e=this.a.d:x},
gBE(){var x,w=this.a,v=w.f
w=w.c
x=this.gja()
return H.Mq(w,x,v.xS(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.ac(w.goC())
x.vC()
x.a.a6s(B.azl(w.a.c,w.gja()))},
xH(){if(this.c!=null)this.k(new B.bVf())},
m(){var x,w=this,v=w.d
v.T(w.goC())
x=w.Q
if(x!=null)x.az()
v=v.a
v.Mo()
v.a3a()
w.a_()},
ZU(d){var x,w,v=this
if(v.f===D.uR)v.d.a.a3a()
x=v.d.a
x.Mo()
w=v.Q
if(w!=null)w.az()
v.k(new B.bVv(v,d))
x.a6s(B.azl(v.a.c,d))
w=v.a
if(d<w.e)x.a6s(B.azl(w.c,d+1))},
Ri(d){return this.aTI(d)},
aTI(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$Ri=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.uQ){u.d.a.Mo()
u.k(new B.bVz(u))
x=1
break}t=u.r!=null?D.j8:D.mh
u.k(new B.bVA(u))
s=u.d
r=A.a([B.azl(u.a.c,u.gja())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.KJ(r,q),$async$Ri)
case 3:p=f
if(u.c==null||u.f!==D.uQ){x=1
break}u.k(new B.bVB(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$Ri,w)},
Q8(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Q8=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jS){x=1
break}p=l.a
p.Mo()
r=B.ED(s.gBE()).length
s.k(new B.bVD(s))
o=s.Q
if(o!=null)o.az()
s.Q=A.hx(C.eU,new B.bVE(s))
u=4
o=B.c8k(r)
n=A.di(0,0,0,350*r,0,0)
x=7
return A.c(p.a90(l.b.c,o,n,new B.bVF(s),new B.bVG(s)),$async$Q8)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lw){q=l
l=s.Q
if(l!=null)l.az()
if(s.c!=null)s.k(new B.bVH(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Q8,w)},
Bx(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$Bx=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.uR){x=1
break}m=s.Q
if(m!=null)m.az()
s.k(new B.bVJ(s))
s.Q=A.hx(C.iq,new B.bVK(s))
l=new A.Cm()
$.EG()
l.ol()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a93(),$async$Bx)
case 7:q=e
if(q.b<0.8){s.b54("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.auJ(q,B.ED(s.gBE()).length),$async$Bx)
case 8:p=e
s.ch=A.di(0,0,r.ga4u(),0,0,0)
k=A.lx().geP().h(0,"debug")
if(k==="1"){o=B.ckE(m.Jb())
A.r4().$1("[tutor] "+s.a.c+":"+s.gja()+" audio="+C.f.ao(q.b,1)+"s infer="+p.b+"ms total="+r.gCr()+"ms "+p.gSH()+" text="+p.a)
A.r4().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.ao(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.ao(p.b/1000,2)+" \u062b\n"+p.gSH()+"\n"+A.n(o)+"\n"+p.a}s.af6(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lw){n=m
m=A.lx().geP().h(0,"debug")
if(m==="1")A.r4().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.Jb())
s.a2_(B.Ms(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Bx,w)},
a2_(d,e){var x=this,w=x.Q
if(w!=null)w.az()
if(x.c==null)return
x.k(new B.bVu(x,d,e))},
b54(d){return this.a2_(d,null)},
af6(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.az()
if(s.c==null)return
x=B.ciH(s.gBE(),d)
r.a=null
if(C.c.P(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gja()
t=x.gtn()
r.a=w.atM(v,u,q.b.a,t)
q.zG()}s.k(new B.bVw(r,s,x))},
NL(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$NL=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jS){x=1
break}s.k(new B.bVn(s))
l=s.Q
if(l!=null)l.az()
s.Q=A.hx(C.iq,new B.bVo(s))
k=new A.Cm()
$.EG()
k.ol()
r=k
u=4
l=g.a
x=7
return A.c(l.bkY(B.azl(s.a.c,s.gja()),B.ED(s.gBE()).length),$async$NL)
case 7:q=e
p=B.ckE(l.Jb())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.ao(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.ao(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.ao(r.gCr()/1000,2)+" \u062b)\n"+q.gSH()+"\n"+A.n(p)+"\n"+q.a
A.r4().$1("[tutor-debug] "+s.a.c+":"+s.gja()+" audio="+C.f.ao(q.c,1)+"s infer="+q.b+"ms total="+r.gCr()+"ms "+q.gSH()+" text="+q.a)
A.r4().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.di(0,0,r.ga4u(),0,0,0)
s.af6(q.a)
n=s.r
if(n!=null){l=n.gtn()
j=n.b
i=A.al(j).i("aj<1>")
j=A.aa(new A.aj(j,new B.bVp(),i),i.i("Z.E"))
A.r4().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.k(new B.bVq(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lw){m=l
A.r4().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.Jb())
s.a2_(B.Ms(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$NL,w)},
ga0N(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.r8():v).a!==D.ff)return!1}return!0},
u(d){var x,w=this,v=null,u=w.d,t=u.c.a63(w.a.c,w.gja()),s=u.b,r=s.d&&!w.x&&w.f!==D.j8,q=H.ke(w.a.c),p=y.p,o=A.a([A.bR(v,v,v,v,C.iv,v,v,new B.bVP(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aK6(),m=A.d("\u0622\u064a\u0629 "+E.bp(w.gja()),v,v,v,v,C.m_,v,v,v),l=E.bp(w.gja()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.b1,A.d("("+l+" \u0645\u0646 "+E.bp(k.e-k.d+1)+")",v,v,v,v,F.aK,v,v,v),C.bz,w.aYl(t,s.a)],p),C.i,C.d,C.e,0,v,v),C.t],p)
if(r)s.push(w.aSa())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.uR&&l!==D.oT}else l=!1
if(l)s.push(w.aHN(m))
else s.push(A.d(w.gBE()+" \ufd3f"+E.bp(w.gja())+"\ufd3e",v,v,v,v,D.kf,C.a0,C.bh,v))}s=A.a([new B.H9(u,!0,v),n,C.B,new E.du(A.I(s,C.ag,C.d,C.e,0,C.l),D.aj9,C.aM,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.j8)s.push(w.b6z(n))
if(w.r!=null&&w.f===D.j8&&w.ch!=null){x=C.f.am(C.j.aH(w.ch.a,1000)/100)
s.push(new A.H(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bp(C.j.aH(x,10))+"\u066b"+E.bp(C.j.a2(x,10)))+" \u062b",v,v,v,v,F.aK,C.a0,v,v),v))}n=w.as
if(n!=null)s.push(new A.H(C.aM,A.d(n,v,v,v,v,D.B3,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.CV(n,"check "+w.a.c+":"+w.gja(),v))}s.push(w.aIk())
s.push(C.a3)
s.push(A.ik(C.v,C.I,v,new B.bVQ(w),D.bjE,D.boT,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga0N()
s.push(new E.du(A.A(A.a([D.aoS,C.Y,A.R(A.I(A.a([D.bqt,A.d(w.ga0N()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aK,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nv],p),C.i,C.d,C.e,0,v,v),C.a5,C.aM,new B.bVR(w,d),n,v))}n=A.lx().geP().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dv(D.aqd,D.boi,u.f===D.jS&&w.f!==D.oT?w.gaJ3():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.H(C.ir,A.x5(n,F.aK,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn0()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aK,v,v,v))}p.push(A.bh(D.bpE,v,v,v,new B.bVS(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.BS)
return L.xu(o,s,q)},
aK6(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.aq(A.fx(new B.bVs(this),w,null,C.af,new B.bVt()),36,null)},
aYl(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.ff)return D.b5m
x=d.b
w=E.bp(x)
v=E.bp(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.bV:C.H7
u.push(new A.H(D.ajQ,A.b0(r,s?G.cL:C.eR,q,16),q))}return A.b4i(A.A(u,C.i,C.d,C.M,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aSa(){var x=null
return A.bw(!1,A.v(12),!0,A.D(x,D.afe,C.k,x,x,new A.F(C.pt,x,x,A.v(12),x,x,x,C.n),x,x,x,D.aiI,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bVy(this),x,x,x,x,x,x,x)},
aHN(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gMm(),w)
A:{if(D.j1===v){u=D.kf.cu(G.cL)
break A}if(D.uz===v){u=D.kf.a3O(D.dW,C.i1,D.dW)
break A}if(D.uA===v){u=D.kf.a3O(D.eP,C.i1,D.eP)
break A}u=D.kf.a3O(C.eR,C.kb,C.cg)
break A}t=x[w]
r.push(new A.f0(t.a,s,s,C.by,s,s,s,s,s,s,u))
r.push(P.AV)}x=E.bp(this.gja())
r.push(A.ek(s,s,s,s,s,s,s,s,s,D.kf.cu(C.am),"\ufd3f"+x+"\ufd3e"))
return A.Jd(A.ek(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.a0,C.bh)},
b6z(d){var x,w,v,u,t,s,r=this.w
if(C.c.P(d.c).length===0)return D.bDk
if(d.gtn()){x=r==null
if((x?null:r.a)===D.ff&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.ff?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bp(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.Dc(G.cL,C.bV,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMm()
w=J.dB(x)
v=w.iE(x,new B.bVL()).gL(0)
u=w.iE(x,new B.bVM()).gL(0)
t=w.iE(x,new B.bVN()).gL(0)
x=A.a([],y.s)
if(u>0)x.push(E.bp(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bp(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bp(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJu().length!==0)x.push(E.bp(d.gJu().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eP:D.dW
x=C.b.aE(x," \u2022 ")
s=d.gJu().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aE(d.gJu(),"\u060c "):""
return new B.Dc(w,C.nl,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aIk(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jS,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aH(new A.aW(f,0,!1).dL(w).a,1e6)}v=C.j.aH(B.c8k(B.ED(j.gBE()).length).a,1e6)
f=j.gb3F()
w=96+26*j.y
u=D.eP.ae(0.25)
w=A.iF(i,A.a4R(C.P,A.D(i,D.aqq,C.k,i,i,D.a7a,i,84,i,i,i,i,84),i,C.aT,new A.F(u,i,i,i,i,i,i,C.c_),C.EQ,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cO)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c7f(x)+" / "+B.c7f(v),i,i,i,i,K.ox,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aK,i,i,i),A.bh(D.buU,i,i,i,f,i,i)],y.p),C.i,C.d,C.e,0,C.l)
case 3:t=C.f.ey((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bp(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bp(t)+" \u062b)"
return new A.H(C.pV,A.I(A.a([C.vD,C.a3,D.bn4,A.d(h,i,i,i,i,F.aK,C.a0,i,i)],y.p),C.i,C.d,C.e,0,C.l),i)
default:s=f===D.uQ
r=j.r
f=r==null
w=!f
q=w&&r.gtn()
u=A.b0(s?C.nm:K.Hl,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.ev(i,i,D.b85,i,i,i,i)
u=A.R(new A.zF(C.a49,!0,new B.bVg(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Y4(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.IX[n]
p.push(new A.eh(m,i,A.d("\xd7"+E.bp(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.L,A.oG(new B.bVh(j),p,A.da([h.b.b],o),!1,A.ki(i,i,i,new A.bd(new B.bVi(),l),i,i,i,i,new A.bd(new B.bVj(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cJ),o)],k),C.i,C.d,C.e,0,i,i)
h=g&&!s?j.gb_l():i
u=A.b0(f?D.qu:C.nl,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cE,i,i,i)
p=q?C.il:C.v
h=A.a([o,C.t,A.fj(u,f,h,A.ev(p,q?C.h:C.ac,D.tH,i,i,i,i))],k)
if(w&&j.gja()<j.a.e)C.b.A(h,A.a([C.B,q?A.fj(D.atH,D.btF,new B.bVk(j),A.ev(G.cL,C.ac,D.tH,i,i,i,i)):A.bh(D.bk3,i,i,i,new B.bVl(j),i,i)],k))
if(w){f=j.gja()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.H(C.js,A.d(j.ga0N()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,K.uc,C.a0,i,i),i))
return A.I(h,C.ag,C.d,C.e,0,C.l)}}}
B.Dc.prototype={
u(d){var x=this,w=null,v=x.c,u=v.ae(0.12),t=A.v(14),s=A.aG(v.ae(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b0(x.d,v,w,w),C.L,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bK(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.V,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bM,A.d(x.f,w,w,w,w,C.Ba,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.F(u,w,s,t,w,w,w,C.n),w,w,C.aM,C.ae,w,w,w)}}
B.CT.prototype={
O(){var x=y.S
return new B.a23($.Mz(),A.B(x,y.B),A.aV(x),A.B(x,y.N),A.ee(null,y.H))}}
B.a23.prototype={
W(){this.Y()
this.d.ac(this.goC())},
xH(){if(this.c!=null)this.k(new B.bUZ())},
m(){var x,w=this,v=w.d
v.T(w.goC())
x=w.y
if(x!=null)x.az()
v.a.a3a()
w.a_()},
I_(d){return this.b3r(d)},
b3r(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$I_=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.k(new B.bV7(t,d))
r=t.y
if(r!=null)r.az()
t.y=A.hx(C.eU,new B.bV8(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c8k(B.ED(H.Mq(q,d,p.xS(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.di(0,0,0,350*B.ED(H.Mq(p,d,o.xS(p,d)).b).length,0,0)
x=6
return A.c(r.a.a90(r.b.c,q,p,new B.bV9(t,d),new B.bVa(t)),$async$I_)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lw){s=r
r=t.y
if(r!=null)r.az()
if(t.c!=null)t.k(new B.bVb(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$I_,w)},
Fv(d,e){return this.aLf(d,e)},
aLf(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$Fv=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.az()
s.k(new B.bV2(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a93()
if(e&&n!=null)s.I_(n)
q=null
u=4
x=7
return A.c(r,$async$Fv)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lw){p=o
s.k(new B.bV3(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bG(new B.bV4(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Fv,w)},
gaVR(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aG(x)&&!v.n(0,x)&&!u.aG(x)&&x!==t.e)return x
return null},
b0a(){this.k(new B.bV5(this))},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jS,o=s.e,n=s.gaVR(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("cd<2>")
x=new A.aj(new A.cd(m,l),new B.bVc(),l.i("aj<Z.E>")).gL(0)
l=H.ke(s.a.c)
m=y.p
q=A.a([new B.H9(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bp(s.a.d)+" \u0644\u062d\u062f "+E.bp(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aK,r,r,r),C.t],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b56(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.B3,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.CV(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bp(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aH(new A.aW(v,0,!1).dL(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c7f(v),r,r,r,r,K.ox,C.a0,r,r)
j=A.f9(A.v(6),A.pZ(C.eQ,D.eP,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b0(u?O.He:C.nm,r,r,r)
C.b.A(q,A.a([v,C.J,j,C.t,A.fj(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cE,r,r,r),new B.bVd(s,o),A.ev(C.v,C.ac,D.tH,r,r,r,r))],m))}else if(n!=null){j=p?new B.bVe(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bp(n)
q.push(A.fj(D.ary,A.d(v,r,r,r,r,C.cE,r,r,r),j,A.ev(C.v,C.ac,D.tH,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aUR)
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
C.b.A(q,A.a([new B.Dc(j,v,k,u,r),A.dv(D.atu,D.bui,s.gb09(),r)],m))}q.push(C.t)
q.push(D.BS)
return L.xu(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b56(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.aqV
else if(l.r.n(0,d))x=N.tK
else if(i!=null)x=D.arb
else if(j!=null){w=j.gtn()?C.bV:D.anp
x=A.b0(w,j.gtn()?G.cL:D.dW,k,k)}else x=D.apv
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bp(d),k,k,k,k,D.bfe,k,k,k),C.bz,x],w),C.i,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.a1F,k,k,k))
if(j!=null&&!j.gtn()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMm()
o=J.be(p)
n=o.h(p,r)
A:{if(D.j1===n){m=G.cL
break A}if(D.uz===n){m=D.dW
break A}if(D.uA===n){m=D.eP
break A}m=C.eR
break A}m=D.kf.baE(m,o.h(p,r)===D.uB?C.kb:k,22)
C.b.A(t,A.a([new A.f0(q.a,k,k,C.by,k,k,k,k,k,k,m),P.AV],u))}w=A.a([C.ah,A.Jd(A.ek(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.a0,C.bh)],w)
if(C.c.P(j.c).length===0)w.push(D.bpS)
C.b.A(v,w)}return new E.du(A.I(v,C.ag,C.d,C.e,0,C.l),C.bI,C.cY,k,!1,k)}}
B.CS.prototype={
O(){return new B.a22($.Mz())}}
B.a22.prototype={
W(){this.Y()
var x=this.d
x.ac(this.goC())
x.vC()},
xH(){if(this.c!=null)this.k(new B.bUQ())},
m(){this.d.T(this.goC())
this.a_()},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gayn(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kZ(o,0,new B.bUX(q))
v=C.b.kZ(o,0,new B.bUY())
o=y.p
o=A.a([A.A(A.a([A.R(s.XK(E.bp(q.gasQ()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.L,A.R(s.XK(E.bp(q.apr()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.L,A.R(s.XK(E.bp(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.i,C.d,C.e,0,r,r),C.t,new E.du(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bp(C.f.am(w*100/v))+"\u066a",r,r,r,r,C.bt,r,r,r),C.J,A.f9(A.v(6),A.pZ(C.eQ,G.cL,8,w/v,r),C.aC),C.ah,A.d(E.bp(w)+" \u0645\u0646 "+E.bp(v)+" \u0622\u064a\u0629",r,r,r,r,F.aK,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a5,C.aM,r,!1,r)],o)
if(p.length===0)o.push(D.aV4)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.M)(p),++t)o.push(s.b58(p[t]))
o.push(C.B)
u=$.C().b
u===$&&A.b()
u=u.ga5().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aK,r,r,r))
return L.xu(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
XK(d,e){var x=null
return new E.du(A.I(A.a([A.d(d,x,x,x,x,D.beX,x,x,x),A.d(e,x,x,x,x,C.a2b,C.a0,x,x)],y.p),C.i,C.d,C.e,0,C.l),C.a5,C.I,x,!1,x)},
b58(d){var x=null,w=this.d.c,v=I.cN[d-1].a[1],u=w.a5V(d),t=w.bfP(d),s=y.p,r=A.A(A.a([A.R(A.d(H.ke(d),x,x,x,x,C.bt,x,x,x),1),A.d(E.bp(C.f.am(u*100/v))+"\u066a",x,x,x,x,D.bg2,x,x,x)],s),C.i,C.d,C.e,0,x,x),q=A.f9(A.v(6),A.pZ(C.eQ,G.cL,7,u/v,x),C.aC),p=E.bp(u),o=E.bp(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bp(t):""
return new E.du(A.I(A.a([r,C.J,q,C.ah,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aK,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a5,C.aM,new B.bUW(this,d),!1,x)},
NO(d){return this.aJp(d)},
aJp(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$NO=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cN[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e4(C.cK,new B.bUV(v,d,u),t,!0,null,null,!1,y.H),$async$NO)
case 2:return A.h(null,w)}})
return A.i($async$NO,w)}}
B.aiK.prototype={
Rh(d,e){var x=null,w=A.nh(x,x,x,x,x,x,x,x,x,x,x,D.b7F,C.I,x,x,x,x,C.jR,x,x)
return A.bh(A.d(d,x,x,x,x,C.lZ,x,x,x),x,x,x,new B.b4w(e),x,w)},
u(d){var x=this,w=y.p
return new E.du(A.I(A.a([D.btr,C.J,D.buT,A.d2(C.ax,A.a([x.Rh("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Rh("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aF,0,12),D.bje,x.Rh("tanzil.net","https://tanzil.net"),D.bwu,x.Rh("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a5,C.aM,null,!1,null)}}
B.CV.prototype={
O(){return new B.a25()}}
B.a25.prototype={
galJ(){var x=this.a
return B.cI_(x.c,x.d,$.c8X().Jb())},
Rj(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$Rj=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.k(new B.bVT(s))
v=3
r=A.c2u()
n=s.galJ()
m=y.N
q=A.B(m,m)
J.dX(q,"app","mogtama3y")
J.dX(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dX(q,"ua",m)}x=6
return A.c(A.a9l(n,null,C.FT,q),$async$Rj)
case 6:if(s.c!=null)s.k(new B.bVU(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cn?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.k(new B.bVV(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.k(new B.bVW(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Rj,w)},
u(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bw(!1,t,!0,new A.H(C.pW,A.A(A.a([A.b0(u.d?C.xU:C.l3,C.cg,t,18),C.bL,D.bvF],s),C.i,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bVY(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.D(t,A.x5(u.galJ(),D.bbg,t,C.A),C.k,t,t,new A.F(C.pt,t,t,x,t,t,t,C.n),t,t,D.aiL,C.e9,t,t,1/0))}if(u.f)s.push(D.bjw)
else{x=A.nh(t,t,t,t,t,t,t,t,t,t,t,C.a_Z,C.I,t,t,t,t,C.jR,t,t)
w=u.e
v=w?t:u.gb57()
s.push(A.fX(w?C.a0d:D.asS,D.bsq,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,D.a1F,t,t,t))
return new A.H(C.aM,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["ak<~>()","~()","N(no)","ak<Jx>()","ak<Jv>()","ak<Jw>()","a7<no>()","N(rk)","bD(ox)","CU(t)","CS(t)","N(mM)","CT(t)","N(I8)"])
B.b4x.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.a_(A.cZ(b.G.document).baseURI)
q=A.bB(r,0,null).a1("quran_tutor/tutor.js?v=3").j(0)
x=7
return A.c(A.eA(import(q),y.m),$async$$0)
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
m=B.cxl("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:329}
B.b4A.prototype={
$1(d){var x=null
return A.bYs(A.cQ(d,"persist",x,x,x,x))},
$S:1103}
B.b4z.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.r4(),$async$$0)
case 4:x=3
return A.c(n.eA(m.cZ(l.cQ(e,"loadModel",A.bZa(new B.b4y(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.u(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.u(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.r3(p,"ms")
r=q.oq(p,"cached")
A.u(p.backend)
v=new B.Jv(o,t,s,r,q.r3(p,"threads"),q.oq(p,"isolated"),q.r3(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b4y.prototype={
$2(d,e){this.a.$2(C.f.am(d),C.f.am(e))},
$S:1104}
B.b4E.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.r4(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aH(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aH(v.d.a,1000)
u.onLevel=A.fP(new B.b4C(v.e))
u.onAutoStop=A.fP(new B.b4D(v.f))
x=5
return A.c(A.eA(A.cZ(A.cQ(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b4C.prototype={
$1(d){return this.a.$1(d)},
$S:66}
B.b4D.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b4F.prototype={
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
return A.c(t.r4(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eA(p.cZ(o.cQ(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.Jw(r,A.dT(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b4H.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.r4(),$async$$0)
case 4:x=3
return A.c(q.eA(p.cZ(o.cQ(e,"transcribe",t.audio,t.rate,s.ai0(u.c),null)),y.m),$async$$0)
case 3:v=r.alD(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b4G.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.r4(),$async$$0)
case 4:x=3
return A.c(r.eA(q.cZ(p.cQ(e,"transcribeUrl",u.b,t.ai0(u.c),null,null)),y.m),$async$$0)
case 3:v=s.alD(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b4B.prototype={
$1(d){return d},
$S:37}
B.aVM.prototype={
$0(){var x,w,v,u,t=this.a,s=A.cl(t.a.length,D.uB,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aVL.prototype={
$1(d){return d===D.j1},
$S:z+2}
B.bYU.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c3q(e[x],d[x])<0.75)return!1
return!0},
$S:1105}
B.c_Y.prototype={
$1(d){return d.length!==0},
$S:11}
B.b4L.prototype={
$1(d){return d.a===D.ff},
$S:z+7}
B.b4M.prototype={
$1(d){return C.j.aH(d,1000)},
$S:60}
B.b4J.prototype={
$1(d){return C.f.c7(d)},
$S:1106}
B.b4N.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.jb("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.aq.fz(r,null))
j=A.aM(k.h(0,"n"))
j=j==null?null:C.f.c7(j)
j=C.j.d2(j==null?2:j,1,5)
i=C.b.n(D.IX,k.h(0,"r"))?A.ey(k.h(0,"r")):1
h=A.ec(k.h(0,"auto"))
g=A.ec(k.h(0,"hide"))
k=A.ec(k.h(0,"in"))
s.a.b=new B.Vb(j,i,h!==!1,g===!0,k===!0)}u=2
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
return A.c(A.jb("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.c6y(y.P.a(C.aq.fz(q,null)))
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
return A.c(A.jb("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.aq.fz(p,null))
n=C.f.c7(A.d8(J.av(o,"s")))
m=C.f.c7(A.d8(J.av(o,"f")))
l=C.f.c7(A.d8(J.av(o,"t")))
if(B.ckJ(n,m)&&B.ckJ(n,l)&&m<=l)s.a.z=new A.aR(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a8P()){k.a.aqf()
x=1
break}a1=k
x=18
return A.c(k.a.MH(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a3()
if(k.b.e)k.D5()
k.wz()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:107}
B.b4O.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a3()},
$S:1107}
B.b4P.prototype={
$2(d,e){return C.j.aH(A.ez(A.n(d),null,null),1000)===this.a},
$S:1108}
B.bI1.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.El(),$async$$1)
case 2:t=f
if(u.c!=null)u.k(new B.bI0(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1109}
B.bI0.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bI2.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bI_(x,d))},
$S:z+8}
B.bI_.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bI3.prototype={
$1(d){},
$S:23}
B.bHO.prototype={
$0(){},
$S:0}
B.bHU.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.CU(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bHV.prototype={
$0(){},
$S:0}
B.bHY.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aB(A.aA(new B.bHX(),null,x),x)},
$S:0}
B.bHX.prototype={
$1(d){return D.bxQ},
$S:z+10}
B.bHZ.prototype={
$0(){return B.ckv(this.a)},
$S:0}
B.bHR.prototype={
$0(){var x=this.b
return this.a.xI(x.a,x.b,x.c)},
$S:0}
B.bHS.prototype={
$1(d){return this.a.k(new B.bHQ())},
$S:5}
B.bHQ.prototype={
$0(){},
$S:0}
B.bHT.prototype={
$0(){var x=this.a
return x.k(new B.bHP(x))},
$S:0}
B.bHP.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bHW.prototype={
$0(){return this.a.b55(this.b)},
$S:0}
B.c2g.prototype={
$1(d){return new A.jB(new B.c2d(this.a,this.b,this.c),null)},
$S:57}
B.c2d.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c2f(u,e),s=this.a,r=new B.c2e(s,e),q=A.d(H.ke(this.c),v,v,v,v,C.ot,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bp(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aK,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bp(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bp(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d2(w+4,1,u)))}u=A.a([q,C.ah,p,C.t,A.d2(C.ax,n,C.aF,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c28(s)),C.a09,t.$3("\u0644\u062d\u062f",s.c,new B.c29(s))],o),C.i,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aUW)
u.push(C.a4)
u.push(A.dD(D.bmx,new B.c2a(s,d),A.ev(C.v,C.ac,D.b82,v,v,v,v)))
return A.ct(!0,new A.H(C.Fk,A.I(u,C.ag,C.d,C.M,0,C.l),v),C.I,!0)},
$S:383}
B.c2f.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.i5,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.cg(v,A.d("\u0622\u064a\u0629 "+E.bp(v),u,u,u,u,u,u,u,u),C.au,u,w))
return A.R(A.I(A.a([t,R.FP(C.cK,!0,s,320,new B.c2c(this.b,f),D.bgk,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1111}
B.c2c.prototype={
$1(d){return d==null?null:this.a.$1(new B.c2b(this.b,d))},
$S:50}
B.c2b.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c2e.prototype={
$3(d,e,f){var x=null
return A.c40(x,A.d(d,x,x,x,x,x,x,x,x),new B.c27(this.a,this.b,e,f))},
$S:1112}
B.c27.prototype={
$0(){var x=this
return x.b.$1(new B.c26(x.a,x.c,x.d))},
$S:0}
B.c26.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c28.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c29.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c2a.prototype={
$0(){var x=this.a
return A.O(this.b,!1).aj(new A.W(x.b,x.c))},
$S:0}
B.bVf.prototype={
$0(){},
$S:0}
B.bVv.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mh
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bVz.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.j8:D.mh},
$S:0}
B.bVA.prototype={
$0(){var x=this.a
x.f=D.uQ
x.as=null},
$S:0}
B.bVB.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bVD.prototype={
$0(){var x=this.a
x.f=D.uR
x.as=null
x.y=0
x.z=new A.aW(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bVE.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bVC())},
$S:31}
B.bVC.prototype={
$0(){},
$S:0}
B.bVG.prototype={
$1(d){return this.a.y=d},
$S:66}
B.bVF.prototype={
$1(d){return this.a.Bx()},
$S:5}
B.bVH.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.j8:D.mh
x=this.b
w.as=B.Ms(x)
w.at=x},
$S:0}
B.bVJ.prototype={
$0(){var x=this.a
x.f=D.oT
x.ay=Date.now()},
$S:0}
B.bVK.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bVI())},
$S:31}
B.bVI.prototype={
$0(){},
$S:0}
B.bVu.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.j8:D.mh
x.as=this.b
x.at=this.c},
$S:0}
B.bVw.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.j8
x.x=!1},
$S:0}
B.bVn.prototype={
$0(){var x=this.a
x.f=D.oT
x.ay=Date.now()
x.as=null},
$S:0}
B.bVo.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bVm())},
$S:31}
B.bVm.prototype={
$0(){},
$S:0}
B.bVp.prototype={
$1(d){return d.d!==D.j1},
$S:z+11}
B.bVq.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bVP.prototype={
$0(){return B.ckv(this.a)},
$S:0}
B.bVQ.prototype={
$1(d){var x=this.a.d
return x.qF(x.b.aoX(d))},
$S:3}
B.bVR.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aB(A.aA(new B.bVO(this.a),null,x),x)},
$S:0}
B.bVO.prototype={
$1(d){var x=this.a.a
return new B.CT(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bVS.prototype={
$0(){this.a.d.a.bk6()
this.b.I(y.q).f.Z(D.b95)},
$S:0}
B.bVt.prototype={
$2(d,e){return C.b1},
$S:18}
B.bVs.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a63(s.c,r).a.a){case 2:s=G.cL
break
case 1:s=D.dW
break
case 0:s=C.il
break
default:s=u}x=A.v(18)
w=t.f===D.oT?u:new B.bVr(t,r)
v=s.ae(0.25)
if(r===t.gja())s=C.h
s=A.aG(s,r===t.gja()?2:1)
return A.bw(!1,x,!0,A.D(C.P,A.d(E.bp(r),u,u,u,u,C.a1k,u,u,u),C.k,u,u,new A.F(v,u,s,u,u,u,u,C.c_),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:71}
B.bVr.prototype={
$0(){return this.a.ZU(this.b)},
$S:0}
B.bVy.prototype={
$0(){var x=this.a
return x.k(new B.bVx(x))},
$S:0}
B.bVx.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bVL.prototype={
$1(d){return d===D.uz},
$S:z+2}
B.bVM.prototype={
$1(d){return d===D.uA},
$S:z+2}
B.bVN.prototype={
$1(d){return d===D.uB},
$S:z+2}
B.bVg.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Ri(x)},
$S:0}
B.bVh.prototype={
$1(d){var x=this.a.d
return x.qF(x.b.ba2(d.ga4(d)))},
$S:101}
B.bVj.prototype={
$1(d){return d.n(0,C.T)?C.ac:C.h},
$S:4}
B.bVi.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.bVk.prototype={
$0(){var x=this.a
return x.ZU(x.gja()+1)},
$S:0}
B.bVl.prototype={
$0(){var x=this.a
return x.ZU(x.gja()+1)},
$S:0}
B.bUZ.prototype={
$0(){},
$S:0}
B.bV7.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aW(Date.now(),0,!1)},
$S:0}
B.bV8.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bV6())},
$S:31}
B.bV6.prototype={
$0(){},
$S:0}
B.bVa.prototype={
$1(d){return this.a.x=d},
$S:66}
B.bV9.prototype={
$1(d){return this.a.Fv(this.b,!1)},
$S:5}
B.bVb.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.Ms(x)
w.as=x},
$S:0}
B.bV2.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.bV3.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.Ms(x))
w.as=x},
$S:0}
B.bV4.prototype={
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
return A.c(n.a.auJ(s.b,B.ED(H.Mq(l,m,k.xS(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.ciH(H.Mq(l,m,k.xS(l,m)).b,r.a)
if(C.c.P(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtn()
l.atM(k,m,n.b.a,j)}n.zG()
if(o.c!=null)o.k(new B.bV_(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lw){p=o
o=s.a
if(o.c!=null)o.k(new B.bV0(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.k(new B.bV1(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:135}
B.bV_.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.bV0.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.Ms(w))
x.as=w},
$S:0}
B.bV1.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bV5.prototype={
$0(){var x=this.a
x.f.ar(0)
x.w.ar(0)
x.as=null},
$S:0}
B.bVc.prototype={
$1(d){return d.gtn()},
$S:z+13}
B.bVd.prototype={
$0(){return this.a.Fv(this.b,!0)},
$S:0}
B.bVe.prototype={
$0(){return this.a.I_(this.b)},
$S:0}
B.bUQ.prototype={
$0(){},
$S:0}
B.bUX.prototype={
$2(d,e){return d+this.a.a5V(e)},
$S:102}
B.bUY.prototype={
$2(d,e){return d+I.cN[e-1].a[1]},
$S:102}
B.bUW.prototype={
$0(){return this.a.NO(this.b)},
$S:0}
B.bUV.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.ke(p),q,q,q,q,C.ot,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.ba(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.r8():r).a.a){case 2:r=G.cL.ae(0.35)
break
case 1:r=D.dW.ae(0.35)
break
case 0:r=C.fT
break
default:r=q}m.push(A.D(C.P,A.d(E.bp(t),q,q,q,q,C.ke,q,q,q),C.k,q,q,new A.F(r,q,q,new A.cy(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.ct(!0,new A.H(C.fZ,A.I(A.a([o,C.ah,D.bqM,C.t,new A.dy(D.a72,A.fc(A.d2(C.ax,m,C.aF,6,6),q,C.r,q,q,q,C.w),q),C.a3,A.bh(D.bst,q,q,q,new B.bUU(w,d,p),q,q)],n),C.ag,C.d,C.M,0,C.l),q),C.I,!0)},
$S:36}
B.bUU.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dp(null,null,!0,null,new B.bUT(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.L_(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e5()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.bUT.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.ke(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dx(A.a([A.bh(C.ep,x,x,x,new B.bUR(d),x,x),A.bh(C.oG,x,x,x,new B.bUS(d),x,x)],y.p),w,D.bu0)},
$S:14}
B.bUR.prototype={
$0(){A.O(this.a,!1).aj(!1)
return null},
$S:0}
B.bUS.prototype={
$0(){A.O(this.a,!1).aj(!0)
return null},
$S:0}
B.c34.prototype={
$1(d){var x=this.a
return new A.ku(new B.c33(x),null,x,null)},
$S:1113}
B.c33.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.eh(w,t,A.d(E.bp(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bj9,C.a3,D.bsU,C.J,A.oG(new B.c2Z(s,r),q,A.da([r.a],x),!1,A.ki(t,t,t,new A.bd(new B.c3_(),v),t,t,t,t,new A.bd(new B.c30(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.ik(C.v,C.I,t,new B.c31(s,r),D.bq2,D.bvY,r.c),A.ik(C.v,C.I,t,new B.c32(s,r),t,D.biH,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ah,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn0(),t,t,t,t,F.aK,t,C.bh,t)],u))
x.push(C.B)
x.push(D.a3j)
return A.ct(!0,A.fc(A.I(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.fZ,t,t,C.w),C.I,!0)},
$S:1114}
B.c2Z.prototype={
$1(d){return this.a.qF(this.b.ba_(d.ga4(d)))},
$S:101}
B.c30.prototype={
$1(d){return d.n(0,C.T)?C.ac:C.h},
$S:4}
B.c3_.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.c31.prototype={
$1(d){return this.a.qF(this.b.b9l(d))},
$S:3}
B.c32.prototype={
$1(d){return this.a.qF(this.b.aoX(d))},
$S:3}
B.b4w.prototype={
$0(){return A.cC(A.bB(this.a,0,null),C.aU,null)},
$S:0}
B.c3k.prototype={
$1(d){var x,w=A.aF("https?://",!0,!1,!1)
w=A.bJ(d,w,"")
x=A.aF("www\\.",!0,!1,!1)
return A.uM(A.bJ(w,x,"www[.]"),A.aF("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c3l(),null)},
$S:37}
B.c3l.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:55}
B.bVT.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bVU.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bVV.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bVW.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bVY.prototype={
$0(){var x=this.a
return x.k(new B.bVX(x))},
$S:0}
B.bVX.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c3j.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:162};(function installTearOffs(){var x=a._instance_0u
x(B.aiL.prototype,"gbfQ","bfR",1)
var w
x(w=B.Vc.prototype,"gbg6","D5",0)
x(w,"gaDp","wz",0)
x(w=B.a_D.prototype,"goC","xH",1)
x(w,"gaXG","PK",0)
x(w=B.a24.prototype,"goC","xH",1)
x(w,"gb_l","Q8",0)
x(w,"gb3F","Bx",0)
x(w,"gaJ3","NL",0)
x(w=B.a23.prototype,"goC","xH",1)
x(w,"gb09","b0a",1)
x(B.a22.prototype,"goC","xH",1)
x(B.a25.prototype,"gb57","Rj",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aiL,B.Vd,B.Jv,B.Jx,B.Jw,B.lw,B.Sk,B.mM,B.I8,B.rk,B.aiM,B.Vb])
x(A.l3,[B.b4x,B.b4z,B.b4E,B.b4F,B.b4H,B.b4G,B.aVM,B.b4N,B.bI0,B.bI_,B.bHO,B.bHV,B.bHY,B.bHZ,B.bHR,B.bHQ,B.bHT,B.bHP,B.bHW,B.c2b,B.c27,B.c26,B.c2a,B.bVf,B.bVv,B.bVz,B.bVA,B.bVB,B.bVD,B.bVC,B.bVH,B.bVJ,B.bVI,B.bVu,B.bVw,B.bVn,B.bVm,B.bVq,B.bVP,B.bVR,B.bVS,B.bVr,B.bVy,B.bVx,B.bVg,B.bVk,B.bVl,B.bUZ,B.bV7,B.bV6,B.bVb,B.bV2,B.bV3,B.bV_,B.bV0,B.bV1,B.bV5,B.bVd,B.bVe,B.bUQ,B.bUW,B.bUU,B.bUR,B.bUS,B.b4w,B.bVT,B.bVU,B.bVV,B.bVW,B.bVY,B.bVX])
x(A.iw,[B.b4A,B.b4C,B.b4D,B.b4B,B.aVL,B.c_Y,B.b4L,B.b4M,B.b4J,B.bI1,B.bI2,B.bI3,B.bHU,B.bHX,B.bHS,B.c2g,B.c2f,B.c2c,B.c2e,B.c28,B.c29,B.bVE,B.bVG,B.bVF,B.bVK,B.bVo,B.bVp,B.bVQ,B.bVO,B.bVL,B.bVM,B.bVN,B.bVh,B.bVj,B.bVi,B.bV8,B.bVa,B.bV9,B.bV4,B.bVc,B.bUV,B.bUT,B.c34,B.c2Z,B.c30,B.c3_,B.c31,B.c32,B.c3k,B.c3l,B.c3j])
x(A.nT,[B.b4y,B.bYU,B.b4O,B.b4P,B.c2d,B.bVt,B.bVs,B.bUX,B.bUY,B.c33])
x(A.Dt,[B.no,B.EX,B.H8,B.DU])
w(B.Vc,A.hX)
x(A.K,[B.wK,B.CU,B.CT,B.CS,B.CV])
x(A.L,[B.a_D,B.a24,B.a23,B.a22,B.a25])
x(A.a3,[B.H9,B.Xt,B.Dc,B.aiK])})()
A.pa(b.typeUniverse,JSON.parse('{"lw":{"bO":[]},"CU":{"K":[],"k":[]},"CT":{"K":[],"k":[]},"CS":{"K":[],"k":[]},"CV":{"K":[],"k":[]},"Vc":{"az":[]},"wK":{"K":[],"k":[]},"a_D":{"L":["wK"]},"H9":{"a3":[],"k":[]},"Xt":{"a3":[],"k":[]},"a24":{"L":["CU"]},"Dc":{"a3":[],"k":[]},"a23":{"L":["CT"]},"a22":{"L":["CS"]},"aiK":{"a3":[],"k":[]},"a25":{"L":["CV"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rk"),c:x("eh<x>"),r:x("cg<x>"),k:x("E<mM>"),n:x("E<eh<x>>"),I:x("E<cg<x>>"),R:x("E<hI>"),Z:x("E<aQ<o,@>>"),d:x("E<Sk>"),s:x("E<o>"),p:x("E<k>"),t:x("E<x>"),m:x("bN"),j:x("a7<@>"),L:x("a7<x>"),P:x("aQ<o,@>"),f:x("aQ<@,@>"),x:x("au<o,x>"),a:x("bD"),K:x("a4"),B:x("I8"),l:x("+(x,x)"),e:x("d3<mM>"),N:x("o"),C:x("Jv"),D:x("Jw"),X:x("Vd"),_:x("Jx"),U:x("aj<o>"),G:x("no"),q:x("p7"),b:x("bd<S?>"),y:x("N"),i:x("a2"),z:x("@"),S:x("x"),A:x("bN?"),Y:x("aQ<@,@>?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("ft"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.p1=new B.EX(0,"none")
D.p2=new B.EX(1,"learning")
D.ff=new B.EX(2,"memorized")
D.a72=new A.aB(0,1/0,0,320)
D.eP=new A.S(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a7a=new A.F(D.eP,null,null,null,null,null,null,C.c_)
D.dW=new A.S(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.as8=new A.G(C.Hj,null,C.cg,null,null,null)
D.bu8=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.f8,null,null,null,null,null,null,null,null)
D.bbJ=new A.r(!0,C.eR,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bqO=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bbJ,null,null,null,null,null,null,null,null)
D.aIS=x([D.as8,C.J,D.bu8,D.bqO],y.p)
D.afe=new A.fh(C.w,C.d,C.e,C.i,null,C.l,null,0,D.aIS,null)
D.aiI=new A.X(0,26,0,26)
D.aiL=new A.X(0,4,0,6)
D.aj9=new A.X(14,12,14,14)
D.ajQ=new A.X(3,0,0,0)
D.anp=new A.Q(63251,"MaterialIcons",null,!1)
D.qu=new A.Q(63677,"MaterialIcons",null,!1)
D.aod=new A.Q(983209,"MaterialIcons",null,!1)
D.aoS=new A.G(D.aod,28,C.v,null,null,null)
D.apv=new A.G(C.GX,null,C.il,null,null,null)
D.an8=new A.Q(62961,"MaterialIcons",null,!1)
D.aqd=new A.G(D.an8,null,null,null,null,null)
D.ano=new A.Q(63199,"MaterialIcons",null,!1)
D.aqe=new A.G(D.ano,null,null,null,null,null)
D.aqn=new A.G(C.l2,null,C.eR,null,null,null)
D.aqq=new A.G(C.nm,44,C.h,null,null,null)
D.aqV=new A.G(D.qu,null,D.eP,null,null,null)
D.arb=new A.G(C.nd,null,D.eP,null,null,null)
D.ary=new A.G(D.qu,null,null,null,null,null)
D.as4=new A.G(C.jz,20,D.dW,null,null,null)
D.asq=new A.G(C.nj,30,C.v,null,null,null)
D.asS=new A.G(C.l7,16,C.v,null,null,null)
D.anJ=new A.Q(63520,"MaterialIcons",null,!1)
D.atj=new A.G(D.anJ,null,null,null,null,null)
D.atu=new A.G(C.nl,null,null,null,null,null)
D.an_=new A.Q(62842,"MaterialIcons",null,!0)
D.atH=new A.G(D.an_,null,null,null,null,null)
D.IX=x([1,3,5],y.t)
D.JK=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aVw=new A.H(C.n3,C.mu,null)
D.aFL=x([D.aVw],y.p)
D.aZZ=new A.W(C.nf,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.aZN=new A.W(D.qu,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b_j=new A.W(C.dw,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.anY=new A.Q(63625,"MaterialIcons",null,!1)
D.b_w=new A.W(D.anY,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aHQ=x([D.aZZ,D.aZN,D.b_j,D.b_w],A.ae("E<+(Q,o)>"))
D.aKb=x([D.p1,D.p2,D.ff],A.ae("E<EX>"))
D.On=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aRB=new B.H8(0,"idle")
D.Uy=new B.H8(1,"loading")
D.jS=new B.H8(2,"ready")
D.aRC=new B.H8(3,"failed")
D.aqT=new A.G(C.bV,18,G.cL,null,null,null)
D.bv5=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uc,null,null,null,null,null,null,null,null)
D.aED=x([D.aqT,C.b1,D.bv5],y.p)
D.b5t=new A.eq(C.af,C.d,C.e,C.i,null,C.l,null,0,D.aED,null)
D.aUs=new A.H(C.aM,D.b5t,null)
D.ajO=new A.X(2,6,2,4)
D.bbp=new A.r(!0,C.v,null,null,null,null,14,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bj7=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bbp,null,null,null,null,null,null,null,null)
D.aUH=new A.H(D.ajO,D.bj7,null)
D.bvu=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.f8,null,null,null,null,null,null,null,null)
D.aG4=x([N.tK,C.L,D.bvu],y.p)
D.b5o=new A.eq(C.af,C.cq,C.e,C.i,null,C.l,null,0,D.aG4,null)
D.aUR=new A.H(C.pT,D.b5o,null)
D.Bi=new A.r(!0,D.dW,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bvQ=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Bi,null,null,null,null,null,null,null,null)
D.aUW=new A.H(C.dX,D.bvQ,null)
D.bv0=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aK,C.a0,null,null,null,null,null,null,null)
D.aV4=new A.H(C.C,D.bv0,null)
D.ajL=new A.X(2,0,2,8)
D.br3=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aK,null,null,null,null,null,null,null,null)
D.aVn=new A.H(D.ajL,D.br3,null)
D.at1=new A.G(C.l5,30,C.v,null,null,null)
D.bwv=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Bj,null,null,null,null,null,null,null,null)
D.akV=new A.bX(1,C.ad,D.bwv,null)
D.aGj=x([D.at1,C.Y,D.akV],y.p)
D.b5b=new A.eq(C.af,C.d,C.e,C.i,null,C.l,null,0,D.aGj,null)
D.asC=new A.G(C.dw,18,G.cL,null,null,null)
D.a1u=new A.r(!0,G.cL,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.buJ=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a1u,null,null,null,null,null,null,null,null)
D.aF3=x([D.asC,C.bL,D.buJ],y.p)
D.b5m=new A.eq(C.af,C.d,C.M,C.i,null,C.l,null,0,D.aF3,null)
D.b7F=new A.T(0,30)
D.tH=new A.T(1/0,54)
D.b82=new A.T(1/0,48)
D.b85=new A.T(1/0,50)
D.b88=new A.T(1/0,52)
D.bsD=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.b95=new A.d6(D.bsD,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.baU=new A.r(!0,C.h,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bbg=new A.r(!0,C.am,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.B3=new A.r(!0,D.eP,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.kf=new A.r(!0,C.h,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a1F=new A.r(!0,D.eP,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beX=new A.r(!0,C.v,null,null,null,null,24,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bfe=new A.r(!0,C.v,null,null,null,null,null,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bg1=new A.r(!0,D.dW,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bg2=new A.r(!0,G.cL,null,null,null,null,null,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgk=new A.r(!0,C.h,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhZ=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.i5,null,null,null,null,null,null,null,null)
D.biH=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.cR,null,null,null,null,null,null,null,null)
D.bj9=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.ot,null,null,null,null,null,null,null,null)
D.bje=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aK,null,null,null,null,null,null,null,null)
D.bcA=new A.r(!0,G.cL,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjw=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bcA,null,null,null,null,null,null,null,null)
D.bjE=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aK,null,null,null,null,null,null,null,null)
D.bk3=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.f8,null,null,null,null,null,null,null,null)
D.blN=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cE,null,null,null,null,null,null,null,null)
D.bmx=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bP,null,null,null,null,null,null,null,null)
D.bmC=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aK,null,null,null,null,null,null,null,null)
D.bn4=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.Bn,null,null,null,null,null,null,null,null)
D.boi=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.boT=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.ox,null,null,null,null,null,null,null,null)
D.bpE=new A.m("reset safe mode / WebGPU ban",null,O.a10,null,null,null,null,null,null,null,null)
D.bpS=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Bi,null,null,null,null,null,null,null,null)
D.bq2=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aK,null,null,null,null,null,null,null,null)
D.bqt=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bt,null,null,null,null,null,null,null,null)
D.bqM=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.br4=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.bsq=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a24,null,null,null,null,null,null,null,null)
D.bec=new A.r(!0,D.eP,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bst=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bec,null,null,null,null,null,null,null,null)
D.bsU=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.ox,null,null,null,null,null,null,null,null)
D.btr=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0U,null,null,null,null,null,null,null,null)
D.btF=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cE,null,null,null,null,null,null,null,null)
D.bu0=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bui=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.buT=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aK,null,null,null,null,null,null,null,null)
D.buU=new A.m("\u062e\u0644\u0635\u062a",null,C.m_,null,null,null,null,null,null,null,null)
D.buV=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Bi,null,null,null,null,null,null,null,null)
D.bfg=new A.r(!0,C.cG,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.i1,null,null,null,null,null,null,null,null)
D.bvF=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bfg,null,null,null,null,null,null,null,null)
D.bvU=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bt,null,null,null,null,null,null,null,null)
D.bvY=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.cR,null,null,null,null,null,null,null,null)
D.bwu=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aK,null,null,null,null,null,null,null,null)
D.a3j=new B.aiK(null)
D.bxQ=new B.CS(null)
D.bxR=new B.Vb(2,1,!0,!1,!1)
D.a3o=new B.Vd(!1,!1,!1,!1,!1,0)
D.j1=new B.no(0,"ok")
D.uz=new B.no(1,"near")
D.uA=new B.no(2,"wrong")
D.uB=new B.no(3,"missing")
D.a3P=new B.no(4,"extra")
D.anE=new A.Q(63456,"MaterialIcons",null,!1)
D.bDk=new B.Dc(D.dW,D.anE,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bDY=new B.Xt(!1,null)
D.BS=new B.Xt(!0,null)
D.mh=new B.DU(0,"idle")
D.uQ=new B.DU(1,"playing")
D.uR=new B.DU(2,"recording")
D.oT=new B.DU(3,"thinking")
D.j8=new B.DU(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cKY","c8X",()=>new B.aiL())
x($,"cOo","cos",()=>A.aF("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cOp","cot",()=>A.aF("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cOB","coC",()=>A.aF("\u0648\u0670",!0,!1,!1))
x($,"cNX","co8",()=>A.aF("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cMe","cmY",()=>A.aF("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cNt","cnL",()=>A.aF("[\u0654\u0655]",!0,!1,!1))
x($,"cMf","cmZ",()=>A.aF("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cMm","cn4",()=>A.aF("[\u0624\u0626]",!0,!1,!1))
x($,"cNv","cnN",()=>A.aF("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cO1","cob",()=>A.aF("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cND","cnU",()=>A.aF("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cOm","c9y",()=>A.aF("\\s+",!0,!1,!1))
x($,"cIg","r8",()=>B.cpr(D.p1,0,A.c4z(0,!0)))
x($,"cKZ","Mz",()=>new B.Vc($.c8X(),D.bxR,B.cxm(),D.aRB,$.V()))})()};
(a=>{a["ipJ7Yhdv7AFFNetA7b3kcbfZRxA="]=a.current})($__dart_deferred_initializers__);