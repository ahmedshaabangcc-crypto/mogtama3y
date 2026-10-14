((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aUf(){var x=$.c5X
return x==null?$.c5X=new B.aUg().$0():x},
cuT(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kx(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.cl(D.cN[w].a[1],"",!1,x)
v=new A.dG("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=C.c.hC(s,"\r")?C.c.a7(s,0,s.length-1):s
if(r.length===0)continue
if(C.c.bz(r,"#")){v.a+=r+"\n"
continue}q=C.c.ha(r,"|")
p=q<0?-1:C.c.jR(r,"|",q+1)
if(p<0)continue
o=A.dP(C.c.a7(r,0,q),null)
n=A.dP(C.c.a7(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=C.c.cf(r,p+1)}x=v.a
return new B.oC(m,C.c.Lh(x.charCodeAt(0)==0?x:x))},
Ms(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.Lm(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fR(x,0,A.iS(4,"count",y.C),w).aE(0," ")
if(B.c1L(v)===$.cn4())return new A.Lm(v,A.fR(x,4,null,w).aE(0," "))}return new A.Lm(null,f)},
c1L(d){var x,w,v,u=new A.dG("")
for(x=new A.Ip(d);x.v();){w=x.d
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
ckq(d){var x,w,v,u,t,s,r={},q=B.c1L(B.cDt(d))
r.a=q
r.a=C.c.P(C.c.fQ(q,A.aF("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dP(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rk
x=r.a
u=A.aF("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.aa(new A.aj(w,new B.c2D(r,A.bK(x,u,"")),s),s.i("Z.E"))
return x},
cDt(d){return A.uP(d,A.aF("[\u0660-\u0669]",!0,!1,!1),new B.c_U(),null)},
oC:function oC(d,e){this.a=d
this.b=e},
aUg:function aUg(){},
c2D:function c2D(d,e){this.a=d
this.b=e},
c_U:function c_U(){},
c5W(){var x=$.ce7
return x==null?$.ce7=new B.aUc().$0():x},
ki(d){return"\u0633\u0648\u0631\u0629 "+D.cN[d-1].a[0]},
aUc:function aUc(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[35]
F=c[14]
D=c[27]
B.oC.prototype={
xS(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["ak<oC>()"])
B.aUg.prototype={
$0(){var x=0,w=A.j(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.uV().iy("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.azl(J.fy(J.c4_(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cuT(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c5X=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:z+0}
B.c2D.prototype={
$1(d){var x=d-1,w=B.c1L(D.cN[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fQ(w,A.aF("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cN[x].a[3]
v=A.aF("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bK(x.toLowerCase(),v,""),this.b)},
$S:78}
B.c_U.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:55}
B.aUc.prototype={
$0(){var x=0,w=A.j(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.a9A("AmiriQuranMT",A.a([],y.p))
r.anx($.uV().iy("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vH(),$async$$0)
case 7:$.ce8=!0
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
x(B.oC,A.a4)
w(A.l7,[B.aUg,B.aUc])
w(A.iA,[B.c2D,B.c_U])})()
var y={p:A.ae("E<ak<kL>>"),x:A.ae("E<o>"),r:A.ae("E<x>"),B:A.ae("a7<o>"),u:A.ae("oC"),w:A.ae("o"),a:A.ae("aj<x>"),e:A.ae("N"),C:A.ae("x")};(function constants(){E.AV=new A.f3(" ",null,null,C.by,null,null,null,null,null,null,null)})();(function staticFields(){$.c5X=null
$.ce7=null
$.ce8=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cMn","cn4",()=>B.c1L("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["gAGUTlHXr2+/dY/y9HrZWqLp6h0="]=a.current})($__dart_deferred_initializers__);