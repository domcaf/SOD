package Goodguy;

# TODO: Keep in mind that Tk angles are specified in degrees while PERL trig functions expect radians.

use lib '.';
use Moose;
use namespace::autoclean;
use Data::Dumper;

#with 'GlobalConstants', 'MooseX::Log::Log4perl', 'Utilities';
with 'GlobalConstants', 'MooseX::Log::Log4perl';
extends 'Sprites';

#has 'gdc' => (is => 'rw', isa => 'Object'); # gdc = game display canvas. Using "our $gdc" instead; shorter to type in code.
has 'maxX' => ( is => 'rw', isa => 'Int', default => 0 )
  ;    # Maximum size of game display canvas in X dimension.
has 'maxY' => ( is => 'rw', isa => 'Int', default => 0 )
  ;    # Maximum size of game display canvas in Y dimension.

has 'color'     => ( is => 'rw', isa => 'Str', default => 'blue' );
has 'gun_angle' => ( is => 'rw', isa => 'Int', default => 0 )
  ;    # Degrees. Might it be more efficient to use Radians in future? #TODO
has 'GOOD_GUY_BULLET_SPEED_FACTOR' =>
  ( is => 'ro', isa => 'Int', default => 20 );

# ggbb = Good Guy Bounding Box
has 'ggbb' => ( is => 'rw', isa => 'HashRef' )
  ;    # Can be populated by calling Sprites->calculateBoundingBoxCoordinates().

# gbbo = Gun Bounding Box Offset.  This is how much bigger to make bounding box for drawing good guy's gun.
#     Because good guy is round, we'll use one constant for both x & y offsets to keep things simpler.
has 'gbbo' => ( is => 'rw', isa => 'Num' );

# Good guy constants
use constant {

    #GOOD_GUY_BULLET_SPEED_FACTOR => 3,
    GOOD_GUY_GUN_LENGTH => 0.03,    #  specified as percentage
    GOOD_GUY_RADIUS     => 0.08,    #  specified as percentage
    GOOD_GUY_ROTATION_INCREMENT =>
      5,    #  degrees; #TODO consider Radians for efficiency in future?
    GUN_WIDTH_HALF_ANGLE => 0.1,    #  specified in radians
    GUN_WIDTH_FULL_ANGLE => 5,      # specified in degrees
    MAX_GOOD_GUY_EVENTS  => 1,      #  num of events processed per visit

};

# Coordinates of center of good guy are in superclass Sprites.

#my ($radius);                        #  radius of good_guy, excluding barrel. Implies bounding box is square. See ggbb

#my ($gun_length);                    #  length as a %age of screen dimensions. Handled by ggbb & gbbo.

our $gdc
  ; # Used so we don't have to pass handle to "Game Display Canvas" all over the place. We set it once
    # in good_guy_post_constructor() and then we can use it in all class methods as needed.

our $bbc
  ; # Used to hold 'b'ounding 'b'ox 'c'oordinates for good guy body in global private instance variable.

# METHODS

#-----------------------------------------------------------------------------------

