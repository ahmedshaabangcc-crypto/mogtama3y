((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,P,H,G,N,Q,K,B={
cFQ(d){var x,w,v,u,t,s
if(d instanceof B.lN)return d
try{x=A.cW(d)
w=x.code
v=x.message
u=w==null?"failed":A.S(w)
t=v==null?"":A.S(v)
return new B.lN(u,t)}catch(s){u=A.n(d)
return new B.lN("failed",u)}},
akQ:function akQ(){this.b=this.a=null},
b7S:function b7S(d){this.a=d},
b7V:function b7V(){},
b7U:function b7U(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b7T:function b7T(d){this.a=d},
b7Z:function b7Z(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b7X:function b7X(d){this.a=d},
b7Y:function b7Y(d){this.a=d},
b8_:function b8_(d){this.a=d},
b81:function b81(d,e,f){this.a=d
this.b=e
this.c=f},
b80:function b80(d,e,f){this.a=d
this.b=e
this.c=f},
b7W:function b7W(){},
cFR(d,e){return new B.lN(d,e)},
Wx:function Wx(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
KB:function KB(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
KD:function KD(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
KC:function KC(d,e){this.a=d
this.b=e},
lN:function lN(d,e){this.a=d
this.b=e},
crR(d){var x,w=$.cwB()
w=A.bD(d,w,"\u0627")
x=$.cwC()
w=A.bD(w,x,"\u064a")
x=$.cwL()
w=A.bD(w,x,"\u0627")
x=$.cv5()
w=A.bD(w,x,"\u0627")
x=$.cwh()
w=A.bD(w,x,"\u0621")
x=$.cvU()
w=A.bD(w,x,"\u0621")
x=$.cv6()
w=A.bD(w,x,"\u0627")
x=$.cvc()
w=A.bD(w,x,"\u0621")
w=A.bD(w,"\u0649","\u064a")
w=A.bD(w,"\u0629","\u0647")
x=$.cvW()
w=A.bD(w,x,"")
x=$.cwk()
w=A.bD(w,x," ")
x=$.cw2()
w=A.bD(w,x," ")
x=$.chr()
return C.c.K(A.bD(w,x," "))},
cKz(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kb(x,w)
for(u=0;u<x;++u)v[u]=u
t=A.cc(x,0,!1,w)
for(s=1;s<=l;++s,r=t,t=v,v=r){t[0]=s
for(w=s-1,u=1;u<=k;++u){q=u-1
p=d.charCodeAt(w)===e.charCodeAt(q)?0:1
o=v[u]+1
n=t[q]+1
m=v[q]+p
if(o<n)q=o<m?o:m
else q=n<m?n:m
t[u]=q}}return v[k]},
cbd(d,e){var x,w,v,u,t,s
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
s=1-B.cKz(d,e)/u
return s>=1?0.99:s},
FE(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.uc(d,$.chr()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.crR(u)
s=A.bD(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.TD(r.a+" "+u,r.b))}continue}q.push(new B.TD(u,s))}return q},
cJe(d,e){var x,w,v,u,t=new B.c4W(),s=A.a([],y.s)
for(x=A.fj(e,0,A.iq(5,"count",y.S),A.aj(e).c),w=x.$ti,x=new A.ch(x,x.gN(0),w.i("ch<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.L_)&&t.$2(d,D.L_)?C.b.jB(d,5):d
return!t.$2(s,D.PH)&&t.$2(u,D.PH)?C.b.jB(u,4):u},
cqM(d,e){var x=B.FE(d),w=B.crR(e),v=y.U
v=A.a9(new A.ah(A.a(w.split(" "),y.s),new B.c72(),v),v.i("Y.E"))
return new B.Jd(x,B.cIp(x,B.cJe(v,x)),w)},
cIp(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.cc(x,0,!1,s)
q=A.cc(x,0,!1,y.S)
p=A.cc(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.cbd(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.cbd(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.cbd(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.jf
else m=a2>=0.6?D.va:D.vb
a1.push(new B.na(o,x,s,m))
break
case 1:--o
a1.push(new B.na(o,a4[o],null,D.vc))
break
case 2:--n
a1.push(new B.na(null,null,a6[n],D.a5a))
break
case 3:--o
a3=n-2
a1.push(new B.na(o,a4[o],a6[a3]+" "+a6[n-1],D.jf))
n=a3
break
default:x=o-1;--n
a1.push(new B.na(x,a4[x],a6[n],D.jf))
o-=2
a1.push(new B.na(o,a4[o],a6[n],D.jf))}}a4=y.e
a4=A.a9(new A.d8(a1,a4),a4.i("aW.E"))
return a4},
nQ:function nQ(d,e){this.a=d
this.b=e},
TD:function TD(d,e){this.a=d
this.b=e},
na:function na(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Jd:function Jd(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aYS:function aYS(d){this.a=d},
aYR:function aYR(){},
c4W:function c4W(){},
c72:function c72(){},
cxC(d,e,f){return new B.rK(d,e,f)},
cLu(d){var x
A:{if("memorized"===d){x=D.fn
break A}if("learning"===d){x=D.pC
break A}x=D.pB
break A}return x},
csR(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cW[d-1].a[1]},
cFS(){var x=y.S
return new B.akR(A.C(x,y.u),A.aO(x))},
b84(d){var x=d.eP()
return C.c.du(C.j.k(A.br(x)),4,"0")+"-"+C.c.du(C.j.k(A.bu(x)),2,"0")+"-"+C.c.du(C.j.k(A.c_(x)),2,"0")},
cnF(d){var x=y.x,w=A.a9(new A.av(A.a(d.split("-"),y.s),A.cMV(),x),x.i("aW.E"))
return B.b84(A.dz(w[0],w[1],w[2]-1,12,0,0,0))},
ceq(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.C(p,y.u),n=A.aO(p),m=new B.akR(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcN(),x=x.ga_(x),w=y.j;x.v();){v=x.gG()
u=A.dX(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aN(t)>=3){v=C.j.aI(u,1000)
s=C.j.a3(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cW[v-1].a[1])}if(v)continue
v=J.bb(t)
r=C.f.bB(A.cT(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rK(D.aNW[r],C.f.bB(A.cT(v.h(t,1))),new A.aR(A.kE(C.f.bB(A.cT(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aCg(q,y.o)
p=A.mB(x,new B.b83(),x.$ti.i("Y.E"),p)
n.A(0,new A.ah(p,o.ga4M(),A.y(p).i("ah<Y.E>")))}m.c=A.q(d.h(0,"last"))
p=A.ar(d.h(0,"streak"))
p=p==null?null:C.f.bB(p)
p=m.d=p==null?0:p
o=A.ar(d.h(0,"best"))
o=o==null?null:C.f.bB(o)
m.e=o==null?p:o
return m},
aBx(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.du(C.j.k(d),3,"0")+C.c.du(C.j.k(e),3,"0")+".mp3"},
FY:function FY(d,e){this.a=d
this.b=e},
rK:function rK(d,e,f){this.a=d
this.b=e
this.c=f},
akR:function akR(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b85:function b85(){},
b86:function b86(){},
b83:function b83(){},
Wv:function Wv(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cDj(){return new B.xd(null)},
cPl(d,e){var x,w,v,u,t={},s=I.cW[e-1].a[1],r=$.NJ().c
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
return A.e4(C.cT,new B.c9R(t,s,e),d,!0,null,null,!1,y.l)},
cgd(d){return A.du(0,0,0,0,0,C.j.d1(C.f.al(6+d*1.2),25,90))},
cf7(d){return E.bq(C.j.aI(d,60))+":"+C.c.du(E.bq(C.j.a3(d,60)),2,"\u0660")},
csD(d){return A.e4(C.cT,new B.caO($.NJ()),d,!0,null,null,!1,y.H)},
NC(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl9()
break A}return x},
cQH(d,e,f){var x,w=new B.cb6(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
csM(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.ap.f4(a4,null))
s=y.Y
r=s.a(J.at(x,"rec"))
w=r==null?C.cO:r
q=s.a(J.at(x,"last"))
v=q==null?C.cO:q
u=new B.cb5()
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
a0=J.aN(t)!==0?" \xb7 recovered from "+A.n(t):""
a1=J.k(J.at(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.k(J.at(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
Ia:function Ia(d,e){this.a=d
this.b=e},
Ww:function Ww(d,e,f,g,h){var _=this
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
_.T$=_.R$=0},
b87:function b87(d){this.a=d},
b88:function b88(d){this.a=d},
b89:function b89(d){this.a=d},
xd:function xd(d){this.a=d},
a1b:function a1b(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bOt:function bOt(d){this.a=d},
bOs:function bOs(d,e){this.a=d
this.b=e},
bOu:function bOu(d){this.a=d},
bOr:function bOr(d,e){this.a=d
this.b=e},
bOv:function bOv(){},
bOf:function bOf(){},
bOl:function bOl(d,e,f){this.a=d
this.b=e
this.c=f},
bOm:function bOm(){},
bOp:function bOp(d){this.a=d},
bOo:function bOo(){},
bOq:function bOq(d){this.a=d},
bOi:function bOi(d,e){this.a=d
this.b=e},
bOj:function bOj(d){this.a=d},
bOh:function bOh(){},
bOk:function bOk(d){this.a=d},
bOg:function bOg(d){this.a=d},
bOn:function bOn(d,e){this.a=d
this.b=e},
Ib:function Ib(d,e,f){this.c=d
this.d=e
this.a=f},
YX:function YX(d,e){this.c=d
this.a=e},
c9R:function c9R(d,e,f){this.a=d
this.b=e
this.c=f},
c9O:function c9O(d,e,f){this.a=d
this.b=e
this.c=f},
c9Q:function c9Q(d,e){this.a=d
this.b=e},
c9N:function c9N(d,e){this.a=d
this.b=e},
c9M:function c9M(d,e){this.a=d
this.b=e},
c9P:function c9P(d,e){this.a=d
this.b=e},
c9I:function c9I(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c9H:function c9H(d,e,f){this.a=d
this.b=e
this.c=f},
c9J:function c9J(d){this.a=d},
c9K:function c9K(d){this.a=d},
c9L:function c9L(d,e){this.a=d
this.b=e},
EU:function EU(d,e){this.a=d
this.b=e},
DR:function DR(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a3K:function a3K(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
c1g:function c1g(){},
c1w:function c1w(d,e){this.a=d
this.b=e},
c1A:function c1A(d){this.a=d},
c1B:function c1B(d){this.a=d},
c1C:function c1C(d,e,f){this.a=d
this.b=e
this.c=f},
c1E:function c1E(d){this.a=d},
c1F:function c1F(d){this.a=d},
c1D:function c1D(){},
c1H:function c1H(d){this.a=d},
c1G:function c1G(d){this.a=d},
c1I:function c1I(d,e){this.a=d
this.b=e},
c1K:function c1K(d){this.a=d},
c1L:function c1L(d){this.a=d},
c1J:function c1J(){},
c1v:function c1v(d,e,f){this.a=d
this.b=e
this.c=f},
c1x:function c1x(d,e,f){this.a=d
this.b=e
this.c=f},
c1o:function c1o(d){this.a=d},
c1p:function c1p(d){this.a=d},
c1n:function c1n(){},
c1q:function c1q(){},
c1r:function c1r(d,e){this.a=d
this.b=e},
c1Q:function c1Q(d){this.a=d},
c1R:function c1R(d){this.a=d},
c1S:function c1S(d,e){this.a=d
this.b=e},
c1P:function c1P(d){this.a=d},
c1T:function c1T(d,e){this.a=d
this.b=e},
c1u:function c1u(){},
c1t:function c1t(d){this.a=d},
c1s:function c1s(d,e){this.a=d
this.b=e},
c1z:function c1z(d){this.a=d},
c1y:function c1y(d){this.a=d},
c1M:function c1M(){},
c1N:function c1N(){},
c1O:function c1O(){},
c1h:function c1h(d,e,f){this.a=d
this.b=e
this.c=f},
c1i:function c1i(d){this.a=d},
c1k:function c1k(){},
c1j:function c1j(){},
c1l:function c1l(d){this.a=d},
c1m:function c1m(d){this.a=d},
E9:function E9(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
DQ:function DQ(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a3J:function a3J(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
c1_:function c1_(){},
c18:function c18(d,e){this.a=d
this.b=e},
c19:function c19(d){this.a=d},
c17:function c17(){},
c1b:function c1b(d){this.a=d},
c1a:function c1a(d,e){this.a=d
this.b=e},
c1c:function c1c(d,e){this.a=d
this.b=e},
c13:function c13(d,e){this.a=d
this.b=e},
c14:function c14(d,e,f){this.a=d
this.b=e
this.c=f},
c15:function c15(d,e,f){this.a=d
this.b=e
this.c=f},
c10:function c10(d,e,f){this.a=d
this.b=e
this.c=f},
c11:function c11(d,e,f){this.a=d
this.b=e
this.c=f},
c12:function c12(d,e){this.a=d
this.b=e},
c16:function c16(d){this.a=d},
c1d:function c1d(){},
c1e:function c1e(d,e){this.a=d
this.b=e},
c1f:function c1f(d,e){this.a=d
this.b=e},
DP:function DP(d){this.a=d},
a3I:function a3I(d){this.d=d
this.c=this.a=null},
c0R:function c0R(){},
c0Y:function c0Y(d){this.a=d},
c0Z:function c0Z(){},
c0X:function c0X(d,e){this.a=d
this.b=e},
c0W:function c0W(d,e,f){this.a=d
this.b=e
this.c=f},
c0V:function c0V(d,e,f){this.a=d
this.b=e
this.c=f},
c0U:function c0U(d){this.a=d},
c0S:function c0S(d){this.a=d},
c0T:function c0T(d){this.a=d},
caO:function caO(d){this.a=d},
caN:function caN(d){this.a=d},
caI:function caI(d,e){this.a=d
this.b=e},
caK:function caK(){},
caJ:function caJ(){},
caL:function caL(d,e){this.a=d
this.b=e},
caM:function caM(d,e){this.a=d
this.b=e},
akP:function akP(d){this.a=d},
b7R:function b7R(d){this.a=d},
cb6:function cb6(){},
cb7:function cb7(){},
DS:function DS(d,e,f){this.c=d
this.d=e
this.a=f},
a3L:function a3L(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
c1U:function c1U(d){this.a=d},
c1V:function c1V(d){this.a=d},
c1W:function c1W(d,e){this.a=d
this.b=e},
c1X:function c1X(d){this.a=d},
c1Z:function c1Z(d){this.a=d},
c1Y:function c1Y(d){this.a=d},
cb5:function cb5(){}},D,R,O,I,E,F
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
B.akQ.prototype={
ri(){var x=this,w=x.a
if(w!=null)return A.et(w,y.m)
w=x.b
return w==null?x.b=new B.b7S(x).$0():w},
uE(d,e){return this.aPb(d,e,e)},
aPb(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
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
r=B.cFQ(s)
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
Nm(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$Nm=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.ri(),$async$Nm)
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
v=new B.Wx(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a4J
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Nm,w)},
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
v=new A.auY(q,p)
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
bm0(){var x=y.K
A.Qz(this.ri().bJ(new B.b7V(),x),x)},
rh(d,e){var x=A.jZ(d[e])
x=x==null?null:C.f.al(x)
return x==null?0:x},
bjo(d,e,f){return this.uE(new B.b7U(this,d,e,f),y.C)},
galR(){var x,w
try{x=A.kv(b.G.sessionStorage)
return x}catch(w){return null}},
gatt(){var x=A.eq(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
aa3(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.eq(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gatt())return!1
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
l=A.aC("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.k(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aC("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.jZ(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.galR()
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
as_(){var x,w,v,u,t,s,r=null
try{x=this.galR()
if(x!=null)A.cR(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cW(x.location)
u=A.S(v.hash)
t=A.S(v.search)
s=A.bt(A.S(A.cW(x.document).baseURI),0,r).a2("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cR(v,"replace",s+t+x,r,r,r)},
bj6(){var x,w=null,v=b.G,u=A.cW(v.history),t=A.jZ(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cR(u,"back",w,w,w,w)
else{x=A.S(A.cW(v.document).baseURI)
A.cR(A.cW(v.location),"replace",A.bt(x,0,w).a2("./").k(0)+"#/",w,w,w)}},
aaf(d,e,f,g,h){return this.uE(new B.b7Z(this,e,d,f,h,g),y.H)},
aaj(){return this.uE(new B.b8_(this),y.D)},
a4p(){var x=null,w=this.a
if(w!=null)A.cR(w,"cancelRecording",x,x,x,x)},
anh(d){var x,w,v=this,u=A.q(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.rh(d,"ms")
w=A.jZ(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.KD(u,x,w,v.rh(d,"frames"),v.rh(d,"tokens"),v.ou(d,"retried"),v.rh(d,"encMs"),v.rh(d,"decMs"),v.rh(d,"featMs"))},
ajA(d){var x={}
x.words=d
return x},
awA(d,e){return this.uE(new B.b81(this,d,e),y._)},
boc(d,e){return this.uE(new B.b80(this,d,e),y._)},
Lq(d,e){return this.bm6(d,e)},
bm6(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Lq=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.ri(),$async$Lq)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.aj(d).i("av<1,o>")
o=A.a9(new A.av(d,new B.b7W(),o),o.i("aW.E"))
x=11
return A.c(A.eK(A.cW(A.cR(r,"play",o,e,null,null)),y.y),$async$Lq)
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
return A.i($async$Lq,w)},
N3(){var x=null,w=this.a
if(w!=null)A.cR(w,"stopPlayback",x,x,x,x)},
JU(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.S(A.cR(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bnm(){var x,w,v=null
try{x=this.a
if(x!=null)A.cR(x,"resetDevice",v,v,v,v)}catch(w){}},
a7F(d){var x=this.a
if(x!=null)A.cR(x,"prefetch",d,null,null,null)}}
B.Wx.prototype={}
B.KB.prototype={
gn7(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.KD.prototype={
gTG(){var x=this,w=C.f.aB(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.KC.prototype={}
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
$ibN:1}
B.nQ.prototype={
S(){return"WordStatus."+this.b}}
B.TD.prototype={}
B.na.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Jd.prototype={
gN1(){var x,w=this,v=w.d
if(v===$){x=new B.aYS(w).$0()
w.d!==$&&A.aq()
w.d=x
v=x}return v},
gKd(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a5a&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbkf(){return J.h0(this.gN1(),new B.aYR()).gN(0)},
gtF(){var x=this.a
return x.length!==0&&this.gbkf()===x.length&&this.gKd().length===0}}
B.FY.prototype={
S(){return"AyahStatus."+this.b}}
B.rK.prototype={}
B.akR.prototype={
a7g(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.rz():x},
b1d(d){var x=this,w=B.b84(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cnF(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
ar9(){var x=Date.now(),w=B.b84(new A.aR(x,0,!1))
x=this.c
return x===w||x===B.cnF(w)?this.d:0},
avB(d,e,f,g){var x=this,w=new A.aR(Date.now(),0,!1),v=x.a7g(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.fn:D.pC,s=new B.rK(t,u,w.h6()),r=d*1000+e
x.a.p(0,r,s)
x.b.D(0,r)
x.b1d(w)
return s},
a78(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cW[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rz():s).a===D.fn)++u}return u},
bj4(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cW[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rz():s).a===D.pC)++u}return u},
gauA(){var x=this.a,w=A.y(x).i("c5<2>")
return new A.ah(new A.c5(x,w),new B.b85(),w.i("ah<Y.E>")).gN(0)},
gaAd(){var x=this.a,w=A.y(x).i("bQ<1>")
w=A.mB(new A.bQ(x,w),new B.b86(),w.i("Y.E"),y.S)
w=A.eH(w,A.y(w).i("Y.E"))
x=A.a9(w,A.y(w).c)
C.b.lf(x)
return x},
dq(){var x,w,v,u,t,s=this,r=y.N,q=A.C(r,y.L)
for(x=s.a,x=new A.eB(x,A.y(x).i("eB<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.a9(x,A.y(x).c)
return A.I(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
beX(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b6r(x,300,A.y(x).c),x=new A.Kh(J.as(x.a),x.b,A.y(x).i("Kh<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gG()
s=C.j.aI(t,1000)
t=C.j.a3(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.rz():q).a===D.fn?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.rz()
r=u.h(0,r)
o.push(A.I(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.rz():r).c.iG()],w,v))}return o},
bjG(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.L)(d),++u){t=d[u]
s=A.ez(t.h(0,"surah"))*1000+A.ez(t.h(0,"ayah"))
r=w.h(0,C.j.aI(s,1000)*1000+C.j.a3(s,1000))
if((r==null?$.rz():r).c.iG()===t.h(0,"updated_at"))v.L(0,s)}},
bjO(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.as(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gG()
if(!u.b(s))continue
r=A.ar(s.h(0,"surah"))
q=r==null?null:C.f.bB(r)
r=A.ar(s.h(0,"ayah"))
p=r==null?null:C.f.bB(r)
o=A.dF(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cW[q-1].a[1])
if(r)continue
n=B.cLu(s.h(0,"status"))
if(n===D.pB)continue
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
w.L(0,r)
t=!0}return t}}
B.Wv.prototype={
JD(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Wv(w,v,u,t,f==null?x.e:f)},
bd9(d){var x=null
return this.JD(x,x,d,x,x)},
aqF(d){var x=null
return this.JD(x,d,x,x,x)},
bdd(d){var x=null
return this.JD(x,x,x,x,d)},
bcw(d){var x=null
return this.JD(d,x,x,x,x)},
bda(d){var x=null
return this.JD(x,x,x,d,x)},
dq(){var x=this
return A.I(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Ia.prototype={
S(){return"ModelState."+this.b}}
B.Ww.prototype={
vQ(){var x=this.Q
return x==null?this.Q=new B.b87(this).$0():x},
qS(d){return this.ayq(d)},
ayq(d){var x=0,w=A.j(y.H),v=this
var $async$qS=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a5()
x=2
return A.c(A.ir("mt.tutor.settings",C.ap.hl(d.dq(),null)),$async$qS)
case 2:return A.h(null,w)}})
return A.i($async$qS,w)},
A6(){var x=0,w=A.j(y.H),v=this,u
var $async$A6=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a5()
x=2
return A.c(A.ir("mt.tutor.progress",C.ap.hl(v.c.dq(),null)),$async$A6)
case 2:u=v.as
if(u!=null)u.av()
v.as=A.cS(C.x,v.gaFi())
return A.h(null,w)}})
return A.i($async$A6,w)},
MM(d,e,f){return this.azd(d,e,f)},
azd(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$MM=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.aZ(d,e,f)
x=2
return A.c(A.ir("mt.tutor.last",C.ap.hl(A.I(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$MM)
case 2:return A.h(null,w)}})
return A.i($async$MM,w)},
Dw(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Dw=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.W0||n===D.ka){x=1
break}s.f=D.W0
s.y=null
s.a5()
u=4
n=A.lO().geK().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lO().geK().h(0,"tutor_threads")
p=A.dX(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bjo(new B.b88(s),n,p),$async$Dw)
case 7:s.x=e
s.f=D.ka
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
s.f=D.aVN
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
return A.c(p.aQ("quran_tutor_progress").d9("surah, ayah, status, perfect_count, updated_at"),$async$wN)
case 7:o=a1
n=r.c.bjO(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.beX()
if(J.aN(l)===0){x=10
break}h=p
g=A.I(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.nj(h.x,k,k))
x=11
return A.c(f.bnL("quran_tutor_save",!1,g,i),$async$wN)
case 11:r.c.bjG(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.ir("mt.tutor.progress",C.ap.hl(r.c.dq(),null)),$async$wN)
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
LH(d){return this.bno(d)},
bno(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$LH=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.ceq(t.c.dq()).dq()
y.f.a(p.h(0,"rows")).en(0,new B.b89(d))
t.c=B.ceq(p)
x=2
return A.c(t.A6(),$async$LH)
case 2:v=4
s=$.D().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.ar("quran_tutor_reset",A.I(["p_surah",d],y.N,r),r),$async$LH)
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
return A.i($async$LH,w)}}
B.xd.prototype={
O(){var x=$.NJ()
return new B.a1b(x,new A.ae(C.F,$.U()))}}
B.a1b.prototype={
W(){var x,w,v=this
v.Z()
x=v.d
x.ac(v.goG())
w=y.a
x.vQ().bJ(new B.bOt(v),w)
H.aXk().bJ(new B.bOu(v),w).fB(new B.bOv())
A.Qz(H.cdM(),y.y)},
y5(){if(this.c!=null)this.j(new B.bOf())},
m(){var x,w=this
w.d.U(w.goG())
x=w.e
x.q$=$.U()
x.M$=0
w.a0()},
Qz(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$Qz=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qS(s.b.bd9(!0)),$async$Qz)
case 3:t=s.a
t.bm0()
if(t.aa3()){t.as_()
x=1
break}s.Dw()
case 1:return A.h(v,w)}})
return A.i($async$Qz,w)},
y6(d,e,f){return this.aZS(d,e,f)},
b8a(d){return this.y6(d,null,null)},
aZS(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$y6=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.H(y.q).f.Y(A.aB(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.W(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cPl(s,d),$async$y6)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.MM(d,t.a,t.b),$async$y6)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aD(A.aH(new B.bOl(u,d,t),null,r),r),$async$y6)
case 8:if(u.c!=null)u.j(new B.bOm())
case 1:return A.h(v,w)}})
return A.i($async$y6,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gatt()&&!A.O(d,!1).vn())u.push(A.bP(x,x,x,x,C.z5,x,x,t.gbj5(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bP(x,x,x,x,D.avF,x,x,new B.bOp(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bP(x,x,x,x,C.iB,x,x,new B.bOq(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aJ3
else w=t?this.aUC():this.aVd()
return L.y_(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aVd(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a4J
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b9Z,C.T],x)
for(t=0;t<4;++t){s=D.aLn[t]
u.push(new A.z(C.bu,A.A(A.a([A.aX(s.a,C.ao,p,18),C.O,new A.bW(1,C.af,A.d(s.b,p,p,p,p,p,G.a2f,p,p,p),p)],x),C.r,C.d,C.e,0,p,p),p))}u=A.J(u,C.r,C.d,C.e,0,C.l)
s=A.a([D.bDx,C.J,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bq(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,p,F.aP,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bq(C.f.al(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.J,A.d(q,p,p,p,p,p,A.bB(p,p,r?D.e3:C.cN,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.J,D.bCy],x))
x=A.a([new E.dG(u,C.a7,C.aM,p,!0,p),new E.dG(A.J(s,C.r,C.d,C.e,0,C.l),C.a7,C.aM,p,!1,p),D.bMp,C.J],x)
if(v!=null)x.push(new E.dG(A.d(v,p,p,p,p,p,D.bmT,p,p,p),C.a7,C.aM,p,!1,p))
else x.push(A.fn(D.ass,p,D.bsW,this.gb_a(),A.el(C.w,C.ah,D.bd0,p,p,p,p)))
x.push(C.a5)
x.push(D.a4F)
return x},
aUC(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.K(r.a.a),p=q.length===0,o=p?C.rX:H.csw(q),n=t.z,m=A.Q(v.amy(C.db,E.bq(s.gauA())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bq(s.ar9()),k=s.c,j=Date.now()
k=k===B.b84(new A.aR(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Ib(t,!1,u),A.A(A.a([m,C.O,A.Q(v.amy(C.lt,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.v],j)
if(n!=null){t=H.kx(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bq(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bq(m)+"\u2013"+E.bq(l)
k.push(new E.dG(A.A(A.a([D.auL,C.a_,A.Q(A.J(A.a([D.boS,A.d(t+" \u2014 "+m,u,u,u,u,u,C.bA,u,u,u)],j),C.r,C.d,C.e,0,C.l),1),M.nX],j),C.h,C.d,C.e,0,u,u),C.a7,C.aM,new B.bOi(v,n),!0,u))}t=C.i.a9(0.08)
k.push(A.ay(u,C.o,!1,u,!0,C.m,u,A.az(),r,u,u,u,u,u,2,A.cK(u,new A.cp(4,A.v(14),C.L),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.uI,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.ri,u,u,u,u,u,u,u,u,u,u,u,u),C.q,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bOj(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.d1,!0,C.u,u,C.E,u,u,u,u))
k.push(C.v)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.byq)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.RY(o[x]))
C.b.A(k,t)}else{t=A.a([D.aZa,D.aZW,v.RY(1)],j)
for(w=114;w>=78;--w)t.push(v.RY(w))
t.push(C.J)
r=v.f
p=A.aX(r?C.yL:C.lr,C.ao,u,u)
t.push(A.eY(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,u,C.ff,u,u,u),new B.bOk(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.RY(w))
C.b.A(k,t)}k.push(C.T)
k.push(D.CS)
return k},
amy(d,e,f){var x=null,w=y.p
return new E.dG(A.A(A.a([A.aX(d,C.w,x,x),C.O,A.Q(A.J(A.a([A.d(e,x,x,x,x,x,C.bA,x,x,x),A.d(f,x,1,C.N,x,x,C.a2U,x,x,x)],w),C.r,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a7,C.H,x,!1,x)},
RY(d){var x,w=null,v=this.d.c,u=I.cW[d-1].a[1],t=v.a78(d),s=t/u,r=y.p,q=A.am(A.dA(C.P,A.a([A.cc7(C.eC,G.cU,w,w,w,w,w,3,s,w),A.d(E.bq(d),w,w,w,w,w,P.a3g,w,w,w)],r),C.m,C.bn,w),36,36),p=A.d(H.kx(d),w,w,w,w,w,D.bhB,w,w,w)
if(t===0)x=E.bq(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bq(t)+" \u0645\u0646 "+E.bq(u)
r=A.a([q,C.cx,A.Q(A.J(A.a([p,A.d(x,w,w,w,w,w,A.bB(w,w,t===u?G.cU:C.cN,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.r,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bq(C.f.al(s*100))+"\u066a",w,w,w,w,w,D.a2K,w,w,w))
r.push(D.asA)
return new E.dG(A.A(r,C.h,C.d,C.e,0,w,w),C.qz,C.d9,new B.bOn(this,d),!1,w)}}
B.Ib.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aYV
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.NC(x),r,r,r,r,r,D.C1,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.DS(w,"model load",r))
x.push(C.J)
x.push(A.cjz(C.mr,r,q.gbjn()))
return new E.dG(A.J(x,C.r,C.d,C.e,0,C.l),C.a7,C.aM,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bq(C.f.al(u/1e6))+" \u0645\u0646 "+E.bq(C.f.al(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,r,C.p4,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fd(x,A.qp(C.eC,C.w,7,s?t:r,r),C.aB)],w)
if(!this.d)C.b.A(x,A.a([C.J,D.btO],w))
return new E.dG(A.J(x,C.r,C.d,C.e,0,C.l),C.a7,C.aM,r,!1,r)}}}
B.YX.prototype={
t(d){var x=null,w=D.e3.a9(0.1),v=A.v(14),u=A.aK(D.e3.a9(0.4),1)
return A.E(x,A.A(A.a([D.auo,C.O,A.Q(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,x,C.C8,x,x,x),1)],y.p),C.r,C.d,C.e,0,x,x),C.k,x,x,new A.G(w,x,u,v,x,x,x,C.n),x,x,x,C.aM,C.ad,x,x,x)}}
B.EU.prototype={
S(){return"_Phase."+this.b}}
B.DR.prototype={
O(){return new B.a3K($.NJ(),D.mJ)}}
B.a3K.prototype={
gjg(){var x=this.e
return x===$?this.e=this.a.d:x},
gC5(){var x,w=this.a,v=w.f
w=w.c
x=this.gjg()
return H.NA(w,x,v.yh(w,x)).b},
W(){var x,w=this
w.Z()
x=w.d
x.ac(w.goG())
x.vQ()
x.a.a7F(B.aBx(w.a.c,w.gjg()))},
y5(){if(this.c!=null)this.j(new B.c1g())},
m(){var x,w=this,v=w.d
v.U(w.goG())
x=w.Q
if(x!=null)x.av()
v=v.a
v.N3()
v.a4p()
w.a0()},
a_Z(d){var x,w,v=this
if(v.f===D.vr)v.d.a.a4p()
x=v.d.a
x.N3()
w=v.Q
if(w!=null)w.av()
v.j(new B.c1w(v,d))
x.a7F(B.aBx(v.a.c,d))
w=v.a
if(d<w.e)x.a7F(B.aBx(w.c,d+1))},
Se(d){return this.aW5(d)},
aW5(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$Se=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.vq){u.d.a.N3()
u.j(new B.c1A(u))
x=1
break}t=u.r!=null?D.jm:D.mJ
u.j(new B.c1B(u))
s=u.d
r=A.a([B.aBx(u.a.c,u.gjg())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.Lq(r,q),$async$Se)
case 3:p=f
if(u.c==null||u.f!==D.vq){x=1
break}u.j(new B.c1C(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$Se,w)},
QZ(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$QZ=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.ka){x=1
break}p=l.a
p.N3()
r=B.FE(s.gC5()).length
s.j(new B.c1E(s))
o=s.Q
if(o!=null)o.av()
s.Q=A.hh(C.f0,new B.c1F(s))
u=4
o=B.cgd(r)
n=A.du(0,0,0,350*r,0,0)
x=7
return A.c(p.aaf(l.b.c,o,n,new B.c1G(s),new B.c1H(s)),$async$QZ)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lN){q=l
l=s.Q
if(l!=null)l.av()
if(s.c!=null)s.j(new B.c1I(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$QZ,w)},
C_(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$C_=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.vr){x=1
break}m=s.Q
if(m!=null)m.av()
s.j(new B.c1K(s))
s.Q=A.hh(C.iv,new B.c1L(s))
l=new A.Di()
$.FH()
l.op()
r=l
u=4
m=s.d.a
x=7
return A.c(m.aaj(),$async$C_)
case 7:q=e
if(q.b<0.8){s.b89("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.awA(q,B.FE(s.gC5()).length),$async$C_)
case 8:p=e
s.ch=A.du(0,0,r.ga5I(),0,0,0)
k=A.lO().geK().h(0,"debug")
if(k==="1"){o=B.csM(m.JU())
A.ru().$1("[tutor] "+s.a.c+":"+s.gjg()+" audio="+C.f.aB(q.b,1)+"s infer="+p.b+"ms total="+r.gCS()+"ms "+p.gTG()+" text="+p.a)
A.ru().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.aB(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aB(p.b/1000,2)+" \u062b\n"+p.gTG()+"\n"+A.n(o)+"\n"+p.a}s.agz(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lN){n=m
m=A.lO().geK().h(0,"debug")
if(m==="1")A.ru().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.JU())
s.a3f(B.NC(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$C_,w)},
a3f(d,e){var x=this,w=x.Q
if(w!=null)w.av()
if(x.c==null)return
x.j(new B.c1v(x,d,e))},
b89(d){return this.a3f(d,null)},
agz(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.av()
if(s.c==null)return
x=B.cqM(s.gC5(),d)
r.a=null
if(C.c.K(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjg()
t=x.gtF()
r.a=w.avB(v,u,q.b.a,t)
q.A6()}s.j(new B.c1x(r,s,x))},
Oz(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$Oz=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.ka){x=1
break}s.j(new B.c1o(s))
l=s.Q
if(l!=null)l.av()
s.Q=A.hh(C.iv,new B.c1p(s))
k=new A.Di()
$.FH()
k.op()
r=k
u=4
l=g.a
x=7
return A.c(l.boc(B.aBx(s.a.c,s.gjg()),B.FE(s.gC5()).length),$async$Oz)
case 7:q=e
p=B.csM(l.JU())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.aB(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aB(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.aB(r.gCS()/1000,2)+" \u062b)\n"+q.gTG()+"\n"+A.n(p)+"\n"+q.a
A.ru().$1("[tutor-debug] "+s.a.c+":"+s.gjg()+" audio="+C.f.aB(q.c,1)+"s infer="+q.b+"ms total="+r.gCS()+"ms "+q.gTG()+" text="+q.a)
A.ru().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.du(0,0,r.ga5I(),0,0,0)
s.agz(q.a)
n=s.r
if(n!=null){l=n.gtF()
j=n.b
i=A.aj(j).i("ah<1>")
j=A.a9(new A.ah(j,new B.c1q(),i),i.i("Y.E"))
A.ru().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.c1r(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lN){m=l
A.ru().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.JU())
s.a3f(B.NC(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Oz,w)},
ga1Y(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.rz():v).a!==D.fn)return!1}return!0},
t(d){var x,w=this,v=null,u=w.d,t=u.c.a7g(w.a.c,w.gjg()),s=u.b,r=s.d&&!w.x&&w.f!==D.jm,q=H.kx(w.a.c),p=y.p,o=A.a([A.bP(v,v,v,v,C.iB,v,v,new B.c1Q(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aMj(),m=A.d("\u0622\u064a\u0629 "+E.bq(w.gjg()),v,v,v,v,v,C.mp,v,v,v),l=E.bq(w.gjg()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.aV,A.d("("+l+" \u0645\u0646 "+E.bq(k.e-k.d+1)+")",v,v,v,v,v,F.aP,v,v,v),C.bD,w.b_Y(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.v],p)
if(r)s.push(w.aUx())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.vr&&l!==D.ps}else l=!1
if(l)s.push(w.aJX(m))
else s.push(A.d(w.gC5()+" \ufd3f"+E.bq(w.gjg())+"\ufd3e",v,v,v,v,v,D.kA,C.Y,C.b8,v))}s=A.a([new B.Ib(u,!0,v),n,C.B,new E.dG(A.J(s,C.a9,C.d,C.e,0,C.l),D.alh,C.aM,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.jm)s.push(w.b9E(n))
if(w.r!=null&&w.f===D.jm&&w.ch!=null){x=C.f.al(C.j.aI(w.ch.a,1000)/100)
s.push(new A.z(C.bu,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bq(C.j.aI(x,10))+"\u066b"+E.bq(C.j.a3(x,10)))+" \u062b",v,v,v,v,v,F.aP,C.Y,v,v),v))}n=w.as
if(n!=null)s.push(new A.z(C.aM,A.d(n,v,v,v,v,v,D.C1,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.DS(n,"check "+w.a.c+":"+w.gjg(),v))}s.push(w.aKx())
s.push(C.T)
s.push(A.iB(C.w,C.H,v,new B.c1R(w),D.bqE,D.bw7,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga1Y()
s.push(new E.dG(A.A(A.a([D.ar1,C.a_,A.Q(A.J(A.a([D.bxM,A.d(w.ga1Y()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,v,F.aP,v,v,v)],p),C.r,C.d,C.e,0,C.l),1),M.nX],p),C.h,C.d,C.e,0,v,v),C.a7,C.aM,new B.c1S(w,d),n,v))}n=A.lO().geK().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.d7(D.asr,D.bvz,u.f===D.ka&&w.f!==D.ps?w.gaLg():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.z(C.h6,A.p3(n,F.aP,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn7()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,v,F.aP,v,v,v))}p.push(A.b2(D.bwV,v,v,v,new B.c1T(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.CS)
return L.y_(o,s,q)},
aMj(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.am(A.fo(new B.c1t(this),w,null,C.ae,new B.c1u()),36,null)},
b_Y(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fn)return D.bab
x=d.b
w=E.bq(x)
v=E.bq(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c2:C.r7
u.push(new A.z(D.am0,A.aX(r,s?G.cU:C.eZ,q,16),q))}return A.Kv(A.A(u,C.h,C.d,C.I,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aUx(){var x=null
return A.bv(!1,A.v(12),!0,A.E(x,D.ah_,C.k,x,x,new A.G(C.q3,x,x,A.v(12),x,x,x,C.n),x,x,x,x,D.akP,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.c1z(this),x,x,x,x,x,x,x)},
aJX(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.at(d.gN1(),w)
A:{if(D.jf===v){u=D.kA.cv(G.cU)
break A}if(D.va===v){u=D.kA.a51(D.e3,C.fO,D.e3)
break A}if(D.vb===v){u=D.kA.a51(D.eX,C.fO,D.eX)
break A}u=D.kA.a51(C.eZ,C.j8,C.c9)
break A}t=x[w]
r.push(new A.eT(t.a,s,s,C.bv,s,s,s,s,s,s,u))
r.push(O.BT)}x=E.bq(this.gjg())
r.push(A.ew(s,s,s,s,s,s,s,s,s,D.kA.cv(C.ao),"\ufd3f"+x+"\ufd3e"))
return A.Dv(A.ew(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Y,C.b8)},
b9E(d){var x,w,v,u,t,s,r=this.w
if(C.c.K(d.c).length===0)return D.bLM
if(d.gtF()){x=r==null
if((x?null:r.a)===D.fn&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fn?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bq(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.E9(G.cU,C.c2,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gN1()
w=J.dJ(x)
v=w.io(x,new B.c1M()).gN(0)
u=w.io(x,new B.c1N()).gN(0)
t=w.io(x,new B.c1O()).gN(0)
x=A.a([],y.s)
if(u>0)x.push(E.bq(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bq(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bq(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gKd().length!==0)x.push(E.bq(d.gKd().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eX:D.e3
x=C.b.aq(x," \u2022 ")
s=d.gKd().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aq(d.gKd(),"\u060c "):""
return new B.E9(w,C.nM,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aKx(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.ka,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aI(new A.aR(f,0,!1).dE(w).a,1e6)}v=C.j.aI(B.cgd(B.FE(j.gC5()).length).a,1e6)
f=j.gb6J()
w=96+26*j.y
u=D.eX.a9(0.25)
w=A.hU(i,A.a6C(C.P,A.E(i,D.asE,C.k,i,i,D.a8I,i,84,i,i,i,i,i,84),i,C.aU,new A.G(u,i,i,i,i,i,i,C.bX),C.FO,i,w,i,w),C.q,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cv)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.cf7(x)+" / "+B.cf7(v),i,i,i,i,i,K.p3,i,i,i)
return A.J(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,i,F.aP,i,i,i),A.b2(D.bCx,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.eE((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bq(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bq(t)+" \u062b)"
return new A.z(C.qu,A.J(A.a([C.wj,C.T,D.bug,A.d(h,i,i,i,i,i,F.aP,C.Y,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.vq
r=j.r
f=r==null
w=!f
q=w&&r.gtF()
u=A.aX(s?C.nN:K.Iq,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i,i)
o=A.el(i,i,D.bcY,i,i,i,i)
u=A.Q(new A.Ao(C.a5v,!0,new B.c1h(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.ZA(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.Kc[n]
p.push(new A.eh(m,i,A.d("\xd7"+E.bq(m),i,i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.O,A.nG(new B.c1i(j),p,A.dh([h.b.b],o),!1,A.kB(i,i,i,new A.bh(new B.c1j(),l),i,i,i,i,new A.bh(new B.c1k(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cR),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb24():i
u=A.aX(f?D.r2:C.nM,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,i,C.cr,i,i,i)
p=q?C.is:C.w
h=A.a([o,C.v,A.fn(u,i,f,h,A.el(p,q?C.i:C.ah,D.uj,i,i,i,i))],k)
if(w&&j.gjg()<j.a.e)C.b.A(h,A.a([C.B,q?A.fn(D.aw0,i,D.bBc,new B.c1l(j),A.el(G.cU,C.ah,D.uj,i,i,i,i)):A.b2(D.br4,i,i,i,new B.c1m(j),i,i)],k))
if(w){f=j.gjg()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.z(C.hR,A.d(j.ga1Y()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,i,K.uQ,C.Y,i,i),i))
return A.J(h,C.a9,C.d,C.e,0,C.l)}}}
B.E9.prototype={
t(d){var x=this,w=null,v=x.c,u=v.a9(0.12),t=A.v(14),s=A.aK(v.a9(0.5),1),r=y.p
return A.E(w,A.A(A.a([A.aX(x.d,v,w,w),C.O,A.Q(A.J(A.a([A.d(x.e,w,w,w,w,w,A.bB(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.U,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bN,A.d(x.f,w,w,w,w,w,C.C8,w,w,w)],r),C.r,C.d,C.e,0,C.l),1)],r),C.r,C.d,C.e,0,w,w),C.k,w,w,new A.G(u,w,s,t,w,w,w,C.n),w,w,w,C.aM,C.ad,w,w,w)}}
B.DQ.prototype={
O(){var x=y.S
return new B.a3J($.NJ(),A.C(x,y.B),A.aO(x),A.C(x,y.N),A.et(null,y.H))}}
B.a3J.prototype={
W(){this.Z()
this.d.ac(this.goG())},
y5(){if(this.c!=null)this.j(new B.c1_())},
m(){var x,w=this,v=w.d
v.U(w.goG())
x=w.y
if(x!=null)x.av()
v.a.a4p()
w.a0()},
IJ(d){return this.b6s(d)},
b6s(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$IJ=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.c18(t,d))
r=t.y
if(r!=null)r.av()
t.y=A.hh(C.f0,new B.c19(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.cgd(B.FE(H.NA(q,d,p.yh(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.du(0,0,0,350*B.FE(H.NA(p,d,o.yh(p,d)).b).length,0,0)
x=6
return A.c(r.a.aaf(r.b.c,q,p,new B.c1a(t,d),new B.c1b(t)),$async$IJ)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lN){s=r
r=t.y
if(r!=null)r.av()
if(t.c!=null)t.j(new B.c1c(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$IJ,w)},
G2(d,e){return this.aNz(d,e)},
aNz(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$G2=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.av()
s.j(new B.c13(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.aaj()
if(e&&n!=null)s.IJ(n)
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
s.j(new B.c14(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bJ(new B.c15(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$G2,w)},
gaYk(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b3_(){this.j(new B.c16(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.ka,o=s.e,n=s.gaYk(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("c5<2>")
x=new A.ah(new A.c5(m,l),new B.c1d(),l.i("ah<Y.E>")).gN(0)
l=H.kx(s.a.c)
m=y.p
q=A.a([new B.Ib(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bq(s.a.d)+" \u0644\u062d\u062f "+E.bq(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,r,F.aP,r,r,r),C.v],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b8b(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,r,D.C1,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.DS(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bq(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aI(new A.aR(v,0,!1).dE(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.cf7(v),r,r,r,r,r,K.p3,C.Y,r,r)
j=A.fd(A.v(6),A.qp(C.eC,D.eX,6,s.x,r),C.aB)
u=o<s.a.e
t=A.aX(u?R.Ik:C.nN,r,r,r)
C.b.A(q,A.a([v,C.J,j,C.v,A.fn(t,r,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,r,C.cr,r,r,r),new B.c1e(s,o),A.el(C.w,C.ah,D.uj,r,r,r,r))],m))}else if(n!=null){j=p?new B.c1f(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bq(n)
q.push(A.fn(D.atR,r,A.d(v,r,r,r,r,r,C.cr,r,r,r),j,A.el(C.w,C.ah,D.uj,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aZn)
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
C.b.A(q,A.a([new B.E9(j,v,k,u,r),A.d7(D.avP,D.bBS,s.gb2Z(),r)],m))}q.push(C.v)
q.push(D.CS)
return L.y_(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b8b(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.at9
else if(l.r.n(0,d))x=N.um
else if(i!=null)x=D.ats
else if(j!=null){w=j.gtF()?C.c2:D.apz
x=A.aX(w,j.gtF()?G.cU:D.e3,k,k)}else x=D.arJ
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bq(d),k,k,k,k,k,C.a31,k,k,k),C.bD,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,k,D.a2W,k,k,k))
if(j!=null&&!j.gtF()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gN1()
o=J.bb(p)
n=o.h(p,r)
A:{if(D.jf===n){m=G.cU
break A}if(D.va===n){m=D.e3
break A}if(D.vb===n){m=D.eX
break A}m=C.eZ
break A}m=D.kA.bdP(m,o.h(p,r)===D.vc?C.j8:k,22)
C.b.A(t,A.a([new A.eT(q.a,k,k,C.bv,k,k,k,k,k,k,m),O.BT],u))}w=A.a([C.ak,A.Dv(A.ew(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Y,C.b8)],w)
if(C.c.K(j.c).length===0)w.push(D.bx9)
C.b.A(v,w)}return new E.dG(A.J(v,C.a9,C.d,C.e,0,C.l),C.bQ,C.d9,k,!1,k)}}
B.DP.prototype={
O(){return new B.a3I($.NJ())}}
B.a3I.prototype={
W(){this.Z()
var x=this.d
x.ac(this.goG())
x.vQ()},
y5(){if(this.c!=null)this.j(new B.c0R())},
m(){this.d.U(this.goG())
this.a0()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gaAd(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.i1(o,0,new B.c0Y(q))
v=C.b.i1(o,0,new B.c0Z())
o=y.p
o=A.a([A.A(A.a([A.Q(s.YQ(E.bq(q.gauA()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.O,A.Q(s.YQ(E.bq(q.ar9()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.O,A.Q(s.YQ(E.bq(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.v,new E.dG(A.J(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bq(C.f.al(w*100/v))+"\u066a",r,r,r,r,r,C.bA,r,r,r),C.J,A.fd(A.v(6),A.qp(C.eC,G.cU,8,w/v,r),C.aB),C.ak,A.d(E.bq(w)+" \u0645\u0646 "+E.bq(v)+" \u0622\u064a\u0629",r,r,r,r,r,F.aP,r,r,r)],o),C.r,C.d,C.e,0,C.l),C.a7,C.aM,r,!1,r)],o)
if(p.length===0)o.push(D.aZD)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b8d(p[t]))
o.push(C.B)
u=$.D().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,r,F.aP,r,r,r))
return L.y_(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
YQ(d,e){var x=null
return new E.dG(A.J(A.a([A.d(d,x,x,x,x,x,D.blQ,x,x,x),A.d(e,x,x,x,x,x,C.a3t,C.Y,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a7,C.H,x,!1,x)},
b8d(d){var x=null,w=this.d.c,v=I.cW[d-1].a[1],u=w.a78(d),t=w.bj4(d),s=y.p,r=A.A(A.a([A.Q(A.d(H.kx(d),x,x,x,x,x,C.bA,x,x,x),1),A.d(E.bq(C.f.al(u*100/v))+"\u066a",x,x,x,x,x,D.bmU,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fd(A.v(6),A.qp(C.eC,G.cU,7,u/v,x),C.aB),p=E.bq(u),o=E.bq(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bq(t):""
return new E.dG(A.J(A.a([r,C.J,q,C.ak,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,x,F.aP,x,x,x)],s),C.r,C.d,C.e,0,C.l),C.a7,C.aM,new B.c0X(this,d),!1,x)},
OC(d){return this.aLC(d)},
aLC(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$OC=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cW[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e4(C.cT,new B.c0W(v,d,u),t,!0,null,null,!1,y.H),$async$OC)
case 2:return A.h(null,w)}})
return A.i($async$OC,w)}}
B.akP.prototype={
Sd(d,e){var x=null,w=A.jR(x,x,x,x,x,x,x,x,x,x,x,D.bcx,C.H,x,x,x,x,C.k9,x,x)
return A.b2(A.d(d,x,x,x,x,x,C.mo,x,x,x),x,x,x,new B.b7R(e),x,w)},
t(d){var x=this,w=y.p
return new E.dG(A.J(A.a([D.bAX,C.J,D.bCw,A.cF(C.ar,A.a([x.Sd("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Sd("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.av,0,12),D.bqe,x.Sd("tanzil.net","https://tanzil.net"),D.bEd,x.Sd("everyayah.com","https://everyayah.com")],w),C.r,C.d,C.e,0,C.l),C.a7,C.aM,null,!1,null)}}
B.DS.prototype={
O(){return new B.a3L()}}
B.a3L.prototype={
gann(){var x=this.a
return B.cQH(x.c,x.d,$.cgQ().JU())},
Sf(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$Sf=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.c1U(s))
v=3
r=A.cad()
n=s.gann()
m=y.N
q=A.C(m,m)
J.e_(q,"app","mogtama3y")
J.e_(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.e_(q,"ua",m)}x=6
return A.c(A.abf(n,null,C.GV,q),$async$Sf)
case 6:if(s.c!=null)s.j(new B.c1V(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.c6?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.c1W(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.c1X(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Sf,w)},
t(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bv(!1,t,!0,new A.z(C.lc,A.A(A.a([A.aX(u.d?C.yL:C.lr,C.c9,t,18),C.bM,D.bDk],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.c1Z(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.E(t,A.p3(u.gann(),D.bi1,t,C.z),C.k,t,t,new A.G(C.q3,t,t,x,t,t,t,C.n),t,t,t,D.akS,C.eh,t,t,1/0))}if(u.f)s.push(D.bqy)
else{x=A.jR(t,t,t,t,t,t,t,t,t,t,t,C.a1h,C.H,t,t,t,t,C.k9,t,t)
w=u.e
v=w?t:u.gb8c()
s.push(A.eY(w?C.a1v:D.avd,t,D.bzV,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,t,D.a2W,t,t,t))
return new A.z(C.aM,A.J(s,C.r,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["al<~>()","~()","M(nQ)","al<KD>()","al<KB>()","al<KC>()","a6<nQ>()","M(rK)","bI(oW)","DR(u)","DP(u)","M(na)","DQ(u)","M(Jd)"])
B.b7S.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.S(A.cW(b.G.document).baseURI)
q=A.bt(r,0,null).a2("quran_tutor/tutor.js?v=3").k(0)
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
m=B.cFR("network",A.n(o))
throw A.t(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:314}
B.b7V.prototype={
$1(d){var x=null
return A.c4u(A.cR(d,"persist",x,x,x,x))},
$S:1163}
B.b7U.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.ri(),$async$$0)
case 4:x=3
return A.c(n.eK(m.cW(l.cR(e,"loadModel",A.c5c(new B.b7T(u.b)),u.c,u.d,null)),y.m),$async$$0)
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
v=new B.KB(o,t,s,r,q.rh(p,"threads"),q.ou(p,"isolated"),q.rh(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b7T.prototype={
$2(d,e){this.a.$2(C.f.al(d),C.f.al(e))},
$S:1164}
B.b7Z.prototype={
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
u.onLevel=A.fY(new B.b7X(v.e))
u.onAutoStop=A.fY(new B.b7Y(v.f))
x=5
return A.c(A.eK(A.cW(A.cR(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b7X.prototype={
$1(d){return this.a.$1(d)},
$S:72}
B.b7Y.prototype={
$1(d){return this.a.$1(d)},
$S:4}
B.b8_.prototype={
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
v=new B.KC(r,A.dV(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b81.prototype={
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
return A.c(q.eK(p.cW(o.cR(e,"transcribe",t.audio,t.rate,s.ajA(u.c),null)),y.m),$async$$0)
case 3:v=r.anh(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b80.prototype={
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
return A.c(r.eK(q.cW(p.cR(e,"transcribeUrl",u.b,t.ajA(u.c),null,null)),y.m),$async$$0)
case 3:v=s.anh(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b7W.prototype={
$1(d){return d},
$S:37}
B.aYS.prototype={
$0(){var x,w,v,u,t=this.a,s=A.cc(t.a.length,D.vc,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aYR.prototype={
$1(d){return d===D.jf},
$S:z+2}
B.c4W.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.cbd(e[x],d[x])<0.75)return!1
return!0},
$S:1165}
B.c72.prototype={
$1(d){return d.length!==0},
$S:10}
B.b85.prototype={
$1(d){return d.a===D.fn},
$S:z+7}
B.b86.prototype={
$1(d){return C.j.aI(d,1000)},
$S:59}
B.b83.prototype={
$1(d){return C.f.bB(d)},
$S:1166}
B.b87.prototype={
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
i=C.b.n(D.Kc,k.h(0,"r"))?A.ez(k.h(0,"r")):1
h=A.eq(k.h(0,"auto"))
g=A.eq(k.h(0,"hide"))
k=A.eq(k.h(0,"in"))
s.a.b=new B.Wv(j,i,h!==!1,g===!0,k===!0)}u=2
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
if(q!=null)s.a.c=B.ceq(y.P.a(C.ap.f4(q,null)))
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
n=C.f.bB(A.cT(J.at(o,"s")))
m=C.f.bB(A.cT(J.at(o,"f")))
l=C.f.bB(A.cT(J.at(o,"t")))
if(B.csR(n,m)&&B.csR(n,l)&&m<=l)s.a.z=new A.aZ(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.aa3()){k.a.as_()
x=1
break}a1=k
x=18
return A.c(k.a.Nm(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a5()
if(k.b.e)k.Dw()
k.wN()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:114}
B.b88.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a5()},
$S:1167}
B.b89.prototype={
$2(d,e){return C.j.aI(A.eJ(A.n(d),null,null),1000)===this.a},
$S:1168}
B.bOt.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.EO(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bOs(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1169}
B.bOs.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bOu.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bOr(x,d))},
$S:z+8}
B.bOr.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bOv.prototype={
$1(d){},
$S:26}
B.bOf.prototype={
$0(){},
$S:0}
B.bOl.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.DR(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bOm.prototype={
$0(){},
$S:0}
B.bOp.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aD(A.aH(new B.bOo(),null,x),x)},
$S:0}
B.bOo.prototype={
$1(d){return D.bFD},
$S:z+10}
B.bOq.prototype={
$0(){return B.csD(this.a)},
$S:0}
B.bOi.prototype={
$0(){var x=this.b
return this.a.y6(x.a,x.b,x.c)},
$S:0}
B.bOj.prototype={
$1(d){return this.a.j(new B.bOh())},
$S:4}
B.bOh.prototype={
$0(){},
$S:0}
B.bOk.prototype={
$0(){var x=this.a
return x.j(new B.bOg(x))},
$S:0}
B.bOg.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bOn.prototype={
$0(){return this.a.b8a(this.b)},
$S:0}
B.c9R.prototype={
$1(d){return new A.jj(new B.c9O(this.a,this.b,this.c),null)},
$S:56}
B.c9O.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c9Q(u,e),s=this.a,r=new B.c9P(s,e),q=A.d(H.kx(this.c),v,v,v,v,v,C.p_,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bq(u)+" \u0622\u064a\u0629)",v,v,v,v,v,F.aP,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bq(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bq(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.ak,p,C.v,A.cF(C.ar,n,C.av,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c9J(s)),C.a1s,t.$3("\u0644\u062d\u062f",s.c,new B.c9K(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aZs)
u.push(C.a5)
u.push(A.d1(D.btI,v,new B.c9L(s,d),A.el(C.w,C.ah,D.bcV,v,v,v,v)))
return A.cx(!0,new A.z(C.Gm,A.J(u,C.a9,C.d,C.I,0,C.l),v),C.H,!0)},
$S:286}
B.c9Q.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,u,C.ic,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c4(v,A.d("\u0622\u064a\u0629 "+E.bq(v),u,u,u,u,u,u,u,u,u),C.ai,u,w))
return A.Q(A.J(A.a([t,Q.GU(C.cT,!0,s,320,new B.c9N(this.b,f),D.bna,e,y.S)],y.p),C.r,C.d,C.e,0,C.l),1)},
$S:1171}
B.c9N.prototype={
$1(d){return d==null?null:this.a.$1(new B.c9M(this.b,d))},
$S:51}
B.c9M.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c9P.prototype={
$3(d,e,f){var x=null
return A.aCp(x,A.d(d,x,x,x,x,x,x,x,x,x),new B.c9I(this.a,this.b,e,f))},
$S:1172}
B.c9I.prototype={
$0(){var x=this
return x.b.$1(new B.c9H(x.a,x.c,x.d))},
$S:0}
B.c9H.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c9J.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c9K.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c9L.prototype={
$0(){var x=this.a
return A.O(this.b,!1).ad(new A.W(x.b,x.c))},
$S:0}
B.c1g.prototype={
$0(){},
$S:0}
B.c1w.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mJ
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.c1A.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.jm:D.mJ},
$S:0}
B.c1B.prototype={
$0(){var x=this.a
x.f=D.vq
x.as=null},
$S:0}
B.c1C.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.c1E.prototype={
$0(){var x=this.a
x.f=D.vr
x.as=null
x.y=0
x.z=new A.aR(Date.now(),0,!1)
x.ax=null},
$S:0}
B.c1F.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c1D())},
$S:28}
B.c1D.prototype={
$0(){},
$S:0}
B.c1H.prototype={
$1(d){return this.a.y=d},
$S:72}
B.c1G.prototype={
$1(d){return this.a.C_()},
$S:4}
B.c1I.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.jm:D.mJ
x=this.b
w.as=B.NC(x)
w.at=x},
$S:0}
B.c1K.prototype={
$0(){var x=this.a
x.f=D.ps
x.ay=Date.now()},
$S:0}
B.c1L.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c1J())},
$S:28}
B.c1J.prototype={
$0(){},
$S:0}
B.c1v.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.jm:D.mJ
x.as=this.b
x.at=this.c},
$S:0}
B.c1x.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.jm
x.x=!1},
$S:0}
B.c1o.prototype={
$0(){var x=this.a
x.f=D.ps
x.ay=Date.now()
x.as=null},
$S:0}
B.c1p.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c1n())},
$S:28}
B.c1n.prototype={
$0(){},
$S:0}
B.c1q.prototype={
$1(d){return d.d!==D.jf},
$S:z+11}
B.c1r.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.c1Q.prototype={
$0(){return B.csD(this.a)},
$S:0}
B.c1R.prototype={
$1(d){var x=this.a.d
return x.qS(x.b.aqF(d))},
$S:3}
B.c1S.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aD(A.aH(new B.c1P(this.a),null,x),x)},
$S:0}
B.c1P.prototype={
$1(d){var x=this.a.a
return new B.DQ(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.c1T.prototype={
$0(){this.a.d.a.bnm()
this.b.H(y.q).f.Y(D.be4)},
$S:0}
B.c1u.prototype={
$2(d,e){return C.aV},
$S:18}
B.c1t.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a7g(s.c,r).a.a){case 2:s=G.cU
break
case 1:s=D.e3
break
case 0:s=C.is
break
default:s=u}x=A.v(18)
w=t.f===D.ps?u:new B.c1s(t,r)
v=s.a9(0.25)
if(r===t.gjg())s=C.i
s=A.aK(s,r===t.gjg()?2:1)
return A.bv(!1,x,!0,A.E(C.P,A.d(E.bq(r),u,u,u,u,u,C.a2A,u,u,u),C.k,u,u,new A.G(v,u,s,u,u,u,u,C.bX),u,u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:65}
B.c1s.prototype={
$0(){return this.a.a_Z(this.b)},
$S:0}
B.c1z.prototype={
$0(){var x=this.a
return x.j(new B.c1y(x))},
$S:0}
B.c1y.prototype={
$0(){return this.a.x=!0},
$S:0}
B.c1M.prototype={
$1(d){return d===D.va},
$S:z+2}
B.c1N.prototype={
$1(d){return d===D.vb},
$S:z+2}
B.c1O.prototype={
$1(d){return d===D.vc},
$S:z+2}
B.c1h.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Se(x)},
$S:0}
B.c1i.prototype={
$1(d){var x=this.a.d
return x.qS(x.b.bdd(d.ga1(d)))},
$S:116}
B.c1k.prototype={
$1(d){return d.n(0,C.V)?C.ah:C.i},
$S:5}
B.c1j.prototype={
$1(d){return d.n(0,C.V)?C.w:C.a8},
$S:5}
B.c1l.prototype={
$0(){var x=this.a
return x.a_Z(x.gjg()+1)},
$S:0}
B.c1m.prototype={
$0(){var x=this.a
return x.a_Z(x.gjg()+1)},
$S:0}
B.c1_.prototype={
$0(){},
$S:0}
B.c18.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aR(Date.now(),0,!1)},
$S:0}
B.c19.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.c17())},
$S:28}
B.c17.prototype={
$0(){},
$S:0}
B.c1b.prototype={
$1(d){return this.a.x=d},
$S:72}
B.c1a.prototype={
$1(d){return this.a.G2(this.b,!1)},
$S:4}
B.c1c.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.NC(x)
w.as=x},
$S:0}
B.c13.prototype={
$0(){var x=this.a
x.e=null
x.r.D(0,this.b)},
$S:0}
B.c14.prototype={
$0(){var x,w=this.a,v=this.b
w.r.L(0,v)
x=this.c
w.w.p(0,v,B.NC(x))
w.as=x},
$S:0}
B.c15.prototype={
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
return A.c(n.a.awA(s.b,B.FE(H.NA(l,m,k.yh(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cqM(H.NA(l,m,k.yh(l,m)).b,r.a)
if(C.c.K(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtF()
l.avB(k,m,n.b.a,j)}n.A6()
if(o.c!=null)o.j(new B.c10(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lN){p=o
o=s.a
if(o.c!=null)o.j(new B.c11(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.c12(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:148}
B.c10.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.c11.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.NC(w))
x.as=w},
$S:0}
B.c12.prototype={
$0(){return this.a.r.L(0,this.b)},
$S:0}
B.c16.prototype={
$0(){var x=this.a
x.f.ao(0)
x.w.ao(0)
x.as=null},
$S:0}
B.c1d.prototype={
$1(d){return d.gtF()},
$S:z+13}
B.c1e.prototype={
$0(){return this.a.G2(this.b,!0)},
$S:0}
B.c1f.prototype={
$0(){return this.a.IJ(this.b)},
$S:0}
B.c0R.prototype={
$0(){},
$S:0}
B.c0Y.prototype={
$2(d,e){return d+this.a.a78(e)},
$S:117}
B.c0Z.prototype={
$2(d,e){return d+I.cW[e-1].a[1]},
$S:117}
B.c0X.prototype={
$0(){return this.a.OC(this.b)},
$S:0}
B.c0W.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kx(p),q,q,q,q,q,C.p_,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.b9(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.rz():r).a.a){case 2:r=G.cU.a9(0.35)
break
case 1:r=D.e3.a9(0.35)
break
case 0:r=C.h1
break
default:r=q}m.push(A.E(C.P,A.d(E.bq(t),q,q,q,q,q,C.ky,q,q,q),C.k,q,q,new A.G(r,q,q,new A.cE(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,q,38))}return A.cx(!0,new A.z(C.h8,A.J(A.a([o,C.ak,D.by5,C.v,new A.dm(D.a8y,A.f4(A.cF(C.ar,m,C.av,6,6),q,C.q,q,q,q,C.y),q),C.T,A.b2(D.bzY,q,q,q,new B.c0V(w,d,p),q,q)],n),C.a9,C.d,C.I,0,C.l),q),C.H,!0)},
$S:35}
B.c0V.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dc(null,null,!0,null,new B.c0U(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.LH(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e5()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.c0U.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kx(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x,x)
return A.di(A.a([A.b2(C.ev,x,x,x,new B.c0S(d),x,x),A.b2(C.pf,x,x,x,new B.c0T(d),x,x)],y.p),w,D.bBA)},
$S:14}
B.c0S.prototype={
$0(){A.O(this.a,!1).ad(!1)
return null},
$S:0}
B.c0T.prototype={
$0(){A.O(this.a,!1).ad(!0)
return null},
$S:0}
B.caO.prototype={
$1(d){var x=this.a
return new A.kO(new B.caN(x),null,x,null)},
$S:1173}
B.caN.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.eh(w,t,A.d(E.bq(w),t,t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bq9,C.T,D.bAn,C.J,A.nG(new B.caI(s,r),q,A.dh([r.a],x),!1,A.kB(t,t,t,new A.bh(new B.caJ(),v),t,t,t,t,new A.bh(new B.caK(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.iB(C.w,C.H,t,new B.caL(s,r),D.bxk,D.bDB,r.c),A.iB(C.w,C.H,t,new B.caM(s,r),t,D.bpA,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ak,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn7(),t,t,t,t,t,F.aP,t,C.b8,t)],u))
x.push(C.B)
x.push(D.a4F)
return A.cx(!0,A.f4(A.J(x,C.a9,C.d,C.e,0,C.l),t,C.q,C.h8,t,t,C.y),C.H,!0)},
$S:1174}
B.caI.prototype={
$1(d){return this.a.qS(this.b.bda(d.ga1(d)))},
$S:116}
B.caK.prototype={
$1(d){return d.n(0,C.V)?C.ah:C.i},
$S:5}
B.caJ.prototype={
$1(d){return d.n(0,C.V)?C.w:C.a8},
$S:5}
B.caL.prototype={
$1(d){return this.a.qS(this.b.bcw(d))},
$S:3}
B.caM.prototype={
$1(d){return this.a.qS(this.b.aqF(d))},
$S:3}
B.b7R.prototype={
$0(){return A.ck(A.bt(this.a,0,null),C.aH,null)},
$S:0}
B.cb6.prototype={
$1(d){var x,w=A.aC("https?://",!0,!1,!1)
w=A.bD(d,w,"")
x=A.aC("www\\.",!0,!1,!1)
return A.vd(A.bD(w,x,"www[.]"),A.aC("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.cb7(),null)},
$S:37}
B.cb7.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:57}
B.c1U.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.c1V.prototype={
$0(){return this.a.f=!0},
$S:0}
B.c1W.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.c1X.prototype={
$0(){return this.a.e=!1},
$S:0}
B.c1Z.prototype={
$0(){var x=this.a
return x.j(new B.c1Y(x))},
$S:0}
B.c1Y.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.cb5.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:179};(function installTearOffs(){var x=a._instance_0u
x(B.akQ.prototype,"gbj5","bj6",1)
var w
x(w=B.Ww.prototype,"gbjn","Dw",0)
x(w,"gaFi","wN",0)
x(w=B.a1b.prototype,"goG","y5",1)
x(w,"gb_a","Qz",0)
x(w=B.a3K.prototype,"goG","y5",1)
x(w,"gb24","QZ",0)
x(w,"gb6J","C_",0)
x(w,"gaLg","Oz",0)
x(w=B.a3J.prototype,"goG","y5",1)
x(w,"gb2Z","b3_",1)
x(B.a3I.prototype,"goG","y5",1)
x(B.a3L.prototype,"gb8c","Sf",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a7,[B.akQ,B.Wx,B.KB,B.KD,B.KC,B.lN,B.TD,B.na,B.Jd,B.rK,B.akR,B.Wv])
x(A.lm,[B.b7S,B.b7U,B.b7Z,B.b8_,B.b81,B.b80,B.aYS,B.b87,B.bOs,B.bOr,B.bOf,B.bOm,B.bOp,B.bOq,B.bOi,B.bOh,B.bOk,B.bOg,B.bOn,B.c9M,B.c9I,B.c9H,B.c9L,B.c1g,B.c1w,B.c1A,B.c1B,B.c1C,B.c1E,B.c1D,B.c1I,B.c1K,B.c1J,B.c1v,B.c1x,B.c1o,B.c1n,B.c1r,B.c1Q,B.c1S,B.c1T,B.c1s,B.c1z,B.c1y,B.c1h,B.c1l,B.c1m,B.c1_,B.c18,B.c17,B.c1c,B.c13,B.c14,B.c10,B.c11,B.c12,B.c16,B.c1e,B.c1f,B.c0R,B.c0X,B.c0V,B.c0S,B.c0T,B.b7R,B.c1U,B.c1V,B.c1W,B.c1X,B.c1Z,B.c1Y])
x(A.iP,[B.b7V,B.b7X,B.b7Y,B.b7W,B.aYR,B.c72,B.b85,B.b86,B.b83,B.bOt,B.bOu,B.bOv,B.bOl,B.bOo,B.bOj,B.c9R,B.c9Q,B.c9N,B.c9P,B.c9J,B.c9K,B.c1F,B.c1H,B.c1G,B.c1L,B.c1p,B.c1q,B.c1R,B.c1P,B.c1M,B.c1N,B.c1O,B.c1i,B.c1k,B.c1j,B.c19,B.c1b,B.c1a,B.c15,B.c1d,B.c0W,B.c0U,B.caO,B.caI,B.caK,B.caJ,B.caL,B.caM,B.cb6,B.cb7,B.cb5])
x(A.oj,[B.b7T,B.c4W,B.b88,B.b89,B.c9O,B.c1u,B.c1t,B.c0Y,B.c0Z,B.caN])
x(A.Er,[B.nQ,B.FY,B.Ia,B.EU])
w(B.Ww,A.i9)
x(A.K,[B.xd,B.DR,B.DQ,B.DP,B.DS])
x(A.N,[B.a1b,B.a3K,B.a3J,B.a3I,B.a3L])
x(A.a3,[B.Ib,B.YX,B.E9,B.akP])})()
A.pz(b.typeUniverse,JSON.parse('{"lN":{"bN":[]},"DR":{"K":[],"l":[]},"DQ":{"K":[],"l":[]},"DP":{"K":[],"l":[]},"DS":{"K":[],"l":[]},"Ww":{"aI":[]},"xd":{"K":[],"l":[]},"a1b":{"N":["xd"]},"Ib":{"a3":[],"l":[]},"YX":{"a3":[],"l":[]},"a3K":{"N":["DR"]},"E9":{"a3":[],"l":[]},"a3J":{"N":["DQ"]},"a3I":{"N":["DP"]},"akP":{"a3":[],"l":[]},"a3L":{"N":["DS"]}}'))
var y=(function rtii(){var x=A.ag
return{u:x("rK"),c:x("eh<x>"),r:x("c4<x>"),k:x("H<na>"),n:x("H<eh<x>>"),I:x("H<c4<x>>"),R:x("H<hV>"),Z:x("H<aD<o,@>>"),d:x("H<TD>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bT"),j:x("a6<@>"),L:x("a6<x>"),P:x("aD<o,@>"),f:x("aD<@,@>"),x:x("av<o,x>"),a:x("bI"),K:x("a7"),B:x("Jd"),l:x("+(x,x)"),e:x("d8<na>"),N:x("o"),C:x("KB"),D:x("KC"),X:x("Wx"),_:x("KD"),U:x("ah<o>"),G:x("nQ"),q:x("pw"),b:x("bh<V?>"),y:x("M"),i:x("a2"),z:x("@"),S:x("x"),A:x("bT?"),Y:x("aD<@,@>?"),O:x("a7?"),M:x("+quota,usage(x,x)?"),o:x("dK"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.pB=new B.FY(0,"none")
D.pC=new B.FY(1,"learning")
D.fn=new B.FY(2,"memorized")
D.a8y=new A.aE(0,1/0,0,320)
D.eX=new A.V(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.t)
D.a8I=new A.G(D.eX,null,null,null,null,null,null,C.bX)
D.e3=new A.V(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.t)
D.aur=new A.F(C.yW,null,C.c9,null,null,null)
D.bBI=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.ff,null,null,null,null,null,null,null,null)
D.biv=new A.r(!0,C.eZ,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.by7=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.biv,null,null,null,null,null,null,null,null)
D.aMu=x([D.aur,C.J,D.bBI,D.by7],y.p)
D.ah_=new A.fk(C.y,C.d,C.e,C.h,null,C.l,null,0,D.aMu,null)
D.akP=new A.T(0,26,0,26)
D.akS=new A.T(0,4,0,6)
D.alh=new A.T(14,12,14,14)
D.am0=new A.T(3,0,0,0)
D.apz=new A.R(63251,"MaterialIcons",null,!1)
D.r2=new A.R(63677,"MaterialIcons",null,!1)
D.aqn=new A.R(983209,"MaterialIcons",null,!1)
D.ar1=new A.F(D.aqn,28,C.w,null,null,null)
D.arJ=new A.F(C.I3,null,C.is,null,null,null)
D.api=new A.R(62961,"MaterialIcons",null,!1)
D.asr=new A.F(D.api,null,null,null,null,null)
D.apx=new A.R(63199,"MaterialIcons",null,!1)
D.ass=new A.F(D.apx,null,null,null,null,null)
D.asA=new A.F(C.jR,null,C.eZ,null,null,null)
D.asE=new A.F(C.nN,44,C.i,null,null,null)
D.at9=new A.F(D.r2,null,D.eX,null,null,null)
D.ats=new A.F(C.lq,null,D.eX,null,null,null)
D.atR=new A.F(D.r2,null,null,null,null,null)
D.auo=new A.F(C.hU,20,D.e3,null,null,null)
D.auL=new A.F(C.nK,30,C.w,null,null,null)
D.avd=new A.F(C.lw,16,C.w,null,null,null)
D.avF=new A.F(C.I_,null,null,null,null,null)
D.avP=new A.F(C.nM,null,null,null,null,null)
D.aw0=new A.F(C.HN,null,null,null,null,null)
D.Kc=x([1,3,5],y.t)
D.L_=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.b_6=new A.z(C.iy,C.mV,null)
D.aJ3=x([D.b_6],y.p)
D.b3E=new A.W(C.nG,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b3r=new A.W(D.r2,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b3Z=new A.W(C.db,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.b4c=new A.W(C.I2,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aLn=x([D.b3E,D.b3r,D.b3Z,D.b4c],A.ag("H<+(R,o)>"))
D.aNW=x([D.pB,D.pC,D.fn],A.ag("H<FY>"))
D.PH=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aVM=new B.Ia(0,"idle")
D.W0=new B.Ia(1,"loading")
D.ka=new B.Ia(2,"ready")
D.aVN=new B.Ia(3,"failed")
D.at7=new A.F(C.c2,18,G.cU,null,null,null)
D.bCJ=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uQ,null,null,null,null,null,null,null,null)
D.aHS=x([D.at7,C.aV,D.bCJ],y.p)
D.baj=new A.ed(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aHS,null)
D.aYV=new A.z(C.aM,D.baj,null)
D.alZ=new A.T(2,6,2,4)
D.bib=new A.r(!0,C.w,null,null,null,null,14,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bq5=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bib,null,null,null,null,null,null,null,null)
D.aZa=new A.z(D.alZ,D.bq5,null)
D.bD8=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.ff,null,null,null,null,null,null,null,null)
D.aJq=x([N.um,C.O,D.bD8],y.p)
D.bad=new A.ed(C.ae,C.ch,C.e,C.h,null,C.l,null,0,D.aJq,null)
D.aZn=new A.z(C.lb,D.bad,null)
D.Cg=new A.r(!0,D.e3,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bDt=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Cg,null,null,null,null,null,null,null,null)
D.aZs=new A.z(C.dp,D.bDt,null)
D.bCE=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aP,C.Y,null,null,null,null,null,null,null)
D.aZD=new A.z(C.C,D.bCE,null)
D.alW=new A.T(2,0,2,8)
D.byp=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aP,null,null,null,null,null,null,null,null)
D.aZW=new A.z(D.alW,D.byp,null)
D.avm=new A.F(C.lu,30,C.w,null,null,null)
D.bEe=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Ch,null,null,null,null,null,null,null,null)
D.an7=new A.bW(1,C.af,D.bEe,null)
D.aJG=x([D.avm,C.a_,D.an7],y.p)
D.b9Z=new A.ed(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aJG,null)
D.auY=new A.F(C.db,18,G.cU,null,null,null)
D.a2K=new A.r(!0,G.cU,null,null,null,null,12,C.R,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bCm=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a2K,null,null,null,null,null,null,null,null)
D.aIk=x([D.auY,C.bM,D.bCm],y.p)
D.bab=new A.ed(C.ae,C.d,C.I,C.h,null,C.l,null,0,D.aIk,null)
D.bcx=new A.X(0,30)
D.uj=new A.X(1/0,54)
D.bcV=new A.X(1/0,48)
D.bcY=new A.X(1/0,50)
D.bd0=new A.X(1/0,52)
D.bA7=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.be4=new A.cV(D.bA7,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.bhB=new A.r(!0,C.i,null,null,null,null,14.5,C.R,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bi1=new A.r(!0,C.ao,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.C1=new A.r(!0,D.eX,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.kA=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a2W=new A.r(!0,D.eX,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.blQ=new A.r(!0,C.w,null,null,null,null,24,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmT=new A.r(!0,D.e3,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmU=new A.r(!0,G.cU,null,null,null,null,null,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bna=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.boS=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.ic,null,null,null,null,null,null,null,null)
D.bpA=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.d1,null,null,null,null,null,null,null,null)
D.bq9=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.p_,null,null,null,null,null,null,null,null)
D.bqe=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aP,null,null,null,null,null,null,null,null)
D.bjn=new A.r(!0,G.cU,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bqy=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bjn,null,null,null,null,null,null,null,null)
D.bqE=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aP,null,null,null,null,null,null,null,null)
D.br4=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.ff,null,null,null,null,null,null,null,null)
D.bsW=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cr,null,null,null,null,null,null,null,null)
D.btI=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bE,null,null,null,null,null,null,null,null)
D.btO=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aP,null,null,null,null,null,null,null,null)
D.bug=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.uR,null,null,null,null,null,null,null,null)
D.bvz=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bw7=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.p3,null,null,null,null,null,null,null,null)
D.bwV=new A.m("reset safe mode / WebGPU ban",null,C.BV,null,null,null,null,null,null,null,null)
D.bx9=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Cg,null,null,null,null,null,null,null,null)
D.bxk=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aP,null,null,null,null,null,null,null,null)
D.bxM=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bA,null,null,null,null,null,null,null,null)
D.by5=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aP,null,null,null,null,null,null,null,null)
D.byq=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aP,null,null,null,null,null,null,null,null)
D.bzV=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a3m,null,null,null,null,null,null,null,null)
D.bl0=new A.r(!0,D.eX,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bzY=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bl0,null,null,null,null,null,null,null,null)
D.bAn=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.p3,null,null,null,null,null,null,null,null)
D.bAX=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a2c,null,null,null,null,null,null,null,null)
D.bBc=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cr,null,null,null,null,null,null,null,null)
D.bBA=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bBS=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bCw=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aP,null,null,null,null,null,null,null,null)
D.bCx=new A.m("\u062e\u0644\u0635\u062a",null,C.mp,null,null,null,null,null,null,null,null)
D.bCy=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Cg,null,null,null,null,null,null,null,null)
D.bm8=new A.r(!0,C.cN,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.fO,null,null,null,null,null,null,null,null)
D.bDk=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bm8,null,null,null,null,null,null,null,null)
D.bDx=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bA,null,null,null,null,null,null,null,null)
D.bDB=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.d1,null,null,null,null,null,null,null,null)
D.bEd=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aP,null,null,null,null,null,null,null,null)
D.a4F=new B.akP(null)
D.bFD=new B.DP(null)
D.bFE=new B.Wv(2,1,!0,!1,!1)
D.a4J=new B.Wx(!1,!1,!1,!1,!1,0)
D.jf=new B.nQ(0,"ok")
D.va=new B.nQ(1,"near")
D.vb=new B.nQ(2,"wrong")
D.vc=new B.nQ(3,"missing")
D.a5a=new B.nQ(4,"extra")
D.apO=new A.R(63456,"MaterialIcons",null,!1)
D.bLM=new B.E9(D.e3,D.apO,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bMp=new B.YX(!1,null)
D.CS=new B.YX(!0,null)
D.mJ=new B.EU(0,"idle")
D.vq=new B.EU(1,"playing")
D.vr=new B.EU(2,"recording")
D.ps=new B.EU(3,"thinking")
D.jm=new B.EU(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cTH","cgQ",()=>new B.akQ())
x($,"cXa","cwB",()=>A.aC("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cXb","cwC",()=>A.aC("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cXn","cwL",()=>A.aC("\u0648\u0670",!0,!1,!1))
x($,"cWJ","cwh",()=>A.aC("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cUZ","cv5",()=>A.aC("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cWe","cvU",()=>A.aC("[\u0654\u0655]",!0,!1,!1))
x($,"cV_","cv6",()=>A.aC("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cV6","cvc",()=>A.aC("[\u0624\u0626]",!0,!1,!1))
x($,"cWg","cvW",()=>A.aC("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cWO","cwk",()=>A.aC("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cWo","cw2",()=>A.aC("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cX8","chr",()=>A.aC("\\s+",!0,!1,!1))
x($,"cR_","rz",()=>B.cxC(D.pB,0,A.ccn(0,!0)))
x($,"cTI","NJ",()=>new B.Ww($.cgQ(),D.bFE,B.cFS(),D.aVM,$.U()))})()};
(a=>{a["cF4JqPiyMM/bEFueqItE2xxbD2k="]=a.current})($__dart_deferred_initializers__);