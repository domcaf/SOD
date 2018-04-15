#!/usr/bin/env perl
#!/usr/bin/env perl -d

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

use Goodguy; # Found using preceeding 'use lib' pragma.
use Bullet;

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
use Utilities;  # Found using preceeding 'use lib' pragma.

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

=pod

=head1 S P I R A L S    O F    D E A T H

=head3 copyright 1992, 2017

No portion of this software package may be altered, distributed
or modified without the author's express written permission.

                               By

               Dominic Caffey a.k.a Thurlow Dominic Vigil Caffey
                    Advanced C Programming Class
                     Instructor:  David Conger
                       Spring Trimester 1992
                       TVI - Montoya Campus

				Converted to use PERL/Tk during 4th Quarter/2017.

=head2 Description

"Spirals of Death" is a game in which bad guys, who move in a
decaying spirals, shoot at the good guy who's located in the center
of the screen.  The good guy can rotate his gun and fire back.  The
user assumes the role of the good guy.  The object of the game is
to destroy all the bad guys before being destroyed.  The good guy
can take 3 hits before dying; he will change to a different color
each time he's hit in the following color progression:  Green ->
Yellow -> Red -> Background Color.  The game is over when the good
guy's color is the same as that of the game background.  The good
guy fires green bullets and the bad guys fire yellow bullets.

=head2 C O M M A N D    K E Y S

=over 4

=item * Key         | Function

=item * ------------+------------------------------

=item * "<-"        = Rotate gun counter clockwise.

=item * "->"        = Rotate gun clockwise.

=item * "space bar" = fire gun.

=item * "h" or "H"  = display this help screen.

=item * "p" or "P"  = pause the game.

=item * "q" or "Q"  = quit the game.

=back

=head2 Known Bugs:

=over 4

=item * Program does not free up memory correctly when it ends or is quit by the user thus causing the machine upon which it is run to periodically crash.

=item * Acknowledgement of successful kills by either the good guy or bad guys needs to be refined as it doesn't always work correctly.

=back

=head2 Future Features for possible implementation:

=over 4

=item * Use Moose object framework.

=item * Convert to use "P-threads".

=item * Create unit tests for code.

=item * Create functional tests for code.

=item * Store score history in an sqlite database.

=item * Display score statistics such as averages for: shots fired by good, time played, shots fired by bad, etc.

=item * Display graphs of statistics.

=item * Enable the ability to control the bad guys and allow user to chose whether to play as good guy or bad guys.

=item * Enable the ability to play with another game instance over a network within the same subnet. Use UDP sockets?

=item * Explore what can be done in 3D?

=back

=head4 Dominic Caffey, Author - "Spirals of Death".

=cut

GetOptions("help|?");

pod2usage(
    {
        -exitval => 0,
        -message => "$0 help requested.",
        -verbose => 2
    }
) if ($opt_help);

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

$mw->title("Spirals Of Death - $0");

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

#my $gdc = $mw->Canvas( -background => 'black', -borderwidth => 1, -confine => 1, -setgrid => 1 ) # setgrid apparently not valid canvas option.
my $gdc =
  $mw->Canvas( -background => 'black', -borderwidth => 1, -confine => 1 )
  ->pack( -side => 'top', -fill => 'both', -expand => 1 )
  ; # Game Display Canvas Widget - We're limiting scrolling to scroll region established later on.

my $serverInfo = $gdc->server;    # String is returned.
$lh->debug("Server info for canvas: \"$serverInfo\".");

#$splash->Update(0.5);

if (0) {

# Put a grid on the canvas, gdc, to help DEBUG scaling and placement issues. It can be commented out when things are working correctly.
    $gdc->createGrid( 0, 0, 10, 10, -fill => 'white' );
    $gdc->createGrid(
        0, 0, 50, 50,
        -lines => 1,
        -dash  => '-.',
        -fill  => 'white'
    );
    $gdc->createGrid(
        0, 0, 100, 100,
        -width => 3,
        -lines => 1,
        -fill  => 'white'
    );
    $lh->debug(
"Grid Info in pixels:\n\tDots every 10\n\tDashed lines every 50\n\tSolid lines every 100"
    );
}

