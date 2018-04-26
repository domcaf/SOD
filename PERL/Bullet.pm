package Bullet;

use lib '.';
use Moose;
use namespace::autoclean;
use Data::Dumper;

#use constant { BULLET_RADIUS => 0.02
#};    # percentage of average screen dimensions.
#with 'GlobalConstants', 'MooseX::Log::Log4perl', 'Utilities';

with 'GlobalConstants', 'MooseX::Log::Log4perl';
extends 'Sprites';

has 'BULLET_RADIUS' => (
    isa     => 'Num',
    is      => 'ro',
    default => 0.02
);

has 'color' => ( is => 'rw', isa => 'Str', default => 'blue' );

#bullets attributes/properties.

# x-coordinate of center of circular bullet; defined in super class Sprites.

# y-coordinate of center of circular bullet; defined in super class Sprites.

# Radius of bullet as %age of screen dimensions; if it's tiny then it can be a square bullet
# defined with width, half_width, height and half_height attributes defined in super
# class Sprites. See constant BULLET_RADIUS defined above.

#  movement increments */
has 'x_step' => (
    isa => 'Num',
    is  => 'rw'
);

#  movement increments */
has 'y_step' => (
    isa => 'Num',
    is  => 'rw'
);

# reference to player who shot bullet */
has 'from' => (
    isa => 'Object',    # This actually a reference to an object.
    is  => 'rw'
);

our $gdc
  ; # Used so we don't have to pass handle to "Game Display Canvas" all over the place. We set it once
    # in bullet_post_constructor() and then we can use it in all class/instance methods as needed.

# The following two class globals are for canvas dimensions.
our $maxX;
our $maxY;
our $background_color;

# methods go here

sub bullet_post_constructor {

# DESCRIPTION     : Moose manual strongly discourages overriding default free
#                                     constructor so this method should be called AFTER constructor
#                                     to set some values in the Sprites superclass. It should only
#                                     be called once immediately after free constructor is called.
# INPUTS          : - A ref to Game Display Canvas.
#                   - initial X coordinate of bullet.
#                   - initial Y coordinate of bullet.
#                   - X axis movement step.
#                   - Y axis movement step.
#                   - Who fired the bullet; a reference.
# OUTPUTS         : Int value. Zero, 0, means ok otherwise a problem occurred.

    my $self = shift;

    $Data::Dumper::Sortkeys = 1;

    $self->log->debug('Entered bullet_post_constructor method.');
    $self->log->debug(
        'Parameters received excluding self object: ' . Dumper( \@_ ) );

    $gdc = shift
      ; # You always want to do this if using shift instead of accessing @_ directly so you're always
        # getting correct params in intended vars.
        #if ( !defined($gdc) ); # gdc is a class/instance global scoped with "our".

    $self->x(shift);
    $self->y(shift);
    $self->x_step(shift);
    $self->y_step(shift);
    $self->from(shift);

    $self->log->debug(
            "Attribute values after being loaded from method parameter list:"
          . "\n\tx = "
          . $self->x
          . "\n\ty = "
          . $self->y
          . "\n\tx_step = "
          . $self->x_step
          . "\n\ty_step = "
          . $self->y_step
          . "\n\tfrom = "
          . Dumper( $self->from ) );

    # Might need these later for collision detection.
    #     $self->maxX( $gdc->cget( -width  ) );
    #     $self->maxY( $gdc->cget( -height ) );

    $maxX = $gdc->cget( -width )  if ( !defined($maxX) );
    $maxY = $gdc->cget( -height ) if ( !defined($maxY) );
    $background_color = $gdc->cget( -background )
      if ( !defined($background_color) )
      ;    # Do we really need this? Yes we do in move_bullet() method.

    # Because bullet is circular, height and width are the same.
    $self->width( $self->BULLET_RADIUS *
          ( ( $gdc->cget( -width ) + $gdc->cget( -height ) ) / 2 ) );
    $self->half_width( $self->width / 2 );

    $self->height( $self->width );
    $self->half_height( $self->height / 2 );

    #$self->gbbo(GOOD_GUY_GUN_LENGTH * ( ( $self->maxX + $self->maxY ) / 2 ));

    my $success = $self->ZERO_VALUE;

    #setcolor($background_color);
    #$gdc->configure(-insertBackground => $background_color);

    # Draw bullet

    my $bbc = $self->calculateBoundingBoxCoordinates();

    $gdc->createOval(
        $bbc->{ul_x},
        $bbc->{ul_y},
        $bbc->{lr_x},
        $bbc->{lr_y},
        -fill => (
            (
                  ( ref( $self->from ) eq 'Goodguy' ) ? 'orange'
                : ( ref( $self->from ) eq 'Badguy' )  ? 'red'
                :                                       'blue'
            )
        ),
        -outline => (
            (
                  ( ref( $self->from ) eq 'Goodguy' ) ? 'orange'
                : ( ref( $self->from ) eq 'Badguy' )  ? 'red'
                :                                       'blue'
            )
        )
    );

    $self->log->debug(
        "\tShooter is a \"" . ref( $self->from ) . "\" object." );
    $self->log->debug('Leaving bullet_post_constructor method.');
    return ($success);

}    # bullet_post_constructor()

