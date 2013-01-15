
{graphics: g} = love

export *

class Enemy
  reloader.watch_class self if reloader

  lazy_value @, "sprite", => Spriter "art/enemy.png"

  w: 15
  h: 21

  fit_move: Entity.fit_move

  stand_left: {
    ox: 8, oy: 4
    "4,7,28,25"
    "36,7,28,25"
  }

  stand_right: {
    ox: 11, oy: 4
  }

  new: (x,y) =>
    @box = Box x, y, @w, @h
    @dir = "right"
    @vel = Vec2d 0,0

    @anim = StateAnim @dir, {
      stand_left:   @sprite\seq @stand_left, 0.8
      stand_right:  @sprite\seq @stand_left, 0.8, true
    }
    @anim\set_state "stand_left"
  
  update: (dt, world) =>
    @anim\update dt

    -- apply gravity
    @vel += world.gravity * dt
    cx, cy = @fit_move @vel[1], @vel[2], world

    on_ground = cy and @vel[2] >= 0

    if on_ground != @on_ground
      @on_ground = on_ground

    if cy
      @vel[2] = 0

    true

  draw: =>
    {:ox, :oy} = @[@anim.current_name]
    @anim\draw @box.x - ox, @box.y - oy

    if show_boxes
      @box\draw {100,255,100, 100}
      g.setColor 255,255,255
