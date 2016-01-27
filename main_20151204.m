
%% RUN DATA EXTRACTION

% single stiched
DICfilen = catstr('../04_StichedFields/Beam3Processed_0',[1982 2175 2351 2604 2788 3159 3304]','_s.mat'); %0 364 965 1222 1477 1641 1817 1982 2175 2351 2604 XXXX 3159 3304

% single raw
% filen = {'test-sys1-00364_3.mat'};

% multiple raw files
% filen = [catstr('test-sys1-00',[364 617 965],'_3.mat');...
%          catstr('test-sys1-0',[1222 1477 1641 1986 2415 2895 3304],'_3.mat')];



%%
% use gui to select DIC files
%DICcrack = DICextract;


%%

% the filenames and pathnames are relative to the current directory 
% -->  current directory must be 03_Scripts

%opt.cont    = [0:0.05:15]*1E-3;  
opt.cont    = logspace(-6,-2,20);  
opt.filenout = 'beam3_cracks';
opt.dirout   = '../05_CrackAnalysis';

opt.rpos  = [0.33 0.5 0.66];
opt.dist  = [25 -25];

%%DICcrack = DICextract(DICfilen(16),opt);

DICcrack = DICextract(DICfilen,opt);
%%
% [filen, pathn] = uigetfile([opt.dirout '/' opt.filenout '*.mat']);
% load([pathn filen]);

%% CREATE CONTOUR PLOTS

% conto = [1:0.5:15]*1E-3;
% figure
% contour(stitchedInfo.x,-stitchedInfo.y,stitchedInfo.e1,conto)
% set(gca,'dataAspectRatio',[1 1 1])

% hold on
% contour(x_0,-y_0,e1_0,conto)
% contour(x_1,-y_1,e1_1,conto)
% contour(x_2,-y_2,e1_2,conto)

%% ANALYSIS FOR SINGLE PLOT
opt.crackscale = 10;
opt.maxcrack   = 20;
opt.smooth     = 5;%5;
opt.scale      = 0.1837; %mm/pixel


nplines = size(DICcrack,1);
ntimes  = size(DICcrack(1).DICfilen,2);

% polyline i
for i=[3 5 8 12 21 24 28 33] %1:nplines
    
% point along segment: k
k=2;

s   = cat(1,DICcrack(i).p(:,k).s);
a   = cat(1,DICcrack(i).p(:,k).alpha);

m   = cat(1,DICcrack(i).p(:,k).m);

du  = cat(1,DICcrack(i).p(:,k).du);
dv  = cat(1,DICcrack(i).p(:,k).dv);
d   = cat(1,DICcrack(i).p(:,k).d);
d00 = cat(1,DICcrack(i).p(:,k).d00);
d90 = cat(1,DICcrack(i).p(:,k).d90);

a = smooth(a,opt.smooth);
for tj = 1:ntimes
    d00(:,tj) = smooth(d00(:,tj),opt.smooth);
    d90(:,tj) = smooth(d90(:,tj),opt.smooth);
end
clear u v e1
for j = 1:DICcrack(i).nseg
    for tj = 1:ntimes
        u(j,tj,:)   = DICcrack(i).p(j,k).u(:,tj);
        v(j,tj,:)   = DICcrack(i).p(j,k).v(:,tj);
        e1(j,tj,:)  = DICcrack(i).p(j,k).e1(:,tj);
    end
end

% for all time frame t (dim2)
close all

h1 = figure; hold on
h2 = figure; hold on
h3 = figure; hold on
h4 = figure; hold on
h5 = figure; hold on
h6 = figure; hold on

figure(h1)
plot(s*opt.scale,a,'displayname','inclination')
xlabel('station along crack  $s$ [mm]')
ylabel('inclination $\alpha$')

clear plotopt
plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d')  '_incl_'];
plotopt.path      = [opt.dirout '/figures'];
plotopt.format    = 'pdf';
plotopt.lineStyle = 'n';
figplot(h1,plotopt)

for t = 1:ntimes
    frame = strrep(DICcrack(i).frame{t},'_','-');
    
    figure(h2)
	l1 = plot(s*opt.scale,u(:,t,1)*opt.scale,'-','Color',getColor(t));
    l2 = plot(s*opt.scale,u(:,t,2)*opt.scale,'--','Color',getColor(t));
		
	if t == 1
		set(l1,'displayname',['frame ' frame ' - side1'])
		set(l2,'displayname',['frame ' frame ' - side2'])
	else
		set(l1,'displayname',['frame ' frame ''])
		set(get(l2.Annotation,'LegendInformation'),'IconDisplayStyle','off');
	end
	
	xlabel('station along crack $s$ [mm]')
    ylabel('horizontal deformation $u$ [mm]')

    figure(h3)
    l1 = plot(s*opt.scale,v(:,t,1)*opt.scale,'-','Color',getColor(t));
    l2 = plot(s*opt.scale,v(:,t,2)*opt.scale,'--','Color',getColor(t));
    
	if t == 1
		set(l1,'displayname',['frame ' frame ' - side1'])
		set(l2,'displayname',['frame ' frame ' - side2'])
	else
		set(l1,'displayname',['frame ' frame ''])
		set(get(l2.Annotation,'LegendInformation'),'IconDisplayStyle','off');
	end
	
	xlabel('station along crack $s$ [mm]')
    ylabel('vertical deformation $v$ [mm]')

    figure(h4)
    l1 = plot(s*opt.scale,e1(:,t,1)*1000,'-','Color',getColor(t));
    l2 = plot(s*opt.scale,e1(:,t,2)*1000,'--','Color',getColor(t));
    
	if t == 1
		set(l1,'displayname',['frame ' frame ' - side1'])
		set(l2,'displayname',['frame ' frame ' - side2'])
	else
		set(l1,'displayname',['frame ' frame ''])
		set(get(l2.Annotation,'LegendInformation'),'IconDisplayStyle','off');
	end
	
    xlabel('station along crack $s$ [mm]')
    ylabel('principal strain $10^3 e_1$')

    figure(h5)
    plot(s*opt.scale,d90(:,t)*opt.scale,'displayname',['frame ' frame ''],'Color',getColor(t))
    xlabel('station along crack $s$ [mm]')
    ylabel('crack opening $w_{90}$ [mm]')

    figure(h6)
    plot(s*opt.scale,d00(:,t)*opt.scale,'displayname',['frame ' frame ''],'Color',getColor(t))
    xlabel('station along crack $s$ [mm]')
    ylabel('crack slip $w_{00}$ [mm]')
end

figure(h2),legend show
plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d') '_u'];
figplot(h2,plotopt)

figure(h3),legend show
plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d') '_v'];
figplot(h3,plotopt)

figure(h4),legend show
plotopt.filen     =  [opt.filenout '_line_' num2str(i,'%3.3d') '_e1'];
figplot(h4,plotopt)

figure(h5),legend show
plotopt.filen     =  [opt.filenout '_line_' num2str(i,'%3.3d') '_d90'];
figplot(h5,plotopt)

figure(h6),legend show
plotopt.filen     =  [opt.filenout '_line_' num2str(i,'%3.3d') '_d00'];
figplot(h6,plotopt)

end

figpos([h1 h2 h3 h4 h5 h6])

%% plot crack pattern

close all
clear h10

opt.maxcrack = 5;

for t = 1:ntimes %[3 5 10 16]
    frame = strrep(DICcrack(i).frame{t},'_','-');
    
    h10(t) = figure;
    title(['crack pattern frame ' frame])
    hold on
    set(gca,'dataAspectRatio',[1 1 1])

		
    for i= 1:nplines
		w1 = 0;
        for j = 1:DICcrack(i).nseg
             
			 % info if sufficient correlation level
			 m  = DICcrack(i).p(j,k).m(:,t) > 0.6;
			 
			 if all(m)
				 %line width according to crack opening
				 w1 = DICcrack(i).d90(j,t)*opt.scale; %set some kind of threshold to kick out
				 % the values that are no correlated (use the mask)
				 w1 = min(abs(w1),opt.maxcrack);				 
			 else
				w1 = max(0.01,w1); 
			 end
			 			 
             % current slip
             %w2 = DICcrack(i).p(j,k).d00(t)*opt.scale;
             
             % set line color to white if below certain opening
             if abs(w1) < 0.01
                 col = [1 1 1];
             else
                 col = [0 0 0];
			 end
			 
			 % set line to grey if bad correlation
			 if ~all(m)
				 col = 0.6 * [1 1 1];
			 end
                         
             plot(DICcrack(i).coo(j:j+1,1),-DICcrack(i).coo(j:j+1,2),'k',...
                 'linewidth',w1 *opt.crackscale,...
                 'color',col);    
             xlabel('x-coordinate [pixel]') 
		     ylabel('z-coordinate [pixel]')
            
        end
    end
 
figure(h10(t))
plotopt.filen     = [opt.filenout '_frame_' frame '_e1'];
plotopt.format    = {'pdf'};

plotopt.lineStyle = 'nW';
plotopt.legend    = 'off';
plotopt.size = [25 10];

figplot(h10(t),plotopt)
    
end

figpos(h10)
close all


%% plot crack slip map

% close all
% clear h10
% 
% for t = 1:ntimes %[3 5 10 16]
%     frame = strrep(DICcrack(i).frame{t},'_','-');
%     
%     h10(t) = figure;
%     title(['crack pattern frame ' frame])
%     hold on
%     set(gca,'dataAspectRatio',[1 1 1])
% 
% 		
%     for i=1:nplines
% 		w1 = 0;
%         for j = 1:DICcrack(i).nseg
%              
% 			 % info if sufficient correlation level
% 			 m  = DICcrack(i).p(j,k).m(:,t) < 0.5;
% 			 
% 			 if ~all(m)
% 				 %line width according to crack opening
% 				 w2 = DICcrack(i).d00(j,t)*opt.scale; %set some kind of threshold to kick out
% 				 % the values that are no correlated (use the mask)
% 				 w2 = min(abs(w2),opt.maxcrack);
% 				 % w1 = max(0.001,w1);
% 			 else
% 				 %w1 = 0;
% 			 end
%              
%              % set line color to white if below certain opening
%              if abs(w2) < 0.01
%                  col = [1 1 1];
%              else
%                  col = [0 0 0];
% 			 end
% 			 
% 			 % set line to grey if bad correlation
% 			 if all(m)
% 				 col = 0.4 * [1 1 1];
% 			 end
%                          
%              plot(DICcrack(i).coo(j:j+1,1),-DICcrack(i).coo(j:j+1,2),'k',...
%                  'linewidth',w2 *opt.crackscale,...
%                  'color',col);    
%              
%              xlabel('x-coordinate [pixel]') 
%              ylabel('z-coordinate [pixel]') 
%         end
%     end
% 
% figure(h10(t))
% plotopt.filen     = [opt.filenout '_frame_' frame '_e1'];
% plotopt.format    = {'pdf'};
% 
% plotopt.lineStyle = 'nW';
% plotopt.legend    = 'off';
% plotopt.size = [25 10];
% 
% figplot(h10(t),plotopt)
%     
% end
% 
% figpos(h10)
% close all


%%

% opt.filenout = 'beam3_deform';
% opt.dirout   = '../05_DeformationAnalysis';
% 
% opt.rpos     = 0.01:0.01:0.99;
% opt.dist	 = [25 -25];
% 
% DICdef = DICextract(DICfilen,opt);
% 
% 
% 
% %% plot deflection line
% opt.crackscale = 3;
% opt.maxcrack   = 20;
% 
% nplines = size(DICdef,1);
% ntimes  = size(DICdef(1).DICfilen,2);
% 
% % polyline i
% for i=1:nplines
%     
% close all
% 	
% clear u v e1 m   
% % for segment 1
% j=1;
% 
% s   = cat(1,DICdef(i).p(1,:).s);
% a   = cat(1,DICdef(i).p(1,:).alpha);
% 
% 
% du  = cat(1,DICdef(i).p(1,:).du) ;
% dv  = cat(1,DICdef(i).p(1,:).dv);
% d   = cat(1,DICdef(i).p(1,:).d);
% d00 = cat(1,DICdef(i).p(1,:).d00);
% d90 = cat(1,DICdef(i).p(1,:).d90);
% phi = cat(1,DICdef(i).p(1,:).phi);
% 
% for k = 1:length(DICdef(i).rpos)    
%     for tj = 1:size(d,2)
%         side = 1;
%         u(k,tj,:)   = DICdef(i).p(j,k).u(:,tj);
%         v(k,tj,:)   = DICdef(i).p(j,k).v(:,tj);
%         e1(k,tj,:)  = DICdef(i).p(j,k).e1(:,tj);
% 		
% 		m(k,tj,:)   = DICdef(i).p(j,k).m(:,tj) < 0.5;
%     end
% end
% 
% 
% a = smooth(a,5);
% for tj = 1:size(d,2)
%     d00(:,tj) = smooth(d00(:,tj),5);
%     d90(:,tj) = smooth(d90(:,tj),5);
% end
% 
% m = all(m,3);
% 
% dum = {'u','v','e1'};
% for ii = 1:length(dum)
% 	eval([dum{ii} '(m) = NaN']);
% end
% 
% dum = {'du','dv','d','d00','d90','phi'};
% for ii = 1:length(dum)
% 	eval([dum{ii} '(m) = NaN']);
% end
% 
% 
% 
% % for all time frame t (dim2)
% 
% 
% clear plotopt
% plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d')  '_defl_'];
% plotopt.path      = opt.dirout;
% plotopt.legend    = 'off';
% plotopt.format    = 'pdf';
% plotopt.lineStyle = 'n';
% 
% h1 = figure; hold on
% h2 = figure; hold on
% h3 = figure; hold on
% h4 = figure; hold on
% h5 = figure; hold on
% h6 = figure; hold on
% h7 = figure; hold on
% 
% for t = 1:ntimes
%     frame = strrep(DICdef(i).frame{t},'_','-');
% 
%     figure(h1)
% 	dumv = mean(v(:,t,1),3);
%     plot(s*opt.scale,dumv*opt.scale,'--','displayname',['frame ' frame ''],'Color',getColor(t))
%     xlabel('station along crack  $s$ [mm]')
%     ylabel('deflection $w$ [mm]')
% 
%     figure(h2)
% 	dumu = mean(u(:,t,1),3);
%     plot(s*opt.scale,dumu*opt.scale,'--','displayname',['frame ' frame ''],'Color',getColor(t))
%     xlabel('station along crack  $s$ [mm]')
%     ylabel('horizontal shift $u$ [mm]')
% 
% 	figure(h3)
% 	dumv = dv(:,t,1);
%     plot(s*opt.scale,dumv*opt.scale,'--','displayname',['frame ' frame ''],'Color',getColor(t))
%     xlabel('station along crack  $s$ [mm]')
%     ylabel('change in deflection $dw$ [mm]')
% 	
%     figure(h4)
% 	dumu = du(:,t,1);
%     plot(s*opt.scale,dumu*opt.scale,'--','displayname',['frame ' frame ''],'Color',getColor(t))
%     xlabel('station along crack  $s$ [mm]')
%     ylabel('change in shift $du$ [mm]')    
% 
% 	figure(h5)
% 	dum = d00(:,t,1);
%     plot(s*opt.scale,dum*opt.scale,'--','displayname',['frame ' frame ''],'Color',getColor(t))
%     xlabel('station along crack  $s$ [mm]')
%     ylabel('change in deformation $d00$ [mm]')
% 	
%     figure(h6)
% 	dum = d90(:,t,1);
%     plot(s*opt.scale,dum*opt.scale,'--','displayname',['frame ' frame ''],'Color',getColor(t))
%     xlabel('station along crack  $s$ [mm]')
%     ylabel('change in deformation $d90$ [mm]')   
% 	
%     figure(h7)
% 	dum = phi(:,t,1);
%     plot(s*opt.scale,dum*opt.scale,'--','displayname',['frame ' frame ''],'Color',getColor(t))
%     xlabel('station along crack  $s$ [mm]')
%     ylabel('rotation $\phi$ [mm]')   	
% end
% 
% figure(h1)
% plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d') '_verDefl'];
% figplot(h1,plotopt)
% 
% figure(h2)
% plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d') '_horShift'];
% figplot(h2,plotopt)
% 
% figure(h3)
% plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d') '_dverDefl'];
% figplot(h3,plotopt)
% 
% figure(h4)
% plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d') '_dhorShift'];
% figplot(h4,plotopt)
% 
% figure(h5)
% plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d') '_dparDef'];
% figplot(h5,plotopt)
% 
% figure(h6)
% plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d') '_dperDef'];
% figplot(h6,plotopt)
% 
% figure(h7)
% plotopt.filen     = [opt.filenout '_line_' num2str(i,'%3.3d') '_rot'];
% figplot(h7,plotopt)
% 
% figpos([h1 h2 h3 h4 h5 h6 h7])
% pause
% end

