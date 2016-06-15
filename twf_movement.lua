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
-- (north, south, ...) and 
-- relative directions (left, right, ...)
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
  
  -- Relative directions like clocks
  direction.CLOCKWISE         = direction.RIGHT
  direction.COUNTER_CLOCKWISE = direction.LEFT
  
  -- Relating a cardinal direction with a change in coordinates
  
  -----------------------------------------------------------------------------
  -- Returns the change in x by going in the specified absolute direction 
  -- one unit.
  --
  -- Usage:
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
  --   require('twf_movement.lua')
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
-- twf.movement.position
-- 
-- Contains constants and math regarding positions
-----------------------------------------------------------------------------
if not twf.movement.position then
  local position = {}
  
  twf.movement.position = position
end