package GlobalConstants;
#package SOD::GlobalConstants;

#use Exporter;
#@ISA = ("Exporter");
#@EXPORT = qw();

use Moose::Role;
#use namespace::autoclean;

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
#use constant {
#
#    #ZERO_VALUE  => 0,
#    ONE_VALUE   => 1,
#    TWO_VALUE   => 2,
#    THREE_VALUE => 3,
#    FOUR_VALUE  => 4,
#    FIVE_VALUE  => 5,
#    TEN_VALUE   => 10
#
#};

#our $ZERO_VALUE  = 0;

has 'ZERO_VALUE'  => (is => 'ro', default => 0,  isa => 'Int');
has 'ONE_VALUE'   => (is => 'ro', default => 1,  isa => 'Int');
has 'TWO_VALUE'   => (is => 'ro', default => 2,  isa => 'Int');
has 'THREE_VALUE' => (is => 'ro', default => 3,  isa => 'Int');
has 'FOUR_VALUE'  => (is => 'ro', default => 4,  isa => 'Int');
has 'FIVE_VALUE'  => (is => 'ro', default => 5,  isa => 'Int');
has 'TEN_VALUE'   => (is => 'ro', default => 10, isa => 'Int');

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

#no Moose;
#__PACKAGE__->meta->make_immutable;

1;

# End of file.
