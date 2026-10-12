((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,R,G,H,N,O,S,K,B={
cv_(d){var x,w,v,u,t,s
if(d instanceof B.lr)return d
try{x=A.cV(d)
w=x.code
v=x.message
u=w==null?"failed":A.a0(w)
t=v==null?"":A.a0(v)
return new B.lr(u,t)}catch(s){u=A.n(d)
return new B.lr("failed",u)}},
ahN:function ahN(){this.b=this.a=null},
b3i:function b3i(d){this.a=d},
b3l:function b3l(){},
b3k:function b3k(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b3j:function b3j(d){this.a=d},
b3p:function b3p(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b3n:function b3n(d){this.a=d},
b3o:function b3o(d){this.a=d},
b3q:function b3q(d){this.a=d},
b3s:function b3s(d,e,f){this.a=d
this.b=e
this.c=f},
b3r:function b3r(d,e,f){this.a=d
this.b=e
this.c=f},
b3m:function b3m(){},
cv0(d,e){return new B.lr(d,e)},
Uv:function Uv(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
IW:function IW(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
IY:function IY(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
IX:function IX(d,e){this.a=d
this.b=e},
lr:function lr(d,e){this.a=d
this.b=e},
chx(d){var x,w=$.cma()
w=A.bB(d,w,"\u0627")
x=$.cmb()
w=A.bB(w,x,"\u064a")
x=$.cmk()
w=A.bB(w,x,"\u0627")
x=$.ckG()
w=A.bB(w,x,"\u0627")
x=$.clR()
w=A.bB(w,x,"\u0621")
x=$.clt()
w=A.bB(w,x,"\u0621")
x=$.ckH()
w=A.bB(w,x,"\u0627")
x=$.ckN()
w=A.bB(w,x,"\u0621")
w=A.bB(w,"\u0649","\u064a")
w=A.bB(w,"\u0629","\u0647")
x=$.clv()
w=A.bB(w,x,"")
x=$.clU()
w=A.bB(w,x," ")
x=$.clC()
w=A.bB(w,x," ")
x=$.c7A()
return C.c.O(A.bB(w,x," "))},
czI(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kl(x,w)
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
c1r(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.ax("[\u0627\u0621]",!0,!1,!1)
w=A.bB(d,x,"")
x=A.ax("[\u0627\u0621]",!0,!1,!1)
v=A.bB(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.czI(d,e)/u
return s>=1?0.99:s},
Ec(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tA(d,$.c7A()),w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.length===0)continue
t=B.chx(u)
s=A.bB(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.RA(r.a+" "+u,r.b))}continue}q.push(new B.RA(u,s))}return q},
cyp(d,e){var x,w,v,u,t=new B.bWZ(),s=A.a([],y.s)
for(x=A.fL(e,0,A.iK(5,"count",y.S),A.ak(e).c),w=x.$ti,x=new A.c9(x,x.gM(0),w.i("c9<aZ.E>")),w=w.i("aZ.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.Jo)&&t.$2(d,D.Jo)?C.b.jR(d,5):d
return!t.$2(s,D.O1)&&t.$2(u,D.O1)?C.b.jR(u,4):u},
cgz(d,e){var x=B.Ec(d),w=B.chx(e),v=y.U
v=A.aa(new A.am(A.a(w.split(" "),y.s),new B.bYZ(),v),v.i("Z.E"))
return new B.Hx(x,B.cxA(x,B.cyp(v,x)),w)},
cxA(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.K)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.ck(x,0,!1,s)
q=A.ck(x,0,!1,y.S)
p=A.ck(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c1r(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c1r(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c1r(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
else m=a2>=0.6?D.un:D.uo
a1.push(new B.mG(o,x,s,m))
break
case 1:--o
a1.push(new B.mG(o,a4[o],null,D.up))
break
case 2:--n
a1.push(new B.mG(null,null,a6[n],D.a3u))
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
nh:function nh(d,e){this.a=d
this.b=e},
RA:function RA(d,e){this.a=d
this.b=e},
mG:function mG(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Hx:function Hx(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aUA:function aUA(d){this.a=d},
aUz:function aUz(){},
bWZ:function bWZ(){},
bYZ:function bYZ(){},
cn9(d,e,f){return new B.r4(d,e,f)},
cAB(d){var x
A:{if("memorized"===d){x=D.fb
break A}if("learning"===d){x=D.oW
break A}x=D.oV
break A}return x},
ciu(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cN[d-1].a[1]},
cv1(){var x=y.S
return new B.ahO(A.C(x,y.u),A.aV(x))},
b3v(d){var x=d.fa()
return C.c.df(C.j.j(A.bp(x)),4,"0")+"-"+C.c.df(C.j.j(A.bt(x)),2,"0")+"-"+C.c.df(C.j.j(A.bV(x)),2,"0")},
cdE(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cC_(),x),x.i("aZ.E"))
return B.b3v(A.dm(w[0],w[1],w[2]-1,12,0,0,0))},
c4B(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.C(p,y.u),n=A.aV(p),m=new B.ahO(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcK(),x=x.ga_(x),w=y.j;x.v();){v=x.gJ()
u=A.dN(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aM(t)>=3){v=C.j.aJ(u,1000)
s=C.j.a0(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cN[v-1].a[1])}if(v)continue
v=J.ba(t)
r=C.f.c2(A.d3(v.h(t,0)))
if(r<0||r>=3)continue
o.q(0,u,new B.r4(D.aJg[r],C.f.c2(A.d3(v.h(t,1))),new A.aW(A.l1(C.f.c2(A.d3(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.ayU(q,y.o)
p=A.ma(x,new B.b3u(),x.$ti.i("Z.E"),p)
n.A(0,new A.am(p,o.ga2P(),A.y(p).i("am<Z.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aL(d.h(0,"streak"))
p=p==null?null:C.f.c2(p)
p=m.d=p==null?0:p
o=A.aL(d.h(0,"best"))
o=o==null?null:C.f.c2(o)
m.e=o==null?p:o
return m},
ayg(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.df(C.j.j(d),3,"0")+C.c.df(C.j.j(e),3,"0")+".mp3"},
Eu:function Eu(d,e){this.a=d
this.b=e},
r4:function r4(d,e,f){this.a=d
this.b=e
this.c=f},
ahO:function ahO(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b3w:function b3w(){},
b3x:function b3x(){},
b3u:function b3u(){},
Ut:function Ut(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
csy(){return new B.wr(null)},
cEm(d,e){var x,w,v,u,t={},s=I.cN[e-1].a[1],r=$.LR().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.qT():v).a===D.fb}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.cU(u+4,1,s)
return A.eb(C.cK,new B.c0h(t,s,e),d,!0,null,null,!1,y.l)},
c6p(d){return A.dh(0,0,0,0,0,C.j.cU(C.f.aw(6+d*1.2),25,90))},
c5l(d){return E.bm(C.j.aJ(d,60))+":"+C.c.df(E.bm(C.j.a0(d,60)),2,"\u0660")},
cig(d){return A.eb(C.cK,new B.c14($.LR()),d,!0,null,null,!1,y.H)},
LM(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gkR()
break A}return x},
cFF(d,e,f){var x,w=new B.c1k(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
cip(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.as.fB(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.h9:r
q=s.a(J.av(x,"last"))
v=q==null?C.h9:q
u=new B.c1j()
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
a1=J.k(J.av(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.k(J.av(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
GD:function GD(d,e){this.a=d
this.b=e},
Uu:function Uu(d,e,f,g,h){var _=this
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
b3y:function b3y(d){this.a=d},
b3z:function b3z(d){this.a=d},
b3A:function b3A(d){this.a=d},
wr:function wr(d){this.a=d},
ZR:function ZR(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bGo:function bGo(d){this.a=d},
bGn:function bGn(d,e){this.a=d
this.b=e},
bGp:function bGp(d){this.a=d},
bGm:function bGm(d,e){this.a=d
this.b=e},
bGq:function bGq(){},
bGa:function bGa(){},
bGg:function bGg(d,e,f){this.a=d
this.b=e
this.c=f},
bGh:function bGh(){},
bGk:function bGk(d){this.a=d},
bGj:function bGj(){},
bGl:function bGl(d){this.a=d},
bGd:function bGd(d,e){this.a=d
this.b=e},
bGe:function bGe(d){this.a=d},
bGc:function bGc(){},
bGf:function bGf(d){this.a=d},
bGb:function bGb(d){this.a=d},
bGi:function bGi(d,e){this.a=d
this.b=e},
GE:function GE(d,e,f){this.c=d
this.d=e
this.a=f},
WI:function WI(d,e){this.c=d
this.a=e},
c0h:function c0h(d,e,f){this.a=d
this.b=e
this.c=f},
c0e:function c0e(d,e,f){this.a=d
this.b=e
this.c=f},
c0g:function c0g(d,e){this.a=d
this.b=e},
c0d:function c0d(d,e){this.a=d
this.b=e},
c0c:function c0c(d,e){this.a=d
this.b=e},
c0f:function c0f(d,e){this.a=d
this.b=e},
c08:function c08(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c07:function c07(d,e,f){this.a=d
this.b=e
this.c=f},
c09:function c09(d){this.a=d},
c0a:function c0a(d){this.a=d},
c0b:function c0b(d,e){this.a=d
this.b=e},
Dw:function Dw(d,e){this.a=d
this.b=e},
CA:function CA(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a1e:function a1e(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bTk:function bTk(){},
bTA:function bTA(d,e){this.a=d
this.b=e},
bTE:function bTE(d){this.a=d},
bTF:function bTF(d){this.a=d},
bTG:function bTG(d,e,f){this.a=d
this.b=e
this.c=f},
bTI:function bTI(d){this.a=d},
bTJ:function bTJ(d){this.a=d},
bTH:function bTH(){},
bTL:function bTL(d){this.a=d},
bTK:function bTK(d){this.a=d},
bTM:function bTM(d,e){this.a=d
this.b=e},
bTO:function bTO(d){this.a=d},
bTP:function bTP(d){this.a=d},
bTN:function bTN(){},
bTz:function bTz(d,e,f){this.a=d
this.b=e
this.c=f},
bTB:function bTB(d,e,f){this.a=d
this.b=e
this.c=f},
bTs:function bTs(d){this.a=d},
bTt:function bTt(d){this.a=d},
bTr:function bTr(){},
bTu:function bTu(){},
bTv:function bTv(d,e){this.a=d
this.b=e},
bTU:function bTU(d){this.a=d},
bTV:function bTV(d){this.a=d},
bTW:function bTW(d,e){this.a=d
this.b=e},
bTT:function bTT(d){this.a=d},
bTX:function bTX(d,e){this.a=d
this.b=e},
bTy:function bTy(){},
bTx:function bTx(d){this.a=d},
bTw:function bTw(d,e){this.a=d
this.b=e},
bTD:function bTD(d){this.a=d},
bTC:function bTC(d){this.a=d},
bTQ:function bTQ(){},
bTR:function bTR(){},
bTS:function bTS(){},
bTl:function bTl(d,e,f){this.a=d
this.b=e
this.c=f},
bTm:function bTm(d){this.a=d},
bTo:function bTo(){},
bTn:function bTn(){},
bTp:function bTp(d){this.a=d},
bTq:function bTq(d){this.a=d},
CR:function CR(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
Cz:function Cz(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a1d:function a1d(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bT3:function bT3(){},
bTc:function bTc(d,e){this.a=d
this.b=e},
bTd:function bTd(d){this.a=d},
bTb:function bTb(){},
bTf:function bTf(d){this.a=d},
bTe:function bTe(d,e){this.a=d
this.b=e},
bTg:function bTg(d,e){this.a=d
this.b=e},
bT7:function bT7(d,e){this.a=d
this.b=e},
bT8:function bT8(d,e,f){this.a=d
this.b=e
this.c=f},
bT9:function bT9(d,e,f){this.a=d
this.b=e
this.c=f},
bT4:function bT4(d,e,f){this.a=d
this.b=e
this.c=f},
bT5:function bT5(d,e,f){this.a=d
this.b=e
this.c=f},
bT6:function bT6(d,e){this.a=d
this.b=e},
bTa:function bTa(d){this.a=d},
bTh:function bTh(){},
bTi:function bTi(d,e){this.a=d
this.b=e},
bTj:function bTj(d,e){this.a=d
this.b=e},
Cy:function Cy(d){this.a=d},
a1c:function a1c(d){this.d=d
this.c=this.a=null},
bSV:function bSV(){},
bT1:function bT1(d){this.a=d},
bT2:function bT2(){},
bT0:function bT0(d,e){this.a=d
this.b=e},
bT_:function bT_(d,e,f){this.a=d
this.b=e
this.c=f},
bSZ:function bSZ(d,e,f){this.a=d
this.b=e
this.c=f},
bSY:function bSY(d){this.a=d},
bSW:function bSW(d){this.a=d},
bSX:function bSX(d){this.a=d},
c14:function c14(d){this.a=d},
c13:function c13(d){this.a=d},
c0Z:function c0Z(d,e){this.a=d
this.b=e},
c10:function c10(){},
c1_:function c1_(){},
c11:function c11(d,e){this.a=d
this.b=e},
c12:function c12(d,e){this.a=d
this.b=e},
ahM:function ahM(d){this.a=d},
b3h:function b3h(d){this.a=d},
c1k:function c1k(){},
c1l:function c1l(){},
CB:function CB(d,e,f){this.c=d
this.d=e
this.a=f},
a1f:function a1f(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bTY:function bTY(d){this.a=d},
bTZ:function bTZ(d){this.a=d},
bU_:function bU_(d,e){this.a=d
this.b=e},
bU0:function bU0(d){this.a=d},
bU2:function bU2(d){this.a=d},
bU1:function bU1(d){this.a=d},
c1j:function c1j(){}},D,P,Q,I,E,F
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
B.ahN.prototype={
qM(){var x=this,w=x.a
if(w!=null)return A.ed(w,y.m)
w=x.b
return w==null?x.b=new B.b3i(x).$0():w},
u_(d,e){return this.aLv(d,e,e)},
aLv(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
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
r=B.cv_(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$u_,w)},
o5(d,e){var x=A.em(d[e])
if(x==null)x=null
return x===!0},
Me(){var x=0,w=A.j(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$Me=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.qM(),$async$Me)
case 7:r=h.cV(g.cN(e,"support",null,null,null,null))
q=s.o5(r,"worker")
p=s.o5(r,"wasm")
o=s.o5(r,"mic")
n=s.o5(r,"audio")
s.o5(r,"webgpu")
m=s.o5(r,"secure")
s.o5(r,"ios")
l=A.kM(r.memory)
if(l==null)l=null
if(l==null)l=0
s.o5(r,"isolated")
k=A.kM(r.cores)
if(k!=null)C.f.aw(k)
v=new B.Uv(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a32
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Me,w)},
E3(){var x=0,w=A.j(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$E3=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.qM(),$async$E3)
case 8:x=7
return A.c(m.ez(l.cV(k.cN(e,"storage",null,null,null,null)),y.A),$async$E3)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.aw(A.dT(r.quota))
p=C.f.aw(A.dT(r.usage))
v=new A.arM(q,p)
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
return A.i($async$E3,w)},
bgJ(){var x=y.K
A.OG(this.qM().bB(new B.b3l(),x),x)},
qL(d,e){var x=A.kM(d[e])
x=x==null?null:C.f.aw(x)
return x==null?0:x},
be6(d,e,f){return this.u_(new B.b3k(this,d,e,f),y.C)},
gaj6(){var x,w
try{x=A.k6(b.G.sessionStorage)
return x}catch(w){return null}},
gaqu(){var x=A.em(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a84(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.em(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gaqu())return!1
l=A.em(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cV(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.a0(x.userAgent)
l=A.kM(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.u(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.ax("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.k(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.ax("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.kM(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.gaj6()
l=l==null?f:A.u(A.cN(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dN(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.k6(m.localStorage)
m=o
m=m==null?f:A.u(A.cN(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dN(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
ap2(){var x,w,v,u,t,s,r=null
try{x=this.gaj6()
if(x!=null)A.cN(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cV(x.location)
u=A.a0(v.hash)
t=A.a0(v.search)
s=A.bi(A.a0(A.cV(x.document).baseURI),0,r).a2("tutor/").j(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cN(v,"replace",s+t+x,r,r,r)},
bdQ(){var x,w=null,v=b.G,u=A.cV(v.history),t=A.kM(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cN(u,"back",w,w,w,w)
else{x=A.a0(A.cV(v.document).baseURI)
A.cN(A.cV(v.location),"replace",A.bi(x,0,w).a2("./").j(0)+"#/",w,w,w)}},
a8f(d,e,f,g,h){return this.u_(new B.b3p(this,e,d,f,h,g),y.H)},
a8i(){return this.u_(new B.b3q(this),y.D)},
a2s(){var x=null,w=this.a
if(w!=null)A.cN(w,"cancelRecording",x,x,x,x)},
akr(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.qL(d,"ms")
w=A.kM(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.IY(u,x,w,v.qL(d,"frames"),v.qL(d,"tokens"),v.o5(d,"retried"),v.qL(d,"encMs"),v.qL(d,"decMs"),v.qL(d,"featMs"))},
ah_(d){var x={}
x.words=d
return x},
atB(d,e){return this.u_(new B.b3s(this,d,e),y._)},
biV(d,e){return this.u_(new B.b3r(this,d,e),y._)},
Kl(d,e){return this.bgO(d,e)},
bgO(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Kl=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:u=4
p=s.a
x=p==null?7:9
break
case 7:x=10
return A.c(s.qM(),$async$Kl)
case 10:x=8
break
case 9:g=p
case 8:r=g
o=A.ak(d).i("au<1,o>")
o=A.aa(new A.au(d,new B.b3m(),o),o.i("aZ.E"))
x=11
return A.c(A.ez(A.cV(A.cN(r,"play",o,e,null,null)),y.y),$async$Kl)
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
return A.i($async$Kl,w)},
LX(){var x=null,w=this.a
if(w!=null)A.cN(w,"stopPlayback",x,x,x,x)},
IQ(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.a0(A.cN(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bi2(){var x,w,v=null
try{x=this.a
if(x!=null)A.cN(x,"resetDevice",v,v,v,v)}catch(w){}},
a5M(d){var x=this.a
if(x!=null)A.cN(x,"prefetch",d,null,null,null)}}
B.Uv.prototype={}
B.IW.prototype={
gmJ(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.IY.prototype={
gS7(){var x=this,w=C.f.an(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.IX.prototype={}
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
B.nh.prototype={
R(){return"WordStatus."+this.b}}
B.RA.prototype={}
B.mG.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Hx.prototype={
gLW(){var x,w=this,v=w.d
if(v===$){x=new B.aUA(w).$0()
w.d!==$&&A.ap()
w.d=x
v=x}return v},
gJ7(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.d===D.a3u&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbeY(){return J.h2(this.gLW(),new B.aUz()).gM(0)},
gt4(){var x=this.a
return x.length!==0&&this.gbeY()===x.length&&this.gJ7().length===0}}
B.Eu.prototype={
R(){return"AyahStatus."+this.b}}
B.r4.prototype={}
B.ahO.prototype={
a5o(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.qT():x},
aY4(d){var x=this,w=B.b3v(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cdE(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
aoe(){var x=Date.now(),w=B.b3v(new A.aW(x,0,!1))
x=this.c
return x===w||x===B.cdE(w)?this.d:0},
asF(d,e,f,g){var x=this,w=new A.aW(Date.now(),0,!1),v=x.a5o(d,e),u=g?C.j.cU(v.b+1,0,100):0,t=g&&u>=f?D.fb:D.oW,s=new B.r4(t,u,w.i4()),r=d*1000+e
x.a.q(0,r,s)
x.b.F(0,r)
x.aY4(w)
return s},
a5f(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cN[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qT():s).a===D.fb)++u}return u},
bdO(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cN[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qT():s).a===D.oW)++u}return u},
garE(){var x=this.a,w=A.y(x).i("cd<2>")
return new A.am(new A.cd(x,w),new B.b3w(),w.i("am<Z.E>")).gM(0)},
gaxf(){var x=this.a,w=A.y(x).i("bH<1>")
w=A.ma(new A.bH(x,w),new B.b3x(),w.i("Z.E"),y.S)
w=A.eS(w,A.y(w).i("Z.E"))
x=A.aa(w,A.y(w).c)
C.b.ma(x)
return x},
dA(){var x,w,v,u,t,s=this,r=y.N,q=A.C(r,y.L)
for(x=s.a,x=new A.eD(x,A.y(x).i("eD<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.q(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.aa(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
b9M(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b1R(x,300,A.y(x).c),x=new A.IC(J.aE(x.a),x.b,A.y(x).i("IC<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gJ()
s=C.j.aJ(t,1000)
t=C.j.a0(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.qT():q).a===D.fb?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.qT()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.qT():r).c.jL()],w,v))}return o},
beo(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.K)(d),++u){t=d[u]
s=A.ex(t.h(0,"surah"))*1000+A.ex(t.h(0,"ayah"))
r=w.h(0,C.j.aJ(s,1000)*1000+C.j.a0(s,1000))
if((r==null?$.qT():r).c.jL()===t.h(0,"updated_at"))v.K(0,s)}},
bew(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aE(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gJ()
if(!u.b(s))continue
r=A.aL(s.h(0,"surah"))
q=r==null?null:C.f.c2(r)
r=A.aL(s.h(0,"ayah"))
p=r==null?null:C.f.c2(r)
o=A.dW(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=I.cN[q-1].a[1])
if(r)continue
n=B.cAB(s.h(0,"status"))
if(n===D.oV)continue
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
v.q(0,r,new B.r4(n,C.j.cU(l==null?0:l,0,100),o.i4()))
w.K(0,r)
t=!0}return t}}
B.Ut.prototype={
Iz(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Ut(w,v,u,t,f==null?x.e:f)},
b84(d){var x=null
return this.Iz(x,x,d,x,x)},
anK(d){var x=null
return this.Iz(x,d,x,x,x)},
b88(d){var x=null
return this.Iz(x,x,x,x,d)},
b7s(d){var x=null
return this.Iz(d,x,x,x,x)},
b85(d){var x=null
return this.Iz(x,x,x,d,x)},
dA(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.GD.prototype={
R(){return"ModelState."+this.b}}
B.Uu.prototype={
vj(){var x=this.Q
return x==null?this.Q=new B.b3y(this).$0():x},
qm(d){return this.avs(d)},
avs(d){var x=0,w=A.j(y.H),v=this
var $async$qm=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a6()
x=2
return A.c(A.j5("mt.tutor.settings",C.as.iB(d.dA(),null)),$async$qm)
case 2:return A.h(null,w)}})
return A.i($async$qm,w)},
zl(){var x=0,w=A.j(y.H),v=this,u
var $async$zl=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a6()
x=2
return A.c(A.j5("mt.tutor.progress",C.as.iB(v.c.dA(),null)),$async$zl)
case 2:u=v.as
if(u!=null)u.aA()
v.as=A.cM(C.y,v.gaCc())
return A.h(null,w)}})
return A.i($async$zl,w)},
LG(d,e,f){return this.awe(d,e,f)},
awe(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$LG=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.aQ(d,e,f)
x=2
return A.c(A.j5("mt.tutor.last",C.as.iB(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$LG)
case 2:return A.h(null,w)}})
return A.i($async$LG,w)},
CM(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$CM=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.Uc||n===D.jJ){x=1
break}s.f=D.Uc
s.y=null
s.a6()
u=4
n=A.ls().geV().h(0,"tutor_device")
if(n==null)n="auto"
p=A.ls().geV().h(0,"tutor_threads")
p=A.dN(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.be6(new B.b3z(s),n,p),$async$CM)
case 7:s.x=e
s.f=D.jJ
n=A.ls().geV().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.qQ().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a9(m)
if(n instanceof B.lr){q=n
s.f=D.aQE
s.y=q
n=A.ls().geV().h(0,"debug")
if(n==="1")A.qQ().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a6()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$CM,w)},
wk(){var x=0,w=A.j(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
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
n=r.c.bew(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.b9M()
if(J.aM(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.mO(h.x,k,k))
x=11
return A.c(f.bir("quran_tutor_save",!1,g,i),$async$wk)
case 11:r.c.beo(l)
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
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$wk,w)},
Kz(d){return this.bi4(d)},
bi4(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Kz=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c4B(t.c.dA()).dA()
y.f.a(p.h(0,"rows")).e8(0,new B.b3A(d))
t.c=B.c4B(p)
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
return A.c(s.aC("quran_tutor_reset",A.J(["p_surah",d],y.N,r),r),$async$Kz)
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
return A.i($async$Kz,w)}}
B.wr.prototype={
P(){var x=$.LR()
return new B.ZR(x,new A.af(C.J,$.S()))}}
B.ZR.prototype={
X(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goh())
w=y.a
x.vj().bB(new B.bGo(v),w)
H.aT1().bB(new B.bGp(v),w).fP(new B.bGq())
A.OG(H.c3X(),y.y)},
xs(){if(this.c!=null)this.k(new B.bGa())},
m(){var x,w=this
w.d.V(w.goh())
x=w.e
x.p$=$.S()
x.L$=0
w.a1()},
Pf(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$Pf=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qm(s.b.b84(!0)),$async$Pf)
case 3:t=s.a
t.bgJ()
if(t.a84()){t.ap2()
x=1
break}s.CM()
case 1:return A.h(v,w)}})
return A.i($async$Pf,w)},
xt(d,e,f){return this.aVX(d,e,f)},
b3p(d){return this.xt(d,null,null)},
aVX(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
var $async$xt=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.Z(A.aT(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.W(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cEm(s,d),$async$xt)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.LG(d,t.a,t.b),$async$xt)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.N(s,!1).az(A.aA(new B.bGg(u,d,t),null,r),r),$async$xt)
case 8:if(u.c!=null)u.k(new B.bGh())
case 1:return A.h(v,w)}})
return A.i($async$xt,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gaqu()&&!A.N(d,!1).uM())u.push(A.bS(x,x,x,x,C.xW,x,x,t.gbdP(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bS(x,x,x,x,D.asm,x,x,new B.bGk(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bS(x,x,x,x,C.ir,x,x,new B.bGl(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aEQ
else w=t?this.aQS():this.aRt()
return L.x9(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aRt(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a32
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b4c,C.a2],x)
for(t=0;t<4;++t){s=D.aGV[t]
u.push(new A.H(C.bs,A.A(A.a([A.b3(s.a,C.ap,p,18),C.K,new A.bU(1,C.ac,A.d(s.b,p,p,p,p,G.a0E,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.buJ,C.I,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bm(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aK,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bm(C.f.aw(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.I,A.d(q,p,p,p,p,A.bI(p,p,r?D.dU:C.cF,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.I,D.btL],x))
x=A.a([new E.dx(u,C.a4,C.aJ,p,!0,p),new E.dx(A.I(s,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,p,!1,p),D.bCM,C.I],x)
if(v!=null)x.push(new E.dx(A.d(v,p,p,p,p,D.bf_,p,p,p),C.a4,C.aJ,p,!1,p))
else x.push(A.ft(D.apl,D.bkH,this.gaWe(),A.eC(C.v,C.ae,D.b76,p,p)))
x.push(C.a0)
x.push(D.a2Y)
return x},
aQS(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.O(r.a.a),p=q.length===0,o=p?C.rd:H.ci9(q),n=t.z,m=A.R(v.ajM(C.dv,E.bm(s.garE())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bm(s.aoe()),k=s.c,j=Date.now()
k=k===B.b3v(new A.aW(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.GE(t,!1,u),A.A(A.a([m,C.K,A.R(v.ajM(C.kT,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.u],j)
if(n!=null){t=H.k8(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bm(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bm(m)+"\u2013"+E.bm(l)
k.push(new E.dx(A.A(A.a([D.aru,C.W,A.R(A.I(A.a([D.bgW,A.d(t+" \u2014 "+m,u,u,u,u,C.bz,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nk],j),C.h,C.d,C.e,0,u,u),C.a4,C.aJ,new B.bGd(v,n),!0,u))}t=C.i.ae(0.08)
k.push(A.aF(u,C.x,!1,u,!0,C.m,u,A.aG(),r,u,u,u,u,u,2,A.cQ(u,new A.ch(4,A.v(14),C.O),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.tW,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qy,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bGe(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.dl,!0,C.t,u,C.E,u,u,u,u))
k.push(C.u)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bpV)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.K)(o),++x)t.push(v.Qs(o[x]))
C.b.A(k,t)}else{t=A.a([D.aTJ,D.aUp,v.Qs(1)],j)
for(w=114;w>=78;--w)t.push(v.Qs(w))
t.push(C.I)
r=v.f
p=A.b3(r?C.xB:C.n2,C.ap,u,u)
t.push(A.hp(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.f3,u,u,u),new B.bGf(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Qs(w))
C.b.A(k,t)}k.push(C.a2)
k.push(D.Bz)
return k},
ajM(d,e,f){var x=null,w=y.p
return new E.dx(A.A(A.a([A.b3(d,C.v,x,x),C.K,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bz,x,x,x),A.d(f,1,C.M,x,x,C.a1h,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a4,C.L,x,!1,x)},
Qs(d){var x,w=null,v=this.d.c,u=I.cN[d-1].a[1],t=v.a5f(d),s=t/u,r=y.p,q=A.ao(A.du(C.P,A.a([A.c2l(C.eK,G.cL,w,w,w,w,w,3,s,w),A.d(E.bm(d),w,w,w,w,R.a1D,w,w,w)],r),C.m,C.bj,w),36,36),p=A.d(H.k8(d),w,w,w,w,D.b9Q,w,w,w)
if(t===0)x=E.bm(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bm(t)+" \u0645\u0646 "+E.bm(u)
r=A.a([q,C.cC,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bI(w,w,t===u?G.cL:C.cF,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bm(C.f.aw(s*100))+"\u066a",w,w,w,w,D.a18,w,w,w))
r.push(D.apu)
return new E.dx(A.A(r,C.h,C.d,C.e,0,w,w),C.pT,C.db,new B.bGi(this,d),!1,w)}}
B.GE.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b0
return D.aTu
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.LM(x),r,r,r,r,D.AL,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.CB(w,"model load",r))
x.push(C.I)
x.push(new A.zk(C.a3P,!1,q.gbe5(),r,r,r,r,C.k,r,!1,r,!0,r,C.u7,r))
return new E.dx(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.cU(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bm(C.f.aw(u/1e6))+" \u0645\u0646 "+E.bm(C.f.aw(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.oq,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.f5(x,A.pK(C.eK,C.v,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.I,D.blv],w))
return new E.dx(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)}}}
B.WI.prototype={
t(d){var x=null,w=D.dU.ae(0.1),v=A.v(14),u=A.aH(D.dU.ae(0.4),1)
return A.D(x,A.A(A.a([D.ar8,C.K,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.AS,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.E(w,x,u,v,x,x,x,C.n),x,x,C.aJ,C.ad,x,x,x)}}
B.Dw.prototype={
R(){return"_Phase."+this.b}}
B.CA.prototype={
P(){return new B.a1e($.LR(),D.m3)}}
B.a1e.prototype={
gj_(){var x=this.e
return x===$?this.e=this.a.d:x},
gBl(){var x,w=this.a,v=w.f
w=w.c
x=this.gj_()
return H.LK(w,x,v.xD(w,x)).b},
X(){var x,w=this
w.Y()
x=w.d
x.ac(w.goh())
x.vj()
x.a.a5M(B.ayg(w.a.c,w.gj_()))},
xs(){if(this.c!=null)this.k(new B.bTk())},
m(){var x,w=this,v=w.d
v.V(w.goh())
x=w.Q
if(x!=null)x.aA()
v=v.a
v.LX()
v.a2s()
w.a1()},
Zc(d){var x,w,v=this
if(v.f===D.uE)v.d.a.a2s()
x=v.d.a
x.LX()
w=v.Q
if(w!=null)w.aA()
v.k(new B.bTA(v,d))
x.a5M(B.ayg(v.a.c,d))
w=v.a
if(d<w.e)x.a5M(B.ayg(w.c,d+1))},
QJ(d){return this.aSk(d)},
aSk(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$QJ=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.uD){u.d.a.LX()
u.k(new B.bTE(u))
x=1
break}t=u.r!=null?D.iZ:D.m3
u.k(new B.bTF(u))
s=u.d
r=A.a([B.ayg(u.a.c,u.gj_())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.Kl(r,q),$async$QJ)
case 3:p=f
if(u.c==null||u.f!==D.uD){x=1
break}u.k(new B.bTG(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$QJ,w)},
PB(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$PB=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jJ){x=1
break}p=l.a
p.LX()
r=B.Ec(s.gBl()).length
s.k(new B.bTI(s))
o=s.Q
if(o!=null)o.aA()
s.Q=A.hq(C.eO,new B.bTJ(s))
u=4
o=B.c6p(r)
n=A.dh(0,0,0,350*r,0,0)
x=7
return A.c(p.a8f(l.b.c,o,n,new B.bTK(s),new B.bTL(s)),$async$PB)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a9(k)
if(l instanceof B.lr){q=l
l=s.Q
if(l!=null)l.aA()
if(s.c!=null)s.k(new B.bTM(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$PB,w)},
Be(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$Be=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.uE){x=1
break}m=s.Q
if(m!=null)m.aA()
s.k(new B.bTO(s))
s.Q=A.hq(C.im,new B.bTP(s))
l=new A.C3()
$.Ef()
l.o1()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a8i(),$async$Be)
case 7:q=e
if(q.b<0.8){s.b3o("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.atB(q,B.Ec(s.gBl()).length),$async$Be)
case 8:p=e
s.ch=A.dh(0,0,r.ga3P(),0,0,0)
k=A.ls().geV().h(0,"debug")
if(k==="1"){o=B.cip(m.IQ())
A.qQ().$1("[tutor] "+s.a.c+":"+s.gj_()+" audio="+C.f.an(q.b,1)+"s infer="+p.b+"ms total="+r.gC9()+"ms "+p.gS7()+" text="+p.a)
A.qQ().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.an(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.an(p.b/1000,2)+" \u062b\n"+p.gS7()+"\n"+A.n(o)+"\n"+p.a}s.ae9(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a9(i)
if(m instanceof B.lr){n=m
m=A.ls().geV().h(0,"debug")
if(m==="1")A.qQ().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.IQ())
s.a1h(B.LM(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Be,w)},
a1h(d,e){var x=this,w=x.Q
if(w!=null)w.aA()
if(x.c==null)return
x.k(new B.bTz(x,d,e))},
b3o(d){return this.a1h(d,null)},
ae9(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aA()
if(s.c==null)return
x=B.cgz(s.gBl(),d)
r.a=null
if(C.c.O(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gj_()
t=x.gt4()
r.a=w.asF(v,u,q.b.a,t)
q.zl()}s.k(new B.bTB(r,s,x))},
Nh(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$Nh=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jJ){x=1
break}s.k(new B.bTs(s))
l=s.Q
if(l!=null)l.aA()
s.Q=A.hq(C.im,new B.bTt(s))
k=new A.C3()
$.Ef()
k.o1()
r=k
u=4
l=g.a
x=7
return A.c(l.biV(B.ayg(s.a.c,s.gj_()),B.Ec(s.gBl()).length),$async$Nh)
case 7:q=e
p=B.cip(l.IQ())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.an(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.an(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.an(r.gC9()/1000,2)+" \u062b)\n"+q.gS7()+"\n"+A.n(p)+"\n"+q.a
A.qQ().$1("[tutor-debug] "+s.a.c+":"+s.gj_()+" audio="+C.f.an(q.c,1)+"s infer="+q.b+"ms total="+r.gC9()+"ms "+q.gS7()+" text="+q.a)
A.qQ().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dh(0,0,r.ga3P(),0,0,0)
s.ae9(q.a)
n=s.r
if(n!=null){l=n.gt4()
j=n.b
i=A.ak(j).i("am<1>")
j=A.aa(new A.am(j,new B.bTu(),i),i.i("Z.E"))
A.qQ().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.k(new B.bTv(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a9(f)
if(l instanceof B.lr){m=l
A.qQ().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.IQ())
s.a1h(B.LM(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Nh,w)},
ga05(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.qT():v).a!==D.fb)return!1}return!0},
t(d){var x,w=this,v=null,u=w.d,t=u.c.a5o(w.a.c,w.gj_()),s=u.b,r=s.d&&!w.x&&w.f!==D.iZ,q=H.k8(w.a.c),p=y.p,o=A.a([A.bS(v,v,v,v,C.ir,v,v,new B.bTU(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aIL(),m=A.d("\u0622\u064a\u0629 "+E.bm(w.gj_()),v,v,v,v,O.or,v,v,v),l=E.bm(w.gj_()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.b1,A.d("("+l+" \u0645\u0646 "+E.bm(k.e-k.d+1)+")",v,v,v,v,F.aK,v,v,v),C.by,w.aWU(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.u],p)
if(r)s.push(w.aQN())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.uE&&l!==D.oM}else l=!1
if(l)s.push(w.aGt(m))
else s.push(A.d(w.gBl()+" \ufd3f"+E.bm(w.gj_())+"\ufd3e",v,v,v,v,D.k7,C.Y,C.bh,v))}s=A.a([new B.GE(u,!0,v),n,C.B,new E.dx(A.I(s,C.ag,C.d,C.e,0,C.l),D.aij,C.aJ,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.iZ)s.push(w.b4O(n))
if(w.r!=null&&w.f===D.iZ&&w.ch!=null){x=C.f.aw(C.j.aJ(w.ch.a,1000)/100)
s.push(new A.H(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bm(C.j.aJ(x,10))+"\u066b"+E.bm(C.j.a0(x,10)))+" \u062b",v,v,v,v,F.aK,C.Y,v,v),v))}n=w.as
if(n!=null)s.push(new A.H(C.aJ,A.d(n,v,v,v,v,D.AL,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.CB(n,"check "+w.a.c+":"+w.gj_(),v))}s.push(w.aH_())
s.push(C.a2)
s.push(A.ie(C.v,C.L,v,new B.bTV(w),D.biB,D.bnL,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga05()
s.push(new E.dx(A.A(A.a([D.ao0,C.W,A.R(A.I(A.a([D.bpj,A.d(w.ga05()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aK,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nk],p),C.h,C.d,C.e,0,v,v),C.a4,C.aJ,new B.bTW(w,d),n,v))}n=A.ls().geV().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dt(D.apk,D.bna,u.f===D.jJ&&w.f!==D.oM?w.gaHJ():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.H(C.io,A.wN(n,F.aK,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gmJ()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aK,v,v,v))}p.push(A.bd(D.bou,v,v,v,new B.bTX(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.Bz)
return L.x9(o,s,q)},
aIL(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b0
return A.ao(A.fv(new B.bTx(this),w,null,C.af,new B.bTy()),36,null)},
aWU(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fb)return D.b4n
x=d.b
w=E.bm(x)
v=E.bm(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.bV:C.GN
u.push(new A.H(D.aj_,A.b3(r,s?G.cL:C.eL,q,16),q))}return A.c4y(A.A(u,C.h,C.d,C.N,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aQN(){var x=null
return A.bz(!1,A.v(12),!0,A.D(x,D.aet,C.k,x,x,new A.E(C.pn,x,x,A.v(12),x,x,x,C.n),x,x,x,D.ahT,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bTD(this),x,x,x,x,x,x,x)},
aGt(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gLW(),w)
A:{if(D.iS===v){u=D.k7.ck(G.cL)
break A}if(D.un===v){u=D.k7.a36(D.dU,C.hZ,D.dU)
break A}if(D.uo===v){u=D.k7.a36(D.eJ,C.hZ,D.eJ)
break A}u=D.k7.a36(C.eL,C.k4,C.cw)
break A}t=x[w]
r.push(new A.eX(t.a,s,s,C.bx,s,s,s,s,s,s,u))
r.push(Q.AC)}x=E.bm(this.gj_())
r.push(A.ek(s,s,s,s,s,s,s,s,s,D.k7.ck(C.ap),"\ufd3f"+x+"\ufd3e"))
return A.ID(A.ek(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Y,C.bh)},
b4O(d){var x,w,v,u,t,s,r=this.w
if(C.c.O(d.c).length===0)return D.bC8
if(d.gt4()){x=r==null
if((x?null:r.a)===D.fb&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fb?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bm(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.CR(G.cL,C.bV,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gLW()
w=J.dF(x)
v=w.ir(x,new B.bTQ()).gM(0)
u=w.ir(x,new B.bTR()).gM(0)
t=w.ir(x,new B.bTS()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bm(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bm(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bm(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJ7().length!==0)x.push(E.bm(d.gJ7().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eJ:D.dU
x=C.b.aE(x," \u2022 ")
s=d.gJ7().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aE(d.gJ7(),"\u060c "):""
return new B.CR(w,C.na,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aH_(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jJ,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aJ(new A.aW(f,0,!1).dF(w).a,1e6)}v=C.j.aJ(B.c6p(B.Ec(j.gBl()).length).a,1e6)
f=j.gb21()
w=96+26*j.y
u=D.eJ.ae(0.25)
w=A.iB(i,A.a3W(C.P,A.D(i,D.apx,C.k,i,i,D.a6q,i,84,i,i,i,i,84),i,C.aR,new A.E(u,i,i,i,i,i,i,C.bZ),C.Ev,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cO)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c5l(x)+" / "+B.c5l(v),i,i,i,i,K.op,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aK,i,i,i),A.bd(D.btK,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.ep((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bm(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bm(t)+" \u062b)"
return new A.H(C.pP,A.I(A.a([C.vq,C.a2,D.blY,A.d(h,i,i,i,i,F.aK,C.Y,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.uD
r=j.r
f=r==null
w=!f
q=w&&r.gt4()
u=A.b3(s?D.xL:K.H0,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.eC(i,i,D.b73,i,i)
u=A.R(new A.zk(C.a3P,!0,new B.bTl(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Xi(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.IC[n]
p.push(new A.eg(m,i,A.d("\xd7"+E.bm(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.K,A.ov(new B.bTm(j),p,A.d6([h.b.b],o),!1,A.kc(i,i,i,new A.br(new B.bTn(),l),i,i,i,i,new A.br(new B.bTo(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cJ),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gaYM():i
u=A.b3(f?D.qo:C.na,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cD,i,i,i)
p=q?C.ii:C.v
h=A.a([o,C.u,A.ft(u,f,h,A.eC(p,q?C.i:C.ae,D.tA,i,i))],k)
if(w&&j.gj_()<j.a.e)C.b.A(h,A.a([C.B,q?A.ft(D.asK,D.bsv,new B.bTp(j),A.eC(G.cL,C.ae,D.tA,i,i)):A.bd(D.biZ,i,i,i,new B.bTq(j),i,i)],k))
if(w){f=j.gj_()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.H(C.ji,A.d(j.ga05()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,D.a1M,C.Y,i,i),i))
return A.I(h,C.ag,C.d,C.e,0,C.l)}}}
B.CR.prototype={
t(d){var x=this,w=null,v=x.c,u=v.ae(0.12),t=A.v(14),s=A.aH(v.ae(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b3(x.d,v,w,w),C.K,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bI(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.U,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bL,A.d(x.f,w,w,w,w,C.AS,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.E(u,w,s,t,w,w,w,C.n),w,w,C.aJ,C.ad,w,w,w)}}
B.Cz.prototype={
P(){var x=y.S
return new B.a1d($.LR(),A.C(x,y.B),A.aV(x),A.C(x,y.N),A.ed(null,y.H))}}
B.a1d.prototype={
X(){this.Y()
this.d.ac(this.goh())},
xs(){if(this.c!=null)this.k(new B.bT3())},
m(){var x,w=this,v=w.d
v.V(w.goh())
x=w.y
if(x!=null)x.aA()
v.a.a2s()
w.a1()},
HI(d){return this.b1O(d)},
b1O(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$HI=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.k(new B.bTc(t,d))
r=t.y
if(r!=null)r.aA()
t.y=A.hq(C.eO,new B.bTd(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c6p(B.Ec(H.LK(q,d,p.xD(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dh(0,0,0,350*B.Ec(H.LK(p,d,o.xD(p,d)).b).length,0,0)
x=6
return A.c(r.a.a8f(r.b.c,q,p,new B.bTe(t,d),new B.bTf(t)),$async$HI)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a9(m)
if(r instanceof B.lr){s=r
r=t.y
if(r!=null)r.aA()
if(t.c!=null)t.k(new B.bTg(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$HI,w)},
Fd(d,e){return this.aJU(d,e)},
aJU(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$Fd=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aA()
s.k(new B.bT7(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a8i()
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
s.k(new B.bT8(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bB(new B.bT9(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$Fd,w)},
gaUr(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aG(x)&&!v.n(0,x)&&!u.aG(x)&&x!==t.e)return x
return null},
aZB(){this.k(new B.bTa(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jJ,o=s.e,n=s.gaUr(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("cd<2>")
x=new A.am(new A.cd(m,l),new B.bTh(),l.i("am<Z.E>")).gM(0)
l=H.k8(s.a.c)
m=y.p
q=A.a([new B.GE(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bm(s.a.d)+" \u0644\u062d\u062f "+E.bm(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aK,r,r,r),C.u],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b3q(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.AL,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.CB(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bm(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aJ(new A.aW(v,0,!1).dF(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c5l(v),r,r,r,r,K.op,C.Y,r,r)
j=A.f5(A.v(6),A.pK(C.eK,D.eJ,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b3(u?P.GU:D.xL,r,r,r)
C.b.A(q,A.a([v,C.I,j,C.u,A.ft(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cD,r,r,r),new B.bTi(s,o),A.eC(C.v,C.ae,D.tA,r,r))],m))}else if(n!=null){j=p?new B.bTj(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bm(n)
q.push(A.ft(D.aqE,A.d(v,r,r,r,r,C.cD,r,r,r),j,A.eC(C.v,C.ae,D.tA,r,r)))}if(s.r.a!==0&&k)q.push(D.aTT)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cL:D.dU
v=k?C.n0:C.na
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bm(x)
u=s.a
u=k+" \u0645\u0646 "+E.bm(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.CR(j,v,k,u,r),A.dt(D.asx,D.bt8,s.gaZA(),r)],m))}q.push(C.u)
q.push(D.Bz)
return L.x9(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b3q(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.aq0
else if(l.r.n(0,d))x=N.tB
else if(i!=null)x=D.aqh
else if(j!=null){w=j.gt4()?C.bV:D.amx
x=A.b3(w,j.gt4()?G.cL:D.dU,k,k)}else x=D.aoD
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bm(d),k,k,k,k,D.bea,k,k,k),C.by,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.a1j,k,k,k))
if(j!=null&&!j.gt4()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gLW()
o=J.ba(p)
n=o.h(p,r)
A:{if(D.iS===n){m=G.cL
break A}if(D.un===n){m=D.dU
break A}if(D.uo===n){m=D.eJ
break A}m=C.eL
break A}m=D.k7.b8H(m,o.h(p,r)===D.up?C.k4:k,22)
C.b.A(t,A.a([new A.eX(q.a,k,k,C.bx,k,k,k,k,k,k,m),Q.AC],u))}w=A.a([C.aj,A.ID(A.ek(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Y,C.bh)],w)
if(C.c.O(j.c).length===0)w.push(D.boI)
C.b.A(v,w)}return new E.dx(A.I(v,C.ag,C.d,C.e,0,C.l),C.bI,C.db,k,!1,k)}}
B.Cy.prototype={
P(){return new B.a1c($.LR())}}
B.a1c.prototype={
X(){this.Y()
var x=this.d
x.ac(this.goh())
x.vj()},
xs(){if(this.c!=null)this.k(new B.bSV())},
m(){this.d.V(this.goh())
this.a1()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gaxf(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kN(o,0,new B.bT1(q))
v=C.b.kN(o,0,new B.bT2())
o=y.p
o=A.a([A.A(A.a([A.R(s.X3(E.bm(q.garE()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.K,A.R(s.X3(E.bm(q.aoe()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.K,A.R(s.X3(E.bm(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.u,new E.dx(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bm(C.f.aw(w*100/v))+"\u066a",r,r,r,r,C.bz,r,r,r),C.I,A.f5(A.v(6),A.pK(C.eK,G.cL,8,w/v,r),C.aC),C.aj,A.d(E.bm(w)+" \u0645\u0646 "+E.bm(v)+" \u0622\u064a\u0629",r,r,r,r,F.aK,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,r,!1,r)],o)
if(p.length===0)o.push(D.aU6)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.K)(p),++t)o.push(s.b3s(p[t]))
o.push(C.B)
u=$.B().b
u===$&&A.b()
u=u.ga3().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aK,r,r,r))
return L.x9(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
X3(d,e){var x=null
return new E.dx(A.I(A.a([A.d(d,x,x,x,x,D.bdT,x,x,x),A.d(e,x,x,x,x,C.a1Q,C.Y,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a4,C.L,x,!1,x)},
b3s(d){var x=null,w=this.d.c,v=I.cN[d-1].a[1],u=w.a5f(d),t=w.bdO(d),s=y.p,r=A.A(A.a([A.R(A.d(H.k8(d),x,x,x,x,C.bz,x,x,x),1),A.d(E.bm(C.f.aw(u*100/v))+"\u066a",x,x,x,x,D.bf0,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.f5(A.v(6),A.pK(C.eK,G.cL,7,u/v,x),C.aC),p=E.bm(u),o=E.bm(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bm(t):""
return new E.dx(A.I(A.a([r,C.I,q,C.aj,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aK,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,new B.bT0(this,d),!1,x)},
Nk(d){return this.aI3(d)},
aI3(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$Nk=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cN[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.eb(C.cK,new B.bT_(v,d,u),t,!0,null,null,!1,y.H),$async$Nk)
case 2:return A.h(null,w)}})
return A.i($async$Nk,w)}}
B.ahM.prototype={
QI(d,e){var x=null,w=A.na(x,x,x,x,x,x,x,x,x,x,x,D.b6C,C.L,x,x,x,x,C.lf,x,x)
return A.bd(A.d(d,x,x,x,x,C.lL,x,x,x),x,x,x,new B.b3h(e),x,w)},
t(d){var x=this,w=y.p
return new E.dx(A.I(A.a([D.bsh,C.I,D.btJ,A.d0(C.ax,A.a([x.QI("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.QI("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aF,0,12),D.bib,x.QI("tanzil.net","https://tanzil.net"),D.bvj,x.QI("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a4,C.aJ,null,!1,null)}}
B.CB.prototype={
P(){return new B.a1f()}}
B.a1f.prototype={
gakx(){var x=this.a
return B.cFF(x.c,x.d,$.c70().IQ())},
QK(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$QK=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.k(new B.bTY(s))
v=3
r=A.c0v()
n=s.gakx()
m=y.N
q=A.C(m,m)
J.dX(q,"app","mogtama3y")
J.dX(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dX(q,"ua",m)}x=6
return A.c(A.a8n(n,null,C.Fz,q),$async$QK)
case 6:if(s.c!=null)s.k(new B.bTZ(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a9(k)
o=p instanceof A.cm?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.k(new B.bU_(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.k(new B.bU0(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$QK,w)},
t(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bz(!1,t,!0,new A.H(C.pQ,A.A(A.a([A.b3(u.d?C.xB:C.n2,C.cw,t,18),C.bQ,D.buu],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bU2(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.D(t,A.wN(u.gakx(),D.bac,t,C.A),C.k,t,t,new A.E(C.pn,t,t,x,t,t,t,C.n),t,t,D.ahW,C.e8,t,t,1/0))}if(u.f)s.push(D.bit)
else{x=A.na(t,t,t,t,t,t,t,t,t,t,t,C.a_E,C.L,t,t,t,t,C.lf,t,t)
w=u.e
v=w?t:u.gb3r()
s.push(A.hp(w?C.a_S:D.arW,D.brf,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,D.a1j,t,t,t))
return new A.H(C.aJ,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["aj<~>()","~()","O(nh)","aj<IY>()","aj<IW>()","aj<IX>()","a7<nh>()","O(r4)","bE(on)","CA(t)","Cy(t)","O(mG)","Cz(t)","O(Hx)"])
B.b3i.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.a0(A.cV(b.G.document).baseURI)
q=A.bi(r,0,null).a2("quran_tutor/tutor.js?v=3").j(0)
x=7
return A.c(A.ez(import(q),y.m),$async$$0)
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
m=B.cv0("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:286}
B.b3l.prototype={
$1(d){var x=null
return A.bWx(A.cN(d,"persist",x,x,x,x))},
$S:1095}
B.b3k.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.qM(),$async$$0)
case 4:x=3
return A.c(n.ez(m.cV(l.cN(e,"loadModel",A.bXf(new B.b3j(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.u(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.u(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.qL(p,"ms")
r=q.o5(p,"cached")
A.u(p.backend)
v=new B.IW(o,t,s,r,q.qL(p,"threads"),q.o5(p,"isolated"),q.qL(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b3j.prototype={
$2(d,e){this.a.$2(C.f.aw(d),C.f.aw(e))},
$S:1096}
B.b3p.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t,s
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=v.a
s=t.a
x=s==null?2:3
break
case 2:x=4
return A.c(t.qM(),$async$$0)
case 4:s=e
case 3:u={}
u.maxMs=C.j.aJ(v.b.a,1000)
u.autoStop=v.c
u.minMs=C.j.aJ(v.d.a,1000)
u.onLevel=A.fN(new B.b3n(v.e))
u.onAutoStop=A.fN(new B.b3o(v.f))
x=5
return A.c(A.ez(A.cV(A.cN(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b3n.prototype={
$1(d){return this.a.$1(d)},
$S:61}
B.b3o.prototype={
$1(d){return this.a.$1(d)},
$S:6}
B.b3q.prototype={
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
return A.c(t.qM(),$async$$0)
case 7:x=5
break
case 6:e=s
case 5:x=3
return A.c(q.ez(p.cV(o.cN(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.IX(r,A.dT(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b3s.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.qM(),$async$$0)
case 4:x=3
return A.c(q.ez(p.cV(o.cN(e,"transcribe",t.audio,t.rate,s.ah_(u.c),null)),y.m),$async$$0)
case 3:v=r.akr(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b3r.prototype={
$0(){var x=0,w=A.j(y._),v,u=this,t,s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.qM(),$async$$0)
case 4:x=3
return A.c(r.ez(q.cV(p.cN(e,"transcribeUrl",u.b,t.ah_(u.c),null,null)),y.m),$async$$0)
case 3:v=s.akr(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b3m.prototype={
$1(d){return d},
$S:32}
B.aUA.prototype={
$0(){var x,w,v,u,t=this.a,s=A.ck(t.a.length,D.up,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aUz.prototype={
$1(d){return d===D.iS},
$S:z+2}
B.bWZ.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c1r(e[x],d[x])<0.75)return!1
return!0},
$S:1097}
B.bYZ.prototype={
$1(d){return d.length!==0},
$S:11}
B.b3w.prototype={
$1(d){return d.a===D.fb},
$S:z+7}
B.b3x.prototype={
$1(d){return C.j.aJ(d,1000)},
$S:66}
B.b3u.prototype={
$1(d){return C.f.c2(d)},
$S:1098}
B.b3y.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.jC("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.as.fB(r,null))
j=A.aL(k.h(0,"n"))
j=j==null?null:C.f.c2(j)
j=C.j.cU(j==null?2:j,1,5)
i=C.b.n(D.IC,k.h(0,"r"))?A.ex(k.h(0,"r")):1
h=A.em(k.h(0,"auto"))
g=A.em(k.h(0,"hide"))
k=A.em(k.h(0,"in"))
s.a.b=new B.Ut(j,i,h!==!1,g===!0,k===!0)}u=2
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
return A.c(A.jC("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.c4B(y.P.a(C.as.fB(q,null)))
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
return A.c(A.jC("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.as.fB(p,null))
n=C.f.c2(A.d3(J.av(o,"s")))
m=C.f.c2(A.d3(J.av(o,"f")))
l=C.f.c2(A.d3(J.av(o,"t")))
if(B.ciu(n,m)&&B.ciu(n,l)&&m<=l)s.a.z=new A.aQ(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a84()){k.a.ap2()
x=1
break}a1=k
x=18
return A.c(k.a.Me(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a6()
if(k.b.e)k.CM()
k.wk()
case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:110}
B.b3z.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a6()},
$S:1099}
B.b3A.prototype={
$2(d,e){return C.j.aJ(A.ey(A.n(d),null,null),1000)===this.a},
$S:1100}
B.bGo.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.E3(),$async$$1)
case 2:t=f
if(u.c!=null)u.k(new B.bGn(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1101}
B.bGn.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bGp.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bGm(x,d))},
$S:z+8}
B.bGm.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bGq.prototype={
$1(d){},
$S:23}
B.bGa.prototype={
$0(){},
$S:0}
B.bGg.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.CA(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bGh.prototype={
$0(){},
$S:0}
B.bGk.prototype={
$0(){var x=y.z
return A.N(this.a,!1).az(A.aA(new B.bGj(),null,x),x)},
$S:0}
B.bGj.prototype={
$1(d){return D.bwF},
$S:z+10}
B.bGl.prototype={
$0(){return B.cig(this.a)},
$S:0}
B.bGd.prototype={
$0(){var x=this.b
return this.a.xt(x.a,x.b,x.c)},
$S:0}
B.bGe.prototype={
$1(d){return this.a.k(new B.bGc())},
$S:6}
B.bGc.prototype={
$0(){},
$S:0}
B.bGf.prototype={
$0(){var x=this.a
return x.k(new B.bGb(x))},
$S:0}
B.bGb.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bGi.prototype={
$0(){return this.a.b3p(this.b)},
$S:0}
B.c0h.prototype={
$1(d){return new A.jv(new B.c0e(this.a,this.b,this.c),null)},
$S:59}
B.c0e.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c0g(u,e),s=this.a,r=new B.c0f(s,e),q=A.d(H.k8(this.c),v,v,v,v,C.ol,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bm(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aK,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bm(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bm(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.cU(w+4,1,u)))}u=A.a([q,C.aj,p,C.u,A.d0(C.ax,n,C.aF,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c09(s)),C.a_O,t.$3("\u0644\u062d\u062f",s.c,new B.c0a(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aTY)
u.push(C.a0)
u.push(A.dB(D.blq,new B.c0b(s,d),A.eC(C.v,C.ae,D.b70,v,v)))
return A.ct(!0,new A.H(C.F0,A.I(u,C.ag,C.d,C.N,0,C.l),v),C.L,!0)},
$S:381}
B.c0g.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.i2,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.cg(v,A.d("\u0622\u064a\u0629 "+E.bm(v),u,u,u,u,u,u,u,u),C.aw,u,w))
return A.R(A.I(A.a([t,S.Fk(C.cK,!0,s,320,new B.c0d(this.b,f),D.bfi,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1103}
B.c0d.prototype={
$1(d){return d==null?null:this.a.$1(new B.c0c(this.b,d))},
$S:48}
B.c0c.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c0f.prototype={
$3(d,e,f){var x=null
return A.c21(x,A.d(d,x,x,x,x,x,x,x,x),new B.c08(this.a,this.b,e,f))},
$S:1104}
B.c08.prototype={
$0(){var x=this
return x.b.$1(new B.c07(x.a,x.c,x.d))},
$S:0}
B.c07.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c09.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c0a.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c0b.prototype={
$0(){var x=this.a
return A.N(this.b,!1).aj(new A.W(x.b,x.c))},
$S:0}
B.bTk.prototype={
$0(){},
$S:0}
B.bTA.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.m3
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bTE.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.iZ:D.m3},
$S:0}
B.bTF.prototype={
$0(){var x=this.a
x.f=D.uD
x.as=null},
$S:0}
B.bTG.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bTI.prototype={
$0(){var x=this.a
x.f=D.uE
x.as=null
x.y=0
x.z=new A.aW(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bTJ.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bTH())},
$S:30}
B.bTH.prototype={
$0(){},
$S:0}
B.bTL.prototype={
$1(d){return this.a.y=d},
$S:61}
B.bTK.prototype={
$1(d){return this.a.Be()},
$S:6}
B.bTM.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.iZ:D.m3
x=this.b
w.as=B.LM(x)
w.at=x},
$S:0}
B.bTO.prototype={
$0(){var x=this.a
x.f=D.oM
x.ay=Date.now()},
$S:0}
B.bTP.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bTN())},
$S:30}
B.bTN.prototype={
$0(){},
$S:0}
B.bTz.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.iZ:D.m3
x.as=this.b
x.at=this.c},
$S:0}
B.bTB.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.iZ
x.x=!1},
$S:0}
B.bTs.prototype={
$0(){var x=this.a
x.f=D.oM
x.ay=Date.now()
x.as=null},
$S:0}
B.bTt.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bTr())},
$S:30}
B.bTr.prototype={
$0(){},
$S:0}
B.bTu.prototype={
$1(d){return d.d!==D.iS},
$S:z+11}
B.bTv.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bTU.prototype={
$0(){return B.cig(this.a)},
$S:0}
B.bTV.prototype={
$1(d){var x=this.a.d
return x.qm(x.b.anK(d))},
$S:3}
B.bTW.prototype={
$0(){var x=y.z
return A.N(this.b,!1).az(A.aA(new B.bTT(this.a),null,x),x)},
$S:0}
B.bTT.prototype={
$1(d){var x=this.a.a
return new B.Cz(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bTX.prototype={
$0(){this.a.d.a.bi2()
this.b.I(y.q).f.Z(D.b82)},
$S:0}
B.bTy.prototype={
$2(d,e){return C.b1},
$S:20}
B.bTx.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a5o(s.c,r).a.a){case 2:s=G.cL
break
case 1:s=D.dU
break
case 0:s=C.ii
break
default:s=u}x=A.v(18)
w=t.f===D.oM?u:new B.bTw(t,r)
v=s.ae(0.25)
if(r===t.gj_())s=C.i
s=A.aH(s,r===t.gj_()?2:1)
return A.bz(!1,x,!0,A.D(C.P,A.d(E.bm(r),u,u,u,u,C.a0Z,u,u,u),C.k,u,u,new A.E(v,u,s,u,u,u,u,C.bZ),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:63}
B.bTw.prototype={
$0(){return this.a.Zc(this.b)},
$S:0}
B.bTD.prototype={
$0(){var x=this.a
return x.k(new B.bTC(x))},
$S:0}
B.bTC.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bTQ.prototype={
$1(d){return d===D.un},
$S:z+2}
B.bTR.prototype={
$1(d){return d===D.uo},
$S:z+2}
B.bTS.prototype={
$1(d){return d===D.up},
$S:z+2}
B.bTl.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.QJ(x)},
$S:0}
B.bTm.prototype={
$1(d){var x=this.a.d
return x.qm(x.b.b88(d.ga4(d)))},
$S:118}
B.bTo.prototype={
$1(d){return d.n(0,C.a3)?C.ae:C.i},
$S:4}
B.bTn.prototype={
$1(d){return d.n(0,C.a3)?C.v:C.a8},
$S:4}
B.bTp.prototype={
$0(){var x=this.a
return x.Zc(x.gj_()+1)},
$S:0}
B.bTq.prototype={
$0(){var x=this.a
return x.Zc(x.gj_()+1)},
$S:0}
B.bT3.prototype={
$0(){},
$S:0}
B.bTc.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aW(Date.now(),0,!1)},
$S:0}
B.bTd.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bTb())},
$S:30}
B.bTb.prototype={
$0(){},
$S:0}
B.bTf.prototype={
$1(d){return this.a.x=d},
$S:61}
B.bTe.prototype={
$1(d){return this.a.Fd(this.b,!1)},
$S:6}
B.bTg.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.LM(x)
w.as=x},
$S:0}
B.bT7.prototype={
$0(){var x=this.a
x.e=null
x.r.F(0,this.b)},
$S:0}
B.bT8.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.q(0,v,B.LM(x))
w.as=x},
$S:0}
B.bT9.prototype={
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
return A.c(n.a.atB(s.b,B.Ec(H.LK(l,m,k.xD(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cgz(H.LK(l,m,k.xD(l,m)).b,r.a)
if(C.c.O(q.c).length!==0){l=n.c
k=o.a.c
j=q.gt4()
l.asF(k,m,n.b.a,j)}n.zl()
if(o.c!=null)o.k(new B.bT4(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a9(h)
if(o instanceof B.lr){p=o
o=s.a
if(o.c!=null)o.k(new B.bT5(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.k(new B.bT6(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:147}
B.bT4.prototype={
$0(){var x=this.c
this.a.f.q(0,this.b,x)
return x},
$S:0}
B.bT5.prototype={
$0(){var x=this.a,w=this.c
x.w.q(0,this.b,B.LM(w))
x.as=w},
$S:0}
B.bT6.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bTa.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)
x.as=null},
$S:0}
B.bTh.prototype={
$1(d){return d.gt4()},
$S:z+13}
B.bTi.prototype={
$0(){return this.a.Fd(this.b,!0)},
$S:0}
B.bTj.prototype={
$0(){return this.a.HI(this.b)},
$S:0}
B.bSV.prototype={
$0(){},
$S:0}
B.bT1.prototype={
$2(d,e){return d+this.a.a5f(e)},
$S:117}
B.bT2.prototype={
$2(d,e){return d+I.cN[e-1].a[1]},
$S:117}
B.bT0.prototype={
$0(){return this.a.Nk(this.b)},
$S:0}
B.bT_.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.k8(p),q,q,q,q,C.ol,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.b8(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.qT():r).a.a){case 2:r=G.cL.ae(0.35)
break
case 1:r=D.dU.ae(0.35)
break
case 0:r=C.fQ
break
default:r=q}m.push(A.D(C.P,A.d(E.bm(t),q,q,q,q,C.lG,q,q,q),C.k,q,q,new A.E(r,q,q,new A.cv(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.ct(!0,new A.H(C.fW,A.I(A.a([o,C.aj,D.bpC,C.u,new A.dw(D.a6i,A.f8(A.d0(C.ax,m,C.aF,6,6),q,C.r,q,q,q,C.w),q),C.a2,A.bd(D.brj,q,q,q,new B.bSZ(w,d,p),q,q)],n),C.ag,C.d,C.N,0,C.l),q),C.L,!0)},
$S:36}
B.bSZ.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dp(null,null,!0,null,new B.bSY(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Kz(t),$async$$0)
case 5:if(u.e!=null)A.N(u,!1).dY()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.bSY.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.k8(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dv(A.a([A.bd(C.en,x,x,x,new B.bSW(d),x,x),A.bd(C.oz,x,x,x,new B.bSX(d),x,x)],y.p),w,D.bsR)},
$S:14}
B.bSW.prototype={
$0(){A.N(this.a,!1).aj(!1)
return null},
$S:0}
B.bSX.prototype={
$0(){A.N(this.a,!1).aj(!0)
return null},
$S:0}
B.c14.prototype={
$1(d){var x=this.a
return new A.km(new B.c13(x),null,x,null)},
$S:1105}
B.c13.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.eg(w,t,A.d(E.bm(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bi6,C.a2,D.brK,C.I,A.ov(new B.c0Z(s,r),q,A.d6([r.a],x),!1,A.kc(t,t,t,new A.br(new B.c1_(),v),t,t,t,t,new A.br(new B.c10(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.ie(C.v,C.L,t,new B.c11(s,r),D.boT,D.buN,r.c),A.ie(C.v,C.L,t,new B.c12(s,r),t,D.bhF,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.aj,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gmJ(),t,t,t,t,F.aK,t,C.bh,t)],u))
x.push(C.B)
x.push(D.a2Y)
return A.ct(!0,A.f8(A.I(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.fW,t,t,C.w),C.L,!0)},
$S:1106}
B.c0Z.prototype={
$1(d){return this.a.qm(this.b.b85(d.ga4(d)))},
$S:118}
B.c10.prototype={
$1(d){return d.n(0,C.a3)?C.ae:C.i},
$S:4}
B.c1_.prototype={
$1(d){return d.n(0,C.a3)?C.v:C.a8},
$S:4}
B.c11.prototype={
$1(d){return this.a.qm(this.b.b7s(d))},
$S:3}
B.c12.prototype={
$1(d){return this.a.qm(this.b.anK(d))},
$S:3}
B.b3h.prototype={
$0(){return A.cz(A.bi(this.a,0,null),C.aT,null)},
$S:0}
B.c1k.prototype={
$1(d){var x,w=A.ax("https?://",!0,!1,!1)
w=A.bB(d,w,"")
x=A.ax("www\\.",!0,!1,!1)
return A.uy(A.bB(w,x,"www[.]"),A.ax("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c1l(),null)},
$S:32}
B.c1l.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:54}
B.bTY.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bTZ.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bU_.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bU0.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bU2.prototype={
$0(){var x=this.a
return x.k(new B.bU1(x))},
$S:0}
B.bU1.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c1j.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:158};(function installTearOffs(){var x=a._instance_0u
x(B.ahN.prototype,"gbdP","bdQ",1)
var w
x(w=B.Uu.prototype,"gbe5","CM",0)
x(w,"gaCc","wk",0)
x(w=B.ZR.prototype,"goh","xs",1)
x(w,"gaWe","Pf",0)
x(w=B.a1e.prototype,"goh","xs",1)
x(w,"gaYM","PB",0)
x(w,"gb21","Be",0)
x(w,"gaHJ","Nh",0)
x(w=B.a1d.prototype,"goh","xs",1)
x(w,"gaZA","aZB",1)
x(B.a1c.prototype,"goh","xs",1)
x(B.a1f.prototype,"gb3r","QK",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a5,[B.ahN,B.Uv,B.IW,B.IY,B.IX,B.lr,B.RA,B.mG,B.Hx,B.r4,B.ahO,B.Ut])
x(A.kY,[B.b3i,B.b3k,B.b3p,B.b3q,B.b3s,B.b3r,B.aUA,B.b3y,B.bGn,B.bGm,B.bGa,B.bGh,B.bGk,B.bGl,B.bGd,B.bGc,B.bGf,B.bGb,B.bGi,B.c0c,B.c08,B.c07,B.c0b,B.bTk,B.bTA,B.bTE,B.bTF,B.bTG,B.bTI,B.bTH,B.bTM,B.bTO,B.bTN,B.bTz,B.bTB,B.bTs,B.bTr,B.bTv,B.bTU,B.bTW,B.bTX,B.bTw,B.bTD,B.bTC,B.bTl,B.bTp,B.bTq,B.bT3,B.bTc,B.bTb,B.bTg,B.bT7,B.bT8,B.bT4,B.bT5,B.bT6,B.bTa,B.bTi,B.bTj,B.bSV,B.bT0,B.bSZ,B.bSW,B.bSX,B.b3h,B.bTY,B.bTZ,B.bU_,B.bU0,B.bU2,B.bU1])
x(A.is,[B.b3l,B.b3n,B.b3o,B.b3m,B.aUz,B.bYZ,B.b3w,B.b3x,B.b3u,B.bGo,B.bGp,B.bGq,B.bGg,B.bGj,B.bGe,B.c0h,B.c0g,B.c0d,B.c0f,B.c09,B.c0a,B.bTJ,B.bTL,B.bTK,B.bTP,B.bTt,B.bTu,B.bTV,B.bTT,B.bTQ,B.bTR,B.bTS,B.bTm,B.bTo,B.bTn,B.bTd,B.bTf,B.bTe,B.bT9,B.bTh,B.bT_,B.bSY,B.c14,B.c0Z,B.c10,B.c1_,B.c11,B.c12,B.c1k,B.c1l,B.c1j])
x(A.pj,[B.b3j,B.bWZ,B.b3z,B.b3A,B.c0e,B.bTy,B.bTx,B.bT1,B.bT2,B.c13])
x(A.JO,[B.nh,B.Eu,B.GD,B.Dw])
w(B.Uu,A.i7)
x(A.L,[B.wr,B.CA,B.Cz,B.Cy,B.CB])
x(A.M,[B.ZR,B.a1e,B.a1d,B.a1c,B.a1f])
x(A.a3,[B.GE,B.WI,B.CR,B.ahM])})()
A.p_(b.typeUniverse,JSON.parse('{"lr":{"bN":[]},"CA":{"L":[],"l":[]},"Cz":{"L":[],"l":[]},"Cy":{"L":[],"l":[]},"CB":{"L":[],"l":[]},"Uu":{"aC":[]},"wr":{"L":[],"l":[]},"ZR":{"M":["wr"]},"GE":{"a3":[],"l":[]},"WI":{"a3":[],"l":[]},"a1e":{"M":["CA"]},"CR":{"a3":[],"l":[]},"a1d":{"M":["Cz"]},"a1c":{"M":["Cy"]},"ahM":{"a3":[],"l":[]},"a1f":{"M":["CB"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("r4"),c:x("eg<x>"),r:x("cg<x>"),k:x("F<mG>"),n:x("F<eg<x>>"),I:x("F<cg<x>>"),R:x("F<hC>"),Z:x("F<aP<o,@>>"),d:x("F<RA>"),s:x("F<o>"),p:x("F<l>"),t:x("F<x>"),m:x("bM"),j:x("a7<@>"),L:x("a7<x>"),P:x("aP<o,@>"),f:x("aP<@,@>"),x:x("au<o,x>"),a:x("bE"),K:x("a5"),B:x("Hx"),l:x("+(x,x)"),e:x("d8<mG>"),N:x("o"),C:x("IW"),D:x("IX"),X:x("Uv"),_:x("IY"),U:x("am<o>"),G:x("nh"),q:x("oX"),b:x("br<U?>"),y:x("O"),i:x("a2"),z:x("@"),S:x("x"),A:x("bM?"),Y:x("aP<@,@>?"),O:x("a5?"),M:x("+quota,usage(x,x)?"),o:x("fm"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.oV=new B.Eu(0,"none")
D.oW=new B.Eu(1,"learning")
D.fb=new B.Eu(2,"memorized")
D.a6i=new A.aB(0,1/0,0,320)
D.eJ=new A.U(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a6q=new A.E(D.eJ,null,null,null,null,null,null,C.bZ)
D.dU=new A.U(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.arc=new A.G(C.GZ,null,C.cw,null,null,null)
D.bsZ=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.f3,null,null,null,null,null,null,null,null)
D.baF=new A.r(!0,C.eL,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bpE=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.baF,null,null,null,null,null,null,null,null)
D.aHX=x([D.arc,C.I,D.bsZ,D.bpE],y.p)
D.aet=new A.fb(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aHX,null)
D.ahT=new A.X(0,26,0,26)
D.ahW=new A.X(0,4,0,6)
D.aij=new A.X(14,12,14,14)
D.aj_=new A.X(3,0,0,0)
D.amx=new A.Q(63251,"MaterialIcons",null,!1)
D.qo=new A.Q(63677,"MaterialIcons",null,!1)
D.xL=new A.Q(983516,"MaterialIcons",null,!1)
D.anm=new A.Q(983209,"MaterialIcons",null,!1)
D.ao0=new A.G(D.anm,28,C.v,null,null,null)
D.aoD=new A.G(C.GD,null,C.ii,null,null,null)
D.amg=new A.Q(62961,"MaterialIcons",null,!1)
D.apk=new A.G(D.amg,null,null,null,null,null)
D.amw=new A.Q(63199,"MaterialIcons",null,!1)
D.apl=new A.G(D.amw,null,null,null,null,null)
D.apu=new A.G(C.kS,null,C.eL,null,null,null)
D.apx=new A.G(D.xL,44,C.i,null,null,null)
D.aq0=new A.G(D.qo,null,D.eJ,null,null,null)
D.aqh=new A.G(C.n1,null,D.eJ,null,null,null)
D.aqE=new A.G(D.qo,null,null,null,null,null)
D.ar8=new A.G(C.jq,20,D.dU,null,null,null)
D.aru=new A.G(C.n8,30,C.v,null,null,null)
D.arW=new A.G(C.kW,16,C.v,null,null,null)
D.amR=new A.Q(63520,"MaterialIcons",null,!1)
D.asm=new A.G(D.amR,null,null,null,null,null)
D.asx=new A.G(C.na,null,null,null,null,null)
D.am7=new A.Q(62842,"MaterialIcons",null,!0)
D.asK=new A.G(D.am7,null,null,null,null,null)
D.IC=x([1,3,5],y.t)
D.Jo=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aUy=new A.H(C.mS,C.mh,null)
D.aEQ=x([D.aUy],y.p)
D.aZ0=new A.W(C.n4,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.aYP=new A.W(D.qo,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.aZl=new A.W(C.dv,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.an5=new A.Q(63625,"MaterialIcons",null,!1)
D.aZy=new A.W(D.an5,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aGV=x([D.aZ0,D.aYP,D.aZl,D.aZy],A.ae("F<+(Q,o)>"))
D.aJg=x([D.oV,D.oW,D.fb],A.ae("F<Eu>"))
D.O1=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aQD=new B.GD(0,"idle")
D.Uc=new B.GD(1,"loading")
D.jJ=new B.GD(2,"ready")
D.aQE=new B.GD(3,"failed")
D.apZ=new A.G(C.bV,18,G.cL,null,null,null)
D.a1M=new A.r(!0,C.ap,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.btW=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,D.a1M,null,null,null,null,null,null,null,null)
D.aDI=x([D.apZ,C.b1,D.btW],y.p)
D.b4u=new A.er(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aDI,null)
D.aTu=new A.H(C.aJ,D.b4u,null)
D.aiY=new A.X(2,6,2,4)
D.bal=new A.r(!0,C.v,null,null,null,null,14,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bi4=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bal,null,null,null,null,null,null,null,null)
D.aTJ=new A.H(D.aiY,D.bi4,null)
D.buk=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.f3,null,null,null,null,null,null,null,null)
D.aF9=x([N.tB,C.K,D.buk],y.p)
D.b4p=new A.er(C.af,C.cn,C.e,C.h,null,C.l,null,0,D.aF9,null)
D.aTT=new A.H(C.pM,D.b4p,null)
D.AZ=new A.r(!0,D.dU,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.buF=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.AZ,null,null,null,null,null,null,null,null)
D.aTY=new A.H(C.dV,D.buF,null)
D.btR=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aK,C.Y,null,null,null,null,null,null,null)
D.aU6=new A.H(C.C,D.btR,null)
D.aiV=new A.X(2,0,2,8)
D.bpU=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aK,null,null,null,null,null,null,null,null)
D.aUp=new A.H(D.aiV,D.bpU,null)
D.as5=new A.G(C.kU,30,C.v,null,null,null)
D.bvk=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.B_,null,null,null,null,null,null,null,null)
D.ak4=new A.bU(1,C.ac,D.bvk,null)
D.aFo=x([D.as5,C.W,D.ak4],y.p)
D.b4c=new A.er(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aFo,null)
D.arG=new A.G(C.dv,18,G.cL,null,null,null)
D.a18=new A.r(!0,G.cL,null,null,null,null,12,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.btz=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a18,null,null,null,null,null,null,null,null)
D.aE8=x([D.arG,C.bQ,D.btz],y.p)
D.b4n=new A.er(C.af,C.d,C.N,C.h,null,C.l,null,0,D.aE8,null)
D.b6C=new A.T(0,30)
D.tA=new A.T(1/0,54)
D.b70=new A.T(1/0,48)
D.b73=new A.T(1/0,50)
D.b76=new A.T(1/0,52)
D.brt=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.b82=new A.d9(D.brt,null,null,null,null,null,null,null,null,null,null,null,null,C.y,!1,null,null,null,C.m,null)
D.b9Q=new A.r(!0,C.i,null,null,null,null,14.5,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bac=new A.r(!0,C.ap,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.AL=new A.r(!0,D.eJ,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.k7=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a1j=new A.r(!0,D.eJ,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bdT=new A.r(!0,C.v,null,null,null,null,24,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bea=new A.r(!0,C.v,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bf_=new A.r(!0,D.dU,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bf0=new A.r(!0,G.cL,null,null,null,null,null,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bfi=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgW=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.i2,null,null,null,null,null,null,null,null)
D.bhF=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.dl,null,null,null,null,null,null,null,null)
D.bi6=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.ol,null,null,null,null,null,null,null,null)
D.bib=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aK,null,null,null,null,null,null,null,null)
D.bbw=new A.r(!0,G.cL,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bit=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bbw,null,null,null,null,null,null,null,null)
D.biB=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aK,null,null,null,null,null,null,null,null)
D.biZ=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.f3,null,null,null,null,null,null,null,null)
D.bkH=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cD,null,null,null,null,null,null,null,null)
D.blq=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bN,null,null,null,null,null,null,null,null)
D.blv=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aK,null,null,null,null,null,null,null,null)
D.blY=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.B3,null,null,null,null,null,null,null,null)
D.bna=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bnL=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.op,null,null,null,null,null,null,null,null)
D.bou=new A.m("reset safe mode / WebGPU ban",null,P.a0G,null,null,null,null,null,null,null,null)
D.boI=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.AZ,null,null,null,null,null,null,null,null)
D.boT=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aK,null,null,null,null,null,null,null,null)
D.bpj=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bz,null,null,null,null,null,null,null,null)
D.bpC=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.bpV=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aK,null,null,null,null,null,null,null,null)
D.brf=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a1I,null,null,null,null,null,null,null,null)
D.bd8=new A.r(!0,D.eJ,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.brj=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bd8,null,null,null,null,null,null,null,null)
D.brK=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.op,null,null,null,null,null,null,null,null)
D.bsh=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0y,null,null,null,null,null,null,null,null)
D.bsv=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cD,null,null,null,null,null,null,null,null)
D.bsR=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bt8=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.btJ=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aK,null,null,null,null,null,null,null,null)
D.btK=new A.m("\u062e\u0644\u0635\u062a",null,O.or,null,null,null,null,null,null,null,null)
D.btL=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.AZ,null,null,null,null,null,null,null,null)
D.bec=new A.r(!0,C.cF,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.hZ,null,null,null,null,null,null,null,null)
D.buu=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bec,null,null,null,null,null,null,null,null)
D.buJ=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bz,null,null,null,null,null,null,null,null)
D.buN=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.dl,null,null,null,null,null,null,null,null)
D.bvj=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aK,null,null,null,null,null,null,null,null)
D.a2Y=new B.ahM(null)
D.bwF=new B.Cy(null)
D.bwG=new B.Ut(2,1,!0,!1,!1)
D.a32=new B.Uv(!1,!1,!1,!1,!1,0)
D.iS=new B.nh(0,"ok")
D.un=new B.nh(1,"near")
D.uo=new B.nh(2,"wrong")
D.up=new B.nh(3,"missing")
D.a3u=new B.nh(4,"extra")
D.amM=new A.Q(63456,"MaterialIcons",null,!1)
D.bC8=new B.CR(D.dU,D.amM,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bCM=new B.WI(!1,null)
D.Bz=new B.WI(!0,null)
D.m3=new B.Dw(0,"idle")
D.uD=new B.Dw(1,"playing")
D.uE=new B.Dw(2,"recording")
D.oM=new B.Dw(3,"thinking")
D.iZ=new B.Dw(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cIC","c70",()=>new B.ahN())
x($,"cLX","cma",()=>A.ax("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cLY","cmb",()=>A.ax("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cM9","cmk",()=>A.ax("\u0648\u0670",!0,!1,!1))
x($,"cLv","clR",()=>A.ax("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cJO","ckG",()=>A.ax("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cL1","clt",()=>A.ax("[\u0654\u0655]",!0,!1,!1))
x($,"cJP","ckH",()=>A.ax("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cJW","ckN",()=>A.ax("[\u0624\u0626]",!0,!1,!1))
x($,"cL3","clv",()=>A.ax("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cLA","clU",()=>A.ax("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cLb","clC",()=>A.ax("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cLV","c7A",()=>A.ax("\\s+",!0,!1,!1))
x($,"cFV","qT",()=>B.cn9(D.oV,0,A.c2A(0,!0)))
x($,"cID","LR",()=>new B.Uu($.c70(),D.bwG,B.cv1(),D.aQD,$.S()))})()};
(a=>{a["Uu6TKn8Yj1vJVWeuu7cDj7lv6KY="]=a.current})($__dart_deferred_initializers__);