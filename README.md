# Prototrak_GCode_Splitter
 This script splits .cam files into 1000 line segments which is necessary for Prototraks so they don't throw an error because they can only storage so many bytes (or bits) per G-Code file.

To use this script, have a .cam file ready for splitting. Grab the file directory (if it is not located 
in the same folder as the script) and copy and paste it into the appropriate section. See code 
for further details. Once that's done, run the code and follow the instructions. You will need to 
enter the file number. For the Prototraks I am familiar with, you can only use four digit file names (max is 9999). 
So just enter "####" when it asks for the number. 

Example: I have a g-code named "1400.cam". I put the file location into the appropriate section 
and then I enter "1400" when the dialog pops into the command window. 