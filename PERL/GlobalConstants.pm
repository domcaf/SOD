package GlobalConstants;

# This package is a Moose Role.

use Moose::Role;

# See the following regarding log4perl usage:
#	http://search.cpan.org/~mschilli/Log-Log4perl-1.49/lib/Log/Log4perl.pm#Initialize_via_a_configuration_file
#	and
#	http://search.cpan.org/~mschilli/Log-Log4perl-1.49/lib/Log/Log4perl.pm#Initialize_once_and_only_once

#use Log::Log4perl;
#use constant LOG_CONFIG => '/home/domcaf/Documents/GIT-DATA/SOD/PERL/log.conf';
has 'LOG_CONFIG' => (is => 'ro', default => '/home/domcaf/Documents/GIT-DATA/SOD/PERL/log.conf', isa => 'Str');


# lh = log handle for Log4PERL usage.
#our $lh;
#
#BEGIN {
#    Log::Log4perl->init_once(LOG_CONFIG);
#
#    # lh = log handle for Log4PERL usage.
#    $lh = Log::Log4perl->get_logger("GlobalConstants");
#}
#


# See http://search.cpan.org/~lammel/MooseX-Log-Log4perl-0.46/lib/MooseX/Log/Log4perl/Easy.pm
# The above documents a Moose Extension that may help solve your problems to get common logging
# in all your modules.

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

    SPACE_BAR => 32,

    WAIT      => 0,
    DONT_WAIT => 1

};

# int get_keystroke(int pause, int *special_key); # prototype - C language context.

#  integer constants */

#has 'LOG_CONFIG' => (is => 'ro', default => '/home/domcaf/Documents/GIT-DATA/SOD/PERL/log.conf', isa => 'Str');

has 'ZERO_VALUE'    => ( is => 'ro', default => 0,  isa => 'Int' );
has 'ONE_VALUE'     => ( is => 'ro', default => 1,  isa => 'Int' );
has 'TWO_VALUE'     => ( is => 'ro', default => 2,  isa => 'Int' );
has 'THREE_VALUE'   => ( is => 'ro', default => 3,  isa => 'Int' );
has 'FOUR_VALUE'    => ( is => 'ro', default => 4,  isa => 'Int' );
has 'FIVE_VALUE'    => ( is => 'ro', default => 5,  isa => 'Int' );
has 'TEN_VALUE'     => ( is => 'ro', default => 10, isa => 'Int' );
has 'TWENTY_VALUE'  => ( is => 'ro', default => 20, isa => 'Int' );
has 'THIRTY_VALUE'  => ( is => 'ro', default => 30, isa => 'Int' );
has 'FORTY_VALUE'   => ( is => 'ro', default => 40, isa => 'Int' );
has 'FIFTY_VALUE'   => ( is => 'ro', default => 50, isa => 'Int' );
has 'HUNDRED_VALUE' => ( is => 'ro', default => 10, isa => 'Int' );

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

#----------------------------------------------------------------------------------


#----------------------------------------------------------------------------------

1;

# End of file.
