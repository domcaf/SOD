#!/usr/bin/perl
#!/usr/bin/perl -d:ptkdb

use Data::Dumper;
use constant LOG_FILE => '>/tmp/sod.log';
#use Excel::Writer::XLSX;
#use File::Find;
use Getopt::Long;
use Log::Log4perl qw(:easy);
use Pod::Usage;

$opt_help = 0; # Default to not displaying help.

$Data::Dumper::Sortkeys = 1;

Log::Log4perl->easy_init( { level => $DEBUG, file => LOG_FILE } );

ALWAYS("$0 commencing execution.");

=pod

=head1 S P I R A L S    O F    D E A T H

=head3 copyright 1992, 2017

No portion of this software package may be altered, distributed
or modified without the author's express written permission.

                               By

               Dominic Caffey a.k.a Thurlow Dominic Vigil Caffey
                    Advanced C Programming Class
                     Instructor:  David Conger
                       Spring Trimester 1992
                       TVI - Montoya Campus

				Converted to use PERL/Tk during 4th Quater/2017.

=head2 Description

"Spirals of Death" is a game in which bad guys, who move in a
decaying spirals, shoot at the good guy who's located in the center
of the screen.  The good guy can rotate his gun and fire back.  The
user assumes the role of the good guy.  The object of the game is
to destroy all the bad guys before being destroyed.  The good guy
can take 3 hits before dying; he will change to a different color
each time he's hit in the following color progression:  Green ->
Yellow -> Red -> Background Color.  The game is over when the good
guy's color is the same as that of the game background.  The good
guy fires green bullets and the bad guys fire yellow bullets.

=head2 C O M M A N D    K E Y S

=over 4

=item * Key         | Function

=item * ------------+------------------------------

=item * "<-"        = Rotate gun counter clockwise.

=item * "->"        = Rotate gun clockwise.

=item * "space bar" = fire gun.

=item * "h" or "H"  = display this help screen.

=item * "p" or "P"  = pause the game.

=item * "q" or "Q"  = quit the game.

=back

=head2 Known Bugs:

=over 4

=item * Program does not free up memory correctly when it ends or is quit by the user thus causing the machine upon which it is run to periodically crash.

=item * Acknowledgement of successful kills by either the good guy or bad guys needs to be refined as it doesn't always work correctly.

=back

=head2 Future Features for possible implementation:

=over 4

=item * Use Moose object framework.

=item * Convert to use "P-threads".

=item * Create unit tests for code.

=item * Create functional tests for code.

=item * Store score history in an sqlite database.

=item * Display score statistics such as averages for: shots fired by good, time played, shots fired by bad, etc.

=item * Display graphs of statistics.

=item * Enable the ability to control the bad guys and allow user to chose whether to play as good guy or bad guys.

=item * Enable the ability to play with another game instance over a network within the same subnet. Use UDP sockets?

=item * Explore what can be done in 3D?

=back

=head4 Dominic Caffey, Author - "Spirals of Death".

=cut

GetOptions("help|?");

pod2usage(
    {
        -exitval => 0,
        -message => "$0 help requested.",
        -verbose => 2
    }
) if ($opt_help);


# methods
ADD_GOOD.C
ADD_PL.C
DEL_PL.C
DRAW_PL.C
HITCOLID.C
MOVE_PL.C
SETCLEAN.C
SPIRALS.C
SPIRHELP.C
TESTTRIG.C
VISIT_PL.C
# constants
GETKEYS.H
NUM_DEFS.H
PLAYERS.H
PROTOTYP.H
Contents of GETKEYS.H below:
# --------------------------------getkeys.h----------------------------------*/

#ifndef __GETKEYS_INCLUDED__


# ---------------------------------constants---------------------------------*/

#define F1               59
#define F2               60
#define F3               61
#define F4               62
#define F5               63
#define F6               64
#define F7               65
#define F8               66
#define F9               67
#define F10              68
#define F11              133
#define F12              134

#define SHIFT_F1         84
#define SHIFT_F2         85
#define SHIFT_F3         86
#define SHIFT_F4         87
#define SHIFT_F5         88
#define SHIFT_F6         89
#define SHIFT_F7         90
#define SHIFT_F8         91
#define SHIFT_F9         92
#define SHIFT_F10        93
#define SHIFT_F11        135
#define SHIFT_F12        136

