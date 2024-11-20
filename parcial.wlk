// Apellido y Nombre: 
// Apellido y Nombre: 
class Agente {
  var deudaInicial
  const paquetesVendidos
  var estrategiaDeVenta
  
  // 1a)
  method venderA(paquete, alma) {
    if (!alma.puedeCostear(paquete)) {
      throw new DomainException(message = "El alma no puede costear el paquete")
    }
    paquetesVendidos.add(paquete)
  }
  
  method paquetesVendidos() = paquetesVendidos
  
  // 1d)
  method deuda() = deudaInicial - self.dineroGanado() // podría tener una deuda que se actualice también.
  
  // 1c)
  method dineroGanado() = paquetesVendidos.sum({ paquete => paquete.costo() })
  
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
  
  // 1b)
  method mejorAgente() = agentes.max(
    { agente => agente.cantidadPaquetesVendidos() }
  )
  
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
  method costoPara(alma) = (100 * self.cuantoReduceA(alma)).min(350)
  
  method cuantoReduceA(alma)
}

object tren inherits Paquete {
  override method cuantoReduceA(alma) = 4
}

class Bote inherits Paquete {  
  override method cuantoReduceA(alma) = (alma.accionesBuenas() / 50).min(2)
}

object palo inherits Paquete {
  override method cuantoReduceA(alma) = 0.05
}

object crucero inherits Bote {
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

const paquetes = [tren, new Bote(), crucero, palo]

object clasico {
  method paquetePara(alma) = paquetes.max( { e => e.costoPara(alma)})
}
object navegante {
  method paquetePara(alma) = if (alma.cantAccionesBuenas() > 50) crucero else new Bote()
}

object indiferente {  
  method paquetePara(alma) = paquetes.anyOne()
}