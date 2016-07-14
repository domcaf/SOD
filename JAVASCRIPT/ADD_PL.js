
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This file contains the routine which adds a player in **/
/**                   the game, "Spirals Of Death".                         **/
/** This File's Name: add_pl.c or add_player.                               **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4/01/1992.                                 **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*-------------------------< Other Include Files >---------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <graphics.h>
#include <conio.h>
#include "num_defs.h"
#include "players.h"
#include "prototyp.h"

/*----------------------< End Other Include Files >--------------------------*/


/*-----------------------------< Functions >---------------------------------*/


/*****************************< Start add_player >*********************/

/***************************************************************************/
/** Function Name   : add_player.                                    	  **/
/** Description     : Add a player to the game ie           bad_guy or    **/
/**                   bullet and initialize the player.                   **/
/** Inputs          : Head of the player_list, type of player, image of   **/
/**                   bad guy to be added & who fired their gun ie good or**/
/**                   bad guy.                                            **/
/** Outputs         : A flag indicating if addition was successful.       **/
/**                   Returns an value of 0 if successful or 1 otherwise. **/
/** Programmer(s)   : Dominic Caffey.                                     **/
/** Notes & Comments: Created on 4/12/1992.                               **/
/**                  -The player list is a circular doubly linked list.   **/
/**                  -Not all the parameters in the call will be used on  **/
/**                   any given call to this routine.  "player_list" &    **/
/**                   "pt" will always have values but "image" & "from"   **/
/**                   may or not have legitimate values depending on the  **/
/**                   type of player to be added.  "from" will only have  **/
/**                   a legitimate value when a bullet is being added     **/
/**                   otherwise its value should always be NULL.  "image" **/
/**                   will only have a legitimate value when a	bad guy is **/
/**                   being added otherwise its value should be NULL.     **/
/**                  -A good guy can't be added using this routine.  See  **/
/**                   the routine called "add_good" to add a good guy.    **/
/**                                                                       **/
/**                                                                       **/
/**                                                                       **/
/**                                                                       **/
/***************************************************************************/

int add_player(players *player_list, enum player_type pt, sprites *image, players *from)
{
	players *new_player;
	int success  = ONE_VALUE;

	new_player = (players *) calloc(ONE_VALUE,sizeof(players));

	if(new_player != NULL)
	{

		/* indicate success in adding new player */
		success = ZERO_VALUE;

		/* set the player type */
		new_player->pt = pt;

		/* load data into the new_player */
		switch (pt)
		{
			case bad:
				/* point to the bad_guy bitmap */
				new_player->pd.bg.badguy.bitmap = image->bitmap;

				/* set the bitmap extents */
				new_player->pd.bg.badguy.x = getmaxx();
				new_player->pd.bg.badguy.y = getmaxy();
				new_player->pd.bg.badguy.width = image->width;
				new_player->pd.bg.badguy.height = image->height;

				/* randomly choose a step angle between 1 & BAD_GUY_MAX_ANGLE_STEP & convert it to radians */
				new_player->pd.bg.angle_step = (1 + random(BAD_GUY_MAX_ANGLE_STEP)) * (HALF_CIRCLE_RADIANS/HALF_CIRCLE_DEGREES);

				new_player->pd.bg.current_angle = ZERO_VALUE;

				/*new_player->pd.bg.radius = (int) sqrt(pow((getmaxx()/TWO_VALUE),TWO_VALUE) + pow((getmaxy()/TWO_VALUE),TWO_VALUE));*/
				new_player->pd.bg.radius = (int) getmaxx()/TWO_VALUE;


				break;
			case bullet:
				if ((from->pt == good) || (from->pt == bad))
				{
					new_player->pd.b.radius = BULLET_RADIUS;

					/* figure out where the bullet came from */
					new_player->pd.b.from = from;

					if (from->pt == good)
					{
						/* center of bullet when fired by the good guy */
						new_player->pd.b.x = polar_to_cartesian_coords((float) (from->pd.gg.radius + from->pd.gg.gun_length + (TWO_VALUE * BULLET_RADIUS)),from->pd.gg.gun_angle,'x') + from->pd.gg.x;
						new_player->pd.b.y = polar_to_cartesian_coords((float) (from->pd.gg.radius + from->pd.gg.gun_length + (TWO_VALUE * BULLET_RADIUS)),from->pd.gg.gun_angle,'y') + from->pd.gg.y;


						/* movement step increments for bullet when fired by the good guy */
						new_player->pd.b.x_step = BULLET_RADIUS * cos(from->pd.gg.gun_angle) * GOOD_GUY_BULLET_SPEED_FACTOR;
						new_player->pd.b.y_step = BULLET_RADIUS * sin(from->pd.gg.gun_angle) * GOOD_GUY_BULLET_SPEED_FACTOR;
					}
					else
					{
						/* center of bullet when fired by a bad guy */
						new_player->pd.b.x = from->pd.bg.badguy.x;
						new_player->pd.b.y = from->pd.bg.badguy.y;


						/* movement step increments for bullet when fired by a bad guy */
						new_player->pd.b.x_step = -BULLET_RADIUS * cos(from->pd.bg.current_angle);
						new_player->pd.b.y_step = -BULLET_RADIUS * sin(from->pd.bg.current_angle);
					}
				}
				else
				{
						success = ONE_VALUE;
						free(new_player);
				}
				break;
			default:  /* invalid player type */
				success = ONE_VALUE;
				free(new_player);
				break;
		}

		if (!success)

			/* update all links for new player & player_list */

			if (player_list == NULL)  /* this should never happen, but just in case */
			{
				success = ONE_VALUE;
				free(new_player);

			}
			else   /* the list is not empty - insert the new node */
			{
				/* set the new players prev link to list head's prev link */
				new_player->prev = player_list->prev;

				/* set the prev player's next to point at new player */
				player_list->prev->next = new_player;

				/* set head's prev link to point at new player */
				player_list->prev = new_player;

				/* set the new players next to point at list head */
				new_player->next = player_list;
			}

	}

	return(success);

} /* add_player */

/*****************************< End add_player >***********************/

/*---------------------------< End Functions >-------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/