sub good_guy_post_constructor {

  # DESCRIPTION     : Moose manual strongly discourages overriding default free
  #					constructor so this method should be called AFTER constructor
  #					to set some values in the Sprites superclass. It should only
  #					be called once immediately after free constructor is called.
  # INPUTS          : A ref to Game Display Canvas.
  # OUTPUTS         : Int value. Zero, 0, means ok otherwise a problem occurred.

    #
## ****************************< Start add_good >*************************/
    #
## ****************************************************************************/
## * Function Name   : add_good.												   		 **/
## * Description     : Add a good guy  into the player list.                 **/
## * Inputs          : None.                                                 **/
## * Outputs         : Returns the addess of the player that was just added. **/
## * Programmer(s)   : Dominic Caffey.                                       **/
## * Notes & Comments: Created on 5/7/92.                                    **/
## *                                                                         **/
## *                                                                         **/
## ****************************************************************************/
    #
    #players *add_good(void)
    #{
    #	players *new_player;
    #
    #	new_player = (players *) calloc(ONE_VALUE,sizeof(players));
    #
    #	if(new_player != NULL)
    #	{
    #		#  initialize the good guy */
    #		#  center of good guy */
    #		new_player->pd.gg.x = getmaxx()/TWO_VALUE;
    #		new_player->pd.gg.y = getmaxy()/TWO_VALUE;
    #
    #		#  radius of good_guy, excluding barrel, as %age of screen dimensions */
    #		new_player->pd.gg.radius = getmaxx() * GOOD_GUY_RADIUS;
    #
    #		#  length as a %age of screen dimensions */
    #		new_player->pd.gg.gun_length = getmaxx() * GOOD_GUY_GUN_LENGTH;
    #		new_player->pd.gg.gun_color = GREEN;
    #
    #		#  angle in radians where gun is pointing */
    #		new_player->pd.gg.gun_angle = ZERO_VALUE;
    #
    #		#  half the angle width of the gun barrel in radians */
    #		new_player->pd.gg.gun_width_half_angle = GUN_WIDTH_HALF_ANGLE;
    #
    #		#  set the next & previous pointers */
    #		new_player->next = new_player;
    #
    #		new_player->prev = new_player;
    #	}
    #
    #	return(new_player);
    #}
## ****************************< End add_good >***************************/
    #

    my $self = shift;

    $self->log->debug('Entered good_guy_post_constructor method.');

    $gdc = shift;    # gdc is a class global scoped with "our".
                     #$self->gdc( $gdc );    # Game Display Canvas object = gdc.

#my $gun_direction = shift; # Gun barrel adjustment angle for good guy in radians.

    $self->maxX( $gdc->cget( -width ) );
    $self->maxY( $gdc->cget( -height ) );

    $self->x( $self->maxX / $self->TWO_VALUE );
    $self->y( $self->maxY / $self->TWO_VALUE );

    # Because good guy is circular, height and width are the same.
    $self->width( GOOD_GUY_RADIUS * ( ( $self->maxX + $self->maxY ) / 2 ) );
    $self->half_width( $self->width / 2 );

    $self->height( $self->width );
    $self->half_height( $self->height / 2 );

    $self->gbbo( GOOD_GUY_GUN_LENGTH * ( ( $self->maxX + $self->maxY ) / 2 ) );

    my $success = $self->ZERO_VALUE;

    #my $background_color = $gdc->cget(-background);

    #setcolor($background_color);
    #$gdc->configure(-insertBackground => $background_color);

    # Draw good guy's body.
    $bbc = $self->calculateBoundingBoxCoordinates();
    $self->ggbb($bbc);
    $gdc->createOval(
        $bbc->{ul_x}, $bbc->{ul_y}, $bbc->{lr_x}, $bbc->{lr_y},
        -fill    => 'green',
        -outline => 'green'
    );
    $self->color('green');

    $self->log->debug('Leaving good_guy_post_constructor method.');
    return ($success);
}    # good_guy_post_constructor()

#-----------------------------------------------------------------------------------

