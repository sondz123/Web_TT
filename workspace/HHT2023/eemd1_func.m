function [TH,allmode,instataneousfrequency,phase2023]=eemd1_func(tenfile)
%function allmode=eemd(Y,Nstd,NE)
%close all;clear all;
%tenfile='input300gal.txt' % nhap ten file can xu ly
[A,B] = textread(tenfile,'%f %f'); 
Y=B(1:length(B));
Nstd=0.1; % can nang cap
NE=10;% can lam ro
%part1.read data, find out standard deviation ,devide all data by std
xsize=length(Y);
dd=1:1:xsize;
Ystd=std(Y);
Y=Y/Ystd;

%part2.evaluate TNM as total IMF number,ssign 0 to TNM2 matrix
TNM=fix(log2(xsize))-1;
TNM2=TNM+2;
for kk=1:1:TNM2, 
    for ii=1:1:xsize,
        allmode(ii,kk)=0.0;
    end
end

%part3 Do EEMD  -----EEMD loop start
for iii=1:1:NE,   %EEMD loop -NE times EMD sum together
  
    %part4 --Add noise to original data,we have X1
    for i=1:xsize,
        temp=randn(1,1)*Nstd;
        X1(i)=Y(i)+temp;
    end

    %part4 --assign original data in the first column  
    for jj=1:1:xsize,
        mode(jj,1) = Y(jj);
    end
    
    %part5--give initial 0 to xorigin and xend
    xorigin = X1;
    xend = xorigin;
    
    %part6--start to find an IMF-----IMF loop start
    nmode = 1;
    while nmode <= TNM,
        xstart = xend; %last loop value assign to new iteration loop 
                       %xstart -loop start data
        iter = 1;      %loop index initial value
 
        %part7--sift 10 times to get IMF---sift loop  start 
        while iter<=10,
            [spmax, spmin, flag]=extrema(xstart);  %call function extrema 
            %the usage of  spline ,please see part11.  
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift 
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift 
            mean_ul = (upper + lower)/2;%spline mean of upper and lower  
            xstart = xstart - mean_ul;%extract spline mean from Xstart
            iter = iter +1;
        end
        %part7--sift 10 times to get IMF---sift loop  end      
        
        %part8--subtract IMF from data ,then let the residual xend to start to find next IMF 
         xend = xend - xstart;
   
   	     nmode=nmode+1;
        
        %part9--after sift 10 times,that xstart is this time IMF 
        for jj=1:1:xsize,
            mode(jj,nmode) = xstart(jj);
        end

    end
    %part6--start to find an IMF-----IMF loop end

    %part 10--after gotten  all(TNM) IMFs ,the residual xend is over all trend
    %                        put them in the last column  
    for jj=1:1:xsize,
        mode(jj,nmode+1)=xend(jj);
    end
    %after part 10 ,original +TNM-IMF+overall trend  ---those are all in mode    
     allmode=allmode+mode;
    
end
%part3 Do EEMD  -----EEMD loop end

%part10--devide EEMD summation by NE,std be multiply back to data
allmode=allmode/NE;
allmode=allmode*Ystd;

%part11--the syntax of the matlab function spline
%yy= spline(x,y,xx); this means
%x and y are matrixs of n1 points ,use n1 set (x,y) to form the cubic spline
%xx and yy are matrixs of n2 points,we want know the spline value yy(y-axis) in the xx (x-axis)position
%after the spline is formed by n1 points ,find coordinate value on the spline for [xx,yy] --n2 position. 
% dung comment 21April
% for ij=1:1:kk
% figure
% plot(allmode(:,ij));xlabel('Time'), ylabel('Amplitude eemd');
% %set(gca,'FontSize',8,'XLim',[0 c(end)],'YLim',[0 100]); xlabel('Time'), ylabel('Frequency');
% end
Fs=1000;
[hang cot]=size(allmode); % tim so hang cot
for csi=1:1:cot % max bang so cot (10)=====================
th12=imag(hilbert(allmode(:,csi)));th2= angle(hilbert(allmode(:,csi)));
instataneousfrequency(:,csi) =Fs*diff(unwrap(th2)/(2*pi)); 
phase2023(:,csi)=unwrap(th2)/(2*pi)
% figure
% subplot(2,1,1);
% plot(abs(instataneousfrequency(:,csi)));xlabel('Time'), ylabel('Frequency(Hz)');
% subplot(2,1,2);
% plot(phase2023(:,csi));xlabel('Time'), ylabel('Phase(Rad)');
end
%figure
[MM M] = size(allmode);
N = length(Y);
c = linspace(0,(N-1),N);
% for k1 = 0:8:M-1 %in 8 imf vao mot khung
%    figure
%    for k2 = 1:min(8,M-k1); subplot(8,1,k2); plot(c,allmode(:,k1+k2)); set(gca,'FontSize',9,'XLim',[0 c(end)]); end
%    xlabel('Time(s)');
% end
TH=0;
for k =1:M
    TH=TH+allmode(:,k);
end
% figure
% plot(TH)
end