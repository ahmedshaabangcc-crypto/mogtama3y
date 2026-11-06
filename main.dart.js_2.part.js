((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aXe(){var x=$.cdm
return x==null?$.cdm=new B.aXf().$0():x},
cCS(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kb(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.cb(D.cW[w].a[1],"",!1,x)
v=new A.dM("")
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
return new B.oV(m,C.c.LX(x.charCodeAt(0)==0?x:x))},
Nx(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.Mp(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fj(x,0,A.iq(4,"count",y.C),w).au(0," ")
if(B.c8K(v)===$.cuJ())return new A.Mp(v,A.fj(x,4,null,w).au(0," "))}return new A.Mp(null,f)},
c8K(d){var x,w,v,u=new A.dM("")
for(x=new A.Jq(d);x.v();){w=x.d
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
return C.c.N(x.charCodeAt(0)==0?x:x).toLowerCase()},
cs5(d){var x,w,v,u,t,s,r={},q=B.c8K(B.cLz(d))
r.a=q
r.a=C.c.N(C.c.fS(q,A.aD("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dX(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rU
x=r.a
u=A.aD("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.a9(new A.ai(w,new B.c9U(r,A.bF(x,u,"")),s),s.i("Y.E"))
return x},
cLz(d){return A.vc(d,A.aD("[\u0660-\u0669]",!0,!1,!1),new B.c6w(),null)},
oV:function oV(d,e){this.a=d
this.b=e},
aXf:function aXf(){},
c9U:function c9U(d,e){this.a=d
this.b=e},
c6w:function c6w(){},
cdl(){var x=$.clA
return x==null?$.clA=new B.aXb().$0():x},
kx(d){return"\u0633\u0648\u0631\u0629 "+D.cW[d-1].a[0]},
aXb:function aXb(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[35]
F=c[14]
D=c[27]
B.oV.prototype={
yh(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["al<oV>()"])
B.aXf.prototype={
$0(){var x=0,w=A.j(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.vi().iC("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.aBs(J.fC(J.cbl(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cCS(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.cdm=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:z+0}
B.c9U.prototype={
$1(d){var x=d-1,w=B.c8K(D.cW[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fS(w,A.aD("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cW[x].a[3]
v=A.aD("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bF(x.toLowerCase(),v,""),this.b)},
$S:72}
B.c6w.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:57}
B.aXb.prototype={
$0(){var x=0,w=A.j(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.abr("AmiriQuranMT",A.a([],y.p))
r.ap4($.vi().iC("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vV(),$async$$0)
case 7:$.clB=!0
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
x(B.oV,A.a7)
w(A.lm,[B.aXf,B.aXb])
w(A.iP,[B.c9U,B.c6w])})()
var y={p:A.af("H<al<l2>>"),x:A.af("H<o>"),r:A.af("H<x>"),B:A.af("a6<o>"),u:A.af("oV"),w:A.af("o"),a:A.af("ai<x>"),e:A.af("M"),C:A.af("x")};(function constants(){E.BR=new A.eT(" ",null,null,C.bv,null,null,null,null,null,null,null)})();(function staticFields(){$.cdm=null
$.clA=null
$.clB=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cUD","cuJ",()=>B.c8K("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["8IKK3zQ9mADe57Ng9stWnPblg6c="]=a.current})($__dart_deferred_initializers__);