#ifndef LEVELTYPES_BI
#define LEVELTYPES_BI

#include "hashtable.bi"
#include "constants.bi"

enum ObjectType_t
    EFFECT
    PORTAL
    TRIGGER
    SPAWN
end enum

type Object_t
    as zstring * 128 object_name
    as ushort object_type
    as ushort object_shape
    as ushort inRangeSet
    as Vector2D p
    as Vector2D size
    as any ptr data_
end type

type destroyedBlocks_t
	as integer width_
	as integer height_
	as byte ptr data_
end type

enum EffectType_t
    ANIMATE
    FLICKER
    DESTRUCT
    NONE
end enum

type Level_FalloutType
    as Vector2D a
    as Vector2D b
    as integer ptr cachedImage
    as integer  flavor
end type

type Level_EffectData
    as short  nextTile
    as ushort effect
    as ushort offset
    as ushort delay
    as ushort tilenum
end type

type Level_Tileset
    as zstring ptr set_name
    as ushort set_width
    as ushort set_height
    as ushort count
    as ushort row_count
    as uinteger ptr set_image
    as HashTable tileEffect
end type

type Level_VisBlock
    as ushort tileset
    as ushort tileNum
    as short frameDelay
    as ushort usesAnim
    as ushort rotatedType
end type

Type Level_LayerData
    as ushort order
    as ushort parallax
    as ushort inRangeSet
    as ushort isDestructible
    as ushort isFallout
    as ushort illuminated
    as ubyte  ambientLevel
    as ushort coverage
    as single depth
end type

enum PortalDirection_t
    D_LEFT
    D_UP
    D_RIGHT
    D_DOWN
    D_IN
    NO_FACING
end enum

type PortalType_t
    as Vector2D a, b
    as zstring ptr portal_name
    as zstring ptr to_map
    as zstring ptr to_portal
    as PortalDirection_t direction
end type

type BoundingBox_t
    as Vector2D a,b
    as double area
    as zstring ptr portalName
end type

type LevelSwitch_t
    as integer shouldSwitch
    as Vector2D p
    as string fileName
    as string portalName
    as PortalDirection_t facing
end type


#endif