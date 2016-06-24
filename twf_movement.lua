-----------------------------------------------------------------------------
-- twf_movement.lua
-- 
-- This file contains all pertinent objects for abstractions regarding 
-- movement. 
-- 
-- @author Timothy 
-- @namespace twf.movement
-----------------------------------------------------------------------------

if not twf then twf = {} end
if not twf.movement then twf.movement = {} end

-----------------------------------------------------------------------------
-- twf.movement.direction
-- 
-- Contains constants and maths to relate between both absolute directions
-- (north, south, ...) and relative directions (left, right, ...)
-----------------------------------------------------------------------------

if not twf.movement.direction then
  local direction = {}
  
  -- Cardinal directions
  direction.NORTH = 1
  direction.EAST  = 2
  direction.SOUTH = 3
  direction.WEST  = 4
  direction.UP    = 5
  direction.DOWN  = 6
  
  -- Coordinate directions
  direction.NEGATIVE_Z = direction.NORTH
  direction.POSITIVE_X = direction.EAST
  direction.POSITIVE_Z = direction.SOUTH
  direction.NEGATIVE_X = direction.WEST
  direction.POSITIVE_Y = direction.UP
  direction.NEGATIVE_Y = direction.DOWN
  
  -- Relative directions
  direction.FORWARD = 11
  direction.RIGHT   = 12
  direction.BACK    = 13
  direction.LEFT    = 14
  
  -- Relative directions like clocks looking down at the turtle from above
  direction.CLOCKWISE         = direction.RIGHT
  direction.COUNTER_CLOCKWISE = direction.LEFT
  
  -- Relating a cardinal direction with a change in coordinates
  
  -----------------------------------------------------------------------------
  -- Returns the change in x by going in the specified absolute direction 
  -- one unit.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --   
  --   -- prints 1
  --   print(direction.changeInX(direction.EAST)) 
  -- 
  -- @param dir an absolute direction.
  -- @return    a number for the change in x when moving in the specified
  --            direction
  -- @error     if dir is not a valid, absolute direction
  --
  -----------------------------------------------------------------------------
  function direction.changeInX(dir)
    if     dir == direction.NEGATIVE_Z then return 0
    elseif dir == direction.POSITIVE_X then return 1
    elseif dir == direction.POSITIVE_Z then return 0
    elseif dir == direction.NEGATIVE_X then return -1
    elseif dir == direction.POSITIVE_Y then return 0
    elseif dir == direction.NEGATIVE_Y then return 0
    else
      error('Expected absolute direction but got ' .. dir .. ' (type: ' .. type(dir) .. ') (toString: ' .. direction.toString(dir) .. ')')
    end
  end
  
  
  -----------------------------------------------------------------------------
  -- Returns the change in y by going in the specified absolute direction one 
  -- unit.
  -- 
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --   
  --   -- prints 1
  --   print(direction.changeInY(direction.UP)) 
  --
  -- @param dir an absolute direction
  -- @return    a number for the change in y when moving in the specified
  --            direction
  -- @error     if dir is not a valid, absolute direction
  -----------------------------------------------------------------------------
  function direction.changeInY(dir)
    if     dir == direction.NEGATIVE_Z then return 0
    elseif dir == direction.POSITIVE_X then return 0
    elseif dir == direction.POSITIVE_Z then return 0
    elseif dir == direction.NEGATIVE_X then return 0
    elseif dir == direction.POSITIVE_Y then return 1
    elseif dir == direction.NEGATIVE_Y then return -1
    else
      error('Expected absolute direction but got ' .. dir .. ' (type: ' .. type(dir) .. ') (toString: ' .. direction.toString(dir) .. ')')
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns the change in z by going in the specified absolute direction one 
  -- unit.
  -- 
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --   
  --   -- prints 1
  --   print(direction.changeInZ(direction.SOUTH)) 
  --
  -- @param dir an absolute direction
  -- @return    a number for the change in z when moving in the specified
  --            direction
  -- @error     if dir is not a valid, absolute direction
  -----------------------------------------------------------------------------
  function direction.changeInZ(dir)
    if     dir == direction.NEGATIVE_Z then return -1
    elseif dir == direction.POSITIVE_X then return 0
    elseif dir == direction.POSITIVE_Z then return 1
    elseif dir == direction.NEGATIVE_X then return 0
    elseif dir == direction.POSITIVE_Y then return 0
    elseif dir == direction.NEGATIVE_Y then return 0
    else
      error('Expected absolute direction but got ' .. dir .. ' (type: ' .. type(dir) .. ') (toString: ' .. direction.toString(dir) .. ')')
    end
  end
  
  -- Altering a direction with a relative direction
  
  -----------------------------------------------------------------------------
  -- Returns the direction that comes from going relDir in dir. 
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   -- prints west (-x)
  --   print(direction.toString(direction.alter(direction.NORTH, direction.CLOCKWISE)))
  --
  --   -- prints up (+y)
  --   print(direction.toString(direction.alter(direction.UP, direction.CLOCKWISE)))
  --
  --   -- prints down (-y)
  --   print(direction.toString(direction.alter(direction.UP, direction.BACK)))
  --
  --   -- prints south (+z)
  --   print(direction.toString(direction.alter(direction.NORTH, direction.BACK))
  --
  -- @param dir    a direction
  -- @param relDir a relative direction
  -- @return       a direction (number) relDir of dir
  -- @error        if absDir is not a valid direction
  --               if relDir is not a valid relative direction
  -----------------------------------------------------------------------------
  function direction.alter(dir, relDir)
    if not direction.isDirection(dir) then 
      error('Expected dir to be a direction, but is ' .. dir)
    end
    if not direction.isRelative(relDir) then
      error('Expected relDir to be relative, but is ' .. direction.toString(relDir))
    end
    
    if relDir == direction.CLOCKWISE then 
      if     dir == direction.NORTH   then return direction.EAST
      elseif dir == direction.EAST    then return direction.SOUTH
      elseif dir == direction.SOUTH   then return direction.WEST
      elseif dir == direction.WEST    then return direction.NORTH
      elseif dir == direction.FORWARD then return direction.LEFT
      elseif dir == direction.LEFT    then return direction.BACK
      elseif dir == direction.BACK    then return direction.RIGHT
      elseif dir == direction.RIGHT   then return direction.FORWARD
      elseif dir == direction.UP      then return direction.UP
      elseif dir == direction.DOWN    then return direction.DOWN end
    elseif relDir == direction.COUNTER_CLOCKWISE then
      if     dir == direction.NORTH   then return direction.WEST
      elseif dir == direction.WEST    then return direction.SOUTH
      elseif dir == direction.SOUTH   then return direction.EAST
      elseif dir == direction.EAST    then return direction.NORTH
      elseif dir == direction.FORWARD then return direction.RIGHT
      elseif dir == direction.RIGHT   then return direction.BACK
      elseif dir == direction.BACK    then return direction.LEFT
      elseif dir == direction.LEFT    then return direction.FORWARD
      elseif dir == direction.UP      then return direction.UP
      elseif dir == direction.DOWN    then return direction.DOWN end
    elseif relDir == direction.BACK then
      if     dir == direction.NORTH   then return direction.SOUTH
      elseif dir == direction.SOUTH   then return direction.NORTH
      elseif dir == direction.WEST    then return direction.EAST
      elseif dir == direction.EAST    then return direction.WEST
      elseif dir == direction.FORWARD then return direction.BACK
      elseif dir == direction.RIGHT   then return direction.LEFT
      elseif dir == direction.BACK    then return direction.FORWARD
      elseif dir == direction.LEFT    then return direction.RIGHT
      elseif dir == direction.UP      then return direction.DOWN
      elseif dir == direction.DOWN    then return direction.UP end
    elseif relDir == direction.FORWARD then
      return dir
    elseif relDir == direction.UP then
      return direction.UP
    elseif relDir == direction.DOWN then 
      return direction.DOWN
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns the absolute direction that comes from going clockwise of the 
  -- specified absolute direction. 
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   -- prints west (-x)
  --   print(direction.toString(direction.clockwiseOf(direction.NORTH)))
  -- 
  -- @param dir an absolute direction
  -- @return    an absolute direction (number) clockwise of dir
  -- @error     if dir is not a valid absolute direction
  -----------------------------------------------------------------------------
  function direction.clockwiseOf(dir)
      return direction.alter(dir, direction.CLOCKWISE)
  end
  
  
  -----------------------------------------------------------------------------
  -- Returns the absolute direction that comes from going counterclockwise of
  -- the specified absolute direction
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   -- prints east (+x)
  --   print(direction.toString(direction.counterClockwiseOf(direction.NORTH)))
  -- 
  -- @param dir an absolute direction
  -- @return    an absolute direction (number) counterclockwise of dir
  -- @error     if dir is not a valid absolute direction
  -----------------------------------------------------------------------------
  function direction.counterClockwiseOf(dir)
    return direction.alter(dir, direction.COUNTER_CLOCKWISE)
  end
  
  -----------------------------------------------------------------------------
  -- Returns the direction that comes from going in the opposite 
  -- direction of the specified direction.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  -- 
  --   -- prints south (+z)
  --   print(direction.toString(direction.inverse(direction.NORTH)))
  -- 
  -- @param dir a direction
  -- @return    the direction (number) opposite of the specified 
  --            direction
  -- @error     if dir is not a valid direction
  -----------------------------------------------------------------------------
  function direction.inverse(dir)
    if dir == direction.UP then return direction.DOWN 
    elseif dir == direction.DOWN then return direction.UP end
    
    return direction.alter(dir, direction.BACK)
  end
  
  -- Identify functions
  
  -----------------------------------------------------------------------------
  -- Returns if the specified direction is a valid direction
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   -- prints true
  --   print(direction.isDirection(direction.NORTH))
  --
  --   -- prints false
  --   print(direction.isDirection('potato'))
  --
  -- @param dir a (potential) direction
  -- @return    a boolean that is true if dir is a direction, false otherwise
  -----------------------------------------------------------------------------
  function direction.isDirection(dir)
    if     dir == direction.NORTH   then return true 
    elseif dir == direction.SOUTH   then return true
    elseif dir == direction.WEST    then return true
    elseif dir == direction.EAST    then return true
    elseif dir == direction.UP      then return true
    elseif dir == direction.DOWN    then return true
    elseif dir == direction.FORWARD then return true
    elseif dir == direction.BACK    then return true
    elseif dir == direction.LEFT    then return true
    elseif dir == direction.RIGHT   then return true
    else return false end
  end
  
  -----------------------------------------------------------------------------
  -- Returns if the specified direction is absolute.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --   
  --   -- prints true
  --   print(direction.isAbsolute(direction.NORTH))
  --
  -- @param dir a direction
  -- @return    a boolean that is true if dir is absolute, false otherwise
  -- @error     if dir is not a valid direction
  -----------------------------------------------------------------------------
  function direction.isAbsolute(dir)
    if     dir == direction.NORTH   then return true 
    elseif dir == direction.SOUTH   then return true
    elseif dir == direction.WEST    then return true
    elseif dir == direction.EAST    then return true
    elseif dir == direction.UP      then return true
    elseif dir == direction.DOWN    then return true
    else return false end
  end
  
  -----------------------------------------------------------------------------
  -- Returns if the specified direction is relative
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --   
  --   -- prints true
  --   print(direction.isRelative(direction.LEFT))
  --
  -- @param dir a direction
  -- @return    a boolean that is true if dir is relative, false otherwise
  -- @error     if dir is not a valid direction
  -----------------------------------------------------------------------------
  function direction.isRelative(dir)
    if     dir == direction.UP      then return true
    elseif dir == direction.DOWN    then return true
    elseif dir == direction.FORWARD then return true
    elseif dir == direction.BACK    then return true
    elseif dir == direction.LEFT    then return true
    elseif dir == direction.RIGHT   then return true
    else return false end
  end
  
  -- Serialization functions
  
  -----------------------------------------------------------------------------
  -- Converts the specified direction to an object that can be serialized
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   local myInfo = {dir = direction.serializableObject(direction.FORWARD) }
  --   local serialized = textutils.serialize(myInfo)
  --   local unserialized = textutils.unserialize(myInfo)
  --   unserialized.dir = direction.unserializeObject(unserialized.dir)
  --
  -- @param dir the direction to serialize into a table
  -- @return something that can be serialized with textutils 
  -----------------------------------------------------------------------------
  function direction.serializableObject(dir)
    if not direction.isDirection(dir) then 
      error('Expected direction but got ' .. dir)
    end
    
    return dir
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the specified object that was serialized using 
  -- serializableObject.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   local myInfo = {dir = direction.serializableObject(direction.FORWARD) }
  --   local serialized = textutils.serialize(myInfo)
  --   local unserialized = textutils.unserialize(myInfo)
  --   unserialized.dir = direction.unserializeObject(unserialized.dir)
  --
  -- @param serObj the object returned from the matching serializableObject fn
  -- @return a direction
  -----------------------------------------------------------------------------
  function direction.unserializeObject(serObj)
    local dir = serObj
    
    if not direction.isDirection(dir) then 
      error('Expected direction but got ' .. dir)
    end
    
    return dir
  end
  
  -----------------------------------------------------------------------------
  -- Serializes the specified direction into a string, that can be unserialized
  -- using unserialize
  -- 
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   local serialized = direction.serialize(direction.NORTH)
  --   local unserialized = direction.unserialize(serialized)
  --   -- prints true
  --   print(direction.equals(direction.NORTH, unserialized))
  --
  -- @param dir the direction to serialize
  -- @return    a string that can be unserialized representing dir
  -- @error     if dir is not a valid direction
  -----------------------------------------------------------------------------
  function direction.serialize(dir)
    return textutils.serialize(direction.serializableObject(dir))
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the specified string that was acquired from serialize.
  -- 
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   local serialized = direction.serialize(direction.NORTH)
  --   local unserialized = direction.unserialize(serialized)
  --   -- prints true
  --   print(direction.equals(direction.NORTH, unserialized))
  --
  -- @param serializedDir the string from serialize
  -- @return              the direction that was given to serialize
  -- @error               if the string is not a valid serialization
  -----------------------------------------------------------------------------
  function direction.unserialize(serializedDir)
    local serObj = textutils.unserialize(serializedDir)
    
    return direction.unserializeObject(serObj)
  end
  
  -- Miscellaneous functions
  
  -----------------------------------------------------------------------------
  -- Converts the direction to a human-readable cardinal representation. If
  -- the direction is not absolute (e.g. it's relative), an error is thrown.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   -- prints east
  --   print(direction.toCardinalString(direction.EAST))
  
  --   -- prints east
  --   print(direction.toCardinalString(direction.POSITIVE_X))
  --
  -- @param dir an absolute direction
  -- @return    a string representing the direction using cardinal language
  -- @error     if dir is not an absolute direction
  -----------------------------------------------------------------------------
  function direction.toCardinalString(dir)
    if not direction.isAbsolute(dir) then 
      error('Expected absolute direction but got ' .. dir)
    end
    
    if     dir == direction.NORTH   then return 'north' 
    elseif dir == direction.SOUTH   then return 'south'
    elseif dir == direction.WEST    then return 'west'
    elseif dir == direction.EAST    then return 'east'
    elseif dir == direction.UP      then return 'up'
    elseif dir == direction.DOWN    then return 'down'
    end
  end
  
  -----------------------------------------------------------------------------
  -- Converts the direction to a human-readable coordinate representation. If 
  -- the direction is not absolute (e.g. it's relative), an error is thrown.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   -- prints positive x
  --   print(direction.toCardinalString(direction.EAST))
  
  --   -- prints positive x
  --   print(direction.toCardinalString(direction.POSITIVE_X))
  --
  -- @param dir an absolute direction
  -- @return    a string representing the direction using coordinate language
  -----------------------------------------------------------------------------
  function direction.toCoordinateString(dir)
    if not direction.isAbsolute(dir) then 
      error('Expected absolute direction but got ' .. dir)
    end
    
    if     dir == direction.POSITIVE_X   then return 'positive x' 
    elseif dir == direction.NEGATIVE_X   then return 'negative x'
    elseif dir == direction.POSITIVE_Y   then return 'positive y'
    elseif dir == direction.NEGATIVE_Y   then return 'negative y'
    elseif dir == direction.POSITIVE_Z   then return 'positive z'
    elseif dir == direction.NEGATIVE_Z   then return 'negative z'
    end
  end
  
  
  -----------------------------------------------------------------------------
  -- Converts the direction to a human-readable relative representation. If the
  -- direction is not relative (e.g. it's absolute), an error is thrown.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   -- prints left
  --   print(direction.toCardinalString(direction.LEFT))
  
  --   -- prints right
  --   print(direction.toCardinalString(direction.RIGHT))
  --
  -- @param dir a relative direction
  -- @return    a string representing the direction using coordinate language
  -----------------------------------------------------------------------------
  function direction.toRelativeString(dir)
    if not direction.isRelative(dir) then 
      error('Expected relative direction but got ' .. dir)
    end
    
    if     dir == direction.UP      then return 'up'
    elseif dir == direction.DOWN    then return 'down'
    elseif dir == direction.FORWARD then return 'forward'
    elseif dir == direction.BACK    then return 'back'
    elseif dir == direction.LEFT    then return 'left'
    elseif dir == direction.RIGHT   then return 'right'
    end
  end
  
  -----------------------------------------------------------------------------
  -- Converts the direction into a human-readable string. Cardinal and 
  -- coordinate directions are shown in both formats. Invalid directions do not
  -- throw exceptions, but rather return "invalid".
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   -- prints east (+x)
  --   print(direction.toString(direction.EAST)) 
  --
  --   -- prints left
  --   print(direction.toString(direction.LEFT))
  --
  --   -- prints invalid
  --   print(direction.toString("bob"))
  --
  -- @param dir the cardinal, coordinate, or relative direction
  -- @return    a string representing the direction
  -----------------------------------------------------------------------------
  function direction.toString(dir)
    if not direction.isDirection(dir) then
      error('Expected direction but got ' .. dir)
    end
    
    if     dir == direction.NORTH   then return 'north (-z)' 
    elseif dir == direction.SOUTH   then return 'south (+z)'
    elseif dir == direction.WEST    then return 'west (-x)'
    elseif dir == direction.EAST    then return 'east (+x)'
    elseif dir == direction.UP      then return 'up (+y)'
    elseif dir == direction.DOWN    then return 'down (-y)'
    elseif dir == direction.FORWARD then return 'forward'
    elseif dir == direction.BACK    then return 'back'
    elseif dir == direction.LEFT    then return 'left'
    elseif dir == direction.RIGHT   then return 'right'
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns if the two specified directions are equal to each other
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   -- prints true
  --   print(direction.equals(direction.NORTH, direction.NEGATIVE_Z))
  -- 
  -- @param dir1 a direction
  -- @param dir2 a direction
  -- @return     if dir1 is equal to dir2
  -- @error      if dir1 isn't a direction or dir2 isn't a direction
  -----------------------------------------------------------------------------
  function direction.equals(dir1, dir2)
    if not direction.isDirection(dir1) then
      error('Expected direction for dir1 but got ' .. dir1)
    end
    if not direction.isDirection(dir2) then
      error('Expected direction for dir2 but got ' .. dir2)
    end
    
    return dir1 == dir2
  end
  
  
  -----------------------------------------------------------------------------
  -- Computes the hashcode of the specified direction
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  --
  --   -- prints true
  --   print(direction.hashCode(direction.NORTH) ~= direction.hashCode(direction.SOUTH))
  --
  -- @param dir a direction
  -- @return    a hash code of dir
  -- @error     if dir isn't a direction
  -----------------------------------------------------------------------------
  function direction.hashCode(dir)
    if not direction.isDirection(dir) then 
      error('Expected direction but got ' .. dir)
    end
    
    return 31 * dir
  end
  
  twf.movement.direction = direction
end

-----------------------------------------------------------------------------
-- twf.movement.Position
-- 
-- Describes a three-dimensional position, containing x, y,  and z using the
-- same axis that are seen in-game.
-----------------------------------------------------------------------------
if not twf.movement.position then
  local Position = {}
  
  -- Instance variables
  
  -----------------------------------------------------------------------------
  -- The x-coordinate of this instance
  -- @type number
  -----------------------------------------------------------------------------
  Position.x = 0
  
  -----------------------------------------------------------------------------
  -- The y-coordinate of this instance
  -- @type number
  -----------------------------------------------------------------------------
  Position.y = 0
  
  -----------------------------------------------------------------------------
  -- The z-coordinate of this instance
  -- @type number
  -----------------------------------------------------------------------------
  Position.z = 0
  
  -- Constructors 
  
  -----------------------------------------------------------------------------
  -- Creates a new position object and returns it.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local p = Position:new()
  --   -- prints 0
  --   print(p.x) 
  --   
  --   p = Position:new({x = 1, y = 5, z = 2})
  --   -- prints 1
  --   print(p.x)
  --
  -- @param o (optional) the object that is inheriting from Position
  -- @return             an object that has all the functions of a Position 
  --                     object
  -----------------------------------------------------------------------------
  function Position:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
  end
  
  -- Math
  
  -----------------------------------------------------------------------------
  -- Calculates the squared euclidean distance to the other position
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local p1 = Position:new({x = 0, y = 0, z = 0})
  --   local p2 = Position:new({x = 0, y = 5, z = 12})
  --   local distSqr = p1:euclideanDistanceSquaredTo(p2)
  --   -- prints 169 (13^2)
  --   print(distSqr)
  --
  -- Remarks:
  --   This is symmetric, i.e. for points p1 and p2:
  --   p1.euclideanDistanceSquaredTo(p2) == p2.euclideanDistanceSquaredTo(p1)
  -- 
  -- @param other the position to calculate distance squared to
  -- @return      the euclidean distance squared to the other point
  -----------------------------------------------------------------------------
  function Position:euclideanDistanceSquaredTo(other)
    return (self.x - other.x) * (self.x - other.x) +
           (self.y - other.y) * (self.y - other.y) +
           (self.z - other.z) * (self.z - other.z)
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the euclidean distance to the other position. 
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local p1 = Position:new({x = 0, y = 0, z = 0})
  --   local p2 = Position:new({x = 3, y = 4, z = 0})
  --   local dist = p1:euclideanDistanceTo(p2)
  --   -- prints 5
  --   print(dist) 
  -- 
  -- Remarks:
  --   Should be substituted with euclidean distance squared when possible
  --   to remove the need to take the square root.
  --
  -- @param other position to calculate euclidean distance to
  -- @return      number for the euclidean distance from this point to the
  --              other point
  -----------------------------------------------------------------------------
  function Position:euclideanDistanceTo(other)
    return math.sqrt(self:euclidanceDistanceSquaredTo(other))
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the manhattan distance to the other position.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local p1 = Position:new({x = 0, y = 0, z = 0})
  --   local p2 = Position:new({x = 2, y = 3, z = 5})
  --   local dist = p1:manhattanDistance(p2)
  --   -- prints 10
  --   print(dist)
  --
  -- Remarks:
  --   The manhattan distance is symmetric, i.e. for points p1 and p2
  --   p1.manhattanDistance(p2) == p2.manhattanDistance(p1)
  --
  -- @param other the position to calculate manhattan distance to
  -- @return      the manhattan distance to the other point
  -----------------------------------------------------------------------------
  function Position:manhattanDistance(other)
    return math.abs(self.x - other.x) + math.abs(self.y - other.y) + math.abs(self.z - other.z)
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the vector that points from this point to the specified other
  -- point, with appropriate magnitude
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local Vector = twf.movement.Vector
  --
  --   local p1 = Position:new({x = -1, y = 1, z = 0})
  --   local p2 = Position:new({x = 0, y = 1, z = 0})
  --   local v = p1:vectorTo(p2)
  --   -- prints <1, 0, 0>
  --   print(v.toString())
  --
  -- @param other the other position to get the vector to
  -- @return      vector from this position to the specified other position
  -- @error       if this position and the other position are the same
  -----------------------------------------------------------------------------
  function Position:vectorTo(other)
    return twf.movement.Vector:new({x = (other.x - self.x), y = (other.y - self.y), z = (other.z - self.z)})
  end
  
  -- Serialization
  
  -----------------------------------------------------------------------------
  -- Returns an object that can be serialized with textutils
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local obj = twf.movement.Position:new()
  --   local data = { pos = obj:serializableObject() }
  --   local serialized = textutils.serialize(data)
  --   local unserialized = textutils.unserialize(data)
  --   unserialized.pos = twf.movement.Position.unserializeObject(unserialized.pos)
  --
  -- @return object serializable using textutils
  -----------------------------------------------------------------------------
  function Position:serializableObject()
    local resultTable = {}
    
    resultTable.x = self.x
    resultTable.y = self.y
    resultTable.z = self.z
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Returns the object that was serialized with serializableObject
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local obj = twf.movement.Position:new()
  --   local data = { pos = obj:serializableObject() }
  --   local serialized = textutils.serialize(data)
  --   local unserialized = textutils.unserialize(data)
  --   unserialized.pos = twf.movement.Position.unserializeObject(unserialized.pos)
  --
  -- @return object serializable using textutils
  -----------------------------------------------------------------------------
  function Position.unserializeObject(serObj)
    local x = serObj.x
    local y = serObj.y
    local z = serObj.z
    
    return Position:new({x = x, y = y, z = z})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this instance into something unserializable
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local obj = twf.movement.Position:new()
  --   local serialized = obj:serialize()
  --   local unserialized = twf.movement.Position.unserialize(serialized)
  --
  -- @return a string serialization of this instance
  -----------------------------------------------------------------------------
  function Position:serialize()
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the serialized object into the original object
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local obj = twf.movement.Position:new()
  --   local serialized = obj:serialize()
  --   local unserialized = twf.movement.Position.unserialize(serialized)
  --
  -- @param serialized a string from serialize()
  -- @return           the position the serialized string represents
  -----------------------------------------------------------------------------
  function Position.unserialize(serialized)
    return Position.unserializeObject(textutils.unserialize(serialized))
  end
  
  -- Miscellaneous
  -----------------------------------------------------------------------------
  -- Returns the vector with the same information as one from the origin to 
  -- this position.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local Vector = twf.movement.Vector
  --   local p = Position:new({x = 0, y = 1, z = 0})
  --   local v = p:toVector()
  --   -- prints 1
  --   print(v.deltaY)
  --
  -- @returns twf.movement.Vector representation of this position
  -----------------------------------------------------------------------------  
  function Position:toVector()
    return twf.movement.Vector:new({deltaX = self.x, deltaY = self.y, deltaZ = self.z})
  end
  
  -----------------------------------------------------------------------------
  -- Clones this position object - returning a loggically equivalent but
  -- different instance of position.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local p = Position:new({x = 3, y = 2, z = 5})
  --   local p2 = p:clone()
  --   -- prints true
  --   print(p:equals(p2))
  --   p.x = p.x + 1
  --   -- prints false
  --   print(p:equals(p2))
  --
  -- @return a position instance with the same state as this one
  -----------------------------------------------------------------------------
  function Position:clone()
    return Position:new({x = self.x, y = self.y, z = self.z})
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable, concise representation of this position
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local p1 = Position:new({x = 0, y = 1, z = 2})
  --   -- prints (0, 1, 2)
  --   print(p1:toString())
  --
  -- @return a human-readable string representing this position
  -----------------------------------------------------------------------------
  function Position:toString()
    return '(' .. self.x .. ', ' .. self.y .. ', ' .. self.z .. ')'
  end
  
  -----------------------------------------------------------------------------
  -- Returns if the specified other position is logically equivalent to this 
  -- instance.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local p1 = Position:new({x = 2, y = 2, z = 2})
  --   local p2 = Position:new({x = 2, y = 2, z = 2})
  --   -- prints true
  --   print(p1.equals(p2))
  --
  -- @param other the other position to compare to
  -- @return      boolean true if they are logically equal, false otherwise
  -----------------------------------------------------------------------------
  function Position:equals(other)
    if self.x ~= other.x then return false end
    if self.y ~= other.y then return false end
    if self.z ~= other.z then return false end
    return true
  end
  
  -----------------------------------------------------------------------------
  -- Returns a reasonable hash code for this position instance.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local p1 = Position:new({x = 2, y = 1, z = 2})
  --   local p2 = Position:new({x = 1, y = 2, z = 2})
  --   -- prints true
  --   print(p1.hashCode() ~= p2.hashCode())
  --   
  -- @return the hash code of this position
  -----------------------------------------------------------------------------
  function Position:hashCode()
    local result = 31
    
    result = 17 * result + self.x
    result = 17 * result + self.y
    result = 17 * result + self.z
    
    return result
  end
  
  twf.movement.Position = Position
end

-----------------------------------------------------------------------------
-- twf.movement.Vector
--
-- Describes a vector in three dimensions. Contains the same information
-- as a position, but is seperated to prevent a lot of accidential errors 
-- caused from treating positions as vectors and vice-versa.
-----------------------------------------------------------------------------
if not twf.movement.Vector then
  local Vector = {}
  
  -----------------------------------------------------------------------------
  -- Describes the change in x for this vector
  -- 
  -- @type number
  -----------------------------------------------------------------------------
  Vector.deltaX = 0
  
  -----------------------------------------------------------------------------
  -- Describes the change in y for this vector
  --
  -- @type number
  -----------------------------------------------------------------------------
  Vector.deltaY = 0
  
  -----------------------------------------------------------------------------
  -- Describes the change in z for this vector
  --
  -- @type number
  -----------------------------------------------------------------------------
  Vector.deltaZ = 0
  
  -----------------------------------------------------------------------------
  -- Creates a new vector and returns it
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new()
  --   local v2 = Vector:new({deltaX = 5, deltaY = 0, deltaZ = 1})  
  -- 
  -- @param o (optional) superseding object
  -- @return a new instance of vector
  -----------------------------------------------------------------------------
  function Vector:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
  end
  
  -- Math
  
  -----------------------------------------------------------------------------
  -- Calculates the squared magnitude of this vector
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 3, deltaY = 0, deltaZ = 4})
  --   local mag = v:squaredMagnitude()
  --   -- prints 25
  --   print(mag)
  --
  -- @return squared magnitude of this vector
  -----------------------------------------------------------------------------
  function Vector:squaredMagnitude()
    return (deltaX * deltaX) + (deltaY * deltaY) + (deltaZ * deltaZ)
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the magnitude of this vector
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 3, deltaY = 0, deltaZ = 4})
  --   local mag = v:magnitude()
  --   -- prints 5
  --   print(mag)
  --
  -- @return magnitude of this vector
  -----------------------------------------------------------------------------
  function Vector:magnitude()
    return math.sqrt(self:squaredMagnitude())
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the vector in the same direction as this instance, but with a
  -- magnitude of 1
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 2, deltaY = 0, deltaZ = 2})
  --   local uv = v:normalized()
  --   -- prints <0.707, 0, 0.707>
  --   print(uv:toString())
  --
  -- @return Vector object that points in the same direction but with
  --         magnitude 1
  -----------------------------------------------------------------------------
  function Vector:normalized()
    local magn = self:magnitude()
    return Vector:new({
      deltaX = self.deltaX / magn,
      deltaY = self.deltaY / magn,
      deltaZ = self.deltaZ / magn
    })
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the vector resulting from adding other to this instance
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 2, deltaY = 0, deltaZ = 2})
  --   local a = Vector:new({deltaX = 1, deltaY = 1, deltaZ = 1})
  --   local res = v:add(a)
  --   -- prints <3, 1, 3>
  --   print(res:toString())
  --
  -- @param other vector object to add to this one
  -- @return the vector result from this instance added to other
  -----------------------------------------------------------------------------
  function Vector:add(other)
    return Vector:new({
      deltaX = self.deltaX + other.deltaX, 
      deltaY = self.deltaY + other.deltaY, 
      deltaZ = self.deltaZ + other.deltaZ
    })
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the vector resulting from multipling this vector by a scalar.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 2, deltaY = 0, deltaZ = 2})
  --   local v2 = v:multiply(2)
  --   -- prints <4, 0, 4>
  --   print(v2:toString())
  --   
  function Vector:multiply(scalar)
    return Vector:new({
      deltaX = self.deltaX * scalar,
      deltaY = self.deltaY * scalar,
      deltaZ = self.deltaZ * scalar
    })
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the vector resulting from subtracting other to this instance
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 2, deltaY = 0, deltaZ = 2})
  --   local a = Vector:new({deltaX = 1, deltaY = 1, deltaZ = 1})
  --   local res = v:subtract(a)
  --   -- prints <1, -1, 1>
  --   print(res:toString())
  --
  -- @param other vector object to add to this one
  -- @return the vector result when other is subtracted from this instance
  -----------------------------------------------------------------------------
  function Vector:subtract(other)
    return Vector:new({
      deltaX = self.deltaX - other.deltaX, 
      deltaY = self.deltaY - other.deltaY, 
      deltaZ = self.deltaZ - other.deltaZ
    })
  end
  
  -----------------------------------------------------------------------------
  -- Calculates the inverse of this vector.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 1, deltaY = 0, deltaZ = 2})
  --   local v2 = v:inverse()
  --   -- prints <-1, 0, -2>
  --   print(v2:inverse())
  -- 
  -- @return vector object that is the inverse of this instance
  -----------------------------------------------------------------------------
  function Vector:inverse()
    return Vector:new({
      deltaX = -self.deltaX, 
      deltaY = -self.deltaY, 
      deltaZ = -self.deltaZ
    })
  end
  
  -- Serialization
  
  -----------------------------------------------------------------------------
  -- Returns an object that can be serialized with textutils
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local obj = twf.movement.Vector:new()
  --   local data = { pos = obj:serializableObject() }
  --   local serialized = textutils.serialize(data)
  --   local unserialized = textutils.unserialize(data)
  --   unserialized.pos = twf.movement.Vector.unserializeObject(unserialized.pos)
  --
  -- @return object serializable using textutils
  -----------------------------------------------------------------------------
  function Vector:serializableObject()
    local resultTable = {}
    
    resultTable.deltaX = self.deltaX
    resultTable.deltaY = self.deltaY
    resultTable.deltaZ = self.deltaZ
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Returns the object that was serialized with serializableObject
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local obj = twf.movement.Vector:new()
  --   local data = { pos = obj:serializableObject() }
  --   local serialized = textutils.serialize(data)
  --   local unserialized = textutils.unserialize(data)
  --   unserialized.pos = twf.movement.Vector.unserializeObject(unserialized.pos)
  --
  -- @return object serializable using textutils
  -----------------------------------------------------------------------------
  function Vector.unserializeObject(serObj)
    local deltaX = serTable.deltaX
    local deltaY = serTable.deltaY
    local deltaZ = serTable.deltaZ
    
    return Vector:new({deltaX = deltaX, deltaY = deltaY, deltaZ = deltaZ})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this instance into something unserializable
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local obj = twf.movement.Vector:new()
  --   local serialized = obj:serialize()
  --   local unserialized = twf.movement.Vector.unserialize(serialized)
  --
  -- @return a string serialization of this instance
  -----------------------------------------------------------------------------
  function Vector:serialize()
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the serialized object into the original object
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local obj = twf.movement.Vector:new()
  --   local serialized = obj:serialize()
  --   local unserialized = twf.movement.Vector.unserialize(serialized)
  --
  -- @param serialized a string from serialize()
  -- @return           the Vector the serialized string represents
  -----------------------------------------------------------------------------
  function Vector.unserialize(serialized)
    return Vector.unserializeObject(textutils.unserialize(serialized))
  end
  
  -- Miscellaneous
  
  -----------------------------------------------------------------------------
  -- Returns the point representation of this vector
  -- 
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 5, deltaY = 0, deltaZ = 0})
  --   local p = v:toPosition()
  --   -- prints 5
  --   print(p.x)
  --
  -- @return twf.movement.Position representation of this Vector
  -----------------------------------------------------------------------------
  function Vector:toPosition()
    return twf.movement.Position:new({x = self.deltaX, y = self.deltaY, z = self.deltaZ})
  end
  
  -----------------------------------------------------------------------------
  -- Clones this vector instance
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 3, deltaY = 2, deltaZ = 5})
  --   local v2 = v:clone()
  --   -- prints true
  --   print(v:equals(v2))
  --   v.deltaX = 2
  --   -- prints false
  --   print(v:equals(v2))
  --
  -- @return vector clone of this instance
  -----------------------------------------------------------------------------
  function Vector:clone()
    return Vector:new({deltaX = self.deltaX, deltaY = self.deltaY, deltaZ = self.deltaZ})
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable, concise string representation of this vector
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 1, deltaY = 3, deltaZ = 2})
  --   -- prints <1, 3, 2>
  --   print(v:toString())
  --
  -- @return string representation of this vector
  -----------------------------------------------------------------------------
  function Vector:toString()
    return '<' .. self.deltaX .. ', ' .. self.deltaY .. ', ' .. self.deltaZ .. '>'
  end
  
  -----------------------------------------------------------------------------
  -- Compares this vector with another vector
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 3, deltaY = 2, deltaZ = 5})
  --   local v2 = Vector:new({deltaX = 3, deltaY = 2, deltaZ = 5})
  --   -- prints true
  --   print(v:equals(v2))
  --
  -- @return true if this instance is equal to the other instance,
  --         false otherwise
  -----------------------------------------------------------------------------
  function Vector:equals(other)
    if self.deltaX ~= other.deltaX then return false end
    if self.deltaY ~= other.deltaY then return false end
    if self.deltaZ ~= other.deltaZ then return false end
    
    return true
  end
  
  -----------------------------------------------------------------------------
  -- Calculates a reasonable hash code of this vector
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 3, deltaY = 2, deltaZ = 5})
  --   local v2 = Vector:new({deltaX = 3, deltaY = 2, deltaZ = 5})
  --   -- prints true
  --   print(v:hashCode() == v2:hashCode())
  --
  -- @return this vectors hash code
  -----------------------------------------------------------------------------
  function Vector:hashCode()
    local result = 37
    
    result = result * 19 + self.deltaX
    result = result * 19 + self.deltaY
    result = result * 19 + self.deltaZ
    
    return result
  end
  
  twf.movement.Vector = Vector
