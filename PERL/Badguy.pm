package Badguy;

use lib '.';
use Moose;
use namespace::autoclean;
use Data::Dumper;
use Tk::Photo;
use Tk::PNG;

use Utilities;  # Trig utilities for Polar <--> Cartesian coordinate conversion.

with 'GlobalConstants', 'MooseX::Log::Log4perl';
extends 'Sprites';

# What follows below are actually radii for the different body parts mentioned */
# Bad guy constants. Some of the values may seem reversed but it's because
# Borland Graphics Interface primitives work diffrently than Tk's.

use constant {

    BAD_GUY_BODY_HEIGHT         => 0.005,    #  percentage */
    BAD_GUY_BODY_WIDTH          => 0.008,    #  percentage */
    BAD_GUY_EYE_ANGLE_1         => 30,       #  degrees */
    BAD_GUY_EYE_ANGLE_2         => 50,       #  degrees */
    BAD_GUY_EYE_ANGLE_3         => 130,      #  degrees */
    BAD_GUY_EYE_ANGLE_4         => 150,      #  degrees */
    BAD_GUY_EYE_LENGTH          => 0.02,     #  percentage */
    BAD_GUY_MAX_ANGLE_STEP      => 6,        #  This is in degrees */
    BAD_GUY_MOUTH_HEIGHT        => 0.001,    #  percentage */
    BAD_GUY_MOUTH_WIDTH         => 0.003,    #  percentage */
    SHOOTING_PROBABILITY_FACTOR => 33,

};

has 'maxX' => ( is => 'rw', isa => 'Int', default => 0 )
  ;    # Maximum size of game display canvas in X dimension.
has 'maxY' => ( is => 'rw', isa => 'Int', default => 0 )
  ;    # Maximum size of game display canvas in Y dimension.

has 'radius' => (

    #  radial distance from screen center */
    isa => 'Num',
    is  => 'rw'
);

has 'angle_step' => (

#  Angle in degrees because most Tk APIs prefer degrees as opposed to radians. */
    isa     => 'Int',
    is      => 'rw',
    default => 1
);

has 'current_angle' => (

    #  current angular position in degrees */
    isa     => 'Num',
    is      => 'rw',
    default => 0
);

has 'tkTag' => (

# Label used to tie/associate image objects and image items together for badguy display.
# It's important to distinguish between "tags" and "ids" in Tk context. "Tags" can be
# arbitrarily chosen by programmer as long as their unique. "Ids" are returned from a
# Tk canvas call to create an object. i.e. $tkId = $canvas->createImage(...).

    isa => 'Str',
    is  => 'rw'
);

has 'tkId' => (

   # Used for storing the Tk Id returned from a canvas->createXXX() method call.
   # Attribute is typed as "Any" because we don't know if we're getting back a
   # string, number or a ref of some kind so "Any" is the safest choice.

    isa => 'Any',
    is  => 'rw'

);

our $gdc
  ; # This should be set in post constructor method so "Game Display Canvas" doesn't have to be passed all other the place.

our $screen_center_x;
our $screen_center_y;

# METHODS

