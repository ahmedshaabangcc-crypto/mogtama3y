((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aUe(){var x=$.c5V
return x==null?$.c5V=new B.aUf().$0():x},
cuQ(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kt(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.cl(D.cN[w].a[1],"",!1,x)
v=new A.dF("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=C.c.hC(s,"\r")?C.c.a7(s,0,s.length-1):s
if(r.length===0)continue
if(C.c.bz(r,"#")){v.a+=r+"\n"
continue}q=C.c.ha(r,"|")
p=q<0?-1:C.c.jQ(r,"|",q+1)
if(p<0)continue
o=A.dO(C.c.a7(r,0,q),null)
n=A.dO(C.c.a7(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=C.c.cf(r,p+1)}x=v.a
return new B.ox(m,C.c.Lh(x.charCodeAt(0)==0?x:x))},
Mq(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.Lk(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fN(x,0,A.iO(4,"count",y.C),w).aE(0," ")
if(B.c1J(v)===$.cn1())return new A.Lk(v,A.fN(x,4,null,w).aE(0," "))}return new A.Lk(null,f)},
c1J(d){var x,w,v,u=new A.dF("")
for(x=new A.In(d);x.v();){w=x.d
v=!0
if(!(w>=1611&&w<=1631))if(w!==1648)v=w>=1750&&w<=1773||w===1600
if(v)continue
A:{if(1570===w||1571===w||1573===w||1649===w){v=A.eF(1575)
u.a+=v
break A}if(1577===w){v=A.eF(1607)
u.a+=v
break A}if(1609===w){v=A.eF(1610)
u.a+=v
break A}v=A.eF(w)
u.a+=v}}x=u.a
return C.c.P(x.charCodeAt(0)==0?x:x).toLowerCase()},
ckn(d){var x,w,v,u,t,s,r={},q=B.c1J(B.cDp(d))
r.a=q
r.a=C.c.P(C.c.h2(q,A.aF("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dO(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rk
x=r.a
u=A.aF("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.aa(new A.aj(w,new B.c2B(r,A.bJ(x,u,"")),s),s.i("Z.E"))
return x},
cDp(d){return A.uM(d,A.aF("[\u0660-\u0669]",!0,!1,!1),new B.c_S(),null)},
ox:function ox(d,e){this.a=d
this.b=e},
aUf:function aUf(){},
c2B:function c2B(d,e){this.a=d
this.b=e},
c_S:function c_S(){},
c5U(){var x=$.ce5
return x==null?$.ce5=new B.aUb().$0():x},
ke(d){return"\u0633\u0648\u0631\u0629 "+D.cN[d-1].a[0]},
aUb:function aUb(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[35]
F=c[14]
D=c[27]
B.ox.prototype={
xS(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["ak<ox>()"])
B.aUf.prototype={
$0(){var x=0,w=A.j(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.uS().iy("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.azk(J.fu(J.c3Y(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cuQ(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c5V=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:z+0}
B.c2B.prototype={
$1(d){var x=d-1,w=B.c1J(D.cN[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.h2(w,A.aF("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cN[x].a[3]
v=A.aF("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bJ(x.toLowerCase(),v,""),this.b)},
$S:78}
B.c_S.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:55}
B.aUb.prototype={
$0(){var x=0,w=A.j(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.a9y("AmiriQuranMT",A.a([],y.p))
r.anv($.uS().iy("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vH(),$async$$0)
case 7:$.ce6=!0
v=!0
x=1
break
u=2
x=6
break
case 4:u=3
p=t.pop()
v=!1
x=1
break
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:158};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.ox,A.a4)
w(A.l3,[B.aUf,B.aUb])
w(A.iw,[B.c2B,B.c_S])})()
var y={p:A.ae("E<ak<kH>>"),x:A.ae("E<o>"),r:A.ae("E<x>"),B:A.ae("a7<o>"),u:A.ae("ox"),w:A.ae("o"),a:A.ae("aj<x>"),e:A.ae("N"),C:A.ae("x")};(function constants(){E.AV=new A.f0(" ",null,null,C.by,null,null,null,null,null,null,null)})();(function staticFields(){$.c5V=null
$.ce5=null
$.ce6=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cMj","cn1",()=>B.c1J("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["p88juOxCx/6PsbQPKwJagKoE1Bs="]=a.current})($__dart_deferred_initializers__);