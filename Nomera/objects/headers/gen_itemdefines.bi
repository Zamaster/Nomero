#ifndef GEN_ITEMDEFINES_BI
#define GEN_ITEMDEFINES_BI
type ITEM_BIGOSCILLOSCOPE_TYPE_DATA 
    as zstring ptr someText2
    as Vector2D vec
    as integer shouldDraw
    AS DOUBLE thetime
end type
type ITEM_FREQUENCYCOUNTER_TYPE_DATA 
    as zstring ptr someText2
    as Vector2D vec
    as integer shouldDraw
end type
type ITEM_TANDY2000_TYPE_notItemData_t
    as integer      temp
    as integer ptr  test2
end type
type ITEM_TANDY2000_TYPE_DATA 
    as integer testInt
    as double  testDbl
    as single  testSng
    as Vector2D   alright
    as integer checkIt
    as ITEM_TANDY2000_TYPE_notItemData_t cheese
end type
enum Item_Type_e
    ITEM_NONE
    ITEM_BIGOSCILLOSCOPE
    ITEM_FREQUENCYCOUNTER
    ITEM_TANDY2000
end enum
enum Item_slotEnum_e
    ITEM_BIGOSCILLOSCOPE_SLOT_PLAYSOUNDTEST_E
    ITEM_BIGOSCILLOSCOPE_SLOT_DRAW2PARAMS_E
    ITEM_FREQUENCYCOUNTER_SLOT_TESTSLOT3_E
    ITEM_FREQUENCYCOUNTER_SLOT_EXPLODE_E
    ITEM_TANDY2000_SLOT_MYONLYSLOT_E
end enum
union Item_objectData_u
    as ITEM_BIGOSCILLOSCOPE_TYPE_DATA ptr BIGOSCILLOSCOPE_DATA
    as ITEM_FREQUENCYCOUNTER_TYPE_DATA ptr FREQUENCYCOUNTER_DATA
    as ITEM_TANDY2000_TYPE_DATA ptr TANDY2000_DATA
end union
#endif