sub bad_guy_post_constructor {

# DESCRIPTION     : Moose manual strongly discourages overriding default free
#                   constructor so this method should be called AFTER constructor
#                   to set some values in the Sprites superclass. It should only
#                   be called once immediately after free constructor is called.
# INPUTS          : A ref to Game Display Canvas.
# OUTPUTS         : Int value. Zero, 0, means ok otherwise a problem occurred.

    my $self = shift;

    $self->log->debug('Entered bad_guy_post_constructor method.');

    $gdc = shift;    # gdc is a class global scoped with "our".

    my $labelForId = shift;
    $self->tkTag($labelForId);

    $self->maxX( $gdc->cget( -width ) );
    $screen_center_x = $self->maxX / 2;

    $self->maxY( $gdc->cget( -height ) );
    $screen_center_y = $self->maxY / 2;

    my $success = $self->ZERO_VALUE;

#  set the bitmap extents - can only be done after image is loaded then query image obj
#       Try doing this in the draw_bad_guy() method.
#  $self->width(image->width);
#  $self->height(image->height);

#  Don't think you have to specify a bounding box when displaying an image/bitmap.

  #  randomly choose a step angle between 1 & BAD_GUY_MAX_ANGLE_STEP ( degrees )
    $self->angle_step( int( rand(BAD_GUY_MAX_ANGLE_STEP) ) + 1 );

    $self->current_angle( int( rand( $self->FULL_CIRCLE_DEGREES ) ) );

    $self->radius(
        int(
            ( ( $self->maxX > $self->maxY ) ? $self->maxY : $self->maxX ) /
              $self->TWO_VALUE
        )
    );

    $self->log->debug('Leaving bad_guy_post_constructor method.');
    return ($success);

}    # bad_guy_post_constructor()

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
    my $self = shift;

    $self->log->debug('Entered draw_bad_guy method.');

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
    my $BGBOB_xStart = ( $self->maxX / $self->THIRTY_VALUE );
    my $BGBOB_yStart = $m * $BGBOB_xStart + $b;

    my $BGMOB_xStart = $BGBOB_xStart + $self->TEN_VALUE;
    my $BGMOB_yStart = $m * $BGMOB_xStart + $b;

    my $BGMOB_xEnd = $BGMOB_xStart + $self->TEN_VALUE;
    my $BGMOB_yEnd = $m * $BGMOB_xEnd + $b;

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

    $self->log->debug(
        'Bad Guy Body Oval box beginning and ending coordinates:');
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

    $self->log->debug(
"\nBad Guy Mouth Oval box should be entirely within Bad Guy Body Oval Box.\n"
    );

    $self->log->debug(
        'Bad Guy Mouth Oval box beginning and ending coordinates:');
    $self->log->debug('Ending coordinates should be concentric/within Start');
    $self->log->debug("Start:\t( $BGMOB_xStart, $BGMOB_yStart )");
    $self->log->debug("End:\t( $BGMOB_xEnd, $BGMOB_yEnd )");

    #setfillstyle( SOLID_FILL, RED );

    # Draw bad guy eyes

    my ( $startX, $startY, $endX, $endY );

    $startX = $BGBOB_xStart;
    $startY = $BGMOB_yEnd - $self->TWENTY_VALUE;
    $endX   = $BGBOB_xEnd;
    $endY   = $BGMOB_yEnd + $self->TEN_VALUE;

    $self->log->debug( "Bad Guy Eyes Bounding Box coordinates:\n\t"
          . "($startX, $startY) and ($endX, $endY)" );

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
        -fill    => 'red',
        -start   => BAD_GUY_EYE_ANGLE_1,
        -extent  => ( BAD_GUY_EYE_ANGLE_2 - BAD_GUY_EYE_ANGLE_1 ),
        -style   => 'pieslice',
        -outline => 'green',
        -tags    => ['Badguy Right Eye']
    );

    # Draw left eye
    $gdc->createArc(
        $startX,
        $startY,
        $endX,
        $endY,
        -fill    => 'red',
        -start   => BAD_GUY_EYE_ANGLE_3,
        -extent  => ( BAD_GUY_EYE_ANGLE_4 - BAD_GUY_EYE_ANGLE_3 ),
        -style   => 'pieslice',
        -outline => 'green',
        -tags    => ['Badguy Left Eye']
    );