#define CTRL_F1          94
#define CTRL_F2          95
#define CTRL_F3          96
#define CTRL_F4          97
#define CTRL_F5          98
#define CTRL_F6          99
#define CTRL_F7          100
#define CTRL_F8          101
#define CTRL_F9          102
#define CTRL_F10         103
#define CTRL_F11         137
#define CTRL_F12         138  

#define ALT_F1           104
#define ALT_F2           105
#define ALT_F3           106
#define ALT_F4           107
#define ALT_F5           108
#define ALT_F6           109
#define ALT_F7           110
#define ALT_F8           111
#define ALT_F9           112
#define ALT_F10          113
#define ALT_F11          139
#define ALT_F12          140

#define UP_ARROW         72
#define DOWN_ARROW       80
#define LEFT_ARROW       75
#define RIGHT_ARROW      77

#define CTRL_W           23
#define CTRL_Z           26

#define HOME_KEY         71
#define END_KEY          79

#define PGUP_KEY         73
#define PGDN_KEY         81

#define INSERT_KEY       82
#define DELETE_KEY       83

#define SPACE_BAR        32  #  added by Dominic Caffey on 4-28-92 */

#define WAIT             0
#define DONT_WAIT        1

# -------------------------------end constants-------------------------------*/



# --------------------------------prototypes---------------------------------*/

int get_keystroke(int pause, int *special_key);

# ------------------------------end prototypes-------------------------------*/


#define __GETKEYS_INCLUDED__ 
#endif

# ------------------------------end getkeys.h--------------------------------*/
Contents of NUM_DEFS.H below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This file contains definitions for numeric constants. **/
# * This File's Name: Num_defs.h.                                           **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 2-23-92.                                   **/
# *                                                                         **/
# **************************< End General Information >***********************/

# ----------------------------< Constants >----------------------------------*/

#ifndef NUM_DEFS_H

#  integer constants */

	#define ZERO_VALUE  0
	#define ONE_VALUE   1
	#define TWO_VALUE   2
	#define THREE_VALUE 3
	#define FOUR_VALUE  4
	#define FIVE_VALUE  5
	#define TEN_VALUE   10

#  trigonometry constants */

	#define HALF_CIRCLE_RADIANS 3.1415927 #  # of radians in half circle */
	#define HALF_CIRCLE_DEGREES 180  #  # of degrees in half circle */
	#define PI          3.1415927

	#define NUM_DEFS_H

#endif

# --------------------------< End Constants >--------------------------------*/

# -----------------------------< End Of File >-------------------------------*/

Contents of PLAYERS.H below:
# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This file contains the definition of a player for the **/
# *                   game "Spirals Of Death". A player can be the goodguy, **/
# *                   a badguy or a bullet fired by either of the previous. **/
# * This File's Name: Players.h.                                            **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-05-92.                                   **/
# *                                                                         **/
# **************************< End General Information >***********************/

# ----------------------------< Constants >----------------------------------*/

# * Description     : Stores constants associated with the description and  **/
# *                   behavior of a good guy.                               **/


#define GOOD_GUY_RADIUS 0.05      #  This is specified as a percentage */
#define GOOD_GUY_GUN_LENGTH 0.01 #  This is specified as a percentage */
#define GUN_WIDTH_HALF_ANGLE 0.1  #  SPECIFIED IN RADIANS */

# * Description     : Stores constants associated with the description and                                                      **/
# *                   behavior of a bad guy.                                                      **/

#  What follows below are actually radii for the different body parts mentioned */

#define BAD_GUY_BODY_HEIGHT 	0.01      #  percentage */
#define BAD_GUY_BODY_WIDTH 	0.02      #  percentage */
#define BAD_GUY_MOUTH_HEIGHT 	0.006     #  percentage */
#define BAD_GUY_MOUTH_WIDTH 	0.01 	  #  percentage */
#define BAD_GUY_EYE_LENGTH 	0.02      #  percentage */
#define BAD_GUY_EYE_ANGLE_1     30        #  degrees */
#define BAD_GUY_EYE_ANGLE_2     50        #  degrees */
#define BAD_GUY_EYE_ANGLE_3     130       #  degrees */
#define BAD_GUY_EYE_ANGLE_4     150       #  degrees */



