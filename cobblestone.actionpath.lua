dofile('twf_actionpath.lua') -- Import TWF actionpaths
twf.actionpath.ActionPath:new({
  head = twf.actionpath.action.SelectorAction:new({
    children = {
      twf.actionpath.action.SequenceAction:new({
        children = {
          twf.actionpath.action.InventoryCheckAction:new({
            item = { name = 'any', count = 64 },
            slots = { 16 },
            countCheck = 'exact'
          }),
          twf.actionpath.action.Repeater:new({
            child = twf.actionpath.action.DieOnFailure:new({
              child = twf.actionpath.action.MoveResultInterpreter:new({
                child = twf.movement.action.TurnAction:new({
                  direction = twf.movement.direction.RIGHT
                })
              })
            }),
            times = 2
          }),
          twf.actionpath.action.RetryOnFailure:new({
            child = twf.actionpath.action.DropAction:new({
              dropBy = 'all', direction = twf.movement.direction.FORWARD
            })
          }),
          twf.actionpath.action.Repeater:new({
            child = twf.actionpath.action.DieOnFailure:new({
              child = twf.actionpath.action.MoveResultInterpreter:new({
                child = twf.movement.action.TurnAction:new({
                  direction = twf.movement.direction.RIGHT
                })
              })
            }),
            times = 2
          })
        }
      }),
      twf.actionpath.action.Succeeder:new({
        child = twf.inventory.action.DigAction:new({
          direction = twf.movement.direction.FORWARD
        })
      })
    }
  })
}):saveToFile('cobblestone.actionpath')