end

-----------------------------------------------------------------------------
-- twf.movement.MovementResult
-- Describes a result from a movement, returned from most movement functions
-----------------------------------------------------------------------------
if not twf.movement.MovementResult then
  local MovementResult = {}
  
  -- Constants - chosen to be moderately large primes to prevent collisions
  
  -----------------------------------------------------------------------------
  -- Describes a movement that went as expected
  -----------------------------------------------------------------------------
  MovementResult.MOVE_SUCCESS = 4903
  
  -----------------------------------------------------------------------------
  -- Describes a movement that did not succeed with no further information. 
  -- This may indicate an entity is blocking the way.
  -----------------------------------------------------------------------------
  MovementResult.MOVE_FAILURE = 4909
  
  -----------------------------------------------------------------------------
  -- Describes a movement that did not succeed due to a lack of fuel
  -----------------------------------------------------------------------------
  MovementResult.MOVE_NO_FUEL = 4919
  
  -----------------------------------------------------------------------------
  -- Describes a movement that did not succeed due to something blocking the 
  -- path of the turtle.
  -----------------------------------------------------------------------------
  MovementResult.MOVE_BLOCKED = 4931
  
  -----------------------------------------------------------------------------
  -- Returns if the specified movement result indicates success
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local MovementResult = twf.movement.MovementResult
  --   local mr = MovementResult.MOVE_NO_FUEL
  --   -- prints Move failed!
  --   if not MovementResult.isSuccess(mr) then 
  --     print('Move failed!')
  --   else
  --     print('Move succeeded!')
  --   end
  --
  -- @param movementResult the result of some movement
  -- @return               boolean true if the movement result indicates
  --                       success, false otherwise
  -- @error                if movementResult is not a valid code
  -----------------------------------------------------------------------------
  function MovementResult.isSuccess(movementResult)
    if movementResult == MovementResult.MOVE_SUCCESS then 
      return true
    end
    
    return false
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of the specified movement
  -- result code.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local MovementResult = twf.movement.MovementResult
  --   -- prints movement failed: not enough fuel
  --   print(MovementResult.toString(MovementResult.MOVE_NO_FUEL))
  --
  -- @param movementResult the movement result to convert to a string
  -- @return               string representation of this movement result
  -- @error                if movementResult is not a valid movement result 
  --                       code
  -----------------------------------------------------------------------------
  function MovementResult.toString(movementResult)
    if     movementResult == MovementResult.MOVE_SUCCESS then return 'movement succeeded'
    elseif movementResult == MovementResult.MOVE_FAILURE then return 'movement failed: unknown'
    elseif movementResult == MovementResult.MOVE_NO_FUEL then return 'movement failed: not enough fuel'
    elseif movementResult == MovementResult.MOVE_BLOCKED then return 'movement failed: blocked' end
    
    error('Expected movement result but got ' .. movementResult)
  end
  
  twf.movement.MovementResult = MovementResult
