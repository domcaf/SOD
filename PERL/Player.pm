package Player;

use lib '.';
use Moose;
use namespace::autoclean;
use Data::Dumper;

#@EXPORT = qw(&add_player &delete_player &visit_player);



 # * Description     : This file contains the definition of a player for the **/
 # *                   game "Spirals Of Death". A player can be the goodguy, **/
 # *                   a badguy or a bullet fired by either of the previous. **/


                    #enum player_type { good, bad, bullet } pt;
					has player_type (
						isa => 'Str',
						is	=> 'ro'
					);

#                    union {
#                        goodguys gg;
#                        badguys bg;
#                        bullets b;
#                    }

                    has pd (
						isa => '_goodguy | _badguy | _bullet',
						is => 'ro'
						);    #  pd = player data */

                    #struct _player * next, *prev;  #  link structure pointers */

					has next (
						isa => 'Object',
						is = 'rw'
					);

					has prev (
						isa => 'Object',
						is = 'rw'
					);

					# METHODS


	#  prototypes for add_pl.c */

		int add_player(players *, enum player_type, sprites *, players *);

	#  prototypes for del_pl.c */

		void  delete_player(players *);

	#  prototypes for visit_pl.c */

		void  visit_player(players *);


Contents of VISIT_PL.C below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This file contains the routine for visiting a player  **/
# *                   in the game "Spirals Of Death".                       **/
# * This File's Name: visit_pl.c or visit_player.                           **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/01/1992.                                 **/
# *                                                                         **/
# **************************< End General Information >***********************/


# ****************************< Start visit_player >********************/

# ****************************************************************************/
# * Function Name   : visit_player.                                    **/
# * Description     : This routine visits a player in the player_list and   **/
# *                   gives the player the opportunity to behave according  **/
# *                   to its nature. ie shoot, move, crash or do nothing.   **/
# * Inputs          : A pointer to a player in the player_list.             **/
# * Outputs         : None.                                                 **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-28-92.                                   **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

void visit_player(players *player)
{
	int event_count, keystroke, special_key, exit_flag = ZERO_VALUE;
	int good_shot;  #  this is basically a dummy variable & is used only to satisfy function calling conventions */
	players *wounded;

	switch(player->pt)
	{
		case good:
			for(event_count = ZERO_VALUE; event_count < MAX_GOOD_GUY_EVENTS; event_count++)
			{
				#  get a keystroke from the good guy and act accordingly */
				keystroke = get_keystroke(DONT_WAIT,&special_key);

			  #  process the keystroke */
				if(keystroke || special_key)
					if(keystroke && !special_key)
					{
						switch(keystroke)
						{
							case 'H': #  activate help and pause the game */
							case 'h':
								spirals_help();
								break;

							case 'P': #  pause the game */
							case 'p':
								getch();
								break;

							case 'Q': #  quit the game */
							case 'q':
								exit_flag = ONE_VALUE;
								break;

							case SPACE_BAR:  #  fire the good guy's gun */
								good_shot = add_player(player,bullet,NULL,player);
								break;

							default:  #  ignore invalid keystrokes */
								break;
						}
					}
					else if(!keystroke && special_key)
					{
						switch(special_key)
						{
							case LEFT_ARROW:  #  rotate the good guy's gun counter clockwise */
								draw_good_guy(player,-GOOD_GUY_ROTATION_INCREMENT);
								break;

							case RIGHT_ARROW: #  rotate the good guy's gun clockwise */
								draw_good_guy(player,GOOD_GUY_ROTATION_INCREMENT);
								break;

							default:  #  ignore invalid keystrokes */
								break;
						}
					}
			}
			break;

		case bad:

			#  determine if bad guy crashed into good guy */
			if(did_bad_good_guy_collide(player))
				delete_player(player);
			else
			{

#ifndef no_shoot

				#  randomly decide on gun firing & take action */
				if(random(SHOOTING_PROBABILITY_FACTOR) == ONE_VALUE)
					good_shot = add_player(player,bullet,NULL,player);

#endif

				#  erase bad guy from old location and move to new location */
				move_player(player);
			}

			break;

		case bullet:

			#  determine if and what bullet may have struck */
			if((wounded = did_bullet_hit_something(player)) != NULL)
			{
				#  delete the wounded player or change its status */
				switch(wounded->pt)
				{
					case good:

						#  set the good guy's color to its next color */
						switch(wounded->pd.gg.gun_color)
						{
							case GREEN:
								wounded->pd.gg.gun_color = YELLOW;
								break;

							case YELLOW:
								wounded->pd.gg.gun_color = RED;
								break;

							case RED:
							default:
								wounded->pd.gg.gun_color = getbkcolor();
								break;
						}

						draw_good_guy(wounded,ZERO_VALUE);
						break;

					case bad:
					case bullet:
						#  delete the bad guy or the bullet */
						delete_player(wounded);
						break;

					default: #  do nothing */
						break;
				}

				#  delete the bullet */
				delete_player(player);

			}

			#  bullet didn't hit anything, move the player to its next position */
			move_player(player);

			break;

		default:    #  don't do anything */
			break;
	}

	if (exit_flag)
	{
		#  the game's over so free up the memory that was previously allocated */

		player->prev->next = NULL;

		while(player != NULL)
		{
			player = player->next;
			free(player->prev);
		}


		#  restore the pregame video environment */
		restore_pre_game_environment();

		#  display the score & pause before terminating program */
		exit(ZERO_VALUE);
	}
} # ****************************< End visit_player >**********************/


	#  prototypes for move_pl.c */

		void  move_player(players *);

		int did_bad_good_guy_collide(players *);
		#players *did_bullet_hit_something(players *);



                no Moose;
                __PACKAGE__->meta->make_immutable;

	#define PLAYERS_H

