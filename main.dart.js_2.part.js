((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aSU(){var x=$.c3x
return x==null?$.c3x=new B.aSV().$0():x},
cs1(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kk(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.ck(D.cL[w].a[1],"",!1,x)
v=new A.dH("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=C.c.hr(s,"\r")?C.c.a7(s,0,s.length-1):s
if(r.length===0)continue
if(C.c.bs(r,"#")){v.a+=r+"\n"
continue}q=C.c.fn(r,"|")
p=q<0?-1:C.c.jE(r,"|",q+1)
if(p<0)continue
o=A.dR(C.c.a7(r,0,q),null)
n=A.dR(C.c.a7(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=C.c.cm(r,p+1)}x=v.a
return new B.om(m,C.c.KR(x.charCodeAt(0)==0?x:x))},
LI(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.KE(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fL(x,0,A.iJ(4,"count",y.C),w).aE(0," ")
if(B.c_m(v)===$.ckf())return new A.KE(v,A.fL(x,4,null,w).aE(0," "))}return new A.KE(null,f)},
c_m(d){var x,w,v,u=new A.dH("")
for(x=new A.Sn(d);x.v();){w=x.d
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
chG(d){var x,w,v,u,t,s,r={},q=B.c_m(B.cAA(d))
r.a=q
r.a=C.c.O(C.c.fU(q,A.aB("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dR(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.rc
x=r.a
u=A.aB("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.aa(new A.am(w,new B.c0b(r,A.bB(x,u,"")),s),s.i("Y.E"))
return x},
cAA(d){return A.ux(d,A.aB("[\u0660-\u0669]",!0,!1,!1),new B.bYC(),null)},
om:function om(d,e){this.a=d
this.b=e},
aSV:function aSV(){},
c0b:function c0b(d,e){this.a=d
this.b=e},
bYC:function bYC(){},
c3w(){var x=$.cbC
return x==null?$.cbC=new B.aSR().$0():x},
k7(d){return"\u0633\u0648\u0631\u0629 "+D.cL[d-1].a[0]},
aSR:function aSR(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[36]
F=c[14]
D=c[28]
B.om.prototype={
xD(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["aj<om>()"])
B.aSV.prototype={
$0(){var x=0,w=A.k(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.uA().ik("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.aya(J.fn(J.c1y(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cs1(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c3x=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:z+0}
B.c0b.prototype={
$1(d){var x=d-1,w=B.c_m(D.cL[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fU(w,A.aB("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cL[x].a[3]
v=A.aB("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bB(x.toLowerCase(),v,""),this.b)},
$S:72}
B.bYC.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:54}
B.aSR.prototype={
$0(){var x=0,w=A.k(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.a8w("AmiriQuranMT",A.a([],y.p))
r.amd($.uA().ik("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vp(),$async$$0)
case 7:$.cbD=!0
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
$S:197};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.om,A.a5)
w(A.kW,[B.aSV,B.aSR])
w(A.ir,[B.c0b,B.bYC])})()
var y={p:A.ae("F<aj<kx>>"),x:A.ae("F<o>"),r:A.ae("F<x>"),B:A.ae("a7<o>"),u:A.ae("om"),w:A.ae("o"),a:A.ae("am<x>"),e:A.ae("P"),C:A.ae("x")};(function constants(){E.Av=new A.eX(" ",null,null,C.bx,null,null,null,null,null,null,null)})();(function staticFields(){$.c3x=null
$.cbC=null
$.cbD=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cJg","ckf",()=>B.c_m("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["RKDL3JqtHgmpd6cK2PIVrABJdac="]=a.current})($__dart_deferred_initializers__);