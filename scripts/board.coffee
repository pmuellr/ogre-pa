# Licensed under the Apache License. See footer for details.

IMAGE_URL    = "vendor/vassal/images"
BOARD_IMAGE  = "#{IMAGE_URL}/ogre-map.png"

BOARD_WIDTH  =  900
BOARD_HEIGHT = 1542
HEX_COLS     =   15
HEX_ROWS     =   22
HEX_WIDTH    =   70
HEX_HEIGHT   =   60
HEX_OFFSET_X =   36
HEX_OFFSET_Y =  101

CRATERS = [
    "0304"
]

RUBBLE = [
    ["0103", "0203"]
    ["0104", "0203"]
]

PIECE_IMAGES = 
    cp_alpha    : "cp-alpha"
    gev         : "gev"
    hvy_tank    : "hvy-tank"
    hwz         : "hwz"
    infantry_1  : "infantry-1"
    infantry_2  : "infantry-2"
    infantry_3  : "infantry-3"
    msl_tank    : "msl-tank"
    ogre_mk3    : "ogre-mk3"
    ogre_mk5    : "ogre-mk5"


#-------------------------------------------------------------------------------

path = require "path"

utils = require "./utils"

board = exports

#-------------------------------------------------------------------------------
main = ->
    board.image = BOARD_IMAGE

    buildHexes()
    buildEdges()
    buildPieceImages()

    return

#-------------------------------------------------------------------------------
buildHexes = ->
    board.hexes = {}

    yOffsetOdd  = HEX_OFFSET_Y
    yOffsetEven = HEX_OFFSET_Y - HEX_HEIGHT/2
    
    xIncrement  = HEX_WIDTH * 3/4  
    yIncrement  = HEX_HEIGHT
    
    for col in [1...HEX_COLS]
        for row in [1...HEX_ROWS]
            odd = !!(col % 2)
            continue if odd and (row == 1)
    
            xOffset = HEX_OFFSET_X
            yOffset = HEX_OFFSET_Y if odd
            yOffset = HEX_OFFSET_Y - HEX_HEIGHT/2 if !odd

            x     = xOffset + xIncrement * (row - 1)
            y     = yOffset + yIncrement * (col - 1)
            name  = getHexName(col, row)
    
            board.hexes[name] = {name, row, col, x, y}

    return

#-------------------------------------------------------------------------------
buildPieceImages = ->
    board.pieceImages =
        b: {}
        w: {}
    
    for name, file of PIECE_IMAGES
        file = "#{IMAGE_URL}/#{file}"
        board.pieceImages.b[name] = "#{file}-b.png"
        board.pieceImages.w[name] = "#{file}-w.png"

    return

#-------------------------------------------------------------------------------
directions =
    0: [ 0, -1]
    1: [ 1,  0]
    2: [ 1,  1]
    3: [ 0,  1]
    4: [-1,  0]
    5: [-1, -1]

#-------------------------------------------------------------------------------
buildEdges = ->

    for name, hex of board.hexes
        hex.edges = {}

        odd = !!(hex.col % 2)

        for dirName, dirOffset of directions
            cCol  = hex.col + dirOffset[0]
            cRow  = hex.row + dirOffset[1]
            cName = getHexName(cCol, cRow)

            continue unless board.hexes[cName]

            hex.edges[cName] = {hex}

    for crater in CRATERS
        hex = board.hexes[crater]

        for cName, edge in hex.edges
            cHex = board.hexes[cName]
            cHex.edges[hex.name].isCrater = true

    for rubble in RUBBLE
        hex1 = board.hexes[rubble[0]]
        hex2 = board.hexes[rubble[1]]

        hex1.edges[hex2.name].isRubble = true
        hex2.edges[hex1.name].isRubble = true

    return

#-------------------------------------------------------------------------------
getHexName = (col, row) ->
    return utils.padLeft(col, 2, "0") + utils.padLeft(row, 2, "0")


#-------------------------------------------------------------------------------
main()

#-------------------------------------------------------------------------------
# Copyright 2013 Patrick Mueller
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------
