#include "doublehash.bi"
#include "crt.bi"


#define MIN_CELLS 4
#define MAX_CAPACITY 0.65
#define EXPAND_FACTOR 2


constructor DoubleHash()
    construct_()
end constructor
constructor DoubleHash(datasize as uinteger)
    construct_()
    init(datasize)
end constructor
sub DoubleHash.construct_()
    data1_ = 0
    data2_ = 0    
    numObjects = 0
end sub
destructor DoubleHash()
    clean()
end destructor

sub DoubleHash.init(datasize as uinteger)
    dim as integer i
    clean()
    resetRoll()
    dataSizeBytes = datasize
    numCells1 = MIN_CELLS
    numCells2 = MIN_CELLS
    data1_ = allocate(sizeof(DoubleHashNode_t ptr) * numCells1)
    data2_ = allocate(sizeof(DoubleHashNode_t ptr) * numCells2)
    for i = 0 to numCells1 - 1
        data1_[i] = 0
    next i    
    for i = 0 to numCells2 - 1
        data2_[i] = 0
    next i     
end sub


function DoubleHash.insert(key1 as integer, key2 as integer, data_ as any ptr) as any ptr
    dim as uinteger keyLoc1, keyLoc2
    dim as DoubleHashNode_t ptr newNode1, newNode2
    dim as DoubleHashFrame_t ptr frame_
    
    keyLoc1 = hashInteger1(key1)
    keyLoc2 = hashInteger2(key2)

    frame_ = allocate(sizeof(DoubleHashFrame_t))
    frame_->key_type1 = KEY_INTEGER
    frame_->key_type2 = KEY_INTEGER
    
    frame_->data1.key_integer = key1
    
    frame_->data2.key_integer = key2
    
    frame_->data_ = allocate(dataSizeBytes)
    memcpy(frame_->data_, data_, dataSizeBytes)

    newNode1 = allocate(sizeof(DoubleHashNode_t))
    newNode2 = allocate(sizeof(DoubleHashNode_t))
    newNode1->data_ = frame_
    newNode2->data_ = frame_
    
    if this.data1_[keyLoc1] = 0 then
        newNode1->next_ = 0
    else
        newNode1->next_ = this.data1_[keyLoc1]
        this.data1_[keyLoc1]->last_ = newNode1
    end if
    if this.data2_[keyLoc2] = 0 then
        newNode2->next_ = 0
    else
        newNode2->next_ = this.data2_[keyLoc2]
        this.data2_[keyLoc2]->last_ = newNode2
    end if
    newNode1->last_ = 0
    newNode2->last_ = 0
    newNode1->sibling_ = newNode2
    newNode2->sibling_ = newNode1
    newNode1->index = keyLoc1
    newNode2->index = keyLoc2
    this.data1_[keyLoc1] = newNode1
    this.data2_[keyLoc2] = newNode2
    
    numObjects += 1
    
    rehash1()
    rehash2()
    return frame_->data_
end function
function DoubleHash.insert(key1 as string , key2 as integer, data_ as any ptr) as any ptr
    dim as uinteger keyLoc1, keyLoc2
    dim as DoubleHashNode_t ptr newNode1, newNode2
    dim as DoubleHashFrame_t ptr frame_
    
    keyLoc1 = hashString1(key1)
    keyLoc2 = hashInteger2(key2)

    frame_ = allocate(sizeof(DoubleHashFrame_t))
    frame_->key_type1 = KEY_STRING
    frame_->key_type2 = KEY_INTEGER
    
    frame_->data1.key_string = allocate(len(key1) + 1)
    *(frame_->data1.key_string) = key1
    
    frame_->data2.key_integer = key2
    
    frame_->data_ = allocate(dataSizeBytes)
    memcpy(frame_->data_, data_, dataSizeBytes)

    newNode1 = allocate(sizeof(DoubleHashNode_t))
    newNode2 = allocate(sizeof(DoubleHashNode_t))
    newNode1->data_ = frame_
    newNode2->data_ = frame_
    
    if this.data1_[keyLoc1] = 0 then
        newNode1->next_ = 0
    else
        newNode1->next_ = this.data1_[keyLoc1]
        this.data1_[keyLoc1]->last_ = newNode1
    end if
    if this.data2_[keyLoc2] = 0 then
        newNode2->next_ = 0
    else
        newNode2->next_ = this.data2_[keyLoc2]
        this.data2_[keyLoc2]->last_ = newNode2
    end if
    newNode1->last_ = 0
    newNode2->last_ = 0
    newNode1->sibling_ = newNode2
    newNode2->sibling_ = newNode1
    newNode1->index = keyLoc1
    newNode2->index = keyLoc2
    this.data1_[keyLoc1] = newNode1
    this.data2_[keyLoc2] = newNode2
    
    numObjects += 1
    
    rehash1()
    rehash2()
    return frame_->data_

