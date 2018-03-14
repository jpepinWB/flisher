# flisher

The Defense Logistics Agency publishes FLIS data quarterly at the URL http://www.dla.mil/HQ/InformationOperations/LogisticsInformationServices/FOIAReading.aspx.

One file, "flisfoi.zip" contains a flat text file containing various record types, one per line.  Fields are delimited by character counts (the locations of these boundaries is in the accompanying DOC file.

The text file is full of lines that look like this:

```
018940000000042A2390077777CK FILTER ASSEMBLY X46Q2006082N A
0201ZK01   06082
0343269ZD 24039UK 60A890216
045972006082000
015940000000045A507P008573TERMINAL BOARD ASSEX46B2006082NAA0
0201ZK01   06082
03 525ZZ  0CEN3JWROGJWOEGIOW
0343959ZD 24039UK 60A890D255
045972006082000
011560000000047A2380039730MODIFICATION KIT,AINM9B1975284P U
0203A70200X95354NCT99                                               YB01   97142                                                    ZW01   05333                                      
031592CTB 02731M30294
03 322ZZ  8V613M30294
042TU1977273000
05DAB17B1KT000000600.000U HB2BPX 1992245L     00
09 CT 011790Z04720  W671Z9AAZWAIRCRAFT PARTS NOI
08PP000000650120012001200001000ZZZ0B00050010000900090ZZZZZZZZZZZZ00A00F00MIMPC = 3B NONSTOCKED ITEM - SPECIAL REQUIREMENTS|
```

The first two digits indicate the recordtype, followed by the relevant data.  Record type "01" is important, as this line contains the unique identifier for that piece of equipment, which is NOT found in the other record types, though they "belong" to this row.

The script reads line by line, parsing the individual record types (segments) into their own separate files and reinserting the identifier for each line.

01	Item Identification Data (Segment A)

02	MOE Rule Data (Segment B) *** NOT YET IMPLEMENTED ***

03	Reference Number / CAGE Data (Segment C)

04	Item Standardization Data (Segment E) *** NOT YET IMPLEMENTED ***

09	Freight Data (Segment G) *** NOT YET IMPLEMENTED ***

05	Management Data (Segment H) *** NOT YET IMPLEMENTED ***

08	Packaging Data (Segment W) *** partial implementation, ignores free text starting at col 74 ***
