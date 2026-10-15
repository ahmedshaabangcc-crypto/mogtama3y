((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,L,M,Q,H,G,N,R,K,B={
cze(d){var x,w,v,u,t,s
if(d instanceof B.lE)return d
try{x=A.d3(d)
w=x.code
v=x.message
u=w==null?"failed":A.Y(w)
t=v==null?"":A.Y(v)
return new B.lE(u,t)}catch(s){u=A.n(d)
return new B.lE("failed",u)}},
aj4:function aj4(){this.b=this.a=null},
b50:function b50(d){this.a=d},
b53:function b53(){},
b52:function b52(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b51:function b51(d){this.a=d},
b57:function b57(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b55:function b55(d){this.a=d},
b56:function b56(d){this.a=d},
b58:function b58(d){this.a=d},
b5a:function b5a(d,e,f){this.a=d
this.b=e
this.c=f},
b59:function b59(d,e,f){this.a=d
this.b=e
this.c=f},
b54:function b54(){},
czf(d,e){return new B.lE(d,e)},
Vr:function Vr(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
JF:function JF(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
JH:function JH(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
JG:function JG(d,e){this.a=d
this.b=e},
lE:function lE(d,e){this.a=d
this.b=e},
clD(d){var x,w=$.cqk()
w=A.bD(d,w,"\u0627")
x=$.cql()
w=A.bD(w,x,"\u064a")
x=$.cqu()
w=A.bD(w,x,"\u0627")
x=$.coQ()
w=A.bD(w,x,"\u0627")
x=$.cq0()
w=A.bD(w,x,"\u0621")
x=$.cpD()
w=A.bD(w,x,"\u0621")
x=$.coR()
w=A.bD(w,x,"\u0627")
x=$.coX()
w=A.bD(w,x,"\u0621")
w=A.bD(w,"\u0649","\u064a")
w=A.bD(w,"\u0629","\u0647")
x=$.cpF()
w=A.bD(w,x,"")
x=$.cq3()
w=A.bD(w,x," ")
x=$.cpM()
w=A.bD(w,x," ")
x=$.cbh()
return C.c.P(A.bD(w,x," "))},
cDW(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
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
c5a(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aD("[\u0627\u0621]",!0,!1,!1)
w=A.bD(d,x,"")
x=A.aD("[\u0627\u0621]",!0,!1,!1)
v=A.bD(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cDW(d,e)/u
return s>=1?0.99:s},
EQ(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tY(d,$.cbh()),w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.length===0)continue
t=B.clD(u)
s=A.bD(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Sy(r.a+" "+u,r.b))}continue}q.push(new B.Sy(u,s))}return q},
cCB(d,e){var x,w,v,u,t=new B.c_o(),s=A.a([],y.s)
for(x=A.fu(e,0,A.ih(5,"count",y.S),A.al(e).c),w=x.$ti,x=new A.ca(x,x.gM(0),w.i("ca<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.JX)&&t.$2(d,D.JX)?C.b.jy(d,5):d
return!t.$2(s,D.OA)&&t.$2(u,D.OA)?C.b.jy(u,4):u},
ckz(d,e){var x=B.EQ(d),w=B.clD(e),v=y.U
v=A.aa(new A.ak(A.a(w.split(" "),y.s),new B.c1u(),v),v.i("a_.E"))
return new B.Ij(x,B.cBM(x,B.cCB(v,x)),w)},
cBM(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.L)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.cn(x,0,!1,s)
q=A.cn(x,0,!1,y.S)
p=A.cn(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c5a(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c5a(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c5a(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
a1.push(new B.mV(null,null,a6[n],D.a3S))
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
a4=A.aa(new A.d8(a1,a4),a4.i("aW.E"))
return a4},
nA:function nA(d,e){this.a=d
this.b=e},
Sy:function Sy(d,e){this.a=d
this.b=e},
mV:function mV(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Ij:function Ij(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aWg:function aWg(d){this.a=d},
aWf:function aWf(){},
c_o:function c_o(){},
c1u:function c1u(){},
crj(d,e,f){return new B.rq(d,e,f)},
cER(d){var x
A:{if("memorized"===d){x=D.fg
break A}if("learning"===d){x=D.p8
break A}x=D.p7
break A}return x},
cmC(d,e){return d>=1&&d<=114&&e>=1&&e<=I.cO[d-1].a[1]},
czg(){var x=y.S
return new B.aj5(A.B(x,y.u),A.aS(x))},
b5d(d){var x=d.ff()
return C.c.dq(C.j.k(A.bq(x)),4,"0")+"-"+C.c.dq(C.j.k(A.bt(x)),2,"0")+"-"+C.c.dq(C.j.k(A.bW(x)),2,"0")},
cht(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cGg(),x),x.i("aW.E"))
return B.b5d(A.dr(w[0],w[1],w[2]-1,12,0,0,0))},
c8i(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.B(p,y.u),n=A.aS(p),m=new B.aj5(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcN(),x=x.ga_(x),w=y.j;x.v();){v=x.gI()
u=A.dT(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aQ(t)>=3){v=C.j.aH(u,1000)
s=C.j.a2(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=I.cO[v-1].a[1])}if(v)continue
v=J.bg(t)
r=C.f.bW(A.cS(v.h(t,0)))
if(r<0||r>=3)continue
o.p(0,u,new B.rq(D.aKG[r],C.f.bW(A.cS(v.h(t,1))),new A.aR(A.ks(C.f.bW(A.cS(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.aAm(q,y.o)
p=A.mp(x,new B.b5c(),x.$ti.i("a_.E"),p)
n.A(0,new A.ak(p,o.ga3F(),A.y(p).i("ak<a_.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aE(d.h(0,"streak"))
p=p==null?null:C.f.bW(p)
p=m.d=p==null?0:p
o=A.aE(d.h(0,"best"))
o=o==null?null:C.f.bW(o)
m.e=o==null?p:o
return m},
azF(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.dq(C.j.k(d),3,"0")+C.c.dq(C.j.k(e),3,"0")+".mp3"},
F8:function F8(d,e){this.a=d
this.b=e},
rq:function rq(d,e,f){this.a=d
this.b=e
this.c=f},
aj5:function aj5(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b5e:function b5e(){},
b5f:function b5f(){},
b5c:function b5c(){},
Vp:function Vp(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
cwL(){return new B.wS(null)},
cIG(d,e){var x,w,v,u,t={},s=I.cO[e-1].a[1],r=$.MJ().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.rf():v).a===D.fg}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.d1(u+4,1,s)
return A.e2(C.cL,new B.c40(t,s,e),d,!0,null,null,!1,y.l)},
ca3(d){return A.dn(0,0,0,0,0,C.j.d1(C.f.ak(6+d*1.2),25,90))},
c9_(d){return E.bp(C.j.aH(d,60))+":"+C.c.dq(E.bp(C.j.a2(d,60)),2,"\u0660")},
cmo(d){return A.e2(C.cL,new B.c4P($.MJ()),d,!0,null,null,!1,y.H)},
MC(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gl2()
break A}return x},
cK0(d,e,f){var x,w=new B.c54(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
cmx(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.ap.fb(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.f3:r
q=s.a(J.av(x,"last"))
v=q==null?C.f3:q
u=new B.c53()
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
Hj:function Hj(d,e){this.a=d
this.b=e},
Vq:function Vq(d,e,f,g,h){var _=this
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
b5g:function b5g(d){this.a=d},
b5h:function b5h(d){this.a=d},
b5i:function b5i(d){this.a=d},
wS:function wS(d){this.a=d},
a_S:function a_S(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bJh:function bJh(d){this.a=d},
bJg:function bJg(d,e){this.a=d
this.b=e},
bJi:function bJi(d){this.a=d},
bJf:function bJf(d,e){this.a=d
this.b=e},
bJj:function bJj(){},
bJ3:function bJ3(){},
bJ9:function bJ9(d,e,f){this.a=d
this.b=e
this.c=f},
bJa:function bJa(){},
bJd:function bJd(d){this.a=d},
bJc:function bJc(){},
bJe:function bJe(d){this.a=d},
bJ6:function bJ6(d,e){this.a=d
this.b=e},
bJ7:function bJ7(d){this.a=d},
bJ5:function bJ5(){},
bJ8:function bJ8(d){this.a=d},
bJ4:function bJ4(d){this.a=d},
bJb:function bJb(d,e){this.a=d
this.b=e},
Hk:function Hk(d,e,f){this.c=d
this.d=e
this.a=f},
XI:function XI(d,e){this.c=d
this.a=e},
c40:function c40(d,e,f){this.a=d
this.b=e
this.c=f},
c3Y:function c3Y(d,e,f){this.a=d
this.b=e
this.c=f},
c4_:function c4_(d,e){this.a=d
this.b=e},
c3X:function c3X(d,e){this.a=d
this.b=e},
c3W:function c3W(d,e){this.a=d
this.b=e},
c3Z:function c3Z(d,e){this.a=d
this.b=e},
c3S:function c3S(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c3R:function c3R(d,e,f){this.a=d
this.b=e
this.c=f},
c3T:function c3T(d){this.a=d},
c3U:function c3U(d){this.a=d},
c3V:function c3V(d,e){this.a=d
this.b=e},
E7:function E7(d,e){this.a=d
this.b=e},
D7:function D7(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2k:function a2k(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bWI:function bWI(){},
bWY:function bWY(d,e){this.a=d
this.b=e},
bX1:function bX1(d){this.a=d},
bX2:function bX2(d){this.a=d},
bX3:function bX3(d,e,f){this.a=d
this.b=e
this.c=f},
bX5:function bX5(d){this.a=d},
bX6:function bX6(d){this.a=d},
bX4:function bX4(){},
bX8:function bX8(d){this.a=d},
bX7:function bX7(d){this.a=d},
bX9:function bX9(d,e){this.a=d
this.b=e},
bXb:function bXb(d){this.a=d},
bXc:function bXc(d){this.a=d},
bXa:function bXa(){},
bWX:function bWX(d,e,f){this.a=d
this.b=e
this.c=f},
bWZ:function bWZ(d,e,f){this.a=d
this.b=e
this.c=f},
bWQ:function bWQ(d){this.a=d},
bWR:function bWR(d){this.a=d},
bWP:function bWP(){},
bWS:function bWS(){},
bWT:function bWT(d,e){this.a=d
this.b=e},
bXh:function bXh(d){this.a=d},
bXi:function bXi(d){this.a=d},
bXj:function bXj(d,e){this.a=d
this.b=e},
bXg:function bXg(d){this.a=d},
bXk:function bXk(d,e){this.a=d
this.b=e},
bWW:function bWW(){},
bWV:function bWV(d){this.a=d},
bWU:function bWU(d,e){this.a=d
this.b=e},
bX0:function bX0(d){this.a=d},
bX_:function bX_(d){this.a=d},
bXd:function bXd(){},
bXe:function bXe(){},
bXf:function bXf(){},
bWJ:function bWJ(d,e,f){this.a=d
this.b=e
this.c=f},
bWK:function bWK(d){this.a=d},
bWM:function bWM(){},
bWL:function bWL(){},
bWN:function bWN(d){this.a=d},
bWO:function bWO(d){this.a=d},
Dq:function Dq(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
D6:function D6(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a2j:function a2j(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bWr:function bWr(){},
bWA:function bWA(d,e){this.a=d
this.b=e},
bWB:function bWB(d){this.a=d},
bWz:function bWz(){},
bWD:function bWD(d){this.a=d},
bWC:function bWC(d,e){this.a=d
this.b=e},
bWE:function bWE(d,e){this.a=d
this.b=e},
bWv:function bWv(d,e){this.a=d
this.b=e},
bWw:function bWw(d,e,f){this.a=d
this.b=e
this.c=f},
bWx:function bWx(d,e,f){this.a=d
this.b=e
this.c=f},
bWs:function bWs(d,e,f){this.a=d
this.b=e
this.c=f},
bWt:function bWt(d,e,f){this.a=d
this.b=e
this.c=f},
bWu:function bWu(d,e){this.a=d
this.b=e},
bWy:function bWy(d){this.a=d},
bWF:function bWF(){},
bWG:function bWG(d,e){this.a=d
this.b=e},
bWH:function bWH(d,e){this.a=d
this.b=e},
D5:function D5(d){this.a=d},
a2i:function a2i(d){this.d=d
this.c=this.a=null},
bWi:function bWi(){},
bWp:function bWp(d){this.a=d},
bWq:function bWq(){},
bWo:function bWo(d,e){this.a=d
this.b=e},
bWn:function bWn(d,e,f){this.a=d
this.b=e
this.c=f},
bWm:function bWm(d,e,f){this.a=d
this.b=e
this.c=f},
bWl:function bWl(d){this.a=d},
bWj:function bWj(d){this.a=d},
bWk:function bWk(d){this.a=d},
c4P:function c4P(d){this.a=d},
c4O:function c4O(d){this.a=d},
c4J:function c4J(d,e){this.a=d
this.b=e},
c4L:function c4L(){},
c4K:function c4K(){},
c4M:function c4M(d,e){this.a=d
this.b=e},
c4N:function c4N(d,e){this.a=d
this.b=e},
aj3:function aj3(d){this.a=d},
b5_:function b5_(d){this.a=d},
c54:function c54(){},
c55:function c55(){},
D8:function D8(d,e,f){this.c=d
this.d=e
this.a=f},
a2l:function a2l(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bXl:function bXl(d){this.a=d},
bXm:function bXm(d){this.a=d},
bXn:function bXn(d,e){this.a=d
this.b=e},
bXo:function bXo(d){this.a=d},
bXq:function bXq(d){this.a=d},
bXp:function bXp(d){this.a=d},
c53:function c53(){}},D,O,P,I,E,F
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
B.aj4.prototype={
ra(){var x=this,w=x.a
if(w!=null)return A.ej(w,y.m)
w=x.b
return w==null?x.b=new B.b50(x).$0():w},
un(d,e){return this.aN9(d,e,e)},
aN9(d,e,f){var x=0,w=A.j(f),v,u=2,t=[],s,r,q,p
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
r=B.cze(s)
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
case 7:r=h.d3(g.cU(e,"support",null,null,null,null))
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
v=new B.Vr(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a3r
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
return A.c(m.eF(l.d3(k.cU(e,"storage",null,null,null,null)),y.A),$async$Ep)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.ak(A.dN(r.quota))
p=C.f.ak(A.dN(r.usage))
v=new A.ata(q,p)
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
bj4(){var x=y.K
A.Py(this.ra().bG(new B.b53(),x),x)},
r9(d,e){var x=A.jQ(d[e])
x=x==null?null:C.f.ak(x)
return x==null?0:x},
bgq(d,e,f){return this.un(new B.b52(this,d,e,f),y.C)},
gakr(){var x,w
try{x=A.kj(b.G.sessionStorage)
return x}catch(w){return null}},
garV(){var x=A.eg(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a8X(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.eg(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.garV())return!1
l=A.eg(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.d3(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.Y(x.userAgent)
l=A.jQ(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.u(x.platform)
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
l=this.gakr()
l=l==null?f:A.u(A.cU(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dT(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.kj(m.localStorage)
m=o
m=m==null?f:A.u(A.cU(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dT(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
aqs(){var x,w,v,u,t,s,r=null
try{x=this.gakr()
if(x!=null)A.cU(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.d3(x.location)
u=A.Y(v.hash)
t=A.Y(v.search)
s=A.bz(A.Y(A.d3(x.document).baseURI),0,r).a1("tutor/").k(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.cU(v,"replace",s+t+x,r,r,r)},
bg9(){var x,w=null,v=b.G,u=A.d3(v.history),t=A.jQ(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.cU(u,"back",w,w,w,w)
else{x=A.Y(A.d3(v.document).baseURI)
A.cU(A.d3(v.location),"replace",A.bz(x,0,w).a1("./").k(0)+"#/",w,w,w)}},
a98(d,e,f,g,h){return this.un(new B.b57(this,e,d,f,h,g),y.H)},
a9b(){return this.un(new B.b58(this),y.D)},
a3i(){var x=null,w=this.a
if(w!=null)A.cU(w,"cancelRecording",x,x,x,x)},
alP(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.r9(d,"ms")
w=A.jQ(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.JH(u,x,w,v.r9(d,"frames"),v.r9(d,"tokens"),v.or(d,"retried"),v.r9(d,"encMs"),v.r9(d,"decMs"),v.r9(d,"featMs"))},
aie(d){var x={}
x.words=d
return x},
auX(d,e){return this.un(new B.b5a(this,d,e),y._)},
blh(d,e){return this.un(new B.b59(this,d,e),y._)},
KQ(d,e){return this.bja(d,e)},
bja(d,e){var x=0,w=A.j(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
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
o=A.aa(new A.au(d,new B.b54(),o),o.i("aW.E"))
x=11
return A.c(A.eF(A.d3(A.cU(r,"play",o,e,null,null)),y.y),$async$KQ)
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
if(w!=null)A.cU(w,"stopPlayback",x,x,x,x)},
Ji(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.Y(A.cU(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bkq(){var x,w,v=null
try{x=this.a
if(x!=null)A.cU(x,"resetDevice",v,v,v,v)}catch(w){}},
a6A(d){var x=this.a
if(x!=null)A.cU(x,"prefetch",d,null,null,null)}}
B.Vr.prototype={}
B.JF.prototype={
gn3(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.JH.prototype={
gSQ(){var x=this,w=C.f.az(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.JG.prototype={}
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
B.Sy.prototype={}
B.mV.prototype={
k(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Ij.prototype={
gMt(){var x,w=this,v=w.d
if(v===$){x=new B.aWg(w).$0()
w.d!==$&&A.aq()
w.d=x
v=x}return v},
gJB(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.L)(x),++v){u=x[v]
if(u.d===D.a3S&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbhh(){return J.h6(this.gMt(),new B.aWf()).gM(0)},
gts(){var x=this.a
return x.length!==0&&this.gbhh()===x.length&&this.gJB().length===0}}
B.F8.prototype={
R(){return"AyahStatus."+this.b}}
B.rq.prototype={}
B.aj5.prototype={
a6b(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.rf():x},
aZL(d){var x=this,w=B.b5d(d),v=x.c
if(v===w)return
v=v!=null&&v===B.cht(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
apE(){var x=Date.now(),w=B.b5d(new A.aR(x,0,!1))
x=this.c
return x===w||x===B.cht(w)?this.d:0},
au_(d,e,f,g){var x=this,w=new A.aR(Date.now(),0,!1),v=x.a6b(d,e),u=g?C.j.d1(v.b+1,0,100):0,t=g&&u>=f?D.fg:D.p8,s=new B.rq(t,u,w.hd()),r=d*1000+e
x.a.p(0,r,s)
x.b.E(0,r)
x.aZL(w)
return s},
a62(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cO[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rf():s).a===D.fg)++u}return u},
bg7(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=I.cO[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.rf():s).a===D.p8)++u}return u},
gat2(){var x=this.a,w=A.y(x).i("cf<2>")
return new A.ak(new A.cf(x,w),new B.b5e(),w.i("ak<a_.E>")).gM(0)},
gayB(){var x=this.a,w=A.y(x).i("bJ<1>")
w=A.mp(new A.bJ(x,w),new B.b5f(),w.i("a_.E"),y.S)
w=A.eQ(w,A.y(w).i("a_.E"))
x=A.aa(w,A.y(w).c)
C.b.mt(x)
return x},
dw(){var x,w,v,u,t,s=this,r=y.N,q=A.B(r,y.L)
for(x=s.a,x=new A.eu(x,A.y(x).i("eu<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.p(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.aa(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
bc2(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b3z(x,300,A.y(x).c),x=new A.Jn(J.aB(x.a),x.b,A.y(x).i("Jn<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gI()
s=C.j.aH(t,1000)
t=C.j.a2(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.rf():q).a===D.fg?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.rf()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.rf():r).c.j7()],w,v))}return o},
bgI(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.L)(d),++u){t=d[u]
s=A.eD(t.h(0,"surah"))*1000+A.eD(t.h(0,"ayah"))
r=w.h(0,C.j.aH(s,1000)*1000+C.j.a2(s,1000))
if((r==null?$.rf():r).c.j7()===t.h(0,"updated_at"))v.K(0,s)}},
bgQ(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
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
n=B.cER(s.h(0,"status"))
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
B.Vp.prototype={
J1(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Vp(w,v,u,t,f==null?x.e:f)},
bah(d){var x=null
return this.J1(x,x,d,x,x)},
ap9(d){var x=null
return this.J1(x,d,x,x,x)},
bal(d){var x=null
return this.J1(x,x,x,x,d)},
b9E(d){var x=null
return this.J1(d,x,x,x,x)},
bai(d){var x=null
return this.J1(x,x,x,d,x)},
dw(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Hj.prototype={
R(){return"ModelState."+this.b}}
B.Vq.prototype={
vC(){var x=this.Q
return x==null?this.Q=new B.b5g(this).$0():x},
qK(d){return this.awP(d)},
awP(d){var x=0,w=A.j(y.H),v=this
var $async$qK=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:v.b=d
v.a4()
x=2
return A.c(A.ii("mt.tutor.settings",C.ap.i8(d.dw(),null)),$async$qK)
case 2:return A.h(null,w)}})
return A.i($async$qK,w)},
zL(){var x=0,w=A.j(y.H),v=this,u
var $async$zL=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:v.a4()
x=2
return A.c(A.ii("mt.tutor.progress",C.ap.i8(v.c.dw(),null)),$async$zL)
case 2:u=v.as
if(u!=null)u.aC()
v.as=A.cR(C.x,v.gaDD())
return A.h(null,w)}})
return A.i($async$zL,w)},
Md(d,e,f){return this.axB(d,e,f)},
axB(d,e,f){var x=0,w=A.j(y.H),v=this
var $async$Md=A.e(function(g,h){if(g===1)return A.f(h,w)
for(;;)switch(x){case 0:v.z=new A.b_(d,e,f)
x=2
return A.c(A.ii("mt.tutor.last",C.ap.i8(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$Md)
case 2:return A.h(null,w)}})
return A.i($async$Md,w)},
D9(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$D9=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.UP||n===D.jR){x=1
break}s.f=D.UP
s.y=null
s.a4()
u=4
n=A.lF().geL().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lF().geL().h(0,"tutor_threads")
p=A.dT(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bgq(new B.b5h(s),n,p),$async$D9)
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
s.f=D.aSe
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
return A.c(p.aS("quran_tutor_progress").da("surah, ayah, status, perfect_count, updated_at"),$async$wz)
case 7:o=a1
n=r.c.bgQ(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.bc2()
if(J.aQ(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.n2(h.x,k,k))
x=11
return A.c(f.bkO("quran_tutor_save",!1,g,i),$async$wz)
case 11:r.c.bgI(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.ii("mt.tutor.progress",C.ap.i8(r.c.dw(),null)),$async$wz)
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
L6(d){return this.bks(d)},
bks(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$L6=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c8i(t.c.dw()).dw()
y.f.a(p.h(0,"rows")).ej(0,new B.b5i(d))
t.c=B.c8i(p)
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
O(){var x=$.MJ()
return new B.a_S(x,new A.ah(C.L,$.X()))}}
B.a_S.prototype={
W(){var x,w,v=this
v.Y()
x=v.d
x.ac(v.goD())
w=y.a
x.vC().bG(new B.bJh(v),w)
H.aUJ().bG(new B.bJi(v),w).fv(new B.bJj())
A.Py(H.c7E(),y.y)},
xL(){if(this.c!=null)this.j(new B.bJ3())},
m(){var x,w=this
w.d.T(w.goD())
x=w.e
x.q$=$.X()
x.L$=0
w.a0()},
PS(){var x=0,w=A.j(y.H),v,u=this,t,s
var $async$PS=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.qK(s.b.bah(!0)),$async$PS)
case 3:t=s.a
t.bj4()
if(t.a8X()){t.aqs()
x=1
break}s.D9()
case 1:return A.h(v,w)}})
return A.i($async$PS,w)},
xM(d,e,f){return this.aXE(d,e,f)},
b5o(d){return this.xM(d,null,null)},
aXE(d,e,f){var x=0,w=A.j(y.H),v,u=this,t,s,r
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
return A.c(B.cIG(s,d),$async$xM)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.Md(d,t.a,t.b),$async$xM)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.O(s,!1).aA(A.ax(new B.bJ9(u,d,t),null,r),r),$async$xM)
case 8:if(u.c!=null)u.j(new B.bJa())
case 1:return A.h(v,w)}})
return A.i($async$xM,w)},
u(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.garV()&&!A.O(d,!1).v6())u.push(A.bQ(x,x,x,x,C.yo,x,x,t.gbg8(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bQ(x,x,x,x,D.atx,x,x,new B.bJd(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bQ(x,x,x,x,C.iw,x,x,new B.bJe(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aGa
else w=t?this.aSx():this.aT8()
return L.xC(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aT8(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a3r
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b60,C.a1],x)
for(t=0;t<4;++t){s=D.aIi[t]
u.push(new A.F(C.bs,A.A(A.a([A.b0(s.a,C.am,p,18),C.N,new A.bU(1,C.ad,A.d(s.b,p,p,p,p,G.a10,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bxd,C.F,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.bp(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aL,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.bp(C.f.ak(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.F,A.d(q,p,p,p,p,A.bK(p,p,r?D.dX:C.cG,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.F,D.bwf],x))
x=A.a([new E.dz(u,C.a4,C.aO,p,!0,p),new E.dz(A.I(s,C.q,C.d,C.e,0,C.l),C.a4,C.aO,p,!1,p),D.bFs,C.F],x)
if(v!=null)x.push(new E.dz(A.d(v,p,p,p,p,D.bh0,p,p,p),C.a4,C.aO,p,!1,p))
else x.push(A.fn(D.aqq,D.bmU,this.gaXW(),A.eA(C.v,C.ae,D.b91,p,p,p,p)))
x.push(C.a5)
x.push(D.a3n)
return x},
aSx(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.P(r.a.a),p=q.length===0,o=p?C.ro:H.cmh(q),n=t.z,m=A.R(v.al6(C.dw,E.bp(s.gat2())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.bp(s.apE()),k=s.c,j=Date.now()
k=k===B.b5d(new A.aR(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Hk(t,!1,u),A.A(A.a([m,C.N,A.R(v.al6(C.l6,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.t],j)
if(n!=null){t=H.kl(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.bp(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.bp(m)+"\u2013"+E.bp(l)
k.push(new E.dz(A.A(A.a([D.asE,C.Y,A.R(A.I(A.a([D.biZ,A.d(t+" \u2014 "+m,u,u,u,u,C.bw,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),M.nz],j),C.h,C.d,C.e,0,u,u),C.a4,C.aO,new B.bJ6(v,n),!0,u))}t=C.i.ad(0.08)
k.push(A.aI(u,C.y,!1,u,!0,C.m,u,A.aK(),r,u,u,u,u,u,2,A.cG(u,new A.ci(4,A.v(14),C.M),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.ua,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qK,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bJ7(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.cS,!0,C.u,u,C.E,u,u,u,u))
k.push(C.t)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bsg)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.L)(o),++x)t.push(v.Ra(o[x]))
C.b.A(k,t)}else{t=A.a([D.aVu,D.aWa,v.Ra(1)],j)
for(w=114;w>=78;--w)t.push(v.Ra(w))
t.push(C.F)
r=v.f
p=A.b0(r?C.y4:C.l5,C.am,u,u)
t.push(A.fG(p,u,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.f9,u,u,u),new B.bJ8(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Ra(w))
C.b.A(k,t)}k.push(C.a1)
k.push(D.C5)
return k},
al6(d,e,f){var x=null,w=y.p
return new E.dz(A.A(A.a([A.b0(d,C.v,x,x),C.N,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bw,x,x,x),A.d(f,1,C.O,x,x,C.a1G,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a4,C.J,x,!1,x)},
Ra(d){var x,w=null,v=this.d.c,u=I.cO[d-1].a[1],t=v.a62(d),s=t/u,r=y.p,q=A.ap(A.dA(C.P,A.a([A.c65(C.eQ,G.cM,w,w,w,w,w,3,s,w),A.d(E.bp(d),w,w,w,w,Q.a21,w,w,w)],r),C.m,C.bk,w),36,36),p=A.d(H.kl(d),w,w,w,w,D.bbR,w,w,w)
if(t===0)x=E.bp(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.bp(t)+" \u0645\u0646 "+E.bp(u)
r=A.a([q,C.cE,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bK(w,w,t===u?G.cM:C.cG,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.bp(C.f.ak(s*100))+"\u066a",w,w,w,w,D.a1w,w,w,w))
r.push(D.aqy)
return new E.dz(A.A(r,C.h,C.d,C.e,0,w,w),C.q2,C.d_,new B.bJb(this,d),!1,w)}}
B.Hk.prototype={
u(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b1
return D.aVf
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.MC(x),r,r,r,r,D.Bg,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.D8(w,"model load",r))
x.push(C.F)
x.push(new A.zQ(C.a4c,!1,q.gbgp(),r,r,r,r,C.k,r,!1,r,!0,r,C.up,r))
return new E.dz(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aO,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.d1(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.bp(C.f.ak(u/1e6))+" \u0645\u0646 "+E.bp(C.f.ak(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.oF,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.ff(x,A.q6(C.eQ,C.v,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.F,D.bnK],w))
return new E.dz(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aO,r,!1,r)}}}
B.XI.prototype={
u(d){var x=null,w=D.dX.ad(0.1),v=A.v(14),u=A.aH(D.dX.ad(0.4),1)
return A.D(x,A.A(A.a([D.ash,C.N,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.Bm,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.G(w,x,u,v,x,x,x,C.n),x,x,C.aO,C.ac,x,x,x)}}
B.E7.prototype={
R(){return"_Phase."+this.b}}
B.D7.prototype={
O(){return new B.a2k($.MJ(),D.mk)}}
B.a2k.prototype={
gjc(){var x=this.e
return x===$?this.e=this.a.d:x},
gBI(){var x,w=this.a,v=w.f
w=w.c
x=this.gjc()
return H.MA(w,x,v.xW(w,x)).b},
W(){var x,w=this
w.Y()
x=w.d
x.ac(w.goD())
x.vC()
x.a.a6A(B.azF(w.a.c,w.gjc()))},
xL(){if(this.c!=null)this.j(new B.bWI())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.Q
if(x!=null)x.aC()
v=v.a
v.Mv()
v.a3i()
w.a0()},
ZY(d){var x,w,v=this
if(v.f===D.uY)v.d.a.a3i()
x=v.d.a
x.Mv()
w=v.Q
if(w!=null)w.aC()
v.j(new B.bWY(v,d))
x.a6A(B.azF(v.a.c,d))
w=v.a
if(d<w.e)x.a6A(B.azF(w.c,d+1))},
Rr(d){return this.aU_(d)},
aU_(d){var x=0,w=A.j(y.H),v,u=this,t,s,r,q,p
var $async$Rr=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:if(u.f===D.uX){u.d.a.Mv()
u.j(new B.bX1(u))
x=1
break}t=u.r!=null?D.j9:D.mk
u.j(new B.bX2(u))
s=u.d
r=A.a([B.azF(u.a.c,u.gjc())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.KQ(r,q),$async$Rr)
case 3:p=f
if(u.c==null||u.f!==D.uX){x=1
break}u.j(new B.bX3(u,t,p))
case 1:return A.h(v,w)}})
return A.i($async$Rr,w)},
Qg(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Qg=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jR){x=1
break}p=l.a
p.Mv()
r=B.EQ(s.gBI()).length
s.j(new B.bX5(s))
o=s.Q
if(o!=null)o.aC()
s.Q=A.hD(C.eU,new B.bX6(s))
u=4
o=B.ca3(r)
n=A.dn(0,0,0,350*r,0,0)
x=7
return A.c(p.a98(l.b.c,o,n,new B.bX7(s),new B.bX8(s)),$async$Qg)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a8(k)
if(l instanceof B.lE){q=l
l=s.Q
if(l!=null)l.aC()
if(s.c!=null)s.j(new B.bX9(s,q))}else throw k
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
s.j(new B.bXb(s))
s.Q=A.hD(C.iq,new B.bXc(s))
l=new A.Cz()
$.ET()
l.om()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a9b(),$async$BB)
case 7:q=e
if(q.b<0.8){s.b5n("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.auX(q,B.EQ(s.gBI()).length),$async$BB)
case 8:p=e
s.ch=A.dn(0,0,r.ga4D(),0,0,0)
k=A.lF().geL().h(0,"debug")
if(k==="1"){o=B.cmx(m.Ji())
A.rb().$1("[tutor] "+s.a.c+":"+s.gjc()+" audio="+C.f.az(q.b,1)+"s infer="+p.b+"ms total="+r.gCv()+"ms "+p.gSQ()+" text="+p.a)
A.rb().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.az(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(p.b/1000,2)+" \u062b\n"+p.gSQ()+"\n"+A.n(o)+"\n"+p.a}s.afj(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a8(i)
if(m instanceof B.lE){n=m
m=A.lF().geL().h(0,"debug")
if(m==="1")A.rb().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.Ji())
s.a27(B.MC(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$BB,w)},
a27(d,e){var x=this,w=x.Q
if(w!=null)w.aC()
if(x.c==null)return
x.j(new B.bWX(x,d,e))},
b5n(d){return this.a27(d,null)},
afj(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aC()
if(s.c==null)return
x=B.ckz(s.gBI(),d)
r.a=null
if(C.c.P(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gjc()
t=x.gts()
r.a=w.au_(v,u,q.b.a,t)
q.zL()}s.j(new B.bWZ(r,s,x))},
NT(){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$NT=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jR){x=1
break}s.j(new B.bWQ(s))
l=s.Q
if(l!=null)l.aC()
s.Q=A.hD(C.iq,new B.bWR(s))
k=new A.Cz()
$.ET()
k.om()
r=k
u=4
l=g.a
x=7
return A.c(l.blh(B.azF(s.a.c,s.gjc()),B.EQ(s.gBI()).length),$async$NT)
case 7:q=e
p=B.cmx(l.Ji())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.az(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.az(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.az(r.gCv()/1000,2)+" \u062b)\n"+q.gSQ()+"\n"+A.n(p)+"\n"+q.a
A.rb().$1("[tutor-debug] "+s.a.c+":"+s.gjc()+" audio="+C.f.az(q.c,1)+"s infer="+q.b+"ms total="+r.gCv()+"ms "+q.gSQ()+" text="+q.a)
A.rb().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.dn(0,0,r.ga4D(),0,0,0)
s.afj(q.a)
n=s.r
if(n!=null){l=n.gts()
j=n.b
i=A.al(j).i("ak<1>")
j=A.aa(new A.ak(j,new B.bWS(),i),i.i("a_.E"))
A.rb().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.j(new B.bWT(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a8(f)
if(l instanceof B.lE){m=l
A.rb().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.Ji())
s.a27(B.MC(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$NT,w)},
ga0U(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.rf():v).a!==D.fg)return!1}return!0},
u(d){var x,w=this,v=null,u=w.d,t=u.c.a6b(w.a.c,w.gjc()),s=u.b,r=s.d&&!w.x&&w.f!==D.j9,q=H.kl(w.a.c),p=y.p,o=A.a([A.bQ(v,v,v,v,C.iw,v,v,new B.bXh(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aKo(),m=A.d("\u0622\u064a\u0629 "+E.bp(w.gjc()),v,v,v,v,C.m1,v,v,v),l=E.bp(w.gjc()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.aX,A.d("("+l+" \u0645\u0646 "+E.bp(k.e-k.d+1)+")",v,v,v,v,F.aL,v,v,v),C.bB,w.aYB(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.t],p)
if(r)s.push(w.aSs())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.uY&&l!==D.oZ}else l=!1
if(l)s.push(w.aI3(m))
else s.push(A.d(w.gBI()+" \ufd3f"+E.bp(w.gjc())+"\ufd3e",v,v,v,v,D.ke,C.a0,C.bi,v))}s=A.a([new B.Hk(u,!0,v),n,C.B,new E.dz(A.I(s,C.ah,C.d,C.e,0,C.l),D.ajf,C.aO,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.j9)s.push(w.b6S(n))
if(w.r!=null&&w.f===D.j9&&w.ch!=null){x=C.f.ak(C.j.aH(w.ch.a,1000)/100)
s.push(new A.F(C.bs,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.bp(C.j.aH(x,10))+"\u066b"+E.bp(C.j.a2(x,10)))+" \u062b",v,v,v,v,F.aL,C.a0,v,v),v))}n=w.as
if(n!=null)s.push(new A.F(C.aO,A.d(n,v,v,v,v,D.Bg,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.D8(n,"check "+w.a.c+":"+w.gjc(),v))}s.push(w.aIC())
s.push(C.a1)
s.push(A.is(C.v,C.J,v,new B.bXi(w),D.bkH,D.bq0,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga0U()
s.push(new E.dz(A.A(A.a([D.ap1,C.Y,A.R(A.I(A.a([D.brD,A.d(w.ga0U()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aL,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),M.nz],p),C.h,C.d,C.e,0,v,v),C.a4,C.aO,new B.bXj(w,d),n,v))}n=A.lF().geL().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dj(D.aqp,D.bpr,u.f===D.jR&&w.f!==D.oZ?w.gaJl():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.F(C.ir,A.xd(n,F.aL,v,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gn3()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aL,v,v,v))}p.push(A.bh(D.bqN,v,v,v,new B.bXk(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.C5)
return L.xC(o,s,q)},
aKo(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b1
return A.ap(A.fr(new B.bWV(this),w,null,C.af,new B.bWW()),36,null)},
aYB(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.fg)return D.b6c
x=d.b
w=E.bp(x)
v=E.bp(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.c1:C.y9
u.push(new A.F(D.ajX,A.b0(r,s?G.cM:C.eR,q,16),q))}return A.aiZ(A.A(u,C.h,C.d,C.K,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aSs(){var x=null
return A.bw(!1,A.v(12),!0,A.D(x,D.afm,C.k,x,x,new A.G(C.pz,x,x,A.v(12),x,x,x,C.n),x,x,x,D.aiP,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bX0(this),x,x,x,x,x,x,x)},
aI3(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gMt(),w)
A:{if(D.j2===v){u=D.ke.ct(G.cM)
break A}if(D.uG===v){u=D.ke.a3W(D.dX,C.hm,D.dX)
break A}if(D.uH===v){u=D.ke.a3W(D.eP,C.hm,D.eP)
break A}u=D.ke.a3W(C.eR,C.ka,C.cc)
break A}t=x[w]
r.push(new A.eL(t.a,s,s,C.br,s,s,s,s,s,s,u))
r.push(P.B8)}x=E.bp(this.gjc())
r.push(A.eq(s,s,s,s,s,s,s,s,s,D.ke.ct(C.am),"\ufd3f"+x+"\ufd3e"))
return A.CM(A.eq(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.a0,C.bi)},
b6S(d){var x,w,v,u,t,s,r=this.w
if(C.c.P(d.c).length===0)return D.bEP
if(d.gts()){x=r==null
if((x?null:r.a)===D.fg&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.fg?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.bp(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.Dq(G.cM,C.c1,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gMt()
w=J.dB(x)
v=w.iD(x,new B.bXd()).gM(0)
u=w.iD(x,new B.bXe()).gM(0)
t=w.iD(x,new B.bXf()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.bp(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.bp(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.bp(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJB().length!==0)x.push(E.bp(d.gJB().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eP:D.dX
x=C.b.aB(x," \u2022 ")
s=d.gJB().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aB(d.gJB(),"\u060c "):""
return new B.Dq(w,C.np,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aIC(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jR,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aH(new A.aR(f,0,!1).dG(w).a,1e6)}v=C.j.aH(B.ca3(B.EQ(j.gBI()).length).a,1e6)
f=j.gb3X()
w=96+26*j.y
u=D.eP.ad(0.25)
w=A.iN(i,A.a59(C.P,A.D(i,D.aqB,C.k,i,i,D.a7f,i,84,i,i,i,i,84),i,C.aU,new A.G(u,i,i,i,i,i,i,C.bY),C.F0,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cP)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c9_(x)+" / "+B.c9_(v),i,i,i,i,K.oE,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aL,i,i,i),A.bh(D.bwe,i,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.ez((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.bp(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.bp(t)+" \u062b)"
return new A.F(C.pZ,A.I(A.a([C.vM,C.a1,D.bob,A.d(h,i,i,i,i,F.aL,C.a0,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.uX
r=j.r
f=r==null
w=!f
q=w&&r.gts()
u=A.b0(s?C.nq:K.Hx,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.eA(i,i,D.b8Z,i,i,i,i)
u=A.R(new A.zQ(C.a4c,!0,new B.bWJ(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.Yj(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.J9[n]
p.push(new A.em(m,i,A.d("\xd7"+E.bp(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.N,A.oO(new B.bWK(j),p,A.db([h.b.b],o),!1,A.kp(i,i,i,new A.bf(new B.bWL(),l),i,i,i,i,new A.bf(new B.bWM(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cJ),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gb_B():i
u=A.b0(f?D.qy:C.np,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cF,i,i,i)
p=q?C.il:C.v
h=A.a([o,C.t,A.fn(u,f,h,A.eA(p,q?C.i:C.ae,D.tL,i,i,i,i))],k)
if(w&&j.gjc()<j.a.e)C.b.A(h,A.a([C.B,q?A.fn(D.atX,D.buW,new B.bWN(j),A.eA(G.cM,C.ae,D.tL,i,i,i,i)):A.bh(D.bl6,i,i,i,new B.bWO(j),i,i)],k))
if(w){f=j.gjc()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.F(C.jt,A.d(j.ga0U()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,K.uj,C.a0,i,i),i))
return A.I(h,C.ah,C.d,C.e,0,C.l)}}}
B.Dq.prototype={
u(d){var x=this,w=null,v=x.c,u=v.ad(0.12),t=A.v(14),s=A.aH(v.ad(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b0(x.d,v,w,w),C.N,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bK(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.W,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bQ,A.d(x.f,w,w,w,w,C.Bm,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.G(u,w,s,t,w,w,w,C.n),w,w,C.aO,C.ac,w,w,w)}}
B.D6.prototype={
O(){var x=y.S
return new B.a2j($.MJ(),A.B(x,y.B),A.aS(x),A.B(x,y.N),A.ej(null,y.H))}}
B.a2j.prototype={
W(){this.Y()
this.d.ac(this.goD())},
xL(){if(this.c!=null)this.j(new B.bWr())},
m(){var x,w=this,v=w.d
v.T(w.goD())
x=w.y
if(x!=null)x.aC()
v.a.a3i()
w.a0()},
I6(d){return this.b3J(d)},
b3J(d){var x=0,w=A.j(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$I6=A.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new B.bWA(t,d))
r=t.y
if(r!=null)r.aC()
t.y=A.hD(C.eU,new B.bWB(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.ca3(B.EQ(H.MA(q,d,p.xW(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.dn(0,0,0,350*B.EQ(H.MA(p,d,o.xW(p,d)).b).length,0,0)
x=6
return A.c(r.a.a98(r.b.c,q,p,new B.bWC(t,d),new B.bWD(t)),$async$I6)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a8(m)
if(r instanceof B.lE){s=r
r=t.y
if(r!=null)r.aC()
if(t.c!=null)t.j(new B.bWE(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$I6,w)},
FB(d,e){return this.aLy(d,e)},
aLy(d,e){var x=0,w=A.j(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$FB=A.e(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aC()
s.j(new B.bWv(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a9b()
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
s.j(new B.bWw(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bG(new B.bWx(s,o,d),y.H)}case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$FB,w)},
gaW8(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aF(x)&&!v.n(0,x)&&!u.aF(x)&&x!==t.e)return x
return null},
b0s(){this.j(new B.bWy(this))},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jR,o=s.e,n=s.gaW8(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("cf<2>")
x=new A.ak(new A.cf(m,l),new B.bWF(),l.i("ak<a_.E>")).gM(0)
l=H.kl(s.a.c)
m=y.p
q=A.a([new B.Hk(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.bp(s.a.d)+" \u0644\u062d\u062f "+E.bp(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aL,r,r,r),C.t],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b5p(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.Bg,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.D8(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.bp(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aH(new A.aR(v,0,!1).dG(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c9_(v),r,r,r,r,K.oE,C.a0,r,r)
j=A.ff(A.v(6),A.q6(C.eQ,D.eP,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b0(u?O.Hq:C.nq,r,r,r)
C.b.A(q,A.a([v,C.F,j,C.t,A.fn(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cF,r,r,r),new B.bWG(s,o),A.eA(C.v,C.ae,D.tL,r,r,r,r))],m))}else if(n!=null){j=p?new B.bWH(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.bp(n)
q.push(A.fn(D.arL,A.d(v,r,r,r,r,C.cF,r,r,r),j,A.eA(C.v,C.ae,D.tL,r,r,r,r)))}if(s.r.a!==0&&k)q.push(D.aVF)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?G.cM:D.dX
v=k?C.ng:C.np
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.bp(x)
u=s.a
u=k+" \u0645\u0646 "+E.bp(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.Dq(j,v,k,u,r),A.dj(D.atJ,D.bvB,s.gb0r(),r)],m))}q.push(C.t)
q.push(D.C5)
return L.xC(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b5p(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.ar6
else if(l.r.n(0,d))x=N.tO
else if(i!=null)x=D.arn
else if(j!=null){w=j.gts()?C.c1:D.anz
x=A.b0(w,j.gts()?G.cM:D.dX,k,k)}else x=D.apH
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.bp(d),k,k,k,k,D.bgd,k,k,k),C.bB,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.a1I,k,k,k))
if(j!=null&&!j.gts()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gMt()
o=J.bg(p)
n=o.h(p,r)
A:{if(D.j2===n){m=G.cM
break A}if(D.uG===n){m=D.dX
break A}if(D.uH===n){m=D.eP
break A}m=C.eR
break A}m=D.ke.baX(m,o.h(p,r)===D.uI?C.ka:k,22)
C.b.A(t,A.a([new A.eL(q.a,k,k,C.br,k,k,k,k,k,k,m),P.B8],u))}w=A.a([C.ai,A.CM(A.eq(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.a0,C.bi)],w)
if(C.c.P(j.c).length===0)w.push(D.br1)
C.b.A(v,w)}return new E.dz(A.I(v,C.ah,C.d,C.e,0,C.l),C.bM,C.d_,k,!1,k)}}
B.D5.prototype={
O(){return new B.a2i($.MJ())}}
B.a2i.prototype={
W(){this.Y()
var x=this.d
x.ac(this.goD())
x.vC()},
xL(){if(this.c!=null)this.j(new B.bWi())},
m(){this.d.T(this.goD())
this.a0()},
u(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gayB(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kZ(o,0,new B.bWp(q))
v=C.b.kZ(o,0,new B.bWq())
o=y.p
o=A.a([A.A(A.a([A.R(s.XR(E.bp(q.gat2()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.N,A.R(s.XR(E.bp(q.apE()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.N,A.R(s.XR(E.bp(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.t,new E.dz(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.bp(C.f.ak(w*100/v))+"\u066a",r,r,r,r,C.bw,r,r,r),C.F,A.ff(A.v(6),A.q6(C.eQ,G.cM,8,w/v,r),C.aC),C.ai,A.d(E.bp(w)+" \u0645\u0646 "+E.bp(v)+" \u0622\u064a\u0629",r,r,r,r,F.aL,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a4,C.aO,r,!1,r)],o)
if(p.length===0)o.push(D.aVT)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.L)(p),++t)o.push(s.b5r(p[t]))
o.push(C.B)
u=$.C().b
u===$&&A.b()
u=u.ga3().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aL,r,r,r))
return L.xC(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
XR(d,e){var x=null
return new E.dz(A.I(A.a([A.d(d,x,x,x,x,D.bfW,x,x,x),A.d(e,x,x,x,x,C.a2d,C.a0,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a4,C.J,x,!1,x)},
b5r(d){var x=null,w=this.d.c,v=I.cO[d-1].a[1],u=w.a62(d),t=w.bg7(d),s=y.p,r=A.A(A.a([A.R(A.d(H.kl(d),x,x,x,x,C.bw,x,x,x),1),A.d(E.bp(C.f.ak(u*100/v))+"\u066a",x,x,x,x,D.bh1,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.ff(A.v(6),A.q6(C.eQ,G.cM,7,u/v,x),C.aC),p=E.bp(u),o=E.bp(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.bp(t):""
return new E.dz(A.I(A.a([r,C.F,q,C.ai,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aL,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a4,C.aO,new B.bWo(this,d),!1,x)},
NW(d){return this.aJH(d)},
aJH(d){var x=0,w=A.j(y.H),v=this,u,t
var $async$NW=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=I.cO[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.e2(C.cL,new B.bWn(v,d,u),t,!0,null,null,!1,y.H),$async$NW)
case 2:return A.h(null,w)}})
return A.i($async$NW,w)}}
B.aj3.prototype={
Rq(d,e){var x=null,w=A.mI(x,x,x,x,x,x,x,x,x,x,x,D.b8y,C.J,x,x,x,x,C.jQ,x,x)
return A.bh(A.d(d,x,x,x,x,C.m0,x,x,x),x,x,x,new B.b5_(e),x,w)},
u(d){var x=this,w=y.p
return new E.dz(A.I(A.a([D.buH,C.F,D.bwd,A.cX(C.aw,A.a([x.Rq("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.Rq("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aE,0,12),D.bki,x.Rq("tanzil.net","https://tanzil.net"),D.bxO,x.Rq("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a4,C.aO,null,!1,null)}}
B.D8.prototype={
O(){return new B.a2l()}}
B.a2l.prototype={
galV(){var x=this.a
return B.cK0(x.c,x.d,$.caG().Ji())},
Rs(){var x=0,w=A.j(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$Rs=A.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.j(new B.bXl(s))
v=3
r=A.c4e()
n=s.galV()
m=y.N
q=A.B(m,m)
J.dW(q,"app","mogtama3y")
J.dW(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dW(q,"ua",m)}x=6
return A.c(A.a9D(n,null,C.G5,q),$async$Rs)
case 6:if(s.c!=null)s.j(new B.bXm(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a8(k)
o=p instanceof A.cj?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.j(new B.bXn(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.j(new B.bXo(s))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$Rs,w)},
u(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bw(!1,t,!0,new A.F(C.kQ,A.A(A.a([A.b0(u.d?C.y4:C.l5,C.cc,t,18),C.bJ,D.bx_],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bXq(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.D(t,A.xd(u.galV(),D.bcf,t,C.A),C.k,t,t,new A.G(C.pz,t,t,x,t,t,t,C.n),t,t,D.aiS,C.e9,t,t,1/0))}if(u.f)s.push(D.bkA)
else{x=A.mI(t,t,t,t,t,t,t,t,t,t,t,C.a01,C.J,t,t,t,t,C.jQ,t,t)
w=u.e
v=w?t:u.gb5q()
s.push(A.fG(w?C.a0g:D.at5,t,D.btE,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,D.a1I,t,t,t))
return new A.F(C.aO,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["ai<~>()","~()","N(nA)","ai<JH>()","ai<JF>()","ai<JG>()","a7<nA>()","N(rq)","bE(oG)","D7(t)","D5(t)","N(mV)","D6(t)","N(Ij)"])
B.b50.prototype={
$0(){var x=0,w=A.j(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.Y(A.d3(b.G.document).baseURI)
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
m=B.czf("network",A.n(o))
throw A.r(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:307}
B.b53.prototype={
$1(d){var x=null
return A.bZX(A.cU(d,"persist",x,x,x,x))},
$S:1113}
B.b52.prototype={
$0(){var x=0,w=A.j(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.ra(),$async$$0)
case 4:x=3
return A.c(n.eF(m.d3(l.cU(e,"loadModel",A.c_F(new B.b51(u.b)),u.c,u.d,null)),y.m),$async$$0)
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
v=new B.JF(o,t,s,r,q.r9(p,"threads"),q.or(p,"isolated"),q.r9(p,"warmMs"))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+4}
B.b51.prototype={
$2(d,e){this.a.$2(C.f.ak(d),C.f.ak(e))},
$S:1114}
B.b57.prototype={
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
u.onLevel=A.fV(new B.b55(v.e))
u.onAutoStop=A.fV(new B.b56(v.f))
x=5
return A.c(A.eF(A.d3(A.cU(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.b55.prototype={
$1(d){return this.a.$1(d)},
$S:70}
B.b56.prototype={
$1(d){return this.a.$1(d)},
$S:5}
B.b58.prototype={
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
return A.c(q.eF(p.d3(o.cU(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.JG(r,A.dN(r.seconds))
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+5}
B.b5a.prototype={
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
return A.c(q.eF(p.d3(o.cU(e,"transcribe",t.audio,t.rate,s.aie(u.c),null)),y.m),$async$$0)
case 3:v=r.alP(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b59.prototype={
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
return A.c(r.eF(q.d3(p.cU(e,"transcribeUrl",u.b,t.aie(u.c),null,null)),y.m),$async$$0)
case 3:v=s.alP(e)
x=1
break
case 1:return A.h(v,w)}})
return A.i($async$$0,w)},
$S:z+3}
B.b54.prototype={
$1(d){return d},
$S:37}
B.aWg.prototype={
$0(){var x,w,v,u,t=this.a,s=A.cn(t.a.length,D.uI,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aWf.prototype={
$1(d){return d===D.j2},
$S:z+2}
B.c_o.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c5a(e[x],d[x])<0.75)return!1
return!0},
$S:1115}
B.c1u.prototype={
$1(d){return d.length!==0},
$S:11}
B.b5e.prototype={
$1(d){return d.a===D.fg},
$S:z+7}
B.b5f.prototype={
$1(d){return C.j.aH(d,1000)},
$S:59}
B.b5c.prototype={
$1(d){return C.f.bW(d)},
$S:1116}
B.b5g.prototype={
$0(){var x=0,w=A.j(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.iA("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.ap.fb(r,null))
j=A.aE(k.h(0,"n"))
j=j==null?null:C.f.bW(j)
j=C.j.d1(j==null?2:j,1,5)
i=C.b.n(D.J9,k.h(0,"r"))?A.eD(k.h(0,"r")):1
h=A.eg(k.h(0,"auto"))
g=A.eg(k.h(0,"hide"))
k=A.eg(k.h(0,"in"))
s.a.b=new B.Vp(j,i,h!==!1,g===!0,k===!0)}u=2
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
if(q!=null)s.a.c=B.c8i(y.P.a(C.ap.fb(q,null)))
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
n=C.f.bW(A.cS(J.av(o,"s")))
m=C.f.bW(A.cS(J.av(o,"f")))
l=C.f.bW(A.cS(J.av(o,"t")))
if(B.cmC(n,m)&&B.cmC(n,l)&&m<=l)s.a.z=new A.b_(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a8X()){k.a.aqs()
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
B.b5h.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a4()},
$S:1117}
B.b5i.prototype={
$2(d,e){return C.j.aH(A.eE(A.n(d),null,null),1000)===this.a},
$S:1118}
B.bJh.prototype={
$1(d){var x=0,w=A.j(y.a),v=this,u,t
var $async$$1=A.e(function(e,f){if(e===1)return A.f(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.Ep(),$async$$1)
case 2:t=f
if(u.c!=null)u.j(new B.bJg(u,t))
return A.h(null,w)}})
return A.i($async$$1,w)},
$S:1119}
B.bJg.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bJi.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bJf(x,d))},
$S:z+8}
B.bJf.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bJj.prototype={
$1(d){},
$S:24}
B.bJ3.prototype={
$0(){},
$S:0}
B.bJ9.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.D7(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bJa.prototype={
$0(){},
$S:0}
B.bJd.prototype={
$0(){var x=y.z
return A.O(this.a,!1).aA(A.ax(new B.bJc(),null,x),x)},
$S:0}
B.bJc.prototype={
$1(d){return D.bza},
$S:z+10}
B.bJe.prototype={
$0(){return B.cmo(this.a)},
$S:0}
B.bJ6.prototype={
$0(){var x=this.b
return this.a.xM(x.a,x.b,x.c)},
$S:0}
B.bJ7.prototype={
$1(d){return this.a.j(new B.bJ5())},
$S:5}
B.bJ5.prototype={
$0(){},
$S:0}
B.bJ8.prototype={
$0(){var x=this.a
return x.j(new B.bJ4(x))},
$S:0}
B.bJ4.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bJb.prototype={
$0(){return this.a.b5o(this.b)},
$S:0}
B.c40.prototype={
$1(d){return new A.j9(new B.c3Y(this.a,this.b,this.c),null)},
$S:57}
B.c3Y.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c4_(u,e),s=this.a,r=new B.c3Z(s,e),q=A.d(H.kl(this.c),v,v,v,v,C.oA,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.bp(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aL,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.bp(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.bp(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.d1(w+4,1,u)))}u=A.a([q,C.ai,p,C.t,A.cX(C.aw,n,C.aE,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c3T(s)),C.a0c,t.$3("\u0644\u062d\u062f",s.c,new B.c3U(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aVK)
u.push(C.a5)
u.push(A.dH(D.bnF,new B.c3V(s,d),A.eA(C.v,C.ae,D.b8W,v,v,v,v)))
return A.cu(!0,new A.F(C.Fx,A.I(u,C.ah,C.d,C.K,0,C.l),v),C.J,!0)},
$S:390}
B.c4_.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.i7,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.c7(v,A.d("\u0622\u064a\u0629 "+E.bp(v),u,u,u,u,u,u,u,u),C.ar,u,w))
return A.R(A.I(A.a([t,R.G0(C.cL,!0,s,320,new B.c3X(this.b,f),D.bhj,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1121}
B.c3X.prototype={
$1(d){return d==null?null:this.a.$1(new B.c3W(this.b,d))},
$S:49}
B.c3W.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c3Z.prototype={
$3(d,e,f){var x=null
return A.c5M(x,A.d(d,x,x,x,x,x,x,x,x),new B.c3S(this.a,this.b,e,f))},
$S:1122}
B.c3S.prototype={
$0(){var x=this
return x.b.$1(new B.c3R(x.a,x.c,x.d))},
$S:0}
B.c3R.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c3T.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c3U.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c3V.prototype={
$0(){var x=this.a
return A.O(this.b,!1).af(new A.W(x.b,x.c))},
$S:0}
B.bWI.prototype={
$0(){},
$S:0}
B.bWY.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.mk
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bX1.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.j9:D.mk},
$S:0}
B.bX2.prototype={
$0(){var x=this.a
x.f=D.uX
x.as=null},
$S:0}
B.bX3.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bX5.prototype={
$0(){var x=this.a
x.f=D.uY
x.as=null
x.y=0
x.z=new A.aR(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bX6.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bX4())},
$S:31}
B.bX4.prototype={
$0(){},
$S:0}
B.bX8.prototype={
$1(d){return this.a.y=d},
$S:70}
B.bX7.prototype={
$1(d){return this.a.BB()},
$S:5}
B.bX9.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.j9:D.mk
x=this.b
w.as=B.MC(x)
w.at=x},
$S:0}
B.bXb.prototype={
$0(){var x=this.a
x.f=D.oZ
x.ay=Date.now()},
$S:0}
B.bXc.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bXa())},
$S:31}
B.bXa.prototype={
$0(){},
$S:0}
B.bWX.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.j9:D.mk
x.as=this.b
x.at=this.c},
$S:0}
B.bWZ.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.j9
x.x=!1},
$S:0}
B.bWQ.prototype={
$0(){var x=this.a
x.f=D.oZ
x.ay=Date.now()
x.as=null},
$S:0}
B.bWR.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bWP())},
$S:31}
B.bWP.prototype={
$0(){},
$S:0}
B.bWS.prototype={
$1(d){return d.d!==D.j2},
$S:z+11}
B.bWT.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bXh.prototype={
$0(){return B.cmo(this.a)},
$S:0}
B.bXi.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.ap9(d))},
$S:3}
B.bXj.prototype={
$0(){var x=y.z
return A.O(this.b,!1).aA(A.ax(new B.bXg(this.a),null,x),x)},
$S:0}
B.bXg.prototype={
$1(d){var x=this.a.a
return new B.D6(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bXk.prototype={
$0(){this.a.d.a.bkq()
this.b.J(y.q).f.Z(D.ba0)},
$S:0}
B.bWW.prototype={
$2(d,e){return C.aX},
$S:17}
B.bWV.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a6b(s.c,r).a.a){case 2:s=G.cM
break
case 1:s=D.dX
break
case 0:s=C.il
break
default:s=u}x=A.v(18)
w=t.f===D.oZ?u:new B.bWU(t,r)
v=s.ad(0.25)
if(r===t.gjc())s=C.i
s=A.aH(s,r===t.gjc()?2:1)
return A.bw(!1,x,!0,A.D(C.P,A.d(E.bp(r),u,u,u,u,C.a1m,u,u,u),C.k,u,u,new A.G(v,u,s,u,u,u,u,C.bY),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:62}
B.bWU.prototype={
$0(){return this.a.ZY(this.b)},
$S:0}
B.bX0.prototype={
$0(){var x=this.a
return x.j(new B.bX_(x))},
$S:0}
B.bX_.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bXd.prototype={
$1(d){return d===D.uG},
$S:z+2}
B.bXe.prototype={
$1(d){return d===D.uH},
$S:z+2}
B.bXf.prototype={
$1(d){return d===D.uI},
$S:z+2}
B.bWJ.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.Rr(x)},
$S:0}
B.bWK.prototype={
$1(d){var x=this.a.d
return x.qK(x.b.bal(d.ga5(d)))},
$S:117}
B.bWM.prototype={
$1(d){return d.n(0,C.T)?C.ae:C.i},
$S:4}
B.bWL.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.bWN.prototype={
$0(){var x=this.a
return x.ZY(x.gjc()+1)},
$S:0}
B.bWO.prototype={
$0(){var x=this.a
return x.ZY(x.gjc()+1)},
$S:0}
B.bWr.prototype={
$0(){},
$S:0}
B.bWA.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.aR(Date.now(),0,!1)},
$S:0}
B.bWB.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new B.bWz())},
$S:31}
B.bWz.prototype={
$0(){},
$S:0}
B.bWD.prototype={
$1(d){return this.a.x=d},
$S:70}
B.bWC.prototype={
$1(d){return this.a.FB(this.b,!1)},
$S:5}
B.bWE.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.MC(x)
w.as=x},
$S:0}
B.bWv.prototype={
$0(){var x=this.a
x.e=null
x.r.E(0,this.b)},
$S:0}
B.bWw.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.p(0,v,B.MC(x))
w.as=x},
$S:0}
B.bWx.prototype={
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
return A.c(n.a.auX(s.b,B.EQ(H.MA(l,m,k.xW(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.ckz(H.MA(l,m,k.xW(l,m)).b,r.a)
if(C.c.P(q.c).length!==0){l=n.c
k=o.a.c
j=q.gts()
l.au_(k,m,n.b.a,j)}n.zL()
if(o.c!=null)o.j(new B.bWs(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a8(h)
if(o instanceof B.lE){p=o
o=s.a
if(o.c!=null)o.j(new B.bWt(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.j(new B.bWu(o,s.c))
x=t.pop()
break
case 5:return A.h(null,w)
case 1:return A.f(u.at(-1),w)}})
return A.i($async$$1,w)},
$S:148}
B.bWs.prototype={
$0(){var x=this.c
this.a.f.p(0,this.b,x)
return x},
$S:0}
B.bWt.prototype={
$0(){var x=this.a,w=this.c
x.w.p(0,this.b,B.MC(w))
x.as=w},
$S:0}
B.bWu.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bWy.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)
x.as=null},
$S:0}
B.bWF.prototype={
$1(d){return d.gts()},
$S:z+13}
B.bWG.prototype={
$0(){return this.a.FB(this.b,!0)},
$S:0}
B.bWH.prototype={
$0(){return this.a.I6(this.b)},
$S:0}
B.bWi.prototype={
$0(){},
$S:0}
B.bWp.prototype={
$2(d,e){return d+this.a.a62(e)},
$S:116}
B.bWq.prototype={
$2(d,e){return d+I.cO[e-1].a[1]},
$S:116}
B.bWo.prototype={
$0(){return this.a.NW(this.b)},
$S:0}
B.bWn.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(H.kl(p),q,q,q,q,C.oA,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.ba(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.rf():r).a.a){case 2:r=G.cM.ad(0.35)
break
case 1:r=D.dX.ad(0.35)
break
case 0:r=C.fW
break
default:r=q}m.push(A.D(C.P,A.d(E.bp(t),q,q,q,q,C.kd,q,q,q),C.k,q,q,new A.G(r,q,q,new A.cz(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cu(!0,new A.F(C.h1,A.I(A.a([o,C.ai,D.brW,C.t,new A.dD(D.a77,A.f5(A.cX(C.aw,m,C.aE,6,6),q,C.r,q,q,q,C.w),q),C.a1,A.bh(D.btI,q,q,q,new B.bWm(w,d,p),q,q)],n),C.ah,C.d,C.K,0,C.l),q),C.J,!0)},
$S:36}
B.bWm.prototype={
$0(){var x=0,w=A.j(y.H),v=this,u,t
var $async$$0=A.e(function(d,e){if(d===1)return A.f(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dm(null,null,!0,null,new B.bWl(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.L6(t),$async$$0)
case 5:if(u.e!=null)A.O(u,!1).e5()
case 3:return A.h(null,w)}})
return A.i($async$$0,w)},
$S:1}
B.bWl.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+H.kl(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.du(A.a([A.bh(C.eo,x,x,x,new B.bWj(d),x,x),A.bh(C.oM,x,x,x,new B.bWk(d),x,x)],y.p),w,D.bvh)},
$S:14}
B.bWj.prototype={
$0(){A.O(this.a,!1).af(!1)
return null},
$S:0}
B.bWk.prototype={
$0(){A.O(this.a,!1).af(!0)
return null},
$S:0}
B.c4P.prototype={
$1(d){var x=this.a
return new A.kD(new B.c4O(x),null,x,null)},
$S:1123}
B.c4O.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.em(w,t,A.d(E.bp(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bkc,C.a1,D.bu8,C.F,A.oO(new B.c4J(s,r),q,A.db([r.a],x),!1,A.kp(t,t,t,new A.bf(new B.c4K(),v),t,t,t,t,new A.bf(new B.c4L(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.is(C.v,C.J,t,new B.c4M(s,r),D.brc,D.bxh,r.c),A.is(C.v,C.J,t,new B.c4N(s,r),t,D.bjH,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.ai,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gn3(),t,t,t,t,F.aL,t,C.bi,t)],u))
x.push(C.B)
x.push(D.a3n)
return A.cu(!0,A.f5(A.I(x,C.ah,C.d,C.e,0,C.l),t,C.r,C.h1,t,t,C.w),C.J,!0)},
$S:1124}
B.c4J.prototype={
$1(d){return this.a.qK(this.b.bai(d.ga5(d)))},
$S:117}
B.c4L.prototype={
$1(d){return d.n(0,C.T)?C.ae:C.i},
$S:4}
B.c4K.prototype={
$1(d){return d.n(0,C.T)?C.v:C.a7},
$S:4}
B.c4M.prototype={
$1(d){return this.a.qK(this.b.b9E(d))},
$S:3}
B.c4N.prototype={
$1(d){return this.a.qK(this.b.ap9(d))},
$S:3}
B.b5_.prototype={
$0(){return A.cv(A.bz(this.a,0,null),C.aR,null)},
$S:0}
B.c54.prototype={
$1(d){var x,w=A.aD("https?://",!0,!1,!1)
w=A.bD(d,w,"")
x=A.aD("www\\.",!0,!1,!1)
return A.uS(A.bD(w,x,"www[.]"),A.aD("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c55(),null)},
$S:37}
B.c55.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:58}
B.bXl.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bXm.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bXn.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bXo.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bXq.prototype={
$0(){var x=this.a
return x.j(new B.bXp(x))},
$S:0}
B.bXp.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c53.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:203};(function installTearOffs(){var x=a._instance_0u
x(B.aj4.prototype,"gbg8","bg9",1)
var w
x(w=B.Vq.prototype,"gbgp","D9",0)
x(w,"gaDD","wz",0)
x(w=B.a_S.prototype,"goD","xL",1)
x(w,"gaXW","PS",0)
x(w=B.a2k.prototype,"goD","xL",1)
x(w,"gb_B","Qg",0)
x(w,"gb3X","BB",0)
x(w,"gaJl","NT",0)
x(w=B.a2j.prototype,"goD","xL",1)
x(w,"gb0r","b0s",1)
x(B.a2i.prototype,"goD","xL",1)
x(B.a2l.prototype,"gb5q","Rs",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a4,[B.aj4,B.Vr,B.JF,B.JH,B.JG,B.lE,B.Sy,B.mV,B.Ij,B.rq,B.aj5,B.Vp])
x(A.lb,[B.b50,B.b52,B.b57,B.b58,B.b5a,B.b59,B.aWg,B.b5g,B.bJg,B.bJf,B.bJ3,B.bJa,B.bJd,B.bJe,B.bJ6,B.bJ5,B.bJ8,B.bJ4,B.bJb,B.c3W,B.c3S,B.c3R,B.c3V,B.bWI,B.bWY,B.bX1,B.bX2,B.bX3,B.bX5,B.bX4,B.bX9,B.bXb,B.bXa,B.bWX,B.bWZ,B.bWQ,B.bWP,B.bWT,B.bXh,B.bXj,B.bXk,B.bWU,B.bX0,B.bX_,B.bWJ,B.bWN,B.bWO,B.bWr,B.bWA,B.bWz,B.bWE,B.bWv,B.bWw,B.bWs,B.bWt,B.bWu,B.bWy,B.bWG,B.bWH,B.bWi,B.bWo,B.bWm,B.bWj,B.bWk,B.b5_,B.bXl,B.bXm,B.bXn,B.bXo,B.bXq,B.bXp])
x(A.iE,[B.b53,B.b55,B.b56,B.b54,B.aWf,B.c1u,B.b5e,B.b5f,B.b5c,B.bJh,B.bJi,B.bJj,B.bJ9,B.bJc,B.bJ7,B.c40,B.c4_,B.c3X,B.c3Z,B.c3T,B.c3U,B.bX6,B.bX8,B.bX7,B.bXc,B.bWR,B.bWS,B.bXi,B.bXg,B.bXd,B.bXe,B.bXf,B.bWK,B.bWM,B.bWL,B.bWB,B.bWD,B.bWC,B.bWx,B.bWF,B.bWn,B.bWl,B.c4P,B.c4J,B.c4L,B.c4K,B.c4M,B.c4N,B.c54,B.c55,B.c53])
x(A.o4,[B.b51,B.c_o,B.b5h,B.b5i,B.c3Y,B.bWW,B.bWV,B.bWp,B.bWq,B.c4O])
x(A.DH,[B.nA,B.F8,B.Hj,B.E7])
w(B.Vq,A.i1)
x(A.K,[B.wS,B.D7,B.D6,B.D5,B.D8])
x(A.M,[B.a_S,B.a2k,B.a2j,B.a2i,B.a2l])
x(A.a3,[B.Hk,B.XI,B.Dq,B.aj3])})()
A.ph(b.typeUniverse,JSON.parse('{"lE":{"bP":[]},"D7":{"K":[],"l":[]},"D6":{"K":[],"l":[]},"D5":{"K":[],"l":[]},"D8":{"K":[],"l":[]},"Vq":{"aA":[]},"wS":{"K":[],"l":[]},"a_S":{"M":["wS"]},"Hk":{"a3":[],"l":[]},"XI":{"a3":[],"l":[]},"a2k":{"M":["D7"]},"Dq":{"a3":[],"l":[]},"a2j":{"M":["D6"]},"a2i":{"M":["D5"]},"aj3":{"a3":[],"l":[]},"a2l":{"M":["D8"]}}'))
var y=(function rtii(){var x=A.ae
return{u:x("rq"),c:x("em<x>"),r:x("c7<x>"),k:x("H<mV>"),n:x("H<em<x>>"),I:x("H<c7<x>>"),R:x("H<hO>"),Z:x("H<aP<o,@>>"),d:x("H<Sy>"),s:x("H<o>"),p:x("H<l>"),t:x("H<x>"),m:x("bO"),j:x("a7<@>"),L:x("a7<x>"),P:x("aP<o,@>"),f:x("aP<@,@>"),x:x("au<o,x>"),a:x("bE"),K:x("a4"),B:x("Ij"),l:x("+(x,x)"),e:x("d8<mV>"),N:x("o"),C:x("JF"),D:x("JG"),X:x("Vr"),_:x("JH"),U:x("ak<o>"),G:x("nA"),q:x("pe"),b:x("bf<S?>"),y:x("N"),i:x("a2"),z:x("@"),S:x("x"),A:x("bO?"),Y:x("aP<@,@>?"),O:x("a4?"),M:x("+quota,usage(x,x)?"),o:x("fz"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.p7=new B.F8(0,"none")
D.p8=new B.F8(1,"learning")
D.fg=new B.F8(2,"memorized")
D.a77=new A.aC(0,1/0,0,320)
D.eP=new A.S(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a7f=new A.G(D.eP,null,null,null,null,null,null,C.bY)
D.dX=new A.S(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.asl=new A.E(C.yg,null,C.cc,null,null,null)
D.bvr=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.f9,null,null,null,null,null,null,null,null)
D.bcJ=new A.q(!0,C.eR,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.brY=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.bcJ,null,null,null,null,null,null,null,null)
D.aJk=x([D.asl,C.F,D.bvr,D.brY],y.p)
D.afm=new A.fm(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aJk,null)
D.aiP=new A.U(0,26,0,26)
D.aiS=new A.U(0,4,0,6)
D.ajf=new A.U(14,12,14,14)
D.ajX=new A.U(3,0,0,0)
D.anz=new A.Q(63251,"MaterialIcons",null,!1)
D.qy=new A.Q(63677,"MaterialIcons",null,!1)
D.aoo=new A.Q(983209,"MaterialIcons",null,!1)
D.ap1=new A.E(D.aoo,28,C.v,null,null,null)
D.apH=new A.E(C.H8,null,C.il,null,null,null)
D.anh=new A.Q(62961,"MaterialIcons",null,!1)
D.aqp=new A.E(D.anh,null,null,null,null,null)
D.anx=new A.Q(63199,"MaterialIcons",null,!1)
D.aqq=new A.E(D.anx,null,null,null,null,null)
D.aqy=new A.E(C.l4,null,C.eR,null,null,null)
D.aqB=new A.E(C.nq,44,C.i,null,null,null)
D.ar6=new A.E(D.qy,null,D.eP,null,null,null)
D.arn=new A.E(C.nh,null,D.eP,null,null,null)
D.arL=new A.E(D.qy,null,null,null,null,null)
D.ash=new A.E(C.iv,20,D.dX,null,null,null)
D.asE=new A.E(C.nn,30,C.v,null,null,null)
D.at5=new A.E(C.l9,16,C.v,null,null,null)
D.anT=new A.Q(63520,"MaterialIcons",null,!1)
D.atx=new A.E(D.anT,null,null,null,null,null)
D.atJ=new A.E(C.np,null,null,null,null,null)
D.an8=new A.Q(62842,"MaterialIcons",null,!0)
D.atX=new A.E(D.an8,null,null,null,null,null)
D.J9=x([1,3,5],y.t)
D.JX=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aWk=new A.F(C.kR,C.mx,null)
D.aGa=x([D.aWk],y.p)
D.b_M=new A.W(C.nj,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.b_z=new A.W(D.qy,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.b06=new A.W(C.dw,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.ao8=new A.Q(63625,"MaterialIcons",null,!1)
D.b0k=new A.W(D.ao8,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aIi=x([D.b_M,D.b_z,D.b06,D.b0k],A.ae("H<+(Q,o)>"))
D.aKG=x([D.p7,D.p8,D.fg],A.ae("H<F8>"))
D.OA=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aSd=new B.Hj(0,"idle")
D.UP=new B.Hj(1,"loading")
D.jR=new B.Hj(2,"ready")
D.aSe=new B.Hj(3,"failed")
D.ar4=new A.E(C.c1,18,G.cM,null,null,null)
D.bwq=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,K.uj,null,null,null,null,null,null,null,null)
D.aF4=x([D.ar4,C.aX,D.bwq],y.p)
D.b6k=new A.ek(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aF4,null)
D.aVf=new A.F(C.aO,D.b6k,null)
D.ajV=new A.U(2,6,2,4)
D.bcp=new A.q(!0,C.v,null,null,null,null,14,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bk9=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.bcp,null,null,null,null,null,null,null,null)
D.aVu=new A.F(D.ajV,D.bk9,null)
D.bwP=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.f9,null,null,null,null,null,null,null,null)
D.aGu=x([N.tO,C.N,D.bwP],y.p)
D.b6e=new A.ek(C.af,C.cp,C.e,C.h,null,C.l,null,0,D.aGu,null)
D.aVF=new A.F(C.n0,D.b6e,null)
D.Bu=new A.q(!0,D.dX,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bx9=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.Bu,null,null,null,null,null,null,null,null)
D.aVK=new A.F(C.dJ,D.bx9,null)
D.bwl=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aL,C.a0,null,null,null,null,null,null,null)
D.aVT=new A.F(C.C,D.bwl,null)
D.ajS=new A.U(2,0,2,8)
D.bsf=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aL,null,null,null,null,null,null,null,null)
D.aWa=new A.F(D.ajS,D.bsf,null)
D.atf=new A.E(C.l7,30,C.v,null,null,null)
D.bxP=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.Bv,null,null,null,null,null,null,null,null)
D.al3=new A.bU(1,C.ad,D.bxP,null)
D.aGJ=x([D.atf,C.Y,D.al3],y.p)
D.b60=new A.ek(C.af,C.d,C.e,C.h,null,C.l,null,0,D.aGJ,null)
D.asQ=new A.E(C.dw,18,G.cM,null,null,null)
D.a1w=new A.q(!0,G.cM,null,null,null,null,12,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bw2=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a1w,null,null,null,null,null,null,null,null)
D.aFv=x([D.asQ,C.bJ,D.bw2],y.p)
D.b6c=new A.ek(C.af,C.d,C.K,C.h,null,C.l,null,0,D.aFv,null)
D.b8y=new A.T(0,30)
D.tL=new A.T(1/0,54)
D.b8W=new A.T(1/0,48)
D.b8Z=new A.T(1/0,50)
D.b91=new A.T(1/0,52)
D.btS=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.ba0=new A.d7(D.btS,null,null,null,null,null,null,null,null,null,null,null,null,C.x,!1,null,null,null,C.m,null)
D.bbR=new A.q(!0,C.i,null,null,null,null,14.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bcf=new A.q(!0,C.am,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.Bg=new A.q(!0,D.eP,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.ke=new A.q(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a1I=new A.q(!0,D.eP,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bfW=new A.q(!0,C.v,null,null,null,null,24,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgd=new A.q(!0,C.v,null,null,null,null,null,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bh0=new A.q(!0,D.dX,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bh1=new A.q(!0,G.cM,null,null,null,null,null,C.W,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhj=new A.q(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.biZ=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.i7,null,null,null,null,null,null,null,null)
D.bjH=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.cS,null,null,null,null,null,null,null,null)
D.bkc=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oA,null,null,null,null,null,null,null,null)
D.bki=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aL,null,null,null,null,null,null,null,null)
D.bdA=new A.q(!0,G.cM,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bkA=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bdA,null,null,null,null,null,null,null,null)
D.bkH=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aL,null,null,null,null,null,null,null,null)
D.bl6=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.f9,null,null,null,null,null,null,null,null)
D.bmU=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cF,null,null,null,null,null,null,null,null)
D.bnF=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bF,null,null,null,null,null,null,null,null)
D.bnK=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aL,null,null,null,null,null,null,null,null)
D.bob=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.Bz,null,null,null,null,null,null,null,null)
D.bpr=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bq0=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,K.oE,null,null,null,null,null,null,null,null)
D.bqN=new A.m("reset safe mode / WebGPU ban",null,O.a12,null,null,null,null,null,null,null,null)
D.br1=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.Bu,null,null,null,null,null,null,null,null)
D.brc=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aL,null,null,null,null,null,null,null,null)
D.brD=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bw,null,null,null,null,null,null,null,null)
D.brW=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aL,null,null,null,null,null,null,null,null)
D.bsg=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aL,null,null,null,null,null,null,null,null)
D.btE=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a26,null,null,null,null,null,null,null,null)
D.bfa=new A.q(!0,D.eP,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.btI=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bfa,null,null,null,null,null,null,null,null)
D.bu8=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,K.oE,null,null,null,null,null,null,null,null)
D.buH=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0X,null,null,null,null,null,null,null,null)
D.buW=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cF,null,null,null,null,null,null,null,null)
D.bvh=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bvB=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bwd=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aL,null,null,null,null,null,null,null,null)
D.bwe=new A.m("\u062e\u0644\u0635\u062a",null,C.m1,null,null,null,null,null,null,null,null)
D.bwf=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.Bu,null,null,null,null,null,null,null,null)
D.bgf=new A.q(!0,C.cG,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.hm,null,null,null,null,null,null,null,null)
D.bx_=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bgf,null,null,null,null,null,null,null,null)
D.bxd=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bw,null,null,null,null,null,null,null,null)
D.bxh=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.cS,null,null,null,null,null,null,null,null)
D.bxO=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aL,null,null,null,null,null,null,null,null)
D.a3n=new B.aj3(null)
D.bza=new B.D5(null)
D.bzb=new B.Vp(2,1,!0,!1,!1)
D.a3r=new B.Vr(!1,!1,!1,!1,!1,0)
D.j2=new B.nA(0,"ok")
D.uG=new B.nA(1,"near")
D.uH=new B.nA(2,"wrong")
D.uI=new B.nA(3,"missing")
D.a3S=new B.nA(4,"extra")
D.anO=new A.Q(63456,"MaterialIcons",null,!1)
D.bEP=new B.Dq(D.dX,D.anO,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bFs=new B.XI(!1,null)
D.C5=new B.XI(!0,null)
D.mk=new B.E7(0,"idle")
D.uX=new B.E7(1,"playing")
D.uY=new B.E7(2,"recording")
D.oZ=new B.E7(3,"thinking")
D.j9=new B.E7(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cMY","caG",()=>new B.aj4())
x($,"cQp","cqk",()=>A.aD("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cQq","cql",()=>A.aD("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cQC","cqu",()=>A.aD("\u0648\u0670",!0,!1,!1))
x($,"cPY","cq0",()=>A.aD("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cOf","coQ",()=>A.aD("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cPu","cpD",()=>A.aD("[\u0654\u0655]",!0,!1,!1))
x($,"cOg","coR",()=>A.aD("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cOn","coX",()=>A.aD("[\u0624\u0626]",!0,!1,!1))
x($,"cPw","cpF",()=>A.aD("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cQ2","cq3",()=>A.aD("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cPE","cpM",()=>A.aD("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cQn","cbh",()=>A.aD("\\s+",!0,!1,!1))
x($,"cKh","rf",()=>B.crj(D.p7,0,A.c6k(0,!0)))
x($,"cMZ","MJ",()=>new B.Vq($.caG(),D.bzb,B.czg(),D.aSd,$.X()))})()};
(a=>{a["ZQ7fLVIPBg7ciKlONOmBN+OWe34="]=a.current})($__dart_deferred_initializers__);