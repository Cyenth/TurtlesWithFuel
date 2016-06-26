-----------------------------------------------------------------------------
-- twf_waypoints.lua
-- 
-- This file provides actionpaths that allow for typical combined-movement 
-- using waypoints to navigate along paths. 
-- 
-- @author Timothy 
-- @namespace twf.waypoints
-----------------------------------------------------------------------------

dofile('twf_actionpath.lua')

if not twf.waypoints then twf.waypoints = {} end

-----------------------------------------------------------------------------
-- twf.waypoints.Waypoint
--
-- Describes a waypoint that the turtle might want to go to.
-----------------------------------------------------------------------------
if not twf.waypoints.Waypoint then
  local Waypoint = {}
  
  -----------------------------------------------------------------------------
  -- The name of this waypoint, may be nil
  -----------------------------------------------------------------------------
  Waypoint.name = nil
  
  -----------------------------------------------------------------------------
  -- The id for this waypoint
  -----------------------------------------------------------------------------
  Waypoint.id = nil
  
  -----------------------------------------------------------------------------
  -- The position that this waypoint is located at
  -----------------------------------------------------------------------------
  Waypoint.position = nil
  
  -----------------------------------------------------------------------------
  -- The orientation of this waypoint. May be nil
  -----------------------------------------------------------------------------
  Waypoint.orientation = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of waypoint
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypoint = twf.waypoints.Waypoint:new({
  --     name = 'start',
  --     id = 1,
  --     position = twf.movement.Position:new({x = 0, y = 0, z = 0}),
  --     orientation = twf.movement.direction.NORTH
  --   })
  --
  -- @param o superseding object
  -- @error   if o.id is not a number
  -- @error   if o.position is not a position
  -- @error   if o.orientation is not nil and not a valid direction to face
  -----------------------------------------------------------------------------
  function Waypoint:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.id) ~= 'number' then 
      error('Expected o.id to be a number but it is ' .. type(o.id))
    end
    
    if type(o.position) ~= 'table' then 
      error('Expected o.position to be a position, but it is ' .. type(o.position))
    end
    
    if type(o.orientation) == 'number' then 
      local orientationIsValid = o.orientation == twf.movement.direction.NORTH
      orientationIsValid = orientationIsValid or o.orientation == twf.movement.direction.WEST
      orientationIsValid = orientationIsValid or o.orientation == twf.movement.direction.EAST
      orientationIsValid = orientationIsValid or o.orientation == twf.movement.direction.SOUTH
      
      if not orientationIsValid then 
        error('Expected o.orientation to be nil or a direction to face, but it is ' .. o.orientation)
      end
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this waypoint into an object
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypoint = twf.waypoints.Waypoint:new({
  --     name = 'start',
  --     id = 1,
  --     position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  --   })
  --   local serialized = waypoint:serializableObject()
  --   local unserialized = twf.waypoints.Waypoint.unserializeObject(serialized)
  -- 
  -- @return object serializable using textutils
  -----------------------------------------------------------------------------
  function Waypoint:serializableObject()
    local resultTable = {}
    
    resultTable.name = self.name
    resultTable.id = self.id
    resultTable.position = self.position:serializableObject()
    if self.orientation then 
      resultTable.orientation = twf.movement.direction.serializableObject(self.orientation)
    end
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the waypoint serialized using serializableObject
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypoint = twf.waypoints.Waypoint:new({
  --     name = 'start',
  --     id = 1,
  --     position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  --   })
  --   local serialized = waypoint:serializableObject()
  --   local unserialized = twf.waypoints.Waypoint.unserializeObject(serialized)
  -- 
  -- @param serialized the serialized object
  -- @return           waypoint that was serialized
  -----------------------------------------------------------------------------
  function Waypoint.unserializeObject(serialized)
    local name = serialized.name
    local id = serialized.id
    local position = twf.movement.Position.unserializeObject(serialized.position)
    local orientation = nil
    if serialized.orientation then 
      orientation = twf.movement.direction.unserializeObject(serialized.orientation)
    end
    
    return Waypoint:new({
      name = name,
      id = id,
      position = position,
      orientation = orientation
    })
  end
  
  
  -----------------------------------------------------------------------------
  -- Serializes this waypoint into a string
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypoint = twf.waypoints.Waypoint:new({
  --     name = 'start',
  --     id = 1,
  --     position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  --   })
  --   local serialized = waypoint:serialize()
  --   local unserialized = twf.waypoints.Waypoint.unserialize(serialized)
  -- 
  -- @return string serialization
  -----------------------------------------------------------------------------
  function Waypoint:serialize()
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the waypoint serialized using serializableObject
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypoint = twf.waypoints.Waypoint:new({
  --     name = 'start',
  --     id = 1,
  --     position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  --   })
  --   local serialized = waypoint:serialize()
  --   local unserialized = twf.waypoints.Waypoint.unserialize(serialized)
  -- 
  -- @param serialized the serialized string
  -- @return           waypoint that was serialized
  -----------------------------------------------------------------------------
  function Waypoint.unserialize(serialized)
    return Waypoint.unserializeObject(textutils.unserialize(serialized))
  end
  
  -----------------------------------------------------------------------------
  -- Clones this waypoint, returning a logically equivalent copy
  -- 
  -- Usage:
  --  dofile('twf_waypoints.lua')
  --   local waypoint = twf.waypoints.Waypoint:new({
  --     name = 'start',
  --     id = 1,
  --     position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  --   })
  --   local copy = waypoint:clone()
  --
  -- @return the clone of this waypoint
  -----------------------------------------------------------------------------
  function Waypoint:clone()
    return Waypoint:new({
      name = self.name,
      id = self.id,
      position = self.position:clone(),
      orientation = self.orientation
    })
  end
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of this waypoint
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypoint = twf.waypoints.Waypoint:new({
  --     name = 'start',
  --     id = 1,
  --     position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  --   })
  --   -- prints waypoint start (id=1) at (0, 0, 0) facing north (-z)
  --   print waypoint:toString()
  -----------------------------------------------------------------------------
  function Waypoint:toString()
    local result = 'waypoint '
    if self.name then  
      result = result .. self.name.. ' '
    end
    
    result = result .. '(id=' .. self.id .. ') at ' .. self.position:toString()
    
    if self.orientation then 
      result = result .. ' facing ' .. twf.movement.direction.toString(self.orientation)
    end
    
    return result
  end
  
  -----------------------------------------------------------------------------
  -- Determines if this waypoint is logically equal to the other waypoint.
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypoint = twf.waypoints.Waypoint:new({
  --     name = 'start',
  --     id = 1,
  --     position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  --   })
  --   local waypoint2 = waypoint:clone()
  --   -- prints true
  --   print(waypoint:equals(waypoint2))
  --
  -- @param other the waypoint to compare to
  -- @return if this waypoint is logically equal to the other waypoint
  -----------------------------------------------------------------------------
  function Waypoint:equals(other)
    if self.name ~= other.name then return false end
    if self.id ~= other.id then return false end
    if not self.position:equals(other.position) then return false end
    
    return true
  end
  
  -----------------------------------------------------------------------------
  -- Calculates a reasonable hash code for this waypoint.
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypoint = twf.waypoints.Waypoint:new({
  --     name = 'start',
  --     id = 1,
  --     position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  --   })
  --   local hash = waypoint:hashCode()
  --
  -- @return number hash code
  -----------------------------------------------------------------------------
  function Waypoint:hashCode()
    local result = 31
    
    if self.name then 
      for i = 1, #self.name do 
        result = result * 17 + string.byte(self.name, i)
      end
    end
    result = result * 17 + self.id
    result = result * 17 + self.position:hashCode()
    
    return result
  end
  
  
  twf.waypoints.Waypoint = Waypoint
