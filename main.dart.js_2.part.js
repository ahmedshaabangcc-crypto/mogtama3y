((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,D,C={
cvX(d){var x,w,v,u,t=d.length
if(t<18||d[0]!==31||d[1]!==139||d[2]!==8)throw B.q(A.aif)
x=d[3]
w=(x&4)!==0?10+(2+((d[10]|d[11]<<8)>>>0)):10
if((x&8)!==0){for(;v=w+1,d[w]!==0;w=v);w=v}if((x&16)!==0){for(;v=w+1,d[w]!==0;w=v);w=v}if((x&2)!==0)w+=2
u=(d[t-4]|d[t-3]<<8|d[t-2]<<16|d[t-1]<<24)>>>0
t=u>0?u:65536
return new C.blL(d,w,new Uint8Array(t)).as4()},
anp(d,e,f,g){var x,w,v,u,t,s,r,q,p,o
for(x=d.a,w=x.$flags|0,v=0;v<16;++v){w&2&&B.az(x)
x[v]=0}for(u=0;u<g;++u){t=e[f+u]
s=x[t]
w&2&&B.az(x)
x[t]=s+1}r=B.ch(16,0,!1,y.S)
for(q=1;q<15;q=p){p=q+1
r[p]=r[q]+x[q]}for(x=d.b,w=x.$flags|0,u=0;u<g;++u){o=e[f+u]
if(o!==0){t=r[o]
r[o]=t+1
w&2&&B.az(x)
x[t]=u}}},
J8:function J8(d,e){this.a=d
this.b=e},
blL:function blL(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.f=_.e=_.d=0},
aQD(){var x=$.bZ6
return x==null?$.bZ6=new C.aQE().$0():x},
clN(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.k7(114,y.a)
for(x=y.N,w=0;w<114;++w)m[w]=B.ch(A.dp[w].a[1],"",!1,x)
v=new B.du("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=D.c.hH(s,"\r")?D.c.aa(s,0,s.length-1):s
if(r.length===0)continue
if(D.c.bu(r,"#")){v.a+=r+"\n"
continue}q=D.c.fL(r,"|")
p=q<0?-1:D.c.jC(r,"|",q+1)
if(p<0)continue
o=B.el(D.c.aa(r,0,q),null)
n=B.el(D.c.aa(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=D.c.cm(r,p+1)}x=v.a
return new C.o_(m,D.c.Kt(x.charCodeAt(0)==0?x:x))},
awN(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new B.JM(null,f)
x=B.a(f.split(" "),y.s)
if(x.length>4){w=y.N
v=B.h0(x,0,B.jq(4,"count",y.S),w).aH(0," ")
if(C.bVx(v)===$.ce9())return new B.JM(v,B.h0(x,4,null,w).aH(0," "))}return new B.JM(null,f)},
bVx(d){var x,w,v,u=new B.du("")
for(x=new B.Rj(d);x.v();){w=x.d
v=!0
if(!(w>=1611&&w<=1631))if(w!==1648)v=w>=1750&&w<=1773||w===1600
if(v)continue
A:{if(1570===w||1571===w||1573===w||1649===w){v=B.eO(1575)
u.a+=v
break A}if(1577===w){v=B.eO(1607)
u.a+=v
break A}if(1609===w){v=B.eO(1610)
u.a+=v
break A}v=B.eO(w)
u.a+=v}}x=u.a
return D.c.R(x.charCodeAt(0)==0?x:x).toLowerCase()},
cbF(d){var x,w,v,u,t,s,r={},q=C.bVx(C.cud(d))
r.a=q
r.a=D.c.R(D.c.fN(q,B.aW("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.t
w=B.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=B.el(u,null)
if(t!=null)return t>=1&&t<=114?B.a([t],x):D.qR
x=r.a
u=B.aW("[\\s'\\-]",!0,!1,!1)
s=y.Z
x=B.ab(new B.ap(w,new C.bW5(r,B.bR(x,u,"")),s),s.i("Y.E"))
return x},
cud(d){return B.xj(d,B.aW("[\u0660-\u0669]",!0,!1,!1),new C.bTR(),null)},
o_:function o_(d,e){this.a=d
this.b=e},
aQE:function aQE(){},
bW5:function bW5(d,e){this.a=d
this.b=e},
bTR:function bTR(){},
bZ5(){var x=$.c5Q
return x==null?$.c5Q=new C.aQA().$0():x},
jU(d){return"\u0633\u0648\u0631\u0629 "+A.dp[d-1].a[0]},
aQA:function aQA(){},
bUW(d){return C.cvY(d)},
cvY(d){var x=0,w=B.k(y.N),v,u=2,t=[],s,r,q,p,o,n,m,l,k,j,i,h
var $async$bUW=B.f(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:if(d.length<2||d[0]!==31||d[1]!==139){v=D.ao.cr(d)
x=1
break}u=4
k=b.G
s=k.DecompressionStream
r=k.Response
x=s!=null&&r!=null?7:8
break
case 7:k=y.g
j=y.o
q=B.a8y(k.a(s),"gzip",j)
p=B.a8y(k.a(r),d,j)
o=B.eE(p.body)
n=B.fH(o,"pipeThrough",q,null,j)
m=B.a8y(r,n,j)
x=9
return B.c(B.eF(B.fH(m,"text",null,null,j),y.N),$async$bUW)
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
case 6:v=D.ao.cr(C.cvX(d))
x=1
break
case 1:return B.i(v,w)
case 2:return B.h(t.at(-1),w)}})
return B.j($async$bUW,w)}},A
J=c[1]
B=c[0]
D=c[2]
C=a.updateHolder(c[10],C)
A=c[25]
C.J8.prototype={}
C.blL.prototype={
nd(d){var x,w,v,u,t=this,s=t.e
for(x=t.a,w=x.length;v=t.f,v<d;){u=t.b
if(u>=w)throw B.q(A.ai5)
t.b=u+1
s=(s|D.k.Dv(x[u],v))>>>0
t.f=v+8}t.e=D.k.qQ(s,d)
t.f=v-d
return(s&D.k.Py(1,d)-1)>>>0},
a_f(d){var x,w=this,v=w.d,u=w.c,t=u.length
if(v===t){x=new Uint8Array(t*2)
D.aw.iC(x,0,v,u)
w.c=x
v=x}else v=u
u=w.d++
v.$flags&2&&B.az(v)
v[u]=d},
cr(d){var x,w,v,u,t,s
for(x=d.a,w=0,v=0,u=0,t=1;t<16;++t){w=(w|this.nd(1))>>>0
s=x[t]
if(w-s<v)return d.b[u+(w-v)]
u+=s
v=v+s<<1>>>0
w=w<<1}throw B.q(A.aic)},
amu(d,e){var x,w,v,u,t,s=this
for(;;){x=s.cr(d)
if(x<256)s.a_f(x)
else if(x===256)return
else{x-=257
if(x>=29)throw B.q(A.ai8)
w=A.aGT[x]+s.nd(A.au4[x])
v=s.cr(e)
u=A.aH1[v]+s.nd(A.ayK[v])
if(u>s.d)throw B.q(A.aie)
for(t=0;t<w;++t)s.a_f(s.c[s.d-u])}}},
as4(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h=this,g=B.cO(),f=B.cO(),e=y.S,d=h.a,a0=!1
do{x=h.nd(1)
w=h.nd(2)
if(w===0){v=h.f=h.e=0
u=h.b
t=(d[u]|d[u+1]<<8)>>>0
h.b=u+4
for(;v<t;++v)h.a_f(d[h.b++])}else if(w===1){if(!a0){s=B.ch(318,0,!1,e)
for(r=0;r<144;++r)s[r]=8
for(r=144;r<256;++r)s[r]=9
for(r=256;r<280;++r)s[r]=7
for(r=280;r<288;++r)s[r]=8
for(r=288;r<318;++r)s[r]=5
u=new Int16Array(16)
g.sfw(new C.J8(u,new Int16Array(288)))
u=new Int16Array(16)
f.sfw(new C.J8(u,new Int16Array(30)))
C.anp(g.bw(),s,0,288)
C.anp(f.bw(),s,288,30)
a0=!0}h.amu(g.bw(),f.bw())}else if(w===2){q=h.nd(5)+257
p=h.nd(5)+1
o=h.nd(4)+4
s=B.ch(320,0,!1,e)
for(v=0;v<o;++v)s[A.aGm[v]]=h.nd(3)
u=new Int16Array(16)
n=new C.J8(u,new Int16Array(288))
u=new Int16Array(16)
m=new C.J8(u,new Int16Array(30))
C.anp(n,s,0,19)
for(u=q+p,l=0;l<u;){k=h.cr(n)
if(k<16){j=l+1
s[l]=k
l=j}else{if(k===16){if(l===0)throw B.q(A.aia)
t=s[l-1]
k=3+h.nd(2)}else{k=k===17?3+h.nd(3):11+h.nd(7)
t=0}if(l+k>u)throw B.q(A.ai9)
for(;i=k-1,k>0;k=i,l=j){j=l+1
s[l]=t}}}C.anp(n,s,0,q)
C.anp(m,s,q,p)
h.amu(n,m)}else throw B.q(A.ai6)}while(x===0)
e=h.c
d=h.d
return e.length===d?e:B.wm(e,0,d)}}
C.o_.prototype={
HV(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["aj<o_>()"])
C.aQE.prototype={
$0(){var x=0,w=B.k(y.x),v,u=2,t=[],s,r,q,p,o
var $async$$0=B.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return B.c($.xo().iz("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return B.c(C.bUW(J.fr(J.bXc(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=C.clN(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.bZ6=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return B.i(v,w)
case 2:return B.h(t.at(-1),w)}})
return B.j($async$$0,w)},
$S:z+0}
C.bW5.prototype={
$1(d){var x=d-1,w=C.bVx(A.dp[x].a[0]),v=this.a
if(D.c.n(w,v.a)||D.c.n(D.c.fN(w,B.aW("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=A.dp[x].a[3]
v=B.aW("[\\s'\\-]",!0,!1,!1)
return D.c.n(B.bR(x.toLowerCase(),v,""),this.b)},
$S:79}
C.bTR.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:55}
C.aQA.prototype={
$0(){var x=0,w=B.k(y.y),v,u=2,t=[],s,r,q,p
var $async$$0=B.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new B.a7i("AmiriQuranMT",B.a([],y.m))
r.ali($.xo().iz("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return B.c(s.va(),$async$$0)
case 7:$.c5R=!0
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
case 6:case 1:return B.i(v,w)
case 2:return B.h(t.at(-1),w)}})
return B.j($async$$0,w)},
$S:171};(function inheritance(){var x=a.inheritMany
x(B.a3,[C.J8,C.blL,C.o_])
x(B.nn,[C.aQE,C.aQA])
x(B.ju,[C.bW5,C.bTR])})()
var y=(function rtii(){var x=B.as
return{m:x("G<aj<ki>>"),s:x("G<o>"),t:x("G<y>"),o:x("bP"),g:x("hM"),a:x("a7<o>"),x:x("o_"),N:x("o"),Z:x("ap<y>"),y:x("Q"),S:x("y")}})();(function constants(){var x=a.makeConstList
A.ai5=new B.eH("truncated deflate stream",null,null)
A.ai6=new B.eH("bad block type",null,null)
A.ai8=new B.eH("bad length symbol",null,null)
A.ai9=new B.eH("too many lengths",null,null)
A.aia=new B.eH("repeat with no first length",null,null)
A.aic=new B.eH("bad huffman code",null,null)
A.aie=new B.eH("distance too far back",null,null)
A.aif=new B.eH("not a gzip stream",null,null)
A.au4=x([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],y.t)
A.ayK=x([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],y.t)
A.aYa=new B.bf(["\u0627\u0644\u0641\u0627\u062a\u062d\u0629",7,!0,"Al-Faatiha"])
A.aXc=new B.bf(["\u0627\u0644\u0628\u0642\u0631\u0629",286,!1,"Al-Baqara"])
A.aX_=new B.bf(["\u0622\u0644 \u0639\u0645\u0631\u0627\u0646",200,!1,"Aal-i-Imraan"])
A.aXx=new B.bf(["\u0627\u0644\u0646\u0633\u0627\u0621",176,!1,"An-Nisaa"])
A.aXI=new B.bf(["\u0627\u0644\u0645\u0627\u0626\u062f\u0629",120,!1,"Al-Maaida"])
A.aWI=new B.bf(["\u0627\u0644\u0623\u0646\u0639\u0627\u0645",165,!0,"Al-An'aam"])
A.aXa=new B.bf(["\u0627\u0644\u0623\u0639\u0631\u0627\u0641",206,!0,"Al-A'raaf"])
A.aXb=new B.bf(["\u0627\u0644\u0623\u0646\u0641\u0627\u0644",75,!1,"Al-Anfaal"])
A.aYd=new B.bf(["\u0627\u0644\u062a\u0648\u0628\u0629",129,!1,"At-Tawba"])
A.aWF=new B.bf(["\u064a\u0648\u0646\u0633",109,!0,"Yunus"])
A.aY_=new B.bf(["\u0647\u0648\u062f",123,!0,"Hud"])
A.aXV=new B.bf(["\u064a\u0648\u0633\u0641",111,!0,"Yusuf"])
A.aXn=new B.bf(["\u0627\u0644\u0631\u0639\u062f",43,!1,"Ar-Ra'd"])
A.aY5=new B.bf(["\u0627\u0628\u0631\u0627\u0647\u064a\u0645",52,!0,"Ibrahim"])
A.aXv=new B.bf(["\u0627\u0644\u062d\u062c\u0631",99,!0,"Al-Hijr"])
A.aYn=new B.bf(["\u0627\u0644\u0646\u062d\u0644",128,!0,"An-Nahl"])
A.aWG=new B.bf(["\u0627\u0644\u0625\u0633\u0631\u0627\u0621",111,!0,"Al-Israa"])
A.aYf=new B.bf(["\u0627\u0644\u0643\u0647\u0641",110,!0,"Al-Kahf"])
A.aXg=new B.bf(["\u0645\u0631\u064a\u0645",98,!0,"Maryam"])
A.aXK=new B.bf(["\u0637\u0647",135,!0,"Taa-Haa"])
A.aY4=new B.bf(["\u0627\u0644\u0623\u0646\u0628\u064a\u0627\u0621",112,!0,"Al-Anbiyaa"])
A.aWY=new B.bf(["\u0627\u0644\u062d\u062c",78,!1,"Al-Hajj"])
A.aYb=new B.bf(["\u0627\u0644\u0645\u0624\u0645\u0646\u0648\u0646",118,!0,"Al-Muminoon"])
A.aXq=new B.bf(["\u0627\u0644\u0646\u0648\u0631",64,!1,"An-Noor"])
A.aXL=new B.bf(["\u0627\u0644\u0641\u0631\u0642\u0627\u0646",77,!0,"Al-Furqaan"])
A.aXS=new B.bf(["\u0627\u0644\u0634\u0639\u0631\u0627\u0621",227,!0,"Ash-Shu'araa"])
A.aXs=new B.bf(["\u0627\u0644\u0646\u0645\u0644",93,!0,"An-Naml"])
A.aWW=new B.bf(["\u0627\u0644\u0642\u0635\u0635",88,!0,"Al-Qasas"])
A.aWK=new B.bf(["\u0627\u0644\u0639\u0646\u0643\u0628\u0648\u062a",69,!0,"Al-Ankaboot"])
A.aYm=new B.bf(["\u0627\u0644\u0631\u0648\u0645",60,!0,"Ar-Room"])
A.aY0=new B.bf(["\u0644\u0642\u0645\u0627\u0646",34,!0,"Luqman"])
A.aY6=new B.bf(["\u0627\u0644\u0633\u062c\u062f\u0629",30,!0,"As-Sajda"])
A.aWE=new B.bf(["\u0627\u0644\u0623\u062d\u0632\u0627\u0628",73,!1,"Al-Ahzaab"])
A.aX6=new B.bf(["\u0633\u0628\u0625",54,!0,"Saba"])
A.aXm=new B.bf(["\u0641\u0627\u0637\u0631",45,!0,"Faatir"])
A.aWJ=new B.bf(["\u064a\u0633",83,!0,"Yaseen"])
A.aXM=new B.bf(["\u0627\u0644\u0635\u0627\u0641\u0627\u062a",182,!0,"As-Saaffaat"])
A.aX4=new B.bf(["\u0635",88,!0,"Saad"])
A.aXk=new B.bf(["\u0627\u0644\u0632\u0645\u0631",75,!0,"Az-Zumar"])
A.aXo=new B.bf(["\u063a\u0627\u0641\u0631",85,!0,"Al-Ghaafir"])
A.aXA=new B.bf(["\u0641\u0635\u0644\u062a",54,!0,"Fussilat"])
A.aXp=new B.bf(["\u0627\u0644\u0634\u0648\u0631\u0649",53,!0,"Ash-Shura"])
A.aWM=new B.bf(["\u0627\u0644\u0632\u062e\u0631\u0641",89,!0,"Az-Zukhruf"])
A.aWS=new B.bf(["\u0627\u0644\u062f\u062e\u0627\u0646",59,!0,"Ad-Dukhaan"])
A.aY7=new B.bf(["\u0627\u0644\u062c\u0627\u062b\u064a\u0629",37,!0,"Al-Jaathiya"])
A.aXX=new B.bf(["\u0627\u0644\u0623\u062d\u0642\u0627\u0641",35,!0,"Al-Ahqaf"])
A.aXl=new B.bf(["\u0645\u062d\u0645\u062f",38,!1,"Muhammad"])
A.aXu=new B.bf(["\u0627\u0644\u0641\u062a\u062d",29,!1,"Al-Fath"])
A.aYe=new B.bf(["\u0627\u0644\u062d\u062c\u0631\u0627\u062a",18,!1,"Al-Hujuraat"])
A.aXC=new B.bf(["\u0642",45,!0,"Qaaf"])
A.aX2=new B.bf(["\u0627\u0644\u0630\u0627\u0631\u064a\u0627\u062a",60,!0,"Adh-Dhaariyat"])
A.aXh=new B.bf(["\u0627\u0644\u0637\u0648\u0631",49,!0,"At-Tur"])
A.aXZ=new B.bf(["\u0627\u0644\u0646\u062c\u0645",62,!0,"An-Najm"])
A.aYc=new B.bf(["\u0627\u0644\u0642\u0645\u0631",55,!0,"Al-Qamar"])
A.aYj=new B.bf(["\u0627\u0644\u0631\u062d\u0645\u0646",78,!1,"Ar-Rahmaan"])
A.aXj=new B.bf(["\u0627\u0644\u0648\u0627\u0642\u0639\u0629",96,!0,"Al-Waaqia"])
A.aXQ=new B.bf(["\u0627\u0644\u062d\u062f\u064a\u062f",29,!1,"Al-Hadid"])
A.aXF=new B.bf(["\u0627\u0644\u0645\u062c\u0627\u062f\u0644\u0629",22,!1,"Al-Mujaadila"])
A.aWC=new B.bf(["\u0627\u0644\u062d\u0634\u0631",24,!1,"Al-Hashr"])
A.aWT=new B.bf(["\u0627\u0644\u0645\u0645\u062a\u062d\u0646\u0629",13,!1,"Al-Mumtahana"])
A.aX1=new B.bf(["\u0627\u0644\u0635\u0641",14,!1,"As-Saff"])
A.aWQ=new B.bf(["\u0627\u0644\u062c\u0645\u0639\u0629",11,!1,"Al-Jumu'a"])
A.aXD=new B.bf(["\u0627\u0644\u0645\u0646\u0627\u0641\u0642\u0648\u0646",11,!1,"Al-Munaafiqoon"])
A.aWU=new B.bf(["\u0627\u0644\u062a\u063a\u0627\u0628\u0646",18,!1,"At-Taghaabun"])
A.aYp=new B.bf(["\u0627\u0644\u0637\u0644\u0627\u0642",12,!1,"At-Talaaq"])
A.aY9=new B.bf(["\u0627\u0644\u062a\u062d\u0631\u064a\u0645",12,!1,"At-Tahrim"])
A.aYl=new B.bf(["\u0627\u0644\u0645\u0644\u0643",30,!0,"Al-Mulk"])
A.aXi=new B.bf(["\u0627\u0644\u0642\u0644\u0645",52,!0,"Al-Qalam"])
A.aYi=new B.bf(["\u0627\u0644\u062d\u0627\u0642\u0629",52,!0,"Al-Haaqqa"])
A.aXN=new B.bf(["\u0627\u0644\u0645\u0639\u0627\u0631\u062c",44,!0,"Al-Ma'aarij"])
A.aXd=new B.bf(["\u0646\u0648\u062d",28,!0,"Nooh"])
A.aXB=new B.bf(["\u0627\u0644\u062c\u0646",28,!0,"Al-Jinn"])
A.aYg=new B.bf(["\u0627\u0644\u0645\u0632\u0645\u0644",20,!0,"Al-Muzzammil"])
A.aYk=new B.bf(["\u0627\u0644\u0645\u062f\u062b\u0631",56,!0,"Al-Muddaththir"])
A.aXH=new B.bf(["\u0627\u0644\u0642\u064a\u0627\u0645\u0629",40,!0,"Al-Qiyaama"])
A.aXw=new B.bf(["\u0627\u0644\u0627\u0646\u0633\u0627\u0646",31,!1,"Al-Insaan"])
A.aWH=new B.bf(["\u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a",50,!0,"Al-Mursalaat"])
A.aXz=new B.bf(["\u0627\u0644\u0646\u0628\u0625",40,!0,"An-Naba"])
A.aXR=new B.bf(["\u0627\u0644\u0646\u0627\u0632\u0639\u0627\u062a",46,!0,"An-Naazi'aat"])
A.aXY=new B.bf(["\u0639\u0628\u0633",42,!0,"Abasa"])
A.aXf=new B.bf(["\u0627\u0644\u062a\u0643\u0648\u064a\u0631",29,!0,"At-Takwir"])
A.aX9=new B.bf(["\u0627\u0644\u0625\u0646\u0641\u0637\u0627\u0631",19,!0,"Al-Infitaar"])
A.aXE=new B.bf(["\u0627\u0644\u0645\u0637\u0641\u0641\u064a\u0646",36,!0,"Al-Mutaffifin"])
A.aXW=new B.bf(["\u0627\u0644\u0625\u0646\u0634\u0642\u0627\u0642",25,!0,"Al-Inshiqaaq"])
A.aXT=new B.bf(["\u0627\u0644\u0628\u0631\u0648\u062c",22,!0,"Al-Burooj"])
A.aXy=new B.bf(["\u0627\u0644\u0637\u0627\u0631\u0642",17,!0,"At-Taariq"])
A.aWV=new B.bf(["\u0627\u0644\u0623\u0639\u0644\u0649",19,!0,"Al-A'laa"])
A.aXe=new B.bf(["\u0627\u0644\u063a\u0627\u0634\u064a\u0629",26,!0,"Al-Ghaashiya"])
A.aY1=new B.bf(["\u0627\u0644\u0641\u062c\u0631",30,!0,"Al-Fajr"])
A.aXG=new B.bf(["\u0627\u0644\u0628\u0644\u062f",20,!0,"Al-Balad"])
A.aX8=new B.bf(["\u0627\u0644\u0634\u0645\u0633",15,!0,"Ash-Shams"])
A.aX7=new B.bf(["\u0627\u0644\u0644\u064a\u0644",21,!0,"Al-Lail"])
A.aX5=new B.bf(["\u0627\u0644\u0636\u062d\u0649",11,!0,"Ad-Dhuhaa"])
A.aX3=new B.bf(["\u0627\u0644\u0634\u0631\u062d",8,!0,"Ash-Sharh"])
A.aX0=new B.bf(["\u0627\u0644\u062a\u064a\u0646",8,!0,"At-Tin"])
A.aXO=new B.bf(["\u0627\u0644\u0639\u0644\u0642",19,!0,"Al-Alaq"])
A.aWP=new B.bf(["\u0627\u0644\u0642\u062f\u0631",5,!0,"Al-Qadr"])
A.aYh=new B.bf(["\u0627\u0644\u0628\u064a\u0646\u0629",8,!1,"Al-Bayyina"])
A.aWD=new B.bf(["\u0627\u0644\u0632\u0644\u0632\u0644\u0629",8,!1,"Az-Zalzala"])
A.aXt=new B.bf(["\u0627\u0644\u0639\u0627\u062f\u064a\u0627\u062a",11,!0,"Al-Aadiyaat"])
A.aWN=new B.bf(["\u0627\u0644\u0642\u0627\u0631\u0639\u0629",11,!0,"Al-Qaari'a"])
A.aWL=new B.bf(["\u0627\u0644\u062a\u0643\u0627\u062b\u0631",8,!0,"At-Takaathur"])
A.aWR=new B.bf(["\u0627\u0644\u0639\u0635\u0631",3,!0,"Al-Asr"])
A.aWX=new B.bf(["\u0627\u0644\u0647\u0645\u0632\u0629",9,!0,"Al-Humaza"])
A.aWZ=new B.bf(["\u0627\u0644\u0641\u064a\u0644",5,!0,"Al-Fil"])
A.aXP=new B.bf(["\u0642\u0631\u064a\u0634",4,!0,"Quraish"])
A.aWO=new B.bf(["\u0627\u0644\u0645\u0627\u0639\u0648\u0646",7,!0,"Al-Maa'un"])
A.aY3=new B.bf(["\u0627\u0644\u0643\u0648\u062b\u0631",3,!0,"Al-Kawthar"])
A.aXU=new B.bf(["\u0627\u0644\u0643\u0627\u0641\u0631\u0648\u0646",6,!0,"Al-Kaafiroon"])
A.aY2=new B.bf(["\u0627\u0644\u0646\u0635\u0631",3,!1,"An-Nasr"])
A.aYo=new B.bf(["\u0627\u0644\u0645\u0633\u062f",5,!0,"Al-Masad"])
A.aY8=new B.bf(["\u0627\u0644\u0625\u062e\u0644\u0627\u0635",4,!0,"Al-Ikhlaas"])
A.aXr=new B.bf(["\u0627\u0644\u0641\u0644\u0642",5,!0,"Al-Falaq"])
A.aXJ=new B.bf(["\u0627\u0644\u0646\u0627\u0633",6,!0,"An-Naas"])
A.dp=x([A.aYa,A.aXc,A.aX_,A.aXx,A.aXI,A.aWI,A.aXa,A.aXb,A.aYd,A.aWF,A.aY_,A.aXV,A.aXn,A.aY5,A.aXv,A.aYn,A.aWG,A.aYf,A.aXg,A.aXK,A.aY4,A.aWY,A.aYb,A.aXq,A.aXL,A.aXS,A.aXs,A.aWW,A.aWK,A.aYm,A.aY0,A.aY6,A.aWE,A.aX6,A.aXm,A.aWJ,A.aXM,A.aX4,A.aXk,A.aXo,A.aXA,A.aXp,A.aWM,A.aWS,A.aY7,A.aXX,A.aXl,A.aXu,A.aYe,A.aXC,A.aX2,A.aXh,A.aXZ,A.aYc,A.aYj,A.aXj,A.aXQ,A.aXF,A.aWC,A.aWT,A.aX1,A.aWQ,A.aXD,A.aWU,A.aYp,A.aY9,A.aYl,A.aXi,A.aYi,A.aXN,A.aXd,A.aXB,A.aYg,A.aYk,A.aXH,A.aXw,A.aWH,A.aXz,A.aXR,A.aXY,A.aXf,A.aX9,A.aXE,A.aXW,A.aXT,A.aXy,A.aWV,A.aXe,A.aY1,A.aXG,A.aX8,A.aX7,A.aX5,A.aX3,A.aX0,A.aXO,A.aWP,A.aYh,A.aWD,A.aXt,A.aWN,A.aWL,A.aWR,A.aWX,A.aWZ,A.aXP,A.aWO,A.aY3,A.aXU,A.aY2,A.aYo,A.aY8,A.aXr,A.aXJ],B.as("G<+(o,y,Q,o)>"))
A.aGm=x([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],y.t)
A.aGT=x([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],y.t)
A.aH1=x([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],y.t)
A.zL=new B.eP(" ",null,null,D.bt,null,null,null,null,null,null,null)})();(function staticFields(){$.bZ6=null
$.c5Q=null
$.c5R=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cCq","ce9",()=>C.bVx("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["ZS2SJZq7WgZGm6DgoT2H7DYFBsg="]=a.current})($__dart_deferred_initializers__);