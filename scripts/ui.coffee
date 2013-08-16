# Licensed under the Apache License. See footer for details.

svg   = require "./svg"
board = require "./board"

ui = exports

#-------------------------------------------------------------------------------
main = ->

    body$  = $ "body"
    svg$   = $ svg.createElement "svg"
    image$ = $ svg.createImageElement "vassal/images/ogre-map.png"

    svg$.attr
        id:      "board"
        x:       0
        y:       0
        width:   board.width
        height:  board.height
        viewBox: "0 0 #{board.width} #{board.height}"

    image$.attr
        x:      0
        y:      0
        width:  board.width
        height: board.height

    svg$.append   image$
    body$.append  svg$

    # drawDots()
    drawEdges()
    # drawLabels()

    buildPiece board.pieceImages.w.cp_alpha  , board.hexes["0102"]
    buildPiece board.pieceImages.w.gev       , board.hexes["0202"]
    buildPiece board.pieceImages.w.hvy_tank  , board.hexes["0302"]
    buildPiece board.pieceImages.w.hwz       , board.hexes["0402"]
    buildPiece board.pieceImages.w.infantry_1, board.hexes["0502"]
    buildPiece board.pieceImages.w.infantry_2, board.hexes["0602"]
    buildPiece board.pieceImages.w.infantry_3, board.hexes["0702"]
    buildPiece board.pieceImages.w.msl_tank  , board.hexes["0802"]
    buildPiece board.pieceImages.w.ogre_mk3  , board.hexes["0902"]
    buildPiece board.pieceImages.w.ogre_mk5  , board.hexes["1002"]

    buildPiece board.pieceImages.b.cp_alpha  , board.hexes["0103"]
    buildPiece board.pieceImages.b.gev       , board.hexes["0203"]
    buildPiece board.pieceImages.b.hvy_tank  , board.hexes["0303"]
    buildPiece board.pieceImages.b.hwz       , board.hexes["0403"]
    buildPiece board.pieceImages.b.infantry_1, board.hexes["0503"]
    buildPiece board.pieceImages.b.infantry_2, board.hexes["0603"]
    buildPiece board.pieceImages.b.infantry_3, board.hexes["0703"]
    buildPiece board.pieceImages.b.msl_tank  , board.hexes["0803"]
    buildPiece board.pieceImages.b.ogre_mk3  , board.hexes["0903"]
    buildPiece board.pieceImages.b.ogre_mk5  , board.hexes["1003"]


#-------------------------------------------------------------------------------
buildPiece = (url, hex) ->
    board$ = $ "#board"

    #-----------------------------------------------
    group$ = $ svg.createElement "g"
    group$.attr
        opacity: 1.0

    group$.click -> alert "clicked on #{name}"

    board$.append group$
    
    #-----------------------------------------------
    image$ = $ svg.createImageElement url
    image$.attr
        x:       hex.x - board.pieceWidth  / 2
        y:       hex.y - board.pieceHeight / 2
        width:   board.pieceWidth
        height:  board.pieceHeight

    group$.append image$

    return group$

#-------------------------------------------------------------------------------
drawDots = () ->
    board$ = $ "#board"
    for id, hex of board.hexes

        dot$ = $ svg.createElement "circle"
        dot$.attr
            cx:      hex.x
            cy:      hex.y
            r:       5
            fill:    "black"
            opacity: 0.7

        board$.append dot$

    return

#-------------------------------------------------------------------------------
drawLabels = () ->
    board$ = $ "#board"
    for id, hex of board.hexes

        label$ = $ svg.createElement "text"
        label$.attr
            x:              hex.x 
            y:              hex.y
            fill:           "white"
            stroke:         "white"
            "font-size":    24
            "text-anchor":  "middle"

        label$.text hex.name

        board$.append label$

    return

#-------------------------------------------------------------------------------
drawEdges = () ->
    board$ = $ "#board"

    for id, srcHex of board.hexes

        for dir, edge of srcHex.edges

            if edge.isCrater
                cls = "diag-crater-line"
            else if edge.isRubble
                cls = "diag-rubble-line"
            else
                cls = "diag-edge-line"

            line$ = $ svg.createElement "line"
            line$.attr
                x1: srcHex.x
                y1: srcHex.y
                x2: edge.hex.x
                y2: edge.hex.y
                class: cls

            board$.append line$

    return

#-------------------------------------------------------------------------------
$(main)

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
