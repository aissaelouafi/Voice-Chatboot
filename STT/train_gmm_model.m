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

options=statset('Display','final','MaxIter',1500,'TolFun',1e-10);


% La liste des phrases a reconnaitres 
phrases = {'bonjour','cava','tu_vas_bien'};

% GMM array
GMMs = cell(15*length(phrases),2);

g = 1;
% Read speech samples, sampling rate and precision from file
for j=1:length(phrases)
    for i=1:15
        % Construct train data filename
        file = sprintf('%s_%d',phrases{j},i);

        % Read the audio file
        audio_file = audioread(sprintf('%s%s%s','./train/',file,'.wav'));
        
        % Calculate MFCCs features
        MFCCs = mfcc( audio_file, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
        
        %Calculate Gaussian mixture Model
        GMM = gmdistribution.fit(MFCCs,8,'CovType','diagonal');
        
        %Add GMM model to list
        GMMs{g,1} = GMM;
        
        %Add the phrase 
        GMMs{g,2} = phrases{j};
        
        %Increment GMMs index
        g=g+1;

    end
end


test_audio = audioread('./test/cava_test_4.wav');
MFCCs_test = mfcc( test_audio, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';

for g=1:length(GMMs)
    [POST_PROBA,nlog(g)] = posterior(GMMs{g},MFCCs_test);
end



%[ V I]= min(abs(nlog));
mean_array = reshape(nlog,15,length(phrases));
mean_array = mean(mean_array);
min_proba = min(mean_array);
phrase_index = find(mean_array == min_proba);

sound(test_audio,8000);
disp(sprintf('La phrase est : %s',strrep(phrases{phrase_index},'_',' ')));