end function
function DoubleHash.insert(key1 as integer, key2 as string , data_ as any ptr) as any ptr
    dim as uinteger keyLoc1, keyLoc2
    dim as DoubleHashNode_t ptr newNode1, newNode2
    dim as DoubleHashFrame_t ptr frame_
    
    keyLoc1 = hashInteger1(key1)
    keyLoc2 = hashString2(key2)

    frame_ = allocate(sizeof(DoubleHashFrame_t))
    frame_->key_type1 = KEY_INTEGER
    frame_->key_type2 = KEY_STRING
    
    frame_->data1.key_integer = key1
    
    frame_->data2.key_string = allocate(len(key2) + 1)
    *(frame_->data2.key_string) = key2
    
    frame_->data_ = allocate(dataSizeBytes)
    memcpy(frame_->data_, data_, dataSizeBytes)

    newNode1 = allocate(sizeof(DoubleHashNode_t))
    newNode2 = allocate(sizeof(DoubleHashNode_t))
    newNode1->data_ = frame_
    newNode2->data_ = frame_
    
    if this.data1_[keyLoc1] = 0 then
        newNode1->next_ = 0
    else
        newNode1->next_ = this.data1_[keyLoc1]
        this.data1_[keyLoc1]->last_ = newNode1
    end if
    if this.data2_[keyLoc2] = 0 then
        newNode2->next_ = 0
    else
        newNode2->next_ = this.data2_[keyLoc2]
        this.data2_[keyLoc2]->last_ = newNode2
    end if
    newNode1->last_ = 0
    newNode2->last_ = 0
    newNode1->sibling_ = newNode2
    newNode2->sibling_ = newNode1
    newNode1->index = keyLoc1
    newNode2->index = keyLoc2
    this.data1_[keyLoc1] = newNode1
    this.data2_[keyLoc2] = newNode2
    
    numObjects += 1
    
    rehash1()
    rehash2()
    return frame_->data_

end function
function DoubleHash.insert(key1 as string , key2 as string , data_ as any ptr) as any ptr
    dim as uinteger keyLoc1, keyLoc2
    dim as DoubleHashNode_t ptr newNode1, newNode2
    dim as DoubleHashFrame_t ptr frame_
    
    keyLoc1 = hashString1(key1)
    keyLoc2 = hashString2(key2)

    frame_ = allocate(sizeof(DoubleHashFrame_t))
    frame_->key_type1 = KEY_STRING
    frame_->key_type2 = KEY_STRING
    
    frame_->data1.key_string = allocate(len(key1) + 1)
    *(frame_->data1.key_string) = key1
    
    frame_->data2.key_string = allocate(len(key2) + 1)
    *(frame_->data2.key_string) = key2
    
    frame_->data_ = allocate(dataSizeBytes)
    memcpy(frame_->data_, data_, dataSizeBytes)

    newNode1 = allocate(sizeof(DoubleHashNode_t))
    newNode2 = allocate(sizeof(DoubleHashNode_t))
    newNode1->data_ = frame_
    newNode2->data_ = frame_
    
    if this.data1_[keyLoc1] = 0 then
        newNode1->next_ = 0
    else
        newNode1->next_ = this.data1_[keyLoc1]
        this.data1_[keyLoc1]->last_ = newNode1
    end if
    if this.data2_[keyLoc2] = 0 then
        newNode2->next_ = 0
    else
        newNode2->next_ = this.data2_[keyLoc2]
        this.data2_[keyLoc2]->last_ = newNode2
    end if
    newNode1->last_ = 0
    newNode2->last_ = 0
    newNode1->sibling_ = newNode2
    newNode2->sibling_ = newNode1
    newNode1->index = keyLoc1
    newNode2->index = keyLoc2
    this.data1_[keyLoc1] = newNode1
    this.data2_[keyLoc2] = newNode2
    
    numObjects += 1
    
    rehash1()
    rehash2()
    return frame_->data_

end function      

sub DoubleHash.removeKey1(key1 as integer)
    dim as uinteger keyLoc1
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr sibling
    dim as DoubleHashNode_t ptr nextNode
        
    keyLoc1 = hashInteger1(key1) 
    
    curNode = data1_[keyLoc1]
    while curNode <> 0
        if curNode->data_->key_type1 = KEY_INTEGER then
            if curNode->data_->data1.key_integer = key1 then
                
                nextNode = curNode->next_
                if nextNode then nextNode->last_ = curNode->last_
                if curNode->last_ then 
                    curNode->last_->next_ = nextNode
                else
                    this.data1_[keyLoc1] = curNode->next_                
                end if
                
          
                sibling = curNode->sibling_
                if sibling->next_ then sibling->next_->last_ = sibling->last_
                if sibling->last_ then 
                    sibling->last_->next_ = sibling->next_
                else
                    this.data2_[sibling->index] = sibling->next_
                end if
                
                
                
                deallocate(sibling)
                
                deallocate(curNode->data_->data_)
                if curNode->data_->key_type2 = KEY_STRING then deallocate(curNode->data_->data2.key_string)
                deallocate(curNode->data_)
                
                deallocate(curNode)
                
                numObjects -= 1
                if nextNode = 0 then exit sub
                curNode = nextNode
            else
                curNode = curNode->next_            
            end if
        else
            curNode = curNode->next_
        end if
    wend    
