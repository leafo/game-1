
{graphics: g} = love

export *

class Bullet extends Box
  reloader.watch_class self if reloader
  lazy_value @, "sprite", => Spriter "art/bullet.png", 16

  alive: true
  speed: 180
  w: 5, h: 4

  frames: {
    "3,6,9,4"
    "19,6,9,4"
  }

  player_offset: {
    left: {7,9}
    right: {-7,9}
  }

  offset: {
    left: {1,0}
    right: {3,0}
  }

  new: (@x, @y, @vel) =>
    @box = @
    @anim = @sprite\seq @frames, 0.2, @vel[1] < 0

  update: (dt, world) =>
    @anim\update dt
    @move unpack @vel * dt
    not world\collides @

  draw: =>
    ox, oy = unpack @offset[@vel[1] < 0 and "left" or "right"]
    @anim\draw @x - ox, @y - oy
    if show_boxes
      super {10,10,255, 100}
      g.setColor 255,255,255

