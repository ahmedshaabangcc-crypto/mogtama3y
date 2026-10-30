((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,P,H,G,N,Q,K,B={
cEo(d){var x,w,v,u,t,s
if(d instanceof B.lM)return d
try{x=A.cU(d)
w=x.code
v=x.message
u=w==null?"failed":A.S(w)
t=v==null?"":A.S(v)
return new B.lM(u,t)}catch(s){u=A.n(d)
return new B.lM("failed",u)}},
akB:function akB(){this.b=this.a=null},
b7z:function b7z(d){this.a=d},
b7C:function b7C(){},
b7B:function b7B(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b7A:function b7A(d){this.a=d},
b7G:function b7G(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b7E:function b7E(d){this.a=d},
b7F:function b7F(d){this.a=d},
b7H:function b7H(d){this.a=d},
b7J:function b7J(d,e,f){this.a=d
this.b=e
this.c=f},
b7I:function b7I(d,e,f){this.a=d
this.b=e
this.c=f},
b7D:function b7D(){},
cEp(d,e){return new B.lM(d,e)},
Wn:function Wn(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
Ks:function Ks(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
Ku:function Ku(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
Kt:function Kt(d,e){this.a=d
this.b=e},
lM:function lM(d,e){this.a=d
this.b=e},
cqq(d){var x,w=$.cv9()
w=A.bJ(d,w,"\u0627")
x=$.cva()
w=A.bJ(w,x,"\u064a")
x=$.cvj()
w=A.bJ(w,x,"\u0627")
x=$.ctF()
w=A.bJ(w,x,"\u0627")
x=$.cuQ()
w=A.bJ(w,x,"\u0621")
x=$.cus()
w=A.bJ(w,x,"\u0621")
x=$.ctG()
w=A.bJ(w,x,"\u0627")
x=$.ctM()
w=A.bJ(w,x,"\u0621")
w=A.bJ(w,"\u0649","\u064a")
w=A.bJ(w,"\u0629","\u0647")
x=$.cuu()
w=A.bJ(w,x,"")
x=$.cuT()
w=A.bJ(w,x," ")
x=$.cuB()
w=A.bJ(w,x," ")
x=$.cg1()
return C.c.N(A.bJ(w,x," "))},
cJ7(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.k9(x,w)
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
c9O(d,e){var x,w,v,u,t,s
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
s=1-B.cJ7(d,e)/u
return s>=1?0.99:s},
Fv(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.ua(d,$.cg1()),w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.length===0)continue
t=B.cqq(u)
s=A.bJ(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Tt(r.a+" "+u,r.b))}continue}q.push(new B.Tt(u,s))}return q},
cHN(d,e){var x,w,v,u,t=new B.c3z(),s=A.a([],y.s)
for(x=A.ff(e,0,A.ip(5,"count",y.S),A.aj(e).c),w=x.$ti,x=new A.ce(x,x.gM(0),w.i("ce<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.KG)&&t.$2(d,D.KG)?C.b.jB(d,5):d
return!t.$2(s,D.Pk)&&t.$2(u,D.Pk)?C.b.jB(u,4):u},
cpl(d,e){var x=B.Fv(d),w=B.cqq(e),v=y.U
v=A.a9(new A.ai(A.a(w.split(" "),y.s),new B.c5G(),v),v.i("Y.E"))
return new B.J4(x,B.cGY(x,B.cHN(v,x)),w)},
cGY(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.K)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.c8(x,0,!1,s)
q=A.c8(x,0,!1,y.S)
p=A.c8(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c9O(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c9O(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c9O(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
else m=a2>=0.6?D.v1:D.v2
a1.push(new B.n6(o,x,s,m))
break
case 1:--o
a1.push(new B.n6(o,a4[o],null,D.v3))
break
case 2:--n
a1.push(new B.n6(null,null,a6[n],D.a4J))
break
case 3:--o
a3=n-2
a1.push(new B.n6(o,a4[o],a6[a3]+" "+a6[n-1],D.j7))
n=a3
break
default:x=o-1;--n
a1.push(new B.n6(x,a4[x],a6[n],D.j7))
o-=2
a1.push(new B.n6(o,a4[o],a6[n],D.j7))}}a4=y.e
a4=A.a9(new A.d5(a1,a4),a4.i("aW.E"))
return a4},
nN:function nN(d,e){this.a=d
this.b=e},
Tt:function Tt(d,e){this.a=d
this.b=e},
n6:function n6(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
J4:function J4(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aYy:function aYy(d){this.a=d},
aYx:function aYx(){},
c3z:function c3z(){},
c5G:function c5G(){},
cwa(d,e,f){return new B.rF(d,e,f)},
cK2(d){var x
A:{if("memorized"===d){x=D.fm
break A}if("learning"===d){x=D.ps
break A}x=D.pr
break A}return x},
crq(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cW[d-1].a[1]},
cEq(){var x=y.S
return new B.akC(A.C(x,y.u),A.aT(x))},
b7M(d){var x=d.eV()
return C.c.dt(C.j.k(A.br(x)),4,"0")+"-"+C.c.dt(C.j.k(A.bt(x)),2,"0")+"-"+C.c.dt(C.j.k(A.bY(x)),2,"0")},
cme(d){var x=y.x,w=A.a9(new A.av(A.a(d.split("-"),y.s),A.cLt(),x),x.i("aW.E"))
return B.b7M(A.dy(w[0],w[1],w[2]-1,12,0,0,0))},
cd0(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.C(p,y.u),n=A.aT(p),m=new B.akC(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcO(),x=x.ga_(x),w=y.j;x.v();){v=x.gG()
u=A.dW(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aO(t)>=3){v=C.j.aI(u,1000)
s=C.j.a3(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cW[v-1].a[1])}if(v)continue
v=J.bc(t)
r=C.f.bB(A.cS(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rF(D.aMv[r],C.f.bB(A.cS(v.h(t,1))),new A.aP(A.kD(C.f.bB(A.cS(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aC1(q,y.o)
p=A.mz(x,new B.b7L(),x.$ti.i("Y.E"),p)
n.A(0,new A.ai(p,o.ga4x(),A.y(p).i("ai<Y.E>")))}m.c=A.q(d.h(0,"last"))
p=A.ar(d.h(0,"streak"))
p=p==null?null:C.f.bB(p)
p=m.d=p==null?0:p
o=A.ar(d.h(0,"best"))
o=o==null?null:C.f.bB(o)
m.e=o==null?p:o
return m},
aBi(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dt(C.j.k(d),3,"0")+C.c.dt(C.j.k(e),3,"0")+".mp3"},
FP:function FP(d,e){this.a=d
this.b=e},
rF:function rF(d,e,f){this.a=d
this.b=e
this.c=f},
akC:function akC(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b7N:function b7N(){},
b7O:function b7O(){},
b7L:function b7L(){},
Wl:function Wl(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cBR(){return new B.xa(null)},
cNU(d,e){var x,w,v,u,t={},s=I.cW[e-1].a[1],r=$.Nz().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.ru():v).a===D.fm}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d1(u+4,1,s)
return A.e2(C.cT,new B.c8r(t,s,e),d,!0,null,null,!1,y.l)},
ceO(d){return A.dt(0,0,0,0,0,C.j.d1(C.f.al(6+d*1.2),25,90))},
cdI(d){return E.bq(C.j.aI(d,60))+":"+C.c.dt(E.bq(C.j.a3(d,60)),2,"\u0660")},
crc(d){return A.e2(C.cT,new B.c9o($.Nz()),d,!0,null,null,!1,y.H)},
Ns(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl9()
break A}return x},
cPf(d,e,f){var x,w=new B.c9H(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
crl(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.ap.f3(a4,null))
s=y.Y
r=s.a(J.at(x,"rec"))
w=r==null?C.cN:r
q=s.a(J.at(x,"last"))
v=q==null?C.cN:q
u=new B.c9G()
s=J.at(v,"recovered")
t=A.n(s==null?"":s)
s=A.n(u.$1(J.at(w,"wall")))
p=A.n(u.$1(J.at(w,"source")))
o=A.n(u.$1(J.at(w,"ctxRate")))
n=A.n(u.$1(J.at(w,"pcmPeak")))
m=A.n(u.$1(J.at(w,"ctxState")))
l=A.n(u.$1(J.at(w,"stopMs")))
k=A.n(u.$1(J.at(v,"prepMs")))
j=A.n(u.$1(J.at(v,"ms")))
i=A.n(u.$1(J.at(v,"featMs")))
h=A.n(u.$1(J.at(v,"encMs")))
g=A.n(u.$1(J.at(v,"decMs")))
f=A.n(u.$1(J.at(v,"wallMs")))
e=A.n(u.$1(J.at(v,"backend")))
d=A.n(u.$1(J.at(v,"threads")))
a0=J.aO(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.k(J.at(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.k(J.at(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
I1:function I1(d,e){this.a=d
this.b=e},
Wm:function Wm(d,e,f,g,h){var _=this
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
b7P:function b7P(d){this.a=d},
b7Q:function b7Q(d){this.a=d},
b7R:function b7R(d){this.a=d},
xa:function xa(d){this.a=d},
a0Y:function a0Y(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bNg:function bNg(d){this.a=d},
bNf:function bNf(d,e){this.a=d
this.b=e},
bNh:function bNh(d){this.a=d},
bNe:function bNe(d,e){this.a=d
this.b=e},
bNi:function bNi(){},
bN2:function bN2(){},
bN8:function bN8(d,e,f){this.a=d
this.b=e
this.c=f},
bN9:function bN9(){},
bNc:function bNc(d){this.a=d},
bNb:function bNb(){},
bNd:function bNd(d){this.a=d},
bN5:function bN5(d,e){this.a=d
this.b=e},
bN6:function bN6(d){this.a=d},
bN4:function bN4(){},
bN7:function bN7(d){this.a=d},
bN3:function bN3(d){this.a=d},
bNa:function bNa(d,e){this.a=d
this.b=e},
I2:function I2(d,e,f){this.c=d
this.d=e
this.a=f},
YK:function YK(d,e){this.c=d
this.a=e},
c8r:function c8r(d,e,f){this.a=d
this.b=e
this.c=f},
c8o:function c8o(d,e,f){this.a=d
this.b=e
this.c=f},
c8q:function c8q(d,e){this.a=d
this.b=e},
c8n:function c8n(d,e){this.a=d
this.b=e},
c8m:function c8m(d,e){this.a=d
this.b=e},
c8p:function c8p(d,e){this.a=d
this.b=e},
c8i:function c8i(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c8h:function c8h(d,e,f){this.a=d
this.b=e
this.c=f},
c8j:function c8j(d){this.a=d},
c8k:function c8k(d){this.a=d},
c8l:function c8l(d,e){this.a=d
this.b=e},
EL:function EL(d,e){this.a=d
this.b=e},
DI:function DI(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a3v:function a3v(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
c_U:function c_U(){},
c09:function c09(d,e){this.a=d
this.b=e},
c0d:function c0d(d){this.a=d},
c0e:function c0e(d){this.a=d},
c0f:function c0f(d,e,f){this.a=d
this.b=e
this.c=f},
c0h:function c0h(d){this.a=d},
c0i:function c0i(d){this.a=d},
c0g:function c0g(){},
c0k:function c0k(d){this.a=d},
c0j:function c0j(d){this.a=d},
c0l:function c0l(d,e){this.a=d
this.b=e},
c0n:function c0n(d){this.a=d},
c0o:function c0o(d){this.a=d},
c0m:function c0m(){},
c08:function c08(d,e,f){this.a=d
this.b=e
this.c=f},
c0a:function c0a(d,e,f){this.a=d
this.b=e
this.c=f},
c01:function c01(d){this.a=d},
c02:function c02(d){this.a=d},
c00:function c00(){},
c03:function c03(){},
c04:function c04(d,e){this.a=d
this.b=e},
c0t:function c0t(d){this.a=d},
c0u:function c0u(d){this.a=d},
c0v:function c0v(d,e){this.a=d
this.b=e},
c0s:function c0s(d){this.a=d},
c0w:function c0w(d,e){this.a=d
this.b=e},
c07:function c07(){},
c06:function c06(d){this.a=d},
c05:function c05(d,e){this.a=d
this.b=e},
c0c:function c0c(d){this.a=d},
c0b:function c0b(d){this.a=d},
c0p:function c0p(){},
c0q:function c0q(){},
c0r:function c0r(){},
c_V:function c_V(d,e,f){this.a=d
this.b=e
this.c=f},
c_W:function c_W(d){this.a=d},
c_Y:function c_Y(){},
c_X:function c_X(){},
c_Z:function c_Z(d){this.a=d},
c0_:function c0_(d){this.a=d},
E0:function E0(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
DH:function DH(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a3u:function a3u(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
c_D:function c_D(){},
c_M:function c_M(d,e){this.a=d
this.b=e},
c_N:function c_N(d){this.a=d},
c_L:function c_L(){},
c_P:function c_P(d){this.a=d},
c_O:function c_O(d,e){this.a=d
this.b=e},
c_Q:function c_Q(d,e){this.a=d
this.b=e},
c_H:function c_H(d,e){this.a=d
this.b=e},
c_I:function c_I(d,e,f){this.a=d
this.b=e
this.c=f},
c_J:function c_J(d,e,f){this.a=d
this.b=e
this.c=f},
c_E:function c_E(d,e,f){this.a=d
this.b=e
this.c=f},
c_F:function c_F(d,e,f){this.a=d
this.b=e
this.c=f},
c_G:function c_G(d,e){this.a=d
this.b=e},
c_K:function c_K(d){this.a=d},
c_R:function c_R(){},
c_S:function c_S(d,e){this.a=d
this.b=e},
c_T:function c_T(d,e){this.a=d
this.b=e},
DG:function DG(d){this.a=d},
a3t:function a3t(d){this.d=d
this.c=this.a=null},
c_u:function c_u(){},
c_B:function c_B(d){this.a=d},
c_C:function c_C(){},
c_A:function c_A(d,e){this.a=d
this.b=e},
c_z:function c_z(d,e,f){this.a=d
this.b=e
this.c=f},
c_y:function c_y(d,e,f){this.a=d
this.b=e
this.c=f},
c_x:function c_x(d){this.a=d},
c_v:function c_v(d){this.a=d},
c_w:function c_w(d){this.a=d},
c9o:function c9o(d){this.a=d},
c9n:function c9n(d){this.a=d},
c9i:function c9i(d,e){this.a=d
this.b=e},
c9k:function c9k(){},
c9j:function c9j(){},
c9l:function c9l(d,e){this.a=d
this.b=e},
c9m:function c9m(d,e){this.a=d
this.b=e},
akA:function akA(d){this.a=d},
b7y:function b7y(d){this.a=d},
c9H:function c9H(){},
c9I:function c9I(){},
DJ:function DJ(d,e,f){this.c=d
this.d=e
this.a=f},
a3w:function a3w(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
c0x:function c0x(d){this.a=d},
c0y:function c0y(d){this.a=d},
c0z:function c0z(d,e){this.a=d
this.b=e},
c0A:function c0A(d){this.a=d},
c0C:function c0C(d){this.a=d},
c0B:function c0B(d){this.a=d},
c9G:function c9G(){}},D,R,O,I,E,F
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
B.akB.prototype={
rh(){var x=this,w=x.a
if(w!=null)return A.er(w,y.m)
w=x.b
return w==null?x.b=new B.b7z(x).$0():w},
uD(d,e){return this.aOQ(d,e,e)},
aOQ(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
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
r=B.cEo(s)
throw A.t(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$uD,w)},
ou(d,e){var x=A.en(d[e])
if(x==null)x=null
return x===!0},
Ne(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$Ne=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.rh(),$async$Ne)
case 7:r=h.cU(g.cQ(e,"support",null,null,null,null))
q=s.ou(r,"worker")
p=s.ou(r,"wasm")
o=s.ou(r,"mic")
n=s.ou(r,"audio")
s.ou(r,"webgpu")
m=s.ou(r,"secure")
s.ou(r,"ios")
l=A.jX(r.memory)
if(l==null)l=null
if(l==null)l=0
s.ou(r,"isolated")
k=A.jX(r.cores)
if(k!=null)C.f.al(k)
v=new B.Wn(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a4i
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Ne,w)},
EL(){var x=0,w=A.j(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$EL=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.rh(),$async$EL)
case 8:x=7
return A.c(m.eH(l.cU(k.cQ(e,"storage",null,null,null,null)),y.A),$async$EL)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.al(A.dU(r.quota))
p=C.f.al(A.dU(r.usage))
v=new A.auJ(q,p)
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
return A.i($async$EL,w)},
blt(){var x=y.K
A.Qp(this.rh().bJ(new B.b7C(),x),x)},
rg(d,e){var x=A.jX(d[e])
x=x==null?null:C.f.al(x)
return x==null?0:x},
biR(d,e,f){return this.uD(new B.b7B(this,d,e,f),y.C)},
galA(){var x,w
try{x=A.ku(b.G.sessionStorage)
return x}catch(w){return null}},
gatb(){var x=A.en(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a9P(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.en(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gatb())return!1
l=A.en(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cU(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.S(x.userAgent)
l=A.jX(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.q(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aE("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.k(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aE("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.jX(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.galA()
l=l==null?f:A.q(A.cQ(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dW(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.ku(m.localStorage)
m=o
m=m==null?f:A.q(A.cQ(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dW(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
arI(){var x,w,v,u,t,s,r=null
try{x=this.galA()
if(x!=null)A.cQ(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cU(x.location)
u=A.S(v.hash)
t=A.S(v.search)
s=A.bv(A.S(A.cU(x.document).baseURI),0,r).a2("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cQ(v,"replace",s+t+x,r,r,r)},
biz(){var x,w=null,v=b.G,u=A.cU(v.history),t=A.jX(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cQ(u,"back",w,w,w,w)
else{x=A.S(A.cU(v.document).baseURI)
A.cQ(A.cU(v.location),"replace",A.bv(x,0,w).a2("./").k(0)+"#/",w,w,w)}},
aa0(d,e,f,g,h){return this.uD(new B.b7G(this,e,d,f,h,g),y.H)},
aa4(){return this.uD(new B.b7H(this),y.D)},
a4a(){var x=null,w=this.a
if(w!=null)A.cQ(w,"cancelRecording",x,x,x,x)},
an_(d){var x,w,v=this,u=A.q(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.rg(d,"ms")
w=A.jX(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.Ku(u,x,w,v.rg(d,"frames"),v.rg(d,"tokens"),v.ou(d,"retried"),v.rg(d,"encMs"),v.rg(d,"decMs"),v.rg(d,"featMs"))},
ajj(d){var x={}
x.words=d
return x},
awi(d,e){return this.uD(new B.b7J(this,d,e),y._)},
bnF(d,e){return this.uD(new B.b7I(this,d,e),y._)},
Li(d,e){return this.blz(d,e)},
blz(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Li=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.rh(),$async$Li)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.aj(d).i("av<1,o>")
o=A.a9(new A.av(d,new B.b7D(),o),o.i("aW.E"))
x=11
return A.c(A.eH(A.cU(A.cQ(r,"play",o,e,null,null)),y.y),$async$Li)
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
return A.i($async$Li,w)},
MW(){var x=null,w=this.a
if(w!=null)A.cQ(w,"stopPlayback",x,x,x,x)},
JM(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.S(A.cQ(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bmP(){var x,w,v=null
try{x=this.a
if(x!=null)A.cQ(x,"resetDevice",v,v,v,v)}catch(w){}},
a7q(d){var x=this.a
if(x!=null)A.cQ(x,"prefetch",d,null,null,null)}}
B.Wn.prototype={}
B.Ks.prototype={
gn6(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.Ku.prototype={
gTq(){var x=this,w=C.f.aA(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.Kt.prototype={}
B.lM.prototype={
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
$ibK:1}
B.nN.prototype={
S(){return"WordStatus."+this.b}}
B.Tt.prototype={}
B.n6.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.J4.prototype={
gMU(){var x,w=this,v=w.d
if(v===$){x=new B.aYy(w).$0()
w.d!==$&&A.aq()
w.d=x
v=x}return v},
gK5(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.d===D.a4J&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbjI(){return J.h8(this.gMU(),new B.aYx()).gM(0)},
gtE(){var x=this.a
return x.length!==0&&this.gbjI()===x.length&&this.gK5().length===0}}
B.FP.prototype={
S(){return"AyahStatus."+this.b}}
B.rF.prototype={}
B.akC.prototype={
a71(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.ru():x},
b0O(d){var x=this,w=B.b7M(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cme(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
aqS(){var x=Date.now(),w=B.b7M(new A.aP(x,0,!1))
x=this.c
return x===w||x===B.cme(w)?this.d:0},
avj(d,e,f,g){var x=this,w=new A.aP(Date.now(),0,!1),v=x.a71(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.fm:D.ps,s=new B.rF(t,u,w.h6()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.b0O(w)
return s},
a6U(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cW[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.ru():s).a===D.fm)++u}return u},
bix(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cW[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.ru():s).a===D.ps)++u}return u},
gaui(){var x=this.a,w=A.y(x).i("c3<2>")
return new A.ai(new A.c3(x,w),new B.b7N(),w.i("ai<Y.E>")).gM(0)},
gazW(){var x=this.a,w=A.y(x).i("bM<1>")
w=A.mz(new A.bM(x,w),new B.b7O(),w.i("Y.E"),y.S)
w=A.eU(w,A.y(w).i("Y.E"))
x=A.a9(w,A.y(w).c)
C.b.lG(x)
return x},
du(){var x,w,v,u,t,s=this,r=y.N,q=A.C(r,y.L)
for(x=s.a,x=new A.eA(x,A.y(x).i("eA<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.a9(x,A.y(x).c)
return A.I(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
bep(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b68(x,300,A.y(x).c),x=new A.K8(J.as(x.a),x.b,A.y(x).i("K8<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gG()
s=C.j.aI(t,1000)
t=C.j.a3(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.ru():q).a===D.fm?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.ru()
r=u.h(0,r)
o.push(A.I(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.ru():r).c.iG()],w,v))}return o},
bj8(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.K)(d),++u){t=d[u]
s=A.ey(t.h(0,"surah"))*1000+A.ey(t.h(0,"ayah"))
r=w.h(0,C.j.aI(s,1000)*1000+C.j.a3(s,1000))
if((r==null?$.ru():r).c.iG()===t.h(0,"updated_at"))v.K(0,s)}},
bjg(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.as(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gG()
if(!u.b(s))continue
r=A.ar(s.h(0,"surah"))
q=r==null?null:C.f.bB(r)
r=A.ar(s.h(0,"ayah"))
p=r==null?null:C.f.bB(r)
o=A.dH(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cW[q-1].a[1])
if(r)continue
n=B.cK2(s.h(0,"status"))
if(n===D.pr)continue
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
v.p(0,r,new B.rF(n,C.j.d1(l==null?0:l,0,100),o.h6()))
w.K(0,r)
t=!0}return t}}
B.Wl.prototype={
Jv(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Wl(w,v,u,t,f==null?x.e:f)},
bcC(d){var x=null
return this.Jv(x,x,d,x,x)},
aqn(d){var x=null
return this.Jv(x,d,x,x,x)},
bcG(d){var x=null
return this.Jv(x,x,x,x,d)},
bbZ(d){var x=null
return this.Jv(d,x,x,x,x)},
bcD(d){var x=null
return this.Jv(x,x,x,d,x)},
du(){var x=this
return A.I(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.I1.prototype={
S(){return"ModelState."+this.b}}
B.Wm.prototype={
vP(){var x=this.Q
return x==null?this.Q=new B.b7P(this).$0():x},
qQ(d){return this.ay8(d)},
ay8(d){var x=0,w=A.j(y.H),v=this
var $async$qQ=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a5()
x=2
return A.c(A.iq("mt.tutor.settings",C.ap.hl(d.du(),null)),$async$qQ)
case 2:return A.h(null,w)}})
return A.i($async$qQ,w)},
A4(){var x=0,w=A.j(y.H),v=this,u
var $async$A4=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a5()
x=2
return A.c(A.iq("mt.tutor.progress",C.ap.hl(v.c.du(),null)),$async$A4)
case 2:u=v.as
if(u!=null)u.au()
v.as=A.cR(C.w,v.gaF0())
return A.h(null,w)}})
return A.i($async$A4,w)},
ME(d,e,f){return this.ayW(d,e,f)},
ayW(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$ME=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.aZ(d,e,f)
x=2
return A.c(A.iq("mt.tutor.last",C.ap.hl(A.I(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$ME)
case 2:return A.h(null,w)}})
return A.i($async$ME,w)},
Dt(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Dt=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.VB||n===D.k2){x=1
break}s.f=D.VB
s.y=null
s.a5()
u=4
n=A.lN().geK().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lN().geK().h(0,"tutor_threads")
p=A.dW(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.biR(new B.b7Q(s),n,p),$async$Dt)
case 7:s.x=e
s.f=D.k2
n=A.lN().geK().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.rp().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a8(m)
if(n instanceof B.lM){q=n
s.f=D.aUa
s.y=q
n=A.lN().geK().h(0,"debug")
if(n==="1")A.rp().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a5()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Dt,w)},
wM(){var x=0,w=A.j(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wM=A.e(function(a0,a1){if(a0===1){t.push(a1)
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
return A.c(p.aS("quran_tutor_progress").d9("surah, ayah, status, perfect_count, updated_at"),$async$wM)
case 7:o=a1
n=r.c.bjg(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bep()
if(J.aO(l)===0){x=10
break}h=p
g=A.I(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.ne(h.x,k,k))
x=11
return A.c(f.bnd("quran_tutor_save",!1,g,i),$async$wM)
case 11:r.c.bj8(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.iq("mt.tutor.progress",C.ap.hl(r.c.du(),null)),$async$wM)
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
return A.i($async$wM,w)},
Lz(d){return this.bmR(d)},
bmR(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Lz=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.cd0(t.c.du()).du()
y.f.a(p.h(0,"rows")).en(0,new B.b7R(d))
t.c=B.cd0(p)
x=2
return A.c(t.A4(),$async$Lz)
case 2:v=4
s=$.D().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.ar("quran_tutor_reset",A.I(["p_surah",d],y.N,r),r),$async$Lz)
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
return A.i($async$Lz,w)}}
B.xa.prototype={
O(){var x=$.Nz()
return new B.a0Y(x,new A.ah(C.I,$.X()))}}
B.a0Y.prototype={
W(){var x,w,v=this
v.Z()
x=v.d
x.ac(v.goG())
w=y.a
x.vP().bJ(new B.bNg(v),w)
H.aX0().bJ(new B.bNh(v),w).fB(new B.bNi())
A.Qp(H.ccm(),y.y)},
y3(){if(this.c!=null)this.j(new B.bN2())},
m(){var x,w=this
w.d.U(w.goG())
x=w.e
x.q$=$.X()
x.L$=0
w.a0()},
Qn(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$Qn=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qQ(s.b.bcC(!0)),$async$Qn)
case 3:t=s.a
t.blt()
if(t.a9P()){t.arI()
x=1
break}s.Dt()
case 1:return A.h(v,w)}})
return A.i($async$Qn,w)},
y4(d,e,f){return this.aZv(d,e,f)},
b7D(d){return this.y4(d,null,null)},
aZv(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$y4=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.H(y.q).f.Y(A.aI(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null,null),null,C.w,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.V(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cNU(s,d),$async$y4)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.ME(d,t.a,t.b),$async$y4)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aE(A.aH(new B.bN8(u,d,t),null,r),r),$async$y4)
case 8:if(u.c!=null)u.j(new B.bN9())
case 1:return A.h(v,w)}})
return A.i($async$y4,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gatb()&&!A.O(d,!1).vm())u.push(A.bP(x,x,x,x,C.yV,x,x,t.gbiy(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bP(x,x,x,x,D.av5,x,x,new B.bNc(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bP(x,x,x,x,C.iz,x,x,new B.bNd(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aHW
else w=t?this.aUg():this.aUS()
return L.xX(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aUS(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a4i
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b8k,C.a0],x)
for(t=0;t<4;++t){s=D.aK5[t]
u.push(new A.A(C.bt,A.z(A.a([A.aX(s.a,C.ao,p,18),C.O,new A.bV(1,C.af,A.d(s.b,p,p,p,p,p,G.a1P,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.J(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bzQ,C.H,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bq(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,p,F.aO,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bq(C.f.al(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.H,A.d(q,p,p,p,p,p,A.bB(p,p,r?D.e3:C.cM,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.H,D.byR],x))
x=A.a([new E.dE(u,C.a6,C.aM,p,!0,p),new E.dE(A.J(s,C.q,C.d,C.e,0,C.l),C.a6,C.aM,p,!1,p),D.bIu,C.H],x)
if(v!=null)x.push(new E.dE(A.d(v,p,p,p,p,p,D.bjB,p,p,p),C.a6,C.aM,p,!1,p))
else x.push(A.fq(D.arW,D.bpv,this.gaZO(),A.eq(C.u,C.ah,D.bbm,p,p,p,p)))
x.push(C.a5)
x.push(D.a4e)
return x},
aUg(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.N(r.a.a),p=q.length===0,o=p?C.rO:H.cr5(q),n=t.z,m=A.R(v.amg(C.d8,E.bq(s.gaui())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bq(s.aqS()),k=s.c,j=Date.now()
k=k===B.b7M(new A.aP(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.I2(t,!1,u),A.z(A.a([m,C.O,A.R(v.amg(C.lk,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.v],j)
if(n!=null){t=H.kw(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bq(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bq(m)+"\u2013"+E.bq(l)
k.push(new E.dE(A.z(A.a([D.aub,C.Z,A.R(A.J(A.a([D.blz,A.d(t+" \u2014 "+m,u,u,u,u,u,C.bA,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nN],j),C.h,C.d,C.e,0,u,u),C.a6,C.aM,new B.bN5(v,n),!0,u))}t=C.i.aa(0.08)
k.push(A.aF(u,C.y,!1,u,!0,C.m,u,A.aG(),r,u,u,u,u,u,2,A.cJ(u,new A.cn(4,A.v(14),C.L),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.uz,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.r9,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bN6(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.d_,!0,C.t,u,C.E,u,u,u,u))
k.push(C.v)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.buT)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.K)(o),++x)t.push(v.RJ(o[x]))
C.b.A(k,t)}else{t=A.a([D.aXx,D.aYh,v.RJ(1)],j)
for(w=114;w>=78;--w)t.push(v.RJ(w))
t.push(C.H)
r=v.f
p=A.aX(r?C.yz:C.li,C.ao,u,u)
t.push(A.fg(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,u,C.fe,u,u,u),new B.bN7(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.RJ(w))
C.b.A(k,t)}k.push(C.a0)
k.push(D.CE)
return k},
amg(d,e,f){var x=null,w=y.p
return new E.dE(A.z(A.a([A.aX(d,C.u,x,x),C.O,A.R(A.J(A.a([A.d(e,x,x,x,x,x,C.bA,x,x,x),A.d(f,x,1,C.N,x,x,C.a2t,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a6,C.K,x,!1,x)},
RJ(d){var x,w=null,v=this.d.c,u=I.cW[d-1].a[1],t=v.a6U(d),s=t/u,r=y.p,q=A.am(A.dz(C.P,A.a([A.caI(C.eC,G.cU,w,w,w,w,w,3,s,w),A.d(E.bq(d),w,w,w,w,w,P.a2Q,w,w,w)],r),C.m,C.bm,w),36,36),p=A.d(H.kw(d),w,w,w,w,w,D.bel,w,w,w)
if(t===0)x=E.bq(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bq(t)+" \u0645\u0646 "+E.bq(u)
r=A.a([q,C.cw,A.R(A.J(A.a([p,A.d(x,w,w,w,w,w,A.bB(w,w,t===u?G.cU:C.cM,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bq(C.f.al(s*100))+"\u066a",w,w,w,w,w,D.a2j,w,w,w))
r.push(D.as3)
return new E.dE(A.z(r,C.h,C.d,C.e,0,w,w),C.qp,C.d6,new B.bNa(this,d),!1,w)}}
B.I2.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aXg
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.Ns(x),r,r,r,r,r,D.BP,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.DJ(w,"model load",r))
x.push(C.H)
x.push(A.ci9(C.mj,r,q.gbiQ()))
return new E.dE(A.J(x,C.q,C.d,C.e,0,C.l),C.a6,C.aM,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bq(C.f.al(u/1e6))+" \u0645\u0646 "+E.bq(C.f.al(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,r,C.oV,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fa(x,A.ql(C.eC,C.u,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.H,D.bql],w))
return new E.dE(A.J(x,C.q,C.d,C.e,0,C.l),C.a6,C.aM,r,!1,r)}}}
B.YK.prototype={
t(d){var x=null,w=D.e3.aa(0.1),v=A.v(14),u=A.aK(D.e3.aa(0.4),1)
return A.E(x,A.z(A.a([D.atQ,C.O,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,x,C.BW,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.F(w,x,u,v,x,x,x,C.n),x,x,x,C.aM,C.ae,x,x,x)}}
B.EL.prototype={
S(){return"_Phase."+this.b}}
B.DI.prototype={
O(){return new B.a3v($.Nz(),D.mB)}}
B.a3v.prototype={
gjg(){var x=this.e
return x===$?this.e=this.a.d:x},
gC2(){var x,w=this.a,v=w.f
w=w.c
x=this.gjg()
return H.Nq(w,x,v.yf(w,x)).b},
W(){var x,w=this
w.Z()
x=w.d
x.ac(w.goG())
x.vP()
x.a.a7q(B.aBi(w.a.c,w.gjg()))},
y3(){if(this.c!=null)this.j(new B.c_U())},
m(){var x,w=this,v=w.d
v.U(w.goG())
x=w.Q
if(x!=null)x.au()
v=v.a
v.MW()
v.a4a()
w.a0()},
a_J(d){var x,w,v=this
if(v.f===D.vi)v.d.a.a4a()
x=v.d.a
x.MW()
w=v.Q
if(w!=null)w.au()
v.j(new B.c09(v,d))
x.a7q(B.aBi(v.a.c,d))
w=v.a
if(d<w.e)x.a7q(B.aBi(w.c,d+1))},
S_(d){return this.aVK(d)},
aVK(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$S_=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.vh){u.d.a.MW()
u.j(new B.c0d(u))
x=1
break}t=u.r!=null?D.je:D.mB
u.j(new B.c0e(u))
s=u.d
r=A.a([B.aBi(u.a.c,u.gjg())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.Li(r,q),$async$S_)
case 3:p=f
if(u.c==null||u.f!==D.vh){x=1
break}u.j(new B.c0f(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$S_,w)},
QN(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$QN=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.k2){x=1
break}p=l.a
p.MW()
r=B.Fv(s.gC2()).length
s.j(new B.c0h(s))
o=s.Q
if(o!=null)o.au()
s.Q=A.he(C.eZ,new B.c0i(s))
u=4
o=B.ceO(r)
n=A.dt(0,0,0,350*r,0,0)
x=7
return A.c(p.aa0(l.b.c,o,n,new B.c0j(s),new B.c0k(s)),$async$QN)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lM){q=l
l=s.Q
if(l!=null)l.au()
if(s.c!=null)s.j(new B.c0l(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$QN,w)},
BX(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$BX=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.vi){x=1
break}m=s.Q
if(m!=null)m.au()
s.j(new B.c0n(s))
s.Q=A.he(C.iu,new B.c0o(s))
l=new A.D9()
$.Fy()
l.op()
r=l
u=4
m=s.d.a
x=7
return A.c(m.aa4(),$async$BX)
case 7:q=e
if(q.b<0.8){s.b7C("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.awi(q,B.Fv(s.gC2()).length),$async$BX)
case 8:p=e
s.ch=A.dt(0,0,r.ga5t(),0,0,0)
k=A.lN().geK().h(0,"debug")
if(k==="1"){o=B.crl(m.JM())
A.rp().$1("[tutor] "+s.a.c+":"+s.gjg()+" audio="+C.f.aA(q.b,1)+"s infer="+p.b+"ms total="+r.gCP()+"ms "+p.gTq()+" text="+p.a)
A.rp().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.aA(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aA(p.b/1000,2)+" \u062b\n"+p.gTq()+"\n"+A.n(o)+"\n"+p.a}s.agi(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lM){n=m
m=A.lN().geK().h(0,"debug")
if(m==="1")A.rp().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.JM())
s.a3_(B.Ns(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$BX,w)},
a3_(d,e){var x=this,w=x.Q
if(w!=null)w.au()
if(x.c==null)return
x.j(new B.c08(x,d,e))},
b7C(d){return this.a3_(d,null)},
agi(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.au()
if(s.c==null)return
x=B.cpl(s.gC2(),d)
r.a=null
if(C.c.N(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjg()
t=x.gtE()
r.a=w.avj(v,u,q.b.a,t)
q.A4()}s.j(new B.c0a(r,s,x))},
On(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$On=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.k2){x=1
break}s.j(new B.c01(s))
l=s.Q
if(l!=null)l.au()
s.Q=A.he(C.iu,new B.c02(s))
k=new A.D9()
$.Fy()
k.op()
r=k
u=4
l=g.a
x=7
return A.c(l.bnF(B.aBi(s.a.c,s.gjg()),B.Fv(s.gC2()).length),$async$On)
case 7:q=e
p=B.crl(l.JM())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.aA(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aA(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.aA(r.gCP()/1000,2)+" \u062b)\n"+q.gTq()+"\n"+A.n(p)+"\n"+q.a
A.rp().$1("[tutor-debug] "+s.a.c+":"+s.gjg()+" audio="+C.f.aA(q.c,1)+"s infer="+q.b+"ms total="+r.gCP()+"ms "+q.gTq()+" text="+q.a)
A.rp().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dt(0,0,r.ga5t(),0,0,0)
s.agi(q.a)
n=s.r
if(n!=null){l=n.gtE()
j=n.b
i=A.aj(j).i("ai<1>")
j=A.a9(new A.ai(j,new B.c03(),i),i.i("Y.E"))
A.rp().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.c04(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lM){m=l
A.rp().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.JM())
s.a3_(B.Ns(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$On,w)},
ga1I(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.ru():v).a!==D.fm)return!1}return!0},
t(d){var x,w=this,v=null,u=w.d,t=u.c.a71(w.a.c,w.gjg()),s=u.b,r=s.d&&!w.x&&w.f!==D.je,q=H.kw(w.a.c),p=y.p,o=A.a([A.bP(v,v,v,v,C.iz,v,v,new B.c0t(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aLZ(),m=A.d("\u0622\u064a\u0629 "+E.bq(w.gjg()),v,v,v,v,v,C.mg,v,v,v),l=E.bq(w.gjg()-w.a.d+1),k=w.a
s=A.a([A.z(A.a([m,C.aV,A.d("("+l+" \u0645\u0646 "+E.bq(k.e-k.d+1)+")",v,v,v,v,v,F.aO,v,v,v),C.bD,w.b_B(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.v],p)
if(r)s.push(w.aUb())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.vi&&l!==D.pi}else l=!1
if(l)s.push(w.aJC(m))
else s.push(A.d(w.gC2()+" \ufd3f"+E.bq(w.gjg())+"\ufd3e",v,v,v,v,v,D.kq,C.Y,C.b7,v))}s=A.a([new B.I2(u,!0,v),n,C.B,new E.dE(A.J(s,C.ac,C.d,C.e,0,C.l),D.akL,C.aM,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.je)s.push(w.b96(n))
if(w.r!=null&&w.f===D.je&&w.ch!=null){x=C.f.al(C.j.aI(w.ch.a,1000)/100)
s.push(new A.A(C.bt,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bq(C.j.aI(x,10))+"\u066b"+E.bq(C.j.a3(x,10)))+" \u062b",v,v,v,v,v,F.aO,C.Y,v,v),v))}n=w.as
if(n!=null)s.push(new A.A(C.aM,A.d(n,v,v,v,v,v,D.BP,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.DJ(n,"check "+w.a.c+":"+w.gjg(),v))}s.push(w.aKc())
s.push(C.a0)
s.push(A.iz(C.u,C.K,v,new B.c0u(w),D.bnf,D.bsB,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga1I()
s.push(new E.dE(A.z(A.a([D.aqv,C.Z,A.R(A.J(A.a([D.buf,A.d(w.ga1I()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,v,F.aO,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nN],p),C.h,C.d,C.e,0,v,v),C.a6,C.aM,new B.c0v(w,d),n,v))}n=A.lN().geK().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dg(D.arV,D.bs3,u.f===D.k2&&w.f!==D.pi?w.gaKW():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.A(C.hP,A.u4(n,F.aO,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn6()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,v,F.aO,v,v,v))}p.push(A.b8(D.bto,v,v,v,new B.c0w(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.CE)
return L.xX(o,s,q)},
aLZ(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.am(A.ft(new B.c06(this),w,null,C.ad,new B.c07()),36,null)},
b_B(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fm)return D.b8x
x=d.b
w=E.bq(x)
v=E.bq(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c1:C.qY
u.push(new A.A(D.alv,A.aX(r,s?G.cU:C.eX,q,16),q))}return A.Km(A.z(u,C.h,C.d,C.G,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aUb(){var x=null
return A.bu(!1,A.v(12),!0,A.E(x,D.agu,C.k,x,x,new A.F(C.pU,x,x,A.v(12),x,x,x,C.n),x,x,x,x,D.akh,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.c0c(this),x,x,x,x,x,x,x)},
aJC(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.at(d.gMU(),w)
A:{if(D.j7===v){u=D.kq.cv(G.cU)
break A}if(D.v1===v){u=D.kq.a4N(D.e3,C.fN,D.e3)
break A}if(D.v2===v){u=D.kq.a4N(D.eW,C.fN,D.eW)
break A}u=D.kq.a4N(C.eX,C.j2,C.c8)
break A}t=x[w]
r.push(new A.eP(t.a,s,s,C.bv,s,s,s,s,s,s,u))
r.push(O.BF)}x=E.bq(this.gjg())
r.push(A.ev(s,s,s,s,s,s,s,s,s,D.kq.cv(C.ao),"\ufd3f"+x+"\ufd3e"))
return A.Dm(A.ev(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Y,C.b7)},
b96(d){var x,w,v,u,t,s,r=this.w
if(C.c.N(d.c).length===0)return D.bHR
if(d.gtE()){x=r==null
if((x?null:r.a)===D.fm&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fm?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bq(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.E0(G.cU,C.c1,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMU()
w=J.dG(x)
v=w.io(x,new B.c0p()).gM(0)
u=w.io(x,new B.c0q()).gM(0)
t=w.io(x,new B.c0r()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bq(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bq(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bq(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gK5().length!==0)x.push(E.bq(d.gK5().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eW:D.e3
x=C.b.aB(x," \u2022 ")
s=d.gK5().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aB(d.gK5(),"\u060c "):""
return new B.E0(w,C.nE,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aKc(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.k2,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aI(new A.aP(f,0,!1).dD(w).a,1e6)}v=C.j.aI(B.ceO(B.Fv(j.gC2()).length).a,1e6)
f=j.gb6b()
w=96+26*j.y
u=D.eW.aa(0.25)
w=A.hS(i,A.a6p(C.P,A.E(i,D.as7,C.k,i,i,D.a8e,i,84,i,i,i,i,i,84),i,C.aU,new A.F(u,i,i,i,i,i,i,C.bW),C.FA,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cu)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.cdI(x)+" / "+B.cdI(v),i,i,i,i,i,K.oU,i,i,i)
return A.J(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,i,F.aO,i,i,i),A.b8(D.byQ,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.eD((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bq(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bq(t)+" \u062b)"
return new A.A(C.qk,A.J(A.a([C.w9,C.a0,D.bqO,A.d(h,i,i,i,i,i,F.aO,C.Y,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.vh
r=j.r
f=r==null
w=!f
q=w&&r.gtE()
u=A.aX(s?C.nF:K.Ic,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i,i)
o=A.eq(i,i,D.bbj,i,i,i,i)
u=A.R(new A.Ai(C.a53,!0,new B.c_V(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Zn(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.JT[n]
p.push(new A.ef(m,i,A.d("\xd7"+E.bq(m),i,i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.z(A.a([u,C.O,A.nD(new B.c_W(j),p,A.de([h.b.b],o),!1,A.kA(i,i,i,new A.bg(new B.c_X(),l),i,i,i,i,new A.bg(new B.c_Y(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cR),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb1E():i
u=A.aX(f?D.qU:C.nE,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,i,C.cp,i,i,i)
p=q?C.ir:C.u
h=A.a([o,C.v,A.fq(u,f,h,A.eq(p,q?C.i:C.ah,D.u9,i,i,i,i))],k)
if(w&&j.gjg()<j.a.e)C.b.A(h,A.a([C.B,q?A.fq(D.avs,D.bxy,new B.c_Z(j),A.eq(G.cU,C.ah,D.u9,i,i,i,i)):A.b8(D.bnG,i,i,i,new B.c0_(j),i,i)],k))
if(w){f=j.gjg()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.A(C.hQ,A.d(j.ga1I()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,i,K.uH,C.Y,i,i),i))
return A.J(h,C.ac,C.d,C.e,0,C.l)}}}
B.E0.prototype={
t(d){var x=this,w=null,v=x.c,u=v.aa(0.12),t=A.v(14),s=A.aK(v.aa(0.5),1),r=y.p
return A.E(w,A.z(A.a([A.aX(x.d,v,w,w),C.O,A.R(A.J(A.a([A.d(x.e,w,w,w,w,w,A.bB(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.T,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bN,A.d(x.f,w,w,w,w,w,C.BW,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.F(u,w,s,t,w,w,w,C.n),w,w,w,C.aM,C.ae,w,w,w)}}
B.DH.prototype={
O(){var x=y.S
return new B.a3u($.Nz(),A.C(x,y.B),A.aT(x),A.C(x,y.N),A.er(null,y.H))}}
B.a3u.prototype={
W(){this.Z()
this.d.ac(this.goG())},
y3(){if(this.c!=null)this.j(new B.c_D())},
m(){var x,w=this,v=w.d
v.U(w.goG())
x=w.y
if(x!=null)x.au()
v.a.a4a()
w.a0()},
IB(d){return this.b5X(d)},
b5X(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$IB=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.c_M(t,d))
r=t.y
if(r!=null)r.au()
t.y=A.he(C.eZ,new B.c_N(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.ceO(B.Fv(H.Nq(q,d,p.yf(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dt(0,0,0,350*B.Fv(H.Nq(p,d,o.yf(p,d)).b).length,0,0)
x=6
return A.c(r.a.aa0(r.b.c,q,p,new B.c_O(t,d),new B.c_P(t)),$async$IB)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lM){s=r
r=t.y
if(r!=null)r.au()
if(t.c!=null)t.j(new B.c_Q(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$IB,w)},
FZ(d,e){return this.aNe(d,e)},
aNe(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$FZ=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.au()
s.j(new B.c_H(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.aa4()
if(e&&n!=null)s.IB(n)
q=null
u=4
x=7
return A.c(r,$async$FZ)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lM){p=o
s.j(new B.c_I(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bJ(new B.c_J(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$FZ,w)},
gaXY(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b2z(){this.j(new B.c_K(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.k2,o=s.e,n=s.gaXY(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("c3<2>")
x=new A.ai(new A.c3(m,l),new B.c_R(),l.i("ai<Y.E>")).gM(0)
l=H.kw(s.a.c)
m=y.p
q=A.a([new B.I2(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bq(s.a.d)+" \u0644\u062d\u062f "+E.bq(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,r,F.aO,r,r,r),C.v],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b7E(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,r,D.BP,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.DJ(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bq(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aI(new A.aP(v,0,!1).dD(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.cdI(v),r,r,r,r,r,K.oU,C.Y,r,r)
j=A.fa(A.v(6),A.ql(C.eC,D.eW,6,s.x,r),C.aC)
u=o<s.a.e
t=A.aX(u?R.I6:C.nF,r,r,r)
C.b.A(q,A.a([v,C.H,j,C.v,A.fq(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,r,C.cp,r,r,r),new B.c_S(s,o),A.eq(C.u,C.ah,D.u9,r,r,r,r))],m))}else if(n!=null){j=p?new B.c_T(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bq(n)
q.push(A.fq(D.ati,A.d(v,r,r,r,r,r,C.cp,r,r,r),j,A.eq(C.u,C.ah,D.u9,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aXJ)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cU:D.e3
v=k?C.nw:C.nE
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bq(x)
u=s.a
u=k+" \u0645\u0646 "+E.bq(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.E0(j,v,k,u,r),A.dg(D.avf,D.byd,s.gb2y(),r)],m))}q.push(C.v)
q.push(D.CE)
return L.xX(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b7E(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.asD
else if(l.r.n(0,d))x=N.uc
else if(i!=null)x=D.asV
else if(j!=null){w=j.gtE()?C.c1:D.ap3
x=A.aX(w,j.gtE()?G.cU:D.e3,k,k)}else x=D.arc
w=y.p
v=A.a([A.z(A.a([A.d("\u0622\u064a\u0629 "+E.bq(d),k,k,k,k,k,C.a2B,k,k,k),C.bD,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,k,D.a2v,k,k,k))
if(j!=null&&!j.gtE()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMU()
o=J.bc(p)
n=o.h(p,r)
A:{if(D.j7===n){m=G.cU
break A}if(D.v1===n){m=D.e3
break A}if(D.v2===n){m=D.eW
break A}m=C.eX
break A}m=D.kq.bdh(m,o.h(p,r)===D.v3?C.j2:k,22)
C.b.A(t,A.a([new A.eP(q.a,k,k,C.bv,k,k,k,k,k,k,m),O.BF],u))}w=A.a([C.aj,A.Dm(A.ev(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Y,C.b7)],w)
if(C.c.N(j.c).length===0)w.push(D.btD)
C.b.A(v,w)}return new E.dE(A.J(v,C.ac,C.d,C.e,0,C.l),C.bP,C.d6,k,!1,k)}}
B.DG.prototype={
O(){return new B.a3t($.Nz())}}
B.a3t.prototype={
W(){this.Z()
var x=this.d
x.ac(this.goG())
x.vP()},
y3(){if(this.c!=null)this.j(new B.c_u())},
m(){this.d.U(this.goG())
this.a0()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gazW(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.i0(o,0,new B.c_B(q))
v=C.b.i0(o,0,new B.c_C())
o=y.p
o=A.a([A.z(A.a([A.R(s.YA(E.bq(q.gaui()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.O,A.R(s.YA(E.bq(q.aqS()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.O,A.R(s.YA(E.bq(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.v,new E.dE(A.J(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bq(C.f.al(w*100/v))+"\u066a",r,r,r,r,r,C.bA,r,r,r),C.H,A.fa(A.v(6),A.ql(C.eC,G.cU,8,w/v,r),C.aC),C.aj,A.d(E.bq(w)+" \u0645\u0646 "+E.bq(v)+" \u0622\u064a\u0629",r,r,r,r,r,F.aO,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a6,C.aM,r,!1,r)],o)
if(p.length===0)o.push(D.aXZ)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.K)(p),++t)o.push(s.b7G(p[t]))
o.push(C.B)
u=$.D().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,r,F.aO,r,r,r))
return L.xX(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
YA(d,e){var x=null
return new E.dE(A.J(A.a([A.d(d,x,x,x,x,x,D.biy,x,x,x),A.d(e,x,x,x,x,x,C.a32,C.Y,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a6,C.K,x,!1,x)},
b7G(d){var x=null,w=this.d.c,v=I.cW[d-1].a[1],u=w.a6U(d),t=w.bix(d),s=y.p,r=A.z(A.a([A.R(A.d(H.kw(d),x,x,x,x,x,C.bA,x,x,x),1),A.d(E.bq(C.f.al(u*100/v))+"\u066a",x,x,x,x,x,D.bjC,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fa(A.v(6),A.ql(C.eC,G.cU,7,u/v,x),C.aC),p=E.bq(u),o=E.bq(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bq(t):""
return new E.dE(A.J(A.a([r,C.H,q,C.aj,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,x,F.aO,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a6,C.aM,new B.c_A(this,d),!1,x)},
Oq(d){return this.aLh(d)},
aLh(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$Oq=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cW[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e2(C.cT,new B.c_z(v,d,u),t,!0,null,null,!1,y.H),$async$Oq)
case 2:return A.h(null,w)}})
return A.i($async$Oq,w)}}
B.akA.prototype={
RZ(d,e){var x=null,w=A.km(x,x,x,x,x,x,x,x,x,x,x,D.baT,C.K,x,x,x,x,C.k1,x,x)
return A.b8(A.d(d,x,x,x,x,x,C.mf,x,x,x),x,x,x,new B.b7y(e),x,w)},
t(d){var x=this,w=y.p
return new E.dE(A.J(A.a([D.bxj,C.H,D.byP,A.cK(C.ar,A.a([x.RZ("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.RZ("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.ax,0,12),D.bmS,x.RZ("tanzil.net","https://tanzil.net"),D.bAs,x.RZ("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a6,C.aM,null,!1,null)}}
B.DJ.prototype={
O(){return new B.a3w()}}
B.a3w.prototype={
gan5(){var x=this.a
return B.cPf(x.c,x.d,$.cfq().JM())},
S0(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$S0=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.c0x(s))
v=3
r=A.c8O()
n=s.gan5()
m=y.N
q=A.C(m,m)
J.dZ(q,"app","mogtama3y")
J.dZ(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dZ(q,"ua",m)}x=6
return A.c(A.ab2(n,null,C.GG,q),$async$S0)
case 6:if(s.c!=null)s.j(new B.c0y(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cb?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.c0z(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.c0A(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$S0,w)},
t(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bu(!1,t,!0,new A.A(C.l4,A.z(A.a([A.aX(u.d?C.yz:C.li,C.c8,t,18),C.bM,D.bzD],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.c0C(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.E(t,A.u4(u.gan5(),D.beM,t,C.z),C.k,t,t,new A.F(C.pU,t,t,x,t,t,t,C.n),t,t,t,D.akl,C.eg,t,t,1/0))}if(u.f)s.push(D.bn9)
else{x=A.km(t,t,t,t,t,t,t,t,t,t,t,C.a0R,C.K,t,t,t,t,C.k1,t,t)
w=u.e
v=w?t:u.gb7F()
s.push(A.fg(w?C.a14:D.auE,t,D.bwh,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,t,D.a2v,t,t,t))
return new A.A(C.aM,A.J(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["al<~>()","~()","M(nN)","al<Ku>()","al<Ks>()","al<Kt>()","a7<nN>()","M(rF)","bG(oT)","DI(u)","DG(u)","M(n6)","DH(u)","M(J4)"])
B.b7z.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.S(A.cU(b.G.document).baseURI)
q=A.bv(r,0,null).a2("quran_tutor/tutor.js?v=3").k(0)
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
m=B.cEp("network",A.n(o))
throw A.t(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:314}
B.b7C.prototype={
$1(d){var x=null
return A.c37(A.cQ(d,"persist",x,x,x,x))},
$S:1155}
B.b7B.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.rh(),$async$$0)
case 4:x=3
return A.c(n.eH(m.cU(l.cQ(e,"loadModel",A.c3Q(new B.b7A(u.b)),u.c,u.d,null)),y.m),$async$$0)
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
v=new B.Ks(o,t,s,r,q.rg(p,"threads"),q.ou(p,"isolated"),q.rg(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b7A.prototype={
$2(d,e){this.a.$2(C.f.al(d),C.f.al(e))},
$S:1156}
B.b7G.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
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
u.onLevel=A.fX(new B.b7E(v.e))
u.onAutoStop=A.fX(new B.b7F(v.f))
x=5
return A.c(A.eH(A.cU(A.cQ(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b7E.prototype={
$1(d){return this.a.$1(d)},
$S:71}
B.b7F.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b7H.prototype={
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
return A.c(t.rh(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eH(p.cU(o.cQ(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.Kt(r,A.dU(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b7J.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.rh(),$async$$0)
case 4:x=3
return A.c(q.eH(p.cU(o.cQ(e,"transcribe",t.audio,t.rate,s.ajj(u.c),null)),y.m),$async$$0)
case 3:v=r.an_(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b7I.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.rh(),$async$$0)
case 4:x=3
return A.c(r.eH(q.cU(p.cQ(e,"transcribeUrl",u.b,t.ajj(u.c),null,null)),y.m),$async$$0)
case 3:v=s.an_(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b7D.prototype={
$1(d){return d},
$S:40}
B.aYy.prototype={
$0(){var x,w,v,u,t=this.a,s=A.c8(t.a.length,D.v3,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aYx.prototype={
$1(d){return d===D.j7},
$S:z+2}
B.c3z.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c9O(e[x],d[x])<0.75)return!1
return!0},
$S:1157}
B.c5G.prototype={
$1(d){return d.length!==0},
$S:10}
B.b7N.prototype={
$1(d){return d.a===D.fm},
$S:z+7}
B.b7O.prototype={
$1(d){return C.j.aI(d,1000)},
$S:59}
B.b7L.prototype={
$1(d){return C.f.bB(d)},
$S:1158}
B.b7P.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iI("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.ap.f3(r,null))
j=A.ar(k.h(0,"n"))
j=j==null?null:C.f.bB(j)
j=C.j.d1(j==null?2:j,1,5)
i=C.b.n(D.JT,k.h(0,"r"))?A.ey(k.h(0,"r")):1
h=A.en(k.h(0,"auto"))
g=A.en(k.h(0,"hide"))
k=A.en(k.h(0,"in"))
s.a.b=new B.Wl(j,i,h!==!1,g===!0,k===!0)}u=2
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
if(q!=null)s.a.c=B.cd0(y.P.a(C.ap.f3(q,null)))
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
n=C.f.bB(A.cS(J.at(o,"s")))
m=C.f.bB(A.cS(J.at(o,"f")))
l=C.f.bB(A.cS(J.at(o,"t")))
if(B.crq(n,m)&&B.crq(n,l)&&m<=l)s.a.z=new A.aZ(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a9P()){k.a.arI()
x=1
break}a1=k
x=18
return A.c(k.a.Ne(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a5()
if(k.b.e)k.Dt()
k.wM()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:112}
B.b7Q.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a5()},
$S:1159}
B.b7R.prototype={
$2(d,e){return C.j.aI(A.eG(A.n(d),null,null),1000)===this.a},
$S:1160}
B.bNg.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.EL(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bNf(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1161}
B.bNf.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bNh.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bNe(x,d))},
$S:z+8}
B.bNe.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bNi.prototype={
$1(d){},
$S:24}
B.bN2.prototype={
$0(){},
$S:0}
B.bN8.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.DI(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bN9.prototype={
$0(){},
$S:0}
B.bNc.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aE(A.aH(new B.bNb(),null,x),x)},
$S:0}
B.bNb.prototype={
$1(d){return D.bBR},
$S:z+10}
B.bNd.prototype={
$0(){return B.crc(this.a)},
$S:0}
B.bN5.prototype={
$0(){var x=this.b
return this.a.y4(x.a,x.b,x.c)},
$S:0}
B.bN6.prototype={
$1(d){return this.a.j(new B.bN4())},
$S:5}
B.bN4.prototype={
$0(){},
$S:0}
B.bN7.prototype={
$0(){var x=this.a
return x.j(new B.bN3(x))},
$S:0}
B.bN3.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bNa.prototype={
$0(){return this.a.b7D(this.b)},
$S:0}
B.c8r.prototype={
$1(d){return new A.je(new B.c8o(this.a,this.b,this.c),null)},
$S:57}
B.c8o.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c8q(u,e),s=this.a,r=new B.c8p(s,e),q=A.d(H.kw(this.c),v,v,v,v,v,C.oQ,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bq(u)+" \u0622\u064a\u0629)",v,v,v,v,v,F.aO,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bq(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bq(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.aj,p,C.v,A.cK(C.ar,n,C.ax,6,8),C.B,A.z(A.a([t.$3("\u0645\u0646",s.b,new B.c8j(s)),C.a11,t.$3("\u0644\u062d\u062f",s.c,new B.c8k(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aXO)
u.push(C.a5)
u.push(A.dq(D.bqg,v,new B.c8l(s,d),A.eq(C.u,C.ah,D.bbg,v,v,v,v)))
return A.cx(!0,new A.A(C.G7,A.J(u,C.ac,C.d,C.G,0,C.l),v),C.K,!0)},
$S:405}
B.c8q.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,u,C.ic,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c7(v,A.d("\u0622\u064a\u0629 "+E.bq(v),u,u,u,u,u,u,u,u,u),C.an,u,w))
return A.R(A.J(A.a([t,Q.GL(C.cT,!0,s,320,new B.c8n(this.b,f),D.bjT,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1163}
B.c8n.prototype={
$1(d){return d==null?null:this.a.$1(new B.c8m(this.b,d))},
$S:51}
B.c8m.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c8p.prototype={
$3(d,e,f){var x=null
return A.aCa(x,A.d(d,x,x,x,x,x,x,x,x,x),new B.c8i(this.a,this.b,e,f))},
$S:1164}
B.c8i.prototype={
$0(){var x=this
return x.b.$1(new B.c8h(x.a,x.c,x.d))},
$S:0}
B.c8h.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c8j.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c8k.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c8l.prototype={
$0(){var x=this.a
return A.O(this.b,!1).ae(new A.V(x.b,x.c))},
$S:0}
B.c_U.prototype={
$0(){},
$S:0}
B.c09.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mB
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.c0d.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.je:D.mB},
$S:0}
B.c0e.prototype={
$0(){var x=this.a
x.f=D.vh
x.as=null},
$S:0}
B.c0f.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.c0h.prototype={
$0(){var x=this.a
x.f=D.vi
x.as=null
x.y=0
x.z=new A.aP(Date.now(),0,!1)
x.ax=null},
$S:0}
B.c0i.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c0g())},
$S:28}
B.c0g.prototype={
$0(){},
$S:0}
B.c0k.prototype={
$1(d){return this.a.y=d},
$S:71}
B.c0j.prototype={
$1(d){return this.a.BX()},
$S:5}
B.c0l.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.je:D.mB
x=this.b
w.as=B.Ns(x)
w.at=x},
$S:0}
B.c0n.prototype={
$0(){var x=this.a
x.f=D.pi
x.ay=Date.now()},
$S:0}
B.c0o.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c0m())},
$S:28}
B.c0m.prototype={
$0(){},
$S:0}
B.c08.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.je:D.mB
x.as=this.b
x.at=this.c},
$S:0}
B.c0a.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.je
x.x=!1},
$S:0}
B.c01.prototype={
$0(){var x=this.a
x.f=D.pi
x.ay=Date.now()
x.as=null},
$S:0}
B.c02.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c00())},
$S:28}
B.c00.prototype={
$0(){},
$S:0}
B.c03.prototype={
$1(d){return d.d!==D.j7},
$S:z+11}
B.c04.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.c0t.prototype={
$0(){return B.crc(this.a)},
$S:0}
B.c0u.prototype={
$1(d){var x=this.a.d
return x.qQ(x.b.aqn(d))},
$S:3}
B.c0v.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aE(A.aH(new B.c0s(this.a),null,x),x)},
$S:0}
B.c0s.prototype={
$1(d){var x=this.a.a
return new B.DH(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.c0w.prototype={
$0(){this.a.d.a.bmP()
this.b.H(y.q).f.Y(D.bco)},
$S:0}
B.c07.prototype={
$2(d,e){return C.aV},
$S:17}
B.c06.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a71(s.c,r).a.a){case 2:s=G.cU
break
case 1:s=D.e3
break
case 0:s=C.ir
break
default:s=u}x=A.v(18)
w=t.f===D.pi?u:new B.c05(t,r)
v=s.aa(0.25)
if(r===t.gjg())s=C.i
s=A.aK(s,r===t.gjg()?2:1)
return A.bu(!1,x,!0,A.E(C.P,A.d(E.bq(r),u,u,u,u,u,C.a29,u,u,u),C.k,u,u,new A.F(v,u,s,u,u,u,u,C.bW),u,u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:69}
B.c05.prototype={
$0(){return this.a.a_J(this.b)},
$S:0}
B.c0c.prototype={
$0(){var x=this.a
return x.j(new B.c0b(x))},
$S:0}
B.c0b.prototype={
$0(){return this.a.x=!0},
$S:0}
B.c0p.prototype={
$1(d){return d===D.v1},
$S:z+2}
B.c0q.prototype={
$1(d){return d===D.v2},
$S:z+2}
B.c0r.prototype={
$1(d){return d===D.v3},
$S:z+2}
B.c_V.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.S_(x)},
$S:0}
B.c_W.prototype={
$1(d){var x=this.a.d
return x.qQ(x.b.bcG(d.ga1(d)))},
$S:115}
B.c_Y.prototype={
$1(d){return d.n(0,C.U)?C.ah:C.i},
$S:4}
B.c_X.prototype={
$1(d){return d.n(0,C.U)?C.u:C.a8},
$S:4}
B.c_Z.prototype={
$0(){var x=this.a
return x.a_J(x.gjg()+1)},
$S:0}
B.c0_.prototype={
$0(){var x=this.a
return x.a_J(x.gjg()+1)},
$S:0}
B.c_D.prototype={
$0(){},
$S:0}
B.c_M.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aP(Date.now(),0,!1)},
$S:0}
B.c_N.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c_L())},
$S:28}
B.c_L.prototype={
$0(){},
$S:0}
B.c_P.prototype={
$1(d){return this.a.x=d},
$S:71}
B.c_O.prototype={
$1(d){return this.a.FZ(this.b,!1)},
$S:5}
B.c_Q.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.Ns(x)
w.as=x},
$S:0}
B.c_H.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.c_I.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.Ns(x))
w.as=x},
$S:0}
B.c_J.prototype={
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
return A.c(n.a.awi(s.b,B.Fv(H.Nq(l,m,k.yf(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cpl(H.Nq(l,m,k.yf(l,m)).b,r.a)
if(C.c.N(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtE()
l.avj(k,m,n.b.a,j)}n.A4()
if(o.c!=null)o.j(new B.c_E(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lM){p=o
o=s.a
if(o.c!=null)o.j(new B.c_F(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.c_G(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:144}
B.c_E.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.c_F.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.Ns(w))
x.as=w},
$S:0}
B.c_G.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.c_K.prototype={
$0(){var x=this.a
x.f.ao(0)
x.w.ao(0)
x.as=null},
$S:0}
B.c_R.prototype={
$1(d){return d.gtE()},
$S:z+13}
B.c_S.prototype={
$0(){return this.a.FZ(this.b,!0)},
$S:0}
B.c_T.prototype={
$0(){return this.a.IB(this.b)},
$S:0}
B.c_u.prototype={
$0(){},
$S:0}
B.c_B.prototype={
$2(d,e){return d+this.a.a6U(e)},
$S:114}
B.c_C.prototype={
$2(d,e){return d+I.cW[e-1].a[1]},
$S:114}
B.c_A.prototype={
$0(){return this.a.Oq(this.b)},
$S:0}
B.c_z.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kw(p),q,q,q,q,q,C.oQ,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.bb(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.ru():r).a.a){case 2:r=G.cU.aa(0.35)
break
case 1:r=D.e3.aa(0.35)
break
case 0:r=C.h0
break
default:r=q}m.push(A.E(C.P,A.d(E.bq(t),q,q,q,q,q,C.ko,q,q,q),C.k,q,q,new A.F(r,q,q,new A.cD(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,q,38))}return A.cx(!0,new A.A(C.h6,A.J(A.a([o,C.aj,D.buy,C.v,new A.dm(D.a84,A.f1(A.cK(C.ar,m,C.ax,6,6),q,C.r,q,q,q,C.x),q),C.a0,A.b8(D.bwk,q,q,q,new B.c_y(w,d,p),q,q)],n),C.ac,C.d,C.G,0,C.l),q),C.K,!0)},
$S:35}
B.c_y.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dd(null,null,!0,null,new B.c_x(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Lz(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e5()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.c_x.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kw(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x,x)
return A.dj(A.a([A.b8(C.ev,x,x,x,new B.c_v(d),x,x),A.b8(C.p5,x,x,x,new B.c_w(d),x,x)],y.p),w,D.bxW)},
$S:14}
B.c_v.prototype={
$0(){A.O(this.a,!1).ae(!1)
return null},
$S:0}
B.c_w.prototype={
$0(){A.O(this.a,!1).ae(!0)
return null},
$S:0}
B.c9o.prototype={
$1(d){var x=this.a
return new A.kN(new B.c9n(x),null,x,null)},
$S:1165}
B.c9n.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.ef(w,t,A.d(E.bq(w),t,t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bmN,C.a0,D.bwK,C.H,A.nD(new B.c9i(s,r),q,A.de([r.a],x),!1,A.kA(t,t,t,new A.bg(new B.c9j(),v),t,t,t,t,new A.bg(new B.c9k(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.iz(C.u,C.K,t,new B.c9l(s,r),D.btO,D.bzU,r.c),A.iz(C.u,C.K,t,new B.c9m(s,r),t,D.bmh,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.aj,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn6(),t,t,t,t,t,F.aO,t,C.b7,t)],u))
x.push(C.B)
x.push(D.a4e)
return A.cx(!0,A.f1(A.J(x,C.ac,C.d,C.e,0,C.l),t,C.r,C.h6,t,t,C.x),C.K,!0)},
$S:1166}
B.c9i.prototype={
$1(d){return this.a.qQ(this.b.bcD(d.ga1(d)))},
$S:115}
B.c9k.prototype={
$1(d){return d.n(0,C.U)?C.ah:C.i},
$S:4}
B.c9j.prototype={
$1(d){return d.n(0,C.U)?C.u:C.a8},
$S:4}
B.c9l.prototype={
$1(d){return this.a.qQ(this.b.bbZ(d))},
$S:3}
B.c9m.prototype={
$1(d){return this.a.qQ(this.b.aqn(d))},
$S:3}
B.b7y.prototype={
$0(){return A.cp(A.bv(this.a,0,null),C.aL,null)},
$S:0}
B.c9H.prototype={
$1(d){var x,w=A.aE("https?://",!0,!1,!1)
w=A.bJ(d,w,"")
x=A.aE("www\\.",!0,!1,!1)
return A.v9(A.bJ(w,x,"www[.]"),A.aE("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c9I(),null)},
$S:40}
B.c9I.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:58}
B.c0x.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.c0y.prototype={
$0(){return this.a.f=!0},
$S:0}
B.c0z.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.c0A.prototype={
$0(){return this.a.e=!1},
$S:0}
B.c0C.prototype={
$0(){var x=this.a
return x.j(new B.c0B(x))},
$S:0}
B.c0B.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c9G.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:232};(function installTearOffs(){var x=a._instance_0u
x(B.akB.prototype,"gbiy","biz",1)
var w
x(w=B.Wm.prototype,"gbiQ","Dt",0)
x(w,"gaF0","wM",0)
x(w=B.a0Y.prototype,"goG","y3",1)
x(w,"gaZO","Qn",0)
x(w=B.a3v.prototype,"goG","y3",1)
x(w,"gb1E","QN",0)
x(w,"gb6b","BX",0)
x(w,"gaKW","On",0)
x(w=B.a3u.prototype,"goG","y3",1)
x(w,"gb2y","b2z",1)
x(B.a3t.prototype,"goG","y3",1)
x(B.a3w.prototype,"gb7F","S0",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a6,[B.akB,B.Wn,B.Ks,B.Ku,B.Kt,B.lM,B.Tt,B.n6,B.J4,B.rF,B.akC,B.Wl])
x(A.ll,[B.b7z,B.b7B,B.b7G,B.b7H,B.b7J,B.b7I,B.aYy,B.b7P,B.bNf,B.bNe,B.bN2,B.bN9,B.bNc,B.bNd,B.bN5,B.bN4,B.bN7,B.bN3,B.bNa,B.c8m,B.c8i,B.c8h,B.c8l,B.c_U,B.c09,B.c0d,B.c0e,B.c0f,B.c0h,B.c0g,B.c0l,B.c0n,B.c0m,B.c08,B.c0a,B.c01,B.c00,B.c04,B.c0t,B.c0v,B.c0w,B.c05,B.c0c,B.c0b,B.c_V,B.c_Z,B.c0_,B.c_D,B.c_M,B.c_L,B.c_Q,B.c_H,B.c_I,B.c_E,B.c_F,B.c_G,B.c_K,B.c_S,B.c_T,B.c_u,B.c_A,B.c_y,B.c_v,B.c_w,B.b7y,B.c0x,B.c0y,B.c0z,B.c0A,B.c0C,B.c0B])
x(A.iN,[B.b7C,B.b7E,B.b7F,B.b7D,B.aYx,B.c5G,B.b7N,B.b7O,B.b7L,B.bNg,B.bNh,B.bNi,B.bN8,B.bNb,B.bN6,B.c8r,B.c8q,B.c8n,B.c8p,B.c8j,B.c8k,B.c0i,B.c0k,B.c0j,B.c0o,B.c02,B.c03,B.c0u,B.c0s,B.c0p,B.c0q,B.c0r,B.c_W,B.c_Y,B.c_X,B.c_N,B.c_P,B.c_O,B.c_J,B.c_R,B.c_z,B.c_x,B.c9o,B.c9i,B.c9k,B.c9j,B.c9l,B.c9m,B.c9H,B.c9I,B.c9G])
x(A.og,[B.b7A,B.c3z,B.b7Q,B.b7R,B.c8o,B.c07,B.c06,B.c_B,B.c_C,B.c9n])
x(A.Ei,[B.nN,B.FP,B.I1,B.EL])
w(B.Wm,A.i7)
x(A.L,[B.xa,B.DI,B.DH,B.DG,B.DJ])
x(A.N,[B.a0Y,B.a3v,B.a3u,B.a3t,B.a3w])
x(A.a3,[B.I2,B.YK,B.E0,B.akA])})()
A.pv(b.typeUniverse,JSON.parse('{"lM":{"bK":[]},"DI":{"L":[],"l":[]},"DH":{"L":[],"l":[]},"DG":{"L":[],"l":[]},"DJ":{"L":[],"l":[]},"Wm":{"aD":[]},"xa":{"L":[],"l":[]},"a0Y":{"N":["xa"]},"I2":{"a3":[],"l":[]},"YK":{"a3":[],"l":[]},"a3v":{"N":["DI"]},"E0":{"a3":[],"l":[]},"a3u":{"N":["DH"]},"a3t":{"N":["DG"]},"akA":{"a3":[],"l":[]},"a3w":{"N":["DJ"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rF"),c:x("ef<x>"),r:x("c7<x>"),k:x("H<n6>"),n:x("H<ef<x>>"),I:x("H<c7<x>>"),R:x("H<hT>"),Z:x("H<aA<o,@>>"),d:x("H<Tt>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bR"),j:x("a7<@>"),L:x("a7<x>"),P:x("aA<o,@>"),f:x("aA<@,@>"),x:x("av<o,x>"),a:x("bG"),K:x("a6"),B:x("J4"),l:x("+(x,x)"),e:x("d5<n6>"),N:x("o"),C:x("Ks"),D:x("Kt"),X:x("Wn"),_:x("Ku"),U:x("ai<o>"),G:x("nN"),q:x("ps"),b:x("bg<U?>"),y:x("M"),i:x("a2"),z:x("@"),S:x("x"),A:x("bR?"),Y:x("aA<@,@>?"),O:x("a6?"),M:x("+quota,usage(x,x)?"),o:x("dJ"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.pr=new B.FP(0,"none")
D.ps=new B.FP(1,"learning")
D.fm=new B.FP(2,"memorized")
D.a84=new A.az(0,1/0,0,320)
D.eW=new A.U(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a8e=new A.F(D.eW,null,null,null,null,null,null,C.bW)
D.e3=new A.U(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.atT=new A.G(C.yL,null,C.c8,null,null,null)
D.by3=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.fe,null,null,null,null,null,null,null,null)
D.bff=new A.r(!0,C.eX,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.buA=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bff,null,null,null,null,null,null,null,null)
D.aL9=x([D.atT,C.H,D.by3,D.buA],y.p)
D.agu=new A.fi(C.x,C.d,C.e,C.h,null,C.l,null,0,D.aL9,null)
D.akh=new A.T(0,26,0,26)
D.akl=new A.T(0,4,0,6)
D.akL=new A.T(14,12,14,14)
D.alv=new A.T(3,0,0,0)
D.ap3=new A.Q(63251,"MaterialIcons",null,!1)
D.qU=new A.Q(63677,"MaterialIcons",null,!1)
D.apS=new A.Q(983209,"MaterialIcons",null,!1)
D.aqv=new A.G(D.apS,28,C.u,null,null,null)
D.arc=new A.G(C.HQ,null,C.ir,null,null,null)
D.aoN=new A.Q(62961,"MaterialIcons",null,!1)
D.arV=new A.G(D.aoN,null,null,null,null,null)
D.ap1=new A.Q(63199,"MaterialIcons",null,!1)
D.arW=new A.G(D.ap1,null,null,null,null,null)
D.as3=new A.G(C.jJ,null,C.eX,null,null,null)
D.as7=new A.G(C.nF,44,C.i,null,null,null)
D.asD=new A.G(D.qU,null,D.eW,null,null,null)
D.asV=new A.G(C.lh,null,D.eW,null,null,null)
D.ati=new A.G(D.qU,null,null,null,null,null)
D.atQ=new A.G(C.hU,20,D.e3,null,null,null)
D.aub=new A.G(C.nC,30,C.u,null,null,null)
D.auE=new A.G(C.ln,16,C.u,null,null,null)
D.av5=new A.G(C.HM,null,null,null,null,null)
D.avf=new A.G(C.nE,null,null,null,null,null)
D.avs=new A.G(C.Hz,null,null,null,null,null)
D.JT=x([1,3,5],y.t)
D.KG=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aYs=new A.A(C.iw,C.mN,null)
D.aHW=x([D.aYs],y.p)
D.b2_=new A.V(C.ny,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b1N=new A.V(D.qU,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b2k=new A.V(C.d8,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.b2y=new A.V(C.HP,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aK5=x([D.b2_,D.b1N,D.b2k,D.b2y],A.ae("H<+(Q,o)>"))
D.aMv=x([D.pr,D.ps,D.fm],A.ae("H<FP>"))
D.Pk=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aU9=new B.I1(0,"idle")
D.VB=new B.I1(1,"loading")
D.k2=new B.I1(2,"ready")
D.aUa=new B.I1(3,"failed")
D.asB=new A.G(C.c1,18,G.cU,null,null,null)
D.bz1=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uH,null,null,null,null,null,null,null,null)
D.aGQ=x([D.asB,C.aV,D.bz1],y.p)
D.b8F=new A.eb(C.ad,C.d,C.e,C.h,null,C.l,null,0,D.aGQ,null)
D.aXg=new A.A(C.aM,D.b8F,null)
D.alt=new A.T(2,6,2,4)
D.beW=new A.r(!0,C.u,null,null,null,null,14,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmJ=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.beW,null,null,null,null,null,null,null,null)
D.aXx=new A.A(D.alt,D.bmJ,null)
D.bzr=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.fe,null,null,null,null,null,null,null,null)
D.aIf=x([N.uc,C.O,D.bzr],y.p)
D.b8z=new A.eb(C.ad,C.cf,C.e,C.h,null,C.l,null,0,D.aIf,null)
D.aXJ=new A.A(C.l3,D.b8z,null)
D.C3=new A.r(!0,D.e3,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bzM=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.C3,null,null,null,null,null,null,null,null)
D.aXO=new A.A(C.dD,D.bzM,null)
D.byX=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aO,C.Y,null,null,null,null,null,null,null)
D.aXZ=new A.A(C.C,D.byX,null)
D.alq=new A.T(2,0,2,8)
D.buS=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aO,null,null,null,null,null,null,null,null)
D.aYh=new A.A(D.alq,D.buS,null)
D.auN=new A.G(C.ll,30,C.u,null,null,null)
D.bAt=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.C4,null,null,null,null,null,null,null,null)
D.amC=new A.bV(1,C.af,D.bAt,null)
D.aIv=x([D.auN,C.Z,D.amC],y.p)
D.b8k=new A.eb(C.ad,C.d,C.e,C.h,null,C.l,null,0,D.aIv,null)
D.auo=new A.G(C.d8,18,G.cU,null,null,null)
D.a2j=new A.r(!0,G.cU,null,null,null,null,12,C.R,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.byF=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a2j,null,null,null,null,null,null,null,null)
D.aHg=x([D.auo,C.bM,D.byF],y.p)
D.b8x=new A.eb(C.ad,C.d,C.G,C.h,null,C.l,null,0,D.aHg,null)
D.baT=new A.W(0,30)
D.u9=new A.W(1/0,54)
D.bbg=new A.W(1/0,48)
D.bbj=new A.W(1/0,50)
D.bbm=new A.W(1/0,52)
D.bwu=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.bco=new A.cX(D.bwu,null,null,null,null,null,null,null,null,null,null,null,null,C.w,!1,null,null,null,C.m,null)
D.bel=new A.r(!0,C.i,null,null,null,null,14.5,C.R,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beM=new A.r(!0,C.ao,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.BP=new A.r(!0,D.eW,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.kq=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a2v=new A.r(!0,D.eW,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.biy=new A.r(!0,C.u,null,null,null,null,24,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjB=new A.r(!0,D.e3,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjC=new A.r(!0,G.cU,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjT=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.blz=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.ic,null,null,null,null,null,null,null,null)
D.bmh=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.d_,null,null,null,null,null,null,null,null)
D.bmN=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oQ,null,null,null,null,null,null,null,null)
D.bmS=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aO,null,null,null,null,null,null,null,null)
D.bg7=new A.r(!0,G.cU,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bn9=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bg7,null,null,null,null,null,null,null,null)
D.bnf=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aO,null,null,null,null,null,null,null,null)
D.bnG=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.fe,null,null,null,null,null,null,null,null)
D.bpv=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cp,null,null,null,null,null,null,null,null)
D.bqg=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bE,null,null,null,null,null,null,null,null)
D.bql=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aO,null,null,null,null,null,null,null,null)
D.bqO=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.uI,null,null,null,null,null,null,null,null)
D.bs3=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bsB=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oU,null,null,null,null,null,null,null,null)
D.bto=new A.m("reset safe mode / WebGPU ban",null,C.BI,null,null,null,null,null,null,null,null)
D.btD=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.C3,null,null,null,null,null,null,null,null)
D.btO=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aO,null,null,null,null,null,null,null,null)
D.buf=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bA,null,null,null,null,null,null,null,null)
D.buy=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aO,null,null,null,null,null,null,null,null)
D.buT=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aO,null,null,null,null,null,null,null,null)
D.bwh=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a2W,null,null,null,null,null,null,null,null)
D.bhK=new A.r(!0,D.eW,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bwk=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bhK,null,null,null,null,null,null,null,null)
D.bwK=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oU,null,null,null,null,null,null,null,null)
D.bxj=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a1M,null,null,null,null,null,null,null,null)
D.bxy=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cp,null,null,null,null,null,null,null,null)
D.bxW=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.byd=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.byP=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aO,null,null,null,null,null,null,null,null)
D.byQ=new A.m("\u062e\u0644\u0635\u062a",null,C.mg,null,null,null,null,null,null,null,null)
D.byR=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.C3,null,null,null,null,null,null,null,null)
D.biR=new A.r(!0,C.cM,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.fN,null,null,null,null,null,null,null,null)
D.bzD=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.biR,null,null,null,null,null,null,null,null)
D.bzQ=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bA,null,null,null,null,null,null,null,null)
D.bzU=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.d_,null,null,null,null,null,null,null,null)
D.bAs=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aO,null,null,null,null,null,null,null,null)
D.a4e=new B.akA(null)
D.bBR=new B.DG(null)
D.bBS=new B.Wl(2,1,!0,!1,!1)
D.a4i=new B.Wn(!1,!1,!1,!1,!1,0)
D.j7=new B.nN(0,"ok")
D.v1=new B.nN(1,"near")
D.v2=new B.nN(2,"wrong")
D.v3=new B.nN(3,"missing")
D.a4J=new B.nN(4,"extra")
D.api=new A.Q(63456,"MaterialIcons",null,!1)
D.bHR=new B.E0(D.e3,D.api,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bIu=new B.YK(!1,null)
D.CE=new B.YK(!0,null)
D.mB=new B.EL(0,"idle")
D.vh=new B.EL(1,"playing")
D.vi=new B.EL(2,"recording")
D.pi=new B.EL(3,"thinking")
D.je=new B.EL(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cSf","cfq",()=>new B.akB())
x($,"cVI","cv9",()=>A.aE("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cVJ","cva",()=>A.aE("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cVV","cvj",()=>A.aE("\u0648\u0670",!0,!1,!1))
x($,"cVg","cuQ",()=>A.aE("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cTx","ctF",()=>A.aE("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cUM","cus",()=>A.aE("[\u0654\u0655]",!0,!1,!1))
x($,"cTy","ctG",()=>A.aE("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cTF","ctM",()=>A.aE("[\u0624\u0626]",!0,!1,!1))
x($,"cUO","cuu",()=>A.aE("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cVl","cuT",()=>A.aE("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cUW","cuB",()=>A.aE("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cVG","cg1",()=>A.aE("\\s+",!0,!1,!1))
x($,"cPy","ru",()=>B.cwa(D.pr,0,A.caY(0,!0)))
x($,"cSg","Nz",()=>new B.Wm($.cfq(),D.bBS,B.cEq(),D.aU9,$.X()))})()};
(a=>{a["bEMw5H80inPNm90jare29ZjAlEs="]=a.current})($__dart_deferred_initializers__);