# Contents of PROTOTYP.H below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This file contains the prototype definitions for all  **/
# *                   the functions for the game "Spirals Of Death".        **/
# * This File's Name: prototyp.h                                            **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/01/1992.                                 **/
# *                                                                         **/
# **************************< End General Information >***********************/

# -----------------------------< Prototypes >--------------------------------*/

#ifndef prototyp_h

	#  prototypes for draw_pl.c */
	#  prototypes for setclean.c */

		#int  setup_video_driver_and_mode(void);
		#void restore_pre_game_environment(void);

	#  prototypes for polrcart.c */

#		float polar_to_cartesian_coords(float, float, char);
#		float cartesian_to_polar_coords(float, float, char);

	#  prototypes for hit.c */
	#  prototypes for spirhelp.c */
		#void spirals_help(void);

# ---------------------------< End Prototypes >------------------------------*/

	#define prototyp_h

#endif

# -----------------------------< End Of File >-------------------------------*/

Contents of ADD_GOOD.C below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : add a good guy to the player list.                    **/
# * This File's Name: add_good.c                                            **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on .                                          **/
# *                                                                         **/
# **************************< End General Information >***********************/

# -------------------------< Other Include Files >---------------------------*/

#include <stdlib.h>
#include <graphics.h>
#include "num_defs.h"
#include "players.h"

# ----------------------< End Other Include Files >--------------------------*/

# -----------------------------< Functions >---------------------------------*/

# ****************************< Start add_good >*************************/

# ****************************************************************************/
# * Function Name   : add_good.												   		 **/
# * Description     : Add a good guy  into the player list.                 **/
# * Inputs          : None.                                                 **/
# * Outputs         : Returns the addess of the player that was just added. **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 5/7/92.                                    **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

players *add_good(void)
{
	players *new_player;

	new_player = (players *) calloc(ONE_VALUE,sizeof(players));

	if(new_player != NULL)
	{
		#  initialize the good guy */
		#  center of good guy */
		new_player->pd.gg.x = getmaxx()/TWO_VALUE;
		new_player->pd.gg.y = getmaxy()/TWO_VALUE;

		#  radius of good_guy, excluding barrel, as %age of screen dimensions */
		new_player->pd.gg.radius = getmaxx() * GOOD_GUY_RADIUS;

		#  length as a %age of screen dimensions */
		new_player->pd.gg.gun_length = getmaxx() * GOOD_GUY_GUN_LENGTH;
		new_player->pd.gg.gun_color = GREEN;

		#  angle in radians where gun is pointing */
		new_player->pd.gg.gun_angle = ZERO_VALUE;

		#  half the angle width of the gun barrel in radians */
		new_player->pd.gg.gun_width_half_angle = GUN_WIDTH_HALF_ANGLE;

		#  set the next & previous pointers */
		new_player->next = new_player;

		new_player->prev = new_player;
	}

	return(new_player);
}
# ****************************< End add_good >***************************/

# ---------------------------< End Functions >-------------------------------*/

