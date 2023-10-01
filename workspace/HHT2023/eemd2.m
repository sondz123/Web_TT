function [allmode,instataneousfrequency,phase2023,A,ftemp] = eemd2(tenfile)
    %A
    %ftemp
    [TH,allmode,instataneousfrequency,phase2023]=eemd1_func(tenfile);
    [hang, cot]=size(instataneousfrequency);
    max_A = 0; max_ftemp = 0;
%     A = mhs_func(2,allmode,instataneousfrequency);
    for cs=2:1:cot
        [A,ftemp] = mhs_func(cs,allmode,instataneousfrequency);
        %sua tu day 12/9/2023
        sort_ftemp = sort(ftemp);
        if length(A) > max_A
            max_A = length(A);
        end
        if length(ftemp) > max_ftemp
            max_ftemp = length(ftemp);
        end
        for cs_f = 1:1:max_ftemp
            full_A(cs,cs_f) = NaN;
            full_ftemp(cs,cs_f) = NaN;
        end
        for cs_f = 1:1:length(ftemp)
            full_ftemp(cs,cs_f) = sort_ftemp(cs_f);
            full_A(cs,cs_f) = A(cs_f);
        end
    end
%     ftemp = mhs_func(2,allmode,instataneousfrequency);
%     for cs=2:1:cot
%         if(cs > 2) 
%             A = [A,mhs_func(cs,allmode,instataneousfrequency)]; 
%             ftemp = [ftemp,mhs_func(cs,allmode,instataneousfrequency)];
%         end
%     end
    allmode = allmode';
    instataneousfrequency = instataneousfrequency';
    phase2023 = phase2023';
    A = full_A;
    ftemp = full_ftemp;