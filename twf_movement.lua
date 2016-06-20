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
    error('Not yet implemented')
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
    error('Not yet implemented')
  end
  
  -- Altering a direction with a relative direction
  
  -----------------------------------------------------------------------------
  -- Returns the absolute direction that comes from going relDir in absDir. 
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
  -- @param absDir an absolute direction
  -- @param relDir a relative direction
  -- @return       an absolute direction (number) relDir of absDir
  -- @error        if absDir is not a valid absolute direction
  --               if relDir is not a valid relative direction
  -----------------------------------------------------------------------------
  function direction.alter(absDir, relDir)
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns the absolute direction that comes from going in the opposite 
  -- direction of the specified absolute direction.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local direction = twf.movement.direction
  -- 
  --   -- prints south (+z)
  --   print(direction.toString(direction.inverse(direction.NORTH)))
  -- 
  -- @param dir an absolute direction
  -- @return    the absolute direction (number) opposite of the specified 
  --            direction
  -- @error     if dir is not a valid absolute direction
  -----------------------------------------------------------------------------
  function direction.inverse(dir)
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
  end
  
  -- Serialization functions
  
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
  function direction.serialize(dir)
    error('Not yet implemented')
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
    error('Not yet implemented')
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
  -----------------------------------------------------------------------------
  function direction.toCardinalString(dir)
    error('Not yet implemented')
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
  
  --   -- prints east
  --   print(direction.toCardinalString(direction.POSITIVE_X))
  --
  -- @param dir an absolute direction
  -- @return    a string representing the direction using coordinate language
  -----------------------------------------------------------------------------
  function direction.toCoordinateString(dir)
    error('Not yet implemented')
  end
  
  
  -----------------------------------------------------------------------------
  -- Converts the direction to a human-readable relative representation. If the
  -- direction is not relative (e.g. it's absolute), an error is thrown.
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
  function direction.toRelativeString(dir)
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
  end
  
  -- Serialization
  
  -----------------------------------------------------------------------------
  -- Serializes this instance into something unserializable
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local p = Position:new({x = 3, y = 2, z = 5})
  --   local serialized = p:serialize()
  --   local p2 = Position.unserialize(serialized)
  --   -- prints true
  --   print(p:equals(p2))
  --
  -- @return a string serialization of this instance
  -----------------------------------------------------------------------------
  function Position:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes a serialized position into the position object
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Position = twf.movement.Position
  --   local p = Position:new({x = 3, y = 2, z = 5})
  --   local serialized = p:serialize()
  --   local p2 = Position.unserialize(serialized)
  --   -- prints true
  --   print(p:equals(p2))
  --
  -- @param serialized a string from serialize()
  -- @return           the position the serialized string represents
  -----------------------------------------------------------------------------
  function Position.unserialize(serialized)
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
  end
  
  -- Math
  
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
    error('Not yet implemented')
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
  --   -- prints <1, 0, 1>
  --   print(uv:toString())
  --
  -- @return Vector object that points in the same direction but with
  --         magnitude 1
  -----------------------------------------------------------------------------
  function Vector:normalized()
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
  end
  
  -- Serialization
  
  -----------------------------------------------------------------------------
  -- Serializes the vector, such that it can be unserialized later
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 3, deltaY = 2, deltaZ = 5})
  --   local serialized = v:serialize()
  --   local unserialized = Vector.unserialize(serialized)
  --   -- prints true
  --   print(v:equals(unserialized))
  --
  -- @return string serialization of this vector
  -----------------------------------------------------------------------------
  function Vector:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes this vector from a serialized string
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local Vector = twf.movement.Vector
  --   local v = Vector:new({deltaX = 3, deltaY = 2, deltaZ = 5})
  --   local serialized = v:serialize()
  --   local unserialized = Vector.unserialize(serialized)
  --   -- prints true
  --   print(v:equals(unserialized))
  --
  -- @param serialized the serialized vector object
  -- @return vector object the string was representing
  function Vector.unserialize(serialized)
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    -----------------------------------------------------------------------------
    function Action:perform()
      error('Action:perform() should not be called!')
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
      error('Action:unserialize() should not be called!')
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
    --   local moveForward = twf.movement.action.MoveAction:new({direction = twf.movement.direction.FORWARD})
    --   -- like turtle.forward()
    --   moveForward:perform()
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
    --   local moveForward = twf.movement.action.MoveAction:new({direction = twf.movement.direction.FORWARD})
    --   local result = moveForward:perform()
    --   -- Might print movement success
    --   -- Might print movement failed: no fuel
    --   print(twf.movement.MovementResult:toString(result))
    --
    -- @return twf.movement.MovementResult result of the movement attempt
    -----------------------------------------------------------------------------
    function MoveAction:perform()
      if self:detect() then 
        return MovementResult.MOVE_BLOCKED 
      elseif turtle.getFuelLevel() < 1 then
        return MovementResult.NO_FUEL
      elseif self:move() then 
        return MovementResult.MOVE_SUCCESS
      else
        return MovementResult.MOVE_FAILURE
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
    --   local result = moveForward:perform()
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
      local resultTable = {}
      
      resultTable.direction = twf.movement.direction.serialize(self.direction)
      
      return textutils.serialize(resultTable)
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
      
      local direction = twf.movement.direction.unserialize(serTable.direction)
      
      return MoveAction:new({direction = direction})
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
      error('Not yet implemented')
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
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Attempts to turn the turtle once
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local ta = twf.movement.action.TurnAction:new({direction = twf.movement.direction.LEFT})
    --   local result = ta:perform()
    --   -- Might print movement success
    --   -- Might print movement failed: no fuel
    --   print(twf.movement.MovementResult:toString(result))
    --
    -- @return twf.movement.MovementResult result of the movement attempt
    -----------------------------------------------------------------------------
    function TurnAction:perform()
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Called when this action completes successfully - should update the state
    -- of the turtle.
    --
    -- Usage:
    --   dofile('twf_movement.lua')
    --   local st = twf.movement.StatefulTurtle:new()
    --   local turnClockwise = twf.movement.action.TurnAction:new({direction = twf.movement.direction.CLOCKWISE})
    --   local result = turnClockwise:perform()
    --   if twf.movement.MovementResult.isSuccess(result) then
    --     turnClockwise:updateState(st)
    --   end
    --
    -- @param stateTurtle stateful turtle to be updated
    -----------------------------------------------------------------------------
    function TurnAction:updateState(stateTurtle)
      error('Not yet implemented')
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
    -- Serializes this action
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.movement.action.TurnAction:new({direction = twf.movement.direction.CLOCKWISE})
    --   local serialized = act:serialize()
    --   local unserialized = twf.movement.action.TurnAction.unserialize(serialized)
    -- 
    -- @return string serialization of this action
    -----------------------------------------------------------------------------
    function TurnAction:serialize()
      error('Not yet implemented')
    end
    
    -----------------------------------------------------------------------------
    -- Unserializes an action serialized by the corresponding serialize function
    --
    -- Usage: 
    --   dofile('twf_movement.lua')
    --   local act = twf.movement.action.TurnAction:new({direction = twf.movement.direction.CLOCKWISE})
    --   local serialized = act:serialize()
    --   local unserialized = twf.movement.action.TurnAction.unserialize(serialized)
    -- 
    -- @param serialized string serialization of this action
    -- @return           action instance the serialized string represented
    -----------------------------------------------------------------------------
    function TurnAction.unserialize(serialized)
      error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
  -- @error if the fuel level is not in a valid state
  -----------------------------------------------------------------------------
  function StatefulTurtle:recoverAction()
    error('Not yet implemented')
  end
  
  -- Movement
  
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
    times = times or 1
    
    local result = nil
    
    for i = 1, times, 1 do 
      local act = twf.movement.action.MoveAction:new({direction = twf.movement.direction.FORWARD})
      self:prepareAction(act)
      result = act:perform()
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
    error('Not yet implemented')
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
    error('Not yet implemented')
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
    error('Not yet implemented')
  end
  
  -- Turning
  
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
    error('Not yet implemented')
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
  function StatefulTurtle:serialize()
    error('Not yet implemented')
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
    error('Not yet implemented')
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
  --   -- Prints facing north at (0, 0, 0)
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
  
  twf.movement.StatefulTurtle = StatefulTurtle
end