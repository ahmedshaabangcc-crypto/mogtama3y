((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aUn(){var x=$.c6o
return x==null?$.c6o=new B.aUo().$0():x},
cvo(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kB(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.cl(D.cN[w].a[1],"",!1,x)
v=new A.dI("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=C.c.hB(s,"\r")?C.c.a7(s,0,s.length-1):s
if(r.length===0)continue
if(C.c.bz(r,"#")){v.a+=r+"\n"
continue}q=C.c.h2(r,"|")
p=q<0?-1:C.c.jT(r,"|",q+1)
if(p<0)continue
o=A.dR(C.c.a7(r,0,q),null)
n=A.dR(C.c.a7(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=C.c.cb(r,p+1)}x=v.a
return new B.oE(m,C.c.Lj(x.charCodeAt(0)==0?x:x))},
Mw(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.Lq(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fS(x,0,A.iV(4,"count",y.C),w).aE(0," ")
if(B.c2b(v)===$.cnA())return new A.Lq(v,A.fS(x,4,null,w).aE(0," "))}return new A.Lq(null,f)},
c2b(d){var x,w,v,u=new A.dI("")
for(x=new A.It(d);x.v();){w=x.d
v=!0
if(!(w>=1611&&w<=1631))if(w!==1648)v=w>=1750&&w<=1773||w===1600
if(v)continue
A:{if(1570===w||1571===w||1573===w||1649===w){v=A.eI(1575)
u.a+=v
break A}if(1577===w){v=A.eI(1607)
u.a+=v
break A}if(1609===w){v=A.eI(1610)
u.a+=v
break A}v=A.eI(w)
u.a+=v}}x=u.a
return C.c.P(x.charCodeAt(0)==0?x:x).toLowerCase()},
ckX(d){var x,w,v,u,t,s,r={},q=B.c2b(B.cE_(d))
r.a=q
r.a=C.c.P(C.c.fQ(q,A.aF("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dR(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rl
x=r.a
u=A.aF("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.aa(new A.aj(w,new B.c34(r,A.bK(x,u,"")),s),s.i("Z.E"))
return x},
cE_(d){return A.uR(d,A.aF("[\u0660-\u0669]",!0,!1,!1),new B.c0k(),null)},
oE:function oE(d,e){this.a=d
this.b=e},
aUo:function aUo(){},
c34:function c34(d,e){this.a=d
this.b=e},
c0k:function c0k(){},
c6n(){var x=$.ceA
return x==null?$.ceA=new B.aUk().$0():x},
kl(d){return"\u0633\u0648\u0631\u0629 "+D.cN[d-1].a[0]},
aUk:function aUk(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[35]
F=c[14]
D=c[27]
B.oE.prototype={
xT(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["ak<oE>()"])
B.aUo.prototype={
$0(){var x=0,w=A.j(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.uX().iy("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.azr(J.fy(J.c4r(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cvo(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c6o=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:z+0}
B.c34.prototype={
$1(d){var x=d-1,w=B.c2b(D.cN[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fQ(w,A.aF("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cN[x].a[3]
v=A.aF("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bK(x.toLowerCase(),v,""),this.b)},
$S:76}
B.c0k.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:56}
B.aUk.prototype={
$0(){var x=0,w=A.j(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.a9F("AmiriQuranMT",A.a([],y.p))
r.any($.uX().iy("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vH(),$async$$0)
case 7:$.ceB=!0
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
$S:204};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.oE,A.a4)
w(A.lb,[B.aUo,B.aUk])
w(A.iC,[B.c34,B.c0k])})()
var y={p:A.ae("G<ak<kQ>>"),x:A.ae("G<o>"),r:A.ae("G<x>"),B:A.ae("a7<o>"),u:A.ae("oE"),w:A.ae("o"),a:A.ae("aj<x>"),e:A.ae("N"),C:A.ae("x")};(function constants(){E.AW=new A.f3(" ",null,null,C.by,null,null,null,null,null,null,null)})();(function staticFields(){$.c6o=null
$.ceA=null
$.ceB=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cMW","cnA",()=>B.c2b("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["EvZoRDua2io5iPS8beLiEpmWnEY="]=a.current})($__dart_deferred_initializers__);