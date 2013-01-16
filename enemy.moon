
{graphics: g} = love

-- ai that is controlled by player
manual_ai = =>
  mover = make_mover "w", "s", "a", "d"
  {
    update: (dt) ->
      dir = mover!
      if dir\is_zero!
        @moving = nil
      else
        @moving = dir * @speed
      @update_state!
  }


export *

class Enemy
  reloader.watch_class self if reloader

  lazy_value @, "sprite", => Spriter "art/enemy.png"

  w: 15
  h: 21

  speed: 30

  fit_move: Entity.fit_move

  states: {
    stand_left: {
      ox: 8, oy: 4
      "4,7,28,25"
      "36,7,28,25"
    }

    stand_right: {
      ox: 5, oy: 4
    }

    left: {
      ox: 14, oy: 3
      "64,8,30,24"
      "96,8,30,24"
    }

    right: {
      ox: 0, oy: 3
    }
  }


  new: (x,y) =>
    @box = Box x, y, @w, @h
    @vel = Vec2d 0,0
    @dir = "right"

    import states from @
    @anim = StateAnim @dir, {
      stand_left:   @sprite\seq states.stand_left, 0.8
      stand_right:  @sprite\seq states.stand_left, 0.8, true

      left: @sprite\seq states.left, 0.2
      right: @sprite\seq states.left, 0.2, true
    }

    @ai = @make_ai!

  make_ai: =>
    do return manual_ai @

    Sequence ->
      while not @on_ground
        coroutine.yield!

      wait 1.0
      @moving = pick_one Vec2d(@speed,0), Vec2d(-@speed,0)
      @update_state!
      wait 1.0
      @moving = nil
      @update_state!
      again!


  update: (dt, world) =>
    @anim\update dt
    @ai\update dt

    -- apply gravity
    @vel += world.gravity * dt
    dx, dy = unpack @vel

    if @moving
      dx += @moving[1] * dt
      dy += @moving[2] * dt

    cx, cy = @fit_move dx, dy, world

    on_ground = cy and @vel[2] >= 0

    if on_ground != @on_ground
      @on_ground = on_ground

    if cy
      @vel[2] = 0

    true

  update_state: =>
    if @moving
      dir = if @moving[1] < 0
        "left"
      else
        "right"
      @anim\set_state dir
      @dir = dir
    else
      @anim\set_state "stand_#{@dir}"

  draw: =>
    import states from @
    {:ox, :oy} = states[@anim.current_name]
    @anim\draw @box.x - ox, @box.y - oy

    if show_boxes
      @box\draw {100,255,100, 100}
      g.setColor 255,255,255
