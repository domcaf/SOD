
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This file contains bullet hit and collision detection **/
/**                   routines for the game "Spirals Of Death".             **/
/** This File's Name: hitcolid.c or hit_collide.                            **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4/01/1992.                                 **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*-------------------------< Other Include Files >---------------------------*/

#include <math.h>
#include <graphics.h>
#include <conio.h>
#include <stdlib.h>
#include "num_defs.h"
#include "players.h"
#include "prototyp.h"

/*----------------------< End Other Include Files >--------------------------*/

/*-----------------------------< Functions >---------------------------------*/

/*****************************< Start did_bad_good_guy_collide >********/

/*****************************************************************************/
/** Function Name   : did_bad_good_guy_collide.                        **/
/** Description     : This function determines if a bad guy and the good    **/
/**                   guy collided.  It returns a value of 1 if a collision **/
/**                   took place otherwise it returns a value of 0.         **/
/** Inputs          : A pointer to a bad guy.                               **/
/** Outputs         : An indicator of whether or not a collision took place.**/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4-29-92.                                   **/
/**                  - On the first call to this routine, it searches the   **/
/**                    player list to find the good guy.  When it finds good**/
/**                    guy, it stores the good guy's address in a static    **/
/**                    pointer variable.  This way on subsequent calls to   **/
/**                    this routine the player list doesn't have to be      **/
/**                    researched to find the good guy.                     **/
/**                  - If a collision has occurred, the good guy's color is **/
/**                    changed to the next color in its color sequence.     **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

int did_bad_good_guy_collide(players *bg)
{
	int collide = ZERO_VALUE;
	float bad_guy_radial_distance;
	static players *gg = NULL;
	players *ferret; /* used to find the good guy in the player list */

	/* find the good guy in the player list */
	if(gg == NULL)
	{
		ferret = bg;  /* set the ferret to the same value as the bad guy as a starting point */

		while((ferret->next != bg) && (ferret->next->pt != good))
			ferret = ferret->next;

		/* the good guy has been found */
		gg = ferret->next;

	}

	/* start checking for the collision */

	/* calculate radius of bad guy from center of screen */
	bad_guy_radial_distance = sqrt(pow((bg->pd.bg.badguy.x - gg->pd.gg.x),TWO_VALUE) + pow((bg->pd.bg.badguy.y - gg->pd.gg.y),TWO_VALUE));

	if(bad_guy_radial_distance <= gg->pd.gg.radius)
	{
		collide = ONE_VALUE;

		/* while we're here, set the good guy's color to its next color */
		switch(gg->pd.gg.gun_color)
		{
			case GREEN:
				gg->pd.gg.gun_color = YELLOW;
				draw_good_guy(gg,ZERO_VALUE);
				break;

			case YELLOW:
				gg->pd.gg.gun_color = RED;
				draw_good_guy(gg,ZERO_VALUE);
				break;

			case RED:
			default:
				gg->pd.gg.gun_color = getbkcolor();
				draw_good_guy(gg,ZERO_VALUE);
				break;
		}
	}

	return(collide);
}

/*****************************< End did_bad_good_guy_collide >***********/



/*****************************< Start did_bullet_hit_something >********/

/*****************************************************************************/
/** Function Name   : did_bullet_hit_something.                        **/
/** Description     : This function determines if a bullet hit something.   **/
/**                   If it hit something it identifies what it hit and     **/
/**                   returns a pointer to the hit object otherwise it      **/
/**                   returns a value of NULL.                              **/
/** Inputs          : A pointer to the bullet being tested for a hit.       **/
/** Outputs         : A pointer to hit object or NULL if no hit.            **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4-30-92.                                   **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

players *did_bullet_hit_something(players *bullet)
{
	players *target = NULL;
	float look_ahead_x, look_ahead_y, look_ahead_dist_to_screen_center, distance_between_bullets;
	static int background_color;
	static int screen_center_x, screen_center_y;
	int target_found = ZERO_VALUE;

	background_color = getbkcolor();
	screen_center_x = (int) (getmaxx()/TWO_VALUE);
	screen_center_y = (int) (getmaxy()/TWO_VALUE);


	/* calculate look ahead coordinates */
	look_ahead_x = bullet->pd.b.x + (TWO_VALUE * bullet->pd.b.x_step);
	look_ahead_y = bullet->pd.b.y + (TWO_VALUE * bullet->pd.b.y_step);

	/* determine if the bullet actually hit something */
	if(getpixel((int) look_ahead_x,(int) look_ahead_y) != background_color)
	{
		/* the bullet hit something, find out what it hit */
		target = bullet->next; /* set starting point for search */

		while((target != bullet) && (!target_found))  /* traverse the player list */
		{
			if(target != bullet->pd.b.from) /* a player can't shoot itself */

				if(target->pt == good)
				{
					look_ahead_dist_to_screen_center = sqrt(pow((look_ahead_x - screen_center_x),TWO_VALUE) + pow((look_ahead_y - screen_center_y),TWO_VALUE));

					if(look_ahead_dist_to_screen_center <= target->pd.gg.radius)
						target_found = ONE_VALUE;
				}
				else if(target->pt == bad)
				{
					if((look_ahead_x >= target->pd.bg.badguy.x) &&
						(look_ahead_x <= (target->pd.bg.badguy.x + target->pd.bg.badguy.width)) &&
						(look_ahead_y >= target->pd.bg.badguy.y) &&
						(look_ahead_y <= (target->pd.bg.badguy.y + target->pd.bg.badguy.height)))
							target_found = ONE_VALUE;
				}
				else /* the player type is another bullet */
				{
				  /* if the distance between their two centers is less than (2 * r) then they hit each other */
					distance_between_bullets = sqrt(pow((look_ahead_x - target->pd.b.x),TWO_VALUE) + pow((look_ahead_y - target->pd.b.y),TWO_VALUE));

					if(distance_between_bullets <= (2 * bullet->pd.b.radius))
						target_found = ONE_VALUE;
				}

			if(!target_found)
				target = target->next;

		}
	}

	return(target);
}

/*****************************< End did_bullet_hit_something >***********/

/*---------------------------< End Functions >-------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/

