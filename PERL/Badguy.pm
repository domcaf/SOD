package Badguy;

use Moose;
use namespace::autoclean;
#use Log::Log4perl;
use lib '.';
#use Utilities;

with 'GlobalConstants', 'MooseX::Log::Log4perl';
#with 'GlobalConstants', 'Log';

extends 'Sprites';

# lh = log handle for Log4PERL usage.
our $lh;

#BEGIN {
#    #Log::Log4perl->init_once( $self->LOG_CONFIG ); # This line may be unnecessary.
#
#    # lh = log handle for Log4PERL usage.
#    $lh = Log::Log4perl->get_logger("GlobalConstants");
#}


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
	# Because PERL/Tk works so much differently from BGI, calculating the bounding
	# box coordinates will be easiest by making sure they all are on the same
	# line represented by equation, y = mx + b. Start with upper left and work
	# your way down to lower right. Using a constant scaling factor will make it
	# easier to do point calculations.

	# Bad Guy Body Oval Box = BGBOB
	# Bad Guy Mouth Oval Box = BGMOB

	# per standard line equation, y = mx + b
	# m = slope
	my $m = 0.45;
	# b = y offset
	my $b = $self->TWENTY_VALUE;


# New calculations used with PERL/Tk
    my $BGBOB_xStart = ( $maxX / $self->THIRTY_VALUE );
    my $BGBOB_yStart = $m * $BGBOB_xStart + $b;

	my $BGMOB_xStart = $BGBOB_xStart + $self->TEN_VALUE;
	my $BGMOB_yStart = $m * $BGMOB_xStart + $b;
	
	my $BGMOB_xEnd   = $BGMOB_xStart + $self->TEN_VALUE;
	my $BGMOB_yEnd   = $m * $BGMOB_xEnd + $b;

    my $BGBOB_xEnd = $BGMOB_xEnd + $self->TEN_VALUE;
    my $BGBOB_yEnd = $m * $BGBOB_xEnd + $b;

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

	# Draw mouth

    $gdc->createOval(
        $BGMOB_xStart,
        $BGMOB_yStart,
        $BGMOB_xEnd,
        $BGMOB_yEnd,
        -fill    => 'blue',
        -outline => 'red',
        -tags    => 'Badguy Mouth'
    );

	$self->log->debug("\nBad Guy Mouth Oval box should be entirely within Bad Guy Body Oval Box.\n");

	$self->log->debug('Bad Guy Mouth Oval box beginning and ending coordinates:');
	$self->log->debug('Ending coordinates should be concentric/within Start');
	$self->log->debug("Start:\t( $BGMOB_xStart, $BGMOB_yStart )");
	$self->log->debug("End:\t( $BGMOB_xEnd, $BGMOB_yEnd )");

    #setfillstyle( SOLID_FILL, RED );

# Draw bad guy eyes

	my ($startX, $startY, $endX, $endY);

#        $startX = ( $maxX / $self->TWO_VALUE );
#        $startY = ( $maxY / $self->TWO_VALUE );
#        $endX = ( BAD_GUY_EYE_LENGTH * $maxX );
#        $endY = ( BAD_GUY_EYE_LENGTH * $maxY );

        $startX = $BGBOB_xStart;
        $startY = $BGMOB_yEnd - $self->TWENTY_VALUE;
        $endX = $BGBOB_xEnd;
        $endY = $BGMOB_yEnd + $self->TEN_VALUE;

	$self->log->debug("Bad Guy Eyes Bounding Box coordinates:\n\t" .
		"($startX, $startY) and ($endX, $endY)");

	# The rectangle below is just for visualizing the bounding box for the eyes.
	# It's not part of the Bad Guy; it's for debugging.

    if (0) {
        $gdc->createRectangle( $startX, $startY, $endX,
            $endY, -fill => 'green' );
    }

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
		-outline => 'green',
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
		-outline => 'green',
		-tags => ['Badguy Left Eye']
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