end sub
sub DoubleHash.removeKey1(key1 as string)
    dim as uinteger keyLoc1
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr sibling
    dim as DoubleHashNode_t ptr nextNode
        
    keyLoc1 = hashString1(key1) 
    
    curNode = data1_[keyLoc1]
    while curNode <> 0
        if curNode->data_->key_type1 = KEY_STRING then
            if *(curNode->data_->data1.key_string) = key1 then
                
                nextNode = curNode->next_
                if nextNode then nextNode->last_ = curNode->last_
                if curNode->last_ then 
                    curNode->last_->next_ = nextNode
                else
                    this.data1_[keyLoc1] = curNode->next_                
                end if
            
                sibling = curNode->sibling_
                if sibling->next_ then sibling->next_->last_ = sibling->last_
                if sibling->last_ then 
                    sibling->last_->next_ = sibling->next_
                else
                    this.data2_[sibling->index] = sibling->next_
                end if
                
                deallocate(sibling)
                
                deallocate(curNode->data_->data_)
                deallocate(curNode->data_->data1.key_string)
                if curNode->data_->key_type2 = KEY_STRING then deallocate(curNode->data_->data2.key_string)
                deallocate(curNode->data_)
                
                deallocate(curNode)
                
                numObjects -= 1
                if nextNode = 0 then exit sub
                curNode = nextNode
            else
                curNode = curNode->next_            
            end if
        else
            curNode = curNode->next_
        end if
    wend        
end sub
sub DoubleHash.removeKey2(key2 as integer)
    dim as uinteger keyLoc2
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr sibling
    dim as DoubleHashNode_t ptr nextNode
        
    keyLoc2 = hashInteger2(key2) 
    
    curNode = data2_[keyLoc2]
    while curNode <> 0
        if curNode->data_->key_type2 = KEY_INTEGER then
            if curNode->data_->data2.key_integer = key2 then
                
                nextNode = curNode->next_
                if nextNode then nextNode->last_ = curNode->last_
                if curNode->last_ then 
                    curNode->last_->next_ = nextNode
                else
                    this.data2_[keyLoc2] = curNode->next_                
                end if
            
                sibling = curNode->sibling_
                if sibling->next_ then sibling->next_->last_ = sibling->last_
                if sibling->last_ then 
                    sibling->last_->next_ = sibling->next_
                else
                    this.data1_[sibling->index] = sibling->next_
                end if
                
                deallocate(sibling)
                
                deallocate(curNode->data_->data_)
                if curNode->data_->key_type1 = KEY_STRING then deallocate(curNode->data_->data1.key_string)
                deallocate(curNode->data_)
                
                deallocate(curNode)
                
                numObjects -= 1
                if nextNode = 0 then exit sub
                curNode = nextNode
            else
                curNode = curNode->next_            
            end if
        else
            curNode = curNode->next_
        end if
    wend       
end sub
sub DoubleHash.removeKey2(key2 as string)  
    dim as uinteger keyLoc2
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr sibling
    dim as DoubleHashNode_t ptr nextNode
        
    keyLoc2 = hashString2(key2) 
    
    curNode = data2_[keyLoc2]
    while curNode <> 0
        if curNode->data_->key_type2 = KEY_STRING then
            if *(curNode->data_->data2.key_string) = key2 then
                
                nextNode = curNode->next_
                if nextNode then nextNode->last_ = curNode->last_
                if curNode->last_ then 
                    curNode->last_->next_ = nextNode
                else
                    this.data2_[keyLoc2] = curNode->next_                
                end if
            
                sibling = curNode->sibling_
                if sibling->next_ then sibling->next_->last_ = sibling->last_
                if sibling->last_ then 
                    sibling->last_->next_ = sibling->next_
                else
                    this.data1_[sibling->index] = sibling->next_
                end if
                
                deallocate(sibling)
                
                deallocate(curNode->data_->data_)
                deallocate(curNode->data_->data2.key_string)
                if curNode->data_->key_type1 = KEY_STRING then deallocate(curNode->data_->data1.key_string)
                deallocate(curNode->data_)
                
                deallocate(curNode)
                
                numObjects -= 1
                if nextNode = 0 then exit sub
                curNode = nextNode
            else
                curNode = curNode->next_            
            end if
        else
            curNode = curNode->next_
        end if
    wend          
end sub      

sub DoubleHash.remove(key1 as integer, key2 as integer)
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr sibling

    if numCells1 > numCells2 then
        keyLoc = hashInteger1(key1)       
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_INTEGER then
                if curNode->data_->data1.key_integer = key1 then
                    if curNode->data_->key_type2 = KEY_INTEGER then
                        if curNode->data_->data2.key_integer = key2 then
                            if curNode->next_ then curNode->next_->last_ = curNode->last_
                            if curNode->last_ then 
                                curNode->last_->next_ = curNode->next_
                            else
                                this.data1_[keyLoc] = curNode->next_                
                            end if
                            sibling = curNode->sibling_
                            if sibling->next_ then sibling->next_->last_ = sibling->last_
                            if sibling->last_ then 
                                sibling->last_->next_ = sibling->next_
                            else
                                this.data2_[sibling->index] = sibling->next_
                            end if
                            deallocate(sibling)
                            deallocate(curNode->data_->data_)
                            deallocate(curNode->data_)
                            deallocate(curNode)
                            numObjects -= 1
                            exit sub
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_            
        wend       
    else
        keyLoc = hashInteger2(key2)       
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_INTEGER then
                if curNode->data_->data2.key_integer = key2 then
                    if curNode->data_->key_type1 = KEY_INTEGER then
                        if curNode->data_->data1.key_integer = key1 then
                            if curNode->next_ then curNode->next_->last_ = curNode->last_
                            if curNode->last_ then 
                                curNode->last_->next_ = curNode->next_
                            else
                                this.data2_[keyLoc] = curNode->next_                
                            end if
                            sibling = curNode->sibling_
                            if sibling->next_ then sibling->next_->last_ = sibling->last_
                            if sibling->last_ then 
                                sibling->last_->next_ = sibling->next_
                            else
                                this.data1_[sibling->index] = sibling->next_
                            end if
                            deallocate(sibling)
                            deallocate(curNode->data_->data_)
                            deallocate(curNode->data_)
                            deallocate(curNode)
                            numObjects -= 1
                            exit sub
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_            
        wend    
    end if
