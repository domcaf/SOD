package Sprites;

# This is basically an abstract class meaning that it will be extended/derived
# by consuming classes but never instantiated directly by itself.

use lib '.';
use Moose;
use namespace::autoclean;

use constant { BULLET_RADIUS => 2 };

has 'bitmap' => ( is => 'rw', isa => 'Object' );

has 'x' => ( is => 'rw', isa => 'Num' );

has 'y' => ( is => 'rw', isa => 'Num' );

has 'width' => ( is => 'rw', isa => 'Num' );

has 'height' => ( is => 'rw', isa => 'Num' );

1;