#define SHOOTING_PROBABILITY_FACTOR 101


#define BAD_GUY_MAX_ANGLE_STEP 6 #  This is in degrees */
#define GOOD_GUY_BULLET_SPEED_FACTOR 3
#define MAX_GOOD_GUY_EVENTS 1 #  max # of events processed per visit to good guy */
#define GOOD_GUY_ROTATION_INCREMENT 0.087 #  equivalent to 5 degrees in radians */
#define BULLET_RADIUS 2

# --------------------------< End Constants >--------------------------------*/


# ----------------------------< Typedefs  >----------------------------------*/

#ifndef PLAYERS_H

	#ifndef SPRITES_H

		typedef struct _sprites
		{
			short unsigned int *bitmap;
			int x, y;
			int width, height;
		} sprites;

		#define SPRITES_H
	#endif



	#ifndef BULLET_H

		typedef struct _bullet
		{
			float x, y;       #  center of circular bullet */
			int radius;	#  radius of bullet as %age of screen dimensions */
			float x_step, y_step;	#  movement increments */
			void *from; #  pointer to player who shot bullet */
		} bullets;

		#define BULLET_H
	#endif


	#ifndef BADGUY_H

		typedef struct _badguy
		{
			sprites badguy;    #  badguy inherits qualities of sprite */

			int radius; #  radial distance from screen center */

			float angle_step;  #  angle in radians */
			float current_angle; #  current angular position in radians */
		} badguys;

		#define BADGUY_H
	#endif


	#ifndef GOODGUY_H

		typedef struct _goodguy
		{
			int x, y;       #  center of good guy */
			int radius;	#  radius of good_guy, excluding barrel */

			int gun_length;  #  length as a %age of screen dimensions */
			int gun_color;

			float gun_angle; #  angle in radians where gun is pointing */
			float gun_width_half_angle; #  half the angle width of the gun barrel in radians */
		} goodguys;

		#define GOODGUY_H
	#endif

		typedef struct _player
		{
			enum player_type {good,bad,bullet} pt;

			union
			{
				goodguys gg;
				badguys  bg;
				bullets   b;
			} pd; #  pd = player data */

			struct _player *next, *prev; #  link structure pointers */
		} players;

	#define PLAYERS_H
#endif

# --------------------------< End Typedefs  >--------------------------------*/

# -----------------------------< End Of File >-------------------------------*/
Contents of PROTOTYP.H below:

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

		void draw_good_guy(players *, float new_angle);

		int  draw_bad_guy(sprites *);

	#  prototypes for setclean.c */

		int  setup_video_driver_and_mode(void);
		void restore_pre_game_environment(void);

	#  prototypes for polrcart.c */

		float polar_to_cartesian_coords(float, float, char);
		float cartesian_to_polar_coords(float, float, char);

	#  prototypes for add_good.c */

		players *add_good(void);

	#  prototypes for add_pl.c */

		int add_player(players *, enum player_type, sprites *, players *);

	#  prototypes for del_pl.c */

		void  delete_player(players *);

	#  prototypes for visit_pl.c */

		void  visit_player(players *);

	#  prototypes for move_pl.c */

		void  move_player(players *);

	#  prototypes for hit.c */

		int did_bad_good_guy_collide(players *);
		players *did_bullet_hit_something(players *);

	#  prototypes for spirhelp.c */
		void spirals_help(void);

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

void draw_good_guy(players *gg, float new_angle)
{
	static int background_color;
	int x_barrel, y_barrel;

	background_color = getbkcolor();

	setcolor(background_color);

	#  erase the gun barrel from its current location */
	setfillstyle(SOLID_FILL,background_color);

	x_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'x') + gg->pd.gg.x;
	y_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'y') + gg->pd.gg.y;

	fillellipse(x_barrel,y_barrel,gg->pd.gg.gun_length,gg->pd.gg.gun_length);

	#  redraw gun barrel at its new location */

	setfillstyle(SOLID_FILL,gg->pd.gg.gun_color);
	gg->pd.gg.gun_angle+= new_angle;

	x_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'x') + gg->pd.gg.x;
	y_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'y') + gg->pd.gg.y;

	fillellipse(x_barrel,y_barrel,gg->pd.gg.gun_length,gg->pd.gg.gun_length);

	#  redraw the gun turret body - maybe this should only be done when a hit is taken */
	fillellipse(gg->pd.gg.x,gg->pd.gg.y,gg->pd.gg.radius,gg->pd.gg.radius);

}

