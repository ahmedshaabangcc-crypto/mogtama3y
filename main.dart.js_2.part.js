((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aXk(){var x=$.cdN
return x==null?$.cdN=new B.aXl().$0():x},
cDi(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kb(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.cc(D.cW[w].a[1],"",!1,x)
v=new A.dN("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=C.c.hG(s,"\r")?C.c.a7(s,0,s.length-1):s
if(r.length===0)continue
if(C.c.bz(r,"#")){v.a+=r+"\n"
continue}q=C.c.fF(r,"|")
p=q<0?-1:C.c.jX(r,"|",q+1)
if(p<0)continue
o=A.dX(C.c.a7(r,0,q),null)
n=A.dX(C.c.a7(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=C.c.cc(r,p+1)}x=v.a
return new B.oW(m,C.c.M_(x.charCodeAt(0)==0?x:x))},
NA(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.Ms(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fj(x,0,A.iq(4,"count",y.C),w).aq(0," ")
if(B.c9a(v)===$.cv9())return new A.Ms(v,A.fj(x,4,null,w).aq(0," "))}return new A.Ms(null,f)},
c9a(d){var x,w,v,u=new A.dN("")
for(x=new A.Js(d);x.v();){w=x.d
v=!0
if(!(w>=1611&&w<=1631))if(w!==1648)v=w>=1750&&w<=1773||w===1600
if(v)continue
A:{if(1570===w||1571===w||1573===w||1649===w){v=A.eR(1575)
u.a+=v
break A}if(1577===w){v=A.eR(1607)
u.a+=v
break A}if(1609===w){v=A.eR(1610)
u.a+=v
break A}v=A.eR(w)
u.a+=v}}x=u.a
return C.c.K(x.charCodeAt(0)==0?x:x).toLowerCase()},
csw(d){var x,w,v,u,t,s,r={},q=B.c9a(B.cM_(d))
r.a=q
r.a=C.c.K(C.c.fL(q,A.aC("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dX(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rX
x=r.a
u=A.aC("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.a9(new A.ah(w,new B.cak(r,A.bD(x,u,"")),s),s.i("Y.E"))
return x},
cM_(d){return A.vd(d,A.aC("[\u0660-\u0669]",!0,!1,!1),new B.c6W(),null)},
oW:function oW(d,e){this.a=d
this.b=e},
aXl:function aXl(){},
cak:function cak(d,e){this.a=d
this.b=e},
c6W:function c6W(){},
cdM(){var x=$.cm0
return x==null?$.cm0=new B.aXh().$0():x},
kx(d){return"\u0633\u0648\u0631\u0629 "+D.cW[d-1].a[0]},
aXh:function aXh(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[35]
F=c[14]
D=c[27]
B.oW.prototype={
yh(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["al<oW>()"])
B.aXl.prototype={
$0(){var x=0,w=A.j(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.vj().iC("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.aBw(J.fD(J.cbM(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cDi(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.cdN=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:z+0}
B.cak.prototype={
$1(d){var x=d-1,w=B.c9a(D.cW[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fL(w,A.aC("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cW[x].a[3]
v=A.aC("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bD(x.toLowerCase(),v,""),this.b)},
$S:74}
B.c6W.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:57}
B.aXh.prototype={
$0(){var x=0,w=A.j(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.abu("AmiriQuranMT",A.a([],y.p))
r.apb($.vj().iC("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vV(),$async$$0)
case 7:$.cm1=!0
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
$S:240};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.oW,A.a7)
w(A.lm,[B.aXl,B.aXh])
w(A.iP,[B.cak,B.c6W])})()
var y={p:A.ag("H<al<l2>>"),x:A.ag("H<o>"),r:A.ag("H<x>"),B:A.ag("a6<o>"),u:A.ag("oW"),w:A.ag("o"),a:A.ag("ah<x>"),e:A.ag("M"),C:A.ag("x")};(function constants(){E.BT=new A.eT(" ",null,null,C.bv,null,null,null,null,null,null,null)})();(function staticFields(){$.cdN=null
$.cm0=null
$.cm1=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cV3","cv9",()=>B.c9a("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["uZXTOu+PzhZnEmjP/19aB78NDXQ="]=a.current})($__dart_deferred_initializers__);