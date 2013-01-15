
{graphics: g} = love

export *

class World
  gravity: Vec2d 0,10
  new: (@player) =>
    @map = load_map "levels/first.png"
    @entities = DrawList!
    @particles = DrawList!
    @setup!

  setup: =>
    @entities\add Enemy 180, 50

  draw: (viewport) =>
    @map\draw viewport
    g.setColor 255,255,255

    @player\draw!
    g.setColor 255,255,255

    @entities\draw!
    g.setColor 255,255,255

    @particles\draw!

  update: (dt) =>
    @entities\update dt, @
    @particles\update dt, @
    @player\update dt, @

  collides: (thing) =>
    @map\collides thing

load_map = (fname) ->
  TileMap.from_image fname, {
    cell_w: 16
    cell_h: 16
  }, {
    "0,0,0": (x,y) ->
      with Box x,y, 16,16
        .layer = 0
        .draw = =>
          Box.draw @, {100,100,100}
  }

