package Sprites;

# This is basically an abstract class meaning that it will be extended/derived
# by consuming classes but never instantiated directly by itself.

use lib '.';
use Moose;
use namespace::autoclean;

#with 'GlobalConstants', 'MooseX::Log::Log4perl', 'Utilities';
with 'MooseX::Log::Log4perl';

has 'bitmap' => ( is => 'rw', isa => 'Object' );

# Because Tk graphics primitives generally rely on bounding boxes for drawing a lot of things, it might
# make more sense to store the bounding box coordinates of upper-left and lower-right points then the
# center of a graphic entity, and its width and height. On the other hand, the math will get a lot more
# complicated so it might be best to create a utility  routine that calculates the bounding box points based on
# the center point coordinates and height & width info below.

has 'x' => ( is => 'rw', isa => 'Num' );

has 'y' => ( is => 'rw', isa => 'Num' );

has 'width' => ( is => 'rw', isa => 'Num' );
has 'half_width' => ( is => 'rw', isa => 'Num' );

has 'height' => ( is => 'rw', isa => 'Num' );
has 'half_height' => ( is => 'rw', isa => 'Num' );

sub calculateBoundingBoxCoordinates {

# This subroutine/method calculates the bounding box coordinates so that a bitmap or graphics object can be drawn
# due to Tk's requirement that many graphics primitives require a bounding box to be specified to do things. This
# bounding box is specified using (x,y) coordinates for the points for the upper left and lower right corners of
# the bounding box. These calculations are based on the equation for a line i.e. y = mx + b.

# Also note that when calculating the new position of a sprite, one should update this object instance's x & y center
# point coordinates BEFORE calling this method.

# This method returns a reference to a hash containing the calculated bounding box coordinates.

    my $self = shift;

    $self->log->debug('Entered calculateBoundingBoxCoordinates method.');

    my $b = $self->y;

    my $m =
      ( $self->height == $self->width ) ? 1 : ( $self->height / $self->width );

    my %boundingBoxCoordinates = ();

    # ul = upper left of bounding box
    # lr = lower right of bounding box

    $boundingBoxCoordinates{ul_x} = $self->x - $self->half_width;
    $boundingBoxCoordinates{ul_y} = $self->y - $self->half_height;
    $boundingBoxCoordinates{lr_x} = $self->x + $self->half_width;
    $boundingBoxCoordinates{lr_y} = $self->y + $self->half_height;

    $self->log->debug('Leaving calculateBoundingBoxCoordinates method.');

    return ( \%boundingBoxCoordinates );

}    # calculateBoundingBoxCoordinates()

1;
