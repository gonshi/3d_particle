###!
  * Main Function
###

$ = require "jquery"
CameraManager = require "./model/cameraManager"
Box = require "./model/box"
Ticker = require "./util/ticker"

$ ->
  cameraManager = CameraManager()
  ctx = $( "#canvas" ).get( 0 ).getContext "2d"
  ctx_width = $( "#canvas" ).width()
  ctx_height = $( "#canvas" ).height()
  ticker = Ticker()
  ticker.setFps 30
  box = []
  VER_LENGTH = 8
  is_makeBox = false

  ###
    DECLARE
  ###
  v = []

  faces = [
    {
      color : "hsla(0, 100%, 70%, 1)"
      verticies : [ 0, 1, 2, 3 ]
    }
    {
      color : "hsla(30, 100%, 70%, 1)"
      verticies : [ 1, 5, 6, 2 ]
    }
    {
      color : "hsla(60, 100%, 70%, 1)"
      verticies : [ 5, 4, 7, 6 ]
    }
    {
      color : "hsla(90, 100%, 70%, 1)"
      verticies : [ 4, 0, 3, 7 ]
    }
    {
      color : "hsla(120, 100%, 70%, 1)"
      verticies : [ 4, 5, 1, 0 ]
    }
    {
      color : "hsla(150, 100%, 70%, 1)"
      verticies : [ 3, 2, 6, 7 ]
    }
  ]

  if window._DEBUG
    if Object.freeze?
      window.DEBUG = Object.freeze window._DEBUG
    else
      window.DEBUG = state: true
  else
    if Object.freeze?
      window.DEBUG = Object.freeze state: false
    else
      window.DEBUG = state: false

  ###
    EVENT LISTENER
  ###
 
  ticker.listen ->
    ctx.clearRect 0, 0, ctx_width, ctx_height
    # 注視距離・視線角のアップデート
    cameraManager.update()

    box.push new Box() if is_makeBox

    # 各頂点に回転角を代入し頂点をアップデート
    for i in [ 0...box.length ]
      for j in [ 0...VER_LENGTH ]
        _affineIn = box[ i ].affineIn[ j ]
        _affineIn.rotate.x += 1
        _affineIn.rotate.y += 1
        _affineIn.rotate.z += 1

        _affineIn.position.x += box[ i ].speed.x
        _affineIn.position.y += box[ i ].speed.y
        _affineIn.position.z += box[ i ].speed.z
        if _affineIn.position.x > ctx_width / 2 ||
           _affineIn.position.x < -ctx_width / 2
          box[ i ].speed.x *= -1
        if _affineIn.position.y > ctx_width / 2 ||
           _affineIn.position.y < -ctx_width / 2
          box[ i ].speed.y *= -1
        if _affineIn.position.z > ctx_width / 2 ||
           _affineIn.position.z < -ctx_width / 2
          box[ i ].speed.z *= -1

      box[ i ].update()

    for i in [ 0...box.length ]
      faces.sort ( a, b )->
        pA = 0
        for j in [ 0...a.verticies.length ]
          pA += box[ i ].affineOut[ a.verticies[ j ] ].p
          if j == a.verticies.length - 1
            pA /= 4

        pB = 0
        for j in [ 0...b.verticies.length ]
          pB += box[ i ].affineOut[ b.verticies[ j ] ].p
          if j == b.verticies.length - 1
            pB /= 4

        if pA < pB
          return -1
        else if pA > pB
          return 1
        else
          return 0

    box: for i in [ 0...box.length ]
      is_draw = true
      for j in [ 0...VER_LENGTH ]
        if box[ i ].affineOut[ j ].p > 2
          is_draw = false
          break
      if is_draw
        for j in [ 0...faces.length ]
          ctx.beginPath()
          for k in [ 0...faces[ j ].verticies.length ]
            if k == 0
              ctx.moveTo( box[ i ].affineOut[ faces[ j ].verticies[ k ] ].x,
              box[ i ].affineOut[ faces[ j ].verticies[ k ] ].y )
            else
              ctx.lineTo( box[ i ].affineOut[ faces[ j ].verticies[ k ] ].x,
              box[ i ].affineOut[ faces[ j ].verticies[ k ] ].y )
          ctx.closePath()
          ctx.fillStyle = faces[ j ].color
          ctx.fill()

  ###
    INIT
  ###
  $( "#canvas" ).on "mousedown", ->
    $( ".intro" ).hide()
    is_makeBox = true
  $( "#canvas" ).on "mouseup", ->
    is_makeBox = false