#	#  set the bitmap extents */
#
#	$self->super->x = ($self->maxX / TWO_VALUE) - (BAD_GUY_BODY_WIDTH * $self->maxX);
#	$self->super->y = ($self->maxY / TWO_VALUE) - (BAD_GUY_EYE_LENGTH * $self->maxX);
#	$self->super->width = TWO_VALUE * BAD_GUY_BODY_WIDTH * $self->maxX;
#	$self->super->height = (BAD_GUY_EYE_LENGTH * $self->maxX) + (BAD_GUY_BODY_HEIGHT * $self->maxY);
#
#	#  allocate space for the bitmap. See Tk::Window?
#	# # See sect 17.7.3 of "Mastering PERL/Tk" from grabbing a bitmap off a canvas.
#	# You may also need to work with a thumbnail per MPTk section: 17.7.4. Tk::Thumbnail
#	# See also:
#	#	http://search.cpan.org/~srezic/Tk-804.034/WinPhoto/WinPhoto.pm
#	#	http://search.cpan.org/~kryde/Image-Base-Tk-3/lib/Image/Base/Tk/Canvas.pm
#	#	http://www.perlmonks.org/?node_id=361299  # Has good Tk::Photo examples.
#	#	See also section 17.7 of MPTk, photo has several methods that may be useful.
#
#	$self->super->bitmap = (short unsigned int *) calloc(ONE_VALUE,($self->super->width * $self->super->height * sizeof(short unsigned int)));

# Get parent window of gdc canvas - it's passed in as param when this method is called.
#my $mw = $gdc->cget();
#$mw = $gdc->parent; # See Mastering-PERL-Tk-book_html-format/ch13_02.htm, "Parent of a Widget".

    $self->log->debug("Attempting to get bitmap image of BadGuy.");

# See article at http://www.perlmonks.org/?node_id=361299 especially the last comment that
# demonstrates a better way to get image with the canvas->postscript() method.
# See http://search.cpan.org/~srezic/Tk-804.034/pod/Canvas.pod for parameter explanation
# for canvas->postscript() call.

#$self->SUPER::bitmap = $gdc->postscript  # This gets an error and see https://metacpan.org/pod/distribution/Moose/lib/Moose/Manual/Attributes.pod#ATTRIBUTE-INHERITANCE
# regarding superclass attribute access.

    $gdc->postscript(
        -colormode => 'color',
        -file      => $self->BAD_GUY_PS_LOC
        , #file in which to write Postscript. If not specified method returns string of postscript.
        -height => $BGBOB_yEnd,
        -width  => $BGBOB_xEnd,
        -x      => $startX,
        -y      => $startY,
    );

#sleep(5); # Give a couple of moments to see what was put up on screen before erasing.
#-----------------------------------------------------------------------------------
# Clear the bad guy image previously generated on screen.
    $gdc->createRectangle( $startX, $startY, $BGBOB_xEnd, $BGBOB_yEnd,
        -fill => 'black' );

#sleep(5); # Give a couple of moments to see that erasure was successful.
#-----------------------------------------------------------------------------------

# So we can see what we're grabbing. See also if you don't want to make a system call:  http://search.cpan.org/~cjm/PostScript-Convert-0.03/lib/PostScript/Convert.pm

    my $convCmd =
      'convert ' . $self->BAD_GUY_PS_LOC . ' ' . $self->BAD_GUY_PNG_LOC;
    $self->log->debug(
        'Attempting to write image grabbed to a file with command: '
          . $convCmd );
    system("$convCmd");

  #=============================================================================

    $self->log->debug( 'Attempting to read png image grabbed from a file: '
          . $self->BAD_GUY_PNG_LOC );

    my $badGuyImgObj = $gdc->Photo(
        $self->tkTag,
        -file    => $self->BAD_GUY_PNG_LOC,
        -format  => 'PNG',
        -palette => '1/1/1'
    );
    $self->log->debug("created image object of type photo");

    # Store image object in Sprites superclass.
    # When trying to store in superclass an exception is thrown.
    $self->log->debug(
        "Attempting to store badGuyImgObj in Sprites base class.");
    $self->bitmap($badGuyImgObj);
    $self->log->debug(
        "Storage of badGuyImgObj in Sprites base class completed.");

    $Data::Dumper::Sortkeys = 1;
    $self->log->debug( "BadGuy image object is a \""
          . ref($badGuyImgObj)
          . "\" whose contents is:\n"
          . Dumper($badGuyImgObj)
          . "\n" );

#########################################################################
    # NOTE: The name $self->tkTag is what ties the $badGuyImgObj created above
    #	to the image item on the canvas below depending on it's state.
