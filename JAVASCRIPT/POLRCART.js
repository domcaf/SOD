// JavaScript functions to do conversions between Cartesian and Polar coordinate systems.
// Algorithm at https://www.mathsisfun.com/polar-cartesian-coordinates.html.

function polar_to_cartesian_coords(radius, angle, x_or_y) {

	let x = radius * Math.cos(angle);

	let y = radius * Math.sin(angle);

	return((x_or_y == 'x') ? x : y);

	// Later on we'll change this to return a json obj with the x & y coordinates inside.
	// It's very inefficient to make 2 calls to this.
}


function cartesian_to_polar_coords(x, y, angle_or_radius) {

	let radius = Math.sqrt((Math.pow(x, 2) + Math.pow(y, 2)));

	let angle = Math.atan2(y, x); // Return value in radians.

	return((angle_or_radius == 'a') ? angle : radius);

	// Later on we'll change this to return a json obj with the radius and angle inside.
	// It's very inefficient to make 2 calls to this.
}

// End of file.
