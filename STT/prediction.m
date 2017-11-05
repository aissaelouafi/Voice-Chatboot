% Load matlab worksplace image
load('gmm_models.mat')
disp(wavfile);



% Get the wav filename argument 
filename = strsplit(wavfile,'/');
filename = filename{length(filename)};
filename_split = strsplit(filename,'_');


% Call infos 
caller_id = filename_split{1};
 

% Load audio test file
audio_file = sprintf('../Records/%s',filename);
test_audio = audioread(audio_file);
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

%sound(test_audio,8000);
disp(sprintf('La phrase par la moyenne est : %s',strrep(phrases{phrase_index},'_',' ')));
disp(sprintf('La phrase par le min est : %s',strrep(GMMs{I,2},'_',' ')));


% Write the conversations result to txt file
fileID = fopen(sprintf('../Conversations/full_conversation_%s.txt',caller_id),'a');
question_details = sprintf('%s ; %s ; %s ; %s\n','Caller',datestr(now,'YYYY-mm-dd HH:MM:SS.FFF'),filename,strrep(GMMs{I,2},'_',' '));
nbytes = fprintf(fileID,question_details);


% Generate the response 
% ./matlab -nodesktop -r "cd ~/Desktop/MLProjets/VoiceChatboot/STT/; run('~/Desktop/MLProjets/VoiceChatboot/STT/prediction.m')"
response = sprintf('Il est %s heures et %s minutes Aissa',datestr(now,'HH'),datestr(now,'MM'));
response_details = sprintf('%s ; %s ; %s ; %s\n','Chatboot',datestr(now,'YYYY-mm-dd HH:MM:SS.FFF'),'None',response);
nbytes = fprintf(fileID,response_details);
fclose(fileID);

uniquefileID = fopen(sprintf('../Conversations/%s.txt',caller_id),'w');

% Asterisk lit le fichier txt apres il le supprime ... 
nbytes = fprintf(uniquefileID,response);
fclose(uniquefileID);

quit;