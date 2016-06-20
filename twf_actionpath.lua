-----------------------------------------------------------------------------
-- twf_actionpath.lua
--
-- This file contains all pertinent objects to programs that subscribe to the
-- action path pattern.
--
-- The action path pattern is a program that is described by a set of actions,
-- where each action is short and recoverable. This pattern increases the 
-- length of the code substantially and reduces legibility when used directly,
-- but really shines for both recovering when the turtle crashes for some 
-- reason, and dynamically creating variations on programs without 
-- significant development costs.
--
-- @author Timothy
-----------------------------------------------------------------------------

dofile('twf_movement.lua')
dofile('twf_inventory.lua')

if not twf.actionpath then twf.actionpath = {} end
if not twf.actionpath.action then twf.actionpath.action = {} end

-----------------------------------------------------------------------------
-- twf.actionpath.action.Action 
--
-- Describes how actions will be treated in actionpaths. It should be noted
-- that this is strictly compatible with twf.movement.action.Action. 
-- 
-- @see twf.movement.action.Action
-----------------------------------------------------------------------------
if not twf.actionpath.action.Action then 
  local Action = {}
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --
  -- @param o (optional) superseding object
  -- @return  a new instance of this action
  -----------------------------------------------------------------------------
  function Action:new(o)
    error('Action:new(o) should not be called directly!')
  end
  
  -----------------------------------------------------------------------------
  -- Performs this action. Returns the result of the action. The actionpath 
  -- such that the last action is assumed to have succeeded.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.Action:new()
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function Action:perform(stateTurtle, pathState)
    error('Action:perform(stateTurtle, pathState) should not be called directly!')
  end
  
  -----------------------------------------------------------------------------
  -- Called when this action completes successfully. Should update the state
  -- of the turtle. Non-leaf actions should do nothing here.
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --   local st = twf.movement.StateTurtle.loadOrInit('my_program')
  --   local pathState = {}
  --   local result = act:perform(st, pathState)
  --   if someSuccessCheck(result) then 
  --     act:update(st, pathState)
  --   end
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function Action:updateState(stateTurtle, pathState)
    error('Action:updateState(stateTurtle, pathState should not be called directly!')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.Action
  --   print(twf.actionpath.action.Action.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function Action.name()
    return 'twf.actionpath.action.Action'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Action.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function Action:serialize(actionPath)
    error('Action:serialize(actionPath) should not be called directly!')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Action.unserialize(serialized)
  --   -- Depends on the action what this prints
  --   print(unserialized:serialize())
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Action.unserialize(serialized)
    error('Action:unserialize(serialized) should not be called directly!')
  end
  
  twf.actionpatch.action.Action = Action
end

-----------------------------------------------------------------------------
-- Describes an action path. An action path is a modified behavior tree, with
-- special consideration for recovery due to the high "disastrous failure" 
-- rate of turtles.
--
-- In order for successful recover, action paths should have each step 
-- involve going to absolute positions, never relative ones.
--
-- Comparing to behavior trees:
--   Action <=> Behavior 
--   Most default actions are already implemented in twf.actionpath.actions
--   Internal state can be stored and retrieved from the actionpath if 
--   desired (see extensions to twf.movement.action.Action) (primitive types
--   only)
--
-- Behavior tree useful links
-- @see https://en.wikipedia.org/wiki/Behavior_tree 
-- @see http://guineashots.com/2014/09/24/implementing-a-behavior-tree-part-1/
-- @see http://www.gamasutra.com/blogs/ChrisSimpson/20140717/221339/Behavior_trees_for_AI_How_they_work.php
--
-- This codebase
-- @see twf.actionpath.actions
-----------------------------------------------------------------------------
if not twf.actionpath.ActionPath then 
  local ActionPath = {}
  
  -----------------------------------------------------------------------------
  -- The action to start with, similiar to a linked list
  -----------------------------------------------------------------------------
  ActionPath.head = nil
  
  -----------------------------------------------------------------------------
  -- List of actions that have been registered with this action path. Required
  -- in order to load actions
  -----------------------------------------------------------------------------
  ActionPath.registeredActions = nil
  
  -----------------------------------------------------------------------------
  -- Describes the current state of this path. 
  -----------------------------------------------------------------------------
  ActionPath.pathState = nil
  
  -----------------------------------------------------------------------------
  -- Initializes a new action path
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --
  -- @param o (optional) superseding object
  -- @return a new instance of action path
  function ActionPath:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Registers the specified actions such that they may be loaded from file
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.movement.action, twf.actionpath.action)
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   local myCustomAction = {}
  --   function myCustomAction:new(o) error('Not yet implemented') end
  --   function myCustomAction:perform(stateTurtle, pathState) error('Not yet implemented') end
  --   function myCustomAction:updateState(stateTurtle, pathState) error('Not yet implemented') end
  --   function myCustomAction.name() return 'myCustomAction' end
  --   function myCustomAction:serialize(actionPath) error('Not yet implemented') end
  --   function myCustomAction:unserialize(serialized) error('Not yet implemented') end
  --   local myCustomAction2 = {}
  --   -- Functions, like above, omitted
  --   -- ...
  --   actPath:registerActions(myCustomAction, myCustomAction2, twf.movement.action, twf.actionpath.action)
  -- 
  -- @param arg either a table of actions or an action to load or some 
  --            combination of those
  -----------------------------------------------------------------------------
  function ActionPath:registerActions(...)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Loads the action path from the specified file name. Any actions referenced
  -- MUST have already been registered using registerActions
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.movement.action, twf.actionpath.action)
  --   actPath:loadFromFile('my_prog.actionpath')
  --
  -- @param fileName the file to load from 
  -----------------------------------------------------------------------------
  function ActionPath:loadFromFile(fileName)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Saves this action path to file. Does not need to have its actions
  -- registered in order to save.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:saveToFile('my_prog.actionpath')
  -- 
  -- @param fileName the filename to save to 
  -----------------------------------------------------------------------------
  function ActionPath:saveToFile(fileName)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- 'Ticks' this action path by calling the head actions perform. Assuming the
  -- head action return ActionResult.SUCCESS then its updateState is called.
  -- Otherwise, an error is thrown. 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.movement.action, twf.actionpath.action)
  --   actPath:loadFromFile('my_prog.actionpath')
  --   actPath:tick()
  -----------------------------------------------------------------------------
  function ActionPath:tick()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Serializes the specified action 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.movement.action, twf.actionpath.action)
  --   local act = twf.actionpath.action.FuelCheckAction({fuelLevel = 5})
  --   local serialized = actPath:serializeAction(act)
  --   local unserialized = actPath:unserializeAction(act)
  --
  -- @return string serialization of the action
  -----------------------------------------------------------------------------
  function ActionPath:serializeAction(action)
    local resultTable = {}
    
    resultTable.name = action.name()
    resultTable.action = action:serialize(self)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by unserializeAction. MUST be one of the
  -- registered actions.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.movement.action, twf.actionpath.action)
  --   local act = twf.actionpath.action.FuelCheckAction({fuelLevel = 5})
  --   local serialized = actPath:serializeAction(act)
  --   local unserialized = actPath:unserializeAction(act)
  --
  -- @param serializedAction the serialized action
  -- @return                 action that was serialized
  function ActionPath:unserializeAction(serializedAction)
    error('Not yet implemented')
  end
  -----------------------------------------------------------------------------
  -- Serializes this actionpaths head action and pathstate such that it can be 
  -- recovered by an actionpath with the same registered actions
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   local serialized = actPath:serialize()
  --   local actPath2 = twf.actionpath.ActionPath:new()
  --   actPath2:unserialize(serialized)
  --
  -- @return string serialization of this actionpath
 -----------------------------------------------------------------------------
  function ActionPath:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Loads the action path list from a string. MUST have the same 
  -- registered actions as the actionpath that was serialized for this function 
  -- to work correctly. Should be saved without overriding the "original" 
  -- actionpath file that was created to ensure successful recovery in 
  -- conjunction with twf.movement.StatefulTurtle.loadOrInit
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.movement.action, twf.actionpath.action)
  --   local serialized = actPath:serialize()
  --   local actPath2 = twf.actionpath.ActionPath:new()
  --   actPath2:registerActions(twf.movement.action, twf.actionpath.action)
  --   actPath2:unserialize(serialized)
  --
  -- @param serialized string serialization of an actionpath
  -- @return           action path that was serialized
  -----------------------------------------------------------------------------
  function ActionPath:unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.ActionPath = ActionPath
