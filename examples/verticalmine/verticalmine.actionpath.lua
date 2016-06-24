dofile('twf_ores.lua') -- requires ore extensions

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
local Inverter = twf.actionpath.action.InverterAction
local Message = twf.actionpath.action.MessageAction

local DigVein = twf.ores.action.DigVeinAction

twf.actionpath.ActionPath:new({
  head = Sequence:new({children = {
    Succeeder:new({child = 
      Sequence:new({children = {
        Inverter:new({child = FuelCheck:new({fuelLevel = 500})}),
        Die:new({message = 'Not enough fuel!'})
      }})
    }),
    Succeeder:new({child = 
      Sequence:new({children = {
        InventoryCheck:new({ 
          item = { name = 'any', count = 1 },
          slots = 'any',
          countCheck = 'minimum'
        }),
        Die:new({message = 'Inventory not empty!'})
      }})
    }),
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
    }),
    Message:new({message = 'Done!'})
  }})
}):saveToFile('verticalmine.actionpath')