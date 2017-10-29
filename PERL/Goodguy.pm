package SOD::Goodguy;

use Exporter;
@ISA    = ("Exporter");
@EXPORT = qw(&draw_good_guy &add_good);

use Moose;
use namespace::autoclean;

# Good guy constants
use constant {

    GOOD_GUY_RADIUS      => 0.05,    #  This is specified as a percentage */
    GOOD_GUY_GUN_LENGTH  => 0.01,    #  This is specified as a percentage */
    GUN_WIDTH_HALF_ANGLE => 0.1      #  SPECIFIED IN RADIANS */

};
my ( $x, $y );                       #  center of good guy */
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

no Moose;
__PACKAGE__->meta->make_immutable;

#define GOODGUY_H
# End of file.

1;