end sub
sub DoubleHash.remove(key1 as string , key2 as integer)
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr sibling

    if numCells1 > numCells2 then
        keyLoc = hashString1(key1)       
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_STRING then
                if *(curNode->data_->data1.key_string) = key1 then
                    if curNode->data_->key_type2 = KEY_INTEGER then
                        if curNode->data_->data2.key_integer = key2 then
                            if curNode->next_ then curNode->next_->last_ = curNode->last_
                            if curNode->last_ then 
                                curNode->last_->next_ = curNode->next_
                            else
                                this.data1_[keyLoc] = curNode->next_                
                            end if
                            sibling = curNode->sibling_
                            if sibling->next_ then sibling->next_->last_ = sibling->last_
                            if sibling->last_ then 
                                sibling->last_->next_ = sibling->next_
                            else
                                this.data2_[sibling->index] = sibling->next_
                            end if
                            deallocate(sibling)
                            deallocate(curNode->data_->data_)
                            deallocate(curNode->data_->data1.key_string)
                            deallocate(curNode->data_)
                            deallocate(curNode)
                            numObjects -= 1
                            exit sub
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_            
        wend       
    else
        keyLoc = hashInteger2(key2)       
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_INTEGER then
                if curNode->data_->data2.key_integer = key2 then
                    if curNode->data_->key_type1 = KEY_STRING then
                        if *(curNode->data_->data1.key_string) = key1 then
                            if curNode->next_ then curNode->next_->last_ = curNode->last_
                            if curNode->last_ then 
                                curNode->last_->next_ = curNode->next_
                            else
                                this.data2_[keyLoc] = curNode->next_                
                            end if
                            sibling = curNode->sibling_
                            if sibling->next_ then sibling->next_->last_ = sibling->last_
                            if sibling->last_ then 
                                sibling->last_->next_ = sibling->next_
                            else
                                this.data1_[sibling->index] = sibling->next_
                            end if
                            deallocate(sibling)
                            deallocate(curNode->data_->data_)
                            deallocate(curNode->data_->data1.key_string)
                            deallocate(curNode->data_)
                            deallocate(curNode)
                            numObjects -= 1
                            exit sub
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_            
        wend    
    end if
end sub
sub DoubleHash.remove(key1 as integer, key2 as string )
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr sibling

    if numCells1 > numCells2 then
        keyLoc = hashInteger1(key1)       
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_INTEGER then
                if curNode->data_->data1.key_integer = key1 then
                    if curNode->data_->key_type2 = KEY_STRING then
                        if *(curNode->data_->data2.key_string) = key2 then
                            if curNode->next_ then curNode->next_->last_ = curNode->last_
                            if curNode->last_ then 
                                curNode->last_->next_ = curNode->next_
                            else
                                this.data1_[keyLoc] = curNode->next_                
                            end if
                            sibling = curNode->sibling_
                            if sibling->next_ then sibling->next_->last_ = sibling->last_
                            if sibling->last_ then 
                                sibling->last_->next_ = sibling->next_
                            else
                                this.data2_[sibling->index] = sibling->next_
                            end if
                            deallocate(sibling)
                            deallocate(curNode->data_->data_)
                            deallocate(curNode->data_->data2.key_string)
                            deallocate(curNode->data_)
                            deallocate(curNode)
                            numObjects -= 1
                            exit sub
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_            
        wend       
    else
        keyLoc = hashString2(key2)       
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_STRING then
                if *(curNode->data_->data2.key_string) = key2 then
                    if curNode->data_->key_type1 = KEY_INTEGER then
                        if curNode->data_->data1.key_integer = key1 then
                            if curNode->next_ then curNode->next_->last_ = curNode->last_
                            if curNode->last_ then 
                                curNode->last_->next_ = curNode->next_
                            else
                                this.data2_[keyLoc] = curNode->next_                
                            end if
                            sibling = curNode->sibling_
                            if sibling->next_ then sibling->next_->last_ = sibling->last_
                            if sibling->last_ then 
                                sibling->last_->next_ = sibling->next_
                            else
                                this.data1_[sibling->index] = sibling->next_
                            end if
                            deallocate(sibling)
                            deallocate(curNode->data_->data_)
                            deallocate(curNode->data_->data2.key_string)
                            deallocate(curNode->data_)
                            deallocate(curNode)
                            numObjects -= 1
                            exit sub
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_            
        wend    
    end if
