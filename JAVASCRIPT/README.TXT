                   S P I R A L S    O F    D E A T H

                           copyright 1992

No portion of this software package may be altered, distributed
or modified without the author's express written permission.

                               By

               Dominic Caffey a.k.a Thurlow Caffey

                    Advanced C Programming Class
                     Instructor:  David Conger
                       Spring Trimester 1992
                       TVI - Montoya Campus

     "Spirals of Death" is a game in which bad guys, who move in a
decaying spirals, shoot at the good guy who's located in the center
of the screen.  The good guy can rotate his gun and fire back.  The
user assumes the role of the good guy.  The object of the game is
to destroy all the bad guys before being destroyed.  The good guy
can take 3 hits before dying; he will change to a different color
each time he's hit in the following color progression:  Green ->
Yellow -> Red -> Background Color.  The game is over when the good
guy's color is the same as that of the game background.  The good
guy fires green bullets and the bad guys fire yellow bullets.

C O M M A N D    K E Y S
Key         | Function
------------+------------------------------
"<-"        = Rotate gun counter clockwise.
"->"        = Rotate gun clockwise.
"space bar" = fire gun.
"h" or "H"  = display this help screen.
"p" or "P"  = pause the game.
"q" or "Q"  = quit the game.

                           Known Bugs:

Program does not free up memory correctly when it ends or is quit
     by the user thus causing the machine upon which it is run to
     periodically crash.

Acknowledgement of successful kills by either the good guy or bad
     guys needs to be refined as it doesn't always work correctly.

                    Special Notes To Grader:

     The hard drive on my computer ceased to function on 5-14-92 at
about 11:15pm.  As a result of the failure I was not able to
compile the corrections to the "Known Bugs" and online help
facility.  Thus the executable that is enclosed with this package
does not have online help and exhibits the behaviors enumerated in
the "Known Bugs" section of this document.  The source code
contains correction attempts but has not been compiled and linked
to produce an executable to reflect the corrections.

                                      Dominic Caffey             
                                      Author - "Spirals of Death"

