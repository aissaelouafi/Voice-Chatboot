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

GMixtures = 10;

options=statset('Display','final','MaxIter',5000,'TolFun',1e-10);

%8 - 1500

% La liste des phrases a reconnaitres 
%phrases = {'cava','tu_vas_bien','quelle_heure_est_il','comment_tu_tappelle','bonjour','quels_sont_les_restaurants_ouverts'};
phrases = {'quelle_heure_est_il','comment_tu_tappelle','quels_sont_les_restaurants_ouverts'};

% train data size 
train_size = 25;

% GMM array
GMMs = cell(train_size*length(phrases),2);

g = 1;
% Read speech samples, sampling rate and precision from file
for j=1:length(phrases)
    for i=1:train_size
        % Construct train data filename
        file = sprintf('%s_%d',phrases{j},i);

        % Read the audio file
        audio_file = audioread(sprintf('%s%s%s','./train/',file,'.wav'));
        
        disp(file);
        % Calculate MFCCs features
        MFCCs = mfcc( audio_file, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
        
        %Calculate Gaussian mixture Model
        GMM = gmdistribution.fit(MFCCs,GMixtures,'CovType','diagonal');
        
        %Add GMM model to list
        GMMs{g,1} = GMM;
        
        %Add the phrase 
        GMMs{g,2} = phrases{j};
        
        %Increment GMMs index
        g=g+1;

    end
end

save('gmm_models')