/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This file contains the definition of a player for the **/
/**                   game "Spirals Of Death". A player can be the goodguy, **/
/**                   a badguy or a bullet fired by either of the previous. **/
/** This File's Name: Players.h.                                            **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4-05-92.                                   **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*----------------------------< Constants >----------------------------------*/

/** Description     : Stores constants associated with the description and  **/
/**                   behavior of a good guy.                               **/


#define GOOD_GUY_RADIUS 0.05      /* This is specified as a percentage */
#define GOOD_GUY_GUN_LENGTH 0.01 /* This is specified as a percentage */
#define GUN_WIDTH_HALF_ANGLE 0.1  /* SPECIFIED IN RADIANS */

/** Description     : Stores constants associated with the description and                                                      **/
/**                   behavior of a bad guy.                                                      **/

/* What follows below are actually radii for the different body parts mentioned */

#define BAD_GUY_BODY_HEIGHT 	0.01      /* percentage */
#define BAD_GUY_BODY_WIDTH 	0.02      /* percentage */
#define BAD_GUY_MOUTH_HEIGHT 	0.006     /* percentage */
#define BAD_GUY_MOUTH_WIDTH 	0.01 	  /* percentage */
#define BAD_GUY_EYE_LENGTH 	0.02      /* percentage */
#define BAD_GUY_EYE_ANGLE_1     30        /* degrees */
#define BAD_GUY_EYE_ANGLE_2     50        /* degrees */
#define BAD_GUY_EYE_ANGLE_3     130       /* degrees */
#define BAD_GUY_EYE_ANGLE_4     150       /* degrees */



#define SHOOTING_PROBABILITY_FACTOR 101


#define BAD_GUY_MAX_ANGLE_STEP 6 /* This is in degrees */
#define GOOD_GUY_BULLET_SPEED_FACTOR 3
#define MAX_GOOD_GUY_EVENTS 1 /* max # of events processed per visit to good guy */
#define GOOD_GUY_ROTATION_INCREMENT 0.087 /* equivalent to 5 degrees in radians */
#define BULLET_RADIUS 2

/*--------------------------< End Constants >--------------------------------*/


/*----------------------------< Typedefs  >----------------------------------*/

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
			float x, y;       /* center of circular bullet */
			int radius;	/* radius of bullet as %age of screen dimensions */
			float x_step, y_step;	/* movement increments */
			void *from; /* pointer to player who shot bullet */
		} bullets;

		#define BULLET_H
	#endif


	#ifndef BADGUY_H

		typedef struct _badguy
		{
			sprites badguy;    /* badguy inherits qualities of sprite */

			int radius; /* radial distance from screen center */

			float angle_step;  /* angle in radians */
			float current_angle; /* current angular position in radians */
		} badguys;

		#define BADGUY_H
	#endif


	#ifndef GOODGUY_H

		typedef struct _goodguy
		{
			int x, y;       /* center of good guy */
			int radius;	/* radius of good_guy, excluding barrel */

			int gun_length;  /* length as a %age of screen dimensions */
			int gun_color;

			float gun_angle; /* angle in radians where gun is pointing */
			float gun_width_half_angle; /* half the angle width of the gun barrel in radians */
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
			} pd; /* pd = player data */

			struct _player *next, *prev; /* link structure pointers */
		} players;

	#define PLAYERS_H
#endif

/*--------------------------< End Typedefs  >--------------------------------*/

/*-----------------------------< End Of File >-------------------------------*/
