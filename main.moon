
require "lovekit.all"
export reloader = require "lovekit.reloader"

{graphics: g} = love

local dispatch
fonts = {}

export show_boxes = true
p = (str, ...) -> g.print str\lower!, ...

require "player"
require "world"

class Game
  new: =>
    @viewport = Viewport scale: 2
    @player = Player 40, 40
    @world = World!

  draw: =>
    @viewport\apply!
    @world\draw viewport
    @player\draw!

    g.setColor 255,255,255
    p "Hello World", 10, 10

    @viewport\pop!

  update: (dt) =>
    reloader\update! if reloader
    @player\update dt, @world

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