end

-----------------------------------------------------------------------------
-- Action path extensions to the StatefulTurtle that allow for simple 
-- integration with action paths.
-----------------------------------------------------------------------------
if not twf.movement.StatefulTurtle.ACTIONPATH_EXTENSIONS then
  local StatefulTurtle = twf.movement.StatefulTurtle
  
  -----------------------------------------------------------------------------
  -- Executes or recovers the specified actionpath. Should not be used with 
  -- loadOrInit.
  --
  -- Remarks:
  --  First loads the actionpath from file. Due to the strict serialization 
  --  this will run the turtle in the appropriate state - the next child to
  --  be called will 
  --
  -- Usage:
  --   -- Generally in startup file
  --   dofile('twf_actionpath.lua')
  --   local ActionPath = twf.actionpath.ActionPath
  --   local myProg = ActionPath:new()
  --   myProg:registerActions(twf.movement.action, twf.actionpath.action)
  --   -- Register custom actions here
  --   myProg:loadFromFile('my_program.actionpath')
  --   
  --   local st = twf.movement.StatefulTurtle:new()
  --   st:executeActionPath(myProg, 'state', 'actpath_state')
  --
  -- Remarks:
  --   This function may never return 
  --
  -- @param actionPath         the action path to execute
  -- @param statePrefix        prefix for the turtle state. 
  --                           Postfixed with .dat and _action_recovery.dat
  -- @param actPathStatePrefix prefix for the action path state.
  --                           Postfixed with _recovery.dat
  -- @see                      twf.actionpath.ActionPath
  -----------------------------------------------------------------------------
  function StatefulTurtle:executeActionPath(actionPath, statePrefix, actPathStatePrefix)
    error('Not yet implemented')
  end
  
  StatefulTurtle.ACTIONPATH_EXTENSIONS = true
