EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:arduino
LIBS:HALL-TLE4935G
LIBS:DDLM
LIBS:Tete_budha
LIBS:Panhard
LIBS:aecp_Nano_V3-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L arduino_mini U1
U 1 1 57015F7D
P 3750 2750
F 0 "U1" H 3750 1099 70  0000 C CNN
F 1 "Arduino_Nano_V3" H 3750 978 70  0000 C CNN
F 2 "arduino:arduino_mini" H 3750 864 60  0000 C CNN
F 3 "" H 3750 2750 60  0000 C CNN
	1    3750 2750
	-1   0    0    -1  
$EndComp
$Comp
L CONN_01X02 P5
U 1 1 570AB4C6
P 6450 1150
F 0 "P5" H 6528 1188 50  0000 L CNN
F 1 "CONN_12V" H 6528 1097 50  0000 L CNN
F 2 "Connect:bornier2" H 6450 1150 50  0001 C CNN
F 3 "" H 6450 1150 50  0000 C CNN
	1    6450 1150
	1    0    0    1   
$EndComp
$Comp
L LM7805CT U3
U 1 1 570AB610
P 5700 1150
F 0 "U3" H 5700 1558 50  0000 C CNN
F 1 "LM7805CT" H 5700 1467 50  0000 C CNN
F 2 "TO_SOT_Packages_THT:TO-220_Neutral123_Vertical_LargePads" H 5700 1376 50  0001 C CIN
F 3 "" H 5700 1150 50  0000 C CNN
	1    5700 1150
	-1   0    0    -1  
$EndComp
Wire Wire Line
	6100 1100 6250 1100
Wire Wire Line
	6250 1500 6250 1200
Wire Wire Line
	5200 1500 6250 1500
Wire Wire Line
	5700 1500 5700 1400
$Comp
L +5V #PWR01
U 1 1 570AB81F
P 4750 950
F 0 "#PWR01" H 4750 800 50  0001 C CNN
F 1 "+5V" H 4768 1123 50  0000 C CNN
F 2 "" H 4750 950 50  0000 C CNN
F 3 "" H 4750 950 50  0000 C CNN
	1    4750 950 
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 570AB839
P 5900 1550
F 0 "#PWR02" H 5900 1300 50  0001 C CNN
F 1 "GND" H 5908 1377 50  0000 C CNN
F 2 "" H 5900 1550 50  0000 C CNN
F 3 "" H 5900 1550 50  0000 C CNN
	1    5900 1550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 1550 5900 1500
Connection ~ 5900 1500
Wire Wire Line
	2100 1100 5300 1100
Wire Wire Line
	3750 1100 3750 1600
Wire Wire Line
	4750 950  4750 1100
Connection ~ 4750 1100
$Comp
L TLE4905G U2
U 1 1 570AB9C1
P 7500 2400
F 0 "U2" H 7819 2063 60  0000 C CNN
F 1 "A3144" H 7819 2169 60  0000 C CNN
F 2 "TO_SOT_Packages_THT:TO-92_Horizontal2_Inline_Narrow_Oval" H 7500 2400 60  0001 C CNN
F 3 "" H 7500 2400 60  0000 C CNN
	1    7500 2400
	-1   0    0    1   
$EndComp
Wire Wire Line
	3050 3350 1950 3350
Wire Wire Line
	2100 3150 1950 3150
Wire Wire Line
	2100 1100 2100 3150
Connection ~ 3750 1100
$Comp
L GND #PWR03
U 1 1 570ABC3D
P 3750 4750
F 0 "#PWR03" H 3750 4500 50  0001 C CNN
F 1 "GND" H 3758 4577 50  0000 C CNN
F 2 "" H 3750 4750 50  0000 C CNN
F 3 "" H 3750 4750 50  0000 C CNN
	1    3750 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 4300 3750 4750
Wire Wire Line
	5300 4600 2100 4600
Wire Wire Line
	2100 4600 2100 3250