#sub draw_bullet {
#
## DESCRIPTION: Draws a bullet at an (x,y) location.
## INPUTS     : A ref to Game Display Canvas and the new (x,y) location at which to draw bullet.
## OUTPUTS    : None.
#
#    my $self = shift;
#
#    $self->log->debug('Entered draw_bullet method.');
#
# #my $gdc = shift;    # Game Display Canvas object = gdc.
# #    my $gun_direction =
# #      shift;            # Gun barrel adjustment angle for good guy in degrees.
#
#    #    my $maxX    = $gdc->cget( -width );
#    #    my $maxY    = $gdc->cget( -height );
#    my $success = $self->ZERO_VALUE;
#
#    # my $background_color = $gdc->cget( -background );
#
#    # you might find a lot of the code for this inside player.pm in add_player.
#
##			case bullet:
##				if ((from->pt == good) || (from->pt == bad))
##				{
##					new_player->pd.b.radius = BULLET_RADIUS;
##
##					#  figure out where the bullet came from */
##					new_player->pd.b.from = from;
##
##					if (from->pt == good)
##					{
##						#  center of bullet when fired by the good guy */
##						new_player->pd.b.x = polar_to_cartesian_coords((float) (from->pd.gg.radius + from->pd.gg.gun_length + (TWO_VALUE * BULLET_RADIUS)),from->pd.gg.gun_angle,'x') + from->pd.gg.x;
##						new_player->pd.b.y = polar_to_cartesian_coords((float) (from->pd.gg.radius + from->pd.gg.gun_length + (TWO_VALUE * BULLET_RADIUS)),from->pd.gg.gun_angle,'y') + from->pd.gg.y;
##
##
##						#  movement step increments for bullet when fired by the good guy */
##						new_player->pd.b.x_step = BULLET_RADIUS * cos(from->pd.gg.gun_angle) * GOOD_GUY_BULLET_SPEED_FACTOR;
##						new_player->pd.b.y_step = BULLET_RADIUS * sin(from->pd.gg.gun_angle) * GOOD_GUY_BULLET_SPEED_FACTOR;
##					}
##					else
##					{
##						#  center of bullet when fired by a bad guy */
##						new_player->pd.b.x = from->pd.bg.badguy.x;
##						new_player->pd.b.y = from->pd.bg.badguy.y;
##
##
##						#  movement step increments for bullet when fired by a bad guy */
##						new_player->pd.b.x_step = -BULLET_RADIUS * cos(from->pd.bg.current_angle);
##						new_player->pd.b.y_step = -BULLET_RADIUS * sin(from->pd.bg.current_angle);
##					}
##				}
##				else
##				{
##						success = ONE_VALUE;
##						free(new_player);
##				}
##				break;
#
#    $self->log->debug('Exited draw_bullet method.');
#
#}    # sub draw_bullet

# ****************************< Start did_bullet_hit_something >********/

# ****************************************************************************/
# * Function Name   : did_bullet_hit_something.                        **/
# * Description     : This function determines if a bullet hit something.   **/
# *                   If it hit something it identifies what it hit and     **/
# *                   returns a pointer to the hit object otherwise it      **/
# *                   returns a value of NULL.                              **/
# * Inputs          : A pointer to the bullet being tested for a hit.       **/
# * Outputs         : A pointer to hit object or NULL if no hit.            **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-30-92.                                   **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

#players *did_bullet_hit_something(players *bullet)
#{
#	players *target = NULL;
#	float look_ahead_x, look_ahead_y, look_ahead_dist_to_screen_center, distance_between_bullets;
#	static int background_color;
#	static int screen_center_x, screen_center_y;
#	int target_found = ZERO_VALUE;
#
#	background_color = getbkcolor();
#	screen_center_x = (int) (getmaxx()/TWO_VALUE);
#	screen_center_y = (int) (getmaxy()/TWO_VALUE);
#
#
#	#  calculate look ahead coordinates */
#	look_ahead_x = bullet->pd.b.x + (TWO_VALUE * bullet->pd.b.x_step);
#	look_ahead_y = bullet->pd.b.y + (TWO_VALUE * bullet->pd.b.y_step);
#
#	#  determine if the bullet actually hit something */
#	if(getpixel((int) look_ahead_x,(int) look_ahead_y) != background_color)
#	{
#		#  the bullet hit something, find out what it hit */
#		target = bullet->next; #  set starting point for search */
#
#		while((target != bullet) && (!target_found))  #  traverse the player list */
#		{
#			if(target != bullet->pd.b.from) #  a player can't shoot itself */
#
#				if(target->pt == good)
#				{
#					look_ahead_dist_to_screen_center = sqrt(pow((look_ahead_x - screen_center_x),TWO_VALUE) + pow((look_ahead_y - screen_center_y),TWO_VALUE));
#
#					if(look_ahead_dist_to_screen_center <= target->pd.gg.radius)
#						target_found = ONE_VALUE;
#				}
#				else if(target->pt == bad)
#				{
#					if((look_ahead_x >= target->pd.bg.badguy.x) &&
#						(look_ahead_x <= (target->pd.bg.badguy.x + target->pd.bg.badguy.width)) &&
#						(look_ahead_y >= target->pd.bg.badguy.y) &&
#						(look_ahead_y <= (target->pd.bg.badguy.y + target->pd.bg.badguy.height)))
#							target_found = ONE_VALUE;
#				}
#				else #  the player type is another bullet */
#				{
#				  #  if the distance between their two centers is less than (2 * r) then they hit each other */
#					distance_between_bullets = sqrt(pow((look_ahead_x - target->pd.b.x),TWO_VALUE) + pow((look_ahead_y - target->pd.b.y),TWO_VALUE));
#
#					if(distance_between_bullets <= (2 * bullet->pd.b.radius))
#						target_found = ONE_VALUE;
#				}
#
#			if(!target_found)
#				target = target->next;
#
#		}
#	}
#
#	return(target);
#}
#
# ****************************< End did_bullet_hit_something >***********/

