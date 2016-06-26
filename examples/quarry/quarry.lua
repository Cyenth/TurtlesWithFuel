dofile('twf_waypoints.lua')
dofile('twf_ores.lua')

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
actPath:registerActions(twf.movement.action, twf.inventory.action, twf.actionpath.action, twf.ores.action, twf.ores._digveinaction, twf.waypoints.action)
st:executeActionPath(actPath, 'quarry', 'quarry', false)

if fs.exists('startup') then 
  fs.delete('startup')
end