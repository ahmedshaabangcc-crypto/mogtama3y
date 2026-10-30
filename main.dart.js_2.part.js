((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aWX(){var x=$.cbW
return x==null?$.cbW=new B.aWY().$0():x},
cBo(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.k8(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.c8(D.cW[w].a[1],"",!1,x)
v=new A.dL("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=C.c.hG(s,"\r")?C.c.a7(s,0,s.length-1):s
if(r.length===0)continue
if(C.c.bz(r,"#")){v.a+=r+"\n"
continue}q=C.c.fF(r,"|")
p=q<0?-1:C.c.jX(r,"|",q+1)
if(p<0)continue
o=A.dW(C.c.a7(r,0,q),null)
n=A.dW(C.c.a7(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=C.c.cc(r,p+1)}x=v.a
return new B.oT(m,C.c.LN(x.charCodeAt(0)==0?x:x))},
Nm(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.Me(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.ff(x,0,A.ip(4,"count",y.C),w).aB(0," ")
if(B.c7i(v)===$.cth())return new A.Me(v,A.ff(x,4,null,w).aB(0," "))}return new A.Me(null,f)},
c7i(d){var x,w,v,u=new A.dL("")
for(x=new A.Jg(d);x.v();){w=x.d
v=!0
if(!(w>=1611&&w<=1631))if(w!==1648)v=w>=1750&&w<=1773||w===1600
if(v)continue
A:{if(1570===w||1571===w||1573===w||1649===w){v=A.eN(1575)
u.a+=v
break A}if(1577===w){v=A.eN(1607)
u.a+=v
break A}if(1609===w){v=A.eN(1610)
u.a+=v
break A}v=A.eN(w)
u.a+=v}}x=u.a
return C.c.O(x.charCodeAt(0)==0?x:x).toLowerCase()},
cqE(d){var x,w,v,u,t,s,r={},q=B.c7i(B.cK6(d))
r.a=q
r.a=C.c.O(C.c.fS(q,A.aE("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dW(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rK
x=r.a
u=A.aE("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.a9(new A.ah(w,new B.c8s(r,A.bJ(x,u,"")),s),s.i("X.E"))
return x},
cK6(d){return A.v7(d,A.aE("[\u0660-\u0669]",!0,!1,!1),new B.c56(),null)},
oT:function oT(d,e){this.a=d
this.b=e},
aWY:function aWY(){},
c8s:function c8s(d,e){this.a=d
this.b=e},
c56:function c56(){},
cbV(){var x=$.ck9
return x==null?$.ck9=new B.aWU().$0():x},
ku(d){return"\u0633\u0648\u0631\u0629 "+D.cW[d-1].a[0]},
aWU:function aWU(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[35]
F=c[14]
D=c[27]
B.oT.prototype={
yd(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["al<oT>()"])
B.aWY.prototype={
$0(){var x=0,w=A.k(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.vd().iC("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.aBb(J.fA(J.c9U(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cBo(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.cbW=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:z+0}
B.c8s.prototype={
$1(d){var x=d-1,w=B.c7i(D.cW[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fS(w,A.aE("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cW[x].a[3]
v=A.aE("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bJ(x.toLowerCase(),v,""),this.b)},
$S:73}
B.c56.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:58}
B.aWU.prototype={
$0(){var x=0,w=A.k(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.abb("AmiriQuranMT",A.a([],y.p))
r.aoO($.vd().iC("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vT(),$async$$0)
case 7:$.cka=!0
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
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:200};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.oT,A.a6)
w(A.lj,[B.aWY,B.aWU])
w(A.iN,[B.c8s,B.c56])})()
var y={p:A.ae("H<al<l_>>"),x:A.ae("H<o>"),r:A.ae("H<x>"),B:A.ae("a7<o>"),u:A.ae("oT"),w:A.ae("o"),a:A.ae("ah<x>"),e:A.ae("M"),C:A.ae("x")};(function constants(){E.BE=new A.eP(" ",null,null,C.bu,null,null,null,null,null,null,null)})();(function staticFields(){$.cbW=null
$.ck9=null
$.cka=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cTa","cth",()=>B.c7i("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["zEbkxJEkAc1IbfyjHK2oZBELd6Q="]=a.current})($__dart_deferred_initializers__);