Wire Wire Line
	2250 3250 1950 3250
Connection ~ 3750 4600
$Comp
L CONN_01X02 P4
U 1 1 570ABCA6
P 5600 2900
F 0 "P4" H 5677 2938 50  0000 L CNN
F 1 "CONN_SEL1" H 5677 2847 50  0000 L CNN
F 2 "Connect:bornier2" H 5600 2900 50  0001 C CNN
F 3 "" H 5600 2900 50  0000 C CNN
	1    5600 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 2950 5300 2950
Wire Wire Line
	5300 2400 5300 4600
$Comp
L CONN_01X03 P3
U 1 1 570ABDF6
P 5600 2300
F 0 "P3" H 5677 2338 50  0000 L CNN
F 1 "CONN_DEP" H 5677 2247 50  0000 L CNN
F 2 "Connect:bornier3" H 5600 2300 50  0001 C CNN
F 3 "" H 5600 2300 50  0000 C CNN
	1    5600 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4450 2550 5100 2550
Wire Wire Line
	5400 2400 5300 2400
Connection ~ 5300 2950
Wire Wire Line
	5400 2300 5100 2300
Wire Wire Line
	5100 2300 5100 2550
Wire Wire Line
	5400 2200 5100 2200
$Comp
L Q_NIGBT_GCE Q2
U 1 1 570AC050
P 2450 2400
F 0 "Q2" H 2644 2354 50  0000 L CNN
F 1 "IRGB14C40" H 2644 2445 50  0000 L CNN
F 2 "TO_SOT_Packages_THT:TO-220_Neutral123_Vertical_LargePads" H 2650 2500 50  0001 C CNN
F 3 "" H 2450 2400 50  0000 C CNN
	1    2450 2400
	-1   0    0    1   
$EndComp
$Comp
L Q_NIGBT_GCE Q1
U 1 1 570AC1A5
P 2450 1600
F 0 "Q1" H 2644 1554 50  0000 L CNN
F 1 "IRGB14C40" H 2644 1645 50  0000 L CNN
F 2 "TO_SOT_Packages_THT:TO-220_Neutral123_Vertical_LargePads" H 2650 1700 50  0001 C CNN
F 3 "" H 2450 1600 50  0000 C CNN
	1    2450 1600
	-1   0    0    1   
$EndComp
Wire Wire Line
	2750 2400 2750 3150
Wire Wire Line
	2750 2400 2650 2400
Wire Wire Line
	3050 2600 2850 2600
Wire Wire Line
	2850 2600 2850 1600
Wire Wire Line
	2850 1600 2650 1600
Wire Wire Line
	2350 1400 2350 1300
Wire Wire Line
	2350 1800 2350 2000
Wire Wire Line
	2350 2200 2350 2150
Wire Wire Line
	2350 2750 2350 2600
Wire Wire Line
	3600 1600 3600 1500
Wire Wire Line
	3600 1500 5100 1500
Wire Wire Line
	5100 1500 5100 2200
NoConn ~ 3900 1600
NoConn ~ 3050 2100
NoConn ~ 3050 2200
NoConn ~ 3050 2300
NoConn ~ 3050 2400
NoConn ~ 3050 2500
NoConn ~ 4450 2350
NoConn ~ 4450 3250
NoConn ~ 3050 3450
NoConn ~ 3050 3550
NoConn ~ 3050 3250
NoConn ~ 3050 3050
NoConn ~ 3050 2800
NoConn ~ 4450 4050
NoConn ~ 4450 3950
$Comp
L PWR_FLAG #FLG04
U 1 1 570ACEED
P 4650 4500
F 0 "#FLG04" H 4650 4595 50  0001 C CNN
F 1 "PWR_FLAG" H 4650 4724 50  0000 C CNN
F 2 "" H 4650 4500 50  0000 C CNN
F 3 "" H 4650 4500 50  0000 C CNN
	1    4650 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 4500 4650 4600
