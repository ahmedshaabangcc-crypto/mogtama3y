((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,C,H,K,L,M,A={
cl0(d,e){return new A.JE(e,d,null)},
JE:function JE(d,e,f){this.w=d
this.b=e
this.a=f},
cM1(d){return B.a5e(new A.c6E(d,null),y.q)},
c6E:function c6E(d,e){this.a=d
this.b=e},
cO_(d,e){if(d<10)return null
if(e>0&&e-d<15)return null
return d},
N7(d){var x,w,v,u,t,s
if(!isNaN(d))x=d==1/0||d==-1/0||d<0
else x=!0
w=C.f.eD(x?0:d)
v=C.j.aI(w,3600)
u=C.j.aI(C.j.a3(w,3600),60)
t=C.j.a3(w,60)
s=new A.c6q()
return v>0?""+v+":"+B.n(s.$1(u))+":"+B.n(s.$1(t)):""+u+":"+B.n(s.$1(t))},
oQ:function oQ(d,e,f){this.c=d
this.a=e
this.b=f},
aPG:function aPG(d,e){this.a=d
this.b=e},
aPH:function aPH(d){this.a=d},
xJ:function xJ(d,e,f,g){var _=this
_.c=d
_.d=e
_.a=f
_.b=g},
c6q:function c6q(){},
cdA(){var x,w,v
try{x=B.ks(b.G.navigator)
w=x
w=B.ks(w==null?null:w.mediaSession)
return w}catch(v){return null}},
cqI(d,e,f,g,h){var x,w,v,u,t,s,r,q=A.cdA()
if(q==null)return
try{x=y.V.a(b.G.MediaMetadata)
if(x!=null){t={}
t.src=f
t.sizes="512x512"
t.type="image/png"
w=t
t={}
t.title=h
t.artist=e
t.album=d
t.artwork=B.a([w],y.O)
v=t
q.metadata=B.tm(x,v,null,y.m)}}catch(s){}for(r=g.gcP(),r=r.ga_(r);r.v();){u=r.gG()
try{B.cP(q,"setActionHandler",u.a,B.fX(new A.c8z(u)),null,null)}catch(s){}}},
c8y(d){var x,w,v
try{x=A.cdA()
if(x!=null){w=d?"playing":"paused"
x.playbackState=w}}catch(v){}},
cOe(d,e,f){var x,w,v,u=A.cdA()
if(u==null||!(d>0)||!isFinite(d))return
try{w={}
w.duration=d
w.position=C.f.d1(e,0,d)
w.playbackRate=f
x=w
B.cP(u,"setPositionState",x,null,null,null)}catch(v){}},
coR(d){var x,w,v,u
try{x=B.cU(b.G.document)
w=B.S(x.baseURI)
v=B.bx(w,0,null).a2(d).k(0)
return v}catch(u){return d}},
c8z:function c8z(d){this.a=d},
cje(d){var x,w,v,u=B.q(d.h(0,"name"))
if(u==null)u=""
x=B.aE("\\s+",!0,!1,!1)
w=C.c.O(B.bJ(u,x," "))
v=A.cN3(w)
u=B.ar(d.h(0,"id"))
u=u==null?null:C.f.bB(u)
if(u==null)u=0
x=B.q(d.h(0,"server"))
return new A.oH(u,w,v.a,v.b,A.ced(x==null?"":x),A.cN6(d.h(0,"surah_list")),v.c)},
cBL(d){var x,w,v,u,t=B.a([],y.Q),s=y.g.a(d.h(0,"moshaf"))
s=J.av(s==null?C.a6:s)
x=y.f
w=y.N
v=y.z
while(s.v()){u=s.gG()
if(x.b(u))t.push(A.cje(B.cJ(u,w,v)))}C.b.en(t,new A.aYv())
C.b.eu(t,new A.aYw())
s=B.ar(d.h(0,"id"))
s=s==null?null:C.f.bB(s)
if(s==null)s=0
x=B.q(d.h(0,"name"))
return new A.kS(s,C.c.O(x==null?"":x),t)},
cN3(d){var x,w,v,u,t,s,r,q,p=C.c.ua(d,B.aE("\\s+-\\s+",!0,!1,!1))
p=new B.au(p,new A.c7z(),B.aj(p).i("au<1,o>")).EM(0,new A.c7A())
x=B.a9(p,p.$ti.i("X.E"))
if(x.length===0)return D.b36
w=C.b.ga1(x)
v=B.ff(x,1,null,B.aj(x).c).fU(0)
u=new A.c7D()
if(C.b.e2(x,new A.c7B(u)))t=D.Aq
else t=C.b.e2(x,new A.c7C(u))?D.Ar:D.As
if(C.c.bz(w,"\u0627\u0644\u0645\u0635\u062d\u0641"))w="\u062d\u0641\u0635 \u0639\u0646 \u0639\u0627\u0635\u0645"
p=B.a([],y.s)
for(s=v.length,r=0;r<v.length;v.length===s||(0,B.K)(v),++r){q=v[r]
if(q!=="\u0645\u0631\u062a\u0644"&&!C.c.bz(q,"\u0627\u0644\u0645\u0635\u062d\u0641"))p.push(q)}return new B.aZ(w,t,p.length===0?null:C.b.aB(p," - "))},
cN6(d){var x,w,v,u,t,s,r,q,p,o,n,m=null
if(y._.b(d))x=d
else x=B.a(B.n(d==null?"":d).split(","),y.s)
w=B.aT(y.S)
for(v=J.av(x);v.v();){u=v.gG()
t=C.c.O(B.n(u))
s=B.aE("^(\\d+)-(\\d+)$",!0,!1,!1).l2(t)
if(s!=null){r=s.b
q=r[1]
q.toString
p=B.eG(q,m,m)
r=r[2]
r.toString
o=B.eG(r,m,m)
n=p<1?1:p
r=o>114
for(;;){if(!(n<=(r?114:o)))break
w.E(0,n);++n}continue}n=typeof u=="number"?C.f.bB(u):B.dW(t,m)
if(n!=null&&n>=1&&n<=114)w.E(0,n)}v=B.a9(w,w.$ti.c)
C.b.lG(v)
return v},
cdM(d){var x,w,v,u,t=B.a([],y.s)
for(x=0;w=d.length,x<w;x=u){v=x
for(;;){u=v+1
if(!(u<w&&d[u]===d[v]+1))break
v=u}t.push(v===x?""+d[x]:""+d[x]+"-"+d[v])}return C.b.aB(t,",")},
ced(d){var x=C.c.O(d)
if(x.length===0)return x
if(C.c.bz(x,"http://"))x="https://"+C.c.cc(x,7)
return C.c.hG(x,"/")?x:x+"/"},
aAS(d,e){var x,w,v,u=d.length-1
for(x=0;x<=u;){w=C.j.i9(x+u,1)
v=d[w]
if(v===e)return!0
if(v<e)x=w+1
else u=w-1}return!1},
ceg(d){var x,w,v,u,t,s=y.f,r=s.b(d)?d.h(0,"reciters"):d
if(!y._.b(r))return D.zl
x=B.a([],y.Z)
for(w=J.av(r),v=y.N,u=y.z;w.v();){t=w.gG()
if(s.b(t))x.push(A.cBL(B.cJ(t,v,u)))}C.b.en(x,new A.c7G())
return x},
v2(d){var x,w=B.aE("[\u064b-\u065f\u0670\u0640]",!0,!1,!1)
w=B.bJ(d,w,"")
x=B.aE("[\u0623\u0625\u0622\u0671]",!0,!1,!1)
w=B.bJ(w,x,"\u0627")
w=B.bJ(w,"\u0629","\u0647")
w=B.bJ(w,"\u0649","\u064a")
w=B.bJ(w,"\u0624","\u0648")
w=B.bJ(w,"\u0626","\u064a")
x=B.aE("\\s+",!0,!1,!1)
return B.bJ(w,x,"").toLowerCase()},
cNN(d){var x,w=A.v2(d)
for(x=0;x<18;++x)if(C.c.n(w,A.v2(D.aEj[x])))return x
return 1048576},
aBq(d){var x,w,v,u=B.a([],y.A)
for(x=J.av(d);x.v();){w=x.gG()
u.push(new B.V(A.cNN(w.b),w))}C.b.eu(u,new A.c8Y())
x=B.a([],y.Z)
for(w=u.length,v=0;v<u.length;u.length===w||(0,B.K)(u),++v)x.push(u[v].b)
return x},
cLB(d,e,f,g,h){var x,w,v,u,t,s=A.v2(g),r=B.a([],y.Z)
for(x=J.av(d),w=s.length!==0,v=f!=null;x.v();){u=x.gG()
if(!w||C.c.n(A.v2(u.b),s))t=(!v||f.n(0,u.a))&&C.b.e2(u.c,new A.c6m(h,e))
else t=!1
if(t)r.push(u)}return r},
cpU(d,e,f){var x,w,v,u,t,s,r,q=B.a([],y.Q)
for(x=d.c,w=x.length,v=f!=null,u=e!=null,t=0;t<x.length;x.length===w||(0,B.K)(x),++t){s=x[t]
if(!v||C.c.n(A.v2(s.c),A.v2(f)))r=!u||s.d===e
else r=!1
if(r)q.push(s)}return q},
cLJ(d){var x
if(d>=1048576){x=d/1048576
return B.n(x>=10?C.f.ak(x):C.f.aA(x,1))+" \u0645\u064a\u062c\u0627"}return""+C.f.ak(d/1024)+" \u0643\u064a\u0644\u0648"},
tU:function tU(d,e,f){this.c=d
this.a=e
this.b=f},
oH:function oH(d,e,f,g,h,i,j){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j},
kS:function kS(d,e,f){this.a=d
this.b=e
this.c=f},
aYv:function aYv(){},
aYw:function aYw(){},
c7z:function c7z(){},
c7A:function c7A(){},
c7D:function c7D(){},
c7B:function c7B(d){this.a=d},
c7C:function c7C(d){this.a=d},
c7G:function c7G(){},
c8Y:function c8Y(){},
c6m:function c6m(d,e){this.a=d
this.b=e},
N2(d){return"\u0633\u0648\u0631\u0629 "+I.cW[d-1].a[0]},
czu(){var x=$.ciP
return x==null?$.ciP=new A.aPM().$0():x},
acN(){var x=0,w=B.k(y.j),v,u=2,t=[],s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d
var $async$acN=B.e(function(a0,a1){if(a0===1){t.push(a1)
x=u}for(;;)switch(x){case 0:e=B.a([],y.s)
l=[D.b13,D.b_D],k=0
case 3:if(!(k<2)){x=5
break}j=l[k]
s=null
r=null
s=j.a
r=j.b
u=7
q=B.bx(s,0,null)
p=null
x=10
return B.c(p!=null?p.$2(q,r):B.cLR(q,null).qI(r),$async$acN)
case 10:o=a1
if(o.b!==200){j=B.du("HTTP "+o.b)
throw B.t(j)}j=o.w
n=A.ceg(C.ap.f3(new B.uW(!1).AB(j,0,null,!0),null))
if(J.aN(n)===0){j=B.du("empty list")
throw B.t(j)}$.HE=null
j=n
v=j
x=1
break
u=2
x=9
break
case 7:u=6
d=t.pop()
m=B.a8(d)
j=B.bx(s,0,null).glp()
h=B.n(m)
g=B.aE("\\s+",!0,!1,!1)
f=C.c.O(B.bJ(h,g," "))
h=f.length>140?C.c.a7(f,0,140)+"\u2026":f
J.eQ(e,j+": "+h)
x=9
break
case 6:x=2
break
case 9:case 4:++k
x=3
break
case 5:l=J.a5W(e," \u2022 ")
$.HE=l
throw B.t(B.du(l))
case 1:return B.i(v,w)
case 2:return B.h(t.at(-1),w)}})
return B.j($async$acN,w)},
ciR(d){var x=B.n(d),w=B.aE("\\s+",!0,!1,!1),v=C.c.O(B.bJ(x,w," "))
return v.length>140?C.c.a7(v,0,140)+"\u2026":v},
ciQ(d,e){var x,w=e.iG(),v=B.a([],y.t)
for(x=J.av(d);x.v();)v.push(x.gG().du())
return B.iq("listen.cache.v1",C.ap.hl(B.J(["t",w,"reciters",v],y.N,y.K),null))},
acP(){var x=0,w=B.k(y.j),v,u,t,s
var $async$acP=B.e(function(d,e){if(d===1)return B.h(e,w)
for(;;)switch(x){case 0:x=3
return B.c($.vd().iC("assets/listen/reciters.json.gz"),$async$acP)
case 3:u=e
t=A
s=C.ap
x=4
return B.c(M.aBb(J.fA(C.bL.gcz(u),u.byteOffset,u.byteLength)),$async$acP)
case 4:v=t.ceg(s.f3(e,null))
x=1
break
case 1:return B.i(v,w)}})
return B.j($async$acP,w)},
Rn(){var x=0,w=B.k(y.H),v,u=2,t=[],s=[],r,q,p,o,n,m,l,k
var $async$Rn=B.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:if($.cbr){x=1
break}$.cbr=!0
u=3
o=y.H,n=0
case 6:if(!(n<3)){x=8
break}r=D.aFD[n]
x=9
return B.c(B.tc(r,null,o),$async$Rn)
case 9:if(!$.wC){s=[1]
x=4
break}u=11
x=14
return B.c(A.acN(),$async$Rn)
case 14:q=e
p=new B.aO(Date.now(),0,!1)
A.ciQ(q,p)
$.acO=!1
$.wB=A.aBq(q)
$.wC=!1
m=$.c9t()
m.su(m.a+1)
s=[1]
x=4
break
u=3
x=13
break
case 11:u=10
k=t.pop()
x=13
break
case 10:x=3
break
case 13:case 7:++n
x=6
break
case 8:s.push(5)
x=4
break
case 3:s=[2]
case 4:u=2
$.cbr=!1
x=s.pop()
break
case 5:case 1:return B.i(v,w)
case 2:return B.h(t.at(-1),w)}})
return B.j($async$Rn,w)},
czv(d){var x
if(!d&&$.wB!=null&&!$.wC)return B.eq($.wB,y.j)
x=$.cbq
return x==null?$.cbq=new A.aPN(d).$0():x},
czw(d){var x,w,v,u=$.wB
if(u==null)u=D.zl
x=u.length
w=0
for(;w<x;++w){v=u[w]
if(v.a===d)return v}return null},
acQ(d){var x=0,w=B.k(y.H),v
var $async$acQ=B.e(function(e,f){if(e===1)return B.h(f,w)
for(;;)switch(x){case 0:if(!$.wA.K(0,d))$.wA.E(0,d)
v=B.a9($.wA,B.y($.wA).c)
x=2
return B.c(B.iq("listen.favs",C.ap.hl(v,null)),$async$acQ)
case 2:return B.i(null,w)}})
return B.j($async$acQ,w)},
ciU(d,e,f,g){var x,w,v=""+d+"/"+e+"/"+f
$.tt.K(0,v)
if(g!=null)$.tt.p(0,v,C.f.og(g*10)/10)
for(x=B.y($.tt).i("bM<1>");$.tt.a>150;){w=new B.bM($.tt,x).ga_(0)
if(!w.v())B.ag(B.dO())
$.tt.K(0,w.gG())}B.iq("listen.pos",C.ap.hl($.tt,null))},
ciT(d,e,f,g){var x=B.J(["r",d.a,"rn",d.b,"m",e.a,"mn",e.b,"sv",e.e,"sl",A.cdM(e.f),"s",f,"p",C.f.og(g*10)/10,"t",new B.aO(Date.now(),0,!1).iG()],y.N,y.z)
$.cbs=x
B.iq("listen.last",C.ap.hl(x,null))},
ciS(){var x,w,v,u,t,s,r,q,p,o,n=null,m=$.cbs
if(m==null)return n
try{x=C.f.bB(B.cS(m.h(0,"r")))
w=C.f.bB(B.cS(m.h(0,"m")))
v=A.czw(x)
r=v
q=r==null?n:r.bjf(w)
u=q==null?A.cje(B.J(["id",w,"name",m.h(0,"mn"),"server",m.h(0,"sv"),"surah_list",m.h(0,"sl")],y.N,y.z)):q
p=v
t=p==null?new A.kS(x,B.n(m.h(0,"rn")),B.a([u],y.Q)):p
s=C.f.bB(B.cS(m.h(0,"s")))
if(!A.aAS(u.f,s)||u.e.length===0)return n
r=B.ar(m.h(0,"p"))
if(r==null)r=n
if(r==null)r=0
return new B.b_([t,u,s,r])}catch(o){return n}},
cbt(){B.iq("listen.prefs",C.ap.hl(B.J(["speed",$.Ro,"mode",$.HF.b],y.N,y.K),null))
return null},
czt(d){return new A.wz(d,null)},
cet(d){var x=null
B.dk(x,x,!0,x,new A.c8I(),d,x,!0,y.H)},
cq_(d){B.e2(C.cT,new A.c7m(),d,!0,C.kb,null,!0,y.H)},
c2R:function c2R(){},
aPM:function aPM(){},
aPI:function aPI(){},
aPJ:function aPJ(){},
aPK:function aPK(d){this.a=d},
aPL:function aPL(){},
aPN:function aPN(d){this.a=d},
Rm:function Rm(d,e,f,g){var _=this
_.a=$
_.d=_.c=_.b=null
_.f=_.e=!1
_.r=null
_.y=_.x=_.w=0
_.as=_.Q=_.z=null
_.at=d
_.ay=_.ax=null
_.ch=e
_.CW=f
_.L$=0
_.q$=g
_.T$=_.R$=0},
aPF:function aPF(d){this.a=d},
aPx:function aPx(d){this.a=d},
aPy:function aPy(d){this.a=d},
aPz:function aPz(d){this.a=d},
aPA:function aPA(d){this.a=d},
aPB:function aPB(d){this.a=d},
aPC:function aPC(d){this.a=d},
aPD:function aPD(d){this.a=d},
aPE:function aPE(d){this.a=d},
wz:function wz(d,e){this.c=d
this.a=e},
a_g:function a_g(d){var _=this
_.d=d
_.f=_.e=null
_.r=!0
_.x=_.w=null
_.y=!1
_.c=_.a=null},
bxa:function bxa(d){this.a=d},
bx6:function bx6(d){this.a=d},
bx7:function bx7(d,e){this.a=d
this.b=e},
bx8:function bx8(d,e){this.a=d
this.b=e},
bx9:function bx9(d){this.a=d},
bxc:function bxc(d){this.a=d},
bxd:function bxd(d){this.a=d},
bxe:function bxe(d){this.a=d},
bxb:function bxb(){},
bx2:function bx2(d){this.a=d},
bx5:function bx5(d,e){this.a=d
this.b=e},
bx4:function bx4(d,e){this.a=d
this.b=e},
bx3:function bx3(d,e){this.a=d
this.b=e},
bxw:function bxw(d){this.a=d},
bxx:function bxx(d){this.a=d},
bxv:function bxv(d){this.a=d},
bxy:function bxy(d){this.a=d},
bxz:function bxz(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
bxo:function bxo(d){this.a=d},
bxm:function bxm(){},
bxn:function bxn(d){this.a=d},
bxp:function bxp(d){this.a=d},
bxl:function bxl(d){this.a=d},
bxq:function bxq(d,e){this.a=d
this.b=e},
bxk:function bxk(d,e){this.a=d
this.b=e},
bxr:function bxr(d){this.a=d},
bxj:function bxj(d){this.a=d},
bxs:function bxs(d,e){this.a=d
this.b=e},
bxi:function bxi(d,e){this.a=d
this.b=e},
bxt:function bxt(d){this.a=d},
bxu:function bxu(d,e){this.a=d
this.b=e},
bxg:function bxg(d,e,f){this.a=d
this.b=e
this.c=f},
bxh:function bxh(d,e,f){this.a=d
this.b=e
this.c=f},
bxf:function bxf(){},
Z5:function Z5(d,e){this.c=d
this.a=e},
bpA:function bpA(d,e){this.a=d
this.b=e},
aus:function aus(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
bNR:function bNR(){},
bNS:function bNS(){},
ap3:function ap3(d){this.a=d},
blL:function blL(d){this.a=d},
c8I:function c8I(){},
c8G:function c8G(){},
c8H:function c8H(d){this.a=d},
Tn:function Tn(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
aur:function aur(){this.c=this.a=null},
bNO:function bNO(d){this.a=d},
bNP:function bNP(d,e){this.a=d
this.b=e},
bNN:function bNN(){},
bNQ:function bNQ(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
bNM:function bNM(d,e,f){this.a=d
this.b=e
this.c=f},
qu:function qu(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
asL:function asL(){this.d=$
this.c=this.a=null},
bBc:function bBc(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
bBa:function bBa(d,e,f){this.a=d
this.b=e
this.c=f},
bBb:function bBb(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
bB9:function bB9(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
bB8:function bB8(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
acM:function acM(d){this.a=d},
aPw:function aPw(d){this.a=d},
aPv:function aPv(d){this.a=d},
c7m:function c7m(){},
Bd:function Bd(d){this.a=d},
asg:function asg(){this.c=this.a=this.d=null},
bxA:function bxA(d){this.a=d},
bxN:function bxN(d,e){this.a=d
this.b=e},
bxE:function bxE(d){this.a=d},
bxD:function bxD(d,e){this.a=d
this.b=e},
bxF:function bxF(d,e){this.a=d
this.b=e},
bxC:function bxC(d){this.a=d},
bxG:function bxG(d){this.a=d},
bxH:function bxH(d){this.a=d},
bxI:function bxI(d,e){this.a=d
this.b=e},
bxJ:function bxJ(d,e){this.a=d
this.b=e},
bxK:function bxK(d,e){this.a=d
this.b=e},
bxL:function bxL(d,e,f){this.a=d
this.b=e
this.c=f},
bxB:function bxB(d,e){this.a=d
this.b=e},
bxM:function bxM(d){this.a=d}},D,I,E,F,G,N
J=c[1]
B=c[0]
C=c[2]
H=c[20]
K=c[28]
L=c[29]
M=c[14]
A=a.updateHolder(c[9],A)
D=c[25]
I=c[27]
E=c[16]
F=c[18]
G=c[11]
N=c[26]
A.JE.prototype={
ol(d,e){return A.cl0(e,this.w)},
dS(d){return!this.w.l(0,d.w)}}
A.oQ.prototype={
S(){return"PlayMode."+this.b}}
A.aPG.prototype={
gasO(){return C.b.e2(this.a,new A.aPH(this))},
auk(d){var x,w,v,u,t
for(x=this.a,w=x.length,v=this.b,u=0;u<w;++u){t=x[u]
if(t>v)return t}return d?C.b.ga1(x):null},
vX(){return this.auk(!1)},
zq(){var x,w,v
for(x=this.a,w=B.aj(x).i("d5<1>"),x=new B.d5(x,w),x=new B.cd(x,x.gM(0),w.i("cd<aW.E>")),w=w.i("aW.E");x.v();){v=x.d
if(v==null)v=w.a(v)
if(v<this.b)return v}return null},
b9V(d){var x=null
switch(d.a){case 0:x=this.vX()
break
case 1:x=this.b
break
case 2:x=this.auk(!0)
break
case 3:break}return x}}
A.xJ.prototype={
S(){return"SleepTimer."+this.b}}
A.tU.prototype={
S(){return"RecitationKind."+this.b}}
A.oH.prototype={
ghu(){var x=this.r
x=x==null?"":" ("+x+")"
return this.c+" \u2014 "+this.d.c+x},
du(){var x=this
return B.J(["id",x.a,"name",x.b,"server",x.e,"surah_list",A.cdM(x.f)],y.N,y.z)}}
A.kS.prototype={
gavM(){var x,w,v,u=B.aT(y.N)
for(x=this.c,w=x.length,v=0;v<x.length;x.length===w||(0,B.K)(x),++v)u.E(0,x[v].c)
return u},
gatS(){var x,w,v,u=B.aT(y.D)
for(x=this.c,w=x.length,v=0;v<x.length;x.length===w||(0,B.K)(x),++v)u.E(0,x[v].d)
return u},
bjf(d){var x,w,v,u
for(x=this.c,w=x.length,v=0;v<w;++v){u=x[v]
if(u.a===d)return u}return null},
du(){var x,w,v,u,t,s,r=B.a([],y.t)
for(x=this.c,w=x.length,v=y.N,u=y.z,t=0;t<x.length;x.length===w||(0,B.K)(x),++t){s=x[t]
r.push(B.J(["id",s.a,"name",s.b,"server",s.e,"surah_list",A.cdM(s.f)],v,u))}return B.J(["id",this.a,"name",this.b,"moshaf",r],v,u)}}
A.Rm.prototype={
a9U(d,e,f,g){var x=this
x.R3()
x.b=d
x.c=e
x.d=new A.aPG(B.ts(e.f,y.S),f)
x.b1G()
return x.uI(f,g)},
oq(d,e,f){return this.a9U(d,e,f,!0)},
uI(d,e){return this.aVK(d,e)},
aVK(d,e){var x=0,w=B.k(y.H),v=this,u,t,s,r,q,p,o
var $async$uI=B.e(function(f,g){if(f===1)return B.h(g,w)
for(;;)switch(x){case 0:o=v.b
o.toString
u=v.c
u.toString
v.d.b=d
v.r=null
t=v.y=v.x=v.w=0
v.as=null
s=e?$.tt.h(0,""+o.a+"/"+u.a+"/"+d):null
v.z=v.Q=s
v.f=!0
r=A.ced(u.e)+C.c.dt(C.j.k(d),3,"0")+".mp3"
q=v.a
q===$&&B.b()
q.Xa(r)
q.a9C($.Ro)
p=q.i5()
v.b85()
A.ciT(o,u,d,s==null?t:s)
v.a5()
v.OG(r,d)
x=2
return B.c(p,$async$uI)
case 2:v.a00(g)
return B.i(null,w)}})
return B.j($async$uI,w)},
a00(d){var x,w=this
if(d==null||d==="AbortError")return
w.e=w.f=!1
A:{if("NotAllowedError"===d){x="\u062f\u0648\u0633 \u25b6 \u0639\u0634\u0627\u0646 \u064a\u0628\u062f\u0623 \u0627\u0644\u062a\u0634\u063a\u064a\u0644"
break A}if("NotSupportedError"===d){x="\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u0634\u063a\u0651\u0644 \u0627\u0644\u0645\u0644\u0641 \u062f\u0647 \u2014 \u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a \u0623\u0648 \u0642\u0627\u0631\u0626 \u062a\u0627\u0646\u064a"
break A}if("unsupported"===d){x="\u0627\u0644\u0645\u062a\u0635\u0641\u062d \u062f\u0647 \u0645\u0634 \u0628\u064a\u0634\u063a\u0651\u0644 \u0627\u0644\u0635\u0648\u062a"
break A}x="\u062d\u0635\u0644\u062a \u0645\u0634\u0643\u0644\u0629 \u0641\u064a \u0627\u0644\u062a\u0634\u063a\u064a\u0644 \u2014 \u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a"
break A}w.r=x
w.a5()},
OG(d,e){return this.aMR(d,e)},
aMR(d,e){var x=0,w=B.k(y.H),v=1,u=[],t=this,s,r,q,p,o,n
var $async$OG=B.e(function(f,g){if(f===1){u.push(g)
x=v}for(;;)switch(x){case 0:v=3
x=6
return B.c(A.cM1(B.bx(d,0,null)).qI(C.na),$async$OG)
case 6:s=g
q=s.e.h(0,"content-length")
r=B.dW(q==null?"":q,null)
q=!1
if(r!=null)if(r>0){p=t.d
if((p==null?null:p.b)===e){q=t.c
q=(q==null?null:A.ced(q.e)+C.c.dt(C.j.k(e),3,"0")+".mp3")===d}}if(q){t.as=r
t.a5()}v=1
x=5
break
case 3:v=2
n=u.pop()
x=5
break
case 2:x=1
break
case 5:return B.i(null,w)
case 1:return B.h(u.at(-1),w)}})
return B.j($async$OG,w)},
E0(){var x=0,w=B.k(y.H),v,u=this,t
var $async$E0=B.e(function(d,e){if(d===1)return B.h(e,w)
for(;;)switch(x){case 0:if(!(u.b!=null&&u.d!=null)){x=1
break}if(u.e){t=u.a
t===$&&B.b()
t.ky()
x=1
break}if(u.r!=null){v=u.avK()
x=1
break}u.r=null
u.f=!0
u.a5()
t=u.a
t===$&&B.b()
x=3
return B.c(t.i5(),$async$E0)
case 3:u.a00(e)
case 1:return B.i(v,w)}})
return B.j($async$E0,w)},
avK(){var x,w=this
if(w.b!=null&&w.d!=null){x=w.d
x=x==null?null:x.b
x.toString
x=w.uI(x,!0)}else x=B.eq(null,y.H)
return x},
kd(d){var x,w,v,u=this
if(!(u.b!=null&&u.d!=null))return
x=u.x
w=C.f.d1(d,0,x>0?x:Math.abs(d))
v=u.a
v===$&&B.b()
v.X_(w)
u.w=w
u.HO(!0)
u.a5()},
bmO(){this.z=null
this.kd(0)},
vX(){var x=0,w=B.k(y.H),v=this,u,t
var $async$vX=B.e(function(d,e){if(d===1)return B.h(e,w)
for(;;)switch(x){case 0:u=v.d
t=u==null?null:u.vX()
x=t!=null?2:3
break
case 2:x=4
return B.c(v.uI(t,!1),$async$vX)
case 4:case 3:return B.i(null,w)}})
return B.j($async$vX,w)},
zq(){var x=0,w=B.k(y.H),v,u=this,t,s,r
var $async$zq=B.e(function(d,e){if(d===1)return B.h(e,w)
for(;;)switch(x){case 0:r=u.d
if(r==null){x=1
break}t=u.a
t===$&&B.b()
s=t.lS("currentTime")>5?r.b:r.zq()
if(s==null){x=1
break}x=s===r.b?3:5
break
case 3:u.z=null
u.kd(0)
x=4
break
case 5:x=6
return B.c(u.uI(s,!1),$async$zq)
case 6:case 4:case 1:return B.i(v,w)}})
return B.j($async$zq,w)},
X9(d){var x,w=this,v=w.ay
if(v!=null)v.au()
w.ay=null
w.at=d
w.ax=null
x=d.c
if(x!=null){w.ax=new B.aO(Date.now(),0,!1).ee(B.ds(0,0,0,0,x,0).a)
w.ay=B.cQ(B.ds(0,0,0,0,x,0),new A.aPF(w))}w.a5()},
eQ(){var x,w=this
w.R3()
x=w.a
x===$&&B.b()
x.eQ()
w.X9(D.oB)
w.d=w.c=w.b=null
w.f=w.e=!1
w.r=null
A.c8y(!1)
w.a5()},
R3(){var x,w,v=this,u=v.b,t=v.c,s=v.d,r=s==null?null:s.b
if(u==null||t==null||r==null)return
s=v.a
s===$&&B.b()
x=s.lS("currentTime")
w=s.lS("duration")
if(x<=0)return
A.ciU(u.a,t.a,r,A.cO_(x,w))
A.ciT(u,t,r,x)
v.ch=new B.aO(Date.now(),0,!1)},
HO(d){var x,w=new B.aO(Date.now(),0,!1)
if(!d&&C.j.aI(w.dD(this.CW).a,1e6)<5)return
this.CW=w
x=this.a
x===$&&B.b()
A.cOe(x.lS("duration"),x.lS("currentTime"),$.Ro)},
b0z(){return this.HO(!1)},
aVI(d){var x,w,v,u=this,t="duration"
if(!(u.b!=null&&u.d!=null))return
A:{if("timeupdate"===d){x=u.a
x===$&&B.b()
u.w=x.lS("currentTime")
u.x=x.lS(t)
u.y=x.gbaJ()
if(u.e&&C.j.aI(new B.aO(Date.now(),0,!1).dD(u.ch).a,1e6)>=5)u.R3()
u.b0z()
break A}if("loadedmetadata"===d||"durationchange"===d){x=u.a
x===$&&B.b()
w=u.x=x.lS(t)
v=u.Q
if(v!=null&&d==="loadedmetadata"){u.Q=null
if(w<=0||v<w-5){x.X_(v)
u.w=v}}u.HO(!0)
break A}if("playing"===d){u.e=!0
u.f=!1
u.r=null
A.c8y(!0)
u.HO(!0)
break A}if("pause"===d){u.e=!1
A.c8y(!1)
u.R3()
break A}if("waiting"===d||"stalled"===d){x=u.a
x===$&&B.b()
x=x.b
x=B.en(x==null?null:x.paused)
if(x==null)x=null
if(x===!1)u.f=!0
break A}if("canplay"===d){u.f=!1
break A}if("error"===d){u.e=u.f=!1
u.r="\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u062d\u0645\u0651\u0644 \u0627\u0644\u0633\u0648\u0631\u0629 \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a"
break A}if("ended"===d){u.aYe()
return}}u.a5()},
aYe(){var x,w,v,u=this,t=u.b
t.toString
x=u.c
x.toString
w=u.d
w=w==null?null:w.b
w.toString
A.ciU(t.a,x.a,w,null)
u.e=!1
if(u.at===D.B7){u.X9(D.oB)
u.a5()
return}v=u.d.b9V($.HF)
if(v==null){A.c8y(!1)
u.a5()
return}if(v===w){u.w=0
t=u.a
t===$&&B.b()
t.X_(0)
t.i5().bJ(u.gaRT(),y.H)
u.a5()
return}u.uI(v,!1)},
b1G(){var x=this
A.cqI("","",A.coR("icons/Icon-512.png"),B.J(["play",new A.aPx(x),"pause",new A.aPy(x),"previoustrack",new A.aPz(x),"nexttrack",new A.aPA(x),"seekbackward",new A.aPB(x),"seekforward",new A.aPC(x),"seekto",new A.aPD(x),"stop",new A.aPE(x)],y.N,y.B),"")},
b85(){var x,w=this.b,v=this.c,u=this.d,t=u==null?null:u.b
if(w==null||v==null||t==null)return
u=A.N2(t)
x=w.b
A.cqI("\u0645\u064f\u062c\u062a\u0645\u0639\u064a \u2014 \u0627\u0633\u062a\u0645\u0627\u0639 \u0627\u0644\u0642\u0631\u0622\u0646",v.ghu(),A.coR("icons/Icon-512.png"),D.aTj,u+" \u2014 "+x)}}
A.wz.prototype={
N(){return new A.a_g(new B.ai(C.M,$.Y()))}}
A.a_g.prototype={
gx7(){var x=this.a.c
return x!=null&&x>=1&&x<=114?x:null},
W(){this.Y()
$.c9t().ac(this.gaj5())
this.aVG()},
m(){$.c9t().U(this.gaj5())
var x=this.d
x.q$=$.Y()
x.L$=0
this.a0()},
aYB(){if(this.c!=null)this.j(new A.bxa(this))},
AZ(d){return this.aVP(d)},
aVG(){return this.AZ(!1)},
aVP(d){var x=0,w=B.k(y.H),v=1,u=[],t=this,s,r,q,p
var $async$AZ=B.e(function(e,f){if(e===1){u.push(f)
x=v}for(;;)switch(x){case 0:t.j(new A.bx6(t))
x=2
return B.c(A.czu(),$async$AZ)
case 2:v=4
x=7
return B.c(A.czv(d),$async$AZ)
case 7:s=f
if(t.c!=null)t.j(new A.bx7(t,s))
v=1
x=6
break
case 4:v=3
p=u.pop()
r=B.a8(p)
if(t.c!=null)t.j(new A.bx8(t,r))
x=6
break
case 3:x=1
break
case 6:if(t.c!=null)t.j(new A.bx9(t))
return B.i(null,w)
case 1:return B.h(u.at(-1),w)}})
return B.j($async$AZ,w)},
aZA(d){var x,w,v,u=this,t=null,s=u.w,r=A.cpU(d,u.x,s)
if(u.gx7()==null)x=r
else{s=B.aj(r).i("ah<1>")
x=B.a9(new B.ah(r,new A.bxc(u),s),s.i("X.E"))}s=d.c
if(s.length===1)w=new A.qu(d,C.b.ga1(s),u.gx7(),t)
else{if(x.length===1)s=u.w!=null||u.x!=null
else s=!1
w=s?new A.qu(d,C.b.ga1(x),u.gx7(),t):new A.Tn(d,u.gx7(),u.w,u.x,t)}s=u.c
s.toString
v=y.z
B.O(s,!1).aE(B.aF(new A.bxd(w),t,v),v).bJ(new A.bxe(u),y.P)},
ai5(d,e,f,g){var x,w,v,u,t=null,s=B.d(d,t,t,t,t,t,t,t,t,t)
if(g==null)x=t
else x=B.aX(g,e?C.ag:C.t,t,16)
w=B.bB(t,t,e?C.ag:C.i,t,t,t,t,t,t,t,t,12.5,t,t,C.S,t,t,!0,t,t,t,t,t,t,t,t)
v=$.cfe()
u=e?C.t:C.cC
return new B.B(C.x3,B.GZ(x,t,v,s,w,new A.bx2(f),e,t,!1,new B.b9(u,1,C.V,-1),C.cR),t)},
a0E(d,e,f){return this.ai5(d,e,f,null)},
aVp(){var x,w,v,u,t,s,r,q,p,o=null,n={},m=A.ciS()
if(m==null)return C.b0
n.a=n.b=n.c=null
x=m.a
w=x[0]
n.c=w
v=x[1]
n.b=v
u=n.a=x[2]
t=x[3]
s=$.vb()
x=s.b
r=x==null
q=!1
if(!r&&s.d!=null){x=r?o:x.a
if(x===w.a){x=s.c
x=x==null?o:x.a
if(x===v.a){x=s.d
x=(x==null?o:x.b)===u}else x=q
q=x}}if(q)return C.b0
x=B.d(A.N2(u)+" \u2014 "+n.c.b,o,1,C.N,o,o,C.bz,o,o,o)
r=n.b
p=y.p
return new E.dE(B.z(B.a([D.avq,C.Y,B.R(B.I(B.a([D.bzs,x,B.d(t>10?r.ghu()+" \u2022 \u0648\u0642\u0641\u062a \u0639\u0646\u062f "+E.bq(A.N7(t)):r.ghu(),o,1,C.N,o,o,F.aO,o,o,o)],p),C.q,C.d,C.e,0,C.l),1),B.fq(D.yW,C.a3A,new A.bx4(n,s),B.ez(C.t,C.ag,o,o,o,o,o))],p),C.h,C.d,C.e,0,o,o),C.a5,C.aL,new A.bx5(n,s),!0,o)},
aNj(){var x,w,v,u,t,s=null,r=this.gx7()
if(r==null)return C.b0
x=A.ciS()
w=x!=null&&A.aAS(x.a[1].f,r)?x:s
v=B.d("\u0647\u062a\u0633\u0645\u0639 "+A.N2(r),s,s,s,s,s,C.bz,s,s,s)
u=w==null
t=y.p
v=B.a([v,C.aj,B.d(u?"\u0627\u062e\u062a\u0627\u0631 \u0627\u0644\u0642\u0627\u0631\u0626 \u0645\u0646 \u062a\u062d\u062a":"\u0628\u0635\u0648\u062a "+w.a[0].b+" \u0648\u0644\u0627 \u0627\u062e\u062a\u0627\u0631 \u0642\u0627\u0631\u0626 \u062a\u0627\u0646\u064a \u0645\u0646 \u062a\u062d\u062a",s,s,s,s,s,F.aO,s,s,s)],t)
if(!u){u=B.ez(C.t,C.ag,s,s,s,s,s)
C.b.A(v,B.a([C.B,B.fq(D.yW,B.d("\u0634\u063a\u0651\u0644 "+A.N2(r)+" \u2014 "+w.a[0].b,s,s,C.N,s,s,s,s,s,s),new A.bx3(w,r),u)],t))}return new E.dE(B.I(v,C.ac,C.d,C.e,0,C.l),C.a5,C.aL,s,!1,s)},
t(d){var x,w,v,u,t,s,r,q,p=this,o=null,n={},m=E.Kh(d),l=p.e,k=l==null
if(k)x=D.zl
else{w=p.d.a.a
v=p.w
u=p.x
x=A.cLB(l,u,p.y?$.wA:o,w,v)}n.a=x
t=p.gx7()
if(t!=null){w=B.a([],y.Z)
for(v=x.length,s=0;s<x.length;x.length===v||(0,B.K)(x),++s){r=x[s]
if(C.b.e2(r.c,new A.bxw(t)))w.push(r)}n.a=w}w=B.C(y.N,y.S)
for(s=0;s<13;++s){q=D.NC[s]
w.p(0,q,k?0:J.h8(l,new A.bxx(q)).gM(0))}k=E.Nf(d)
return B.aL(B.aS(B.a([B.bP(o,o,o,o,N.IE,o,o,new A.bxy(d),o,o,o,"\u0639\u0646 \u0627\u0644\u062a\u0644\u0627\u0648\u0627\u062a",o)],y.p),C.dm,o,!0,!0,C.ag,o,1,o,o,o,!1,o,!1,C.i,C.dm,o,o,!0,o,o,o,o,o,D.bAo,o,k,o,1,o,!0),C.ag,B.it($.vb(),new A.bxz(n,p,m,t,w,l),o),D.zu,o,o,o,o,o)}}
A.Z5.prototype={
t(d){var x=null
return new B.B(C.bs,B.hS(x,B.xu("\u062a\u0641\u0627\u0635\u064a\u0644: "+this.c,D.bdN,C.Z,C.z),C.r,!1,x,x,x,x,x,x,x,new A.bpA(this,d),x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,!1,C.ct),x)}}
A.aus.prototype={
t(d){var x,w,v,u,t,s=null,r=this.c,q=r.a,p=$.wA.n(0,q),o=$.vb(),n=o.b
if(n!=null&&o.d!=null){o=n.a
x=o===q}else x=!1
q=r.gavM()
o=B.y(q).i("jr<1,o>")
w=B.eT(new B.jr(q,new A.bNR(),o),o.i("X.E")).aB(0,"\u060c ")
if(r.gatS().a>1){q=r.gatS()
v=" \u2022 "+new B.jr(q,new A.bNS(),B.y(q).i("jr<1,o>")).aB(0,"\u060c ")}else v=""
q=C.t.aa(0.18)
if(x)o=D.ar5
else{o=r.b
o=B.d((o.length===0?C.e_:new B.fV(o)).ga1(0),s,s,s,s,s,C.md,s,s,s)}o=B.rO(q,s,o,19)
q=B.d(r.b,s,1,C.N,s,s,C.bz,s,s,s)
n=r.c.length
n=n>1?" \u2022 "+E.bq(n)+" \u0645\u0635\u0627\u062d\u0641":""
u=y.p
n=B.R(B.I(B.a([q,B.d(w+v+n,s,1,C.N,s,s,F.aO,s,s,s)],u),C.q,C.d,C.e,0,C.l),1)
q=p?"\u0634\u064a\u0644\u0647 \u0645\u0646 \u0627\u0644\u0645\u0641\u0636\u0644\u064a\u0646":"\u0636\u064a\u0641\u0647 \u0644\u0644\u0645\u0641\u0636\u0644\u064a\u0646"
t=p?C.jM:D.I5
return new E.dE(B.z(B.a([o,C.Y,n,B.bP(s,s,s,s,B.aX(t,p?C.t:C.eX,s,s),s,s,this.e,s,s,s,q,s)],u),C.h,C.d,C.e,0,s,s),D.akz,C.d6,this.d,x,s)}}
A.ap3.prototype={
t(d){var x=null
return new B.B(C.l1,B.bf(D.bmr,x,x,x,new A.blL(d),x,x),x)}}
A.Tn.prototype={
N(){return new A.aur()}}
A.aur.prototype={
t(a1){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null,e=this.a,d=e.c,a0=e.e
a0=A.cpU(d,e.f,a0)
x=B.ka(a0,B.aj(a0).c)
e=B.a9(d.c,y.c)
C.b.eu(e,new A.bNO(x))
a0=d.a
w=$.wA.n(0,a0)
v=E.Kh(a1)
u=this.a.d
t=E.Nf(a1)
s=B.d(d.b,f,f,f,f,f,f,f,f,f)
r=w?"\u0634\u064a\u0644\u0647 \u0645\u0646 \u0627\u0644\u0645\u0641\u0636\u0644\u064a\u0646":"\u0636\u064a\u0641\u0647 \u0644\u0644\u0645\u0641\u0636\u0644\u064a\u0646"
q=w?C.jM:D.I5
p=y.p
t=B.aS(B.a([B.bP(f,f,f,f,B.aX(q,w?C.t:f,f,f),f,f,new A.bNP(this,d),f,f,f,r,f)],p),C.dm,f,!0,!0,C.ag,f,1,f,f,f,!1,f,!1,C.i,C.dm,f,f,!0,f,f,f,f,f,s,f,t,f,1,f,!0)
s=B.a([new B.B(C.bs,B.d("\u0627\u062e\u062a\u0627\u0631 \u0627\u0644\u0631\u0648\u0627\u064a\u0629 \u0648\u0637\u0631\u064a\u0642\u0629 \u0627\u0644\u0642\u0631\u0627\u0621\u0629 ("+E.bq(e.length)+")",f,f,f,f,f,F.aO,f,f,f),f)],p)
for(r=e.length,q=u!=null,o=0;o<e.length;e.length===r||(0,B.K)(e),++o){n=e[o]
m=$.vb()
l=m.c
l=l==null?f:l.a
if(l===n.a){m=m.b
m=(m==null?f:m.a)===a0}else m=!1
l=n.d
if(l===D.Aq)k=C.jL
else k=l===D.Ar?C.yq:C.jJ
k=B.aX(k,C.t,f,f)
j=B.d(n.c,f,f,f,f,f,C.bz,f,f,f)
i=n.r
i=i==null?"":" \u2022 "+i
h=n.f
g=h.length
g=g===114?"\u0627\u0644\u0645\u0635\u062d\u0641 \u0643\u0627\u0645\u0644":E.bq(g)+" \u0633\u0648\u0631\u0629"
h=q&&!A.aAS(h,u)?" \u2022 "+("\u0633\u0648\u0631\u0629 "+I.cW[u-1].a[0])+" \u0645\u0634 \u0645\u0648\u062c\u0648\u062f\u0629 \u0641\u064a\u0647":""
s.push(new E.dE(B.z(B.a([k,C.Y,new B.bX(1,C.ah,B.I(B.a([j,B.d(l.c+i+" \u2022 "+g+h,f,f,f,f,f,F.aO,f,f,f)],p),C.q,C.d,C.e,0,C.l),f),C.yY],p),C.h,C.d,C.e,0,f,f),C.a5,C.aL,new A.bNQ(a1,d,n,u),m,f))}s.push(D.a4R)
return B.aL(t,C.ag,B.b5(s,f,f,new B.T(v,8,v,24),f,C.w,!1),D.zu,f,f,f,f,f)}}
A.qu.prototype={
N(){return new A.asL()}}
A.asL.prototype={
W(){var x,w,v,u,t,s,r=this,q=null
r.Y()
x=r.a
w=x.d
v=$.vb()
u=x.e
if(u==null){t=v.c
t=t==null?q:t.a
if(t===w.a){t=v.b
t=t==null?q:t.a
x=t===x.c.a}else x=!1
if(x){x=v.d
x=x==null?q:x.b
u=x}else u=q}s=u==null?-1:C.b.fF(w.f,u)
x=B.nz(s>2?(s-2)*64+120:0,q,q)
r.d!==$&&B.bv()
r.d=x},
m(){var x=this.d
x===$&&B.b()
x.m()
this.a0()},
t(d){var x=null,w=this.a,v=w.c,u=w.d,t=E.Kh(d),s=$.vb()
w=E.Nf(d)
return B.aL(B.aS(x,C.dm,x,!0,!0,C.ag,x,1,x,x,x,!1,x,!1,C.i,C.dm,x,x,!0,x,x,x,x,x,B.d(v.b,x,x,x,x,x,x,x,x,x),x,w,x,1,x,!0),C.ag,B.it(s,new A.bBc(this,s,v,u,t),x),D.zu,x,x,x,x,x)}}
A.acM.prototype={
t(d){var x=$.vb()
return B.it(x,new A.aPw(x),null)}}
A.Bd.prototype={
N(){return new A.asg()}}
A.asg.prototype={
Z3(d,e,f){var x=null,w=B.d(d,x,x,x,x,x,x,x,x,x),v=B.bB(x,x,e?C.ag:C.i,x,x,x,x,x,x,x,x,12.5,x,x,C.S,x,x,!0,x,x,x,x,x,x,x,x),u=$.cfe(),t=e?C.t:C.cC
return B.eY(x,x,u,x,w,v,new A.bxA(f),e,x,!1,new B.b9(t,1,C.V,-1),x,C.cR)},
a0F(d,e){var x=null
return new B.B(C.jz,B.I(B.a([B.d(d,x,x,x,x,x,D.bjt,x,x,x),C.G,B.cR(C.au,e,C.aC,6,6)],y.p),C.q,C.d,C.e,0,C.l),x)},
t(d){var x=$.vb()
return B.it(x,new A.bxN(this,x),null)}}
var z=a.updateTypes(["M(oH)","al<~>()","~()","x(oH,oH)","M(kS)","qu(u)","x(+(x,kS),+(x,kS))","M(oQ)","oQ()","al<a7<kS>>()","~(o?)","~(o)","o(tU)","dE(u,x)","Bd(u)"])
A.c6E.prototype={
$1(d){return d.Rb("HEAD",this.a,this.b)},
$S:164}
A.aPH.prototype={
$1(d){return d>this.a.b},
$S:73}
A.c6q.prototype={
$1(d){return C.c.dt(C.j.k(d),2,"0")},
$S:52}
A.c8z.prototype={
$1(d){var x,w,v=null
try{x=B.jV(d==null?null:d.seekTime)
v=x==null?null:x}catch(w){}this.a.b.$1(v)},
$S:1147}
A.aYv.prototype={
$1(d){return d.e.length===0||d.f.length===0},
$S:z+0}
A.aYw.prototype={
$2(d,e){var x,w,v,u=d.c,t=u==="\u062d\u0641\u0635 \u0639\u0646 \u0639\u0627\u0635\u0645"?0:1,s=e.c,r=C.j.bN(t,s==="\u062d\u0641\u0635 \u0639\u0646 \u0639\u0627\u0635\u0645"?0:1)
if(r!==0)return r
x=C.c.bN(u,s)
if(x!==0)return x
w=C.j.bN(d.d.a,e.d.a)
if(w!==0)return w
u=d.r==null?0:1
v=C.j.bN(u,e.r==null?0:1)
if(v!==0)return v
return C.j.bN(e.f.length,d.f.length)},
$S:z+3}
A.c7z.prototype={
$1(d){return C.c.O(d)},
$S:40}
A.c7A.prototype={
$1(d){return d.length!==0},
$S:10}
A.c7D.prototype={
$2(d,e){return C.c.n(d,e)},
$S:333}
A.c7B.prototype={
$1(d){return this.a.$2(d,"\u0627\u0644\u0645\u0639\u0644\u0645")},
$S:10}
A.c7C.prototype={
$1(d){var x=this.a
return x.$2(d,"\u0627\u0644\u0645\u062c\u0648\u062f")||x.$2(d,"\u0645\u062c\u0648\u062f")},
$S:10}
A.c7G.prototype={
$1(d){return d.c.length===0||d.b.length===0},
$S:z+4}
A.c8Y.prototype={
$2(d,e){var x=C.j.bN(d.a,e.a)
return x!==0?x:C.c.bN(d.b.b,e.b.b)},
$S:z+6}
A.c6m.prototype={
$1(d){var x=this.a
if(x==null||C.c.n(A.v2(d.c),A.v2(x))){x=this.b
x=x==null||d.d===x}else x=!1
return x},
$S:z+0}
A.c2R.prototype={
$1(d){return d.n(0,C.U)?C.t:D.aeT},
$S:4}
A.aPM.prototype={
$0(){var x=0,w=B.k(y.P),v=1,u=[],t,s,r,q,p,o,n,m,l,k,j,i
var $async$$0=B.e(function(d,e){if(d===1){u.push(e)
x=v}for(;;)switch(x){case 0:v=3
x=6
return B.c(B.iI("listen.favs"),$async$$0)
case 6:t=e
if(t!=null)$.wA.A(0,J.fC(y._.a(C.ap.f3(t,null)),new A.aPI(),y.S))
v=1
x=5
break
case 3:v=2
l=u.pop()
x=5
break
case 2:x=1
break
case 5:v=8
x=11
return B.c(B.iI("listen.pos"),$async$$0)
case 11:s=e
if(s!=null)y.f.a(C.ap.f3(s,null)).b4(0,new A.aPJ())
v=1
x=10
break
case 8:v=7
k=u.pop()
x=10
break
case 7:x=1
break
case 10:v=13
x=16
return B.c(B.iI("listen.last"),$async$$0)
case 16:r=e
if(r!=null)$.cbs=B.cJ(y.f.a(C.ap.f3(r,null)),y.N,y.z)
v=1
x=15
break
case 13:v=12
j=u.pop()
x=15
break
case 12:x=1
break
case 15:v=18
x=21
return B.c(B.iI("listen.prefs"),$async$$0)
case 21:q=e
if(q!=null){p=y.f.a(C.ap.f3(q,null))
m=B.ar(J.as(p,"speed"))
o=m==null?null:m
if(o!=null&&C.b.n(D.Nz,o))$.Ro=o
$.HF=C.b.md(D.KR,new A.aPK(p),new A.aPL())}v=1
x=20
break
case 18:v=17
i=u.pop()
x=20
break
case 17:x=1
break
case 20:return B.i(null,w)
case 1:return B.h(u.at(-1),w)}})
return B.j($async$$0,w)},
$S:112}
A.aPI.prototype={
$1(d){return C.f.bB(B.cS(d))},
$S:212}
A.aPJ.prototype={
$2(d,e){var x=B.n(d)
B.cS(e)
$.tt.p(0,x,e)
return e},
$S:263}
A.aPK.prototype={
$1(d){return d.b===this.a.h(0,"mode")},
$S:z+7}
A.aPL.prototype={
$0(){return D.tC},
$S:z+8}
A.aPN.prototype={
$0(){var x=0,w=B.k(y.j),v,u=2,t=[],s=[],r=this,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1
var $async$$0=B.e(function(a2,a3){if(a2===1){t.push(a3)
x=u}for(;;)switch(x){case 0:u=3
q=null
p=null
u=7
x=10
return B.c(B.iI("listen.cache.v1"),$async$$0)
case 10:o=a3
if(o!=null){n=y.f.a(C.ap.f3(o,null))
p=B.dJ(B.n(J.as(n,"t")))
q=A.ceg(n)}u=3
x=9
break
case 7:u=6
d=t.pop()
x=9
break
case 6:x=3
break
case 9:if(!r.a&&q!=null&&J.aN(q)!==0&&p!=null&&new B.aO(Date.now(),0,!1).dD(p).a<1728e8){e=A.aBq(q)
$.wB=e
$.wC=!1
v=e
s=[1]
x=4
break}u=12
x=15
return B.c(A.acN(),$async$$0)
case 15:m=a3
l=new B.aO(Date.now(),0,!1)
A.ciQ(m,l)
$.acO=!1
e=A.aBq(m)
$.wB=e
$.wC=!1
v=e
s=[1]
x=4
break
u=3
x=14
break
case 12:u=11
a0=t.pop()
k=B.a8(a0)
if(q!=null&&J.aN(q)!==0){$.acO=!1
h=A.aBq(q)
$.wB=h
$.wC=!0
j=h
A.Rn()
v=j
s=[1]
x=4
break}u=17
x=20
return B.c(A.acP(),$async$$0)
case 20:i=a3
if(J.bU(i)){e=B.du("empty snapshot")
throw B.t(e)}$.acO=!0
j=A.aBq(i)
$.wB=j
$.wC=!0
h=j
A.Rn()
v=h
s=[1]
x=4
break
u=11
x=19
break
case 17:u=16
a1=t.pop()
g=B.a8(a1)
e=$.HE
if(e==null)e=A.ciR(k)
$.HE=e+" \u2022 snapshot: "+A.ciR(g)
throw a1
x=19
break
case 16:x=11
break
case 19:x=14
break
case 11:x=3
break
case 14:s.push(5)
x=4
break
case 3:s=[2]
case 4:u=2
$.cbq=null
x=s.pop()
break
case 5:case 1:return B.i(v,w)
case 2:return B.h(t.at(-1),w)}})
return B.j($async$$0,w)},
$S:z+9}
A.aPF.prototype={
$0(){var x=this.a,w=x.a
w===$&&B.b()
w.ky()
x.at=D.oB
x.ax=null
x.a5()},
$S:0}
A.aPx.prototype={
$1(d){return this.a.E0()},
$S:72}
A.aPy.prototype={
$1(d){var x=this.a.a
x===$&&B.b()
return x.ky()},
$S:72}
A.aPz.prototype={
$1(d){return this.a.zq()},
$S:72}
A.aPA.prototype={
$1(d){return this.a.vX()},
$S:72}
A.aPB.prototype={
$1(d){var x=this.a,w=x.a
w===$&&B.b()
return x.kd(w.lS("currentTime")+-10)},
$S:72}
A.aPC.prototype={
$1(d){var x=this.a,w=x.a
w===$&&B.b()
return x.kd(w.lS("currentTime")+10)},
$S:72}
A.aPD.prototype={
$1(d){if(d!=null)this.a.kd(d)},
$S:72}
A.aPE.prototype={
$1(d){return this.a.eQ()},
$S:72}
A.bxa.prototype={
$0(){return this.a.e=$.wB},
$S:0}
A.bx6.prototype={
$0(){var x=this.a
x.r=!0
x.f=null},
$S:0}
A.bx7.prototype={
$0(){return this.a.e=this.b},
$S:0}
A.bx8.prototype={
$0(){return this.a.f=this.b},
$S:0}
A.bx9.prototype={
$0(){return this.a.r=!1},
$S:0}
A.bxc.prototype={
$1(d){var x=this.a.gx7()
x.toString
return A.aAS(d.f,x)},
$S:z+0}
A.bxd.prototype={
$1(d){return this.a},
$S:19}
A.bxe.prototype={
$1(d){var x=this.a
if(x.c!=null)x.j(new A.bxb())},
$S:24}
A.bxb.prototype={
$0(){},
$S:0}
A.bx2.prototype={
$1(d){return this.a.$0()},
$S:3}
A.bx5.prototype={
$0(){var x=this.a
return this.b.oq(x.c,x.b,x.a)},
$S:0}
A.bx4.prototype={
$0(){var x=this.a
return this.b.oq(x.c,x.b,x.a)},
$S:0}
A.bx3.prototype={
$0(){var x=this.a.a
return $.vb().oq(x[0],x[1],this.b)},
$S:0}
A.bxw.prototype={
$1(d){return A.aAS(d.f,this.a)},
$S:z+0}
A.bxx.prototype={
$1(d){return d.gavM().e2(0,new A.bxv(this.a))},
$S:z+4}
A.bxv.prototype={
$1(d){return C.c.n(A.v2(d),A.v2(this.a))},
$S:10}
A.bxy.prototype={
$0(){return A.cet(this.a)},
$S:0}
A.bxz.prototype={
$2(d,e){var x,w,v,u,t,s,r=this,q=null,p=r.c,o=r.b,n=y.p,m=B.a([o.aNj()],n)
if(r.d==null)m.push(o.aVp())
x=o.d
w=x.a.a.length===0?q:B.bP(q,q,q,q,C.Ir,q,q,new A.bxn(o),q,q,q,q,q)
v=C.i.aa(0.07)
m.push(B.aI(q,C.y,!1,q,!0,C.m,q,B.aK(),x,q,q,q,q,q,2,B.cI(q,new B.cm(4,B.v(14),C.J),q,C.xa,q,q,q,q,!0,q,q,q,q,q,q,v,!0,q,q,q,q,q,q,q,q,q,q,q,q,q,C.ux,"\u062f\u0648\u0651\u0631 \u0639\u0644\u0649 \u0642\u0627\u0631\u0626\u2026 (\u0627\u0644\u062d\u0635\u0631\u064a\u060c \u0627\u0644\u0645\u0646\u0634\u0627\u0648\u064a\u060c \u0627\u0644\u0639\u0641\u0627\u0633\u064a)",q,q,q,q,q,q,q,q,q,!0,!0,!1,q,C.r5,q,q,q,q,q,q,w,q,q,q,q,q),C.r,!0,q,!0,q,!1,q,C.D,q,q,q,q,q,q,q,q,q,1,q,q,!1,"\u2022",q,new A.bxo(o),q,q,q,!1,q,q,!1,q,!0,q,C.C,q,q,q,q,q,q,q,q,q,q,q,C.d_,!0,C.u,q,C.E,q,q,q,q))
m.push(C.B)
w=B.a([o.ai5("\u0627\u0644\u0645\u0641\u0636\u0644\u064a\u0646",o.y,new A.bxp(o),C.jM)],n)
for(u=0;u<3;++u){t=D.aMY[u]
w.push(o.a0E(t.c,o.x===t,new A.bxq(o,t)))}m.push(B.am(B.b5(w,q,q,q,q,C.ad,!1),40,q))
x=B.a([o.a0E("\u0643\u0644 \u0627\u0644\u0631\u0648\u0627\u064a\u0627\u062a",o.w==null,new A.bxr(o))],n)
for(w=r.e,u=0;u<13;++u){s=D.NC[u]
v=w.h(0,s)
v.toString
if(v>0){v=w.h(0,s)
v.toString
x.push(o.a0E(s+" ("+E.bq(v)+")",o.w===s,new A.bxs(o,s)))}}m.push(B.am(B.b5(x,q,q,q,q,C.ad,!1),40,q))
x=r.f==null
if(x)w="\u0627\u0644\u0627\u0633\u062a\u0645\u0627\u0639 \u0628\u064a\u0633\u062a\u0647\u0644\u0643 \u0646\u062a \u2014 \u0627\u0644\u0633\u0648\u0631\u0629 \u0627\u0644\u0637\u0648\u064a\u0644\u0629 \u0645\u0645\u0643\u0646 \u062a\u0648\u0635\u0644 \u0644\u0639\u0634\u0631\u0627\u062a \u0627\u0644\u0645\u064a\u062c\u0627"
else{w=E.bq(r.a.a.length)
if($.acO)v=" \u2022 \u0642\u0627\u064a\u0645\u0629 \u0645\u062e\u0632\u0651\u0646\u0629 \u0645\u0639 \u0627\u0644\u062a\u0637\u0628\u064a\u0642 (\u0645\u0648\u0642\u0639 \u0627\u0644\u0642\u0631\u0651\u0627\u0621 \u0645\u0634 \u0628\u064a\u0631\u062f \u062f\u0644\u0648\u0642\u062a\u064a)"
else v=$.wC?" \u2022 \u0642\u0627\u064a\u0645\u0629 \u0645\u062d\u0641\u0648\u0638\u0629 (\u0645\u0634 \u0645\u062a\u062d\u062f\u0651\u062b\u0629)":""
v=w+" \u0642\u0627\u0631\u0626 \u2022 \u0627\u0644\u0627\u0633\u062a\u0645\u0627\u0639 \u0628\u064a\u0633\u062a\u0647\u0644\u0643 \u0646\u062a\u060c \u0627\u0644\u0623\u062d\u0633\u0646 \u0639\u0644\u0649 \u0627\u0644\u0648\u0627\u064a \u0641\u0627\u064a"+v
w=v}m.push(new B.B(C.qg,B.z(B.a([D.IY,C.aX,B.R(B.d(w,q,q,q,q,q,H.ur,q,q,q),1)],n),C.h,C.d,C.e,0,q,q),q))
if(!x&&$.wC&&$.HE!=null){w=$.HE
w.toString
m.push(new A.Z5(w,q))}m=B.a([new B.mO(new B.T(p,8,p,0),G.cl4(m),q)],n)
if(o.r&&x)m.push(D.bbp)
else if(x){p=B.a([D.asl,C.v,D.bq4,C.v],n)
n=o.f
if(n!=null){x=$.HE
p.push(new A.Z5(x==null?B.n(n):x,q))}p.push(B.dC(C.mf,new A.bxt(o),q))
m.push(B.cl2(B.bL(new B.B(C.b8,B.I(p,C.h,C.d,C.K,0,C.l),q),q,q),!1))}else{n=r.a
x=n.a.length
if(x===0)m.push(new B.nD(new B.B(C.Gb,B.d(o.y&&$.wA.a===0?"\u0644\u0633\u0647 \u0645\u0641\u064a\u0634 \u0645\u0641\u0636\u0644\u064a\u0646 \u2014 \u062f\u0648\u0633 \u2606 \u062c\u0646\u0628 \u0627\u0644\u0642\u0627\u0631\u0626":"\u0645\u0641\u064a\u0634 \u0642\u0627\u0631\u0626 \u0628\u0627\u0644\u0628\u062d\u062b \u062f\u0647",q,q,q,q,q,C.fe,C.Z,q,q),q),q))
else m.push(new B.mO(new B.T(p,0,p,24),G.ajk(new A.bxu(n,o),x+1),q))}return B.Pi(q,q,m)},
$S:403}
A.bxo.prototype={
$1(d){return this.a.j(new A.bxm())},
$S:5}
A.bxm.prototype={
$0(){},
$S:0}
A.bxn.prototype={
$0(){var x=this.a,w=x.d
return x.j(w.gbbb(w))},
$S:0}
A.bxp.prototype={
$0(){var x=this.a
return x.j(new A.bxl(x))},
$S:0}
A.bxl.prototype={
$0(){var x=this.a
return x.y=!x.y},
$S:0}
A.bxq.prototype={
$0(){var x=this.a
return x.j(new A.bxk(x,this.b))},
$S:0}
A.bxk.prototype={
$0(){var x=this.a,w=this.b
return x.x=x.x===w?null:w},
$S:0}
A.bxr.prototype={
$0(){var x=this.a
return x.j(new A.bxj(x))},
$S:0}
A.bxj.prototype={
$0(){return this.a.w=null},
$S:0}
A.bxs.prototype={
$0(){var x=this.a
return x.j(new A.bxi(x,this.b))},
$S:0}
A.bxi.prototype={
$0(){var x=this.a,w=this.b
return x.w=x.w===w?null:w},
$S:0}
A.bxt.prototype={
$0(){return this.a.AZ(!0)},
$S:0}
A.bxu.prototype={
$2(d,e){var x,w=this.a,v=w.a
if(e===v.length)w=D.a4R
else{x=this.b
x=new A.aus(v[e],new A.bxg(w,x,e),new A.bxh(w,x,e),null)
w=x}return w},
$S:348}
A.bxg.prototype={
$0(){return this.b.aZA(this.a.a[this.c])},
$S:0}
A.bxh.prototype={
$0(){var x=0,w=B.k(y.H),v=this,u
var $async$$0=B.e(function(d,e){if(d===1)return B.h(e,w)
for(;;)switch(x){case 0:x=2
return B.c(A.acQ(v.a.a[v.c].a),$async$$0)
case 2:u=v.b
if(u.c!=null)u.j(new A.bxf())
return B.i(null,w)}})
return B.j($async$$0,w)},
$S:1}
A.bxf.prototype={
$0(){},
$S:0}
A.bpA.prototype={
$0(){var x=null
B.hK(new B.hh(this.a.c))
this.b.H(y.I).f.Z(B.aQ(x,x,x,x,x,C.m,x,B.d("\u0627\u062a\u0646\u0633\u062e\u062a \u0627\u0644\u062a\u0641\u0627\u0635\u064a\u0644 \u2014 \u0627\u0628\u0639\u062a\u0647\u0627 \u0644\u0644\u062f\u0639\u0645",x,x,x,x,x,x,x,x,x),x,C.x,x,x,x,x,x,x,x,x,x,x))},
$S:0}
A.bNR.prototype={
$1(d){return C.b.ga1(d.split(" "))},
$S:40}
A.bNS.prototype={
$1(d){return d.c},
$S:z+12}
A.blL.prototype={
$0(){return A.cet(this.a)},
$S:0}
A.c8I.prototype={
$1(d){var x=null
return B.dr(B.a([B.bf(D.brB,x,x,x,new A.c8G(),x,x),B.bf(C.kq,x,x,x,new A.c8H(d),x,x)],y.p),D.bw8,D.bs0)},
$S:14}
A.c8G.prototype={
$0(){return B.cp(B.bx("https://www.mp3quran.net/ar",0,null),C.aM,null)},
$S:0}
A.c8H.prototype={
$0(){B.O(this.a,!1).ag(null)
return null},
$S:0}
A.bNO.prototype={
$2(d,e){var x=this.a,w=x.n(0,d)?0:1
return C.j.bN(w,x.n(0,e)?0:1)},
$S:z+3}
A.bNP.prototype={
$0(){var x=0,w=B.k(y.H),v=this,u
var $async$$0=B.e(function(d,e){if(d===1)return B.h(e,w)
for(;;)switch(x){case 0:x=2
return B.c(A.acQ(v.b.a),$async$$0)
case 2:u=v.a
if(u.c!=null)u.j(new A.bNN())
return B.i(null,w)}})
return B.j($async$$0,w)},
$S:1}
A.bNN.prototype={
$0(){},
$S:0}
A.bNQ.prototype={
$0(){var x=this,w=y.z
return B.O(x.a,!1).aE(B.aF(new A.bNM(x.b,x.c,x.d),null,w),w)},
$S:0}
A.bNM.prototype={
$1(d){return new A.qu(this.a,this.b,this.c,null)},
$S:z+5}
A.bBc.prototype={
$2(d,e){var x,w,v,u,t,s,r,q=this,p=null,o=q.b,n=o.b,m=n==null,l=!1
if(!m&&o.d!=null){n=m?p:n.a
if(n===q.c.a){n=o.c
n=n==null?p:n.a
n=n===q.d.a
l=n}}n=q.a
m=n.d
m===$&&B.b()
x=q.e
w=q.d
v=B.d(w.ghu(),p,1,C.N,p,p,C.bz,p,p,p)
u=w.f
t=u.length
s=q.c
r=y.p
return B.Pi(p,m,B.a([new B.mO(new B.T(x,8,x,6),new B.nD(B.am(new E.dE(B.I(B.a([v,B.d(t===114?"\u0627\u0644\u0645\u0635\u062d\u0641 \u0643\u0627\u0645\u0644 (\u0661\u0661\u0664 \u0633\u0648\u0631\u0629)":"\u0645\u062a\u0627\u062d "+E.bq(t)+" \u0633\u0648\u0631\u0629 \u0645\u0646 \u0661\u0661\u0664",p,p,p,p,p,F.aO,p,p,p),C.G,B.z(B.a([B.fq(D.yW,D.bnI,new A.bBa(o,s,w),B.ez(C.t,C.ag,p,p,p,p,C.cR))],r),C.h,C.d,C.e,0,p,p)],r),C.q,C.cf,C.e,0,C.l),C.a5,C.I,p,!1,p),112,p),p),p),new B.mO(new B.T(x,0,x,24),B.cCS(new B.u7(new A.bBb(n,w,l,o,s),u.length,!0,!0,!0,0,B.a5A(),p),64),p)],r))},
$S:403}
A.bBa.prototype={
$0(){var x=this,w=$.HF
if(w===D.ZI||w===D.ZH){$.HF=D.tC
A.cbt()
x.a.a5()}w=x.c
x.a.a9U(x.b,w,C.b.ga1(w.f),!1)},
$S:0}
A.bBb.prototype={
$2(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=null,j=l.b,i=j.f[e]
if(l.c){x=l.d.d
w=(x==null?k:x.b)===i}else w=!1
x=l.e
v=$.tt.h(0,""+x.a+"/"+j.a+"/"+i)
u=l.a.a.e===i
t=I.cW[i-1]
s=w||u
r=l.d
q=B.am(B.d(E.bq(i),k,k,k,k,k,C.md,C.Z,k,k),k,34)
p=B.d(A.N2(i),k,k,k,k,k,C.bz,k,k,k)
if(w)o=r.f?"\u0628\u064a\u062d\u0645\u0651\u0644\u2026":E.bq(A.N7(r.w))+" / "+E.bq(A.N7(r.x))
else{o=t.a
n=o[2]?"\u0645\u0643\u064a\u0629":"\u0645\u062f\u0646\u064a\u0629"
o=E.bq(o[1])
m=v!=null?" \u2022 \u0648\u0642\u0641\u062a \u0639\u0646\u062f "+E.bq(A.N7(v)):""
m=n+" \u2022 "+o+" \u0622\u064a\u0629"+m
o=m}n=y.p
o=B.R(B.I(B.a([p,B.d(o,k,k,k,k,k,F.aO,k,k,k)],n),C.q,C.cf,C.e,0,C.l),1)
p=w&&r.e?"\u0625\u064a\u0642\u0627\u0641 \u0645\u0624\u0642\u062a":"\u062a\u0634\u063a\u064a\u0644"
return new E.dE(B.z(B.a([q,C.aX,o,B.bP(k,k,k,k,B.aX(w&&r.e?D.apE:C.nx,C.t,k,34),k,k,new A.bB8(w,r,x,j,i),k,k,k,p,k)],n),C.h,C.d,C.e,0,k,k),D.akj,C.d6,new A.bB9(w,d,r,x,j,i),s,k)},
$S:z+13}
A.bB9.prototype={
$0(){var x=this
return x.a?A.cq_(x.b):x.c.oq(x.d,x.e,x.f)},
$S:0}
A.bB8.prototype={
$0(){var x=this,w=x.b
return x.a?w.E0():w.oq(x.c,x.d,x.e)},
$S:0}
A.aPw.prototype={
$2(d,e){var x,w,v,u,t,s,r=null,q=this.a
if(!(q.b!=null&&q.d!=null))return C.b0
x=q.x
w=x>0?C.f.d1(q.w/x,0,1):0
x=B.mi(B.qk(C.eC,C.t,2.5,q.f&&q.x===0?r:w,r),C.z)
v=q.d
v=v==null?r:v.b
v.toString
v=B.d(A.N2(v),r,1,C.N,r,r,C.bz,r,r,r)
u=q.r
t=u==null
if(t)u=q.b.b
s=y.p
u=B.a([D.auy,C.Y,B.R(B.I(B.a([v,B.d(u,r,1,C.N,r,r,B.bB(r,r,!t?D.EC:C.cM,r,r,r,r,r,r,r,r,12,r,r,r,r,r,!0,r,r,r,r,r,r,r,r),r,r,r)],s),C.q,C.d,C.e,0,C.l),1)],s)
if(q.f&&!q.e)u.push(D.aXP)
else{v=q.e
t=v?"\u0625\u064a\u0642\u0627\u0641 \u0645\u0624\u0642\u062a":"\u062a\u0634\u063a\u064a\u0644"
if(q.r!=null)v=C.ny
else v=v?D.HQ:C.qU
u.push(B.bP(r,r,r,r,B.aX(v,C.i,r,30),r,r,q.gaw8(),r,r,r,t,r))}v=q.d
v=v==null?r:v.gasO()
u.push(B.bP(r,r,r,r,D.asU,r,r,v===!0?q.gmo():r,r,r,r,"\u0627\u0644\u0633\u0648\u0631\u0629 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627",r))
u.push(B.bP(r,r,r,r,D.asf,r,r,q.gMQ(),r,r,r,"\u0642\u0641\u0644",r))
return B.d1(!1,C.a2,!0,r,B.cx(!0,B.bu(!1,r,!0,B.I(B.a([x,new B.B(D.aku,B.z(u,C.h,C.d,C.e,0,r,r),r)],s),C.h,C.d,C.K,0,C.l),r,!0,r,r,r,r,r,r,r,r,r,r,r,new A.aPv(d),r,r,r,r,r,r,r),C.I,!1),C.k,C.cT,0,r,r,r,r,r,C.b3)},
$S:54}
A.aPv.prototype={
$0(){return A.cq_(this.a)},
$S:0}
A.c7m.prototype={
$1(d){return D.aPB},
$S:z+14}
A.bxA.prototype={
$1(d){return this.a.$0()},
$S:3}
A.bxN.prototype={
$2(a0,a1){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f=null,e=this.b,d=e.b
if(!(d!=null&&e.d!=null))return D.bbj
x=e.c
x.toString
w=e.d
w=w==null?f:w.b
w.toString
v=e.x
u=this.a
t=u.d
if(t==null)t=e.w
s=e.ax
r=s==null?f:s.dD(new B.aO(Date.now(),0,!1))
s=B.bL(B.E(f,f,C.k,f,f,new B.F(C.ir,f,f,B.v(2),f,f,f,C.n),f,4,f,f,f,f,f,40),f,f)
q=C.t.aa(0.15)
p=B.aH(C.t.aa(0.5),1)
o=y.p
w=B.a([s,C.a4,B.bL(B.E(f,B.aX(e.e?D.yy:C.jJ,C.t,f,40),C.k,f,f,new B.F(q,f,p,f,f,f,f,C.bW),f,84,f,f,f,f,f,84),f,f),C.v,B.d(A.N2(w),f,f,f,f,f,K.a1L,C.Z,f,f),B.d(d.b,f,f,f,f,f,D.bfA,C.Z,f,f),B.d(x.ghu(),f,f,f,f,f,F.aO,C.Z,f,f)],o)
s=e.r
if(s!=null){q=B.v(12)
w.push(B.E(f,B.z(B.a([D.aqV,C.O,B.R(B.d(s,f,f,f,f,f,C.d_,f,f,f),1),B.bf(D.bt_,f,f,f,e.gbmT(),f,f)],o),C.h,C.d,C.e,0,f,f),C.k,f,f,new B.F(D.aeQ,f,f,q,f,f,f,C.n),f,f,f,C.l1,C.bP,f,f,f))}s=e.z
if(s!=null&&e.r==null)w.push(new B.B(C.hP,B.z(B.a([B.d("\u0643\u0645\u0651\u0644\u0646\u0627 \u0645\u0646 "+E.bq(A.N7(s)),f,f,f,f,f,F.aO,f,f,f),B.bf(D.bxd,f,f,f,e.gbmN(),f,f)],o),C.h,C.cf,C.e,0,f,f),f))
w.push(C.G)
s=G.cce(a0).bdi(C.t,C.eC,C.afE,C.t,D.b7S,3)
q=v>0
p=q?C.f.d1(t,0,v):0
n=q?C.f.d1(e.y,0,v):f
m=q?v:1
l=q?new A.bxE(u):f
s=A.cl0(G.cl_(f,f,m,0,q?new A.bxF(u,e):f,l,n,p),s)
p=B.d(E.bq(A.N7(t)),f,f,f,f,f,C.BL,f,f,f)
p=B.z(B.a([p,C.bC,B.d(q?E.bq(A.N7(v)):"--:--",f,f,f,f,f,C.BL,f,f,f)],o),C.h,C.d,C.e,0,f,f)
n=B.bP(C.i,f,f,f,D.arI,32,f,e.gVx(),f,f,f,"\u0627\u0644\u0633\u0648\u0631\u0629 \u0627\u0644\u0644\u064a \u0642\u0628\u0644\u0647\u0627",f)
m=B.bP(C.i,f,f,f,D.aqt,30,f,new A.bxG(e),f,f,f,"\u0631\u062c\u0648\u0639 \u0661\u0660 \u062b\u0648\u0627\u0646\u064a",f)
if(e.f&&!e.e&&e.r==null)q=D.aXT
else{q=e.e?"\u0625\u064a\u0642\u0627\u0641 \u0645\u0624\u0642\u062a":"\u062a\u0634\u063a\u064a\u0644"
l=B.te(f,C.t,f,f,f,f,f,C.ag,f,f,f,f,f,f,f,f,f)
if(e.r!=null)k=C.ny
else k=e.e?D.HQ:C.qU
q=B.Qz(B.aX(k,f,f,f),40,e.gaw8(),l,q,f)}q=B.am(q,68,68)
l=B.bP(C.i,f,f,f,D.atd,30,f,new A.bxH(e),f,f,f,"\u0642\u062f\u0651\u0627\u0645 \u0661\u0660 \u062b\u0648\u0627\u0646\u064a",f)
k=e.d
k=k==null?f:k.gasO()
w.push(B.mi(B.I(B.a([s,new B.B(D.al4,p,f),C.aj,B.z(B.a([n,m,q,l,B.bP(C.i,f,C.ir,f,D.ass,32,f,k===!0?e.gmo():f,f,f,f,"\u0627\u0644\u0633\u0648\u0631\u0629 \u0627\u0644\u0644\u064a \u0628\u0639\u062f\u0647\u0627",f)],o),C.h,C.zK,C.e,0,f,f)],o),C.h,C.d,C.e,0,C.l),C.z))
s=B.a([],o)
for(j=0;j<4;++j){i=D.KR[j]
s.push(u.Z3(i.c,$.HF===i,new A.bxI(e,i)))}w.push(u.a0F("\u0628\u0639\u062f \u0645\u0627 \u0627\u0644\u0633\u0648\u0631\u0629 \u062a\u062e\u0644\u0635",s))
s=B.a([],o)
for(j=0;j<4;++j){h=D.Nz[j]
s.push(u.Z3(E.bq(h===C.f.og(h)?C.f.bB(h):h)+"\xd7",$.Ro===h,new A.bxJ(e,h)))}w.push(u.a0F("\u0627\u0644\u0633\u0631\u0639\u0629",s))
if(r!=null&&r.a>=0)s="\u0645\u0624\u0642\u062a \u0627\u0644\u0646\u0648\u0645 \u2014 \u0647\u064a\u0642\u0641 \u0628\u0639\u062f "+E.bq(C.j.aI(r.a,6e7)+1)+" \u062f\u0642\u064a\u0642\u0629"
else s=e.at===D.B7?"\u0645\u0624\u0642\u062a \u0627\u0644\u0646\u0648\u0645 \u2014 \u0647\u064a\u0642\u0641 \u0622\u062e\u0631 \u0627\u0644\u0633\u0648\u0631\u0629":"\u0645\u0624\u0642\u062a \u0627\u0644\u0646\u0648\u0645"
q=B.a([],o)
for(j=0;j<5;++j){g=D.aDe[j]
q.push(u.Z3(g.d,e.at===g,new A.bxK(e,g)))}w.push(u.a0F(s,q))
w.push(C.a4)
e=e.as
w.push(B.z(B.a([D.IY,C.aX,B.R(B.d(e!=null?"\u062d\u062c\u0645 \u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a "+E.bq(A.cLJ(e))+" \u2014 \u0627\u0644\u0627\u0633\u062a\u0645\u0627\u0639 \u0628\u064a\u0633\u062a\u0647\u0644\u0643 \u0646\u062a":"\u0627\u0644\u0627\u0633\u062a\u0645\u0627\u0639 \u0628\u064a\u0633\u062a\u0647\u0644\u0643 \u0646\u062a \u2014 \u0627\u0644\u0623\u062d\u0633\u0646 \u0639\u0644\u0649 \u0627\u0644\u0648\u0627\u064a \u0641\u0627\u064a",f,f,f,f,f,H.ur,f,f,f),1)],o),C.h,C.d,C.e,0,f,f))
w.push(C.aj)
w.push(B.z(B.a([B.fg(D.auY,f,D.byH,new A.bxL(a0,d,x),f),C.bC,B.bf(D.byc,f,f,f,new A.bxM(a0),f,f)],o),C.h,C.d,C.e,0,f,f))
return B.f1(B.bL(new B.dl(C.vK,B.I(w,C.ac,C.d,C.K,0,C.l),f),f,f),f,C.r,D.al3,f,f,C.w)},
$S:54}
A.bxE.prototype={
$1(d){var x=this.a
return x.j(new A.bxD(x,d))},
$S:71}
A.bxD.prototype={
$0(){return this.a.d=this.b},
$S:0}
A.bxF.prototype={
$1(d){var x
this.b.kd(d)
x=this.a
x.j(new A.bxC(x))},
$S:71}
A.bxC.prototype={
$0(){return this.a.d=null},
$S:0}
A.bxG.prototype={
$0(){var x=this.a,w=x.a
w===$&&B.b()
return x.kd(w.lS("currentTime")+-10)},
$S:0}
A.bxH.prototype={
$0(){var x=this.a,w=x.a
w===$&&B.b()
return x.kd(w.lS("currentTime")+10)},
$S:0}
A.bxI.prototype={
$0(){$.HF=this.b
A.cbt()
this.a.a5()
return null},
$S:0}
A.bxJ.prototype={
$0(){var x,w=this.a,v=this.b
$.Ro=v
A.cbt()
x=w.a
x===$&&B.b()
x.a9C(v)
w.HO(!0)
w.a5()
return null},
$S:0}
A.bxK.prototype={
$0(){return this.a.X9(this.b)},
$S:0}
A.bxL.prototype={
$0(){var x,w=this.a
B.O(w,!1).e5()
x=y.z
B.O(w,!1).aE(B.aF(new A.bxB(this.b,this.c),null,x),x)},
$S:0}
A.bxB.prototype={
$1(d){return new A.qu(this.a,this.b,null,null)},
$S:z+5}
A.bxM.prototype={
$0(){return A.cet(this.a)},
$S:0};(function installTearOffs(){var x=a._instance_1u,w=a._instance_0u
var v
x(v=A.Rm.prototype,"gaRT","a00",10)
w(v,"gaw8","E0",1)
w(v,"gbmT","avK",1)
w(v,"gbmN","bmO",2)
w(v,"gmo","vX",1)
w(v,"gVx","zq",1)
w(v,"gMQ","eQ",2)
x(v,"gaVH","aVI",11)
w(A.a_g.prototype,"gaj5","aYB",2)})();(function inheritance(){var x=a.inherit,w=a.inheritMany
x(A.JE,B.dR)
w(B.iN,[A.c6E,A.aPH,A.c6q,A.c8z,A.aYv,A.c7z,A.c7A,A.c7B,A.c7C,A.c7G,A.c6m,A.c2R,A.aPI,A.aPK,A.aPx,A.aPy,A.aPz,A.aPA,A.aPB,A.aPC,A.aPD,A.aPE,A.bxc,A.bxd,A.bxe,A.bx2,A.bxw,A.bxx,A.bxv,A.bxo,A.bNR,A.bNS,A.c8I,A.bNM,A.c7m,A.bxA,A.bxE,A.bxF,A.bxB])
w(B.Ef,[A.oQ,A.xJ,A.tU])
w(B.a6,[A.aPG,A.oH,A.kS])
w(B.og,[A.aYw,A.c7D,A.c8Y,A.aPJ,A.bxz,A.bxu,A.bNO,A.bBc,A.bBb,A.aPw,A.bxN])
w(B.lj,[A.aPM,A.aPL,A.aPN,A.aPF,A.bxa,A.bx6,A.bx7,A.bx8,A.bx9,A.bxb,A.bx5,A.bx4,A.bx3,A.bxy,A.bxm,A.bxn,A.bxp,A.bxl,A.bxq,A.bxk,A.bxr,A.bxj,A.bxs,A.bxi,A.bxt,A.bxg,A.bxh,A.bxf,A.bpA,A.blL,A.c8G,A.c8H,A.bNP,A.bNN,A.bNQ,A.bBa,A.bB9,A.bB8,A.aPv,A.bxD,A.bxC,A.bxG,A.bxH,A.bxI,A.bxJ,A.bxK,A.bxL,A.bxM])
x(A.Rm,B.i7)
w(B.L,[A.wz,A.Tn,A.qu,A.Bd])
w(B.N,[A.a_g,A.aur,A.asL,A.asg])
w(B.a2,[A.Z5,A.aus,A.ap3,A.acM])})()
B.pv(b.typeUniverse,JSON.parse('{"JE":{"dR":[],"bQ":[],"bD":[],"l":[]},"Tn":{"L":[],"l":[]},"qu":{"L":[],"l":[]},"Bd":{"L":[],"l":[]},"Rm":{"aD":[]},"wz":{"L":[],"l":[]},"a_g":{"N":["wz"]},"Z5":{"a2":[],"l":[]},"aus":{"a2":[],"l":[]},"ap3":{"a2":[],"l":[]},"aur":{"N":["Tn"]},"asL":{"N":["qu"]},"acM":{"a2":[],"l":[]},"asg":{"N":["Bd"]}}'))
var y=(function rtii(){var x=B.ae
return{O:x("H<bR>"),t:x("H<aA<o,@>>"),Q:x("H<oH>"),Z:x("H<kS>"),A:x("H<+(x,kS)>"),s:x("H<o>"),p:x("H<l>"),m:x("bR"),j:x("a7<kS>"),_:x("a7<@>"),f:x("aA<@,@>"),c:x("oH"),P:x("bG"),K:x("a6"),D:x("tU"),q:x("kU"),N:x("o"),I:x("ps"),z:x("@"),S:x("x"),V:x("hV?"),g:x("a7<@>?"),H:x("~"),B:x("~(a3?)")}})();(function constants(){var x=a.makeConstList
D.aeQ=new B.U(0.2,0.9372549019607843,0.26666666666666666,0.26666666666666666,C.p)
D.aeT=new B.U(1,0.13333333333333333,0.19607843137254902,0.35294117647058826,C.p)
D.EC=new B.U(1,1,0.7058823529411765,0.6588235294117647,C.p)
D.akj=new B.T(10,0,4,0)
D.aku=new B.T(12,6,4,6)
D.akz=new B.T(12,8,4,8)
D.al3=new B.T(18,10,18,18)
D.al4=new B.T(20,0,20,0)
D.yy=new B.Q(63421,"MaterialIcons",null,!1)
D.apE=new B.Q(983122,"MaterialIcons",null,!1)
D.HQ=new B.Q(983126,"MaterialIcons",null,!1)
D.I5=new B.Q(983505,"MaterialIcons",null,!1)
D.apK=new B.Q(983288,"MaterialIcons",null,!1)
D.aqt=new B.G(D.apK,null,null,null,null,null)
D.aqV=new B.G(C.lf,null,D.EC,null,null,null)
D.ar5=new B.G(D.yy,20,C.t,null,null,null)
D.arI=new B.G(L.I4,null,null,null,null,null)
D.asf=new B.G(C.hT,null,C.c8,null,null,null)
D.asl=new B.G(C.Ic,40,C.c8,null,null,null)
D.I3=new B.Q(983442,"MaterialIcons",null,!1)
D.ass=new B.G(D.I3,null,null,null,null,null)
D.asU=new B.G(D.I3,null,C.ao,null,null,null)
D.ap5=new B.Q(63390,"MaterialIcons",null,!1)
D.atd=new B.G(D.ap5,null,null,null,null,null)
D.IY=new B.G(C.Id,15,C.c8,null,null,null)
D.yW=new B.G(C.qU,null,null,null,null,null)
D.auy=new B.G(D.yy,null,C.t,null,null,null)
D.ap3=new B.Q(63380,"MaterialIcons",null,!1)
D.auY=new B.G(D.ap3,18,C.t,null,null,null)
D.apb=new B.Q(63471,"MaterialIcons",null,!1)
D.avq=new B.G(D.apb,null,C.t,null,null,null)
D.tC=new A.oQ("\u0643\u0645\u0651\u0644 \u0627\u0644\u0645\u0635\u062d\u0641",0,"continuous")
D.ZH=new A.oQ("\u0643\u0631\u0651\u0631 \u0627\u0644\u0633\u0648\u0631\u0629",1,"repeatOne")
D.aYZ=new A.oQ("\u0643\u0631\u0651\u0631 \u0627\u0644\u0645\u0635\u062d\u0641 \u0643\u0644\u0647",2,"repeatAll")
D.ZI=new A.oQ("\u0627\u0644\u0633\u0648\u0631\u0629 \u062f\u064a \u0628\u0633",3,"once")
D.KR=x([D.tC,D.ZH,D.aYZ,D.ZI],B.ae("H<oQ>"))
D.oB=new A.xJ(null,"\u0645\u0646 \u063a\u064a\u0631",0,"off")
D.bbm=new A.xJ(15,"\u0661\u0665 \u062f\u0642\u064a\u0642\u0629",1,"m15")
D.bbk=new A.xJ(30,"\u0663\u0660 \u062f\u0642\u064a\u0642\u0629",2,"m30")
D.bbl=new A.xJ(60,"\u0633\u0627\u0639\u0629",3,"m60")
D.B7=new A.xJ(null,"\u0622\u062e\u0631 \u0627\u0644\u0633\u0648\u0631\u0629",4,"endOfSurah")
D.aDe=x([D.oB,D.bbm,D.bbk,D.bbl,D.B7],B.ae("H<xJ>"))
D.aEj=x(["\u0645\u062d\u0645\u0648\u062f \u062e\u0644\u064a\u0644 \u0627\u0644\u062d\u0635\u0631\u064a","\u0645\u062d\u0645\u062f \u0635\u062f\u064a\u0642 \u0627\u0644\u0645\u0646\u0634\u0627\u0648\u064a","\u0639\u0628\u062f\u0627\u0644\u0628\u0627\u0633\u0637 \u0639\u0628\u062f\u0627\u0644\u0635\u0645\u062f","\u0645\u0634\u0627\u0631\u064a \u0627\u0644\u0639\u0641\u0627\u0633\u064a","\u0639\u0628\u062f\u0627\u0644\u0631\u062d\u0645\u0646 \u0627\u0644\u0633\u062f\u064a\u0633","\u0633\u0639\u0648\u062f \u0627\u0644\u0634\u0631\u064a\u0645","\u0645\u0627\u0647\u0631 \u0627\u0644\u0645\u0639\u064a\u0642\u0644\u064a","\u0633\u0639\u062f \u0627\u0644\u063a\u0627\u0645\u062f\u064a","\u064a\u0627\u0633\u0631 \u0627\u0644\u062f\u0648\u0633\u0631\u064a","\u0645\u062d\u0645\u062f \u0623\u064a\u0648\u0628","\u0645\u062d\u0645\u062f \u0627\u0644\u0637\u0628\u0644\u0627\u0648\u064a","\u0645\u062d\u0645\u0648\u062f \u0639\u0644\u064a \u0627\u0644\u0628\u0646\u0627","\u0623\u062d\u0645\u062f \u0628\u0646 \u0639\u0644\u064a \u0627\u0644\u0639\u062c\u0645\u064a","\u0639\u0644\u064a \u0628\u0646 \u0639\u0628\u062f\u0627\u0644\u0631\u062d\u0645\u0646 \u0627\u0644\u062d\u0630\u064a\u0641\u064a","\u0646\u0627\u0635\u0631 \u0627\u0644\u0642\u0637\u0627\u0645\u064a","\u0625\u062f\u0631\u064a\u0633 \u0623\u0628\u0643\u0631","\u0641\u0627\u0631\u0633 \u0639\u0628\u0627\u062f","\u0623\u0628\u0648 \u0628\u0643\u0631 \u0627\u0644\u0634\u0627\u0637\u0631\u064a"],y.s)
D.aFD=x([C.FF,C.f_,C.x_],B.ae("H<bF>"))
D.Nz=x([0.75,1,1.25,1.5],B.ae("H<a3>"))
D.NC=x(["\u062d\u0641\u0635","\u0648\u0631\u0634","\u0642\u0627\u0644\u0648\u0646","\u0627\u0644\u062f\u0648\u0631\u064a","\u0627\u0644\u0633\u0648\u0633\u064a","\u0634\u0639\u0628\u0629","\u0627\u0644\u0628\u0632\u064a","\u0642\u0646\u0628\u0644","\u062e\u0644\u0641","\u0627\u0628\u0646 \u0630\u0643\u0648\u0627\u0646","\u0647\u0634\u0627\u0645","\u064a\u0639\u0642\u0648\u0628","\u0627\u0628\u0646 \u062c\u0645\u0627\u0632"],y.s)
D.zl=x([],y.Z)
D.As=new A.tU("\u0645\u0631\u062a\u0644",0,"murattal")
D.Ar=new A.tU("\u0645\u062c\u0648\u062f",1,"mujawwad")
D.Aq=new A.tU("\u0645\u0639\u0644\u0645",2,"muallim")
D.aMY=x([D.As,D.Ar,D.Aq],B.ae("H<tU>"))
D.zu=new A.acM(null)
D.aPB=new A.Bd(null)
D.aTj=new B.af(C.cX,[],B.ae("af<o,~(a3?)>"))
D.ac_=new B.hJ(2.4,null,null,null,null,C.t,null,null,null,null)
D.bb7=new B.cB(22,22,D.ac_,null)
D.aXP=new B.B(C.ae,D.bb7,null)
D.ac0=new B.hJ(3,null,null,null,null,C.t,null,null,null,null)
D.aXT=new B.B(C.h6,D.ac0,null)
D.b_D=new B.V("https://mp3quran.net/api/v3/reciters?language=ar",C.na)
D.b13=new B.V("https://www.mp3quran.net/api/v3/reciters?language=ar",C.FB)
D.b36=new B.aZ("\u062d\u0641\u0635 \u0639\u0646 \u0639\u0627\u0635\u0645",D.As,null)
D.b7S=new G.aia(7)
D.bxS=new B.m("\u0645\u0641\u064a\u0634 \u062d\u0627\u062c\u0629 \u0634\u063a\u0651\u0627\u0644\u0629",null,C.fe,null,null,null,null,null,null,null,null)
D.abs=new B.ch(C.P,null,null,D.bxS,null)
D.bbj=new B.cB(null,160,D.abs,null)
D.bbp=new B.V6(C.mJ,!1,null)
D.bdN=new B.r(!0,C.eX,null,null,null,null,10.5,null,null,null,null,null,1.5,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bfA=new B.r(!0,C.t,null,null,null,null,15,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bjt=new B.r(!0,C.ao,null,null,null,null,12.5,C.S,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.bmr=new B.m("\u0627\u0644\u062a\u0644\u0627\u0648\u0627\u062a \u0645\u0646 mp3quran.net",null,C.BG,null,null,null,null,null,null,null,null)
D.bnI=new B.m("\u0634\u063a\u0651\u0644 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,null,null,null,null,null,null,null,null,null)
D.bq4=new B.m("\u0645\u0639\u0631\u0641\u0646\u0627\u0634 \u0646\u062c\u064a\u0628 \u0642\u0627\u064a\u0645\u0629 \u0627\u0644\u0642\u0631\u0651\u0627\u0621 \u2014 \u0627\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0646\u062a \u0648\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a",null,C.fe,C.Z,null,null,null,null,null,null,null)
D.brB=new B.m("mp3quran.net",null,null,null,null,null,null,null,null,null,null)
D.bs0=new B.m("\u0639\u0646 \u0627\u0644\u062a\u0644\u0627\u0648\u0627\u062a",null,null,null,null,null,null,null,null,null,null)
D.bt_=new B.m("\u062c\u0631\u0651\u0628 \u062a\u0627\u0646\u064a",null,C.eS,null,null,null,null,null,null,null,null)
D.bw8=new B.m("\u0627\u0644\u062a\u0644\u0627\u0648\u0627\u062a \u0645\u0646 \u0645\u0648\u0642\u0639 mp3quran.net (\u0623\u0643\u062a\u0631 \u0645\u0646 \u0662\u0660\u0660 \u0642\u0627\u0631\u0626 \u0628\u0631\u0648\u0627\u064a\u0627\u062a \u0645\u062e\u062a\u0644\u0641\u0629) \u2014 \u0627\u0644\u0645\u0648\u0642\u0639 \u0628\u064a\u062a\u064a\u062d \u0627\u0633\u062a\u062e\u062f\u0627\u0645 \u0645\u0648\u0627\u062f\u0647 \u0648\u0631\u0648\u0627\u0628\u0637\u0647 \u0644\u0644\u062c\u0645\u064a\u0639. \u0627\u0644\u0635\u0648\u062a \u0628\u064a\u062a\u0634\u063a\u0651\u0644 \u0645\u0628\u0627\u0634\u0631\u0629 \u0645\u0646 \u0633\u064a\u0631\u0641\u0631\u0627\u062a\u0647\u0645\u060c \u0648\u0645\u0634 \u0628\u0646\u062d\u0645\u0651\u0644 \u062d\u0627\u062c\u0629 \u0639\u0644\u0649 \u062c\u0647\u0627\u0632\u0643.\n\n\u0627\u0644\u0627\u0633\u062a\u0645\u0627\u0639 \u0628\u064a\u0633\u062a\u0647\u0644\u0643 \u0646\u062a: \u0627\u0644\u0633\u0648\u0631\u0629 \u0627\u0644\u0642\u0635\u064a\u0631\u0629 \u0634\u0648\u064a\u0629 \u0643\u064a\u0644\u0648\u0628\u0627\u064a\u062a\u0627\u062a \u0648\u0627\u0644\u0637\u0648\u064a\u0644\u0629 (\u0632\u064a \u0627\u0644\u0628\u0642\u0631\u0629) \u0645\u0645\u0643\u0646 \u062a\u0648\u0635\u0644 \u0644\u0640 \u0665\u0660 \u0645\u064a\u062c\u0627 \u0623\u0648 \u0623\u0643\u062a\u0631.",null,null,null,null,null,null,null,null,null,null)
D.bxd=new B.m("\u0627\u0628\u062f\u0623 \u0645\u0646 \u0627\u0644\u0623\u0648\u0644",null,C.mc,null,null,null,null,null,null,null,null)
D.byc=new B.m("\u0627\u0644\u062a\u0644\u0627\u0648\u0627\u062a \u0645\u0646 mp3quran.net",null,H.ur,null,null,null,null,null,null,null,null)
D.byH=new B.m("\u0633\u0648\u0631 \u0627\u0644\u0645\u0635\u062d\u0641 \u062f\u0647",null,C.eS,null,null,null,null,null,null,null,null)
D.bzs=new B.m("\u0622\u062e\u0631 \u0627\u0633\u062a\u0645\u0627\u0639",null,F.aO,null,null,null,null,null,null,null,null)
D.bAo=new B.m("\u0627\u0633\u062a\u0645\u0627\u0639 \u0627\u0644\u0642\u0631\u0622\u0646",null,null,null,null,null,null,null,null,null,null)
D.a4R=new A.ap3(null)})();(function staticFields(){$.wB=null
$.wC=!1
$.wA=B.aT(y.S)
$.tt=B.C(y.N,B.ae("a3"))
$.cbs=null
$.Ro=1
$.HF=D.tC
$.ciP=null
$.cbq=null
$.acO=!1
$.HE=null
$.cbr=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cTf","cfe",()=>B.cmc(new A.c2R(),B.ae("U")))
x($,"cQ5","c9t",()=>B.y2(0))
x($,"cQ4","vb",()=>{var w=new A.Rm(D.oB,B.caw(0,!1),B.caw(0,!1),$.Y()),v=B.cm8(w.gaVH())
w.a!==$&&B.bv()
w.a=v
return w})})()};
(a=>{a["zn05pULQCTPfaGMRr0E29SaKbuc="]=a.current})($__dart_deferred_initializers__);