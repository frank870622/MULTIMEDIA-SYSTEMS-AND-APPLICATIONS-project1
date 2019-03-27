[y, fs] = audioread('sound.wav');    %讀取音檔
                                     %y為向量，fs為取樣頻率
time=(1:length(y))/fs;               %時間變數
frame = abs(y);                      %取向量的絕對值，做energy計算之用
frameNumber = size(frame,1);         %這個音檔的總向量數

%energy
j = 1;count = 0;
energy = zeros(int16(length(y)/150+1), 1);    %初始化0矩陣
for i = 1:frameNumber            
        energy(j) = energy(j) + frame(i);     %設定一個frame為150個向量
        count = count + 1;    %音檔的energy為單個frame內的向量絕對值總和
        if(count >= 150)
            count = 0;
            j = j + 1;
        end
end

energytime = (1:length(energy))/fs*150;    %對應frame的時間
minvoice = max(energy) * 0.05;             %用音量來判斷end-point
speech = find(energy>minvoice);            %找到音檔內所有音量>minvoice的點

%zero cross rate
zerorate = zeros(int16(length(y)/150+1), 1);
j = 1;count = 0;
for i = 1:frameNumber-1        %zero-cross rate:
        if y(i)*y(i+1) < 0     %每個frame內，向量通過0點的次數
            zerorate(j) = zerorate(j) + 1;
        end
        count = count + 1;
        if(count >= 150)
            count = 0;
            j = j + 1;
        end
end

zerotime = (1:length(zerorate))/fs*150;    %對應frame的時間

%pitch 音高，使用acf法
j = 1;count = 1;
acfs = zeros(int16(length(y)/150+1), 1);
for i = 1:frameNumber        %首先先將向量以frame做區隔
        acfs(j,count) = frame(i);
        count = count + 1;
        if(count > 150)
            count = 1;
            j = j + 1;
        end
end

for i = 1:int16(length(y)/150)-1    %使用acf:相鄰frame的內積
        acf(i) = dot(acfs(i, :), acfs(i+1, :));
end
acftime = (1:length(acf))/fs*150;   %對應frame的時間

%印出waveform
subplot(4,1,1);
plot(time, y);
xlim([min(time),max(time)]);
%以紅線標出音檔的end-point
line(time(speech(1)*150)*[1 1], [-1, 1], 'color', 'r');
line(time(speech(end)*150)*[1 1], [-1, 1], 'color', 'r');
title('Waveform');
xlabel('time');
ylabel('vector');
%印出energy
subplot(4,1,2);
plot(energytime,energy);
xlim([min(energytime),max(energytime)]);
%以紅線畫出以音量判別end-point的線
line([min(energytime), max(energytime)], minvoice*[1 1], 'color', 'r');
title('Energy');
xlabel('time');
ylabel('energy');
%印出 zero-crossing rate
subplot(4,1,3);
plot(zerotime,zerorate);
xlim([min(zerotime),max(zerotime)]);
title('Zero-crossing rate');
xlabel('time');
ylabel('rate');
%印出 pitch
subplot(4,1,4)
plot(acftime, acf);
xlim([min(acftime),max(acftime)]);
title('Pitch');
xlabel('time');
ylabel('pitch');
