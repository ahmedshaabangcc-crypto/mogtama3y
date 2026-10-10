((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,K,L,Q,M,G,N,R,I,B={
cu9(d){var x,w,v,u,t,s
if(d instanceof B.lp)return d
try{x=A.cU(d)
w=x.code
v=x.message
u=w==null?"failed":A.a_(w)
t=v==null?"":A.a_(v)
return new B.lp(u,t)}catch(s){u=A.n(d)
return new B.lp("failed",u)}},
ahy:function ahy(){this.b=this.a=null},
b2U:function b2U(d){this.a=d},
b2X:function b2X(){},
b2W:function b2W(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
b2V:function b2V(d){this.a=d},
b30:function b30(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
b2Z:function b2Z(d){this.a=d},
b3_:function b3_(d){this.a=d},
b31:function b31(d){this.a=d},
b33:function b33(d,e,f){this.a=d
this.b=e
this.c=f},
b32:function b32(d,e,f){this.a=d
this.b=e
this.c=f},
b2Y:function b2Y(){},
cua(d,e){return new B.lp(d,e)},
Um:function Um(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.w=i},
IO:function IO(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.f=h
_.r=i
_.w=j},
IQ:function IQ(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
IP:function IP(d,e){this.a=d
this.b=e},
lp:function lp(d,e){this.a=d
this.b=e},
cgI(d){var x,w=$.clk()
w=A.bE(d,w,"\u0627")
x=$.cll()
w=A.bE(w,x,"\u064a")
x=$.clu()
w=A.bE(w,x,"\u0627")
x=$.cjR()
w=A.bE(w,x,"\u0627")
x=$.cl0()
w=A.bE(w,x,"\u0621")
x=$.ckD()
w=A.bE(w,x,"\u0621")
x=$.cjS()
w=A.bE(w,x,"\u0627")
x=$.cjY()
w=A.bE(w,x,"\u0621")
w=A.bE(w,"\u0649","\u064a")
w=A.bE(w,"\u0629","\u0647")
x=$.ckF()
w=A.bE(w,x,"")
x=$.cl3()
w=A.bE(w,x," ")
x=$.ckM()
w=A.bE(w,x," ")
x=$.c6P()
return C.c.O(A.bE(w,x," "))},
cyR(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=d.length,k=e.length
if(l===0)return k
if(k===0)return l
x=k+1
w=y.S
v=J.kj(x,w)
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
c0J(d,e){var x,w,v,u,t,s
if(d===e)return 1
x=A.aD("[\u0627\u0621]",!0,!1,!1)
w=A.bE(d,x,"")
x=A.aD("[\u0627\u0621]",!0,!1,!1)
v=A.bE(e,x,"")
if(w.length!==0&&w===v)return 1
u=d.length
t=e.length
u=u>t?u:t
if(u===0)return 1
s=1-B.cyR(d,e)/u
return s>=1?0.99:s},
E7(d){var x,w,v,u,t,s,r,q=A.a([],y.d)
for(x=C.c.tz(d,$.c6P()),w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.length===0)continue
t=B.cgI(u)
s=A.bE(t," ","")
if(s.length===0){if(q.length!==0){r=q.pop()
q.push(new B.Rr(r.a+" "+u,r.b))}continue}q.push(new B.Rr(u,s))}return q},
cxz(d,e){var x,w,v,u,t=new B.bWm(),s=A.a([],y.s)
for(x=A.fL(e,0,A.iI(5,"count",y.S),A.ak(e).c),w=x.$ti,x=new A.c9(x,x.gM(0),w.i("c9<aY.E>")),w=w.i("aY.E");x.v();){v=x.d
s.push((v==null?w.a(v):v).b)}u=!t.$2(s,D.J7)&&t.$2(d,D.J7)?C.b.jQ(d,5):d
return!t.$2(s,D.NL)&&t.$2(u,D.NL)?C.b.jQ(u,4):u},
cfL(d,e){var x=B.E7(d),w=B.cgI(e),v=y.U
v=A.aa(new A.am(A.a(w.split(" "),y.s),new B.bYl(),v),v.i("Y.E"))
return new B.Hp(x,B.cwK(x,B.cxz(v,x)),w)},
cwK(a5,a6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=A.a([],y.s)
for(x=a5.length,w=0;w<a5.length;a5.length===x||(0,A.K)(a5),++w)a4.push(a5[w].b)
v=a4.length
u=a6.length
t=u+1
x=(v+1)*t
s=y.i
r=A.ck(x,0,!1,s)
q=A.ck(x,0,!1,y.S)
p=A.ck(v*(u===0?1:u),0,!1,s)
for(o=0;o<v;++o)for(x=o*u,n=0;n<u;++n)p[x+n]=B.c0J(a4[o],a6[n])
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
e=2}if(n>=2&&r[h-2]<g&&B.c0J(a4[m],a6[n-2]+a6[n-1])>=1){g=r[h-2]
e=3}if(s&&r[i+n-1]<g&&B.c0J(a4[j]+a4[m],a6[n-1])>=1){g=r[i+n-1]
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
if(a2>=1)m=D.iQ
else m=a2>=0.6?D.ui:D.uj
a1.push(new B.mG(o,x,s,m))
break
case 1:--o
a1.push(new B.mG(o,a4[o],null,D.uk))
break
case 2:--n
a1.push(new B.mG(null,null,a6[n],D.a38))
break
case 3:--o
a3=n-2
a1.push(new B.mG(o,a4[o],a6[a3]+" "+a6[n-1],D.iQ))
n=a3
break
default:x=o-1;--n
a1.push(new B.mG(x,a4[x],a6[n],D.iQ))
o-=2
a1.push(new B.mG(o,a4[o],a6[n],D.iQ))}}a4=y.e
a4=A.aa(new A.d8(a1,a4),a4.i("aY.E"))
return a4},
ng:function ng(d,e){this.a=d
this.b=e},
Rr:function Rr(d,e){this.a=d
this.b=e},
mG:function mG(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Hp:function Hp(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.d=$},
aUa:function aUa(d){this.a=d},
aU9:function aU9(){},
bWm:function bWm(){},
bYl:function bYl(){},
cmj(d,e,f){return new B.r3(d,e,f)},
czK(d){var x
A:{if("memorized"===d){x=D.f9
break A}if("learning"===d){x=D.oS
break A}x=D.oR
break A}return x},
chF(d,e){return d>=1&&d<=114&&e>=1&&e<=H.cK[d-1].a[1]},
cub(){var x=y.S
return new B.ahz(A.C(x,y.u),A.aV(x))},
b36(d){var x=d.f9()
return C.c.df(C.j.j(A.bo(x)),4,"0")+"-"+C.c.df(C.j.j(A.bt(x)),2,"0")+"-"+C.c.df(C.j.j(A.bU(x)),2,"0")},
ccR(d){var x=y.x,w=A.aa(new A.au(A.a(d.split("-"),y.s),A.cB6(),x),x.i("aY.E"))
return B.b36(A.dk(w[0],w[1],w[2]-1,12,0,0,0))},
c3S(d){var x,w,v,u,t,s,r,q,p=y.S,o=A.C(p,y.u),n=A.aV(p),m=new B.ahz(o,n),l=d.h(0,"rows")
if(y.f.b(l))for(x=l.gcK(),x=x.ga_(x),w=y.j;x.v();){v=x.gJ()
u=A.dS(A.n(v.a),null)
t=v.b
v=!0
if(u!=null)if(w.b(t))if(J.aM(t)>=3){v=C.j.aJ(u,1000)
s=C.j.a0(u,1000)
v=!(v>=1&&v<=114&&s>=1&&s<=H.cK[v-1].a[1])}if(v)continue
v=J.ba(t)
r=C.f.c2(A.d3(v.h(t,0)))
if(r<0||r>=3)continue
o.q(0,u,new B.r3(D.aIP[r],C.f.c2(A.d3(v.h(t,1))),new A.b3(A.lO(C.f.c2(A.d3(v.h(t,2))),0,!0),0,!0)))}q=d.h(0,"dirty")
if(y.j.b(q)){x=J.ayB(q,y.o)
p=A.m8(x,new B.b35(),x.$ti.i("Y.E"),p)
n.A(0,new A.am(p,o.ga2L(),A.y(p).i("am<Y.E>")))}m.c=A.u(d.h(0,"last"))
p=A.aL(d.h(0,"streak"))
p=p==null?null:C.f.c2(p)
p=m.d=p==null?0:p
o=A.aL(d.h(0,"best"))
o=o==null?null:C.f.c2(o)
m.e=o==null?p:o
return m},
ay_(d,e){return"https://everyayah.com/data/Husary_Muallim_128kbps/"+C.c.df(C.j.j(d),3,"0")+C.c.df(C.j.j(e),3,"0")+".mp3"},
Ep:function Ep(d,e){this.a=d
this.b=e},
r3:function r3(d,e,f){this.a=d
this.b=e
this.c=f},
ahz:function ahz(d,e){var _=this
_.a=d
_.b=e
_.c=null
_.e=_.d=0},
b37:function b37(){},
b38:function b38(){},
b35:function b35(){},
Uk:function Uk(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
crI(){return new B.wm(null)},
cDp(d,e){var x,w,v,u,t={},s=H.cK[e-1].a[1],r=$.LJ().c
t.a=1
x=r.a
w=e*1000
v=1
for(;;){if(v<=s){v=x.h(0,w+v)
v=(v==null?$.qS():v).a===D.f9}else v=!1
if(!v)break
v=++t.a}x=t.a
if(x>s){t.a=1
u=1}else u=x
x=s<=10
if(x)u=1
t.b=u
t.c=x?s:C.j.cU(u+4,1,s)
return A.ee(C.cS,new B.c_B(t,s,e),d,!0,null,null,!1,y.l)},
c5E(d){return A.df(0,0,0,0,0,C.j.cU(C.f.aw(6+d*1.2),25,90))},
c4C(d){return E.br(C.j.aJ(d,60))+":"+C.c.df(E.br(C.j.a0(d,60)),2,"\u0660")},
cht(d){return A.ee(C.cS,new B.c0m($.LJ()),d,!0,null,null,!1,y.H)},
LE(d){var x,w=d.a
A:{if("timeout"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0627\u062a\u0623\u062e\u0631 \u0623\u0648\u064a \u0648\u0645\u0631\u062f\u0651\u0634\u060c \u0641\u0648\u0642\u0651\u0641\u0646\u0627\u0647 \u0648\u062c\u0631\u0651\u0628\u0646\u0627 \u062a\u0627\u0646\u064a \u0628\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0623\u062e\u0641 \u0648\u0645\u0646\u0641\u0639\u0634. \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}if("crashed"===w){x="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0642\u0641 \u0641\u062c\u0623\u0629 (\u063a\u0627\u0644\u0628\u064b\u0627 \u0630\u0627\u0643\u0631\u0629 \u0627\u0644\u062c\u0647\u0627\u0632 \u0645\u0634 \u0645\u0643\u0641\u064a\u0629). \u0627\u0642\u0641\u0644 \u0627\u0644\u062a\u0627\u0628\u0627\u062a \u0648\u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0627\u0644\u062a\u0627\u0646\u064a\u0629 \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u2014 \u0648\u0644\u0648 \u0627\u062a\u0643\u0631\u0631\u062a \u0627\u0628\u0639\u062a\u0644\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u062a\u062d\u062a."
break A}x=d.gkQ()
break A}return x},
cEH(d,e,f){var x,w=new B.c0C(),v=w.$1(f),u=w.$1("\xab\u0627\u0644\u0645\u062d\u0641\u0651\u0638\xbb \u0645\u0634\u0643\u0644\u0629 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 ("+e+")\n"+d.a+": "+d.b+"\n"),t=1990-u.length
if(v.length>t)v=t<=1?"":C.c.a7(v,0,t-1)+"\u2026"
x=u+v
return x.length>1990?C.c.a7(x,0,1990):x},
chA(a4){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3
try{x=y.P.a(C.au.fQ(a4,null))
s=y.Y
r=s.a(J.av(x,"rec"))
w=r==null?C.h8:r
q=s.a(J.av(x,"last"))
v=q==null?C.h8:q
u=new B.c0B()
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
a1=J.e(J.av(x,"safe"),!0)?" \xb7 safe mode":""
a2=J.e(J.av(x,"nogpu"),!0)?" \xb7 no-gpu":""
return"record "+s+" s ("+p+", "+o+" Hz, peak "+n+", "+m+") \u2192 stop/decode "+l+" ms \u2192 resample "+k+" ms \u2192 infer "+j+" ms (mel "+i+", enc "+h+", dec "+g+") \u2192 wall "+f+" ms \xb7 "+e+" \xd7"+d+a0+a1+a2}catch(a3){return""}},
Gv:function Gv(d,e){this.a=d
this.b=e},
Ul:function Ul(d,e,f,g,h){var _=this
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
b39:function b39(d){this.a=d},
b3a:function b3a(d){this.a=d},
b3b:function b3b(d){this.a=d},
wm:function wm(d){this.a=d},
ZE:function ZE(d,e){var _=this
_.d=d
_.e=e
_.f=!1
_.c=_.a=_.w=_.r=null},
bFM:function bFM(d){this.a=d},
bFL:function bFL(d,e){this.a=d
this.b=e},
bFN:function bFN(d){this.a=d},
bFK:function bFK(d,e){this.a=d
this.b=e},
bFO:function bFO(){},
bFy:function bFy(){},
bFE:function bFE(d,e,f){this.a=d
this.b=e
this.c=f},
bFF:function bFF(){},
bFI:function bFI(d){this.a=d},
bFH:function bFH(){},
bFJ:function bFJ(d){this.a=d},
bFB:function bFB(d,e){this.a=d
this.b=e},
bFC:function bFC(d){this.a=d},
bFA:function bFA(){},
bFD:function bFD(d){this.a=d},
bFz:function bFz(d){this.a=d},
bFG:function bFG(d,e){this.a=d
this.b=e},
Gw:function Gw(d,e,f){this.c=d
this.d=e
this.a=f},
Wz:function Wz(d,e){this.c=d
this.a=e},
c_B:function c_B(d,e,f){this.a=d
this.b=e
this.c=f},
c_y:function c_y(d,e,f){this.a=d
this.b=e
this.c=f},
c_A:function c_A(d,e){this.a=d
this.b=e},
c_x:function c_x(d,e){this.a=d
this.b=e},
c_w:function c_w(d,e){this.a=d
this.b=e},
c_z:function c_z(d,e){this.a=d
this.b=e},
c_s:function c_s(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
c_r:function c_r(d,e,f){this.a=d
this.b=e
this.c=f},
c_t:function c_t(d){this.a=d},
c_u:function c_u(d){this.a=d},
c_v:function c_v(d,e){this.a=d
this.b=e},
Ds:function Ds(d,e){this.a=d
this.b=e},
Cw:function Cw(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a11:function a11(d,e){var _=this
_.d=d
_.e=$
_.f=e
_.w=_.r=null
_.x=!1
_.y=0
_.ax=_.at=_.as=_.Q=_.z=null
_.ay=0
_.c=_.a=_.ch=null},
bSI:function bSI(){},
bSY:function bSY(d,e){this.a=d
this.b=e},
bT1:function bT1(d){this.a=d},
bT2:function bT2(d){this.a=d},
bT3:function bT3(d,e,f){this.a=d
this.b=e
this.c=f},
bT5:function bT5(d){this.a=d},
bT6:function bT6(d){this.a=d},
bT4:function bT4(){},
bT8:function bT8(d){this.a=d},
bT7:function bT7(d){this.a=d},
bT9:function bT9(d,e){this.a=d
this.b=e},
bTb:function bTb(d){this.a=d},
bTc:function bTc(d){this.a=d},
bTa:function bTa(){},
bSX:function bSX(d,e,f){this.a=d
this.b=e
this.c=f},
bSZ:function bSZ(d,e,f){this.a=d
this.b=e
this.c=f},
bSQ:function bSQ(d){this.a=d},
bSR:function bSR(d){this.a=d},
bSP:function bSP(){},
bSS:function bSS(){},
bST:function bST(d,e){this.a=d
this.b=e},
bTh:function bTh(d){this.a=d},
bTi:function bTi(d){this.a=d},
bTj:function bTj(d,e){this.a=d
this.b=e},
bTg:function bTg(d){this.a=d},
bTk:function bTk(d,e){this.a=d
this.b=e},
bSW:function bSW(){},
bSV:function bSV(d){this.a=d},
bSU:function bSU(d,e){this.a=d
this.b=e},
bT0:function bT0(d){this.a=d},
bT_:function bT_(d){this.a=d},
bTd:function bTd(){},
bTe:function bTe(){},
bTf:function bTf(){},
bSJ:function bSJ(d,e,f){this.a=d
this.b=e
this.c=f},
bSK:function bSK(d){this.a=d},
bSM:function bSM(){},
bSL:function bSL(){},
bSN:function bSN(d){this.a=d},
bSO:function bSO(d){this.a=d},
CN:function CN(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
Cv:function Cv(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
a10:function a10(d,e,f,g,h){var _=this
_.d=d
_.e=null
_.f=e
_.r=f
_.w=g
_.x=0
_.as=_.Q=_.z=_.y=null
_.at=h
_.c=_.a=null},
bSr:function bSr(){},
bSA:function bSA(d,e){this.a=d
this.b=e},
bSB:function bSB(d){this.a=d},
bSz:function bSz(){},
bSD:function bSD(d){this.a=d},
bSC:function bSC(d,e){this.a=d
this.b=e},
bSE:function bSE(d,e){this.a=d
this.b=e},
bSv:function bSv(d,e){this.a=d
this.b=e},
bSw:function bSw(d,e,f){this.a=d
this.b=e
this.c=f},
bSx:function bSx(d,e,f){this.a=d
this.b=e
this.c=f},
bSs:function bSs(d,e,f){this.a=d
this.b=e
this.c=f},
bSt:function bSt(d,e,f){this.a=d
this.b=e
this.c=f},
bSu:function bSu(d,e){this.a=d
this.b=e},
bSy:function bSy(d){this.a=d},
bSF:function bSF(){},
bSG:function bSG(d,e){this.a=d
this.b=e},
bSH:function bSH(d,e){this.a=d
this.b=e},
Cu:function Cu(d){this.a=d},
a1_:function a1_(d){this.d=d
this.c=this.a=null},
bSi:function bSi(){},
bSp:function bSp(d){this.a=d},
bSq:function bSq(){},
bSo:function bSo(d,e){this.a=d
this.b=e},
bSn:function bSn(d,e,f){this.a=d
this.b=e
this.c=f},
bSm:function bSm(d,e,f){this.a=d
this.b=e
this.c=f},
bSl:function bSl(d){this.a=d},
bSj:function bSj(d){this.a=d},
bSk:function bSk(d){this.a=d},
c0m:function c0m(d){this.a=d},
c0l:function c0l(d){this.a=d},
c0g:function c0g(d,e){this.a=d
this.b=e},
c0i:function c0i(){},
c0h:function c0h(){},
c0j:function c0j(d,e){this.a=d
this.b=e},
c0k:function c0k(d,e){this.a=d
this.b=e},
ahx:function ahx(d){this.a=d},
b2T:function b2T(d){this.a=d},
c0C:function c0C(){},
c0D:function c0D(){},
Cx:function Cx(d,e,f){this.c=d
this.d=e
this.a=f},
a12:function a12(){var _=this
_.f=_.e=_.d=!1
_.c=_.a=_.r=null},
bTl:function bTl(d){this.a=d},
bTm:function bTm(d){this.a=d},
bTn:function bTn(d,e){this.a=d
this.b=e},
bTo:function bTo(d){this.a=d},
bTq:function bTq(d){this.a=d},
bTp:function bTp(d){this.a=d},
c0B:function c0B(){}},D,O,P,H,E,F
J=c[1]
A=c[0]
C=c[2]
K=c[14]
L=c[18]
Q=c[20]
M=c[31]
G=c[13]
N=c[22]
R=c[10]
I=c[36]
B=a.updateHolder(c[8],B)
D=c[37]
O=c[29]
P=c[34]
H=c[27]
E=c[15]
F=c[17]
B.ahy.prototype={
qM(){var x=this,w=x.a
if(w!=null)return A.ec(w,y.m)
w=x.b
return w==null?x.b=new B.b2U(x).$0():w},
u_(d,e){return this.aLl(d,e,e)},
aLl(d,e,f){var x=0,w=A.k(f),v,u=2,t=[],s,r,q,p
var $async$u_=A.f(function(g,h){if(g===1){t.push(h)
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
r=B.cu9(s)
throw A.q(r)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$u_,w)},
o4(d,e){var x=A.em(d[e])
if(x==null)x=null
return x===!0},
Me(){var x=0,w=A.k(y.X),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g
var $async$Me=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
h=A
g=A
x=7
return A.c(s.qM(),$async$Me)
case 7:r=h.cU(g.d0(e,"support",null,null,null,null))
q=s.o4(r,"worker")
p=s.o4(r,"wasm")
o=s.o4(r,"mic")
n=s.o4(r,"audio")
s.o4(r,"webgpu")
m=s.o4(r,"secure")
s.o4(r,"ios")
l=A.kJ(r.memory)
if(l==null)l=null
if(l==null)l=0
s.o4(r,"isolated")
k=A.kJ(r.cores)
if(k!=null)C.f.aw(k)
v=new B.Um(q,p,o,n,m,l)
x=1
break
u=2
x=6
break
case 4:u=3
i=t.pop()
v=D.a2I
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Me,w)},
E2(){var x=0,w=A.k(y.M),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$E2=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
m=A
l=A
k=A
x=8
return A.c(s.qM(),$async$E2)
case 8:x=7
return A.c(m.eF(l.cU(k.d0(e,"storage",null,null,null,null)),y.A),$async$E2)
case 7:r=e
if(r==null){v=null
x=1
break}q=C.f.aw(A.dI(r.quota))
p=C.f.aw(A.dI(r.usage))
v=new A.arw(q,p)
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
return A.j($async$E2,w)},
bgr(){var x=y.K
A.Oy(this.qM().bB(new B.b2X(),x),x)},
qL(d,e){var x=A.kJ(d[e])
x=x==null?null:C.f.aw(x)
return x==null?0:x},
bdS(d,e,f){return this.u_(new B.b2W(this,d,e,f),y.C)},
gaiY(){var x,w
try{x=A.my(b.G.sessionStorage)
return x}catch(w){return null}},
gaqm(){var x=A.em(b.G.mogtama3yTutorIsolated)
if(x==null)x=null
return x===!0},
a80(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
try{m=b.G
l=A.em(m.crossOriginIsolated)
if(l==null)l=f
if(l===!0)return!1
if(this.gaqm())return!1
l=A.em(m.isSecureContext)
if(l==null)l=f
if(l!==!0)return!1
x=A.cU(m.navigator)
if(!("serviceWorker" in x))return!1
w=A.a_(x.userAgent)
l=A.kJ(x.maxTouchPoints)
k=l==null?f:l
v=k==null?0:k
l=A.u(x.platform)
j=l==null?f:l
u=j==null?"":j
l=A.aD("iPad|iPhone|iPod",!0,!1,!1)
if(!l.b.test(w))i=J.e(u,"MacIntel")&&v>1
else i=!0
t=i
l=A.aD("Chrome/|Chromium/|Firefox/|Edg/",!0,!1,!1)
s=l.b.test(w)
if(t||!s)return!1
l=A.kJ(x.hardwareConcurrency)
h=l==null?f:l
r=h==null?0:h
if(r>0&&r<3)return!1
q=Date.now()
l=this.gaiY()
l=l==null?f:A.u(A.d0(l,"getItem","mt.tutor.iso",f,f,f))
if(l==null)l=f
p=A.dS(l==null?"":l,f)
if(p!=null&&q-p<3e4)return!1
o=A.my(m.localStorage)
m=o
m=m==null?f:A.u(A.d0(m,"getItem","mt.tutor.noiso",f,f,f))
if(m==null)m=f
n=A.dS(m==null?"":m,f)
if(n!=null&&q-n<2592e5)return!1
return!0}catch(g){return!1}},
aoV(){var x,w,v,u,t,s,r=null
try{x=this.gaiY()
if(x!=null)A.d0(x,"setItem","mt.tutor.iso",""+Date.now(),r,r)}catch(w){}x=b.G
v=A.cU(x.location)
u=A.a_(v.hash)
t=A.a_(v.search)
s=A.bl(A.a_(A.cU(x.document).baseURI),0,r).a2("tutor/").j(0)
x=u.length===0?"#/masjid/tools/tutor":u
A.d0(v,"replace",s+t+x,r,r,r)},
bdB(){var x,w=null,v=b.G,u=A.cU(v.history),t=A.kJ(u.length),s=t==null?w:t
if((s==null?0:s)>1)A.d0(u,"back",w,w,w,w)
else{x=A.a_(A.cU(v.document).baseURI)
A.d0(A.cU(v.location),"replace",A.bl(x,0,w).a2("./").j(0)+"#/",w,w,w)}},
a8b(d,e,f,g,h){return this.u_(new B.b30(this,e,d,f,h,g),y.H)},
a8e(){return this.u_(new B.b31(this),y.D)},
a2o(){var x=null,w=this.a
if(w!=null)A.d0(w,"cancelRecording",x,x,x,x)},
akj(d){var x,w,v=this,u=A.u(d.text)
if(u==null)u=null
if(u==null)u=""
x=v.qL(d,"ms")
w=A.kJ(d.seconds)
if(w==null)w=null
if(w==null)w=0
return new B.IQ(u,x,w,v.qL(d,"frames"),v.qL(d,"tokens"),v.o4(d,"retried"),v.qL(d,"encMs"),v.qL(d,"decMs"),v.qL(d,"featMs"))},
agP(d){var x={}
x.words=d
return x},
att(d,e){return this.u_(new B.b33(this,d,e),y._)},
biC(d,e){return this.u_(new B.b32(this,d,e),y._)},
Kl(d,e){return this.bgv(d,e)},
bgv(d,e){var x=0,w=A.k(y.y),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$Kl=A.f(function(f,g){if(f===1){t.push(g)
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
o=A.aa(new A.au(d,new B.b2Y(),o),o.i("aY.E"))
x=11
return A.c(A.eF(A.cU(A.d0(r,"play",o,e,null,null)),y.y),$async$Kl)
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
return A.j($async$Kl,w)},
LX(){var x=null,w=this.a
if(w!=null)A.d0(w,"stopPlayback",x,x,x,x)},
IQ(){var x,w,v,u=null
try{w=this.a
x=w==null?u:A.a_(A.d0(w,"diag",u,u,u,u))
w=x
if(w==null)w=u
if(w==null)w="{}"
return w}catch(v){return"{}"}},
bhK(){var x,w,v=null
try{x=this.a
if(x!=null)A.d0(x,"resetDevice",v,v,v,v)}catch(w){}},
a5I(d){var x=this.a
if(x!=null)A.d0(x,"prefetch",d,null,null,null)}}
B.Um.prototype={}
B.IO.prototype={
gmJ(){var x=this.f,w=x>0?"CPU \xd7"+x:""
x=this.a
if(x==="webgpu")return"WebGPU"
if(C.c.n(x,"webgpu"))return"WebGPU + "+w
return w.length===0?x:w}}
B.IQ.prototype={
gS4(){var x=this,w=C.f.am(x.d/100,0),v=x.f?" (retried on 30 s)":""
return"window "+w+" s, "+x.e+" tokens"+v+", mel "+x.x+" ms, encoder "+x.r+" ms, decoder "+x.w+" ms"}}
B.IP.prototype={}
B.lp.prototype={
gkQ(){var x,w=this.a
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
B.ng.prototype={
R(){return"WordStatus."+this.b}}
B.Rr.prototype={}
B.mG.prototype={
j(d){var x,w=this.b
if(w==null)w=""
x=this.c
if(x==null)x=""
return this.d.b+":"+w+"->"+x}}
B.Hp.prototype={
gLW(){var x,w=this,v=w.d
if(v===$){x=new B.aUa(w).$0()
w.d!==$&&A.ap()
w.d=x
v=x}return v},
gJ7(){var x,w,v,u,t,s=A.a([],y.s)
for(x=this.b,w=x.length,v=0;v<x.length;x.length===w||(0,A.K)(x),++v){u=x[v]
if(u.d===D.a38&&u.c!=null){t=u.c
t.toString
s.push(t)}}return s},
gbeI(){return J.h2(this.gLW(),new B.aU9()).gM(0)},
gt3(){var x=this.a
return x.length!==0&&this.gbeI()===x.length&&this.gJ7().length===0}}
B.Ep.prototype={
R(){return"AyahStatus."+this.b}}
B.r3.prototype={}
B.ahz.prototype={
a5k(d,e){var x=this.a.h(0,d*1000+e)
return x==null?$.qS():x},
aXR(d){var x=this,w=B.b36(d),v=x.c
if(v===w)return
v=v!=null&&v===B.ccR(w)?x.d+1:1
x.d=v
if(v>x.e)x.e=v
x.c=w},
ao6(){var x=Date.now(),w=B.b36(new A.b3(x,0,!1))
x=this.c
return x===w||x===B.ccR(w)?this.d:0},
asx(d,e,f,g){var x=this,w=new A.b3(Date.now(),0,!1),v=x.a5k(d,e),u=g?C.j.cU(v.b+1,0,100):0,t=g&&u>=f?D.f9:D.oS,s=new B.r3(t,u,w.i4()),r=d*1000+e
x.a.q(0,r,s)
x.b.F(0,r)
x.aXR(w)
return s},
a5b(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=H.cK[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qS():s).a===D.f9)++u}return u},
bdz(d){var x,w,v,u,t,s
for(x=d-1,w=this.a,v=d*1000,u=0,t=1;t<=H.cK[x].a[1];++t){s=w.h(0,v+t)
if((s==null?$.qS():s).a===D.oS)++u}return u},
garw(){var x=this.a,w=A.y(x).i("cd<2>")
return new A.am(new A.cd(x,w),new B.b37(),w.i("am<Y.E>")).gM(0)},
gax7(){var x=this.a,w=A.y(x).i("bG<1>")
w=A.m8(new A.bG(x,w),new B.b38(),w.i("Y.E"),y.S)
w=A.eS(w,A.y(w).i("Y.E"))
x=A.aa(w,A.y(w).c)
C.b.ma(x)
return x},
dA(){var x,w,v,u,t,s=this,r=y.N,q=A.C(r,y.L)
for(x=s.a,x=new A.eB(x,A.y(x).i("eB<1,2>")).ga_(0),w=y.t;x.v();){v=x.d
u=v.a
t=v.b
q.q(0,""+u,A.a([t.a.a,t.b,t.c.a],w))}x=s.b
x=A.aa(x,A.y(x).c)
return A.J(["v",1,"rows",q,"dirty",x,"last",s.c,"streak",s.d,"best",s.e],r,y.z)},
b9x(){var x,w,v,u,t,s,r,q,p,o=A.a([],y.Z)
for(x=this.b,x=A.b1r(x,300,A.y(x).c),x=new A.Iu(J.aE(x.a),x.b,A.y(x).i("Iu<1>")),w=y.N,v=y.z,u=this.a;x.v();){t=x.gJ()
s=C.j.aJ(t,1000)
t=C.j.a0(t,1000)
r=s*1000+t
q=u.h(0,r)
q=(q==null?$.qS():q).a===D.f9?"memorized":"learning"
p=u.h(0,r)
if(p==null)p=$.qS()
r=u.h(0,r)
o.push(A.J(["surah",s,"ayah",t,"status",q,"perfect_count",p.b,"updated_at",(r==null?$.qS():r).c.jK()],w,v))}return o},
be9(d){var x,w,v,u,t,s,r
for(x=d.length,w=this.a,v=this.b,u=0;u<d.length;d.length===x||(0,A.K)(d),++u){t=d[u]
s=A.ex(t.h(0,"surah"))*1000+A.ex(t.h(0,"ayah"))
r=w.h(0,C.j.aJ(s,1000)*1000+C.j.a0(s,1000))
if((r==null?$.qS():r).c.jK()===t.h(0,"updated_at"))v.K(0,s)}},
beh(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
for(x=J.aE(d),w=this.b,v=this.a,u=y.f,t=!1;x.v();){s=x.gJ()
if(!u.b(s))continue
r=A.aL(s.h(0,"surah"))
q=r==null?null:C.f.c2(r)
r=A.aL(s.h(0,"ayah"))
p=r==null?null:C.f.c2(r)
o=A.dW(A.n(s.h(0,"updated_at")))
r=!0
if(q!=null)if(p!=null)if(o!=null)r=!(q>=1&&q<=114&&p>=1&&p<=H.cK[q-1].a[1])
if(r)continue
n=B.czK(s.h(0,"status"))
if(n===D.oR)continue
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
v.q(0,r,new B.r3(n,C.j.cU(l==null?0:l,0,100),o.i4()))
w.K(0,r)
t=!0}return t}}
B.Uk.prototype={
Iz(d,e,f,g,h){var x=this,w=g==null?x.a:g,v=h==null?x.b:h,u=d==null?x.c:d,t=e==null?x.d:e
return new B.Uk(w,v,u,t,f==null?x.e:f)},
b7Q(d){var x=null
return this.Iz(x,x,d,x,x)},
anC(d){var x=null
return this.Iz(x,d,x,x,x)},
b7U(d){var x=null
return this.Iz(x,x,x,x,d)},
b7d(d){var x=null
return this.Iz(d,x,x,x,x)},
b7R(d){var x=null
return this.Iz(x,x,x,d,x)},
dA(){var x=this
return A.J(["n",x.a,"r",x.b,"auto",x.c,"hide",x.d,"in",x.e],y.N,y.z)}}
B.Gv.prototype={
R(){return"ModelState."+this.b}}
B.Ul.prototype={
vj(){var x=this.Q
return x==null?this.Q=new B.b39(this).$0():x},
ql(d){return this.avk(d)},
avk(d){var x=0,w=A.k(y.H),v=this
var $async$ql=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:v.b=d
v.a6()
x=2
return A.c(A.j5("mt.tutor.settings",C.au.iA(d.dA(),null)),$async$ql)
case 2:return A.i(null,w)}})
return A.j($async$ql,w)},
zl(){var x=0,w=A.k(y.H),v=this,u
var $async$zl=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:v.a6()
x=2
return A.c(A.j5("mt.tutor.progress",C.au.iA(v.c.dA(),null)),$async$zl)
case 2:u=v.as
if(u!=null)u.aD()
v.as=A.cS(C.y,v.gaC4())
return A.i(null,w)}})
return A.j($async$zl,w)},
LG(d,e,f){return this.aw6(d,e,f)},
aw6(d,e,f){var x=0,w=A.k(y.H),v=this
var $async$LG=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:v.z=new A.aQ(d,e,f)
x=2
return A.c(A.j5("mt.tutor.last",C.au.iA(A.J(["s",d,"f",e,"t",f],y.N,y.S),null)),$async$LG)
case 2:return A.i(null,w)}})
return A.j($async$LG,w)},
CL(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m
var $async$CL=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:n=s.f
if(n===D.TW||n===D.jG){x=1
break}s.f=D.TW
s.y=null
s.a6()
u=4
n=A.lq().geV().h(0,"tutor_device")
if(n==null)n="auto"
p=A.lq().geV().h(0,"tutor_threads")
p=A.dS(p==null?"":p,null)
if(p==null)p=0
x=7
return A.c(s.a.bdS(new B.b3a(s),n,p),$async$CL)
case 7:s.x=e
s.f=D.jG
n=A.lq().geV().h(0,"debug")
if(n==="1"){n=s.x
n.toString
r=n
A.qP().$1("[tutor] model ready: "+r.a+" "+r.b+" threads="+r.f+" isolated="+r.r+" in "+r.c+" ms (warm-up "+r.w+" ms, cached before: "+r.d+")")}u=2
x=6
break
case 4:u=3
m=t.pop()
n=A.a9(m)
if(n instanceof B.lp){q=n
s.f=D.aQc
s.y=q
n=A.lq().geV().h(0,"debug")
if(n==="1")A.qP().$1("[tutor] model failed: "+A.n(q))}else throw m
x=6
break
case 3:x=2
break
case 6:s.a6()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$CL,w)},
wk(){var x=0,w=A.k(y.H),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e
var $async$wk=A.f(function(a0,a1){if(a0===1){t.push(a1)
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
return A.c(p.aQ("quran_tutor_progress").d6("surah, ayah, status, perfect_count, updated_at"),$async$wk)
case 7:o=a1
n=r.c.beh(o)
m=0,k=y.N,i=y.z
case 8:if(!(m<25)){x=10
break}l=r.c.b9x()
if(J.aM(l)===0){x=10
break}h=p
g=A.J(["p_rows",l],k,i)
f=h.CW
f===$&&A.b()
f.b.A(0,A.mO(h.x,k,k))
x=11
return A.c(f.bi7("quran_tutor_save",!1,g,i),$async$wk)
case 11:r.c.be9(l)
case 9:++m
x=8
break
case 10:x=12
return A.c(A.j5("mt.tutor.progress",C.au.iA(r.c.dA(),null)),$async$wk)
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
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$wk,w)},
Kz(d){return this.bhM(d)},
bhM(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o
var $async$Kz=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:p=B.c3S(t.c.dA()).dA()
y.f.a(p.h(0,"rows")).e8(0,new B.b3b(d))
t.c=B.c3S(p)
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
case 6:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$Kz,w)}}
B.wm.prototype={
P(){var x=$.LJ()
return new B.ZE(x,new A.ae(C.J,$.S()))}}
B.ZE.prototype={
X(){var x,w,v=this
v.Y()
x=v.d
x.ad(v.gog())
w=y.a
x.vj().bB(new B.bFM(v),w)
G.aSC().bB(new B.bFN(v),w).fO(new B.bFO())
A.Oy(G.c3d(),y.y)},
xs(){if(this.c!=null)this.k(new B.bFy())},
m(){var x,w=this
w.d.V(w.gog())
x=w.e
x.p$=$.S()
x.L$=0
w.a1()},
Pc(){var x=0,w=A.k(y.H),v,u=this,t,s
var $async$Pc=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:s=u.d
x=3
return A.c(s.ql(s.b.b7Q(!0)),$async$Pc)
case 3:t=s.a
t.bgr()
if(t.a80()){t.aoV()
x=1
break}s.CL()
case 1:return A.i(v,w)}})
return A.j($async$Pc,w)},
xt(d,e,f){return this.aVJ(d,e,f)},
b39(d){return this.xt(d,null,null)},
aVJ(d,e,f){var x=0,w=A.k(y.H),v,u=this,t,s,r
var $async$xt=A.f(function(g,h){if(g===1)return A.h(h,w)
for(;;)switch(x){case 0:if(u.w==null){u.c.I(y.q).f.Z(A.aT(null,null,null,null,null,C.m,null,A.d("\u0644\u062d\u0638\u0629\u2026 \u0628\u0646\u062c\u0647\u0651\u0632 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641",null,null,null,null,null,null,null,null),null,C.y,null,null,null,null,null,null,null,null,null,null))
x=1
break}x=e!=null&&f!=null?3:5
break
case 3:t=new A.a0(e,f)
x=4
break
case 5:s=u.c
s.toString
x=6
return A.c(B.cDp(s,d),$async$xt)
case 6:t=h
case 4:if(t==null||u.c==null){x=1
break}x=7
return A.c(u.d.LG(d,t.a,t.b),$async$xt)
case 7:s=u.c
if(s==null){x=1
break}r=y.z
x=8
return A.c(A.N(s,!1).az(A.az(new B.bFE(u,d,t),null,r),r),$async$xt)
case 8:if(u.c!=null)u.k(new B.bFF())
case 1:return A.i(v,w)}})
return A.j($async$xt,w)},
t(d){var x=null,w=this.d,v=w.b,u=A.a([],y.p),t=w.a
if(t.gaqm()&&!A.N(d,!1).uM())u.push(A.bT(x,x,x,x,C.xR,x,x,t.gbdA(),x,x,x,"\u0631\u062c\u0648\u0639 \u0644\u0645\u0633\u062c\u062f\u064a",x))
t=v.e
if(t)u.push(A.bT(x,x,x,x,D.arV,x,x,new B.bFI(d),x,x,x,"\u062a\u0642\u062f\u0651\u0645\u064a",x))
u.push(A.bT(x,x,x,x,C.io,x,x,new B.bFJ(d),x,x,x,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",x))
if(!w.e)w=D.aEn
else w=t?this.aQI():this.aRi()
return K.x3(u,w,"\u0627\u0644\u0645\u062d\u0641\u0651\u0638")},
aRi(){var x,w,v,u,t,s,r,q,p=null,o=this.d.d
if(o==null)o=D.a2I
x=this.r
w=x==null?p:x.a-x.b
if(!(o.a&&o.b))v="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u062f\u0639\u0645 \u062a\u0634\u063a\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638. \u062c\u0631\u0651\u0628 \u0623\u062d\u062f\u062b \u0646\u0633\u062e\u0629 \u0645\u0646 Chrome (\u0623\u0646\u062f\u0631\u0648\u064a\u062f) \u0623\u0648 Safari (\u0622\u064a\u0641\u0648\u0646)."
else if(!o.f)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u062d\u062a\u0627\u062c \u0627\u0644\u0645\u0648\u0642\u0639 \u064a\u0641\u062a\u062d \u0639\u0644\u0649 https \u0639\u0634\u0627\u0646 \u064a\u0633\u062a\u062e\u062f\u0645 \u0627\u0644\u0645\u0627\u064a\u0643."
else v=!o.c||!o.d?"\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0633\u0645\u062d \u0628\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0645\u0646 \u0627\u0644\u0645\u0627\u064a\u0643.":p
x=y.p
u=A.a([D.b3H,C.a0],x)
for(t=0;t<4;++t){s=D.aGs[t]
u.push(new A.H(C.bt,A.A(A.a([A.b4(s.a,C.aq,p,18),C.K,new A.bS(1,C.ac,A.d(s.b,p,p,p,p,D.b9B,p,p,p),p)],x),C.q,C.d,C.e,0,p,p),p))}u=A.I(u,C.q,C.d,C.e,0,C.l)
s=A.a([D.bue,C.I,A.d("\u0647\u0646\u062d\u0645\u0651\u0644 \u0645\u0644\u0641 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 (\u062d\u0648\u0627\u0644\u064a "+E.br(105)+" \u0645\u064a\u062c\u0627) \u0648\u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632\u060c \u0648\u0628\u0639\u062f \u0643\u062f\u0647 \u0628\u064a\u0641\u062a\u062d \u0645\u0646 \u063a\u064a\u0631 \u062a\u062d\u0645\u064a\u0644. \u064a\u064f\u0641\u0636\u0651\u0644 \u062a\u0643\u0648\u0646 \u0639\u0644\u0649 Wi-Fi.",p,p,p,p,F.aJ,p,p,p)],x)
if(w!=null){r=w<3e8
q=r?"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629 \u0644\u0644\u0645\u062a\u0635\u0641\u062d \u0642\u0644\u064a\u0644\u0629 ("+E.br(C.f.aw(w/1e6))+" \u0645\u064a\u062c\u0627) \u2014 \u0641\u0636\u0651\u064a \u0634\u0648\u064a\u0629 \u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0623\u0648\u0644.":"\u0627\u0644\u0645\u0633\u0627\u062d\u0629 \u0627\u0644\u0645\u062a\u0627\u062d\u0629: \u0643\u0641\u0627\u064a\u0629 \u2713"
C.b.A(s,A.a([C.I,A.d(q,p,p,p,p,A.bK(p,p,r?D.dT:C.cI,p,p,p,p,p,p,p,p,12,p,p,p,p,p,!0,p,p,p,p,p,p,p,p),p,p,p)],x))}r=o.w
if(r>0&&r<3)C.b.A(s,A.a([C.I,D.btg],x))
x=A.a([new E.dA(u,C.a4,C.aN,p,!0,p),new E.dA(A.I(s,C.q,C.d,C.e,0,C.l),C.a4,C.aN,p,!1,p),D.bCc,C.I],x)
if(v!=null)x.push(new E.dA(A.d(v,p,p,p,p,D.bev,p,p,p),C.a4,C.aN,p,!1,p))
else x.push(A.fs(D.aoV,D.bkb,this.gaW0(),A.eA(C.v,C.af,D.b6D,p,p)))
x.push(C.a1)
x.push(D.a2D)
return x},
aQI(){var x,w,v=this,u=null,t=v.d,s=t.c,r=v.e,q=C.c.O(r.a.a),p=q.length===0,o=p?C.r8:G.chm(q),n=t.z,m=A.R(v.ajD(C.du,E.br(s.garw())+" \u0622\u064a\u0629","\u062d\u0641\u0638\u062a\u0647\u0627"),1),l=E.br(s.ao6()),k=s.c,j=Date.now()
k=k===B.b36(new A.b3(j,0,!1))?"\u0648\u0631\u0627 \u0628\u0639\u0636 \u2014 \u0643\u0645\u0651\u0644!":"\u0633\u0645\u0651\u0639 \u0627\u0644\u0646\u0647\u0627\u0631\u062f\u0647 \u0639\u0634\u0627\u0646 \u062a\u0643\u0645\u0651\u0644"
j=y.p
k=A.a([new B.Gw(t,!1,u),A.A(A.a([m,C.K,A.R(v.ajD(C.kP,l+" \u064a\u0648\u0645",k),1)],j),C.h,C.d,C.e,0,u,u),C.u],j)
if(n!=null){t=G.k6(n.a)
m=n.b
l=n.c
m=m===l?"\u0622\u064a\u0629 "+E.br(m):"\u0627\u0644\u0622\u064a\u0627\u062a "+E.br(m)+"\u2013"+E.br(l)
k.push(new E.dA(A.A(A.a([D.ar2,C.X,A.R(A.I(A.a([D.bgr,A.d(t+" \u2014 "+m,u,u,u,u,C.bz,u,u,u)],j),C.q,C.d,C.e,0,C.l),1),L.ng],j),C.h,C.d,C.e,0,u,u),C.a4,C.aN,new B.bFB(v,n),!0,u))}t=C.i.ae(0.08)
k.push(A.aF(u,C.x,!1,u,!0,C.m,u,A.aG(),r,u,u,u,u,u,2,A.cO(u,new A.ch(4,A.v(14),C.N),u,u,u,u,u,u,!0,u,u,u,u,u,u,t,!0,u,u,u,u,u,u,u,u,u,u,u,u,u,C.tR,"\u0639\u0627\u064a\u0632 \u062a\u062d\u0641\u0638 \u0633\u0648\u0631\u0629 \u0625\u064a\u0647\u061f",u,u,u,u,u,u,u,u,u,!0,!0,!1,u,C.qt,u,u,u,u,u,u,u,u,u,u,u,u),C.r,!0,u,!0,u,!1,u,C.D,u,u,u,u,u,u,u,u,u,1,u,u,!1,"\u2022",u,new B.bFC(v),u,u,u,!1,u,u,!1,u,!0,u,C.C,u,u,u,u,u,u,u,u,u,u,u,C.dk,!0,C.t,u,C.E,u,u,u,u))
k.push(C.u)
if(!p){t=A.a([],j)
if(o.length===0)t.push(D.bpp)
for(r=o.length,x=0;x<o.length;o.length===r||(0,A.K)(o),++x)t.push(v.Qp(o[x]))
C.b.A(k,t)}else{t=A.a([D.aTh,D.aTX,v.Qp(1)],j)
for(w=114;w>=78;--w)t.push(v.Qp(w))
t.push(C.I)
r=v.f
p=A.b4(r?C.xw:C.mZ,C.aq,u,u)
t.push(A.hn(p,A.d(r?"\u0627\u062e\u0641\u064a \u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631":"\u0628\u0627\u0642\u064a \u0627\u0644\u0633\u0648\u0631 (\u0627\u0644\u0628\u0642\u0631\u0629 \u0644\u062d\u062f \u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a)",u,u,u,u,C.f1,u,u,u),new B.bFD(v),u))
if(v.f)for(w=2;w<=77;++w)t.push(v.Qp(w))
C.b.A(k,t)}k.push(C.a0)
k.push(D.Bq)
return k},
ajD(d,e,f){var x=null,w=y.p
return new E.dA(A.A(A.a([A.b4(d,C.v,x,x),C.K,A.R(A.I(A.a([A.d(e,x,x,x,x,C.bz,x,x,x),A.d(f,1,C.M,x,x,C.a0Y,x,x,x)],w),C.q,C.d,C.e,0,C.l),1)],w),C.h,C.d,C.e,0,x,x),C.a4,C.L,x,!1,x)},
Qp(d){var x,w=null,v=this.d.c,u=H.cK[d-1].a[1],t=v.a5b(d),s=t/u,r=y.p,q=A.ao(A.ds(C.P,A.a([A.c1D(C.eJ,D.d9,w,w,w,w,w,3,s,w),A.d(E.br(d),w,w,w,w,Q.a1i,w,w,w)],r),C.m,C.bj,w),36,36),p=A.d(G.k6(d),w,w,w,w,D.b9l,w,w,w)
if(t===0)x=E.br(u)+" \u0622\u064a\u0629"
else x=t===u?"\u0645\u062d\u0641\u0648\u0638\u0629 \u0643\u0644\u0647\u0627 \u2713":"\u062d\u0641\u0638\u062a "+E.br(t)+" \u0645\u0646 "+E.br(u)
r=A.a([q,C.cF,A.R(A.I(A.a([p,A.d(x,w,w,w,w,A.bK(w,w,t===u?D.d9:C.cI,w,w,w,w,w,w,w,w,11.5,w,w,w,w,w,!0,w,w,w,w,w,w,w,w),w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r)
if(s>0&&s<1)r.push(A.d(E.br(C.f.aw(s*100))+"\u066a",w,w,w,w,D.a0Q,w,w,w))
r.push(D.ap3)
return new E.dA(A.A(r,C.h,C.d,C.e,0,w,w),C.pO,C.db,new B.bFG(this,d),!1,w)}}
B.Gw.prototype={
t(d){var x,w,v,u,t,s,r=null,q=this.c
switch(q.f.a){case 2:if(this.d)return C.b2
return D.aT2
case 3:x=q.y
x=A.a([A.d(x==null?"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638":B.LE(x),r,r,r,r,D.AC,r,r,r)],y.p)
w=q.y
if(w!=null)x.push(new B.Cx(w,"model load",r))
x.push(C.I)
x.push(new A.zf(C.a3t,!1,q.gbdR(),r,r,r,r,C.k,r,!1,r,!0,r,C.u2,r))
return new E.dA(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aN,r,!1,r)
case 0:case 1:v=q.w
u=q.r
q=v>0
t=q?C.f.cU(u/v,0,1):r
s=q&&u<v
q=A.d(s?"\u0628\u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026 "+E.br(C.f.aw(u/1e6))+" \u0645\u0646 "+E.br(C.f.aw(v/1e6))+" \u0645\u064a\u062c\u0627":"\u0628\u0646\u062c\u0647\u0651\u0632 \u0627\u0644\u0645\u062d\u0641\u0651\u0638\u2026",r,r,r,r,C.om,r,r,r)
x=A.v(8)
w=y.p
x=A.a([q,C.B,A.f5(x,A.pH(C.eJ,C.v,7,s?t:r,r),C.aC)],w)
if(!this.d)C.b.A(x,A.a([C.I,D.bl_],w))
return new E.dA(A.I(x,C.q,C.d,C.e,0,C.l),C.a4,C.aN,r,!1,r)}}}
B.Wz.prototype={
t(d){var x=null,w=D.dT.ae(0.1),v=A.v(14),u=A.aH(D.dT.ae(0.4),1)
return A.D(x,A.A(A.a([D.aqH,C.K,A.R(A.d(this.c?"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0627\u0644\u062a\u062c\u0648\u064a\u062f.":"\u0645\u0633\u0627\u0639\u062f \u0644\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0645\u0634 \u0628\u062f\u064a\u0644 \u0639\u0646 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u2014 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u0645\u0645\u0643\u0646 \u064a\u063a\u0644\u0637\u060c \u0648\u0645\u0634 \u0628\u064a\u062d\u0643\u0645 \u0639\u0644\u0649 \u0623\u062d\u0643\u0627\u0645 \u0627\u0644\u062a\u062c\u0648\u064a\u062f. \u0627\u0642\u0631\u0627 \u0639\u0644\u0649 \u0634\u064a\u062e \u0623\u0648 \u0645\u062d\u0641\u0651\u0638 \u0641\u064a \u0645\u0633\u062c\u062f\u0643 \u0643\u0645\u0627\u0646.",x,x,x,x,C.AJ,x,x,x),1)],y.p),C.q,C.d,C.e,0,x,x),C.k,x,x,new A.E(w,x,u,v,x,x,x,C.n),x,x,C.aN,C.ad,x,x,x)}}
B.Ds.prototype={
R(){return"_Phase."+this.b}}
B.Cw.prototype={
P(){return new B.a11($.LJ(),D.m0)}}
B.a11.prototype={
gj_(){var x=this.e
return x===$?this.e=this.a.d:x},
gBk(){var x,w=this.a,v=w.f
w=w.c
x=this.gj_()
return G.LC(w,x,v.xD(w,x)).b},
X(){var x,w=this
w.Y()
x=w.d
x.ad(w.gog())
x.vj()
x.a.a5I(B.ay_(w.a.c,w.gj_()))},
xs(){if(this.c!=null)this.k(new B.bSI())},
m(){var x,w=this,v=w.d
v.V(w.gog())
x=w.Q
if(x!=null)x.aD()
v=v.a
v.LX()
v.a2o()
w.a1()},
Z9(d){var x,w,v=this
if(v.f===D.uz)v.d.a.a2o()
x=v.d.a
x.LX()
w=v.Q
if(w!=null)w.aD()
v.k(new B.bSY(v,d))
x.a5I(B.ay_(v.a.c,d))
w=v.a
if(d<w.e)x.a5I(B.ay_(w.c,d+1))},
QG(d){return this.aS9(d)},
aS9(d){var x=0,w=A.k(y.H),v,u=this,t,s,r,q,p
var $async$QG=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:if(u.f===D.uy){u.d.a.LX()
u.k(new B.bT1(u))
x=1
break}t=u.r!=null?D.iX:D.m0
u.k(new B.bT2(u))
s=u.d
r=A.a([B.ay_(u.a.c,u.gj_())],y.s)
q=d==null?s.b.b:d
x=3
return A.c(s.a.Kl(r,q),$async$QG)
case 3:p=f
if(u.c==null||u.f!==D.uy){x=1
break}u.k(new B.bT3(u,t,p))
case 1:return A.i(v,w)}})
return A.j($async$QG,w)},
Py(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k
var $async$Py=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:l=s.d
if(l.f!==D.jG){x=1
break}p=l.a
p.LX()
r=B.E7(s.gBk()).length
s.k(new B.bT5(s))
o=s.Q
if(o!=null)o.aD()
s.Q=A.i0(C.eM,new B.bT6(s))
u=4
o=B.c5E(r)
n=A.df(0,0,0,350*r,0,0)
x=7
return A.c(p.a8b(l.b.c,o,n,new B.bT7(s),new B.bT8(s)),$async$Py)
case 7:u=2
x=6
break
case 4:u=3
k=t.pop()
l=A.a9(k)
if(l instanceof B.lp){q=l
l=s.Q
if(l!=null)l.aD()
if(s.c!=null)s.k(new B.bT9(s,q))}else throw k
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Py,w)},
Bj(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i
var $async$Bj=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if(s.f!==D.uz){x=1
break}m=s.Q
if(m!=null)m.aD()
s.k(new B.bTb(s))
s.Q=A.i0(C.ii,new B.bTc(s))
l=new A.C_()
$.Ea()
l.tA()
r=l
u=4
m=s.d.a
x=7
return A.c(m.a8e(),$async$Bj)
case 7:q=e
if(q.b<0.8){s.b38("\u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0642\u0635\u064a\u0631 \u0623\u0648\u064a \u2014 \u062f\u0648\u0633 \xab\u0633\u0645\u0651\u0639\xbb \u0648\u0627\u0642\u0631\u0627 \u0627\u0644\u0622\u064a\u0629 \u0643\u0644\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb.")
x=1
break}x=8
return A.c(m.att(q,B.E7(s.gBk()).length),$async$Bj)
case 8:p=e
s.ch=A.df(0,0,r.ga3L(),0,0,0)
k=A.lq().geV().h(0,"debug")
if(k==="1"){o=B.chA(m.IQ())
A.qP().$1("[tutor] "+s.a.c+":"+s.gj_()+" audio="+C.f.am(q.b,1)+"s infer="+p.b+"ms total="+r.gC8()+"ms "+p.gS4()+" text="+p.a)
A.qP().$1("[tutor] stages: "+A.n(o))
s.ax="\u062a\u0633\u062c\u064a\u0644\u0643 "+C.f.am(p.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.am(p.b/1000,2)+" \u062b\n"+p.gS4()+"\n"+A.n(o)+"\n"+p.a}s.ae1(p.a)
u=2
x=6
break
case 4:u=3
i=t.pop()
m=A.a9(i)
if(m instanceof B.lp){n=m
m=A.lq().geV().h(0,"debug")
if(m==="1")A.qP().$1("[tutor] check failed: "+A.n(n)+"\n"+s.d.a.IQ())
s.a1d(B.LE(n),n)}else throw i
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Bj,w)},
a1d(d,e){var x=this,w=x.Q
if(w!=null)w.aD()
if(x.c==null)return
x.k(new B.bSX(x,d,e))},
b38(d){return this.a1d(d,null)},
ae1(d){var x,w,v,u,t,s=this,r={},q=s.Q
if(q!=null)q.aD()
if(s.c==null)return
x=B.cfL(s.gBk(),d)
r.a=null
if(C.c.O(x.c).length!==0){q=s.d
w=q.c
v=s.a.c
u=s.gj_()
t=x.gt3()
r.a=w.asx(v,u,q.b.a,t)
q.zl()}s.k(new B.bSZ(r,s,x))},
Nf(){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f
var $async$Nf=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:g=s.d
if(g.f!==D.jG){x=1
break}s.k(new B.bSQ(s))
l=s.Q
if(l!=null)l.aD()
s.Q=A.i0(C.ii,new B.bSR(s))
k=new A.C_()
$.Ea()
k.tA()
r=k
u=4
l=g.a
x=7
return A.c(l.biC(B.ay_(s.a.c,s.gj_()),B.E7(s.gBk()).length),$async$Nf)
case 7:q=e
p=B.chA(l.IQ())
o="\u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a "+C.f.am(q.c,1)+" \u062b \u2014 \u0627\u0644\u062a\u0639\u0631\u0651\u0641 "+C.f.am(q.b/1000,2)+" \u062b (\u0627\u0644\u0643\u0644 "+C.f.am(r.gC8()/1000,2)+" \u062b)\n"+q.gS4()+"\n"+A.n(p)+"\n"+q.a
A.qP().$1("[tutor-debug] "+s.a.c+":"+s.gj_()+" audio="+C.f.am(q.c,1)+"s infer="+q.b+"ms total="+r.gC8()+"ms "+q.gS4()+" text="+q.a)
A.qP().$1("[tutor-debug] stages: "+A.n(p))
s.ch=A.df(0,0,r.ga3L(),0,0,0)
s.ae1(q.a)
n=s.r
if(n!=null){l=n.gt3()
j=n.b
i=A.ak(j).i("am<1>")
j=A.aa(new A.am(j,new B.bSS(),i),i.i("Y.E"))
A.qP().$1("[tutor-debug] perfect="+l+" ops="+A.n(j))}s.k(new B.bST(s,o))
u=2
x=6
break
case 4:u=3
f=t.pop()
l=A.a9(f)
if(l instanceof B.lp){m=l
A.qP().$1("[tutor-debug] failed: "+A.n(m)+"\n"+g.a.IQ())
s.a1d(B.LE(m),m)}else throw f
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Nf,w)},
ga02(){var x,w,v
for(x=this.a.d,w=this.d;v=this.a,x<=v.e;++x){v=w.c.a.h(0,v.c*1000+x)
if((v==null?$.qS():v).a!==D.f9)return!1}return!0},
t(d){var x,w=this,v=null,u=w.d,t=u.c.a5k(w.a.c,w.gj_()),s=u.b,r=s.d&&!w.x&&w.f!==D.iX,q=G.k6(w.a.c),p=y.p,o=A.a([A.bT(v,v,v,v,C.io,v,v,new B.bTh(d),v,v,v,"\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",v)],p),n=w.aIB(),m=A.d("\u0622\u064a\u0629 "+E.br(w.gj_()),v,v,v,v,N.on,v,v,v),l=E.br(w.gj_()-w.a.d+1),k=w.a
s=A.a([A.A(A.a([m,C.b_,A.d("("+l+" \u0645\u0646 "+E.br(k.e-k.d+1)+")",v,v,v,v,F.aJ,v,v,v),C.by,w.aWG(t,s.a)],p),C.h,C.d,C.e,0,v,v),C.u],p)
if(r)s.push(w.aQD())
else{m=w.r
if(m!=null){l=w.f
l=l!==D.uz&&l!==D.oI}else l=!1
if(l)s.push(w.aGj(m))
else s.push(A.d(w.gBk()+" \ufd3f"+E.br(w.gj_())+"\ufd3e",v,v,v,v,D.k4,C.Z,C.bg,v))}s=A.a([new B.Gw(u,!0,v),n,C.B,new E.dA(A.I(s,C.ag,C.d,C.e,0,C.l),D.ahY,C.aN,v,!1,v)],p)
n=w.r
if(n!=null&&w.f===D.iX)s.push(w.b4z(n))
if(w.r!=null&&w.f===D.iX&&w.ch!=null){x=C.f.aw(C.j.aJ(w.ch.a,1000)/100)
s.push(new A.H(C.bt,A.d("\u0627\u062a\u0631\u0627\u062c\u0639 \u0641\u064a "+(E.br(C.j.aJ(x,10))+"\u066b"+E.br(C.j.a0(x,10)))+" \u062b",v,v,v,v,F.aJ,C.Z,v,v),v))}n=w.as
if(n!=null)s.push(new A.H(C.aN,A.d(n,v,v,v,v,D.AC,v,v,v),v))
if(w.as!=null&&w.at!=null){n=w.at
n.toString
s.push(new B.Cx(n,"check "+w.a.c+":"+w.gj_(),v))}s.push(w.aGS())
s.push(C.a0)
s.push(A.ie(C.v,C.L,v,new B.bTi(w),D.bi5,D.bnf,u.b.d))
n=w.a
if(n.e>n.d){n=w.ga02()
s.push(new E.dA(A.A(A.a([D.anB,C.X,A.R(A.I(A.a([D.boO,A.d(w.ga02()?"\u062d\u0641\u0638\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u0633\u0645\u0651\u0639\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636 \u0645\u0646 \u063a\u064a\u0631 \u0645\u0627 \u062a\u0634\u0648\u0641\u0647\u0627":"\u0644\u0645\u0627 \u062a\u062e\u0644\u0651\u0635 \u0627\u0644\u0622\u064a\u0627\u062a \u0648\u0627\u062d\u062f\u0629 \u0648\u0627\u062d\u062f\u0629\u060c \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0644\u0647\u0627 \u0648\u0631\u0627 \u0628\u0639\u0636",v,v,v,v,F.aJ,v,v,v)],p),C.q,C.d,C.e,0,C.l),1),L.ng],p),C.h,C.d,C.e,0,v,v),C.a4,C.aN,new B.bTj(w,d),n,v))}n=A.lq().geV().h(0,"debug")
if(n==="1"){p=A.a([C.B,A.dr(D.aoU,D.bmF,u.f===D.jG&&w.f!==D.oI?w.gaHB():v,v)],p)
n=w.ax
if(n!=null)p.push(new A.H(C.ij,A.BI(n,F.aJ,v),v))
n=u.x
if(n!=null){m=n.a
l=n.b
n=n.gmJ()
u=u.x
p.push(A.d("model: "+m+" "+l+" \u2014 "+n+", isolated "+u.r+", load "+u.c+" ms (warm-up "+u.w+" ms)",v,v,v,v,F.aJ,v,v,v))}p.push(A.be(D.bnZ,v,v,new B.bTk(w,d),v,v))
C.b.A(s,p)}s.push(C.B)
s.push(D.Bq)
return K.x3(o,s,q)},
aIB(){var x=this.a,w=x.e-x.d+1
if(w===1)return C.b2
return A.ao(A.fu(new B.bSV(this),w,null,C.ae,new B.bSW()),36,null)},
aWG(d,e){var x,w,v,u,t,s,r,q=null
if(d.a===D.f9)return D.b3S
x=d.b
w=E.br(x)
v=E.br(e)
u=A.a([],y.p)
for(t=0;t<e;++t){s=t<x
r=s?C.bV:C.GA
u.push(new A.H(D.aiE,A.b4(r,s?D.d9:C.fd,q,16),q))}return A.c3P(A.A(u,C.h,C.d,C.O,0,q,q),q,"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637 \u0648\u0631\u0627 \u0628\u0639\u0636: "+w+" \u0645\u0646 "+v,q,q)},
aQD(){var x=null
return A.bz(!1,A.v(12),!0,A.D(x,D.ae5,C.k,x,x,new A.E(C.pj,x,x,A.v(12),x,x,x,C.n),x,x,x,D.ahw,x,x,x),x,!0,x,x,x,x,x,x,x,x,x,x,x,new B.bT0(this),x,x,x,x,x,x,x)},
aGj(d){var x,w,v,u,t,s=null,r=A.a([],y.R)
for(x=d.a,w=0;w<x.length;++w){v=J.av(d.gLW(),w)
A:{if(D.iQ===v){u=D.k4.ck(D.d9)
break A}if(D.ui===v){u=D.k4.a32(D.dT,C.hW,D.dT)
break A}if(D.uj===v){u=D.k4.a32(D.eI,C.hW,D.eI)
break A}u=D.k4.a32(C.fd,C.k1,C.cw)
break A}t=x[w]
r.push(new A.eX(t.a,s,s,C.bx,s,s,s,s,s,s,u))
r.push(P.At)}x=E.br(this.gj_())
r.push(A.ek(s,s,s,s,s,s,s,s,s,D.k4.ck(C.aq),"\ufd3f"+x+"\ufd3e"))
return A.Iv(A.ek(r,s,s,s,s,s,s,s,s,s,s),s,s,s,C.Z,C.bg)},
b4z(d){var x,w,v,u,t,s,r=this.w
if(C.c.O(d.c).length===0)return D.bBz
if(d.gt3()){x=r==null
if((x?null:r.a)===D.f9&&r.b===this.d.b.a)x="\u0627\u0644\u0622\u064a\u0629 \u062f\u064a \u0627\u062a\u062d\u0641\u0638\u062a! \u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627."
else x=!x&&r.a!==D.f9?"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637. \u0633\u0645\u0651\u0639\u0647\u0627 \u0643\u0645\u0627\u0646 "+E.br(this.d.b.a-r.b)+" \u0645\u0631\u0629 \u0639\u0634\u0627\u0646 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629.":"\u062a\u0633\u0645\u064a\u0639 \u0645\u0638\u0628\u0648\u0637."
return new B.CN(D.d9,C.bV,"\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713",x,null)}x=d.gLW()
w=J.dE(x)
v=w.iq(x,new B.bTd()).gM(0)
u=w.iq(x,new B.bTe()).gM(0)
t=w.iq(x,new B.bTf()).gM(0)
x=A.a([],y.s)
if(u>0)x.push(E.br(u)+" \u063a\u0644\u0637")
if(v>0)x.push(E.br(v)+" \u0631\u0627\u062c\u0639\u0647\u0627")
if(t>0)x.push(E.br(t)+" \u0646\u0627\u0642\u0635\u0629")
if(d.gJ7().length!==0)x.push(E.br(d.gJ7().length)+" \u0632\u064a\u0627\u062f\u0629")
w=u+t>0?D.eI:D.dT
x=C.b.aE(x," \u2022 ")
s=d.gJ7().length!==0?"\n\u0632\u064a\u0627\u062f\u0629: "+C.b.aE(d.gJ7(),"\u060c "):""
return new B.CN(w,C.n6,"\u0642\u0631\u0628\u062a! \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0644\u0648\u0651\u0646\u0629",x+"\n\u0627\u0644\u0623\u0635\u0641\u0631: \u0631\u0627\u062c\u0639 \u0627\u0644\u0643\u0644\u0645\u0629 \u062f\u064a \u2014 \u0627\u0644\u0623\u062d\u0645\u0631: \u063a\u0644\u0637 \u2014 \u0627\u0644\u0631\u0645\u0627\u062f\u064a \u0627\u0644\u0645\u0634\u0637\u0648\u0628: \u0646\u0633\u064a\u062a\u0647\u0627."+s,null)},
aGS(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.d,g=h.f===D.jG,f=j.f
switch(f.a){case 2:if(j.z==null)x=0
else{f=Date.now()
w=j.z
w.toString
x=C.j.aJ(new A.b3(f,0,!1).dN(w).a,1e6)}v=C.j.aJ(B.c5E(B.E7(j.gBk()).length).a,1e6)
f=j.gb3c()
w=96+26*j.y
u=D.eI.ae(0.25)
w=A.iT(i,A.a3K(C.P,A.D(i,D.ap6,C.k,i,i,D.a63,i,84,i,i,i,i,84),i,C.aR,new A.E(u,i,i,i,i,i,i,C.bZ),C.El,i,w,i,w),C.r,!1,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,f,i,i,i,i,i,i,!1,C.cV)
u=A.d("\u0628\u0646\u0633\u062c\u0651\u0644\u2026 "+B.c4C(x)+" / "+B.c4C(v),i,i,i,i,I.ol,i,i,i)
return A.I(A.a([w,C.B,u,A.d(h.b.c?"\u0644\u0645\u0627 \u062a\u062e\u0644\u0635 \u0627\u0633\u0643\u062a \u062b\u0627\u0646\u064a\u0629 \u0623\u0648 \u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb":"\u062f\u0648\u0633 \xab\u062e\u0644\u0635\u062a\xbb \u0644\u0645\u0627 \u062a\u062e\u0644\u0635",i,i,i,i,F.aJ,i,i,i),A.be(D.btf,i,i,f,i,i)],y.p),C.h,C.d,C.e,0,C.l)
case 3:t=C.f.ep((Date.now()-j.ay)/1000)
if(t<8)h="\u062b\u0648\u0627\u0646\u064a \u0648\u0646\u0642\u0648\u0644\u0643"
else h=t<25?"\u0644\u0633\u0647 \u0634\u063a\u0627\u0644\u064a\u0646 \u2014 \u0627\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0628\u062a\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0643\u062a\u0631 ("+E.br(t)+" \u062b)":"\u0648\u0627\u062e\u062f \u0648\u0642\u062a \u0623\u0637\u0648\u0644 \u0645\u0646 \u0627\u0644\u0639\u0627\u062f\u064a \u2014 \u0644\u0648 \u0639\u0644\u0651\u0642 \u0647\u0646\u0639\u064a\u062f \u062a\u0634\u063a\u064a\u0644\u0647 \u0644\u0648\u062d\u062f\u0646\u0627 ("+E.br(t)+" \u062b)"
return new A.H(C.pK,A.I(A.a([C.vl,C.a0,D.bls,A.d(h,i,i,i,i,F.aJ,C.Z,i,i)],y.p),C.h,C.d,C.e,0,C.l),i)
default:s=f===D.uy
r=j.r
f=r==null
w=!f
q=w&&r.gt3()
u=A.b4(s?D.xG:I.GO,i,i,i)
if(s)p="\u0648\u0642\u0651\u0641"
else p=w&&!q?"\u0627\u0633\u0645\u0639 \u0627\u0644\u0635\u062d":"\u0627\u0633\u0645\u0639"
p=A.d(p,i,i,i,i,i,i,i,i)
o=A.eA(i,i,D.b6A,i,i)
u=A.R(new A.zf(C.a3t,!0,new B.bSJ(j,r,q),i,i,i,o,C.k,i,!1,i,!0,i,new A.X8(p,u,o,i,i),i),1)
p=A.a([],y.n)
for(o=y.c,n=0;n<3;++n){m=D.Il[n]
p.push(new A.eg(m,i,A.d("\xd7"+E.br(m),i,i,i,i,i,i,i,i),o))}o=y.S
l=y.b
k=y.p
o=A.A(A.a([u,C.K,A.ou(new B.bSK(j),p,A.d6([h.b.b],o),!1,A.ka(i,i,i,new A.bq(new B.bSL(),l),i,i,i,i,new A.bq(new B.bSM(),l),i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,C.cP),o)],k),C.h,C.d,C.e,0,i,i)
h=g&&!s?j.gaYy():i
u=A.b4(f?D.qj:C.n6,i,i,i)
if(g)f=f?"\u0633\u0645\u0651\u0639":"\u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a"
else f="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
f=A.d(f,i,i,i,i,C.cC,i,i,i)
p=q?C.id:C.v
h=A.a([o,C.u,A.fs(u,f,h,A.eA(p,q?C.i:C.af,D.tv,i,i))],k)
if(w&&j.gj_()<j.a.e)C.b.A(h,A.a([C.B,q?A.fs(D.asi,D.bs0,new B.bSN(j),A.eA(D.d9,C.af,D.tv,i,i)):A.be(D.bit,i,i,new B.bSO(j),i,i)],k))
if(w){f=j.gj_()
w=j.a
u=w.e
f=f===u&&q&&u>w.d}else f=!1
if(f)h.push(new A.H(C.jg,A.d(j.ga02()?"\u062e\u0644\u0651\u0635\u062a \u0627\u0644\u0622\u064a\u0627\u062a \u062f\u064a \u2014 \u062c\u0631\u0651\u0628 \xab\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636\xbb \u062a\u062d\u062a.":"\u062e\u0644\u0635\u062a \u0622\u062e\u0631 \u0622\u064a\u0629 \u2014 \u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0644\u0633\u0647 (\u0627\u0644\u0646\u0642\u0637 \u0627\u0644\u0635\u0641\u0631\u0627 \u0641\u0648\u0642).",i,i,i,i,D.a1r,C.Z,i,i),i))
return A.I(h,C.ag,C.d,C.e,0,C.l)}}}
B.CN.prototype={
t(d){var x=this,w=null,v=x.c,u=v.ae(0.12),t=A.v(14),s=A.aH(v.ae(0.5),1),r=y.p
return A.D(w,A.A(A.a([A.b4(x.d,v,w,w),C.K,A.R(A.I(A.a([A.d(x.e,w,w,w,w,A.bK(w,w,v,w,w,w,w,w,w,w,w,15,w,w,C.U,w,w,!0,w,w,w,w,w,w,w,w),w,w,w),C.bL,A.d(x.f,w,w,w,w,C.AJ,w,w,w)],r),C.q,C.d,C.e,0,C.l),1)],r),C.q,C.d,C.e,0,w,w),C.k,w,w,new A.E(u,w,s,t,w,w,w,C.n),w,w,C.aN,C.ad,w,w,w)}}
B.Cv.prototype={
P(){var x=y.S
return new B.a10($.LJ(),A.C(x,y.B),A.aV(x),A.C(x,y.N),A.ec(null,y.H))}}
B.a10.prototype={
X(){this.Y()
this.d.ad(this.gog())},
xs(){if(this.c!=null)this.k(new B.bSr())},
m(){var x,w=this,v=w.d
v.V(w.gog())
x=w.y
if(x!=null)x.aD()
v.a.a2o()
w.a1()},
HI(d){return this.b1y(d)},
b1y(d){var x=0,w=A.k(y.H),v=1,u=[],t=this,s,r,q,p,o,n,m
var $async$HI=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.k(new B.bSA(t,d))
r=t.y
if(r!=null)r.aD()
t.y=A.i0(C.eM,new B.bSB(t))
v=3
r=t.d
q=t.a
p=q.f
q=q.c
q=B.c5E(B.E7(G.LC(q,d,p.xD(q,d)).b).length)
p=t.a
o=p.f
p=p.c
p=A.df(0,0,0,350*B.E7(G.LC(p,d,o.xD(p,d)).b).length,0,0)
x=6
return A.c(r.a.a8b(r.b.c,q,p,new B.bSC(t,d),new B.bSD(t)),$async$HI)
case 6:v=1
x=5
break
case 3:v=2
m=u.pop()
r=A.a9(m)
if(r instanceof B.lp){s=r
r=t.y
if(r!=null)r.aD()
if(t.c!=null)t.k(new B.bSE(t,s))}else throw m
x=5
break
case 2:x=1
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$HI,w)},
Fd(d,e){return this.aJK(d,e)},
aJK(d,e){var x=0,w=A.k(y.H),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$Fd=A.f(function(f,g){if(f===1){t.push(g)
x=u}for(;;)switch(x){case 0:if(s.e!==d){x=1
break}o=s.y
if(o!=null)o.aD()
s.k(new B.bSv(s,d))
n=d<s.a.e?d+1:null
r=s.d.a.a8e()
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
if(o instanceof B.lp){p=o
s.k(new B.bSw(s,d,p))}else throw l
x=6
break
case 3:x=2
break
case 6:if(q!=null){o=q
s.at=s.at.bB(new B.bSx(s,o,d),y.H)}case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$Fd,w)},
gaUg(){var x,w,v,u,t=this
for(x=t.a.d,w=t.f,v=t.r,u=t.w;x<=t.a.e;++x)if(!w.aG(x)&&!v.n(0,x)&&!u.aG(x)&&x!==t.e)return x
return null},
aZn(){this.k(new B.bSy(this))},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d,p=q.f===D.jG,o=s.e,n=s.gaUg(),m=s.f,l=m.a,k=s.w.a,j=s.a,i=l+k===j.e-j.d+1&&s.r.a===0&&o==null
l=A.y(m).i("cd<2>")
x=new A.am(new A.cd(m,l),new B.bSF(),l.i("am<Y.E>")).gM(0)
l=G.k6(s.a.c)
m=y.p
q=A.a([new B.Gw(q,!0,r),A.d("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 "+E.br(s.a.d)+" \u0644\u062d\u062f "+E.br(s.a.e)+" \u0645\u0646 \u062d\u0641\u0638\u0643\u060c \u0622\u064a\u0629 \u0622\u064a\u0629: \u0628\u0639\u062f \u0643\u0644 \u0622\u064a\u0629 \u062f\u0648\u0633 \xab\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629\xbb \u0648\u0643\u0645\u0651\u0644 \u0639\u0644\u0649 \u0637\u0648\u0644 \u2014 \u0647\u0646\u0635\u062d\u0651\u062d \u0648\u0625\u0646\u062a \u0628\u062a\u0642\u0631\u0627.",r,r,r,r,F.aJ,r,r,r),C.u],m)
for(w=s.a.d;w<=s.a.e;++w)q.push(s.b3a(w))
q.push(C.B)
k=s.Q
if(k!=null)q.push(A.d(k,r,r,r,r,D.AC,r,r,r))
k=s.as
if(k!=null){j=s.a
q.push(new B.Cx(k,"review "+j.c+":"+j.d+"-"+j.e,r))}k=o==null
if(!k){j=E.br(o)
if(s.z==null)v=0
else{v=Date.now()
u=s.z
u.toString
u=C.j.aJ(new A.b3(v,0,!1).dN(u).a,1e6)
v=u}v=A.d("\u0628\u0646\u0633\u062c\u0651\u0644 \u0622\u064a\u0629 "+j+"\u2026 "+B.c4C(v),r,r,r,r,I.ol,C.Z,r,r)
j=A.f5(A.v(6),A.pH(C.eJ,D.eI,6,s.x,r),C.aC)
u=o<s.a.e
t=A.b4(u?O.GH:D.xG,r,r,r)
C.b.A(q,A.a([v,C.I,j,C.u,A.fs(t,A.d(u?"\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629":"\u062e\u0644\u0635\u062a",r,r,r,r,C.cC,r,r,r),new B.bSG(s,o),A.eA(C.v,C.af,D.tv,r,r))],m))}else if(n!=null){j=p?new B.bSH(s,n):r
if(!p)v="\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0644\u0633\u0647 \u0628\u064a\u062a\u062d\u0645\u0651\u0644\u2026"
else v=n===s.a.d?"\u0627\u0628\u062f\u0623 \u0627\u0644\u062a\u0633\u0645\u064a\u0639":"\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+E.br(n)
q.push(A.fs(D.aqd,A.d(v,r,r,r,r,C.cC,r,r,r),j,A.eA(C.v,C.af,D.tv,r,r)))}if(s.r.a!==0&&k)q.push(D.aTr)
if(i){k=s.a
k=x===k.e-k.d+1
j=k?D.d9:D.dT
v=k?C.mX:C.n6
if(k)k="\u0645\u0627 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647 \u2713 \u0633\u0645\u0651\u0639\u062a\u0647\u0645 \u0643\u0644\u0647\u0645 \u0635\u062d"
else{k=E.br(x)
u=s.a
u=k+" \u0645\u0646 "+E.br(u.e-u.d+1)+" \u0622\u064a\u0627\u062a \u0645\u0638\u0628\u0648\u0637\u0629"
k=u}u=s.a
u=x===u.e-u.d+1?"\u0631\u0628\u0646\u0627 \u064a\u062b\u0628\u0651\u062a\u0647\u0627 \u0641\u064a \u0642\u0644\u0628\u0643.":"\u0627\u0631\u062c\u0639 \u0644\u0644\u0622\u064a\u0627\u062a \u0627\u0644\u0644\u064a \u0641\u064a\u0647\u0627 \u0623\u0644\u0648\u0627\u0646 \u0648\u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0648\u0628\u0639\u062f\u064a\u0646 \u0633\u0645\u0651\u0639 \u062a\u0627\u0646\u064a."
C.b.A(q,A.a([new B.CN(j,v,k,u,r),A.dr(D.as5,D.bsE,s.gaZm(),r)],m))}q.push(C.u)
q.push(D.Bq)
return K.x3(r,q,"\u0633\u0645\u0651\u0639 "+l)},
b3a(d){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.f.h(0,d),i=l.w.h(0,d)
if(l.e===d)x=D.apA
else if(l.r.n(0,d))x=M.tw
else if(i!=null)x=D.apR
else if(j!=null){w=j.gt3()?C.bV:D.am9
x=A.b4(w,j.gt3()?D.d9:D.dT,k,k)}else x=D.aod
w=y.p
v=A.a([A.A(A.a([A.d("\u0622\u064a\u0629 "+E.br(d),k,k,k,k,D.bdF,k,k,k),C.by,x],w),C.h,C.d,C.e,0,k,k)],w)
if(i!=null)v.push(A.d(i,k,k,k,k,D.a1_,k,k,k))
if(j!=null&&!j.gt3()){u=y.R
t=A.a([],u)
for(s=j.a,r=0;r<s.length;++r){q=s[r]
p=j.gLW()
o=J.ba(p)
n=o.h(p,r)
A:{if(D.iQ===n){m=D.d9
break A}if(D.ui===n){m=D.dT
break A}if(D.uj===n){m=D.eI
break A}m=C.fd
break A}m=D.k4.b8s(m,o.h(p,r)===D.uk?C.k1:k,22)
C.b.A(t,A.a([new A.eX(q.a,k,k,C.bx,k,k,k,k,k,k,m),P.At],u))}w=A.a([C.aj,A.Iv(A.ek(t,k,k,k,k,k,k,k,k,k,k),k,k,k,C.Z,C.bg)],w)
if(C.c.O(j.c).length===0)w.push(D.boc)
C.b.A(v,w)}return new E.dA(A.I(v,C.ag,C.d,C.e,0,C.l),C.bH,C.db,k,!1,k)}}
B.Cu.prototype={
P(){return new B.a1_($.LJ())}}
B.a1_.prototype={
X(){this.Y()
var x=this.d
x.ad(this.gog())
x.vj()},
xs(){if(this.c!=null)this.k(new B.bSi())},
m(){this.d.V(this.gog())
this.a1()},
t(d){var x,w,v,u,t,s=this,r=null,q=s.d.c,p=q.gax7(),o=A.a([],y.t)
for(x=78;x<=114;++x)o.push(x)
w=C.b.kM(o,0,new B.bSp(q))
v=C.b.kM(o,0,new B.bSq())
o=y.p
o=A.a([A.A(A.a([A.R(s.X0(E.br(q.garw()),"\u0622\u064a\u0629 \u0645\u062d\u0641\u0648\u0638\u0629"),1),C.K,A.R(s.X0(E.br(q.ao6()),"\u064a\u0648\u0645 \u0648\u0631\u0627 \u0628\u0639\u0636"),1),C.K,A.R(s.X0(E.br(q.e),"\u0623\u0637\u0648\u0644 \u0633\u0644\u0633\u0644\u0629"),1)],o),C.h,C.d,C.e,0,r,r),C.u,new E.dA(A.I(A.a([A.d("\u062c\u0632\u0621 \u0639\u0645\u0651: "+E.br(C.f.aw(w*100/v))+"\u066a",r,r,r,r,C.bz,r,r,r),C.I,A.f5(A.v(6),A.pH(C.eJ,D.d9,8,w/v,r),C.aC),C.aj,A.d(E.br(w)+" \u0645\u0646 "+E.br(v)+" \u0622\u064a\u0629",r,r,r,r,F.aJ,r,r,r)],o),C.q,C.d,C.e,0,C.l),C.a4,C.aN,r,!1,r)],o)
if(p.length===0)o.push(D.aTE)
for(u=p.length,t=0;t<p.length;p.length===u||(0,A.K)(p),++t)o.push(s.b3d(p[t]))
o.push(C.B)
u=$.B().b
u===$&&A.b()
u=u.ga3().e.a
o.push(A.d((u==null?r:u.r)!=null?"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643 \u0648\u064a\u0638\u0647\u0631 \u0639\u0644\u0649 \u0623\u064a \u062c\u0647\u0627\u0632 \u062a\u062f\u062e\u0644 \u0645\u0646\u0647.":"\u062a\u0642\u062f\u0651\u0645\u0643 \u0645\u062d\u0641\u0648\u0638 \u0639\u0644\u0649 \u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647. \u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644 \u0639\u0634\u0627\u0646 \u064a\u062a\u062d\u0641\u0638 \u0639\u0644\u0649 \u062d\u0633\u0627\u0628\u0643.",r,r,r,r,F.aJ,r,r,r))
return K.x3(r,o,"\u062a\u0642\u062f\u0651\u0645\u064a \u0641\u064a \u0627\u0644\u062d\u0641\u0638")},
X0(d,e){var x=null
return new E.dA(A.I(A.a([A.d(d,x,x,x,x,D.bdn,x,x,x),A.d(e,x,x,x,x,C.a1v,C.Z,x,x)],y.p),C.h,C.d,C.e,0,C.l),C.a4,C.L,x,!1,x)},
b3d(d){var x=null,w=this.d.c,v=H.cK[d-1].a[1],u=w.a5b(d),t=w.bdz(d),s=y.p,r=A.A(A.a([A.R(A.d(G.k6(d),x,x,x,x,C.bz,x,x,x),1),A.d(E.br(C.f.aw(u*100/v))+"\u066a",x,x,x,x,D.bew,x,x,x)],s),C.h,C.d,C.e,0,x,x),q=A.f5(A.v(6),A.pH(C.eJ,D.d9,7,u/v,x),C.aC),p=E.br(u),o=E.br(v),n=t>0?" \u2022 \u0628\u062a\u0631\u0627\u062c\u0639 "+E.br(t):""
return new E.dA(A.I(A.a([r,C.I,q,C.aj,A.d("\u0645\u062d\u0641\u0648\u0638 "+p+" \u0645\u0646 "+o+n,x,x,x,x,F.aJ,x,x,x)],s),C.q,C.d,C.e,0,C.l),C.a4,C.aN,new B.bSo(this,d),!1,x)},
Ni(d){return this.aHW(d)},
aHW(d){var x=0,w=A.k(y.H),v=this,u,t
var $async$Ni=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=H.cK[d-1].a[1]
t=v.c
t.toString
x=2
return A.c(A.ee(C.cS,new B.bSn(v,d,u),t,!0,null,null,!1,y.H),$async$Ni)
case 2:return A.i(null,w)}})
return A.j($async$Ni,w)}}
B.ahx.prototype={
QF(d,e){var x=null,w=A.oB(x,x,x,x,x,x,x,x,x,x,x,D.b66,C.L,x,x,x,x,C.lb,x,x)
return A.be(A.d(d,x,x,x,x,C.lH,x,x,x),x,x,new B.b2T(e),x,w)},
t(d){var x=this,w=y.p
return new E.dA(A.I(A.a([D.brN,C.I,D.bte,A.d2(C.aB,A.a([x.QF("tarteel-ai/whisper-base-ar-quran","https://huggingface.co/tarteel-ai/whisper-base-ar-quran"),x.QF("iqbalaesthetic/Basira","https://huggingface.co/iqbalaesthetic/Basira")],w),C.aG,0,12),D.bhG,x.QF("tanzil.net","https://tanzil.net"),D.buP,x.QF("everyayah.com","https://everyayah.com")],w),C.q,C.d,C.e,0,C.l),C.a4,C.aN,null,!1,null)}}
B.Cx.prototype={
P(){return new B.a12()}}
B.a12.prototype={
gakp(){var x=this.a
return B.cEH(x.c,x.d,$.c6g().IQ())},
QH(){var x=0,w=A.k(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k
var $async$QH=A.f(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:s.k(new B.bTl(s))
v=3
r=A.chf()
n=s.gakp()
m=y.N
q=A.C(m,m)
J.dX(q,"app","mogtama3y")
J.dX(q,"path","tutor \u203a "+s.a.d)
if(r!=null){m=r.length>160?C.c.a7(r,0,160):r
J.dX(q,"ua",m)}x=6
return A.c(A.a8c(n,null,C.Fl,q),$async$QH)
case 6:if(s.c!=null)s.k(new B.bTm(s))
t.push(5)
x=4
break
case 3:v=2
k=u.pop()
p=A.a9(k)
o=p instanceof A.cm?p.a:"\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0628\u0639\u062a \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a."
if(s.c!=null)s.k(new B.bTn(s,o))
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
if(s.c!=null)s.k(new B.bTo(s))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$QH,w)},
t(d){var x,w,v,u=this,t=null,s=y.p
s=A.a([A.bz(!1,t,!0,new A.H(C.pL,A.A(A.a([A.b4(u.d?C.xw:C.mZ,C.cw,t,18),C.bQ,D.bu_],s),C.h,C.d,C.e,0,t,t),t),t,!0,t,t,t,t,t,t,t,t,t,t,t,new B.bTq(u),t,t,t,t,t,t,t)],s)
if(u.d){x=A.v(8)
s.push(A.D(t,A.BI(u.gakp(),D.b9J,C.A),C.k,t,t,new A.E(C.pj,t,t,x,t,t,t,C.n),t,t,D.ahA,C.e7,t,t,1/0))}if(u.f)s.push(D.bhY)
else{x=A.oB(t,t,t,t,t,t,t,t,t,t,t,D.b67,C.L,t,t,t,t,C.lb,t,t)
w=u.e
v=w?t:u.gb3b()
s.push(A.hn(w?C.a_A:D.aru,D.bqK,v,x))}x=u.r
if(x!=null)s.push(A.d(x,t,t,t,t,D.a1_,t,t,t))
return new A.H(C.aN,A.I(s,C.q,C.d,C.e,0,C.l),t)}}
var z=a.updateTypes(["aj<~>()","~()","P(ng)","aj<IQ>()","aj<IO>()","aj<IP>()","a7<ng>()","P(r3)","bD(om)","Cw(t)","Cu(t)","P(mG)","Cv(t)","P(Hp)"])
B.b2U.prototype={
$0(){var x=0,w=A.k(y.m),v,u=2,t=[],s=this,r,q,p,o,n,m,l
var $async$$0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=A.a_(A.cU(b.G.document).baseURI)
q=A.bl(r,0,null).a2("quran_tutor/tutor.js?v=3").j(0)
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
o=A.a9(l)
s.a.b=null
m=B.cua("network",A.n(o))
throw A.q(m)
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:359}
B.b2X.prototype={
$1(d){var x=null
return A.bVV(A.d0(d,"persist",x,x,x,x))},
$S:1091}
B.b2W.prototype={
$0(){var x=0,w=A.k(y.C),v,u=this,t,s,r,q,p,o,n,m,l
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:q=u.a
n=A
m=A
l=A
x=4
return A.c(q.qM(),$async$$0)
case 4:x=3
return A.c(n.eF(m.cU(l.d0(e,"loadModel",A.bWD(new B.b2V(u.b)),u.c,u.d,null)),y.m),$async$$0)
case 3:p=e
o=A.u(p.device)
if(o==null)o=null
if(o==null)o=""
t=A.u(p.dtype)
if(t==null)t=null
if(t==null)t=""
s=q.qL(p,"ms")
r=q.o4(p,"cached")
A.u(p.backend)
v=new B.IO(o,t,s,r,q.qL(p,"threads"),q.o4(p,"isolated"),q.qL(p,"warmMs"))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+4}
B.b2V.prototype={
$2(d,e){this.a.$2(C.f.aw(d),C.f.aw(e))},
$S:1092}
B.b30.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t,s
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
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
u.onLevel=A.fN(new B.b2Z(v.e))
u.onAutoStop=A.fN(new B.b3_(v.f))
x=5
return A.c(A.eF(A.cU(A.d0(s,"startRecording",u,null,null,null)),y.O),$async$$0)
case 5:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.b2Z.prototype={
$1(d){return this.a.$1(d)},
$S:58}
B.b3_.prototype={
$1(d){return this.a.$1(d)},
$S:6}
B.b31.prototype={
$0(){var x=0,w=A.k(y.D),v,u=this,t,s,r,q,p,o
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
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
return A.c(q.eF(p.cU(o.d0(e,"stopRecording",null,null,null,null)),y.m),$async$$0)
case 3:r=e
v=new B.IP(r,A.dI(r.seconds))
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+5}
B.b33.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p,o
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.b.a
s=u.a
r=s
q=A
p=A
o=A
x=4
return A.c(s.qM(),$async$$0)
case 4:x=3
return A.c(q.eF(p.cU(o.d0(e,"transcribe",t.audio,t.rate,s.agP(u.c),null)),y.m),$async$$0)
case 3:v=r.akj(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b32.prototype={
$0(){var x=0,w=A.k(y._),v,u=this,t,s,r,q,p
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:t=u.a
s=t
r=A
q=A
p=A
x=4
return A.c(t.qM(),$async$$0)
case 4:x=3
return A.c(r.eF(q.cU(p.d0(e,"transcribeUrl",u.b,t.agP(u.c),null,null)),y.m),$async$$0)
case 3:v=s.akj(e)
x=1
break
case 1:return A.i(v,w)}})
return A.j($async$$0,w)},
$S:z+3}
B.b2Y.prototype={
$1(d){return d},
$S:31}
B.aUa.prototype={
$0(){var x,w,v,u,t=this.a,s=A.ck(t.a.length,D.uk,!1,y.G)
for(t=t.b,x=t.length,w=0;w<x;++w){v=t[w]
u=v.a
if(u!=null)s[u]=v.d}return s},
$S:z+6}
B.aU9.prototype={
$1(d){return d===D.iQ},
$S:z+2}
B.bWm.prototype={
$2(d,e){var x,w=e.length
if(d.length<w)return!1
for(x=0;x<w;++x)if(B.c0J(e[x],d[x])<0.75)return!1
return!0},
$S:1093}
B.bYl.prototype={
$1(d){return d.length!==0},
$S:11}
B.b37.prototype={
$1(d){return d.a===D.f9},
$S:z+7}
B.b38.prototype={
$1(d){return C.j.aJ(d,1000)},
$S:67}
B.b35.prototype={
$1(d){return C.f.c2(d)},
$S:1094}
B.b39.prototype={
$0(){var x=0,w=A.k(y.a),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=A.f(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c(A.jB("mt.tutor.settings"),$async$$0)
case 7:r=a3
if(r!=null){k=y.P.a(C.au.fQ(r,null))
j=A.aL(k.h(0,"n"))
j=j==null?null:C.f.c2(j)
j=C.j.cU(j==null?2:j,1,5)
i=C.b.n(D.Il,k.h(0,"r"))?A.ex(k.h(0,"r")):1
h=A.em(k.h(0,"auto"))
g=A.em(k.h(0,"hide"))
k=A.em(k.h(0,"in"))
s.a.b=new B.Uk(j,i,h!==!1,g===!0,k===!0)}u=2
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
return A.c(A.jB("mt.tutor.progress"),$async$$0)
case 12:q=a3
if(q!=null)s.a.c=B.c3S(y.P.a(C.au.fQ(q,null)))
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
return A.c(A.jB("mt.tutor.last"),$async$$0)
case 17:p=a3
if(p!=null){o=y.P.a(C.au.fQ(p,null))
n=C.f.c2(A.d3(J.av(o,"s")))
m=C.f.c2(A.d3(J.av(o,"f")))
l=C.f.c2(A.d3(J.av(o,"t")))
if(B.chF(n,m)&&B.chF(n,l)&&m<=l)s.a.z=new A.aQ(n,m,l)}u=2
x=16
break
case 14:u=13
a0=t.pop()
x=16
break
case 13:x=2
break
case 16:k=s.a
if(k.b.e&&k.a.a80()){k.a.aoV()
x=1
break}a1=k
x=18
return A.c(k.a.Me(),$async$$0)
case 18:a1.d=a3
k.e=!0
k.a6()
if(k.b.e)k.CL()
k.wk()
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:108}
B.b3a.prototype={
$2(d,e){var x=this.a
x.r=d
x.w=e
x.a6()},
$S:1095}
B.b3b.prototype={
$2(d,e){return C.j.aJ(A.eO(A.n(d),null,null),1000)===this.a},
$S:1096}
B.bFM.prototype={
$1(d){var x=0,w=A.k(y.a),v=this,u,t
var $async$$1=A.f(function(e,f){if(e===1)return A.h(f,w)
for(;;)switch(x){case 0:u=v.a
x=2
return A.c(u.d.a.E2(),$async$$1)
case 2:t=f
if(u.c!=null)u.k(new B.bFL(u,t))
return A.i(null,w)}})
return A.j($async$$1,w)},
$S:1097}
B.bFL.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bFN.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bFK(x,d))},
$S:z+8}
B.bFK.prototype={
$0(){return this.a.w=this.b},
$S:0}
B.bFO.prototype={
$1(d){},
$S:23}
B.bFy.prototype={
$0(){},
$S:0}
B.bFE.prototype={
$1(d){var x=this.c,w=this.a.w
w.toString
return new B.Cw(this.b,x.a,x.b,w,null)},
$S:z+9}
B.bFF.prototype={
$0(){},
$S:0}
B.bFI.prototype={
$0(){var x=y.z
return A.N(this.a,!1).az(A.az(new B.bFH(),null,x),x)},
$S:0}
B.bFH.prototype={
$1(d){return D.bwa},
$S:z+10}
B.bFJ.prototype={
$0(){return B.cht(this.a)},
$S:0}
B.bFB.prototype={
$0(){var x=this.b
return this.a.xt(x.a,x.b,x.c)},
$S:0}
B.bFC.prototype={
$1(d){return this.a.k(new B.bFA())},
$S:6}
B.bFA.prototype={
$0(){},
$S:0}
B.bFD.prototype={
$0(){var x=this.a
return x.k(new B.bFz(x))},
$S:0}
B.bFz.prototype={
$0(){var x=this.a
return x.f=!x.f},
$S:0}
B.bFG.prototype={
$0(){return this.a.b39(this.b)},
$S:0}
B.c_B.prototype={
$1(d){return new A.ju(new B.c_y(this.a,this.b,this.c),null)},
$S:56}
B.c_y.prototype={
$2(d,e){var x,w,v=null,u=this.b,t=new B.c_A(u,e),s=this.a,r=new B.c_z(s,e),q=A.d(G.k6(this.c),v,v,v,v,C.oh,v,v,v),p=A.d("\u0647\u062a\u0633\u0645\u0651\u0639 \u0623\u0646\u0647\u064a \u0622\u064a\u0627\u062a\u061f ("+E.br(u)+" \u0622\u064a\u0629)",v,v,v,v,F.aJ,v,v,v),o=y.p,n=A.a([],o)
if(u<=30)n.push(r.$3("\u0627\u0644\u0633\u0648\u0631\u0629 \u0643\u0644\u0647\u0627",1,u))
x=u<5
w=E.br(x?u:5)
x=x?u:5
n.push(r.$3("\u0623\u0648\u0644 "+w+" \u0622\u064a\u0627\u062a",1,x))
x=s.a
if(x>1){x=E.br(x)
w=s.a
n.push(r.$3("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u064a\u0629 "+x,w,C.j.cU(w+4,1,u)))}u=A.a([q,C.aj,p,C.u,A.d2(C.aB,n,C.aG,6,8),C.B,A.A(A.a([t.$3("\u0645\u0646",s.b,new B.c_t(s)),C.a_w,t.$3("\u0644\u062d\u062f",s.c,new B.c_u(s))],o),C.h,C.d,C.e,0,v,v)],o)
if(s.c-s.b>=10)u.push(D.aTw)
u.push(C.a1)
u.push(A.dG(D.bkV,new B.c_v(s,d),A.eA(C.v,C.af,D.b6x,v,v)))
return A.cu(!0,new A.H(C.EN,A.I(u,C.ag,C.d,C.O,0,C.l),v),C.L,!0)},
$S:252}
B.c_A.prototype={
$3(d,e,f){var x,w,v,u=null,t=A.d(d,u,u,u,u,C.hZ,u,u,u),s=A.a([],y.I)
for(x=this.a,w=y.r,v=1;v<=x;++v)s.push(new A.cg(v,A.d("\u0622\u064a\u0629 "+E.br(v),u,u,u,u,u,u,u,u),C.aw,u,w))
return A.R(A.I(A.a([t,R.Fe(C.cS,!0,s,320,new B.c_x(this.b,f),D.beO,e,y.S)],y.p),C.q,C.d,C.e,0,C.l),1)},
$S:1099}
B.c_x.prototype={
$1(d){return d==null?null:this.a.$1(new B.c_w(this.b,d))},
$S:48}
B.c_w.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
B.c_z.prototype={
$3(d,e,f){var x=null
return A.c1j(x,A.d(d,x,x,x,x,x,x,x,x),new B.c_s(this.a,this.b,e,f))},
$S:1100}
B.c_s.prototype={
$0(){var x=this
return x.b.$1(new B.c_r(x.a,x.c,x.d))},
$S:0}
B.c_r.prototype={
$0(){var x=this.a
x.b=this.b
x.c=this.c},
$S:0}
B.c_t.prototype={
$1(d){var x=this.a
x.b=d
if(x.c<d)x.c=d},
$S:15}
B.c_u.prototype={
$1(d){var x=this.a
x.c=d
if(x.b>d)x.b=d},
$S:15}
B.c_v.prototype={
$0(){var x=this.a
return A.N(this.b,!1).aj(new A.a0(x.b,x.c))},
$S:0}
B.bSI.prototype={
$0(){},
$S:0}
B.bSY.prototype={
$0(){var x=this.a
x.e=this.b
x.f=D.m0
x.w=x.r=null
x.x=!1
x.ch=x.ax=x.as=null},
$S:0}
B.bT1.prototype={
$0(){var x=this.a
return x.f=x.r!=null?D.iX:D.m0},
$S:0}
B.bT2.prototype={
$0(){var x=this.a
x.f=D.uy
x.as=null},
$S:0}
B.bT3.prototype={
$0(){var x=this.a
x.f=this.b
if(!this.c&&x.as==null)x.as=null},
$S:0}
B.bT5.prototype={
$0(){var x=this.a
x.f=D.uz
x.as=null
x.y=0
x.z=new A.b3(Date.now(),0,!1)
x.ax=null},
$S:0}
B.bT6.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bT4())},
$S:32}
B.bT4.prototype={
$0(){},
$S:0}
B.bT8.prototype={
$1(d){return this.a.y=d},
$S:58}
B.bT7.prototype={
$1(d){return this.a.Bj()},
$S:6}
B.bT9.prototype={
$0(){var x,w=this.a
w.f=w.r!=null?D.iX:D.m0
x=this.b
w.as=B.LE(x)
w.at=x},
$S:0}
B.bTb.prototype={
$0(){var x=this.a
x.f=D.oI
x.ay=Date.now()},
$S:0}
B.bTc.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bTa())},
$S:32}
B.bTa.prototype={
$0(){},
$S:0}
B.bSX.prototype={
$0(){var x=this.a
x.f=x.r!=null?D.iX:D.m0
x.as=this.b
x.at=this.c},
$S:0}
B.bSZ.prototype={
$0(){var x=this.b
x.r=this.c
x.w=this.a.a
x.f=D.iX
x.x=!1},
$S:0}
B.bSQ.prototype={
$0(){var x=this.a
x.f=D.oI
x.ay=Date.now()
x.as=null},
$S:0}
B.bSR.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bSP())},
$S:32}
B.bSP.prototype={
$0(){},
$S:0}
B.bSS.prototype={
$1(d){return d.d!==D.iQ},
$S:z+11}
B.bST.prototype={
$0(){return this.a.ax=this.b},
$S:0}
B.bTh.prototype={
$0(){return B.cht(this.a)},
$S:0}
B.bTi.prototype={
$1(d){var x=this.a.d
return x.ql(x.b.anC(d))},
$S:3}
B.bTj.prototype={
$0(){var x=y.z
return A.N(this.b,!1).az(A.az(new B.bTg(this.a),null,x),x)},
$S:0}
B.bTg.prototype={
$1(d){var x=this.a.a
return new B.Cv(x.c,x.d,x.e,x.f,null)},
$S:z+12}
B.bTk.prototype={
$0(){this.a.d.a.bhK()
this.b.I(y.q).f.Z(D.b7z)},
$S:0}
B.bSW.prototype={
$2(d,e){return C.b_},
$S:20}
B.bSV.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.a,r=s.d+e
switch(t.d.c.a5k(s.c,r).a.a){case 2:s=D.d9
break
case 1:s=D.dT
break
case 0:s=C.id
break
default:s=u}x=A.v(18)
w=t.f===D.oI?u:new B.bSU(t,r)
v=s.ae(0.25)
if(r===t.gj_())s=C.i
s=A.aH(s,r===t.gj_()?2:1)
return A.bz(!1,x,!0,A.D(C.P,A.d(E.br(r),u,u,u,u,C.a0G,u,u,u),C.k,u,u,new A.E(v,u,s,u,u,u,u,C.bZ),u,u,u,u,u,u,36),u,!0,u,u,u,u,u,u,u,u,u,u,u,w,u,u,u,u,u,u,u)},
$S:62}
B.bSU.prototype={
$0(){return this.a.Z9(this.b)},
$S:0}
B.bT0.prototype={
$0(){var x=this.a
return x.k(new B.bT_(x))},
$S:0}
B.bT_.prototype={
$0(){return this.a.x=!0},
$S:0}
B.bTd.prototype={
$1(d){return d===D.ui},
$S:z+2}
B.bTe.prototype={
$1(d){return d===D.uj},
$S:z+2}
B.bTf.prototype={
$1(d){return d===D.uk},
$S:z+2}
B.bSJ.prototype={
$0(){var x=this.b!=null&&!this.c?1:null
return this.a.QG(x)},
$S:0}
B.bSK.prototype={
$1(d){var x=this.a.d
return x.ql(x.b.b7U(d.ga4(d)))},
$S:113}
B.bSM.prototype={
$1(d){return d.n(0,C.a2)?C.af:C.i},
$S:4}
B.bSL.prototype={
$1(d){return d.n(0,C.a2)?C.v:C.a8},
$S:4}
B.bSN.prototype={
$0(){var x=this.a
return x.Z9(x.gj_()+1)},
$S:0}
B.bSO.prototype={
$0(){var x=this.a
return x.Z9(x.gj_()+1)},
$S:0}
B.bSr.prototype={
$0(){},
$S:0}
B.bSA.prototype={
$0(){var x=this.a
x.e=this.b
x.Q=null
x.x=0
x.z=new A.b3(Date.now(),0,!1)},
$S:0}
B.bSB.prototype={
$1(d){var x=this.a
if(x.c!=null)x.k(new B.bSz())},
$S:32}
B.bSz.prototype={
$0(){},
$S:0}
B.bSD.prototype={
$1(d){return this.a.x=d},
$S:58}
B.bSC.prototype={
$1(d){return this.a.Fd(this.b,!1)},
$S:6}
B.bSE.prototype={
$0(){var x,w=this.a
w.e=null
x=this.b
w.Q=B.LE(x)
w.as=x},
$S:0}
B.bSv.prototype={
$0(){var x=this.a
x.e=null
x.r.F(0,this.b)},
$S:0}
B.bSw.prototype={
$0(){var x,w=this.a,v=this.b
w.r.K(0,v)
x=this.c
w.w.q(0,v,B.LE(x))
w.as=x},
$S:0}
B.bSx.prototype={
$1(d){var x=0,w=A.k(y.H),v=1,u=[],t=[],s=this,r,q,p,o,n,m,l,k,j,i,h
var $async$$1=A.f(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:v=3
o=s.a
n=o.d
m=s.c
l=o.a
k=l.f
l=l.c
x=6
return A.c(n.a.att(s.b,B.E7(G.LC(l,m,k.xD(l,m)).b).length),$async$$1)
case 6:r=f
l=o.a
k=l.f
l=l.c
q=B.cfL(G.LC(l,m,k.xD(l,m)).b,r.a)
if(C.c.O(q.c).length!==0){l=n.c
k=o.a.c
j=q.gt3()
l.asx(k,m,n.b.a,j)}n.zl()
if(o.c!=null)o.k(new B.bSs(o,m,q))
t.push(5)
x=4
break
case 3:v=2
h=u.pop()
o=A.a9(h)
if(o instanceof B.lp){p=o
o=s.a
if(o.c!=null)o.k(new B.bSt(o,s.c,p))}else throw h
t.push(5)
x=4
break
case 2:t=[1]
case 4:v=1
o=s.a
if(o.c!=null)o.k(new B.bSu(o,s.c))
x=t.pop()
break
case 5:return A.i(null,w)
case 1:return A.h(u.at(-1),w)}})
return A.j($async$$1,w)},
$S:126}
B.bSs.prototype={
$0(){var x=this.c
this.a.f.q(0,this.b,x)
return x},
$S:0}
B.bSt.prototype={
$0(){var x=this.a,w=this.c
x.w.q(0,this.b,B.LE(w))
x.as=w},
$S:0}
B.bSu.prototype={
$0(){return this.a.r.K(0,this.b)},
$S:0}
B.bSy.prototype={
$0(){var x=this.a
x.f.aq(0)
x.w.aq(0)
x.as=null},
$S:0}
B.bSF.prototype={
$1(d){return d.gt3()},
$S:z+13}
B.bSG.prototype={
$0(){return this.a.Fd(this.b,!0)},
$S:0}
B.bSH.prototype={
$0(){return this.a.HI(this.b)},
$S:0}
B.bSi.prototype={
$0(){},
$S:0}
B.bSp.prototype={
$2(d,e){return d+this.a.a5b(e)},
$S:112}
B.bSq.prototype={
$2(d,e){return d+H.cK[e-1].a[1]},
$S:112}
B.bSo.prototype={
$0(){return this.a.Ni(this.b)},
$S:0}
B.bSn.prototype={
$1(d){var x,w,v,u,t,s,r,q=null,p=this.b,o=A.d(G.k6(p),q,q,q,q,C.oh,q,q,q),n=y.p,m=A.a([],n)
for(x=this.c,w=this.a,v=w.d,u=p*1000,t=1;t<=x;++t){s=new A.b8(10,10)
r=v.c.a.h(0,u+t)
switch((r==null?$.qS():r).a.a){case 2:r=D.d9.ae(0.35)
break
case 1:r=D.dT.ae(0.35)
break
case 0:r=C.fO
break
default:r=q}m.push(A.D(C.P,A.d(E.br(t),q,q,q,q,C.lC,q,q,q),C.k,q,q,new A.E(r,q,q,new A.cv(s,s,s,s),q,q,q,C.n),q,38,q,q,q,q,38))}return A.cu(!0,new A.H(C.fV,A.I(A.a([o,C.aj,D.bp6,C.u,new A.dx(D.a5W,A.f8(A.d2(C.aB,m,C.aG,6,6),q,C.r,q,q,q,C.w),q),C.a0,A.be(D.bqO,q,q,new B.bSm(w,d,p),q,q)],n),C.ag,C.d,C.O,0,C.l),q),C.L,!0)},
$S:37}
B.bSm.prototype={
$0(){var x=0,w=A.k(y.H),v=this,u,t
var $async$$0=A.f(function(d,e){if(d===1)return A.h(e,w)
for(;;)switch(x){case 0:u=v.b
t=v.c
x=4
return A.c(A.dm(null,null,!0,null,new B.bSl(t),u,null,!0,y.y),$async$$0)
case 4:x=e===!0?2:3
break
case 2:x=5
return A.c(v.a.d.Kz(t),$async$$0)
case 5:if(u.e!=null)A.N(u,!1).e2()
case 3:return A.i(null,w)}})
return A.j($async$$0,w)},
$S:1}
B.bSl.prototype={
$1(d){var x=null,w=A.d("\u0647\u062a\u0628\u062f\u0623 "+G.k6(this.a)+" \u0645\u0646 \u0627\u0644\u0623\u0648\u0644.",x,x,x,x,x,x,x,x)
return A.dt(A.a([A.be(C.em,x,x,new B.bSj(d),x,x),A.be(C.ov,x,x,new B.bSk(d),x,x)],y.p),w,D.bsm)},
$S:14}
B.bSj.prototype={
$0(){A.N(this.a,!1).aj(!1)
return null},
$S:0}
B.bSk.prototype={
$0(){A.N(this.a,!1).aj(!0)
return null},
$S:0}
B.c0m.prototype={
$1(d){var x=this.a
return new A.la(new B.c0l(x),null,x,null)},
$S:1101}
B.c0l.prototype={
$2(d,e){var x,w,v,u,t=null,s=this.a,r=s.b,q=A.a([],y.n)
for(x=y.c,w=1;w<=5;++w)q.push(new A.eg(w,t,A.d(E.br(w),t,t,t,t,t,t,t,t),x))
x=y.S
v=y.b
u=y.p
x=A.a([D.bhB,C.a0,D.brf,C.I,A.ou(new B.c0g(s,r),q,A.d6([r.a],x),!1,A.ka(t,t,t,new A.bq(new B.c0h(),v),t,t,t,t,new A.bq(new B.c0i(),v),t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t),x),C.B,A.ie(C.v,C.L,t,new B.c0j(s,r),D.bon,D.bui,r.c),A.ie(C.v,C.L,t,new B.c0k(s,r),t,D.bha,r.d)],u)
s=s.x
if(s!=null)C.b.A(x,A.a([C.aj,A.d("\u0627\u0644\u0645\u0639\u0627\u0644\u062c: "+s.gmJ(),t,t,t,t,F.aJ,t,C.bg,t)],u))
x.push(C.B)
x.push(D.a2D)
return A.cu(!0,A.f8(A.I(x,C.ag,C.d,C.e,0,C.l),t,C.r,C.fV,t,t,C.w),C.L,!0)},
$S:1102}
B.c0g.prototype={
$1(d){return this.a.ql(this.b.b7R(d.ga4(d)))},
$S:113}
B.c0i.prototype={
$1(d){return d.n(0,C.a2)?C.af:C.i},
$S:4}
B.c0h.prototype={
$1(d){return d.n(0,C.a2)?C.v:C.a8},
$S:4}
B.c0j.prototype={
$1(d){return this.a.ql(this.b.b7d(d))},
$S:3}
B.c0k.prototype={
$1(d){return this.a.ql(this.b.anC(d))},
$S:3}
B.b2T.prototype={
$0(){return A.cz(A.bl(this.a,0,null),C.aT,null)},
$S:0}
B.c0C.prototype={
$1(d){var x,w=A.aD("https?://",!0,!1,!1)
w=A.bE(d,w,"")
x=A.aD("www\\.",!0,!1,!1)
return A.uv(A.bE(w,x,"www[.]"),A.aD("([A-Za-z0-9-]+)\\.(com|net|org|io|xyz|ru|info|me|link)\\b",!1,!1,!1),new B.c0D(),null)},
$S:31}
B.c0D.prototype={
$1(d){return A.n(d.h(0,1))+"[.]"+A.n(d.h(0,2))},
$S:54}
B.bTl.prototype={
$0(){var x=this.a
x.e=!0
x.r=null},
$S:0}
B.bTm.prototype={
$0(){return this.a.f=!0},
$S:0}
B.bTn.prototype={
$0(){return this.a.r=this.b},
$S:0}
B.bTo.prototype={
$0(){return this.a.e=!1},
$S:0}
B.bTq.prototype={
$0(){var x=this.a
return x.k(new B.bTp(x))},
$S:0}
B.bTp.prototype={
$0(){var x=this.a
return x.d=!x.d},
$S:0}
B.c0B.prototype={
$1(d){return d==null?"\u2013":A.n(d)},
$S:195};(function installTearOffs(){var x=a._instance_0u
x(B.ahy.prototype,"gbdA","bdB",1)
var w
x(w=B.Ul.prototype,"gbdR","CL",0)
x(w,"gaC4","wk",0)
x(w=B.ZE.prototype,"gog","xs",1)
x(w,"gaW0","Pc",0)
x(w=B.a11.prototype,"gog","xs",1)
x(w,"gaYy","Py",0)
x(w,"gb3c","Bj",0)
x(w,"gaHB","Nf",0)
x(w=B.a10.prototype,"gog","xs",1)
x(w,"gaZm","aZn",1)
x(B.a1_.prototype,"gog","xs",1)
x(B.a12.prototype,"gb3b","QH",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.a5,[B.ahy,B.Um,B.IO,B.IQ,B.IP,B.lp,B.Rr,B.mG,B.Hp,B.r3,B.ahz,B.Uk])
x(A.kV,[B.b2U,B.b2W,B.b30,B.b31,B.b33,B.b32,B.aUa,B.b39,B.bFL,B.bFK,B.bFy,B.bFF,B.bFI,B.bFJ,B.bFB,B.bFA,B.bFD,B.bFz,B.bFG,B.c_w,B.c_s,B.c_r,B.c_v,B.bSI,B.bSY,B.bT1,B.bT2,B.bT3,B.bT5,B.bT4,B.bT9,B.bTb,B.bTa,B.bSX,B.bSZ,B.bSQ,B.bSP,B.bST,B.bTh,B.bTj,B.bTk,B.bSU,B.bT0,B.bT_,B.bSJ,B.bSN,B.bSO,B.bSr,B.bSA,B.bSz,B.bSE,B.bSv,B.bSw,B.bSs,B.bSt,B.bSu,B.bSy,B.bSG,B.bSH,B.bSi,B.bSo,B.bSm,B.bSj,B.bSk,B.b2T,B.bTl,B.bTm,B.bTn,B.bTo,B.bTq,B.bTp])
x(A.ir,[B.b2X,B.b2Z,B.b3_,B.b2Y,B.aU9,B.bYl,B.b37,B.b38,B.b35,B.bFM,B.bFN,B.bFO,B.bFE,B.bFH,B.bFC,B.c_B,B.c_A,B.c_x,B.c_z,B.c_t,B.c_u,B.bT6,B.bT8,B.bT7,B.bTc,B.bSR,B.bSS,B.bTi,B.bTg,B.bTd,B.bTe,B.bTf,B.bSK,B.bSM,B.bSL,B.bSB,B.bSD,B.bSC,B.bSx,B.bSF,B.bSn,B.bSl,B.c0m,B.c0g,B.c0i,B.c0h,B.c0j,B.c0k,B.c0C,B.c0D,B.c0B])
x(A.ph,[B.b2V,B.bWm,B.b3a,B.b3b,B.c_y,B.bSW,B.bSV,B.bSp,B.bSq,B.c0l])
x(A.JG,[B.ng,B.Ep,B.Gv,B.Ds])
w(B.Ul,A.i6)
x(A.L,[B.wm,B.Cw,B.Cv,B.Cu,B.Cx])
x(A.M,[B.ZE,B.a11,B.a10,B.a1_,B.a12])
x(A.a4,[B.Gw,B.Wz,B.CN,B.ahx])})()
A.oY(b.typeUniverse,JSON.parse('{"lp":{"bN":[]},"Cw":{"L":[],"l":[]},"Cv":{"L":[],"l":[]},"Cu":{"L":[],"l":[]},"Cx":{"L":[],"l":[]},"Ul":{"aC":[]},"wm":{"L":[],"l":[]},"ZE":{"M":["wm"]},"Gw":{"a4":[],"l":[]},"Wz":{"a4":[],"l":[]},"a11":{"M":["Cw"]},"CN":{"a4":[],"l":[]},"a10":{"M":["Cv"]},"a1_":{"M":["Cu"]},"ahx":{"a4":[],"l":[]},"a12":{"M":["Cx"]}}'))
var y=(function rtii(){var x=A.ai
return{u:x("r3"),c:x("eg<x>"),r:x("cg<x>"),k:x("F<mG>"),n:x("F<eg<x>>"),I:x("F<cg<x>>"),R:x("F<hB>"),Z:x("F<aP<o,@>>"),d:x("F<Rr>"),s:x("F<o>"),p:x("F<l>"),t:x("F<x>"),m:x("bM"),j:x("a7<@>"),L:x("a7<x>"),P:x("aP<o,@>"),f:x("aP<@,@>"),x:x("au<o,x>"),a:x("bD"),K:x("a5"),B:x("Hp"),l:x("+(x,x)"),e:x("d8<mG>"),N:x("o"),C:x("IO"),D:x("IP"),X:x("Um"),_:x("IQ"),U:x("am<o>"),G:x("ng"),q:x("qI"),b:x("bq<U?>"),y:x("P"),i:x("a2"),z:x("@"),S:x("x"),A:x("bM?"),Y:x("aP<@,@>?"),O:x("a5?"),M:x("+quota,usage(x,x)?"),o:x("fm"),H:x("~")}})();(function constants(){var x=a.makeConstList
D.oR=new B.Ep(0,"none")
D.oS=new B.Ep(1,"learning")
D.f9=new B.Ep(2,"memorized")
D.a5W=new A.aA(0,1/0,0,320)
D.eI=new A.U(1,0.9725490196078431,0.44313725490196076,0.44313725490196076,C.p)
D.a63=new A.E(D.eI,null,null,null,null,null,null,C.bZ)
D.dT=new A.U(1,0.984313725490196,0.7490196078431373,0.1411764705882353,C.p)
D.d9=new A.U(1,0.20392156862745098,0.8274509803921568,0.6,C.p)
D.aqL=new A.G(C.GM,null,C.cw,null,null,null)
D.bsu=new A.m("\u0627\u0644\u0646\u0635 \u0645\u062e\u0641\u064a \u2014 \u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,C.f1,null,null,null,null,null,null,null,null)
D.baa=new A.r(!0,C.fd,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bp8=new A.m("(\u062f\u0648\u0633 \u0647\u0646\u0627 \u0644\u0648 \u0639\u0627\u064a\u0632 \u062a\u0628\u0635)",null,D.baa,null,null,null,null,null,null,null,null)
D.aHv=x([D.aqL,C.I,D.bsu,D.bp8],y.p)
D.ae5=new A.fb(C.w,C.d,C.e,C.h,null,C.l,null,0,D.aHv,null)
D.ahw=new A.X(0,26,0,26)
D.ahA=new A.X(0,4,0,6)
D.ahY=new A.X(14,12,14,14)
D.aiE=new A.X(3,0,0,0)
D.am9=new A.Q(63251,"MaterialIcons",null,!1)
D.qj=new A.Q(63677,"MaterialIcons",null,!1)
D.xG=new A.Q(983516,"MaterialIcons",null,!1)
D.amY=new A.Q(983209,"MaterialIcons",null,!1)
D.anB=new A.G(D.amY,28,C.v,null,null,null)
D.aod=new A.G(C.Gq,null,C.id,null,null,null)
D.alT=new A.Q(62961,"MaterialIcons",null,!1)
D.aoU=new A.G(D.alT,null,null,null,null,null)
D.am8=new A.Q(63199,"MaterialIcons",null,!1)
D.aoV=new A.G(D.am8,null,null,null,null,null)
D.ap3=new A.G(C.kO,null,C.fd,null,null,null)
D.ap6=new A.G(D.xG,44,C.i,null,null,null)
D.apA=new A.G(D.qj,null,D.eI,null,null,null)
D.apR=new A.G(C.mY,null,D.eI,null,null,null)
D.aqd=new A.G(D.qj,null,null,null,null,null)
D.aqH=new A.G(C.jo,20,D.dT,null,null,null)
D.ar2=new A.G(C.n4,30,C.v,null,null,null)
D.aru=new A.G(C.kS,16,C.v,null,null,null)
D.amt=new A.Q(63520,"MaterialIcons",null,!1)
D.arV=new A.G(D.amt,null,null,null,null,null)
D.as5=new A.G(C.n6,null,null,null,null,null)
D.alK=new A.Q(62842,"MaterialIcons",null,!0)
D.asi=new A.G(D.alK,null,null,null,null,null)
D.Il=x([1,3,5],y.t)
D.J7=x(["\u0627\u0639\u0648\u0630","\u0628\u0627\u0644\u0644\u0647","\u0645\u0646","\u0627\u0644\u0634\u064a\u0637\u0627\u0646","\u0627\u0644\u0631\u062c\u064a\u0645"],y.s)
D.aU5=new A.H(C.mO,C.me,null)
D.aEn=x([D.aU5],y.p)
D.aYw=new A.a0(C.n0,"\u0627\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0629 \u0628\u0635\u0648\u062a \u0627\u0644\u0634\u064a\u062e \u0627\u0644\u062d\u0635\u0631\u064a (\u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645) \u0645\u0631\u0629 \u0623\u0648 \u0663 \u0623\u0648 \u0665 \u0645\u0631\u0627\u062a.")
D.aYk=new A.a0(D.qj,"\u0633\u0645\u0651\u0639\u0647\u0627 \u0645\u0646 \u062d\u0641\u0638\u0643 \u2014 \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0644\u0648\u0651\u0646\u0644\u0643 \u0643\u0644 \u0643\u0644\u0645\u0629: \u0623\u062e\u0636\u0631 \u0635\u062d\u060c \u0623\u0635\u0641\u0631 \u0631\u0627\u062c\u0639\u0647\u0627\u060c \u0623\u062d\u0645\u0631 \u063a\u0644\u0637.")
D.aYR=new A.a0(C.du,"\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0644\u0645\u0627 \u062a\u0633\u0645\u0651\u0639\u0647\u0627 \u0635\u062d \u0645\u0631\u062a\u064a\u0646 \u0648\u0631\u0627 \u0628\u0639\u0636 (\u062a\u0642\u062f\u0631 \u062a\u063a\u064a\u0651\u0631\u0647\u0627 \u0645\u0646 \u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a).")
D.amH=new A.Q(63625,"MaterialIcons",null,!1)
D.aZ2=new A.a0(D.amH,"\u0643\u0644 \u062f\u0647 \u0628\u064a\u062d\u0635\u0644 \u0639\u0644\u0649 \u0645\u0648\u0628\u0627\u064a\u0644\u0643 \u2014 \u0635\u0648\u062a\u0643 \u0645\u0634 \u0628\u064a\u062a\u0631\u0641\u0639 \u0639\u0644\u0649 \u0623\u064a \u0633\u064a\u0631\u0641\u0631.")
D.aGs=x([D.aYw,D.aYk,D.aYR,D.aZ2],A.ai("F<+(Q,o)>"))
D.aIP=x([D.oR,D.oS,D.f9],A.ai("F<Ep>"))
D.NL=x(["\u0628\u0633\u0645","\u0627\u0644\u0644\u0647","\u0627\u0644\u0631\u062d\u0645\u0646","\u0627\u0644\u0631\u062d\u064a\u0645"],y.s)
D.aQb=new B.Gv(0,"idle")
D.TW=new B.Gv(1,"loading")
D.jG=new B.Gv(2,"ready")
D.aQc=new B.Gv(3,"failed")
D.apy=new A.G(C.bV,18,D.d9,null,null,null)
D.a1r=new A.r(!0,C.aq,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.btr=new A.m("\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u062c\u0627\u0647\u0632 \u064a\u0633\u0645\u0639\u0643",null,D.a1r,null,null,null,null,null,null,null,null)
D.aDf=x([D.apy,C.b_,D.btr],y.p)
D.b3Z=new A.er(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aDf,null)
D.aT2=new A.H(C.aN,D.b3Z,null)
D.aiC=new A.X(2,6,2,4)
D.b9R=new A.r(!0,C.v,null,null,null,null,14,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhz=new A.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0647\u0646\u0627 \u2014 \u0627\u0644\u0641\u0627\u062a\u062d\u0629 \u0648\u062c\u0632\u0621 \u0639\u0645\u0651",null,D.b9R,null,null,null,null,null,null,null,null)
D.aTh=new A.H(D.aiC,D.bhz,null)
D.btQ=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.f1,null,null,null,null,null,null,null,null)
D.aEH=x([M.tw,C.K,D.btQ],y.p)
D.b3U=new A.er(C.ae,C.cm,C.e,C.h,null,C.l,null,0,D.aEH,null)
D.aTr=new A.H(C.pH,D.b3U,null)
D.AQ=new A.r(!0,D.dT,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bua=new A.m("\u0646\u0635\u064a\u062d\u0629: \u0627\u062d\u0641\u0638 \u0663\u2013\u0665 \u0622\u064a\u0627\u062a \u0641\u064a \u0627\u0644\u0645\u0631\u0629 \u0623\u0633\u0647\u0644.",null,D.AQ,null,null,null,null,null,null,null,null)
D.aTw=new A.H(C.dU,D.bua,null)
D.btm=new A.m("\u0644\u0633\u0647 \u0645\u0633\u0645\u0651\u0639\u062a\u0634 \u0623\u064a \u0622\u064a\u0629 \u2014 \u0627\u0628\u062f\u0623 \u0628\u0633\u0648\u0631\u0629 \u0642\u0635\u064a\u0631\u0629 \u0645\u0646 \u062c\u0632\u0621 \u0639\u0645\u0651.",null,F.aJ,C.Z,null,null,null,null,null,null,null)
D.aTE=new A.H(C.C,D.btm,null)
D.aiz=new A.X(2,0,2,8)
D.bpo=new A.m("\u0627\u0644\u0633\u0648\u0631 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u060c \u0645\u0646 \u0627\u0644\u0646\u0627\u0633 \u0644\u062d\u062f \u0627\u0644\u0646\u0628\u0623.",null,F.aJ,null,null,null,null,null,null,null,null)
D.aTX=new A.H(D.aiz,D.bpo,null)
D.arE=new A.G(C.kQ,30,C.v,null,null,null)
D.buQ=new A.m("\u0633\u0645\u0651\u0639\u060c \u0648\u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u064a\u0642\u0648\u0644\u0643 \u0635\u062d \u0648\u0644\u0627 \u063a\u0644\u0637",null,C.AR,null,null,null,null,null,null,null,null)
D.ajJ=new A.bS(1,C.ac,D.buQ,null)
D.aEW=x([D.arE,C.X,D.ajJ],y.p)
D.b3H=new A.er(C.ae,C.d,C.e,C.h,null,C.l,null,0,D.aEW,null)
D.are=new A.G(C.du,18,D.d9,null,null,null)
D.a0Q=new A.r(!0,D.d9,null,null,null,null,12,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bt4=new A.m("\u0645\u062d\u0641\u0648\u0638\u0629",null,D.a0Q,null,null,null,null,null,null,null,null)
D.aDG=x([D.are,C.bQ,D.bt4],y.p)
D.b3S=new A.er(C.ae,C.d,C.O,C.h,null,C.l,null,0,D.aDG,null)
D.b66=new A.T(0,30)
D.b67=new A.T(0,34)
D.tv=new A.T(1/0,54)
D.b6x=new A.T(1/0,48)
D.b6A=new A.T(1/0,50)
D.b6D=new A.T(1/0,52)
D.bqZ=new A.m("safe mode / no-gpu flags cleared (reload)",null,null,null,null,null,null,null,null,null,null)
D.b7z=new A.d9(D.bqZ,null,null,null,null,null,null,null,null,null,null,null,null,C.y,!1,null,null,null,C.m,null)
D.b9l=new A.r(!0,C.i,null,null,null,null,14.5,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b9B=new A.r(!0,C.i,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.b9J=new A.r(!0,C.aq,null,null,null,null,11,null,null,null,null,null,1.4,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.AC=new A.r(!0,D.eI,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.k4=new A.r(!0,C.i,null,"AmiriQuranMT",null,null,27,null,null,null,null,null,2,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a1_=new A.r(!0,D.eI,null,null,null,null,12,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bdn=new A.r(!0,C.v,null,null,null,null,24,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bdF=new A.r(!0,C.v,null,null,null,null,null,C.T,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bev=new A.r(!0,D.dT,null,null,null,null,13,null,null,null,null,null,1.6,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bew=new A.r(!0,D.d9,null,null,null,null,null,C.U,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.beO=new A.r(!0,C.i,null,null,null,null,16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bgr=new A.m("\u0643\u0645\u0651\u0644 \u0645\u0646 \u0622\u062e\u0631 \u0645\u0631\u0629",null,C.hZ,null,null,null,null,null,null,null,null)
D.bha=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643 (\u062e\u0628\u0651\u064a \u0627\u0644\u0646\u0635)",null,C.dk,null,null,null,null,null,null,null,null)
D.bhB=new A.m("\u0625\u0639\u062f\u0627\u062f\u0627\u062a \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.oh,null,null,null,null,null,null,null,null)
D.bhG=new A.m("\u2022 \u0646\u0635 \u0627\u0644\u0645\u0635\u062d\u0641: \u0645\u0634\u0631\u0648\u0639 \u062a\u0646\u0632\u064a\u0644 Tanzil (\u062a\u0631\u062e\u064a\u0635 CC BY 3.0).",null,F.aJ,null,null,null,null,null,null,null,null)
D.bb_=new A.r(!0,D.d9,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bhY=new A.m("\u0648\u0635\u0644\u062a\u0646\u0627 \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0634\u0643\u0631\u064b\u0627\u060c \u0647\u0646\u0628\u0635 \u0639\u0644\u064a\u0647\u0627.",null,D.bb_,null,null,null,null,null,null,null,null)
D.bi5=new A.m("\u062e\u0628\u0651\u064a \u0646\u0635 \u0627\u0644\u0622\u064a\u0629 \u0648\u0633\u0645\u0651\u0639 \u0645\u0646 \u062d\u0641\u0638\u0643",null,F.aJ,null,null,null,null,null,null,null,null)
D.bit=new A.m("\u0639\u062f\u0651\u064a \u0644\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.f1,null,null,null,null,null,null,null,null)
D.bkb=new A.m("\u062d\u0645\u0651\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0648\u0627\u0628\u062f\u0623",null,C.cC,null,null,null,null,null,null,null,null)
D.bkV=new A.m("\u064a\u0644\u0627 \u0646\u0628\u062f\u0623",null,C.bN,null,null,null,null,null,null,null,null)
D.bl_=new A.m("\u0645\u0645\u0643\u0646 \u062a\u0633\u0645\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0645\u0646 \u062f\u0644\u0648\u0642\u062a\u064a \u0644\u062d\u062f \u0645\u0627 \u064a\u062e\u0644\u0635.",null,F.aJ,null,null,null,null,null,null,null,null)
D.bls=new A.m("\u0628\u0646\u0633\u0645\u0639 \u062a\u0633\u0645\u064a\u0639\u0643\u2026",null,C.AV,null,null,null,null,null,null,null,null)
D.bmF=new A.m("\u062c\u0631\u0651\u0628 \u0639\u0644\u0649 \u062a\u0644\u0627\u0648\u0629 \u0627\u0644\u062d\u0635\u0631\u064a (\u0644\u0644\u062a\u062c\u0631\u0628\u0629)",null,null,null,null,null,null,null,null,null,null)
D.bnf=new A.m("\u0627\u062e\u062a\u0628\u0631 \u0646\u0641\u0633\u0643",null,I.ol,null,null,null,null,null,null,null,null)
D.bnZ=new A.m("reset safe mode / WebGPU ban",null,O.a0n,null,null,null,null,null,null,null,null)
D.boc=new A.m("\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629",null,D.AQ,null,null,null,null,null,null,null,null)
D.bon=new A.m("\u0628\u0639\u062f \u062d\u0648\u0627\u0644\u064a \u062b\u0627\u0646\u064a\u0629 \u0633\u0643\u0648\u062a",null,F.aJ,null,null,null,null,null,null,null,null)
D.boO=new A.m("\u0633\u0645\u0651\u0639 \u0627\u0644\u0622\u064a\u0627\u062a \u0643\u0644\u0647\u0627 \u0645\u0639 \u0628\u0639\u0636",null,C.bz,null,null,null,null,null,null,null,null)
D.bp6=new A.m("\u0623\u062e\u0636\u0631: \u0645\u062d\u0641\u0648\u0638\u0629 \u2014 \u0623\u0635\u0641\u0631: \u0628\u062a\u0631\u0627\u062c\u0639\u0647\u0627 \u2014 \u0631\u0645\u0627\u062f\u064a: \u0644\u0633\u0647",null,F.aJ,null,null,null,null,null,null,null,null)
D.bpp=new A.m("\u0645\u0641\u064a\u0634 \u0633\u0648\u0631\u0629 \u0628\u0627\u0644\u0627\u0633\u0645 \u062f\u0647",null,F.aJ,null,null,null,null,null,null,null,null)
D.bqK=new A.m("\u0627\u0628\u0639\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,C.a1n,null,null,null,null,null,null,null,null)
D.bcC=new A.r(!0,D.eI,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bqO=new A.m("\u0627\u0628\u062f\u0623 \u0627\u0644\u0633\u0648\u0631\u0629 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,D.bcC,null,null,null,null,null,null,null,null)
D.brf=new A.m("\u0627\u0644\u0622\u064a\u0629 \u062a\u062a\u062d\u0633\u0628 \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0639\u062f \u0643\u0627\u0645 \u062a\u0633\u0645\u064a\u0639 \u0635\u062d \u0648\u0631\u0627 \u0628\u0639\u0636\u061f",null,I.ol,null,null,null,null,null,null,null,null)
D.brN=new A.m("\u0627\u0644\u0645\u0635\u0627\u062f\u0631",null,C.a0g,null,null,null,null,null,null,null,null)
D.bs0=new A.m("\u0627\u0644\u0622\u064a\u0629 \u0627\u0644\u062c\u0627\u064a\u0629",null,C.cC,null,null,null,null,null,null,null,null)
D.bsm=new A.m("\u062a\u0645\u0633\u062d \u062a\u0642\u062f\u0651\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a\u061f",null,null,null,null,null,null,null,null,null,null)
D.bsE=new A.m("\u0633\u0645\u0651\u0639\u0647\u0645 \u062a\u0627\u0646\u064a",null,null,null,null,null,null,null,null,null,null)
D.bte=new A.m("\u2022 \u0646\u0645\u0648\u0630\u062c \u0627\u0644\u062a\u0639\u0631\u0651\u0641 \u0639\u0644\u0649 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: whisper-base-ar-quran \u0645\u0646 Tarteel (\u062a\u0631\u062e\u064a\u0635 Apache-2.0)\u060c \u0628\u0635\u064a\u063a\u0629 ONNX \u0645\u0646 \u0645\u0634\u0631\u0648\u0639 Basira\u060c \u0648\u0628\u064a\u0634\u062a\u063a\u0644 \u062c\u0648\u0651\u0647 \u0627\u0644\u0645\u062a\u0635\u0641\u062d \u0628\u0645\u0643\u062a\u0628\u0629 Transformers.js.",null,F.aJ,null,null,null,null,null,null,null,null)
D.btf=new A.m("\u062e\u0644\u0635\u062a",null,N.on,null,null,null,null,null,null,null,null)
D.btg=new A.m("\u0627\u0644\u062c\u0647\u0627\u0632 \u062f\u0647 \u0630\u0627\u0643\u0631\u062a\u0647 \u0642\u0644\u064a\u0644\u0629 \u2014 \u0627\u0644\u0645\u062d\u0641\u0651\u0638 \u0645\u0645\u0643\u0646 \u064a\u0643\u0648\u0646 \u0628\u0637\u064a\u0621 \u0639\u0644\u064a\u0647.",null,D.AQ,null,null,null,null,null,null,null,null)
D.bdH=new A.r(!0,C.cI,null,null,null,null,12.5,null,null,null,null,null,null,null,null,null,null,C.hW,null,null,null,null,null,null,null,null)
D.bu_=new A.m("\u062a\u0641\u0627\u0635\u064a\u0644 \u0644\u0644\u062f\u0639\u0645",null,D.bdH,null,null,null,null,null,null,null,null)
D.bue=new A.m("\u0623\u0648\u0644 \u0645\u0631\u0629 \u0628\u0633: \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0651\u0638",null,C.bz,null,null,null,null,null,null,null,null)
D.bui=new A.m("\u0648\u0642\u0651\u0641 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0644\u0648\u062d\u062f\u0647 \u0644\u0645\u0627 \u0623\u0633\u0643\u062a",null,C.dk,null,null,null,null,null,null,null,null)
D.buP=new A.m("\u2022 \u0627\u0644\u062a\u0644\u0627\u0648\u0629: \u0627\u0644\u0634\u064a\u062e \u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a \u2014 \u0627\u0644\u0645\u0635\u062d\u0641 \u0627\u0644\u0645\u0639\u0644\u0651\u0645\u060c \u0645\u0646 everyayah.com.",null,F.aJ,null,null,null,null,null,null,null,null)
D.a2D=new B.ahx(null)
D.bwa=new B.Cu(null)
D.bwb=new B.Uk(2,1,!0,!1,!1)
D.a2I=new B.Um(!1,!1,!1,!1,!1,0)
D.iQ=new B.ng(0,"ok")
D.ui=new B.ng(1,"near")
D.uj=new B.ng(2,"wrong")
D.uk=new B.ng(3,"missing")
D.a38=new B.ng(4,"extra")
D.amo=new A.Q(63456,"MaterialIcons",null,!1)
D.bBz=new B.CN(D.dT,D.amo,"\u0645\u0633\u0645\u0639\u0646\u0627\u0634 \u062d\u0627\u062c\u0629 \u0648\u0627\u0636\u062d\u0629","\u0642\u0631\u0651\u0628 \u0627\u0644\u0645\u0648\u0628\u0627\u064a\u0644 \u0645\u0646\u0643 \u0648\u0627\u0642\u0631\u0627 \u0628\u0635\u0648\u062a \u0648\u0627\u0636\u062d \u0641\u064a \u0645\u0643\u0627\u0646 \u0647\u0627\u062f\u064a\u060c \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a.",null)
D.bCc=new B.Wz(!1,null)
D.Bq=new B.Wz(!0,null)
D.m0=new B.Ds(0,"idle")
D.uy=new B.Ds(1,"playing")
D.uz=new B.Ds(2,"recording")
D.oI=new B.Ds(3,"thinking")
D.iX=new B.Ds(4,"result")})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cHD","c6g",()=>new B.ahy())
x($,"cKW","clk",()=>A.aD("\u0640[\u064b-\u0652]*\u0670",!0,!1,!1))
x($,"cKX","cll",()=>A.aD("\u0640[\u064b-\u0652]*[\u06e6\u06e7]",!0,!1,!1))
x($,"cL8","clu",()=>A.aD("\u0648\u0670",!0,!1,!1))
x($,"cKu","cl0",()=>A.aD("[\u0648\u064a\u0649][\u064b-\u0652]*[\u0654]",!0,!1,!1))
x($,"cIP","cjR",()=>A.aD("\u0627[\u0654\u0655]",!0,!1,!1))
x($,"cK0","ckD",()=>A.aD("[\u0654\u0655]",!0,!1,!1))
x($,"cIQ","cjS",()=>A.aD("[\u0622\u0623\u0625\u0671\u0672\u0673]",!0,!1,!1))
x($,"cIX","cjY",()=>A.aD("[\u0624\u0626]",!0,!1,!1))
x($,"cK2","ckF",()=>A.aD("[\u064b-\u065f\u0670\u06d6-\u06ed\u08d3-\u08ff\u0640]",!0,!1,!1))
x($,"cKz","cl3",()=>A.aD("[\u06dd\u06de\u0660-\u0669\u06f0-\u06f90-9]",!0,!1,!1))
x($,"cKa","ckM",()=>A.aD("[^\u0621-\u064a\\s]",!0,!1,!1))
x($,"cKU","c6P",()=>A.aD("\\s+",!0,!1,!1))
x($,"cEX","qS",()=>B.cmj(D.oR,0,A.c1S(0,!0)))
x($,"cHE","LJ",()=>new B.Ul($.c6g(),D.bwb,B.cub(),D.aQb,$.S()))})()};
(a=>{a["qok7pCc7gMG61gLP0QDDR90NU0k="]=a.current})($__dart_deferred_initializers__);