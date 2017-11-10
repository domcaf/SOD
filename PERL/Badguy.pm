package SOD::Badguy;

use Exporter;
@ISA    = ("Exporter");
@EXPORT = qw(&draw_bad_guy);

use Moose;
use namespace::autoclean;

extends 'Sprites';

# * Description     : Stores constants associated with the description and **/
# *                   behavior of a bad guy.                               **/

#  What follows below are actually radii for the different body parts mentioned */
# Bad guy constants

use constant {

    BAD_GUY_BODY_HEIGHT  => 0.01,    #  percentage */
    BAD_GUY_BODY_WIDTH   => 0.02,    #  percentage */
    BAD_GUY_EYE_ANGLE_1  => 30,      #  degrees */
    BAD_GUY_EYE_ANGLE_2  => 50,      #  degrees */
    BAD_GUY_EYE_ANGLE_3  => 130,     #  degrees */
    BAD_GUY_EYE_ANGLE_4  => 150      #  degrees */
      BAD_GUY_EYE_LENGTH => 0.02,    #  percentage */
    BAD_GUY_MAX_ANGLE_STEP      => 6,        #  This is in degrees */
    BAD_GUY_MOUTH_HEIGHT        => 0.006,    #  percentage */
    BAD_GUY_MOUTH_WIDTH         => 0.01,     #  percentage */
    SHOOTING_PROBABILITY_FACTOR => 101,

};

# This is a derived class of Sprites so the attribute below is unnecessary.
#has 'badguy' => (
#    isa => 'Object',    #  badguy inherits qualities of sprite
#    is  => 'ro'
#);

has 'radius' => (

    #  radial distance from screen center */
    isa => 'Int',
    is  => 'rw'
);

has 'angle_step' => (

    #  angle in radians */
    isa => 'Num',
    is  => 'ro'
);

has 'current_angle' => (

    #  current angular position in radians */
    isa => 'Num',
    is  => 'rw'
);

# METHODS

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

sub draw_bad_guy(Sprites super.bitmap)
{
	$success = 0;

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




# package _badguy;

no Moose;
__PACKAGE__->meta->make_immutable;

#define BADGUY_H
#endif

1;

