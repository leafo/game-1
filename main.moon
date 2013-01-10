
require "lovekit.all"

{graphics: g} = love

local dispatch
fonts = {}
sprites = {}

p = (str, ...) -> g.print str\lower!, ...

class Player
  speed: 80
  w: 10
  h: 20

  new: (x,y) =>
    @box = Box x,y, @w,@h

  draw: =>
    @box\draw {195,128,255}

  update: (dt, world) =>
    dir = movement_vector!
    @box\move unpack dir * @speed * dt

class Game
  new: =>
    @viewport = Viewport scale: 2
    @player = Player 10, 10

  draw: =>
    @viewport\apply!
    @player\draw!

    g.setColor 255,255,255
    p "Hello World", 10, 10
    @viewport\pop!

  update: (dt) =>
    @player\update dt

load_font = (img, chars)->
  font_image = imgfy img
  g.newImageFont font_image.tex, chars

love.load = ->
  g.setBackgroundColor 30,30,30

  fonts.main = load_font "img/font.png",
    [[ abcdefghijklmnopqrstuvwxyz-1234567890!.,:;'"?$&]]

  g.setFont fonts.main

  dispatch = Dispatcher Game!
  dispatch\bind love