my $pb = $gof->Button( -text => 'Play', -command => &playGame )
  ->pack( -side => 'top' );    # Play button. This gets all the action going.

# See the following for displaying a splashscreen: http://search.cpan.org/~srezic/Tk-Splash-0.16/lib/Tk/Splash.pm
#$splash->Update(1.0);
#sleep(5);
#$splash->Destroy();
    # Get the dimensions of the canvas used to to display game play display.
    # Use the configure method of the canvas object instead of cget so you can
    # get all configuration items for widget at one time.

    my @canvasConfig = $gdc->configure();    # returns list of list refs
    $lh->trace(
        "gdc = Game Display Canvas, configuration information as follows:");
    $lh->trace( "\n" . Dumper( \@canvasConfig ) . "\n" );

    $canvasWidth  = $gdc->cget( -width );
    $canvasHeight = $gdc->cget( -height );
    $lh->info( "\nGame Display Canvas Dimensions:\twidth = "
          . $canvasWidth
          . "\theight = "
          . $canvasHeight
          . "\n" );

    #  initialize the random # generator */
    #randomize();

    $lh->info('Attempting to draw bad guy bitmap with graphics primitives.');

    #sleep(5); #DEBUG

    my $Badguy = Badguy->new();
    $Badguy->bad_guy_post_constructor($gdc); # Do additional initialization.

    #  generate and capture bad guy image
    #if ( $Badguy->draw_bad_guy($gdc) ) { # Canvas object ref needed for drawing.
    if ( $Badguy->draw_bad_guy() ) { 
        $lh->fatal(
"\a\a\a\nSomething bad happened in draw_bad_guy.\nProgram execution terminated."
        );
        exit( $gpo->ONE_VALUE );
    }

	my $Goodguy = Goodguy->new();
	$Goodguy->good_guy_post_constructor($gdc); # Do additional initialization.

    #if ( $Goodguy->draw_good_guy($gdc, 'l') ) { # Canvas object ref needed for drawing; gun angle is in degrees.
    if ( $Goodguy->draw_good_guy('l') ) { # gun angle is in degrees.
        $lh->fatal(
"\a\a\a\nSomething bad happened in draw_good_guy.\nProgram execution terminated."
        );
        exit( $gpo->ONE_VALUE );
    }


#   #  load initial conditions into good_guy & bad_guys i.e. build player list */
#
#    #  load the good guy into the list */
#
#    player_list = add_good();
#
#    if ( player_list == NULL ) {
#        print(
#"\a\a\a\nCouldn't create good guy to add to list.\nProgram execution terminated."
#        );
#        exit($gpo->ONE_VALUE);
#    }
#
#    #  display the good guy */
#    draw_good_guy( player_list, $gpo->ZERO_VALUE );
#
#    #ifndef good_debug
#    #  load the bad guys into the list */
#    do {
#        error_flag = add_player( player_list, bad, &bad_image, NULL );
#        bad_guy_count++;
#    } while ( ( bad_guy_count < MAX_BAD_GUYS ) && ( !error_flag ) );
#
#    #endif
#

   # The following needs to be called after you get all players on the
   # canvas with the exception of bullets.  Bullets can leave the scrollable
   # area and we don't care about them once they leave the scrollable area.
   # Also note that for our purposes the scrollable area is basically static.
   # This is why we're setting the bounding region BEFORE any bullets get fired.
   # See section 9.3 of "Mastering Perl/Tk".

# line below causes window to shrink from maximized so be careful when you call it.
# Only call once you've got all graphical game elements on screen.

    if (0) {
        $gdc->configure( -scrollregion => [ $gdc->bbox("all") ] );
        $lh->debug(
'Canvas bounding box for all subwidgets is active. It causes maximized window to shrink.'
        );
    }
    else {
        $lh->debug(
'Canvas bounding box for all subwidgets currently disabled because it causes maximized window to shrink.'
        );
    }