# ****************************< End draw_good_guy >***********************/

# ****************************< Start draw_bad_guy >**********************/

# ****************************************************************************/
# * Function Name   : draw_bad_guy.                                     **/
# * Description     : Draws an image of a bad guy on the screen and stores  **/
# *                   it in a sprite that is passed to it from the calling  **/
# *                   routine.                                              **/
# * Inputs          : A pointer to a sprite.                                **/
# * Outputs         : returns 0 if successful and 1 if there was a problem. **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-5-1992.                                  **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

int draw_bad_guy(sprites *bg)
{
	int success;

	#  put the bad guy on the screen */

	setfillstyle(SOLID_FILL,YELLOW);

	fillellipse((getmaxx()/TWO_VALUE),(getmaxy()/TWO_VALUE),(BAD_GUY_BODY_WIDTH * getmaxx()),(BAD_GUY_BODY_HEIGHT * getmaxy()));

	setfillstyle(SOLID_FILL,RED);

	pieslice((getmaxx()/TWO_VALUE),(getmaxy()/TWO_VALUE),BAD_GUY_EYE_ANGLE_1,BAD_GUY_EYE_ANGLE_2,(BAD_GUY_EYE_LENGTH * getmaxx()));
	pieslice((getmaxx()/TWO_VALUE),(getmaxy()/TWO_VALUE),BAD_GUY_EYE_ANGLE_3,BAD_GUY_EYE_ANGLE_4,(BAD_GUY_EYE_LENGTH * getmaxx()));

	setfillstyle(SOLID_FILL,BLUE);

	fillellipse((getmaxx()/TWO_VALUE),(getmaxy()/TWO_VALUE),(BAD_GUY_MOUTH_WIDTH * getmaxx()),(BAD_GUY_MOUTH_HEIGHT * getmaxy()));

	#  set the bitmap extents */

	bg->x = (getmaxx() / TWO_VALUE) - (BAD_GUY_BODY_WIDTH * getmaxx());
	bg->y = (getmaxy() / TWO_VALUE) - (BAD_GUY_EYE_LENGTH * getmaxx());
	bg->width = TWO_VALUE * BAD_GUY_BODY_WIDTH * getmaxx();
	bg->height = (BAD_GUY_EYE_LENGTH * getmaxx()) + (BAD_GUY_BODY_HEIGHT * getmaxy());

	#  allocate space for the bitmap */

	bg->bitmap = (short unsigned int *) calloc(ONE_VALUE,(bg->width * bg->height * sizeof(short unsigned int)));

	if (bg->bitmap != NULL)
	{
		getimage(bg->x,bg->y,(bg->x + bg->width),(bg->y + bg->height),(short unsigned int *) bg->bitmap);

		#  erase image from screen now that it has been captured */
		putimage(bg->x,bg->y,(short unsigned int *) bg->bitmap,XOR_PUT);

		success = ZERO_VALUE;
	}
	else
		success = ONE_VALUE;

	return(success);
}

# *************************< End draw_bad_guy >***************************/

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



# ****************************< Start did_bullet_hit_something >********/

