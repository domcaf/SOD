package Sprites;
#package SOD::Sprites;

use Exporter;
@ISA    = ("Exporter");
@EXPORT = qw( );

use Moose;
use namespace::autoclean;

# Player behaviour limits
use constant {
    BULLET_RADIUS => 2
};

has 'bitmap' => ( is => 'rw', isa => 'Object' );

has 'x' => ( is => 'rw', isa => 'Int' );

has 'y' => ( is => 'rw', isa => 'Int' );

has 'width' => ( is => 'rw', isa => 'Num' );

has 'height' => ( is => 'rw', isa => 'Num' );

no Moose;
__PACKAGE__->meta->make_immutable;

1;

