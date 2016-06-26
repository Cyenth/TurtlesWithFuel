dofile('twf_waypoints.lua')

local st = twf.movement.StatefulTurtle.loadSavedState('turtle_state.dat')

if not st then 
  st = twf.movement.StatefulTurtle:new({
    saveFile = 'turtle_state.dat',
    actionRecoveryFile = 'turtle_state_action_recovery.dat'
  })
end

st:loadInventoryFromTurtle()
st.fuelLevel = turtle.getFuelLevel()

local actPath = twf.actionpath.ActionPath:new()
actPath:registerActions(twf.movement.action, twf.inventory.action, twf.actionpath.action, twf.waypoints.action)
st:executeActionPath(actPath, 'waypoints', 'waypoints', false)

if fs.exists('startup') then 
  fs.delete('startup')
end