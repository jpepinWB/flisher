#!/bin/bash
# downloads FLIS database from dla.mil

wget http://www.dla.mil/Portals/104/Documents/InformationOperations/LogisticsInformationServices/FOIA/FLISFOI.zip
unzip FLISFOI.zip -d efs/
rm FLISFOI.zip