end

-----------------------------------------------------------------------------
-- twf.movement.action
--
-- Describes actions that the turtle could be executing. This is effectively
-- a thin wrapper around move functions that allows for consistent 
-- serialization.
-----------------------------------------------------------------------------
if not twf.movement.action then
  local action = {}
  
  -----------------------------------------------------------------------------
  -- twf.movement.action.Action
  --
  -- Describes a generic action the turtle can do. This isn't used anywhere, it
  -- is merely a reference for other actions
  -----------------------------------------------------------------------------
  do 
    local Action = {}
    
    -----------------------------------------------------------------------------
    -- Creates a new instance of an action.
    -- 
    -- Usage: Not used directly
    --
    -- @param o (optional) superseding object
    -- @return  a new instance of an Action
    -----------------------------------------------------------------------------
    function Action:new(o)
      error('Action:new(o) should not be called!')
    end
    
    -----------------------------------------------------------------------------
    -- Performs this action. Should consume exactly 1 fuel on success
    --
    -- Usage: Not used directly
    --
    -- @param stateTurtle StatefulTurtle
    -----------------------------------------------------------------------------
    function Action:perform(stateTurtle)
      error('Action:perform(stateTurtle) should not be called!')
    end
    
    -----------------------------------------------------------------------------
    -- Called when this action completes successfully - should update the state
    -- of the turtle.
    --
    -- Usage: Not used directly
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function Action:updateState(stateTurtle)
      error('Action:updateState(stateTurtle) should not be called!')
    end
    
    -----------------------------------------------------------------------------
    -- A unique name for this action type.
    --
    -- Usage: Not used directly
    --
    -- @return string, unique to this action type
    -----------------------------------------------------------------------------
    function Action.name()
      return 'twf.movement.action.Action'
    end
    
    -----------------------------------------------------------------------------
    -- Returns an object that can be serialized using textutils
    --
    -- Usage: Not used directly
    --
    -- @return object that can be serialized
    -----------------------------------------------------------------------------
    function Action:serializableObject()
      error('Action:serializableObject() should not be called!')
    end
    
    -----------------------------------------------------------------------------
    -- Returns the action that was serialized into an object from
    -- serializableObject
    --
    -- Usage: Not used directly
    --
    -- @param serObj the serialized object
    -- @return object that was serialized
    -----------------------------------------------------------------------------
    function Action.unserializeObject(serObj)
      error('Action.unserializeObject() should not be called')
    end
    
    -----------------------------------------------------------------------------
    -- Serializes this action
    --
    -- Usage: Not used directly
    -- 
    -- @return string serialization of this action
    -----------------------------------------------------------------------------
    function Action:serialize()
      error('Action:serialize() should not be called!')
    end
    -----------------------------------------------------------------------------
    -- Unserializes an action serialized by the corresponding serialize function
    --
    -- Usage: Not used directly
    --
    -- @param serialized string serialization of this action
    -- @return           action instance the serialized string represented
    -----------------------------------------------------------------------------
    function Action.unserialize(serialized)
      error('Action.unserialize() should not be called!')
    end
    
    action.Action = Action
  end
  
  -----------------------------------------------------------------------------
  -- twf.movement.action.MoveAction
  -- 
  -- An action that attempts to move the turtle one unit without turning
  -----------------------------------------------------------------------------
  do
    local MoveAction = {}
    
    -----------------------------------------------------------------------------
    -- The relative direction that this move action is going in
    -----------------------------------------------------------------------------
    MoveAction.direction = nil
    
    -----------------------------------------------------------------------------
    -- Creates a new instance of a move action
    -- 
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local moveForward = twf.movement.action.MoveAction:new({direction = twf.movement.direction.FORWARD})
    --   -- like turtle.forward()
    --   moveForward:perform(st)
    --
    -- @param o superseding object
    -- @return  new instance of this action
    -----------------------------------------------------------------------------
    function MoveAction:new(o)
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      
      local dirValid =       o.direction == twf.movement.direction.FORWARD
      dirValid = dirValid or o.direction == twf.movement.direction.BACK
      dirValid = dirValid or o.direction == twf.movement.direction.UP
      dirValid = dirValid or o.direction == twf.movement.direction.DOWN
      
      if not dirValid then 
        error('MoveAction:new() Expected direction twf.movement.direction.FORWARD, BACK, UP, or DOWN!')
      end
      
      return o
    end
    
    -- Utility functions --
    
    -----------------------------------------------------------------------------
    -- Detects if there is a block in the direction the turtle is trying to move
    -- if possible. If it is not possible to do so, returns false. Not usually
    -- called by outside classes, since MoveAction:perform() handles detection
    -- to improve performance.
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local MoveAction = twf.movement.MoveAction
    --   local act = MoveAction:new({direction = twf.movement.direction.FORWARD})
    --   if act then
    --     print('detected block in front!')
    --   end
    --
    -- @return true if a block was definitely detected, false otherwise
    -----------------------------------------------------------------------------
    function MoveAction:detect() 
      if     self.direction == twf.movement.direction.FORWARD then return turtle.detect()
      elseif self.direction == twf.movement.direction.UP      then return turtle.detectUp()
      elseif self.direction == twf.movement.direction.DOWN    then return turtle.detectDown()
      elseif self.direction == twf.movement.direction.BACK    then return false
      else 
        error('MoveAction:detect() unexpected direction!')
      end
    end
    
    -----------------------------------------------------------------------------
    -- Moves in the appropriate direction, returning true on success and false on 
    -- failure. Not usually called directly, since does not give a particularly
    -- useful result compared to perform
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local MoveAction = twf.movement.MoveAction
    --   local act = MoveAction:new({direction = twf.movement.direction.FORWARD})
    --   local succ = act:move() -- Like turtle.forward()
    --
    -- @return true on success, false on failure
    -----------------------------------------------------------------------------
    function MoveAction:move()
      if     self.direction == twf.movement.direction.FORWARD then return turtle.forward()
      elseif self.direction == twf.movement.direction.UP      then return turtle.up()
      elseif self.direction == twf.movement.direction.DOWN    then return turtle.down()
      elseif self.direction == twf.movement.direction.BACK    then return turtle.back()
      else 
        error('MoveAction:move() unexpected direction!')
      end
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to move the turtle once towards direction
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local moveForward = twf.movement.action.MoveAction:new({direction = twf.movement.direction.FORWARD})
    --   local result = moveForward:perform(st)
    --   -- Might print movement success
    --   -- Might print movement failed: no fuel
    --   print(twf.movement.MovementResult:toString(result))
    --
    -- @param stateTurtle StatefulTurtle
    -- @return twf.movement.MovementResult result of the movement attempt
    -----------------------------------------------------------------------------
    function MoveAction:perform(stateTurtle)
      if self:detect() then 
        return twf.movement.MovementResult.MOVE_BLOCKED 
      elseif turtle.getFuelLevel() < 1 then
        return twf.movement.MovementResult.NO_FUEL
      elseif self:move() then 
        return twf.movement.MovementResult.MOVE_SUCCESS
      else
        return twf.movement.MovementResult.MOVE_FAILURE
      end
    end
    
    -----------------------------------------------------------------------------
    -- Called when this action completes successfully - should update the state
    -- of the turtle.
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local moveForward = twf.movement.action.MoveAction:new({direction = twf.movement.direction.FORWARD})
    --   local result = moveForward:perform(st)
    --   if twf.movement.MovementResult.isSuccess(result) then
    --     moveForward:updateState(st)
    --   end
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function MoveAction:updateState(stateTurtle)
      if self.direction == twf.movement.direction.FORWARD then 
        stateTurtle.position.x = stateTurtle.position.x + twf.movement.direction.changeInX(stateTurtle.orientation)
        stateTurtle.position.z = stateTurtle.position.z + twf.movement.direction.changeInZ(stateTurtle.orientation)
      elseif self.direction == twf.movement.direction.BACK then
        stateTurtle.position.x = stateTurtle.position.x - twf.movement.direction.changeInX(stateTurtle.orientation)
        stateTurtle.position.z = stateTurtle.position.z - twf.movement.direction.changeInZ(stateTurtle.orientation)
      elseif self.direction == twf.movement.direction.UP then
        stateTurtle.position.y = stateTurtle.position.y + 1
      elseif self.direction == twf.movement.direction.DOWN then
        stateTurtle.position.y = stateTurtle.position.y - 1
      else
        error('MoveAction:updateState(stateTurtle) unexpected direction!')
      end
    end
    
    -----------------------------------------------------------------------------
    -- Returns a unique name for this action type
    --
    -- @return a unique name for this action type
    -----------------------------------------------------------------------------
    function MoveAction.name()
      return 'twf.movement.action.MoveAction'
    end
    
    -----------------------------------------------------------------------------
    -- Returns an object that can be serialized using textutils
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.movement.action.MoveAction:new({direction = twf.movement.direction.FORWARD})
    --   local serAct = { name = act.name(), action = act:serializableObject() }
    --   local serialized = textutils.serialize(serAct)
    --   local unserialized = textutils.unserialize(serialized)
    --   unserialized.action = twf.movement.action.MoveAction.unserializeObject(unserialized.action)
    --
    -- @return object that can be serialized
    -----------------------------------------------------------------------------
    function MoveAction:serializableObject()
      local resultTable = {}
      
      resultTable.direction = twf.movement.direction.serializableObject(self.direction)
      
      return resultTable
    end
    
    -----------------------------------------------------------------------------
    -- Returns the action that was serialized into an object from
    -- serializableObject
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.movement.action.MoveAction:new({direction = twf.movement.direction.FORWARD})
    --   local serAct = { name = act.name(), action = act:serializableObject() }
    --   local serialized = textutils.serialize(serAct)
    --   local unserialized = textutils.unserialize(serialized)
    --   unserialized.action = twf.movement.action.MoveAction.unserializeObject(unserialized.action)
    --
    -- @param serObj the serialized object
    -- @return object that was serialized
    -----------------------------------------------------------------------------
    function MoveAction.unserializeObject(serObj)
      local direction = twf.movement.direction.unserializeObject(serObj.direction)
      
      return MoveAction:new({direction = direction})
    end
    
    -----------------------------------------------------------------------------
    -- Serializes this action
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.movement.action.MoveAction:new({direction = twf.movement.direction.FORWARD})
    --   local serialized = act:serialize()
    --   local unserialized = twf.movement.action.MoveAction.unserialize(serialized)
    -- 
    -- @return string serialization of this action
    -----------------------------------------------------------------------------
    function MoveAction:serialize()
      return textutils.serialize(self:serializableObject())
    end
    
    -----------------------------------------------------------------------------
    -- Unserializes an action serialized by the corresponding serialize function
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.movement.action.MoveAction:new()
    --   local serialized = act:serialize()
    --   local unserialized = twf.movement.action.MoveAction.unserialize(serialized)
    -- 
    -- @param serialized string serialization of this action
    -- @return           action instance the serialized string represented
    -----------------------------------------------------------------------------
    function MoveAction.unserialize(serialized)
      local serTable = textutils.unserialize(serialized)
      
      return MoveAction.unserializeObject(serTable)
    end
    
    action.MoveAction = MoveAction
  end
  
  -----------------------------------------------------------------------------
  -- twf.movement.action.TurnAction
  -- 
  -- An action that attempts to turn the turtle once
  -----------------------------------------------------------------------------
  do
    local TurnAction = {}
    
    -----------------------------------------------------------------------------
    -- The direction this turn is in, either twf.movement.direction.LEFT or 
    -- twf.movement.direction.RIGHT
    -----------------------------------------------------------------------------
    TurnAction.direction = nil
    
    -----------------------------------------------------------------------------
    -- Creates a new instance of this action
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local ta = twf.movement.action.TurnAction:new({direction = twf.movement.direction.LEFT})
    --
    -- @param o superseding object
    -- @return  a new instance of this action
    -----------------------------------------------------------------------------
    function TurnAction:new(o)
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      
      local validDir =       o.direction == twf.movement.direction.LEFT
      validDir = validDir or o.direction == twf.movement.direction.RIGHT
      
      if not validDir then 
        error('Expected LEFT or RIGHT but got ' .. o.direction)
      end
      
      return o
    end
    
    -----------------------------------------------------------------------------
    -- Turns the turtle in the appropriate direction. Returns true on success and
    -- false on failure. Not usually called directly, since its result isn't as 
    -- useful as from perform.
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local ta = twf.movement.action.TurnAction:new({direction = twf.movement.direction.LEFT})
    --   local succ = ta:turn() -- like turtle.turnLeft()
    function TurnAction:turn()
      if     self.direction == twf.movement.direction.LEFT  then return turtle.turnLeft() 
      elseif self.direction == twf.movement.direction.RIGHT then return turtle.turnRight()
      else error('TurnAction:turn() invalid direction ' .. self.direction) end
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to turn the turtle once
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local ta = twf.movement.action.TurnAction:new({direction = twf.movement.direction.LEFT})
    --   local result = ta:perform(st)
    --   -- Might print movement success
    --   -- Might print movement failed: no fuel
    --   print(twf.movement.MovementResult:toString(result))
    --
    -- @param stateTurtle StatefulTurtle
    -- @return twf.movement.MovementResult result of the movement attempt
    -----------------------------------------------------------------------------
    function TurnAction:perform(stateTurtle)
      if turtle.getFuelLevel() < 1 then 
        return twf.movement.MovementResult.MOVE_NO_FUEL
      elseif self:turn() then
        return twf.movement.MovementResult.MOVE_SUCCESS
      else
        return twf.movement.MovementResult.MOVE_FAILURE
      end
    end
    
    -----------------------------------------------------------------------------
    -- Called when this action completes successfully - should update the state
    -- of the turtle.
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local turnClockwise = twf.movement.action.TurnAction:new({direction = twf.movement.direction.CLOCKWISE})
    --   local result = turnClockwise:perform(st)
    --   if twf.movement.MovementResult.isSuccess(result) then
    --     turnClockwise:updateState(st)
    --   end
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function TurnAction:updateState(stateTurtle)
      stateTurtle.orientation = twf.movement.direction.alter(stateTurtle.orientation, self.direction)
    end
    
    -----------------------------------------------------------------------------
    -- Returns a unique name for this action type
    --
    -- @return a unique name for this action type
    -----------------------------------------------------------------------------
    function TurnAction.name()
      return 'twf.movement.action.TurnAction'
    end
    
    -----------------------------------------------------------------------------
    -- Returns an object that can be serialized using textutils
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.movement.action.TurnAction:new({direction = twf.movement.direction.FORWARD})
    --   local serAct = { name = act.name(), action = act:serializableObject() }
    --   local serialized = textutils.serialize(serAct)
    --   local unserialized = textutils.unserialize(serialized)
    --   unserialized.action = twf.movement.action.TurnAction.unserializeObject(unserialized.action)
    --
    -- @return object that can be serialized
    -----------------------------------------------------------------------------
    function TurnAction:serializableObject()
      local resultTable = {}
      
      resultTable.direction = twf.movement.direction.serializableObject(self.direction)
      
      return resultTable
    end
    
    -----------------------------------------------------------------------------
    -- Returns the action that was serialized into an object from
    -- serializableObject
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.movement.action.TurnAction:new({direction = twf.movement.direction.FORWARD})
    --   local serAct = { name = act.name(), action = act:serializableObject() }
    --   local serialized = textutils.serialize(serAct)
    --   local unserialized = textutils.unserialize(serialized)
    --   unserialized.action = twf.movement.action.TurnAction.unserializeObject(unserialized.action)
    --
    -- @param serObj the serialized object
    -- @return object that was serialized
    -----------------------------------------------------------------------------
    function TurnAction.unserializeObject(serObj)
      local direction = twf.movement.direction.unserializeObject(serObj.direction)
      
      return TurnAction:new({direction = direction})
    end
    
    -----------------------------------------------------------------------------
    -- Serializes this action
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.movement.action.TurnAction:new({direction = twf.movement.direction.FORWARD})
    --   local serialized = act:serialize()
    --   local unserialized = twf.movement.action.TurnAction.unserialize(serialized)
    -- 
    -- @return string serialization of this action
    -----------------------------------------------------------------------------
    function TurnAction:serialize()
      return textutils.serialize(self:serializableObject())
    end
    
    -----------------------------------------------------------------------------
    -- Unserializes an action serialized by the corresponding serialize function
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.movement.action.TurnAction:new()
    --   local serialized = act:serialize()
    --   local unserialized = twf.movement.action.TurnAction.unserialize(serialized)
    -- 
    -- @param serialized string serialization of this action
    -- @return           action instance the serialized string represented
    -----------------------------------------------------------------------------
    function TurnAction.unserialize(serialized)
      local serTable = textutils.unserialize(serialized)
      
      return TurnAction.unserializeObject(serTable)
    end
    
    action.TurnAction = TurnAction
  end
  
  twf.movement.action = action
