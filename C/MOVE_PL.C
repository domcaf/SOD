
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This file contains the routine used to move a player  **/
/**                   in the game "Spirals Of Death".                       **/
/** This File's Name: move_pl.c or move_player.                             **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4/01/1992.                                 **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*-------------------------< Other Include Files >---------------------------*/

#include <math.h>
#include <graphics.h>
#include <conio.h>
#include "num_defs.h"
#include "players.h"

/*----------------------< End Other Include Files >--------------------------*/

/*-----------------------------< Prototypes >--------------------------------*/

#include "prototyp.h"

/*---------------------------< End Prototypes >------------------------------*/

/*-----------------------------< Functions >---------------------------------*/

/*****************************< Start move_player >**********************/

/*****************************************************************************/
/** Function Name   : move_player.												 **/
/** Description     : Move a player from its current location to its next   **/
/**                   location.                                             **/
/** Inputs          : A pointer to the player to be moved.                  **/
/** Outputs         : None.                                                 **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4-29-92.                                   **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

void move_player(players *mm)  /* mm = move me */
{
	players *player_who_shot_bullet;

	static float reference_radius;
	static float reference_angle;

	static int screen_max_x;
	static int screen_max_y;
	static int two_pi_rads = TWO_VALUE * PI;
	static int screen_center_x;
	static int screen_center_y;

	screen_max_x = getmaxx();
	screen_max_y = getmaxy();

	screen_center_x = (int) screen_max_x / TWO_VALUE;
	screen_center_y = (int) screen_max_y / TWO_VALUE;


	reference_radius = sqrt(pow((getmaxx()/TWO_VALUE),TWO_VALUE) + pow((getmaxy()/TWO_VALUE),TWO_VALUE));
	reference_angle = atan(getmaxy()/getmaxx());

	setfillstyle(SOLID_FILL,getbkcolor());

	if(mm->pt == bad)
	{
		/* erase mm from its old location */
		bar(mm->pd.bg.badguy.x,mm->pd.bg.badguy.y,(mm->pd.bg.badguy.x + mm->pd.bg.badguy.width),(mm->pd.bg.badguy.y + mm->pd.bg.badguy.height));

		/* update the current angle of the bad guy */
		mm->pd.bg.current_angle += mm->pd.bg.angle_step;

		/* calculate the new polar radius for the bad guy's new location */
		if(mm->pd.bg.current_angle > two_pi_rads)
		{
			mm->pd.bg.radius-= FIVE_VALUE;
			mm->pd.bg.current_angle-= two_pi_rads;
		}

		/* convert the polar angle into cartesian coordinates for the bad guy's new location */
		mm->pd.bg.badguy.x = (int) polar_to_cartesian_coords(mm->pd.bg.radius,mm->pd.bg.current_angle,'x') + screen_center_x;
		mm->pd.bg.badguy.y = (int) polar_to_cartesian_coords(mm->pd.bg.radius,mm->pd.bg.current_angle,'y') + screen_center_y;

		/* redisplay mm at its new position */
		putimage(mm->pd.bg.badguy.x,mm->pd.bg.badguy.y,(short unsigned int *) mm->pd.bg.badguy.bitmap,COPY_PUT);

	}
	else if(mm->pt == bullet)
	{
		/* erase mm from its old location */
		fillellipse((int) mm->pd.b.x,(int) mm->pd.b.y,mm->pd.b.radius,mm->pd.b.radius);

		/* setup mm's new position */
		mm->pd.b.x += mm->pd.b.x_step;
		mm->pd.b.y += mm->pd.b.y_step;

		if((mm->pd.b.x <= screen_max_x) && (mm->pd.b.x >= ZERO_VALUE) && (mm->pd.b.y <= screen_max_y) && (mm->pd.b.y >= ZERO_VALUE))
		{
			/* identify the type of player who shot the bullet */
			player_who_shot_bullet = (players *) mm->pd.b.from;  /* this is necessary because "from" is a void pointer */

			/* redisplay mm at its new position  - choose appropriate bullet color */
			setfillstyle(SOLID_FILL,(player_who_shot_bullet->pt == good) ? GREEN : YELLOW);

			fillellipse((int) mm->pd.b.x,(int) mm->pd.b.y,mm->pd.b.radius,mm->pd.b.radius);
		}
		else
			delete_player(mm);

	}
}

/*****************************< End move_player >************************/


/*---------------------------< End Functions >-------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/