sub draw_good_guy {

    #void draw_good_guy(players *gg, float gun_direction)

  # DESCRIPTION     : Draws the good guy's gun turrent and gun barrel at
  #                   its current location plus or minus the adjustment
  #      				 angle that is passed to it.  Also makes the adjustment
  #                   in the good guy's data structure as to what its
  #                   current gun angle is.
  # INPUTS          : A ref to Game Display Canvas and the gun barrel adjustment
  #                   angle specified in degrees.
  # OUTPUTS         : The good guy's new gun angle via the parameter list.

    my $self = shift;

    $self->log->debug('Entered draw_good_guy method.');

#my $gdc = shift;    # Game Display Canvas object = gdc. Now in "our $gdc" as class/instance global.
    my $gun_direction =
      shift;    # Gun barrel adjustment angle for good guy in degrees.

    my $maxX = $gdc->cget( -width )
      ;         # Already doing this in good_guy_post_constructor method TODO
    my $maxY = $gdc->cget( -height )
      ;         # Already doing this in good_guy_post_constructor method TODO

    my $success = $self->ZERO_VALUE;

    my $background_color = $gdc->cget( -background )
      ;         # Already doing this in good_guy_post_constructor method

# erase the gun barrel from its current location -----------------------------------------------------------

    my $bbc =
      $self->ggbb;    # Get good guy's bounding box coordinates as a hashref.

    # OLD
    # TODO - consider replacing with new below
    #    $gdc->createArc(
    #        ( $bbc->{ul_x} - $self->gbbo ),
    #        ( $bbc->{ul_y} - $self->gbbo ),
    #        ( $bbc->{lr_x} + $self->gbbo ),
    #        ( $bbc->{lr_y} + $self->gbbo ),
    #	-start => $self->gun_angle,
    #	-extent => GUN_WIDTH_FULL_ANGLE,
    #	-fill => 'black',
    #	-outline => 'black',
    #	-style => 'pieslice'
    #    );

    # NEW
    $gdc->createArc(
        ( $self->ggbb->{ul_x} - $self->gbbo ),
        ( $self->ggbb->{ul_y} - $self->gbbo ),
        ( $self->ggbb->{lr_x} + $self->gbbo ),
        ( $self->ggbb->{lr_y} + $self->gbbo ),
        -start   => $self->gun_angle,
        -extent  => GUN_WIDTH_FULL_ANGLE,
        -fill    => 'black',
        -outline => 'black',
        -style   => 'pieslice'
    );

# It might be easiest to have a bounding box for the gun barrel slightly larger than the good guy
# body centered on the same point as the good guy body. Store the good guy body color in good guy
# object and use same color for drawing its gun barrel.

    #$gdc->createOval( $x_barrel, $y_barrel, $gun_length, $gun_length );

#  redraw gun barrel at its new location -----------------------------------------------------------

    #    setfillstyle( SOLID_FILL, gg->pd . gg . gun_color );
    #    gg->pd . gg . gun_angle += gun_direction;
    #
    #    x_barrel = polar_to_cartesian_coords( gg->pd . gg . radius,
    #        gg->pd . gg . gun_angle, 'x' ) + gg->pd
    #      . gg
    #      . x;
    #    y_barrel = polar_to_cartesian_coords( gg->pd . gg . radius,
    #        gg->pd . gg . gun_angle, 'y' ) + gg->pd
    #      . gg . y;
    #
    #	createArc(x_barrel,y_barrel,gg->pd.gg.gun_length,gg->pd.gg.gun_length);

    my $currentGunAngle = $self->gun_angle;

    if ( $gun_direction =~ /^(Left|a)$/ ) {
        $currentGunAngle +=
          GOOD_GUY_ROTATION_INCREMENT;    # left - counterclockwise
    }
    else {
        $currentGunAngle -= GOOD_GUY_ROTATION_INCREMENT;    # right - clockwise
    }

# Store new gun angle after doing modulus calculation to avoid crazy overflows
# where angle would become larger than 360 degrees after going full circle a few times.
    $self->gun_angle( $currentGunAngle % $self->FULL_CIRCLE_DEGREES );

    $gdc->createArc(
        ( $bbc->{ul_x} - $self->gbbo ),
        ( $bbc->{ul_y} - $self->gbbo ),
        ( $bbc->{lr_x} + $self->gbbo ),
        ( $bbc->{lr_y} + $self->gbbo ),
        -start   => $self->gun_angle,
        -extent  => GUN_WIDTH_FULL_ANGLE,
        -fill    => 'red',
        -outline => 'yellow',
        -style   => 'pieslice'
    );

# redraw the gun turret body or we'll end up with an empty one from redrawing gun barrel at its new angle.
    $gdc->createOval(
        $bbc->{ul_x}, $bbc->{ul_y}, $bbc->{lr_x}, $bbc->{lr_y},
        -fill    => $self->color,
        -outline => $self->color
    );

    $self->log->debug('Leaving draw_good_guy method.');

    return ($success);
}    # draw_good_guy()

# ****************************< End draw_good_guy >***********************/

#players * add_good(void);

1;
