
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This file contains the routines for drawing good guys **/
/**                   and bad guys.                                         **/
/** This File's Name: draw_pl.c or draw_player_module.                      **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4/01/1992.                                 **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*-------------------------< Other Include Files >---------------------------*/

#include <stdlib.h>
#include <graphics.h>
#include "num_defs.h"
#include "players.h"

/*----------------------< End Other Include Files >--------------------------*/

/*-----------------------------< Prototypes >--------------------------------*/

#include "prototyp.h"

/*---------------------------< End Prototypes >------------------------------*/

/*-----------------------------< Functions >---------------------------------*/

/*****************************< Start draw_good_guy >********************/

/*****************************************************************************/
/** Function Name   : draw_good_guy.                                        **/
/** Description     : Draws the good guy's gun turrent and gun barrel at    **/
/**                   its current location plus or minus the adjustment     **/
/**      				 angle that is passed to it.  Also makes the adjustment**/
/**                   in the good guy's data structure as to what its       **/
/**                   current gun angle is.                                 **/
/** Inputs          : A pointer to the good guy and the gun barrel adjustment*/
/**                   angle specified in radians.                           **/
/** Outputs         : The good guy's new gun angle via the parameter list.  **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4/12/1992.                                 **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

void draw_good_guy(players *gg, float new_angle)
{
	static int background_color;
	int x_barrel, y_barrel;

	background_color = getbkcolor();

	setcolor(background_color);

	/* erase the gun barrel from its current location */
	setfillstyle(SOLID_FILL,background_color);

	x_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'x') + gg->pd.gg.x;
	y_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'y') + gg->pd.gg.y;

	fillellipse(x_barrel,y_barrel,gg->pd.gg.gun_length,gg->pd.gg.gun_length);

	/* redraw gun barrel at its new location */

	setfillstyle(SOLID_FILL,gg->pd.gg.gun_color);
	gg->pd.gg.gun_angle+= new_angle;

	x_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'x') + gg->pd.gg.x;
	y_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'y') + gg->pd.gg.y;

	fillellipse(x_barrel,y_barrel,gg->pd.gg.gun_length,gg->pd.gg.gun_length);

	/* redraw the gun turret body - maybe this should only be done when a hit is taken */
	fillellipse(gg->pd.gg.x,gg->pd.gg.y,gg->pd.gg.radius,gg->pd.gg.radius);

}

/*****************************< End draw_good_guy >***********************/

/*****************************< Start draw_bad_guy >**********************/

/*****************************************************************************/
/** Function Name   : draw_bad_guy.                                     **/
/** Description     : Draws an image of a bad guy on the screen and stores  **/
/**                   it in a sprite that is passed to it from the calling  **/
/**                   routine.                                              **/
/** Inputs          : A pointer to a sprite.                                **/
/** Outputs         : returns 0 if successful and 1 if there was a problem. **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4-5-1992.                                  **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

int draw_bad_guy(sprites *bg)
{
	int success;

	/* put the bad guy on the screen */

	setfillstyle(SOLID_FILL,YELLOW);

	fillellipse((getmaxx()/TWO_VALUE),(getmaxy()/TWO_VALUE),(BAD_GUY_BODY_WIDTH * getmaxx()),(BAD_GUY_BODY_HEIGHT * getmaxy()));

	setfillstyle(SOLID_FILL,RED);

	pieslice((getmaxx()/TWO_VALUE),(getmaxy()/TWO_VALUE),BAD_GUY_EYE_ANGLE_1,BAD_GUY_EYE_ANGLE_2,(BAD_GUY_EYE_LENGTH * getmaxx()));
	pieslice((getmaxx()/TWO_VALUE),(getmaxy()/TWO_VALUE),BAD_GUY_EYE_ANGLE_3,BAD_GUY_EYE_ANGLE_4,(BAD_GUY_EYE_LENGTH * getmaxx()));

	setfillstyle(SOLID_FILL,BLUE);

	fillellipse((getmaxx()/TWO_VALUE),(getmaxy()/TWO_VALUE),(BAD_GUY_MOUTH_WIDTH * getmaxx()),(BAD_GUY_MOUTH_HEIGHT * getmaxy()));

	/* set the bitmap extents */

	bg->x = (getmaxx() / TWO_VALUE) - (BAD_GUY_BODY_WIDTH * getmaxx());
	bg->y = (getmaxy() / TWO_VALUE) - (BAD_GUY_EYE_LENGTH * getmaxx());
	bg->width = TWO_VALUE * BAD_GUY_BODY_WIDTH * getmaxx();
	bg->height = (BAD_GUY_EYE_LENGTH * getmaxx()) + (BAD_GUY_BODY_HEIGHT * getmaxy());

	/* allocate space for the bitmap */

	bg->bitmap = (short unsigned int *) calloc(ONE_VALUE,(bg->width * bg->height * sizeof(short unsigned int)));

	if (bg->bitmap != NULL)
	{
		getimage(bg->x,bg->y,(bg->x + bg->width),(bg->y + bg->height),(short unsigned int *) bg->bitmap);

		/* erase image from screen now that it has been captured */
		putimage(bg->x,bg->y,(short unsigned int *) bg->bitmap,XOR_PUT);

		success = ZERO_VALUE;
	}
	else
		success = ONE_VALUE;

	return(success);
}

/**************************< End draw_bad_guy >***************************/

/*---------------------------< End Functions >-------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/

