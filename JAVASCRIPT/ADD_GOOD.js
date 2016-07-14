
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : add a good guy to the player list.                    **/
/** This File's Name: add_good.c                                            **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on .                                          **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*-------------------------< Other Include Files >---------------------------*/

#include <stdlib.h>
#include <graphics.h>
#include "num_defs.h"
#include "players.h"

/*----------------------< End Other Include Files >--------------------------*/

/*-----------------------------< Functions >---------------------------------*/

/*****************************< Start add_good >*************************/

/*****************************************************************************/
/** Function Name   : add_good.												   		 **/
/** Description     : Add a good guy  into the player list.                 **/
/** Inputs          : None.                                                 **/
/** Outputs         : Returns the addess of the player that was just added. **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 5/7/92.                                    **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

players *add_good(void)
{
	players *new_player;

	new_player = (players *) calloc(ONE_VALUE,sizeof(players));

	if(new_player != NULL)
	{
		/* initialize the good guy */
		/* center of good guy */
		new_player->pd.gg.x = getmaxx()/TWO_VALUE;
		new_player->pd.gg.y = getmaxy()/TWO_VALUE;

		/* radius of good_guy, excluding barrel, as %age of screen dimensions */
		new_player->pd.gg.radius = getmaxx() * GOOD_GUY_RADIUS;

		/* length as a %age of screen dimensions */
		new_player->pd.gg.gun_length = getmaxx() * GOOD_GUY_GUN_LENGTH;
		new_player->pd.gg.gun_color = GREEN;

		/* angle in radians where gun is pointing */
		new_player->pd.gg.gun_angle = ZERO_VALUE;

		/* half the angle width of the gun barrel in radians */
		new_player->pd.gg.gun_width_half_angle = GUN_WIDTH_HALF_ANGLE;

		/* set the next & previous pointers */
		new_player->next = new_player;

		new_player->prev = new_player;
	}

	return(new_player);
}
/*****************************< End add_good >***************************/

/*---------------------------< End Functions >-------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/
