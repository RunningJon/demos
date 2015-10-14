README file for Demos
***********************************************************************************
Site: http://www.PivotalGuru.com
Author: Jon Roberts
***********************************************************************************
This series of demos are used in conjunction with the Pivotal Single Node Virtual 
Machine of Pivotal HD and HAWQ.  

***********************************************************************************
Instructions
***********************************************************************************
1.  Download "demos.sh" from github
https://raw.githubusercontent.com/pivotalguru/demos/master/demos.sh

2.  scp the demos.sh file to the Pivotal HD Virtual Machine
Example with the virutal machine named "phd3":

scp demos.sh root@phd3:/root

3.  ssh to the Virutal Machine (or use a graphical login as root)
ssh root@phd3

4.  Execute the demos.sh script
chmod 750 demos.sh
./demos.sh

5.  Follow the menus to view the available demos.  

Note:  More demos will be added from time to time and demos.sh will automatically 
make the new demos available.

***********************************************************************************
Configuration
***********************************************************************************
The demos.sh script will automatically create a "variables.sh" in the same
directory.  Typically the default values do not need to be changed but if needed,
you can edit the "variables.sh" file to make changes.

The demos.sh script will automtically update itself when executed which will 
overwrite any changes you make to demos.sh or any file in the demo repository 
except for "variables.sh".  
