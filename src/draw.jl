"""
Draw a ```tile``` using ```Luxor.jl```.
If the ```tile``` has no subtiles, it colors it with a random color from ```palette```.

This function does not set up any ```Luxor.Drawing()``` environment by itself.
Regard it more as a ```Luxor.rect()``` function.

Optional arguments:
    - ```origin```: a ```Tuple``` of two numbers two specify the coordinates of the top-left corner of the tile. Defaults to ```(0,0)```;
    - ```palette```: a ```Vector{Vector{Int}}``` containing rgba values of the colors to use to paint the ```tile```. Defaults to ```palette_StampingItOut```.
"""
function draw(tile::TileNode; origin=(0,0), palette=palette_StampingItOut)
    col = rand(palette/255)
    setcolor(col...)
    rect(origin[1], origin[2], tile.b, tile.h, :fillstroke)
end
function draw(tile::TileLeaf; origin=(0,0), palette=palette_StampingItOut)
    b = base(tile)
    h = height(tile)
    draw(tile.subtiles[1]; origin=(origin[1],origin[2]), palette=palette)
    if tile.orientation == H
        draw(tile.subtiles[2]; origin=(origin[1]+base(tile.subtiles[1]), origin[2]), palette=palette)
    else
        draw(tile.subtiles[2]; origin=(origin[1], origin[2]+height(tile.subtiles[1])), palette=palette)
    end
end
