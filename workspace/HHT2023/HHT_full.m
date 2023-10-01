close all;clear all;
%tenfile='input300gal.txt'
tenfile=input('nhap ten file (vi du:input300gal.txt): ','s');% nhap ten file
[TH,allmode,instataneousfrequency]=eemd1_func(tenfile);
cs=1;
while cs~=0;
cs=input(' nhap so thu tu ham imf (nhap 0 thoat): ')
figure;
[A,ftemp]=mhs_func(cs,allmode,instataneousfrequency)
end