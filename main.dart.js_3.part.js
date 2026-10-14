((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var B,D,C={
cFg(d){var x,w,v,u,t=d.length
if(t<18||d[0]!==31||d[1]!==139||d[2]!==8)throw B.q(A.alC)
x=d[3]
w=(x&4)!==0?10+(2+((d[10]|d[11]<<8)>>>0)):10
if((x&8)!==0){for(;v=w+1,d[w]!==0;w=v);w=v}if((x&16)!==0){for(;v=w+1,d[w]!==0;w=v);w=v}if((x&2)!==0)w+=2
u=(d[t-4]|d[t-3]<<8|d[t-2]<<16|d[t-1]<<24)>>>0
t=u>0?u:65536
return new C.bpV(d,w,new Uint8Array(t)).aup()},
aq_(d,e,f,g){var x,w,v,u,t,s,r,q,p,o
for(x=d.a,w=x.$flags|0,v=0;v<16;++v){w&2&&B.aC(x)
x[v]=0}for(u=0;u<g;++u){t=e[f+u]
s=x[t]
w&2&&B.aC(x)
x[t]=s+1}r=B.cl(16,0,!1,y.e)
for(q=1;q<15;q=p){p=q+1
r[p]=r[q]+x[q]}for(x=d.b,w=x.$flags|0,u=0;u<g;++u){o=e[f+u]
if(o!==0){t=r[o]
r[o]=t+1
w&2&&B.aC(x)
x[t]=u}}},
KC:function KC(d,e){this.a=d
this.b=e},
bpV:function bpV(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.f=_.e=_.d=0},
azk(d){return C.cFh(d)},
cFh(d){var x=0,w=B.j(y.g),v,u=2,t=[],s,r,q,p,o,n,m,l,k,j,i,h
var $async$azk=B.e(function(e,f){if(e===1){t.push(f)
x=u}for(;;)switch(x){case 0:if(d.length<2||d[0]!==31||d[1]!==139){v=D.av.cB(d)
x=1
break}u=4
k=b.G
s=k.DecompressionStream
r=k.Response
x=s!=null&&r!=null?7:8
break
case 7:k=y.k
j=y.h
q=B.t1(k.a(s),"gzip",null,j)
p=B.t1(k.a(r),d,null,j)
o=B.cZ(p.body)
n=B.cZ(B.cQ(o,"pipeThrough",q,null,null,null))
m=B.t1(r,n,null,j)
x=9
return B.c(B.eA(B.cZ(B.cQ(m,"text",null,null,null,null)),y.g),$async$azk)
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
case 6:v=D.av.cB(C.cFg(d))
x=1
break
case 1:return B.h(v,w)
case 2:return B.f(t.at(-1),w)}})
return B.i($async$azk,w)}},A
B=c[0]
D=c[2]
C=a.updateHolder(c[14],C)
A=c[27]
C.KC.prototype={}
C.bpV.prototype={
nG(d){var x,w,v,u,t=this,s=t.e
for(x=t.a,w=x.length;v=t.f,v<d;){u=t.b
if(u>=w)throw B.q(A.als)
t.b=u+1
s=(s|D.j.Ea(x[u],v))>>>0
t.f=v+8}t.e=D.j.rm(s,d)
t.f=v-d
return(s&D.j.QG(1,d)-1)>>>0},
a0L(d){var x,w=this,v=w.d,u=w.c,t=u.length
if(v===t){x=new Uint8Array(t*2)
D.az.iU(x,0,v,u)
w.c=x
v=x}else v=u
u=w.d++
v.$flags&2&&B.aC(v)
v[u]=d},
cB(d){var x,w,v,u,t,s
for(x=d.a,w=0,v=0,u=0,t=1;t<16;++t){w=(w|this.nG(1))>>>0
s=x[t]
if(w-s<v)return d.b[u+(w-v)]
u+=s
v=v+s<<1>>>0
w=w<<1}throw B.q(A.alz)},
aoG(d,e){var x,w,v,u,t,s=this
for(;;){x=s.cB(d)
if(x<256)s.a0L(x)
else if(x===256)return
else{x-=257
if(x>=29)throw B.q(A.alv)
w=A.aL2[x]+s.nG(A.ay3[x])
v=s.cB(e)
u=A.aLb[v]+s.nG(A.aCR[v])
if(u>s.d)throw B.q(A.alB)
for(t=0;t<w;++t)s.a0L(s.c[s.d-u])}}},
aup(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h=this,g=B.cY(),f=B.cY(),e=y.e,d=h.a,a0=!1
do{x=h.nG(1)
w=h.nG(2)
if(w===0){v=h.f=h.e=0
u=h.b
t=(d[u]|d[u+1]<<8)>>>0
h.b=u+4
for(;v<t;++v)h.a0L(d[h.b++])}else if(w===1){if(!a0){s=B.cl(318,0,!1,e)
for(r=0;r<144;++r)s[r]=8
for(r=144;r<256;++r)s[r]=9
for(r=256;r<280;++r)s[r]=7
for(r=280;r<288;++r)s[r]=8
for(r=288;r<318;++r)s[r]=5
u=new Int16Array(16)
g.sfO(new C.KC(u,new Int16Array(288)))
u=new Int16Array(16)
f.sfO(new C.KC(u,new Int16Array(30)))
C.aq_(g.bB(),s,0,288)
C.aq_(f.bB(),s,288,30)
a0=!0}h.aoG(g.bB(),f.bB())}else if(w===2){q=h.nG(5)+257
p=h.nG(5)+1
o=h.nG(4)+4
s=B.cl(320,0,!1,e)
for(v=0;v<o;++v)s[A.aKv[v]]=h.nG(3)
u=new Int16Array(16)
n=new C.KC(u,new Int16Array(288))
u=new Int16Array(16)
m=new C.KC(u,new Int16Array(30))
C.aq_(n,s,0,19)
for(u=q+p,l=0;l<u;){k=h.cB(n)
if(k<16){j=l+1
s[l]=k
l=j}else{if(k===16){if(l===0)throw B.q(A.alx)
t=s[l-1]
k=3+h.nG(2)}else{k=k===17?3+h.nG(3):11+h.nG(7)
t=0}if(l+k>u)throw B.q(A.alw)
for(;i=k-1,k>0;k=i,l=j){j=l+1
s[l]=t}}}C.aq_(n,s,0,q)
C.aq_(m,s,q,p)
h.aoG(n,m)}else throw B.q(A.alt)}while(x===0)
e=h.c
d=h.d
return e.length===d?e:B.xy(e,0,d)}}
var z=a.updateTypes([]);(function inheritance(){var x=a.inheritMany
x(B.a4,[C.KC,C.bpV])})()
var y={b:B.ae("E<x>"),h:B.ae("bN"),k:B.ae("hK"),g:B.ae("o"),e:B.ae("x")};(function constants(){var x=a.makeConstList
A.als=new B.eU("truncated deflate stream",null,null)
A.alt=new B.eU("bad block type",null,null)
A.alv=new B.eU("bad length symbol",null,null)
A.alw=new B.eU("too many lengths",null,null)
A.alx=new B.eU("repeat with no first length",null,null)
A.alz=new B.eU("bad huffman code",null,null)
A.alB=new B.eU("distance too far back",null,null)
A.alC=new B.eU("not a gzip stream",null,null)
A.ay3=x([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],y.b)
A.aCR=x([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],y.b)
A.b2T=new B.aX(["\u0627\u0644\u0641\u0627\u062a\u062d\u0629",7,!0,"Al-Faatiha"])
A.b1K=new B.aX(["\u0627\u0644\u0628\u0642\u0631\u0629",286,!1,"Al-Baqara"])
A.b1t=new B.aX(["\u0622\u0644 \u0639\u0645\u0631\u0627\u0646",200,!1,"Aal-i-Imraan"])
A.b27=new B.aX(["\u0627\u0644\u0646\u0633\u0627\u0621",176,!1,"An-Nisaa"])
A.b2j=new B.aX(["\u0627\u0644\u0645\u0627\u0626\u062f\u0629",120,!1,"Al-Maaida"])
A.b19=new B.aX(["\u0627\u0644\u0623\u0646\u0639\u0627\u0645",165,!0,"Al-An'aam"])
A.b1I=new B.aX(["\u0627\u0644\u0623\u0639\u0631\u0627\u0641",206,!0,"Al-A'raaf"])
A.b1J=new B.aX(["\u0627\u0644\u0623\u0646\u0641\u0627\u0644",75,!1,"Al-Anfaal"])
A.b2X=new B.aX(["\u0627\u0644\u062a\u0648\u0628\u0629",129,!1,"At-Tawba"])
A.b15=new B.aX(["\u064a\u0648\u0646\u0633",109,!0,"Yunus"])
A.b2F=new B.aX(["\u0647\u0648\u062f",123,!0,"Hud"])
A.b2x=new B.aX(["\u064a\u0648\u0633\u0641",111,!0,"Yusuf"])
A.b1W=new B.aX(["\u0627\u0644\u0631\u0639\u062f",43,!1,"Ar-Ra'd"])
A.b2N=new B.aX(["\u0627\u0628\u0631\u0627\u0647\u064a\u0645",52,!0,"Ibrahim"])
A.b23=new B.aX(["\u0627\u0644\u062d\u062c\u0631",99,!0,"Al-Hijr"])
A.b37=new B.aX(["\u0627\u0644\u0646\u062d\u0644",128,!0,"An-Nahl"])
A.b17=new B.aX(["\u0627\u0644\u0625\u0633\u0631\u0627\u0621",111,!0,"Al-Israa"])
A.b2Z=new B.aX(["\u0627\u0644\u0643\u0647\u0641",110,!0,"Al-Kahf"])
A.b1O=new B.aX(["\u0645\u0631\u064a\u0645",98,!0,"Maryam"])
A.b2m=new B.aX(["\u0637\u0647",135,!0,"Taa-Haa"])
A.b2L=new B.aX(["\u0627\u0644\u0623\u0646\u0628\u064a\u0627\u0621",112,!0,"Al-Anbiyaa"])
A.b1r=new B.aX(["\u0627\u0644\u062d\u062c",78,!1,"Al-Hajj"])
A.b2U=new B.aX(["\u0627\u0644\u0645\u0624\u0645\u0646\u0648\u0646",118,!0,"Al-Muminoon"])
A.b1Z=new B.aX(["\u0627\u0644\u0646\u0648\u0631",64,!1,"An-Noor"])
A.b2n=new B.aX(["\u0627\u0644\u0641\u0631\u0642\u0627\u0646",77,!0,"Al-Furqaan"])
A.b2u=new B.aX(["\u0627\u0644\u0634\u0639\u0631\u0627\u0621",227,!0,"Ash-Shu'araa"])
A.b20=new B.aX(["\u0627\u0644\u0646\u0645\u0644",93,!0,"An-Naml"])
A.b1p=new B.aX(["\u0627\u0644\u0642\u0635\u0635",88,!0,"Al-Qasas"])
A.b1b=new B.aX(["\u0627\u0644\u0639\u0646\u0643\u0628\u0648\u062a",69,!0,"Al-Ankaboot"])
A.b36=new B.aX(["\u0627\u0644\u0631\u0648\u0645",60,!0,"Ar-Room"])
A.b2G=new B.aX(["\u0644\u0642\u0645\u0627\u0646",34,!0,"Luqman"])
A.b2O=new B.aX(["\u0627\u0644\u0633\u062c\u062f\u0629",30,!0,"As-Sajda"])
A.b14=new B.aX(["\u0627\u0644\u0623\u062d\u0632\u0627\u0628",73,!1,"Al-Ahzaab"])
A.b1E=new B.aX(["\u0633\u0628\u0625",54,!0,"Saba"])
A.b1V=new B.aX(["\u0641\u0627\u0637\u0631",45,!0,"Faatir"])
A.b1a=new B.aX(["\u064a\u0633",83,!0,"Yaseen"])
A.b2o=new B.aX(["\u0627\u0644\u0635\u0627\u0641\u0627\u062a",182,!0,"As-Saaffaat"])
A.b1B=new B.aX(["\u0635",88,!0,"Saad"])
A.b1T=new B.aX(["\u0627\u0644\u0632\u0645\u0631",75,!0,"Az-Zumar"])
A.b1X=new B.aX(["\u063a\u0627\u0641\u0631",85,!0,"Al-Ghaafir"])
A.b2a=new B.aX(["\u0641\u0635\u0644\u062a",54,!0,"Fussilat"])
A.b1Y=new B.aX(["\u0627\u0644\u0634\u0648\u0631\u0649",53,!0,"Ash-Shura"])
A.b1d=new B.aX(["\u0627\u0644\u0632\u062e\u0631\u0641",89,!0,"Az-Zukhruf"])
A.b1j=new B.aX(["\u0627\u0644\u062f\u062e\u0627\u0646",59,!0,"Ad-Dukhaan"])
A.b2P=new B.aX(["\u0627\u0644\u062c\u0627\u062b\u064a\u0629",37,!0,"Al-Jaathiya"])
A.b2B=new B.aX(["\u0627\u0644\u0623\u062d\u0642\u0627\u0641",35,!0,"Al-Ahqaf"])
A.b1U=new B.aX(["\u0645\u062d\u0645\u062f",38,!1,"Muhammad"])
A.b22=new B.aX(["\u0627\u0644\u0641\u062a\u062d",29,!1,"Al-Fath"])
A.b2Y=new B.aX(["\u0627\u0644\u062d\u062c\u0631\u0627\u062a",18,!1,"Al-Hujuraat"])
A.b2c=new B.aX(["\u0642",45,!0,"Qaaf"])
A.b1z=new B.aX(["\u0627\u0644\u0630\u0627\u0631\u064a\u0627\u062a",60,!0,"Adh-Dhaariyat"])
A.b1Q=new B.aX(["\u0627\u0644\u0637\u0648\u0631",49,!0,"At-Tur"])
A.b2E=new B.aX(["\u0627\u0644\u0646\u062c\u0645",62,!0,"An-Najm"])
A.b2V=new B.aX(["\u0627\u0644\u0642\u0645\u0631",55,!0,"Al-Qamar"])
A.b33=new B.aX(["\u0627\u0644\u0631\u062d\u0645\u0646",78,!1,"Ar-Rahmaan"])
A.b1S=new B.aX(["\u0627\u0644\u0648\u0627\u0642\u0639\u0629",96,!0,"Al-Waaqia"])
A.b2s=new B.aX(["\u0627\u0644\u062d\u062f\u064a\u062f",29,!1,"Al-Hadid"])
A.b2g=new B.aX(["\u0627\u0644\u0645\u062c\u0627\u062f\u0644\u0629",22,!1,"Al-Mujaadila"])
A.b11=new B.aX(["\u0627\u0644\u062d\u0634\u0631",24,!1,"Al-Hashr"])
A.b1m=new B.aX(["\u0627\u0644\u0645\u0645\u062a\u062d\u0646\u0629",13,!1,"Al-Mumtahana"])
A.b1x=new B.aX(["\u0627\u0644\u0635\u0641",14,!1,"As-Saff"])
A.b1h=new B.aX(["\u0627\u0644\u062c\u0645\u0639\u0629",11,!1,"Al-Jumu'a"])
A.b2d=new B.aX(["\u0627\u0644\u0645\u0646\u0627\u0641\u0642\u0648\u0646",11,!1,"Al-Munaafiqoon"])
A.b1n=new B.aX(["\u0627\u0644\u062a\u063a\u0627\u0628\u0646",18,!1,"At-Taghaabun"])
A.b39=new B.aX(["\u0627\u0644\u0637\u0644\u0627\u0642",12,!1,"At-Talaaq"])
A.b2S=new B.aX(["\u0627\u0644\u062a\u062d\u0631\u064a\u0645",12,!1,"At-Tahrim"])
A.b35=new B.aX(["\u0627\u0644\u0645\u0644\u0643",30,!0,"Al-Mulk"])
A.b1R=new B.aX(["\u0627\u0644\u0642\u0644\u0645",52,!0,"Al-Qalam"])
A.b32=new B.aX(["\u0627\u0644\u062d\u0627\u0642\u0629",52,!0,"Al-Haaqqa"])
A.b2p=new B.aX(["\u0627\u0644\u0645\u0639\u0627\u0631\u062c",44,!0,"Al-Ma'aarij"])
A.b1L=new B.aX(["\u0646\u0648\u062d",28,!0,"Nooh"])
A.b2b=new B.aX(["\u0627\u0644\u062c\u0646",28,!0,"Al-Jinn"])
A.b30=new B.aX(["\u0627\u0644\u0645\u0632\u0645\u0644",20,!0,"Al-Muzzammil"])
A.b34=new B.aX(["\u0627\u0644\u0645\u062f\u062b\u0631",56,!0,"Al-Muddaththir"])
A.b2i=new B.aX(["\u0627\u0644\u0642\u064a\u0627\u0645\u0629",40,!0,"Al-Qiyaama"])
A.b26=new B.aX(["\u0627\u0644\u0627\u0646\u0633\u0627\u0646",31,!1,"Al-Insaan"])
A.b18=new B.aX(["\u0627\u0644\u0645\u0631\u0633\u0644\u0627\u062a",50,!0,"Al-Mursalaat"])
A.b29=new B.aX(["\u0627\u0644\u0646\u0628\u0625",40,!0,"An-Naba"])
A.b2t=new B.aX(["\u0627\u0644\u0646\u0627\u0632\u0639\u0627\u062a",46,!0,"An-Naazi'aat"])
A.b2D=new B.aX(["\u0639\u0628\u0633",42,!0,"Abasa"])
A.b1N=new B.aX(["\u0627\u0644\u062a\u0643\u0648\u064a\u0631",29,!0,"At-Takwir"])
A.b1H=new B.aX(["\u0627\u0644\u0625\u0646\u0641\u0637\u0627\u0631",19,!0,"Al-Infitaar"])
A.b2e=new B.aX(["\u0627\u0644\u0645\u0637\u0641\u0641\u064a\u0646",36,!0,"Al-Mutaffifin"])
A.b2y=new B.aX(["\u0627\u0644\u0625\u0646\u0634\u0642\u0627\u0642",25,!0,"Al-Inshiqaaq"])
A.b2v=new B.aX(["\u0627\u0644\u0628\u0631\u0648\u062c",22,!0,"Al-Burooj"])
A.b28=new B.aX(["\u0627\u0644\u0637\u0627\u0631\u0642",17,!0,"At-Taariq"])
A.b1o=new B.aX(["\u0627\u0644\u0623\u0639\u0644\u0649",19,!0,"Al-A'laa"])
A.b1M=new B.aX(["\u0627\u0644\u063a\u0627\u0634\u064a\u0629",26,!0,"Al-Ghaashiya"])
A.b2H=new B.aX(["\u0627\u0644\u0641\u062c\u0631",30,!0,"Al-Fajr"])
A.b2h=new B.aX(["\u0627\u0644\u0628\u0644\u062f",20,!0,"Al-Balad"])
A.b1G=new B.aX(["\u0627\u0644\u0634\u0645\u0633",15,!0,"Ash-Shams"])
A.b1F=new B.aX(["\u0627\u0644\u0644\u064a\u0644",21,!0,"Al-Lail"])
A.b1C=new B.aX(["\u0627\u0644\u0636\u062d\u0649",11,!0,"Ad-Dhuhaa"])
A.b1A=new B.aX(["\u0627\u0644\u0634\u0631\u062d",8,!0,"Ash-Sharh"])
A.b1v=new B.aX(["\u0627\u0644\u062a\u064a\u0646",8,!0,"At-Tin"])
A.b2q=new B.aX(["\u0627\u0644\u0639\u0644\u0642",19,!0,"Al-Alaq"])
A.b1g=new B.aX(["\u0627\u0644\u0642\u062f\u0631",5,!0,"Al-Qadr"])
A.b31=new B.aX(["\u0627\u0644\u0628\u064a\u0646\u0629",8,!1,"Al-Bayyina"])
A.b12=new B.aX(["\u0627\u0644\u0632\u0644\u0632\u0644\u0629",8,!1,"Az-Zalzala"])
A.b21=new B.aX(["\u0627\u0644\u0639\u0627\u062f\u064a\u0627\u062a",11,!0,"Al-Aadiyaat"])
A.b1e=new B.aX(["\u0627\u0644\u0642\u0627\u0631\u0639\u0629",11,!0,"Al-Qaari'a"])
A.b1c=new B.aX(["\u0627\u0644\u062a\u0643\u0627\u062b\u0631",8,!0,"At-Takaathur"])
A.b1i=new B.aX(["\u0627\u0644\u0639\u0635\u0631",3,!0,"Al-Asr"])
A.b1q=new B.aX(["\u0627\u0644\u0647\u0645\u0632\u0629",9,!0,"Al-Humaza"])
A.b1s=new B.aX(["\u0627\u0644\u0641\u064a\u0644",5,!0,"Al-Fil"])
A.b2r=new B.aX(["\u0642\u0631\u064a\u0634",4,!0,"Quraish"])
A.b1f=new B.aX(["\u0627\u0644\u0645\u0627\u0639\u0648\u0646",7,!0,"Al-Maa'un"])
A.b2K=new B.aX(["\u0627\u0644\u0643\u0648\u062b\u0631",3,!0,"Al-Kawthar"])
A.b2w=new B.aX(["\u0627\u0644\u0643\u0627\u0641\u0631\u0648\u0646",6,!0,"Al-Kaafiroon"])
A.b2I=new B.aX(["\u0627\u0644\u0646\u0635\u0631",3,!1,"An-Nasr"])
A.b38=new B.aX(["\u0627\u0644\u0645\u0633\u062f",5,!0,"Al-Masad"])
A.b2Q=new B.aX(["\u0627\u0644\u0625\u062e\u0644\u0627\u0635",4,!0,"Al-Ikhlaas"])
A.b2_=new B.aX(["\u0627\u0644\u0641\u0644\u0642",5,!0,"Al-Falaq"])
A.b2l=new B.aX(["\u0627\u0644\u0646\u0627\u0633",6,!0,"An-Naas"])
A.cN=x([A.b2T,A.b1K,A.b1t,A.b27,A.b2j,A.b19,A.b1I,A.b1J,A.b2X,A.b15,A.b2F,A.b2x,A.b1W,A.b2N,A.b23,A.b37,A.b17,A.b2Z,A.b1O,A.b2m,A.b2L,A.b1r,A.b2U,A.b1Z,A.b2n,A.b2u,A.b20,A.b1p,A.b1b,A.b36,A.b2G,A.b2O,A.b14,A.b1E,A.b1V,A.b1a,A.b2o,A.b1B,A.b1T,A.b1X,A.b2a,A.b1Y,A.b1d,A.b1j,A.b2P,A.b2B,A.b1U,A.b22,A.b2Y,A.b2c,A.b1z,A.b1Q,A.b2E,A.b2V,A.b33,A.b1S,A.b2s,A.b2g,A.b11,A.b1m,A.b1x,A.b1h,A.b2d,A.b1n,A.b39,A.b2S,A.b35,A.b1R,A.b32,A.b2p,A.b1L,A.b2b,A.b30,A.b34,A.b2i,A.b26,A.b18,A.b29,A.b2t,A.b2D,A.b1N,A.b1H,A.b2e,A.b2y,A.b2v,A.b28,A.b1o,A.b1M,A.b2H,A.b2h,A.b1G,A.b1F,A.b1C,A.b1A,A.b1v,A.b2q,A.b1g,A.b31,A.b12,A.b21,A.b1e,A.b1c,A.b1i,A.b1q,A.b1s,A.b2r,A.b1f,A.b2K,A.b2w,A.b2I,A.b38,A.b2Q,A.b2_,A.b2l],B.ae("E<+(o,x,N,o)>"))
A.aKv=x([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],y.b)
A.aL2=x([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],y.b)
A.aLb=x([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],y.b)})()};
(a=>{a["ZYsySy2dAFw+cSDjKOcYMlJ1YxA="]=a.current})($__dart_deferred_initializers__);