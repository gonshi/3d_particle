$ = require "jquery"
instance = null

class CameraManager
  constructor: ->
    @self =
      x: 0
      y: 0
      z: 300

    @target =
      x: 0
      y: 0
      z: 0

    @distance =
      x: 0
      y: 0
      z: 0

    @angle =
      cosPhi: 0
      sinPhi: 0
      cosTheta: 0
      sinTheta: 0

    @zoom = 1

    @display =
      x: $( "#canvas" ).width() / 2
      y: $( "#canvas" ).height() / 2
      z: 0

  update: ->
    @distance.x = @target.x - @self.x
    @distance.y = @target.y - @self.y
    @distance.z = @target.z - @self.z

    # 2次元
    @angle.cosPhi = -@distance.z / Math.sqrt( @distance.x * @distance.x +
                    @distance.z * @distance.z )
    @angle.sinPhi = @distance.x / Math.sqrt( @distance.x * @distance.x +
                    @distance.z * @distance.z )

    # 3次元
    @angle.cosTheta = Math.sqrt( @distance.x * @distance.x +
                      @distance.z * @distance.z ) /
                      Math.sqrt( @distance.x * @distance.x +
                      @distance.y * @distance.y + @distance.z * @distance.z )
    @angle.sinTheta = -@distance.y / Math.sqrt( @distance.x * @distance.x +
                      @distance.y * @distance.y + @distance.z * @distance.z )

getInstance = ->
  if !instance
    instance = new CameraManager()
  return instance

module.exports = getInstance
