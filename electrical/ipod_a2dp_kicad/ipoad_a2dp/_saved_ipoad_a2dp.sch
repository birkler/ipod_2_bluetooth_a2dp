EESchema Schematic File Version 4
EELAYER 26 0
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
L Connector:Raspberry_Pi_2_3 J1
U 1 1 5CB9E120
P 3850 3800
F 0 "J1" H 3850 5278 50  0000 C CNN
F 1 "Raspberry_Pi_2_3" H 3850 5187 50  0000 C CNN
F 2 "" H 3850 3800 50  0001 C CNN
F 3 "https://www.raspberrypi.org/documentation/hardware/raspberrypi/schematics/rpi_SCH_3bplus_1p0_reduced.pdf" H 3850 3800 50  0001 C CNN
	1    3850 3800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0101
U 1 1 5CB9E172
P 3750 2100
F 0 "#PWR0101" H 3750 1950 50  0001 C CNN
F 1 "+5V" H 3765 2273 50  0000 C CNN
F 2 "" H 3750 2100 50  0001 C CNN
F 3 "" H 3750 2100 50  0001 C CNN
	1    3750 2100
	1    0    0    -1  
$EndComp
$Comp
L power:GNDD #PWR0102
U 1 1 5CB9E1A5
P 3450 5300
F 0 "#PWR0102" H 3450 5050 50  0001 C CNN
F 1 "GNDD" H 3454 5145 50  0000 C CNN
F 2 "" H 3450 5300 50  0001 C CNN
F 3 "" H 3450 5300 50  0001 C CNN
	1    3450 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3450 5100 3450 5300
Wire Wire Line
	3750 2500 3750 2100
$Comp
L Device:R R1
U 1 1 5CB9E24F
P 2500 2900
F 0 "R1" V 2293 2900 50  0000 C CNN
F 1 "R" V 2384 2900 50  0000 C CNN
F 2 "" V 2430 2900 50  0001 C CNN
F 3 "~" H 2500 2900 50  0001 C CNN
	1    2500 2900
	0    1    1    0   
$EndComp
$Comp
L Device:R R2
U 1 1 5CB9E2A8
P 2500 3000
F 0 "R2" V 2293 3000 50  0000 C CNN
F 1 "R" V 2384 3000 50  0000 C CNN
F 2 "" V 2430 3000 50  0001 C CNN
F 3 "~" H 2500 3000 50  0001 C CNN
	1    2500 3000
	0    1    1    0   
$EndComp
Wire Wire Line
	3050 2900 2650 2900
Wire Wire Line
	3050 3000 2650 3000
Text Label 2700 2900 0    50   ~ 0
Test
Text GLabel 2150 3000 0    50   Input ~ 0
Test
$EndSCHEMATC