Connection ~ 4650 4600
$Comp
L CONN_01X03 P7
U 1 1 570AD48D
P 8200 2400
F 0 "P7" H 8278 2438 50  0000 L CNN
F 1 "CONN_HALL2" H 8278 2347 50  0000 L CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x03" H 8200 2400 50  0001 C CNN
F 3 "" H 8200 2400 50  0000 C CNN
	1    8200 2400
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X03 P6
U 1 1 570AD572
P 1750 3250
F 0 "P6" H 1669 2919 50  0000 C CNN
F 1 "CONN_HALL1" H 1669 3010 50  0000 C CNN
F 2 "Connect:bornier3" H 1750 3250 50  0001 C CNN
F 3 "" H 1750 3250 50  0000 C CNN
	1    1750 3250
	-1   0    0    1   
$EndComp
Wire Wire Line
	7500 2300 8000 2300
Wire Wire Line
	8000 2400 7500 2400
Wire Wire Line
	7500 2500 8000 2500
$Comp
L HEATSINK HS1
U 1 1 570ADE4D
P 2550 1600
F 0 "HS1" V 2491 1778 50  0000 L CNN
F 1 "HEATSINK" V 2582 1778 50  0000 L CNN
F 2 "Heatsinks:Heatsink_Fischer_SK104-STC-STIC_35x13mm_2xDrill2.5mm" H 2550 1600 50  0001 C CNN
F 3 "" H 2550 1600 50  0000 C CNN
	1    2550 1600
	0    1    1    0   
$EndComp
$Comp
L HEATSINK HS2
U 1 1 570ADF02
P 2550 2400
F 0 "HS2" V 2491 2578 50  0000 L CNN
F 1 "HEATSINK" V 2582 2578 50  0000 L CNN
F 2 "Heatsinks:Heatsink_Fischer_SK104-STC-STIC_35x13mm_2xDrill2.5mm" H 2550 2400 50  0001 C CNN
F 3 "" H 2550 2400 50  0000 C CNN
	1    2550 2400
	0    1    1    0   
$EndComp
$Comp
L TST P8
U 1 1 570D6471
P 7000 1800
F 0 "P8" H 7078 1940 50  0000 L CNN
F 1 "FIX" H 7078 1849 50  0000 L CNN
F 2 "Connect:1pin" H 7000 1800 50  0001 C CNN
F 3 "" H 7000 1800 50  0000 C CNN
	1    7000 1800
	1    0    0    -1  
$EndComp
$Comp
L TST P9
U 1 1 570D6673
P 7250 1800
F 0 "P9" H 7328 1940 50  0000 L CNN
F 1 "FIX" H 7328 1849 50  0000 L CNN
F 2 "Connect:1pin" H 7250 1800 50  0001 C CNN
F 3 "" H 7250 1800 50  0000 C CNN
	1    7250 1800
	1    0    0    -1  
$EndComp
$Comp
L TST P10
U 1 1 570D66C1
P 7500 1800
F 0 "P10" H 7578 1940 50  0000 L CNN
F 1 "FIX" H 7578 1849 50  0000 L CNN
F 2 "Connect:1pin" H 7500 1800 50  0001 C CNN
F 3 "" H 7500 1800 50  0000 C CNN
	1    7500 1800
	1    0    0    -1  
$EndComp
$Comp
L TST P11
U 1 1 570D670E
P 7750 1800
F 0 "P11" H 7828 1940 50  0000 L CNN
F 1 "FIX" H 7828 1849 50  0000 L CNN
F 2 "Connect:1pin" H 7750 1800 50  0001 C CNN
F 3 "" H 7750 1800 50  0000 C CNN
	1    7750 1800
	1    0    0    -1  
$EndComp
NoConn ~ 7000 1800
NoConn ~ 7250 1800
NoConn ~ 7500 1800
NoConn ~ 7750 1800
NoConn ~ 4450 2650
Wire Wire Line
	2750 3150 3050 3150
