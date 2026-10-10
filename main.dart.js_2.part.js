((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,D,C={
cx5(d){var x,w,v,u,t=d.length
if(t<18||d[0]!==31||d[1]!==139||d[2]!==8)throw B.q(A.aiq)
x=d[3]
w=(x&4)!==0?10+(2+((d[10]|d[11]<<8)>>>0)):10
if((x&8)!==0){for(;v=w+1,d[w]!==0;w=v);w=v}if((x&16)!==0){for(;v=w+1,d[w]!==0;w=v);w=v}if((x&2)!==0)w+=2
u=(d[t-4]|d[t-3]<<8|d[t-2]<<16|d[t-1]<<24)>>>0
t=u>0?u:65536
return new C.bm0(d,w,new Uint8Array(t)).asc()},
anz(d,e,f,g){var x,w,v,u,t,s,r,q,p,o
for(x=d.a,w=x.$flags|0,v=0;v<16;++v){w&2&&B.aA(x)
x[v]=0}for(u=0;u<g;++u){t=e[f+u]
s=x[t]
w&2&&B.aA(x)
x[t]=s+1}r=B.ch(16,0,!1,y.S)
for(q=1;q<15;q=p){p=q+1
r[p]=r[q]+x[q]}for(x=d.b,w=x.$flags|0,u=0;u<g;++u){o=e[f+u]
if(o!==0){t=r[o]
r[o]=t+1
w&2&&B.aA(x)
x[t]=u}}},
Jc:function Jc(d,e){this.a=d
this.b=e},
bm0:function bm0(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.f=_.e=_.d=0},
aQT(){var x=$.c_9
return x==null?$.c_9=new C.aQU().$0():x},
cmV(d){var x,w,v,u,t,s,r,q,p,o,n,m=J.k8(114,y.a)
for(x=y.N,w=0;w<114;++w)m[w]=B.ch(A.dp[w].a[1],"",!1,x)
v=new B.dx("")
for(x=d.split("\n"),u=x.length,t=0;t<u;++t){s=x[t]
r=D.c.hI(s,"\r")?D.c.aa(s,0,s.length-1):s
if(r.length===0)continue
if(D.c.bu(r,"#")){v.a+=r+"\n"
continue}q=D.c.fN(r,"|")
p=q<0?-1:D.c.jC(r,"|",q+1)
if(p<0)continue
o=B.em(D.c.aa(r,0,q),null)
n=B.em(D.c.aa(r,q+1,p),null)
if(o==null||n==null||o<1||o>114||n<1||n>m[o-1].length)continue
m[o-1][n-1]=D.c.cm(r,p+1)}x=v.a
return new C.o0(m,D.c.Kz(x.charCodeAt(0)==0?x:x))},
awY(d,e,f){var x,w,v
if(d===1||d===9||e!==1)return new B.JQ(null,f)
x=B.a(f.split(" "),y.s)
if(x.length>4){w=y.N
v=B.h3(x,0,B.jr(4,"count",y.S),w).aG(0," ")
if(C.bWz(v)===$.cfg())return new B.JQ(v,B.h3(x,4,null,w).aG(0," "))}return new B.JQ(null,f)},
bWz(d){var x,w,v,u=new B.dx("")
for(x=new B.Ro(d);x.v();){w=x.d
v=!0
if(!(w>=1611&&w<=1631))if(w!==1648)v=w>=1750&&w<=1773||w===1600
if(v)continue
A:{if(1570===w||1571===w||1573===w||1649===w){v=B.eP(1575)
u.a+=v
break A}if(1577===w){v=B.eP(1607)
u.a+=v
break A}if(1609===w){v=B.eP(1610)
u.a+=v
break A}v=B.eP(w)
u.a+=v}}x=u.a
return D.c.P(x.charCodeAt(0)==0?x:x).toLowerCase()},
ccM(d){var x,w,v,u,t,s,r={},q=C.bWz(C.cvl(d))
r.a=q
r.a=D.c.P(D.c.fP(q,B.aW("^\u0633\u0648\u0631\u0647\\s*",!0,!1,!1),""))
x=y.t
w=B.a([],x)
for(v=1;v<=114;++v)w.push(v)
u=r.a
if(u.length===0)return w
t=B.em(u,null)
if(t!=null)return t>=1&&t<=114?B.a([t],x):D.qU
x=r.a
u=B.aW("[\\s'\\-]",!0,!1,!1)
s=y.Z
x=B.ab(new B.ao(w,new C.bX8(r,B.bR(x,u,"")),s),s.i("Y.E"))
return x},
cvl(d){return B.xk(d,B.aW("[\u0660-\u0669]",!0,!1,!1),new C.bUT(),null)},
o0:function o0(d,e){this.a=d
this.b=e},
aQU:function aQU(){},
bX8:function bX8(d,e){this.a=d
this.b=e},
bUT:function bUT(){},
c_8(){var x=$.c6U
return x==null?$.c6U=new C.aQQ().$0():x},
jV(d){return"\u0633\u0648\u0631\u0629 "+A.dp[d-1].a[0]},
aQQ:function aQQ(){},
bVY(d){return C.cx6(d)},
cx6(d){var x=0,w=B.k(y.N),v,u=2,t=[],s,r,q,p,o,n,m,l,k,j,i,h
var $async$bVY=B.f(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:if(d.length<2||d[0]!==31||d[1]!==139){v=D.ao.ct(d)
x=1
break}u=4
k=b.G
s=k.DecompressionStream
r=k.Response
x=s!=null&&r!=null?7:8
break
case 7:k=y.g
j=y.o
q=B.a8F(k.a(s),"gzip",j)
p=B.a8F(k.a(r),d,j)
o=B.eF(p.body)
n=B.fJ(o,"pipeThrough",q,null,j)
m=B.a8F(r,n,j)
x=9
return B.c(B.eG(B.fJ(m,"text",null,null,j),y.N),$async$bVY)
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
case 6:v=D.ao.ct(C.cx5(d))
x=1
break
case 1:return B.i(v,w)
case 2:return B.h(t.at(-1),w)}})
return B.j($async$bVY,w)}},A
J=c[1]
B=c[0]
D=c[2]
C=a.updateHolder(c[10],C)
A=c[25]
C.Jc.prototype={}
C.bm0.prototype={
ne(d){var x,w,v,u,t=this,s=t.e
for(x=t.a,w=x.length;v=t.f,v<d;){u=t.b
if(u>=w)throw B.q(A.aig)
t.b=u+1
s=(s|D.j.DA(x[u],v))>>>0
t.f=v+8}t.e=D.j.qS(s,d)
t.f=v-d
return(s&D.j.PF(1,d)-1)>>>0},
a_n(d){var x,w=this,v=w.d,u=w.c,t=u.length
if(v===t){x=new Uint8Array(t*2)
D.aw.iD(x,0,v,u)
w.c=x
v=x}else v=u
u=w.d++
v.$flags&2&&B.aA(v)
v[u]=d},
ct(d){var x,w,v,u,t,s
for(x=d.a,w=0,v=0,u=0,t=1;t<16;++t){w=(w|this.ne(1))>>>0
s=x[t]
if(w-s<v)return d.b[u+(w-v)]
u+=s
v=v+s<<1>>>0
w=w<<1}throw B.q(A.ain)},
amC(d,e){var x,w,v,u,t,s=this
for(;;){x=s.ct(d)
if(x<256)s.a_n(x)
else if(x===256)return
else{x-=257
if(x>=29)throw B.q(A.aij)
w=A.aHe[x]+s.ne(A.aup[x])
v=s.ct(e)
u=A.aHn[v]+s.ne(A.az4[v])
if(u>s.d)throw B.q(A.aip)
for(t=0;t<w;++t)s.a_n(s.c[s.d-u])}}},
asc(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h=this,g=B.cO(),f=B.cO(),e=y.S,d=h.a,a0=!1
do{x=h.ne(1)
w=h.ne(2)
if(w===0){v=h.f=h.e=0
u=h.b
t=(d[u]|d[u+1]<<8)>>>0
h.b=u+4
for(;v<t;++v)h.a_n(d[h.b++])}else if(w===1){if(!a0){s=B.ch(318,0,!1,e)
for(r=0;r<144;++r)s[r]=8
for(r=144;r<256;++r)s[r]=9
for(r=256;r<280;++r)s[r]=7
for(r=280;r<288;++r)s[r]=8
for(r=288;r<318;++r)s[r]=5
u=new Int16Array(16)
g.sfz(new C.Jc(u,new Int16Array(288)))
u=new Int16Array(16)
f.sfz(new C.Jc(u,new Int16Array(30)))
C.anz(g.bw(),s,0,288)
C.anz(f.bw(),s,288,30)
a0=!0}h.amC(g.bw(),f.bw())}else if(w===2){q=h.ne(5)+257
p=h.ne(5)+1
o=h.ne(4)+4
s=B.ch(320,0,!1,e)
for(v=0;v<o;++v)s[A.aGI[v]]=h.ne(3)
u=new Int16Array(16)
n=new C.Jc(u,new Int16Array(288))
u=new Int16Array(16)
m=new C.Jc(u,new Int16Array(30))
C.anz(n,s,0,19)
for(u=q+p,l=0;l<u;){k=h.ct(n)
if(k<16){j=l+1
s[l]=k
l=j}else{if(k===16){if(l===0)throw B.q(A.ail)
t=s[l-1]
k=3+h.ne(2)}else{k=k===17?3+h.ne(3):11+h.ne(7)
t=0}if(l+k>u)throw B.q(A.aik)
for(;i=k-1,k>0;k=i,l=j){j=l+1
s[l]=t}}}C.anz(n,s,0,q)
C.anz(m,s,q,p)
h.amC(n,m)}else throw B.q(A.aih)}while(x===0)
e=h.c
d=h.d
return e.length===d?e:B.wn(e,0,d)}}
C.o0.prototype={
I0(d,e){return this.a[d-1][e-1]}}
var z=a.updateTypes(["aj<o0>()"])
C.aQU.prototype={
$0(){var x=0,w=B.k(y.x),v,u=2,t=[],s,r,q,p,o
var $async$$0=B.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
x=7
return B.c($.xp().iA("assets/quran/quran-uthmani.txt.gz"),$async$$0)
case 7:s=e
x=8
return B.c(C.bVY(J.ft(J.bYf(s),s.byteOffset,s.byteLength)),$async$$0)
case 8:r=e
q=C.cmV(r)
v=q
x=1
break
u=2
x=6
break
case 4:u=3
o=t.pop()
$.c_9=null
throw o
x=6
break
case 3:x=2
break
case 6:case 1:return B.i(v,w)
case 2:return B.h(t.at(-1),w)}})
return B.j($async$$0,w)},
$S:z+0}
C.bX8.prototype={
$1(d){var x=d-1,w=C.bWz(A.dp[x].a[0]),v=this.a
if(D.c.n(w,v.a)||D.c.n(D.c.fP(w,B.aW("^\u0627\u0644",!0,!1,!1),""),v.a))return!0
x=A.dp[x].a[3]
v=B.aW("[\\s'\\-]",!0,!1,!1)
return D.c.n(B.bR(x.toLowerCase(),v,""),this.b)},
$S:86}
C.bUT.prototype={
$1(d){var x=d.h(0,0)
x.toString
return""+(x.charCodeAt(0)-1632)},
$S:57}
C.aQQ.prototype={
$0(){var x=0,w=B.k(y.y),v,u=2,t=[],s,r,q,p
var $async$$0=B.f(function(d,e){if(d===1){t.push(e)
x=u}for(;;)switch(x){case 0:u=4
r=new B.a7p("AmiriQuranMT",B.a([],y.m))
r.alr($.xp().iA("assets/quran/AmiriQuran-Regular.ttf"))
s=r
x=7
return B.c(s.vd(),$async$$0)
case 7:$.c6V=!0
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
$S:170};(function inheritance(){var x=a.inheritMany
x(B.a3,[C.Jc,C.bm0,C.o0])
x(B.np,[C.aQU,C.aQQ])
x(B.jv,[C.bX8,C.bUT])})()
var y=(function rtii(){var x=B.as
return{m:x("G<aj<kj>>"),s:x("G<o>"),t:x("G<x>"),o:x("bP"),g:x("hM"),a:x("a7<o>"),x:x("o0"),N:x("o"),Z:x("ao<x>"),y:x("Q"),S:x("x")}})();(function constants(){var x=a.makeConstList
A.aig=new B.eI("truncated deflate stream",null,null)
A.aih=new B.eI("bad block type",null,null)
A.aij=new B.eI("bad length symbol",null,null)
A.aik=new B.eI("too many lengths",null,null)
A.ail=new B.eI("repeat with no first length",null,null)
A.ain=new B.eI("bad huffman code",null,null)
A.aip=new B.eI("distance too far back",null,null)
A.aiq=new B.eI("not a gzip stream",null,null)
A.aup=x([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],y.t)
A.az4=x([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],y.t)
A.aYB=new B.bf(["\u0627\u0644\u0641\u0627\u062a\u062d\u0629",7,!0,"Al-Faatiha"])
A.aXD=new B.bf(["\u0627\u0644\u0628\u0642\u0631\u0629",286,!1,"Al-Baqara"])
A.aXq=new B.bf(["\u0622\u0644 \u0639\u0645\u0631\u0627\u0646",200,!1,"Aal-i-Imraan"])
A.aXY=new B.bf(["\u0627\u0644\u0646\u0633\u0627\u0621",176,!1,"An-Nisaa"])
A.aY8=new B.bf(["\u0627\u0644\u0645\u0627\u0626\u062f\u0629",120,!1,"Al-Maaida"])
A.aX8=new B.bf(["\u0627\u0644\u0623\u0646\u0639\u0627\u0645",165,!0,"Al-An'aam"])
A.aXB=new B.bf(["\u0627\u0644\u0623\u0639\u0631\u0627\u0641",206,!0,"Al-A'raaf"])
A.aXC=new B.bf(["\u0627\u0644\u0623\u0646\u0641\u0627\u0644",75,!1,"Al-Anfaal"])
A.aYE=new B.bf(["\u0627\u0644\u062a\u0648\u0628\u0629",129,!1,"At-Tawba"])
A.aX5=new B.bf(["\u064a\u0648\u0646\u0633",109,!0,"Yunus"])
A.aYq=new B.bf(["\u0647\u0648\u062f",123,!0,"Hud"])
A.aYl=new B.bf(["\u064a\u0648\u0633\u0641",111,!0,"Yusuf"])
A.aXO=new B.bf(["\u0627\u0644\u0631\u0639\u062f",43,!1,"Ar-Ra'd"])
A.aYw=new B.bf(["\u0627\u0628\u0631\u0627\u0647\u064a\u0645",52,!0,"Ibrahim"])
A.aXW=new B.bf(["\u0627\u0644\u062d\u062c\u0631",99,!0,"Al-Hijr"])
A.aYO=new B.bf(["\u0627\u0644\u0646\u062d\u0644",128,!0,"An-Nahl"])
A.aX6=new B.bf(["\u0627\u0644\u0625\u0633\u0631\u0627\u0621",111,!0,"Al-Israa"])
A.aYG=new B.bf(["\u0627\u0644\u0643\u0647\u0641",110,!0,"Al-Kahf"])
A.aXH=new B.bf(["\u0645\u0631\u064a\u0645",98,!0,"Maryam"])
A.aYa=new B.bf(["\u0637\u0647",135,!0,"Taa-Haa"])
A.aYv=new B.bf(["\u0627\u0644\u0623\u0646\u0628\u064a\u0627\u0621",112,!0,"Al-Anbiyaa"])
A.aXo=new B.bf(["\u0627\u0644\u062d\u062c",78,!1,"Al-Hajj"])
A.aYC=new B.bf(["\u0627\u0644\u0645\u0624\u0645\u0646\u0648\u0646",118,!0,"Al-Muminoon"])
A.aXR=new B.bf(["\u0627\u0644\u0646\u0648\u0631",64,!1,"An-Noor"])
A.aYb=new B.bf(["\u0627\u0644\u0641\u0631\u0642\u0627\u0646",77,!0,"Al-Furqaan"])
A.aYi=new B.bf(["\u0627\u0644\u0634\u0639\u0631\u0627\u0621",227,!0,"Ash-Shu'araa"])
A.aXT=new B.bf(["\u0627\u0644\u0646\u0645\u0644",93,!0,"An-Naml"])
A.aXm=new B.bf(["\u0627\u0644\u0642\u0635\u0635",88,!0,"Al-Qasas"])
A.aXa=new B.bf(["\u0627\u0644\u0639\u0646\u0643\u0628\u0648\u062a",69,!0,"Al-Ankaboot"])
A.aYN=new B.bf(["\u0627\u0644\u0631\u0648\u0645",60,!0,"Ar-Room"])
A.aYr=new B.bf(["\u0644\u0642\u0645\u0627\u0646",34,!0,"Luqman"])
A.aYx=new B.bf(["\u0627\u0644\u0633\u062c\u062f\u0629",30,!0,"As-Sajda"])
A.aX4=new B.bf(["\u0627\u0644\u0623\u062d\u0632\u0627\u0628",73,!1,"Al-Ahzaab"])
A.aXx=new B.bf(["\u0633\u0628\u0625",54,!0,"Saba"])
A.aXN=new B.bf(["\u0641\u0627\u0637\u0631",45,!0,"Faatir"])
A.aX9=new B.bf(["\u064a\u0633",83,!0,"Yaseen"])
A.aYc=new B.bf(["\u0627\u0644\u0635\u0627\u0641\u0627\u062a",182,!0,"As-Saaffaat"])
A.aXv=new B.bf(["\u0635",88,!0,"Saad"])
A.aXL=new B.bf(["\u0627\u0644\u0632\u0645\u0631",75,!0,"Az-Zumar"])
A.aXP=new B.bf(["\u063a\u0627\u0641\u0631",85,!0,"Al-Ghaafir"])
A.aY0=new B.bf(["\u0641\u0635\u0644\u062a",54,!0,"Fussilat"])
A.aXQ=new B.bf(["\u0627\u0644\u0634\u0648\u0631\u0649",53,!0,"Ash-Shura"])
A.aXc=new B.bf(["\u0627\u0644\u0632\u062e\u0631\u0641",89,!0,"Az-Zukhruf"])
A.aXi=new B.bf(["\u0627\u0644\u062f\u062e\u0627\u0646",59,!0,"Ad-Dukhaan"])
A.aYy=new B.bf(["\u0627\u0644\u062c\u0627\u062b\u064a\u0629",37,!0,"Al-Jaathiya"])
A.aYn=new B.bf(["\u0627\u0644\u0623\u062d\u0642\u0627\u0641",35,!0,"Al-Ahqaf"])
A.aXM=new B.bf(["\u0645\u062d\u0645\u062f",38,!1,"Muhammad"])
A.aXV=new B.bf(["\u0627\u0644\u0641\u062a\u062d",29,!1,"Al-Fath"])
A.aYF=new B.bf(["\u0627\u0644\u062d\u062c\u0631\u0627\u062a",18,!1,"Al-Hujuraat"])
A.aY2=new B.bf(["\u0642",45,!0,"Qaaf"])
A.aXt=new B.bf(["\u0627\u0644\u0630\u0627\u0631\u064a\u0627\u062a",60,!0,"Adh-Dhaariyat"])
A.aXI=new B.bf(["\u0627\u0644\u0637\u0648\u0631",49,!0,"At-Tur"])
A.aYp=new B.bf(["\u0627\u0644\u0646\u062c\u0645",62,!0,"An-Najm"])
A.aYD=new B.bf(["\u0627\u0644\u0642\u0645\u0631",55,!0,"Al-Qamar"])
A.aYK=new B.bf(["\u0627\u0644\u0631\u062d\u0645\u0646",78,!1,"Ar-Rahmaan"])
A.aXK=new B.bf(["\u0627\u0644\u0648\u0627\u0642\u0639\u0629",96,!0,"Al-Waaqia"])
A.aYg=new B.bf(["\u0627\u0644\u062d\u062f\u064a\u062f",29,!1,"Al-Hadid"])
A.aY5=new B.bf(["\u0627\u0644\u0645\u062c\u0627\u062f\u0644\u0629",22,!1,"Al-Mujaadila"])
A.aX2=new B.bf(["\u0627\u0644\u062d\u0634\u0631",24,!1,"Al-Hashr"])
A.aXj=new B.bf(["\u0627\u0644\u0645\u0645\u062a\u062d\u0646\u0629",13,!1,"Al-Mumtahana"])
A.aXs=new B.bf(["\u0627\u0644\u0635\u0641",14,!1,"As-Saff"])
A.aXg=new B.bf(["\u0627\u0644\u062c\u0645\u0639\u0629",11,!1,"Al-Jumu'a"])
A.aY3=new B.bf(["\u0627\u0644\u0645\u0646\u0627\u0641\u0642\u0648\u0646",11,!1,"Al-Munaafiqoon"])
A.aXk=new B.bf(["\u0627\u0644\u062a\u063a\u0627\u0628\u0646",18,!1,"At-Taghaabun"])
A.aYQ=new B.bf(["\u0627\u0644\u0637\u0644\u0627\u0642",12,!1,"At-Talaaq"])
A.aYA=new B.bf(["\u0627\u0644\u062a\u062d\u0631\u064a\u0645",12,!1,"At-Tahrim"])
A.aYM=new B.bf(["\u0627\u0644\u0645\u0644\u0643",30,!0,"Al-Mulk"])
A.aXJ=new B.bf(["\u0627\u0644\u0642\u0644\u0645",52,!0,"Al-Qalam"])
A.aYJ=new B.bf(["\u0627\u0644\u062d\u0627\u0642\u0629",52,!0,"Al-Haaqqa"])
A.aYd=new B.bf(["\u0627\u0644\u0645\u0639\u0627\u0631\u062c",44,!0,"Al-Ma'aarij"])
A.aXE=new B.bf(["\u0646\u0648\u062d",28,!0,"Nooh"])
A.aY1=new B.bf(["\u0627\u0644\u062c\u0646",28,!0,"Al-Jinn"])
A.aYH=new B.bf(["\u0627\u0644\u0645\u0632\u0645\u0644",20,!0,"Al-Muzzammil"])
A.aYL=new B.bf(["\u0627\u0644\u0645\u062f\u062b\u0631",56,!0,"Al-Muddaththir"])
A.aY7=new B.bf(["\u0627\u0644\u0642\u064a\u0627\u0645\u0629",40,!0,"Al-Qiyaama"])
A.aXX=new B.bf(["\u0627\u0644\u0627\u0646\u0633\u0627\u0646",31,!1,"Al-Insaan"])
A.aX7=new B.bf(["\u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a",50,!0,"Al-Mursalaat"])
A.aY_=new B.bf(["\u0627\u0644\u0646\u0628\u0625",40,!0,"An-Naba"])
A.aYh=new B.bf(["\u0627\u0644\u0646\u0627\u0632\u0639\u0627\u062a",46,!0,"An-Naazi'aat"])
A.aYo=new B.bf(["\u0639\u0628\u0633",42,!0,"Abasa"])
A.aXG=new B.bf(["\u0627\u0644\u062a\u0643\u0648\u064a\u0631",29,!0,"At-Takwir"])
A.aXA=new B.bf(["\u0627\u0644\u0625\u0646\u0641\u0637\u0627\u0631",19,!0,"Al-Infitaar"])
A.aY4=new B.bf(["\u0627\u0644\u0645\u0637\u0641\u0641\u064a\u0646",36,!0,"Al-Mutaffifin"])
A.aYm=new B.bf(["\u0627\u0644\u0625\u0646\u0634\u0642\u0627\u0642",25,!0,"Al-Inshiqaaq"])
A.aYj=new B.bf(["\u0627\u0644\u0628\u0631\u0648\u062c",22,!0,"Al-Burooj"])
A.aXZ=new B.bf(["\u0627\u0644\u0637\u0627\u0631\u0642",17,!0,"At-Taariq"])
A.aXl=new B.bf(["\u0627\u0644\u0623\u0639\u0644\u0649",19,!0,"Al-A'laa"])
A.aXF=new B.bf(["\u0627\u0644\u063a\u0627\u0634\u064a\u0629",26,!0,"Al-Ghaashiya"])
A.aYs=new B.bf(["\u0627\u0644\u0641\u062c\u0631",30,!0,"Al-Fajr"])
A.aY6=new B.bf(["\u0627\u0644\u0628\u0644\u062f",20,!0,"Al-Balad"])
A.aXz=new B.bf(["\u0627\u0644\u0634\u0645\u0633",15,!0,"Ash-Shams"])
A.aXy=new B.bf(["\u0627\u0644\u0644\u064a\u0644",21,!0,"Al-Lail"])
A.aXw=new B.bf(["\u0627\u0644\u0636\u062d\u0649",11,!0,"Ad-Dhuhaa"])
A.aXu=new B.bf(["\u0627\u0644\u0634\u0631\u062d",8,!0,"Ash-Sharh"])
A.aXr=new B.bf(["\u0627\u0644\u062a\u064a\u0646",8,!0,"At-Tin"])
A.aYe=new B.bf(["\u0627\u0644\u0639\u0644\u0642",19,!0,"Al-Alaq"])
A.aXf=new B.bf(["\u0627\u0644\u0642\u062f\u0631",5,!0,"Al-Qadr"])
A.aYI=new B.bf(["\u0627\u0644\u0628\u064a\u0646\u0629",8,!1,"Al-Bayyina"])
A.aX3=new B.bf(["\u0627\u0644\u0632\u0644\u0632\u0644\u0629",8,!1,"Az-Zalzala"])
A.aXU=new B.bf(["\u0627\u0644\u0639\u0627\u062f\u064a\u0627\u062a",11,!0,"Al-Aadiyaat"])
A.aXd=new B.bf(["\u0627\u0644\u0642\u0627\u0631\u0639\u0629",11,!0,"Al-Qaari'a"])
A.aXb=new B.bf(["\u0627\u0644\u062a\u0643\u0627\u062b\u0631",8,!0,"At-Takaathur"])
A.aXh=new B.bf(["\u0627\u0644\u0639\u0635\u0631",3,!0,"Al-Asr"])
A.aXn=new B.bf(["\u0627\u0644\u0647\u0645\u0632\u0629",9,!0,"Al-Humaza"])
A.aXp=new B.bf(["\u0627\u0644\u0641\u064a\u0644",5,!0,"Al-Fil"])
A.aYf=new B.bf(["\u0642\u0631\u064a\u0634",4,!0,"Quraish"])
A.aXe=new B.bf(["\u0627\u0644\u0645\u0627\u0639\u0648\u0646",7,!0,"Al-Maa'un"])
A.aYu=new B.bf(["\u0627\u0644\u0643\u0648\u062b\u0631",3,!0,"Al-Kawthar"])
A.aYk=new B.bf(["\u0627\u0644\u0643\u0627\u0641\u0631\u0648\u0646",6,!0,"Al-Kaafiroon"])
A.aYt=new B.bf(["\u0627\u0644\u0646\u0635\u0631",3,!1,"An-Nasr"])
A.aYP=new B.bf(["\u0627\u0644\u0645\u0633\u062f",5,!0,"Al-Masad"])
A.aYz=new B.bf(["\u0627\u0644\u0625\u062e\u0644\u0627\u0635",4,!0,"Al-Ikhlaas"])
A.aXS=new B.bf(["\u0627\u0644\u0641\u0644\u0642",5,!0,"Al-Falaq"])
A.aY9=new B.bf(["\u0627\u0644\u0646\u0627\u0633",6,!0,"An-Naas"])
A.dp=x([A.aYB,A.aXD,A.aXq,A.aXY,A.aY8,A.aX8,A.aXB,A.aXC,A.aYE,A.aX5,A.aYq,A.aYl,A.aXO,A.aYw,A.aXW,A.aYO,A.aX6,A.aYG,A.aXH,A.aYa,A.aYv,A.aXo,A.aYC,A.aXR,A.aYb,A.aYi,A.aXT,A.aXm,A.aXa,A.aYN,A.aYr,A.aYx,A.aX4,A.aXx,A.aXN,A.aX9,A.aYc,A.aXv,A.aXL,A.aXP,A.aY0,A.aXQ,A.aXc,A.aXi,A.aYy,A.aYn,A.aXM,A.aXV,A.aYF,A.aY2,A.aXt,A.aXI,A.aYp,A.aYD,A.aYK,A.aXK,A.aYg,A.aY5,A.aX2,A.aXj,A.aXs,A.aXg,A.aY3,A.aXk,A.aYQ,A.aYA,A.aYM,A.aXJ,A.aYJ,A.aYd,A.aXE,A.aY1,A.aYH,A.aYL,A.aY7,A.aXX,A.aX7,A.aY_,A.aYh,A.aYo,A.aXG,A.aXA,A.aY4,A.aYm,A.aYj,A.aXZ,A.aXl,A.aXF,A.aYs,A.aY6,A.aXz,A.aXy,A.aXw,A.aXu,A.aXr,A.aYe,A.aXf,A.aYI,A.aX3,A.aXU,A.aXd,A.aXb,A.aXh,A.aXn,A.aXp,A.aYf,A.aXe,A.aYu,A.aYk,A.aYt,A.aYP,A.aYz,A.aXS,A.aY9],B.as("G<+(o,x,Q,o)>"))
A.aGI=x([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],y.t)
A.aHe=x([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],y.t)
A.aHn=x([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],y.t)
A.zQ=new B.eQ(" ",null,null,D.bu,null,null,null,null,null,null,null)})();(function staticFields(){$.c_9=null
$.c6U=null
$.c6V=!1})();(function lazyInitializers(){var x=a.lazyFinal
x($,"cDB","cfg",()=>C.bWz("\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0640\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650"))})()};
(a=>{a["iR79aMtalL1sHN6hFM0eZr31rdg="]=a.current})($__dart_deferred_initializers__);