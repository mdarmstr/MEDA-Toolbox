function fig_h = plot_vec(vec,elabel,classes,xylabel,lcont,opt,vlabel,mult,maxv)

% Bar or line plot.
%
% plot_vec(vec) % minimum call
% plot_vecplot_vec(vec,elabel,classes,xylabel,lcont,opt,vlabel,mult,maxv) % complete call
%
% INPUTS:
%
% vec: [NxM] vector/s to plot.
%
% elabel: [Nx1] name of the vector elements (numbers are used by default)
%
% classes: [Nx1, str(N), {N}] groups for different visualization (a single
%   group by default)
%
% xylabel: {2} xlabel and ylabel (nothing by default)
%
% lcont: [NxL or Lx1] L control limits (nothing by default)
%
% opt: (str or num) options for data plotting.
%       0: line plot
%       1: bar plot (default)
%
% vlabel: [Mx1] name of the vectors (numbers are used by default)
%
% mult: [NxM] multiplicity of each row (1s by default)
%
% maxv: [1x3] thresholds for the different marker size (20, 50 and 100 by default)
%
%
% OUTPUTS:
%
% fig_h: (1x1) figure handle.
%
%
% EXAMPLE OF USE: To plot three lines with constant control limits:
%
% fig_h = plot_vec(randn(100,3),[],[],{'Functions','Time'},[1, -1, 3]);
%
%
% EXAMPLE OF USE: with labels and classes in observations and variable limit:
%
% fig_h = plot_vec(randn(5,3),{'one','two','three','four','five'},[1 1 1 2 2],{[],'Functions'},randn(5,1),1);
%
%
% EXAMPLE OF USE: with labels, multiplicity and classes in observations and variable limit:
%
% fig_h = plot_vec(randn(5,3),{'one','two','three','four','five'},[1 1 1 2 2],{[],'Functions'},randn(5,1),1,[],100*rand(5,1),[20 50 100]);
%
%
% coded by: Jose Camacho Paez (josecamacho@ugr.es)
%           Alejandro Perez Villegas (alextoni@gmail.com)
%           Michael Sorochan Armstrong (mdarmstr@ugr.es)
% last modification: 26/Jan/2023 - improved spacing of text labels.
%
% Copyright (C) 2022  University of Granada, Granada
% Copyright (C) 2022  Jose Camacho Paez
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% Parameters checking

% Set default values
routine=dbstack;
assert (nargin >= 1, 'Error in the number of arguments. Type ''help %s'' for more info.', routine(1).name);
if size(vec,1) == 1,     vec = vec'; end;
N = size(vec, 1);
M = size(vec, 2);
if nargin < 2 || isempty(elabel), elabel = 1:N; end;
if nargin < 3 || isempty(classes), classes = []; end;
if nargin < 4 || isempty(xylabel), xylabel = {'',''}; end;
if nargin < 5 || isempty(lcont),  lcont = []; end;
if nargin < 6 || isempty(opt),  opt = '1'; end;
if nargin < 7 || isempty(vlabel),  vlabel = 1:M; end;
if nargin < 8 || isempty(mult),    mult    = ones(N,1);         end;
if nargin < 9 || isempty(maxv),    maxv    = [20 50 100];       end;

% Convert int arrays to str
if isnumeric(opt), opt=num2str(opt); end

% Convert row arrays to column arrays
if size(elabel,1)  == 1, elabel = elabel'; end;
if size(classes,1) == 1, classes = classes'; end;
if size(lcont,1) == 1, lcont = lcont'; end;
if size(vlabel,1)  == 1, vlabel = vlabel'; end;
if size(mult,1) == 1, mult = mult'; end;
if size(maxv,2) == 1, maxv = maxv'; end;

% Convert num arrays to str
if ~isempty(elabel) && isnumeric(elabel), elabel=num2str(elabel); end
if ~isempty(vlabel) && isnumeric(vlabel), vlabel=num2str(vlabel); end
if ~isempty(classes) && isnumeric(classes), classes=num2str(classes); end

% Convert char arrays to cell
if ischar(elabel),  elabel = cellstr(elabel); end;
if ischar(classes), classes = cellstr(classes); end;
if ischar(xylabel),  xylabel = cellstr(xylabel); end;
if ischar(vlabel),  vlabel = cellstr(vlabel); end;

