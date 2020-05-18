function [V,N] = load_noff_file(filename)

fid = fopen(filename,'r');
if( fid==-1 )
    error('Cannot open the file.');
    return;
end

str = fgets(fid);   % -1 if eof
if ~strcmp(str(1:4), 'NOFF')
    error('The file is not a valid OFF one.');    
end

str = fgets(fid);
sizes = sscanf(str, '%d %d %d', 3);
nv = sizes(1);

% Read vertices and normals
[VN,cnt] = fscanf(fid,'%lf %lf %lf %lf %lf %lf\n', [6,nv]);
if cnt~=6*nv
    warning('Problem in reading vertices.');
end
VN = VN';

V = VN(:,1:3);
N = VN(:,4:6);

fclose(fid);