end

-----------------------------------------------------------------------------
-- twf.waypoints.WaypointRegistry
--
-- A collection of waypoints, that allows for searching by name, id, or 
-- position. Prevents id and name collision.
-----------------------------------------------------------------------------
if not twf.waypoints.WaypointRegistry then 
  local WaypointRegistry = {}
  
  WaypointRegistry.waypoints = nil
  
  -----------------------------------------------------------------------------
  -- Initializes a new waypoint registry
  --
  -- Usage:
  --   dofile('twf_maypoints.lua')
  --   local waypoints = { 
  --     twf.waypoints.Waypoint:new({
  --       waypointName = 'start',
  --       id = 1,
  --       position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  --     })
  --   }
  --   local waypointRegistry = twf.waypoints.WaypointRegistry:new({waypoints = waypoints})
  --
  -- @param o superseding object
  -- @return  new waypoint registry
  -- @error   if is not a table, or empty, or has id collision
  function WaypointRegistry:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.waypoints) ~= 'table' then
      error('Expected o.waypoints to be a table, but it is ' .. type(o.waypoints))
    end
    
    if #o.waypoints < 1 then 
      error('Expected o.waypoints to not be empty, but it is!')
    end
    
    for i = 1, #o.waypoints do 
      for j = i + 1, #o.waypoints do 
        if o.waypoints[i].id == o.waypoints[j].id then 
          error('Id collision (i=' .. i .. ', j = ' .. j .. ') on ' .. o.waypoints[i]:toString() .. ' and ' .. o.waypoints[j]:toString())
        end
        if o.waypoints[i].name == o.waypoints[j].name then
          error('Name collision (i=' .. i .. ', j = ' .. j .. ') on ' .. o.waypoints[i]:toString() .. ' and ' .. o.waypoints[j]:toString())
        end
      end
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Gets the waypoint with the specified id 
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypointRegistry = <omitted>
  --   local waypoint1 = waypointRegistry:getById(1)
  -- 
  -- @param id the id to search by
  -- @return   the waypoint with that id, or nil
  -----------------------------------------------------------------------------
  function WaypointRegistry:getById(id)
    for _, waypoint in ipairs(self.waypoints) do 
      if waypoint.id == id then return waypoint end
    end
    
    return nil
  end
  
  -----------------------------------------------------------------------------
  -- Gets the waypoint with the specified name
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypointRegistry = <omitted>
  --   local start = waypointRegistry:getByName('start')
  --
  -- @param name the name of the waypoint
  -- @return     the waypoint with that name, or nil
  -----------------------------------------------------------------------------
  function WaypointRegistry:getByName(name)
    for _, waypoint in ipairs(self.waypoints) do 
      if waypoint.name == name then return waypoint end
    end
    
    return nil
  end
  
  -----------------------------------------------------------------------------
  -- Gets the waypoint located at the specified position
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypointRegistry = <omitted>
  --   local someWaypoint = waypointRegistry:getByPosition(twf.movement.Position:new())
  --
  -- @param pos the position of the waypoint
  -- @return    the waypoint at that position, or nil
  -----------------------------------------------------------------------------
  function WaypointRegistry:getByPosition(pos)
    for _, waypoint in ipairs(self.waypoints) do 
      if waypoint.position:equals(pos) then return waypoint end
    end
    
    return nil
  end
  
  -----------------------------------------------------------------------------
  -- Either adds the waypoint if there are no conflicts, or replaces the 
  -- conflicting waypoint.
  -- 
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypointRegistry = <omitted>
  --   local someWaypoint = waypointRegistry:gaddOrSetWaypoint(twf.waypoints.Waypoint:new({
  --      name = 'test', id = 1, position = twf.movement.position:new({x = 0, y = 0, z = 0})
  --   })
  --
  -- @param waypoint the waypoint to add or set into this registry
  -----------------------------------------------------------------------------
  function WaypointRegistry:addOrSetWaypoint(waypoint)
    local i = 1
    while i <= #self.waypoints do 
      if self.waypoints[i].id == waypoint.id or self.waypoints[i].name == waypoint.id then 
        table.remove(self.waypoints, i)
        i = i - 1
      end
      
      i = i + 1
    end
    
    table.insert(self.waypoints, waypoint)
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this waypoint registry into an object serializable by textutils
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypointRegistry = <omitted>
  --   local serialized = waypointRegistry:serializableObject()
  --   local unserialized = twf.waypoints.WaypointRegistry.unserializeObject(serialized)
  --
  -- @return an object serializable with textutils
  -----------------------------------------------------------------------------
  function WaypointRegistry:serializableObject()
    local resultTable = {}
    
    resultTable.waypoints = {}
    for key, val in ipairs(self.waypoints) do 
      resultTable.waypoints[key] = val:serializableObject()
    end
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the waypoint registry serialized with serializableObject
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypointRegistry = <omitted>
  --   local serialized = waypointRegistry:serializableObject()
  --   local unserialized = twf.waypoints.WaypointRegistry.unserializeObject(serialized)
  --
  -- @param serialized the serialization of the waypoint
  -- @return the waypoint registry that was serialized
  -----------------------------------------------------------------------------
  function WaypointRegistry.unserializeObject(serialized)
    local waypoints = {}
    
    for key, val in ipairs(serialized.waypoints) do 
      waypoints[key] = twf.waypoints.Waypoint.unserializeObject(val)
    end
    
    return WaypointRegistry:new({waypoints = waypoints})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this waypoint registry into a string
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypointRegistry = <omitted>
  --   local serialized = waypointRegistry:serializable()
  --   local unserialized = twf.waypoints.WaypointRegistry.unserialize(serialized)
  --
  -- @return a string serialization
  -----------------------------------------------------------------------------
  function WaypointRegistry:serialize()
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the waypoint serialized with serialize
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypointRegistry = <omitted>
  --   local serialized = waypointRegistry:serializable()
  --   local unserialized = twf.waypoints.WaypointRegistry.unserialize(serialized)
  --
  -- @param serialized string serialization of a waypoint registry
  -- @return the waypoint registry that was serialized
  -----------------------------------------------------------------------------
  function WaypointRegistry.unserialize(serialized)
    return WaypointRegistry.unserializeObject(textutils.unserialize(serialized))
  end
  
  -----------------------------------------------------------------------------
  -- Clones this waypoint registry
  --
  -- Usage:
  --   local waypointRegistry = <omitted>
  --   local copy = waypointRegistry:clone()
  --
  -- @return a logical copy of this waypoint registry
  -----------------------------------------------------------------------------
  function WaypointRegistry:clone()
    local waypoints = {}
    for key, val in ipairs(self.waypoints) do 
      waypoints[key] = val:clone()
    end
    
    return WaypointRegistry:new({waypoints = waypoints})
  end
  
  -----------------------------------------------------------------------------
  -- Checks if this waypoint registry is logically equal to the other waypoint
  -- registry
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypointRegistry1 = <omitted>
  --   local waypointRegistry2 = <omitted>
  --   local areEqual = waypointRegistry1:equals(waypointRegistry2)
  --
  -- @param other the waypoint registry to compare with
  -- @return if this waypoint registry is logically equal to the other one
  -----------------------------------------------------------------------------
  function WaypointRegistry:equals(other)
    for key, val in ipairs(self.waypoints) do 
      if not other.waypoints[key] then return false end
      if not val:equals(other.waypoints[key]) then return false end
    end
    
    for key, val in ipairs(other.waypoints) do 
      if not self.waypoints[key] then return false end
      if not val:equals(self.waypoints[key]) then return false end
    end
    
    return true
  end
  
  -----------------------------------------------------------------------------
  -- Returns a reasonable hash code of this waypoint registry
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local waypointRegistry = <omitted>
  --   local hash = waypointRegistry:hashCode()
  --
  -- @return number hash code of this waypoint registry
  -----------------------------------------------------------------------------
  function WaypointRegistry:hashCode()
    local result = 31
    for key, val in ipairs(self.waypoints) do 
      result = 17 * result + val:hashCode()
    end
    
    return result
  end
  
  twf.waypoints.WaypointRegistry = WaypointRegistry
end

-----------------------------------------------------------------------------
-- Extensions to actionpath to support loading waypoints
-----------------------------------------------------------------------------
if not twf.actionpath.ActionPath.WAYPOINT_EXTENSIONS then
  local ActionPath = twf.actionpath.ActionPath
  
  -----------------------------------------------------------------------------
  -- Loads the specified waypoint registry from file, and sets it as the
  -- waypoing registry for this action path, so it can be used in waypoint
  -- related actions. It is not necessary to use this if the action path was
  -- loaded from a file that was saved with an actionpath the waypoint registry 
  -- loaded.
  --
  -- Usage:
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:loadWaypointRegistry('waypoints.dat')
  --
  -- @param fileName the filename to load the waypoint registry from
  -----------------------------------------------------------------------------
  function ActionPath:loadWaypointRegistry(fileName)
    local file = fs.open(fileName, 'r')
    local saved = file.readAll()
    file.close()
    
    self.pathState.waypointRegistry = twf.waypoints.WaypointRegistry.unserialize(saved)
  end
  
  
  -----------------------------------------------------------------------------
  -- Serializes this actionpath 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --   local serialized = act:serializableObject()
  --   local unserialized = twf.actionpath.action.Action.unserializeObject(serialized)
  --
  -- @return object serialization of this action
  -----------------------------------------------------------------------------
  local baseSerializableObject = ActionPath.serializableObject 
  function ActionPath:serializableObject()
    local resultTable = baseSerializableObject(self)
    
    local resultPathState = {}
    for key, value in pairs(resultTable.pathState) do 
      resultPathState[key] = value
    end
    
    if resultPathState.waypointRegistry then
      resultPathState.waypointRegistry = resultPathState.waypointRegistry:serializableObject()
    end
    
    resultTable.pathState = resultPathState
    
    return resultTable
  end
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.ActionPath:new()
  --   local serialized = act:serializableObject()
  --   local unserialized = twf.actionpath.action.ActionPath.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -----------------------------------------------------------------------------
  local baseUnserializeObject = ActionPath.unserializeObject
  function ActionPath:unserializeObject(serTable)
    baseUnserializeObject(self, serTable)
    
    if self.pathState.waypointRegistry then 
      self.pathState.waypointRegistry = twf.waypoints.WaypointRegistry.unserializeObject(self.pathState.waypointRegistry)
    end
  end
  
  ActionPath.WAYPOINT_EXTENSIONS = true
end

if not twf.waypoints.action then twf.waypoints.action = {} end

-----------------------------------------------------------------------------
-- twf.waypoints.action.GotoWaypointAction
--
-- Goes to a waypoint inside a waypoint registry. The waypoint registry must 
-- already be loaded in the action path.
--
-- @see twf.actionpath.ActionPath:loadWaypointRegistry(fileName)
-----------------------------------------------------------------------------
if not twf.waypoints.action.GotoWaypointAction then
  local GotoWaypointAction = {}
  -----------------------------------------------------------------------------
  -- The log file handle for this action.
  -----------------------------------------------------------------------------
  GotoWaypointAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The name of the waypoint that is being gone to
  -----------------------------------------------------------------------------
  GotoWaypointAction.waypointName = nil
  
  -----------------------------------------------------------------------------
  -- The hints that are given to the rudimentary pathfinding algorithm. Any of 
  -- the following:
  --
  --  'xyz' - Go in the x-direction first, then y-direction, then z
  --  'xzy' - Go in the x-direction first, then z-direction, then y
  --  'yxz' - Go in the y-direction first, then x-direction, then z
  --  'yzx' - Go in the y-direction first, then z-direction, then x
  --  'zxy' - Go in the z-direction first, then x-direction, then y
  --
  --  'longestFirst'  - Go the longest axis first, then next longest, then last
  --  'shortestFirst' - Go the shortest axis first, then next shortest, then last
  -----------------------------------------------------------------------------
  GotoWaypointAction.pathfindingHint = nil
  
  -----------------------------------------------------------------------------
  -- The method to resolve obstructions. Any of the following:
  --
  --  'fail'  - return failure
  --  'retry' - retry the movement until it succeeds
  --  'dig'   - dig in the direction of movement
  -----------------------------------------------------------------------------
  GotoWaypointAction.onObstruction = nil
  
  -----------------------------------------------------------------------------
  -- The current move stack of the waypoint action. For internal use.
  -----------------------------------------------------------------------------
  GotoWaypointAction.moveStack = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local act = twf.waypoints.action.GotoWaypointAction:new({
  --     waypointName = 'start',
  --     pathfindingHint = 'xyz',
  --     onObstruction = 'retry'
  --   })
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.waypointName is not a string
  -- @error   if o.pathfindingHint is not a valid string
  -- @error   if o.onObstruction is not a valid string
  -----------------------------------------------------------------------------
  function GotoWaypointAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.waypointName) ~= 'string' then 
      error('Expected o.waypointName to be a string but it is ' .. type(o.waypointName))
    end
    
    if type(o.pathfindingHint) ~= 'string' then 
      error('Expected o.pathfindingHint to be a string but it is ' .. type(o.pathfindingHint))
    end
    
    local pfHintValid = o.pathfindingHint == 'xyz' 
    pfHintValid = pfHintValid or o.pathfindingHint == 'xzy'
    pfHintValid = pfHintValid or o.pathfindingHint == 'yxz'
    pfHintValid = pfHintValid or o.pathfindingHint == 'yzx'
    pfHintValid = pfHintValid or o.pathfindingHint == 'zxy'
    pfHintValid = pfHintValid or o.pathfindingHint == 'zyx'
    pfHintValid = pfHintValid or o.pathfindingHint == 'longestFirst'
    pfHintValid = pfHintValid or o.pathfindingHint == 'shortestFirst'
    
    if not pfHintValid then 
      error('Invalid o.pathfindingHint ' .. tostring(o.pathfindingHint))
    end
    
    local onObsValid = o.onObstruction == 'fail'
    onObsValid = onObsValid or o.onObstruction == 'retry'
    onObsValid = onObsValid or o.onObstruction == 'dig'
    
    if not onObsValid then 
      error('Invalid o.onObstruction ' .. tostring(o.onObstruction))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Guarranteed to be called at least once before perform. The log file should
  -- be set to all of the actions children
  --
  -- @param logFile file handle
  -----------------------------------------------------------------------------
  function GotoWaypointAction:setLogFile(logFile)
    self.logFile = logFile
    
    if self.moveStack then 
      for _, act in ipairs(self.moveStack) do 
        act:setLogFile(logFile)
      end
    end
  end
  
  -----------------------------------------------------------------------------
  -- Initializes the move stack for the specified waypoint. Normally for 
  -- internal use.
  --
  -- @param stateTurtle the stateful turtle
  -- @param pathState   the path state
  function GotoWaypointAction:initMoveStack(stateTurtle, pathState)
    if not pathState.waypointRegistry then 
      error('Waypoint registry not loaded!')
    end
    
    local waypoint = pathState.waypointRegistry:getByName(self.waypointName)
    if not waypoint then 
      error('Waypoint not found!')
    end
    
    self.moveStack = {}
    local goInDir = function(dir, times)
      self.logFile.writeLine('GotoWaypointAction initMoveStack goInDir (dir = ' .. twf.movement.direction.toString(dir) .. ', times=' .. tostring(times) .. ') start')
      
      local act = twf.actionpath.action.MoveResultInterpreterAction:new({
        child = twf.movement.action.MoveAction:new({direction = dir})
      })
      
      if self.onObstruction == 'retry' then 
        act = twf.actionpath.action.SucceederAction:new({child =
          twf.actionpath.action.RepeatUntilFailureAction:new({child = 
            twf.actionpath.action.InverterAction:new({child = act})
          })
        })
      elseif self.onObstruction == 'dig' then
        act = twf.actionpath.action.SucceederAction:new({child =
          twf.actionpath.action.RepeatUntilFailureAction:new({child =                                -- until we 
            twf.actionpath.action.InverterAction:new({child =                                        -- succeed
              twf.actionpath.action.SelectorAction:new({children = {                                 -- try to 
                act,                                                                                 -- move, but if that fails
                twf.actionpath.action.InverterAction:new({child =                                    -- always return failure
                  twf.actionpath.action.SucceederAction:new({child =
                    twf.inventory.action.DigAction:new({direction = twf.movement.direction.FORWARD}) -- but try to dig 
                  })
                })
              }})
            })
          })
        })
      elseif self.onObstruction == 'fail' then 
      else
        error('Unknown onObstruction in goForward')
      end
      
      act = twf.actionpath.action.RepeaterAction:new({times = times, child = act})
      act:setLogFile(self.logFile)
      table.insert(self.moveStack, 1, act)
      self.logFile.writeLine('GotoWaypointAction initMoveStack goInDir end')
    end
    
    local turtleFacing = stateTurtle.orientation
    
    local turnToFace = function(dir) 
      local direction = twf.movement.direction
      local act = nil
      self.logFile.writeLine('GotoWaypointAction initMoveStack turnToFace (dir=' .. twf.movement.direction.toString(dir) .. ') start')
      self.logFile.writeLine('GotoWaypointAction initMoveStack turnToFace expect to be facing ' .. twf.movement.direction.toString(turtleFacing) .. ' at this point')
      if turtleFacing == dir then 
        self.logFile.writeLine('GotoWaypointAction initMoveStack turnToFace no turning necessary')
        return 
      end
      
      if direction.clockwiseOf(turtleFacing) == dir then 
        self.logFile.writeLine('GotoWaypointAction initMoveStack turnToFace turning clockwise once')
        act = twf.actionpath.action.MoveResultInterpreterAction:new({child = 
          twf.movement.action.TurnAction:new({direction = direction.CLOCKWISE})
        })
      elseif direction.counterClockwiseOf(turtleFacing) == dir then 
        self.logFile.writeLine('GotoWaypointAction initMoveStack turnToFace turning counterclockwise once')
        act = twf.actionpath.action.MoveResultInterpreterAction:new({child =
          twf.movement.action.TurnAction:new({direction = direction.COUNTER_CLOCKWISE})
        })
      else -- behind us
        self.logFile.writeLine('GotoWaypointAction initMoveStack turnToFace turning around')
        act = twf.actionpath.action.RepeaterAction:new({times = 2, child =
          twf.actionpath.action.MoveResultInterpreterAction:new({child = 
            twf.movement.action.TurnAction:new({direction = direction.CLOCKWISE})
          })
        })
      end
      act:setLogFile(self.logFile)
      table.insert(self.moveStack, 1, act)
      turtleFacing = dir
    end
    
    local goInX = function()
      local dx = waypoint.position.x - stateTurtle.position.x
      if dx == 0 then 
      elseif dx < 0 then
        turnToFace(twf.movement.direction.NEGATIVE_X)
        goInDir(twf.movement.direction.FORWARD, -dx)
      elseif dx > 0 then
        turnToFace(twf.movement.direction.POSITIVE_X)
        goInDir(twf.movement.direction.FORWARD, dx)
      end
    end
    
    local goInY = function()
      local dy = waypoint.position.y - stateTurtle.position.y
      if dy == 0 then 
      elseif dy < 0 then
        goInDir(twf.movement.direction.DOWN, -dy)
      elseif dy > 0 then
        goInDir(twf.movement.direction.UP, dy)
      end
    end
    
    local goInZ = function()
      local dz = waypoint.position.z - stateTurtle.position.z
      if dz == 0 then 
      elseif dz < 0 then
        turnToFace(twf.movement.direction.NEGATIVE_Z)
        goInDir(twf.movement.direction.FORWARD, -dz)
      elseif dz > 0 then
        turnToFace(twf.movement.direction.POSITIVE_Z)
        goInDir(twf.movement.direction.FORWARD, dz)
      end
    end
    
    if self.pathfindingHint == 'xyz' then
      goInX()
      goInY()
      goInZ()
    elseif self.pathfindingHint == 'xzy' then 
      goInX()
      goInY()
      goInZ()
    elseif self.pathfindingHint == 'yxz' then 
      goInY()
      goInX()
      goInZ()
    elseif self.pathfindingHint == 'yzx' then
      goInY()
      goInZ()
      goInX()
    elseif self.pathfindingHint == 'zxy' then
      goInZ()
      goInX()
      goInY()
    elseif self.pathfindingHint == 'zyx' then
      goInZ()
      goInY()
      goInZ()
    elseif self.pathfindingHint == 'longestFirst' then
      local dx = stateTurtle.position.x - waypoint.position.x
      local dy = stateTurtle.position.y - waypoint.position.y
      local dz = stateTurtle.position.z - waypoint.position.z
      
      local unsorted = {
        {goInX, dx, 'x'},
        {goInY, dy, 'y'},
        {goInZ, dz, 'z'}
      }
      
      local swapped = true -- bubble sort, why not
      while swapped do 
        swapped = false
        for i = 2, #unsorted do 
          if math.abs(unsorted[i - 1][2]) > math.abs(unsorted[i][2]) then 
            local tmp = unsorted[i]
            unsorted[i] = unsorted[i - 1]
            unsorted[i - 1] = tmp
            swapped = true
          end
        end
      end
      
      self.logFile.writeLine('GotoWaypointAction initMoveStack decided to do ' .. unsorted[1][3] .. unsorted[2][3] .. unsorted[3][3])
      unsorted[1][1]()
      unsorted[2][1]()
      unsorted[3][1]()
    elseif self.pathfindingHint == 'shortestFirst' then
      local dx = stateTurtle.position.x - waypoint.position.x
      local dy = stateTurtle.position.y - waypoint.position.y
      local dz = stateTurtle.position.z - waypoint.position.z
      
      local unsorted = {
        {goInX, dx, 'x'},
        {goInY, dy, 'y'},
        {goInZ, dz, 'z'}
      }
      
      local swapped = true -- bubble sort, why not
      while swapped do 
        swapped = false
        for i = 2, #unsorted do 
          if math.abs(unsorted[i - 1][2]) < math.abs(unsorted[i][2]) then
            local tmp = unsorted[i]
            unsorted[i] = unsorted[i - 1]
            unsorted[i - 1] = tmp
            swapped = true
          end
        end
      end
      
      self.logFile.writeLine('GotoWaypointAction initMoveStack decided to do ' .. unsorted[1][3] .. unsorted[2][3] .. unsorted[3][3])
      unsorted[1][1]()
      unsorted[2][1]()
      unsorted[3][1]()
    else 
      error('Unexpected pathfinding hint in initMoveStack')
    end
    
    if waypoint.orientation then 
      turnToFace(waypoint.orientation)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the turtle reaches the destination, running while it's 
  -- going there, failure if an obstacle prevents movement
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.waypoints.action.GotoWaypointAction:new({
  --     waypointName = 'start', 
  --     pathfindingHint = 'xyz',
  --     onObstruction = 'fail'
  --   })
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function GotoWaypointAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('GotoWaypointAction (waypointName = ' .. self.waypointName .. ', pathfindingHint = ' .. self.pathfindingHint .. ', onObstruction = ' .. self.onObstruction .. ') start')
    
    if self.moveStack == nil then 
      self.logFile.writeLine('GotoWaypointAction move stack is nil, initializing move stack')
      self:initMoveStack(stateTurtle, pathState)
      self.logFile.writeLine('GotoWaypointAction move stack initialized, returning running')
      return twf.actionpath.ActionResult.RUNNING
    end
    
    if #self.moveStack == 0 then
      self.logFile.writeLine('GotoWaypointAction move stack is empty, returning success')
      self.moveStack = nil
      return twf.actionpath.ActionResult.SUCCESS
    end
    
    self.logFile.writeLine('GotoWaypointAction move stack is not nil or empty, popping next action')
    local pop = table.remove(self.moveStack)
    
    self.logFile.writeLine('GotoWaypointAction running popped action ' .. pop.name())
    local result = pop:perform(stateTurtle, pathState)
    
    if result == twf.actionpath.ActionResult.SUCCESS then
      self.logFile.writeLine('GotoWaypointAction child returned success - returning running')
      return twf.actionpath.ActionResult.RUNNING
    elseif result == twf.actionpath.ActionResult.RUNNING then
      self.logFile.writeLine('GotoWaypointAction child returned running - adding back to stack and returning running')
      table.insert(self.moveStack, pop)
      return twf.actionpath.ActionResult.RUNNING
    elseif result == twf.actionpath.ActionResult.FAILURE then
      self.logFile.writeLine('GotoWaypointAction child returned failure - returning failure')
      self.moveStack = nil
      return twf.actionpath.ActionResult.FAILURE
    end
    
    error('Should not get here')
  end
  
  -----------------------------------------------------------------------------
  -- Unused
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function GotoWaypointAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   -- prints twf.waypoints.action.GotoWaypointAction
  --   print(twf.waypoints.action.GotoWaypointAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function GotoWaypointAction.name()
    return 'twf.waypoints.action.GotoWaypointAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local act = <omitted>
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.waypoints.action.GotoWaypointAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function GotoWaypointAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.waypointName = self.waypointName
    resultTable.pathfindingHint = self.pathfindingHint
    resultTable.onObstruction = self.onObstruction
    if self.moveStack then 
      resultTable.moveStack = {}
      
      for key, act in ipairs(self.moveStack) do 
        resultTable.moveStack[key] = actionPath:serializableObjectForAction(act)
      end
    end
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local act = <omitted>
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.waypoints.action.GotoWaypointAction.unserializeObject(serialized)
  --
  -- @param serialized the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function GotoWaypointAction.unserializeObject(serialized, actionPath)
    local waypointName = serialized.waypointName
    local pathfindingHint = serialized.pathfindingHint
    local onObstruction = serialized.onObstruction
    local moveStack = nil
    if serialized.moveStack then 
      moveStack = {}
      
      for key, serAct in ipairs(serialized.moveStack) do 
        moveStack[key] = actionPath:unserializeObjectOfAction(serAct)
      end
    end
    
    return GotoWaypointAction:new({
      waypointName = waypointName, 
      pathfindingHint = pathfindingHint, 
      onObstruction = onObstruction,
      moveStack = moveStack
    })
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local act = <omitted>
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.waypoints.action.GotoWaypointAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function GotoWaypointAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject(actionPath))
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local act = <omitted>
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.waypoints.action.GotoWaypointAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function GotoWaypointAction.unserialize(serialized, actionPath)
    return GotoWaypointAction.unserializeObject(textutils.unserialize(serialized), actionPath)
  end
  
  twf.waypoints.action.GotoWaypointAction = GotoWaypointAction
