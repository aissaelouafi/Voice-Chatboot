% Load matlab worksplace image
load('gmm_models.mat')

% Phrase list
phrases = {'cava','tu_vas_bien','comment_tu_tappelle','bonjour'};

% Load test wav files
test_size = 3

for j=1:length(phrases)
    for i=1:test_size
        % Construct the wav file path 
        file = sprintf('%s_test_%d',phrases{j},i)
        
        % Read the wav file
        audio_file = audioread(sprintf('%s%s%s','./test/',file,'.wav'));
        
        % Generate MFCC features
        MFCCs_test = mfcc( audio_file, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';
        
        for g=1:length(GMMs)
            [POST_PROBA,nlog(g,i*j)] = posterior(GMMs{g},MFCCs_test);
end


    end
end
