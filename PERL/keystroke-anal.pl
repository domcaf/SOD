#!/usr/bin/env perl
#!/usr/bin/env perl -d


# The purpose of this script is to analyze keyboard/keystroke events
# under PERL/Tk.

# You don't want to use ptkdb when debugging other PERL/Tk programs
# because of problems with event handling per "Mastering PERL/Tk" book.
#!/usr/bin/env perl -d:ptkdb

# See GlobalConstants.pm for active definitions of few lines below.
# See GlobalsProxy.pm for how to access constants in GlobalConstants.

our $gpo;    # Globals Proxy Object for getting access to GlobalConstants.
our $lh;     # Global log handle for Log4PERL usage.

use lib '.'; # Needed for access/usage of sod packages/class definitions.

use Badguy
  ;  # Found using PERL5LIB environment variable or preceeding 'use lib' pragma.

#use Bullet; # Found using PERL5LIB environment variable or preceeding 'use lib' pragma.
use Data::Dumper;
use Getopt::Long;

#use GlobalConstants;
use GlobalsProxy;

use Goodguy;    # Found using preceeding 'use lib' pragma.

#use Log::Log4perl;
use Log::Log4perl qw(:easy);

#use namespace::autoclean;
#use Player; # Found using PERL5LIB environment variable or preceeding 'use lib' pragma.
use Pod::Usage;

#use Sprites; # Found using PERL5LIB environment variable or preceeding 'use lib' pragma.
use Tk;
use Tk::PNG;

#use Tk::Animation; # See sect 17.9 of "Mastering PERL/Tk".
#use Tk::WinPhoto; # See sect 17.7.3 of "Mastering PERL/Tk". For grabbing a bitmap off a canvas. BadGuy.
use Utilities;    # Found using preceeding 'use lib' pragma.

#$splash->Update(0.1);

# gpo = Globals Proxy Object for getting access to GlobalConstants.
$gpo = GlobalsProxy->new();

die "Cannot instatiate Globals Proxy Object. No point in continuing."
  unless ( defined($gpo) );

Log::Log4perl->easy_init()
  ;   # Doing anything other than this causes MooseX::Log::Log4perl to fail. :^(

#(
#    {
#        level => $INFO, # Using modifiers other than default doesn't work.
#        # file  => ">sod.log" # MooseX::Log::Log4perl doesn't handle files well.
#    }
#);

#Log::Log4perl->init_once( $gpo->LOG_CONFIG );
# lh = log handle for Log4PERL usage.
$lh = Log::Log4perl->get_logger("GlobalConstants");

my $opt_help = 0;    # Default to not displaying help.
$Data::Dumper::Sortkeys = 1;

our ( $canvasWidth, $canvasHeight );
$canvasWidth  = 0;
$canvasHeight = 0;

#Log::Log4perl->easy_init( { level => $DEBUG, file => LOG_FILE } );
#Log::Log4perl->easy_init( { level => $INFO, file => LOG_FILE } );

$lh->info("$0 commencing execution.");

# Description     : This is the main module for the game "Spirals Of Death
# Programmer(s)   : Dominic Caffey.
# Notes & Comments: Created on 3/31/1992. Converted to PERL beginning Oct/2017.

#sprites bad_image;
#players * player_list = NULL;
#int bad_guy_count = gpo;
#int error_flag;

#  set up the video environment */

my $mw = MainWindow->new;

#$mw->resizeable(1,1); # Booleans for X & Y axes.
$mw->FullScreen;    # This is desired when everything is working smoothly.

# Get the dimensions of the main window.

my @MainWindowConfig = $mw->configure();    # returns list of list refs
$lh->trace("mw = Main Window, configuration information as follows:");
$lh->trace( "\n" . Dumper( \@MainWindowConfig ) . "\n" );

my $mainWindowWidth    = $mw->width;
my $mainWindowHeight   = $mw->height;
my $mainWindowGeometry = $mw->geometry;

$lh->info( "\nMain Window Dimensions:\twidth = "
      . $mainWindowWidth
      . "\theight = "
      . $mainWindowHeight
      . "\ngeometry\t"
      . $mainWindowGeometry
      . "\n" );

