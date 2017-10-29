		package SOD::Bullet;

use Exporter;
@ISA = ("Exporter");
@EXPORT = qw(&did_bullet_hit_something);




		use Moose;
use namespace::autoclean;

		 #bullets attributes/properties.
		
 			#  x-coordinate of center of circular bullet */
			has 'x' => (
				isa => 'Num',
				is => 'rw'
			);

 			#  y-coordinate of center of circular bullet */
			has 'y' => (
				isa => 'Num',
				is => 'rw'
			);

			# radius of bullet as %age of screen dimensions */
			has 'radius' => (
				isa => 'Int',
				is => 'ro'
			);

			#  movement increments */
			has 'x_step' => (
				isa => 'Num',
				is => 'ro'
			);

			#  movement increments */
			has 'y_step' => (
				isa => 'Num',
				is => 'ro'
			);

			# reference to player who shot bullet */
			has 'from' => (
				isa => 'Object',
				is => 'ro'
			);

		# methods go here
		players *did_bullet_hit_something(players *);


# ****************************< Start did_bullet_hit_something >********/

# ****************************************************************************/
# * Function Name   : did_bullet_hit_something.                        **/
# * Description     : This function determines if a bullet hit something.   **/
# *                   If it hit something it identifies what it hit and     **/
# *                   returns a pointer to the hit object otherwise it      **/
# *                   returns a value of NULL.                              **/
# * Inputs          : A pointer to the bullet being tested for a hit.       **/
# * Outputs         : A pointer to hit object or NULL if no hit.            **/
# * Programmer(s)   : Dominic Caffey.                                       **/
# * Notes & Comments: Created on 4-30-92.                                   **/
# *                                                                         **/
# *                                                                         **/
# ****************************************************************************/

players *did_bullet_hit_something(players *bullet)
{
	players *target = NULL;
	float look_ahead_x, look_ahead_y, look_ahead_dist_to_screen_center, distance_between_bullets;
	static int background_color;
	static int screen_center_x, screen_center_y;
	int target_found = ZERO_VALUE;

	background_color = getbkcolor();
	screen_center_x = (int) (getmaxx()/TWO_VALUE);
	screen_center_y = (int) (getmaxy()/TWO_VALUE);


	#  calculate look ahead coordinates */
	look_ahead_x = bullet->pd.b.x + (TWO_VALUE * bullet->pd.b.x_step);
	look_ahead_y = bullet->pd.b.y + (TWO_VALUE * bullet->pd.b.y_step);

	#  determine if the bullet actually hit something */
	if(getpixel((int) look_ahead_x,(int) look_ahead_y) != background_color)
	{
		#  the bullet hit something, find out what it hit */
		target = bullet->next; #  set starting point for search */

		while((target != bullet) && (!target_found))  #  traverse the player list */
		{
			if(target != bullet->pd.b.from) #  a player can't shoot itself */

				if(target->pt == good)
				{
					look_ahead_dist_to_screen_center = sqrt(pow((look_ahead_x - screen_center_x),TWO_VALUE) + pow((look_ahead_y - screen_center_y),TWO_VALUE));

					if(look_ahead_dist_to_screen_center <= target->pd.gg.radius)
						target_found = ONE_VALUE;
				}
				else if(target->pt == bad)
				{
					if((look_ahead_x >= target->pd.bg.badguy.x) &&
						(look_ahead_x <= (target->pd.bg.badguy.x + target->pd.bg.badguy.width)) &&
						(look_ahead_y >= target->pd.bg.badguy.y) &&
						(look_ahead_y <= (target->pd.bg.badguy.y + target->pd.bg.badguy.height)))
							target_found = ONE_VALUE;
				}
				else #  the player type is another bullet */
				{
				  #  if the distance between their two centers is less than (2 * r) then they hit each other */
					distance_between_bullets = sqrt(pow((look_ahead_x - target->pd.b.x),TWO_VALUE) + pow((look_ahead_y - target->pd.b.y),TWO_VALUE));

					if(distance_between_bullets <= (2 * bullet->pd.b.radius))
						target_found = ONE_VALUE;
				}

			if(!target_found)
				target = target->next;

		}
	}

	return(target);
}

# ****************************< End did_bullet_hit_something >***********/

		# package _bullet;

		no Moose;
		__PACKAGE__->meta->make_immutable;

# End of file.
  
1;
  
