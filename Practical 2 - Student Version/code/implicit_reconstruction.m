clc
clear all
close all


dataFolder = ['..' filesep 'data'];

[V,normals] = load_noff_file([dataFolder filesep 'bunny-1000_POINTS.off']);
%Normalizing point cloud
diagLength= sqrt(sum((max(V)-min(V)).^2,2));
V = V/diagLength;
diagLength = 1;


%Generating plane point cloud
%origin=rand(1,3);
%axis1=rand(1,3);
%axis2=rand(1,3);
%axis1 = axis1./normv(axis1); 
%normal = cross(axis1,axis2,2);
%normal = normal./normv(normal)
%axis2 = cross(normal, axis1,2);
%axis2 = axis2./normv(axis2); 

%uv = rand(5000,2);
%V = uv*[axis1;axis2];
%normals = repmat(normal,length(V),1);

%random N surface
%V = rand(5000,3);
%coeffs = rand(1,9)*0.5-0.5;
%d = coeffs(1)*V(:,1).^2+coeffs(2)*V(:,2).^2+coeffs(3)*V(:,3).^2+coeffs(4)*V(:,1).*V(:,2)+coeffs(5)*V(:,1).*V(:,3)+coeffs(6)*V(:,2).*V(:,3)+coeffs(7)*V(:,1)+coeffs(8)*V(:,2)+coeffs(9)*V(:,3);


%%parameters
epsNormal = 0.01*diagLength;
h = 0.3*diagLength;
N = 2;
gridRes = 32;

%%MLS Setup function
[C,d, VFull, powers] = setup_MLS(V, normals, N, epsNormal);
minValues = min(VFull,[],1);
maxValues = max(VFull,[],1);
span = maxValues - minValues;

%%Defining oracle function
MLSOracleHandle = @(qx,qy,qz)MLS_oracle_function(qx,qy,qz,C,d,VFull, h, powers);

%%Defining grid and filling it with MLS values
[X,Y,Z]=meshgrid(minValues(1):span(1)/(gridRes-1):maxValues(1),minValues(2):span(2)/(gridRes-1):maxValues(2),minValues(3):span(3)/(gridRes-1):maxValues(3));
[MLSValues, MLSError]=arrayfun(MLSOracleHandle, X, Y, Z);

%%Visualization


%%Showing the point cloud with auxiliary points
figure
hold on
cameratoolbar;
axis equal;
scatter3(VFull(:,1),VFull(:,2),VFull(:,3),20,d, 'filled');

%0 level-set (Zero-set) view
figure
hold on
cameratoolbar;
axis equal;
patch(isosurface(X,Y,Z,MLSValues,0), 'faceColor', 'y');
camlight 
lighting gouraud

%slice view
figure 
hold on
xslice = []; %minValues(1):span(1)/sliceRes:maxValues(1);
yslice = minValues(2):span(2)/(gridRes-1):maxValues(2);
zslice = []; %minValues(3):span(3)/sliceRes:maxValues(3);
slice(X,Y,Z,MLSValues,xslice,yslice,zslice);
cameratoolbar;
axis equal;

%slice view of error function
figure 
hold on
xslice = []; %minValues(1):span(1)/sliceRes:maxValues(1);
yslice = minValues(2):span(2)/(gridRes-1):maxValues(2);
zslice = []; %minValues(3):span(3)/sliceRes:maxValues(3);
slice(X,Y,Z,MLSError,xslice,yslice,zslice);
cameratoolbar;
axis equal;


