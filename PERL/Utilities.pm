package SOD::Utilities;

use Math::Complex;
use Moose;
use namespace::autoclean;

# Keyboard constants
use constant {

    F1  => 59,
    F2  => 60,
    F3  => 61,
    F4  => 62,
    F5  => 63,
    F6  => 64,
    F7  => 65,
    F8  => 66,
    F9  => 67,
    F10 => 68,
    F11 => 133,
    F12 => 134,

    SHIFT_F1  => 84,
    SHIFT_F2  => 85,
    SHIFT_F3  => 86,
    SHIFT_F4  => 87,
    SHIFT_F5  => 88,
    SHIFT_F6  => 89,
    SHIFT_F7  => 90,
    SHIFT_F8  => 91,
    SHIFT_F9  => 92,
    SHIFT_F10 => 93,
    SHIFT_F11 => 135,
    SHIFT_F12 => 136,

    CTRL_F1  => 94,
    CTRL_F2  => 95,
    CTRL_F3  => 96,
    CTRL_F4  => 97,
    CTRL_F5  => 98,
    CTRL_F6  => 99,
    CTRL_F7  => 100,
    CTRL_F8  => 101,
    CTRL_F9  => 102,
    CTRL_F10 => 103,
    CTRL_F11 => 137,
    CTRL_F12 => 138,

    ALT_F1  => 104,
    ALT_F2  => 105,
    ALT_F3  => 106,
    ALT_F4  => 107,
    ALT_F5  => 108,
    ALT_F6  => 109,
    ALT_F7  => 110,
    ALT_F8  => 111,
    ALT_F9  => 112,
    ALT_F10 => 113,
    ALT_F11 => 139,
    ALT_F12 => 140,

    UP_ARROW    => 72,
    DOWN_ARROW  => 80,
    LEFT_ARROW  => 75,
    RIGHT_ARROW => 77,

    CTRL_W => 23,
    CTRL_Z => 26,

    HOME_KEY => 71,
    END_KEY  => 79,

    PGUP_KEY => 73,
    PGDN_KEY => 81,

    INSERT_KEY => 82,
    DELETE_KEY => 83,

    SPACE_BAR => 32,    #  added by Dominic Caffey on 4-28-92 */,

    WAIT      => 0,
    DONT_WAIT => 1

};

# int get_keystroke(int pause, int *special_key); # prototype - C language context.

#  integer constants */
use constant {

    ZERO_VALUE  => 0,
    ONE_VALUE   => 1,
    TWO_VALUE   => 2,
    THREE_VALUE => 3,
    FOUR_VALUE  => 4,
    FIVE_VALUE  => 5,
    TEN_VALUE   => 10

};

# ATTRIBUTES
#  trigonometry constants */
use constant {
    HALF_CIRCLE_DEGREES => 180,          #  # of degrees in half circle */
    HALF_CIRCLE_RADIANS => 3.1415927,    #  # of radians in half circle */
    MAX_BAD_GUYS        => 3,
    MAX_BULLETS         => 1,
    PI                  => 3.1415927,

    #PI                  => HALF_CIRCLE_RADIANS,
};

# METHODS

# -----------------------------< Functions >---------------------------------*/

# Put what follows below in the Utilities package.

# ****************************< Start setup_video_driver_and_mode >*******/

# ****************************************************************************/
# * Function Name   : setup_video_driver_and_mode.                      **/
# * Description     : This routine registers the video driver and sets the  **/
# *                   screen mode that the calling routine will use.  This  **/
# *                   routine is currently hardwired to register the        **/
# *                   "egavga" driver and set the screen mode to "VGAMED"   **/
# *                   which is 640 X 350, 16 color with 2 graphics pages.   **/
# * Inputs          : None.                                                 **/
# * Outputs         : Returns an integer value of "0" if successful and "1" **/
# *                   if the routine failed to register the driver or set   **/
# *                   the appropriate screen mode.                          **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4/02/1992.                                 **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

