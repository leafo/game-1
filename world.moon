
{graphics: g} = love

export *

class World
  gravity: Vec2d 0,10
  new: (@player) =>
    @entities = DrawList!
    @particles = DrawList!
    @collide = UniformGrid!

    @setup!

  setup: =>
    @map = TileMap.from_tiled "levels.first", {
      object: (o) ->
        switch o.name
          when "spawn"
            @player.box.x = o.x
            @player.box.y = o.y
          when "enemy"
            @entities\add Enemy o.x, o.y
    }

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

    @collide\clear!
    @collide\add @player.box, @player
    for e in *@entities
      continue unless e.alive
      if e.box
        @collide\add e.box, e
      else
        @collide\add e

    for e in *@entities
      if e.is_enemy
        for thing in *@collide\get_touching e.box
          e\take_hit thing, @

  collides: (thing) =>
    @map\collides thing
