# TurtlesWithFuel

Contains the core TWF library, as well as several programs built with it. This readme aims to provide a quick entry to this library - for longer overview [read the wiki](https://github.com/Cyenth/TurtlesWithFuel/wiki).

## Credits

I've been meaning to create movement persistance for a long time, but using fuel to achieve that was thought up by [Lama](https://github.com/fnuecke/lama/blob/master/apis/lama) - which is a great alternative!

## What and why?

ComputerCraft is a popular, and my personal favorite, mod for Minecraft. It creates a new type of block, called a 'turtle'. These 'turtles' will run a lua interpreter, and come with various default libraries for movement, digging, placing, etc.. However, it will only run lua files from the top. This normally isn't an issue, since typically programs start at the top and continue downward. However, since Minecraft is a sandbox with a theoretically infinite world, it does not keep the whole world loaded. In fact, it aggressively unloads any area not sufficiently close to a player. 

When the turtle is unloaded, it acts as if power was just cut-off. If the turtle was running a program that say, moved 50 blocks forward, it might be cut off at 22 blocks. The turtle also does not, by default, have any way to fetch its location (except by the gps api, which has its own issues). Thus, the program would have to go to a lot of work in order to make sure that even when rebooted, it would go exactly 50 blocks.

This API provides action paths, which when used correctly, "hide" this issue of persistance, such that the programmer can normally assume that the program will always run to completion.

## Gotchas

This whole library depends on a modification to the base mod that makes turning use fuel. The reason for this can be seen via [this](https://github.com/dan200/ComputerCraft/issues/110) issue. While I cannot distribute the modified version, I can tell you it's *extremely* straight-forward if you use a java decompiler. The one I used is available at http://jd.benow.ca/

## Usage

The library really shines with the use of action paths, however each file in the library indicates some modularity. For example, it's possible to only use the movement api, without the inventory or actonpath extensions. The reverse is not possible, since the inventory and actionpath modules incorporate the movement api. In order to use those libraries directly, it is recommended that you refer to the code.

### What is an action path?

An action path is just a slightly different name for behavior trees. Knowledge about behavior trees is assumed, since other guides such as [this one by Chris Simpson](http://www.gamasutra.com/blogs/ChrisSimpson/20140717/221339/Behavior_trees_for_AI_How_they_work.php) explains what they are, why they are used, and their pros/cons in much greater depth than this readme could hope to.

The reason that a behavior tree was chosen for this project is since it forces the programmer to break each step into its component parts. If the actionpath is serialized immediately after every tick, and recovered when it needs to be run again, the most the behavior tree could repeat is the last tick. For movement related actions (and possibly crafting actions) this requires additional recovery, but otherwise it's fine to repeat that one action. Movement actions handle the additional recovery required to avoid repeating movements in the implementation provided, so in most use cases the potential for being called twice can be ignored!


### Creating an ActionPath file

The actionpath file is a serialization of an action path - which can be created manually with great tedium. However, it's easier to generate the actionpath file in lua. These types of files should have the extension '.actionpath.lua'. This pattern also allows for forward-compatibility with changes to serialization, which can happen whenever an action gains or loses a new variable. There are examples of these files for actual use-cases in the examples/ folder. 

Generally, these files will create an action path, set the head action to the desired action, and save it. Thus, they look like:

    -- dogreatthings.actionpath.lua
    dofile('twf_actionpath.lua')

    twf.actionpath.ActionPath:new({head =
      my.action.DoGreatThingsAction:new()
    }):saveToFile('dogreatthings.actionpath')

Up to the preference of the programmer, it is often helpful to "import" specific actions to improve readability. This would turn the above action path generator into:

    -- dogreatthings.actionpath.lua
    dofile('twf_actionpath.lua')
    
    local DoGreatThings = my.action.DoGreatThingsAction

    twf.actionpath.ActionPath:new({head =
      DoGreatThings:new()
    }):saveToFile('dogreatthings.actionpath')

### Running an ActionPath file

Depending on the action path, there are *many* different ways this might want to be done. However, one typical example is a program that is first run manually, and then will automatically run itself if it gets rebooted. In this case, typically the 'manual' running class would get the name of file without an extension (as is typical in computercraft), and the 'real' running class would get just the .lua extension.

dogreatthings

    -- dogreatthings
    print('This will do great things. Are you sure you want to do great things? (Ctrl+T to terminate)')
    read()
    
    -- Generate actionpath file. Only necessary if you package the actionpath generator rather than just the actionpath. 
    dofile('dogreatthings.actionpath.lua')
    
    -- Create startup file 
    local file = fs.open('startup', 'w')
    file.write('dofile(\'dogreatthings.lua\')')
    file.close()
    
    -- Launch program
    dofile('dogreatthings.lua')

dogreatthings.lua

    -- dogreatthings.lua
    local st = twf.movement.StatefulTurtle.loadSavedState('turtle_state')

    if not st then 
      -- first run 
      st = twf.movement.StatefulTurtle:new({
        saveFile = 'turtle_state.dat',
        actionRecoveryFile = 'turtle_state_action_recovery.dat'
      })
    end
    
    local actPath = twf.actionpath.ActionPath:new()
    actPath:registerActions(
      twf.movement.action,
      twf.inventory.action,
      twf.actionpath.action
    )
    st:executeActionPath(actPath,         -- The actionpath to execute
                         'dogreatthings', -- Where to find the actionpath file, without the .actionpath extension
                         'dogreatthings', -- Where to find the actionpath recovery file, postfixed with _recovery.dat
                         false            -- If this action path should be continuously repeated
                        )
    
    -- Delete startup file to avoid repeating this action
    if file.exists('startup') then 
      file.delete('startup')
    end

Hopefully this doesn't seem like too much boilerplate if you're familiar what it normally looks like to be able to recover from being rebooted. The only new concept here (besides some functions) is the StatefulTurtle - it is the class that handles the state of the turtle, including the "microscopic" action recovery required for the move actions. Generally, if you are using action paths, then you don't need to worry about it more than shown here.