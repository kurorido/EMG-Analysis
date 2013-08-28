function [out point]=moving_avg(data,dur)
l=length(data);
k=menu('Select the function','Average','RMS');
switch k
    case 1
        for i=1:(length(data)-dur);
            out(i,1)=mean(abs(data(i:i+dur,1)));
            point(i,1)=(i+i+dur)/2;
        end
    case 2
        for i=1:(length(data)-dur);
            out(i,1)=sqrt(sum(data(i:i+dur,1).^2)/dur);
            point(i,1)=(i+i+dur)/2;
        end
end