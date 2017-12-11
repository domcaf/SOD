#!/usr/bin/env perl

use constant FILE_LOC => '/tmp/Bad_guy.png';
use Data::Dumper;
use Tk;
use Tk::Photo;
use Tk::PNG;

$Data::Dumper::Sortkeys = 1;


my $mw = MainWindow->new;
warn "created mainwindow";


$mw->title("$0");


my $gdc =
  $mw->Canvas( -background => 'black', -borderwidth => 1, -confine => 1 )
  ->pack( -side => 'top', -fill => 'both', -expand => 1 )
  ; # Game Display Canvas Widget - We're limiting scrolling to scroll region established later on.
warn "created canvas";

my $badGuyImgObj = $gdc->Photo('BadGuy',
    -file    => FILE_LOC,
    -format  => 'PNG',
    -palette => '1/1/1'
);
warn "created image object of type photo";

warn(  "BadGuy image object is a \""
      . ref($badGuyImgObj)
      . "\" whose contents is:\n"
      . Dumper($badGuyImgObj)
      . "\n" );

#########################################################################
# NOTE: The name 'BadGuy' is what ties the $badGuyImgObj created above
#	to the image item on the canvas below depending on it's state.
#########################################################################

# $canvas->createImage(x, y, ?option, value, option, value, ...?)
$gdc->createImage(
    100, 100,
    -anchor        => 'center',
    -image         => 'BadGuy',
    -activeimage   => 'BadGuy',
    -disabledimage => 'BadGuy',
    -state         => 'normal'
);
warn "Created image item for canvas";

$mw->update();

my $mainWindowWidth    = $mw->width;
my $mainWindowHeight   = $mw->height;
my $mainWindowGeometry = $mw->geometry;

warn(  "\nMain Window Dimensions:\twidth = "
      . $mainWindowWidth
      . "\theight = "
      . $mainWindowHeight
      . "\ngeometry\t"
      . $mainWindowGeometry
      . "\n" );

MainLoop;    # This starts the graphics subsystem and causes UI to be displayed.

#exit 0;      #  indicate normal program termination */

1;
