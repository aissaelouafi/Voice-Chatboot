Fs = 8000;

recObj = audiorecorder(44100, 16, 2);
[y,Fs] = audioread('../Records/test.wav');
dt= 1/Fs;
t = 0:dt:(length(y)*dt)-dt;
figure;
plot(t,y); xlabel('Seconds');ylabel('Amplitude');