end sub
sub DoubleHash.remove(key1 as string , key2 as string ) 
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr sibling

    if numCells1 > numCells2 then
        keyLoc = hashString1(key1)       
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_STRING then
                if *(curNode->data_->data1.key_string) = key1 then
                    if curNode->data_->key_type2 = KEY_STRING then
                        if *(curNode->data_->data2.key_string) = key2 then
                            if curNode->next_ then curNode->next_->last_ = curNode->last_
                            if curNode->last_ then 
                                curNode->last_->next_ = curNode->next_
                            else
                                this.data1_[keyLoc] = curNode->next_                
                            end if
                            sibling = curNode->sibling_
                            if sibling->next_ then sibling->next_->last_ = sibling->last_
                            if sibling->last_ then 
                                sibling->last_->next_ = sibling->next_
                            else
                                this.data2_[sibling->index] = sibling->next_
                            end if
                            deallocate(sibling)
                            deallocate(curNode->data_->data_)
                            deallocate(curNode->data_->data2.key_string)
                            deallocate(curNode->data_->data1.key_string)
                            deallocate(curNode->data_)
                            deallocate(curNode)
                            numObjects -= 1
                            exit sub
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_            
        wend       
    else
        keyLoc = hashString2(key2)       
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_STRING then
                if *(curNode->data_->data2.key_string) = key2 then
                    if curNode->data_->key_type1 = KEY_STRING then
                        if *(curNode->data_->data1.key_string) = key1 then
                            if curNode->next_ then curNode->next_->last_ = curNode->last_
                            if curNode->last_ then 
                                curNode->last_->next_ = curNode->next_
                            else
                                this.data2_[keyLoc] = curNode->next_                
                            end if
                            sibling = curNode->sibling_
                            if sibling->next_ then sibling->next_->last_ = sibling->last_
                            if sibling->last_ then 
                                sibling->last_->next_ = sibling->next_
                            else
                                this.data1_[sibling->index] = sibling->next_
                            end if
                            deallocate(sibling)
                            deallocate(curNode->data_->data_)
                            deallocate(curNode->data_->data2.key_string)
                            deallocate(curNode->data_->data1.key_string)                            
                            deallocate(curNode->data_)
                            deallocate(curNode)
                            numObjects -= 1
                            exit sub
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_            
        wend    
    end if
end sub  

function DoubleHash.retrieveKey1(key1 as integer, byref ret_ as any ptr ptr) as integer
    dim as uinteger keyLoc
    dim as integer ret_n, ret_cap 
    dim as DoubleHashNode_t ptr curNode

    ret_n = 0
    ret_cap = 5
    ret_ = allocate(sizeof(any ptr) * ret_cap)
    
    keyLoc = hashInteger1(key1)
    curNode = data1_[keyLoc]
    while curNode <> 0
        if curNode->data_->key_type1 = KEY_INTEGER then
            if curNode->data_->data1.key_integer = key1 then
                if ret_N >= ret_cap then
                    ret_cap += 5
                    ret_ = reallocate(ret_, sizeof(any ptr) * ret_cap)
                end if
                ret_[ret_N] = curNode->data_->data_
                ret_N += 1
            end if
        end if
        curNode = curNode->next_
    wend
    if ret_N = 0 then deallocate(ret_)
    return ret_N
end function
function DoubleHash.retrieveKey1(key1 as string , byref ret_ as any ptr ptr) as integer
    dim as uinteger keyLoc
    dim as integer ret_n, ret_cap 
    dim as DoubleHashNode_t ptr curNode

    ret_n = 0
    ret_cap = 5
    ret_ = allocate(sizeof(any ptr) * ret_cap)
    
    keyLoc = hashString1(key1)
    curNode = data1_[keyLoc]
    while curNode <> 0
        if curNode->data_->key_type1 = KEY_STRING then
            if *(curNode->data_->data1.key_string) = key1 then
                if ret_N >= ret_cap then
                    ret_cap += 5
                    ret_ = reallocate(ret_, sizeof(any ptr) * ret_cap)
                end if
                ret_[ret_N] = curNode->data_->data_
                ret_N += 1
            end if
        end if
        curNode = curNode->next_
    wend
    if ret_N = 0 then deallocate(ret_)
    return ret_N
end function
function DoubleHash.retrieveKey2(key2 as integer, byref ret_ as any ptr ptr) as integer
    dim as uinteger keyLoc
    dim as integer ret_n, ret_cap 
    dim as DoubleHashNode_t ptr curNode

    ret_n = 0
    ret_cap = 5
    ret_ = allocate(sizeof(any ptr) * ret_cap)
    
    keyLoc = hashInteger2(key2)
    curNode = data2_[keyLoc]
    while curNode <> 0
        if curNode->data_->key_type2 = KEY_INTEGER then
            if curNode->data_->data2.key_integer = key2 then
                if ret_N >= ret_cap then
                    ret_cap += 5
                    ret_ = reallocate(ret_, sizeof(any ptr) * ret_cap)
                end if
                ret_[ret_N] = curNode->data_->data_
                ret_N += 1
            end if
        end if
        curNode = curNode->next_
    wend
    if ret_N = 0 then deallocate(ret_)
    return ret_N
end function
function DoubleHash.retrieveKey2(key2 as string , byref ret_ as any ptr ptr) as integer 
    dim as uinteger keyLoc
    dim as integer ret_n, ret_cap 
    dim as DoubleHashNode_t ptr curNode

    ret_n = 0
    ret_cap = 5
    ret_ = allocate(sizeof(any ptr) * ret_cap)
    
    keyLoc = hashString2(key2)
    curNode = data2_[keyLoc]
    while curNode <> 0
        if curNode->data_->key_type2 = KEY_STRING then
            if *(curNode->data_->data2.key_string) = key2 then
                if ret_N >= ret_cap then
                    ret_cap += 5
                    ret_ = reallocate(ret_, sizeof(any ptr) * ret_cap)
                end if
                ret_[ret_N] = curNode->data_->data_
                ret_N += 1
            end if
        end if
        curNode = curNode->next_
    wend
    if ret_N = 0 then deallocate(ret_)
    return ret_N
end function   
 