end

-----------------------------------------------------------------------------
-- twf.waypoints.action.SaveWaypointAction
--
-- Saves a waypoint at the turtles current position
-----------------------------------------------------------------------------
if not twf.waypoints.action.SaveWaypointAction then
  local SaveWaypointAction = {}
  -----------------------------------------------------------------------------
  -- The log file handle for this action.
  -----------------------------------------------------------------------------
  SaveWaypointAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The name of the waypoint to save
  -----------------------------------------------------------------------------
  SaveWaypointAction.waypointName = nil
  
  -----------------------------------------------------------------------------
  -- The id of the waypoint to save
  -----------------------------------------------------------------------------
  SaveWaypointAction.waypointId = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local act = twf.waypoints.action.SaveWaypointAction:new({
  --     waypointName = 'old_spot',
  --     waypointId = 2
  --   })
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.waypointName is not a string
  -- @error   if o.waypointId is not a number
  -----------------------------------------------------------------------------
  function SaveWaypointAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.waypointName) ~= 'string' then 
      error('Expected o.waypointName to be a string, but it is ' .. type(o.waypointName))
    end
    
    if type(o.waypointId) ~= 'number' then 
      error('Expected o.waypointId to be a number, but it is ' .. type(o.waypointId) .. '(waypointName = ' .. o.waypointName .. ')')
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Guarranteed to be called at least once before perform. The log file should
  -- be set to all of the actions children
  --
  -- @param logFile file handle
  -----------------------------------------------------------------------------
  function SaveWaypointAction:setLogFile(logFile)
    self.logFile = logFile
  end
  
  
  -----------------------------------------------------------------------------
  -- Returns success after saving the waypoint with the appropriate name, id,
  -- and the turtles current position
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.waypoints.action.SaveWaypointAction:new({
  --     waypointName = 'start',
  --     waypointId = 2
  --   })
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function SaveWaypointAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('SaveWaypointAction (waypointName = ' .. self.waypointName .. ') start')
    local waypoint = twf.waypoints.Waypoint:new({
      name = self.waypointName,
      id = self.waypointId,
      position = stateTurtle.position:clone(),
      orientation = stateTurtle.orientation
    })
    
    self.logFile.writeLine('SaveWaypointAction saving ' .. waypoint:toString())
    pathState.waypointRegistry:addOrSetWaypoint(waypoint)
    self.logFile.writeLine('SaveWaypointAction returning success')
    return twf.actionpath.ActionResult.SUCCESS
  end
  
  -----------------------------------------------------------------------------
  -- Unused
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function SaveWaypointAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   -- prints twf.waypoints.action.SaveWaypointAction
  --   print(twf.waypoints.action.SaveWaypointAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function SaveWaypointAction.name()
    return 'twf.waypoints.action.SaveWaypointAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local act = <omitted>
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.waypoints.action.SaveWaypointAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function SaveWaypointAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.waypointName = self.waypointName
    resultTable.waypointId = self.waypointId
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local act = <omitted>
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.waypoints.action.SaveWaypointAction.unserializeObject(serialized)
  --
  -- @param serialized the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function SaveWaypointAction.unserializeObject(serialized, actionPath)
    local waypointName = serialized.waypointName
    local waypointId = serialized.waypointId
    
    return SaveWaypointAction:new({
      waypointName = waypointName,
      waypointId = waypointId
    })
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local act = <omitted>
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.waypoints.action.SaveWaypointAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function SaveWaypointAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject(actionPath))
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_waypoints.lua')
  --   local act = <omitted>
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.waypoints.action.SaveWaypointAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SaveWaypointAction.unserialize(serialized, actionPath)
    return SaveWaypointAction.unserializeObject(textutils.unserialize(serialized), actionPath)
  end
  
  twf.waypoints.action.SaveWaypointAction = SaveWaypointAction
end