sub setup_video_driver_and_mode {
    #
## Pretty much all setup is done in the main of the consumer of this module when
## using PERL/Tk. So this sub becomes a no-op that just returns that everything
## is ok until this sub/method is deprecated later.
    #
    #    my $error_flag = ZERO_VALUE;
    #    my $errorcode;
    #	my $graphics_mode = VGAMED;
    #
    #      #ifdef video_problems
    #
##  DAVE - I've been having a lot of problems getting video drivers to link
##  into my program correctly; I've been in touch with Borland and they say that
##  it's probably due to my hardware incompatibility problem.  Everything links
##  fine and dandy but when I run the program I get a very vague message that
##  tells me nothing about what the problem actually is.  I've used preprocessor
##  directives to hop back back and forth between loading the video driver and
##  linking it into the code.  As a result of the problems I've been having, I'm
##  including the "egavga.bgi" video driver and doing a "detect" with "initgraph()".
##  This may be shoddy but it works given my present incompatibility dilemma.
##  - Dom */
#
#      #  register the graphics driver to be used before calling initgraph */
#      $errorcode = registerbgidriver(EGAVGA_driver);
#
#      #  test to see if video driver registration worked */
#
#      if ( $errorcode < ZERO_VALUE ) {
#        print( "Video driver - graphics error: %s\n",
#            grapherrormsg($errorcode) );
#        print( "errorcode = %d\n", $errorcode );
#        print("Press any key to quit.");
#        getch();
#        $error_flag = ONE_VALUE;    #  set an error_flag */
#    }
#    else {
#    #  Set the video environment for the program to be VGA, 640 x 350, 16 color.
##        The VGA driver will be linked directly into this program's
##          resulting executable
##          . See "UTIL.DOC" on your Borland distribution diskettes
##          . */
#
#          initgraph( ( int far * ) & $errorcode,
#            ( int far * ) & graphics_mode, "" );
#
#        #  test to see if initgraph worked */
#        $errorcode = graphresult();
#
#        if ( $errorcode != grOk ) {
#            print( "Initgraph - graphics error: %s\n",
#                grapherrormsg($errorcode) );
#            print("Press any key to quit.");
#            getch();
#            $error_flag = ONE_VALUE;    #  set an error_flag */
#        }
#    }
#
#    #endif
#
#    #ifndef video_problems
#
#    $errorcode = DETECT;
#      initgraph( ( int far * ) & $errorcode, ( int far * ) & graphics_mode, "" );
#
#      #  test to see if initgraph worked */
#      $errorcode = graphresult();
#
#      if ( $errorcode != grOk ) {
#        print( "Initgraph - graphics error: %s\n", grapherrormsg($errorcode) );
#        print("Press any key to quit.");
#        getch();
#        $error_flag = ONE_VALUE;    #  set an error_flag */
#    }
#
#    #endif
#
#    return ($error_flag);
    return (ZERO_VALUE);
}

# ****************************< End setup_video_driver_and_mode >*********/

# ****************************< Start restore_pre_game_environment >******/

# ****************************************************************************/
# * Function Name   : restore_pre_game_environment.                    **/
# * Description     : This routine restores the pre game environment.       **/
# *                   Currently, the pre game environment restoration       **/
# *                   consists only of restoring the pre game video mode but**/
# *                   later revisions of this routine will also restore     **/
# *                   other pre game environment elements.                  **/
# * Inputs          : None.                                                 **/
# * Outputs         : None.                                                 **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-4-92.                                    **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

sub restore_pre_game_environment {

    #closegraph();    #  free the memory allocated by graphics system */

#restorecrtmode(); #  put the system back in the text mode it was in prior to start of game */

    return;
}