% Validate dimensions of input data
if ~isempty(elabel), assert (isequal(size(elabel), [N 1]), 'Dimension Error: 2nd argument must be N-by-1. Type ''help %s'' for more info.', routine(1).name); end;
if ~isempty(classes), assert (isequal(size(classes), [N 1]), 'Dimension Error: 3rd argument must be N-by-1. Type ''help %s'' for more info.', routine(1).name); end;
if ~isempty(xylabel), assert (length(xylabel) == 2, 'Dimension Error: 4th argument must contain 2 cell elements. Type ''help %s'' for more info.', routine(1).name); end;
if ~isempty(lcont), assert (isequal(size(lcont,1), N) || isequal(size(lcont,2), 1), 'Dimension Error: 5th argument must be N-by-L or L-by-1. Type ''help %s'' for more info.', routine(1).name); end;
assert (isequal(size(opt), [1 1]), 'Dimension Error: 6th argument must be 1-by-1. Type ''help %s'' for more info.', routine(1).name);
if ~isempty(vlabel), assert (isequal(size(vlabel), [M 1]), 'Dimension Error: 7th argument must be M-by-1. Type ''help %s'' for more info.', routine(1).name); end;
if ~isempty(mult), assert (isequal(size(mult), [N 1]), 'Dimension Error: 8th argument must be N-by-1. Type ''help %s'' for more info.', routine(1).name); end;
if ~isempty(maxv), assert (isequal(size(maxv), [1 3]), 'Dimension Error: 9th argument must be 1-by-3. Type ''help %s'' for more info.', routine(1).name); end;

% Validate values of input data
assert (isempty(find(opt~='0' & opt~='1')), 'Value Error: 6th argument must contain a binary value. Type ''help %s'' for more info.', routine(1).name);

% Convert constant limits in vectors
if ~isempty(lcont) && ~isequal(size(lcont,1), N), lcont = (lcont*ones(1,N))'; end;

% Exception: bar plot with multivariate vec and one-observation class
if ~opt && ~isempty(classes) && size(vec, 2)>1,
    unique_classes = unique(classes);
    assert (min(hist(classes,unique(classes)))>1, 'Exception: Cannot visualize a multivariate bar plot with one-observation classes. Try setting the 6th argument to 1.');
end;

%% Main code

% Create figure window
fig_h = figure;
hold on;

% Preprocess classes to force them start with 1, 2...n,
unique_classes = unique(classes,'stable');
if iscell(classes)
    ord_classes = arrayfun(@(x) find(strcmp(unique_classes, x), 1), classes);
else
    ord_classes = arrayfun(@(x) find(unique_classes == x, 1), classes);
end
unique_ord_classes = unique(ord_classes);

% Plot vectors

bins = [0 1 maxv Inf];

sizes = [];
for i=1:length(bins)-1
    sizes (i) = round(.5 * i^2 * pi);
end

% Plot multiplicity
for j=1:length(bins)-1,
    ind = mult>bins(j) & mult<=bins(j+1);
    if isnumeric(elabel)
        plot(elabel(find(ind)), 0*find(ind), 'ko', 'MarkerSize', sizes(j), 'HandleVisibility', 'off');
    else
        plot(find(ind), 0*find(ind), 'ko', 'MarkerSize', sizes(j), 'HandleVisibility', 'off');
    end
end

if ~isempty(classes)
    color_list = hsv(length(unique_classes));
    if opt == '0',
        if isnumeric(elabel) && length(elabel)==length(unique(elabel))
            plot(elabel,vec,'k','HandleVisibility', 'off');
        else
            plot(vec,'k','HandleVisibility', 'off');
        end
    end
    for i=1:length(unique_classes)
        ind = ord_classes == unique_ord_classes(i);
        if isnumeric(elabel) && length(elabel)==length(unique(elabel))
            vind = elabel(find(ind));
        else
            vind = find(ind);
        end


        if opt == '0',
            plot(vind, vec(ind,:), 'Color', 'none', 'Marker','O', 'MarkerFaceColor', color_list(i,:), 'DisplayName', unique_classes{i});
        else
           bar([0;vind;max(vind)+1], [zeros(1,size(vec,2));vec(ind,:);zeros(1,size(vec,2))], 0.8, 'FaceColor', color_list(i,:), 'EdgeColor', 'none', 'DisplayName', unique_classes{i});
        end
    end
