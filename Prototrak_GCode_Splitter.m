%{
    Title: Prototrak G-Code Splitter
    Author: James Emerson Parkus
    Date: 02/08/2020
    Purpose: This code takes an input of a .cam file (G-Code for Prototrak)
    and will split it in 1000 line program files with the proper heading
    and termination code. The output is a series of files that are named in
    a consecutive numeration with the original g-code split and ready to be
    loaded on to the Prototrak.

    Instructions: 
    1) Rename file extensions to .txt instead of .cam
    2) Enter the file directory in the Initialization section (see comments
    for further details)
    3) Run the script
    4) Enjoy!
%}
clc
clear

%% Initialization
% Enter directory of data files (comment out if files are in same directory
% as MATLAB file | You must keep the ' ' around your directory name! To
% easily find your directory in Windows Explorer, navigate to the directory
% bar (where it shows your current folder, next to the refresh button).
% Double click that bar, then highlight all the words using Ctrl+A. Then
% copy & paste (Ctrl+C -> Ctrl+V) that into the parentheses.

cd 'G:\Shared drives\SPEX Workgroup\SPEXTRO-IREC\Mechanical\G-Code\Top-Panel'

%% User Inputs
filenumber = input('Please enter the program number (4-digit only) (DO NOT INCLUDE FILE EXTENSION).\n');
original_name = sprintf('%g.cam',filenumber);
new_name = sprintf('%g.txt',filenumber);

movefile(original_name,new_name);

%% Constants
n = 1000; % Max number of lines per file

%% Program
A = readtable(new_name,'Delimiter','\t','ReadVariableNames',false); % Read the file text into the workspace
B = table2array(A); % Convert table to array
C = char(B); % Convert array to character vector
C_Size = size(C); % Find size of array
heading_size = 3; % Specify heading size (might not work perfectly, check it if you change it. This will be improved in future versions.)
heading = C(1:heading_size,:); % Cut the heading off of the text file (this and the ending vector need to be put on each split file)
ending = C(C_Size(1,1),:); % Cut the ending off the text file so only the body text remains
C(1:3,:) = []; % Nullify the first three rows
C(C_Size(1,1)-heading_size,:) = []; % Nullify the last row (ending)
C_Size = size(C); % Redefine the size of the matrix

p = ceil(C_Size(1,1)/n); % The number of times the script needs to be split, ceiling value since it needs to be rounded up)

step = n-5; % Steps the step size for the array concatenator limits
up_lim = step; % Upper limit of concatenation
low_lim = 1; % Lower limit of concatenation

i = 1; % Initialize this as a loop counter
final_index = C_Size(1,1); % Sets the ending criterion for the while loop
while low_lim ~= final_index % Run until the lower limit is equal to the index of the last row
    C_seg = C(low_lim:up_lim,:); % Initial segment of C character matrix
    C_segmented = [heading;C_seg;ending]; % Final segmentation of the matrix with the appropriate heading and ending
    GCode.(sprintf('Seg_%g',i)) = C_segmented; % Throws the GCode into a struct for storage
   
    if i < p - 1 % if the loop counter is less than necessary loop - 1
        low_lim = up_lim;
        up_lim = up_lim + step;        
    end
    
    if i >= p - 1
        low_lim = up_lim;
        up_lim = C_Size(1,1);
    end
    
    i = i + 1;
    
    % These next few lines are necessary for writing the data in the
    % C_segmented file into a txt file that is then re-written with a .cam
    % extension (compatible with Prototrak machines).
    filenum = filenumber + 1;
    filenumber = filenumber + 1;
    filename_txt = sprintf('%g.txt',filenum);
    filename_cam = sprintf('%g.cam',filenum);
    writematrix(C_segmented,filename_txt,'Delimiter','tab');
    movefile(filename_txt,filename_cam);
end
movefile(new_name,original_name); % Renames initial file back to original .cam extension









 




