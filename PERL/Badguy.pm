package Badguy;
#package SOD::Badguy;

#use Exporter;
#@ISA    = ("Exporter");
#@EXPORT = qw(&draw_bad_guy);

use Moose;
use namespace::autoclean;
#use lib '/home/domcaf/Documents/GIT-DATA/SOD/PERL';
#use SOD::Utilities;
use lib '.';

#with 'SOD::GlobalConstants';
with 'GlobalConstants';

extends 'Sprites';

# * Description     : Stores constants associated with the description and **/
# *                   behavior of a bad guy.                               **/

#  What follows below are actually radii for the different body parts mentioned */
# Bad guy constants. Some of the values may seem reversed but it's because 
# Borland Graphics Interface primitives work diffrently than Tk's.

use constant {

    BAD_GUY_BODY_HEIGHT         => 0.005,     #  percentage */
    BAD_GUY_BODY_WIDTH          => 0.008,     #  percentage */
    BAD_GUY_EYE_ANGLE_1         => 30,       #  degrees */
    BAD_GUY_EYE_ANGLE_2         => 50,       #  degrees */
    BAD_GUY_EYE_ANGLE_3         => 130,      #  degrees */
    BAD_GUY_EYE_ANGLE_4         => 150,      #  degrees */
    BAD_GUY_EYE_LENGTH          => 0.02,     #  percentage */
    BAD_GUY_MAX_ANGLE_STEP      => 6,        #  This is in degrees */
    BAD_GUY_MOUTH_HEIGHT        => 0.001,    #  percentage */
    BAD_GUY_MOUTH_WIDTH         => 0.003,     #  percentage */
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
# * Function Name   : draw_bad_guy.                                         **/
# * Description     : Draws an image of a bad guy on the screen and stores  **/
# *                   it in a sprite that is passed to it from the calling  **/
# *                   routine.                                              **/
# * Inputs          : A pointer to a sprite.                                **/
# * Outputs         : returns 0 if successful and 1 if there was a problem. **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-5-1992. Ajusted for PERL/Tk November 2017**/
# ****************************************************************************/

sub draw_bad_guy {
    my $self    = shift;
    my $gdc     = shift;    # Game Display Canvas object = gdc.
	my $maxX = $gdc->cget(-width);
	my $maxY = $gdc->cget(-height);
    my $success = 0;

    #  put the bad guy on the screen */

	# Bad Guy Body Oval Box = BGBOB

    my $BGBOB_xStart = ( $maxX / $self->FIVE_VALUE );
    my $BGBOB_yStart = ( $maxY / $self->FIVE_VALUE );
    my $BGBOB_xEnd = ( BAD_GUY_BODY_WIDTH * $maxX );
    my $BGBOB_yEnd = ( BAD_GUY_BODY_HEIGHT * $maxY );

    $gdc->createOval(
        $BGBOB_xStart,
        $BGBOB_yStart,
        $BGBOB_xEnd,
        $BGBOB_yEnd,
        -fill    => 'yellow',
        -outline => 'magenta',
        -tags    => ['Badguy Body']
    );

	$self->log->debug('Bad Guy Body Oval box beginning and ending coordinates:');
	$self->log->debug('Ending coordinates should be concentric/within Start');
	$self->log->debug("Start:\t( $BGBOB_xStart, $BGBOB_yStart )");
	$self->log->debug("End:\t( $BGBOB_xEnd, $BGBOB_yEnd )");

    #setfillstyle( SOLID_FILL, RED );

	my ($startX, $startY, $endX, $endY);

        $startX = ( $maxX / $self->TWO_VALUE );
        $startY = ( $maxY / $self->TWO_VALUE );
        $endX = ( BAD_GUY_EYE_LENGTH * $maxX );
        $endY = ( BAD_GUY_EYE_LENGTH * $maxY );

	# Draw right eye
    $gdc->createArc(
        $startX,
		$startY,
        $endX,
		$endY,
		-fill => 'red',
		-start => BAD_GUY_EYE_ANGLE_1,
		-extent => ( BAD_GUY_EYE_ANGLE_2 - BAD_GUY_EYE_ANGLE_1),
        -style => 'pieslice',
		-outline => 'blue',
		-tags => ['Badguy Right Eye']
    );

	# Draw left eye
    $gdc->createArc(
        $startX,
		$startY,
        $endX,
		$endY,
		-fill => 'red',
		-start => BAD_GUY_EYE_ANGLE_3,
		-extent => ( BAD_GUY_EYE_ANGLE_4 - BAD_GUY_EYE_ANGLE_3),
        -style => 'pieslice',
		-outline => 'blue',
		-tags => ['Badguy Left Eye']
    );

	# Draw mouth

    $gdc->createOval(
        ( $maxX / $self->THREE_VALUE ),
        ( $maxY / $self->THREE_VALUE ),
        ( BAD_GUY_MOUTH_WIDTH * $maxX ),
        ( BAD_GUY_MOUTH_HEIGHT * $maxY ),
		-fill => 'blue',
		-outline => 'red',
		-tags => 'Badguy Mouth'
    );


#	#  set the bitmap extents */
#
#	$self->super->x = ($maxX / TWO_VALUE) - (BAD_GUY_BODY_WIDTH * $maxX);
#	$self->super->y = ($maxY / TWO_VALUE) - (BAD_GUY_EYE_LENGTH * $maxX);
#	$self->super->width = TWO_VALUE * BAD_GUY_BODY_WIDTH * $maxX;
#	$self->super->height = (BAD_GUY_EYE_LENGTH * $maxX) + (BAD_GUY_BODY_HEIGHT * $maxY);
#
#	#  allocate space for the bitmap. See Tk::Window?
#
#	$self->super->bitmap = (short unsigned int *) calloc(ONE_VALUE,($self->super->width * $self->super->height * sizeof(short unsigned int)));
#
#	if ($self->super->bitmap != NULL)
#	{
#		getimage($self->super->x,$self->super->y,($self->super->x + $self->super->width),($self->super->y + $self->super->height),(short unsigned int *) $self->super->bitmap);
#
#		#  erase image from screen now that it has been captured */
#		putimage($self->super->x,$self->super->y,(short unsigned int *) $self->super->bitmap,XOR_PUT);
#
#		$success = ZERO_VALUE;
#	}
#	else
#		$success = ONE_VALUE;

    return ($success);
} # End draw_bad_guy()

# *************************< End draw_bad_guy >***************************/




# package _badguy;

#no Moose;
#__PACKAGE__->meta->make_immutable;

#define BADGUY_H
#endif

1;