sub move_bullet {
    my $self = shift;
    $self->log->debug('Entering move_bullet method.');

    # Keep in mind that bullets will move in a linear fashion according to
    # equation, y = mx + b.

    # The following may be useful for player movement in context of PERL/Tk:
    # http://search.cpan.org/~srezic/Tk-804.034/pod/Canvas.pod#TRANSFORMATIONS

#	players *player_who_shot_bullet;
#
#	static float reference_radius;
#	static float reference_angle;
#
#	static int screen_max_x;
#	static int screen_max_y;
#	static int two_pi_rads = TWO_VALUE * PI;
#	static int screen_center_x;
#	static int screen_center_y;
#
#	screen_max_x = getmaxx();
#	screen_max_y = getmaxy();
#
#	screen_center_x = (int) screen_max_x / TWO_VALUE;
#	screen_center_y = (int) screen_max_y / TWO_VALUE;
#
#
#	reference_radius = sqrt(pow((getmaxx()/TWO_VALUE),TWO_VALUE) + pow((getmaxy()/TWO_VALUE),TWO_VALUE));
#	reference_angle = atan(getmaxy()/getmaxx());
#
#	setfillstyle(SOLID_FILL,getbkcolor());

    # The following may be useful for player movement in context of PERL/Tk:
    # http://search.cpan.org/~srezic/Tk-804.034/pod/Canvas.pod#TRANSFORMATIONS

#	else if(mm->pt == bullet)
#	{
#		#  erase mm from its old location */
#		fillellipse((int) mm->pd.b.x,(int) mm->pd.b.y,mm->pd.b.radius,mm->pd.b.radius);
#
#		#  setup mm's new position */
#		mm->pd.b.x += mm->pd.b.x_step;
#		mm->pd.b.y += mm->pd.b.y_step;
#
#		if((mm->pd.b.x <= screen_max_x) && (mm->pd.b.x >= ZERO_VALUE) && (mm->pd.b.y <= screen_max_y) && (mm->pd.b.y >= ZERO_VALUE))
#		{
#			#  identify the type of player who shot the bullet */
#			player_who_shot_bullet = (players *) mm->pd.b.from;  #  this is necessary because "from" is a void pointer */
#
#			#  redisplay mm at its new position  - choose appropriate bullet color */
#			setfillstyle(SOLID_FILL,(player_who_shot_bullet->pt == good) ? GREEN : YELLOW);
#
#			fillellipse((int) mm->pd.b.x,(int) mm->pd.b.y,mm->pd.b.radius,mm->pd.b.radius);
#		}
#		else
#			delete_player(mm);
#
#	}

# Erase bullet from its current location.
#my $background_color = $gdc->cget( -background ); # Should already be defined because of bullet_post_constructor().

    my $bbc = $self->calculateBoundingBoxCoordinates();

    $gdc->createOval(
        $bbc->{ul_x},
        $bbc->{ul_y},
        $bbc->{lr_x},
        $bbc->{lr_y},
        -fill    => $background_color,
        -outline => $background_color
    );

    # Redraw bullet in its new location.

    # Calculate new bullet center.

    $self->x( $self->x + $self->x_step );
    $self->y( $self->y + $self->y_step );

    $bbc = $self->calculateBoundingBoxCoordinates();

    $gdc->createOval(
        $bbc->{ul_x},
        $bbc->{ul_y},
        $bbc->{lr_x},
        $bbc->{lr_y},
        -fill => (
            (
                  ( ref( $self->from ) eq 'Goodguy' ) ? 'orange'
                : ( ref( $self->from ) eq 'Badguy' )  ? 'red'
                :                                       'blue'
            )
        ),
        -outline => (
            (
                  ( ref( $self->from ) eq 'Goodguy' ) ? 'orange'
                : ( ref( $self->from ) eq 'Badguy' )  ? 'red'
                :                                       'blue'
            )
        )
    );

    $self->log->debug('Leaving move_bullet method.');
}    # move_bullet()

1;

# End of file.
