((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aUK(){var x=$.c7R
return x==null?$.c7R=new B.aUL().$0():x},
cwX(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kB(114,y.B)
for(x=y.w,w=0;w<114;++w)m[w]=A.cn(D.cO[w].a[1],"",!1,x)
v=new A.dI("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=C.c.hB(s,"\r")?C.c.a7(s,0,s.length-1):s
if(r.length===0)continue
if(C.c.bx(r,"#")){v.a+=r+"\n"
continue}q=C.c.h2(r,"|")
p=q<0?-1:C.c.jT(r,"|",q+1)
if(p<0)continue
o=A.dT(C.c.a7(r,0,q),null)
n=A.dT(C.c.a7(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=C.c.ca(r,p+1)}x=v.a
return new B.oG(m,C.c.Lp(x.charCodeAt(0)==0?x:x))},
MA(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.Lu(null,f)
x=A.a(f.split(" "),y.x)
if(x.length>4){w=y.w
v=A.fu(x,0,A.ih(4,"count",y.C),w).aC(0," ")
if(B.c3v(v)===$.cp6())return new A.Lu(v,A.fu(x,4,null,w).aC(0," "))}return new A.Lu(null,f)},
c3v(d){var x,w,v,u=new A.dI("")
for(x=new A.Iy(d);x.v();){w=x.d
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
cmt(d){var x,w,v,u,t,s,r={},q=B.c3v(B.cFz(d))
r.a=q
r.a=C.c.O(C.c.fQ(q,A.aC("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.r
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dT(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):C.ro
x=r.a
u=A.aC("[\\s'\\-]",!0,!1,!1)
s=y.a
x=A.aa(new A.ak(w,new B.c4w(r,A.bD(x,u,"")),s),s.i("a_.E"))
return x},
cFz(d){return A.uS(d,A.aC("[\u0660-\u0669]",!0,!1,!1),new B.c1z(),null)},
oG:function oG(d,e){this.a=d
this.b=e},
aUL:function aUL(){},
c4w:function c4w(d,e){this.a=d
this.b=e},
c1z:function c1z(){},
c7Q(){var x=$.cg4
return x==null?$.cg4=new B.aUH().$0():x},
kl(d){return"\u0633\u0648\u0631\u0629 "+D.cO[d-1].a[0]},
aUH:function aUH(){}},E,F,D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[13],B)
E=c[35]
F=c[14]
D=c[27]
B.oG.prototype={
xW(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["ai<oG>()"])
B.aUL.prototype={
$0(){var x=0,w=A.j(y.u),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.uY().iz("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(F.azE(J.fA(J.c5V(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.cwX(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c7R=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.h(v,w)
case 2:return A.f(t.at(-1),w)}})
return A.i($async$$0,w)},
$S:z+0}
B.c4w.prototype={
$1(d){var x=d-1,w=B.c3v(D.cO[x].a[0]),v=this.a
if(C.c.n(w,v.a)||C.c.n(C.c.fQ(w,A.aC("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=D.cO[x].a[3]
v=A.aC("[\\s'\\-]",!0,!1,!1)
return C.c.n(A.bD(x.toLowerCase(),v,""),this.b)},
$S:79}
B.c1z.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:58}
B.aUH.prototype={
$0(){var x=0,w=A.j(y.e),v,u=2,t=[],s,r,q,p
var $async$$0=A.e(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.a9R("AmiriQuranMT",A.a([],y.p))
r.anK($.uY().iz("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vI(),$async$$0)
case 7:$.cg5=!0
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
$S:187};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.oG,A.a4)
w(A.lb,[B.aUL,B.aUH])
w(A.iE,[B.c4w,B.c1z])})()
var y={p:A.ae("H<ai<kQ>>"),x:A.ae("H<o>"),r:A.ae("H<x>"),B:A.ae("a7<o>"),u:A.ae("oG"),w:A.ae("o"),a:A.ae("ak<x>"),e:A.ae("N"),C:A.ae("x")};(function constants(){E.B6=new A.eL(" ",null,null,C.br,null,null,null,null,null,null,null)})();(function staticFields(){$.c7R=null
$.cg4=null
$.cg5=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cOy","cp6",()=>B.c3v("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["zTnkk+cPmOtJe2dREUTUPePknUo="]=a.current})($__dart_deferred_initializers__);