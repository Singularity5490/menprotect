--[[
    This script was obfuscated using menprotect v1.0.0 by elerium:tm:
--]]
return(function()local a;local b;local c;local d;local e=function(...)return...end;local f=tonumber;local g=tostring;local h=setmetatable;local i=true;local j=g(f)local k=select;local l=j.byte;local m=j.char;local n=j.sub;local o=function(p)local q=''local r=302-302+302-301;while p[r]do q=q..p[r]r=r+302-302+302-301 end;return q end;local s=j.rep;local t=getfenv()local u=pcall;local v=unpack;local w=j.gsub;local function x(y,z)y[#y+1]=z end;local function A(B)return w(B,s(m(0x2E),2),function(C)return m(f(C,0x10))end)end;local function D(p,E)local F,G=1,0;while p>0 and E>0 do local H,I=p%2,E%2;if H~=I then G=G+F end;p,E,F=(p-H)/2,(E-I)/2,F*2 end;if p<E then p=E end;while p>0 do local H=p%2;if H>0 then G=G+F end;p,F=(p-H)/2,F*2 end;return G end;local function J(K,L)local M={}local N=0;for O=1,#K do x(M,m(D(l(K,O,O),L)))end;return o(M)end;local function P(...)return k(m(0x23),...),{...}end;local function Q(R)R=J(R,28)local S,T;S={g,f,function(U)T={false,true}return T[U+1]end}local V=1;local function W(X)V=V+(X or 1)end;local function Y()local Z=l(R,V,V)return Z end;local function _()local Z=Y()W()return Z end;local function _0(_1)_1=_1 or 1;local _2={}for O=1,_1 do _2[O]=_()end;return f(o(_2))end;local function _3(_1)local _2={}for O=1,_1 do _2[O]=m(_())end;return o(_2)end;local _4;function _4()local _5=_()if _5==0 then return end;local _6=1;local _7=_5==1 and _4 or _;if _5<3 then _6=_7()end;local _8=false;if _5==2 and Y()==0 and _6~=1 then _8=true end;local _9=_5>2 and _ or _5>1 and _0 or _3;local _a=S[_5](_9(_6))if _8 then return-_a end;return _a end;_3(0xB)local _b=_()local function _c()local _d={}local _e={}local _f={}local _g=_()local _h=_()do for _i=1,_4()do _d[_i]={}for _j=1,_()-2 do _d[_i][_j]=_4()end;_d[_i].x=_4()_d[_i].n=_4()end end;do for O=1,_4()do _e[O]=_4()end end;do for O=1,_4()do _f[O]=_c()end end;return{U=_d,a=_e,f=_f,z=_g,F=_h}end;local function _k(_l)local _m=_l and f or e;local _n={}for O=1,_()do _n[O]=_m(J(_4(),_b))end;return _n end;a=_k()return _c()end;local function _o(_p,_q)local _r=_p.U;local _s=_p.a;local _t=_p.f;return function(...)local _u,_v=1,-1;local _w,_x={},k(m(0x23),...)-1;local _y={}local _z={}local _A=h({},{[c]=_y,[d]=function(_B,_C,_D)if _C>_v then _v=_C end;_y[_C]=_D end})local function _E()local _F,_G;while i do _F=_r[_u]_G=_F.n;_u=_u+1;if _G==4 then _A[_F[1]]=_A[_F[2]]elseif _G==117 then _A[_F[1]]=_s[_F[2]+1]elseif _G==-212 then _A[_F[1]]=_q[_F[2]]elseif _G==63 then _A[_F[1]]={}elseif _G==203 then _u=_u+_F[2]elseif _G==248 then local _H=_A;local r=_F[4]or _H[_F[2]]local _I=_F[5]or _H[_F[3]]if r==_I~=_F[1]then _u=_u+1 end elseif _G==252 then local _J=_F[1]local r=_F[2]local _I=_F[3]local _H=_A;local _g,_K;local _L,_M;_g={}if r~=1 then if r~=0 then _L=_J+r-1 else _L=_v end;_M=0;for _N=_J+1,_L do _M=_M+1;_g[_M]=_H[_N]end;_L,_K=P(_H[_J](v(_g,1,_L-_J)))else _L,_K=P(_H[_J]())end;_v=_J-1;if _I~=1 then if _I~=0 then _L=_J+_I-2 else _L=_L+_J-1 end;_M=0;for _N=_J,_L do _M=_M+1;_H[_N]=_K[_M]end end elseif _G==189 then local _J=_F[1]local r=_F[2]local _H=_A;local _M,_O;local _L;if r==1 then return elseif r==0 then _L=_v else _L=_J+r-2 end;_O={}_M=0;for _N=_J,_L do _M=_M+1;_O[_M]=_H[_N]end;return _O,_M elseif _G==211 then local _J=_F[1]local _H=_A;local _P=_H[_J+2]local _Q=_H[_J]+_P;_H[_J]=_Q;if _P>0 then if _Q<=_H[_J+1]then _u=_u+_F[2]_H[_J+3]=_Q end else if _Q>=_H[_J+1]then _u=_u+_F[2]_H[_J+3]=_Q end end elseif _G==157 then local _J=_F[1]local _H=_A;_H[_J]=_H[_J]-_H[_J+2]_u=_u+_F[2]elseif _G==123 then local _R=_t[_F[2]+1]local _H=_A;local _S;local _T;if _R.F~=0 then _S={}_T=h({},{[c]=function(_B,_C)local _U=_S[_C]return _U[1][_U[2]]end,[d]=function(_B,_C,_D)local _U=_S[_C]_U[1][_U[2]]=_D end})for _N=1,_R.F do local _V=_r[_u]if _V.n==4 then _S[_N-1]={_H,_V[2]}elseif _V.n==-212 then _S[_N-1]={_q,_V[2]}end;_u=_u+1 end;_z[#_z+1]=_S end;_H[_F[1]]=_o(_R,_T)elseif _G==98 then local _J=_F[1]local r=_F[2]local _H,_W=_A,_w;_v=_J-1;for _N=_J,_J+(r>0 and r-1 or _x)do _H[_N]=_W[_N-_J]end end end end;local _g={...}for _N=0,_x do if _N>=_p.z then _w[_N-_p.z]=_g[_N+1]else _A[_N]=_g[_N+1]end end;local _J,r,_I=u(_E)if _J then if r and _I>0 then return v(r,1,_I)end;return else return print(r)end end end;return function(R)local _X=Q(R)c=a[1]d=a[2]_o(_X)()end;end)()("\113\121\114\108\110\115\104\121\127\104\96\19\30\29\30\29\27\76\76\122\125\119\118\107\29\30\30\29\28\76\76\125\118\100\122\125\119\118\107\28\28\30\29\27\24\30\29\28\30\29\28\30\30\31\26\30\31\29\30\31\24\30\29\29\30\29\29\30\25\29\26\24\20\24\30\31\29\30\31\24\30\29\30\30\29\30\30\25\31\30\21\31\30\30\31\29\30\31\25\30\29\31\30\29\30\30\29\28\30\20\29\26\27\27\27\24\28\20\30\29\24\24\30\29\24\30\29\31\30\25\24\21\24\24\24\30\31\29\30\31\25\30\29\31\30\29\30\30\29\29\30\20\29\26\27\21\31\20\30\28\30\31\30\25\30\25\30\29\28\30\29\29\30\29\28\30\27\20\31\20\20\26\31\20\30\31\29\20\21\30\29\28\30\29\24\28\28\30\29\31\25\30\29\29\30\29\30\30\29\28\30\20\29\26\27\27\27\31\29\27\30\30\21\20\25\30\29\29\30\29\30\30\29\28\30\20\29\26\27\27\27\31\29\28\30\31\29\20\21\25\30\29\28\30\29\29\30\29\28\30\27\20\31\20\20\26\31\20\30\31\29\20\21\30\29\28\30\29\28\28\28\30\29\31\25\30\29\29\30\29\30\30\29\28\30\20\29\26\27\27\27\31\29\27\30\30\21\20\25\30\29\29\30\29\30\30\29\28\30\20\29\26\27\27\27\31\29\28\30\31\29\20\21\25\30\29\28\30\29\29\30\29\28\30\27\20\31\20\20\26\31\20\30\31\29\20\21\30\29\28\30\29\28\28\28\30\29\31\25\30\29\29\30\29\30\30\29\28\30\20\29\26\27\27\27\31\29\27\30\30\21\20\25\30\29\29\30\29\30\30\29\28\30\20\29\26\27\27\27\31\29\28\30\31\29\20\21\25\30\29\28\30\29\29\30\29\28\30\27\20\31\20\20\26\31\20\30\31\29\20\21\30\29\28\30\29\28\28\28\30\30\30\25\25\30\29\28\30\29\28\31\28\30\29\29\30\31\29\29\27\25\30\29\29\30\29\29\31\28\30\25\29\26\24\24\21\30\31\29\29\27\25\30\29\30\30\29\30\31\28\30\25\31\30\20\21\27\30\31\29\29\27\24\30\29\28\30\29\28\30\22\30\29\24\27\24\26\27\30\21\26\30\31\29\25\27\24\30\29\28\30\30\28\29\30\22\30\29\24\27\24\25\28\21\29\29\30\31\30\29\29\27\31\28\30\31\30\25\21\30\31\30\26\28\31\28\31\29\30\22\30\29\27\26\21\28\21\31\31\25\30\31\30\24\20\24\30\29\28\30\29\28\30\22\30\29\24\27\24\26\27\30\20\26\30\31\30\28\31\27\31\29\30\31\30\26\28\30\31\30\26\28\31\29\31\29\30\22\30\29\20\25\30\21\20\28\28\27\30\31\30\24\20\24\30\29\28\30\29\28\30\22\30\29\24\27\24\26\27\30\20\26\30\31\30\28\31\27\31\29\30\31\30\26\28\30\31\30\26\28\31\29\31\29\30\22\30\29\20\25\30\21\20\28\28\27\30\31\30\24\20\24\30\29\28\30\29\28\30\22\30\29\24\27\24\26\27\30\20\26\30\31\30\28\31\27\31\29\30\31\30\25\21\30\31\30\26\28\31\28\31\29\30\22\30\29\27\26\21\28\21\31\21\21\30\31\30\24\20\24\30\29\28\30\29\28\30\22\30\29\24\27\24\26\27\30\20\26\30\31\30\28\31\27\31\29\30\31\30\26\28\30\31\30\25\21\31\29\31\28\30\22\30\29\20\25\30\20\29\26\30\31\30\31\30\24\20\24\30\29\28\30\29\28\30\22\30\29\24\27\24\26\27\30\20\26\30\31\30\28\31\27\31\29\30\31\30\25\21\30\31\30\25\21\31\28\31\28\30\22\30\29\27\26\20\21\31\28\29\25\30\31\30\24\20\24\30\29\28\30\29\28\30\22\30\29\24\27\24\26\27\30\20\26\30\31\30\28\31\27\31\29\30\31\30\25\21\30\31\30\26\28\31\28\31\29\30\22\30\29\27\26\21\28\21\31\21\21\30\31\30\24\20\24\30\29\28\30\29\28\30\22\30\29\24\27\24\26\27\30\20\26\30\31\30\28\31\27\31\29\30\31\30\26\28\30\31\30\25\21\31\29\31\28\30\22\30\29\20\25\30\20\29\26\30\31\30\31\30\24\20\24\30\29\28\30\29\28\30\22\30\29\24\27\24\26\27\30\20\26\30\31\30\28\31\27\31\29\30\31\30\25\21\30\31\30\25\21\31\28\31\28\30\22\30\29\27\26\20\21\31\28\29\25\30\31\30\24\20\24\30\29\28\30\29\28\30\22\30\29\24\27\24\26\27\30\20\26\30\31\30\28\31\24\30\29\28\30\29\28\30\30\31\26\30\31\29\30\31\25\30\29\28\30\29\29\30\29\28\30\27\20\31\20\20\26\31\20\30\31\29\20\21\30\29\25\30\30\29\30\30\29\25\30\29\29\31\28\31\29\30\29\29\28\28\30\30\30\24\25\30\29\28\30\29\28\31\28\30\29\29\30\31\29\29\27\25\30\29\29\30\29\29\31\28\30\25\29\26\24\24\21\30\31\29\29\27\25\30\29\30\30\29\30\31\28\30\25\31\30\20\21\27\30\31\29\29\27\25\30\29\31\30\29\31\31\28\30\25\24\21\31\24\25\30\31\29\29\27\25\30\29\24\30\29\24\31\28\30\25\26\25\27\21\31\30\31\29\29\27\25\30\29\25\30\29\25\31\28\30\25\20\30\30\24\29\30\31\29\29\27\25\30\29\26\30\29\26\31\28\30\25\21\20\26\20\21\30\31\29\29\27\25\30\29\27\30\29\27\31\28\30\26\29\29\25\29\31\27\30\31\29\29\27\25\30\29\20\30\29\20\31\28\30\26\29\31\29\25\20\25\30\31\29\29\27\25\30\29\21\30\29\28\30\29\28\30\31\25\20\26\30\30\26\31\25\30\30\29\28\30\29\28\30\29\28\30\31\26\25\28\30\30\26\31\25\30\30\29\29\30\29\28\30\29\28\30\31\27\29\24\30\30\26\31\25\30\30\29\30\30\29\28\30\29\28\30\31\27\27\20\30\30\26\31\25\30\30\29\31\30\29\28\30\29\28\30\31\20\24\30\30\30\26\31\25\30\30\29\24\30\29\28\30\29\28\30\31\21\28\26\30\30\26\31\25\30\30\29\25\30\29\28\30\29\28\30\31\21\27\28\30\30\26\31\25\30\30\29\26\30\29\28\30\29\28\30\24\29\28\31\24\30\30\26\31\25\30\30\29\27\30\29\21\31\28\30\26\29\24\20\25\24\25\30\31\29\29\27\25\30\30\29\20\30\30\29\28\31\28\30\26\29\26\24\21\21\31\30\31\29\29\27\25\30\30\29\21\30\30\29\29\31\28\30\26\29\20\29\24\24\29\30\31\29\29\27\24\30\30\29\27\30\29\28\30\22\30\29\24\27\24\26\20\31\20\24\30\31\29\25\27\24\30\30\29\27\30\30\28\29\30\22\30\29\24\27\24\25\29\21\21\21\30\31\30\29\29\24\30\30\29\27\30\29\28\30\24\29\29\30\24\30\31\29\30\31\25\30\29\28\30\29\29\30\29\28\30\27\20\31\20\20\26\31\20\30\31\29\20\21\30\30\29\30\29\30\29\25\73\100\82\116\74\29\30\29\20\84\94\83\91\77\117\87\86\29\30\29\20\37\90\108\79\101\118\102\83\29\30\29\26\108\105\94\121\88\94\29\30\30\29\28\100\78\107\44\79\125\127\74\108\122\29\30\30\29\28\107\72\88\123\118\83\118\125\91\45\29\30\29\21\118\43\89\94\113\116\75\73\110\29\30\30\29\30\105\86\47\43\114\87\73\43\113\119\106\125\29\30\30\29\31\87\106\85\84\78\112\105\102\44\83\105\110\40\30\30\29\31\30\30\29\24\30\29\29\30\29\29\28\28\30\30\29\25\25\30\29\28\30\29\28\31\28\30\29\29\30\31\29\29\27\25\30\29\29\30\29\29\31\28\30\25\29\26\24\24\21\30\31\29\29\27\25\30\29\30\30\29\30\31\28\30\25\31\30\20\21\27\30\31\29\29\27\25\30\29\31\30\29\31\31\28\30\25\24\21\31\24\25\30\31\29\29\27\25\30\29\24\30\29\24\31\28\30\25\26\25\27\21\31\30\31\29\29\27\25\30\29\25\30\29\25\31\28\30\25\20\30\30\24\29\30\31\29\29\27\25\30\29\26\30\29\26\31\28\30\25\21\20\26\20\21\30\31\29\29\27\25\30\29\27\30\29\28\30\29\28\30\31\24\25\20\30\30\26\31\25\30\29\20\30\29\28\30\29\28\30\31\25\30\30\30\30\26\31\25\30\29\21\30\29\28\30\29\28\30\31\25\20\26\30\30\26\31\25\30\30\29\28\30\29\28\30\29\28\30\31\26\25\28\30\30\26\31\25\30\30\29\29\30\29\28\30\29\28\30\31\27\29\24\30\30\26\31\25\30\30\29\30\30\29\28\30\29\28\30\31\27\27\20\30\30\26\31\25\30\30\29\31\30\29\28\30\29\28\30\31\20\24\30\30\30\26\31\25\30\29\28\30\29\29\30\29\28\30\27\20\31\20\20\26\31\20\30\31\29\20\21\30\29\27\29\30\30\29\30\81\121\78\93\101\73\69\112\127\115\93\41\29\30\30\29\24\114\110\77\119\90\89\111\90\72\81\72\113\102\42\29\30\30\29\30\117\110\125\84\75\44\109\125\46\102\93\117\29\30\30\29\24\40\101\83\86\42\79\76\84\91\123\93\70\126\89\29\30\30\29\28\73\43\127\47\122\41\72\47\118\46\29\30\30\29\31\46\113\125\80\122\78\47\126\119\94\91\109\74\29\30\29\25\107\110\76\121\90\30\29\28");
