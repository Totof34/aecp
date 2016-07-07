aecp
====

The project describes a electronic mapped car ignition
especialy for Panhard two cylindre

If you would have more information about this project please visit 
www.audiyofan.org

A link to the dedicated post 
http://www.audiyofan.org/forum/viewtopic.php?f=71&t=9221


PCB & schema are designed with Kicad

the new board uses a Atmega328 and usb link to transmit some data to the PC
it's a Arduino Nano_V3

The idea comes from this site
http://a110a.free.fr/SPIP172/plan.php3

with this startpoint
![](images/0Hall_et_Jumo_150106.jpg)

The prototype of the new board under construction and under kicad

![](images/aecp_nano_V2_6.JPG)
![](images/aecp_nano_V2_7.JPG)

With some parts 

![](images/aecp_pcb.JPG)

You can select different curve with a box

![](images/Selecteur_de_courbes.JPG)

To develop our electronic ignition, we create an new interface with a Nano_V3
to receive data from the Atmega328 and visualize the centrifugal advance curves and vacuum advance

![](images/IHM_09042016_1.png)
![](images/IHM_09042016_Baillargues_Sommieres.png)
![](images/IHM_0904016_multicouleurs.png)

This interface is designed under Processing IDE and the board is programmed with Arduino IDE
All the files available in subfolders

For the printed circuit board please see the source_kicad folder 
or the build folder for a made version

For the schema see below

![](schematics/aecp_Nano_V2.png)

for the rest, I suggest you to navigate into folders and open the pdf

The main code is explained through comments ( in French) in the ino file ( see Arduino folder )


Enjoy

