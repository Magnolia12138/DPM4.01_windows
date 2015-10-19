function [pos, neg] = pascal_data(cls, flippedpos, year)

% [pos, neg] = pascal_data(cls)
% Get training data from the PASCAL dataset.

setVOCyear = year;
globals; 
pascal_init;

if nargin < 2
  flippedpos = false;
end

try
  load([cachedir cls '_train_' year]);%����Ѿ�������ֱ��load(pos neg����)
catch
%   % positive examples from train+val
%   ids = textread(sprintf(VOCopts.imgsetpath, 'trainval'), '%s');
%   pos = [];
%   numpos = 0;
%   for i = 1:length(ids);
%     fprintf('%s: parsing positives: %d/%d\n', cls, i, length(ids));
%     rec = PASreadrecord(sprintf(VOCopts.annopath, ids{i}));%��ȡÿ���������ı�ע(xml�ļ���)
%     clsinds = strmatch(cls, {rec.objects(:).class}, 'exact');%������ʽ�ҵ�ÿ�������еı�ע����
%     % skip difficult examples
%     diff = [rec.objects(clsinds).difficult];
%     clsinds(diff) = [];
%     for j = clsinds(:)'
%       numpos = numpos+1;
%       pos(numpos).im = [VOCopts.datadir rec.imgname];
%       bbox = rec.objects(j).bbox;
%       pos(numpos).x1 = bbox(1);
%       pos(numpos).y1 = bbox(2);
%       pos(numpos).x2 = bbox(3);
%       pos(numpos).y2 = bbox(4);
%       pos(numpos).flip = false;
%       pos(numpos).trunc = rec.objects(j).truncated;
%       if flippedpos %�Ƿ�ˮƽ��ת
%         oldx1 = bbox(1);
%         oldx2 = bbox(3);
%         bbox(1) = rec.imgsize(1) - oldx2 + 1;
%         bbox(3) = rec.imgsize(1) - oldx1 + 1;
%         numpos = numpos+1;
%         pos(numpos).im = [VOCopts.datadir rec.imgname];
%         pos(numpos).x1 = bbox(1);
%         pos(numpos).y1 = bbox(2);
%         pos(numpos).x2 = bbox(3);
%         pos(numpos).y2 = bbox(4);
%         pos(numpos).flip = true;
%         pos(numpos).trunc = rec.objects(j).truncated;
%       end
%     end
%   end

%�����Լ�дһ��txt��ʽ�ı�ע��Ϣ�ļ�����ȡ
    pos = []; % �洢������Ŀ����Ϣ�����飬ÿ��Ԫ����һ���ṹ��{im, x1, y1, x2, y2}
    numpos = 0; % ������Ŀ�����(һ��ͼƬ�п��ܺ��ж��������Ŀ��)
    
    %�����ע���ļ�ΪinriaPersonPos.txt�Ǵ�Inria�������ݼ���õ�50���������ı�ע�ļ�����ʽΪ[x1 y1 x2 y2 RelativePath]
    [a,b,c,d,p] = textread('MyAnnotation.txt','%d %d %d %d %s'); % ע�⣺��ȡ��p������ʱ50*1��cell����
    
    % ����ѵ��ͼƬ�ļ�������ids
    for i = 1:length(a);
        if mod(i,10)==0
            fprintf('%s: parsing positives: %d/%d\n', cls, i, length(a));
        end;
        numpos = numpos+1; % ������Ŀ�����
        pos(numpos).im = p{numpos}; % ����cell��ԪʱҪ��{},���þ���Ԫʱ��()
        pos(numpos).x1 = a(numpos);
        pos(numpos).y1 = b(numpos);
        pos(numpos).x2 = c(numpos);
        pos(numpos).y2 = d(numpos);
        pos(numpos).flip = false;%������ˮƽ��ת
    end

  % negative examples from train (this seems enough!)
  ids = textread(sprintf(VOCopts.imgsetpath, 'train'), '%s');%������ѵ�����ϲ��Ҹ�����
  neg = [];
  numneg = 0;
  addpath('./VOCdevkit/VOCcode');
  for i = 1:length(ids);
    fprintf('%s: parsing negatives: %d/%d\n', cls, i, length(ids));
    rec = PASreadrecord(sprintf(VOCopts.annopath, ids{i}));
    clsinds = strmatch(cls, {rec.objects(:).class}, 'exact');
    if length(clsinds) == 0%���ĳ���������ǰ���ĳ����ģ���clsindsΪ�գ�˵����㶼�Ǹ�����
      numneg = numneg+1;
      neg(numneg).im = [VOCopts.datadir rec.imgname];
      neg(numneg).flip = false;
    end
  end
  
  save([cachedir cls '_train_' year], 'pos', 'neg');
end  
