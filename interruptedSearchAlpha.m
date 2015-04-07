function interrupted_search(ID_num, taskCondition)
try  
        


if nargin<2
    ID_num = input('Participant ID? ', 's');
    taskCondition = input('Task condition (1, 2 or 3)? '); 
end

tstamp = clock;
savefile = fullfile(pwd, 'Results', [sprintf('interruptedSearch-%02d-%02d-%02d-%02d-%02d-task-%d-participant-%s', tstamp(1), tstamp(2), tstamp(3), tstamp(4), tstamp(5), taskCondition), ID_num, '.txt']);
%savefile = fullfile(pwd, 'Results', 'savefile.txt');

fileID = fopen(savefile,'wt+');

fprintf(fileID,'Block\tTrial\tCR\tResponse\tPosition\tDirection\tSearchSize\tBlankStart\tStart\tTime\tEpoch\n');

  
Screen('Preference', 'SkipSyncTests', 1);

%% Experiment Variables.
scr_background = 127.5;
scr_no = 1;

white = WhiteIndex(scr_no);
black = BlackIndex(scr_no);

global black white scr_no;

scr_dimensions = Screen('Rect', scr_no);

xcen = scr_dimensions(3)/2;
ycen = scr_dimensions(4)/2;
xfull = scr_dimensions(3);
yfull = scr_dimensions(4);

% Set up Keyboard
WaitSecs(1);
KbName('UnifyKeyNames');
left_key = KbName('LeftArrow');
right_key = KbName('RightArrow');
down_key = KbName('DownArrow');
esc_key = KbName('Escape');
space_key = KbName('space');
yes_key = KbName('y');
no_key = KbName('n');
keyList = zeros(1, 256);
keyList([yes_key, no_key, left_key, right_key, esc_key, space_key]) = 1;
KbQueueCreate([], keyList); clear keyList

% Sound
InitializePsychSound;
pa = PsychPortAudio('Open', [], [], [], [], [], 256);
bp400 = PsychPortAudio('CreateBuffer', pa, [MakeBeep(400, 0.2); MakeBeep(400, 0.2)]);
PsychPortAudio('FillBuffer', pa, bp400);

% Open Window

scr = Screen('OpenWindow', scr_no, scr_background);

HideCursor;