# Build the player list and add players except for bullets.

# Add good guy to player list.

# Add bad guys to player list.

  #    #  main processing loop - let the games begin ! */
  #
  #    while ( player_list != NULL ) {
  #        visit_player(player_list);
  #
  #        player_list = player_list->next;
  #    }
  #

# Define event handler for keyboard events/commands; must be done AFTER game assets instantiated.

$mw->bind(
    '<KeyRelease>' => sub {
        my ($widget) = @_;
        my $e = $widget->XEvent;    # get event object
        my ( $keysym_text, $keysym_decimal ) = ( $e->K, $e->N );
        $lh->debug(
            "KEYRELEASE EVENT: keysym=$keysym_text, numeric=$keysym_decimal");

#$lh->debug( Dumper( \$e ) ); # Event object has some binary data that makes Dumping messy.

#$Goodguy->draw_good_guy($keysym_text) if($keysym_text =~ /^(Left|a|Right|d)$/);

        if ( $keysym_text =~ /^(Left|a|Right|d)$/ ) {
            $Goodguy->draw_good_guy($keysym_text);
        }
        elsif ( $keysym_text =~ /^(Space| |w)$/ ) {

            # Center of bullet when fired by the good guy; use center of Goodguy. */

            # new_player->pd.b.x = polar_to_cartesian_coords((float) (from->pd.gg.radius + from->pd.gg.gun_length + (TWO_VALUE * BULLET_RADIUS)),from->pd.gg.gun_angle,'x') + from->pd.gg.x;
            # new_player->pd.b.y = polar_to_cartesian_coords((float) (from->pd.gg.radius + from->pd.gg.gun_length + (TWO_VALUE * BULLET_RADIUS)),from->pd.gg.gun_angle,'y') + from->pd.gg.y;

            #  movement step increments for bullet when fired by the good guy */

		my $bulletGood = Bullet->new();
                $bulletGood->bullet_post_constructor($gdc,
			$Goodguy->x,
			$Goodguy->y,  
			(BULLET_RADIUS * cos($Goodguy->gun_angle) * $Goodguy->GOOD_GUY_BULLET_SPEED_FACTOR), # x_step
			(BULLET_RADIUS * sin($Goodguy->gun_angle) * $Goodguy->GOOD_GUY_BULLET_SPEED_FACTOR), # y_step
		);
        }
        else {
            ;    # Null statement until we can decide on suitable default.
        }

    }
);

MainLoop;    # This starts the graphics subsystem and causes UI to be displayed. EVENT HANDLING LOOP.

  #    #  the game's over so free up the memory that was previously allocated */
  #
  #    player_list->prev->next = NULL;
  #
  #    while ( player_list != NULL ) {
  #        player_list = player_list->next;
  #        free( player_list->prev );
  #    }

#  restore the pregame video environment */
restore_pre_game_environment();

exit ( $gpo->ZERO_VALUE );    #  indicate normal program termination */

# -----------------------------< End Main >----------------------------------*/

sub playGame {
    return 0;
}    # sub playGame

#sub BEGIN {
#
##	# Using ptkdb to debug Tk PERL code often doesn't work because of event handling
##	# issues between debugger and code being debugged.
##    $ENV{'DISPLAY'} = 'localhost:10.0'
##      ;    # Needed for use with PTKDB & SSH & X11 forwarding over SSH.
#
#    #require Tk::ProgressSplash;
#    #require Tk::Splash;
#    #our $splash = Tk::ProgressSplash->Show
##    our $splash = Tk::Splash->Show
##	(
##        -splashtype => 'normal',
##        '/tmp/Badguy.png',
##		UNDEF, # $width, can be left undefined.
##		UNDEF, # $height, can be left undefined.
##		'SOD: Spirals Of Death',
##        1 # $overrideredirect, set to true = 1 to display without window manager decoration.
##    );
#
#}    # sub BEGIN

# End of file.
