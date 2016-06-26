dofile('twf_waypoints.lua')
dofile('twf_ores.lua')

local direction = twf.movement.direction

local Move = twf.movement.action.MoveAction
local Turn = twf.movement.action.TurnAction

local Dig = twf.inventory.action.DigAction

local Selector = twf.actionpath.action.SelectorAction
local Sequence = twf.actionpath.action.SequenceAction
local Repeater = twf.actionpath.action.RepeaterAction
local DieOnFailure = twf.actionpath.action.DieOnFailureAction
local RepeatUntilFailure = twf.actionpath.action.RepeatUntilFailureAction
local Die = twf.actionpath.action.DieAction
local Counter = twf.actionpath.action.CounterAction
local Succeeder = twf.actionpath.action.SucceederAction
local FuelCheck = twf.actionpath.action.FuelCheckAction
local InventoryCheck = twf.actionpath.action.InventoryCheckAction
local MoveResultInterpreter = twf.actionpath.action.MoveResultInterpreterAction
local DigResultInterpreter = twf.actionpath.action.DigResultInterpreterAction
local Inverter = twf.actionpath.action.InverterAction
local Drop = twf.actionpath.action.DropAction
local Message = twf.actionpath.action.MessageAction

local DigVein = twf.ores.action.DigVeinAction

local GotoWaypoint = twf.waypoints.action.GotoWaypointAction
local SaveWaypoint = twf.waypoints.action.SaveWaypointAction

-- Sequence that digs vertically
local function verticalMine()
  return Sequence:new({children = {
    Succeeder:new({child = 
      RepeatUntilFailure:new({child = 
        Sequence:new({children = {
          DieOnFailure:new({child = 
            Sequence:new({children = {
              DigVein:new({direction = direction.FORWARD}), -- originally forward
              MoveResultInterpreter:new({child = Turn:new({direction = direction.LEFT})}),
              DigVein:new({direction = direction.FORWARD}), -- originally left 
              MoveResultInterpreter:new({child = Turn:new({direction = direction.LEFT})}),
              DigVein:new({direction = direction.FORWARD}), -- originally back
              MoveResultInterpreter:new({child = Turn:new({direction = direction.LEFT})}),
              DigVein:new({direction = direction.FORWARD}), -- originally right
              MoveResultInterpreter:new({child = Turn:new({direction = direction.LEFT})})
            }})
          }),
          Succeeder:new({child = 
            Dig:new({direction = direction.DOWN})
          }),
          MoveResultInterpreter:new({child = 
            Move:new({direction = direction.DOWN})
          }),
          Counter:new({ id = 'depth', actionType = 'add', number = 1})
        }})
      }),
    }),
    Succeeder:new({child = 
      RepeatUntilFailure:new({child = 
        Sequence:new({children = {
          MoveResultInterpreter:new({child = 
            Move:new({direction = direction.UP})
          }),
          Counter:new({id = 'depth', actionType = 'add', number = -1}),
          Counter:new({id = 'depth', actionType = 'greaterThan', number = 0})
        }})
      })
    })
  }})
end

local function dumpInventoryAndGoBack()
  return Sequence:new({children = {
    SaveWaypoint:new({waypointName = 'old_pos', waypointId = -1}),
    GotoWaypoint:new({
      waypointName = 'chest',
      pathfindingHint = 'longestFirst',
      onObstruction = 'dig'
    }),
    Drop:new({dropBy = 'all', direction = twf.movement.direction.FORWARD}),
    GotoWaypoint:new({
      waypointName = 'old_pos',
      pathfindingHint = 'shortestFirst',
      onObstruction = 'dig'
    })
  }})
end

local function digAndMoveForward()
  return Sequence:new({children = {
    Succeeder:new({child = 
      RepeatUntilFailure:new({child = 
        DigResultInterpreter:new({child = Dig:new({direction = twf.movement.direction.FORWARD}), noBlockIsSuccess = false}) -- makes gravel less problematic
      })
    }),
    MoveResultInterpreter:new({child = Move:new({direction = twf.movement.direction.FORWARD})})
  }})
end

local function digColumn()
  return Sequence:new({children = {
    verticalMine(),
    dumpInventoryAndGoBack(),
    Repeater:new({times = 3, child = 
      Sequence:new({children = {
        Repeater:new({times = 4, child =
          digAndMoveForward()
        }),
        verticalMine(),
        dumpInventoryAndGoBack()
      }})
    })
  }})
end

local actPath = twf.actionpath.ActionPath:new()
actPath.pathState.waypointRegistry = twf.waypoints.WaypointRegistry:new({
  waypoints = {
    twf.waypoints.Waypoint:new({
      id = 1,
      name = 'chest',
      position = twf.movement.Position:new({x=0, y=0, z=0}),
      orientation = direction.SOUTH
    })
  }
})

actPath.head = Sequence:new({children = {
  Succeeder:new({child =
    Sequence:new({children = {
      Inverter:new({child = FuelCheck:new({fuelLevel = 12000})}),
      Die:new({message = "Not enough fuel!"})
    }})
  }),
  dumpInventoryAndGoBack(),
  Repeater:new({times = 2, child =
    Sequence:new({children = {
      digColumn(),
      MoveResultInterpreter:new({child = Turn:new({direction = direction.RIGHT})}),
      Repeater:new({times = 4, child = 
        digAndMoveForward()
      }),
      MoveResultInterpreter:new({child = Turn:new({direction = direction.RIGHT})}),
      digColumn(),
      MoveResultInterpreter:new({child = Turn:new({direction = direction.LEFT})}),
      Repeater:new({times = 4, child = 
        digAndMoveForward()
      }),
      MoveResultInterpreter:new({child = Turn:new({direction = direction.LEFT})})
    }})
  }),
  Message:new({message = 'Quarry complete! '})
}})

actPath:saveToFile('quarry.actionpath')