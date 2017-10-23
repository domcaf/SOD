                package SOD::Sprites;
                use Moose;
use namespace::autoclean;

                    # Player behaviour limits
                    use constant {

        # Some of these constants might be more appropriately located in spcific
        # player type definitions.

                        SHOOTING_PROBABILITY_FACTOR => 101,
                        BAD_GUY_MAX_ANGLE_STEP => 6,    #  This is in degrees */
                        GOOD_GUY_BULLET_SPEED_FACTOR => 3,
                        MAX_GOOD_GUY_EVENTS          => 1
                        ,  #  max # of events processed per visit to good guy */
                        GOOD_GUY_ROTATION_INCREMENT =>
                          0.087,    #  equivalent to 5 degrees in radians */
                        BULLET_RADIUS => 2

                    };
                    short unsigned int *bitmap;
                    int x, y;
			int width, height;

                      no Moose;
                    __PACKAGE__->meta->make_immutable;

# End of file.
  
1;
  
