((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var B,D,C={
cCY(d){var x,w,v,u,t=d.length
if(t<18||d[0]!==31||d[1]!==139||d[2]!==8)throw B.q(A.akM)
x=d[3]
w=(x&4)!==0?10+(2+((d[10]|d[11]<<8)>>>0)):10
if((x&8)!==0){for(;v=w+1,d[w]!==0;w=v);w=v}if((x&16)!==0){for(;v=w+1,d[w]!==0;w=v);w=v}if((x&2)!==0)w+=2
u=(d[t-4]|d[t-3]<<8|d[t-2]<<16|d[t-1]<<24)>>>0
t=u>0?u:65536
return new C.bou(d,w,new Uint8Array(t)).ath()},
ap0(d,e,f,g){var x,w,v,u,t,s,r,q,p,o
for(x=d.a,w=x.$flags|0,v=0;v<16;++v){w&2&&B.aD(x)
x[v]=0}for(u=0;u<g;++u){t=e[f+u]
s=x[t]
w&2&&B.aD(x)
x[t]=s+1}r=B.ck(16,0,!1,y.e)
for(q=1;q<15;q=p){p=q+1
r[p]=r[q]+x[q]}for(x=d.b,w=x.$flags|0,u=0;u<g;++u){o=e[f+u]
if(o!==0){t=r[o]
r[o]=t+1
w&2&&B.aD(x)
x[t]=u}}},
K2:function K2(d,e){this.a=d
this.b=e},
bou:function bou(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.f=_.e=_.d=0},
ayf(d){return C.cCZ(d)},
cCZ(d){var x=0,w=B.j(y.g),v,u=2,t=[],s,r,q,p,o,n,m,l,k,j,i,h
var $async$ayf=B.e(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:if(d.length<2||d[0]!==31||d[1]!==139){v=D.ao.cs(d)
x=1
break}u=4
k=b.G
s=k.DecompressionStream
r=k.Response
x=s!=null&&r!=null?7:8
break
case 7:k=y.k
j=y.h
q=B.rP(k.a(s),"gzip",null,j)
p=B.rP(k.a(r),d,null,j)
o=B.cV(p.body)
n=B.cV(B.cN(o,"pipeThrough",q,null,null,null))
m=B.rP(r,n,null,j)
x=9
return B.c(B.ez(B.cV(B.cN(m,"text",null,null,null,null)),y.g),$async$ayf)
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
case 6:v=D.ao.cs(C.cCY(d))
x=1
break
case 1:return B.h(v,w)
case 2:return B.f(t.at(-1),w)}})
return B.i($async$ayf,w)}},A
B=c[0]
D=c[2]
C=a.updateHolder(c[14],C)
A=c[28]
C.K2.prototype={}
C.bou.prototype={
nn(d){var x,w,v,u,t=this,s=t.e
for(x=t.a,w=x.length;v=t.f,v<d;){u=t.b
if(u>=w)throw B.q(A.akC)
t.b=u+1
s=(s|D.j.DS(x[u],v))>>>0
t.f=v+8}t.e=D.j.r1(s,d)
t.f=v-d
return(s&D.j.Q7(1,d)-1)>>>0},
a04(d){var x,w=this,v=w.d,u=w.c,t=u.length
if(v===t){x=new Uint8Array(t*2)
D.az.iH(x,0,v,u)
w.c=x
v=x}else v=u
u=w.d++
v.$flags&2&&B.aD(v)
v[u]=d},
cs(d){var x,w,v,u,t,s
for(x=d.a,w=0,v=0,u=0,t=1;t<16;++t){w=(w|this.nn(1))>>>0
s=x[t]
if(w-s<v)return d.b[u+(w-v)]
u+=s
v=v+s<<1>>>0
w=w<<1}throw B.q(A.akJ)},
anu(d,e){var x,w,v,u,t,s=this
for(;;){x=s.cs(d)
if(x<256)s.a04(x)
else if(x===256)return
else{x-=257
if(x>=29)throw B.q(A.akF)
w=A.aK7[x]+s.nn(A.ax8[x])
v=s.cs(e)
u=A.aKg[v]+s.nn(A.aBV[v])
if(u>s.d)throw B.q(A.akL)
for(t=0;t<w;++t)s.a04(s.c[s.d-u])}}},
ath(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h=this,g=B.cU(),f=B.cU(),e=y.e,d=h.a,a0=!1
do{x=h.nn(1)
w=h.nn(2)
if(w===0){v=h.f=h.e=0
u=h.b
t=(d[u]|d[u+1]<<8)>>>0
h.b=u+4
for(;v<t;++v)h.a04(d[h.b++])}else if(w===1){if(!a0){s=B.ck(318,0,!1,e)
for(r=0;r<144;++r)s[r]=8
for(r=144;r<256;++r)s[r]=9
for(r=256;r<280;++r)s[r]=7
for(r=280;r<288;++r)s[r]=8
for(r=288;r<318;++r)s[r]=5
u=new Int16Array(16)
g.sfE(new C.K2(u,new Int16Array(288)))
u=new Int16Array(16)
f.sfE(new C.K2(u,new Int16Array(30)))
C.ap0(g.bw(),s,0,288)
C.ap0(f.bw(),s,288,30)
a0=!0}h.anu(g.bw(),f.bw())}else if(w===2){q=h.nn(5)+257
p=h.nn(5)+1
o=h.nn(4)+4
s=B.ck(320,0,!1,e)
for(v=0;v<o;++v)s[A.aJA[v]]=h.nn(3)
u=new Int16Array(16)
n=new C.K2(u,new Int16Array(288))
u=new Int16Array(16)
m=new C.K2(u,new Int16Array(30))
C.ap0(n,s,0,19)
for(u=q+p,l=0;l<u;){k=h.cs(n)
if(k<16){j=l+1
s[l]=k
l=j}else{if(k===16){if(l===0)throw B.q(A.akH)
t=s[l-1]
k=3+h.nn(2)}else{k=k===17?3+h.nn(3):11+h.nn(7)
t=0}if(l+k>u)throw B.q(A.akG)
for(;i=k-1,k>0;k=i,l=j){j=l+1
s[l]=t}}}C.ap0(n,s,0,q)
C.ap0(m,s,q,p)
h.anu(n,m)}else throw B.q(A.akD)}while(x===0)
e=h.c
d=h.d
return e.length===d?e:B.xd(e,0,d)}}
var z=a.updateTypes([]);(function inheritance(){var x=a.inheritMany
x(B.a5,[C.K2,C.bou])})()
var y={b:B.ae("F<x>"),h:B.ae("bM"),k:B.ae("hE"),g:B.ae("o"),e:B.ae("x")};(function constants(){var x=a.makeConstList
A.akC=new B.eR("truncated deflate stream",null,null)
A.akD=new B.eR("bad block type",null,null)
A.akF=new B.eR("bad length symbol",null,null)
A.akG=new B.eR("too many lengths",null,null)
A.akH=new B.eR("repeat with no first length",null,null)
A.akJ=new B.eR("bad huffman code",null,null)
A.akL=new B.eR("distance too far back",null,null)
A.akM=new B.eR("not a gzip stream",null,null)
A.ax8=x([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],y.b)
A.aBV=x([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],y.b)
A.b1V=new B.aX(["\u0627\u0644\u0641\u0627\u062a\u062d\u0629",7,!0,"Al-Faatiha"])
A.b0M=new B.aX(["\u0627\u0644\u0628\u0642\u0631\u0629",286,!1,"Al-Baqara"])
A.b0v=new B.aX(["\u0622\u0644 \u0639\u0645\u0631\u0627\u0646",200,!1,"Aal-i-Imraan"])
A.b19=new B.aX(["\u0627\u0644\u0646\u0633\u0627\u0621",176,!1,"An-Nisaa"])
A.b1l=new B.aX(["\u0627\u0644\u0645\u0627\u0626\u062f\u0629",120,!1,"Al-Maaida"])
A.b0b=new B.aX(["\u0627\u0644\u0623\u0646\u0639\u0627\u0645",165,!0,"Al-An'aam"])
A.b0K=new B.aX(["\u0627\u0644\u0623\u0639\u0631\u0627\u0641",206,!0,"Al-A'raaf"])
A.b0L=new B.aX(["\u0627\u0644\u0623\u0646\u0641\u0627\u0644",75,!1,"Al-Anfaal"])
A.b1Z=new B.aX(["\u0627\u0644\u062a\u0648\u0628\u0629",129,!1,"At-Tawba"])
A.b07=new B.aX(["\u064a\u0648\u0646\u0633",109,!0,"Yunus"])
A.b1H=new B.aX(["\u0647\u0648\u062f",123,!0,"Hud"])
A.b1z=new B.aX(["\u064a\u0648\u0633\u0641",111,!0,"Yusuf"])
A.b0Y=new B.aX(["\u0627\u0644\u0631\u0639\u062f",43,!1,"Ar-Ra'd"])
A.b1P=new B.aX(["\u0627\u0628\u0631\u0627\u0647\u064a\u0645",52,!0,"Ibrahim"])
A.b15=new B.aX(["\u0627\u0644\u062d\u062c\u0631",99,!0,"Al-Hijr"])
A.b29=new B.aX(["\u0627\u0644\u0646\u062d\u0644",128,!0,"An-Nahl"])
A.b09=new B.aX(["\u0627\u0644\u0625\u0633\u0631\u0627\u0621",111,!0,"Al-Israa"])
A.b20=new B.aX(["\u0627\u0644\u0643\u0647\u0641",110,!0,"Al-Kahf"])
A.b0Q=new B.aX(["\u0645\u0631\u064a\u0645",98,!0,"Maryam"])
A.b1o=new B.aX(["\u0637\u0647",135,!0,"Taa-Haa"])
A.b1N=new B.aX(["\u0627\u0644\u0623\u0646\u0628\u064a\u0627\u0621",112,!0,"Al-Anbiyaa"])
A.b0t=new B.aX(["\u0627\u0644\u062d\u062c",78,!1,"Al-Hajj"])
A.b1W=new B.aX(["\u0627\u0644\u0645\u0624\u0645\u0646\u0648\u0646",118,!0,"Al-Muminoon"])
A.b10=new B.aX(["\u0627\u0644\u0646\u0648\u0631",64,!1,"An-Noor"])
A.b1p=new B.aX(["\u0627\u0644\u0641\u0631\u0642\u0627\u0646",77,!0,"Al-Furqaan"])
A.b1w=new B.aX(["\u0627\u0644\u0634\u0639\u0631\u0627\u0621",227,!0,"Ash-Shu'araa"])
A.b12=new B.aX(["\u0627\u0644\u0646\u0645\u0644",93,!0,"An-Naml"])
A.b0r=new B.aX(["\u0627\u0644\u0642\u0635\u0635",88,!0,"Al-Qasas"])
A.b0d=new B.aX(["\u0627\u0644\u0639\u0646\u0643\u0628\u0648\u062a",69,!0,"Al-Ankaboot"])
A.b28=new B.aX(["\u0627\u0644\u0631\u0648\u0645",60,!0,"Ar-Room"])
A.b1I=new B.aX(["\u0644\u0642\u0645\u0627\u0646",34,!0,"Luqman"])
A.b1Q=new B.aX(["\u0627\u0644\u0633\u062c\u062f\u0629",30,!0,"As-Sajda"])
A.b06=new B.aX(["\u0627\u0644\u0623\u062d\u0632\u0627\u0628",73,!1,"Al-Ahzaab"])
A.b0G=new B.aX(["\u0633\u0628\u0625",54,!0,"Saba"])
A.b0X=new B.aX(["\u0641\u0627\u0637\u0631",45,!0,"Faatir"])
A.b0c=new B.aX(["\u064a\u0633",83,!0,"Yaseen"])
A.b1q=new B.aX(["\u0627\u0644\u0635\u0627\u0641\u0627\u062a",182,!0,"As-Saaffaat"])
A.b0D=new B.aX(["\u0635",88,!0,"Saad"])
A.b0V=new B.aX(["\u0627\u0644\u0632\u0645\u0631",75,!0,"Az-Zumar"])
A.b0Z=new B.aX(["\u063a\u0627\u0641\u0631",85,!0,"Al-Ghaafir"])
A.b1c=new B.aX(["\u0641\u0635\u0644\u062a",54,!0,"Fussilat"])
A.b1_=new B.aX(["\u0627\u0644\u0634\u0648\u0631\u0649",53,!0,"Ash-Shura"])
A.b0f=new B.aX(["\u0627\u0644\u0632\u062e\u0631\u0641",89,!0,"Az-Zukhruf"])
A.b0l=new B.aX(["\u0627\u0644\u062f\u062e\u0627\u0646",59,!0,"Ad-Dukhaan"])
A.b1R=new B.aX(["\u0627\u0644\u062c\u0627\u062b\u064a\u0629",37,!0,"Al-Jaathiya"])
A.b1D=new B.aX(["\u0627\u0644\u0623\u062d\u0642\u0627\u0641",35,!0,"Al-Ahqaf"])
A.b0W=new B.aX(["\u0645\u062d\u0645\u062f",38,!1,"Muhammad"])
A.b14=new B.aX(["\u0627\u0644\u0641\u062a\u062d",29,!1,"Al-Fath"])
A.b2_=new B.aX(["\u0627\u0644\u062d\u062c\u0631\u0627\u062a",18,!1,"Al-Hujuraat"])
A.b1e=new B.aX(["\u0642",45,!0,"Qaaf"])
A.b0B=new B.aX(["\u0627\u0644\u0630\u0627\u0631\u064a\u0627\u062a",60,!0,"Adh-Dhaariyat"])
A.b0S=new B.aX(["\u0627\u0644\u0637\u0648\u0631",49,!0,"At-Tur"])
A.b1G=new B.aX(["\u0627\u0644\u0646\u062c\u0645",62,!0,"An-Najm"])
A.b1X=new B.aX(["\u0627\u0644\u0642\u0645\u0631",55,!0,"Al-Qamar"])
A.b25=new B.aX(["\u0627\u0644\u0631\u062d\u0645\u0646",78,!1,"Ar-Rahmaan"])
A.b0U=new B.aX(["\u0627\u0644\u0648\u0627\u0642\u0639\u0629",96,!0,"Al-Waaqia"])
A.b1u=new B.aX(["\u0627\u0644\u062d\u062f\u064a\u062f",29,!1,"Al-Hadid"])
A.b1i=new B.aX(["\u0627\u0644\u0645\u062c\u0627\u062f\u0644\u0629",22,!1,"Al-Mujaadila"])
A.b03=new B.aX(["\u0627\u0644\u062d\u0634\u0631",24,!1,"Al-Hashr"])
A.b0o=new B.aX(["\u0627\u0644\u0645\u0645\u062a\u062d\u0646\u0629",13,!1,"Al-Mumtahana"])
A.b0z=new B.aX(["\u0627\u0644\u0635\u0641",14,!1,"As-Saff"])
A.b0j=new B.aX(["\u0627\u0644\u062c\u0645\u0639\u0629",11,!1,"Al-Jumu'a"])
A.b1f=new B.aX(["\u0627\u0644\u0645\u0646\u0627\u0641\u0642\u0648\u0646",11,!1,"Al-Munaafiqoon"])
A.b0p=new B.aX(["\u0627\u0644\u062a\u063a\u0627\u0628\u0646",18,!1,"At-Taghaabun"])
A.b2b=new B.aX(["\u0627\u0644\u0637\u0644\u0627\u0642",12,!1,"At-Talaaq"])
A.b1U=new B.aX(["\u0627\u0644\u062a\u062d\u0631\u064a\u0645",12,!1,"At-Tahrim"])
A.b27=new B.aX(["\u0627\u0644\u0645\u0644\u0643",30,!0,"Al-Mulk"])
A.b0T=new B.aX(["\u0627\u0644\u0642\u0644\u0645",52,!0,"Al-Qalam"])
A.b24=new B.aX(["\u0627\u0644\u062d\u0627\u0642\u0629",52,!0,"Al-Haaqqa"])
A.b1r=new B.aX(["\u0627\u0644\u0645\u0639\u0627\u0631\u062c",44,!0,"Al-Ma'aarij"])
A.b0N=new B.aX(["\u0646\u0648\u062d",28,!0,"Nooh"])
A.b1d=new B.aX(["\u0627\u0644\u062c\u0646",28,!0,"Al-Jinn"])
A.b22=new B.aX(["\u0627\u0644\u0645\u0632\u0645\u0644",20,!0,"Al-Muzzammil"])
A.b26=new B.aX(["\u0627\u0644\u0645\u062f\u062b\u0631",56,!0,"Al-Muddaththir"])
A.b1k=new B.aX(["\u0627\u0644\u0642\u064a\u0627\u0645\u0629",40,!0,"Al-Qiyaama"])
A.b18=new B.aX(["\u0627\u0644\u0627\u0646\u0633\u0627\u0646",31,!1,"Al-Insaan"])
A.b0a=new B.aX(["\u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a",50,!0,"Al-Mursalaat"])
A.b1b=new B.aX(["\u0627\u0644\u0646\u0628\u0625",40,!0,"An-Naba"])
A.b1v=new B.aX(["\u0627\u0644\u0646\u0627\u0632\u0639\u0627\u062a",46,!0,"An-Naazi'aat"])
A.b1F=new B.aX(["\u0639\u0628\u0633",42,!0,"Abasa"])
A.b0P=new B.aX(["\u0627\u0644\u062a\u0643\u0648\u064a\u0631",29,!0,"At-Takwir"])
A.b0J=new B.aX(["\u0627\u0644\u0625\u0646\u0641\u0637\u0627\u0631",19,!0,"Al-Infitaar"])
A.b1g=new B.aX(["\u0627\u0644\u0645\u0637\u0641\u0641\u064a\u0646",36,!0,"Al-Mutaffifin"])
A.b1A=new B.aX(["\u0627\u0644\u0625\u0646\u0634\u0642\u0627\u0642",25,!0,"Al-Inshiqaaq"])
A.b1x=new B.aX(["\u0627\u0644\u0628\u0631\u0648\u062c",22,!0,"Al-Burooj"])
A.b1a=new B.aX(["\u0627\u0644\u0637\u0627\u0631\u0642",17,!0,"At-Taariq"])
A.b0q=new B.aX(["\u0627\u0644\u0623\u0639\u0644\u0649",19,!0,"Al-A'laa"])
A.b0O=new B.aX(["\u0627\u0644\u063a\u0627\u0634\u064a\u0629",26,!0,"Al-Ghaashiya"])
A.b1J=new B.aX(["\u0627\u0644\u0641\u062c\u0631",30,!0,"Al-Fajr"])
A.b1j=new B.aX(["\u0627\u0644\u0628\u0644\u062f",20,!0,"Al-Balad"])
A.b0I=new B.aX(["\u0627\u0644\u0634\u0645\u0633",15,!0,"Ash-Shams"])
A.b0H=new B.aX(["\u0627\u0644\u0644\u064a\u0644",21,!0,"Al-Lail"])
A.b0E=new B.aX(["\u0627\u0644\u0636\u062d\u0649",11,!0,"Ad-Dhuhaa"])
A.b0C=new B.aX(["\u0627\u0644\u0634\u0631\u062d",8,!0,"Ash-Sharh"])
A.b0x=new B.aX(["\u0627\u0644\u062a\u064a\u0646",8,!0,"At-Tin"])
A.b1s=new B.aX(["\u0627\u0644\u0639\u0644\u0642",19,!0,"Al-Alaq"])
A.b0i=new B.aX(["\u0627\u0644\u0642\u062f\u0631",5,!0,"Al-Qadr"])
A.b23=new B.aX(["\u0627\u0644\u0628\u064a\u0646\u0629",8,!1,"Al-Bayyina"])
A.b04=new B.aX(["\u0627\u0644\u0632\u0644\u0632\u0644\u0629",8,!1,"Az-Zalzala"])
A.b13=new B.aX(["\u0627\u0644\u0639\u0627\u062f\u064a\u0627\u062a",11,!0,"Al-Aadiyaat"])
A.b0g=new B.aX(["\u0627\u0644\u0642\u0627\u0631\u0639\u0629",11,!0,"Al-Qaari'a"])
A.b0e=new B.aX(["\u0627\u0644\u062a\u0643\u0627\u062b\u0631",8,!0,"At-Takaathur"])
A.b0k=new B.aX(["\u0627\u0644\u0639\u0635\u0631",3,!0,"Al-Asr"])
A.b0s=new B.aX(["\u0627\u0644\u0647\u0645\u0632\u0629",9,!0,"Al-Humaza"])
A.b0u=new B.aX(["\u0627\u0644\u0641\u064a\u0644",5,!0,"Al-Fil"])
A.b1t=new B.aX(["\u0642\u0631\u064a\u0634",4,!0,"Quraish"])
A.b0h=new B.aX(["\u0627\u0644\u0645\u0627\u0639\u0648\u0646",7,!0,"Al-Maa'un"])
A.b1M=new B.aX(["\u0627\u0644\u0643\u0648\u062b\u0631",3,!0,"Al-Kawthar"])
A.b1y=new B.aX(["\u0627\u0644\u0643\u0627\u0641\u0631\u0648\u0646",6,!0,"Al-Kaafiroon"])
A.b1K=new B.aX(["\u0627\u0644\u0646\u0635\u0631",3,!1,"An-Nasr"])
A.b2a=new B.aX(["\u0627\u0644\u0645\u0633\u062f",5,!0,"Al-Masad"])
A.b1S=new B.aX(["\u0627\u0644\u0625\u062e\u0644\u0627\u0635",4,!0,"Al-Ikhlaas"])
A.b11=new B.aX(["\u0627\u0644\u0641\u0644\u0642",5,!0,"Al-Falaq"])
A.b1n=new B.aX(["\u0627\u0644\u0646\u0627\u0633",6,!0,"An-Naas"])
A.cN=x([A.b1V,A.b0M,A.b0v,A.b19,A.b1l,A.b0b,A.b0K,A.b0L,A.b1Z,A.b07,A.b1H,A.b1z,A.b0Y,A.b1P,A.b15,A.b29,A.b09,A.b20,A.b0Q,A.b1o,A.b1N,A.b0t,A.b1W,A.b10,A.b1p,A.b1w,A.b12,A.b0r,A.b0d,A.b28,A.b1I,A.b1Q,A.b06,A.b0G,A.b0X,A.b0c,A.b1q,A.b0D,A.b0V,A.b0Z,A.b1c,A.b1_,A.b0f,A.b0l,A.b1R,A.b1D,A.b0W,A.b14,A.b2_,A.b1e,A.b0B,A.b0S,A.b1G,A.b1X,A.b25,A.b0U,A.b1u,A.b1i,A.b03,A.b0o,A.b0z,A.b0j,A.b1f,A.b0p,A.b2b,A.b1U,A.b27,A.b0T,A.b24,A.b1r,A.b0N,A.b1d,A.b22,A.b26,A.b1k,A.b18,A.b0a,A.b1b,A.b1v,A.b1F,A.b0P,A.b0J,A.b1g,A.b1A,A.b1x,A.b1a,A.b0q,A.b0O,A.b1J,A.b1j,A.b0I,A.b0H,A.b0E,A.b0C,A.b0x,A.b1s,A.b0i,A.b23,A.b04,A.b13,A.b0g,A.b0e,A.b0k,A.b0s,A.b0u,A.b1t,A.b0h,A.b1M,A.b1y,A.b1K,A.b2a,A.b1S,A.b11,A.b1n],B.ae("F<+(o,x,O,o)>"))
A.aJA=x([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],y.b)
A.aK7=x([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],y.b)
A.aKg=x([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],y.b)})()};
(a=>{a["odvkbvgXs6YyU4/Dx6gJ6lX+VNQ="]=a.current})($__dart_deferred_initializers__);