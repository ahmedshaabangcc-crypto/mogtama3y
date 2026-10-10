((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,D,B={
cBP(d){var x,w,v,u,t=d.length
if(t<18||d[0]!==31||d[1]!==139||d[2]!==8)throw A.q(C.akl)
x=d[3]
w=(x&4)!==0?10+(2+((d[10]|d[11]<<8)>>>0)):10
if((x&8)!==0){for(;v=w+1,d[w]!==0;w=v);w=v}if((x&16)!==0){for(;v=w+1,d[w]!==0;w=v);w=v}if((x&2)!==0)w+=2
u=(d[t-4]|d[t-3]<<8|d[t-2]<<16|d[t-1]<<24)>>>0
t=u>0?u:65536
return new B.bo2(d,w,new Uint8Array(t)).at6()},
aoG(d,e,f,g){var x,w,v,u,t,s,r,q,p,o
for(x=d.a,w=x.$flags|0,v=0;v<16;++v){w&2&&A.aA(x)
x[v]=0}for(u=0;u<g;++u){t=e[f+u]
s=x[t]
w&2&&A.aA(x)
x[t]=s+1}r=A.ck(16,0,!1,y.S)
for(q=1;q<15;q=p){p=q+1
r[p]=r[q]+x[q]}for(x=d.b,w=x.$flags|0,u=0;u<g;++u){o=e[f+u]
if(o!==0){t=r[o]
r[o]=t+1
w&2&&A.aA(x)
x[t]=u}}},
JU:function JU(d,e){this.a=d
this.b=e},
bo2:function bo2(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.f=_.e=_.d=0},
aSz(){var x=$.c31
return x==null?$.c31=new B.aSA().$0():x},
crs(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.kj(114,y.a)
for(x=y.N,w=0;w<114;++w)m[w]=A.ck(E.cJ[w].a[1],"",!1,x)
v=new A.dH("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=D.c.hr(s,"\r")?D.c.a9(s,0,s.length-1):s
if(r.length===0)continue
if(D.c.bs(r,"#")){v.a+=r+"\n"
continue}q=D.c.fm(r,"|")
p=q<0?-1:D.c.jE(r,"|",q+1)
if(p<0)continue
o=A.dS(D.c.a9(r,0,q),null)
n=A.dS(D.c.a9(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=D.c.cm(r,p+1)}x=v.a
return new B.om(m,D.c.KQ(x.charCodeAt(0)==0?x:x))},
LB(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new A.Kx(null,f)
x=A.a(f.split(" "),y.s)
if(x.length>4){w=y.N
v=A.fL(x,0,A.iI(4,"count",y.S),w).aE(0," ")
if(B.bZV(v)===$.cjG())return new A.Kx(v,A.fL(x,4,null,w).aE(0," "))}return new A.Kx(null,f)},
bZV(d){var x,w,v,u=new A.dH("")
for(x=new A.Sf(d);x.v();){w=x.d
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
return D.c.O(x.charCodeAt(0)==0?x:x).toLowerCase()},
ch7(d){var x,w,v,u,t,s,r={},q=B.bZV(B.cA0(d))
r.a=q
r.a=D.c.O(D.c.fT(q,A.aD("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.t
w=A.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=A.dS(u,null)
if(t!=null)return t>=1&&t<=114?A.a([t],x):D.r6
x=r.a
u=A.aD("[\\s'\\-]",!0,!1,!1)
s=y.Z
x=A.aa(new A.am(w,new B.c_K(r,A.bG(x,u,"")),s),s.i("Y.E"))
return x},
cA0(d){return A.y_(d,A.aD("[\u0660-\u0669]",!0,!1,!1),new B.bY9(),null)},
om:function om(d,e){this.a=d
this.b=e},
aSA:function aSA(){},
c_K:function c_K(d,e){this.a=d
this.b=e},
bY9:function bY9(){},
c30(){var x=$.cb4
return x==null?$.cb4=new B.aSw().$0():x},
k6(d){return"\u0633\u0648\u0631\u0629 "+E.cJ[d-1].a[0]},
aSw:function aSw(){},
bZj(d){return B.cBQ(d)},
cBQ(d){var x=0,w=A.k(y.N),v,u=2,t=[],s,r,q,p,o,n,m,l,k,j,i,h
var $async$bZj=A.f(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:if(d.length<2||d[0]!==31||d[1]!==139){v=D.an.cr(d)
x=1
break}u=4
k=b.G
s=k.DecompressionStream
r=k.Response
x=s!=null&&r!=null?7:8
break
case 7:k=y.g
j=y.o
q=A.rM(k.a(s),"gzip",null,j)
p=A.rM(k.a(r),d,null,j)
o=A.cU(p.body)
n=A.cU(A.db(o,"pipeThrough",q,null,null,null))
m=A.rM(r,n,null,j)
x=9
return A.c(A.eF(A.cU(A.db(m,"text",null,null,null,null)),y.N),$async$bZj)
case 9:l=f
v=l
x=1
break
case 8:u=2
x=6
break
case 4:u=3
h=t.pop()
x=6
break
case 3:x=2
break
case 6:v=D.an.cr(B.cBP(d))
x=1
break
case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$bZj,w)}},C,E
J=c[1]
A=c[0]
D=c[2]
B=a.updateHolder(c[13],B)
C=c[34]
E=c[27]
B.JU.prototype={}
B.bo2.prototype={
nn(d){var x,w,v,u,t=this,s=t.e
for(x=t.a,w=x.length;v=t.f,v<d;){u=t.b
if(u>=w)throw A.q(C.akb)
t.b=u+1
s=(s|D.j.DR(x[u],v))>>>0
t.f=v+8}t.e=D.j.r0(s,d)
t.f=v-d
return(s&D.j.Q3(1,d)-1)>>>0},
a0_(d){var x,w=this,v=w.d,u=w.c,t=u.length
if(v===t){x=new Uint8Array(t*2)
D.ay.iI(x,0,v,u)
w.c=x
v=x}else v=u
u=w.d++
v.$flags&2&&A.aA(v)
v[u]=d},
cr(d){var x,w,v,u,t,s
for(x=d.a,w=0,v=0,u=0,t=1;t<16;++t){w=(w|this.nn(1))>>>0
s=x[t]
if(w-s<v)return d.b[u+(w-v)]
u+=s
v=v+s<<1>>>0
w=w<<1}throw A.q(C.aki)},
anj(d,e){var x,w,v,u,t,s=this
for(;;){x=s.cr(d)
if(x<256)s.a0_(x)
else if(x===256)return
else{x-=257
if(x>=29)throw A.q(C.ake)
w=C.aJA[x]+s.nn(C.awB[x])
v=s.cr(e)
u=C.aJJ[v]+s.nn(C.aBn[v])
if(u>s.d)throw A.q(C.akk)
for(t=0;t<w;++t)s.a0_(s.c[s.d-u])}}},
at6(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h=this,g=A.cT(),f=A.cT(),e=y.S,d=h.a,a0=!1
do{x=h.nn(1)
w=h.nn(2)
if(w===0){v=h.f=h.e=0
u=h.b
t=(d[u]|d[u+1]<<8)>>>0
h.b=u+4
for(;v<t;++v)h.a0_(d[h.b++])}else if(w===1){if(!a0){s=A.ck(318,0,!1,e)
for(r=0;r<144;++r)s[r]=8
for(r=144;r<256;++r)s[r]=9
for(r=256;r<280;++r)s[r]=7
for(r=280;r<288;++r)s[r]=8
for(r=288;r<318;++r)s[r]=5
u=new Int16Array(16)
g.sfD(new B.JU(u,new Int16Array(288)))
u=new Int16Array(16)
f.sfD(new B.JU(u,new Int16Array(30)))
B.aoG(g.bw(),s,0,288)
B.aoG(f.bw(),s,288,30)
a0=!0}h.anj(g.bw(),f.bw())}else if(w===2){q=h.nn(5)+257
p=h.nn(5)+1
o=h.nn(4)+4
s=A.ck(320,0,!1,e)
for(v=0;v<o;++v)s[C.aJ2[v]]=h.nn(3)
u=new Int16Array(16)
n=new B.JU(u,new Int16Array(288))
u=new Int16Array(16)
m=new B.JU(u,new Int16Array(30))
B.aoG(n,s,0,19)
for(u=q+p,l=0;l<u;){k=h.cr(n)
if(k<16){j=l+1
s[l]=k
l=j}else{if(k===16){if(l===0)throw A.q(C.akg)
t=s[l-1]
k=3+h.nn(2)}else{k=k===17?3+h.nn(3):11+h.nn(7)
t=0}if(l+k>u)throw A.q(C.akf)
for(;i=k-1,k>0;k=i,l=j){j=l+1
s[l]=t}}}B.aoG(n,s,0,q)
B.aoG(m,s,q,p)
h.anj(n,m)}else throw A.q(C.akc)}while(x===0)
e=h.c
d=h.d
return e.length===d?e:A.x5(e,0,d)}}
B.om.prototype={
xD(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["aj<om>()"])
B.aSA.prototype={
$0(){var x=0,w=A.k(y.x),v,u=2,t=[],s,r,q,p,o
var $async$$0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return A.c($.y6().iG("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return A.c(B.bZj(J.fB(J.c12(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=B.crs(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c31=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return A.i(v,w)
case 2:return A.h(t.at(-1),w)}})
return A.j($async$$0,w)},
$S:z+0}
B.c_K.prototype={
$1(d){var x=d-1,w=B.bZV(E.cJ[x].a[0]),v=this.a
if(D.c.n(w,v.a)||D.c.n(D.c.fT(w,A.aD("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=E.cJ[x].a[3]
v=A.aD("[\\s'\\-]",!0,!1,!1)
return D.c.n(A.bG(x.toLowerCase(),v,""),this.b)},
$S:72}
B.bY9.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:58}
B.aSw.prototype={
$0(){var x=0,w=A.k(y.y),v,u=2,t=[],s,r,q,p
var $async$$0=A.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new A.a8l("AmiriQuranMT",A.a([],y.m))
r.am9($.y6().iG("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return A.c(s.vp(),$async$$0)
case 7:$.cb5=!0
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
$S:196};(function inheritance(){var x=a.inheritMany
x(A.a5,[B.JU,B.bo2,B.om])
x(A.kV,[B.aSA,B.aSw])
x(A.ir,[B.c_K,B.bY9])})()
var y=(function rtii(){var x=A.ai
return{m:x("F<aj<kw>>"),s:x("F<o>"),t:x("F<x>"),o:x("bM"),g:x("hC"),a:x("a7<o>"),x:x("om"),N:x("o"),Z:x("am<x>"),y:x("P"),S:x("x")}})();(function constants(){var x=a.makeConstList
C.akb=new A.eR("truncated deflate stream",null,null)
C.akc=new A.eR("bad block type",null,null)
C.ake=new A.eR("bad length symbol",null,null)
C.akf=new A.eR("too many lengths",null,null)
C.akg=new A.eR("repeat with no first length",null,null)
C.aki=new A.eR("bad huffman code",null,null)
C.akk=new A.eR("distance too far back",null,null)
C.akl=new A.eR("not a gzip stream",null,null)
C.awB=x([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],y.t)
C.aBn=x([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],y.t)
C.aJ2=x([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],y.t)
C.aJA=x([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],y.t)
C.aJJ=x([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],y.t)
C.As=new A.eX(" ",null,null,D.bx,null,null,null,null,null,null,null)})();(function staticFields(){$.c31=null
$.cb4=null
$.cb5=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cIF","cjG",()=>B.bZV("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["HUQQlJof243nMOosramWzrM/i+g="]=a.current})($__dart_deferred_initializers__);