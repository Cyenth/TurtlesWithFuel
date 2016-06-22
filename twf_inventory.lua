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
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.name) ~= 'string' then 
      error('Expected string for name but got ' .. o.name)
    end
    if type(o.damage) ~= 'number' then 
      error('Expected number for damage but got ' .. o.damage)
    end
    if type(o.count) ~= 'number' then 
      error('Expected number for count but got ' .. o.count)
    end
    
    return o
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
    if type(o) ~= 'table' then return nil end
    if type(o.name) ~= 'string' then return nil end
    if type(o.damage) ~= 'number' then return nil end
    if type(o.count) ~= 'number' then return nil end
    
    setmetatable(o, self)
    self.__index = self
    return o
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
    return self.name .. ':' .. self.damage .. ' x' .. self.count
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
    return self.name == other.name
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
    if self.name ~= other.name then return false end
    if self.damage ~= other.damage then return false end
    return true
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
    local resultTable = {}
    
    resultTable.name = self.name
    resultTable.damage = self.damage
    resultTable.count = self.count
    
    return textutils.serialize(resultTable)
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
    local serTable = textutils.unserialize(serialized)
    
    local name = serTable.name
    local damage = serTable.damage
    local count = serTable.count
    
    return ItemDetail:new({name = name, damage = damage, count = count})
  end
  
  -----------------------------------------------------------------------------
  -- Clones this item detail
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local iDet = twf.inventory.ItemDetail:new({name = 'minecraft:log', damage = 2, count = 64})
  --   local iDet2 = iDet:clone()
  --   iDet2.count = 32
  --   print(iDet.count) -- prints 64
  --   print(iDet2.coutn) -- prints 32
  --
  -- @return a clone of this item detail
  -----------------------------------------------------------------------------
  function ItemDetail:clone()
    return ItemDetail:new({name = self.name, damage = self.damage, count = self.count})
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
    if self.name ~= other.name then return false end
    if self.damage ~= other.damage then return false end
    if self.count ~= other.count then return false end
    
    return true
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
    local result = 31
    
    for i = 1, #self.name do 
      result = 17 * result + string.byte(self.name, i)
    end
    
    result = 19 * result + self.damage
    result = 19 * result + self.count
    
    return result
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
  Inventory.itemDetails = nil
  
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
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if not o.itemDetails then 
      o.itemDetails = {}
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Throws an exception if the index is not valid
  --
  -- @param index index to check
  -- @error       if index is not a number between 1 and 16 (inclusive)
  -----------------------------------------------------------------------------
  function Inventory:checkIndex(index)
    if type(index) ~= 'number' then 
      error('Expected number for index but got ' .. index)
    end
    if index < 1 or index > 16 then 
      error('Expected index (1-16) but got ' .. index)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Loads the inventory such that it matches the turtles current inventory.
  -- 
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local inv = twf.inventory.Inventory
  --   inv:loadFromTurtle()
  --   print(inv:toString()) -- prints the turtles inventory
  -----------------------------------------------------------------------------
  function Inventory:loadFromTurtle()
    for i = 1, 16 do 
      self.itemDetails[i] = twf.inventory.ItemDetail:safeNew(turtle.getItemDetail(i))
    end
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
    self:checkIndex(index)
    
    return self.itemDetails[index]
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
    self:checkIndex(index)
    
    if itemDetail.count < 1 then 
      self.itemDetails[index] = nil
    end
    
    self.itemDetails[inex] = itemDetail
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
    local res = 0
    for i = 1, 16 do
      if self.itemDetails[i] then 
        res = res + 1
      end
    end
    return res
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
    return 16 - self:fullSlots()
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
    for i = 1, 16 do 
      local item = self.itemDetails[i]
      
      if item then
        if strict then
          if item:strictItemEquals(itemDetail) then 
            return true
          end
        elseif item:lenientItemEquals(itemDetail) then 
          return true
        end
      end
    end
    
    return false
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
    local result = 0
    for i = 1, 16 do
      local item = self.itemDetails[i]
      
      if item then 
        if strict then
          if item:strictItemEquals(itemDetail) then 
            result = result + item.count
          end
        elseif item:lenientItemEquals(itemDetail) then
          result = result + item.count
        end
      end
    end
    return result
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
    for i = 1, 16 do 
      local item = self.itemDetails[i]
      
      if item then
        if strict then 
          if item:strictItemEquals(itemDetail) then 
            return i
          end
        elseif item:lenientItemEquals(itemDetail) then 
          return i
        end
      end
    end
    
    return -1
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
    for i = 1, 16 do 
      local item = self.itemDetails[i]
      
      if not item then 
        return i
      end
    end
    
    return -1
  end
  
  
  -----------------------------------------------------------------------------
  -- Returns the first index of a slot with something in it, or -1
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local ItemDetail = twf.inventory.ItemDetail
  --   local inv = Inventory:new()
  --   -- prints -1
  --   print(inv:firstIndexOfFilledSlot(log))
  --
  -- @return number of the index of the first empty slot, or -1
  -----------------------------------------------------------------------------
  function Inventory:firstIndexOfFilledSlot()
    for i = 1, 16 do 
      local item = self.itemDetails[i]
      
      if item then 
        return i
      end
    end
    
    return -1
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
    local resultTable = {}
    
    resultTable.itemDetails = {}
    
    for i = 1, 16 do
      if self.itemDetails[i] then 
        resultTable.itemDetails[i] = self.itemDetails[i]:serialize()
      end
    end
    
    return textutils.serialize(resultTable)
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
    local serTable = textutils.unserialize(serialized)
    
    local itemDetails = {}
    for i = 1, 16 do 
      if serTable.itemDetails[i] then 
        itemDetails[i] = twf.inventory.ItemDetail.unserialize(serTable.itemDetails[i])
      end
    end
    
    return Inventory:new({itemDetails = itemDetails})
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
    local fullSlots = self:fullSlots()
    local perc = self:fullSlots() / self:numberOfSlots()
    perc = math.floor(perc * 100 * 100) / 100 -- limit to 2 digits
    
    local invTable = '{'
    local first = true
    for i = 1, 16 do
      if self.itemDetails[i] then 
        if first then 
          first = false
        else
          invTable = invTable .. ', '
        end
        
        invTable = invTable .. i .. ': ' .. self.itemDetails[i]:toString()
      end
    end
    invTable = invTable .. '}'
    return self:fullSlots() .. '/' .. self:numberOfSlots() .. ' slots used (' .. perc .. '%) ' .. invTable
  end
  
  -----------------------------------------------------------------------------
  -- Returns a table containing the item details of both this inventory and the
  -- specified other inventory, combining strictly equal items
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local Inventory = twf.inventory.Inventory
  --   local inv1 = Inventory:new()
  --   inv1:setItemDetailAt(1, ItemDetail:new({name = 'minecraft:log', damage: 1, count: 32})
  --   local inv2 = Inventory:new()
  --   inv2:setItemDetailAt(1, ItemDetail:new({name = 'minecraft:log', damage: 1, count: 32})
  --   local comb = inv1:combinedItemDetails(inv2)
  --   -- comb[1] is ItemDetail {name = 'minecraft:log', damage: 1, count: 64}
  --
  -- @param other twf.inventory.Inventory inventory to combine with. 
  --              null to get this inventories items but with stacks combined
  -- @param strict boolean true if items must be strictly equal. default false
  -- @return      combination of this inventory with the other inventory, stacks 
  --              combined
  -----------------------------------------------------------------------------
  function Inventory:combinedItemDetails(other, strict)
    if strict == nil then strict = false end
    
    local result = {}
    local tryAdd = function(item) 
      for i = 1, #result do 
        local areSame = false
        if strict then 
          areSame = result[i]:strictItemEquals(item)
        else
          areSame = result[i]:lenientItemEquals(item)
        end
        
        if areSame then 
          result[i].count = result[i].count + item.count
          return
        end
      end
      
      result[#result + 1] = item:clone()
    end
    
    for i = 1, 16 do
      if self.itemDetails[i] then 
        tryAdd(self.itemDetails[i])
      end
    end
    if other then 
      for i = 1, 16 do
        if other.itemDetails[i] then 
          tryAdd(self.itemDetails[i])
        end
      end
    end
    
    return result
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the change in items dofiled for this inventory to match the 
  -- contents of the other inventory.
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
  -- @param other  the inventory to compare with
  -- @param strict (optional) (default false) if items should be compared 
  --               strictly
  -- @return       a tuplet with 2 tables - the first containing what needs to 
  --               be added, the second containing what needs to be removed
  -----------------------------------------------------------------------------
  function Inventory:changeInItemsToGet(other, strict)
    if strict == nil then strict = false end
    
    local comb = self:combinedItemDetails(other, strict)
    local us = self:combinedItemDetails(nil, strict)
    local them = other:combinedItemDetails(nil, strict)
    
    local whatWeNeedMore = {}
    local whatWeNeedLess = {}
    for i = 1, #comb do 
      for j = 1, #us do 
        local areSame = false
        if strict then 
          areSame = us[j]:strictItemEquals(comb[i])
        else
          areSame = us[j]:lenientItemEquals(comb[i])
        end
        
        if areSame then 
          if us[j].count < comb[i].count then 
            whatWeNeedMore[#whatWeNeedMore + 1] = comb[i].count - us[j].count
          elseif us[j].count > comb[i].count then
            whatWeNeedLess[#whatWeNeedLess + 1] = us[j].count - comb[i].count
          end
        end
      end
    end
    
    return whatWeNeedMore, whatWeNeedLess
  end
  
  -----------------------------------------------------------------------------
  -- Compares this inventory with the turtles inventory and updates this 
  -- inventory. This function assumes that a single item or stack of items was
  -- acquired, and follows the typical path for item acquisition. Not 
  -- guarranteed to work in any other scenario.
  --
  -- Usage:
  --   local inv = twf.inventory.Inventory:new()
  --   inv:loadFromTurtle()
  --   turtle.select(1)
  --   turtle.suck()
  --   local newItem = inv:recentlyAcquiredItem(1)
  --   if newItem then 
  --     print('sucked ' .. newItem:toString())
  --   else
  --     print('nothing to suck')
  --   end
  -- 
  -- @param selectedSlot what slot the turtle had selected when it acquired the
  --                     new item / item stack
  -- @return             twf.inventory.ItemDetail if 1 item / item stack was 
  --                     just acquired, nil otherwise
  -- @error              If the turtle definitely did not just acquire either 
  --                     one item stack or no items.
  -----------------------------------------------------------------------------
  function Inventory:recentlyAcquiredItem(selectedSlot)
    local nextIndex = function(index) 
      local result = index + 1
      if result == 17 then return 1 end
      return result
    end
    
    local index = selectedSlot 
    local first = true
    
    while first or index ~= selectedSlot do
      if first then first = false end
      
      local turtleItem = twf.inventory.ItemDetail:safeNew(turtle.getItemDetail(index))
      local cachedItem = self.itemDetails[index]
      if turtleItem then 
        self.itemDetails[index] = turtleItem:clone()
      else
        self.itemDetails[index] = nil
      end
      
      if cachedItem then 
        if not turtleItem then 
          error('Impossible state, we LOST items in recentAcquiredItem!')
        end
        if turtleItem.count ~= cachedItem.count then
          if turtleItem.count < cachedItem.count then 
            error('Impossible state, we LOST items in recentlyAcquiredItem!')
          end
          
          local result = turtleItem:clone()
          result.count = turtleItem.count - cachedItem.count
          
          -- Have to check the next index - it may have overflowed. This loop will almost 
          -- always break early and be much faster than a full inventory check - but is 
          -- worse if theres a lot of partial stacks do to all the cloning
          local newInd = nextIndex(index)
          while newInd ~= index do 
            local nextTurtleItem = twf.inventory.ItemDetail:safeNew(turtle.getItemDetail(newInd))
            local nextCachedItem = self.itemDetails[newInd]
            if nextTurtleItem then 
              self.itemDetails[newInd] = nextTurtleItem:clone()
            else
              self.itemDetails[newInd] = nil
            end
            
            if nextCachedItem then 
              if not nextTurtleItem then 
                error('Impossible state, we LOST items in recentAcquiredItem!')
              end
              if nextCachedItem.count ~= nextTurtleItem.count then
                if nextTurtleItem.count < nextCachedItem.count then
                  error('Impossible state, we LOST items in recentlyAcquiredItem!')
                end
                -- Dont check name/damage, some items stack really strangely
                result.count = result.count + nextTurtleItem.count - nextCachedItem.count
              end
              -- can't be sure we're done when we reach a non-empty slot since we could have
              -- more items left.
            elseif nextTurtleItem then
              result.count = result.count + nextTurtleItem.count
              break -- If there was no item, then theres no way one stack will not be able to fit
            end
            
            newInd = nextIndex(newInd)
          end
          return result
        end
      elseif turtleItem then 
        return turtleItem
      end
      
      index = nextIndex(index)
    end
    
    return nil
  end
  
  -----------------------------------------------------------------------------
  -- Compares this inventory with the turtles inventory and updates this 
  -- inventory. This function assumes that a single item or stack of items was
  -- just lost, and that item was lost in the specified slot. Not guarranteed
  -- to work in another other scenario.
  --
  -- Usage:
  --   local inv = twf.inventory.Inventory:new()
  --   inv:loadFromTurtle()
  --   local selected = inv:firstIndexOFilledSlot()
  --   if selected < 1 then
  --     print('Nothing to drop!')
  --     return
  --   end
  --   turtle.select(selected)
  --   turtle.drop()
  --   local lostItem = inv:recentlyLostItem()
  --   print('Dropped ' .. lostItem:toString())
  --
  -- @param selectedSlot the slot that was selected when the item was lost
  -- @return             twf.inventory.ItemDetail of lost item, or nil if no
  --                     item was lost
  -----------------------------------------------------------------------------
  function Inventory:recentlyLostItem(selectedSlot)
    local cachedItem = self.itemDetails[selectedSlot]
    local turtleItem = twf.inventory.ItemDetail:safeNew(turtle.getItemDetail(selectedSlot))
    if turtleItem then 
      self.itemDetails[selectedSlot] = turtleItem:clone()
    else
      self.itemDetails[selectedSlot] = nil
    end
    
    if turtleItem then 
      if not cachedItem then 
        error('Impossible state! Items acquired in recentlyLostItem!')
      end
      if turtleItem.count > cachedItem.count then 
        error('Impossible state! Items acquired in recentlyLostItem!')
      end
      
      if turtleItem.count < cachedItem.count then 
        local result = cachedItem:clone()
        result.count = cachedItem.count - turtleItem.count
        return result
      end
    else
      if not cachedItem then 
        return nil
      end
      
      return cachedItem
    end
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
    local us = self:combinedItemDetails(nil, strict)
    local them = other:combinedItemDetails(nil, strict)
    
    if #us ~= #them then return false end
    
    for i = 1, #us do 
      local found = false
      for j = 1, #them do 
        if strict then 
          if us[i]:strictItemEquals(them[j]) then 
            found = us[i].count == them[j].count
            break
          end
        else 
          if us[i]:lenientItemEquals(them[j]) then 
            found = us[i].count == them[j].count 
            break
          end
        end
      end
      if not found then return false end
    end
    
    return true
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
    for i = 1, 16 do 
      if self.itemDetails[i] then 
        if not other.itemDetails[i] then return false end
        if not self.itemDetails[i]:equals(other.itemDetails[i]) then return false end
      elseif other.itemDetails[i] then 
        return false 
      end
    end
    
    return true
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
    local result = 31
    
    for i = 1, 16 do 
      if self.itemDetails[i] then 
        result = 17 * result + self.itemDetails[i]:hashCode()
      end
    end
    
    return result
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
    if     digResult == DigResult.DIG_SUCCESS    then return true
    elseif digResult == DigResult.NOTHING_TO_DIG then return true
    elseif digResult == DigResult.NO_ITEM        then return true
    elseif digResult == DigResult.NO_FUEL        then return false
    elseif digResult == DigResult.DIG_FAILED     then return false
    else error('Expected dig result but got ' .. digResult) end
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
    if     digResult == DigResult.DIG_SUCCESS    then return 'dig succeeded'
    elseif digResult == DigResult.NOTHING_TO_DIG then return 'dig succeeded: nothing to dig'
    elseif digResult == DigResult.NO_ITEM        then return 'dig succeeded: no item acquired'
    elseif digResult == DigResult.NO_FUEL        then return 'dig failed: no fiel'
    elseif digResult == DigResult.DIG_FAILED     then return 'dig failed: unknown'
    else error('Expected dig result but got ' .. digResult) end
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
  PlaceResult.NOTHING_TO_PLACE = 1013
  
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
    if     placeResult == PlaceResult.SUCCESS          then return true
    elseif placeResult == PlaceResult.NOTHING_TO_PLACE then return false
    elseif placeResult == PlaceResult.BLOCKED          then return false
    elseif placeResult == PlaceResult.FAILURE          then return false
    else error('Expected place result but got ' .. placeResult) end
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
    if     placeResult == PlaceResult.SUCCESS          then return 'place succeeded'
    elseif placeResult == PlaceResult.NOTHING_TO_PLACE then return 'place failed: no item to place'
    elseif placeResult == PlaceResult.BLOCKED          then return 'place failed: blocked'
    elseif placeResult == PlaceResult.FAILURE          then return 'place failed: unknown'
    else error('Expected place result but got ' .. placeResult) end
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
  -- Indicates that there is nothing to drop in the currently selected slot
  -----------------------------------------------------------------------------
  DropResult.NOTHING_TO_DROP = 7151
  
  -----------------------------------------------------------------------------
  -- Indicates that the turtle does not have enough fuel to drop items
  -----------------------------------------------------------------------------
  DropResult.NO_FUEL = 7159
  
  -----------------------------------------------------------------------------
  -- Indicates that the turtle did not drop items, but the reason cannot be 
  -- determined. This could be that there are no items to drop, the chests 
  -- inventory is full, or the turtle is dropping into a direction-aware
  -- chest-like object from the wrong direction
  -----------------------------------------------------------------------------
  DropResult.FAILURE = 7177
  
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
    if     dropResult == DropResult.SUCCESS         then return true
    elseif dropResult == DropResult.NOTHING_TO_DROP then return false
    elseif dropResult == DropResult.FAILURE         then return false
    elseif dropResult == DropResult.NO_FUEL         then return false
    else error('Expected drop result but got ' .. dropResult) end
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of the specified drop 
  -- result
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local DropResult = twf.inventory.DropResult
  --   local dr = DropResult.SUCCESS
  --   -- prints drop succeeded
  --   print(DropResult.toString(dr))
  --
  -- @param dropResult the drop result
  -- @return           string representation of dropResult
  -- @error            if dropResult is not a valid code
  -----------------------------------------------------------------------------
  function DropResult.toString(dropResult)
    if     dropResult == DropResult.SUCCESS         then return 'drop succeeded'
    elseif dropResult == DropResult.NOTHING_TO_DROP then return 'drop failed: nothing to drop'
    elseif dropResult == DropResult.FAILURE         then return 'drop failed: unknown'
    elseif dropResult == DropResult.NO_FUEL         then return 'drop failed: no fuel'
    else error('Expected drop result but got ' .. dropResult) end
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
    if     suckResult == SuckResult.SUCCESS then return true 
    elseif suckResult == SuckResult.NO_FUEL then return false 
    elseif suckResult == SuckResult.FAILURE then return false 
    else error('Expected suck result but got ' .. suckResult) end
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of the specified suck 
  -- result
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local SuckResult = twf.inventory.SuckResult
  --   local sr = SuckResult.SUCCESS
  --   -- prints suck succeeded
  --   print(SuckResult.toString(sr))
  --
  -- @param suckResult the suck result
  -- @return           string representation of suckResult
  -- @error            if suckResult is not a valid code
  -----------------------------------------------------------------------------
  function SuckResult.toString(suckResult)
    if     suckResult == SuckResult.SUCCESS then return 'suck succeeded' 
    elseif suckResult == SuckResult.NO_FUEL then return 'suck failed: no fuel'
    elseif suckResult == SuckResult.FAILURE then return 'suck failed: unknown'
    else error('Expected suck result but got ' .. suckResult) end
  end
  
  twf.inventory.SuckResult = SuckResult
end

-----------------------------------------------------------------------------
-- Describes the result of the turtle selecting a certain slot
-----------------------------------------------------------------------------
if not twf.inventory.SelectSlotResult then
  local SelectSlotResult = {}
  
  -----------------------------------------------------------------------------
  -- Indicates the slot was successfully selected
  -----------------------------------------------------------------------------
  SelectSlotResult.SUCCESS = 6791
  
  -----------------------------------------------------------------------------
  -- Indicates the slot could not be selected
  -----------------------------------------------------------------------------
  SelectSlotResult.FAILURE = 6793
  
  -----------------------------------------------------------------------------
  -- Returns if the specified select slot result indicates success
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   -- prints true
  --   print(twf.inventory.SelectSlotResult.isSuccess(twf.inventory.SelectSlotResult.SUCCESS))
  -- 
  -- @param selectSlotResult the select slot result
  -- @return                 if selectSlotResult indicates success
  -----------------------------------------------------------------------------
  function SelectSlotResult.isSuccess(selectSlotResult)
    if     selectSlotResult == SelectSlotResult.SUCCESS then return true
    elseif selectSlotResult == SelectSlotResult.FAILURE then return false
    else error('Expected SelectSlotResult for selectSlotResult but got ' .. selectSlotResult) end
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of the specified select  
  -- slot result
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local SelectSlotResult = twf.inventory.SelectSlotResult
  --   local ssr = SelectSlotResult.SUCCESS
  --   -- prints suck succeeded
  --   print(SelectSlotResult.toString(ssr))
  --
  -- @param selectSlotResult the select slot result
  -- @return           string representation of selectSlotResult
  -- @error            if selectSlotResult is not a valid code
  -----------------------------------------------------------------------------
  function SelectSlotResult.toString(selectSlotResult)
    if     selectSlotResult == SelectSlotResult.SUCCESS then return 'slot selected'
    elseif selectSlotResult == SelectSlotResult.FAILURE then return 'slot select failed: unknown'
    else error('Expected SelectSlotResult for selectSlotResult but got ' .. selectSlotResult) end
  end
  
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
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      
      local dirValid =       o.direction == twf.movement.direction.FORWARD
      dirValid = dirValid or o.direction == twf.movement.direction.UP
      dirValid = dirValid or o.direction == twf.movement.direction.DOWN
      
      if not dirValid then 
        error('Expected FORWARD, UP, or DOWN but got direction = ' .. o.direction)
      end
      
      return o
    end
    
    -----------------------------------------------------------------------------
    -- Detects if there is a block in the direction that is about to be dug in.
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.DigAction:new({direction = twf.movement.direction.UP})
    --   local det = act:detect() -- like turtle.detectUp()
    --
    -- @return true on block detected, false otherwise
    -----------------------------------------------------------------------------
    function DigAction:detect()
      if     self.direction == twf.movement.direction.FORWARD then return turtle.detect()
      elseif self.direction == twf.movement.direction.UP      then return turtle.detectUp()
      elseif self.direction == twf.movement.direction.DOWN    then return turtle.detectDown()
      else error('DigAction:detect has invalid direction!') end
    end
    
    -----------------------------------------------------------------------------
    -- Digs in the appropriate direction, returning true on success and false on 
    -- failure. Not usually called directly since its result is not as useful as
    -- the result from perform.
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.DigAction:new({direction = twf.movement.direction.UP})
    --   local succ = act:dig() -- like turtle.digUp
    --
    -- @return true on success, false on failure
    -----------------------------------------------------------------------------
    function DigAction:dig()
      if     self.direction == twf.movement.direction.FORWARD then return turtle.dig()
      elseif self.direction == twf.movement.direction.UP      then return turtle.digUp()
      elseif self.direction == twf.movement.direction.DOWN    then return turtle.digDown()
      else error('DigAction:dig has invalid direction!') end
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to dig once. 
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local digForward = twf.inventory.action.DigAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, item = digForward:perform(stateTurtle)
    --
    -- @param stateTurtle StatefulTurtle
    -- @return tuple of DigResult and ItemDetail for the result and mined items
    -----------------------------------------------------------------------------
    function DigAction:perform(stateTurtle)
      -- Digging related functions never truly fail and don't consume fuel, so 
      -- we update the inventory here.
      
      if not self:detect() then 
        return twf.inventory.DigResult.NOTHING_TO_DIG, nil
      end
      
      local succ = self:dig()
      
      if not succ then 
        return twf.inventory.DigResult.DIG_FAILED
      else
        local item = stateTurtle.inventory:recentlyAcquiredItem(stateTurtle.selectedSlot)
        if item then 
          return twf.inventory.DigResult.DIG_SUCCESS, item 
        else 
          return twf.inventory.DigResult.NO_ITEM, nil
        end
      end
    end
    
    -----------------------------------------------------------------------------
    -- No-op
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function DigAction:updateState(stateTurtle)
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
      local resultTable = {}
      
      resultTable.direction = twf.movement.direction.serialize(self.direction)
      
      return textutils.serialize(resultTable)
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
      local serTable = textutils.unserialize(serialized)
      
      local direction = twf.movement.direction.unserialize(serTable.direction)
      
      return DigAction:new({direction = direction})
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
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      
      local dirValid =       o.direction == twf.movement.direction.FORWARD
      dirValid = dirValid or o.direction == twf.movement.direction.DOWN
      dirValid = dirValid or o.direction == twf.movement.direction.UP
      
      if not dirValid then 
        error('Expected FORWARD, UP, or DOWN for direction but got ' .. o.direction)
      end
      
      return o
    end
    
    -----------------------------------------------------------------------------
    -- Detects if there is a block in the direction that a block is about to be 
    -- placed in 
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.PlaceAction:new({direction = twf.movement.direction.UP})
    --   local det = act:detect() -- like turtle.detectUp()
    --
    -- @return true on block detected, false otherwise
    -----------------------------------------------------------------------------
    function PlaceAction:detect()
      if     self.direction == twf.movement.direction.FORWARD then return turtle.detect()
      elseif self.direction == twf.movement.direction.UP      then return turtle.detectUp()
      elseif self.direction == twf.movement.direction.DOWN    then return turtle.detectDown()
      else error('PlaceAction:detect has invalid direction!') end
    end
    
    -----------------------------------------------------------------------------
    -- Places the item in the currently selected slot in the appropriate
    -- direction. Returns true if an item  was placed, false otherwise. Not 
    -- usually called directly, since its result isn't as useful as that from 
    -- perform(stateTurtle).
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.PlaceAction:new({direction = twf.movement.direction.FORWARD})
    --   local succ = act:place() -- like turtle.place()
    --
    -- @return true if an item was placed, false otherwise
    function PlaceAction:place()
      if     self.direction == twf.movement.direction.FORWARD then return turtle.place()
      elseif self.direction == twf.movement.direction.UP      then return turtle.placeUp()
      elseif self.direction == twf.movement.direction.DOWN    then return turtle.placeDown()
      else error('Unexpected direction in PlaceAction:place') end
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to place an item in the currently selected slot in the 
    -- appropriate direction
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local placeForward = twf.inventory.action.PlaceAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, item = placeForward:perform(stateTurtle)
    --
    -- @param stateTurtle StatefulTurtle
    -- @return tuple of PlaceResult and ItemDetail for the result and placed item
    -----------------------------------------------------------------------------
    function PlaceAction:perform(stateTurtle)
      if self:detect() then 
        return twf.inventory.PlaceResult.BLOCKED, nil
      end
      
      local succ = self:place()
      if succ then 
        local item = stateTurtle.inventory:recentlyLostItem(stateTurtle.selectedSlot)
        if item then 
          return twf.inventory.PlaceResult.SUCCESS, item
        else
          return twf.inventory.PlaceResult.NOTHING_TO_PLACE, nil
        end
      else
        return twf.inventory.PlaceResult.FAILURE, nil
      end
    end
    
    -----------------------------------------------------------------------------
    -- No-op
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function PlaceAction:updateState(stateTurtle)
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
      local resultTable = {}
      
      resultTable = twf.movement.direction.serialize(self.direction)
      
      return textutils.serialize(resultTable)
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
      local serTable = textutils.unserialize(serialized)
      
      local direction = twf.movement.direction.unserialize(serTable.direction)
      
      return PlaceAction:new({direction = direction})
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
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      
      local dirValid =       o.direction == twf.movement.direction.FORWARD
      dirValid = dirValid or o.direction == twf.movement.direction.UP 
      dirValid = dirValid or o.direction == twf.movement.direction.DOWN
      
      if not dirValid then 
        error('Expected FORWARD, UP, or DOWN for o.direction but got ' .. o.direction)
      end
      
      local amountValid = o.amount == nil
      amountValid = amountValid or type(o.amount) == 'number'
      
      if not amountValid then
        error('Expected nil or number for type(o.amount) but got ' .. type(o.amount))
      end
      
      if o.amount == nil then 
        o.amount = 64
      end
      
      return o
    end
    
    -----------------------------------------------------------------------------
    -- Drops items in the appropriate direction, returning true on success and 
    -- false on failure. Not usually called directly, since the result is not 
    -- as useful as that from perform(stateTurtle).
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
      if     self.direction == twf.movement.direction.FORWARD then return turtle.drop(self.amount)
      elseif self.direction == twf.movement.direction.UP      then return turtle.dropUp(self.amount)
      elseif self.direction == twf.movement.direction.DOWN    then return turtle.dropDown(self.amount)
      else error('Unexpected direction in DropAction:drop') end
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to drop the item.
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.DropAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, item = act:perform(stateTurtle)
    --
    -- @param stateTurtle StatefulTurtle
    -- @return tuple of DropResult and ItemDetail for the result and dropped item
    -----------------------------------------------------------------------------
    function DropAction:perform(stateTurtle)
      if not stateTurtle.inventory:getItemDetailAt(stateTurtle.selectedSlot) then 
        return twf.inventory.DropResult.NOTHING_TO_DROP, nil
      end
      
      local result = self:drop()
      
      if result then 
        local item = stateTurtle.inventory:recentlyLostItem(stateTurtle.selectedSlot)
        
        if item then 
          return twf.inventory.DropResult.SUCCESS, item
        else
          return twf.inventory.DropResult.FAILURE, nil
        end
      else
        return twf.inventory.DropResult.FAILURE, nil
      end
    end
    
    -----------------------------------------------------------------------------
    -- No-op
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function DropAction:updateState(stateTurtle)
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
      local resultTable = {}
      
      resultTable.direction = twf.movement.direction.serialize(self.direction)
      resultTable.amount = amount
      
      return textutils.serialize(resultTable)
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
      local serTable = textutils.unserialize(serialized)
      
      local direction = twf.movement.direction.unserialize(serTable.direction)
      local amount = serTable.amount
      
      return DropAction:new({direction = direction, amount = amount})
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
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      
      local dirValid =       o.direction == twf.movement.direction.FORWARD 
      dirValid = dirValid or o.direction == twf.movement.direction.UP
      dirValid = dirValid or o.direction == twf.movement.direction.DOWN 
      
      if not dirValid then 
        error('Expected FORWARD, UP, or DOWN for o.direction but got ' .. o.direction)
      end
      
      local amountValid =          type(o.amount) == 'nil'
      amountValid = amountValid or type(o.amount) == 'number'
      
      if not amountValid then 
        error('Expected nil or number for type(o.amount) but got ' .. type(o.amount))
      end
      
      if o.amount == nil then 
        o.amount = 64
      end
      
      return o
    end
    
    -----------------------------------------------------------------------------
    -- Sucks items from the appropriate direction, returning true on success and 
    -- false on failure. Not usually called directly, since the result is not 
    -- as useful as that from perform(stateTurtle).
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
      if     self.direction == twf.movement.direction.FORWARD then return turtle.suck(self.amount)
      elseif self.direction == twf.movement.direction.UP      then return turtle.suckUp(self.amount)
      elseif self.direction == twf.movement.direction.DOWN    then return turtle.suckDown(self.amount)
      else error('SuckAction:suck unexpected direction') end
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to suck the item.
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.SuckAction:new({direction = twf.movement.direction.FORWARD})
    --   local result, item = act:perform(stateTurtle)
    --
    -- @param stateTurtle StatefulTurtle
    -- @return tuple of SuckResult and ItemDetail for the result and sucked item
    -----------------------------------------------------------------------------
    function SuckAction:perform(stateTurtle)
      local succ = self:suck()
      
      if succ then 
        local item = stateTurtle.inventory:recentlyAcquiredItem(stateTurtle.selectedSlot)
        
        if item then 
          return twf.inventory.SuckResult.SUCCESS, item
        else
          return twf.inventory.SuckResult.FAILURE, nil
        end
      else 
        return twf.inventory.SuckResult.FAILURE, nil
      end
    end
    
    -----------------------------------------------------------------------------
    -- No-op
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function SuckAction:updateState(stateTurtle)
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
      local resultTable = {}
      
      resultTable.direction = twf.movement.direction.serialize(self.direction)
      resultTable.amount = self.amount
      
      return textutils.serialize(resultTable)
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
      local serTable = textutils.unserialize(serialized)
      
      local direction = twf.movement.direction.unserialize(serTable.direction)
      local amount = serTable.amount
      
      return SuckAction:new({direction = direction, amount = amount})
    end
    
    action.SuckAction = SuckAction
  end
  
  -----------------------------------------------------------------------------
  -- twf.inventory.action.SelectSlotAction
  --
  -- An action that selects a specific slot in the turtles inventory
  -----------------------------------------------------------------------------
  do 
    local SelectSlotAction = {}
    
    -----------------------------------------------------------------------------
    -- The slot index to select, a number between 1 and 16 (inclusive)
    -----------------------------------------------------------------------------
    local slotIndex = nil
    
    -----------------------------------------------------------------------------
    -- Creates a new instance of an action.
    -- 
    -- Usage: 
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.SelectSlotAction:new({slotIndex = 3})
    --
    -- @param o superseding object
    -- @return  a new instance of this action
    -----------------------------------------------------------------------------
    function SelectSlotAction:new(o)
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      
      if type(o.slotIndex) ~= 'number' then 
        error('Expected number for type(o.slotIndex) but got ' .. type(o.slotIndex))
      end
      
      if o.slotIndex < 1 or o.slotIndex > 16 then
        error('Expected o.slotIndex to be between 1 and 16, but got ' .. o.slotIndex)
      end
      
      return o
    end
    
    -----------------------------------------------------------------------------
    -- Selects the appropriate slot
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local act = twf.inventory.action.SelectSlotAction:new({slotIndex = 3})
    --   act:perform(st)
    --
    -- @param stateTurtle StatefulTurtle
    -- @return            twf.inventory.SelectSlotResult 
    -----------------------------------------------------------------------------
    function SelectSlotAction:perform(stateTurtle)
      local succ = turtle.select(self.slotIndex)
      
      if succ then 
        return twf.inventory.SelectSlotResult.SUCCESS
      else
        return twf.inventory.SelectSlotResult.FAILURE
      end
    end
    
    -----------------------------------------------------------------------------
    -- Called when this action completes successfully - should update the state
    -- of the turtle.
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local act = twf.inventory.action.SelectSlotAction:new({slotIndex = 3})
    --   local res = act:perform(st)
    --   if twf.inventory.SelectSlotResult.isSuccess(res) then 
    --     act:updateState(st)
    --   end
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function SelectSlotAction:updateState(stateTurtle)
      stateTurtle.selectedSlot = self.slotIndex
    end
    
    -----------------------------------------------------------------------------
    -- A unique name for this action type.
    --
    -- @return string, unique to this action type
    -----------------------------------------------------------------------------
    function SelectSlotAction.name()
      return 'twf.inventory.action.SelectSlotAction'
    end
    
    -----------------------------------------------------------------------------
    -- Serializes this action
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.SelectSlotAction:new({slotIndex = 3})
    --   local serialized = act:serialize()
    --   local unserialized = twf.inventory.action.SelectSlotAction.unserialize(serialized)
    -- 
    -- @return string serialization of this action
    -----------------------------------------------------------------------------
    function SelectSlotAction:serialize()
      local resultTable = {}
      
      resultTable.slotIndex = self.slotIndex
      
      return textutils.serialize(resultTable)
    end
    
    -----------------------------------------------------------------------------
    -- Unserializes an action serialized by the corresponding serialize function
    --
    -- Usage:
    --   dofile('twf_inventory.lua')
    --   local act = twf.inventory.action.SelectSlotAction:new({slotIndex = 3})
    --   local serialized = act:serialize()
    --   local unserialized = twf.inventory.action.SelectSlotAction.unserialize(serialized)
    -- 
    -- @param serialized string serialization of this action
    -- @return           action instance the serialized string represented
    -----------------------------------------------------------------------------
    function SelectSlotAction.unserialize(serialized)
      local serTable = textutils.unserialize(serialized)
      
      local slotIndex = serTable.slotIndex
      
      return SelectSlotAction:new({slotIndex = slotIndex})
    end
    
    action.SelectSlotAction = SelectSlotAction
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
    local result = oldNew(self, o)
    
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
    self.inventory:loadFromTurtle()
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
    local slot = self.inventory:firstIndexOf(itemDetail, strict)
    
    if slot < 0 then 
      return false
    end
    
    self:selectSlot(slot)
  end
  
  -----------------------------------------------------------------------------
  -- Selects the specified item slot
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.inventory.StatefulTurtle:new()
  --   st:selectSlot(1)
  --
  -- @param itemSlot the item slot to select, 1 through 16
  -----------------------------------------------------------------------------
  function StatefulTurtle:selectSlot(itemSlot)
    turtle.select(itemSlot)
    self.selectedSlot = itemSlot
  end
  
  -- Digging functions
  
  
  -----------------------------------------------------------------------------
  -- Attempts to dig, and returns the result of the action. If an item 
  -- is returned, the result is a tuple containing the dig result and the item 
  -- detail describing what was collected. Otherwise, returns the result code
  -- and nil.
  -- 
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local digResult, item = st:dig(twf.movement.direction.FORWARD)
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
  -- @param direct the direction to dig in
  -- @return a tuple {twf.inventory.DigResult, twf.inventory.ItemDetail or nil}
  -----------------------------------------------------------------------------
  function StatefulTurtle.dig(direction)
    local act = twf.inventory.action.DigAction:new({direction = direction})
    
    return act:perform(self)
  end
  
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
    return self:dig(twf.movement.direction.FORWARD)
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
    return self:dig(twf.movement.direction.UP)
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
    return self:dig(twf.movement.direction.DOWN)
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
  -- @param direction the direction to place in 
  -- @return a tuple {twf.inventory.PlaceResult, twf.inventory.ItemDetail or nil}
  -----------------------------------------------------------------------------
  function StatefulTurtle:place(direction)
    local act = twf.inventory.action.PlaceAction:new({direction = direction})
    
    return act:perform(self)
  end
  
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
    return self:place(twf.movement.direction.FORWARD)
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
    return self:place(twf.movement.direction.UP)
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
    return self:place(twf.movement.direction.DOWN)
  end
  
  -- Dropping functions
  
  -----------------------------------------------------------------------------
  -- Attempts to drop the items in the currently selected slot immediately in 
  -- the specified direction, or into a chest in that direction, and returns a 
  -- tuple for the result code and dropped items.
  --
  -- Usage:
  --   dofile('twf_inventory.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local dropResult, item = st:drop(twf.movement.direction.FORWARD)
  --   if not twf.inventory.DropResult.isSuccess(dropResult) then 
  --     error(twf.inventory.DropResult.toString(dropResult))
  --   end
  --   -- prints something like Dropped minecraft:log:1 x64
  --  print('Dropped ' .. item:toString())
  --
  -- @param direction the direction to drop in 
  -- @param amount (optional) number maximum things to drop
  -- @return       tuple {twf.inventory.DropResult, twf.inventory.ItemDetail}
  -----------------------------------------------------------------------------
  function StatefulTurtle:drop(direction, amount)
    local act = twf.inventory.action.DropAction:new({direction = direction, amount = amount})
    
    return act:perform(self)
  end
  
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
    return self:drop(twf.movement.direction.FORWARD, amount)
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
    return self:drop(twf.movement.direction.DOWN, amount)
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
    return self:drop(twf.movement.direction.UP, amount)
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
  --   local suckResult, item = st:suck(twf.movement.direction.FORWARD)
  --   if not twf.inventory.SuckResult.isSuccess(suckResult) then
  --     error(twf.inventory.SuckResult.toString(suckResult))
  --   end
  --   -- prints something like Sucked minecraft:log:1 x64
  --   print('Sucked ' .. item:toString())
  --
  -- @param direction the direction to suck in
  -- @param amount (optional) number maximum things to suck
  -- @return       tuple {twf.inventory.SuckResult, twf.inventory.ItemDetail}
  -----------------------------------------------------------------------------
  function StatefulTurtle:suck(direction, amount)
    local act = twf.inventory.action.SuckAction:new({direction = direction, amount = amount})
    
    return act:perform(self)
  end
  
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
    return self:suck(twf.movement.direction.FORWARD, amount)
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
    return self:suck(twf.movement.direction.DOWN, amount)
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
    return self:suck(twf.movement.direction.UP, amount)
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
    local base = oldSerialize(self)
    
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
  local oldUnserialize = StatefulTurtle.unserialize
  function StatefulTurtle.unserialize(serialized)
    local serTable = textutils.unserialize(serialized)
    
    local base = oldUnserialize(serTable.base)
    local inventory = twf.inventory.Inventory.unserialize(serTable.inventory)
    local selectedSlot = serTable.selectedSlot
    
    base.inventory = inventory
    base.selectedSlot = selectedSlot
    
    return base
  end
  
  -----------------------------------------------------------------------------
  -- Loads the stateful turtle instance or creates a new one, depending on if 
  -- the save file or action recovery file corresponding to the specified file
  -- prefix exist.
  --
  -- The save file is simply the file prefix + .dat
  -- The action recovery file is the file prefix + _action_recovery.dat
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   -- First searches for the action recovery file
  --   -- turtle_state_action_recovery.dat.
  --   -- Next searches for the safe file turtle_state.dat
  --   -- Finally, initializes a new stateful turtle
  --   local st = twf.movement.StatefulTurtle.loadOrInit('turtle_state')
  --
  -- @param filePrefix the file prefix for the save and action recovery files
  -- @return the saved stateful turtle or a new one
  -----------------------------------------------------------------------------
  local oldLoadOrInit = StatefulTurtle.loadOrInit
  function StatefulTurtle.loadOrInit(filePrefix)
    local res = oldLoadOrInit(filePrefix)
    res:loadInventoryFromTurtle()
    res.selectedSlot = turtle.getSelectedSlot()
    return res
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
  local oldClone = StatefulTurtle.clone
  function StatefulTurtle:clone()
    local base = oldClone(self)
    
    base.inventory = self.inventory:clone()
    base.selectedSlot = selectedSlot
    
    return base
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
  local oldToString = StatefulTurtle.toString
  function StatefulTurtle:toString()
    return oldToString(self) .. ' inventory: ' .. self.inventory:toString()
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
  local oldEquals = StatefulTurtle.equals
  function StatefulTurtle:equals(other)
    if not oldEquals(self, other) then return false end
    
    if not self.inventory:equals(other.inventory) then return false end
    if self.selectedSlot ~= other.selectedSlot then return false end
    
    return true
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
  local oldHashCode = StatefulTurtle.hashCode
  function StatefulTurtle:hashCode()
    local result = oldHashCode(self)
    
    result = 17 * result + self.inventory:hashCode()
    result = 17 * result + self.selectedSlot
    
    return result
  end
  
  StatefulTurtle.INVENTORY_EXTENSIONS = true
end