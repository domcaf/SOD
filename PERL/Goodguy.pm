package Goodguy;

use lib '.';
use Moose;
use namespace::autoclean;
use Data::Dumper;

with 'GlobalConstants', 'MooseX::Log::Log4perl', 'Utilities';
extends 'Sprites';

# Good guy constants
use constant {

    GOOD_GUY_BULLET_SPEED_FACTOR => 3,
    GOOD_GUY_GUN_LENGTH          => 0.01,     #  specified as percentage 
    GOOD_GUY_RADIUS              => 0.05,     #  specified as percentage 
    GOOD_GUY_ROTATION_INCREMENT  => 0.087,    #  5 degrees in radians 
    GUN_WIDTH_HALF_ANGLE         => 0.1,      #  specified in radians 
    MAX_GOOD_GUY_EVENTS =>
      1,    #  num of events processed per visit

};

# Coordinates of center of good guy are in superclass Sprites.
#my ( $x, $y );                       #  center of good guy */

my ($radius);                        #  radius of good_guy, excluding barrel */

my ($gun_length);                    #  length as a %age of screen dimensions */
my ($gun_color);

my ($gun_angle);    #  angle in radians where gun is pointing */
my ($gun_width_half_angle)
  ;                 #  half the angle width of the gun barrel in radians */

# goodguys;

# METHODS

#-----------------------------------------------------------------------------------

sub good_guy_post_constructor {

  # DESCRIPTION     : Moose manual strongly discourages overriding default free
  #					constructor so this method should be called AFTER constructor
  #					to set some values in the Sprites superclass. It should only
  #					be called once immediately after free constructor is called.
  # INPUTS          : A ref to Game Display Canvas.
  # OUTPUTS         : Int value. Zero, 0, means ok otherwise a problem occurred.

    my $self = shift;

    $self->log->debug('Entered good_guy_post_constructor method.');

    my $gdc = shift;    # Game Display Canvas object = gdc.

  #my $new_angle = shift; # Gun barrel adjustment angle for good guy in radians.

    my $maxX = $gdc->cget( -width );
    my $maxY = $gdc->cget( -height );

    $self->x( $maxX / $self->TWO_VALUE );
    $self->y( $maxY / $self->TWO_VALUE );

    # Because good guy is circular height and width are the same.
    $self->width( GOOD_GUY_RADIUS * ( ( $maxX + $maxY ) / 2 ) );
    $self->height( $self->width );

    my $success = $self->ZERO_VALUE;

    #my $background_color = $gdc->cget(-background);

    #setcolor($background_color);
    #$gdc->configure(-insertBackground => $background_color);

    $self->log->debug('Leaving good_guy_post_constructor method.');
    return ($success);
}

#-----------------------------------------------------------------------------------

sub draw_good_guy {
#void draw_good_guy(players *gg, float new_angle)

# DESCRIPTION     : Draws the good guy's gun turrent and gun barrel at    
#                   its current location plus or minus the adjustment     
#      				 angle that is passed to it.  Also makes the adjustment
#                   in the good guy's data structure as to what its       
#                   current gun angle is.                                 
# INPUTS          : A ref to Game Display Canvas and the gun barrel adjustment
#                   angle specified in radians.                           
# OUTPUTS         : The good guy's new gun angle via the parameter list.  

    my $self = shift;

    $self->log->debug( 'Entered draw_good_guy method.');

    my $gdc  = shift;    # Game Display Canvas object = gdc.
	my $new_angle = shift; # Gun barrel adjustment angle for good guy in radians.

    my $maxX    = $gdc->cget( -width );
    my $maxY    = $gdc->cget( -height );
    my $success = $self->ZERO_VALUE;

	my $background_color = $gdc->cget(-background);

	#setcolor($background_color);
	$gdc->configure(-insertBackground => $background_color);

	#  erase the gun barrel from its current location */
	#setfillstyle(SOLID_FILL,$background_color);

	$radius = GOOD_GUY_RADIUS * (($maxX + $maxY) / 2); # put in Sprites superclass?
	$gun_angle = $new_angle;

	my $x_barrel = $self->polar_to_cartesian_coords($radius,$gun_angle,'x') + $self->x;
	my $y_barrel = $self->polar_to_cartesian_coords($radius,$gun_angle,'y') + $self->y;

	# fillellipse(x_barrel,y_barrel,gg->pd.gg.gun_length,gg->pd.gg.gun_length);
	 $gdc->createOval($x_barrel,$y_barrel,gg->pd.gg.gun_length,gg->pd.gg.gun_length);

	#  redraw gun barrel at its new location */

	setfillstyle(SOLID_FILL,gg->pd.gg.gun_color);
	gg->pd.gg.gun_angle+= new_angle;

	x_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'x') + gg->pd.gg.x;
	y_barrel = (int) polar_to_cartesian_coords(gg->pd.gg.radius,gg->pd.gg.gun_angle,'y') + gg->pd.gg.y;

	fillellipse(x_barrel,y_barrel,gg->pd.gg.gun_length,gg->pd.gg.gun_length);

	#  redraw the gun turret body - maybe this should only be done when a hit is taken */
	fillellipse(gg->pd.gg.x,gg->pd.gg.y,gg->pd.gg.radius,gg->pd.gg.radius);

    $self->log->debug('Leaving draw_good_guy method.');

    return ($success);
	}

# ****************************< End draw_good_guy >***********************/


players * add_good(void);


1;
