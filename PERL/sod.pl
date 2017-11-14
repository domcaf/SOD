#!/usr/bin/env perl
#!/usr/bin/env perl -d:ptkdb

use constant LOG_FILE => '>/tmp/sod.log';
use Data::Dumper;
use Getopt::Long;
use Log::Log4perl qw(:easy);
use namespace::autoclean;
use Pod::Usage;
use lib '/home/domcaf/Documents/GIT-DATA/SOD/PERL';

use Badguy; # Found using PERL5LIB environment variable or preceeding 'use lib' pragma.
#use Bullet; # Found using PERL5LIB environment variable or preceeding 'use lib' pragma.
#use Goodguy; # Found using PERL5LIB environment variable or preceeding 'use lib' pragma.
#use Player; # Found using PERL5LIB environment variable or preceeding 'use lib' pragma.
#use Sprites; # Found using PERL5LIB environment variable or preceeding 'use lib' pragma.
use Utilities; # Found using PERL5LIB environment variable or preceeding 'use lib' pragma.
use Tk;
use Tk::Animation; # See sect 17.9 of "Mastering PERL/Tk".
use Tk::WinPhoto; # See sect 17.7.3 of "Mastering PERL/Tk". For grabbing a bitmap off a canvas. BadGuy.

$opt_help = 0;    # Default to not displaying help.
$Data::Dumper::Sortkeys = 1;

our($canvasWidth, $canvasHeight);
$canvasWidth = 0;
$canvasHeight = 0;

Log::Log4perl->easy_init( { level => $INFO, file => LOG_FILE } );

ALWAYS("$0 commencing execution.");

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
#int bad_guy_count = ZERO_VALUE;
#int error_flag;

#  set up the video environment */

my $mw = MainWindow->new;

if ( !defined($mw) ) {
    print(
"\a\a\a\nVideo driver or screen mode error - program execution terminated."
    );
    exit(ONE_VALUE);
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

my $gdc = $mw->Canvas( -background => 'black', -borderwidth => 1 )
  ->pack( -side => 'top', -fill => 'both' );    # Game Display Canvas Widget

my $pb = $gof->Button( -text => 'Play', -command => &playGame )
  ->pack( -side => 'top' );    # Play button. This gets all the action going.

MainLoop;    # This starts the graphics subsystem and causes UI to be displayed.

#  restore the pregame video environment */
restore_pre_game_environment();

return (ZERO_VALUE);    #  indicate normal program termination */

# -----------------------------< End Main >----------------------------------*/

sub playGame {

# Get the dimensions of the canvas used to to display game play display.
# Use the configure method of the canvas object instead of cget so you can 
# get all configuration items for widget at one time.

my @canvasConfig = $gdc->configure(); # returns list of list refs
DEBUG "gdc = Game Display Canvas, configuration information as follows:";
DEBUG "\n" . Dumper(\@canvasConfig) . "\n";

$canvasWidth = $gdc->cget(-width);
$canvasHeight = $gdc->cget(-height);
INFO "\nGame Display Canvas Dimensions:\twidth = " . $canvasWidth . "\theight = " . $canvasHeight . "\n";

    #  initialize the random # generator */
    #randomize();

	my $Badguy = Badguy->new();
	my $bad_image;

    #  generate and capture bad guy & good guy images */
    if ( $Badguy->draw_bad_guy($gdc) ) { # Canvas object ref needed for drawing.
        ERROR(
"\a\a\a\nMemory allocation problem in draw_bad_guy.\nProgram execution terminated."
        );
        exit(ONE_VALUE);
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
#        exit(ONE_VALUE);
#    }
#
#    #  display the good guy */
#    draw_good_guy( player_list, ZERO_VALUE );
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
  $gdc->configure(-scrollregion => [ $gdc->bbox("all") ]);

#    #  main processing loop - let the games begin ! */
#
#    while ( player_list != NULL ) {
#        visit_player(player_list);
#
#        player_list = player_list->next;
#    }
#
#    #  the game's over so free up the memory that was previously allocated */
#
#    player_list->prev->next = NULL;
#
#    while ( player_list != NULL ) {
#        player_list = player_list->next;
#        free( player_list->prev );
#    }

	return 0;
}    # sub playGame

#sub BEGIN {
#    $ENV{'DISPLAY'} = 'localhost:10.0'
#      ;    # Needed for use with PTKDB & SSH & X11 forwarding over SSH.
#}    # sub BEGIN

# End of file.
