% find the maginal Hilbert Spectrum

%-------------------------------JDSA---------------------------------------
% A is the sum of the contribution of each frequency component in the freq
% vector for all time points.
% 
% F is the vector with the frequency axis, use it as x axis to plot the mhs
% 
% HS is the hilbert spectrum amplitudes, one imf per coulmn
%
% freq is the instantaneous frequency, one instantaneous frequency per
% column
%
% Flag (1 or 0) flag=1 is used to quantize the values of the instantaneous 
% frequency, then values inside a unit of the resolution ar counted as as
% the same frequency. for instance if you have 2 frequencies 10,34 and 
% 10,45 and the resolution is .25, those 2 frequencies are counted each one
% as 10,5 and the mhs sum the amplitude related to each frequency as if 
% they belong to the same frequency value, this produce smooted graphs
% fs is the sample rate of the original signal.
% flag = 0 dont quantize the vectors of instantaneous frequency

%NOTE:TAKE ON COUNT THAT THE FREQUENCY AXIS IS NOT EQUALLY ESPACED, FROM
%THE INSTANTANEOUS FREQUENCY SOME VALUES OF F ARE NEVER REACHED, THE IF CAN
%CHANGE FOR INSTANCE FROM 12.5 TO 14.5 AND 13 AND 13.5 DO NOT APPEAR AS 
%HAVING 0 (ZERO) CONTRIBUTION
%
function [A,ftemp]=mhs_func(cs,data_imf,data_tanso)
%close all;clear all;clc;
%data_imf='imf2021plus.txt';
%data_tanso='tansoplus.txt';
%HST = textread(data_imf);
HST =data_imf;
%freqT = textread(data_tanso);
freqT = data_tanso;
%cs=7; % chi so hinh can ve
HS=HST(:,cs); freq=freqT(:,cs);
HS = reshape(HS,1,[])';
freq = reshape(freq,1,[])';
flag=1;
fs=500;
fres=0.02;
if flag==1
    if (fres > 1 || fres <= 0) 
        disp('The value of resolution should be > 0 and <= 1Hz')
        return
    end
    fraction = log(1/fres)/log(2);
    wordlength = nearest(log(((fs/2-fraction)*2^(fraction))+1)/log(2));
    q = quantizer('ufixed', 'nearest', 'saturate', [wordlength fraction]);
    freq = quantize(q,freq);

end

i=1;
while isempty(freq)==0
    indx = find(freq==freq(1));
    ftemp(i)= freq(1);
    Atemp(i)=sum(HS(indx));
    freq(indx)=0;
    HS(indx)=0;
    freq = freq(freq~=0);
    HS=HS(HS~=0);
    i = i + 1;
end

[F indx] = sort(ftemp);
A = abs(Atemp(indx));
% figure
% plot(sort(ftemp),abs(Atemp(indx)),'-.');
% title('Marginal Hilbert Spectrum');
% xlabel('Frequency(Hz)'), ylabel('Amplitude(Gal)');
end


      