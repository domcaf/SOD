#!/usr/bin/env perl

package Sprites;

use lib '.';
use Moose;
use namespace::autoclean;

has 'bitmap' => ( is => 'rw', isa => 'Object' );

has 'attitude' => ( is => 'rw', isa => 'Str' );

1;

package Badguy;

use lib '.';
use Moose;
use namespace::autoclean;

extends 'Sprites';

has 'current_angle' => (
    isa => 'Num',
    is  => 'rw'
);

sub draw_bad_guy {
    my $self = shift;
    my $gdc  = shift;    # Game Display Canvas object = gdc.

    my $problem = 0;

    my $badGuyImgObj = 'This is normally a ref to a Tk image object.';

#    warn("Attempting to store badGuyImgObj in Sprites base class.");
#
#	# See https://metacpan.org/pod/distribution/Moose/lib/Moose/Manual/Attributes.pod#ATTRIBUTE-INHERITANCE
#
#    $@ = '';
#    eval { $self->bitmap(\$badGuyImgObj); };
#    if ( length($@) ) {
#        $problem++;
#        warn "$@";
#    }

    warn("Attempting to store attitude in Sprites base class.");
    $@ = '';
    #eval { $self->attitude = 'Mad'; };
    eval { $self->attitude('Mad'); };
    if ( length($@) ) {
        $problem++;
        warn "$@";
    }

	warn "This bad guy's attitude is \"" . $self->attitude . "\"";

    warn("Storage of badGuy attributes in Sprites base class completed.")
      unless ($problem);

    return ($problem);
}    # End draw_bad_guy()

1;

# ------------< main >-----------------------------

use lib '.';         # Needed for access/usage of packages/class definitions.
use Badguy;          # Found using preceeding 'use lib' pragma.
use Data::Dumper;    # For getting a look at object guts.
$Data::Dumper::Sortkeys = 1;    # Improve readability of dumps.

my $gdc =
"This is normally a reference to a Tk canvas but does not really matter in this test case context.";

my $BadDude = Badguy->new();

#  generate and capture bad guy image */
warn "\a\a\aProblem in draw_bad_guy."
  if ( $BadDude->draw_bad_guy( \$gdc ) );

warn "Dump of BadDude object:" . Dumper($BadDude);

print "\nExecution of $0 completed.\n\n";

# End main.
