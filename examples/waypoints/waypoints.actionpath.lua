dofile('twf_waypoints.lua') -- requires ore extensions

local waypointReg = twf.waypoints.WaypointRegistry:new({waypoints = {
  twf.waypoints.Waypoint:new({
    name = 'point1', 
    id = 1, 
    position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  }),
  twf.waypoints.Waypoint:new({
    name = 'point2', 
    id = 2, 
    position = twf.movement.Position:new({x = 5, y = 1, z = 0})
  }),
  twf.waypoints.Waypoint:new({
    name = 'point3', 
    id = 3, 
    position = twf.movement.Position:new({x = 0, y = 0, z = 0})
  }),
  twf.waypoints.Waypoint:new({
    name = 'point4', 
    id = 4, 
    position = twf.movement.Position:new({x = 3, y = 2, z = -1})
  })
}})

local actPath = twf.actionpath.ActionPath:new()
actPath.pathState.waypointRegistry = waypointReg

actPath.head = twf.actionpath.action.SequenceAction:new({children = {
  twf.actionpath.action.SucceederAction:new({child = 
    twf.actionpath.action.SequenceAction:new({children = {
      twf.actionpath.action.InverterAction:new({child = 
        twf.actionpath.action.FuelCheckAction:new({fuelLevel = 50})
      }),
      twf.actionpath.action.DieAction:new({message = 'Not enough fuel!'})
    }})
  }),
  twf.waypoints.action.GotoWaypointAction:new({
    waypointName = 'point1', 
    pathfindingHint = 'longestFirst',
    onObstruction = 'retry'
  }),
 twf.waypoints.action.GotoWaypointAction:new({
    waypointName = 'point2',
    pathfindingHint = 'longestFirst',
    onObstruction = 'retry'
  }),
  twf.waypoints.action.GotoWaypointAction:new({
    waypointName = 'point3',
    pathfindingHint = 'longestFirst',
    onObstruction = 'retry'
  }),
  twf.waypoints.action.GotoWaypointAction:new({
    waypointName = 'point4',
    pathfindingHint = 'longestFirst',
    onObstruction = 'retry'
  }),
  twf.waypoints.action.GotoWaypointAction:new({
    waypointName = 'point1', 
    pathfindingHint = 'longestFirst',
    onObstruction = 'retry'
  }),
  twf.actionpath.action.FaceAction:new({direction = twf.movement.direction.NORTH})
}})

actPath:saveToFile('waypoints.actionpath')