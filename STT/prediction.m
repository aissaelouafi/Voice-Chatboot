% Load matlab worksplace image
load('gmm_models.mat')

% Load audio test file
test_audio = audioread('./test/comment_tu_tappelle_test_3.wav');
MFCCs_test = mfcc( test_audio, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L )';

for g=1:length(GMMs)
    [POST_PROBA,nlog(g)] = posterior(GMMs{g},MFCCs_test);
end


% Get the min proba & find the sentences
[ V I]= min(abs(nlog));

mean_array = reshape(abs(nlog),15,length(phrases));
mean_array = mean(mean_array);
min_proba = min(mean_array);
phrase_index = find(mean_array == min_proba);

sound(test_audio,8000);
disp(sprintf('La phrase par la moyenne est : %s',strrep(phrases{phrase_index},'_',' ')));
disp(sprintf('La phrase par le min est : %s',strrep(GMMs{I,2},'_',' ')));


% Write the conversations result to txt file
fileID = fopen(sprintf('../Conversations/%s.txt','893272829'),'a');
question_details = sprintf('%s -- %s -- %s\n','Caller',datestr(now,'YYYY-mm-dd HH:MM:SS.FFF'),strrep(GMMs{I,2},'_',' '));
nbytes = fprintf(fileID,question_details);
fclose(fileID);


% Generate the response 
