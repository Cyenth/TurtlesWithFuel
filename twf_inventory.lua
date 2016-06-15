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
  -- Calculates the change in items required for this inventory to match the 
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
  -- Indicates the dig was done successfully
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
  -- Indicates a general failure to dig - this is probably bedrock
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
  -- @result          if there is no block where the dig result was trying to 
  --                  dig
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
  --   -- prints 'dig failed: no fuel'
  --   print(DigResult.toString(dr))
  --
  -- @param digResult the dig result
  -- @return          string representation of the dig result
  -----------------------------------------------------------------------------
  function DigResult.toString(digResult)
    error('Not yet implemented')
  end
  
  twf.inventory.DigResult = DigResult
end

-----------------------------------------------------------------------------
-- Actions corresponding to new dig functions
-----------------------------------------------------------------------------
if not twf.inventory.action then
  local action = {}
  
  -----------------------------------------------------------------------------
  -- twf.movement.action.DigForwardAction
  -- 
  -- An action that attempts to dig in front of the turtle
  -----------------------------------------------------------------------------
  do
    local DigForwardAction = {}
    
    -----------------------------------------------------------------------------
    -- Creates a new instance of this action
    --
    -- Usage:
    --   require('twf_inventory.lua')
    --   local act = twf.movement.action.DigForwardAction:new()
    --
    -- @param o (optional) superseding object
    -- @return a new instance of this action
    -----------------------------------------------------------------------------
    function DigForwardAction:new(o)
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to dig once in front of the turtle
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local digForward = twf.inventory.action.DigForwardAction:new()
    --   local result, item = digForward:perform()
    --
    -- @return tuple of DigResult and ItemDetail for the result and mined items
    -----------------------------------------------------------------------------
    function DigForwardAction:perform()
      error('Not yet implemented')
    end
    
     -----------------------------------------------------------------------------
    -- Called when this action completes successfully - should update the state
    -- of the turtle.
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local digForward = twf.inventory.action.DigForwardAction:new()
    --   local result, items = digForward:perform()
    --   if twf.inventory.DigResult.isSuccess(result) then
    --     digForward:updateState(st)
    --   end
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function DigForwardAction:updateState(stateTurtle)
      error('Not yet implemented')
    end
    
    
    -----------------------------------------------------------------------------
    -- Returns a unique name for this action type
    --
    -- @return a unique name for this action type
    -----------------------------------------------------------------------------
    function DigForwardAction:name()
      return 'twf.inventory.action.DigForwardAction'
    end
    
    action.DigForwardAction = DigForwardAction
  end
  
  twf.inventory.action = action
end
  
-----------------------------------------------------------------------------
-- Extensions to twf.movement.StatefulTurtle to allow for digging, as well as
-- miscellaneous item-related functions
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
  -- detail describing what was collected. 
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
  -- @return a tuple {DigResult, Item}
  -----------------------------------------------------------------------------
  function StatefulTurtle:digForward()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Attempts to dig up, and returns the result of the action. If an item is 
  -- returned, the result is a tuple containing the dig result and the item 
  -- detail describing what was collected. Otherwise, the result is just the 
  -- dig result
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
  -- @return a tuple {DigResult, Item}
  -----------------------------------------------------------------------------
  function StatefulTurtle:digUp()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Attempts to dig down, and returns the result of the action. If an item is 
  -- returned, the result is a tuple containing the dig result and the item 
  -- detail describing what was collected. Otherwise, the result is just the 
  -- dig result
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
  -- @return a tuple {DigResult, Item}
  -----------------------------------------------------------------------------
  function StatefulTurtle:digDown()
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