NoConn ~ 3050 2700
NoConn ~ 4450 2750
$Comp
L LOGO G1
U 1 1 570FF659
P 5050 3850
F 0 "G1" H 5050 3704 60  0001 C CNN
F 1 "Tete_budha" H 5050 3996 60  0001 C CNN
F 2 "Tete_budha:Tete_budha" H 5050 3850 60  0001 C CNN
F 3 "" H 5050 3850 60  0000 C CNN
	1    5050 3850
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 57114CAD
P 5200 1300
F 0 "C1" H 5315 1346 50  0000 L CNN
F 1 "100n" H 5315 1255 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Rect_L7_W3.5_P5" H 5238 1150 50  0001 C CNN
F 3 "" H 5200 1300 50  0000 C CNN
	1    5200 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5200 1150 5200 1100
Connection ~ 5200 1100
Wire Wire Line
	5200 1450 5200 1500
Connection ~ 5700 1500
Text Notes 5450 4200 0    60   ~ 0
Copyleft 2016\n\nChristophe Dedessus Les Moutier\nchristophe.dedessus@sfr.fr\n\nLicense CC by SA
$Comp
L CONN_01X02 P12
U 1 1 5765BC76
P 5600 3150
F 0 "P12" H 5677 3188 50  0000 L CNN
F 1 "CONN_SEL2" H 5677 3097 50  0000 L CNN
F 2 "Connect:bornier2" H 5600 3150 50  0001 C CNN
F 3 "" H 5600 3150 50  0000 C CNN
	1    5600 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 3100 4600 3100
Wire Wire Line
	5400 3200 5300 3200
Connection ~ 5300 3200
Wire Wire Line
	2350 2150 2250 2150
Wire Wire Line
	2250 1300 2250 3250
Connection ~ 2100 3250
Wire Wire Line
	2350 1300 2250 1300
Connection ~ 2250 2150
$Comp
L CONN_01X03 P13
U 1 1 576841BF
P 6800 3000
F 0 "P13" H 6878 3038 50  0000 L CNN
F 1 "CONN_DEP2" H 6878 2947 50  0000 L CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x03" H 6800 3000 50  0001 C CNN
F 3 "" H 6800 3000 50  0000 C CNN
	1    6800 3000
	-1   0    0    -1  
$EndComp
NoConn ~ 7700 2800
Wire Wire Line
	7000 2900 7700 2900
Wire Wire Line
	7000 3000 7700 3000
Wire Wire Line
	7000 3100 7700 3100
$Comp
L GND #PWR05
U 1 1 576847EC
P 7350 3200
F 0 "#PWR05" H 7350 2950 50  0001 C CNN
F 1 "GND" H 7358 3027 50  0000 C CNN
F 2 "" H 7350 3200 50  0000 C CNN
F 3 "" H 7350 3200 50  0000 C CNN
	1    7350 3200
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 2600 7350 3200
Connection ~ 7350 3000
Text Notes 7500 3350 0    60   ~ 0
Capteur de dépression\nMP3V5050VC6U
Text Notes 7450 2200 0    60   ~ 0
Capteur effet hall\nA3144
$Comp
L MP3V5050 P14
U 1 1 576866EF
P 8150 2950
F 0 "P14" H 8150 3200 50  0000 C CNN
F 1 "MP3V5050" V 8075 2950 50  0000 C CNN
F 2 "MP3V5050V:MP3V5050V" H 8150 2950 50  0001 C CNN
F 3 "" H 8150 2950 50  0000 C CNN
	1    8150 2950
	1    0    0    -1  