end

-- Useful things for any actionpath

-----------------------------------------------------------------------------
-- twf.actionpath.ActionResult
--
-- A result for a composite or decorator action or action-path-aware actions
-----------------------------------------------------------------------------
if not twf.actionpath.ActionResult then
  local ActionResult = {}
  
  -----------------------------------------------------------------------------
  -- Indicates the action completed successfully. Also a synonym for true for 
  -- some decorators
  -----------------------------------------------------------------------------
  ActionResult.SUCCESS = 10067
  
  -----------------------------------------------------------------------------
  -- Indicates the action needs more time to complete, and should be called 
  -- again before anything else. 
  -----------------------------------------------------------------------------
  ActionResult.RUNNING = 10069
  
  -----------------------------------------------------------------------------
  -- Indicates the action was unsuccessful. Also a synonym for false for some 
  -- decorators
  -----------------------------------------------------------------------------
  ActionResult.FAILURE = 10079
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of this action result
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints action: success
  --   print(twf.actionpath.ActionResult.toString(twf.actionpath.ActionResult.SUCCESS))
  --
  -- @param actionResult the action result code 
  -- @return             string description of the result code
  -----------------------------------------------------------------------------
  function ActionResult.toString(actionResult)
    error('Not yet implemented')
  end
  
  twf.actionpath.ActionResult = ActionResult
end

-- Useful actions

-- Composites