Screen('BlendFunction', scr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('TextFont', scr, 'Ariel');


Screen('TextSize', scr, 40);

Priority(1);




%% Main body

%create_display;

%display_object(1, [xcen+100 ycen-400]);


count_text = 'The task will start in';
countdown_pause(5, count_text);

if taskCondition == 2

   for blockLoop = 1:10 
    
   taskB(60);
   
   if taskCondition ~= 10
   
   count_text = sprintf('Block %d of 10 is now complete. Pause for', blockLoop);
   countdown_pause(30, count_text);
   
   end
   
   end
   
elseif taskCondition == 3
    
    for blockLoop = 1:10 
    
   taskA(60, 2); 
   
   if taskCondition ~= 10
   
   count_text = sprintf('Block %d of 10 is now complete. Pause for', blockLoop);
   countdown_pause(30, count_text);
   
   end
   
   end
    
    
else
 
    for blockLoop = 1:3 
    
   taskA(10, 1); 
   
   if taskCondition ~= 10
   
   count_text = sprintf('Block %d of 10 is now complete. Pause for', blockLoop);
   countdown_pause(30, count_text);
   
   end
   
   end
    
end

count_text = 'The experiment will finish in';
countdown_pause(10, count_text);




%% Shutdown
fclose(fileID);
text_string = 'Thank you!'
DrawFormattedText(scr, text_string, 'center', 'center', 0);

Screen('Flip', scr);

WaitSecs(2);
KbQueueStop;
PsychPortAudio('Close');
sca;
Priority(0);
disp('All done!');
   
    
catch errMessage
      KbQueueStop;
    sca;
    rethrow(errMessage);
    
end



%% Subfunctions

function countdown_pause(time_loop, text_string)
    
    image = fullfile(pwd, 'Pictures', sprintf('%d.jpg', randi(50)));
    temp_image = imread(image, 'jpg');
    temp_texture = Screen('MakeTexture', scr, temp_image);
    
    KbQueueStart;
    for h = 1:time_loop
        time_max = time_loop + 1;
    msg = sprintf('%s %d s', text_string, time_max-h);
    DrawFormattedText(scr, msg, 'center', 0, 0);
    Screen('DrawTexture', scr, temp_texture);
    Screen('Flip', scr);
    WaitSecs(1);
        [~, first_press] = KbQueueCheck;
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif first_press(space_key)
            break
        end
    end

    Screen('Flip', scr);
    KbQueueStop;
    RestrictKeysForKbCheck([left_key, right_key, space_key]);
    WaitSecs(1);

end

function taskA(trialsNum, altTimings) 

shortTrials = randsample(1:trialsNum, (trialsNum / 2));

redTargetTrials = randsample(1:trialsNum, (trialsNum / 2));

smallTrials = randsample(1:trialsNum, (trialsNum / 2));

trialCounter = 0
    
for loop = 1:trialsNum
    
    
    
trialCounter = trialCounter + 1;

if isempty(find(smallTrials == trialCounter))
    
    num_items = 32;
    
else
    
    num_items = 16;
    
end

if isempty(find(redTargetTrials == trialCounter))
    
    targetColour = 1;
    
else
    
    targetColour = 2;
    
end

    
fixation_cross;

WaitSecs(0.5);

if altTimings == 2
    
   if isempty(find(shortTrials == trialCounter)) 
      
       searchDuration = 0.5;
       blankDuration = 1.6;
       
   else
       
       searchDuration = 0.1;
       blankDuration = 2;
       
   end  
   
else
    
       searchDuration = 0.1;
       blankDuration = 0.9;
    
end    

[objectElements, targetInfo, targetPos, targetDir] = create_grid(3, 2, targetColour, num_items);
blankStart = GetSecs-blankDuration;
reactionTime = 0;

for displayLoops = 1:8
    
baseRect = [0 0 420 420];

centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);

Screen('FillRect', scr, white, centeredRect);    
    
objectLoops = size(objectElements,1);
        
        for displayObject = 1:objectLoops 
            
            objecttype = cell2mat(objectElements(displayObject,1));
            objectcolour = cell2mat(objectElements(displayObject,2));
            x_final = cell2mat(objectElements(displayObject,3));
            y_final = cell2mat(objectElements(displayObject,4));
            
           
            
            display_object(objecttype, objectcolour, [x_final y_final]);
            
            
        end
 
        startSecs = Screen('Flip', scr, blankStart + blankDuration);
        
        if displayLoops == 1
        
        trialStart = startSecs;
                     
        end
 
 keyresponse = 'null';

 %startSecs = GetSecs;
 
 KbQueueStart();
 
 WaitSecs(searchDuration-0.02);
 
 [ pressed, first_press] = KbQueueCheck;
timeSecs = first_press(find(first_press));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif first_press(left_key)
            keyresponse = 'left'
            reactionTime = timeSecs - trialStart;
            disp(keyresponse);
            disp(reactionTime);
            
            break;
        elseif first_press(right_key)
            keyresponse = 'right'
            reactionTime = timeSecs - trialStart;
             disp(keyresponse);
            disp(reactionTime);
            
            break;   
        
        end

baseRect = [0 0 420 420];

centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);

Screen('FillRect', scr, white, centeredRect);

 blankStart = Screen('Flip', scr, startSecs+searchDuration);

 WaitSecs(blankDuration - 0.02);
 
 [ pressed, first_press] = KbQueueCheck;
