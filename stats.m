% Azadeh example for using multcompare for stats
load('AvgStartCount.mat')

% labeling the groups
Label = {'ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl',...
    'Sham','Sham','Sham','Sham','Sham','Sham','Sham','Sham','Sham','Sham',...
    '2W','2W','2W','2W','2W','2W','2W','2W','2W','2W','2W',...
    '1M','1M','1M','1M','1M','1M','1M','1M','1M',...
    'EE','EE','EE','EE','EE','EE','EE','EE','EE','EE',...
    };

Label2 = {'ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl',...
    'ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl',...
    'Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk',...
    'Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk',...
    'Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk',...
    };

Label3 = {'ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl','ctrl',...
    'sham','sham','sham','sham','sham','sham','sham','sham','sham','sham',...
    'Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk',...
    'Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk',...
    'Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk','Stk',...
    };
%% all groups: label

% Left
% values for each group
Left = FullStartCountL;
Left(find(isnan(Left))) = [];

% one-way anova for gruops with different sizes
[p,a,s] =  anova1(Left,Label);

% multiple comparison between groups
[c,m,h,nms] = multcompare(s);

% table of comparisons
[nms(c(:,1)), nms(c(:,2)), num2cell(c(:,3:6))]

%   Right
% values for each group
Right = FullStartCountR;
Right(find(isnan(Right))) = [];

% one-way anova for gruops with different sizes
[p,a,s] =  anova1(Right,Label);

% multiple comparison between groups
[c,m,h,nms] = multcompare(s);

% table of comparisons
[nms(c(:,1)), nms(c(:,2)), num2cell(c(:,3:6))]

%% sham and control versus all stroke: label 2
% Left
% values for each group
Left = FullStartCountL;
Left(find(isnan(Left))) = [];

% one-way anova for gruops with different sizes
[p,a,s] =  anova1(Left,Label2);

% multiple comparison between groups
[c,m,h,nms] = multcompare(s);

% table of comparisons
[nms(c(:,1)), nms(c(:,2)), num2cell(c(:,3:6))]

%   Right
% values for each group
Right = FullStartCountR;
Right(find(isnan(Right))) = [];

% one-way anova for gruops with different sizes
[p,a,s] =  anova1(Right,Label2);

% multiple comparison between groups
[c,m,h,nms] = multcompare(s);

% table of comparisons
[nms(c(:,1)), nms(c(:,2)), num2cell(c(:,3:6))]

%% control versus sham and all stroke: label 3
% Left
% values for each group
Left = FullStartCountL;
Left(find(isnan(Left))) = [];

% one-way anova for gruops with different sizes
[p,a,s] =  anova1(Left,Label3);

% multiple comparison between groups
[c,m,h,nms] = multcompare(s);

% table of comparisons
[nms(c(:,1)), nms(c(:,2)), num2cell(c(:,3:6))]

%   Right
% values for each group
Right = FullStartCountR;
Right(find(isnan(Right))) = [];

% one-way anova for gruops with different sizes
[p,a,s] =  anova1(Right,Label2);

% multiple comparison between groups
[c,m,h,nms] = multcompare(s);

% table of comparisons
[nms(c(:,1)), nms(c(:,2)), num2cell(c(:,3:6))]