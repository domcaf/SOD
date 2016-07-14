
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This file contains the routine for visiting a player  **/
/**                   in the game "Spirals Of Death".                       **/
/** This File's Name: visit_pl.c or visit_player.                           **/
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
#include "getkeys.h"
#include "players.h"
#include "prototyp.h"

/*----------------------< End Other Include Files >--------------------------*/

/*-----------------------------< Functions >---------------------------------*/

/*****************************< Start visit_player >********************/

/*****************************************************************************/
/** Function Name   : visit_player.                                    **/
/** Description     : This routine visits a player in the player_list and   **/
/**                   gives the player the opportunity to behave according  **/
/**                   to its nature. ie shoot, move, crash or do nothing.   **/
/** Inputs          : A pointer to a player in the player_list.             **/
/** Outputs         : None.                                                 **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4-28-92.                                   **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

void visit_player(players *player)
{
	int event_count, keystroke, special_key, exit_flag = ZERO_VALUE;
	int good_shot;  /* this is basically a dummy variable & is used only to satisfy function calling conventions */
	players *wounded;

	switch(player->pt)
	{
		case good:
			for(event_count = ZERO_VALUE; event_count < MAX_GOOD_GUY_EVENTS; event_count++)
			{
				/* get a keystroke from the good guy and act accordingly */
				keystroke = get_keystroke(DONT_WAIT,&special_key);

			  /* process the keystroke */
				if(keystroke || special_key)
					if(keystroke && !special_key)
					{
						switch(keystroke)
						{
							case 'H': /* activate help and pause the game */
							case 'h':
								spirals_help();
								break;

							case 'P': /* pause the game */
							case 'p':
								getch();
								break;

							case 'Q': /* quit the game */
							case 'q':
								exit_flag = ONE_VALUE;
								break;

							case SPACE_BAR:  /* fire the good guy's gun */
								good_shot = add_player(player,bullet,NULL,player);
								break;

							default:  /* ignore invalid keystrokes */
								break;
						}
					}
					else if(!keystroke && special_key)
					{
						switch(special_key)
						{
							case LEFT_ARROW:  /* rotate the good guy's gun counter clockwise */
								draw_good_guy(player,-GOOD_GUY_ROTATION_INCREMENT);
								break;

							case RIGHT_ARROW: /* rotate the good guy's gun clockwise */
								draw_good_guy(player,GOOD_GUY_ROTATION_INCREMENT);
								break;

							default:  /* ignore invalid keystrokes */
								break;
						}
					}
			}
			break;

		case bad:

			/* determine if bad guy crashed into good guy */
			if(did_bad_good_guy_collide(player))
				delete_player(player);
			else
			{

#ifndef no_shoot

				/* randomly decide on gun firing & take action */
				if(random(SHOOTING_PROBABILITY_FACTOR) == ONE_VALUE)
					good_shot = add_player(player,bullet,NULL,player);

#endif

				/* erase bad guy from old location and move to new location */
				move_player(player);
			}

			break;

		case bullet:

			/* determine if and what bullet may have struck */
			if((wounded = did_bullet_hit_something(player)) != NULL)
			{
				/* delete the wounded player or change its status */
				switch(wounded->pt)
				{
					case good:

						/* set the good guy's color to its next color */
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
						/* delete the bad guy or the bullet */
						delete_player(wounded);
						break;

					default: /* do nothing */
						break;
				}

				/* delete the bullet */
				delete_player(player);

			}

			/* bullet didn't hit anything, move the player to its next position */
			move_player(player);

			break;

		default:    /* don't do anything */
			break;
	}

	if (exit_flag)
	{
		/* the game's over so free up the memory that was previously allocated */

		player->prev->next = NULL;

		while(player != NULL)
		{
			player = player->next;
			free(player->prev);
		}


		/* restore the pregame video environment */
		restore_pre_game_environment();

		/* display the score & pause before terminating program */
		exit(ZERO_VALUE);
	}
}

/*****************************< End visit_player >**********************/

/*---------------------------< End Functions >-------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/

