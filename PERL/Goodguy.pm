package Goodguy;
#package SOD::Goodguy;

#use Exporter;
#@ISA    = ("Exporter");
#@EXPORT = qw(&draw_good_guy &add_good);

use Moose;
use namespace::autoclean;

extends 'Sprites';


# Good guy constants
use constant {

    GOOD_GUY_BULLET_SPEED_FACTOR => 3,
    GOOD_GUY_GUN_LENGTH          => 0.01,     #  specified as percentage */
    GOOD_GUY_RADIUS              => 0.05,     #  specified as percentage */
    GOOD_GUY_ROTATION_INCREMENT  => 0.087,    #  5 degrees in radians */
    GUN_WIDTH_HALF_ANGLE         => 0.1,      #  specified in radians */
    MAX_GOOD_GUY_EVENTS =>
      1,    #  max # of events processed per visit to good guy */

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

#  prototypes for add_good.c */

void draw_good_guy( players *, float new_angle );

players * add_good(void);

#no Moose;
#__PACKAGE__->meta->make_immutable;

#define GOODGUY_H
# End of file.

1;

