((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aVh(){var x=$.c99
return x==null?$.c99=new B.aVi().$0():x},
cyl(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kC(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.co(D.cQ[w].a[1],"",!1,x)
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
return new B.oL(m,C.c.Ly(x.charCodeAt(0)==0?x:x))},
ML(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.LE(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fw(x,0,A.ii(4,"count",y.C),w).aB(0," ")
if(B.c4A(v)===$.cqo())return new A.LE(v,A.fw(x,4,null,w).aB(0," "))}return new A.LE(null,f)},
c4A(d){var x,w,v,u=new A.dJ("")
for(x=new A.II(d);x.v();){w=x.d
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
return C.c.O(x.charCodeAt(0)==0?x:x).toLowerCase()},
cnM(d){var x,w,v,u,t,s,r={},q=B.c4A(B.cH_(d))
r.a=q
r.a=C.c.O(C.c.fR(q,A.aD("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dU(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rt
x=r.a
u=A.aD("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.a9(new A.ag(w,new B.c5K(r,A.bE(x,u,"")),s),s.i("Z.E"))
return x},
cH_(d){return A.uV(d,A.aD("[\u0660-\u0669]",!0,!1,!1),new B.c2D(),null)},
oL:function oL(d,e){this.a=d
this.b=e},
aVi:function aVi(){},
c5K:function c5K(d,e){this.a=d
this.b=e},
c2D:function c2D(){},
c98(){var x=$.chl
return x==null?$.chl=new B.aVe().$0():x},
kl(d){return"\u0633\u0648\u0631\u0629 "+D.cQ[d-1].a[0]},
aVe:function aVe(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[35]
F=c[14]
D=c[27]
B.oL.prototype={
y3(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["ak<oL>()"])
B.aVi.prototype={
$0(){var x=0,w=A.j(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.v0().iy("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.aA0(J.fB(J.c7c(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cyl(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c99=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:z+0}
B.c5K.prototype={
$1(d){var x=d-1,w=B.c4A(D.cQ[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fR(w,A.aD("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cQ[x].a[3]
v=A.aD("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bE(x.toLowerCase(),v,""),this.b)},
$S:74}
B.c2D.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:56}
B.aVe.prototype={
$0(){var x=0,w=A.j(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.aaa("AmiriQuranMT",A.a([],y.p))
r.ao9($.v0().iy("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vK(),$async$$0)
case 7:$.chm=!0
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
$S:220};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.oL,A.a4)
w(A.ld,[B.aVi,B.aVe])
w(A.iF,[B.c5K,B.c2D])})()
var y={p:A.ae("H<ak<kS>>"),x:A.ae("H<o>"),r:A.ae("H<x>"),B:A.ae("a7<o>"),u:A.ae("oL"),w:A.ae("o"),a:A.ae("ag<x>"),e:A.ae("O"),C:A.ae("x")};(function constants(){E.Bm=new A.eM(" ",null,null,C.bs,null,null,null,null,null,null,null)})();(function staticFields(){$.c99=null
$.chl=null
$.chm=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cQ1","cqo",()=>B.c4A("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["8qJ7IsJRcOLPjuQn/TbAIaBT8WQ="]=a.current})($__dart_deferred_initializers__);