timeSecs = first_press(find(first_press));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif first_press(left_key)
            keyresponse = 'left'
            reactionTime = timeSecs - trialStart;
            disp(keyresponse);
            disp(reactionTime);
            
            break;
        elseif first_press(right_key)
            keyresponse = 'right'
            reactionTime = timeSecs - trialStart;
             disp(keyresponse);
            disp(reactionTime);
            
            break;    
        
        end
 
  KbQueueStop;
%KbWait;

end

fprintf(fileID,'%d\t%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\n', blockLoop, loop, keyresponse, targetInfo, targetPos, targetDir, num_items, reactionTime, displayLoops);
    

end

end


function taskB(trialsNum) 

trialCounter = 0;

downTrialsNumber = trialsNum / 5;
redTrialsNumber = (trialsNum - downTrialsNumber) / 2;
downTrials = randsample(1:trialsNum, downTrialsNumber);

emptyTrials = setdiff(1:trialsNum, downTrials);
redTrials = randsample(emptyTrials, redTrialsNumber);

smallTrials = randsample(1:trialsNum, (trialsNum / 2));


    
for loop = 1:trialsNum
    
trialCounter = trialCounter + 1;  

if isempty(find(smallTrials == trialCounter))
    
    num_items = 32;
    
else
    
    num_items = 16;
    
end
    
fixation_cross;

WaitSecs(0.5);

if ~isempty(find(downTrials == trialCounter))
   
    targetOptionRed = 1;
    targetOptionBlue = 1;
    
elseif ~isempty(find(redTrials == trialCounter))
    
     targetOptionRed = 2;
    targetOptionBlue = 1;
    
else

        targetOptionRed = 1;
        targetOptionBlue = 2;
end



[objectElementsRed, targetInfoRed, targetPos, targetDir] = create_grid(1, targetOptionRed, 2, num_items);
[objectElementsBlue, targetInfoBlue, targetPos, targetDir] = create_grid(2, targetOptionBlue, 1, num_items);
targetInfo = strcat(targetInfoRed, targetInfoBlue);

searchDuration = 0.1;
blankDuration = 0.95;
blankStartB = GetSecs-blankDuration;
reactionTime = 0;

for displayLoops = 1:8
    
baseRect = [0 0 420 420];

centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);

Screen('FillRect', scr, white, centeredRect);    
    
objectLoops = size(objectElementsRed,1);
        
        for displayObject = 1:objectLoops 
            
            objecttype = cell2mat(objectElementsRed(displayObject,1));
            objectcolour = cell2mat(objectElementsRed(displayObject,2));
            x_final = cell2mat(objectElementsRed(displayObject,3));
            y_final = cell2mat(objectElementsRed(displayObject,4));
            
           
            
            display_object(objecttype, objectcolour, [x_final y_final]);
            
            
        end
        
  startSecsA = Screen('Flip', scr, blankStartB + blankDuration);
  
  if displayLoops == 1
      
      trialStart = startSecsA;
      
  end
 
 keyresponse = 'null';
 %startSecs = GetSecs;
 
 KbQueueStart();
 
 WaitSecs(searchDuration-0.02);
 
 [ pressed, first_press] = KbQueueCheck;
timeSecs = first_press(find(first_press));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif first_press(left_key)
            keyresponse = 'left'
            reactionTime = timeSecs - trialStart;
            disp(keyresponse);
            disp(reactionTime);
            
            break;
        elseif first_press(right_key)
            keyresponse = 'right'
            reactionTime = timeSecs - trialStart;
             disp(keyresponse);
            disp(reactionTime);
            
            break; 
        elseif first_press(down_key)
            keyresponse = 'down'
            reactionTime = timeSecs - trialStart;
             disp(keyresponse);
            disp(reactionTime);
            
            break; 
        
        end

baseRect = [0 0 420 420];

centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);

Screen('FillRect', scr, white, centeredRect);

blankStartA = Screen('Flip', scr, startSecsA+searchDuration);

 WaitSecs(blankDuration - 0.02);
 
 [ pressed, first_press] = KbQueueCheck;
