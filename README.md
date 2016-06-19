# TurtlesWithFuel

Contains the core TWF library, as well as several programs built with it.

## Usage

The library really shines with the use of action paths, however each file in the library indicates some modularity. For example, it's possible to only use the movement api, without the inventory or actonpath extensions. The reverse is not possible, since the inventory and actionpath modules incorporate the movement api. In order to use those libraries directly, it is recommended that you refer to the code.

### Creating an ActionPath file

The actionpath file is a serialization of an actionpath - which can be created manually with great tedium. However, it's easier to generate the actionpath file in lua. These types of files should have the extension '.actionpath.lua'

Here is an example of such a program for a cobblestone generator:

    dofile('twf_actionpath.lua') -- Import TWF actionpaths
    
    twf.actionpath.action.ActionPath:new({
      head = twf.actionpath.action.SelectorAction:new({
        children = {
          twf.actionpath.action.SequenceAction:new({
            children = {
              twf.actionpath.action.InventoryCheckAction:new({
                item = { name = 'any', count = 64 },
                slots = { 16 },
                countCheck = 'exact'
              }),
              twf.actionpath.action.DieOnFailure:new({
                child = twf.actionpath.action.Repeater:new({
                  child = twf.movement.action.TurnAction:new({direction = twf.movement.direction.RIGHT}),
                  times = 2
                })
              }),
              twf.actionpath.action.RetryOnFailure:new({
                child = twf.actionpath.action.DropAction:new({
                  dropBy = 'all', direction = twf.movement.direction.FORWARD
                })
              })
              twf.actionpath.action.DieOnFailure:new({
                child = twf.actionpath.action.Repeater:new({
                  child = twf.movement.action.TurnAction:new({direction = twf.movement.direction.RIGHT}),
                  times = 2
                })
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
    }):SaveToFile('cobble_generator.actionpath')