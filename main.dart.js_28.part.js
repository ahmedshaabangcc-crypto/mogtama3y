((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,Q,H,G,N,R,K,B={
cyB(d){var x,w,v,u,t,s
if(d instanceof B.lE)return d
try{x=A.d1(d)
w=x.code
v=x.message
u=w==null?"failed":A.a_(w)
t=v==null?"":A.a_(v)
return new B.lE(u,t)}catch(s){u=A.n(d)
return new B.lE("failed",u)}},
aj0:function aj0(){this.b=this.a=null},
b4V:function b4V(d){this.a=d},
b4Y:function b4Y(){},
b4X:function b4X(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b4W:function b4W(d){this.a=d},
b51:function b51(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b5_:function b5_(d){this.a=d},
b50:function b50(d){this.a=d},
b52:function b52(d){this.a=d},
b54:function b54(d,e,f){this.a=d
this.b=e
this.c=f},
b53:function b53(d,e,f){this.a=d
this.b=e
this.c=f},
b4Z:function b4Z(){},
cyC(d,e){return new B.lE(d,e)},
Vp:function Vp(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
JD:function JD(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
JF:function JF(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
JE:function JE(d,e){this.a=d
this.b=e},
lE:function lE(d,e){this.a=d
this.b=e},
ckZ(d){var x,w=$.cpH()
w=A.bD(d,w,"\u0627")
x=$.cpI()
w=A.bD(w,x,"\u064a")
x=$.cpR()
w=A.bD(w,x,"\u0627")
x=$.coc()
w=A.bD(w,x,"\u0627")
x=$.cpn()
w=A.bD(w,x,"\u0621")
x=$.cp_()
w=A.bD(w,x,"\u0621")
x=$.cod()
w=A.bD(w,x,"\u0627")
x=$.coj()
w=A.bD(w,x,"\u0621")
w=A.bD(w,"\u0649","\u064a")
w=A.bD(w,"\u0629","\u0647")
x=$.cp1()
w=A.bD(w,x,"")
x=$.cpq()
w=A.bD(w,x," ")
x=$.cp8()
w=A.bD(w,x," ")
x=$.caE()
return C.c.O(A.bD(w,x," "))},
cDi(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kB(x,w)
for(u=0;u<x;++u)v[u]=u
t=A.cm(x,0,!1,w)
for(s=1;s<=l;++s,r=t,t=v,v=r){t[0]=s
for(w=s-1,u=1;u<=k;++u){q=u-1
p=d.charCodeAt(w)===e.charCodeAt(q)?0:1
o=v[u]+1
n=t[q]+1
m=v[q]+p
if(o<n)q=o<m?o:m
else q=n<m?n:m
t[u]=q}}return v[k]},
c4v(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aB("[\u0627\u0621]",!0,!1,!1)
w=A.bD(d,x,"")
x=A.aB("[\u0627\u0621]",!0,!1,!1)
v=A.bD(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cDi(d,e)/u
return s>=1?0.99:s},
EM(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tX(d,$.caE()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.ckZ(u)
s=A.bD(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Sw(r.a+" "+u,r.b))}continue}q.push(new B.Sw(u,s))}return q},
cBY(d,e){var x,w,v,u,t=new B.bZN(),s=A.a([],y.s)
for(x=A.fF(e,0,A.iy(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.cb(x,x.gM(0),w.i("cb<aY.E>")),w=w.i("aY.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.JS)&&t.$2(d,D.JS)?C.b.jy(d,5):d
return!t.$2(s,D.Ow)&&t.$2(u,D.Ow)?C.b.jy(u,4):u},
cjV(d,e){var x=B.EM(d),w=B.ckZ(e),v=y.U
v=A.aa(new A.ak(A.a(w.split(" "),y.s),new B.c0T(),v),v.i("Z.E"))
return new B.Ig(x,B.cB8(x,B.cBY(v,x)),w)},
cB8(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.cm(x,0,!1,s)
q=A.cm(x,0,!1,y.S)
p=A.cm(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c4v(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c4v(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c4v(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
else m=a2>=0.6?D.uC:D.uD
a1.push(new B.mU(o,x,s,m))
break
case 1:--o
a1.push(new B.mU(o,a4[o],null,D.uE))
break
case 2:--n
a1.push(new B.mU(null,null,a6[n],D.a3O))
break
case 3:--o
a3=n-2
a1.push(new B.mU(o,a4[o],a6[a3]+" "+a6[n-1],D.j2))
n=a3
break
default:x=o-1;--n
a1.push(new B.mU(x,a4[x],a6[n],D.j2))
o-=2
a1.push(new B.mU(o,a4[o],a6[n],D.j2))}}a4=y.e
a4=A.aa(new A.d6(a1,a4),a4.i("aY.E"))
return a4},
nz:function nz(d,e){this.a=d
this.b=e},
Sw:function Sw(d,e){this.a=d
this.b=e},
mU:function mU(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Ig:function Ig(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aWa:function aWa(d){this.a=d},
aW9:function aW9(){},
bZN:function bZN(){},
c0T:function c0T(){},
cqG(d,e,f){return new B.rr(d,e,f)},
cEd(d){var x
A:{if("memorized"===d){x=D.fg
break A}if("learning"===d){x=D.p6
break A}x=D.p5
break A}return x},
clY(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cN[d-1].a[1]},
cyD(){var x=y.S
return new B.aj1(A.B(x,y.u),A.aU(x))},
b57(d){var x=d.fm()
return C.c.dn(C.j.j(A.bq(x)),4,"0")+"-"+C.c.dn(C.j.j(A.bs(x)),2,"0")+"-"+C.c.dn(C.j.j(A.bW(x)),2,"0")},
cgP(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cFD(),x),x.i("aY.E"))
return B.b57(A.dq(w[0],w[1],w[2]-1,12,0,0,0))},
c7E(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.B(p,y.u),n=A.aU(p),m=new B.aj1(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcP(),x=x.ga0(x),w=y.j;x.v();){v=x.gJ()
u=A.dS(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aP(t)>=3){v=C.j.aH(u,1000)
s=C.j.a2(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cN[v-1].a[1])}if(v)continue
v=J.be(t)
r=C.f.bW(A.cR(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rr(D.aKr[r],C.f.bW(A.cR(v.h(t,1))),new A.aQ(A.ks(C.f.bW(A.cR(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aAh(q,y.o)
p=A.mp(x,new B.b56(),x.$ti.i("Z.E"),p)
n.A(0,new A.ak(p,o.ga3E(),A.y(p).i("ak<Z.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aG(d.h(0,"streak"))
p=p==null?null:C.f.bW(p)
p=m.d=p==null?0:p
o=A.aG(d.h(0,"best"))
o=o==null?null:C.f.bW(o)
m.e=o==null?p:o
return m},
azA(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dn(C.j.j(d),3,"0")+C.c.dn(C.j.j(e),3,"0")+".mp3"},
F4:function F4(d,e){this.a=d
this.b=e},
rr:function rr(d,e,f){this.a=d
this.b=e
this.c=f},
aj1:function aj1(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b58:function b58(){},
b59:function b59(){},
b56:function b56(){},
Vn:function Vn(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cw7(){return new B.wR(null)},
cI2(d,e){var x,w,v,u,t={},s=I.cN[e-1].a[1],r=$.MH().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.rg():v).a===D.fg}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d1(u+4,1,s)
return A.e8(C.cK,new B.c3l(t,s,e),d,!0,null,null,!1,y.l)},
c9q(d){return A.dl(0,0,0,0,0,C.j.d1(C.f.aj(6+d*1.2),25,90))},
c8l(d){return E.bp(C.j.aH(d,60))+":"+C.c.dn(E.bp(C.j.a2(d,60)),2,"\u0660")},
clK(d){return A.e8(C.cK,new B.c49($.MH()),d,!0,null,null,!1,y.H)},
MA(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl2()
break A}return x},
cJn(d,e,f){var x,w=new B.c4p(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
clT(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.ap.fb(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.fx:r
q=s.a(J.av(x,"last"))
v=q==null?C.fx:q
u=new B.c4o()
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
Hg:function Hg(d,e){this.a=d
this.b=e},
Vo:function Vo(d,e,f,g,h){var _=this
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
b5a:function b5a(d){this.a=d},
b5b:function b5b(d){this.a=d},
b5c:function b5c(d){this.a=d},
wR:function wR(d){this.a=d},
a_Q:function a_Q(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bIP:function bIP(d){this.a=d},
bIO:function bIO(d,e){this.a=d
this.b=e},
bIQ:function bIQ(d){this.a=d},
bIN:function bIN(d,e){this.a=d
this.b=e},
bIR:function bIR(){},
bIB:function bIB(){},
bIH:function bIH(d,e,f){this.a=d
this.b=e
this.c=f},
bII:function bII(){},
bIL:function bIL(d){this.a=d},
bIK:function bIK(){},
bIM:function bIM(d){this.a=d},
bIE:function bIE(d,e){this.a=d
this.b=e},
bIF:function bIF(d){this.a=d},
bID:function bID(){},
bIG:function bIG(d){this.a=d},
bIC:function bIC(d){this.a=d},
bIJ:function bIJ(d,e){this.a=d
this.b=e},
Hh:function Hh(d,e,f){this.c=d
this.d=e
this.a=f},
XG:function XG(d,e){this.c=d
this.a=e},
c3l:function c3l(d,e,f){this.a=d
this.b=e
this.c=f},
c3i:function c3i(d,e,f){this.a=d
this.b=e
this.c=f},
c3k:function c3k(d,e){this.a=d
this.b=e},
c3h:function c3h(d,e){this.a=d
this.b=e},
c3g:function c3g(d,e){this.a=d
this.b=e},
c3j:function c3j(d,e){this.a=d
this.b=e},
c3c:function c3c(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c3b:function c3b(d,e,f){this.a=d
this.b=e
this.c=f},
c3d:function c3d(d){this.a=d},
c3e:function c3e(d){this.a=d},
c3f:function c3f(d,e){this.a=d
this.b=e},
E3:function E3(d,e){this.a=d
this.b=e},
D3:function D3(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2h:function a2h(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bW6:function bW6(){},
bWm:function bWm(d,e){this.a=d
this.b=e},
bWq:function bWq(d){this.a=d},
bWr:function bWr(d){this.a=d},
bWs:function bWs(d,e,f){this.a=d
this.b=e
this.c=f},
bWu:function bWu(d){this.a=d},
bWv:function bWv(d){this.a=d},
bWt:function bWt(){},
bWx:function bWx(d){this.a=d},
bWw:function bWw(d){this.a=d},
bWy:function bWy(d,e){this.a=d
this.b=e},
bWA:function bWA(d){this.a=d},
bWB:function bWB(d){this.a=d},
bWz:function bWz(){},
bWl:function bWl(d,e,f){this.a=d
this.b=e
this.c=f},
bWn:function bWn(d,e,f){this.a=d
this.b=e
this.c=f},
bWe:function bWe(d){this.a=d},
bWf:function bWf(d){this.a=d},
bWd:function bWd(){},
bWg:function bWg(){},
bWh:function bWh(d,e){this.a=d
this.b=e},
bWG:function bWG(d){this.a=d},
bWH:function bWH(d){this.a=d},
bWI:function bWI(d,e){this.a=d
this.b=e},
bWF:function bWF(d){this.a=d},
bWJ:function bWJ(d,e){this.a=d
this.b=e},
bWk:function bWk(){},
bWj:function bWj(d){this.a=d},
bWi:function bWi(d,e){this.a=d
this.b=e},
bWp:function bWp(d){this.a=d},
bWo:function bWo(d){this.a=d},
bWC:function bWC(){},
bWD:function bWD(){},
bWE:function bWE(){},
bW7:function bW7(d,e,f){this.a=d
this.b=e
this.c=f},
bW8:function bW8(d){this.a=d},
bWa:function bWa(){},
bW9:function bW9(){},
bWb:function bWb(d){this.a=d},
bWc:function bWc(d){this.a=d},
Dm:function Dm(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
D2:function D2(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2g:function a2g(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bVQ:function bVQ(){},
bVZ:function bVZ(d,e){this.a=d
this.b=e},
bW_:function bW_(d){this.a=d},
bVY:function bVY(){},
bW1:function bW1(d){this.a=d},
bW0:function bW0(d,e){this.a=d
this.b=e},
bW2:function bW2(d,e){this.a=d
this.b=e},
bVU:function bVU(d,e){this.a=d
this.b=e},
bVV:function bVV(d,e,f){this.a=d
this.b=e
this.c=f},
bVW:function bVW(d,e,f){this.a=d
this.b=e
this.c=f},
bVR:function bVR(d,e,f){this.a=d
this.b=e
this.c=f},
bVS:function bVS(d,e,f){this.a=d
this.b=e
this.c=f},
bVT:function bVT(d,e){this.a=d
this.b=e},
bVX:function bVX(d){this.a=d},
bW3:function bW3(){},
bW4:function bW4(d,e){this.a=d
this.b=e},
bW5:function bW5(d,e){this.a=d
this.b=e},
D1:function D1(d){this.a=d},
a2f:function a2f(d){this.d=d
this.c=this.a=null},
bVH:function bVH(){},
bVO:function bVO(d){this.a=d},
bVP:function bVP(){},
bVN:function bVN(d,e){this.a=d
this.b=e},
bVM:function bVM(d,e,f){this.a=d
this.b=e
this.c=f},
bVL:function bVL(d,e,f){this.a=d
this.b=e
this.c=f},
bVK:function bVK(d){this.a=d},
bVI:function bVI(d){this.a=d},
bVJ:function bVJ(d){this.a=d},
c49:function c49(d){this.a=d},
c48:function c48(d){this.a=d},
c43:function c43(d,e){this.a=d
this.b=e},
c45:function c45(){},
c44:function c44(){},
c46:function c46(d,e){this.a=d
this.b=e},
c47:function c47(d,e){this.a=d
this.b=e},
aj_:function aj_(d){this.a=d},
b4U:function b4U(d){this.a=d},
c4p:function c4p(){},
c4q:function c4q(){},
D4:function D4(d,e,f){this.c=d
this.d=e
this.a=f},
a2i:function a2i(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bWK:function bWK(d){this.a=d},
bWL:function bWL(d){this.a=d},
bWM:function bWM(d,e){this.a=d
this.b=e},
bWN:function bWN(d){this.a=d},
bWP:function bWP(d){this.a=d},
bWO:function bWO(d){this.a=d},
c4o:function c4o(){}},D,O,P,I,E,F
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
B.aj0.prototype={
r9(){var x=this,w=x.a
if(w!=null)return A.eh(w,y.m)
w=x.b
return w==null?x.b=new B.b4V(x).$0():w},
un(d,e){return this.aN2(d,e,e)},
aN2(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
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
r=B.cyB(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$un,w)},
or(d,e){var x=A.ef(d[e])
if(x==null)x=null
return x===!0},
ML(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$ML=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.r9(),$async$ML)
case 7:r=h.d1(g.cT(e,"support",null,null,null,null))
q=s.or(r,"worker")
p=s.or(r,"wasm")
o=s.or(r,"mic")
n=s.or(r,"audio")
s.or(r,"webgpu")
m=s.or(r,"secure")
s.or(r,"ios")
l=A.jP(r.memory)
if(l==null)l=null
if(l==null)l=0
s.or(r,"isolated")
k=A.jP(r.cores)
if(k!=null)C.f.aj(k)
v=new B.Vp(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a3n
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$ML,w)},
Eo(){var x=0,w=A.j(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Eo=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.r9(),$async$Eo)
case 8:x=7
return A.c(m.eD(l.d1(k.cT(e,"storage",null,null,null,null)),y.A),$async$Eo)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.aj(A.dN(r.quota))
p=C.f.aj(A.dN(r.usage))
v=new A.at5(q,p)
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
return A.i($async$Eo,w)},
biY(){var x=y.K
A.Px(this.r9().bG(new B.b4Y(),x),x)},
r8(d,e){var x=A.jP(d[e])
x=x==null?null:C.f.aj(x)
return x==null?0:x},
bgk(d,e,f){return this.un(new B.b4X(this,d,e,f),y.C)},
gakn(){var x,w
try{x=A.kj(b.G.sessionStorage)
return x}catch(w){return null}},
garR(){var x=A.ef(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a8V(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.ef(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.garR())return!1
l=A.ef(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.d1(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.a_(x.userAgent)
l=A.jP(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.u(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aB("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.l(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aB("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.jP(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.gakn()
l=l==null?f:A.u(A.cT(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dS(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.kj(m.localStorage)
m=o
m=m==null?f:A.u(A.cT(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dS(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
aqo(){var x,w,v,u,t,s,r=null
try{x=this.gakn()
if(x!=null)A.cT(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.d1(x.location)
u=A.a_(v.hash)
t=A.a_(v.search)
s=A.bz(A.a_(A.d1(x.document).baseURI),0,r).a1("tutor/").j(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cT(v,"replace",s+t+x,r,r,r)},
bg3(){var x,w=null,v=b.G,u=A.d1(v.history),t=A.jP(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cT(u,"back",w,w,w,w)
else{x=A.a_(A.d1(v.document).baseURI)
A.cT(A.d1(v.location),"replace",A.bz(x,0,w).a1("./").j(0)+"#/",w,w,w)}},
a96(d,e,f,g,h){return this.un(new B.b51(this,e,d,f,h,g),y.H)},
a99(){return this.un(new B.b52(this),y.D)},
a3h(){var x=null,w=this.a
if(w!=null)A.cT(w,"cancelRecording",x,x,x,x)},
alL(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.r8(d,"ms")
w=A.jP(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.JF(u,x,w,v.r8(d,"frames"),v.r8(d,"tokens"),v.or(d,"retried"),v.r8(d,"encMs"),v.r8(d,"decMs"),v.r8(d,"featMs"))},
aia(d){var x={}
x.words=d
return x},
auT(d,e){return this.un(new B.b54(this,d,e),y._)},
bla(d,e){return this.un(new B.b53(this,d,e),y._)},
KN(d,e){return this.bj3(d,e)},
bj3(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$KN=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.r9(),$async$KN)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.al(d).i("au<1,o>")
o=A.aa(new A.au(d,new B.b4Z(),o),o.i("aY.E"))
x=11
return A.c(A.eD(A.d1(A.cT(r,"play",o,e,null,null)),y.y),$async$KN)
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
return A.i($async$KN,w)},
Ms(){var x=null,w=this.a
if(w!=null)A.cT(w,"stopPlayback",x,x,x,x)},
Jf(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.a_(A.cT(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bkj(){var x,w,v=null
try{x=this.a
if(x!=null)A.cT(x,"resetDevice",v,v,v,v)}catch(w){}},
a6y(d){var x=this.a
if(x!=null)A.cT(x,"prefetch",d,null,null,null)}}
B.Vp.prototype={}
B.JD.prototype={
gn3(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.JF.prototype={
gSN(){var x=this,w=C.f.aw(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.JE.prototype={}
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
j(d){return"TutorError("+this.a+": "+this.b+")"},
$ibP:1}
B.nz.prototype={
R(){return"WordStatus."+this.b}}
B.Sw.prototype={}
B.mU.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Ig.prototype={
gMq(){var x,w=this,v=w.d
if(v===$){x=new B.aWa(w).$0()
w.d!==$&&A.ao()
w.d=x
v=x}return v},
gJy(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a3O&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbhb(){return J.h6(this.gMq(),new B.aW9()).gM(0)},
gtr(){var x=this.a
return x.length!==0&&this.gbhb()===x.length&&this.gJy().length===0}}
B.F4.prototype={
R(){return"AyahStatus."+this.b}}
B.rr.prototype={}
B.aj1.prototype={
a69(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.rg():x},
aZH(d){var x=this,w=B.b57(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cgP(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
apA(){var x=Date.now(),w=B.b57(new A.aQ(x,0,!1))
x=this.c
return x===w||x===B.cgP(w)?this.d:0},
atW(d,e,f,g){var x=this,w=new A.aQ(Date.now(),0,!1),v=x.a69(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.fg:D.p6,s=new B.rr(t,u,w.hd()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.aZH(w)
return s},
a60(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cN[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rg():s).a===D.fg)++u}return u},
bg1(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cN[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rg():s).a===D.p6)++u}return u},
gasZ(){var x=this.a,w=A.y(x).i("ce<2>")
return new A.ak(new A.ce(x,w),new B.b58(),w.i("ak<Z.E>")).gM(0)},
gayx(){var x=this.a,w=A.y(x).i("bJ<1>")
w=A.mp(new A.bJ(x,w),new B.b59(),w.i("Z.E"),y.S)
w=A.eP(w,A.y(w).i("Z.E"))
x=A.aa(w,A.y(w).c)
C.b.mt(x)
return x},
dw(){var x,w,v,u,t,s=this,r=y.N,q=A.B(r,y.L)
for(x=s.a,x=new A.eH(x,A.y(x).i("eH<1,2>")).ga0(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.aa(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
bbX(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b3t(x,300,A.y(x).c),x=new A.Jk(J.aD(x.a),x.b,A.y(x).i("Jk<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gJ()
s=C.j.aH(t,1000)
t=C.j.a2(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.rg():q).a===D.fg?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.rg()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.rg():r).c.j7()],w,v))}return o},
bgC(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.L)(d),++u){t=d[u]
s=A.eB(t.h(0,"surah"))*1000+A.eB(t.h(0,"ayah"))
r=w.h(0,C.j.aH(s,1000)*1000+C.j.a2(s,1000))
if((r==null?$.rg():r).c.j7()===t.h(0,"updated_at"))v.K(0,s)}},
bgK(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aD(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gJ()
if(!u.b(s))continue
r=A.aG(s.h(0,"surah"))
q=r==null?null:C.f.bW(r)
r=A.aG(s.h(0,"ayah"))
p=r==null?null:C.f.bW(r)
o=A.dW(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cN[q-1].a[1])
if(r)continue
n=B.cEd(s.h(0,"status"))
if(n===D.p5)continue
r=q*1000+p
m=v.h(0,r)
if(m!=null){l=m.c
k=o.a
j=l.a
if(k<=j)l=k===j&&o.b>l.b
else l=!0
l=!l}else l=!1
if(l)continue
l=A.aG(s.h(0,"perfect_count"))
l=l==null?null:C.f.bW(l)
v.p(0,r,new B.rr(n,C.j.d1(l==null?0:l,0,100),o.hd()))
w.K(0,r)
t=!0}return t}}
B.Vn.prototype={
IZ(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Vn(w,v,u,t,f==null?x.e:f)},
bab(d){var x=null
return this.IZ(x,x,d,x,x)},
ap5(d){var x=null
return this.IZ(x,d,x,x,x)},
baf(d){var x=null
return this.IZ(x,x,x,x,d)},
b9y(d){var x=null
return this.IZ(d,x,x,x,x)},
bac(d){var x=null
return this.IZ(x,x,x,d,x)},
dw(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Hg.prototype={
R(){return"ModelState."+this.b}}
B.Vo.prototype={
vC(){var x=this.Q
return x==null?this.Q=new B.b5a(this).$0():x},
qK(d){return this.awL(d)},
awL(d){var x=0,w=A.j(y.H),v=this
var $async$qK=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a3()
x=2
return A.c(A.ih("mt.tutor.settings",C.ap.i8(d.dw(),null)),$async$qK)
case 2:return A.h(null,w)}})
return A.i($async$qK,w)},
zJ(){var x=0,w=A.j(y.H),v=this,u
var $async$zJ=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a3()
x=2
return A.c(A.ih("mt.tutor.progress",C.ap.i8(v.c.dw(),null)),$async$zJ)
case 2:u=v.as
if(u!=null)u.aA()
v.as=A.cO(C.x,v.gaDz())
return A.h(null,w)}})
return A.i($async$zJ,w)},
Ma(d,e,f){return this.axx(d,e,f)},
axx(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$Ma=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.b_(d,e,f)
x=2
return A.c(A.ih("mt.tutor.last",C.ap.i8(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Ma)
case 2:return A.h(null,w)}})
return A.i($async$Ma,w)},
D8(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$D8=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.UL||n===D.jS){x=1
break}s.f=D.UL
s.y=null
s.a3()
u=4
n=A.lF().geQ().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lF().geQ().h(0,"tutor_threads")
p=A.dS(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bgk(new B.b5b(s),n,p),$async$D8)
case 7:s.x=e
s.f=D.jS
n=A.lF().geQ().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.rc().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a8(m)
if(n instanceof B.lE){q=n
s.f=D.aRZ
s.y=q
n=A.lF().geQ().h(0,"debug")
if(n==="1")A.rc().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a3()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$D8,w)},
wz(){var x=0,w=A.j(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wz=A.e(function(a0,a1){if(a0===1){t.push(a1)
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
return A.c(p.aS("quran_tutor_progress").da("surah, ayah, status, perfect_count, updated_at"),$async$wz)
case 7:o=a1
n=r.c.bgK(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bbX()
if(J.aP(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.n1(h.x,k,k))
x=11
return A.c(f.bkH("quran_tutor_save",!1,g,i),$async$wz)
case 11:r.c.bgC(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.ih("mt.tutor.progress",C.ap.i8(r.c.dw(),null)),$async$wz)
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
L3(d){return this.bkl(d)},
bkl(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$L3=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c7E(t.c.dw()).dw()
y.f.a(p.h(0,"rows")).eh(0,new B.b5c(d))
t.c=B.c7E(p)
x=2
return A.c(t.zJ(),$async$L3)
case 2:v=4
s=$.C().b
s===$&&A.b()
r=s.ga4().e.a
x=(r==null?null:r.r)!=null?7:8
break
case 7:r=y.z
x=9
return A.c(s.az("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$L3)
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
return A.i($async$L3,w)}}
B.wR.prototype={
P(){var x=$.MH()
return new B.a_Q(x,new A.ah(C.N,$.W()))}}
B.a_Q.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goD())
w=y.a
x.vC().bG(new B.bIP(v),w)
H.aUD().bG(new B.bIQ(v),w).fw(new B.bIR())
A.Px(H.c7_(),y.y)},
xJ(){if(this.c!=null)this.k(new B.bIB())},
m(){var x,w=this
w.d.T(w.goD())
x=w.e
x.q$=$.W()
x.L$=0
w.a_()},
PQ(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$PQ=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qK(s.b.bab(!0)),$async$PQ)
case 3:t=s.a
t.biY()
if(t.a8V()){t.aqo()
x=1
break}s.D8()
case 1:return A.h(v,w)}})
return A.i($async$PQ,w)},
xK(d,e,f){return this.aXA(d,e,f)},
b5i(d){return this.xK(d,null,null)},
aXA(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$xK=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.Z(A.aN(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.x,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.U(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cI2(s,d),$async$xK)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Ma(d,t.a,t.b),$async$xK)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aB(A.ax(new B.bIH(u,d,t),null,r),r),$async$xK)
case 8:if(u.c!=null)u.k(new B.bII())
case 1:return A.h(v,w)}})
return A.i($async$xK,w)},
u(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.garR()&&!A.O(d,!1).v6())u.push(A.bQ(x,x,x,x,C.yf,x,x,t.gbg2(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bQ(x,x,x,x,D.atq,x,x,new B.bIL(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bQ(x,x,x,x,C.ix,x,x,new B.bIM(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aFZ
else w=t?this.aSr():this.aT2()
return L.xB(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aT2(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a3n
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b5K,C.a1],x)
for(t=0;t<4;++t){s=D.aI4[t]
u.push(new A.F(C.bs,A.A(A.a([A.b0(s.a,C.am,p,18),C.K,new A.bU(1,C.ac,A.d(s.b,p,p,p,p,G.a0Z,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bwD,C.J,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bp(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aK,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bp(C.f.aj(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.J,A.d(q,p,p,p,p,A.bK(p,p,r?D.dW:C.cG,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.J,D.bvF],x))
x=A.a([new E.dy(u,C.a4,C.aN,p,!0,p),new E.dy(A.I(s,C.q,C.d,C.e,0,C.l),C.a4,C.aN,p,!1,p),D.bEM,C.J],x)
if(v!=null)x.push(new E.dy(A.d(v,p,p,p,p,D.bgG,p,p,p),C.a4,C.aN,p,!1,p))
else x.push(A.fn(D.aqj,D.bms,this.gaXS(),A.ey(C.v,C.ad,D.b8K,p,p,p,p)))
x.push(C.a5)
x.push(D.a3j)
return x},
aSr(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.O(r.a.a),p=q.length===0,o=p?C.rm:H.clD(q),n=t.z,m=A.R(v.al2(C.dw,E.bp(s.gasZ())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bp(s.apA()),k=s.c,j=Date.now()
k=k===B.b57(new A.aQ(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Hh(t,!1,u),A.A(A.a([m,C.K,A.R(v.al2(C.l4,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.t],j)
if(n!=null){t=H.kl(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bp(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bp(m)+"\u2013"+E.bp(l)
k.push(new E.dy(A.A(A.a([D.asx,C.Y,A.R(A.I(A.a([D.biD,A.d(t+" \u2014 "+m,u,u,u,u,C.bt,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.ny],j),C.h,C.d,C.e,0,u,u),C.a4,C.aN,new B.bIE(v,n),!0,u))}t=C.i.ad(0.08)
k.push(A.aJ(u,C.y,!1,u,!0,C.m,u,A.aM(),r,u,u,u,u,u,2,A.cG(u,new A.ci(4,A.v(14),C.L),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.u7,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qI,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bIF(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.cR,!0,C.u,u,C.E,u,u,u,u))
k.push(C.t)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.brO)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.R6(o[x]))
C.b.A(k,t)}else{t=A.a([D.aVb,D.aVR,v.R6(1)],j)
for(w=114;w>=78;--w)t.push(v.R6(w))
t.push(C.J)
r=v.f
p=A.b0(r?C.xY:C.l3,C.am,u,u)
t.push(A.fT(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.f9,u,u,u),new B.bIG(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.R6(w))
C.b.A(k,t)}k.push(C.a1)
k.push(D.BY)
return k},
al2(d,e,f){var x=null,w=y.p
return new E.dy(A.A(A.a([A.b0(d,C.v,x,x),C.K,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bt,x,x,x),A.d(f,1,C.O,x,x,C.a1D,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a4,C.I,x,!1,x)},
R6(d){var x,w=null,v=this.d.c,u=I.cN[d-1].a[1],t=v.a60(d),s=t/u,r=y.p,q=A.aq(A.dz(C.P,A.a([A.c5q(C.eR,G.cL,w,w,w,w,w,3,s,w),A.d(E.bp(d),w,w,w,w,Q.a1Z,w,w,w)],r),C.m,C.bj,w),36,36),p=A.d(H.kl(d),w,w,w,w,D.bbx,w,w,w)
if(t===0)x=E.bp(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bp(t)+" \u0645\u0646 "+E.bp(u)
r=A.a([q,C.cD,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bK(w,w,t===u?G.cL:C.cG,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bp(C.f.aj(s*100))+"\u066a",w,w,w,w,D.a1u,w,w,w))
r.push(D.aqs)
return new E.dy(A.A(r,C.h,C.d,C.e,0,w,w),C.q0,C.cY,new B.bIJ(this,d),!1,w)}}
B.Hh.prototype={
u(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b1
return D.aUX
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.MA(x),r,r,r,r,D.B7,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.D4(w,"model load",r))
x.push(C.J)
x.push(new A.zO(C.a48,!1,q.gbgj(),r,r,r,r,C.k,r,!1,r,!0,r,C.ul,r))
return new E.dy(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aN,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bp(C.f.aj(u/1e6))+" \u0645\u0646 "+E.bp(C.f.aj(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.oD,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.fd(x,A.q6(C.eR,C.v,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.J,D.bnh],w))
return new E.dy(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aN,r,!1,r)}}}
B.XG.prototype={
u(d){var x=null,w=D.dW.ad(0.1),v=A.v(14),u=A.aH(D.dW.ad(0.4),1)
return A.D(x,A.A(A.a([D.asb,C.K,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.Bd,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.G(w,x,u,v,x,x,x,C.n),x,x,C.aN,C.ae,x,x,x)}}
B.E3.prototype={
R(){return"_Phase."+this.b}}
B.D3.prototype={
P(){return new B.a2h($.MH(),D.mi)}}
B.a2h.prototype={
gjc(){var x=this.e
return x===$?this.e=this.a.d:x},
gBH(){var x,w=this.a,v=w.f
w=w.c
x=this.gjc()
return H.My(w,x,v.xU(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.ac(w.goD())
x.vC()
x.a.a6y(B.azA(w.a.c,w.gjc()))},
xJ(){if(this.c!=null)this.k(new B.bW6())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.Q
if(x!=null)x.aA()
v=v.a
v.Ms()
v.a3h()
w.a_()},
ZX(d){var x,w,v=this
if(v.f===D.uU)v.d.a.a3h()
x=v.d.a
x.Ms()
w=v.Q
if(w!=null)w.aA()
v.k(new B.bWm(v,d))
x.a6y(B.azA(v.a.c,d))
w=v.a
if(d<w.e)x.a6y(B.azA(w.c,d+1))},
Ro(d){return this.aTU(d)},
aTU(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$Ro=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.uT){u.d.a.Ms()
u.k(new B.bWq(u))
x=1
break}t=u.r!=null?D.j9:D.mi
u.k(new B.bWr(u))
s=u.d
r=A.a([B.azA(u.a.c,u.gjc())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.KN(r,q),$async$Ro)
case 3:p=f
if(u.c==null||u.f!==D.uT){x=1
break}u.k(new B.bWs(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$Ro,w)},
Qe(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Qe=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jS){x=1
break}p=l.a
p.Ms()
r=B.EM(s.gBH()).length
s.k(new B.bWu(s))
o=s.Q
if(o!=null)o.aA()
s.Q=A.hD(C.eV,new B.bWv(s))
u=4
o=B.c9q(r)
n=A.dl(0,0,0,350*r,0,0)
x=7
return A.c(p.a96(l.b.c,o,n,new B.bWw(s),new B.bWx(s)),$async$Qe)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lE){q=l
l=s.Q
if(l!=null)l.aA()
if(s.c!=null)s.k(new B.bWy(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Qe,w)},
BA(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$BA=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.uU){x=1
break}m=s.Q
if(m!=null)m.aA()
s.k(new B.bWA(s))
s.Q=A.hD(C.ir,new B.bWB(s))
l=new A.Cw()
$.EP()
l.om()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a99(),$async$BA)
case 7:q=e
if(q.b<0.8){s.b5h("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.auT(q,B.EM(s.gBH()).length),$async$BA)
case 8:p=e
s.ch=A.dl(0,0,r.ga4B(),0,0,0)
k=A.lF().geQ().h(0,"debug")
if(k==="1"){o=B.clT(m.Jf())
A.rc().$1("[tutor] "+s.a.c+":"+s.gjc()+" audio="+C.f.aw(q.b,1)+"s infer="+p.b+"ms total="+r.gCu()+"ms "+p.gSN()+" text="+p.a)
A.rc().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.aw(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aw(p.b/1000,2)+" \u062b\n"+p.gSN()+"\n"+A.n(o)+"\n"+p.a}s.afg(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lE){n=m
m=A.lF().geQ().h(0,"debug")
if(m==="1")A.rc().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.Jf())
s.a26(B.MA(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$BA,w)},
a26(d,e){var x=this,w=x.Q
if(w!=null)w.aA()
if(x.c==null)return
x.k(new B.bWl(x,d,e))},
b5h(d){return this.a26(d,null)},
afg(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aA()
if(s.c==null)return
x=B.cjV(s.gBH(),d)
r.a=null
if(C.c.O(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjc()
t=x.gtr()
r.a=w.atW(v,u,q.b.a,t)
q.zJ()}s.k(new B.bWn(r,s,x))},
NQ(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$NQ=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jS){x=1
break}s.k(new B.bWe(s))
l=s.Q
if(l!=null)l.aA()
s.Q=A.hD(C.ir,new B.bWf(s))
k=new A.Cw()
$.EP()
k.om()
r=k
u=4
l=g.a
x=7
return A.c(l.bla(B.azA(s.a.c,s.gjc()),B.EM(s.gBH()).length),$async$NQ)
case 7:q=e
p=B.clT(l.Jf())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.aw(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.aw(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.aw(r.gCu()/1000,2)+" \u062b)\n"+q.gSN()+"\n"+A.n(p)+"\n"+q.a
A.rc().$1("[tutor-debug] "+s.a.c+":"+s.gjc()+" audio="+C.f.aw(q.c,1)+"s infer="+q.b+"ms total="+r.gCu()+"ms "+q.gSN()+" text="+q.a)
A.rc().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dl(0,0,r.ga4B(),0,0,0)
s.afg(q.a)
n=s.r
if(n!=null){l=n.gtr()
j=n.b
i=A.al(j).i("ak<1>")
j=A.aa(new A.ak(j,new B.bWg(),i),i.i("Z.E"))
A.rc().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.k(new B.bWh(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lE){m=l
A.rc().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.Jf())
s.a26(B.MA(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$NQ,w)},
ga0T(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.rg():v).a!==D.fg)return!1}return!0},
u(d){var x,w=this,v=null,u=w.d,t=u.c.a69(w.a.c,w.gjc()),s=u.b,r=s.d&&!w.x&&w.f!==D.j9,q=H.kl(w.a.c),p=y.p,o=A.a([A.bQ(v,v,v,v,C.ix,v,v,new B.bWG(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aKi(),m=A.d("\u0622\u064a\u0629 "+E.bp(w.gjc()),v,v,v,v,C.m_,v,v,v),l=E.bp(w.gjc()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.aZ,A.d("("+l+" \u0645\u0646 "+E.bp(k.e-k.d+1)+")",v,v,v,v,F.aK,v,v,v),C.bA,w.aYx(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.t],p)
if(r)s.push(w.aSm())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.uU&&l!==D.oX}else l=!1
if(l)s.push(w.aHZ(m))
else s.push(A.d(w.gBH()+" \ufd3f"+E.bp(w.gjc())+"\ufd3e",v,v,v,v,D.kf,C.Z,C.bi,v))}s=A.a([new B.Hh(u,!0,v),n,C.B,new E.dy(A.I(s,C.ag,C.d,C.e,0,C.l),D.aja,C.aN,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.j9)s.push(w.b6M(n))
if(w.r!=null&&w.f===D.j9&&w.ch!=null){x=C.f.aj(C.j.aH(w.ch.a,1000)/100)
s.push(new A.F(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bp(C.j.aH(x,10))+"\u066b"+E.bp(C.j.a2(x,10)))+" \u062b",v,v,v,v,F.aK,C.Z,v,v),v))}n=w.as
if(n!=null)s.push(new A.F(C.aN,A.d(n,v,v,v,v,D.B7,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.D4(n,"check "+w.a.c+":"+w.gjc(),v))}s.push(w.aIw())
s.push(C.a1)
s.push(A.ir(C.v,C.I,v,new B.bWH(w),D.bkj,D.bpz,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga0T()
s.push(new E.dy(A.A(A.a([D.aoW,C.Y,A.R(A.I(A.a([D.brc,A.d(w.ga0T()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aK,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.ny],p),C.h,C.d,C.e,0,v,v),C.a4,C.aN,new B.bWI(w,d),n,v))}n=A.lF().geQ().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dx(D.aqi,D.boZ,u.f===D.jS&&w.f!==D.oX?w.gaJf():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.F(C.is,A.xc(n,F.aK,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn3()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aK,v,v,v))}p.push(A.bh(D.bqm,v,v,v,new B.bWJ(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.BY)
return L.xB(o,s,q)},
aKi(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b1
return A.aq(A.fB(new B.bWj(this),w,null,C.af,new B.bWk()),36,null)},
aYx(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fg)return D.b5W
x=d.b
w=E.bp(x)
v=E.bp(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.bV:C.Hf
u.push(new A.F(D.ajR,A.b0(r,s?G.cL:C.eS,q,16),q))}return A.aiV(A.A(u,C.h,C.d,C.M,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aSm(){var x=null
return A.bw(!1,A.v(12),!0,A.D(x,D.afg,C.k,x,x,new A.G(C.px,x,x,A.v(12),x,x,x,C.n),x,x,x,D.aiJ,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bWp(this),x,x,x,x,x,x,x)},
aHZ(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gMq(),w)
A:{if(D.j2===v){u=D.kf.ct(G.cL)
break A}if(D.uC===v){u=D.kf.a3V(D.dW,C.hl,D.dW)
break A}if(D.uD===v){u=D.kf.a3V(D.eQ,C.hl,D.eQ)
break A}u=D.kf.a3V(C.eS,C.kb,C.cb)
break A}t=x[w]
r.push(new A.f4(t.a,s,s,C.by,s,s,s,s,s,s,u))
r.push(P.B_)}x=E.bp(this.gjc())
r.push(A.eq(s,s,s,s,s,s,s,s,s,D.kf.ct(C.am),"\ufd3f"+x+"\ufd3e"))
return A.Jl(A.eq(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Z,C.bi)},
b6M(d){var x,w,v,u,t,s,r=this.w
if(C.c.O(d.c).length===0)return D.bE8
if(d.gtr()){x=r==null
if((x?null:r.a)===D.fg&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fg?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bp(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.Dm(G.cL,C.bV,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMq()
w=J.dA(x)
v=w.iE(x,new B.bWC()).gM(0)
u=w.iE(x,new B.bWD()).gM(0)
t=w.iE(x,new B.bWE()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bp(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bp(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bp(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJy().length!==0)x.push(E.bp(d.gJy().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eQ:D.dW
x=C.b.aE(x," \u2022 ")
s=d.gJy().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aE(d.gJy(),"\u060c "):""
return new B.Dm(w,C.no,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aIw(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jS,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aH(new A.aQ(f,0,!1).dG(w).a,1e6)}v=C.j.aH(B.c9q(B.EM(j.gBH()).length).a,1e6)
f=j.gb3S()
w=96+26*j.y
u=D.eQ.ad(0.25)
w=A.iN(i,A.a55(C.P,A.D(i,D.aqv,C.k,i,i,D.a7a,i,84,i,i,i,i,84),i,C.aU,new A.G(u,i,i,i,i,i,i,C.c_),C.EU,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cO)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c8l(x)+" / "+B.c8l(v),i,i,i,i,K.oC,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aK,i,i,i),A.bh(D.bvE,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.ey((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bp(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bp(t)+" \u062b)"
return new A.F(C.pY,A.I(A.a([C.vH,C.a1,D.bnK,A.d(h,i,i,i,i,F.aK,C.Z,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.uT
r=j.r
f=r==null
w=!f
q=w&&r.gtr()
u=A.b0(s?C.np:K.Ht,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.ey(i,i,D.b8H,i,i,i,i)
u=A.R(new A.zO(C.a48,!0,new B.bW7(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Yh(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.J4[n]
p.push(new A.el(m,i,A.d("\xd7"+E.bp(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.K,A.oP(new B.bW8(j),p,A.da([h.b.b],o),!1,A.kp(i,i,i,new A.bd(new B.bW9(),l),i,i,i,i,new A.bd(new B.bWa(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cJ),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb_x():i
u=A.b0(f?D.qw:C.no,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cE,i,i,i)
p=q?C.im:C.v
h=A.a([o,C.t,A.fn(u,f,h,A.ey(p,q?C.i:C.ad,D.tJ,i,i,i,i))],k)
if(w&&j.gjc()<j.a.e)C.b.A(h,A.a([C.B,q?A.fn(D.atP,D.bup,new B.bWb(j),A.ey(G.cL,C.ad,D.tJ,i,i,i,i)):A.bh(D.bkJ,i,i,i,new B.bWc(j),i,i)],k))
if(w){f=j.gjc()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.F(C.jt,A.d(j.ga0T()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,K.uf,C.Z,i,i),i))
return A.I(h,C.ag,C.d,C.e,0,C.l)}}}
B.Dm.prototype={
u(d){var x=this,w=null,v=x.c,u=v.ad(0.12),t=A.v(14),s=A.aH(v.ad(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b0(x.d,v,w,w),C.K,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bK(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.V,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bN,A.d(x.f,w,w,w,w,C.Bd,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.G(u,w,s,t,w,w,w,C.n),w,w,C.aN,C.ae,w,w,w)}}
B.D2.prototype={
P(){var x=y.S
return new B.a2g($.MH(),A.B(x,y.B),A.aU(x),A.B(x,y.N),A.eh(null,y.H))}}
B.a2g.prototype={
W(){this.Y()
this.d.ac(this.goD())},
xJ(){if(this.c!=null)this.k(new B.bVQ())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.y
if(x!=null)x.aA()
v.a.a3h()
w.a_()},
I3(d){return this.b3E(d)},
b3E(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$I3=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.k(new B.bVZ(t,d))
r=t.y
if(r!=null)r.aA()
t.y=A.hD(C.eV,new B.bW_(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c9q(B.EM(H.My(q,d,p.xU(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dl(0,0,0,350*B.EM(H.My(p,d,o.xU(p,d)).b).length,0,0)
x=6
return A.c(r.a.a96(r.b.c,q,p,new B.bW0(t,d),new B.bW1(t)),$async$I3)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lE){s=r
r=t.y
if(r!=null)r.aA()
if(t.c!=null)t.k(new B.bW2(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$I3,w)},
Fz(d,e){return this.aLr(d,e)},
aLr(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$Fz=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aA()
s.k(new B.bVU(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a99()
if(e&&n!=null)s.I3(n)
q=null
u=4
x=7
return A.c(r,$async$Fz)
case 7:q=g
u=2
x=6
break
case 4:u=3
l=t.pop()
o=A.a8(l)
if(o instanceof B.lE){p=o
s.k(new B.bVV(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bG(new B.bVW(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Fz,w)},
gaW2(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b0n(){this.k(new B.bVX(this))},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jS,o=s.e,n=s.gaW2(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("ce<2>")
x=new A.ak(new A.ce(m,l),new B.bW3(),l.i("ak<Z.E>")).gM(0)
l=H.kl(s.a.c)
m=y.p
q=A.a([new B.Hh(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bp(s.a.d)+" \u0644\u062d\u062f "+E.bp(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aK,r,r,r),C.t],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b5j(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.B7,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.D4(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bp(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aH(new A.aQ(v,0,!1).dG(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c8l(v),r,r,r,r,K.oC,C.Z,r,r)
j=A.fd(A.v(6),A.q6(C.eR,D.eQ,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b0(u?O.Hm:C.np,r,r,r)
C.b.A(q,A.a([v,C.J,j,C.t,A.fn(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cE,r,r,r),new B.bW4(s,o),A.ey(C.v,C.ad,D.tJ,r,r,r,r))],m))}else if(n!=null){j=p?new B.bW5(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bp(n)
q.push(A.fn(D.arE,A.d(v,r,r,r,r,C.cE,r,r,r),j,A.ey(C.v,C.ad,D.tJ,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aVl)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cL:D.dW
v=k?C.nf:C.no
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bp(x)
u=s.a
u=k+" \u0645\u0646 "+E.bp(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.Dm(j,v,k,u,r),A.dx(D.atB,D.bv2,s.gb0m(),r)],m))}q.push(C.t)
q.push(D.BY)
return L.xB(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b5j(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.ar0
else if(l.r.n(0,d))x=N.tM
else if(i!=null)x=D.arh
else if(j!=null){w=j.gtr()?C.bV:D.anr
x=A.b0(w,j.gtr()?G.cL:D.dW,k,k)}else x=D.apA
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bp(d),k,k,k,k,D.bfT,k,k,k),C.bA,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.a1F,k,k,k))
if(j!=null&&!j.gtr()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMq()
o=J.be(p)
n=o.h(p,r)
A:{if(D.j2===n){m=G.cL
break A}if(D.uC===n){m=D.dW
break A}if(D.uD===n){m=D.eQ
break A}m=C.eS
break A}m=D.kf.baR(m,o.h(p,r)===D.uE?C.kb:k,22)
C.b.A(t,A.a([new A.f4(q.a,k,k,C.by,k,k,k,k,k,k,m),P.B_],u))}w=A.a([C.ai,A.Jl(A.eq(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Z,C.bi)],w)
if(C.c.O(j.c).length===0)w.push(D.bqB)
C.b.A(v,w)}return new E.dy(A.I(v,C.ag,C.d,C.e,0,C.l),C.bK,C.cY,k,!1,k)}}
B.D1.prototype={
P(){return new B.a2f($.MH())}}
B.a2f.prototype={
W(){this.Y()
var x=this.d
x.ac(this.goD())
x.vC()},
xJ(){if(this.c!=null)this.k(new B.bVH())},
m(){this.d.T(this.goD())
this.a_()},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gayx(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kZ(o,0,new B.bVO(q))
v=C.b.kZ(o,0,new B.bVP())
o=y.p
o=A.a([A.A(A.a([A.R(s.XQ(E.bp(q.gasZ()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.K,A.R(s.XQ(E.bp(q.apA()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.K,A.R(s.XQ(E.bp(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.t,new E.dy(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bp(C.f.aj(w*100/v))+"\u066a",r,r,r,r,C.bt,r,r,r),C.J,A.fd(A.v(6),A.q6(C.eR,G.cL,8,w/v,r),C.aC),C.ai,A.d(E.bp(w)+" \u0645\u0646 "+E.bp(v)+" \u0622\u064a\u0629",r,r,r,r,F.aK,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a4,C.aN,r,!1,r)],o)
if(p.length===0)o.push(D.aVz)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b5l(p[t]))
o.push(C.B)
u=$.C().b
u===$&&A.b()
u=u.ga4().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aK,r,r,r))
return L.xB(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
XQ(d,e){var x=null
return new E.dy(A.I(A.a([A.d(d,x,x,x,x,D.bfB,x,x,x),A.d(e,x,x,x,x,C.a2a,C.Z,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a4,C.I,x,!1,x)},
b5l(d){var x=null,w=this.d.c,v=I.cN[d-1].a[1],u=w.a60(d),t=w.bg1(d),s=y.p,r=A.A(A.a([A.R(A.d(H.kl(d),x,x,x,x,C.bt,x,x,x),1),A.d(E.bp(C.f.aj(u*100/v))+"\u066a",x,x,x,x,D.bgH,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.fd(A.v(6),A.q6(C.eR,G.cL,7,u/v,x),C.aC),p=E.bp(u),o=E.bp(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bp(t):""
return new E.dy(A.I(A.a([r,C.J,q,C.ai,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aK,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a4,C.aN,new B.bVN(this,d),!1,x)},
NT(d){return this.aJB(d)},
aJB(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$NT=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cN[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e8(C.cK,new B.bVM(v,d,u),t,!0,null,null,!1,y.H),$async$NT)
case 2:return A.h(null,w)}})
return A.i($async$NT,w)}}
B.aj_.prototype={
Rn(d,e){var x=null,w=A.nr(x,x,x,x,x,x,x,x,x,x,x,D.b8g,C.I,x,x,x,x,C.jR,x,x)
return A.bh(A.d(d,x,x,x,x,C.lZ,x,x,x),x,x,x,new B.b4U(e),x,w)},
u(d){var x=this,w=y.p
return new E.dy(A.I(A.a([D.bub,C.J,D.bvD,A.d5(C.ax,A.a([x.Rn("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Rn("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aF,0,12),D.bjV,x.Rn("tanzil.net","https://tanzil.net"),D.bxd,x.Rn("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a4,C.aN,null,!1,null)}}
B.D4.prototype={
P(){return new B.a2i()}}
B.a2i.prototype={
galR(){var x=this.a
return B.cJn(x.c,x.d,$.ca2().Jf())},
Rp(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$Rp=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.k(new B.bWK(s))
v=3
r=A.c3z()
n=s.galR()
m=y.N
q=A.B(m,m)
J.dZ(q,"app","mogtama3y")
J.dZ(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dZ(q,"ua",m)}x=6
return A.c(A.a9z(n,null,C.FZ,q),$async$Rp)
case 6:if(s.c!=null)s.k(new B.bWL(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cj?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.k(new B.bWM(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.k(new B.bWN(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Rp,w)},
u(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bw(!1,t,!0,new A.F(C.n1,A.A(A.a([A.b0(u.d?C.xY:C.l3,C.cb,t,18),C.bG,D.bwp],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bWP(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.D(t,A.xc(u.galR(),D.bbU,t,C.z),C.k,t,t,new A.G(C.px,t,t,x,t,t,t,C.n),t,t,D.aiM,C.e9,t,t,1/0))}if(u.f)s.push(D.bkc)
else{x=A.nr(t,t,t,t,t,t,t,t,t,t,t,C.a_Z,C.I,t,t,t,t,C.jR,t,t)
w=u.e
v=w?t:u.gb5k()
s.push(A.fT(w?C.a0d:D.asZ,D.bt9,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,D.a1F,t,t,t))
return new A.F(C.aN,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["aj<~>()","~()","N(nz)","aj<JF>()","aj<JD>()","aj<JE>()","a7<nz>()","N(rr)","bE(oG)","D3(t)","D1(t)","N(mU)","D2(t)","N(Ig)"])
B.b4V.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.a_(A.d1(b.G.document).baseURI)
q=A.bz(r,0,null).a1("quran_tutor/tutor.js?v=3").j(0)
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
m=B.cyC("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:241}
B.b4Y.prototype={
$1(d){var x=null
return A.bZl(A.cT(d,"persist",x,x,x,x))},
$S:1111}
B.b4X.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.r9(),$async$$0)
case 4:x=3
return A.c(n.eD(m.d1(l.cT(e,"loadModel",A.c_3(new B.b4W(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.u(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.u(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.r8(p,"ms")
r=q.or(p,"cached")
A.u(p.backend)
v=new B.JD(o,t,s,r,q.r8(p,"threads"),q.or(p,"isolated"),q.r8(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b4W.prototype={
$2(d,e){this.a.$2(C.f.aj(d),C.f.aj(e))},
$S:1112}
B.b51.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.r9(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aH(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aH(v.d.a,1000)
u.onLevel=A.fV(new B.b5_(v.e))
u.onAutoStop=A.fV(new B.b50(v.f))
x=5
return A.c(A.eD(A.d1(A.cT(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b5_.prototype={
$1(d){return this.a.$1(d)},
$S:71}
B.b50.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b52.prototype={
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
return A.c(t.r9(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.eD(p.d1(o.cT(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.JE(r,A.dN(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b54.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.r9(),$async$$0)
case 4:x=3
return A.c(q.eD(p.d1(o.cT(e,"transcribe",t.audio,t.rate,s.aia(u.c),null)),y.m),$async$$0)
case 3:v=r.alL(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b53.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.r9(),$async$$0)
case 4:x=3
return A.c(r.eD(q.d1(p.cT(e,"transcribeUrl",u.b,t.aia(u.c),null,null)),y.m),$async$$0)
case 3:v=s.alL(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b4Z.prototype={
$1(d){return d},
$S:38}
B.aWa.prototype={
$0(){var x,w,v,u,t=this.a,s=A.cm(t.a.length,D.uE,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aW9.prototype={
$1(d){return d===D.j2},
$S:z+2}
B.bZN.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c4v(e[x],d[x])<0.75)return!1
return!0},
$S:1113}
B.c0T.prototype={
$1(d){return d.length!==0},
$S:11}
B.b58.prototype={
$1(d){return d.a===D.fg},
$S:z+7}
B.b59.prototype={
$1(d){return C.j.aH(d,1000)},
$S:58}
B.b56.prototype={
$1(d){return C.f.bW(d)},
$S:1114}
B.b5a.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iA("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.ap.fb(r,null))
j=A.aG(k.h(0,"n"))
j=j==null?null:C.f.bW(j)
j=C.j.d1(j==null?2:j,1,5)
i=C.b.n(D.J4,k.h(0,"r"))?A.eB(k.h(0,"r")):1
h=A.ef(k.h(0,"auto"))
g=A.ef(k.h(0,"hide"))
k=A.ef(k.h(0,"in"))
s.a.b=new B.Vn(j,i,h!==!1,g===!0,k===!0)}u=2
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
if(q!=null)s.a.c=B.c7E(y.P.a(C.ap.fb(q,null)))
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
if(p!=null){o=y.P.a(C.ap.fb(p,null))
n=C.f.bW(A.cR(J.av(o,"s")))
m=C.f.bW(A.cR(J.av(o,"f")))
l=C.f.bW(A.cR(J.av(o,"t")))
if(B.clY(n,m)&&B.clY(n,l)&&m<=l)s.a.z=new A.b_(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a8V()){k.a.aqo()
x=1
break}a1=k
x=18
return A.c(k.a.ML(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a3()
if(k.b.e)k.D8()
k.wz()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:118}
B.b5b.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a3()},
$S:1115}
B.b5c.prototype={
$2(d,e){return C.j.aH(A.eC(A.n(d),null,null),1000)===this.a},
$S:1116}
B.bIP.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.Eo(),$async$$1)
case 2:t=f
if(u.c!=null)u.k(new B.bIO(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1117}
B.bIO.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bIQ.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bIN(x,d))},
$S:z+8}
B.bIN.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bIR.prototype={
$1(d){},
$S:24}
B.bIB.prototype={
$0(){},
$S:0}
B.bIH.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.D3(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bII.prototype={
$0(){},
$S:0}
B.bIL.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aB(A.ax(new B.bIK(),null,x),x)},
$S:0}
B.bIK.prototype={
$1(d){return D.byA},
$S:z+10}
B.bIM.prototype={
$0(){return B.clK(this.a)},
$S:0}
B.bIE.prototype={
$0(){var x=this.b
return this.a.xK(x.a,x.b,x.c)},
$S:0}
B.bIF.prototype={
$1(d){return this.a.k(new B.bID())},
$S:5}
B.bID.prototype={
$0(){},
$S:0}
B.bIG.prototype={
$0(){var x=this.a
return x.k(new B.bIC(x))},
$S:0}
B.bIC.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bIJ.prototype={
$0(){return this.a.b5i(this.b)},
$S:0}
B.c3l.prototype={
$1(d){return new A.jH(new B.c3i(this.a,this.b,this.c),null)},
$S:60}
B.c3i.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c3k(u,e),s=this.a,r=new B.c3j(s,e),q=A.d(H.kl(this.c),v,v,v,v,C.oy,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bp(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aK,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bp(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bp(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.ai,p,C.t,A.d5(C.ax,n,C.aF,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c3d(s)),C.a09,t.$3("\u0644\u062d\u062f",s.c,new B.c3e(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aVq)
u.push(C.a5)
u.push(A.dG(D.bnc,new B.c3f(s,d),A.ey(C.v,C.ad,D.b8E,v,v,v,v)))
return A.cu(!0,new A.F(C.Fq,A.I(u,C.ag,C.d,C.M,0,C.l),v),C.I,!0)},
$S:359}
B.c3k.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.i6,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.ca(v,A.d("\u0622\u064a\u0629 "+E.bp(v),u,u,u,u,u,u,u,u),C.at,u,w))
return A.R(A.I(A.a([t,R.FX(C.cK,!0,s,320,new B.c3h(this.b,f),D.bgZ,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1119}
B.c3h.prototype={
$1(d){return d==null?null:this.a.$1(new B.c3g(this.b,d))},
$S:50}
B.c3g.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c3j.prototype={
$3(d,e,f){var x=null
return A.c56(x,A.d(d,x,x,x,x,x,x,x,x),new B.c3c(this.a,this.b,e,f))},
$S:1120}
B.c3c.prototype={
$0(){var x=this
return x.b.$1(new B.c3b(x.a,x.c,x.d))},
$S:0}
B.c3b.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c3d.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c3e.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c3f.prototype={
$0(){var x=this.a
return A.O(this.b,!1).ak(new A.U(x.b,x.c))},
$S:0}
B.bW6.prototype={
$0(){},
$S:0}
B.bWm.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mi
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bWq.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.j9:D.mi},
$S:0}
B.bWr.prototype={
$0(){var x=this.a
x.f=D.uT
x.as=null},
$S:0}
B.bWs.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bWu.prototype={
$0(){var x=this.a
x.f=D.uU
x.as=null
x.y=0
x.z=new A.aQ(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bWv.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bWt())},
$S:31}
B.bWt.prototype={
$0(){},
$S:0}
B.bWx.prototype={
$1(d){return this.a.y=d},
$S:71}
B.bWw.prototype={
$1(d){return this.a.BA()},
$S:5}
B.bWy.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.j9:D.mi
x=this.b
w.as=B.MA(x)
w.at=x},
$S:0}
B.bWA.prototype={
$0(){var x=this.a
x.f=D.oX
x.ay=Date.now()},
$S:0}
B.bWB.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bWz())},
$S:31}
B.bWz.prototype={
$0(){},
$S:0}
B.bWl.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.j9:D.mi
x.as=this.b
x.at=this.c},
$S:0}
B.bWn.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.j9
x.x=!1},
$S:0}
B.bWe.prototype={
$0(){var x=this.a
x.f=D.oX
x.ay=Date.now()
x.as=null},
$S:0}
B.bWf.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bWd())},
$S:31}
B.bWd.prototype={
$0(){},
$S:0}
B.bWg.prototype={
$1(d){return d.d!==D.j2},
$S:z+11}
B.bWh.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bWG.prototype={
$0(){return B.clK(this.a)},
$S:0}
B.bWH.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.ap5(d))},
$S:3}
B.bWI.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aB(A.ax(new B.bWF(this.a),null,x),x)},
$S:0}
B.bWF.prototype={
$1(d){var x=this.a.a
return new B.D2(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bWJ.prototype={
$0(){this.a.d.a.bkj()
this.b.I(y.q).f.Z(D.b9I)},
$S:0}
B.bWk.prototype={
$2(d,e){return C.aZ},
$S:19}
B.bWj.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a69(s.c,r).a.a){case 2:s=G.cL
break
case 1:s=D.dW
break
case 0:s=C.im
break
default:s=u}x=A.v(18)
w=t.f===D.oX?u:new B.bWi(t,r)
v=s.ad(0.25)
if(r===t.gjc())s=C.i
s=A.aH(s,r===t.gjc()?2:1)
return A.bw(!1,x,!0,A.D(C.P,A.d(E.bp(r),u,u,u,u,C.a1k,u,u,u),C.k,u,u,new A.G(v,u,s,u,u,u,u,C.c_),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:67}
B.bWi.prototype={
$0(){return this.a.ZX(this.b)},
$S:0}
B.bWp.prototype={
$0(){var x=this.a
return x.k(new B.bWo(x))},
$S:0}
B.bWo.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bWC.prototype={
$1(d){return d===D.uC},
$S:z+2}
B.bWD.prototype={
$1(d){return d===D.uD},
$S:z+2}
B.bWE.prototype={
$1(d){return d===D.uE},
$S:z+2}
B.bW7.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Ro(x)},
$S:0}
B.bW8.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.baf(d.ga5(d)))},
$S:115}
B.bWa.prototype={
$1(d){return d.n(0,C.T)?C.ad:C.i},
$S:4}
B.bW9.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.bWb.prototype={
$0(){var x=this.a
return x.ZX(x.gjc()+1)},
$S:0}
B.bWc.prototype={
$0(){var x=this.a
return x.ZX(x.gjc()+1)},
$S:0}
B.bVQ.prototype={
$0(){},
$S:0}
B.bVZ.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aQ(Date.now(),0,!1)},
$S:0}
B.bW_.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bVY())},
$S:31}
B.bVY.prototype={
$0(){},
$S:0}
B.bW1.prototype={
$1(d){return this.a.x=d},
$S:71}
B.bW0.prototype={
$1(d){return this.a.Fz(this.b,!1)},
$S:5}
B.bW2.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.MA(x)
w.as=x},
$S:0}
B.bVU.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.bVV.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.MA(x))
w.as=x},
$S:0}
B.bVW.prototype={
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
return A.c(n.a.auT(s.b,B.EM(H.My(l,m,k.xU(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cjV(H.My(l,m,k.xU(l,m)).b,r.a)
if(C.c.O(q.c).length!==0){l=n.c
k=o.a.c
j=q.gtr()
l.atW(k,m,n.b.a,j)}n.zJ()
if(o.c!=null)o.k(new B.bVR(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lE){p=o
o=s.a
if(o.c!=null)o.k(new B.bVS(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.k(new B.bVT(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:145}
B.bVR.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.bVS.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.MA(w))
x.as=w},
$S:0}
B.bVT.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bVX.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)
x.as=null},
$S:0}
B.bW3.prototype={
$1(d){return d.gtr()},
$S:z+13}
B.bW4.prototype={
$0(){return this.a.Fz(this.b,!0)},
$S:0}
B.bW5.prototype={
$0(){return this.a.I3(this.b)},
$S:0}
B.bVH.prototype={
$0(){},
$S:0}
B.bVO.prototype={
$2(d,e){return d+this.a.a60(e)},
$S:113}
B.bVP.prototype={
$2(d,e){return d+I.cN[e-1].a[1]},
$S:113}
B.bVN.prototype={
$0(){return this.a.NT(this.b)},
$S:0}
B.bVM.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kl(p),q,q,q,q,C.oy,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.ba(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.rg():r).a.a){case 2:r=G.cL.ad(0.35)
break
case 1:r=D.dW.ad(0.35)
break
case 0:r=C.fU
break
default:r=q}m.push(A.D(C.P,A.d(E.bp(t),q,q,q,q,C.ke,q,q,q),C.k,q,q,new A.G(r,q,q,new A.cA(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cu(!0,new A.F(C.h_,A.I(A.a([o,C.ai,D.brv,C.t,new A.dD(D.a72,A.fh(A.d5(C.ax,m,C.aF,6,6),q,C.r,q,q,q,C.w),q),C.a1,A.bh(D.btd,q,q,q,new B.bVL(w,d,p),q,q)],n),C.ag,C.d,C.M,0,C.l),q),C.I,!0)},
$S:36}
B.bVL.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.ds(null,null,!0,null,new B.bVK(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.L3(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e5()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.bVK.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kl(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dC(A.a([A.bh(C.ep,x,x,x,new B.bVI(d),x,x),A.bh(C.oK,x,x,x,new B.bVJ(d),x,x)],y.p),w,D.buL)},
$S:14}
B.bVI.prototype={
$0(){A.O(this.a,!1).ak(!1)
return null},
$S:0}
B.bVJ.prototype={
$0(){A.O(this.a,!1).ak(!0)
return null},
$S:0}
B.c49.prototype={
$1(d){var x=this.a
return new A.kD(new B.c48(x),null,x,null)},
$S:1121}
B.c48.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.el(w,t,A.d(E.bp(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bjQ,C.a1,D.btE,C.J,A.oP(new B.c43(s,r),q,A.da([r.a],x),!1,A.kp(t,t,t,new A.bd(new B.c44(),v),t,t,t,t,new A.bd(new B.c45(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.ir(C.v,C.I,t,new B.c46(s,r),D.bqM,D.bwH,r.c),A.ir(C.v,C.I,t,new B.c47(s,r),t,D.bjl,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ai,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn3(),t,t,t,t,F.aK,t,C.bi,t)],u))
x.push(C.B)
x.push(D.a3j)
return A.cu(!0,A.fh(A.I(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.h_,t,t,C.w),C.I,!0)},
$S:1122}
B.c43.prototype={
$1(d){return this.a.qK(this.b.bac(d.ga5(d)))},
$S:115}
B.c45.prototype={
$1(d){return d.n(0,C.T)?C.ad:C.i},
$S:4}
B.c44.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.c46.prototype={
$1(d){return this.a.qK(this.b.b9y(d))},
$S:3}
B.c47.prototype={
$1(d){return this.a.qK(this.b.ap5(d))},
$S:3}
B.b4U.prototype={
$0(){return A.cx(A.bz(this.a,0,null),C.aR,null)},
$S:0}
B.c4p.prototype={
$1(d){var x,w=A.aB("https?://",!0,!1,!1)
w=A.bD(d,w,"")
x=A.aB("www\\.",!0,!1,!1)
return A.uS(A.bD(w,x,"www[.]"),A.aB("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c4q(),null)},
$S:38}
B.c4q.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:56}
B.bWK.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bWL.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bWM.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bWN.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bWP.prototype={
$0(){var x=this.a
return x.k(new B.bWO(x))},
$S:0}
B.bWO.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c4o.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:175};(function installTearOffs(){var x=a._instance_0u
x(B.aj0.prototype,"gbg2","bg3",1)
var w
x(w=B.Vo.prototype,"gbgj","D8",0)
x(w,"gaDz","wz",0)
x(w=B.a_Q.prototype,"goD","xJ",1)
x(w,"gaXS","PQ",0)
x(w=B.a2h.prototype,"goD","xJ",1)
x(w,"gb_x","Qe",0)
x(w,"gb3S","BA",0)
x(w,"gaJf","NQ",0)
x(w=B.a2g.prototype,"goD","xJ",1)
x(w,"gb0m","b0n",1)
x(B.a2f.prototype,"goD","xJ",1)
x(B.a2i.prototype,"gb5k","Rp",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aj0,B.Vp,B.JD,B.JF,B.JE,B.lE,B.Sw,B.mU,B.Ig,B.rr,B.aj1,B.Vn])
x(A.lb,[B.b4V,B.b4X,B.b51,B.b52,B.b54,B.b53,B.aWa,B.b5a,B.bIO,B.bIN,B.bIB,B.bII,B.bIL,B.bIM,B.bIE,B.bID,B.bIG,B.bIC,B.bIJ,B.c3g,B.c3c,B.c3b,B.c3f,B.bW6,B.bWm,B.bWq,B.bWr,B.bWs,B.bWu,B.bWt,B.bWy,B.bWA,B.bWz,B.bWl,B.bWn,B.bWe,B.bWd,B.bWh,B.bWG,B.bWI,B.bWJ,B.bWi,B.bWp,B.bWo,B.bW7,B.bWb,B.bWc,B.bVQ,B.bVZ,B.bVY,B.bW2,B.bVU,B.bVV,B.bVR,B.bVS,B.bVT,B.bVX,B.bW4,B.bW5,B.bVH,B.bVN,B.bVL,B.bVI,B.bVJ,B.b4U,B.bWK,B.bWL,B.bWM,B.bWN,B.bWP,B.bWO])
x(A.iE,[B.b4Y,B.b5_,B.b50,B.b4Z,B.aW9,B.c0T,B.b58,B.b59,B.b56,B.bIP,B.bIQ,B.bIR,B.bIH,B.bIK,B.bIF,B.c3l,B.c3k,B.c3h,B.c3j,B.c3d,B.c3e,B.bWv,B.bWx,B.bWw,B.bWB,B.bWf,B.bWg,B.bWH,B.bWF,B.bWC,B.bWD,B.bWE,B.bW8,B.bWa,B.bW9,B.bW_,B.bW1,B.bW0,B.bVW,B.bW3,B.bVM,B.bVK,B.c49,B.c43,B.c45,B.c44,B.c46,B.c47,B.c4p,B.c4q,B.c4o])
x(A.o3,[B.b4W,B.bZN,B.b5b,B.b5c,B.c3i,B.bWk,B.bWj,B.bVO,B.bVP,B.c48])
x(A.DD,[B.nz,B.F4,B.Hg,B.E3])
w(B.Vo,A.i1)
x(A.K,[B.wR,B.D3,B.D2,B.D1,B.D4])
x(A.M,[B.a_Q,B.a2h,B.a2g,B.a2f,B.a2i])
x(A.a3,[B.Hh,B.XG,B.Dm,B.aj_])})()
A.pi(b.typeUniverse,JSON.parse('{"lE":{"bP":[]},"D3":{"K":[],"k":[]},"D2":{"K":[],"k":[]},"D1":{"K":[],"k":[]},"D4":{"K":[],"k":[]},"Vo":{"aA":[]},"wR":{"K":[],"k":[]},"a_Q":{"M":["wR"]},"Hh":{"a3":[],"k":[]},"XG":{"a3":[],"k":[]},"a2h":{"M":["D3"]},"Dm":{"a3":[],"k":[]},"a2g":{"M":["D2"]},"a2f":{"M":["D1"]},"aj_":{"a3":[],"k":[]},"a2i":{"M":["D4"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rr"),c:x("el<x>"),r:x("ca<x>"),k:x("H<mU>"),n:x("H<el<x>>"),I:x("H<ca<x>>"),R:x("H<hO>"),Z:x("H<aR<o,@>>"),d:x("H<Sw>"),s:x("H<o>"),p:x("H<k>"),t:x("H<x>"),m:x("bN"),j:x("a7<@>"),L:x("a7<x>"),P:x("aR<o,@>"),f:x("aR<@,@>"),x:x("au<o,x>"),a:x("bE"),K:x("a4"),B:x("Ig"),l:x("+(x,x)"),e:x("d6<mU>"),N:x("o"),C:x("JD"),D:x("JE"),X:x("Vp"),_:x("JF"),U:x("ak<o>"),G:x("nz"),q:x("pf"),b:x("bd<S?>"),y:x("N"),i:x("a2"),z:x("@"),S:x("x"),A:x("bN?"),Y:x("aR<@,@>?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("fx"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.p5=new B.F4(0,"none")
D.p6=new B.F4(1,"learning")
D.fg=new B.F4(2,"memorized")
D.a72=new A.aC(0,1/0,0,320)
D.eQ=new A.S(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a7a=new A.G(D.eQ,null,null,null,null,null,null,C.c_)
D.dW=new A.S(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.asf=new A.E(C.Hr,null,C.cb,null,null,null)
D.buT=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.f9,null,null,null,null,null,null,null,null)
D.bcm=new A.r(!0,C.eS,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.brx=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bcm,null,null,null,null,null,null,null,null)
D.aJ6=x([D.asf,C.J,D.buT,D.brx],y.p)
D.afg=new A.fm(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aJ6,null)
D.aiJ=new A.X(0,26,0,26)
D.aiM=new A.X(0,4,0,6)
D.aja=new A.X(14,12,14,14)
D.ajR=new A.X(3,0,0,0)
D.anr=new A.Q(63251,"MaterialIcons",null,!1)
D.qw=new A.Q(63677,"MaterialIcons",null,!1)
D.aog=new A.Q(983209,"MaterialIcons",null,!1)
D.aoW=new A.E(D.aog,28,C.v,null,null,null)
D.apA=new A.E(C.H4,null,C.im,null,null,null)
D.ana=new A.Q(62961,"MaterialIcons",null,!1)
D.aqi=new A.E(D.ana,null,null,null,null,null)
D.anq=new A.Q(63199,"MaterialIcons",null,!1)
D.aqj=new A.E(D.anq,null,null,null,null,null)
D.aqs=new A.E(C.l2,null,C.eS,null,null,null)
D.aqv=new A.E(C.np,44,C.i,null,null,null)
D.ar0=new A.E(D.qw,null,D.eQ,null,null,null)
D.arh=new A.E(C.ng,null,D.eQ,null,null,null)
D.arE=new A.E(D.qw,null,null,null,null,null)
D.asb=new A.E(C.iw,20,D.dW,null,null,null)
D.asx=new A.E(C.nm,30,C.v,null,null,null)
D.asZ=new A.E(C.l7,16,C.v,null,null,null)
D.anL=new A.Q(63520,"MaterialIcons",null,!1)
D.atq=new A.E(D.anL,null,null,null,null,null)
D.atB=new A.E(C.no,null,null,null,null,null)
D.an1=new A.Q(62842,"MaterialIcons",null,!0)
D.atP=new A.E(D.an1,null,null,null,null,null)
D.J4=x([1,3,5],y.t)
D.JS=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aW_=new A.F(C.n6,C.mv,null)
D.aFZ=x([D.aW_],y.p)
D.b_t=new A.U(C.ni,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b_g=new A.U(D.qw,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b_O=new A.U(C.dw,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.ao0=new A.Q(63625,"MaterialIcons",null,!1)
D.b01=new A.U(D.ao0,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aI4=x([D.b_t,D.b_g,D.b_O,D.b01],A.ae("H<+(Q,o)>"))
D.aKr=x([D.p5,D.p6,D.fg],A.ae("H<F4>"))
D.Ow=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aRY=new B.Hg(0,"idle")
D.UL=new B.Hg(1,"loading")
D.jS=new B.Hg(2,"ready")
D.aRZ=new B.Hg(3,"failed")
D.aqZ=new A.E(C.bV,18,G.cL,null,null,null)
D.bvQ=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uf,null,null,null,null,null,null,null,null)
D.aET=x([D.aqZ,C.aZ,D.bvQ],y.p)
D.b63=new A.ei(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aET,null)
D.aUX=new A.F(C.aN,D.b63,null)
D.ajP=new A.X(2,6,2,4)
D.bc2=new A.r(!0,C.v,null,null,null,null,14,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjN=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bc2,null,null,null,null,null,null,null,null)
D.aVb=new A.F(D.ajP,D.bjN,null)
D.bwe=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.f9,null,null,null,null,null,null,null,null)
D.aGi=x([N.tM,C.K,D.bwe],y.p)
D.b5Y=new A.ei(C.af,C.cq,C.e,C.h,null,C.l,null,0,D.aGi,null)
D.aVl=new A.F(C.mY,D.b5Y,null)
D.Bm=new A.r(!0,D.dW,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bwz=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Bm,null,null,null,null,null,null,null,null)
D.aVq=new A.F(C.dX,D.bwz,null)
D.bvL=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aK,C.Z,null,null,null,null,null,null,null)
D.aVz=new A.F(C.C,D.bvL,null)
D.ajM=new A.X(2,0,2,8)
D.brN=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aK,null,null,null,null,null,null,null,null)
D.aVR=new A.F(D.ajM,D.brN,null)
D.at8=new A.E(C.l5,30,C.v,null,null,null)
D.bxe=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Bn,null,null,null,null,null,null,null,null)
D.akY=new A.bU(1,C.ac,D.bxe,null)
D.aGx=x([D.at8,C.Y,D.akY],y.p)
D.b5K=new A.ei(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aGx,null)
D.asJ=new A.E(C.dw,18,G.cL,null,null,null)
D.a1u=new A.r(!0,G.cL,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bvt=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a1u,null,null,null,null,null,null,null,null)
D.aFj=x([D.asJ,C.bG,D.bvt],y.p)
D.b5W=new A.ei(C.af,C.d,C.M,C.h,null,C.l,null,0,D.aFj,null)
D.b8g=new A.T(0,30)
D.tJ=new A.T(1/0,54)
D.b8E=new A.T(1/0,48)
D.b8H=new A.T(1/0,50)
D.b8K=new A.T(1/0,52)
D.btn=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.b9I=new A.d7(D.btn,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.bbx=new A.r(!0,C.i,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bbU=new A.r(!0,C.am,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.B7=new A.r(!0,D.eQ,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.kf=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a1F=new A.r(!0,D.eQ,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bfB=new A.r(!0,C.v,null,null,null,null,24,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bfT=new A.r(!0,C.v,null,null,null,null,null,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgG=new A.r(!0,D.dW,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgH=new A.r(!0,G.cL,null,null,null,null,null,C.V,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgZ=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.biD=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.i6,null,null,null,null,null,null,null,null)
D.bjl=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.cR,null,null,null,null,null,null,null,null)
D.bjQ=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oy,null,null,null,null,null,null,null,null)
D.bjV=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aK,null,null,null,null,null,null,null,null)
D.bdd=new A.r(!0,G.cL,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bkc=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bdd,null,null,null,null,null,null,null,null)
D.bkj=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aK,null,null,null,null,null,null,null,null)
D.bkJ=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.f9,null,null,null,null,null,null,null,null)
D.bms=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cE,null,null,null,null,null,null,null,null)
D.bnc=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bI,null,null,null,null,null,null,null,null)
D.bnh=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aK,null,null,null,null,null,null,null,null)
D.bnK=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.Br,null,null,null,null,null,null,null,null)
D.boZ=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bpz=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oC,null,null,null,null,null,null,null,null)
D.bqm=new A.m("reset safe mode / WebGPU ban",null,O.a10,null,null,null,null,null,null,null,null)
D.bqB=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Bm,null,null,null,null,null,null,null,null)
D.bqM=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aK,null,null,null,null,null,null,null,null)
D.brc=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bt,null,null,null,null,null,null,null,null)
D.brv=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.brO=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.bt9=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a23,null,null,null,null,null,null,null,null)
D.beQ=new A.r(!0,D.eQ,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.btd=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.beQ,null,null,null,null,null,null,null,null)
D.btE=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oC,null,null,null,null,null,null,null,null)
D.bub=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0U,null,null,null,null,null,null,null,null)
D.bup=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cE,null,null,null,null,null,null,null,null)
D.buL=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bv2=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bvD=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aK,null,null,null,null,null,null,null,null)
D.bvE=new A.m("\u062e\u0644\u0635\u062a",null,C.m_,null,null,null,null,null,null,null,null)
D.bvF=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Bm,null,null,null,null,null,null,null,null)
D.bfV=new A.r(!0,C.cG,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.hl,null,null,null,null,null,null,null,null)
D.bwp=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bfV,null,null,null,null,null,null,null,null)
D.bwD=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bt,null,null,null,null,null,null,null,null)
D.bwH=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.cR,null,null,null,null,null,null,null,null)
D.bxd=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aK,null,null,null,null,null,null,null,null)
D.a3j=new B.aj_(null)
D.byA=new B.D1(null)
D.byB=new B.Vn(2,1,!0,!1,!1)
D.a3n=new B.Vp(!1,!1,!1,!1,!1,0)
D.j2=new B.nz(0,"ok")
D.uC=new B.nz(1,"near")
D.uD=new B.nz(2,"wrong")
D.uE=new B.nz(3,"missing")
D.a3O=new B.nz(4,"extra")
D.anG=new A.Q(63456,"MaterialIcons",null,!1)
D.bE8=new B.Dm(D.dW,D.anG,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bEM=new B.XG(!1,null)
D.BY=new B.XG(!0,null)
D.mi=new B.E3(0,"idle")
D.uT=new B.E3(1,"playing")
D.uU=new B.E3(2,"recording")
D.oX=new B.E3(3,"thinking")
D.j9=new B.E3(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cMl","ca2",()=>new B.aj0())
x($,"cPN","cpH",()=>A.aB("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cPO","cpI",()=>A.aB("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cQ_","cpR",()=>A.aB("\u0648\u0670",!0,!1,!1))
x($,"cPl","cpn",()=>A.aB("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cND","coc",()=>A.aB("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cOS","cp_",()=>A.aB("[\u0654\u0655]",!0,!1,!1))
x($,"cNE","cod",()=>A.aB("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cNL","coj",()=>A.aB("[\u0624\u0626]",!0,!1,!1))
x($,"cOU","cp1",()=>A.aB("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cPq","cpq",()=>A.aB("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cP1","cp8",()=>A.aB("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cPL","caE",()=>A.aB("\\s+",!0,!1,!1))
x($,"cJE","rg",()=>B.cqG(D.p5,0,A.c5F(0,!0)))
x($,"cMm","MH",()=>new B.Vo($.ca2(),D.byB,B.cyD(),D.aRY,$.W()))})()};
(a=>{a["kmUVNxIJvA/NwIuXRCI2KWymmSw="]=a.current})($__dart_deferred_initializers__);