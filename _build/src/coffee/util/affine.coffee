affine = {}

affine.dtr = ( d )->
  return d * Math.PI / 180

affine.world =
  size: ( p, size )->
    return {
      x: p.x * size.x
      y: p.y * size.y
      z: p.z * size.z
    }

  rotate: {
    x: ( p, rotate )->
      return {
        x: p.x
        y: p.y * Math.cos( affine.dtr( rotate.x ) ) -
           p.z * Math.sin( affine.dtr( rotate.x ) )
        z: p.y * Math.sin( affine.dtr( rotate.x ) ) +
           p.z * Math.cos( affine.dtr( rotate.x ) )
      }
    y: ( p, rotate )->
      return {
        x: p.x * Math.cos( affine.dtr( rotate.y ) ) +
           p.z * Math.sin( affine.dtr( rotate.y ) )
        y: p.y
        z: -p.x * Math.sin( affine.dtr( rotate.y ) ) +
           p.z * Math.cos( affine.dtr( rotate.y ) )
      }
    z: ( p, rotate )->
      return {
        x: p.x * Math.cos( affine.dtr( rotate.z ) ) -
           p.y * Math.sin( affine.dtr( rotate.z ) )
        y: p.x * Math.sin( affine.dtr( rotate.z ) ) +
           p.y * Math.cos( affine.dtr( rotate.z ) )
        z: p.z
      }
  }

  position: ( p, position )->
    return {
      x : p.x + position.x
      y : p.y + position.y
      z : p.z + position.z
    }

affine.view =
  phi: ( p, angle )->
    return {
      x : p.x * angle.cosPhi + p.z * angle.sinPhi
      y : p.y
      z : p.x * - angle.sinPhi + p.z * angle.cosPhi
    }

  theta: ( p, angle )->
    return {
      x : p.x
      y : p.y * angle.cosTheta - p.z * angle.sinTheta
      z : p.y * angle.sinTheta + p.z * angle.cosTheta
    }

  viewReset: ( p, self )->
    return {
      x : p.x - self.x
      y : p.y - self.y
      z : p.z - self.z
    }

affine.perspective = ( p, distance, zoom )->
  return {
    x : p.x * distance.z / p.z * zoom
    y : p.y * distance.z / p.z * zoom
    z : p.z * zoom
    p : distance.z / p.z
  }

affine.display = ( p, display )->
  return {
　　x : p.x + display.x
　　y : -p.y + display.y
　　z : p.z + display.z
　　p : p.p
  }

module.exports = affine