# -----------------------------< End Of File >-------------------------------*/
Contents of ADD_PL.C below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This file contains the routine which adds a player in **/
# *                   the game, "Spirals Of Death".                         **/
# * This File's Name: add_pl.c or add_player.                               **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/01/1992.                                 **/
# *                                                                         **/
# **************************< End General Information >***********************/

# -------------------------< Other Include Files >---------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <graphics.h>
#include <conio.h>
#include "num_defs.h"
#include "players.h"
#include "prototyp.h"

# ----------------------< End Other Include Files >--------------------------*/


# -----------------------------< Functions >---------------------------------*/


# ****************************< Start add_player >*********************/

# **************************************************************************/
# * Function Name   : add_player.                                    	  **/
# * Description     : Add a player to the game ie           bad_guy or    **/
# *                   bullet and initialize the player.                   **/
# * Inputs          : Head of the player_list, type of player, image of   **/
# *                   bad guy to be added & who fired their gun ie good or**/
# *                   bad guy.                                            **/
# * Outputs         : A flag indicating if addition was successful.       **/
# *                   Returns an value of 0 if successful or 1 otherwise. **/
# * Programmer(s)   : Dominic Caffey.                                     **/
# * Notes & Comments: Created on 4/12/1992.                               **/
# *                  -The player list is a circular doubly linked list.   **/
# *                  -Not all the parameters in the call will be used on  **/
# *                   any given call to this routine.  "player_list" &    **/
# *                   "pt" will always have values but "image" & "from"   **/
# *                   may or not have legitimate values depending on the  **/
# *                   type of player to be added.  "from" will only have  **/
# *                   a legitimate value when a bullet is being added     **/
# *                   otherwise its value should always be NULL.  "image" **/
# *                   will only have a legitimate value when a	bad guy is **/
# *                   being added otherwise its value should be NULL.     **/
# *                  -A good guy can't be added using this routine.  See  **/
# *                   the routine called "add_good" to add a good guy.    **/
# *                                                                       **/
# *                                                                       **/
# *                                                                       **/
# *                                                                       **/
# **************************************************************************/

