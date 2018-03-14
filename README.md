# flisher

The Defense Logistics Agency publishes FLIS data quarterly at the URL http://www.dla.mil/HQ/InformationOperations/LogisticsInformationServices/FOIAReading.aspx.

One file, "flisfoi.zip" contains a flat text file containing various record types, one per line.  Fields are delimited by character counts (the locations of these boundaries is in the accompanying DOC file.

The text file is full of lines that look like this:

015840016691759T208-A19159RADAR SET          X43C2017360N A0
0201MM333HM17360D  BA
03 32DZZ  0136517015B0000
045PA2017360000
05DMMPBA1EA037000000.0007 3143A012017335L     00

The first two digits indicate the recordtype, followed by the relevant data.  Record type "01" is important, as this line contains the unique identifier for that piece of equipment, which is NOT found in the other record types, though they "belong" to this row.

The script reads line by line, parsing the individual record types (segments) into their own separate files and reinserting the identifier for each line.
01	Item Identification Data (Segment A)
02	MOE Rule Data (Segment B) *** NOT YET IMPLEMENTED ***
03	Reference Number / CAGE Data (Segment C)
04	Item Standardization Data (Segment E) *** NOT YET IMPLEMENTED ***
09	Freight Data (Segment G) *** NOT YET IMPLEMENTED ***
05	Management Data (Segment H) *** NOT YET IMPLEMENTED ***
08	Packaging Data (Segment W) *** partial implementation, ignores free text starting at col 74 ***
