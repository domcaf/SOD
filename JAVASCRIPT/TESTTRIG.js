/* this program is used to test the correctness and functionality of the
routines contained in the file "polrcart.c". */

float polar_to_cartesian_coords(float,float,char);

float cartesian_to_polar_coords(float , float , char);

#include <stdio.h>

main()
{


	float x, y, radius, angle;
	int resp = 1;


/******/

	while(resp)
	{
		printf("\a\a\nEnter float values for x & y ---> ");
		scanf("%f %f",&x,&y);
		printf("\nYou entered the following values: %f %f.",x,y);


		radius = cartesian_to_polar_coords(x,y,'r');
		angle = cartesian_to_polar_coords(x,y,'a');

		printf("\n\nThe polar coordinates for (%f,%f) are (%f,%f).",x,y,radius,angle);

		printf("\n\nEnter float values for radius & angle ---> ");
		scanf("%f %f",&radius,&angle);
		printf("\nYou entered the following values: %f %f",radius,angle);

		printf("\nThe x coordinate for (%f,%f) is %f",radius,angle,polar_to_cartesian_coords(radius,angle,'x'));

		printf("\nThe y coordinate for (%f,%f) is %f",radius,angle,polar_to_cartesian_coords(radius,angle,'y'));

		printf("\nDo you want to run another test (1 for y, 0 for n) ---> ");
		scanf("%d",&resp);
	}
}

/* end of file */
