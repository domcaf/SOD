		package SOD::Goodguy;
		use Moose;
use namespace::autoclean;
		{

# Good guy constants
use constant {

    GOOD_GUY_RADIUS      => 0.05,    #  This is specified as a percentage */
    GOOD_GUY_GUN_LENGTH  => 0.01,    #  This is specified as a percentage */
    GUN_WIDTH_HALF_ANGLE => 0.1      #  SPECIFIED IN RADIANS */

};
			int x, y;       #  center of good guy */
			int radius;	#  radius of good_guy, excluding barrel */

			int gun_length;  #  length as a %age of screen dimensions */
			int gun_color;

			float gun_angle; #  angle in radians where gun is pointing */
			float gun_width_half_angle; #  half the angle width of the gun barrel in radians */
		} goodguys;

# METHODS

	#  prototypes for add_good.c */

		void draw_good_guy(players *, float new_angle);


		players *add_good(void);

		no Moose;
		__PACKAGE__->meta->make_immutable;

		#define GOODGUY_H
# End of file.
  
1;
  
