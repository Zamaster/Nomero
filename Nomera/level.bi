#ifndef LEVEL_BI
#define LEVEL_BI

#include "tinyblock.bi"
#include "constants.bi"
#include "vector2d.bi"
#include "hash2d.bi"
#include "list.bi"
#include "effectcontroller.bi"
#include "tinybody.bi"
#include "objectlink.bi"
#include "hashtable.bi"

#define MAX_ZONES 8
#define FLIPPED_HORIZ &h4
#define FLIPPED_VERT  &h2
#define FLIPPED_DIAG  &h1
#define FLIPPED_MASK  &h1fffffff

#define SAVE_PATH "saves\"

#include "leveltypes.bi"

type EffectController_ as EffectController

type Level
    public:
        declare constructor
        declare constructor(filename as string)
        declare destructor
        
        declare sub setLink(link_ as objectlink)
        declare sub init(e_p as EffectController_ ptr)
        
        declare sub load(filename as string)
        declare sub process(t as double)
        declare function processPortalCoverage(p as Vector2D,_
                                               w as double, h as double,_
                                               byref l as levelSwitch_t,_
                                               coverage as double = 0.5) as integer
        declare sub repositionFromPortal(l as levelSwitch_t, _
                                         byref p as TinyBody)
                                        
        declare function getWidth() as integer
        declare function getHeight() as integer
        declare function getName() as string
        declare function getLayerN() as integer
        declare sub drawLayer(scnbuff as uinteger ptr,_
                              tl_x as integer, tl_y as integer,_
                              br_x as integer, br_y as integer,_
                              x as integer, y as integer,_
                              cam_x as integer, cam_y as integer,_
                              lyr as integer)
        declare sub drawLayers(scnbuff as uinteger ptr, order as integer,_
                               cam_x as integer, cam_y as integer,_
                               adjust as Vector2D)
        declare function getCollisionLayerData() as TinyBlock ptr
        declare function getCollisionBlock(x as integer,_
                                           y as integer) as TinyBlock
        declare sub resetBlock(x as integer, y as integer, lyr as integer)
        declare sub setCollision(x as integer, y as integer, v as integer)
        declare sub flush()
        declare sub addFallout(x as integer, y as integer, flavor as integer = -1)
        declare function usesSnow() as integer
        declare function mustReconnect() as integer
        
        declare function getCurrentMusicFile() as string
        declare sub overrideCurrentMusicFile(filename as string)
        declare sub addPortal(pt as PortalType_t)
        declare function getDefaultPos() as Vector2D
        declare sub flushDestroyedBlockMemory()
        declare function checkDestroyedBlocks(x as integer, y as integer) as integer
        declare function getLightList(byref lightList_p as LightPair ptr ptr) as integer 
		declare function getCoverageLayerBlocks(x0 as integer, y0 as integer,_
												x1 as integer, y1 as integer,_
												byref data_ as Level_CoverageBlockInfo_t ptr) as integer
        declare function shouldLight() as integer
        declare function getObjectAmbientLevel() as integer
        declare function getHiddenObjectAmbientLevel() as integer
        declare sub setObjectAmbientLevel(col as integer)
        declare sub setHiddenObjectAmbientLevel(col as integer)    
        declare sub drawBackgroundEffects(scnbuff as integer ptr)
        declare function getSmokeTexture() as integer ptr
        declare sub drawSmoke(scnbuff as integer ptr)
        declare sub fadeMistIn()
        declare sub fadeMistOut()
        declare sub resetMistFade()
        declare function getLevelCenterX() as integer
        declare function getLevelCenterY() as integer

        declare function getGroup(group_tag as string, byref layer_nums as integer ptr) as integer
        declare sub setHide(lyr as integer)
        declare sub setUnhide(lyr as integer)
        declare sub setGlow(lyr as integer, glow as integer)
        
        declare function getAmbientLevel(lyr as integer) as integer
        declare sub setAmbientLevel(lyr as integer, col as integer)
        
        declare sub saveMapState() 
        declare sub loadMapState() 

        declare sub enablePortal(portalName as string)
        declare sub disablePortal(portalName as string)
       
        dim as integer justLoaded
    private:
        declare sub prepareWindyMistLayers()
        declare sub processLights()
        declare sub processMist()
        declare sub putDispatch(scnbuff as integer ptr,_
                                block as Level_VisBlock,_
                                x as integer, y as integer,_
                                tilePos_x as integer, tilePos_y as integer,_
                                cam_x as integer, cam_y as integer)
                                
        declare sub splodeBlockReact(xs as integer, ys as integer)
        declare sub modBlockDestruct(lyr as integer, xs as integer, ys as integer)

        dim as integer reconnect
        dim as ushort ptr coldata
        dim as string lvlName
        dim as double auroraTranslate
        dim as ushort lvlWidth
        dim as ushort lvlHeight
        dim as ushort snowfall
        dim as ushort lvlCenterX
        dim as ushort lvlCenterY
        dim as objectLink link
        dim as string loadedMusic
        dim as ushort default_x
        dim as ushort default_y
        dim as ubyte ptr curDestBlocks
        dim as integer noVisuals
        dim as LightPair ptr ptr lightList
        dim as integer lightList_N
        dim as integer shouldLightObjects
        dim as integer objectAmbientLevel
        dim as integer drawAurora
        dim as integer hiddenObjectAmbientLevel
        dim as zimage auroraTexture
        dim as integer ptr smokeTexture
        dim as integer highestLayerIndex
        dim as double fadeOut
        dim as integer fadeDir
        

        
        dim as ushort windyMist
        dim as MistLayer_t ptr windyMistLayers
        dim as integer windyMistLayers_n
        dim as zimage mistTexture
        
        dim as BoundingBox_t portalZones(0 to MAX_ZONES - 1)
        dim as integer       portalZonesNum
        
        dim as Level_Tileset ptr tilesets
        dim as ushort            tilesets_N
        
        dim as Level_VisBlock  ptr ptr blocks
        dim as Level_LayerData ptr     layerData
        dim as ushort                  blocks_N
        
        dim as List foreground_layer
        dim as List background_layer
        dim as List active_layer
        dim as List activeCover_layer
        dim as List activeFront_layer
        
        dim as Hashtable groups
        
        dim as EffectController_ ptr graphicFX_
        
        dim as Hash2D falloutZones
        static as integer ptr falloutTex(0 to 2)
        
        #ifdef DEBUG
			static as integer ptr collisionBlox
        #endif

        dim as Hashtable portalLookup
        dim as Hash2D portals
        dim as integer pendingPortalSwitch
end type


#endif