-----------------------------------------------------------------------------
-- twf.actionpath.action.SequenceAction
--
-- Visits each child in order, starting with the first. Upon success, returns
-- ActionResult.RUNNING if there is another child, otherwise returns SUCCESS.
-- If any child fails, immediately returns failure
-----------------------------------------------------------------------------
if not twf.actionpath.action.SequenceAction then
  local SequenceAction = {}
  
  -----------------------------------------------------------------------------
  -- The children of this sequence, in order
  -----------------------------------------------------------------------------
  SequenceAction.children = nil
  
  -----------------------------------------------------------------------------
  -- The current index of this sequence action
  -----------------------------------------------------------------------------
  SequenceAction.currentIndex = 1
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SequenceAction:new({children = {}})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.children is not a table or is empty
  -----------------------------------------------------------------------------
  function SequenceAction:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Visits each child in order, starting with the first. If any child fails,
  -- immediately returns failure. If no child fails, returns success
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.SequenceAction:new({children = {}})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function SequenceAction:perform(stateTurtle, pathState)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function SequenceAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.SequenceAction
  --   print(twf.actionpath.action.SequenceAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function SequenceAction.name()
    return 'twf.actionpath.action.SequenceAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SequenceAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SequenceAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function SequenceAction:serialize(actionPath)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SequenceAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SequenceAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SequenceAction.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.SequenceAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.SelectorAction
--
-- Visits each child in order, starting with the first. If the child returns
-- success, immediately returns success. Otherwise, returns RUNNING and when
-- called again tries the next child. If no childs are left, returns FAILURE.
-----------------------------------------------------------------------------
if not twf.actionpath.action.SelectorAction then
  local SelectorAction = {}
  
  -----------------------------------------------------------------------------
  -- A table of the children for this selector
  -----------------------------------------------------------------------------
  SelectorAction.children = nil
  
  -----------------------------------------------------------------------------
  -- The current index of this action in children
  -----------------------------------------------------------------------------
  SelectorAction.currentIndex = 1
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this SelectorAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SelectorAction:new({children = {}})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.children is nil or empty
  -----------------------------------------------------------------------------
  function SelectorAction:new(o)
    error('Not yet implemented')
  end
  
  
  -----------------------------------------------------------------------------
  -- Visits each child in order, starting with the first. If any child succeeds,
  -- immediately returns success. If no child succeeds, returns failure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.SelectorAction:new({children = {}})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function SelectorAction:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function SelectorAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.SelectorAction
  --   print(twf.actionpath.action.SelectorAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function SelectorAction.name()
    return 'twf.actionpath.action.SelectorAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SelectorAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SelectorAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function SelectorAction:serialize(actionPath)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SelectorAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SelectorAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SelectorAction.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.SelectorAction = SelectorAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.RandomSelectorAction
--
-- Selects an action at random from a list of actions. That action is run 
-- until it returns either SUCCESS or FAILURE. If it returns success, 
-- immediately returns success. If it returns failure, another child is 
-- selected until either all children are exhausted and the selector returns
-- failure, or a child returns success.
--
-- When ticked again after returning success or failure, acts as a "blank slate" 
-- and may pick any of its children again.
-----------------------------------------------------------------------------
if not twf.actionpath.action.RandomSelectorAction then
  local RandomSelectorAction = {}
  
  -----------------------------------------------------------------------------
  -- The actions that can be chosen from
  -----------------------------------------------------------------------------
  RandomSelectorAction.children = nil
  
  -----------------------------------------------------------------------------
  -- What indexes have already been tried since the last time the selector 
  -- returned success or failure
  -----------------------------------------------------------------------------
  RandomSelectorAction.bannedIndexes = nil
  
  -----------------------------------------------------------------------------
  -- Either nil if this selector needs to pick a new action to try, or the
  -- index of the action that is currently running.
  -----------------------------------------------------------------------------
  RandomSelectorAction.currentIndex = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this RandomSelectorAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RandomSelectorAction:new({children = {}})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.children is nil or empty
  -----------------------------------------------------------------------------
  function RandomSelectorAction:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Visits each child randomly until one returns success or all children are
  -- exhausted, upon which time the selector returns failure.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.RandomSelectorAction:new({children = {}})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function RandomSelectorAction:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function RandomSelectorAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.RandomSelectorAction
  --   print(twf.actionpath.action.RandomSelectorAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function RandomSelectorAction.name()
    return 'twf.actionpath.action.RandomSelectorAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RandomSelectorAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RandomSelectorAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function RandomSelectorAction:serialize(actionPath)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RandomSelectorAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RandomSelectorAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RandomSelectorAction.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.RandomSelectorAction = RandomSelectorAction
end

-- Decorators

-----------------------------------------------------------------------------
-- twf.actionpath.action.Inverter
--
-- Inverts the result of the child - FAILURE -> SUCCESS, RUNNING -> RUNNING, 
-- and SUCCESS -> FAILURE
-----------------------------------------------------------------------------
if not twf.actionpath.action.Inverter then
  local Inverter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this inverter
  -----------------------------------------------------------------------------
  Inverter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this Inverter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Inverter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function Inverter:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns the inverted result of the child
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.Inverter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function Inverter:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function Inverter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.Inverter
  --   print(twf.actionpath.action.Inverter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function Inverter.name()
    return 'twf.actionpath.action.Inverter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Inverter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Inverter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Inverter:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Inverter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Inverter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Inverter.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.Inverter = Inverter
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.Succeeder
--
-- Except for RUNNING which is unaffected, always returns SUCCESS
-----------------------------------------------------------------------------
if not twf.actionpath.action.Succeeder then
  local Succeeder = {}
  
  -----------------------------------------------------------------------------
  -- The child of this succeeder
  -----------------------------------------------------------------------------
  Succeeder.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this Succeeder
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Succeeder:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function Succeeder:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns RUNNING if the child returns RUNNING, otherwise returns SUCCESS
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.Succeeder:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function Succeeder:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function Succeeder:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.Succeeder
  --   print(twf.actionpath.action.Succeeder.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function Succeeder.name()
    return 'twf.actionpath.action.Succeeder'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Succeeder:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Succeeder.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Succeeder:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Succeeder:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Succeeder.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Succeeder.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.Succeeder = Succeeder
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.RepeatUntilFailure
-- 
-- Repeats the child action until it returns failure
-----------------------------------------------------------------------------
if not twf.actionpath.action.RepeatUntilFailure then
  local RepeatUntilFailure = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  RepeatUntilFailure.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this RepeatUntilFailure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailure:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function RepeatUntilFailure:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns RUNNING if the child returns RUNNING or SUCCESS, otherwise returns
  -- FAILURE
  
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.RepeatUntilFailure:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function RepeatUntilFailure:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function RepeatUntilFailure:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.RepeatUntilFailure
  --   print(twf.actionpath.action.RepeatUntilFailure.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function RepeatUntilFailure.name()
    return 'twf.actionpath.action.RepeatUntilFailure'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RepeatUntilFailure.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RepeatUntilFailure:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RepeatUntilFailure.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RepeatUntilFailure.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.RepeatUntilFailure = RepeatUntilFailure
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.Repeater
-- 
-- Repeats the child action either indefinitely or a maximum of some number 
-- of times until the child returns FAILURE. Returns SUCCESS if it reaches
-- the maximum number of times without failure, returns RUNNING while it 
-- reaches that, and returns FAILURE immediately if the child returns failure
--
-- The child returning RUNNING is not counted towards the maximum number of 
-- times
-----------------------------------------------------------------------------
if not twf.actionpath.action.Repeater then
  local Repeater = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  Repeater.child = nil
  
  -----------------------------------------------------------------------------
  -- The number of times to repeat the action, nil for infinite times
  -----------------------------------------------------------------------------
  Repeater.times = nil
  
  -----------------------------------------------------------------------------
  -- The number of times the child action 
  Repeater.counter = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this Repeater
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Repeater:new({child = some.action.ActionName:new(), times = 5})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function Repeater:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns failure if the child returns failure. Returns SUCCESS if the child
  -- has returned SUCCESS the appropriate number of times, and returns RUNNING
  -- otherwise.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.Repeater:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function Repeater:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function Repeater:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.Repeater
  --   print(twf.actionpath.action.Repeater.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function Repeater.name()
    return 'twf.actionpath.action.Repeater'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Repeater:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Repeater.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Repeater:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Repeater:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Repeater.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Repeater.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.Repeater = Repeater
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DieOnFailure
--
-- Crash and burn if the child fails.
--
-- @remarks representative of skydiving
-----------------------------------------------------------------------------
if not twf.actionpath.action.DieOnFailure then
  local DieOnFailure = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  DieOnFailure.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DieOnFailure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailure:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function DieOnFailure:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns success or running if the child does, crashes and burns if the 
  -- child returns failure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DieOnFailure:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -- @error  if the child returns failure
  -----------------------------------------------------------------------------
  function DieOnFailure:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DieOnFailure:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DieOnFailure
  --   print(twf.actionpath.action.DieOnFailure.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DieOnFailure.name()
    return 'twf.actionpath.action.DieOnFailure'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DieOnFailure.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DieOnFailure:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DieOnFailure.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DieOnFailure.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.DieOnFailure = DieOnFailure
end


-----------------------------------------------------------------------------
-- twf.actionpath.action.RetryOnFailure
--
-- Try again if the child fails. Has a small delay before retrying
-----------------------------------------------------------------------------
if not twf.actionpath.action.RetryOnFailure then
  local RetryOnFailure = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  RetryOnFailure.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this RetryOnFailure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailure:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function RetryOnFailure:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns success or running if the child does, and running if the child 
  -- returns failure. Delays for 100ms if the child fails to yield
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.RetryOnFailure:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -- @error  if the child returns failure
  -----------------------------------------------------------------------------
  function RetryOnFailure:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function RetryOnFailure:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.RetryOnFailure
  --   print(twf.actionpath.action.RetryOnFailure.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function RetryOnFailure.name()
    return 'twf.actionpath.action.RetryOnFailure'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RetryOnFailure.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RetryOnFailure:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RetryOnFailure.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RetryOnFailure.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.RetryOnFailure = RetryOnFailure
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.MoveResultInterpreter
--
-- Returns success if the child action returns a successful move result
-----------------------------------------------------------------------------
if not twf.actionpath.action.MoveResultInterpreter then
  local MoveResultInterpreter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  MoveResultInterpreter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this MoveResultInterpreter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function MoveResultInterpreter:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful move result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.MoveResultInterpreter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function MoveResultInterpreter:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function MoveResultInterpreter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.MoveResultInterpreter
  --   print(twf.actionpath.action.MoveResultInterpreter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function MoveResultInterpreter.name()
    return 'twf.actionpath.action.MoveResultInterpreter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.MoveResultInterpreter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function MoveResultInterpreter:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.MoveResultInterpreter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function MoveResultInterpreter.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.MoveResultInterpreter = MoveResultInterpreter
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DigResultInterpreter
--
-- Returns success if the child action returns a successful dig result
-----------------------------------------------------------------------------
if not twf.actionpath.action.DigResultInterpreter then
  local DigResultInterpreter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  DigResultInterpreter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DigResultInterpreter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DigResultInterpreter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function DigResultInterpreter:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful dig result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DigResultInterpreter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function DigResultInterpreter:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DigResultInterpreter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DigResultInterpreter
  --   print(twf.actionpath.action.DigResultInterpreter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DigResultInterpreter.name()
    return 'twf.actionpath.action.DigResultInterpreter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DigResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DigResultInterpreter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DigResultInterpreter:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DigResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DigResultInterpreter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DigResultInterpreter.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.DigResultInterpreter = DigResultInterpreter
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.PlaceResultInterpreter
--
-- Returns success if the child action returns a successful place result
-----------------------------------------------------------------------------
if not twf.actionpath.action.PlaceResultInterpreter then
  local PlaceResultInterpreter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  PlaceResultInterpreter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this PlaceResultInterpreter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful place result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.PlaceResultInterpreter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.PlaceResultInterpreter
  --   print(twf.actionpath.action.PlaceResultInterpreter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter.name()
    return 'twf.actionpath.action.PlaceResultInterpreter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.PlaceResultInterpreter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.PlaceResultInterpreter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.PlaceResultInterpreter = PlaceResultInterpreter
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DropResultInterpreter
--
-- Returns success if the child action returns a successful drop result
-----------------------------------------------------------------------------
if not twf.actionpath.action.DropResultInterpreter then
  local DropResultInterpreter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  DropResultInterpreter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DropResultInterpreter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function DropResultInterpreter:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful drop result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DropResultInterpreter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function DropResultInterpreter:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DropResultInterpreter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DropResultInterpreter
  --   print(twf.actionpath.action.DropResultInterpreter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DropResultInterpreter.name()
    return 'twf.actionpath.action.DropResultInterpreter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropResultInterpreter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DropResultInterpreter:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropResultInterpreter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DropResultInterpreter.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.DropResultInterpreter = DropResultInterpreter
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.SuckResultInterpreter
--
-- Returns success if the child action returns a successful suck result
-----------------------------------------------------------------------------
if not twf.actionpath.action.SuckResultInterpreter then
  local SuckResultInterpreter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  SuckResultInterpreter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this SuckResultInterpreter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function SuckResultInterpreter:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful suck result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.SuckResultInterpreter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function SuckResultInterpreter:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function SuckResultInterpreter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.SuckResultInterpreter
  --   print(twf.actionpath.action.SuckResultInterpreter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function SuckResultInterpreter.name()
    return 'twf.actionpath.action.SuckResultInterpreter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SuckResultInterpreter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SuckResultInterpreter:serialize()
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SuckResultInterpreter.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SuckResultInterpreter.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.SuckResultInterpreter = SuckResultInterpreter
end

-- Leafs

-----------------------------------------------------------------------------
-- twf.actionpath.action.MoveAction
--
-- Moves the turtle in a specific direction a specific number of times. Made 
-- to be specifically compatible with action paths
-----------------------------------------------------------------------------
if not twf.actionpath.action.MoveAction then
  local MoveAction = {}
  
  -----------------------------------------------------------------------------
  -- The final position of the turtle when the move action has completed. Set 
  -- up after being called again when the result was not RUNNING last time.
  -----------------------------------------------------------------------------
  MoveAction.finalPosition = nil
  
  -----------------------------------------------------------------------------
  -- How many times to move
  -----------------------------------------------------------------------------
  MoveAction.times = nil
  
  -----------------------------------------------------------------------------
  -- twf.movement.direction to move in, either FORWARD, UP, DOWN, or BACK
  -----------------------------------------------------------------------------
  MoveAction.direction = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new twf.actionpath.action.MoveAction instance
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveAction({
  --     direction = twf.movement.direction.UP,
  --     times = 2
  --   })
  --
  -- @param o superseding object
  -- @return  new instance of move action
  -- @error   if o.direction is not a valid direction to move in
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
      
      if type(o.times) ~= 'number' || o.times < 1 then
        o.times = 1
      end
      
      return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the turtle has reached its destination. If its 
  -- destination has not been set, sets the destination and returns RUNNING.
  -- If it has been set, moves in the appropriate direction and returns RUNNING.
  -- Cannot fail - so be careful of obstructions!
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.MoveAction({
  --     direction = twf.movement.direction.UP,
  --     times = 2
  --   })
  --   local res = act:perform(st, {}) -- RUNNING (set destination)
  --   res = act:perform(st, {}) -- RUNNING (move up)
  --   res = act:perform(st, {}) -- RUNNING (move up)
  --   res = act:perform(st, {}) -- SUCCESS (destination reached)
  --
  -- @param stateTurtle the state turtle to act on 
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function MoveAction:perform(stateTurtle, pathState)
    local delegate = twf.movement.action.MoveAction:new({direction = self.direction})
    
    if not self.finalPosition then 
      local fakeStateTurtle = {
        position = {
          x = stateTurtle.position.x,
          y = stateTurtle.position.y,
          z = stateTurtle.position.z
        }
      }
      
      for i = 1, self.times, 1 do
        delegate.updateState(fakeStateTurtle)
      end
      self.finalPosition = fakeStateTurtle.position
      return twf.actionpath.ActionResult.RUNNING
    end
    
    do
      local notAtDest =        self.finalPosition.x ~= stateTurtle.position.x
      notAtDest = notAtDest or self.finalPosition.y ~= stateTurtle.position.y
      notAtDest = notAtDest or self.finalPosition.z ~= stateTurtle.position.z
      
      if not notAtDest then
        return twf.actionpath.ActionResult.SUCCESS 
      end
    end
    
    stateTurtle:prepareAction(delegate)
    local result = delegate:perform()
    if twf.movement.MovementResult.isSuccess(result) then
      delegate:updateState(st)
    end
    stateTurtle:finishAction(delegate)
    
    return twf.actionpath.ActionResult.RUNNING
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function MoveAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.MoveAction
  --   print(twf.actionpath.action.MoveAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function MoveAction.name()
    return 'twf.actionpath.action.MoveAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveAction:new({direction = twf.movement.direction.FORWARD, times = 2})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.MoveAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function MoveAction:serialize(actionPath)
    local resultTable = {}
    
    resultTable.direction = self.direction
    resultTable.times = self.times
    resultTable.finalPosition = self.finalPosition
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveAction:new({direction = twf.movement.direction.FORWARD, times = 2})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.MoveAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function MoveAction.unserialize(serialized)
    local serTable = textutils.unserialize(serialized)
    
    local direction = serTable.direction
    local times = serTable.times
    local finalPos = serTable.finalPosition
    
    return MoveAction:new({direction = direction, times = times, finalPosition = finalPos})
  end
  
  twf.actionpath.action.MoveAction = MoveAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.TurnAction
--
-- Turns the turtle in a specific direction a specific number of times. Made 
-- to be specifically compatible with action paths
-----------------------------------------------------------------------------
if not twf.actionpath.action.TurnAction then
  local TurnAction = {}
  
  -----------------------------------------------------------------------------
  -- The final direction of the turtle when the move action has completed. Set 
  -- up after being called again when the result was not RUNNING last time.
  -----------------------------------------------------------------------------
  TurnAction.finalDirection = nil
  
  -----------------------------------------------------------------------------
  -- How many times to turn
  -----------------------------------------------------------------------------
  TurnAction.times = nil
  
  -----------------------------------------------------------------------------
  -- twf.movement.direction to move in, either LEFT or RIGHT
  -----------------------------------------------------------------------------
  TurnAction.direction = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new twf.actionpath.action.TurnAction instance
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.TurnAction({
  --     direction = twf.movement.direction.LEFT,
  --     times = 2
  --   })
  --
  -- @param o superseding object
  -- @return  new instance of move action
  -- @error   if o.direction is not a valid direction to move in
  -----------------------------------------------------------------------------
  function TurnAction:new(o)
      error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the turtle has reached its destination. If its 
  -- destination has not been set, sets the destination and returns RUNNING.
  -- If it has been set, turns in the appropriate direction and returns RUNNING.
  -- Cannot fail - so be careful of obstructions!
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.TurnAction({
  --     direction = twf.movement.direction.LEFT,
  --     times = 2
  --   })
  --   local res = act:perform(st, {}) -- RUNNING (set destination)
  --   res = act:perform(st, {}) -- RUNNING (move left)
  --   res = act:perform(st, {}) -- RUNNING (move left)
  --   res = act:perform(st, {}) -- SUCCESS (destination reached)
  --
  -- @param stateTurtle the state turtle to act on 
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function TurnAction:perform(stateTurtle, pathState)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function TurnAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.TurnAction
  --   print(twf.actionpath.action.TurnAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function TurnAction.name()
    return 'twf.actionpath.action.TurnAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.TurnAction:new({direction = twf.movement.direction.FORWARD, times = 2})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.TurnAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function TurnAction:serialize(actionPath)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.TurnAction:new({direction = twf.movement.direction.LEFT, times = 2})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.TurnAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function TurnAction.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.TurnAction = TurnAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.FuelCheckAction
--
-- Checks if the fuel is above a certain level. If it is, returns SUCCESS 
-- otherwise returns FAILURE
-----------------------------------------------------------------------------
if not twf.actionpath.action.FuelCheckAction then
  local FuelCheckAction = {}
  
  -----------------------------------------------------------------------------
  -- The minimum fuel level to return SUCCESS (inclusive)
  -----------------------------------------------------------------------------
  FuelCheckAction.fuelLevel = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this FuelCheckAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.FuelCheckAction:new({fuelLevel = 5})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.fuelLevel is nil or negative
  -----------------------------------------------------------------------------
  function FuelCheckAction:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the turtle has at least the specified amount of fuel, 
  -- otherwise returns failuer
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.FuelCheckAction:new({fuelLevel = 5})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function FuelCheckAction:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function FuelCheckAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.FuelCheckAction
  --   print(twf.actionpath.action.FuelCheckAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function FuelCheckAction.name()
    return 'twf.actionpath.action.FuelCheckAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.FuelCheckAction:new({fuelLevel = 5})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.FuelCheckAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function FuelCheckAction:serialize(actionPath)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.FuelCheckAction:new({fuelLevel = 5})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.FuelCheckAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function FuelCheckAction.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.FuelCheckAction = FuelCheckAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.InventoryCheckAction
--
-- Checks if there is some amount of some item (or any amount or any item) in
-- a specific slot or range of slots
-----------------------------------------------------------------------------
if not twf.actionpath.action.InventoryCheckAction then
  local InventoryCheckAction = {}
  
  -----------------------------------------------------------------------------
  -- The item detail to search for. 'any' indicates any item
  -- 
  -- Serialized examples:
  --   { name = 'any', count = 1 }
  --   { name = 'minecraft:log', damage = 2, count = 1 }
  -----------------------------------------------------------------------------
  InventoryCheckAction.item = nil
  
  -----------------------------------------------------------------------------
  -- The slots to search in, as a table. 'any' indicates any slot.
  --
  -- Serialized examples:
  --   'any'
  --   { 1, 2, 3, 4 }
  --   { 16 }
  -----------------------------------------------------------------------------
  InventoryCheckAction.slots = nil
  
  -----------------------------------------------------------------------------
  -- True for strict, false for lenient item checking. Ignored for 'any' item
  -----------------------------------------------------------------------------
  InventoryCheckAction.strict = false
  
  -----------------------------------------------------------------------------
  -- A string constant:
  --   'none'    - Does not check count at all
  --   'minimum' - Success if there's at least the items count number of items. 
  --   'exact'   - Success if the count matches exactly the item count.
  --   'maximum' - Success if theres at most the items count number of items
  -----------------------------------------------------------------------------
  InventoryCheckAction.countCheck = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this InventoryCheckAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventoryCheckAction:new(
  --     {
  --       item = { name = 'any', count = 64 },
  --       slots = { 16 },
  --       countCheck = 'exact' 
  --     })
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.item is nil or o.item.name is nil or o.item.count is nil or 
  --          o.item.name is not 'any' and o.item.damage is nil
  -- @error   if o.slots is nil or o.slots is not 'any' or a table with at 
  --          least one number
  -- @error   if o.countCheck is not either 'none', 'minimum', 'exact', or
  --          'maximum'
  -----------------------------------------------------------------------------
  function InventoryCheckAction:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the turtle has the specified items in the specified 
  -- slots
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.InventoryCheckAction:new(
  --     {
  --       item = { name = 'any', count = 64 },
  --       slots = { 16 },
  --       countCheck = 'exact' 
  --     })
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function InventoryCheckAction:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function InventoryCheckAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.InventoryCheckAction
  --   print(twf.actionpath.action.InventoryCheckAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function InventoryCheckAction.name()
    return 'twf.actionpath.action.InventoryCheckAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventoryCheckAction:new({items = 'any', slots = 'any'})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventoryCheckAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function InventoryCheckAction:serialize(actionPath)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventoryCheckAction:new({items = 'any', slots = 'any'})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventoryCheckAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function InventoryCheckAction.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.InventoryCheckAction = InventoryCheckAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.InventorySelectAction
--
-- Selects a slot in the turtles inventory
-----------------------------------------------------------------------------
if not twf.actionpath.action.InventorySelectAction then
  local InventorySelectAction = {}
  
  -----------------------------------------------------------------------------
  -- The index of the slot to select
  -----------------------------------------------------------------------------
  InventorySelectAction.slotIndex = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this InventorySelectAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventorySelectAction:new({slotIndex = 1})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.slotIndex is nil or not on [1, 16]
  -----------------------------------------------------------------------------
  function InventorySelectAction:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Selects the specified slot
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.InventorySelectAction:new({slotIndex = 1})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function InventorySelectAction:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function InventorySelectAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.InventorySelectAction
  --   print(twf.actionpath.action.InventorySelectAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function InventorySelectAction.name()
    return 'twf.actionpath.action.InventorySelectAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventorySelectAction:new({slotIndex = 1})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventorySelectAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function InventorySelectAction:serialize(actionPath)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventorySelectAction:new({slotIndex = 1})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventorySelectAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function InventorySelectAction.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.InventorySelectAction = InventorySelectAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DropAction
-- 
-- Like twf.inventory.action.DropAction, except allows specifying either one
-- or more item slots, or one or more ItemDetails
-----------------------------------------------------------------------------
if not twf.actionpath.action.DropAction then
  local DropAction = {}
  
  -----------------------------------------------------------------------------
  -- Describes what method is being used to decide what to drop, one of the 
  -- following:
  --   'slot'     - Dropping by slot indexes
  --   'item'     - Dropping specific items and specific maximum amounts
  --   'itemType' - Dropping a specific type of items
  --   'all'      - Dropping everything the turtle has
  -----------------------------------------------------------------------------
  DropAction.dropBy = nil
  
  -----------------------------------------------------------------------------
  -- The direction to drop items in
  -----------------------------------------------------------------------------
  DropAction.direction = nil
  
  -----------------------------------------------------------------------------
  -- What slots to drop, if the dropBy is 'slot'.
  -- Examples:
  --   {1, 2, 3}
  --   {16}
  -----------------------------------------------------------------------------
  DropAction.slots = nil
  
  -----------------------------------------------------------------------------
  -- What items (or types of items) to drop, if the dropBy is item or itemType
  -- Examples:
  --   { {name = 'minecraft:log', damage = 1, count = 32} }
  -----------------------------------------------------------------------------
  DropAction.items = nil
  
  -----------------------------------------------------------------------------
  -- If item types should be compared strictly or not. Ignored if the dropBy 
  -- is not 'item' or 'itemType'
  -----------------------------------------------------------------------------
  DropAction.itemStrict = false
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DropAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropAction:new(
  --     {dropBy = 'all', direction = twf.movement.direction.FORWARD})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.dropBy is nil or not 'slot', 'item', 'itemType' or 'all'
  -- @error   if o.dropBy is 'slot' and o.slots is nil or empty
  -- @error   if o.dropBy is 'item' or 'itemType' and o.items is nil or empty
  -- @error   if o.direction is not FORWARD, UP, or DOWN
  -----------------------------------------------------------------------------
  function DropAction:new(o)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Drops the appropriate items/slots. Returns failure if kess than the 
  -- expected items are dropped for the turtles starting inventory.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DropAction:new({slotIndex = 1})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function DropAction:perform(stateTurtle, pathState)
    error('Not yet implemented!')
  end
  
  -----------------------------------------------------------------------------
  -- Called when this action completes successfully - should update the state
  -- of the turtle.
  --
  -- Usage:
  --   dofile('twf_movement.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DropAction:new(
  --     {dropBy = 'any', direction = twf.movement.direction.FORWARD})
  --   local result, items = act:perform()
  --   if twf.inventory.DropResult.isSuccess(result) then
  --     act:updateState(st)
  --   end
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DropAction:updateState(stateTurtle, pathState)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DropAction
  --   print(twf.actionpath.action.DropAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DropAction.name()
    return 'twf.actionpath.action.DropAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropAction:new({slotIndex = 1})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DropAction:serialize(actionPath)
    error('Not yet implemented')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropAction:new({slotIndex = 1})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DropAction.unserialize(serialized)
    error('Not yet implemented')
  end
  
  twf.actionpath.action.DropAction = DropAction
end