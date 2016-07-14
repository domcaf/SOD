/*--------------------------------getkeys.h----------------------------------*/

#ifndef __GETKEYS_INCLUDED__


/*---------------------------------constants---------------------------------*/

#define F1               59
#define F2               60
#define F3               61
#define F4               62
#define F5               63
#define F6               64
#define F7               65
#define F8               66
#define F9               67
#define F10              68
#define F11              133
#define F12              134

#define SHIFT_F1         84
#define SHIFT_F2         85
#define SHIFT_F3         86
#define SHIFT_F4         87
#define SHIFT_F5         88
#define SHIFT_F6         89
#define SHIFT_F7         90
#define SHIFT_F8         91
#define SHIFT_F9         92
#define SHIFT_F10        93
#define SHIFT_F11        135
#define SHIFT_F12        136

#define CTRL_F1          94
#define CTRL_F2          95
#define CTRL_F3          96
#define CTRL_F4          97
#define CTRL_F5          98
#define CTRL_F6          99
#define CTRL_F7          100
#define CTRL_F8          101
#define CTRL_F9          102
#define CTRL_F10         103
#define CTRL_F11         137
#define CTRL_F12         138  

#define ALT_F1           104
#define ALT_F2           105
#define ALT_F3           106
#define ALT_F4           107
#define ALT_F5           108
#define ALT_F6           109
#define ALT_F7           110
#define ALT_F8           111
#define ALT_F9           112
#define ALT_F10          113
#define ALT_F11          139
#define ALT_F12          140

#define UP_ARROW         72
#define DOWN_ARROW       80
#define LEFT_ARROW       75
#define RIGHT_ARROW      77

#define CTRL_W           23
#define CTRL_Z           26

#define HOME_KEY         71
#define END_KEY          79

#define PGUP_KEY         73
#define PGDN_KEY         81

#define INSERT_KEY       82
#define DELETE_KEY       83

#define SPACE_BAR        32  /* added by Dominic Caffey on 4-28-92 */

#define WAIT             0
#define DONT_WAIT        1

/*-------------------------------end constants-------------------------------*/



/*--------------------------------prototypes---------------------------------*/

int get_keystroke(int pause, int *special_key);

/*------------------------------end prototypes-------------------------------*/


#define __GETKEYS_INCLUDED__ 
#endif

/*------------------------------end getkeys.h--------------------------------*/