# ****************************************************************************/
# * Function Name   : did_bullet_hit_something.                        **/
# * Description     : This function determines if a bullet hit something.   **/
# *                   If it hit something it identifies what it hit and     **/
# *                   returns a pointer to the hit object otherwise it      **/
# *                   returns a value of NULL.                              **/
# * Inputs          : A pointer to the bullet being tested for a hit.       **/
# * Outputs         : A pointer to hit object or NULL if no hit.            **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-30-92.                                   **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

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


	#  calculate look ahead coordinates */
	look_ahead_x = bullet->pd.b.x + (TWO_VALUE * bullet->pd.b.x_step);
	look_ahead_y = bullet->pd.b.y + (TWO_VALUE * bullet->pd.b.y_step);

	#  determine if the bullet actually hit something */
	if(getpixel((int) look_ahead_x,(int) look_ahead_y) != background_color)
	{
		#  the bullet hit something, find out what it hit */
		target = bullet->next; #  set starting point for search */

		while((target != bullet) && (!target_found))  #  traverse the player list */
		{
			if(target != bullet->pd.b.from) #  a player can't shoot itself */

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
				else #  the player type is another bullet */
				{
				  #  if the distance between their two centers is less than (2 * r) then they hit each other */
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

# ****************************< End did_bullet_hit_something >***********/

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


# ---------------------------< End Functions >-------------------------------*/

# -----------------------------< End Of File >-------------------------------*/

Contents of SETCLEAN.C below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This module sets up the environment for the game and  **/
# *                   restores the pre game evironment once the game is over**/
# *                   .  Currently, the pre game environment restoration    **/
# *                   consists only of restoring the pre game video mode but**/
# *                   later revisions of this routine will also restore     **/
# *                   other pre game environment elements.                  **/
# * This File's Name: setclean.c or game_setup_cleanup_module.              **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/01/1992.                                 **/
# *                                                                         **/
# **************************< End General Information >***********************/

# -------------------------< Other Include Files >---------------------------*/

#include <stdio.h>
#include <conio.h>
#include <graphics.h>
#include "num_defs.h"

# ----------------------< End Other Include Files >--------------------------*/

# -----------------------------< Functions >---------------------------------*/

# ****************************< Start setup_video_driver_and_mode >*******/

# ****************************************************************************/
# * Function Name   : setup_video_driver_and_mode.                      **/
# * Description     : This routine registers the video driver and sets the  **/
# *                   screen mode that the calling routine will use.  This  **/
# *                   routine is currently hardwired to register the        **/
# *                   "egavga" driver and set the screen mode to "VGAMED"   **/
# *                   which is 640 X 350, 16 color with 2 graphics pages.   **/
# * Inputs          : None.                                                 **/
# * Outputs         : Returns an integer value of "0" if successful and "1" **/
# *                   if the routine failed to register the driver or set   **/
# *                   the appropriate screen mode.                          **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/02/1992.                                 **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

int setup_video_driver_and_mode(void)
{
	int error_flag = ZERO_VALUE;
	int  errorcode, graphics_mode = VGAMED;

#ifdef video_problems

#  DAVE - I've been having a lot of problems getting video drivers to link
into my program correctly; I've been in touch with Borland and they say that
it's probably due to my hardware incompatibility problem.  Everything links
fine and dandy but when I run the program I get a very vague message that
tells me nothing about what the problem actually is.  I've used preprocessor
directives to hop back back and forth between loading the video driver and
linking it into the code.  As a result of the problems I've been having, I'm
including the "egavga.bgi" video driver and doing a "detect" with "initgraph()".
This may be shoddy but it works given my present incompatibility dilemma.
- Dom */

	#  register the graphics driver to be used before calling initgraph */
   	errorcode = registerbgidriver(EGAVGA_driver);    

	#  test to see if video driver registration worked */

	if (errorcode < ZERO_VALUE)
	{
		printf("Video driver - graphics error: %s\n",grapherrormsg(errorcode));
		printf("errorcode = %d\n",errorcode);
		printf("Press any key to quit.");
		getch();
		error_flag = ONE_VALUE; #  set an error_flag */
	}
	else
	{
		#  Set the video environment for the program to be VGA, 640 x 350, 16 color.
		The VGA driver will be linked directly into this program's resulting
		executable. See "UTIL.DOC" on your Borland distribution diskettes. */

		initgraph((int far *) &errorcode,(int far *) &graphics_mode, "");

		#  test to see if initgraph worked */
		errorcode = graphresult(); 

		if (errorcode != grOk)
		{
			printf("Initgraph - graphics error: %s\n",grapherrormsg(errorcode));
			printf("Press any key to quit.");
			getch();
			error_flag = ONE_VALUE; #  set an error_flag */
		}
	}

#endif

#ifndef video_problems

	errorcode = DETECT;
	initgraph((int far *) &errorcode,(int far *) &graphics_mode, "");


		#  test to see if initgraph worked */
		errorcode = graphresult();

		if (errorcode != grOk)
		{
			printf("Initgraph - graphics error: %s\n",grapherrormsg(errorcode));
			printf("Press any key to quit.");
			getch();
			error_flag = ONE_VALUE; #  set an error_flag */
		}

#endif

	return(error_flag);
}

# ****************************< End setup_video_driver_and_mode >*********/

# ****************************< Start restore_pre_game_environment >******/

# ****************************************************************************/
# * Function Name   : restore_pre_game_environment.                    **/
# * Description     : This routine restores the pre game environment.       **/
# *                   Currently, the pre game environment restoration       **/
# *                   consists only of restoring the pre game video mode but**/
# *                   later revisions of this routine will also restore     **/
# *                   other pre game environment elements.                  **/
# * Inputs          : None.                                                 **/
# * Outputs         : None.                                                 **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-4-92.                                    **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

void restore_pre_game_environment(void)
{
	closegraph(); #  free the memory allocated by graphics system */

	restorecrtmode(); #  put the system back in the text mode it was in prior to start of game */
}

# ****************************< End restore_pre_game_environment >********/

# ---------------------------< End Functions >-------------------------------*/

# -----------------------------< End Of File >-------------------------------*/

Contents of SPIRALS.C below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This is the main module for the game "Spirals Of Death**/
# * This File's Name: spirals.c or 0-0-main.                                **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 3/31/1992.                                 **/
# *                                                                         **/
# **************************< End General Information >***********************/

# -------------------------< Other Include Files >---------------------------*/

#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <time.h>
#include <graphics.h>
#include "num_defs.h"
#include "players.h"


# ----------------------< End Other Include Files >--------------------------*/

# ----------------------------< Constants >----------------------------------*/

#define MAX_BAD_GUYS 3
#define MAX_BULLETS  1

# --------------------------< End Constants >--------------------------------*/

# -----------------------------< Prototypes >--------------------------------*/

#include "prototyp.h"

# ---------------------------< End Prototypes >------------------------------*/

# -------------------------------< Main >------------------------------------*/

int main(void)
{
	sprites bad_image;
	players *player_list = NULL;
	int bad_guy_count = ZERO_VALUE;
	int error_flag;

	#  set up the video environment */
	if (setup_video_driver_and_mode())
	{
		printf("\a\a\a\nVideo driver or screen mode error - program execution terminated.");
		exit(ONE_VALUE);
	}

	#  initialize the random # generator */
	randomize();

	#  make the game background color black */
	setbkcolor(BLACK);

	#  generate and capture bad guy & good guy images */
	if(draw_bad_guy(&bad_image))
	{
		printf("\a\a\a\nMemory allocation problem in draw_bad_guy.\nProgram execution terminated.");
		exit(ONE_VALUE);
	}

	#  load initial conditions into good_guy & bad_guys i.e. build player list */

	#  load the good guy into the list */

	player_list = add_good();

	if(player_list == NULL)
	{
		printf("\a\a\a\nCouldn't create good guy to add to list.\nProgram execution terminated.");
		exit(ONE_VALUE);
	}

	#  display the good guy */
	draw_good_guy(player_list,ZERO_VALUE);

#ifndef good_debug
	#  load the bad guys into the list */
	do
	{
		error_flag = add_player(player_list,bad,&bad_image,NULL);
		bad_guy_count++;
	}
	while((bad_guy_count < MAX_BAD_GUYS) && (!error_flag));
#endif

	#  main processing loop - let the games begin ! */

	while(player_list != NULL)
	{
		visit_player(player_list);

		player_list = player_list->next;
	}

	#  the game's over so free up the memory that was previously allocated */

	player_list->prev->next = NULL;

	while(player_list != NULL)
	{
		player_list = player_list->next;
		free(player_list->prev);
	}


	#  restore the pregame video environment */
	restore_pre_game_environment();

	return(ZERO_VALUE); #  indicate normal program termination */
}

# -----------------------------< End Main >----------------------------------*/

# -----------------------------< End Of File >-------------------------------*/

Contents of SPIRHELP.C below:

# ----------------------------< Start Of File >------------------------------*/

# ****************************< General Information >*************************/
# * Description     : This file contains the online help facility for the   **/
# *                   game "Spirals of Death".                              **/
# * This File's Name: spirhelp.c or spirals_help.                           **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 5-14-92.                                    **/
# *                                                                         **/
# **************************< End General Information >***********************/

# -------------------------< Other Include Files >---------------------------*/

#include <stdio.h>
#include <conio.h>
#include <graphics.h>

# ----------------------< End Other Include Files >--------------------------*/

# ----------------------------< Constants >----------------------------------*/



# --------------------------< End Constants >--------------------------------*/

# ------------------------< Enumerated Types >-------------------------------*/



# ----------------------< End Enumerated Types >-----------------------------*/

# ----------------------------< Typedefs  >----------------------------------*/



# --------------------------< End Typedefs  >--------------------------------*/

# -----------------------------< Macros  >-----------------------------------*/



# ---------------------------< End Macros  >---------------------------------*/

# -----------------------------< Prototypes >--------------------------------*/



# ---------------------------< End Prototypes >------------------------------*/

# -----------------------------< Functions >---------------------------------*/

# ****************************< Start spirals_help >*************************/

# ****************************************************************************/
# * Function Name   : spirals_help.													    **/
# * Description     : This is the online help facility for the game "Spirals**/
# *                   Of Death".                                            **/
# * Inputs          : None.                                                 **/
# * Outputs         : None.                                                 **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 5-14-92.                                   **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

void spirals_help(void)
{
	#  put the display in text mode */
	restorecrtmode();

	#  display the help text */

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

	getch(); #  pause the routine while the user is reading the help screen */

	#  put the display back into graphics mode */
	setgraphmode(getgraphmode());

}

# ****************************< End spirals_help >***************************/

# ---------------------------< End Functions >-------------------------------*/

# -------------------------------< Main >------------------------------------*/



# -----------------------------< End Main >----------------------------------*/

# -----------------------------< End Of File >-------------------------------*/

Contents of TESTTRIG.C below:
#  this program is used to test the correctness and functionality of the
routines contained in the file "polrcart.c". */

float polar_to_cartesian_coords(float,float,char);

float cartesian_to_polar_coords(float , float , char);

#include <stdio.h>

main()
{


	float x, y, radius, angle;
	int resp = 1;


# *****/

	while(resp)
	{
		printf("\a\a\nEnter float values for x & y ---> ");
		scanf("%f %f",&x,&y);
		printf("\nYou entered the following values: %f %f.",x,y);


		radius = cartesian_to_polar_coords(x,y,'r');
		angle = cartesian_to_polar_coords(x,y,'a');

		printf("\n\nThe polar coordinates for (%f,%f) are (%f,%f).",x,y,radius,angle);

		printf("\n\nEnter float values for radius & angle ---> ");
		scanf("%f %f",&radius,&angle);
		printf("\nYou entered the following values: %f %f",radius,angle);

		printf("\nThe x coordinate for (%f,%f) is %f",radius,angle,polar_to_cartesian_coords(radius,angle,'x'));

		printf("\nThe y coordinate for (%f,%f) is %f",radius,angle,polar_to_cartesian_coords(radius,angle,'y'));

		printf("\nDo you want to run another test (1 for y, 0 for n) ---> ");
		scanf("%d",&resp);
	}
}

#  end of file */
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

# -------------------------< Other Include Files >---------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <graphics.h>
#include <conio.h>
#include "num_defs.h"
#include "getkeys.h"
#include "players.h"
#include "prototyp.h"

# ----------------------< End Other Include Files >--------------------------*/

# -----------------------------< Functions >---------------------------------*/

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
}

# ****************************< End visit_player >**********************/

# ---------------------------< End Functions >-------------------------------*/

# -----------------------------< End Of File >-------------------------------*/

sub BEGIN {
    $ENV{'DISPLAY'} = 'localhost:10.0';    # Needed for use with PTKDB & SSH & X11 forwarding over SSH.
}    # sub BEGIN

# End of file.