else
    color_list = hsv(M);
    for i=1:M,
        if opt == '0',
            if isnumeric(elabel) && length(elabel)==length(unique(elabel))
                plot(elabel, vec(:,i), 'LineWidth', 2, 'Color', color_list(i,:), 'DisplayName', vlabel{i});
            else
                plot(vec(:,i), 'LineWidth', 2, 'Color', color_list(i,:), 'DisplayName', vlabel{i});
            end
        else
            if isnumeric(elabel) && length(elabel)==length(unique(elabel))
                bar(elabel, vec(:,i), 'FaceColor', color_list(i,:), 'EdgeColor', 'none', 'DisplayName', vlabel{i});
            else
                bar(vec(:,i), 'FaceColor', color_list(i,:), 'EdgeColor', 'none', 'DisplayName', vlabel{i});
            end
        end
    end
end

% Plot control limits
if ~isempty(lcont)
    hold on
    b = [0.5:(N+1);0.5:(N+1)];
    for i=1:size(lcont,2),
        a = [lcont(:,i)';lcont(:,i)'];
        plot(b(2:(end-1))',a(:),'r--','LineWidth',2,'HandleVisibility', 'off');
    end
end

% Get axes handler
axes_h = get(fig_h,'Children');
for i=1:length(axes_h)
    if strcmp(get(axes_h(i), 'type'), 'axes')
        set(axes_h(i), 'FontSize', 14);
        val=i;
    end
end
axes_h = axes_h(i);

%MDSA 20230120 - trying to find a general solution to the text labels.
if ~isempty(elabel) && N > 25

  %Differential vectors to find space in the plot for labels
  ons1 = zeros(N,1);
  ons2 = zeros(N,1);
  ons3 = zeros(N,1);
  onsdiff = zeros(N,3);

  for ii = 2:N-1, [~,min_idx] = min(abs([vec(ii,1) - vec(ii+1,1),vec(ii,1) - vec(ii-1,1)])); ons1(ii) = [vec(ii,1) - vec(ii+1,1),vec(ii,1) - vec(ii-1,1)](min_idx); end
  for ii = 3:N-2, [~,min_idx] = min(abs([vec(ii,1) - vec(ii+2,1),vec(ii,1) - vec(ii-2,1)])); ons2(ii) = [vec(ii,1) - vec(ii+2,1),vec(ii,1) - vec(ii-2,1)](min_idx); end
  for ii = 4:N-3, [~,min_idx] = min(abs([vec(ii,1) - vec(ii+3,1),vec(ii,1) - vec(ii-3,1)])); ons3(ii) = [vec(ii,1) - vec(ii+3,1),vec(ii,1) - vec(ii-3,1)](min_idx); end

  for ii = 1:N, [~,min_idx] = min([abs(ons1(ii)),abs(ons2(ii)),abs(ons3(ii))]); onsdiff(ii,min_idx) = [ons1(ii),ons2(ii),ons3(ii)](min_idx); end

  vecmtrx = [onsdiff, vec(:,1)];
  vecmtrx([1,end],:) = 0; %For large numbers of entries, labels on the edges look bad.
  [U,~,~] = svds((vecmtrx - mean(vecmtrx))./std(vecmtrx),1);
  top_labels = round((1-abs(25-N)/N)*N); %Assuming that we can fit all labels iff 25 elements
  [~,Idx] = sort(U.^2,'descend');
  Idx_top = Idx(1:top_labels);

else
  Idx_top = 1:N;
end

font_size = min(75/abs(N - 25) + 10, 16); %Expected number of elements = 25; between font sizes 11 and 16

for ii = 1:length(Idx_top)
  if vec(Idx_top(ii)) > 0
        text(Idx_top(ii),mean([0,0.75*vec(Idx_top(ii))]),elabel{Idx_top(ii)},'rotation',90,'horizontalalignment','left','FontSize',font_size);
  else
        text(Idx_top(ii),mean([0,0.75*vec(Idx_top(ii))]),elabel{Idx_top(ii)},'rotation',90,'horizontalalignment','right','FontSize',font_size);
  end
end

if ~isempty(xylabel)
    xlabel(xylabel{1}, 'FontSize', 16);
    ylabel(xylabel{2}, 'FontSize', 16);
end

% Set axis
axis tight;
ax = axis;
axis auto;
ax2 = axis;

%legend off
box on;
hold off;
if ~isempty(elabel) && min(vec) < 0
  axis([ax(1:2), 1.25.*max(abs(ax2(3:4))).*sign(ax2(3:4))]);
else
end