sub spirals_help {

    #  put the display in text mode */
    #restorecrtmode();

    my $helpString = "\t\t\t"
      . "S P I R A L S    O F    D E A T H\n\n"
      . "\"Spirals of Death\" is a game in which bad guys, who move in a decaying spirals,\n"
      . "shoot at the good guy who's located in the center of the screen.  The good guy\n"
      . "can rotate his gun and fire back.  The user assumes the role of the good guy.\n"
      . "The object of the game is to destroy all the bad guys before being destroyed.\n"
      . "The good guy can take 3 hits before dying; he will change to a different color\n"
      . "each time he's hit in the following color progression:  Green -> Yellow -> Red -\n"
      . "> Background Color.  The game is over when the good guy's color is the same as\n"
      . "that of the game background.  The good guy fires green bullets and the bad guys\n"
      . "fire yellow bullets.\n\n"
      . "\t\t\tC O M M A N D    K E Y S\n\n"
      . "Key         | Function\n"
      . "------------+------------------------------\n"
      . "\"< -\"       = Rotate gun counter clockwise.\n"
      . "\"->\"        = Rotate gun clockwise.\n"
      . "\"space bar\" = fire gun.\n"
      . "\"h\" or \"H\"  = display this help screen.\n"
      . "\"p\" or \"P\"  = pause the game.\n"
      . "\"q\" or \"Q\"  = quit the game.\n"
      . "\a\a\a           =======> touch a key to start or resume game play <=======";

    # getch(); #  pause the routine while the user is reading the help screen */

    #  put the display back into graphics mode */
    # setgraphmode( getgraphmode() );

    return ($helpString);

} # spirals_help

  # ****************************< End spirals_help >***************************/

  sub testTrig {

    my ( $x, $y, $radius, $angle, $resp );
    $resp = 1;

    while ($resp) {
        print("\a\a\nEnter float values for x & y ---> ");
        my $vals = <>;
        chomp($vals);
        ( $x, $y ) = split $vals;
        print("\nYou entered the following values: $x\t$y.");

        $radius = cartesian_to_polar_coords( $x, $y, 'r' );

        $angle = cartesian_to_polar_coords( $x, $y, 'a' );

        print "\n\nThe polar coordinates for ($x, $y) are ($radius, $angle).";

        print("\n\nEnter float values for radius & angle ---> ");
        $vals = <>;
        chomp($vals);
        ( $radius, $angle ) = split $vals;

        print("\nYou entered the following values: $radius\t$angle");

        print(  "\nThe x coordinate for ($radius ,$angle) is \""
              . polar_to_cartesian_coords( $radius, $angle, 'x' )
              . "\"" );

        print(  "\nThe y coordinate for ($radius ,$angle) is \""
              . polar_to_cartesian_coords( $radius, $angle, 'y' )
              . "\"" );

        print("\nDo you want to run another test (1 for y, 0 for n) ---> ");
        $vals = <>;
        chomp($vals);
        ($resp) = split $vals;

    }
  }    # sub testTrig

#----------------------------------------------------------------------------------

sub polar_to_cartesian_coords {

    my ( $radius, $angle, $x_or_y, $x, $y );
    $radius = shift;
    $angle  = shift;
    $x_or_y = shift;

    # Algorithm at https://www.mathsisfun.com/polar-cartesian-coordinates.html.

    $x = $radius * cos($angle);

    $y = $radius * sin($angle);

    return ( ( $x_or_y eq 'x' ) ? $x : $y );

# Later on we'll change this to return a json obj with the x & y coordinates inside.
# It's very inefficient to make 2 calls to this .;
}

#----------------------------------------------------------------------------------

sub cartesian_to_polar_coords {

    my ( $x, $y, $angle_or_radius, $angle, $radius );
    $x               = shift;
    $y               = shift;
    $angle_or_radius = shift;

    # Algorithm at https://www.mathsisfun.com/polar-cartesian-coordinates.html.

    $radius = sqrt( ( $x**2 + $y**2 ) );

    $angle = atan2( $y, $x );    # Return value in radians.

    return ( ( $angle_or_radius eq 'a' ) ? $angle : $radius );

# Later on we'll change this to return a json obj with the x & y coordinates inside.
# It's very inefficient to make 2 calls to this .;
}

#----------------------------------------------------------------------------------

# package _utilities
no Moose;
__PACKAGE__->meta->make_immutable;

# End of file.

1;
