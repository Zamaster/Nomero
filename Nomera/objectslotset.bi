#ifndef OBJECTSLOTSET_BI
#define OBJECTSLOTSET_BI

#include "item.bi"
#include "shape2d.bi"
#include "objectlink.bi"

type ObjectSlotSet_member_t
    as zstring ptr itemID
    as zstring ptr slot_tag
    as Shape2D geometry
end type

type ObjectSlotSet
    public:
        declare constructor()
        declare destructor()
        declare sub _setlink_(link_ as objectlink)
        declare sub _addSlot_(itemID as string, slot_tag as string, geom as Shape2D)
        declare sub throw(parameter_string as string = "")
        declare function getMember_N() as integer
        declare function getMember(i as integer) as ObjectSlotSet
        declare sub getGeometry(byref geom as Shape2D, i as integer) 
        declare sub getID(byref ID_ as string, i as integer)
        declare sub clean()
    private:
        as ObjectSlotSet_member_t ptr members
        as integer members_N
        as integer members_cap
        as objectlink link
end type

#endif