timeSecs = first_press(find(first_press));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif first_press(left_key)
            keyresponse = 'left'
            reactionTime = timeSecs - trialStart;
            disp(keyresponse);
            disp(reactionTime);
            
            break;
        elseif first_press(right_key)
            keyresponse = 'right'
            reactionTime = timeSecs - trialStart;
             disp(keyresponse);
            disp(reactionTime);
            
            break;   
            
           elseif first_press(down_key)
            keyresponse = 'down'
            reactionTime = timeSecs - trialStart;
             disp(keyresponse);
            disp(reactionTime);
            
            break; 
        
        end
        
 Screen('FillRect', scr, white, centeredRect);    
    
objectLoops = size(objectElementsBlue,1);
        
        for displayObject = 1:objectLoops 
            
            objecttype = cell2mat(objectElementsBlue(displayObject,1));
            objectcolour = cell2mat(objectElementsBlue(displayObject,2));
            x_final = cell2mat(objectElementsBlue(displayObject,3));
            y_final = cell2mat(objectElementsBlue(displayObject,4));
            
           
            
            display_object(objecttype, objectcolour, [x_final y_final]);
            
            
        end
        
 startSecsB = Screen('Flip', scr, blankStartA + blankDuration);
 
 
 WaitSecs(searchDuration-0.02);
 
  [ pressed, first_press] = KbQueueCheck;
timeSecs = first_press(find(first_press));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif first_press(left_key)
            keyresponse = 'left'
            reactionTime = timeSecs - trialStart;
            disp(keyresponse);
            disp(reactionTime);
            
            break;
        elseif first_press(right_key)
            keyresponse = 'right'
            reactionTime = timeSecs - trialStart;
             disp(keyresponse);
            disp(reactionTime);
            
            break;    
            
            elseif first_press(down_key)
            keyresponse = 'down'
            reactionTime = timeSecs - trialStart;
             disp(keyresponse);
            disp(reactionTime);
            
            break; 
        
        end
        
        baseRect = [0 0 420 420];

centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);

Screen('FillRect', scr, white, centeredRect);

 blankStartB = Screen('Flip', scr, startSecsB + searchDuration);

 WaitSecs(blankDuration-0.02);
 
 [ pressed, first_press] = KbQueueCheck;
timeSecs = first_press(find(first_press));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif first_press(left_key)
            keyresponse = 'left'
            reactionTime = timeSecs - trialStart;
            disp(keyresponse);
            disp(reactionTime);
            
            break;
        elseif first_press(right_key)
            keyresponse = 'right'
            reactionTime = timeSecs - trialStart;
             disp(keyresponse);
            disp(reactionTime);
            
            break;   
            
           elseif first_press(down_key)
            keyresponse = 'down'
            reactionTime = timeSecs - trialStart;
             disp(keyresponse);
            disp(reactionTime);
            
            break; 
        
        end
 
  KbQueueStop;
%KbWait;





end

fprintf(fileID,'%d\t%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\n', blockLoop, loop, keyresponse, targetInfo, targetPos, targetDir, num_items, reactionTime, displayLoops);
 

end

end

function fixation_cross
        
        fixCrossDimPix = 10;

        xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
        yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
        allCoords = [xCoords; yCoords];


        lineWidthPix = 4;

        Screen('DrawLines', scr, allCoords,lineWidthPix, black, [xcen ycen], 2);
        Screen('Flip', scr);

end

function display_object(objecttype, objectcolour, mid_coords)
    


%global scr_no xcen ycen scr;

%black = BlackIndex(scr_no);
    
fixCrossDimPix = 10;

if objecttype == 8

	xCoords = [-fixCrossDimPix -fixCrossDimPix -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix 0 0];

elseif objecttype == 7

	xCoords = [fixCrossDimPix fixCrossDimPix -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix 0 0];

