[y, fs] = audioread('sound.wav');    %Ū������
                                     %y���V�q�Afs�������W�v
time=(1:length(y))/fs;               %�ɶ��ܼ�
frame = abs(y);                      %���V�q������ȡA��energy�p�⤧��
frameNumber = size(frame,1);         %�o�ӭ��ɪ��`�V�q��

%energy
j = 1;count = 0;
energy = zeros(int16(length(y)/150+1), 1);    %��l��0�x�}
for i = 1:frameNumber            
        energy(j) = energy(j) + frame(i);     %�]�w�@��frame��150�ӦV�q
        count = count + 1;    %���ɪ�energy�����frame�����V�q������`�M
        if(count >= 150)
            count = 0;
            j = j + 1;
        end
end

energytime = (1:length(energy))/fs*150;    %����frame���ɶ�
minvoice = max(energy) * 0.05;             %�έ��q�ӧP�_end-point
speech = find(energy>minvoice);            %��쭵�ɤ��Ҧ����q>minvoice���I

%zero cross rate
zerorate = zeros(int16(length(y)/150+1), 1);
j = 1;count = 0;
for i = 1:frameNumber-1        %zero-cross rate:
        if y(i)*y(i+1) < 0     %�C��frame���A�V�q�q�L0�I������
            zerorate(j) = zerorate(j) + 1;
        end
        count = count + 1;
        if(count >= 150)
            count = 0;
            j = j + 1;
        end
end

zerotime = (1:length(zerorate))/fs*150;    %����frame���ɶ�

%pitch �����A�ϥ�acf�k
j = 1;count = 1;
acfs = zeros(int16(length(y)/150+1), 1);
for i = 1:frameNumber        %�������N�V�q�Hframe���Ϲj
        acfs(j,count) = frame(i);
        count = count + 1;
        if(count > 150)
            count = 1;
            j = j + 1;
        end
end

for i = 1:int16(length(y)/150)-1    %�ϥ�acf:�۾Fframe�����n
        acf(i) = dot(acfs(i, :), acfs(i+1, :));
end
acftime = (1:length(acf))/fs*150;   %����frame���ɶ�

%�L�Xwaveform
subplot(4,1,1);
plot(time, y);
xlim([min(time),max(time)]);
%�H���u�ХX���ɪ�end-point
line(time(speech(1)*150)*[1 1], [-1, 1], 'color', 'r');
line(time(speech(end)*150)*[1 1], [-1, 1], 'color', 'r');
title('Waveform');
xlabel('time');
ylabel('vector');
%�L�Xenergy
subplot(4,1,2);
plot(energytime,energy);
xlim([min(energytime),max(energytime)]);
%�H���u�e�X�H���q�P�Oend-point���u
line([min(energytime), max(energytime)], minvoice*[1 1], 'color', 'r');
title('Energy');
xlabel('time');
ylabel('energy');
%�L�X zero-crossing rate
subplot(4,1,3);
plot(zerotime,zerorate);
xlim([min(zerotime),max(zerotime)]);
title('Zero-crossing rate');
xlabel('time');
ylabel('rate');
%�L�X pitch
subplot(4,1,4)
plot(acftime, acf);
xlim([min(acftime),max(acftime)]);
title('Pitch');
xlabel('time');
ylabel('pitch');