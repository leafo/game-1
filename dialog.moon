
{graphics: g} = love

p = (str, ...) -> g.print str\lower!, ...

export *

class Dialog
  lazy_value @, "sprite", => Spriter "art/face.png"

  height: 64

  new: (@text) =>

  draw: (viewport) =>
    bottom = viewport.screen.h
    right = viewport.screen.w

    g.push!
    g.translate viewport.x, viewport.y + (bottom - @height)

    g.setColor 0,0,0, 180
    g.rectangle "fill", 0, 0, right, @height

    g.setColor 255,255,255

    @sprite\draw "0,260,80,64", 0, 0

    p "Not all mice go to heaven....", 80, 10

    g.pop!