#sleep(10); # Window starts out fullscreen then resizes; gives time to observe behaviour. Debugging.

if ( !defined($mw) ) {
    print(
"\a\a\a\nVideo driver or screen mode error - program execution terminated."
    );
    exit( $gpo->ONE_VALUE );
}

$mw->title("Keyboard and Keystroke Analysis - $0");

# Layout top widgets of game.
my $gof = $mw->Frame(
    -label       => 'Game Options',
    -background  => 'black',
    -borderwidth => 1,
    -relief      => 'raised'
)->pack( -side => 'right' );    # Game Options Frame

my $qb = $gof->Button( -text => 'Quit', -command => sub { exit; } )
  ->pack( -side => 'bottom' );    # Quit button.

my $gcf = $mw->Frame(
    -label       => 'Game Controls',
    -background  => 'black',
    -borderwidth => 1,
    -relief      => 'raised'
)->pack( -side => 'bottom' );     # Game Controls Frame

my $rlb = $gcf->Button( -text => '< Rotate Left', -command => sub { exit; } )
  ->pack( -side => 'left' );      # Rotate left button.

my $fgb = $gcf->Button( -text => 'Fire * Gun', -command => sub { exit; } )
  ->pack( -side => 'left' );      # Fire button.

my $rrb = $gcf->Button( -text => 'Rotate Right >', -command => sub { exit; } )
  ->pack( -side => 'left' );      # Rotate right button.

#####################################################################################

#my $gdc = $mw->Canvas( -background => 'black', -borderwidth => 1, -confine => 1, -setgrid => 1 ) # setgrid apparently not valid canvas option.
#my $gdc =
#  $mw->Canvas( -background => 'black', -borderwidth => 1, -confine => 1 )
#  ->pack( -side => 'top', -fill => 'both', -expand => 1 )
#  ; # Game Display Canvas Widget - We're limiting scrolling to scroll region established later on.

#####################################################################################

# Put a multiline textbox here in which to display keypress/keyboard event information.

my $tW = $mw->Text(
    -exportselection     => 1,
    -highlightbackground => 'red',
    -highlightcolor      => 'green'
)->pack( -side => 'top', -fill => 'both', -expand => 1 );

#$tW->insert( '1.0', "Keyboard and keypress event info displayed here." );
$tW->insert( 'end', "Keyboard and keypress event info displayed here." );

$mw->bind(
    '<KeyPress>' => sub {
        my ($widget) = @_;
        my $e = $widget->XEvent;    # get event object
        my ( $keysym_text, $keysym_decimal ) = ( $e->K, $e->N );
        print "KEYPRESS keysym=$keysym_text, numeric=$keysym_decimal\n";
        $lh->debug( Dumper( \$e ) );
        #$tW->insert( '1.0', Dumper( \$e ) );
        $tW->insert( 'end', ( "\n\nKEYPRESS " . Dumper( \$e ) ) );
    }
);

$mw->bind(
    '<KeyPress>' => sub {
        my ($widget) = @_;
        my $e = $widget->XEvent;    # get event object
        my ( $keysym_text, $keysym_decimal ) = ( $e->K, $e->N );
        print "KEYRELEASE keysym=$keysym_text, numeric=$keysym_decimal\n";
        $lh->debug( Dumper( \$e ) );
        #$tW->insert( '1.0', Dumper( \$e ) );
        $tW->insert( 'end', ( "\n\nKEYRELEASE " . Dumper( \$e ) ) );
    }
);

#####################################################################################

my $pb = $gof->Button( -text => 'Play', -command => &playGame )
  ->pack( -side => 'top' );       # Play button. This gets all the action going.

MainLoop;    # This starts the graphics subsystem and causes UI to be displayed.

#  restore the pregame video environment */
restore_pre_game_environment();

return ( $gpo->ZERO_VALUE );    #  indicate normal program termination */

# -----------------------------< End Main >----------------------------------*/

sub playGame {

    $lh->debug( 'Entered and leaving playGame subroutine.' );

    return 0;
}                               # sub playGame

# End of file.
