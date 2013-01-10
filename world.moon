
export *

class World
  new: =>
    @map = load_map "levels/first.png"

  draw: (viewport) =>
    @map\draw viewport

  update: (dt) =>

  collides: (thing) => false


load_map = (fname) ->
  TileMap.from_image fname, {
    cell_w: 16
    cell_h: 16
  }, {
    "0,0,0": (x,y) ->
      with Box x,y, 16,16
        .draw = =>
          Box.draw @, {255,255,255}
  }