function DoubleHash.retrieve(key1 as integer, key2 as integer) as any ptr
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    if numCells1 > numCells2 then
        keyLoc = hashInteger1(key1)
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_INTEGER then
                if curNode->data_->data1.key_integer = key1 then
                    if curNode->data_->key_type2 = KEY_INTEGER then
                        if curNode->data_->data2.key_integer = key2 then                    
                            return curNode->data_->data_
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend    
    else
        keyLoc = hashInteger2(key2)
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_INTEGER then
                if curNode->data_->data2.key_integer = key2 then
                    if curNode->data_->key_type1 = KEY_INTEGER then
                        if curNode->data_->data1.key_integer = key1 then                    
                            return curNode->data_->data_
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend     
    end if  
    return 0
end function
function DoubleHash.retrieve(key1 as string , key2 as integer) as any ptr
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    if numCells1 > numCells2 then
        keyLoc = hashString1(key1)
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_STRING then
                if *(curNode->data_->data1.key_string) = key1 then
                    if curNode->data_->key_type2 = KEY_INTEGER then
                        if curNode->data_->data2.key_integer = key2 then                    
                            return curNode->data_->data_
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend    
    else
        keyLoc = hashInteger2(key2)
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_INTEGER then
                if curNode->data_->data2.key_integer = key2 then
                    if curNode->data_->key_type1 = KEY_STRING then
                        if *(curNode->data_->data1.key_string) = key1 then                    
                            return curNode->data_->data_
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend     
    end if  
    return 0
end function
function DoubleHash.retrieve(key1 as integer, key2 as string ) as any ptr
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    if numCells1 > numCells2 then
        keyLoc = hashInteger1(key1)
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_INTEGER then
                if curNode->data_->data1.key_integer = key1 then
                    if curNode->data_->key_type2 = KEY_STRING then
                        if *(curNode->data_->data2.key_string) = key2 then                    
                            return curNode->data_->data_
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend    
    else
        keyLoc = hashString2(key2)
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_STRING then
                if *(curNode->data_->data2.key_string) = key2 then
                    if curNode->data_->key_type1 = KEY_INTEGER then
                        if curNode->data_->data1.key_integer = key1 then                    
                            return curNode->data_->data_
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend     
    end if  
    return 0
end function
function DoubleHash.retrieve(key1 as string , key2 as string ) as any ptr
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    if numCells1 > numCells2 then
        keyLoc = hashString1(key1)
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_STRING then
                if *(curNode->data_->data1.key_string) = key1 then
                    if curNode->data_->key_type2 = KEY_STRING then
                        if *(curNode->data_->data2.key_string) = key2 then                    
                            return curNode->data_->data_
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend    
    else
        keyLoc = hashString2(key2)
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_STRING then
                if *(curNode->data_->data2.key_string) = key2 then
                    if curNode->data_->key_type1 = KEY_STRING then
                        if *(curNode->data_->data1.key_string) = key1 then                    
                            return curNode->data_->data_
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend     
    end if  
    return 0
end function

function DoubleHash.existsKey1(key1 as integer) as integer
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    keyLoc = hashInteger1(key1)
    curNode = data1_[keyLoc]
    while curNode <> 0
        if curNode->data_->key_type1 = KEY_INTEGER then
            if curNode->data_->data1.key_integer = key1 then
                return 1
            end if
        end if
        curNode = curNode->next_
    wend
    return 0
end function
function DoubleHash.existsKey1(key1 as string ) as integer
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    keyLoc = hashString1(key1)
    curNode = data1_[keyLoc]
    while curNode <> 0
        if curNode->data_->key_type1 = KEY_STRING then
            if *(curNode->data_->data1.key_string) = key1 then
                return 1
            end if
        end if
        curNode = curNode->next_
    wend
    return 0
end function
function DoubleHash.existsKey2(key2 as integer) as integer
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    keyLoc = hashInteger2(key2)
    curNode = data2_[keyLoc]
    while curNode <> 0
        if curNode->data_->key_type2 = KEY_INTEGER then
            if curNode->data_->data2.key_integer = key2 then
                return 1
            end if
        end if
        curNode = curNode->next_
    wend
    return 0
end function
function DoubleHash.existsKey2(key2 as string ) as integer  
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    keyLoc = hashString2(key2)
    curNode = data2_[keyLoc]
    while curNode <> 0
        if curNode->data_->key_type2 = KEY_STRING then
            if *(curNode->data_->data2.key_string) = key2 then
                return 1
            end if
        end if
        curNode = curNode->next_
    wend
    return 0
end function   
function DoubleHash.exists(key1 as integer, key2 as integer) as integer
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    if numCells1 > numCells2 then
        keyLoc = hashInteger1(key1)
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_INTEGER then
                if curNode->data_->data1.key_integer = key1 then
                    if curNode->data_->key_type2 = KEY_INTEGER then
                        if curNode->data_->data2.key_integer = key2 then
                            return 1
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend
    else
        keyLoc = hashInteger2(key2)
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_INTEGER then
                if curNode->data_->data2.key_integer = key2 then
                    if curNode->data_->key_type1 = KEY_INTEGER then
                        if curNode->data_->data1.key_integer = key1 then
                            return 1
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend
    end if
    return 0
