((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,P,H,G,N,Q,K,B={
cDX(d){var x,w,v,u,t,s
if(d instanceof B.lL)return d
try{x=A.cU(d)
w=x.code
v=x.message
u=w==null?"failed":A.S(w)
t=v==null?"":A.S(v)
return new B.lL(u,t)}catch(s){u=A.n(d)
return new B.lL("failed",u)}},
akv:function akv(){this.b=this.a=null},
b7v:function b7v(d){this.a=d},
b7y:function b7y(){},
b7x:function b7x(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b7w:function b7w(d){this.a=d},
b7C:function b7C(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b7A:function b7A(d){this.a=d},
b7B:function b7B(d){this.a=d},
b7D:function b7D(d){this.a=d},
b7F:function b7F(d,e,f){this.a=d
this.b=e
this.c=f},
b7E:function b7E(d,e,f){this.a=d
this.b=e
this.c=f},
b7z:function b7z(){},
cDY(d,e){return new B.lL(d,e)},
Wk:function Wk(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
Ko:function Ko(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
Kq:function Kq(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
Kp:function Kp(d,e){this.a=d
this.b=e},
lL:function lL(d,e){this.a=d
this.b=e},
cpZ(d){var x,w=$.cuI()
w=A.bJ(d,w,"\u0627")
x=$.cuJ()
w=A.bJ(w,x,"\u064a")
x=$.cuS()
w=A.bJ(w,x,"\u0627")
x=$.ctd()
w=A.bJ(w,x,"\u0627")
x=$.cuo()
w=A.bJ(w,x,"\u0621")
x=$.cu0()
w=A.bJ(w,x,"\u0621")
x=$.cte()
w=A.bJ(w,x,"\u0627")
x=$.ctk()
w=A.bJ(w,x,"\u0621")
w=A.bJ(w,"\u0649","\u064a")
w=A.bJ(w,"\u0629","\u0647")
x=$.cu2()
w=A.bJ(w,x,"")
x=$.cur()
w=A.bJ(w,x," ")
x=$.cu9()
w=A.bJ(w,x," ")
x=$.cfB()
return C.c.O(A.bJ(w,x," "))},
cIG(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.k8(x,w)
for(u=0;u<x;++u)v[u]=u
t=A.c8(x,0,!1,w)
for(s=1;s<=l;++s,r=t,t=v,v=r){t[0]=s
for(w=s-1,u=1;u<=k;++u){q=u-1
p=d.charCodeAt(w)===e.charCodeAt(q)?0:1
o=v[u]+1
n=t[q]+1
m=v[q]+p
if(o<n)q=o<m?o:m
else q=n<m?n:m
t[u]=q}}return v[k]},
c9l(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aE("[\u0627\u0621]",!0,!1,!1)
w=A.bJ(d,x,"")
x=A.aE("[\u0627\u0621]",!0,!1,!1)
v=A.bJ(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cIG(d,e)/u
return s>=1?0.99:s},
Fr(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.ua(d,$.cfB()),w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.length===0)continue
t=B.cpZ(u)
s=A.bJ(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Tp(r.a+" "+u,r.b))}continue}q.push(new B.Tp(u,s))}return q},
cHl(d,e){var x,w,v,u,t=new B.c36(),s=A.a([],y.s)
for(x=A.ff(e,0,A.ip(5,"count",y.S),A.aj(e).c),w=x.$ti,x=new A.cd(x,x.gM(0),w.i("cd<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.KE)&&t.$2(d,D.KE)?C.b.jB(d,5):d
return!t.$2(s,D.Pi)&&t.$2(u,D.Pi)?C.b.jB(u,4):u},
coU(d,e){var x=B.Fr(d),w=B.cpZ(e),v=y.U
v=A.a9(new A.ah(A.a(w.split(" "),y.s),new B.c5d(),v),v.i("X.E"))
return new B.J1(x,B.cGw(x,B.cHl(v,x)),w)},
cGw(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.K)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.c8(x,0,!1,s)
q=A.c8(x,0,!1,y.S)
p=A.c8(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c9l(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c9l(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c9l(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.j7
else m=a2>=0.6?D.v_:D.v0
a1.push(new B.n4(o,x,s,m))
break
case 1:--o
a1.push(new B.n4(o,a4[o],null,D.v1))
break
case 2:--n
a1.push(new B.n4(null,null,a6[n],D.a4H))
break
case 3:--o
a3=n-2
a1.push(new B.n4(o,a4[o],a6[a3]+" "+a6[n-1],D.j7))
n=a3
break
default:x=o-1;--n
a1.push(new B.n4(x,a4[x],a6[n],D.j7))
o-=2
a1.push(new B.n4(o,a4[o],a6[n],D.j7))}}a4=y.e
a4=A.a9(new A.d5(a1,a4),a4.i("aW.E"))
return a4},
nM:function nM(d,e){this.a=d
this.b=e},
Tp:function Tp(d,e){this.a=d
this.b=e},
n4:function n4(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
J1:function J1(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aYu:function aYu(d){this.a=d},
aYt:function aYt(){},
c36:function c36(){},
c5d:function c5d(){},
cvJ(d,e,f){return new B.rE(d,e,f)},
cJB(d){var x
A:{if("memorized"===d){x=D.fm
break A}if("learning"===d){x=D.pn
break A}x=D.pm
break A}return x},
cqZ(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cW[d-1].a[1]},
cDZ(){var x=y.S
return new B.akw(A.C(x,y.u),A.aT(x))},
b7I(d){var x=d.f0()
return C.c.dt(C.j.k(A.br(x)),4,"0")+"-"+C.c.dt(C.j.k(A.bt(x)),2,"0")+"-"+C.c.dt(C.j.k(A.bY(x)),2,"0")},
clN(d){var x=y.x,w=A.a9(new A.au(A.a(d.split("-"),y.s),A.cL1(),x),x.i("aW.E"))
return B.b7I(A.dx(w[0],w[1],w[2]-1,12,0,0,0))},
ccz(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.C(p,y.u),n=A.aT(p),m=new B.akw(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcP(),x=x.ga_(x),w=y.j;x.v();){v=x.gG()
u=A.dW(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aN(t)>=3){v=C.j.aI(u,1000)
s=C.j.a3(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cW[v-1].a[1])}if(v)continue
v=J.bc(t)
r=C.f.bB(A.cS(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rE(D.aMg[r],C.f.bB(A.cS(v.h(t,1))),new A.aO(A.kB(C.f.bB(A.cS(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aBW(q,y.o)
p=A.my(x,new B.b7H(),x.$ti.i("X.E"),p)
n.A(0,new A.ah(p,o.ga4s(),A.y(p).i("ah<X.E>")))}m.c=A.q(d.h(0,"last"))
p=A.ar(d.h(0,"streak"))
p=p==null?null:C.f.bB(p)
p=m.d=p==null?0:p
o=A.ar(d.h(0,"best"))
o=o==null?null:C.f.bB(o)
m.e=o==null?p:o
return m},
aBc(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dt(C.j.k(d),3,"0")+C.c.dt(C.j.k(e),3,"0")+".mp3"},
FM:function FM(d,e){this.a=d
this.b=e},
rE:function rE(d,e,f){this.a=d
this.b=e
this.c=f},
akw:function akw(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b7J:function b7J(){},
b7K:function b7K(){},
b7H:function b7H(){},
Wi:function Wi(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cBp(){return new B.x7(null)},
cNs(d,e){var x,w,v,u,t={},s=I.cW[e-1].a[1],r=$.Nv().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.rt():v).a===D.fm}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d1(u+4,1,s)
return A.e2(C.cT,new B.c7Z(t,s,e),d,!0,null,null,!1,y.l)},
cen(d){return A.ds(0,0,0,0,0,C.j.d1(C.f.ak(6+d*1.2),25,90))},
cdh(d){return E.bq(C.j.aI(d,60))+":"+C.c.dt(E.bq(C.j.a3(d,60)),2,"\u0660")},
cqL(d){return A.e2(C.cT,new B.c8W($.Nv()),d,!0,null,null,!1,y.H)},
No(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl8()
break A}return x},
cOO(d,e,f){var x,w=new B.c9e(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
cqU(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.ap.f3(a4,null))
s=y.Y
r=s.a(J.as(x,"rec"))
w=r==null?C.cN:r
q=s.a(J.as(x,"last"))
v=q==null?C.cN:q
u=new B.c9d()
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
a0=J.aN(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.f(J.as(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.f(J.as(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
HZ:function HZ(d,e){this.a=d
this.b=e},
Wj:function Wj(d,e,f,g,h){var _=this
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
b7L:function b7L(d){this.a=d},
b7M:function b7M(d){this.a=d},
b7N:function b7N(d){this.a=d},
x7:function x7(d){this.a=d},
a0T:function a0T(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bMO:function bMO(d){this.a=d},
bMN:function bMN(d,e){this.a=d
this.b=e},
bMP:function bMP(d){this.a=d},
bMM:function bMM(d,e){this.a=d
this.b=e},
bMQ:function bMQ(){},
bMA:function bMA(){},
bMG:function bMG(d,e,f){this.a=d
this.b=e
this.c=f},
bMH:function bMH(){},
bMK:function bMK(d){this.a=d},
bMJ:function bMJ(){},
bML:function bML(d){this.a=d},
bMD:function bMD(d,e){this.a=d
this.b=e},
bME:function bME(d){this.a=d},
bMC:function bMC(){},
bMF:function bMF(d){this.a=d},
bMB:function bMB(d){this.a=d},
bMI:function bMI(d,e){this.a=d
this.b=e},
I_:function I_(d,e,f){this.c=d
this.d=e
this.a=f},
YF:function YF(d,e){this.c=d
this.a=e},
c7Z:function c7Z(d,e,f){this.a=d
this.b=e
this.c=f},
c7W:function c7W(d,e,f){this.a=d
this.b=e
this.c=f},
c7Y:function c7Y(d,e){this.a=d
this.b=e},
c7V:function c7V(d,e){this.a=d
this.b=e},
c7U:function c7U(d,e){this.a=d
this.b=e},
c7X:function c7X(d,e){this.a=d
this.b=e},
c7Q:function c7Q(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c7P:function c7P(d,e,f){this.a=d
this.b=e
this.c=f},
c7R:function c7R(d){this.a=d},
c7S:function c7S(d){this.a=d},
c7T:function c7T(d,e){this.a=d
this.b=e},
EI:function EI(d,e){this.a=d
this.b=e},
DF:function DF(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a3r:function a3r(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
c_r:function c_r(){},
c_H:function c_H(d,e){this.a=d
this.b=e},
c_L:function c_L(d){this.a=d},
c_M:function c_M(d){this.a=d},
c_N:function c_N(d,e,f){this.a=d
this.b=e
this.c=f},
c_P:function c_P(d){this.a=d},
c_Q:function c_Q(d){this.a=d},
c_O:function c_O(){},
c_S:function c_S(d){this.a=d},
c_R:function c_R(d){this.a=d},
c_T:function c_T(d,e){this.a=d
this.b=e},
c_V:function c_V(d){this.a=d},
c_W:function c_W(d){this.a=d},
c_U:function c_U(){},
c_G:function c_G(d,e,f){this.a=d
this.b=e
this.c=f},
c_I:function c_I(d,e,f){this.a=d
this.b=e
this.c=f},
c_z:function c_z(d){this.a=d},
c_A:function c_A(d){this.a=d},
c_y:function c_y(){},
c_B:function c_B(){},
c_C:function c_C(d,e){this.a=d
this.b=e},
c00:function c00(d){this.a=d},
c01:function c01(d){this.a=d},
c02:function c02(d,e){this.a=d
this.b=e},
c0_:function c0_(d){this.a=d},
c03:function c03(d,e){this.a=d
this.b=e},
c_F:function c_F(){},
c_E:function c_E(d){this.a=d},
c_D:function c_D(d,e){this.a=d
this.b=e},
c_K:function c_K(d){this.a=d},
c_J:function c_J(d){this.a=d},
c_X:function c_X(){},
c_Y:function c_Y(){},
c_Z:function c_Z(){},
c_s:function c_s(d,e,f){this.a=d
this.b=e
this.c=f},
c_t:function c_t(d){this.a=d},
c_v:function c_v(){},
c_u:function c_u(){},
c_w:function c_w(d){this.a=d},
c_x:function c_x(d){this.a=d},
DY:function DY(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
DE:function DE(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a3q:function a3q(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
c_a:function c_a(){},
c_j:function c_j(d,e){this.a=d
this.b=e},
c_k:function c_k(d){this.a=d},
c_i:function c_i(){},
c_m:function c_m(d){this.a=d},
c_l:function c_l(d,e){this.a=d
this.b=e},
c_n:function c_n(d,e){this.a=d
this.b=e},
c_e:function c_e(d,e){this.a=d
this.b=e},
c_f:function c_f(d,e,f){this.a=d
this.b=e
this.c=f},
c_g:function c_g(d,e,f){this.a=d
this.b=e
this.c=f},
c_b:function c_b(d,e,f){this.a=d
this.b=e
this.c=f},
c_c:function c_c(d,e,f){this.a=d
this.b=e
this.c=f},
c_d:function c_d(d,e){this.a=d
this.b=e},
c_h:function c_h(d){this.a=d},
c_o:function c_o(){},
c_p:function c_p(d,e){this.a=d
this.b=e},
c_q:function c_q(d,e){this.a=d
this.b=e},
DD:function DD(d){this.a=d},
a3p:function a3p(d){this.d=d
this.c=this.a=null},
c_1:function c_1(){},
c_8:function c_8(d){this.a=d},
c_9:function c_9(){},
c_7:function c_7(d,e){this.a=d
this.b=e},
c_6:function c_6(d,e,f){this.a=d
this.b=e
this.c=f},
c_5:function c_5(d,e,f){this.a=d
this.b=e
this.c=f},
c_4:function c_4(d){this.a=d},
c_2:function c_2(d){this.a=d},
c_3:function c_3(d){this.a=d},
c8W:function c8W(d){this.a=d},
c8V:function c8V(d){this.a=d},
c8Q:function c8Q(d,e){this.a=d
this.b=e},
c8S:function c8S(){},
c8R:function c8R(){},
c8T:function c8T(d,e){this.a=d
this.b=e},
c8U:function c8U(d,e){this.a=d
this.b=e},
aku:function aku(d){this.a=d},
b7u:function b7u(d){this.a=d},
c9e:function c9e(){},
c9f:function c9f(){},
DG:function DG(d,e,f){this.c=d
this.d=e
this.a=f},
a3s:function a3s(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
c04:function c04(d){this.a=d},
c05:function c05(d){this.a=d},
c06:function c06(d,e){this.a=d
this.b=e},
c07:function c07(d){this.a=d},
c09:function c09(d){this.a=d},
c08:function c08(d){this.a=d},
c9d:function c9d(){}},D,R,O,I,E,F
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
B.akv.prototype={
rh(){var x=this,w=x.a
if(w!=null)return A.eq(w,y.m)
w=x.b
return w==null?x.b=new B.b7v(x).$0():w},
uD(d,e){return this.aOK(d,e,e)},
aOK(d,e,f){var x=0,w=A.k(f),v,u=2,t=[],s,r,q,p
var $async$uD=A.e(function(g,h){if(g===1){t.push(h)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(d.$0(),$async$uD)
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
r=B.cDX(s)
throw A.t(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$uD,w)},
ou(d,e){var x=A.en(d[e])
if(x==null)x=null
return x===!0},
N9(){var x=0,w=A.k(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$N9=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.rh(),$async$N9)
case 7:r=h.cU(g.cP(e,"support",null,null,null,null))
q=s.ou(r,"worker")
p=s.ou(r,"wasm")
o=s.ou(r,"mic")
n=s.ou(r,"audio")
s.ou(r,"webgpu")
m=s.ou(r,"secure")
s.ou(r,"ios")
l=A.jV(r.memory)
if(l==null)l=null
if(l==null)l=0
s.ou(r,"isolated")
k=A.jV(r.cores)
if(k!=null)C.f.ak(k)
v=new B.Wk(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a4g
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$N9,w)},
EJ(){var x=0,w=A.k(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$EJ=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.rh(),$async$EJ)
case 8:x=7
return A.c(m.eH(l.cU(k.cP(e,"storage",null,null,null,null)),y.A),$async$EJ)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.ak(A.dU(r.quota))
p=C.f.ak(A.dU(r.usage))
v=new A.auD(q,p)
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
return A.j($async$EJ,w)},
blh(){var x=y.K
A.Ql(this.rh().bJ(new B.b7y(),x),x)},
rg(d,e){var x=A.jV(d[e])
x=x==null?null:C.f.ak(x)
return x==null?0:x},
biF(d,e,f){return this.uD(new B.b7x(this,d,e,f),y.C)},
galv(){var x,w
try{x=A.ks(b.G.sessionStorage)
return x}catch(w){return null}},
gat5(){var x=A.en(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a9K(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.en(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gat5())return!1
l=A.en(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cU(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.S(x.userAgent)
l=A.jV(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.q(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aE("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.f(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aE("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.jV(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.galv()
l=l==null?f:A.q(A.cP(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dW(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.ks(m.localStorage)
m=o
m=m==null?f:A.q(A.cP(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dW(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
arC(){var x,w,v,u,t,s,r=null
try{x=this.galv()
if(x!=null)A.cP(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cU(x.location)
u=A.S(v.hash)
t=A.S(v.search)
s=A.bx(A.S(A.cU(x.document).baseURI),0,r).a2("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cP(v,"replace",s+t+x,r,r,r)},
bin(){var x,w=null,v=b.G,u=A.cU(v.history),t=A.jV(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cP(u,"back",w,w,w,w)
else{x=A.S(A.cU(v.document).baseURI)
A.cP(A.cU(v.location),"replace",A.bx(x,0,w).a2("./").k(0)+"#/",w,w,w)}},
a9W(d,e,f,g,h){return this.uD(new B.b7C(this,e,d,f,h,g),y.H)},
aa_(){return this.uD(new B.b7D(this),y.D)},
a45(){var x=null,w=this.a
if(w!=null)A.cP(w,"cancelRecording",x,x,x,x)},
amU(d){var x,w,v=this,u=A.q(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.rg(d,"ms")
w=A.jV(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.Kq(u,x,w,v.rg(d,"frames"),v.rg(d,"tokens"),v.ou(d,"retried"),v.rg(d,"encMs"),v.rg(d,"decMs"),v.rg(d,"featMs"))},
aje(d){var x={}
x.words=d
return x},
awc(d,e){return this.uD(new B.b7F(this,d,e),y._)},
bnt(d,e){return this.uD(new B.b7E(this,d,e),y._)},
Ld(d,e){return this.bln(d,e)},
bln(d,e){var x=0,w=A.k(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Ld=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.rh(),$async$Ld)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.aj(d).i("au<1,o>")
o=A.a9(new A.au(d,new B.b7z(),o),o.i("aW.E"))
x=11
return A.c(A.eH(A.cU(A.cP(r,"play",o,e,null,null)),y.y),$async$Ld)
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
return A.j($async$Ld,w)},
MR(){var x=null,w=this.a
if(w!=null)A.cP(w,"stopPlayback",x,x,x,x)},
JH(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.S(A.cP(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bmD(){var x,w,v=null
try{x=this.a
if(x!=null)A.cP(x,"resetDevice",v,v,v,v)}catch(w){}},
a7l(d){var x=this.a
if(x!=null)A.cP(x,"prefetch",d,null,null,null)}}
B.Wk.prototype={}
B.Ko.prototype={
gn6(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.Kq.prototype={
gTl(){var x=this,w=C.f.aA(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.Kp.prototype={}
B.lL.prototype={
gl8(){var x,w=this.a
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
$ibK:1}
B.nM.prototype={
S(){return"WordStatus."+this.b}}
B.Tp.prototype={}
B.n4.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.J1.prototype={
gMP(){var x,w=this,v=w.d
if(v===$){x=new B.aYu(w).$0()
w.d!==$&&A.aq()
w.d=x
v=x}return v},
gK0(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.d===D.a4H&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbjw(){return J.h8(this.gMP(),new B.aYt()).gM(0)},
gtE(){var x=this.a
return x.length!==0&&this.gbjw()===x.length&&this.gK0().length===0}}
B.FM.prototype={
S(){return"AyahStatus."+this.b}}
B.rE.prototype={}
B.akw.prototype={
a6X(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.rt():x},
b0D(d){var x=this,w=B.b7I(d),v=x.c
if(v===w)return
v=v!=null&&v===B.clN(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
aqM(){var x=Date.now(),w=B.b7I(new A.aO(x,0,!1))
x=this.c
return x===w||x===B.clN(w)?this.d:0},
avc(d,e,f,g){var x=this,w=new A.aO(Date.now(),0,!1),v=x.a6X(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.fm:D.pn,s=new B.rE(t,u,w.h6()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.b0D(w)
return s},
a6P(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cW[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rt():s).a===D.fm)++u}return u},
bil(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cW[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rt():s).a===D.pn)++u}return u},
gauc(){var x=this.a,w=A.y(x).i("c2<2>")
return new A.ah(new A.c2(x,w),new B.b7J(),w.i("ah<X.E>")).gM(0)},
gazQ(){var x=this.a,w=A.y(x).i("bM<1>")
w=A.my(new A.bM(x,w),new B.b7K(),w.i("X.E"),y.S)
w=A.eT(w,A.y(w).i("X.E"))
x=A.a9(w,A.y(w).c)
C.b.lG(x)
return x},
du(){var x,w,v,u,t,s=this,r=y.N,q=A.C(r,y.L)
for(x=s.a,x=new A.eA(x,A.y(x).i("eA<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.a9(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
bed(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b64(x,300,A.y(x).c),x=new A.K5(J.av(x.a),x.b,A.y(x).i("K5<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gG()
s=C.j.aI(t,1000)
t=C.j.a3(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.rt():q).a===D.fm?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.rt()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.rt():r).c.iG()],w,v))}return o},
biX(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.K)(d),++u){t=d[u]
s=A.ex(t.h(0,"surah"))*1000+A.ex(t.h(0,"ayah"))
r=w.h(0,C.j.aI(s,1000)*1000+C.j.a3(s,1000))
if((r==null?$.rt():r).c.iG()===t.h(0,"updated_at"))v.K(0,s)}},
bj4(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.av(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gG()
if(!u.b(s))continue
r=A.ar(s.h(0,"surah"))
q=r==null?null:C.f.bB(r)
r=A.ar(s.h(0,"ayah"))
p=r==null?null:C.f.bB(r)
o=A.dJ(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cW[q-1].a[1])
if(r)continue
n=B.cJB(s.h(0,"status"))
if(n===D.pm)continue
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
v.p(0,r,new B.rE(n,C.j.d1(l==null?0:l,0,100),o.h6()))
w.K(0,r)
t=!0}return t}}
B.Wi.prototype={
Jq(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Wi(w,v,u,t,f==null?x.e:f)},
bcq(d){var x=null
return this.Jq(x,x,d,x,x)},
aqh(d){var x=null
return this.Jq(x,d,x,x,x)},
bcu(d){var x=null
return this.Jq(x,x,x,x,d)},
bbN(d){var x=null
return this.Jq(d,x,x,x,x)},
bcr(d){var x=null
return this.Jq(x,x,x,d,x)},
du(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.HZ.prototype={
S(){return"ModelState."+this.b}}
B.Wj.prototype={
vO(){var x=this.Q
return x==null?this.Q=new B.b7L(this).$0():x},
qQ(d){return this.ay2(d)},
ay2(d){var x=0,w=A.k(y.H),v=this
var $async$qQ=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:v.b=d
v.a5()
x=2
return A.c(A.iq("mt.tutor.settings",C.ap.hl(d.du(),null)),$async$qQ)
case 2:return A.i(null,w)}})
return A.j($async$qQ,w)},
A2(){var x=0,w=A.k(y.H),v=this,u
var $async$A2=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:v.a5()
x=2
return A.c(A.iq("mt.tutor.progress",C.ap.hl(v.c.du(),null)),$async$A2)
case 2:u=v.as
if(u!=null)u.au()
v.as=A.cQ(C.x,v.gaEV())
return A.i(null,w)}})
return A.j($async$A2,w)},
Mz(d,e,f){return this.ayQ(d,e,f)},
ayQ(d,e,f){var x=0,w=A.k(y.H),v=this
var $async$Mz=A.e(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:v.z=new A.aZ(d,e,f)
x=2
return A.c(A.iq("mt.tutor.last",C.ap.hl(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Mz)
case 2:return A.i(null,w)}})
return A.j($async$Mz,w)},
Dr(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Dr=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.Vy||n===D.k0){x=1
break}s.f=D.Vy
s.y=null
s.a5()
u=4
n=A.lM().geK().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lM().geK().h(0,"tutor_threads")
p=A.dW(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.biF(new B.b7M(s),n,p),$async$Dr)
case 7:s.x=e
s.f=D.k0
n=A.lM().geK().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.ro().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a8(m)
if(n instanceof B.lL){q=n
s.f=D.aTU
s.y=q
n=A.lM().geK().h(0,"debug")
if(n==="1")A.ro().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a5()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Dr,w)},
wL(){var x=0,w=A.k(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wL=A.e(function(a0,a1){if(a0===1){t.push(a1)
x=u}for(;;)switch(x){case 0:if(r.at){x=1
break}q=null
try{k=$.D().b
k===$&&A.b()
k=k.ga4().e.a
q=(k==null?null:k.r)!=null}catch(d){x=1
break}if(!q){x=1
break}r.at=!0
u=4
k=$.D().b
k===$&&A.b()
p=k
x=7
return A.c(p.aS("quran_tutor_progress").d9("surah, ayah, status, perfect_count, updated_at"),$async$wL)
case 7:o=a1
n=r.c.bj4(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bed()
if(J.aN(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.nc(h.x,k,k))
x=11
return A.c(f.bn1("quran_tutor_save",!1,g,i),$async$wL)
case 11:r.c.biX(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.iq("mt.tutor.progress",C.ap.hl(r.c.du(),null)),$async$wL)
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
return A.j($async$wL,w)},
Lu(d){return this.bmF(d)},
bmF(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Lu=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.ccz(t.c.du()).du()
y.f.a(p.h(0,"rows")).en(0,new B.b7N(d))
t.c=B.ccz(p)
x=2
return A.c(t.A2(),$async$Lu)
case 2:v=4
s=$.D().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.ar("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$Lu)
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
return A.j($async$Lu,w)}}
B.x7.prototype={
N(){var x=$.Nv()
return new B.a0T(x,new A.ai(C.M,$.Y()))}}
B.a0T.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goG())
w=y.a
x.vO().bJ(new B.bMO(v),w)
H.aWX().bJ(new B.bMP(v),w).fB(new B.bMQ())
A.Ql(H.cbV(),y.y)},
y_(){if(this.c!=null)this.j(new B.bMA())},
m(){var x,w=this
w.d.U(w.goG())
x=w.e
x.q$=$.Y()
x.L$=0
w.a0()},
Qi(){var x=0,w=A.k(y.H),v,u=this,t,s
var $async$Qi=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qQ(s.b.bcq(!0)),$async$Qi)
case 3:t=s.a
t.blh()
if(t.a9K()){t.arC()
x=1
break}s.Dr()
case 1:return A.i(v,w)}})
return A.j($async$Qi,w)},
y0(d,e,f){return this.aZo(d,e,f)},
b7r(d){return this.y0(d,null,null)},
aZo(d,e,f){var x=0,w=A.k(y.H),v,u=this,t,s,r
var $async$y0=A.e(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.H(y.q).f.Z(A.aQ(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.V(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cNs(s,d),$async$y0)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Mz(d,t.a,t.b),$async$y0)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aE(A.aF(new B.bMG(u,d,t),null,r),r),$async$y0)
case 8:if(u.c!=null)u.j(new B.bMH())
case 1:return A.i(v,w)}})
return A.j($async$y0,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gat5()&&!A.O(d,!1).vl())u.push(A.bP(x,x,x,x,C.yU,x,x,t.gbim(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bP(x,x,x,x,D.auV,x,x,new B.bMK(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bP(x,x,x,x,C.iz,x,x,new B.bML(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aHG
else w=t?this.aUa():this.aUM()
return L.xV(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aUM(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a4g
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b80,C.a1],x)
for(t=0;t<4;++t){s=D.aJR[t]
u.push(new A.B(C.bs,A.z(A.a([A.aX(s.a,C.ao,p,18),C.O,new A.bX(1,C.ah,A.d(s.b,p,p,p,p,p,G.a1N,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bzk,C.G,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bq(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,p,F.aO,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bq(C.f.ak(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.G,A.d(q,p,p,p,p,p,A.bB(p,p,r?D.e3:C.cM,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.G,D.byl],x))
x=A.a([new E.dE(u,C.a5,C.aL,p,!0,p),new E.dE(A.I(s,C.q,C.d,C.e,0,C.l),C.a5,C.aL,p,!1,p),D.bHV,C.G],x)
if(v!=null)x.push(new E.dE(A.d(v,p,p,p,p,p,D.bjf,p,p,p),C.a5,C.aL,p,!1,p))
else x.push(A.fq(D.arM,D.bp4,this.gaZG(),A.ez(C.t,C.ag,D.bb2,p,p,p,p)))
x.push(C.a4)
x.push(D.a4c)
return x},
aUa(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.O(r.a.a),p=q.length===0,o=p?C.rK:H.cqE(q),n=t.z,m=A.R(v.amb(C.d8,E.bq(s.gauc())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bq(s.aqM()),k=s.c,j=Date.now()
k=k===B.b7I(new A.aO(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.I_(t,!1,u),A.z(A.a([m,C.O,A.R(v.amb(C.li,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.v],j)
if(n!=null){t=H.ku(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bq(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bq(m)+"\u2013"+E.bq(l)
k.push(new E.dE(A.z(A.a([D.au0,C.Y,A.R(A.I(A.a([D.bld,A.d(t+" \u2014 "+m,u,u,u,u,u,C.bz,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nI],j),C.h,C.d,C.e,0,u,u),C.a5,C.aL,new B.bMD(v,n),!0,u))}t=C.i.aa(0.08)
k.push(A.aI(u,C.y,!1,u,!0,C.m,u,A.aK(),r,u,u,u,u,u,2,A.cI(u,new A.cm(4,A.v(14),C.J),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.ux,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.r5,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bME(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.d_,!0,C.u,u,C.E,u,u,u,u))
k.push(C.v)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bun)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.K)(o),++x)t.push(v.RD(o[x]))
C.b.A(k,t)}else{t=A.a([D.aXf,D.aXZ,v.RD(1)],j)
for(w=114;w>=78;--w)t.push(v.RD(w))
t.push(C.G)
r=v.f
p=A.aX(r?C.yx:C.lg,C.ao,u,u)
t.push(A.fg(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,u,C.fe,u,u,u),new B.bMF(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.RD(w))
C.b.A(k,t)}k.push(C.a1)
k.push(D.CD)
return k},
amb(d,e,f){var x=null,w=y.p
return new E.dE(A.z(A.a([A.aX(d,C.t,x,x),C.O,A.R(A.I(A.a([A.d(e,x,x,x,x,x,C.bz,x,x,x),A.d(f,x,1,C.N,x,x,C.a2r,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a5,C.I,x,!1,x)},
RD(d){var x,w=null,v=this.d.c,u=I.cW[d-1].a[1],t=v.a6P(d),s=t/u,r=y.p,q=A.am(A.dy(C.P,A.a([A.cag(C.eC,G.cU,w,w,w,w,w,3,s,w),A.d(E.bq(d),w,w,w,w,w,P.a2O,w,w,w)],r),C.m,C.bm,w),36,36),p=A.d(H.ku(d),w,w,w,w,w,D.be0,w,w,w)
if(t===0)x=E.bq(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bq(t)+" \u0645\u0646 "+E.bq(u)
r=A.a([q,C.cv,A.R(A.I(A.a([p,A.d(x,w,w,w,w,w,A.bB(w,w,t===u?G.cU:C.cM,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bq(C.f.ak(s*100))+"\u066a",w,w,w,w,w,D.a2h,w,w,w))
r.push(D.arU)
return new E.dE(A.z(r,C.h,C.d,C.e,0,w,w),C.qk,C.d6,new B.bMI(this,d),!1,w)}}
B.I_.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aX_
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.No(x),r,r,r,r,r,D.BN,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.DG(w,"model load",r))
x.push(C.G)
x.push(new A.Af(C.a51,!1,q.gbiE(),r,r,r,r,C.k,r,!1,r,!0,r,C.mf,r))
return new E.dE(A.I(x,C.q,C.d,C.e,0,C.l),C.a5,C.aL,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bq(C.f.ak(u/1e6))+" \u0645\u0646 "+E.bq(C.f.ak(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,r,C.oP,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fa(x,A.qk(C.eC,C.t,7,s?t:r,r),C.aB)],w)
if(!this.d)C.b.A(x,A.a([C.G,D.bpT],w))
return new E.dE(A.I(x,C.q,C.d,C.e,0,C.l),C.a5,C.aL,r,!1,r)}}}
B.YF.prototype={
t(d){var x=null,w=D.e3.aa(0.1),v=A.v(14),u=A.aH(D.e3.aa(0.4),1)
return A.E(x,A.z(A.a([D.atF,C.O,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,x,C.BU,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.F(w,x,u,v,x,x,x,C.n),x,x,x,C.aL,C.ae,x,x,x)}}
B.EI.prototype={
S(){return"_Phase."+this.b}}
B.DF.prototype={
N(){return new B.a3r($.Nv(),D.mx)}}
B.a3r.prototype={
gjg(){var x=this.e
return x===$?this.e=this.a.d:x},
gC0(){var x,w=this.a,v=w.f
w=w.c
x=this.gjg()
return H.Nm(w,x,v.yd(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.ac(w.goG())
x.vO()
x.a.a7l(B.aBc(w.a.c,w.gjg()))},
y_(){if(this.c!=null)this.j(new B.c_r())},
m(){var x,w=this,v=w.d
v.U(w.goG())
x=w.Q
if(x!=null)x.au()
v=v.a
v.MR()
v.a45()
w.a0()},
a_E(d){var x,w,v=this
if(v.f===D.vg)v.d.a.a45()
x=v.d.a
x.MR()
w=v.Q
if(w!=null)w.au()
v.j(new B.c_H(v,d))
x.a7l(B.aBc(v.a.c,d))
w=v.a
if(d<w.e)x.a7l(B.aBc(w.c,d+1))},
RV(d){return this.aVE(d)},
aVE(d){var x=0,w=A.k(y.H),v,u=this,t,s,r,q,p
var $async$RV=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:if(u.f===D.vf){u.d.a.MR()
u.j(new B.c_L(u))
x=1
break}t=u.r!=null?D.je:D.mx
u.j(new B.c_M(u))
s=u.d
r=A.a([B.aBc(u.a.c,u.gjg())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.Ld(r,q),$async$RV)
case 3:p=f
if(u.c==null||u.f!==D.vf){x=1
break}u.j(new B.c_N(u,t,p))
case 1:return A.i(v,w)}})
return A.j($async$RV,w)},
QI(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$QI=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.k0){x=1
break}p=l.a
p.MR()
r=B.Fr(s.gC0()).length
s.j(new B.c_P(s))
o=s.Q
if(o!=null)o.au()
s.Q=A.he(C.eZ,new B.c_Q(s))
u=4
o=B.cen(r)
n=A.ds(0,0,0,350*r,0,0)
x=7
return A.c(p.a9W(l.b.c,o,n,new B.c_R(s),new B.c_S(s)),$async$QI)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lL){q=l
l=s.Q
if(l!=null)l.au()
if(s.c!=null)s.j(new B.c_T(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$QI,w)},
BV(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$BV=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.vg){x=1
break}m=s.Q
if(m!=null)m.au()
s.j(new B.c_V(s))
s.Q=A.he(C.iu,new B.c_W(s))
l=new A.D6()
$.Fu()
l.op()
r=l
u=4
m=s.d.a
x=7
return A.c(m.aa_(),$async$BV)
case 7:q=e
if(q.b<0.8){s.b7q("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.awc(q,B.Fr(s.gC0()).length),$async$BV)
case 8:p=e
s.ch=A.ds(0,0,r.ga5o(),0,0,0)
k=A.lM().geK().h(0,"debug")
if(k==="1"){o=B.cqU(m.JH())
A.ro().$1("[tutor] "+s.a.c+":"+s.gjg()+" audio="+C.f.aA(q.b,1)+"s infer="+p.b+"ms total="+r.gCN()+"ms "+p.gTl()+" text="+p.a)
A.ro().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.aA(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aA(p.b/1000,2)+" \u062b\n"+p.gTl()+"\n"+A.n(o)+"\n"+p.a}s.agd(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lL){n=m
m=A.lM().geK().h(0,"debug")
if(m==="1")A.ro().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.JH())
s.a2V(B.No(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$BV,w)},
a2V(d,e){var x=this,w=x.Q
if(w!=null)w.au()
if(x.c==null)return
x.j(new B.c_G(x,d,e))},
b7q(d){return this.a2V(d,null)},
agd(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.au()
if(s.c==null)return
x=B.coU(s.gC0(),d)
r.a=null
if(C.c.O(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjg()
t=x.gtE()
r.a=w.avc(v,u,q.b.a,t)
q.A2()}s.j(new B.c_I(r,s,x))},
Oi(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$Oi=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.k0){x=1
break}s.j(new B.c_z(s))
l=s.Q
if(l!=null)l.au()
s.Q=A.he(C.iu,new B.c_A(s))
k=new A.D6()
$.Fu()
k.op()
r=k
u=4
l=g.a
x=7
return A.c(l.bnt(B.aBc(s.a.c,s.gjg()),B.Fr(s.gC0()).length),$async$Oi)
case 7:q=e
p=B.cqU(l.JH())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.aA(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aA(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.aA(r.gCN()/1000,2)+" \u062b)\n"+q.gTl()+"\n"+A.n(p)+"\n"+q.a
A.ro().$1("[tutor-debug] "+s.a.c+":"+s.gjg()+" audio="+C.f.aA(q.c,1)+"s infer="+q.b+"ms total="+r.gCN()+"ms "+q.gTl()+" text="+q.a)
A.ro().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.ds(0,0,r.ga5o(),0,0,0)
s.agd(q.a)
n=s.r
if(n!=null){l=n.gtE()
j=n.b
i=A.aj(j).i("ah<1>")
j=A.a9(new A.ah(j,new B.c_B(),i),i.i("X.E"))
A.ro().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.c_C(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lL){m=l
A.ro().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.JH())
s.a2V(B.No(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Oi,w)},
ga1D(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.rt():v).a!==D.fm)return!1}return!0},
t(d){var x,w=this,v=null,u=w.d,t=u.c.a6X(w.a.c,w.gjg()),s=u.b,r=s.d&&!w.x&&w.f!==D.je,q=H.ku(w.a.c),p=y.p,o=A.a([A.bP(v,v,v,v,C.iz,v,v,new B.c00(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aLT(),m=A.d("\u0622\u064a\u0629 "+E.bq(w.gjg()),v,v,v,v,v,C.md,v,v,v),l=E.bq(w.gjg()-w.a.d+1),k=w.a
s=A.a([A.z(A.a([m,C.aX,A.d("("+l+" \u0645\u0646 "+E.bq(k.e-k.d+1)+")",v,v,v,v,v,F.aO,v,v,v),C.bC,w.b_s(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.v],p)
if(r)s.push(w.aU5())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.vg&&l!==D.pd}else l=!1
if(l)s.push(w.aJw(m))
else s.push(A.d(w.gC0()+" \ufd3f"+E.bq(w.gjg())+"\ufd3e",v,v,v,v,v,D.ko,C.Z,C.b6,v))}s=A.a([new B.I_(u,!0,v),n,C.B,new E.dE(A.I(s,C.ac,C.d,C.e,0,C.l),D.akD,C.aL,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.je)s.push(w.b8V(n))
if(w.r!=null&&w.f===D.je&&w.ch!=null){x=C.f.ak(C.j.aI(w.ch.a,1000)/100)
s.push(new A.B(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bq(C.j.aI(x,10))+"\u066b"+E.bq(C.j.a3(x,10)))+" \u062b",v,v,v,v,v,F.aO,C.Z,v,v),v))}n=w.as
if(n!=null)s.push(new A.B(C.aL,A.d(n,v,v,v,v,v,D.BN,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.DG(n,"check "+w.a.c+":"+w.gjg(),v))}s.push(w.aK6())
s.push(C.a1)
s.push(A.iz(C.t,C.I,v,new B.c01(w),D.bmS,D.bs5,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga1D()
s.push(new E.dE(A.z(A.a([D.aqm,C.Y,A.R(A.I(A.a([D.btK,A.d(w.ga1D()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,v,F.aO,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nI],p),C.h,C.d,C.e,0,v,v),C.a5,C.aL,new B.c02(w,d),n,v))}n=A.lM().geK().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.df(D.arL,D.bry,u.f===D.k0&&w.f!==D.pd?w.gaKQ():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.B(C.hP,A.xu(n,F.aO,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn6()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,v,F.aO,v,v,v))}p.push(A.bf(D.bsT,v,v,v,new B.c03(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.CD)
return L.xV(o,s,q)},
aLT(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.am(A.ft(new B.c_E(this),w,null,C.ad,new B.c_F()),36,null)},
b_s(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fm)return D.b8d
x=d.b
w=E.bq(x)
v=E.bq(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c1:C.qV
u.push(new A.B(D.alm,A.aX(r,s?G.cU:C.eX,q,16),q))}return A.Wc(A.z(u,C.h,C.d,C.K,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aU5(){var x=null
return A.bu(!1,A.v(12),!0,A.E(x,D.agq,C.k,x,x,new A.F(C.pP,x,x,A.v(12),x,x,x,C.n),x,x,x,x,D.aka,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.c_K(this),x,x,x,x,x,x,x)},
aJw(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.as(d.gMP(),w)
A:{if(D.j7===v){u=D.ko.cv(G.cU)
break A}if(D.v_===v){u=D.ko.a4I(D.e3,C.fN,D.e3)
break A}if(D.v0===v){u=D.ko.a4I(D.eW,C.fN,D.eW)
break A}u=D.ko.a4I(C.eX,C.j2,C.c8)
break A}t=x[w]
r.push(new A.eP(t.a,s,s,C.bu,s,s,s,s,s,s,u))
r.push(O.BE)}x=E.bq(this.gjg())
r.push(A.eu(s,s,s,s,s,s,s,s,s,D.ko.cv(C.ao),"\ufd3f"+x+"\ufd3e"))
return A.Dj(A.eu(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Z,C.b6)},
b8V(d){var x,w,v,u,t,s,r=this.w
if(C.c.O(d.c).length===0)return D.bHh
if(d.gtE()){x=r==null
if((x?null:r.a)===D.fm&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fm?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bq(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.DY(G.cU,C.c1,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMP()
w=J.dG(x)
v=w.io(x,new B.c_X()).gM(0)
u=w.io(x,new B.c_Y()).gM(0)
t=w.io(x,new B.c_Z()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bq(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bq(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bq(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gK0().length!==0)x.push(E.bq(d.gK0().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eW:D.e3
x=C.b.aB(x," \u2022 ")
s=d.gK0().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aB(d.gK0(),"\u060c "):""
return new B.DY(w,C.nz,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aK6(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.k0,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aI(new A.aO(f,0,!1).dD(w).a,1e6)}v=C.j.aI(B.cen(B.Fr(j.gC0()).length).a,1e6)
f=j.gb6_()
w=96+26*j.y
u=D.eW.aa(0.25)
w=A.hS(i,A.a6k(C.P,A.E(i,D.arY,C.k,i,i,D.a8b,i,84,i,i,i,i,i,84),i,C.aU,new A.F(u,i,i,i,i,i,i,C.bW),C.Fz,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.ct)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.cdh(x)+" / "+B.cdh(v),i,i,i,i,i,K.oO,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,i,F.aO,i,i,i),A.bf(D.byk,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.eD((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bq(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bq(t)+" \u062b)"
return new A.B(C.qf,A.I(A.a([C.w7,C.a1,D.bqk,A.d(h,i,i,i,i,i,F.aO,C.Z,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.vf
r=j.r
f=r==null
w=!f
q=w&&r.gtE()
u=A.aX(s?C.nA:K.Ia,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i,i)
o=A.ez(i,i,D.bb_,i,i,i,i)
u=A.R(new A.Af(C.a51,!0,new B.c_s(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Zi(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.JR[n]
p.push(new A.ed(m,i,A.d("\xd7"+E.bq(m),i,i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.z(A.a([u,C.O,A.nB(new B.c_t(j),p,A.dd([h.b.b],o),!1,A.ky(i,i,i,new A.bg(new B.c_u(),l),i,i,i,i,new A.bg(new B.c_v(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cR),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb1t():i
u=A.aX(f?D.qR:C.nz,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,i,C.co,i,i,i)
p=q?C.ir:C.t
h=A.a([o,C.v,A.fq(u,f,h,A.ez(p,q?C.i:C.ag,D.u5,i,i,i,i))],k)
if(w&&j.gjg()<j.a.e)C.b.A(h,A.a([C.B,q?A.fq(D.avh,D.bx2,new B.c_w(j),A.ez(G.cU,C.ag,D.u5,i,i,i,i)):A.bf(D.bni,i,i,i,new B.c_x(j),i,i)],k))
if(w){f=j.gjg()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.B(C.hQ,A.d(j.ga1D()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,i,K.uF,C.Z,i,i),i))
return A.I(h,C.ac,C.d,C.e,0,C.l)}}}
B.DY.prototype={
t(d){var x=this,w=null,v=x.c,u=v.aa(0.12),t=A.v(14),s=A.aH(v.aa(0.5),1),r=y.p
return A.E(w,A.z(A.a([A.aX(x.d,v,w,w),C.O,A.R(A.I(A.a([A.d(x.e,w,w,w,w,w,A.bB(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.T,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bN,A.d(x.f,w,w,w,w,w,C.BU,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.F(u,w,s,t,w,w,w,C.n),w,w,w,C.aL,C.ae,w,w,w)}}
B.DE.prototype={
N(){var x=y.S
return new B.a3q($.Nv(),A.C(x,y.B),A.aT(x),A.C(x,y.N),A.eq(null,y.H))}}
B.a3q.prototype={
W(){this.Y()
this.d.ac(this.goG())},
y_(){if(this.c!=null)this.j(new B.c_a())},
m(){var x,w=this,v=w.d
v.U(w.goG())
x=w.y
if(x!=null)x.au()
v.a.a45()
w.a0()},
Iw(d){return this.b5L(d)},
b5L(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$Iw=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.c_j(t,d))
r=t.y
if(r!=null)r.au()
t.y=A.he(C.eZ,new B.c_k(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.cen(B.Fr(H.Nm(q,d,p.yd(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.ds(0,0,0,350*B.Fr(H.Nm(p,d,o.yd(p,d)).b).length,0,0)
x=6
return A.c(r.a.a9W(r.b.c,q,p,new B.c_l(t,d),new B.c_m(t)),$async$Iw)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lL){s=r
r=t.y
if(r!=null)r.au()
if(t.c!=null)t.j(new B.c_n(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$Iw,w)},
FX(d,e){return this.aN8(d,e)},
aN8(d,e){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$FX=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.au()
s.j(new B.c_e(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.aa_()
if(e&&n!=null)s.Iw(n)
q=null
u=4
x=7
return A.c(r,$async$FX)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lL){p=o
s.j(new B.c_f(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bJ(new B.c_g(s,o,d),y.H)}case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$FX,w)},
gaXR(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b2o(){this.j(new B.c_h(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.k0,o=s.e,n=s.gaXR(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("c2<2>")
x=new A.ah(new A.c2(m,l),new B.c_o(),l.i("ah<X.E>")).gM(0)
l=H.ku(s.a.c)
m=y.p
q=A.a([new B.I_(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bq(s.a.d)+" \u0644\u062d\u062f "+E.bq(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,r,F.aO,r,r,r),C.v],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b7s(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,r,D.BN,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.DG(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bq(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aI(new A.aO(v,0,!1).dD(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.cdh(v),r,r,r,r,r,K.oO,C.Z,r,r)
j=A.fa(A.v(6),A.qk(C.eC,D.eW,6,s.x,r),C.aB)
u=o<s.a.e
t=A.aX(u?R.I4:C.nA,r,r,r)
C.b.A(q,A.a([v,C.G,j,C.v,A.fq(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,r,C.co,r,r,r),new B.c_p(s,o),A.ez(C.t,C.ag,D.u5,r,r,r,r))],m))}else if(n!=null){j=p?new B.c_q(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bq(n)
q.push(A.fq(D.at8,A.d(v,r,r,r,r,r,C.co,r,r,r),j,A.ez(C.t,C.ag,D.u5,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aXr)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cU:D.e3
v=k?C.nr:C.nz
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bq(x)
u=s.a
u=k+" \u0645\u0646 "+E.bq(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.DY(j,v,k,u,r),A.df(D.av4,D.bxI,s.gb2n(),r)],m))}q.push(C.v)
q.push(D.CD)
return L.xV(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b7s(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.ast
else if(l.r.n(0,d))x=N.u8
else if(i!=null)x=D.asL
else if(j!=null){w=j.gtE()?C.c1:D.aoV
x=A.aX(w,j.gtE()?G.cU:D.e3,k,k)}else x=D.ar2
w=y.p
v=A.a([A.z(A.a([A.d("\u0622\u064a\u0629 "+E.bq(d),k,k,k,k,k,C.a2z,k,k,k),C.bC,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,k,D.a2t,k,k,k))
if(j!=null&&!j.gtE()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMP()
o=J.bc(p)
n=o.h(p,r)
A:{if(D.j7===n){m=G.cU
break A}if(D.v_===n){m=D.e3
break A}if(D.v0===n){m=D.eW
break A}m=C.eX
break A}m=D.ko.bd5(m,o.h(p,r)===D.v1?C.j2:k,22)
C.b.A(t,A.a([new A.eP(q.a,k,k,C.bu,k,k,k,k,k,k,m),O.BE],u))}w=A.a([C.aj,A.Dj(A.eu(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Z,C.b6)],w)
if(C.c.O(j.c).length===0)w.push(D.bt7)
C.b.A(v,w)}return new E.dE(A.I(v,C.ac,C.d,C.e,0,C.l),C.bP,C.d6,k,!1,k)}}
B.DD.prototype={
N(){return new B.a3p($.Nv())}}
B.a3p.prototype={
W(){this.Y()
var x=this.d
x.ac(this.goG())
x.vO()},
y_(){if(this.c!=null)this.j(new B.c_1())},
m(){this.d.U(this.goG())
this.a0()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gazQ(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.i0(o,0,new B.c_8(q))
v=C.b.i0(o,0,new B.c_9())
o=y.p
o=A.a([A.z(A.a([A.R(s.Yv(E.bq(q.gauc()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.O,A.R(s.Yv(E.bq(q.aqM()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.O,A.R(s.Yv(E.bq(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.v,new E.dE(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bq(C.f.ak(w*100/v))+"\u066a",r,r,r,r,r,C.bz,r,r,r),C.G,A.fa(A.v(6),A.qk(C.eC,G.cU,8,w/v,r),C.aB),C.aj,A.d(E.bq(w)+" \u0645\u0646 "+E.bq(v)+" \u0622\u064a\u0629",r,r,r,r,r,F.aO,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a5,C.aL,r,!1,r)],o)
if(p.length===0)o.push(D.aXH)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.K)(p),++t)o.push(s.b7u(p[t]))
o.push(C.B)
u=$.D().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,r,F.aO,r,r,r))
return L.xV(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
Yv(d,e){var x=null
return new E.dE(A.I(A.a([A.d(d,x,x,x,x,x,D.bic,x,x,x),A.d(e,x,x,x,x,x,C.a30,C.Z,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a5,C.I,x,!1,x)},
b7u(d){var x=null,w=this.d.c,v=I.cW[d-1].a[1],u=w.a6P(d),t=w.bil(d),s=y.p,r=A.z(A.a([A.R(A.d(H.ku(d),x,x,x,x,x,C.bz,x,x,x),1),A.d(E.bq(C.f.ak(u*100/v))+"\u066a",x,x,x,x,x,D.bjg,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fa(A.v(6),A.qk(C.eC,G.cU,7,u/v,x),C.aB),p=E.bq(u),o=E.bq(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bq(t):""
return new E.dE(A.I(A.a([r,C.G,q,C.aj,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,x,F.aO,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a5,C.aL,new B.c_7(this,d),!1,x)},
Ol(d){return this.aLb(d)},
aLb(d){var x=0,w=A.k(y.H),v=this,u,t
var $async$Ol=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=I.cW[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e2(C.cT,new B.c_6(v,d,u),t,!0,null,null,!1,y.H),$async$Ol)
case 2:return A.i(null,w)}})
return A.j($async$Ol,w)}}
B.aku.prototype={
RU(d,e){var x=null,w=A.lK(x,x,x,x,x,x,x,x,x,x,x,D.baz,C.I,x,x,x,x,C.k_,x,x)
return A.bf(A.d(d,x,x,x,x,x,C.mc,x,x,x),x,x,x,new B.b7u(e),x,w)},
t(d){var x=this,w=y.p
return new E.dE(A.I(A.a([D.bwO,C.G,D.byj,A.cR(C.au,A.a([x.RU("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.RU("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aC,0,12),D.bmu,x.RU("tanzil.net","https://tanzil.net"),D.bzX,x.RU("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a5,C.aL,null,!1,null)}}
B.DG.prototype={
N(){return new B.a3s()}}
B.a3s.prototype={
gan_(){var x=this.a
return B.cOO(x.c,x.d,$.cf_().JH())},
RW(){var x=0,w=A.k(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$RW=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.c04(s))
v=3
r=A.c8l()
n=s.gan_()
m=y.N
q=A.C(m,m)
J.dZ(q,"app","mogtama3y")
J.dZ(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dZ(q,"ua",m)}x=6
return A.c(A.aaX(n,null,C.GF,q),$async$RW)
case 6:if(s.c!=null)s.j(new B.c05(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cg?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.c06(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.c07(s))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$RW,w)},
t(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bu(!1,t,!0,new A.B(C.l2,A.z(A.a([A.aX(u.d?C.yx:C.lg,C.c8,t,18),C.bM,D.bz7],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.c09(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.E(t,A.xu(u.gan_(),D.ber,t,C.z),C.k,t,t,new A.F(C.pP,t,t,x,t,t,t,C.n),t,t,t,D.akd,C.eg,t,t,1/0))}if(u.f)s.push(D.bmM)
else{x=A.lK(t,t,t,t,t,t,t,t,t,t,t,C.a0O,C.I,t,t,t,t,C.k_,t,t)
w=u.e
v=w?t:u.gb7t()
s.push(A.fg(w?C.a11:D.aut,t,D.bvM,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,t,D.a2t,t,t,t))
return new A.B(C.aL,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["al<~>()","~()","M(nM)","al<Kq>()","al<Ko>()","al<Kp>()","a7<nM>()","M(rE)","bG(oT)","DF(u)","DD(u)","M(n4)","DE(u)","M(J1)"])
B.b7v.prototype={
$0(){var x=0,w=A.k(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.S(A.cU(b.G.document).baseURI)
q=A.bx(r,0,null).a2("quran_tutor/tutor.js?v=3").k(0)
x=7
return A.c(A.eH(import(q),y.m),$async$$0)
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
m=B.cDY("network",A.n(o))
throw A.t(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:313}
B.b7y.prototype={
$1(d){var x=null
return A.c2F(A.cP(d,"persist",x,x,x,x))},
$S:1153}
B.b7x.prototype={
$0(){var x=0,w=A.k(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.rh(),$async$$0)
case 4:x=3
return A.c(n.eH(m.cU(l.cP(e,"loadModel",A.c3n(new B.b7w(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.q(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.q(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.rg(p,"ms")
r=q.ou(p,"cached")
A.q(p.backend)
v=new B.Ko(o,t,s,r,q.rg(p,"threads"),q.ou(p,"isolated"),q.rg(p,"warmMs"))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+4}
B.b7w.prototype={
$2(d,e){this.a.$2(C.f.ak(d),C.f.ak(e))},
$S:1154}
B.b7C.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.rh(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aI(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aI(v.d.a,1000)
u.onLevel=A.fX(new B.b7A(v.e))
u.onAutoStop=A.fX(new B.b7B(v.f))
x=5
return A.c(A.eH(A.cU(A.cP(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.b7A.prototype={
$1(d){return this.a.$1(d)},
$S:71}
B.b7B.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b7D.prototype={
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
return A.c(t.rh(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eH(p.cU(o.cP(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.Kp(r,A.dU(r.seconds))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+5}
B.b7F.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.rh(),$async$$0)
case 4:x=3
return A.c(q.eH(p.cU(o.cP(e,"transcribe",t.audio,t.rate,s.aje(u.c),null)),y.m),$async$$0)
case 3:v=r.amU(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b7E.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.rh(),$async$$0)
case 4:x=3
return A.c(r.eH(q.cU(p.cP(e,"transcribeUrl",u.b,t.aje(u.c),null,null)),y.m),$async$$0)
case 3:v=s.amU(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b7z.prototype={
$1(d){return d},
$S:40}
B.aYu.prototype={
$0(){var x,w,v,u,t=this.a,s=A.c8(t.a.length,D.v1,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aYt.prototype={
$1(d){return d===D.j7},
$S:z+2}
B.c36.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c9l(e[x],d[x])<0.75)return!1
return!0},
$S:1155}
B.c5d.prototype={
$1(d){return d.length!==0},
$S:10}
B.b7J.prototype={
$1(d){return d.a===D.fm},
$S:z+7}
B.b7K.prototype={
$1(d){return C.j.aI(d,1000)},
$S:59}
B.b7H.prototype={
$1(d){return C.f.bB(d)},
$S:1156}
B.b7L.prototype={
$0(){var x=0,w=A.k(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iI("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.ap.f3(r,null))
j=A.ar(k.h(0,"n"))
j=j==null?null:C.f.bB(j)
j=C.j.d1(j==null?2:j,1,5)
i=C.b.n(D.JR,k.h(0,"r"))?A.ex(k.h(0,"r")):1
h=A.en(k.h(0,"auto"))
g=A.en(k.h(0,"hide"))
k=A.en(k.h(0,"in"))
s.a.b=new B.Wi(j,i,h!==!1,g===!0,k===!0)}u=2
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
return A.c(A.iI("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.ccz(y.P.a(C.ap.f3(q,null)))
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
return A.c(A.iI("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.ap.f3(p,null))
n=C.f.bB(A.cS(J.as(o,"s")))
m=C.f.bB(A.cS(J.as(o,"f")))
l=C.f.bB(A.cS(J.as(o,"t")))
if(B.cqZ(n,m)&&B.cqZ(n,l)&&m<=l)s.a.z=new A.aZ(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a9K()){k.a.arC()
x=1
break}a1=k
x=18
return A.c(k.a.N9(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a5()
if(k.b.e)k.Dr()
k.wL()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:112}
B.b7M.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a5()},
$S:1157}
B.b7N.prototype={
$2(d,e){return C.j.aI(A.eG(A.n(d),null,null),1000)===this.a},
$S:1158}
B.bMO.prototype={
$1(d){var x=0,w=A.k(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.EJ(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bMN(u,t))
return A.i(null,w)}})
return A.j($async$$1,w)},
$S:1159}
B.bMN.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bMP.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bMM(x,d))},
$S:z+8}
B.bMM.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bMQ.prototype={
$1(d){},
$S:24}
B.bMA.prototype={
$0(){},
$S:0}
B.bMG.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.DF(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bMH.prototype={
$0(){},
$S:0}
B.bMK.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aE(A.aF(new B.bMJ(),null,x),x)},
$S:0}
B.bMJ.prototype={
$1(d){return D.bBl},
$S:z+10}
B.bML.prototype={
$0(){return B.cqL(this.a)},
$S:0}
B.bMD.prototype={
$0(){var x=this.b
return this.a.y0(x.a,x.b,x.c)},
$S:0}
B.bME.prototype={
$1(d){return this.a.j(new B.bMC())},
$S:5}
B.bMC.prototype={
$0(){},
$S:0}
B.bMF.prototype={
$0(){var x=this.a
return x.j(new B.bMB(x))},
$S:0}
B.bMB.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bMI.prototype={
$0(){return this.a.b7r(this.b)},
$S:0}
B.c7Z.prototype={
$1(d){return new A.je(new B.c7W(this.a,this.b,this.c),null)},
$S:57}
B.c7W.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c7Y(u,e),s=this.a,r=new B.c7X(s,e),q=A.d(H.ku(this.c),v,v,v,v,v,C.oK,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bq(u)+" \u0622\u064a\u0629)",v,v,v,v,v,F.aO,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bq(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bq(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.aj,p,C.v,A.cR(C.au,n,C.aC,6,8),C.B,A.z(A.a([t.$3("\u0645\u0646",s.b,new B.c7R(s)),C.a0Z,t.$3("\u0644\u062d\u062f",s.c,new B.c7S(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aXw)
u.push(C.a4)
u.push(A.dC(D.bpO,new B.c7T(s,d),A.ez(C.t,C.ag,D.baX,v,v,v,v)))
return A.cx(!0,new A.B(C.G6,A.I(u,C.ac,C.d,C.K,0,C.l),v),C.I,!0)},
$S:405}
B.c7Y.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,u,C.ic,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c7(v,A.d("\u0622\u064a\u0629 "+E.bq(v),u,u,u,u,u,u,u,u,u),C.an,u,w))
return A.R(A.I(A.a([t,Q.GI(C.cT,!0,s,320,new B.c7V(this.b,f),D.bjx,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1161}
B.c7V.prototype={
$1(d){return d==null?null:this.a.$1(new B.c7U(this.b,d))},
$S:51}
B.c7U.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c7X.prototype={
$3(d,e,f){var x=null
return A.c9W(x,A.d(d,x,x,x,x,x,x,x,x,x),new B.c7Q(this.a,this.b,e,f))},
$S:1162}
B.c7Q.prototype={
$0(){var x=this
return x.b.$1(new B.c7P(x.a,x.c,x.d))},
$S:0}
B.c7P.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c7R.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c7S.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c7T.prototype={
$0(){var x=this.a
return A.O(this.b,!1).ag(new A.V(x.b,x.c))},
$S:0}
B.c_r.prototype={
$0(){},
$S:0}
B.c_H.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mx
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.c_L.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.je:D.mx},
$S:0}
B.c_M.prototype={
$0(){var x=this.a
x.f=D.vf
x.as=null},
$S:0}
B.c_N.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.c_P.prototype={
$0(){var x=this.a
x.f=D.vg
x.as=null
x.y=0
x.z=new A.aO(Date.now(),0,!1)
x.ax=null},
$S:0}
B.c_Q.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c_O())},
$S:28}
B.c_O.prototype={
$0(){},
$S:0}
B.c_S.prototype={
$1(d){return this.a.y=d},
$S:71}
B.c_R.prototype={
$1(d){return this.a.BV()},
$S:5}
B.c_T.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.je:D.mx
x=this.b
w.as=B.No(x)
w.at=x},
$S:0}
B.c_V.prototype={
$0(){var x=this.a
x.f=D.pd
x.ay=Date.now()},
$S:0}
B.c_W.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c_U())},
$S:28}
B.c_U.prototype={
$0(){},
$S:0}
B.c_G.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.je:D.mx
x.as=this.b
x.at=this.c},
$S:0}
B.c_I.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.je
x.x=!1},
$S:0}
B.c_z.prototype={
$0(){var x=this.a
x.f=D.pd
x.ay=Date.now()
x.as=null},
$S:0}
B.c_A.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c_y())},
$S:28}
B.c_y.prototype={
$0(){},
$S:0}
B.c_B.prototype={
$1(d){return d.d!==D.j7},
$S:z+11}
B.c_C.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.c00.prototype={
$0(){return B.cqL(this.a)},
$S:0}
B.c01.prototype={
$1(d){var x=this.a.d
return x.qQ(x.b.aqh(d))},
$S:3}
B.c02.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aE(A.aF(new B.c0_(this.a),null,x),x)},
$S:0}
B.c0_.prototype={
$1(d){var x=this.a.a
return new B.DE(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.c03.prototype={
$0(){this.a.d.a.bmD()
this.b.H(y.q).f.Z(D.bc3)},
$S:0}
B.c_F.prototype={
$2(d,e){return C.aX},
$S:17}
B.c_E.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a6X(s.c,r).a.a){case 2:s=G.cU
break
case 1:s=D.e3
break
case 0:s=C.ir
break
default:s=u}x=A.v(18)
w=t.f===D.pd?u:new B.c_D(t,r)
v=s.aa(0.25)
if(r===t.gjg())s=C.i
s=A.aH(s,r===t.gjg()?2:1)
return A.bu(!1,x,!0,A.E(C.P,A.d(E.bq(r),u,u,u,u,u,C.a27,u,u,u),C.k,u,u,new A.F(v,u,s,u,u,u,u,C.bW),u,u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:69}
B.c_D.prototype={
$0(){return this.a.a_E(this.b)},
$S:0}
B.c_K.prototype={
$0(){var x=this.a
return x.j(new B.c_J(x))},
$S:0}
B.c_J.prototype={
$0(){return this.a.x=!0},
$S:0}
B.c_X.prototype={
$1(d){return d===D.v_},
$S:z+2}
B.c_Y.prototype={
$1(d){return d===D.v0},
$S:z+2}
B.c_Z.prototype={
$1(d){return d===D.v1},
$S:z+2}
B.c_s.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.RV(x)},
$S:0}
B.c_t.prototype={
$1(d){var x=this.a.d
return x.qQ(x.b.bcu(d.ga1(d)))},
$S:115}
B.c_v.prototype={
$1(d){return d.n(0,C.U)?C.ag:C.i},
$S:4}
B.c_u.prototype={
$1(d){return d.n(0,C.U)?C.t:C.a7},
$S:4}
B.c_w.prototype={
$0(){var x=this.a
return x.a_E(x.gjg()+1)},
$S:0}
B.c_x.prototype={
$0(){var x=this.a
return x.a_E(x.gjg()+1)},
$S:0}
B.c_a.prototype={
$0(){},
$S:0}
B.c_j.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aO(Date.now(),0,!1)},
$S:0}
B.c_k.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c_i())},
$S:28}
B.c_i.prototype={
$0(){},
$S:0}
B.c_m.prototype={
$1(d){return this.a.x=d},
$S:71}
B.c_l.prototype={
$1(d){return this.a.FX(this.b,!1)},
$S:5}
B.c_n.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.No(x)
w.as=x},
$S:0}
B.c_e.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.c_f.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.No(x))
w.as=x},
$S:0}
B.c_g.prototype={
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
return A.c(n.a.awc(s.b,B.Fr(H.Nm(l,m,k.yd(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.coU(H.Nm(l,m,k.yd(l,m)).b,r.a)
if(C.c.O(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtE()
l.avc(k,m,n.b.a,j)}n.A2()
if(o.c!=null)o.j(new B.c_b(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lL){p=o
o=s.a
if(o.c!=null)o.j(new B.c_c(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.c_d(o,s.c))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$1,w)},
$S:150}
B.c_b.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.c_c.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.No(w))
x.as=w},
$S:0}
B.c_d.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.c_h.prototype={
$0(){var x=this.a
x.f.ao(0)
x.w.ao(0)
x.as=null},
$S:0}
B.c_o.prototype={
$1(d){return d.gtE()},
$S:z+13}
B.c_p.prototype={
$0(){return this.a.FX(this.b,!0)},
$S:0}
B.c_q.prototype={
$0(){return this.a.Iw(this.b)},
$S:0}
B.c_1.prototype={
$0(){},
$S:0}
B.c_8.prototype={
$2(d,e){return d+this.a.a6P(e)},
$S:114}
B.c_9.prototype={
$2(d,e){return d+I.cW[e-1].a[1]},
$S:114}
B.c_7.prototype={
$0(){return this.a.Ol(this.b)},
$S:0}
B.c_6.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.ku(p),q,q,q,q,q,C.oK,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.ba(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.rt():r).a.a){case 2:r=G.cU.aa(0.35)
break
case 1:r=D.e3.aa(0.35)
break
case 0:r=C.h0
break
default:r=q}m.push(A.E(C.P,A.d(E.bq(t),q,q,q,q,q,C.km,q,q,q),C.k,q,q,new A.F(r,q,q,new A.cD(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,q,38))}return A.cx(!0,new A.B(C.h6,A.I(A.a([o,C.aj,D.bu2,C.v,new A.dl(D.a81,A.f1(A.cR(C.au,m,C.aC,6,6),q,C.r,q,q,q,C.w),q),C.a1,A.bf(D.bvP,q,q,q,new B.c_5(w,d,p),q,q)],n),C.ac,C.d,C.K,0,C.l),q),C.I,!0)},
$S:35}
B.c_5.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dk(null,null,!0,null,new B.c_4(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Lu(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e5()
case 3:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.c_4.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.ku(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x,x)
return A.dr(A.a([A.bf(C.ev,x,x,x,new B.c_2(d),x,x),A.bf(C.p0,x,x,x,new B.c_3(d),x,x)],y.p),w,D.bxq)},
$S:14}
B.c_2.prototype={
$0(){A.O(this.a,!1).ag(!1)
return null},
$S:0}
B.c_3.prototype={
$0(){A.O(this.a,!1).ag(!0)
return null},
$S:0}
B.c8W.prototype={
$1(d){var x=this.a
return new A.kL(new B.c8V(x),null,x,null)},
$S:1163}
B.c8V.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.ed(w,t,A.d(E.bq(w),t,t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bmq,C.a1,D.bwe,C.G,A.nB(new B.c8Q(s,r),q,A.dd([r.a],x),!1,A.ky(t,t,t,new A.bg(new B.c8R(),v),t,t,t,t,new A.bg(new B.c8S(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.iz(C.t,C.I,t,new B.c8T(s,r),D.bti,D.bzo,r.c),A.iz(C.t,C.I,t,new B.c8U(s,r),t,D.blW,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.aj,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn6(),t,t,t,t,t,F.aO,t,C.b6,t)],u))
x.push(C.B)
x.push(D.a4c)
return A.cx(!0,A.f1(A.I(x,C.ac,C.d,C.e,0,C.l),t,C.r,C.h6,t,t,C.w),C.I,!0)},
$S:1164}
B.c8Q.prototype={
$1(d){return this.a.qQ(this.b.bcr(d.ga1(d)))},
$S:115}
B.c8S.prototype={
$1(d){return d.n(0,C.U)?C.ag:C.i},
$S:4}
B.c8R.prototype={
$1(d){return d.n(0,C.U)?C.t:C.a7},
$S:4}
B.c8T.prototype={
$1(d){return this.a.qQ(this.b.bbN(d))},
$S:3}
B.c8U.prototype={
$1(d){return this.a.qQ(this.b.aqh(d))},
$S:3}
B.b7u.prototype={
$0(){return A.cp(A.bx(this.a,0,null),C.aM,null)},
$S:0}
B.c9e.prototype={
$1(d){var x,w=A.aE("https?://",!0,!1,!1)
w=A.bJ(d,w,"")
x=A.aE("www\\.",!0,!1,!1)
return A.v7(A.bJ(w,x,"www[.]"),A.aE("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c9f(),null)},
$S:40}
B.c9f.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:58}
B.c04.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.c05.prototype={
$0(){return this.a.f=!0},
$S:0}
B.c06.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.c07.prototype={
$0(){return this.a.e=!1},
$S:0}
B.c09.prototype={
$0(){var x=this.a
return x.j(new B.c08(x))},
$S:0}
B.c08.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c9d.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:230};(function installTearOffs(){var x=a._instance_0u
x(B.akv.prototype,"gbim","bin",1)
var w
x(w=B.Wj.prototype,"gbiE","Dr",0)
x(w,"gaEV","wL",0)
x(w=B.a0T.prototype,"goG","y_",1)
x(w,"gaZG","Qi",0)
x(w=B.a3r.prototype,"goG","y_",1)
x(w,"gb1t","QI",0)
x(w,"gb6_","BV",0)
x(w,"gaKQ","Oi",0)
x(w=B.a3q.prototype,"goG","y_",1)
x(w,"gb2n","b2o",1)
x(B.a3p.prototype,"goG","y_",1)
x(B.a3s.prototype,"gb7t","RW",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a6,[B.akv,B.Wk,B.Ko,B.Kq,B.Kp,B.lL,B.Tp,B.n4,B.J1,B.rE,B.akw,B.Wi])
x(A.lj,[B.b7v,B.b7x,B.b7C,B.b7D,B.b7F,B.b7E,B.aYu,B.b7L,B.bMN,B.bMM,B.bMA,B.bMH,B.bMK,B.bML,B.bMD,B.bMC,B.bMF,B.bMB,B.bMI,B.c7U,B.c7Q,B.c7P,B.c7T,B.c_r,B.c_H,B.c_L,B.c_M,B.c_N,B.c_P,B.c_O,B.c_T,B.c_V,B.c_U,B.c_G,B.c_I,B.c_z,B.c_y,B.c_C,B.c00,B.c02,B.c03,B.c_D,B.c_K,B.c_J,B.c_s,B.c_w,B.c_x,B.c_a,B.c_j,B.c_i,B.c_n,B.c_e,B.c_f,B.c_b,B.c_c,B.c_d,B.c_h,B.c_p,B.c_q,B.c_1,B.c_7,B.c_5,B.c_2,B.c_3,B.b7u,B.c04,B.c05,B.c06,B.c07,B.c09,B.c08])
x(A.iN,[B.b7y,B.b7A,B.b7B,B.b7z,B.aYt,B.c5d,B.b7J,B.b7K,B.b7H,B.bMO,B.bMP,B.bMQ,B.bMG,B.bMJ,B.bME,B.c7Z,B.c7Y,B.c7V,B.c7X,B.c7R,B.c7S,B.c_Q,B.c_S,B.c_R,B.c_W,B.c_A,B.c_B,B.c01,B.c0_,B.c_X,B.c_Y,B.c_Z,B.c_t,B.c_v,B.c_u,B.c_k,B.c_m,B.c_l,B.c_g,B.c_o,B.c_6,B.c_4,B.c8W,B.c8Q,B.c8S,B.c8R,B.c8T,B.c8U,B.c9e,B.c9f,B.c9d])
x(A.og,[B.b7w,B.c36,B.b7M,B.b7N,B.c7W,B.c_F,B.c_E,B.c_8,B.c_9,B.c8V])
x(A.Ef,[B.nM,B.FM,B.HZ,B.EI])
w(B.Wj,A.i7)
x(A.L,[B.x7,B.DF,B.DE,B.DD,B.DG])
x(A.N,[B.a0T,B.a3r,B.a3q,B.a3p,B.a3s])
x(A.a2,[B.I_,B.YF,B.DY,B.aku])})()
A.pv(b.typeUniverse,JSON.parse('{"lL":{"bK":[]},"DF":{"L":[],"l":[]},"DE":{"L":[],"l":[]},"DD":{"L":[],"l":[]},"DG":{"L":[],"l":[]},"Wj":{"aD":[]},"x7":{"L":[],"l":[]},"a0T":{"N":["x7"]},"I_":{"a2":[],"l":[]},"YF":{"a2":[],"l":[]},"a3r":{"N":["DF"]},"DY":{"a2":[],"l":[]},"a3q":{"N":["DE"]},"a3p":{"N":["DD"]},"aku":{"a2":[],"l":[]},"a3s":{"N":["DG"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rE"),c:x("ed<x>"),r:x("c7<x>"),k:x("H<n4>"),n:x("H<ed<x>>"),I:x("H<c7<x>>"),R:x("H<hT>"),Z:x("H<aA<o,@>>"),d:x("H<Tp>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bR"),j:x("a7<@>"),L:x("a7<x>"),P:x("aA<o,@>"),f:x("aA<@,@>"),x:x("au<o,x>"),a:x("bG"),K:x("a6"),B:x("J1"),l:x("+(x,x)"),e:x("d5<n4>"),N:x("o"),C:x("Ko"),D:x("Kp"),X:x("Wk"),_:x("Kq"),U:x("ah<o>"),G:x("nM"),q:x("ps"),b:x("bg<U?>"),y:x("M"),i:x("a3"),z:x("@"),S:x("x"),A:x("bR?"),Y:x("aA<@,@>?"),O:x("a6?"),M:x("+quota,usage(x,x)?"),o:x("dI"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.pm=new B.FM(0,"none")
D.pn=new B.FM(1,"learning")
D.fm=new B.FM(2,"memorized")
D.a81=new A.az(0,1/0,0,320)
D.eW=new A.U(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a8b=new A.F(D.eW,null,null,null,null,null,null,C.bW)
D.e3=new A.U(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.atI=new A.G(C.yJ,null,C.c8,null,null,null)
D.bxy=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.fe,null,null,null,null,null,null,null,null)
D.beV=new A.r(!0,C.eX,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bu4=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.beV,null,null,null,null,null,null,null,null)
D.aKV=x([D.atI,C.G,D.bxy,D.bu4],y.p)
D.agq=new A.fi(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aKV,null)
D.aka=new A.T(0,26,0,26)
D.akd=new A.T(0,4,0,6)
D.akD=new A.T(14,12,14,14)
D.alm=new A.T(3,0,0,0)
D.aoV=new A.Q(63251,"MaterialIcons",null,!1)
D.qR=new A.Q(63677,"MaterialIcons",null,!1)
D.apJ=new A.Q(983209,"MaterialIcons",null,!1)
D.aqm=new A.G(D.apJ,28,C.t,null,null,null)
D.ar2=new A.G(C.HO,null,C.ir,null,null,null)
D.aoE=new A.Q(62961,"MaterialIcons",null,!1)
D.arL=new A.G(D.aoE,null,null,null,null,null)
D.aoT=new A.Q(63199,"MaterialIcons",null,!1)
D.arM=new A.G(D.aoT,null,null,null,null,null)
D.arU=new A.G(C.jH,null,C.eX,null,null,null)
D.arY=new A.G(C.nA,44,C.i,null,null,null)
D.ast=new A.G(D.qR,null,D.eW,null,null,null)
D.asL=new A.G(C.lf,null,D.eW,null,null,null)
D.at8=new A.G(D.qR,null,null,null,null,null)
D.atF=new A.G(C.hU,20,D.e3,null,null,null)
D.au0=new A.G(C.nx,30,C.t,null,null,null)
D.aut=new A.G(C.ll,16,C.t,null,null,null)
D.auV=new A.G(C.HK,null,null,null,null,null)
D.av4=new A.G(C.nz,null,null,null,null,null)
D.avh=new A.G(C.Hx,null,null,null,null,null)
D.JR=x([1,3,5],y.t)
D.KE=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aY9=new A.B(C.iw,C.mJ,null)
D.aHG=x([D.aY9],y.p)
D.b1H=new A.V(C.nt,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b1u=new A.V(D.qR,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b21=new A.V(C.d8,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.b2f=new A.V(C.HN,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aJR=x([D.b1H,D.b1u,D.b21,D.b2f],A.ae("H<+(Q,o)>"))
D.aMg=x([D.pm,D.pn,D.fm],A.ae("H<FM>"))
D.Pi=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aTT=new B.HZ(0,"idle")
D.Vy=new B.HZ(1,"loading")
D.k0=new B.HZ(2,"ready")
D.aTU=new B.HZ(3,"failed")
D.asr=new A.G(C.c1,18,G.cU,null,null,null)
D.byw=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uF,null,null,null,null,null,null,null,null)
D.aGA=x([D.asr,C.aX,D.byw],y.p)
D.b8l=new A.em(C.ad,C.d,C.e,C.h,null,C.l,null,0,D.aGA,null)
D.aX_=new A.B(C.aL,D.b8l,null)
D.alk=new A.T(2,6,2,4)
D.beB=new A.r(!0,C.t,null,null,null,null,14,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmm=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.beB,null,null,null,null,null,null,null,null)
D.aXf=new A.B(D.alk,D.bmm,null)
D.byW=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.fe,null,null,null,null,null,null,null,null)
D.aI_=x([N.u8,C.O,D.byW],y.p)
D.b8f=new A.em(C.ad,C.cf,C.e,C.h,null,C.l,null,0,D.aI_,null)
D.aXr=new A.B(C.l1,D.b8f,null)
D.C1=new A.r(!0,D.e3,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bzg=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.C1,null,null,null,null,null,null,null,null)
D.aXw=new A.B(C.dD,D.bzg,null)
D.byr=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aO,C.Z,null,null,null,null,null,null,null)
D.aXH=new A.B(C.C,D.byr,null)
D.alh=new A.T(2,0,2,8)
D.bum=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aO,null,null,null,null,null,null,null,null)
D.aXZ=new A.B(D.alh,D.bum,null)
D.auC=new A.G(C.lj,30,C.t,null,null,null)
D.bzY=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.C2,null,null,null,null,null,null,null,null)
D.amt=new A.bX(1,C.ah,D.bzY,null)
D.aIf=x([D.auC,C.Y,D.amt],y.p)
D.b80=new A.em(C.ad,C.d,C.e,C.h,null,C.l,null,0,D.aIf,null)
D.aud=new A.G(C.d8,18,G.cU,null,null,null)
D.a2h=new A.r(!0,G.cU,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.by9=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a2h,null,null,null,null,null,null,null,null)
D.aH0=x([D.aud,C.bM,D.by9],y.p)
D.b8d=new A.em(C.ad,C.d,C.K,C.h,null,C.l,null,0,D.aH0,null)
D.baz=new A.W(0,30)
D.u5=new A.W(1/0,54)
D.baX=new A.W(1/0,48)
D.bb_=new A.W(1/0,50)
D.bb2=new A.W(1/0,52)
D.bvZ=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.bc3=new A.cZ(D.bvZ,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.be0=new A.r(!0,C.i,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.ber=new A.r(!0,C.ao,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.BN=new A.r(!0,D.eW,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.ko=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a2t=new A.r(!0,D.eW,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bic=new A.r(!0,C.t,null,null,null,null,24,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjf=new A.r(!0,D.e3,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjg=new A.r(!0,G.cU,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjx=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bld=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.ic,null,null,null,null,null,null,null,null)
D.blW=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.d_,null,null,null,null,null,null,null,null)
D.bmq=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oK,null,null,null,null,null,null,null,null)
D.bmu=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aO,null,null,null,null,null,null,null,null)
D.bfN=new A.r(!0,G.cU,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmM=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bfN,null,null,null,null,null,null,null,null)
D.bmS=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aO,null,null,null,null,null,null,null,null)
D.bni=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.fe,null,null,null,null,null,null,null,null)
D.bp4=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.co,null,null,null,null,null,null,null,null)
D.bpO=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bE,null,null,null,null,null,null,null,null)
D.bpT=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aO,null,null,null,null,null,null,null,null)
D.bqk=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.uG,null,null,null,null,null,null,null,null)
D.bry=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bs5=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oO,null,null,null,null,null,null,null,null)
D.bsT=new A.m("reset safe mode / WebGPU ban",null,C.BG,null,null,null,null,null,null,null,null)
D.bt7=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.C1,null,null,null,null,null,null,null,null)
D.bti=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aO,null,null,null,null,null,null,null,null)
D.btK=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bz,null,null,null,null,null,null,null,null)
D.bu2=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aO,null,null,null,null,null,null,null,null)
D.bun=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aO,null,null,null,null,null,null,null,null)
D.bvM=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a2U,null,null,null,null,null,null,null,null)
D.bhp=new A.r(!0,D.eW,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bvP=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bhp,null,null,null,null,null,null,null,null)
D.bwe=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oO,null,null,null,null,null,null,null,null)
D.bwO=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a1K,null,null,null,null,null,null,null,null)
D.bx2=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.co,null,null,null,null,null,null,null,null)
D.bxq=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bxI=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.byj=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aO,null,null,null,null,null,null,null,null)
D.byk=new A.m("\u062e\u0644\u0635\u062a",null,C.md,null,null,null,null,null,null,null,null)
D.byl=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.C1,null,null,null,null,null,null,null,null)
D.biv=new A.r(!0,C.cM,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.fN,null,null,null,null,null,null,null,null)
D.bz7=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.biv,null,null,null,null,null,null,null,null)
D.bzk=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bz,null,null,null,null,null,null,null,null)
D.bzo=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.d_,null,null,null,null,null,null,null,null)
D.bzX=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aO,null,null,null,null,null,null,null,null)
D.a4c=new B.aku(null)
D.bBl=new B.DD(null)
D.bBm=new B.Wi(2,1,!0,!1,!1)
D.a4g=new B.Wk(!1,!1,!1,!1,!1,0)
D.j7=new B.nM(0,"ok")
D.v_=new B.nM(1,"near")
D.v0=new B.nM(2,"wrong")
D.v1=new B.nM(3,"missing")
D.a4H=new B.nM(4,"extra")
D.ap9=new A.Q(63456,"MaterialIcons",null,!1)
D.bHh=new B.DY(D.e3,D.ap9,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bHV=new B.YF(!1,null)
D.CD=new B.YF(!0,null)
D.mx=new B.EI(0,"idle")
D.vf=new B.EI(1,"playing")
D.vg=new B.EI(2,"recording")
D.pd=new B.EI(3,"thinking")
D.je=new B.EI(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cRO","cf_",()=>new B.akv())
x($,"cVg","cuI",()=>A.aE("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cVh","cuJ",()=>A.aE("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cVt","cuS",()=>A.aE("\u0648\u0670",!0,!1,!1))
x($,"cUP","cuo",()=>A.aE("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cT5","ctd",()=>A.aE("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cUk","cu0",()=>A.aE("[\u0654\u0655]",!0,!1,!1))
x($,"cT6","cte",()=>A.aE("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cTd","ctk",()=>A.aE("[\u0624\u0626]",!0,!1,!1))
x($,"cUm","cu2",()=>A.aE("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cUU","cur",()=>A.aE("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cUu","cu9",()=>A.aE("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cVe","cfB",()=>A.aE("\\s+",!0,!1,!1))
x($,"cP6","rt",()=>B.cvJ(D.pm,0,A.caw(0,!0)))
x($,"cRP","Nv",()=>new B.Wj($.cf_(),D.bBm,B.cDZ(),D.aTT,$.Y()))})()};
(a=>{a["bFE2nZQmu/nvH35hIbcQLL3Vczc="]=a.current})($__dart_deferred_initializers__);