#ifndef SOUNDEFFECTS_BI
#define SOUNDEFFECTS_BI


#include "objectlink.bi"

#define NUM_SOUNDS 24

enum SoundEffect_e
	SND_EXPLODE_1
	SND_EXPLODE_2
	SND_FULLCHARGE
	SND_JUMP
	SND_LAND
	SND_THROW
	SND_SHOOT
	SND_ALARM
	SND_DOOR
	SND_DRIP
	SND_HURT
	SND_DEATH
	SND_EXPLODE
    SND_SPINNER
    SND_SIGNAL
    SND_PLACE_APMINE
    SND_PLACE_ELECMINE
    SND_EXPLODE_3
    SND_ARC1
    SND_ARC2
    SND_ARC
    SND_PLACE_GASMINE
    SND_EXPLODE_4
    SND_GEARS
    SND_COLLIDE
    SND_SELECT
end enum

type SoundEffects
	public:
		declare constructor()
		declare sub init()
		declare sub setLink(link_ as objectLink)
		declare function playSound(s as SoundEffect_e) as integer
        declare sub stopSound(chnl as integer) 
		
	private:
		as ObjectLink link
		as integer ptr sounds(0 to NUM_SOUNDS - 1)
        as integer volume(0 to NUM_SOUNDS - 1)
end type
	

#endif
