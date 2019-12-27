#!/bin/sh
AL_AH_REG="0xFF803014"
SW_INPUT_REG="0xFF803010"

LED_R1_REG="0xff803110" # GPIO 15
LED_G1_REG="0xff803050" # GPIO 3
LED_B1_REG="0xff8031a0" # GPIO 24

ZERO_VAL="0x00000000"
LED_Bit_MASK="0x1008008"
LED_N_Bit_MASK="0xFF7FF7"
LED_ACT_CFG="0xFF80301c"

##### init #####
function init(){
	sw $AL_AH_REG $LED_N_Bit_MASK;		# set LED15(R), LED3(G), LED24(B) as active low
}

function xamber_on(){
	sw $SW_INPUT_REG $ZERO_VAL;			#on

	sw $LED_R1_REG 0x00002000;		    #set R brightness, bit 6 ~ 13, value 0~128
	sw $LED_G1_REG 0x00000400;		    #set G brightness, bit 6 ~ 13, value 0~128
	sw $LED_B1_REG 0x00002000;		    #set B brightness, bit 6 ~ 13, value 0~128, 0x2000 means off for RAX20 Power_LED_B
	
	sw $LED_ACT_CFG $LED_Bit_MASK; 
}

function xoff(){
	sw $LED_R1_REG $ZERO_VAL;		    #set R brightness, bit 6 ~ 13, value 0~128
	sw $LED_G1_REG $ZERO_VAL;		    #set G brightness, bit 6 ~ 13, value 0~128
	sw $LED_B1_REG 0x00002000;		    #set B brightness, bit 6 ~ 13, value 0~128, 0x2000 means off for RAX20 Power_LED_B
	
	sw $LED_ACT_CFG $LED_Bit_MASK; 
}


MODE=$1
if [ "x${MODE}" == "xinit" ]; then
	init
elif [ "x${MODE}" == "xamber" ]; then
	xamber_on
elif [ "x${MODE}" == "xoff" ]; then
	xoff

else
	echo Please try:
	echo "${0} init"
	echo "${0} amber"
	echo "${0} off"
fi
