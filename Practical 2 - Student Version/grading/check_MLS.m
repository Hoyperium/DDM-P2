clear all
close all
clc


%%%%%%%%%%%%%%%%%%%%%%Checking with different epsilon values
codeFolder = ['..' filesep 'code'];
dataFolder = ['..' filesep 'data'];
addpath(codeFolder);

currFileName='hound_POINTS';
[V,normals] = load_noff_file([dataFolder filesep currFileName '.off']);
diagLength= sqrt(sum((max(V)-min(V)).^2,2));
V = V/diagLength;
diagLength = 1;
epsValues = [0.005, 0.01, 0.02, 0.1]*diagLength;
h = 0.2*diagLength;
N = 0;
gridRes = 32;

disp('Checking different epsilon values');
disp('*********************************');
for epsIndex = 1:length(epsValues)
     
    %%%%%%Checking against provided solution
    disp(['epsNormal value: ' num2str(epsValues(epsIndex))]);
    clear MLSValues MLSError
    tic
    [C,d, VFull, powers] = setup_MLS(V, normals, N, epsValues(epsIndex));
    minValues = min(VFull,[],1);
    maxValues = max(VFull,[],1);
    span = maxValues - minValues;
    MLSOracleHandle = @(qx,qy,qz)MLS_oracle_function(qx,qy,qz,C,d,VFull, h, powers);
    [X,Y,Z]=meshgrid(minValues(1):span(1)/(gridRes-1):maxValues(1),minValues(2):span(2)/(gridRes-1):maxValues(2),minValues(3):span(3)/(gridRes-1):maxValues(3));
    [MLSValues, MLSError]=arrayfun(MLSOracleHandle, X, Y, Z);
    load([dataFolder filesep currFileName, '-epsvalues-' int2str(epsIndex), '.mat']);
    
    disp(['Execution time: ', num2str(toc), ' s']);
    disp(['Maximum absolute error for MLS values: ' num2str(max(max(max(abs(MLSValues-MLSValuesRef)))))]);
    disp(['Maximum absolute error for MLS error: ' num2str(max(max(max(abs(MLSError-MLSErrorRef)))))]);
    disp(' ');
end




%%%%%%%%%%%%%%%%%%%%%%Checking with different h values
codeFolder = ['..' filesep 'code'];
dataFolder = ['..' filesep 'data'];
hvalues = [0.05, 0.1, 0.3, 0.5]*diagLength;
addpath(codeFolder);

currFileName='bunny-1000_POINTS';
[V,normals] = load_noff_file([dataFolder filesep currFileName '.off']);
diagLength= sqrt(sum((max(V)-min(V)).^2,2));
V = V/diagLength;
diagLength = 1;
epsNormal = 0.01*diagLength;
N = 1;
gridRes = 32;

[C,d, VFull, powers] = setup_MLS(V, normals, N, epsNormal);
minValues = min(VFull,[],1);
maxValues = max(VFull,[],1);
span = maxValues - minValues;
disp('Checking different h values');
disp('***************************');
for hindex = 1:length(hvalues)
     
    %%%%%%Checking against provided solution
    disp(['h value: ' num2str(hvalues(hindex))]);
    clear MLSValues MLSError
    tic
    MLSOracleHandle = @(qx,qy,qz)MLS_oracle_function(qx,qy,qz,C,d,VFull, hvalues(hindex), powers);
    [X,Y,Z]=meshgrid(minValues(1):span(1)/(gridRes-1):maxValues(1),minValues(2):span(2)/(gridRes-1):maxValues(2),minValues(3):span(3)/(gridRes-1):maxValues(3));
    [MLSValues, MLSError]=arrayfun(MLSOracleHandle, X, Y, Z);
    load([dataFolder filesep currFileName, '-hvalues-' int2str(hindex), '.mat']);
    
    disp(['Execution time: ', num2str(toc), ' s']);
    disp(['Maximum absolute error for MLS values: ' num2str(max(max(max(abs(MLSValues-MLSValuesRef)))))]);
    disp(['Maximum absolute error for MLS error: ' num2str(max(max(max(abs(MLSError-MLSErrorRef)))))]);
    disp(' ');
