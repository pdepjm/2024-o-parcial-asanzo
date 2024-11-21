// Apellido y Nombre: 
// Apellido y Nombre: 
class Agente {
  var deudaInicial
  const paquetesVendidos = []
  var estrategiaDeVenta = clasico
  
  // 1a)
  method venderA(paquete, alma) {
    if (!alma.puedeCostear(paquete)) {
      throw new DomainException(message = "El alma no puede costear el paquete")
    }
    paquetesVendidos.add(paquete)
    paquete.almaFinal(alma) // para luego poder consultar el costo sin necesitar el alma. Una mejor forma de modelar esto es tener una clase Venta que conozca el paquete y el alma, y el Agente se guarda las ventas, en lugar de los paquetes.
  }
  
  method paquetesVendidos() = paquetesVendidos
  
  // 1d)
  method deuda() = deudaInicial - self.dineroGanado() // podría tener una deuda que se actualice también.
  
  // 1c)
  method dineroGanado() = paquetesVendidos.sum({ paquete => paquete.costoDeVenta() })
  
  method reducirDeudaInicial(cantidad) {
    deudaInicial -= cantidad
  }
  
  method Inicial(cantidad) {
    deudaInicial += cantidad
  }
  
  method pagoSuDeuda() = self.deuda() == 0
  
  // 4)
  method atender(alma) {
    self.venderA(estrategiaDeVenta.paquetePara(alma), alma)
  }

  // 4c)
  method cambiarEstrategia(estrategia) {
    estrategiaDeVenta = estrategia
  }
  
  method cantidadPaquetesVendidos() = paquetesVendidos.size()
}

object departamentoDeLaMuerte {
  const agentes = []
  const property paquetesPredefinidos = [new Tren(basico=100), new Crucero(basico=40)] //ejemplos
  // 1b)
  method mejorAgente() = agentes.max(
    { agente => agente.cantidadPaquetesVendidos() }
  )

  method agregarAgente(a) {
    agentes.add(a)
  }
  
  // 2)
  method diaDeLosMuertos() {
    self.mejorAgente().reducirDeudaInicial(50)
    agentes.removeAll(self.agentesQueCumplieronDeuda())
    agentes.forEach({ agente => agente.aumentarDeuda(100) })
    // las dos líneas anteriores podrían ser un solo foreach con un if, no estaría mal, si está bien delegado.
  }

  method agentesQueCumplieronDeuda() = agentes.filter({agente => agente.pagoSuDeuda()})
}

// Punto 3), paquetes:
class Paquete {
  const basico
  var property almaFinal = null // ver comentario en el método venderA del Agente.

  method costoPara(alma) = (basico * self.cuantoReduceA(alma)).min(350)
  method costoDeVenta() = self.costoPara(almaFinal)
  method cuantoReduceA(alma)
}

class Tren inherits Paquete {
  override method cuantoReduceA(alma) = 4
}

class Bote inherits Paquete {  
  override method cuantoReduceA(alma) = (alma.cantAccionesBuenas() / 50).min(2)
}

class Palo inherits Paquete {
  override method cuantoReduceA(alma) = 0.05
  override method costoPara(alma) = basico
}

class Crucero inherits Bote {
  override method cuantoReduceA(alma) = super(alma) * 2
}

class Alma {
  const dinero
  const cantAccionesBuenas

  method puedeCostear(paquete) = paquete.costoPara(self) <= self.capital()

  method capital() = cantAccionesBuenas + dinero
    
  method cantAccionesBuenas() = cantAccionesBuenas
}


// Estrategias punto 4:

object clasico {
  method paquetePara(alma) = departamentoDeLaMuerte.paquetesPredefinidos().max( { p => p.costoPara(alma)})
}
object navegante {
  method paquetePara(alma) = if (alma.cantAccionesBuenas() > 50) 
    new Crucero(basico=alma.cantAccionesBuenas()) 
    else new Bote(basico=alma.cantAccionesBuenas())
}

object indiferente {  
  method paquetePara(alma) = new Palo(basico=1.randomUpTo(300))
}