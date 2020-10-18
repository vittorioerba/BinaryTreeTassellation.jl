"""
Enum that defines two possible orientations: ```H``` horizontal, ```V``` vertical.
"""
@enum Orientation H V

"""
Abstract type representing a single rectangular tile
"""
abstract type Tile end

"""
Type representing a rectangular tile with two subtiles.
If orientation is set to ```H```, ```subtiles[1]``` is at the left of ```subtiles[2]```, otherwise ```subtiles[1]``` is below ```subtiles[2]```.

Fields:
    - ```subtiles::NTuple{2,Tile}```: subtiles;
    - ```orientation::Oriantation```: orientation of subtiles.
"""
mutable struct TileLeaf <: Tile
    subtiles::NTuple{2,Tile}
    orientation::Orientation

    """
    Inner constructor for the TileLeaf type. Its subtiles must be compatible, i.e. must share their heaight if they are horizonatally oriented, and similarly if vercitally oriented.
    """
    function TileLeaf(subtiles,orientation)
        if orientation == H
            clause = height(subtiles[1]) == height(subtiles[2])
            errorMsg = "Heights of subtiles not compatible!"
        else
            clause = base(subtiles[1]) == base(subtiles[2])
            errorMsg = "Bases of subtiles not compatible!"
        end

        clause ? new(subtiles,orientation) : error(errorMsg)
    end
end

"""
Type representing a rectangular tile with no subtiles.

Fields:
    - ```b::Float64```: base of tile;
    - ```h::Float64```: height of tile;
"""
mutable struct TileNode <: Tile
    b::Float64 # base
    h::Float64 # height
end

"""
Retrieve recursively the total vertical span of ```tile```.
The vertical span is the height of the subtiles if they are stacked horizontally, and it is the sum of the heights of the subtiles it they are stacked vertically.
"""
height(tile::TileLeaf) = tile.orientation == H ? height(tile.subtiles[1]) : height(tile.subtiles[1])+height(tile.subtiles[2])
height(tile::TileNode) = tile.h

"""
Retrieve recursively the total horiznotal span of ```tile```.
See ```height``` for more informations.
"""
base(tile::TileLeaf) = tile.orientation == V ? base(tile.subtiles[1]) : base(tile.subtiles[1])+base(tile.subtiles[2])
base(tile::TileNode) = tile.b

"""
Retrieve both the horizontal and vertical spans of ```tile```.
"""
size(tile::Tile) = (base(tile),height(tile))

"""
Recursively rescale the spans of a ```tile``` by some factor.

```factor``` can be either:
    - a ```Real```, and both the base and height of ```tile``` will be rescaled by ```factor```
    - a ```(Real,Real)```, and the base and height of ```tile``` will be rescaled respectively by ```factor[1]``` and ```factor[2]```.

"""
function rescale!(factor::T, tile::TileNode) where T<:Real
    tile.b = tile.b * factor
    tile.h = tile.h * factor
    return tile
end
function rescale!(factor::T, tile::TileLeaf) where T<:Real
    rescale!(factor, tile.subtiles[1])
    rescale!(factor, tile.subtiles[2])
    return tile
end
function rescale!(factor::Tuple{T1,T2}, tile::TileNode) where {T1<:Real, T2<:Real}
    tile.b = tile.b * factor[1]
    tile.h = tile.h * factor[2]
    return tile
end
function rescale!(factor::Tuple{T1,T2}, tile::TileLeaf) where {T1<:Real, T2<:Real}
    rescale!(factor, tile.subtiles[1])
    rescale!(factor, tile.subtiles[2])
    return tile
end

"""
Analogous to ```rescale!```, but performs a ```deepcopy``` of ```tile``` before rescaling, so that the original ```tile``` is not modified.
"""
function rescale(factor::T, tile::Tile) where T<:Real
    return rescale!(factor, deepcopy(tile))
end
function rescale(factor::Tuple{T1,T2}, tile::Tile) where {T1<:Real, T2<:Real}
    return rescale!(factor, deepcopy(tile))
end
