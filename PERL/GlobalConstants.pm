package GlobalConstants;

# This package is a Moose Role.

use Moose::Role;

# See the following regarding log4perl usage:
#	http://search.cpan.org/~mschilli/Log-Log4perl-1.49/lib/Log/Log4perl.pm#Initialize_via_a_configuration_file
#	and
#	http://search.cpan.org/~mschilli/Log-Log4perl-1.49/lib/Log/Log4perl.pm#Initialize_once_and_only_once

#use Log::Log4perl;
#use constant LOG_CONFIG => '/home/domcaf/Documents/GIT-DATA/SOD/PERL/log.conf';
has 'LOG_CONFIG' => (
    is      => 'ro',
    default => '/home/domcaf/Documents/GIT-DATA/SOD/PERL/log.conf',
    isa     => 'Str'
);

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

#  integer constants */

#has 'LOG_CONFIG' => (is => 'ro', default => '/home/domcaf/Documents/GIT-DATA/SOD/PERL/log.conf', isa => 'Str');

has 'BAD_GUY_PNG_LOC' =>
  ( is => 'ro', default => '/tmp/Bad_guy.png', isa => 'Str' );
has 'BAD_GUY_PS_LOC' =>
  ( is => 'ro', default => '/tmp/Bad_guy.ps', isa => 'Str' );
has 'FIFTY_VALUE'   => ( is => 'ro', default => 50,  isa => 'Int' );
has 'FIVE_VALUE'    => ( is => 'ro', default => 5,   isa => 'Int' );
has 'FORTY_VALUE'   => ( is => 'ro', default => 40,  isa => 'Int' );
has 'FOUR_VALUE'    => ( is => 'ro', default => 4,   isa => 'Int' );
has 'HUNDRED_VALUE' => ( is => 'ro', default => 100, isa => 'Int' );
has 'ONE_VALUE'     => ( is => 'ro', default => 1,   isa => 'Int' );
has 'TEN_VALUE'     => ( is => 'ro', default => 10,  isa => 'Int' );
has 'THIRTY_VALUE'  => ( is => 'ro', default => 30,  isa => 'Int' );
has 'THREE_VALUE'   => ( is => 'ro', default => 3,   isa => 'Int' );
has 'TWENTY_VALUE'  => ( is => 'ro', default => 20,  isa => 'Int' );
has 'TWO_VALUE'     => ( is => 'ro', default => 2,   isa => 'Int' );
has 'ZERO_VALUE'    => ( is => 'ro', default => 0,   isa => 'Int' );

#  trigonometry and player constants

# TODO: Keep in mind that Tk angles are specified in degrees while PERL trig functions expect radians.

has 'FULL_CIRCLE_DEGREES' => ( default => 360,       is => 'ro', isa => 'Int' );
has 'FULL_CIRCLE_RADIANS' => ( default => 6.282,     is => 'ro', isa => 'Num' );
has 'HALF_CIRCLE_DEGREES' => ( default => 180,       is => 'ro', isa => 'Int' );
has 'HALF_CIRCLE_RADIANS' => ( default => 3.1415927, is => 'ro', isa => 'Num' );
has 'MAX_BAD_GUYS'        => ( default => 1,         is => 'ro', isa => 'Int' );
has 'MAX_BULLETS'         => ( default => 1,         is => 'ro', isa => 'Int' );
has 'PI'                  => ( default => 3.1415927, is => 'ro', isa => 'Num' );
has 'RADS_PER_DEGREE'     => ( default => 0.0174,    is => 'ro', isa => 'Num' );

# METHODS

#----------------------------------------------------------------------------------

#----------------------------------------------------------------------------------

1;

# End of file.