end function
function DoubleHash.exists(key1 as string , key2 as integer) as integer
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    if numCells1 > numCells2 then
        keyLoc = hashString1(key1)
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_STRING then
                if *(curNode->data_->data1.key_string) = key1 then
                    if curNode->data_->key_type2 = KEY_INTEGER then
                        if curNode->data_->data2.key_integer = key2 then
                            return 1
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend
    else
        keyLoc = hashInteger2(key2)
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_INTEGER then
                if curNode->data_->data2.key_integer = key2 then
                    if curNode->data_->key_type1 = KEY_STRING then
                        if *(curNode->data_->data1.key_string) = key1 then
                            return 1
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend
    end if
    return 0
end function
function DoubleHash.exists(key1 as integer, key2 as string ) as integer
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    if numCells1 > numCells2 then
        keyLoc = hashInteger1(key1)
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_INTEGER then
                if curNode->data_->data1.key_integer = key1 then
                    if curNode->data_->key_type2 = KEY_STRING then
                        if *(curNode->data_->data2.key_string) = key2 then
                            return 1
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend
    else
        keyLoc = hashString2(key2)
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_STRING then
                if *(curNode->data_->data2.key_string) = key2 then
                    if curNode->data_->key_type1 = KEY_INTEGER then
                        if curNode->data_->data1.key_integer = key1 then
                            return 1
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend
    end if
    return 0
end function
function DoubleHash.exists(key1 as string , key2 as string ) as integer
    dim as uinteger keyLoc
    dim as DoubleHashNode_t ptr curNode

    if numCells1 > numCells2 then
        keyLoc = hashString1(key1)
        curNode = data1_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type1 = KEY_STRING then
                if *(curNode->data_->data1.key_string) = key1 then
                    if curNode->data_->key_type2 = KEY_STRING then
                        if *(curNode->data_->data2.key_string) = key2 then
                            return 1
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend
    else
        keyLoc = hashString2(key2)
        curNode = data2_[keyLoc]
        while curNode <> 0
            if curNode->data_->key_type2 = KEY_STRING then
                if *(curNode->data_->data2.key_string) = key2 then
                    if curNode->data_->key_type1 = KEY_STRING then
                        if *(curNode->data_->data1.key_string) = key1 then
                            return 1
                        end if
                    end if
                end if
            end if
            curNode = curNode->next_
        wend
    end if
    return 0
end function

function DoubleHash.getSize() as integer
    return numObjects
end function
function DoubleHash.getDataSizeBytes() as integer
    return dataSizeBytes
end function
function DoubleHash.rollGetKey1Type() as DoubleHashNodeKeyType_e
    if lastRollFrame then return lastRollFrame->key_type1
    return KEY_INVALID
end function
function DoubleHash.rollGetKey1String() as string
    if lastRollFrame then 
        if lastRollFrame->key_type1 = KEY_STRING then
            return *(lastRollFrame->data1.key_string)
        end if
    end if
    return ""
end function
function DoubleHash.rollGetKey1Integer() as integer
    if lastRollFrame then 
        if lastRollFrame->key_type1 = KEY_INTEGER then
            return lastRollFrame->data1.key_integer
        end if
    end if
    return 0
end function
function DoubleHash.rollGetKey2Type() as DoubleHashNodeKeyType_e
    if lastRollFrame then return lastRollFrame->key_type2
    return KEY_INVALID
end function
function DoubleHash.rollGetKey2String() as string
    if lastRollFrame then 
        if lastRollFrame->key_type2 = KEY_STRING then
            return *(lastRollFrame->data2.key_string)
        end if
    end if
    return ""
end function
function DoubleHash.rollGetKey2Integer() as integer
    if lastRollFrame then 
        if lastRollFrame->key_type2 = KEY_INTEGER then
            return lastRollFrame->data2.key_integer
        end if
    end if
    return 0
end function
sub DoubleHash.resetRoll()
    curRollNode = 0
    curRollIndx = 0
    curRollTble = 0
    lastRollFrame = 0
end sub
function DoubleHash.roll() as any ptr
    dim as any ptr cn
    dim as integer i
    
    if curRollTble = 0 then
        if numCells1 < numCells2 then
            curRollTble = 1
        else
            curRollTble = 2
        end if
    end if
    
    if curRollNode <> 0 then 
        cn = curRollNode->data_->data_
        lastRollFrame = curRollNode->data_
        curRollNode = curRollNode->next_
        return cn
    else
        if curRollTble = 1 then
            for i = curRollIndx to numCells1 - 1
                if data1_[i] <> 0 then
                    curRollNode = data1_[i]
                    curRollIndx = i + 1
                    cn = curRollNode->data_->data_
                    lastRollFrame = curRollNode->data_
                    curRollNode = curRollNode->next_
                    return cn
                end if
            next i
        else 'curRollTble = 2
            for i = curRollIndx to numCells2 - 1
                if data2_[i] <> 0 then
                    curRollNode = data2_[i]
                    curRollIndx = i + 1
                    cn = curRollNode->data_->data_
                    lastRollFrame = curRollNode->data_
                    curRollNode = curRollNode->next_
                    return cn
                end if
            next i        
        end if
        lastRollFrame = 0
        return 0
    end if   
