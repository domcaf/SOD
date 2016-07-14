
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This file contains the routine that deletes players   **/
/**                   from the game "Spirals Of Death".                     **/
/** This File's Name: del_pl.c.                                             **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4/01/1992.                                 **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*-------------------------< Other Include Files >---------------------------*/

#include <graphics.h>
#include <alloc.h>
#include "players.h"

/*----------------------< End Other Include Files >--------------------------*/


/*-----------------------------< Functions >---------------------------------*/


/*****************************< Start delete_player >******************/

/*****************************************************************************/
/** Function Name   : delete_player.                                   **/
/** Description     : This subroutine deletes a player from the player list **/
/**                   and relinks the appropriate list pointers.            **/
/** Inputs          : A pointer to the player to be deleted from the list.  **/
/** Outputs         : None.                                                 **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4/27/92.                                   **/
/**                  -In addition to deleting a player from the player list,**/
/**                   this routine also takes care of removing the image of **/
/**                   the player from the screen.                           **/
/**                                                                         **/
/**                                                                         **/
/*****************************************************************************/

void delete_player(players *dead)
{
	if(dead->pt == bad || dead->pt == bullet)
	{
		/* remove the image of the dead player */
		setfillstyle(SOLID_FILL,getbkcolor());

		if(dead->pt == bad)
			bar(dead->pd.bg.badguy.x,dead->pd.bg.badguy.y,(dead->pd.bg.badguy.x + dead->pd.bg.badguy.width),(dead->pd.bg.badguy.y + dead->pd.bg.badguy.height));
		else
			fillellipse((int) dead->pd.b.x,(int) dead->pd.b.y,dead->pd.b.radius,dead->pd.b.radius);

		/* set dead's prev to point to dead's next */
		dead->prev->next = dead->next;

		/* set dead's next to point to dead's prev */
		dead->next->prev = dead->prev;

		/* free up the memory that dead used */
		free(dead);
	}
}

/*****************************< End delete_player >********************/

/*---------------------------< End Functions >-------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/

