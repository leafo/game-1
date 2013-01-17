
{graphics: g, :keyboard} = love

export *

class Player
  reloader.watch_class self if reloader

  jump_key: "x"
  shoot_key: "c"

  speed: 80
  jump: 3.4

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
      "102,18,17,14"
      "71,18,17,14"
      "39,18,17,14"
      "7,18,17,14"
    }

    @body = StateAnim @dir, {
      right:  @sprite\seq body_right, 0.2
      left:   @sprite\seq body_right, 0.2, true

      stand_right: @sprite\seq { body_right[4] }, 0
      stand_left: @sprite\seq { body_right[4] }, 0, true

      jump_right: @sprite\seq { body_right[3] }, 0
      jump_left: @sprite\seq { body_right[3] }, 0, true
    }

    head_right = {
      "33,64,30,22"
      "65,64,30,22"
      "97,64,30,22"
      "1,64,30,22"
    }

    charging_head_right = {
      "33,96,30,22"
      "65,96,30,22"
      "97,96,30,22"
       "1,96,30,22"
    }

    @head = StateAnim @dir, {
      right:  @sprite\seq head_right, 0.2
      left:   @sprite\seq head_right, 0.2, true

      stand_right:  @sprite\seq { head_right[4] }, 0.2
      stand_left:   @sprite\seq { head_right[4] }, 0.2, true

      charging_stand_right:  @sprite\seq { charging_head_right[4] }, 0.2
      charging_stand_left:   @sprite\seq { charging_head_right[4] }, 0.2, true

      charging_right:  @sprite\seq charging_head_right, 0.2
      charging_left:   @sprite\seq charging_head_right, 0.2, true
    }

  shoot_seq: =>
    Sequence ->
      @charging = false
      @update_state!
      wait_for_key @shoot_key
      @shooting = true
      wait 0.5
      again!

  update_state: =>
    state = @dir
    unless @is_moving
      state = "stand_" .. state

    body_state = if not @on_ground
      "jump_" .. @dir
    else
      state

    @body\set_state body_state

    state = "charging_" .. state if @charging
    @head\set_state state

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
      @is_moving = false
      @update_state!

    if is_moving
      @dir = if dir.x < 0
        "left"
      else
        "right"
      @update_state!

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
      @charging = true
      @update_state!
      @shooting = false

    -- apply gravity
    @vel += world.gravity * dt

    dx, dy = unpack dir * @speed * dt
    cx, cy = @fit_move dx + @vel[1], dy + @vel[2], world

    on_ground = cy and @vel[2] >= 0

    if on_ground != @on_ground
      @on_ground = on_ground
      @update_state!

    if cy
      @vel[2] = 0

    @body\update dt
    @head\update dt

  __tostring: => "Player<#{@box}>"