elseif objecttype == 6

	xCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix fixCrossDimPix fixCrossDimPix];

elseif objecttype == 5

	xCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix -fixCrossDimPix -fixCrossDimPix];

elseif objecttype == 4

	xCoords = [-fixCrossDimPix fixCrossDimPix+2 fixCrossDimPix fixCrossDimPix];
	yCoords = [-fixCrossDimPix -fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

elseif objecttype == 3

	xCoords = [-fixCrossDimPix fixCrossDimPix+2 fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

elseif objecttype == 2

	xCoords = [-(fixCrossDimPix+2) fixCrossDimPix -fixCrossDimPix -fixCrossDimPix];
	yCoords = [-fixCrossDimPix -fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

elseif objecttype == 1

	xCoords = [-fixCrossDimPix fixCrossDimPix+2 -fixCrossDimPix -fixCrossDimPix];
	yCoords = [fixCrossDimPix fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

else

	error('Object type not defined!');

end

if objectcolour == 0
                
            objectcolourcode = [0 0 255];
            
            
            else
                
            objectcolourcode = [255 0 0];
           
            end

allCoords = [xCoords; yCoords];
lineWidthPix = 4;

disp(objectcolour);
disp(mid_coords);



Screen('DrawLines', scr, allCoords, lineWidthPix, objectcolourcode, mid_coords, 2);



end


function [objectElements, targetInfo, target, targetDir] = create_grid(colOption, targetOn, targetColour, num_items)
targetDir = 0;        
loopcount = 0;

%skip_items = [];

%for skip_row = 1:6
    
%skip_max = 6 * skip_row;
%skip_min = skip_max - 5;
    
%skip_col = randsample(skip_min:skip_max,2);

%skip_items = [skip_items, skip_col]

%end


    

%num_items = 16;

objectElements = [];

skip_items = randsample(1:36, (36 - num_items));

used_points = setdiff(1:36, skip_items);
                %target = randsample(used_points, 1);
                reditems = randsample(used_points, num_items/2);
                blueitems = setdiff(used_points, reditems);
                
if targetColour == 2
    
    target = randsample(reditems, 1);
    
else
    
    target = randsample(blueitems, 1);
    
end
        
        for rows = 1:6
         
            
            for columns = 1:6
            
                loopcount = loopcount + 1;
            
            if isempty(find(skip_items == loopcount))
                
                
                
                
            
            x_value = ((((rows * 2) - 1)/6) * 210) + (xcen - 210);
            y_value = ((((columns * 2) - 1)/6) * 210) + (ycen - 210);
            x_jitter = randi([-8, 8]);
            y_jitter = randi([-8, 8]);
            x_final = x_value + x_jitter; 
            y_final = y_value + y_jitter; 
            
            if target == loopcount && targetOn == 2
                
                objecttype = randsample(5:8, 1);
                
                targetDir = objecttype;
                
            else
            
                objecttype = randi([1, 4]);
            
            end
            
            
              if colOption == 2;
                
                objectcolour = 0;
                
                if target == loopcount 
                    
                    targetInfo = 'Blue';
                    
                end
            
              elseif colOption == 1;
                
                objectcolour = 1;
                
                if target == loopcount 
                    
                    targetInfo = 'Red';
                    
                end
                    
           
              else  
            
                    if isempty(find(reditems == loopcount))
                
                    objectcolour = 0;
                    
                    if target == loopcount 
                    
                    targetInfo = 'Blue';
                    
                end
           
            
                    else
                
                    objectcolour = 1;
                    
                    if target == loopcount 
                    
                    targetInfo = 'Red';
                    
                    end
            
                    end
                    
                end
            
             
            
            %display_object(objecttype, objectcolour, [x_final y_final]);
            
            
            
            newObject = {objecttype, objectcolour, x_final, y_final};
            
            
            
            objectElements = vertcat(objectElements, newObject);
            
            
            
            
            end
            
            end
        end
        
        
        
    end




end