#########################################################################

    $self->tkId(
        $gdc->createImage(
            0, 0,
            -anchor        => 'nw',
            -image         => $self->tkTag,
            -activeimage   => $self->tkTag,
            -disabledimage => $self->tkTag,
            -state         => 'normal'
        )
    );

    $self->log->debug(
        "Created image item for canvas with id of \"" . $self->tkId . "\"" );

#sleep(5); # Give a couple of moments to see what was put up on screen before erasing.
#-----------------------------------------------------------------------------------
# Clear the bad guy image previously placed on screen.
# $gdc->createRectangle( 0, 0, $self->maxX, $self->maxY, -fill => 'black' );

#sleep(5); # Give a couple of moments to see that erasure was successful.
#-----------------------------------------------------------------------------------

#$self->super->bitmap->write( './badguy.png', -format => 'PNG' ); # Let's see what we're grabbing?

# After you are successfully capturing the image, see 9.6.3. The Image Item. It might help with
# subsequent display in different locations.

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

    $self->log->debug('Leaving draw_bad_guy method.');

    return ($success);
}    # End draw_bad_guy()

# *************************< End draw_bad_guy >***************************/

sub move_bad_guy {

    my $self = shift;

# Using an accessor method as if it were a variable doesn't work as well as isolating
# the call as in the example below.  The results vary depending on what you do.
    $self->log->debug( "Entered move_bad_guy method for tag: \""
          . $self->tkTag
          . "\"\tid: \""
          . $self->tkId
          . "\"." );

    $self->log_bad_guy_status();

    # Player type specific functionality has been moved into class methods
    # for specific player types.

    # The following may be useful for player movement in context of PERL/Tk:
    # http://search.cpan.org/~srezic/Tk-804.034/pod/Canvas.pod#TRANSFORMATIONS
    # See also the canvas->move() and canvas->coords() methods.

# Remember that the Tk canvas has methods move() and coords() that make moving things very easy.

#  Erase from old location. This may be unnecessary with move() or coords() methods.

# bar(mm->pd.bg.badguy.x,mm->pd.bg.badguy.y,(mm->pd.bg.badguy.x + mm->pd.bg.badguy.width),(mm->pd.bg.badguy.y + mm->pd.bg.badguy.height));

    #  update the current angle of the bad guy */
    $self->current_angle( $self->current_angle + $self->angle_step );

    #  calculate the new polar radius for the bad guy's new location */
    if ( $self->current_angle > $self->FULL_CIRCLE_DEGREES ) {
        $self->radius(
            (
                  ( $self->radius > $self->FIVE_VALUE )
                ? ( $self->radius - $self->FIVE_VALUE )
                : $self->THREE_VALUE
            )
        );

        $self->current_angle(
            $self->current_angle - $self->FULL_CIRCLE_DEGREES );
    }

    # REMINDER: PERL trig functions expect args in radians and Tk uses degrees.

    my $angleCurrentRadians = $self->current_angle * $self->RADS_PER_DEGREE;

#  Convert the polar angle into cartesian coordinates for the bad guy's new location */
#TODO: This should be refactored so only one call needs to be made to get the Cartesian coordinates.

    $self->x(
        Utilities::polar_to_cartesian_coords( $self->radius,
            $angleCurrentRadians, 'x' ) + $screen_center_x
    );

    $self->y(
        Utilities::polar_to_cartesian_coords( $self->radius,
            $angleCurrentRadians, 'y' ) + $screen_center_y
    );

    # Redisplay bad guy at its new position.
    #$gdc->coords( $self->tkTag, $self->x, $self->y ); # Didn't work.
    $gdc->coords( $self->tkId, $self->x, $self->y );

    # This already exists from draw_bad_guy(). Just put here as comment
    # as reminder of how it was created and persisted.
    #    my $badGuyImgObj = $gdc->Photo(
    #        'BadGuy', # TODO: Is this right or should it be parameterized?
    #        -file    => $self->BAD_GUY_PNG_LOC,
    #        -format  => 'PNG',
    #        -palette => '1/1/1'
    #    );
    #    $self->log->debug("created image object of type photo");
    #
    #    # Store image object in Sprites superclass.
    #    $self->log->debug(
    #        "Attempting to store badGuyImgObj in Sprites base class.");
    #    $self->bitmap($badGuyImgObj);
    #    $self->log->debug(
    #        "Storage of badGuyImgObj in Sprites base class completed.");
    #
    #    $Data::Dumper::Sortkeys = 1;
    #    $self->log->debug( "BadGuy image object is a \""
    #          . ref($badGuyImgObj)
    #          . "\" whose contents is:\n"
    #          . Dumper($badGuyImgObj)
    #          . "\n" );
    #
    #########################################################################
    # NOTE: The name 'BadGuy' is what ties the $badGuyImgObj created above
    #	to the image item on the canvas below depending on it's state.
    #########################################################################
    #
    #    $gdc->createImage(
    #        0, 0,
    #        -anchor        => 'nw',
    #        -image         => 'BadGuy',
    #        -activeimage   => 'BadGuy',
    #        -disabledimage => 'BadGuy',
    #        -state         => 'normal'
    #    );

    $self->log->debug("Moved bad guy from image object on canvas");

    $self->log_bad_guy_status();

    $self->log->debug( "Leaving move_bad_guy method for tag: \""
          . $self->tkTag
          . "\"\tid: \""
          . $self->tkId
          . "\"." );

}    # move_bad_guy()

