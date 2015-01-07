affine = require "../util/affine"
vertexData = require "../model/vertexData"
CameraManager = require "../model/cameraManager"
cameraManager = CameraManager()

class Box
  constructor: ->
    @affineIn = []
    @affineOut = []
    @speed =
      x: Math.random() * 8 + -4
      y: Math.random() * 8 + -4
      z: Math.random() * 8 + -4
    @VER_LENGTH = vertexData.length
    _size =
      x: Math.random() * 5 + 5
      y: Math.random() * 5 + 5
      z: Math.random() * 5 + 5
    _position =
      x: 0
      y: 0
      z: 0

    for i in [ 0...@VER_LENGTH ]
      @affineIn[ i ] =
        vertex: vertexData[ i ].vertex
        size: _size
        rotate: vertexData[ i ].rotate
        position: _position

  update: ->
    for i in [ 0...@VER_LENGTH ]
      @affineOut[ i ] = _process(
        @affineIn[ i ].vertex,
        @affineIn[ i ].size,
        @affineIn[ i ].rotate,
        @affineIn[ i ].position,
        cameraManager.display )

###
  PRIVATE
###
_process = ( model, size, rotate, position, display )->
  ret = affine.world.size model, size
  ret = affine.world.rotate.x ret, rotate
  ret = affine.world.rotate.y ret, rotate
  ret = affine.world.rotate.z ret, rotate
  ret = affine.world.position ret, position
  ret = affine.view.phi ret, cameraManager.angle
  ret = affine.view.theta ret, cameraManager.angle
  ret = affine.view.viewReset ret, cameraManager.self
  ret = affine.perspective ret, cameraManager.distance, cameraManager.zoom
  ret = affine.display ret, display
  return ret

module.exports = Box
