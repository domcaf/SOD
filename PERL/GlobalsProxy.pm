package GlobalsProxy;

# This is essentially a proxy class defintion so that non OO programs can get
# access to the constants in GlobalConstants.pm by instantiating an instance of
# this class and getting access to the constants via the default accessors
# that Moose provides for free. GlobalConstants.pm is a Moose Role which is 
# why the creation of the proxy class instance is necessary. Simply using
# GlobalConstants to gain access to the defined constants would require exporting
# the constants and making GlobalConstants an "EXPORTER". As a Moose role the
# constants are attributes essentially achieving the same effect without having
# to maintain an export list. It's also more OO/Moosey.

# NOTE: This will be a very tiny Moose class defintion.

use lib '.';
use Moose;
with 'GlobalConstants';
use namespace::autoclean;


# ATTRIBUTES
# ****************************************************************************/

# METHODS
# ****************************************************************************/

1;

