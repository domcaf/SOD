package Sprites;

# This is basically an abstract class meaning that it will be extended/derived
# by consuming classes but never instantiated directly by itself.

use lib '.';
use Moose;
use namespace::autoclean;

use constant { BULLET_RADIUS => 2 };

has 'bitmap' => ( is => 'rw', isa => 'Object' );

# Because Tk graphics primitives generally rely on bounding boxes for drawing a lot of things, it might
# make more sense to store the bounding box coordinates of upper-left and lower-right points then the
# center of a graphic entity, and its width and height. On the other hand, the math will get a lot more
# complicated so it might be best to utility create a routine that calculates the bounding box points based on
# the center point coordinates and height & width info below.

has 'x' => ( is => 'rw', isa => 'Num' );

has 'y' => ( is => 'rw', isa => 'Num' );

has 'width' => ( is => 'rw', isa => 'Num' );

has 'height' => ( is => 'rw', isa => 'Num' );

1;
