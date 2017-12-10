% Load matlab worksplace image
warning('off','all')
load('gmm_models.mat')



%wavfile='./test/quels_sont_les_restaurants_ouverts_test_1.wav';
% Get the wav filename argument 
filename = strsplit(wavfile,'/');
filename = filename{length(filename)};
filename_split = strsplit(filename,'_');

%Train sizee
train_size=25;

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

mean_array = reshape(abs(nlog),train_size,length(phrases));
mean_array = mean(mean_array);
min_proba = min(mean_array);
phrase_index = find(mean_array == min_proba);

sound(test_audio,8000);
disp(sprintf('La phrase par la moyenne est : %s',strrep(phrases{phrase_index},'_',' ')));
disp(sprintf('La phrase par le min est : %s',strrep(GMMs{I,2},'_',' ')));


% Write the conversations result to txt file
fileID = fopen(sprintf('../Conversations/full_conversation_%s.txt',caller_id),'a');
question_details = sprintf('%s ; %s ; %s ; %s\n','Caller',datestr(now,'YYYY-mm-dd HH:MM:SS.FFF'),filename,strrep(GMMs{I,2},'_',' '));
nbytes = fprintf(fileID,question_details);


% Generate the response 
% ./matlab -nodesktop -r "cd ~/Desktop/MLProjets/VoiceChatboot/STT/; run('~/Desktop/MLProjets/VoiceChatboot/STT/prediction.m')"
responses_cell = cell(length(phrases),2);
for i=1:length(phrases)
    responses_cell{i,1} = phrases{i};
end

responses_cell{1,2} = {'Cava et toi ?','Super et toi mon gars ?','Parfait et toi ?'};
responses_cell{2,2} = {'Oui je vais bien et toi ?','je vais super bien et toi ?','Oui merci et toi ?'};
responses_cell{3,2} = {sprintf('Il est %s heures et %s minutes',datestr(now,'HH'),datestr(now,'MM')),sprintf('Actuellement il est %s heures et %s minutes',datestr(now,'HH'),datestr(now,'MM')),sprintf('La montre indique quil est %s heures et %s minutes Aissa',datestr(now,'HH'),datestr(now,'MM'))};
responses_cell{4,2} = {'Je mapelle Messi et toi ? ','On mapelle Messi parce que je suis aussi fort que lui ','On me surnomme Messi je suis un geni comme lui'};
responses_cell{5,2} = {'Bonjour ','Hey mon gars','Hello'};
responses_cell{6,2} = {'Les restaurants ouverts a proximite sont : Pizza hut a Gennvilliers, 209 a Saint Denis ','Aucun restaurant nest ouvert',sprintf('Tu te fou de moi connard ! il ya pas de restaurants ouvert a Gennevilliers a %s heures et %s minutes ! arretes de te foutre de moi sil te plait',datestr(now,'HH'),datestr(now,'MM'))};


response = '';
for i=1:length(phrases)
    if(strcmp(responses_cell{i,1},GMMs{I,2}))
       response =  responses_cell{i,2}{randi([1 3],1,1)}
    end
end



uniquefileID = fopen(sprintf('../Conversations/%s.txt',caller_id),'w');

% Asterisk lis le fichier txt apres il le supprime ... 
nbytes = fprintf(uniquefileID,response);
fclose(uniquefileID);


response_details = sprintf('%s ; %s ; %s ; %s\n','Chatboot',datestr(now,'YYYY-mm-dd HH:MM:SS.FFF'),'None',response);
nbytes = fprintf(fileID,response_details);
fclose(fileID);

quit;