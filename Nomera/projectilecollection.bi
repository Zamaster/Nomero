#ifndef PROJECTILECOLLECTION_BI
#define PROJECTILECOLLECTION_BI

#include "vector2d.bi"
#include "tinyspace.bi"
#include "tinybody.bi"
#include "oneshoteffects.bi"
#include "animation.bi"
#include "level.bi"
#include "objectLink.bi"
#include "list.bi"

enum Projectiles
    CHERRY_BOMB
    DETRITIS
    HEART
    WATER_DROP
    BULLET
    SPARK
    BLUE_SPARK
    CARTRIDGE
end enum


type Projectile_t
    as TinyBody body
    as integer  body_i
    as Animation anim
    as Projectiles flavor
    as integer lifeFrames
    as integer data0
end type


type Level_ as Level

type ProjectileCollection
    public:
        declare constructor()
        declare destructor()
		declare sub setLink(link_ as ObjectLink)
        declare sub create(p_ as Vector2D, v_ as Vector2D, f_ as integer = CHERRY_BOMB, noCollide as integer = 0)
        declare sub draw_collection(scnbuff as uinteger ptr)
        declare sub proc_collection(t as double)
        declare sub setParent(TS as TinySpace ptr, LS as Level_ ptr, GS as any ptr)
        declare sub setEffectsGenerator(s as OneShotEffects ptr)
		declare sub checkDynamicCollision(p as Vector2D, size as Vector2D)
        declare sub flush()
    private:
        as TinySpace ptr parent_space
        as List proj_list
        as OneShotEffects ptr   effects
        as any ptr game_space
        as Level_ ptr parent_level
        as ObjectLink link
end type



#endif
