
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This is the main module for the game "Spirals Of Death**/
/** This File's Name: spirals.c or 0-0-main.                                **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 3/31/1992.                                 **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*-------------------------< Other Include Files >---------------------------*/

#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <time.h>
#include <graphics.h>
#include "num_defs.h"
#include "players.h"


/*----------------------< End Other Include Files >--------------------------*/

/*----------------------------< Constants >----------------------------------*/

#define MAX_BAD_GUYS 3
#define MAX_BULLETS  1

/*--------------------------< End Constants >--------------------------------*/

/*-----------------------------< Prototypes >--------------------------------*/

#include "prototyp.h"

/*---------------------------< End Prototypes >------------------------------*/

/*-------------------------------< Main >------------------------------------*/

int main(void)
{
	sprites bad_image;
	players *player_list = NULL;
	int bad_guy_count = ZERO_VALUE;
	int error_flag;

	/* set up the video environment */
	if (setup_video_driver_and_mode())
	{
		printf("\a\a\a\nVideo driver or screen mode error - program execution terminated.");
		exit(ONE_VALUE);
	}

	/* initialize the random # generator */
	randomize();

	/* make the game background color black */
	setbkcolor(BLACK);

	/* generate and capture bad guy & good guy images */
	if(draw_bad_guy(&bad_image))
	{
		printf("\a\a\a\nMemory allocation problem in draw_bad_guy.\nProgram execution terminated.");
		exit(ONE_VALUE);
	}

	/* load initial conditions into good_guy & bad_guys i.e. build player list */

	/* load the good guy into the list */

	player_list = add_good();

	if(player_list == NULL)
	{
		printf("\a\a\a\nCouldn't create good guy to add to list.\nProgram execution terminated.");
		exit(ONE_VALUE);
	}

	/* display the good guy */
	draw_good_guy(player_list,ZERO_VALUE);

#ifndef good_debug
	/* load the bad guys into the list */
	do
	{
		error_flag = add_player(player_list,bad,&bad_image,NULL);
		bad_guy_count++;
	}
	while((bad_guy_count < MAX_BAD_GUYS) && (!error_flag));
#endif

	/* main processing loop - let the games begin ! */

	while(player_list != NULL)
	{
		visit_player(player_list);

		player_list = player_list->next;
	}

	/* the game's over so free up the memory that was previously allocated */

	player_list->prev->next = NULL;

	while(player_list != NULL)
	{
		player_list = player_list->next;
		free(player_list->prev);
	}


	/* restore the pregame video environment */
	restore_pre_game_environment();

	return(ZERO_VALUE); /* indicate normal program termination */
}

/*-----------------------------< End Main >----------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/

