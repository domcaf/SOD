package SOD::Badguy;

use Exporter;
@ISA    = ("Exporter");
@EXPORT = qw(&draw_bad_guy);

use Moose;
use namespace::autoclean;

# * Description     : Stores constants associated with the description and **/
# *                   behavior of a bad guy.                               **/

#  What follows below are actually radii for the different body parts mentioned */
# Bad guy constants

use constant {

    BAD_GUY_BODY_HEIGHT  => 0.01,     #  percentage */
    BAD_GUY_BODY_WIDTH   => 0.02,     #  percentage */
    BAD_GUY_MOUTH_HEIGHT => 0.006,    #  percentage */
    BAD_GUY_MOUTH_WIDTH  => 0.01,     #  percentage */
    BAD_GUY_EYE_LENGTH   => 0.02,     #  percentage */
    BAD_GUY_EYE_ANGLE_1  => 30,       #  degrees */
    BAD_GUY_EYE_ANGLE_2  => 50,       #  degrees */
    BAD_GUY_EYE_ANGLE_3  => 130,      #  degrees */
    BAD_GUY_EYE_ANGLE_4  => 150       #  degrees */

};
sprites badguy;                       #  badguy inherits qualities of sprite */

int radius;                           #  radial distance from screen center */

float angle_step;                     #  angle in radians */
float current_angle;                  #  current angular position in radians */

# METHODS

## Please see file perltidy.ERR
sub draw_bad_guy { $sprites '*'; }

# package _badguy;

no Moose;
__PACKAGE__->meta->make_immutable;

#define BADGUY_H
#endif

1;

