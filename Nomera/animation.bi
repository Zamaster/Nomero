#ifndef ANIMATION_BI
#define ANIMATION_BI

#include "vector2d.bi"
#include "hashtable.bi"

enum ANIM_TYPE
    ANIM_ONE_SHOT
    ANIM_LOOP
    ANIM_STILL
end enum
enum ANIM_RELEASE_TYPE
    ANIM_TO_COMPLETION
    ANIM_INSTANT
    ANIM_FINISH_FRAME
    ANIM_AFTER_RELEASE_POINT
    ANIM_REVERSE
    ANIM_JUMP_TO_RELEASE_THEN_REVERSE
end enum

enum Anim_DrawType_e
	ANIM_GLOW
	ANIM_ALPHA
	ANIM_TRANS
end enum



type FrameData_t
    as Vector2D offset
    as integer  delay
end type

type RotatedGroup_t
	as integer ptr ptr rotatedGroup
end type

type NonTransCount_t
	as integer countPerRotatedGroup(0 to 7)
end type

type Animation_t field = 1
    as ANIM_TYPE         anim_type
    as ANIM_RELEASE_TYPE anim_release_type
    as integer           usePerFrameDelay
    
    as integer     ptr release_frames
    as integer         release_frames_n
    as FrameData_t ptr frame_data
    as integer         frame_hasData
    as integer         frame_n
    as integer         frame_width
    as integer         frame_height
    as integer         frame_delay
    as integer         frame_startCell
    as integer         frame_endCell
    as integer         frame_loopPoint
    as Vector2D        frame_offset
    
    as HashTable       rotatedGroupFrames
    as HashTable	   nonTransCountFrames
end type

type AnimationData_t
    as zstring ptr animName
    as Animation_t ptr animations
    as integer animations_n
    as zstring ptr imgName
    as integer ptr image
    as integer w
    as integer h
    as Anim_DrawType_e drawMode
    as integer defaultAnim
end type



type Animation
        declare constructor
        declare constructor(filename as string)
        declare destructor
        declare sub load(filename as string)
        
        declare sub switch(next_anim as integer)
        declare sub hardSwitch(next_anim as integer)
        declare sub pause()
        declare sub play()
        declare sub restart()
        declare function done() as integer
        
        declare sub setSpeed(s as integer)
        declare sub setGlow(glow as integer)
 
        declare sub drawAnimation(scnbuff as uinteger ptr, x as integer, y as integer, cam as Vector2D = Vector2D(0,0), drawFlags as integer = 0)
        declare sub drawAnimationOverride(scnbuff as uinteger ptr, x as integer, y as integer, anim as integer, frame as integer, cam as Vector2D = Vector2D(0,0), drawFlags as integer = 0)
        
        declare sub step_animation()
        declare function getAnimation() as integer
        declare function getWidth() as integer
        declare function getHeight() as integer 
        declare function getOffset() as Vector2D
        declare function getFrame() as integer
        declare function getGlow() as integer
        
        declare function getFramePixelCount(rotatedFlags as integer = 0) as integer
        declare sub getFrameImageData(byref img as uinteger ptr, byref xpos as integer, byref ypos as integer, byref w as integer, byref h as integer)

    private:
        declare sub init()
        declare sub applySwitch()
        declare sub step_OneShot()
        declare sub step_Loop()
        declare sub step_Still()
        declare sub fetchImageData(animNum as integer, frameNum as integer, rotatedFlag as integer,_
				                   byref imgdata as uinteger ptr, byref drawW as integer, byref drawH as integer, byref offset as Vector2D,_
				                   byref start_x as integer, byref start_y as integer)
        
        declare sub advance()
    
        as AnimationData_t ptr data_
               
        as integer glowValue
        as integer completed
        as integer reachedEnd
        as integer currentAnim
        as integer delayCounter
        as integer currentFrame
        as integer drawFrame
        as integer isPaused
        as integer isReleasing
        as integer pendingSwitch
        as integer speed
    
        static as HashTable animHash
        static as integer initAnimHash
        
end type


#endif
