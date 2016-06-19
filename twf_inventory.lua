-----------------------------------------------------------------------------
-- Contains classes and extensions related to inventory management. 
--
-- @author Timothy
-----------------------------------------------------------------------------

dofile('twf_movement.lua')

if not twf.inventory then twf.inventory = {} end

-----------------------------------------------------------------------------
-- twf.inventory.ItemDetail
--
-- Wrapper around the object returned from the vanilla turtle.getItemDetail.
-----------------------------------------------------------------------------
if not twf.inventory.ItemDetail then 
  local ItemDetail = {}
  
  -----------------------------------------------------------------------------
  -- The name of the item, such as minecraft:log. Generally in the format 
  -- mod:itemname, but not particularly consistent.
  -----------------------------------------------------------------------------
  ItemDetail.name = nil
  
  -----------------------------------------------------------------------------
  -- The damage of the item. The meaning of this varies from item to item
  -----------------------------------------------------------------------------
  ItemDetail.damage = nil
  
  -----------------------------------------------------------------------------
  -- How many items are in this stack
  -----------------------------------------------------------------------------
  ItemDetail.count = nil
  
  -----------------------------------------------------------------------------
  -- Initializes a new instance of ItemDetail.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local res = turtle.getItemDetail(1)
  --   local iDetail = nil
  --   if res then
  --     iDetail = ItemDetail:new(res)
  --   end
  --   if iDetail then 
  --     -- prints something like minecraft:log:2 x64
  --     print(iDetail:toString())
  --   end
  --
  -- @param o superseding object
  -- @return  a new instance of item detail
  -- @error   if the superseding object is nil, or doesn't have a name, damage, 
  --          or count component.
  -----------------------------------------------------------------------------
  function ItemDetail:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Initializes a new instance of ItemDetail if o is a valid representation of
  -- of an item detail, otherwise returns nil
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local iDetail = ItemDetail:safeNew(turtle.getItemDetail(1))
  --
  -- @param o superseding object
  -- @return  a new instance of item detail, or nil
  -----------------------------------------------------------------------------
  function ItemDetail:safeNew(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of this item detail
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local iDetail = ItemDetail:new({name = 'minecraft:log', damage = 1, count = 1})
  --   -- prints 'minecraft:log:1 x1
  --   print(iDetail:toString())
  --
  -- @return string representation of this item detail
  -----------------------------------------------------------------------------
  function ItemDetail:toString()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns if this item detail refers to the same item (name) as the other 
  -- item detail
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local log = ItemDetail:new({name = 'minecraft:log', damage = 1, count = 1})
  --   local other = ItemDetail:safeNew(turtle.getItemDetail(1))
  --   -- prints true if other is a oak log, birch log, etc.
  --   print(log:lenientItemEquals(other))
  --
  -- @param other the item detail to compare to
  -- @return      boolean true if this item detail refers (leniently) to the 
  --              same item detail as other
  -----------------------------------------------------------------------------
  function ItemDetail:lenientItemEquals(other)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns if this item detail refers to the same item (name and damage) as 
  -- the other item detail
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local birchLog = ItemDetail:new({name = 'minecraft:log', damage = 2, count = 1})
  --   local other = ItemDetail:safeNew(turtle.getItemDetail(1))
  --   -- prints true if slot one is some number of birch logs
  --   print(birchLog:equals(other))
  --
  -- @param other the item detail to compare to
  -- @return      boolean true if this item detail refers (strictly) to the 
  --              same item detail as other
  -----------------------------------------------------------------------------
  
  function ItemDetail:strictItemEquals(other)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this item detail into a string
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local birchLog = ItemDetail:new({name = 'minecraft:log', damage = 2, count = 1})
  --   local serialized = birchLog:serialize()
  --   local unserialized = ItemDetail.unserialize(serialized)
  --
  -- @return string serialization of this item detail
  -----------------------------------------------------------------------------
  function ItemDetail:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes this item detail
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local birchLog = ItemDetail:new({name = 'minecraft:log', damage = 2, count = 1})
  --   local serialized = birchLog:serialize()
  --   local unserialized = ItemDetail.unserialize(serialized)
  --
  -- @param serialized the string serialization from serialize
  -- @return           the item detail that was serialized
  -----------------------------------------------------------------------------
  function ItemDetail.unserialize(serialized)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns if this item detail is logically equivalent to the other item 
  -- detail, including stack size.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local expected = ItemDetail:new({name = 'minecraft:log', damage = 2, count = 64})
  --   local actual = ItemDetail:safeNew(turtle.getItemDetail(1))
  --   -- prints true if slot 1 matches expected, false otherwise
  --   print(expected:equals(actual))
  --
  -- @param other the item detail to compare with
  -- @return      boolean true if other is logically equivalent to this 
  --              instance, false otherwise
  -----------------------------------------------------------------------------
  function ItemDetail:equals(other)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a reasonable hash code of this item detail
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail 
  --   local id1 = ItemDetail:new({name = 'minecraft:log', damage = 2, count = 64})
  --   local id2 = ItemDetail:new({name = 'minecraft:log', damage = 2, count = 64})
  --   -- prints true
  --   print(id1:hashCode() == id2:hashCode())
  --
  -- @return number hash code of this item detail
  -----------------------------------------------------------------------------
  function ItemDetail:hashCode()
    error('Not yet implemented')
  end
  
  twf.inventory.ItemDetail = ItemDetail
end

-----------------------------------------------------------------------------
-- Describes a turtles inventory - 16 slots, starting at 1 and going to 16 
-- inclusive.
-----------------------------------------------------------------------------
if not twf.inventory.Inventory then
  local Inventory = {}
  
  -----------------------------------------------------------------------------
  -- The table of item details, where index 1 is the first object.
  -- 
  -- @type table
  -----------------------------------------------------------------------------
  Inventory.itemDetails = {}
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of inventory
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local inv = Inventory:new()
  --
  -- @param o (optional) superseding object
  -- @return a new instance of Inventory
  -----------------------------------------------------------------------------
  function Inventory:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns the item detail at the specified index, may be nil.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local Inventory = twf.inventory.Inventory
  --   local inv = Inventory:new()
  --   inv:setItemDetailAt(1, ItemDetail:safeNew(turtle.getItemDetail(1)))
  --   -- prints the item detail at turtle slot 1
  --   print(inv:getItemDetailAt(1))
  --
  -- @param index the index, where 1 is top-left and 16 is bottom-right
  -- @return      twf.inventory.ItemDetail at that slot, or nil
  -- @error       if index is less than 1 or greater than 16
  -----------------------------------------------------------------------------
  function Inventory:getItemDetailAt(index)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Sets the item detail at the specified index, may be nil to represent no 
  -- item. A count of 0 is assumed to be nil.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local Inventory = twf.inventory.Inventory
  --   local inv = Inventory:new()
  --   inv:setItemDetailAt(1, ItemDetail:safeNew(turtle.getItemDetail(1)))
  --   -- prints the item detail at turtle slot 1
  --   print(inv:getItemDetailAt(1))
  --
  -- @param index      the index, where 1 is top-left and 16 is bottom-right
  -- @param itemDetail the item detail to setItemDetailAt
  -- @error            if index is less than 1 or greater than 16
  -----------------------------------------------------------------------------
  function Inventory:setItemDetailAt(index, itemDetail)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns how many slots of this inventory are occupied
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local inv = Inventory:new()
  --   -- prints 0
  --   print(inv:fullSlots())
  --
  -- @return number of slots that are occupied in this inventory
  -----------------------------------------------------------------------------
  function Inventory:fullSlots()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns how many slots of this inventory are empty
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local inv = Inventory:new()
  --   -- prints 16
  --   print(inv:emptySlots())
  --
  -- @return number of slots that are empty
  -----------------------------------------------------------------------------
  function Inventory:emptySlots()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns how many slots are in this inventory
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local inv = Inventory:new()
  --   -- prints 16
  --   print(inv:numberOfSlots())
  -- 
  -- @return number of slost in this inventory
  -----------------------------------------------------------------------------
  function Inventory:numberOfSlots()
    return 16
  end
  
  -----------------------------------------------------------------------------
  -- Checks if this inventory contains the specified item, leniently or 
  -- strictly
  -- 
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local log = ItemDetail:new({name = 'minecraft:log', damage = 1, count = 1})
  --   local inv = Inventory:new()
  --   -- prints false
  --   print(inv:contains(log))
  -- 
  -- @param itemDetail the item to search for
  -- @param strict     boolean true if items should be compared strictly, false
  --                   for lenient comparison. Default false
  -- @return           if that item is in this inventory 
  -- @see              twf.inventory.ItemDetail#strictItemEquals(ItemDetail)
  -- @see              twf.inventory.ItemDetail#lenientItemEquals(ItemDetail)
  -----------------------------------------------------------------------------
  function Inventory:contains(itemDetail, strict)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Counts the number of the specified item in this inventory
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local log = ItemDetail:new({name = 'minecraft:log', damage = 1, count = 1})
  --   local inv = Inventory:new()
  --   -- prints 0
  --   print(inv:count(log))
  --
  -- @param itemDetail the item to search for
  -- @param strict     boolean true if items should be compared strictly, false 
  --                   otherwise. Default false
  -- @return           number of that item that is in this inventory, lenient
  -- @see              twf.inventory.ItemDetail#strictItemEquals(ItemDetail)
  -- @see              twf.inventory.ItemDetail#lenientItemEquals(ItemDetail)
  -----------------------------------------------------------------------------
  function Inventory:count(itemDetail, strict)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns the first index of the item detail, or -1
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local log = ItemDetail:new({name = 'minecraft:log', damage = 1, count = 1})
  --   local inv = Inventory:new()
  --   -- prints -1
  --   print(inv:firstIndexOf(log))
  -- 
  -- @param itemDetail the item to search for
  -- @param strict     boolean true if items should be compared strictly, false 
  --                   otherwise. Default false
  -- @return           number of the first index of the item, or -1
  -- @see              twf.inventory.ItemDetail#strictItemEquals(ItemDetail)
  -- @see              twf.inventory.ItemDetail#lenientItemEquals(ItemDetail)
  -----------------------------------------------------------------------------
  function Inventory:firstIndexOf(itemDetail, strict)
    error('Not yet implemented')
  end
  
   -----------------------------------------------------------------------------
  -- Returns the first index of an empty slot, or -1
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local inv = Inventory:new()
  --   -- prints 1
  --   print(inv:firstIndexOfEmptySlot(log))
  --
  -- @return number of the index of the first empty slot, or -1
  -----------------------------------------------------------------------------
  function Inventory:firstIndexOfEmptySlot()
    error('Not yet implemented')
  end
  
  
  -- Serialization
  
  -----------------------------------------------------------------------------
  -- Returns a string serialization of this inventory, that can be unserialized
  -- with unserialize
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local Inventory = twf.inventory.Inventory
  --   local inv = Inventory:new()
  --   local serialized = inv:serialize()
  --   local unserialized = Inventory.unserialize(inv)
  --   -- prints true
  --   print(inv:equals(unserialized))
  --
  -- @return string serialization of this inventory
  -----------------------------------------------------------------------------
  function Inventory:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns the inventory represented by the serialized string
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local Inventory = twf.inventory.Inventory
  --   local inv = Inventory:new()
  --   local serialized = inv:serialize()
  --   local unserialized = Inventory.unserialize(inv)
  --   -- prints true
  --   print(inv:equals(unserialized))
  --
  -- @param serialized the string returned from serialize()
  -- @return           inventory that the string represented
  -----------------------------------------------------------------------------
  function Inventory.unserialize(serialized)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable representation of this inventory. 
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local Inventory = twf.inventory.Inventory
  --   local inv = Inventory:new()
  --   -- prints inventory: empty
  --   print('inventory: ' .. inv:toString())
  --   
  --   inv:setItemDetailAt(1, ItemDetail:new({name = 'minecraft:log', damage: 1, count: 64}))
  --   -- prints inventory: 1/16 slots used (6.25%) {1: minecraft:log:1 x64}
  --   print('inventory: ' .. inv:toString())
  --
  -- @return string representing this inventory
  -----------------------------------------------------------------------------
  function Inventory:toString()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the change in items dofiled for this inventory to match the 
  -- contents of the other inventory. This is always a strict comparison.
  -- 
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local inv1 = Inventory:new()
  --   inv1:setItemDetailAt(1, ItemDetail:new({name = 'minecraft:log', damage: 1, count: 64}))
  --
  --   local inv2 = Inventory:new()
  --   inv2:setItemDetailAt(5, ItemDetail:new({name = 'minecraft:log', damage: 1, count: 16}))
  --   -- prints the table {1 = {name = 'minecraft:log', damage: 1, count: 48}, 2 = {}]
  --   print(textutils.serialize(inv1:changeInItemsToGet(inv2)))
  --
  -- @param other the inventory to compare with
  -- @return      a tuplet with 2 tables - the first containing what needs to 
  --              be added, the second containing what needs to be removed
  -----------------------------------------------------------------------------
  function Inventory:changeInItemsToGet(other)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Calculates if the contents of this inventory match the contents of the 
  -- specified other inventory.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local inv1 = Inventory:new()
  --   inv1:setItemDetailAt(1, ItemDetail:new({name = 'minecraft:log', damage: 1, count: 64}))
  --
  --   local inv2 = Inventory:new()
  --   inv2:setItemDetailAt(5, ItemDetail:new({name = 'minecraft:log', damage: 1, count: 64}))
  --   -- prints true
  --   print(inv1:contentEquals(inv2))
  --
  -- @param other  the inventory to compare with
  -- @param strict boolean true if items should be compared strictly, false 
  --               otherwise. Default false
  -----------------------------------------------------------------------------
  function Inventory:contentsEqual(other, strict)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns if this inventory is logically equivalent to the specified other 
  -- inventory - both in contents and their locations/layout.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local Inventory = twf.inventory.Inventory
  --   local inv1 = Inventory:new()
  --   local inv2 = Inventory:new()
  --   -- prints true
  --   print(inv1:equals(inv2))
  --
  -- @param other the other inventory to compare to
  -- @return      boolean true if the inventories are logically equivalent, 
  --              false otherwise
  -----------------------------------------------------------------------------
  function Inventory:equals(other)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a reasonable hash code for this inventory.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local inv1 = Inventory:new()
  --   local inv2 = Inventory:new()
  --   -- prints true
  --   print(inv1.hashCode() == inv2.hashCode())
  --
  -- @return number hash code of this inventory
  -----------------------------------------------------------------------------
  function Inventory:hashCode()
    error('Not yet implemented')
  end
  
  twf.inventory.Inventory = Inventory
end

-----------------------------------------------------------------------------
-- Describes the result of the turtle attempting to dig
-----------------------------------------------------------------------------
if not twf.inventory.DigResult then 
  local DigResult = {}
  
  -----------------------------------------------------------------------------
  -- Indicates the block was dug
  -----------------------------------------------------------------------------
  DigResult.DIG_SUCCESS = 5647
  
  -----------------------------------------------------------------------------
  -- Indicates that there was nothing to dig. This is considered successful
  -----------------------------------------------------------------------------
  DigResult.NOTHING_TO_DIG = 5651
  
  -----------------------------------------------------------------------------
  -- Indicates that there was something to mine, but no item was returned. This
  -- is considered successful, and is usually the result of equipping a hoe
  -----------------------------------------------------------------------------
  DigResult.NO_ITEM = 5653
  
  -----------------------------------------------------------------------------
  -- Indicates that there is no fuel to dig with.
  -----------------------------------------------------------------------------
  DigResult.NO_FUEL = 5657
  
  -----------------------------------------------------------------------------
  -- Indicates a general failure to dig - this is probably bedrock or a full 
  -- inventory.
  -----------------------------------------------------------------------------
  DigResult.DIG_FAILED = 5659
  
  -----------------------------------------------------------------------------
  -- Returns if the dig result represents success
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local DigResult = twf.inventory.DigResult
  --   local dr = DigResult.DIG_SUCCESS
  --   -- prints true
  --   print(DigResult.isSuccess(dr))
  --
  -- @param digResult the dig result to check
  -- @result          if the dig result indicates success
  -- @error           if digResult is not a valid code
  -----------------------------------------------------------------------------
  function DigResult.isSuccess(digResult)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of the dig result
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local DigResult = twf.inventory.DigResult
  --   local dr = DigResult.NO_FUEL
  --   -- prints dig failed: no fuel
  --   print(DigResult.toString(dr))
  --
  -- @param digResult the dig result
  -- @return          string representation of the dig result
  -- @error           if digResult is not a valid code
  -----------------------------------------------------------------------------
  function DigResult.toString(digResult)
    error('Not yet implemented')
  end
  
  twf.inventory.DigResult = DigResult
end

-----------------------------------------------------------------------------
-- Describes the result of the turtle attempting to place an item in the
-- currently selected slot
-----------------------------------------------------------------------------
if not twf.inventory.PlaceResult then
  local PlaceResult = {}
  
  -----------------------------------------------------------------------------
  -- Indicates that the item was placed successfully
  -----------------------------------------------------------------------------
  PlaceResult.SUCCESS = 1009
  
  -----------------------------------------------------------------------------
  -- Indicates that there is no item in the currently selected slot
  -----------------------------------------------------------------------------
  PlaceResult.NO_ITEM = 1013
  
  -----------------------------------------------------------------------------
  -- Indicates that the turtle does not have enough fuel to place the item
  -----------------------------------------------------------------------------
  PlaceResult.NO_FUEL = 1019
  
  -----------------------------------------------------------------------------
  -- Indicates that the there is a block preventing the turtle from placing the
  -- item.
  -----------------------------------------------------------------------------
  PlaceResult.BLOCKED = 1021
  
  -----------------------------------------------------------------------------
  -- Indicates a general failure on the part of the turtle to place the item. 
  -- Likely caused by an entity blocking the turtle
  -----------------------------------------------------------------------------
  PlaceResult.FAILURE = 1031
  
  -----------------------------------------------------------------------------
  -- Returns if the specified place result indicates success
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local PlaceResult = twf.inventory.PlaceResult
  --   local pr = PlaceResult.SUCCESS
  --   -- prints true
  --   print(PlaceResult.isSuccess(pr))
  --
  -- @param placeResult the place result to check
  -- @return            if the place result indicates success
  -- @error             if placeResult is not a valid code 
  -----------------------------------------------------------------------------
  function PlaceResult.isSuccess(placeResult)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable, string representation of the place result code
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local PlaceResult = twf.inventory.PlaceResult
  --   local pr = PlaceResult.NO_FUEL
  --   -- prints place failed: no fuel
  --   print(PlaceResult.toString(pr))
  --
  -- @param placeResult the place result 
  -- @return            string representation of the place result code
  -- @error             if placeResult is not a valid code
  -----------------------------------------------------------------------------
  function PlaceResult.toString(placeResult)
    error('Not yet implemented')
  end
  
  twf.inventory.PlaceResult = PlaceResult
end

-----------------------------------------------------------------------------
-- Describes the result of the turtle attempting to drop items, either onto
-- the ground or into a chest-like object
-----------------------------------------------------------------------------
if not twf.inventory.DropResult then
  local DropResult = {}
  
  -----------------------------------------------------------------------------
  -- Indicates that the turtle successfully dropped some items
  -----------------------------------------------------------------------------
  DropResult.SUCCESS = 7129
  
  -----------------------------------------------------------------------------
  -- Indicates that the turtle does not have enough fuel to drop items
  -----------------------------------------------------------------------------
  DropResult.NO_FUEL = 7151
  
  -----------------------------------------------------------------------------
  -- Indicates that the turtle did not drop items, but the reason cannot be 
  -- determined. This could be that there are no items to drop, the chests 
  -- inventory is full, or the turtle is dropping into a direction-aware
  -- chest-like object from the wrong direction
  -----------------------------------------------------------------------------
  DropResult.FAILURE = 7159
  
  -----------------------------------------------------------------------------
  -- Returns if the specified suck result indicates success, false otherwise.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local DropResult = twf.inventory.DropResult
  --   local dr = DropResult.SUCCESS
  --   -- prints true
  --   print(DropResult.isSuccess(dr))
  --
  -- @param dropResult the drop result
  -- @result           boolean true if the drop result indicates success, false
  --                   otherwise
  -- @error            if dropResult is not a valid code
  -----------------------------------------------------------------------------
  function DropResult.isSuccess(dropResult)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of the specified drop 
  -- result
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local DropResult = twf.inventory.DropResult
  --   local dr = DropResult.SUCCESS
  --   -- prints drop: success
  --   print(DropResult.toString(dr))
  --
  -- @param dropResult the drop result
  -- @return           string representation of dropResult
  -- @error            if dropResult is not a valid code
  -----------------------------------------------------------------------------
  function DropResult.toString(dropResult)
    error('Not yet implemented')
  end
  
  twf.inventory.DropResult = DropResult
end

-----------------------------------------------------------------------------
-- Describes the result of the turtle attempting to suck items, either off 
-- the ground or from a chest-like object
-----------------------------------------------------------------------------
if not twf.inventory.SuckResult then
  local SuckResult = {}
  
  -----------------------------------------------------------------------------
  -- Indicates that the turtle successfully sucked some items
  -----------------------------------------------------------------------------
  SuckResult.SUCCESS = 6203
  
  -----------------------------------------------------------------------------
  -- Indicates that the turtle does not have enough fuel to suck items
  -----------------------------------------------------------------------------
  SuckResult.NO_FUEL = 6211
  
  -----------------------------------------------------------------------------
  -- Indicates that the turtle did not suck items, but the reason cannot be 
  -- determined. This could be that there are no items to suck, the turtles 
  -- inventory is full, or the turtle is sucking from a direction-aware
  -- chest-like object from the wrong direction
  -----------------------------------------------------------------------------
  SuckResult.FAILURE = 6217
  
  -----------------------------------------------------------------------------
  -- Returns if the specified suck result indicates success, false otherwise.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local SuckResult = twf.inventory.SuckResult
  --   local sr = SuckResult.SUCCESS
  --   -- prints true
  --   print(SuckResult.isSuccess(sr))
  --
  -- @param suckResult the suck result
  -- @result           boolean true if the suck result indicates success, false
  --                   otherwise
  -- @error            if suckResult is not a valid code
  -----------------------------------------------------------------------------
  function SuckResult.isSuccess(suckResult)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of the specified suck 
  -- result
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local SuckResult = twf.inventory.SuckResult
  --   local sr = SuckResult.SUCCESS
  --   -- prints suck: success
  --   print(SuckResult.toString(sr))
  --
  -- @param suckResult the suck result
  -- @return           string representation of suckResult
  -- @error            if suckResult is not a valid code
  -----------------------------------------------------------------------------
  function SuckResult.toString(suckResult)
    error('Not yet implemented')
  end
  
  twf.inventory.SuckResult = SuckResult
end
-----------------------------------------------------------------------------
-- Actions corresponding to new dig functions
-----------------------------------------------------------------------------
if not twf.inventory.action then
  local action = {}
  
  -----------------------------------------------------------------------------
  -- twf.inventory.action.DigAction
  -- 
  -- An action that attempts to dig once
  -----------------------------------------------------------------------------
  do
    local DigAction = {}
    
    -----------------------------------------------------------------------------
    -- The direction to dig in. Either twf.movement.direction.FORWARD, UP, or 
    -- DOWN
    -----------------------------------------------------------------------------
    DigAction.direction = nil
    
    -----------------------------------------------------------------------------
    -- The inventory difference after the last call to perform (tuple)
    --
    -- @see twf.inventory.Inventory#changeInItemsToGet(Inventory)
    -----------------------------------------------------------------------------
    DigAction.itemsLast = nil
    
    -----------------------------------------------------------------------------
    -- Creates a new instance of this action
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.DigAction:new({direction = twf.movement.direction.FORWARD})
    --
    -- @param o superseding object
    -- @return  a new instance of this action
    -- @error   if o.direction is not valid
    -----------------------------------------------------------------------------
    function DigAction:new(o)
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to dig once
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local digForward = twf.inventory.action.DigAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, item = digForward:perform()
    --
    -- @return tuple of DigResult and ItemDetail for the result and mined items
    -----------------------------------------------------------------------------
    function DigAction:perform()
      -- Use DigAction.itemsLast!
      error('Not yet implemented')
    end
    
     -----------------------------------------------------------------------------
    -- Called when this action completes successfully - should update the state
    -- of the turtle. For digging related actions, this involves updating the
    -- inventory of the turtle to reflect the newly added items, if any.
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local digForward = twf.inventory.action.DigAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, items = digForward:perform()
    --   if twf.inventory.DigResult.isSuccess(result) then
    --     digForward:updateState(st)
    --   end
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function DigAction:updateState(stateTurtle)
      -- Use DigAction.itemsLast!
      error('Not yet implemented')
    end
    
    
    -----------------------------------------------------------------------------
    -- Returns a unique name for this action type
    --
    -- @return a unique name for this action type
    -----------------------------------------------------------------------------
    function DigAction.name()
      return 'twf.inventory.action.DigAction'
    end
    
    
    -----------------------------------------------------------------------------
    -- Serializes this action
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.inventory.action.DigAction:new({direction = twf.movement.direction.FORWARD})
    --   local serialized = act:serialize()
    --   local unserialized = twf.inventory.action.DigAction.unserialize(serialized)
    -- 
    -- @return string serialization of this action
    -----------------------------------------------------------------------------
    function DigAction:serialize()
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Unserializes an action serialized by the corresponding serialize function
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.inventory.action.DigAction:new({direction = twf.movement.direction.FORWARD})
    --   local serialized = act:serialize()
    --   local unserialized = twf.inventory.action.DigAction.unserialize(serialized)
    -- 
    -- @param serialized string serialization of this action
    -- @return           action instance the serialized string represented
    -----------------------------------------------------------------------------
    function DigAction.unserialize(serialized)
      error('Not yet implemented')
    end
    
    action.DigAction = DigAction
  end
  
  -----------------------------------------------------------------------------
  -- twf.inventory.action.PlaceAction
  -- 
  -- An action that attempts to place the currently selected item
  -----------------------------------------------------------------------------
  do
    local PlaceAction = {}
    
    -----------------------------------------------------------------------------
    -- The direction of this place action. Either twf.movement.direction.FORWARD,
    -- UP, or DOWN
    -----------------------------------------------------------------------------
    PlaceAction.direction = nil
    
    -----------------------------------------------------------------------------
    -- The inventory difference after the last call to perform (tuple)
    --
    -- @see twf.inventory.Inventory#changeInItemsToGet(Inventory)
    -----------------------------------------------------------------------------
    DigAction.itemsLast = nil
    
    -----------------------------------------------------------------------------
    -- Creates a new instance of this action
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.PlaceAction:new({direction = twf.movement.direction.FORWARD})
    --
    -- @param o superseding object
    -- @return  a new instance of this action
    -- @error   if o.direction is not valid
    -----------------------------------------------------------------------------
    function PlaceAction:new(o)
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Places the item in the currently selected slot in the appropriate
    -- direction. Returns true if an item  was placed, false otherwise. Not 
    -- usually called directly, since its result isn't as useful as that from 
    -- perform().
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.PlaceAction:new({direction = twf.movement.direction.FORWARD})
    --   local succ = act:place() -- like turtle.place()
    --
    -- @return true if an item was placed, false otherwise
    function PlaceAction:place()
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to place an item in the currently selected slot in the 
    -- appropriate direction
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local placeForward = twf.inventory.action.PlaceAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, item = placeForward:perform()
    --
    -- @return tuple of PlaceResult and ItemDetail for the result and placed item
    -----------------------------------------------------------------------------
    function PlaceAction:perform()
      error('Not yet implemented')
    end
    
     -----------------------------------------------------------------------------
    -- Called when this action completes successfully - should update the state
    -- of the turtle.
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local placeForward = twf.inventory.action.PlaceAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, items = placeForward:perform()
    --   if twf.inventory.PlaceResult.isSuccess(result) then
    --     placeForward:updateState(st)
    --   end
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function PlaceAction:updateState(stateTurtle)
      error('Not yet implemented')
    end
    
    
    -----------------------------------------------------------------------------
    -- Returns a unique name for this action type
    --
    -- @return a unique name for this action type
    -----------------------------------------------------------------------------
    function PlaceAction.name()
      return 'twf.inventory.action.PlaceAction'
    end
    
    -----------------------------------------------------------------------------
    -- Serializes this action
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.inventory.action.PlaceAction:new({direction = twf.movement.direction.FORWARD})
    --   local serialized = act:serialize()
    --   local unserialized = twf.inventory.action.PlaceAction.unserialize(serialized)
    -- 
    -- @return string serialization of this action
    -----------------------------------------------------------------------------
    function PlaceAction:serialize()
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Unserializes an action serialized by the corresponding serialize function
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.inventory.action.PlaceAction:new({direction = twf.movement.direction.FORWARD})
    --   local serialized = act:serialize()
    --   local unserialized = twf.inventory.action.PlaceAction.unserialize(serialized)
    -- 
    -- @param serialized string serialization of this action
    -- @return           action instance the serialized string represented
    -----------------------------------------------------------------------------
    function PlaceAction.unserialize(serialized)
      error('Not yet implemented')
    end
    
    action.PlaceAction = PlaceAction
  end
  
  -----------------------------------------------------------------------------
  -- twf.inventory.action.DropAction
  -- 
  -- An action that attempts to drop some amount of the currently selected 
  -- item
  -----------------------------------------------------------------------------
  do
    local DropAction = {}
    
    -----------------------------------------------------------------------------
    -- The direction to drop items in, either twf.movement.direction.FORWARD, UP,
    -- or DOWN.
    -----------------------------------------------------------------------------
    DropAction.direction = nil
    
    -----------------------------------------------------------------------------
    -- The maximum amount of items to drop, if there should be a limit. nil to 
    -- try and drop the full stack
    -----------------------------------------------------------------------------
    DropAction.amount = nil
    
    -----------------------------------------------------------------------------
    -- The inventory difference after the last call to perform (tuple)
    --
    -- @see twf.inventory.Inventory#changeInItemsToGet(Inventory)
    -----------------------------------------------------------------------------
    DropAction.itemsLast = nil
    
    -----------------------------------------------------------------------------
    -- Creates a new instance of this action
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.DropAction:new({direction = twf.movement.direction.FORWARD, amount = 1})
    --
    -- @param o superseding object
    -- @return  a new instance of this action
    -- @error   if o.direction is not valid or o.amount is not valid
    -----------------------------------------------------------------------------
    function DropAction:new(o)
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Drops items in the appropriate direction, returning true on success and 
    -- false on failure. Not usually called directly, since the result is not 
    -- as useful as that from perform().
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   -- drop 1 stack forward action 
    --   local act = twf.inventory.action.DropAction:new({direction = twf.movement.direction.FORWARD})
    --   local succ = act:drop() -- like turtle.drop()
    --
    -- @return true on success, false on failure
    -----------------------------------------------------------------------------
    function DropAction:drop()
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to drop the item.
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.DropAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, item = act:perform()
    --
    -- @return tuple of DropResult and ItemDetail for the result and dropped item
    -----------------------------------------------------------------------------
    function DropAction:perform()
      error('Not yet implemented')
    end
    
     -----------------------------------------------------------------------------
    -- Called when this action completes successfully - should update the state
    -- of the turtle.
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local act = twf.inventory.action.DropAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, items = act:perform()
    --   if twf.inventory.DropResult.isSuccess(result) then
    --     act:updateState(st)
    --   end
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function DropAction:updateState(stateTurtle)
      error('Not yet implemented')
    end
    
    
    -----------------------------------------------------------------------------
    -- Returns a unique name for this action type
    --
    -- @return a unique name for this action type
    -----------------------------------------------------------------------------
    function DropAction.name()
      return 'twf.inventory.action.DropAction'
    end
    
    -----------------------------------------------------------------------------
    -- Serializes this action
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.inventory.action.DropAction:new({direction = twf.movement.direction.FORWARD})
    --   local serialized = act:serialize()
    --   local unserialized = twf.inventory.action.DropAction.unserialize(serialized)
    -- 
    -- @return string serialization of this action
    -----------------------------------------------------------------------------
    function DropAction:serialize()
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Unserializes an action serialized by the corresponding serialize function
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.inventory.action.DropAction:new({direction = twf.movement.direction.FORWARD})
    --   local serialized = act:serialize()
    --   local unserialized = twf.inventory.action.DropAction.unserialize(serialized)
    -- 
    -- @param serialized string serialization of this action
    -- @return           action instance the serialized string represented
    -----------------------------------------------------------------------------
    function DropAction.unserialize(serialized)
      error('Not yet implemented')
    end
    
    action.DropAction = DropAction
  end
  
  -----------------------------------------------------------------------------
  -- twf.inventory.action.SuckAction
  -- 
  -- An action that attempts to suck some amount of stuff 
  -----------------------------------------------------------------------------
  do
    local SuckAction = {}
    
    -----------------------------------------------------------------------------
    -- The direction to suck items from, either twf.movement.direction.FORWARD, UP,
    -- or DOWN.
    -----------------------------------------------------------------------------
    SuckAction.direction = nil
    
    -----------------------------------------------------------------------------
    -- The maximum amount of items to suck, if there should be a limit. nil to 
    -- try and suck a full stack
    -----------------------------------------------------------------------------
    SuckAction.amount = nil
    
    -----------------------------------------------------------------------------
    -- The inventory difference after the last call to perform (tuple)
    --
    -- @see twf.inventory.Inventory#changeInItemsToGet(Inventory)
    -----------------------------------------------------------------------------
    SuckAction.itemsLast = nil
    
    -----------------------------------------------------------------------------
    -- Creates a new instance of this action
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.SuckAction:new({direction = twf.movement.direction.FORWARD, amount = 1})
    --
    -- @param o superseding object
    -- @return  a new instance of this action
    -- @error   if o.direction is not valid or o.amount is not valid
    -----------------------------------------------------------------------------
    function SuckAction:new(o)
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Sucks items from the appropriate direction, returning true on success and 
    -- false on failure. Not usually called directly, since the result is not 
    -- as useful as that from perform().
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   -- suck 1 stack forward action 
    --   local act = twf.inventory.action.SuckAction:new({direction = twf.movement.direction.FORWARD})
    --   local succ = act:suck() -- like turtle.suck()
    --
    -- @return true on success, false on failure
    -----------------------------------------------------------------------------
    function SuckAction:suck()
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to suck the item.
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.SuckAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, item = act:perform()
    --
    -- @return tuple of SuckResult and ItemDetail for the result and sucked item
    -----------------------------------------------------------------------------
    function SuckAction:perform()
      error('Not yet implemented')
    end
    
     -----------------------------------------------------------------------------
    -- Called when this action completes successfully - should update the state
    -- of the turtle.
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local act = twf.inventory.action.SuckAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, items = act:perform()
    --   if twf.inventory.DropResult.isSuccess(result) then
    --     act:updateState(st)
    --   end
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function SuckAction:updateState(stateTurtle)
      error('Not yet implemented')
    end
    
    
    -----------------------------------------------------------------------------
    -- Returns a unique name for this action type
    --
    -- @return a unique name for this action type
    -----------------------------------------------------------------------------
    function SuckAction.name()
      return 'twf.inventory.action.SuckAction'
    end
    
    -----------------------------------------------------------------------------
    -- Serializes this action
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.inventory.action.SuckAction:new({direction = twf.movement.direction.FORWARD})
    --   local serialized = act:serialize()
    --   local unserialized = twf.inventory.action.SuckAction.unserialize(serialized)
    -- 
    -- @return string serialization of this action
    -----------------------------------------------------------------------------
    function SuckAction:serialize()
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Unserializes an action serialized by the corresponding serialize function
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.inventory.action.SuckAction:new({direction = twf.movement.direction.FORWARD})
    --   local serialized = act:serialize()
    --   local unserialized = twf.inventory.action.SuckAction.unserialize(serialized)
    -- 
    -- @param serialized string serialization of this action
    -- @return           action instance the serialized string represented
    -----------------------------------------------------------------------------
    function SuckAction.unserialize(serialized)
      error('Not yet implemented')
    end
    
    action.SuckAction = SuckAction
  end
  
  twf.inventory.action = action
end
  
-----------------------------------------------------------------------------
-- Extensions to twf.movement.StatefulTurtle to allow for digging, placing, 
-- dropping, and sucking, as well as miscellaneous item-related functions
-----------------------------------------------------------------------------
if not twf.movement.StatefulTurtle.INVENTORY_EXTENSIONS then
  local StatefulTurtle = twf.movement.StatefulTurtle
  
  -----------------------------------------------------------------------------
  -- The cached inventory of the turtle
  -----------------------------------------------------------------------------
  StatefulTurtle.inventory = nil
  
  -----------------------------------------------------------------------------
  -- Which slot is currently selected on the turtle
  -----------------------------------------------------------------------------
  StatefulTurtle.selectedSlot = 1
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of StatefulTurtle, assuming the turtle is at 
  -- (0, 0, 0), facing north, with nothing in its inventory
  --
  -- Usage:
  --   dofile('twf_movement.lua') 
  --   dofile('twf_inventory.lua') -- inventory extensions
  --   local st = twf.movement.StatefulTurtle:new()
  --
  -- @param o (optional) superseding object
  -- @return an instance of StatefulTurtle
  -----------------------------------------------------------------------------
  local oldNew = StatefulTurtle.new
  function StatefulTurtle:new(o)
    local result = self:oldNew(o)
    
    if not result.inventory then 
      result.inventory = twf.inventory.Inventory:new()
    end
    
    return result
  end
  
  -- Inventory utility functions
  
  -----------------------------------------------------------------------------
  -- Loads the turtles inventory from the turtle api into the stateful turtles 
  -- internal cache. This is not an insignificant time-cost function.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   st:loadInventoryFromTurtle()
  -----------------------------------------------------------------------------
  function StatefulTurtle:loadInventoryFromTurtle()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Selects the item and returns true, or returns false if the item cannot be
  -- found
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local cobble = twf.inventory.ItemDetail:new({name = 'minecraft:cobblestone', damage = 1, count = 1})
  --   local st = twf.movement.StatefulTurtle:new()
  --   st:loadInventoryFromTurtle()
  --   local haveCobble = st:selectItem(cobble)
  --   if not haveCobble then
  --     error('Out of cobblestone!')
  --   end
  --   StatefulTurtle:placeDown() -- places a cobble below the turtle
  -- 
  -- @param itemDetail the item to selectItem
  -- @param strict     true if strict item comparison, false if lenient 
  -- @return           true if the item was found and selected, false otherwise
  -- @see              twf.inventory.ItemDetail#strictItemEquals(ItemDetail)
  -- @see              twf.inventory.ItemDetail#lenientItemEquals(ItemDetail)
  -----------------------------------------------------------------------------
  function StatefulTurtle:selectItem(itemDetail, strict)
    error('Not yet implemented')
  end
  
  -- Digging functions
  
  -----------------------------------------------------------------------------
  -- Attempts to dig forward, and returns the result of the action. If an item 
  -- is returned, the result is a tuple containing the dig result and the item 
  -- detail describing what was collected. Otherwise, returns the result code
  -- and nil.
  -- 
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local digResult, item = st:digForward()
  --   if not twf.inventory.DigResult.isSuccess(digResult) then 
  --     error(twf.inventory.DigResult.toString(digResult))
  --   end
  --   -- prints something like Dug minecraft:log:1 x1
  --   print('Dug ' .. item:toString())
  --
  -- Remarks:
  --   Since digging does not dofile fuel or alter turtle state unrecoverably,
  --   action recovery is not necessary, possible, or supported.
  --
  -- @return a tuple {twf.inventory.DigResult, twf.inventory.ItemDetail or nil}
  -----------------------------------------------------------------------------
  function StatefulTurtle:digForward()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Attempts to dig up, and returns the result of the action. If an item is 
  -- returned, the result is a tuple containing the dig result and the item 
  -- detail describing what was collected. Otherwise, returns the result code
  -- and nil.
  -- 
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local digResult, item = st:digUp()
  --   if not twf.inventory.DigResult.isSuccess(digResult) then 
  --     error(twf.inventory.DigResult.toString(digResult))
  --   end
  --   -- prints something like Dug minecraft:log:1 x1
  --   print('Dug ' .. item:toString())
  --
  -- Remarks:
  --   Since digging does not dofile fuel or alter turtle state unrecoverably,
  --   action recovery is not necessary, possible, or supported.
  --
  -- @return a tuple {twf.inventory.DigResult, twf.inventory.ItemDetail or nil}
  -----------------------------------------------------------------------------
  function StatefulTurtle:digUp()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Attempts to dig down, and returns the result of the action. If an item is 
  -- returned, the result is a tuple containing the dig result and the item 
  -- detail describing what was collected. Otherwise, returns the result code
  -- and nil.
  -- 
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local digResult, item = st:digDown()
  --   if not twf.inventory.DigResult.isSuccess(digResult) then 
  --     error(twf.inventory.DigResult.toString(digResult))
  --   end
  --   -- prints something like Dug minecraft:log:1 x1
  --   print('Dug ' .. item:toString())
  --
  -- Remarks:
  --   Since digging does not dofile fuel or alter turtle state unrecoverably,
  --   action recovery is not necessary, possible, or supported.
  --
  -- @return a tuple {twf.inventory.DigResult, twf.inventory.ItemDetail or nil}
  -----------------------------------------------------------------------------
  function StatefulTurtle:digDown()
    error('Not yet implemented')
  end
  
  -- Placing functions
  
  -----------------------------------------------------------------------------
  -- Attempts to place an item from the currently selected slot, and returns 
  -- the the result code for the action, and either the ItemDetail that was 
  -- placed or nil, as a tuple. 
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local placeResult, item = st:placeForward()
  --   if not twf.inventory.PlaceResult.isSuccess(placeResult) then 
  --     error(twf.inventory.PlaceResult.toString(placeResult)
  --   end
  --   -- prints something like Placed minecraft:log:1 x1
  --   print('Placed ' .. item:toString())
  --
  -- Remarks:
  --   Since placing does not dofile fuel or alter turtle state unrecoverably,
  --   action recovery is not necessary, possible, or supported.
  --
  -- @return a tuple {twf.inventory.PlaceResult, twf.inventory.ItemDetail or nil}
  -----------------------------------------------------------------------------
  function StatefulTurtle:placeForward()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Attempts to place an item from the currently selected slot, and returns 
  -- the the result code for the action, and either the ItemDetail that was 
  -- placed or nil, as a tuple. 
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local placeResult, item = st:placeUp()
  --   if not twf.inventory.PlaceResult.isSuccess(placeResult) then 
  --     error(twf.inventory.PlaceResult.toString(placeResult)
  --   end
  --   -- prints something like Placed minecraft:log:1 x1
  --   print('Placed ' .. item:toString())
  --
  -- Remarks:
  --   Since placing does not dofile fuel or alter turtle state unrecoverably,
  --   action recovery is not necessary, possible, or supported.
  --
  -- @return a tuple {twf.inventory.PlaceResult, twf.inventory.ItemDetail or nil}
  -----------------------------------------------------------------------------
  function StatefulTurtle:placeUp()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Attempts to place an item from the currently selected slot, and returns 
  -- the the result code for the action, and either the ItemDetail that was 
  -- placed or nil, as a tuple. 
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local placeResult, item = st:placeDown()
  --   if not twf.inventory.PlaceResult.isSuccess(placeResult) then 
  --     error(twf.inventory.PlaceResult.toString(placeResult)
  --   end
  --   -- prints something like Placed minecraft:log:1 x1
  --   print('Placed ' .. item:toString())
  --
  -- Remarks:
  --   Since placing does not dofile fuel or alter turtle state unrecoverably,
  --   action recovery is not necessary, possible, or supported.
  --
  -- @return a tuple {twf.inventory.PlaceResult, twf.inventory.ItemDetail or nil}
  -----------------------------------------------------------------------------
  function StatefulTurtle:placeDown()
    error('Not yet implemented')
  end
  
  -- Dropping functions
  
  -----------------------------------------------------------------------------
  -- Attempts to drop the items in the currently selected slot immediately in 
  -- front of the turtle, or into a chest in front of the turtle, and returns a 
  -- tuple for the result code and dropped items.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local dropResult, item = st:dropForward()
  --   if not twf.inventory.DropResult.isSuccess(dropResult) then 
  --     error(twf.inventory.DropResult.toString(dropResult))
  --   end
  --   -- prints something like Dropped minecraft:log:1 x64
  --  print('Dropped ' .. item:toString())
  --
  -- @param amount (optional) number maximum things to drop
  -- @return       tuple {twf.inventory.DropResult, twf.inventory.ItemDetail}
  -----------------------------------------------------------------------------
  function StatefulTurtle:dropForward(amount)
    error('Not yet implemented')
  end
  
  
  -----------------------------------------------------------------------------
  -- Attempts to drop the items in the currently selected slot immediately 
  -- below the turtle, or into a chest below the turtle, and returns a tuple 
  -- for the result code and dropped items.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local dropResult, item = st:dropDown()
  --   if not twf.inventory.DropResult.isSuccess(dropResult) then 
  --     error(twf.inventory.DropResult.toString(dropResult))
  --   end
  --   -- prints something like Dropped minecraft:log:1 x64
  --  print('Dropped ' .. item:toString())
  --
  -- @param amount (optional) number maximum things to drop
  -- @return       tuple {twf.inventory.DropResult, twf.inventory.ItemDetail}
  -----------------------------------------------------------------------------
  function StatefulTurtle:dropDown(amount)
    error('Not yet implemented')
  end
  
  
  -----------------------------------------------------------------------------
  -- Attempts to drop the items in the currently selected slot immediately 
  -- above the turtle, or into a chest above the turtle, and returns a tuple 
  -- for the result code and dropped items.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local dropResult, item = st:dropUp()
  --   if not twf.inventory.DropResult.isSuccess(dropResult) then 
  --     error(twf.inventory.DropResult.toString(dropResult))
  --   end
  --   -- prints something like Dropped minecraft:log:1 x64
  --  print('Dropped ' .. item:toString())
  --
  -- @param amount (optional) number maximum things to drop
  -- @return       tuple {twf.inventory.DropResult, twf.inventory.ItemDetail}
  -----------------------------------------------------------------------------  
  function StatefulTurtle:dropUp(amount)
    error('Not yet implemented')
  end
  
  -- Sucking functions
  
  -----------------------------------------------------------------------------
  -- Attempts to suck a stack of item into the currently selected slot, or the 
  -- slot with the next id. If no slot is found at slot 16, wraps to slot 1.
  -- Stops searching for a slot when every slot has been searched.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local suckResult, item = st:suckForward()
  --   if not twf.inventory.SuckResult.isSuccess(suckResult) then
  --     error(twf.inventory.SuckResult.toString(suckResult))
  --   end
  --   -- prints something like Sucked minecraft:log:1 x64
  --   print('Sucked ' .. item:toString())
  --
  -- @param amount (optional) number maximum things to suck
  -- @return       tuple {twf.inventory.SuckResult, twf.inventory.ItemDetail}
  -----------------------------------------------------------------------------
  function StatefulTurtle:suckForward(amount)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Attempts to suck a stack of item into the currently selected slot, or the 
  -- slot with the next id. If no slot is found at slot 16, wraps to slot 1.
  -- Stops searching for a slot when every slot has been searched.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local suckResult, item = st:suckDown()
  --   if not twf.inventory.SuckResult.isSuccess(suckResult) then
  --     error(twf.inventory.SuckResult.toString(suckResult))
  --   end
  --   -- prints something like Sucked minecraft:log:1 x64
  --   print('Sucked ' .. item:toString())
  --
  -- @param amount (optional) number maximum things to suck
  -- @return       tuple {twf.inventory.SuckResult, twf.inventory.ItemDetail}
  -----------------------------------------------------------------------------
  function StatefulTurtle:suckDown(amount)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Attempts to suck a stack of item into the currently selected slot, or the 
  -- slot with the next id. If no slot is found at slot 16, wraps to slot 1.
  -- Stops searching for a slot when every slot has been searched.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local suckResult, item = st:suckUp()
  --   if not twf.inventory.SuckResult.isSuccess(suckResult) then
  --     error(twf.inventory.SuckResult.toString(suckResult))
  --   end
  --   -- prints something like Sucked minecraft:log:1 x64
  --   print('Sucked ' .. item:toString())
  --
  -- @param amount (optional) number maximum things to suck
  -- @return       tuple {twf.inventory.SuckResult, twf.inventory.ItemDetail}
  -----------------------------------------------------------------------------
  function StatefulTurtle:suckUp(amount)
    error('Not yet implemented')
  end
  
  -- Serialization 
  
  -----------------------------------------------------------------------------
  -- Serializes this instance of StatefulTurtle such that it can be 
  -- unserialized later.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local serialized = st:serialize()
  --   local unserialized = StatefulTurtle.unserialize(serialized)
  --   -- prints true
  --   print(st:equals(unserialized))
  --
  -- @return a string serialization of this instance
  -----------------------------------------------------------------------------
  local oldSerialize = StatefulTurtle.serialize
  function StatefulTurtle:serialize()
    local base = self:oldSerialize()
    
    local resultTable = {
      base = base, 
      inventory = self.inventory:serialize(),
      selectedSlot = self.selectedSlot
    }
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes a serialized stateful turtle into an object formats
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local serialized = st:serialize()
  --   local unserialized = StatefulTurtle.unserialize(serialized)
  --   -- prints true
  --   print(st:equals(unserialized))
  --
  -- @param serialized the serialized string of the turtle
  -- @return the instance of stateful turtle the string represents
  -----------------------------------------------------------------------------
  function StatefulTurtle.unserialize(serialized)
    error('Not yet implemented')
  end
  
  -- Miscellaneous
  
  -----------------------------------------------------------------------------
  -- Clones this instance of stateful turtle.
  -- 
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local cl = st:clone()
  --   -- prints true
  --   print(st:equals(cl))
  --
  -- @return a copy of this instance
  -----------------------------------------------------------------------------
  function StatefulTurtle:clone()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of this stateful turtle
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   -- Prints facing north at (0, 0, 0) inventory: empty
  --   print(st:toString())
  --
  -- @return human readable representation of this instance
  -----------------------------------------------------------------------------
  function StatefulTurtle:toString()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns if this instance of stateful turtle is equal to the specified
  -- other instance
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local st  = StatefulTurtle:new()
  --   local st2 = StatefulTurtle:new()
  --   -- prints true
  --   print(st:equals(st2))
  --
  -- @param other the stateful turtle to compare to
  -- @return      if the two stateful turtles are logically equivalent
  -----------------------------------------------------------------------------
  function StatefulTurtle:equals(other)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a valid hashcode representation of this stateful turtle
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local st  = StatefulTurtle:new()
  --   local st2 = StatefulTurtle:new()
  --   -- prints true
  --   print(st:hashCode() == st2:hashCode())
  --
  -- @return number hash code of this stateful turtle
  -----------------------------------------------------------------------------
  function StatefulTurtle:hashCode()
    error('Not yet implemented')
  end
  
  StatefulTurtle.INVENTORY_EXTENSIONS = true
end