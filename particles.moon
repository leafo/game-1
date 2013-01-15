
{graphics: g} = love

export *

class BulletHit extends Particle
  life: 0.15
  ox: 7
  oy: 6

  frames: {
    "1,34,13,11"
    "17,34,13,11"
  }

  lazy_value @, "sprite", ->
    Spriter "art/bullet.png", 16

  draw: =>
    frame = if @p! < 0.5
      @frames[1]
    else
      @frames[2]

    @sprite\draw frame, @x - @ox, @y - @oy

