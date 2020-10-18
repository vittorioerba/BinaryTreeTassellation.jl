module BinaryTreeTassellation

using Luxor
using Random

export Tile, TileLeaf, TileNode
export base, height, rescale, rescale!, size
export paint_tree

include("Tile.jl")
include("palettes.jl")
include("draw.jl")
include("tree.jl")

end
