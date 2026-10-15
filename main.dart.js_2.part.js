((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aUD(){var x=$.c70
return x==null?$.c70=new B.aUE().$0():x},
cw6(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kB(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.cm(D.cN[w].a[1],"",!1,x)
v=new A.dI("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=C.c.hB(s,"\r")?C.c.a7(s,0,s.length-1):s
if(r.length===0)continue
if(C.c.bx(r,"#")){v.a+=r+"\n"
continue}q=C.c.h2(r,"|")
p=q<0?-1:C.c.jT(r,"|",q+1)
if(p<0)continue
o=A.dS(C.c.a7(r,0,q),null)
n=A.dS(C.c.a7(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=C.c.ca(r,p+1)}x=v.a
return new B.oG(m,C.c.Ll(x.charCodeAt(0)==0?x:x))},
My(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.Ls(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fF(x,0,A.iy(4,"count",y.C),w).aE(0," ")
if(B.c2I(v)===$.cog())return new A.Ls(v,A.fF(x,4,null,w).aE(0," "))}return new A.Ls(null,f)},
c2I(d){var x,w,v,u=new A.dI("")
for(x=new A.Iv(d);x.v();){w=x.d
v=!0
if(!(w>=1611&&w<=1631))if(w!==1648)v=w>=1750&&w<=1773||w===1600
if(v)continue
A:{if(1570===w||1571===w||1573===w||1649===w){v=A.eJ(1575)
u.a+=v
break A}if(1577===w){v=A.eJ(1607)
u.a+=v
break A}if(1609===w){v=A.eJ(1610)
u.a+=v
break A}v=A.eJ(w)
u.a+=v}}x=u.a
return C.c.O(x.charCodeAt(0)==0?x:x).toLowerCase()},
clD(d){var x,w,v,u,t,s,r={},q=B.c2I(B.cEJ(d))
r.a=q
r.a=C.c.O(C.c.fQ(q,A.aB("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dS(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rm
x=r.a
u=A.aB("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.aa(new A.ak(w,new B.c3G(r,A.bD(x,u,"")),s),s.i("Z.E"))
return x},
cEJ(d){return A.uS(d,A.aB("[\u0660-\u0669]",!0,!1,!1),new B.c0N(),null)},
oG:function oG(d,e){this.a=d
this.b=e},
aUE:function aUE(){},
c3G:function c3G(d,e){this.a=d
this.b=e},
c0N:function c0N(){},
c7_(){var x=$.cfe
return x==null?$.cfe=new B.aUA().$0():x},
kl(d){return"\u0633\u0648\u0631\u0629 "+D.cN[d-1].a[0]},
aUA:function aUA(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[35]
F=c[14]
D=c[27]
B.oG.prototype={
xU(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["aj<oG>()"])
B.aUE.prototype={
$0(){var x=0,w=A.j(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.uY().iz("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.azz(J.fy(J.c54(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cw6(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c70=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:z+0}
B.c3G.prototype={
$1(d){var x=d-1,w=B.c2I(D.cN[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fQ(w,A.aB("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cN[x].a[3]
v=A.aB("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bD(x.toLowerCase(),v,""),this.b)},
$S:79}
B.c0N.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:56}
B.aUA.prototype={
$0(){var x=0,w=A.j(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.a9M("AmiriQuranMT",A.a([],y.p))
r.anD($.uY().iz("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vH(),$async$$0)
case 7:$.cff=!0
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
$S:229};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.oG,A.a4)
w(A.lb,[B.aUE,B.aUA])
w(A.iE,[B.c3G,B.c0N])})()
var y={p:A.ae("H<aj<kQ>>"),x:A.ae("H<o>"),r:A.ae("H<x>"),B:A.ae("a7<o>"),u:A.ae("oG"),w:A.ae("o"),a:A.ae("ak<x>"),e:A.ae("N"),C:A.ae("x")};(function constants(){E.B_=new A.f4(" ",null,null,C.by,null,null,null,null,null,null,null)})();(function staticFields(){$.c70=null
$.cfe=null
$.cff=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cNI","cog",()=>B.c2I("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["baO/VNABRKq7Fi5f5guLxDxHKKU="]=a.current})($__dart_deferred_initializers__);