sub log_bad_guy_status {

    my $self = shift;

# TODO: There's probably a way to do this with the instrospection capabilities of Moose; look into for future.

    $self->log->debug( "Bad Guy status for \""
          . $self->tkTag . "\":"
          . "\n\tangle_step    = \""
          . $self->angle_step . "\"."
          . "\n\tcurrent_angle = \""
          . $self->current_angle . "\"."
          . "\n\ttkTag      = \""
          . $self->tkTag . "\"."
          . "\n\tmaxX          = \""
          . $self->maxX . "\"."
          . "\n\tmaxY          = \""
          . $self->maxY . "\"."
          . "\n\tradius        = \""
          . $self->radius
          . "\"." );

    $self->log_sprite_status();

}    # log_bad_guy_status()

sub load_bad_guy_image {

    my $self = shift;

    $self->log->debug(
        "Entered load_bad_guy_image() for \"" . $self->tkTag . "\"." );

    $self->log->debug( 'Attempting to read png image grabbed from a file: '
          . $self->BAD_GUY_PNG_LOC );

    my $badGuyImgObj = $gdc->Photo(
        $self->tkTag,
        -file    => $self->BAD_GUY_PNG_LOC,
        -format  => 'PNG',
        -palette => '1/1/1'
    );
    $self->log->debug("created image object of type photo");

    # Store image object in Sprites superclass.
    $self->log->debug(
        "Attempting to store badGuyImgObj in Sprites base class.");
    $self->bitmap($badGuyImgObj);
    $self->log->debug(
        "Storage of badGuyImgObj in Sprites base class completed.");

    #    $Data::Dumper::Sortkeys = 1;
    #    $self->log->debug( "BadGuy image object is a \""
    #          . ref($badGuyImgObj)
    #          . "\" whose contents is:\n"
    #          . Dumper($badGuyImgObj)
    #          . "\n" );

#########################################################################
    # NOTE: The name $self->tkTag is what ties the $badGuyImgObj created above
    #	to the image item on the canvas below depending on it's state.
#########################################################################

    $self->tkId(
        $gdc->createImage(
            int( rand( int( $self->maxX / 2 ) ) ),    # X
            int( rand( int( $self->maxY / 2 ) ) ),    # Y
            -anchor        => 'nw',
            -image         => $self->tkTag,
            -activeimage   => $self->tkTag,
            -disabledimage => $self->tkTag,
            -state         => 'normal'
        )
    );

    $self->log->debug( "Created image item for canvas which returned id of \""
          . $self->tkId
          . "\"." );

    $self->log->debug(
        "Leaving load_bad_guy_image() for \"" . $self->tkTag . "\"." );

}    # load_bad_guy_image()

1;
