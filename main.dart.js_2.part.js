((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aT1(){var x=$.c3Y
return x==null?$.c3Y=new B.aT2().$0():x},
csx(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kl(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.ck(D.cN[w].a[1],"",!1,x)
v=new A.dH("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=C.c.hr(s,"\r")?C.c.a7(s,0,s.length-1):s
if(r.length===0)continue
if(C.c.bs(r,"#")){v.a+=r+"\n"
continue}q=C.c.fn(r,"|")
p=q<0?-1:C.c.jE(r,"|",q+1)
if(p<0)continue
o=A.dN(C.c.a7(r,0,q),null)
n=A.dN(C.c.a7(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=C.c.cm(r,p+1)}x=v.a
return new B.on(m,C.c.KR(x.charCodeAt(0)==0?x:x))},
LK(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.KG(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fL(x,0,A.iK(4,"count",y.C),w).aE(0," ")
if(B.c_L(v)===$.ckK())return new A.KG(v,A.fL(x,4,null,w).aE(0," "))}return new A.KG(null,f)},
c_L(d){var x,w,v,u=new A.dH("")
for(x=new A.Sq(d);x.v();){w=x.d
v=!0
if(!(w>=1611&&w<=1631))if(w!==1648)v=w>=1750&&w<=1773||w===1600
if(v)continue
A:{if(1570===w||1571===w||1573===w||1649===w){v=A.eW(1575)
u.a+=v
break A}if(1577===w){v=A.eW(1607)
u.a+=v
break A}if(1609===w){v=A.eW(1610)
u.a+=v
break A}v=A.eW(w)
u.a+=v}}x=u.a
return C.c.O(x.charCodeAt(0)==0?x:x).toLowerCase()},
ci9(d){var x,w,v,u,t,s,r={},q=B.c_L(B.cB6(d))
r.a=q
r.a=C.c.O(C.c.fU(q,A.ax("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dN(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rd
x=r.a
u=A.ax("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.aa(new A.am(w,new B.c0C(r,A.bB(x,u,"")),s),s.i("Z.E"))
return x},
cB6(d){return A.uy(d,A.ax("[\u0660-\u0669]",!0,!1,!1),new B.bYX(),null)},
on:function on(d,e){this.a=d
this.b=e},
aT2:function aT2(){},
c0C:function c0C(d,e){this.a=d
this.b=e},
bYX:function bYX(){},
c3X(){var x=$.cc5
return x==null?$.cc5=new B.aSZ().$0():x},
k8(d){return"\u0633\u0648\u0631\u0629 "+D.cN[d-1].a[0]},
aSZ:function aSZ(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[36]
F=c[14]
D=c[28]
B.on.prototype={
xD(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["aj<on>()"])
B.aT2.prototype={
$0(){var x=0,w=A.j(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.uB().ik("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.ayf(J.fn(J.c1Z(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.csx(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c3Y=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:z+0}
B.c0C.prototype={
$1(d){var x=d-1,w=B.c_L(D.cN[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fU(w,A.ax("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cN[x].a[3]
v=A.ax("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bB(x.toLowerCase(),v,""),this.b)},
$S:75}
B.bYX.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:54}
B.aSZ.prototype={
$0(){var x=0,w=A.j(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.a8A("AmiriQuranMT",A.a([],y.p))
r.amk($.uB().ik("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vp(),$async$$0)
case 7:$.cc6=!0
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
$S:228};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.on,A.a5)
w(A.kY,[B.aT2,B.aSZ])
w(A.is,[B.c0C,B.bYX])})()
var y={p:A.ae("F<aj<kz>>"),x:A.ae("F<o>"),r:A.ae("F<x>"),B:A.ae("a7<o>"),u:A.ae("on"),w:A.ae("o"),a:A.ae("am<x>"),e:A.ae("O"),C:A.ae("x")};(function constants(){E.AC=new A.eX(" ",null,null,C.bx,null,null,null,null,null,null,null)})();(function staticFields(){$.c3Y=null
$.cc5=null
$.cc6=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cJT","ckK",()=>B.c_L("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["d8FvKwZPxkq9ACF1fDoGic+Tz64="]=a.current})($__dart_deferred_initializers__);