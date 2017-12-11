#!/usr/bin/env perl

use constant FILE_LOC => '/tmp/Bad_guy.png';
use Data::Dumper;
use Tk;
use Tk::Photo;
use Tk::PNG;

$Data::Dumper::Sortkeys = 1;

#our($canvasWidth, $canvasHeight);
#$canvasWidth = 0;
#$canvasHeight = 0;

my $mw = MainWindow->new;
warn "created mainwindow";

#$mw->Resizeable(1,1); # Booleans for X & Y axes.
#$mw->FullScreen;    # This is desired when everything is working smoothly.

# Get the dimensions of the main window.

#my @MainWindowConfig = $mw->configure(); # returns list of list refs
#$lh->trace("mw = Main Window, configuration information as follows:");
#$lh->trace("\n" . Dumper(\@MainWindowConfig) . "\n");

$mw->title("$0");

# Layout top widgets of game.
#my $gof = $mw->Frame(
#    -label       => 'Game Options',
#    -background  => 'black',
#    -borderwidth => 1,
#    -relief      => 'raised'
#)->pack( -side => 'right' );    # Game Options Frame
#
#my $qb = $gof->Button( -text => 'Quit', -command => sub { exit; } )
#  ->pack( -side => 'bottom' );    # Quit button.
#

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

#$thingie->pack(-side => 'top', -fill => 'both', -expand => 1 );
#$thingie->update();

#$mw->update();
#print "Photo, \"\" "
#  . ( ( $thingie->visible ) ? 'visible' : 'NOT visible' ) . "\n";
#
##$thingie->read($self->BAD_GUY_PNG_LOC, -format => 'PNG');
#
#$Data::Dumper::Sortkeys = 1;
#print(  "BadGuy bitmap is a \""
#      . ref($thingie)
#      . "\" whose contents is:\n"
#      . Dumper($thingie)
#      . "\n" );

#--------------------------------------------------------------------------------------------------

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
