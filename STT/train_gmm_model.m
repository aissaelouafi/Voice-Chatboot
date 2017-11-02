clear all; close all; clc;
fs = 8000;

% Define variables
Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)
alpha = 0.97;           % preemphasis coefficient
M = 20;                 % number of filterbank channels 
C = 12;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 300;               % lower frequency limit (Hz)
HF = 3700;              % upper frequency limit (Hz)

% Read speech samples, sampling rate and precision from file
bonjour_1 = audioread('./train/bonjour_1.wav');
bonjour_2 = audioread('./train/bonjour_2.wav');
bonjour_3 = audioread('./train/bonjour_3.wav');
bonjour_4 = audioread('./train/bonjour_4.wav');
bonjour_5 = audioread('./train/bonjour_5.wav');

% Gmm options

options=statset('Display','final','MaxIter',1500,'TolFun',1e-10);

% Generate MFCCs 
MFCCs_1 = mfcc( bonjour_1, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
MFCCs_2 = mfcc( bonjour_2, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
MFCCs_3 = mfcc( bonjour_3, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
MFCCs_4 = mfcc( bonjour_4, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
MFCCs_5 = mfcc( bonjour_5, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';


MFCCs_bonjour = [MFCCs_1;MFCCs_2;MFCCs_3;MFCCs_4;MFCCs_5];

GMM_bonjour = gmdistribution.fit(MFCCs_1,8,'CovType','diagonal');

% Read speech samples, sampling rate and precision from file
cava_1 = audioread('./train/cava_1.wav');
cava_2 = audioread('./train/cava_2.wav');
cava_3 = audioread('./train/cava_3.wav');
cava_4 = audioread('./train/cava_4.wav');
cava_5 = audioread('./train/cava_5.wav');


% Generate MFCCs 
MFCCs_cava_1 = mfcc( cava_1, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
MFCCs_cava_2 = mfcc( cava_2, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
MFCCs_cava_3 = mfcc( cava_3, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
MFCCs_cava_4 = mfcc( cava_4, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
MFCCs_cava_5 = mfcc( cava_5, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';

MFCCs_cava = [MFCCs_cava_1;MFCCs_cava_1;MFCCs_cava_1;MFCCs_cava_1;MFCCs_cava_1];
GMM_cava = gmdistribution.fit(MFCCs_cava_1,8,'CovType','diagonal');


test_audio = audioread('./train/cava_14.wav');
MFCCs_test = mfcc( test_audio, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';



[POST_cava,nlog(1)] = posterior(GMM_cava,MFCCs_test);
[POST_bonjour,nlog(2)] = posterior(GMM_bonjour,MFCCs_test);

[ V I]= min(abs(nlog));


%figure 
%plot(MFCCs_cava(:,1),MFCCs_cava(:,2),'.','MarkerSize',13,'color','blue')
%hold on 
%plot(MFCCs_bonjour(:,1),MFCCs_bonjour(:,2),'.','MarkerSize',13,'color','red')
