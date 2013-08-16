# Licensed under the Apache License. See footer for details.

IMAGE_URL    = "vassal/images"
BOARD_IMAGE  = "#{IMAGE_URL}/ogre-map.png"

BOARD_WIDTH  =  900
BOARD_HEIGHT = 1542
HEX_COLS     =   15
HEX_ROWS     =   22
HEX_WIDTH    =   78
HEX_HEIGHT   =   67.5
HEX_OFFSET_X =   36
HEX_OFFSET_Y =   34
PIECE_WIDTH  =   50
PIECE_HEIGHT =   50

CRATERS = [ 
    "0108", "0209", "0304", "0313", "0506", "0608", "0611", 
    "0712", "0908", "0914", "1004", "1304", "1310", "1403", 
    "1406", "1413", "1508"
]

RUBBLE = [ 
    ["0103", "0203"], ["0104", "0203"], ["0207", "0308"], 
    ["0210", "0311"], ["0211", "0312"], ["0212", "0312"], 
    ["0212", "0313"], ["0213", "0313"], ["0305", "0405"], 
    ["0307", "0308"], ["0309", "0409"], ["0310", "0410"], 
    ["0311", "0312"], ["0312", "0411"], ["0316", "0317"], 
    ["0316", "0416"], ["0404", "0505"], ["0404", "0405"], 
    ["0408", "0509"], ["0503", "0602"], ["0514", "0614"], 
    ["0515", "0614"], ["0602", "0603"], ["0603", "0703"], 
    ["0607", "0707"], ["0607", "0708"], ["0613", "0614"], 
    ["0708", "0709"], ["0714", "0813"], ["0714", "0814"], 
    ["0716", "0816"], ["0801", "0902"], ["0808", "0909"], 
    ["0812", "0912"], ["0812", "0913"], ["0815", "0816"], 
    ["0816", "0916"], ["0904", "1003"], ["0904", "0905"], 
    ["0905", "1005"], ["0905", "0906"], ["0907", "1007"], 
    ["0911", "1010"], ["0916", "0917"], ["1008", "1108"], 
    ["1012", "1112"], ["1012", "1113"], ["1012", "1013"], 
    ["1015", "1116"], ["1107", "1207"], ["1108", "1207"], 
    ["1108", "1208"], ["1108", "1109"], ["1112", "1113"], 
    ["1112", "1212"], ["1204", "1205"], ["1205", "1305"], 
    ["1206", "1207"], ["1316", "1317"], ["1316", "1416"], 
    ["1408", "1409"], ["1415", "1416"]
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
    board.image  = BOARD_IMAGE
    board.width  = BOARD_WIDTH
    board.height = BOARD_HEIGHT

    board.pieceWidth  = PIECE_WIDTH
    board.pieceHeight = PIECE_HEIGHT

    board.hexes       = buildHexes()
    board.pieceImages = buildPieceImages()

    buildEdges board.hexes

    return

#-------------------------------------------------------------------------------
buildHexes = ->
    hexes = {}

    xOffset     = HEX_OFFSET_X
    yOffsetOdd  = HEX_OFFSET_Y
    yOffsetEven = HEX_OFFSET_Y + HEX_HEIGHT/2

    xIncrement  = HEX_WIDTH * 3/4  
    yIncrement  = HEX_HEIGHT
    
    for col in [1..HEX_COLS]
        oddCol = !!(col % 2)
        yOffset = if oddCol then yOffsetOdd else yOffsetEven

        for row in [1..HEX_ROWS]
            continue if oddCol and (row == 1)
    
            x    = xOffset + xIncrement * (col - 1)
            y    = yOffset + yIncrement * (row - 1)
            name = getHexName(col, row)
    
            hexes[name] = {name, row, col, x, y}

    return hexes

#-------------------------------------------------------------------------------
buildPieceImages = ->
    pieceImages =
        b: {}
        w: {}
    
    for name, file of PIECE_IMAGES
        file = "#{IMAGE_URL}/#{file}"
        pieceImages.b[name] = "#{file}-b.png"
        pieceImages.w[name] = "#{file}-w.png"

    return pieceImages

#-------------------------------------------------------------------------------
directionsEven =
    0: [ 0, -1]
    1: [ 1,  0]
    2: [ 1,  1]
    3: [ 0,  1]
    4: [-1,  1]
    5: [-1,  0]

directionsOdd =
    0: [ 0, -1]
    1: [ 1, -1]
    2: [ 1,  0]
    3: [ 0,  1]
    4: [-1, -1]
    5: [-1,  0]

#-------------------------------------------------------------------------------
buildEdges = (hexes) ->

    for name, hex of hexes
        hex.edges = {}

        odd = !!(hex.col % 2)
        directions = if odd then directionsOdd else directionsEven

        for dirName, dirOffset of directions
            cCol  = hex.col + dirOffset[0]
            cRow  = hex.row + dirOffset[1]
            cName = getHexName(cCol, cRow)

            continue unless hexes[cName]

            hex.edges[cName] = 
                hex: hexes[cName]

    for crater in CRATERS
        hex = hexes[crater]

        for cName, edge of hex.edges
            edge.isCrater = true

            cHex = edge.hex
            cHex.edges[hex.name].isCrater = true

    for rubble in RUBBLE
        hex1 = hexes[rubble[0]]
        hex2 = hexes[rubble[1]]

        if !hex1
            console.log "hex not found: #{rubble[0]}"
            continue

        if !hex2
            console.log "hex not found: #{rubble[1]}"
            continue

        if !hex1.edges[hex2.name]
            console.log "hex edge not not found: #{hex1.name}-#{hex2.name}"
            continue

        if !hex2.edges[hex1.name]
            console.log "hex edge not not found: #{hex2.name}-#{hex1.name}"
            continue

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