int add_player(players *player_list, enum player_type pt, sprites *image, players *from)
{
	players *new_player;
	int success  = ONE_VALUE;

	new_player = (players *) calloc(ONE_VALUE,sizeof(players));

	if(new_player != NULL)
	{

		#  indicate success in adding new player */
		success = ZERO_VALUE;

		#  set the player type */
		new_player->pt = pt;

		#  load data into the new_player */
		switch (pt)
		{
			case bad:
				#  point to the bad_guy bitmap */
				new_player->pd.bg.badguy.bitmap = image->bitmap;

				#  set the bitmap extents */
				new_player->pd.bg.badguy.x = getmaxx();
				new_player->pd.bg.badguy.y = getmaxy();
				new_player->pd.bg.badguy.width = image->width;
				new_player->pd.bg.badguy.height = image->height;

				#  randomly choose a step angle between 1 & BAD_GUY_MAX_ANGLE_STEP & convert it to radians */
				new_player->pd.bg.angle_step = (1 + random(BAD_GUY_MAX_ANGLE_STEP)) * (HALF_CIRCLE_RADIANS/HALF_CIRCLE_DEGREES);

				new_player->pd.bg.current_angle = ZERO_VALUE;

				# new_player->pd.bg.radius = (int) sqrt(pow((getmaxx()/TWO_VALUE),TWO_VALUE) + pow((getmaxy()/TWO_VALUE),TWO_VALUE));*/
				new_player->pd.bg.radius = (int) getmaxx()/TWO_VALUE;


				break;
			case bullet:
				if ((from->pt == good) || (from->pt == bad))
				{
					new_player->pd.b.radius = BULLET_RADIUS;

					#  figure out where the bullet came from */
					new_player->pd.b.from = from;

					if (from->pt == good)
					{
						#  center of bullet when fired by the good guy */
						new_player->pd.b.x = polar_to_cartesian_coords((float) (from->pd.gg.radius + from->pd.gg.gun_length + (TWO_VALUE * BULLET_RADIUS)),from->pd.gg.gun_angle,'x') + from->pd.gg.x;
						new_player->pd.b.y = polar_to_cartesian_coords((float) (from->pd.gg.radius + from->pd.gg.gun_length + (TWO_VALUE * BULLET_RADIUS)),from->pd.gg.gun_angle,'y') + from->pd.gg.y;


						#  movement step increments for bullet when fired by the good guy */
						new_player->pd.b.x_step = BULLET_RADIUS * cos(from->pd.gg.gun_angle) * GOOD_GUY_BULLET_SPEED_FACTOR;
						new_player->pd.b.y_step = BULLET_RADIUS * sin(from->pd.gg.gun_angle) * GOOD_GUY_BULLET_SPEED_FACTOR;
					}
					else
					{
						#  center of bullet when fired by a bad guy */
						new_player->pd.b.x = from->pd.bg.badguy.x;
						new_player->pd.b.y = from->pd.bg.badguy.y;


						#  movement step increments for bullet when fired by a bad guy */
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
			default:  #  invalid player type */
				success = ONE_VALUE;
				free(new_player);
				break;
		}

		if (!success)

			#  update all links for new player & player_list */

			if (player_list == NULL)  #  this should never happen, but just in case */
			{
				success = ONE_VALUE;
				free(new_player);

			}
			else   #  the list is not empty - insert the new node */
			{
				#  set the new players prev link to list head's prev link */
				new_player->prev = player_list->prev;

				#  set the prev player's next to point at new player */
				player_list->prev->next = new_player;

				#  set head's prev link to point at new player */
				player_list->prev = new_player;

				#  set the new players next to point at list head */
				new_player->next = player_list;
			}

	}

	return(success);

} #  add_player */

# ****************************< End add_player >***********************/

# ---------------------------< End Functions >-------------------------------*/

# -----------------------------< End Of File >-------------------------------*/

Contents of DEL_PL.C below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This file contains the routine that deletes players   **/
# *                   from the game "Spirals Of Death".                     **/
# * This File's Name: del_pl.c.                                             **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/01/1992.                                 **/
# *                                                                         **/
# **************************< End General Information >***********************/

# -------------------------< Other Include Files >---------------------------*/

#include <graphics.h>
#include <alloc.h>
#include "players.h"

# ----------------------< End Other Include Files >--------------------------*/


# -----------------------------< Functions >---------------------------------*/


# ****************************< Start delete_player >******************/

# ****************************************************************************/
# * Function Name   : delete_player.                                   **/
# * Description     : This subroutine deletes a player from the player list **/
# *                   and relinks the appropriate list pointers.            **/
# * Inputs          : A pointer to the player to be deleted from the list.  **/
# * Outputs         : None.                                                 **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/27/92.                                   **/
# *                  -In addition to deleting a player from the player list,**/
# *                   this routine also takes care of removing the image of **/
# *                   the player from the screen.                           **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

void delete_player(players *dead)
{
	if(dead->pt == bad || dead->pt == bullet)
	{
		#  remove the image of the dead player */
		setfillstyle(SOLID_FILL,getbkcolor());

		if(dead->pt == bad)
			bar(dead->pd.bg.badguy.x,dead->pd.bg.badguy.y,(dead->pd.bg.badguy.x + dead->pd.bg.badguy.width),(dead->pd.bg.badguy.y + dead->pd.bg.badguy.height));
		else
			fillellipse((int) dead->pd.b.x,(int) dead->pd.b.y,dead->pd.b.radius,dead->pd.b.radius);

		#  set dead's prev to point to dead's next */
		dead->prev->next = dead->next;

		#  set dead's next to point to dead's prev */
		dead->next->prev = dead->prev;

		#  free up the memory that dead used */
		free(dead);
	}
}

# ****************************< End delete_player >********************/

# ---------------------------< End Functions >-------------------------------*/

# -----------------------------< End Of File >-------------------------------*/

Contents of DRAW_PL.C below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This file contains the routines for drawing good guys **/
# *                   and bad guys.                                         **/
# * This File's Name: draw_pl.c or draw_player_module.                      **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/01/1992.                                 **/
# *                                                                         **/
# **************************< End General Information >***********************/

# -------------------------< Other Include Files >---------------------------*/

#include <stdlib.h>
#include <graphics.h>
#include "num_defs.h"
#include "players.h"

# ----------------------< End Other Include Files >--------------------------*/

# -----------------------------< Prototypes >--------------------------------*/

#include "prototyp.h"

# ---------------------------< End Prototypes >------------------------------*/

# -----------------------------< Functions >---------------------------------*/

# ****************************< Start draw_good_guy >********************/

# ****************************************************************************/
# * Function Name   : draw_good_guy.                                        **/
# * Description     : Draws the good guy's gun turrent and gun barrel at    **/
# *                   its current location plus or minus the adjustment     **/
# *      				 angle that is passed to it.  Also makes the adjustment**/
# *                   in the good guy's data structure as to what its       **/
# *                   current gun angle is.                                 **/
# * Inputs          : A pointer to the good guy and the gun barrel adjustment*/
# *                   angle specified in radians.                           **/
# * Outputs         : The good guy's new gun angle via the parameter list.  **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/12/1992.                                 **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/
#
#void draw_good_guy(players *gg, float new_angle)
#{
#	static int background_color;
#	int x_barrel, y_barrel;
#
#	background_color = getbkcolor();
#
#	setcolor(background_color);
#
#	#  erase the gun barrel from its current location */
#	setfillstyle(SOLID_FILL,background_color);
#
#	x_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'x') + gg->pd.gg.x;
#	y_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'y') + gg->pd.gg.y;
#
#	fillellipse(x_barrel,y_barrel,gg->pd.gg.gun_length,gg->pd.gg.gun_length);
#
#	#  redraw gun barrel at its new location */
#
#	setfillstyle(SOLID_FILL,gg->pd.gg.gun_color);
#	gg->pd.gg.gun_angle+= new_angle;
#
#	x_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'x') + gg->pd.gg.x;
#	y_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'y') + gg->pd.gg.y;
#
#	fillellipse(x_barrel,y_barrel,gg->pd.gg.gun_length,gg->pd.gg.gun_length);
#
#	#  redraw the gun turret body - maybe this should only be done when a hit is taken */
#	fillellipse(gg->pd.gg.x,gg->pd.gg.y,gg->pd.gg.radius,gg->pd.gg.radius);
#
#}

# ****************************< End draw_good_guy >***********************/

# ---------------------------< End Functions >-------------------------------*/

# -----------------------------< End Of File >-------------------------------*/

Contents of HITCOLID.C below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This file contains bullet hit and collision detection **/
# *                   routines for the game "Spirals Of Death".             **/
# * This File's Name: hitcolid.c or hit_collide.                            **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/01/1992.                                 **/
# *                                                                         **/
# **************************< End General Information >***********************/

# -------------------------< Other Include Files >---------------------------*/

#include <math.h>
#include <graphics.h>
#include <conio.h>
#include <stdlib.h>
#include "num_defs.h"
#include "players.h"
#include "prototyp.h"

# ----------------------< End Other Include Files >--------------------------*/

# -----------------------------< Functions >---------------------------------*/

# ****************************< Start did_bad_good_guy_collide >********/

# ****************************************************************************/
# * Function Name   : did_bad_good_guy_collide.                        **/
# * Description     : This function determines if a bad guy and the good    **/
# *                   guy collided.  It returns a value of 1 if a collision **/
# *                   took place otherwise it returns a value of 0.         **/
# * Inputs          : A pointer to a bad guy.                               **/
# * Outputs         : An indicator of whether or not a collision took place.**/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-29-92.                                   **/
# *                  - On the first call to this routine, it searches the   **/
# *                    player list to find the good guy.  When it finds good**/
# *                    guy, it stores the good guy's address in a static    **/
# *                    pointer variable.  This way on subsequent calls to   **/
# *                    this routine the player list doesn't have to be      **/
# *                    researched to find the good guy.                     **/
# *                  - If a collision has occurred, the good guy's color is **/
# *                    changed to the next color in its color sequence.     **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

int did_bad_good_guy_collide(players *bg)
{
	int collide = ZERO_VALUE;
	float bad_guy_radial_distance;
	static players *gg = NULL;
	players *ferret; #  used to find the good guy in the player list */

	#  find the good guy in the player list */
	if(gg == NULL)
	{
		ferret = bg;  #  set the ferret to the same value as the bad guy as a starting point */

		while((ferret->next != bg) && (ferret->next->pt != good))
			ferret = ferret->next;

		#  the good guy has been found */
		gg = ferret->next;

	}

	#  start checking for the collision */

	#  calculate radius of bad guy from center of screen */
	bad_guy_radial_distance = sqrt(pow((bg->pd.bg.badguy.x - gg->pd.gg.x),TWO_VALUE) + pow((bg->pd.bg.badguy.y - gg->pd.gg.y),TWO_VALUE));

	if(bad_guy_radial_distance <= gg->pd.gg.radius)
	{
		collide = ONE_VALUE;

		#  while we're here, set the good guy's color to its next color */
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

# ****************************< End did_bad_good_guy_collide >***********/

# ---------------------------< End Functions >-------------------------------*/

# -----------------------------< End Of File >-------------------------------*/

Contents of MOVE_PL.C below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This file contains the routine used to move a player  **/
# *                   in the game "Spirals Of Death".                       **/
# * This File's Name: move_pl.c or move_player.                             **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/01/1992.                                 **/
# *                                                                         **/
# **************************< End General Information >***********************/

# -------------------------< Other Include Files >---------------------------*/

#include <math.h>
#include <graphics.h>
#include <conio.h>
#include "num_defs.h"
#include "players.h"

# ----------------------< End Other Include Files >--------------------------*/

# -----------------------------< Prototypes >--------------------------------*/

#include "prototyp.h"

# ---------------------------< End Prototypes >------------------------------*/

# -----------------------------< Functions >---------------------------------*/

# ****************************< Start move_player >**********************/

# ****************************************************************************/
# * Function Name   : move_player.												 **/
# * Description     : Move a player from its current location to its next   **/
# *                   location.                                             **/
# * Inputs          : A pointer to the player to be moved.                  **/
# * Outputs         : None.                                                 **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-29-92.                                   **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

void move_player(players *mm)  #  mm = move me */
{

	# The following may be useful for player movement in context of PERL/Tk:
	# http://search.cpan.org/~srezic/Tk-804.034/pod/Canvas.pod#TRANSFORMATIONS

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

	# The following may be useful for player movement in context of PERL/Tk:
	# http://search.cpan.org/~srezic/Tk-804.034/pod/Canvas.pod#TRANSFORMATIONS

	if(mm->pt == bad)
	{
		#  erase mm from its old location */
		bar(mm->pd.bg.badguy.x,mm->pd.bg.badguy.y,(mm->pd.bg.badguy.x + mm->pd.bg.badguy.width),(mm->pd.bg.badguy.y + mm->pd.bg.badguy.height));

		#  update the current angle of the bad guy */
		mm->pd.bg.current_angle += mm->pd.bg.angle_step;

		#  calculate the new polar radius for the bad guy's new location */
		if(mm->pd.bg.current_angle > two_pi_rads)
		{
			mm->pd.bg.radius-= FIVE_VALUE;
			mm->pd.bg.current_angle-= two_pi_rads;
		}

		#  convert the polar angle into cartesian coordinates for the bad guy's new location */
		mm->pd.bg.badguy.x = (int) polar_to_cartesian_coords(mm->pd.bg.radius,mm->pd.bg.current_angle,'x') + screen_center_x;
		mm->pd.bg.badguy.y = (int) polar_to_cartesian_coords(mm->pd.bg.radius,mm->pd.bg.current_angle,'y') + screen_center_y;

		#  redisplay mm at its new position */
		putimage(mm->pd.bg.badguy.x,mm->pd.bg.badguy.y,(short unsigned int *) mm->pd.bg.badguy.bitmap,COPY_PUT);

	}
	else if(mm->pt == bullet)
	{
		#  erase mm from its old location */
		fillellipse((int) mm->pd.b.x,(int) mm->pd.b.y,mm->pd.b.radius,mm->pd.b.radius);

		#  setup mm's new position */
		mm->pd.b.x += mm->pd.b.x_step;
		mm->pd.b.y += mm->pd.b.y_step;

		if((mm->pd.b.x <= screen_max_x) && (mm->pd.b.x >= ZERO_VALUE) && (mm->pd.b.y <= screen_max_y) && (mm->pd.b.y >= ZERO_VALUE))
		{
			#  identify the type of player who shot the bullet */
			player_who_shot_bullet = (players *) mm->pd.b.from;  #  this is necessary because "from" is a void pointer */

			#  redisplay mm at its new position  - choose appropriate bullet color */
			setfillstyle(SOLID_FILL,(player_who_shot_bullet->pt == good) ? GREEN : YELLOW);

			fillellipse((int) mm->pd.b.x,(int) mm->pd.b.y,mm->pd.b.radius,mm->pd.b.radius);
		}
		else
			delete_player(mm);

	}
}

# ****************************< End move_player >************************/

# End of file.
  
1;
  
