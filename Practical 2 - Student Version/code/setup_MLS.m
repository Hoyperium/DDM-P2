function [C,d,VFull, powers] = setup_MLS(V,normals, N, epsNormal)

%setup the full matrices of the MLS system

%stub; remove after implementation
C = [];
d=[];
VFull=[V;V+epsNormal*normals;V-epsNormal*normals];
powers=[];
end
