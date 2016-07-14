
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This module sets up the environment for the game and  **/
/**                   restores the pre game evironment once the game is over**/
/**                   .  Currently, the pre game environment restoration    **/
/**                   consists only of restoring the pre game video mode but**/
/**                   later revisions of this routine will also restore     **/
/**                   other pre game environment elements.                  **/
/** This File's Name: setclean.c or game_setup_cleanup_module.              **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4/01/1992.                                 **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*-------------------------< Other Include Files >---------------------------*/

#include <stdio.h>
#include <conio.h>
#include <graphics.h>
#include "num_defs.h"

/*----------------------< End Other Include Files >--------------------------*/

/*-----------------------------< Functions >---------------------------------*/

/*****************************< Start setup_video_driver_and_mode >*******/

/*****************************************************************************/
/** Function Name   : setup_video_driver_and_mode.                      **/
/** Description     : This routine registers the video driver and sets the  **/
/**                   screen mode that the calling routine will use.  This  **/
/**                   routine is currently hardwired to register the        **/
/**                   "egavga" driver and set the screen mode to "VGAMED"   **/
/**                   which is 640 X 350, 16 color with 2 graphics pages.   **/
/** Inputs          : None.                                                 **/
/** Outputs         : Returns an integer value of "0" if successful and "1" **/
/**                   if the routine failed to register the driver or set   **/
/**                   the appropriate screen mode.                          **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4/02/1992.                                 **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

int setup_video_driver_and_mode(void)
{
	int error_flag = ZERO_VALUE;
	int  errorcode, graphics_mode = VGAMED;

#ifdef video_problems

/* DAVE - I've been having a lot of problems getting video drivers to link
into my program correctly; I've been in touch with Borland and they say that
it's probably due to my hardware incompatibility problem.  Everything links
fine and dandy but when I run the program I get a very vague message that
tells me nothing about what the problem actually is.  I've used preprocessor
directives to hop back back and forth between loading the video driver and
linking it into the code.  As a result of the problems I've been having, I'm
including the "egavga.bgi" video driver and doing a "detect" with "initgraph()".
This may be shoddy but it works given my present incompatibility dilemma.
- Dom */

	/* register the graphics driver to be used before calling initgraph */
   	errorcode = registerbgidriver(EGAVGA_driver);    

	/* test to see if video driver registration worked */

	if (errorcode < ZERO_VALUE)
	{
		printf("Video driver - graphics error: %s\n",grapherrormsg(errorcode));
		printf("errorcode = %d\n",errorcode);
		printf("Press any key to quit.");
		getch();
		error_flag = ONE_VALUE; /* set an error_flag */
	}
	else
	{
		/* Set the video environment for the program to be VGA, 640 x 350, 16 color.
		The VGA driver will be linked directly into this program's resulting
		executable. See "UTIL.DOC" on your Borland distribution diskettes. */

		initgraph((int far *) &errorcode,(int far *) &graphics_mode, "");

		/* test to see if initgraph worked */
		errorcode = graphresult(); 

		if (errorcode != grOk)
		{
			printf("Initgraph - graphics error: %s\n",grapherrormsg(errorcode));
			printf("Press any key to quit.");
			getch();
			error_flag = ONE_VALUE; /* set an error_flag */
		}
	}

#endif

#ifndef video_problems

	errorcode = DETECT;
	initgraph((int far *) &errorcode,(int far *) &graphics_mode, "");


		/* test to see if initgraph worked */
		errorcode = graphresult();

		if (errorcode != grOk)
		{
			printf("Initgraph - graphics error: %s\n",grapherrormsg(errorcode));
			printf("Press any key to quit.");
			getch();
			error_flag = ONE_VALUE; /* set an error_flag */
		}

#endif

	return(error_flag);
}

/*****************************< End setup_video_driver_and_mode >*********/

/*****************************< Start restore_pre_game_environment >******/

/*****************************************************************************/
/** Function Name   : restore_pre_game_environment.                    **/
/** Description     : This routine restores the pre game environment.       **/
/**                   Currently, the pre game environment restoration       **/
/**                   consists only of restoring the pre game video mode but**/
/**                   later revisions of this routine will also restore     **/
/**                   other pre game environment elements.                  **/
/** Inputs          : None.                                                 **/
/** Outputs         : None.                                                 **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4-4-92.                                    **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

void restore_pre_game_environment(void)
{
	closegraph(); /* free the memory allocated by graphics system */

	restorecrtmode(); /* put the system back in the text mode it was in prior to start of game */
}

/*****************************< End restore_pre_game_environment >********/

/*---------------------------< End Functions >-------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/

