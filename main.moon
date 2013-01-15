
require "lovekit.all"
export reloader = require "lovekit.reloader"

{graphics: g} = love

local dispatch
fonts = {}

export show_boxes = false
p = (str, ...) -> g.print str\lower!, ...

require "particles"
require "shoot"
require "player"
require "world"

class Game
  new: =>
    @viewport = Viewport scale: 2
    @player = Player 150, 40
    @world = World @player

  draw: =>
    @viewport\apply!
    @world\draw viewport

    g.setColor 255,255,255
    p "#{love.timer.getFPS()}", 1, 1
    p "#{@player.box.x}", 1, 10
    p "#{@player.box.y}", 1, 20
    p "#{@player.body.current_name}", 1, 30

    @viewport\pop!

  update: (dt) =>
    reloader\update! if reloader
    @world\update dt

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

