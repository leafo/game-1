
{graphics: g, :keyboard} = love

export *

class Player
  reloader.watch_class self if reloader

  jump_key: "x"
  shoot_key: "c"

  speed: 80
  jump: 3

  w: 6
  h: 14

  body_ox: 6
  body_oy: 0

  head_ox: {
    right: 8
    left: 5
  }

  head_oy: 19

  fit_move: Entity.fit_move

  new: (x,y) =>
    @box = Box x,y, @w,@h
    @sprite = Spriter "art/player.png", 16
    @dir = "right"
    @vel = Vec2d 0,0
    @gun = @shoot_seq!

    body_right = {
      "39,18,17,14"
      "71,18,17,14"
      "102,18,17,14"
      "7,18,17,14"
    }

    @body = StateAnim @dir, {
      right:  @sprite\seq body_right, 0.2
      left:   @sprite\seq body_right, 0.2, true
      stand_right: @sprite\seq { "7,18,17,14" }, 0
      stand_left: @sprite\seq { "7,18,17,14" }, 0, true
    }

    head_right = {
      "33,64,30,22"
      "65,64,30,22"
      "97,64,30,22"
      "1,64,30,22"
    }

    @head = StateAnim @dir, {
      right:  @sprite\seq head_right, 0.2
      left:   @sprite\seq head_right, 0.2, true

      stand_right:  @sprite\seq { "1,64,30,22" }, 0.2
      stand_left:   @sprite\seq { "1,64,30,22" }, 0.2, true
    }

  shoot_seq: =>
    Sequence ->
      wait_for_key @shoot_key
      @shooting = true
      wait 0.5
      again!

  set_state: (...) =>
    @body\set_state ...
    @head\set_state ...

  draw: =>
    {:body_ox, :body_oy} = @
    head_ox = @head_ox[@dir]

    @body\draw @box.x - body_ox, @box.y - body_oy
    @head\draw @box.x - (body_ox + head_ox), @box.y - (body_oy + @head_oy)

    @box\draw {255,64,64, 64} if show_boxes


  shoot: (world, bullet_cls=Bullet) =>
    dir = if @dir == "left"
      Vec2d -bullet_cls.speed, 0
    else
      Vec2d bullet_cls.speed, 0

    sx, sy = unpack bullet_cls.player_offset[@dir]
    world.entities\add bullet_cls @box.x - sx, @box.y - sy, dir

  update: (dt, world) =>
    dir = movement_vector!
    dir[2] = 0 -- hi
    is_moving = not dir\is_zero!

    -- transition to standing
    if (@is_moving and not is_moving) or @is_moving == nil
      @set_state "stand_#{@dir}"
      @is_moving = false

    if is_moving
      @dir = if dir.x < 0
        "left"
      else
        "right"
      @set_state @dir

    -- transition to moving
    if not @is_moving and is_moving
      print "transition to move"
      @is_moving = true

    -- jumping
    if @on_ground and keyboard.isDown @jump_key
      @vel[2] -= @jump

    @gun\update dt if @gun
    if @shooting
      @shoot world
      @shooting = false

    -- apply gravity
    @vel += world.gravity * dt

    dx, dy = unpack dir * @speed * dt
    cx, cy = @fit_move dx + @vel[1], dy + @vel[2], world

    @on_ground = cy and @vel[2] >= 0
    if cy
      @vel[2] = 0

    @body\update dt
    @head\update dt