$EndComp
NoConn ~ 8600 2800
NoConn ~ 8600 2900
NoConn ~ 8600 3000
NoConn ~ 8600 3100
$Comp
L C C2
U 1 1 576CDB5B
P 7100 2750
F 0 "C2" H 7215 2796 50  0000 L CNN
F 1 "1µ" H 7215 2705 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Rect_L7_W3.5_P5" H 7138 2600 50  0001 C CNN
F 3 "" H 7100 2750 50  0000 C CNN
	1    7100 2750
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 576CDC40
P 7500 2950
F 0 "C3" H 7615 2996 50  0000 L CNN
F 1 "470p" H 7615 2905 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Rect_L7_W3.5_P5" H 7538 2800 50  0001 C CNN
F 3 "" H 7500 2950 50  0000 C CNN
	1    7500 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 2800 7350 2800
Wire Wire Line
	7100 2600 7350 2600
Connection ~ 7350 2800
Connection ~ 7500 3100
Connection ~ 7100 2900
NoConn ~ 4450 3150
Wire Wire Line
	4600 3050 4450 3050
NoConn ~ 4450 2950
Wire Wire Line
	4450 2850 5400 2850
Wire Wire Line
	4600 3100 4600 3050
$Comp
L CONN_01X02 P1
U 1 1 58026BF1
P 1750 2050
F 0 "P1" H 1827 2088 50  0000 L CNN
F 1 "CONN_IGBT" H 1827 1997 50  0000 L CNN
F 2 "Connect:bornier2" H 1750 2050 50  0001 C CNN
F 3 "" H 1750 2050 50  0000 C CNN
	1    1750 2050
	-1   0    0    1   
$EndComp
Wire Wire Line
	2000 2100 2000 2750
Wire Wire Line
	2000 2750 2350 2750
Wire Wire Line
	2350 2000 1950 2000
Wire Wire Line
	2000 2100 1950 2100
$Comp
L TST P18
U 1 1 5807D293
P 9100 1800
F 0 "P18" H 9178 1940 50  0000 L CNN
F 1 "FIX" H 9178 1849 50  0000 L CNN
F 2 "Mounting_Holes:MountingHole_2.2mm_M2_Pad_Via" H 9100 1800 50  0001 C CNN
F 3 "" H 9100 1800 50  0000 C CNN
	1    9100 1800
	1    0    0    -1  
$EndComp
$Comp
L TST P15
U 1 1 5807D31D
P 8350 1800
F 0 "P15" H 8428 1940 50  0000 L CNN
F 1 "FIX" H 8428 1849 50  0000 L CNN
F 2 "Mounting_Holes:MountingHole_2.2mm_M2_Pad_Via" H 8350 1800 50  0001 C CNN
F 3 "" H 8350 1800 50  0000 C CNN
	1    8350 1800
	1    0    0    -1  
$EndComp
$Comp
L TST P16
U 1 1 5807D404
P 8600 1800
F 0 "P16" H 8678 1940 50  0000 L CNN
F 1 "FIX" H 8678 1849 50  0000 L CNN
F 2 "Mounting_Holes:MountingHole_2.2mm_M2_Pad_Via" H 8600 1800 50  0001 C CNN
F 3 "" H 8600 1800 50  0000 C CNN
	1    8600 1800
	1    0    0    -1  
$EndComp
$Comp
L TST P17
U 1 1 5807D40A
P 8850 1800
F 0 "P17" H 8928 1940 50  0000 L CNN
F 1 "FIX" H 8928 1849 50  0000 L CNN
F 2 "Mounting_Holes:MountingHole_2.2mm_M2_Pad_Via" H 8850 1800 50  0001 C CNN
F 3 "" H 8850 1800 50  0000 C CNN
	1    8850 1800
	1    0    0    -1  
$EndComp
$Comp
L 24CT G2
U 1 1 580BB541
P 7850 4450
F 0 "G2" H 7850 3527 60  0001 C CNN
F 1 "24CT" H 7850 5373 60  0001 C CNN
F 2 "DDLM:Panhard24CT" H 7850 4450 60  0001 C CNN
F 3 "" H 7850 4450 60  0001 C CNN
	1    7850 4450
	1    0    0    -1  
$EndComp
$EndSCHEMATC