end function
sub DoubleHash.flush()
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr nextNode
    dim as integer i
    
    if numObjects > 0 then
    
        for i = 0 to numCells1 - 1
            curNode = data1_[i]
            while curNode <> 0 
                nextNode = curNode->next_
                if curNode->data_->key_type1 = KEY_STRING then deallocate(curNode->data_->data1.key_string)
                if curNode->data_->key_type2 = KEY_STRING then deallocate(curNode->data_->data2.key_string)
                deallocate(curNode->data_->data_)
                deallocate(curNode->data_)
                deallocate(curNode)
                curNode = nextNode
            wend 
        next i
        for i = 0 to numCells2 - 1
            curNode = data2_[i]
            while curNode <> 0 
                nextNode = curNode->next_
                deallocate(curNode)
                curNode = nextNode
            wend 
        next i       
        
        resetRoll()
        numObjects = 0
        for i = 0 to numCells1 - 1
            data1_[i] = 0
        next i    
        for i = 0 to numCells2 - 1
            data2_[i] = 0
        next i    
    end if
end sub

sub DoubleHash.clean()
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr nextNode
    dim as integer i
    
    if numObjects > 0 then
        
        for i = 0 to numCells1 - 1
            curNode = data1_[i]
            while curNode <> 0 
                nextNode = curNode->next_
                if curNode->data_->key_type1 = KEY_STRING then deallocate(curNode->data_->data1.key_string)
                if curNode->data_->key_type2 = KEY_STRING then deallocate(curNode->data_->data2.key_string)
                deallocate(curNode->data_->data_)
                deallocate(curNode->data_)
                deallocate(curNode)
                curNode = nextNode
            wend 
        next i
        for i = 0 to numCells2 - 1
            curNode = data2_[i]
            while curNode <> 0 
                nextNode = curNode->next_
                deallocate(curNode)
                curNode = nextNode
            wend 
        next i       
        
        resetRoll()
        numObjects = 0
        deallocate(data1_)
        deallocate(data2_)
        
    end if
end sub
function DoubleHash.hashString1(key as string) as uinteger
    dim as integer  i
    dim as uinteger hash = 31
    for i = 1 to len(key)
        hash = (hash * 54059) xor (asc(mid(key, i, 1)) * 76963)
    next i
    hash = hash mod numCells1
    return hash
end function
function DoubleHash.hashInteger1(s_key as integer) as uinteger
    dim as uinteger key
    key = s_key
    key = key xor ((key shr 20) xor (key shr 12))
    key = key xor ((key shr 7) xor (key shr 4))
    key = key mod numCells1
    return key
end function
function DoubleHash.hashString2(key as string) as uinteger
    dim as integer  i
    dim as uinteger hash = 31
    for i = 1 to len(key)
        hash = (hash * 54059) xor (asc(mid(key, i, 1)) * 76963)
    next i
    hash = hash mod numCells2
    return hash
end function
function DoubleHash.hashInteger2(s_key as integer) as uinteger
    dim as uinteger key
    key = s_key
    key = key xor ((key shr 20) xor (key shr 12))
    key = key xor ((key shr 7) xor (key shr 4))
    key = key mod numCells2
    return key
end function


sub DoubleHash.rehash1()
    dim as double ratio
    dim as DoubleHashNode_t ptr ptr newData
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr nextNode
    dim as integer oldNumCells
    dim as integer i
    dim as uinteger key
 
    oldNumCells = numCells1
    ratio = cdbl(numObjects) / numCells1
    if ratio > MAX_CAPACITY then
        numCells1 = numCells1 * EXPAND_FACTOR
        newData = allocate(sizeof(DoubleHashNode_t ptr) * numCells1)
        for i = 0 to numCells1 - 1
            newData[i] = 0
        next i
        for i = 0 to oldNumCells - 1
            curNode = data1_[i]
            while curNode <> 0 
                if curNode->data_->key_type1 = KEY_INTEGER then
                    key = hashInteger1(curNode->data_->data1.key_integer)
                elseif curNode->data_->key_type1 = KEY_STRING then
                    key = hashString1(*(curNode->data_->data1.key_string))
                end if
                nextNode = curNode->next_
                
                curNode->index = key
                curNode->next_ = newData[key]
                if curNode->next_ then curNode->next_->last_ = curNode
                newData[key] = curNode
                curNode->last_ = 0
                
                curNode = nextNode
            wend
        next i
        deallocate(data1_)
        data1_ = newData
    end if
end sub
sub DoubleHash.rehash2()
    dim as double ratio
    dim as DoubleHashNode_t ptr ptr newData
    dim as DoubleHashNode_t ptr curNode
    dim as DoubleHashNode_t ptr nextNode
    dim as integer oldNumCells
    dim as integer i
    dim as uinteger key
 
    oldNumCells = numCells2
    ratio = cdbl(numObjects) / numCells1
    if ratio > MAX_CAPACITY then
        numCells2 = numCells2 * EXPAND_FACTOR
        newData = allocate(sizeof(DoubleHashNode_t ptr) * numCells2)
        for i = 0 to numCells2 - 1
            newData[i] = 0
        next i
        for i = 0 to oldNumCells - 1
            curNode = data2_[i]
            while curNode <> 0 
                if curNode->data_->key_type2 = KEY_INTEGER then
                    key = hashInteger2(curNode->data_->data2.key_integer)
                elseif curNode->data_->key_type2 = KEY_STRING then
                    key = hashString2(*(curNode->data_->data2.key_string))
                end if
                nextNode = curNode->next_
                
                curNode->index = key
                curNode->next_ = newData[key]
                if curNode->next_ then curNode->next_->last_ = curNode
                newData[key] = curNode
                curNode->last_ = 0
                
                curNode = nextNode
            wend
        next i
        deallocate(data2_)
        data2_ = newData
    end if
end sub
