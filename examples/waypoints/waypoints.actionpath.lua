dofile('twf_waypoints.lua') -- requires ore extensions

local waypointReg = twf.waypoints.WaypointRegsitry:new({waypoints = {
  twf.waypoints.Waypoint:new({
    name = 'point1', 
    id = 1, 
    position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  }),
  twf.waypoints.Waypoint:new({
    name = 'point2', 
    id = 2, 
    position = twf.movement.Position:new({x = 0, y = 2, z = 0})
  }),
  twf.waypoints.Waypoint:new({
    name = 'point3', 
    id = 3, 
    position = twf.movement.Position:new({x = 0, y = 0, z = 3})
  }),
  twf.waypoints.Waypoint:new({
    name = 'point4', 
    id = 4, 
    position = twf.movement.Position:new({x = 3, y = 2, z = 0})
  })
}})

local actPath = twf.actionpath.ActionPath:new()
actPath.pathState.waypointRegistry = waypointReg

actPath.head = twf.actionpath.Sequence:new({children = {
  twf.waypoints.action.GotoWaypointAction:new({
    name = 'point1',
    pathfindingHint = 'longestFirst',
    onObstruction = 'retry'
  }),
  twf.waypoints.action.GotoWaypointAction:new({
    name = 'point2',
    pathfindingHint = 'longestFirst',
    onObstruction = 'retry'
  }),
  twf.waypoints.action.GotoWaypointAction:new({
    name = 'point3',
    pathfindingHint = 'longestFirst',
    onObstruction = 'retry'
  }),
  twf.waypoints.action.GotoWaypointAction:new({
    name = 'point4',
    pathfindingHint = 'longestFirst',
    onObstruction = 'retry'
  })
}})

actPath:saveToFile('waypoints.actionpath')