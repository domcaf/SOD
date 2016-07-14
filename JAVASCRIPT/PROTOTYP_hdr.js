
/*----------------------------< Start Of File >------------------------------*/

/*****************************< General Information >*************************/
/** Description     : This file contains the prototype definitions for all  **/
/**                   the functions for the game "Spirals Of Death".        **/
/** This File's Name: prototyp.h                                            **/
/** Programmer(s)   : Dominic Caffey.                                       **/
/** Notes & Comments: Created on 4/01/1992.                                 **/
/**                                                                         **/
/***************************< End General Information >***********************/

/*-----------------------------< Prototypes >--------------------------------*/

#ifndef prototyp_h

	/* prototypes for draw_pl.c */

		void draw_good_guy(players *, float new_angle);

		int  draw_bad_guy(sprites *);

	/* prototypes for setclean.c */

		int  setup_video_driver_and_mode(void);
		void restore_pre_game_environment(void);

	/* prototypes for polrcart.c */

		float polar_to_cartesian_coords(float, float, char);
		float cartesian_to_polar_coords(float, float, char);

	/* prototypes for add_good.c */

		players *add_good(void);

	/* prototypes for add_pl.c */

		int add_player(players *, enum player_type, sprites *, players *);

	/* prototypes for del_pl.c */

		void  delete_player(players *);

	/* prototypes for visit_pl.c */

		void  visit_player(players *);

	/* prototypes for move_pl.c */

		void  move_player(players *);

	/* prototypes for hit.c */

		int did_bad_good_guy_collide(players *);
		players *did_bullet_hit_something(players *);

	/* prototypes for spirhelp.c */
		void spirals_help(void);

/*---------------------------< End Prototypes >------------------------------*/

	#define prototyp_h

#endif

/*-----------------------------< End Of File >-------------------------------*/

