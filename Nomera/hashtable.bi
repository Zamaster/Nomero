#ifndef HASHTABLE_BI
#define HASHTABLE_BI


#include "debug.bi"

#macro BEGIN_HASH(x, y)
	y.resetRoll()
	do
		x = y.roll()
		if x then
#endmacro

#macro END_HASH()
		else
			exit do
		end if
	loop
#endmacro


enum HashNodeKeyType_e
    KEY_STRING
    KEY_INTEGER
    KEY_INVALID
end enum


type HashNode_t
    as any ptr data_
    as HashNode_t ptr next_
    as HashNodeKeyType_e key_type
    key_string  as zstring ptr
    key_integer as integer
end type

type HashTable
    public:
        declare constructor()
        declare constructor(datasize as uinteger)
        declare destructor()
        declare sub construct_()
        declare sub init(datasize as uinteger)
        declare function insert(r_key as integer, data_ as any ptr) as any ptr
        declare function insert(r_key as string , data_ as any ptr) as any ptr
        declare sub remove(r_key as integer)
        declare sub remove(r_key as string)
        declare function retrieve(r_key as integer) as any ptr
        declare function retrieve(r_key as string ) as any ptr
        declare function exists(r_key as integer) as integer
        declare function exists(r_key as string ) as integer 
        declare function getSize() as integer
        declare function getDataSizeBytes() as integer
        declare sub resetRoll()
        declare function roll() as any ptr
        declare function rollGetKeyType() as HashNodeKeyType_e
        declare function rollGetKeyString() as string
        declare function rollGetKeyInteger() as integer
        declare sub flush()
        declare sub clean()
    private:
        declare function hashString(r_key as string)   as uinteger
        declare function hashInteger(r_key as integer) as uinteger
        declare sub rehash()
        as integer  ready_flag
        as uinteger dataSizeBytes
        as uinteger numObjects
        as uinteger numCells
        as HashNode_t ptr lastRollNode
        as HashNode_t ptr ptr data_
        as HashNode_t ptr curRollNode
        as integer        curRollIndx
end type



#endif
