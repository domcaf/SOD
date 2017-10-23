#!/usr/bin/env perl
#!/usr/bin/env perl -d:ptkdb


use constant LOG_FILE => '>/tmp/sod.log';
use Data::Dumper;
use Getopt::Long;
use Log::Log4perl qw(:easy);
use namespace::autoclean;
use Pod::Usage;
use SOD::Badguy;
use SOD::Bullet;
use SOD::Goodguy;
use SOD::Player;
use SOD::Sprites;
use SOD::Utilities;
use Tk;

$opt_help = 0;    # Default to not displaying help.

$Data::Dumper::Sortkeys = 1;

Log::Log4perl->easy_init( { level => $DEBUG, file => LOG_FILE } );

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

				Converted to use PERL/Tk during 4th Quater/2017.

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
my $gof = $mw->Frame(-label => 'Game Options', -background => 'black', -borderwidth => 1, -relief => 'raised')->pack(-side => 'right'); # Game Options Frame
my $qb = $gof->Button(-text => 'Quit', -command => sub { exit;} )->pack(-side => 'bottom'); # Quit button.

my $gcf = $mw->Frame(-label => 'Game Controls', -background => 'black', -borderwidth => 1, -relief => 'raised')->pack(-side => 'bottom'); # Game Controls Frame
my $rlb = $gcf->Button(-text => '< Rotate Left', -command => sub { exit;} )->pack(-side => 'left'); # Rotate left button.
my $fgb = $gcf->Button(-text => 'Fire * Gun', -command => sub { exit;} )->pack(-side => 'left'); # Fire button.
my $rrb = $gcf->Button(-text => 'Rotate Right >', -command => sub { exit;} )->pack(-side => 'left'); # Rotate right button.


my $gdc = $mw->Canvas(-background => 'black', -borderwidth => 1)->pack(-side => 'top', -fill => 'both'); # Game Display Canvas Widget

MainLoop; # Let's see what we got.
sleep(15); #sleep for 15 seconds be bailing.
exit(ONE_VALUE);

#  initialize the random # generator */
randomize();

#  make the game background color black */
setbkcolor(BLACK);

#  generate and capture bad guy & good guy images */
if ( draw_bad_guy(&bad_image) ) {
    print(
"\a\a\a\nMemory allocation problem in draw_bad_guy.\nProgram execution terminated."
    );
    exit(ONE_VALUE);
}

#  load initial conditions into good_guy & bad_guys i.e. build player list */

#  load the good guy into the list */

player_list = add_good();

if ( player_list == NULL ) {
    print(
"\a\a\a\nCouldn't create good guy to add to list.\nProgram execution terminated."
    );
    exit(ONE_VALUE);
}

#  display the good guy */
draw_good_guy( player_list, ZERO_VALUE );

#ifndef good_debug
#  load the bad guys into the list */
do {
    error_flag = add_player( player_list, bad, &bad_image, NULL );
    bad_guy_count++;
} while ( ( bad_guy_count < MAX_BAD_GUYS ) && ( !error_flag ) );

#endif

#  main processing loop - let the games begin ! */

while ( player_list != NULL ) {
    visit_player(player_list);

    player_list = player_list->next;
}

#  the game's over so free up the memory that was previously allocated */

player_list->prev->next = NULL;

while ( player_list != NULL ) {
    player_list = player_list->next;
    free( player_list->prev );
}

#  restore the pregame video environment */
restore_pre_game_environment();

return (ZERO_VALUE);    #  indicate normal program termination */

# -----------------------------< End Main >----------------------------------*/
# End of file.
