((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aVz(){var x=$.c9Q
return x==null?$.c9Q=new B.aVA().$0():x},
cz9(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kC(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.co(D.cS[w].a[1],"",!1,x)
v=new A.dJ("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=C.c.hC(s,"\r")?C.c.a7(s,0,s.length-1):s
if(r.length===0)continue
if(C.c.bx(r,"#")){v.a+=r+"\n"
continue}q=C.c.fE(r,"|")
p=q<0?-1:C.c.jU(r,"|",q+1)
if(p<0)continue
o=A.dU(C.c.a7(r,0,q),null)
n=A.dU(C.c.a7(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=C.c.ca(r,p+1)}x=v.a
return new B.oM(m,C.c.LC(x.charCodeAt(0)==0?x:x))},
MQ(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.LJ(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fw(x,0,A.ii(4,"count",y.C),w).aC(0," ")
if(B.c5h(v)===$.cr6())return new A.LJ(v,A.fw(x,4,null,w).aC(0," "))}return new A.LJ(null,f)},
c5h(d){var x,w,v,u=new A.dJ("")
for(x=new A.IO(d);x.v();){w=x.d
v=!0
if(!(w>=1611&&w<=1631))if(w!==1648)v=w>=1750&&w<=1773||w===1600
if(v)continue
A:{if(1570===w||1571===w||1573===w||1649===w){v=A.eK(1575)
u.a+=v
break A}if(1577===w){v=A.eK(1607)
u.a+=v
break A}if(1609===w){v=A.eK(1610)
u.a+=v
break A}v=A.eK(w)
u.a+=v}}x=u.a
return C.c.N(x.charCodeAt(0)==0?x:x).toLowerCase()},
cou(d){var x,w,v,u,t,s,r={},q=B.c5h(B.cHP(d))
r.a=q
r.a=C.c.N(C.c.fR(q,A.aD("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dU(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rx
x=r.a
u=A.aD("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.a9(new A.ag(w,new B.c6r(r,A.bF(x,u,"")),s),s.i("Z.E"))
return x},
cHP(d){return A.uW(d,A.aD("[\u0660-\u0669]",!0,!1,!1),new B.c3k(),null)},
oM:function oM(d,e){this.a=d
this.b=e},
aVA:function aVA(){},
c6r:function c6r(d,e){this.a=d
this.b=e},
c3k:function c3k(){},
c9P(){var x=$.ci3
return x==null?$.ci3=new B.aVw().$0():x},
kl(d){return"\u0633\u0648\u0631\u0629 "+D.cS[d-1].a[0]},
aVw:function aVw(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[35]
F=c[14]
D=c[27]
B.oM.prototype={
y6(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["ak<oM>()"])
B.aVA.prototype={
$0(){var x=0,w=A.k(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.v1().iy("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.aAb(J.fB(J.c7T(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cz9(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c9Q=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:z+0}
B.c6r.prototype={
$1(d){var x=d-1,w=B.c5h(D.cS[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fR(w,A.aD("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cS[x].a[3]
v=A.aD("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bF(x.toLowerCase(),v,""),this.b)},
$S:75}
B.c3k.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:58}
B.aVw.prototype={
$0(){var x=0,w=A.k(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.aai("AmiriQuranMT",A.a([],y.p))
r.aoe($.v1().iy("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vO(),$async$$0)
case 7:$.ci4=!0
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
$S:220};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.oM,A.a4)
w(A.ld,[B.aVA,B.aVw])
w(A.iF,[B.c6r,B.c3k])})()
var y={p:A.ae("H<ak<kS>>"),x:A.ae("H<o>"),r:A.ae("H<x>"),B:A.ae("a7<o>"),u:A.ae("oM"),w:A.ae("o"),a:A.ae("ag<x>"),e:A.ae("O"),C:A.ae("x")};(function constants(){E.Bs=new A.eM(" ",null,null,C.bt,null,null,null,null,null,null,null)})();(function staticFields(){$.c9Q=null
$.ci3=null
$.ci4=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cQR","cr6",()=>B.c5h("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["mzbl+wQGYpUnn7bWxPLLtAT5zIs="]=a.current})($__dart_deferred_initializers__);