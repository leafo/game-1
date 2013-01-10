
{graphics: g} = love

export *

class Player
  reloader.watch_class self if reloader

  speed: 80
  w: 6
  h: 14

  body_ox: 5
  body_oy: 0

  head_ox: 13
  head_oy: 19

  new: (x,y) =>
    @box = Box x,y, @w,@h
    @sprite = Spriter "art/player.png", 16

    @body = StateAnim "right", {
      right: @sprite\seq {
        "7,18,17,14"
        "39,18,17,14"
        "71,18,17,14"
        "102,18,17,14"
      }, 0.2
    }

    @head = StateAnim "right", {
      right: @sprite\seq {
        "1,64,30,22"
        "33,64,30,22"
        "65,64,30,22"
        "97,64,30,22"
      }, 0.2
    }

  draw: =>
    @body\draw @box.x - @body_ox, @box.y - @body_oy
    @head\draw @box.x - @head_ox, @box.y - @head_oy

    -- @box\draw {255,64,64, 64} if show_boxes

  update: (dt, world) =>
    dir = movement_vector!
    @box\move unpack dir * @speed * dt
    @body\update dt
    @head\update dt