end
  
-----------------------------------------------------------------------------
-- twf.movement.StatefulTurtle
--
-- Describes a wrapper to the default turtle package that allows the turtle
-- to maintain its position and orientation relative to some point.
--
-- Usage:
--   dofile('twf_movement.lua')
--   local myTurtle = twf.movement.StatefulTurtle.loadOrInit('turtle_state.dat')
--   myTurtle:moveForward()
--   myTurtle:turnLeft()
--   -- if turtle_state.dat was empty, prints Current State: facing west at (0, 0, -1)
--   print('Current State: ' .. myTurtle:toString())
--   myTurtle:saveToFile('turtle_state.dat')
--   
--   
-----------------------------------------------------------------------------
if not twf.movement.StatefulTurtle then
  local direction = twf.movement.direction
  local Position = twf.movement.Position
  local Vector = twf.movement.Vector
  
  local StatefulTurtle = {}
  
  -----------------------------------------------------------------------------
  -- The action recovery file for this stateful turtle instance
  -----------------------------------------------------------------------------
  StatefulTurtle.actionRecoveryFile = 'turtle_state_action_recovery.dat'
  
  -----------------------------------------------------------------------------
  -- The save file for this turtle
  -----------------------------------------------------------------------------
  StatefulTurtle.saveFile = 'turtle_state.dat'
  
  -----------------------------------------------------------------------------
  -- The orientation of the turtle
  -----------------------------------------------------------------------------
  StatefulTurtle.orientation = direction.NORTH
  
  -----------------------------------------------------------------------------
  -- The position of the turtle
  -----------------------------------------------------------------------------
  StatefulTurtle.position = Position:new()
  
  -----------------------------------------------------------------------------
  -- The fuel level of the turtle
  -----------------------------------------------------------------------------
  StatefulTurtle.fuelLevel = 0
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of StatefulTurtle, assumed to be facing north at 
  -- (0, 0, 0) unless otherwise specified
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local st2 = StatefulTurtle:new({
  --                 orientation = direction.WEST, 
  --                 position = twf.movement.Position:new({x = 1, y = 2, z = 3})
  --               })
  -- 
  -- @param o (optional) superseding object
  -- @return  a new instance of StatefulTurtle
  -----------------------------------------------------------------------------
  function StatefulTurtle:new(o)
    o = o or {}
    
    if not o.position then
      o.position = StatefulTurtle.position:clone()
    end
    
    setmetatable(o, self)
    self.__index = self
    return o
  end
  
  -- Chunk load/unload recovery
  
  -----------------------------------------------------------------------------
  -- Prepares to perform the specified action by serializing the position, 
  -- orientation, and fuel level to disk, as well as the action that is about
  -- to be performed.
  --
  -- Example:
  --   When the main program (such as a treefarm) wants to move the turtle 
  --   forward once, a recovery file is saved to disk specifying the position,
  --   orientation, and fuel level of the turtle. Then, the 'core' function is
  --   attempted - in this case, turtle.forward. This function has a chance of
  --   "disastrous failure" - in other words, the turtle gets unloaded without
  --   warning and without guarranteeing the state of the turtle.
  --
  --   If that doesn't happen:
  --     The turtle attempts to moves forward, returning some kind of code 
  --     indicating if the action was successful, and the turtles state is 
  --     updated appropriately.
  --
  --   If that does happen:
  --     The program has set up a startup file, which will be run when the 
  --     turtle is loaded again. The startup file detects that the turtle has
  --     an action recovery file, and creates a new stateful turtle instance
  --     with the same action recovery file and calls recoverAction. That 
  --     instance will compare its fuel to what it had prior to attempting
  --     the action to see if the action was completed before disastrous 
  --     failure. If it was completed, the appropriate modifications to the 
  --     position prior to the action are made and set as the turtles current
  --     position. If it was not completed, the turtles position is simply its
  --     position prior to that action.
  --     
  --     At this point, the position of the turtle has been decided and action
  --     recovery is considered a success - however, it's still up to the
  --     program to decide how to recover from its task.
  -- 
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local moveForwardAct = twf.movement.action.MoveForwardAction:new()
  --   st:prepareAction(action)
  --
  -- @param action the action to prepare to do
  -----------------------------------------------------------------------------
  function StatefulTurtle:prepareAction(action)
    self.fuelLevel = turtle.getFuelLevel()
    
    local serTable = {}
    
    serTable.stateTurtle = self:serialize()
    serTable.actionName = action.name()
    serTable.action = action:serialize()
    
    local toSave = textutils.serialize(serTable)
    
    local file = fs.open(self.actionRecoveryFile, 'w')
    file.write(toSave)
    file.close()
  end
  
  -----------------------------------------------------------------------------
  -- Undoes the operation done from prepareAction after an action is completed,
  -- either successfully or not, in such a manner that the state of the 
  -- stateful turtle is consistent. 
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local moveForwardAct = twf.movement.action.MoveForwardAction:new()
  --   st:prepareAction(action,)
  --   st:finishAction(action)
  --
  -- @param action the action that was prepared
  -----------------------------------------------------------------------------
  function StatefulTurtle:finishAction(action)
    if fs.exists(self.actionRecoveryFile) then
      fs.delete(self.actionRecoveryFile)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the action with the specified action name.
  --
  -- @param actionName the name of the action
  -- @param serialized the serialized action
  -- @return           the action that was serialized 
  -----------------------------------------------------------------------------
  function StatefulTurtle:unserializeAction(actionName, serialized)
    if actionName == twf.movement.action.TurnAction.name() then 
      return twf.movement.action.TurnAction.unserialize(serialized)
    elseif actionName == twf.movement.action.MoveAction.name() then 
      return twf.movement.action.MoveAction.unserialize(serialized)
    end
    
    return nil
  end
  
  -----------------------------------------------------------------------------
  -- Recovers from the action that was prepared to the disk if it is possible
  -- to do so. This will succeed as long as nobody messed with the turtle.
  --
  -- Recovery is done by calculating if the move was performed (based on the
  -- fuel level). If it wasn't performed, the turtles state is assumed to be
  -- the same as before the action. If it was performed, the state is 
  -- recalculated from where it must be after performing the saved action from 
  -- the saved position.
  --
  -- @return true if the action was performed, false if it was not 
  -- @error if the fuel level is not in a valid state
  -----------------------------------------------------------------------------
  function StatefulTurtle:recoverAction()
    local file = fs.open(self.actionRecoveryFile, 'r')
    local saved = file.readAll()
    file.close()
    
    local serTable = textutils.unserialize(saved)
    
    serTable.stateTurtle = StatefulTurtle.unserialize(serTable.stateTurtle)
    local serAct = self:unserializeAction(serTable.actionName, serTable.action)
    if serAct then 
      serTable.action = serAct
    else
      error('Unsupported action for recovery: ' .. serTable.actionName)
    end
    
    self.fuelLevel = turtle.getFuelLevel()
    self.position = serTable.stateTurtle.position
    self.orientation = serTable.stateTurtle.orientation
    
    if self.fuelLevel == serTable.stateTurtle.fuelLevel then 
      return false
    elseif self.fuelLevel == serTable.stateTurtle.fuelLevel - 1 then 
      serTable.action:updateState(self)
      return true
    else 
      error('Invalid fuel level: was ' .. serTable.stateTurtle.fuelLevel .. ', is now ' .. self.fuelLevel)
    end
  end
  
  -- Movement
  
  -----------------------------------------------------------------------------
  -- Moves the turtle in the specified direction the specified numebr of times.
  -- Upon falure, the turtle may be anywhere along the path, but the position 
  -- and orientation of this instance will reflect the turtles true position 
  -- and orientation.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local succ = st:move(twf.movement.direction.FORWARD, 2)
  --   if not twf.movement.MovementResult.isSuccess(succ) then 
  --     print('Move failed!')
  --   end
  -- 
  -- @param direction the relative direction to move in
  -- @param times     (optional) number of times to move
  -- @return          twf.movement.MovementResult the result of the last 
  --                  movement
  -- @see twf.movement.StatefulTurtle#prepareAction (Action Recovery)
  -----------------------------------------------------------------------------
  function StatefulTurtle:move(direction, times)
    times = times or 1
    
    local result = nil
    
    for i = 1, times, 1 do 
      local act = twf.movement.action.MoveAction:new({direction = direction})
      self:prepareAction(act)
      result = act:perform(self)
      local success = twf.movement.MovementResult.isSuccess(result)
      if success then 
        act:updateState(self)
        self:saveToFile()
      end
      self:finishAction(act)
      
      if not success then 
        return result
      end
    end
    
    return result
  end
  
  -----------------------------------------------------------------------------
  -- Moves the turtle forward the specified number of times. Upon failure, the
  -- state of the turtle may be anywhere along the path that this function 
  -- travels, but the position and orientation of this instance will reflect 
  -- the turtles true position and orientation.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local succ = st:moveForward(2)
  --   if not twf.movement.MovementResult.isSuccess(succ) then
  --     print('Move failed!')
  --   end
  --
  -- @param times (optional) specifies the number of times to move forward.
  --              default 1
  -- @return twf.movement.MovementResult the result of the last movement
  -- @see twf.movement.StatefulTurtle#prepareAction (Action Recovery)
  -----------------------------------------------------------------------------
  function StatefulTurtle:moveForward(times)
    return self:move(twf.movement.direction.FORWARD, times)
  end
  
  -----------------------------------------------------------------------------
  -- Moves the turtle back the specified number of times. Upon failure, the
  -- state of the turtle may be anywhere along the path that this function 
  -- travels, but the position and orientation of this instance will reflect 
  -- the turtles true position and orientation.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local succ = st:moveBack(2)
  --   if not twf.movement.MovementResult.isSuccess(succ) then
  --     print('Move failed!')
  --   end
  --
  -- @param times (optional) specifies the number of times to move back.
  --              default 1
  -- @return twf.movement.MovementResult the result of the movement
  -----------------------------------------------------------------------------
  function StatefulTurtle:moveBack(times)
    return self:move(twf.movement.direction.BACK, times)
  end
  
  -----------------------------------------------------------------------------
  -- Moves the turtle up the specified number of times. Upon failure, the state
  -- of the turtle may be anywhere along the path that this function travels,
  -- but the position and orientation of this instance will reflect the turtles
  -- true position and orientation.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local succ = st:moveUp(2)
  --   if not twf.movement.MovementResult.isSuccess(succ) then
  --     print('Move failed!')
  --   end
  --
  -- @param times (optional) specifies the number of times to move up.
  --              default 1
  -- @return twf.movement.MovementResult the result of the movement
  -----------------------------------------------------------------------------
  function StatefulTurtle:moveUp(times)
    return self:move(twf.movement.direction.UP, times)
  end
  
  -----------------------------------------------------------------------------
  -- Moves the turtle down the specified number of times. Upon failure, the
  -- state of the turtle may be anywhere along the path that this function 
  -- travels, but the position and orientation of this instance will 
  -- reflect the turtles true position and orientation.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local succ = st:moveDown(2)
  --   if not twf.movement.MovementResult.isSuccess(succ) then
  --     print('Move failed!')
  --   end
  --
  -- @param times (optional) specifies the number of times to move down.
  --              default 1
  -- @return twf.movement.MovementResult the result of the movement
  -----------------------------------------------------------------------------
  function StatefulTurtle:moveDown(times)
    return self:move(twf.movement.direction.DOWN, times)
  end
  
  -- Turning
  
  
  -----------------------------------------------------------------------------
  -- Turns the turtle in the specified direction the specified numebr of times.
  -- Upon falure, the turtle may be anywhere along the path, but the position 
  -- and orientation of this instance will reflect the turtles true position 
  -- and orientation.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local succ = st:move(twf.movement.direction.LEFT, 2)
  --   if not twf.movement.MovementResult.isSuccess(succ) then 
  --     print('Turn failed!')
  --   end
  -- 
  -- @param direction the relative direction to turn in
  -- @param times     (optional) number of times to turn
  -- @return          twf.movement.MovementResult the result of the last 
  --                  movement
  -- @see twf.movement.StatefulTurtle#prepareAction (Action Recovery)
  -----------------------------------------------------------------------------
  function StatefulTurtle:turn(direction, times)
    times = times or 1
    
    local result = nil
    
    for i = 1, times, 1 do 
      local act = twf.movement.action.TurnAction:new({direction = direction})
      self:prepareAction(act)
      result = act:perform(self)
      local success = twf.movement.MovementResult.isSuccess(result)
      if success then 
        act:updateState(self)
        self:saveToFile()
      end
      self:finishAction(act)
      
      if not success then 
        return result
      end
    end
    
    return result
  end
  
  -----------------------------------------------------------------------------
  -- Turns the turtle left the specified number of times. Upon failure, the
  -- state of the turtle may be anywhere along the path that this function 
  -- travels, but the position and orientation of this instance will 
  -- reflect the turtles true position and orientation.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local succ = st:turnLeft(2)
  --   if not twf.movement.MovementResult.isSuccess(succ) then
  --     print('Turn failed!')
  --   end
  --
  -- @param times (optional) specifies the number of times to turn left.
  --              default 1
  -- @return twf.movement.MovementResult the result of the movement
  -----------------------------------------------------------------------------
  function StatefulTurtle:turnLeft(times)
    return self:turn(twf.movement.direction.LEFT, times)
  end
  
  -----------------------------------------------------------------------------
  -- Turns the turtle right the specified number of times. Upon failure, the
  -- state of the turtle may be anywhere along the path that this function 
  -- travels, but the position and orientation of this instance will 
  -- reflect the turtles true position and orientation.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local succ = st:turnRight(2)
  --   if not twf.movement.MovementResult.isSuccess(succ) then
  --     print('Turn failed!')
  --   end
  --
  -- @param times (optional) specifies the number of times to turn right.
  --              default 1
  -- @return twf.movement.MovementResult the result of the movement
  -----------------------------------------------------------------------------
  function StatefulTurtle:turnRight(times)
    return self:turn(twf.movement.direction.RIGHT, times)
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
  --   local serialized = st:serializableObject()
  --   local unserialized = StatefulTurtle.unserialize(serialized)
  --   -- prints true
  --   print(st:equals(unserialized))
  --
  -- @return an object that can be serialized with textutils
  -----------------------------------------------------------------------------
  function StatefulTurtle:serializableObject()
    local resultTable = {}
    
    resultTable.actionRecoveryFile = self.actionRecoveryFile
    resultTable.saveFile = self.saveFile
    resultTable.orientation = twf.movement.direction.serializableObject(self.orientation)
    resultTable.position = self.position:serializableObject()
    resultTable.fuelLevel = self.fuelLevel
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Serializes the instance that was serialized with serializableObject
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   local serialized = st:serializableObject()
  --   local unserialized = StatefulTurtle.unserialize(serialized)
  --   -- prints true
  --   print(st:equals(unserialized))
  --
  -- @param serTable the serialized object 
  -- @return the object that was serialized 
  -----------------------------------------------------------------------------
  function StatefulTurtle.unserializeObject(serTable)
    local actionRecoveryFile = serTable.actionRecoveryFile
    local saveFile = serTable.saveFile
    local orientation = twf.movement.direction.unserializeObject(serTable.orientation)
    local position = twf.movement.Position.unserializeObject(serTable.position)
    local fuelLevel = serTable.fuelLevel
    
    return StatefulTurtle:new({
      actionRecoveryFile = actionRecoveryFile,
      saveFile = saveFile,
      orientation = orientation,
      position = position,
      fuelLevel = fuelLevel
    })
  end
  
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
  function StatefulTurtle:serialize()
    return textutils.serialize(self:serializableObject())
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
    local serTable = textutils.unserialize(serialized)
    
    return StatefulTurtle.unserializeObject(serTable)
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
  function StatefulTurtle.loadOrInit(filePrefix)
    local saveFile = filePrefix .. '.dat'
    local actionRecoveryFile = filePrefix .. '_action_recovery.dat'
    
    if fs.exists(actionRecoveryFile) then 
      local st = StatefulTurtle:new({
        saveFile = saveFile,
        actionRecoveryFile = actionRecoveryFile
      })
      st:recoverAction()
      st:saveToFile()
      st:finishAction()
      return st
    elseif fs.exists(saveFile) then 
      local file = fs.open(saveFile, 'r')
      local saved = file.readAll()
      file.close()
      
      local res = StatefulTurtle.unserialize(saved)
      res.fuelLevel = turtle.getFuelLevel()
      return res
    else 
      local st = StatefulTurtle:new({
        saveFile = saveFile,
        actionRecoveryFile = actionRecoveryFile,
        fuelLevel = turtle.getFuelLevel()
      })
      st:saveToFile()
      return st
    end
  end
  
  -----------------------------------------------------------------------------
  -- Loads the stateful turtle that was saved to the specified file. Does not 
  -- attempt to recovery any actions or initialize the turtle if the file 
  -- does not exist.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local saved = StatefulTurtle.loadSavedState('turtle_state.dat')
  --   -- saved may be nil
  --
  -- @param saveFile the filename to load from 
  -- @return         the saved stateful turtle or nil
  -----------------------------------------------------------------------------
  function StatefulTurtle.loadSavedState(saveFile)
    if fs.exists(saveFile) then 
      local file = fs.open(saveFile, 'r')
      local saved = file.readAll()
      file.close()
      
      local st = twf.movement.StatefulTurtle.unserialize(saved)
      st.fuelLevel = turtle.getFuelLevel()
      st:loadInventoryFromTurtle()
      st.selectedSlot = turtle.getSelectedSlot()
      return st
    end
    
    return nil
  end
  
  -----------------------------------------------------------------------------
  -- Saves this instance to the disk, creating the file or overwriting its 
  -- content as necessary. This is the prefered method of saving/loading when 
  -- the turtle isn't recovering from being unloaded.
  --
  -- Usage:
  --   local st = twf.movement.StatefulTurtle:new()
  --   st:saveToFile()
  -----------------------------------------------------------------------------
  function StatefulTurtle:saveToFile()
    local file = fs.open(self.saveFile, 'w')
    file.write(self:serialize())
    file.close()
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
    return StatefulTurtle:new({
      saveFile = self.saveFile,
      actionRecoveryFile = self.actionRecoveryFile,
      fuelLevel = self.fuelLevel,
      position = self.position:clone(),
      orientation = self.orientation
    })
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of this stateful turtle
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local StatefulTurtle = twf.movement.StatefulTurtle
  --   local st = StatefulTurtle:new()
  --   -- Prints facing north at (0, 0, 0)
  --   print(st:toString())
  --
  -- @return human readable representation of this instance
  -----------------------------------------------------------------------------
  function StatefulTurtle:toString()
    return 'facing ' .. twf.movement.direction.toCardinalString(self.orientation) .. ' at ' .. self.position:toString()
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
    if self.actionRecoveryFile ~= other.actionRecoveryFile then return false end
    if self.saveFile ~= other.saveFile then return false end
    if self.orientation ~= other.orientation then return false end
    if self.position == nil then 
      if other.position ~= nil then return false end
    else
      if other.position == nil then return false end
      if not self.position:equals(other.position) then return false end
    end
    if self.fuelLevel ~= other.fuelLevel then return false end
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
  function StatefulTurtle:hashCode()
    local result = 83
    
    if self.actionRecoveryFile ~= nil then
      for i = 1, #self.actionRecoveryFile do 
        result = 19 * string.byte(self.actionRecoveryFile, i)
      end
    end
    
    if self.saveFile ~= nil then 
      for i = 1, #self.saveFile do
        result = 17 * result + string.byte(self.saveFile, i)
      end
    end
    
    result = 23 * result + self.orientation
    result = 17 * result + self.position:hashCode()
    result = 17 * result + self.fuelLevel
    
    return result
  end
  
  twf.movement.StatefulTurtle = StatefulTurtle
end