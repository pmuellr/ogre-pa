# Licensed under the Apache License. See footer for details.

svg = exports

NS_SVG   = "http://www.w3.org/2000/svg"
NS_XLINK = "http://www.w3.org/1999/xlink"

#-------------------------------------------------------------------------------
svg.createElement = (name) ->
    return document.createElementNS NS_SVG, name

    return element

#-------------------------------------------------------------------------------
svg.createImageElement = (url) ->
    image = svg.createElement "image"
    image.setAttributeNS NS_XLINK, "href", url

    return image

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