end

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%Checking with different N values
codeFolder = ['..' filesep 'code'];
dataFolder = ['..' filesep 'data'];
Nvalues = 0:3;
addpath(codeFolder);

currFileName='cat_POINTS';
[V,normals] = load_noff_file([dataFolder filesep currFileName '.off']);
diagLength= sqrt(sum((max(V)-min(V)).^2,2));
V = V/diagLength;
diagLength = 1;
epsNormal = 0.01*diagLength;
h = 0.2*diagLength;
gridRes = 32;

disp('Checking different N values');
disp('***************************');
for Nindex = 1:length(Nvalues)
     
    %%%%%%Checking against provided solution
    disp(['N value: ' num2str(Nvalues(Nindex))]);
    clear MLSValues MLSError
    tic
    [C,d, VFull, powers] = setup_MLS(V, normals, Nvalues(Nindex), epsNormal);
    minValues = min(VFull,[],1);
    maxValues = max(VFull,[],1);
    span = maxValues - minValues;
    MLSOracleHandle = @(qx,qy,qz)MLS_oracle_function(qx,qy,qz,C,d,VFull, h, powers);
    [X,Y,Z]=meshgrid(minValues(1):span(1)/(gridRes-1):maxValues(1),minValues(2):span(2)/(gridRes-1):maxValues(2),minValues(3):span(3)/(gridRes-1):maxValues(3));
    [MLSValues, MLSError]=arrayfun(MLSOracleHandle, X, Y, Z);
    load([dataFolder filesep currFileName, '-Nvalues-' int2str(Nindex), '.mat']);
    
    disp(['Execution time: ', num2str(toc), ' s']);
    disp(['Maximum absolute error for MLS values: ' num2str(max(max(max(abs(MLSValues-MLSValuesRef)))))]);
    disp(['Maximum absolute error for MLS error: ' num2str(max(max(max(abs(MLSError-MLSErrorRef)))))]);
    disp(' ');
end

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%Checking with different grid resolutions
codeFolder = ['..' filesep 'code'];
dataFolder = ['..' filesep 'data'];
addpath(codeFolder);

currFileName='sphere_POINTS';
[V,normals] = load_noff_file([dataFolder filesep currFileName '.off']);
diagLength= sqrt(sum((max(V)-min(V)).^2,2));
V = V/diagLength;
diagLength = 1;
epsNormal = 0.01*diagLength;
h = 0.2*diagLength;
N = 2;
gridResValues = [8,16,32,64];

disp('Checking different grid resolutions');
disp('***********************************');
for Gindex = 1:length(gridResValues)
     
 
    %%%%%%Checking against provided solution
    disp(['Grid resolution: ' num2str(gridResValues(Gindex))]);
    clear MLSValues MLSError
    tic
    [C,d, VFull, powers] = setup_MLS(V, normals, N, epsNormal);
    minValues = min(VFull,[],1);
    maxValues = max(VFull,[],1);
    span = maxValues - minValues;
    MLSOracleHandle = @(qx,qy,qz)MLS_oracle_function(qx,qy,qz,C,d,VFull, h, powers);
    [X,Y,Z]=meshgrid(minValues(1):span(1)/(gridResValues(Gindex)-1):maxValues(1),minValues(2):span(2)/(gridResValues(Gindex)-1):maxValues(2),minValues(3):span(3)/(gridResValues(Gindex)-1):maxValues(3));
    [MLSValues, MLSError]=arrayfun(MLSOracleHandle, X, Y, Z);
    load([dataFolder filesep currFileName, '-Gvalues-' int2str(Gindex), '.mat']);
    
    disp(['Execution time: ', num2str(toc), ' s']);
    disp(['Maximum absolute error for MLS values: ' num2str(max(max(max(abs(MLSValues-MLSValuesRef)))))]);
    disp(['Maximum absolute error for MLS error: ' num2str(max(max(max(abs(MLSError-MLSErrorRef)))))]);
    disp(' ');
end





