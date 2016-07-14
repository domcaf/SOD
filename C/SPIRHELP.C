
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This file contains the online help facility for the   **/
/**                   game "Spirals of Death".                              **/
/** This File's Name: spirhelp.c or spirals_help.                           **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 5-14-92.                                    **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*-------------------------< Other Include Files >---------------------------*/

#include <stdio.h>
#include <conio.h>
#include <graphics.h>

/*----------------------< End Other Include Files >--------------------------*/

/*----------------------------< Constants >----------------------------------*/



/*--------------------------< End Constants >--------------------------------*/

/*------------------------< Enumerated Types >-------------------------------*/



/*----------------------< End Enumerated Types >-----------------------------*/

/*----------------------------< Typedefs  >----------------------------------*/



/*--------------------------< End Typedefs  >--------------------------------*/

/*-----------------------------< Macros  >-----------------------------------*/



/*---------------------------< End Macros  >---------------------------------*/

/*-----------------------------< Prototypes >--------------------------------*/



/*---------------------------< End Prototypes >------------------------------*/

/*-----------------------------< Functions >---------------------------------*/

/*****************************< Start spirals_help >*************************/

/*****************************************************************************/
/** Function Name   : spirals_help.													    **/
/** Description     : This is the online help facility for the game "Spirals**/
/**                   Of Death".                                            **/
/** Inputs          : None.                                                 **/
/** Outputs         : None.                                                 **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 5-14-92.                                   **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

void spirals_help(void)
{
	/* put the display in text mode */
	restorecrtmode();

	/* display the help text */

	printf("                        S P I R A L S    O F    D E A T H\n\n");
	printf("\"Spirals of Death\" is a game in which bad guys, who move in a decaying spirals,\n");
	printf("shoot at the good guy who's located in the center of the screen.  The good guy\n");
	printf("can rotate his gun and fire back.  The user assumes the role of the good guy.\n"); 
	printf("The object of the game is to destroy all the bad guys before being destroyed.\n"); 
	printf("The good guy can take 3 hits before dying; he will change to a different color\n");
	printf("each time he's hit in the following color progression:  Green -> Yellow -> Red -\n");
	printf("> Background Color.  The game is over when the good guy's color is the same as\n");
	printf("that of the game background.  The good guy fires green bullets and the bad guys\n");
	printf("fire yellow bullets.\n\n");
	printf("                            C O M M A N D    K E Y S\n\n");
	printf("Key         | Function\n");
	printf("------------+------------------------------\n");
	printf(""<-"        = Rotate gun counter clockwise.\n");
	printf(""->"        = Rotate gun clockwise.\n");
	printf(""space bar" = fire gun.\n");
	printf(""h" or "H"  = display this help screen.\n");
	printf(""p" or "P"  = pause the game.\n");
	printf(""q" or "Q"  = quit the game.\n");
	printf("\a\a\a           =======> touch a key to start or resume game play <=======");

	getch(); /* pause the routine while the user is reading the help screen */

	/* put the display back into graphics mode */
	setgraphmode(getgraphmode());

}

/*****************************< End spirals_help >***************************/

/*---------------------------< End Functions >-------------------------------*/

/*-------------------------------< Main >------------------------------------*/



/*-----------------------------< End Main >----------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/

