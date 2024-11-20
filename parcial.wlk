// Apellido y Nombre: 
// Apellido y Nombre: 
class Agente {
  var deudaInicial
  const paquetesVendidos
  var estrategiaDeVenta
  
  // 1a)
  method venderA(paquete, cliente) {
    if (!cliente.puedeCostear(paquete)) {
      throw new DomainException(message = "El cliente no puede costear el paquete")
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
  method atender(cliente) {
    self.venderA(estrategiaDeVenta.paquetePara(cliente), cliente)
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
  method mejorEmpleado() = agentes.max(
    { agente => agente.cantidadPaquetesVendidos() }
  )
  
  // 2)
  method diaDeLosMuertos() {
    self.mejorEmpleado().reducirDeudaInicial(50)
    agentes.removeAll(self.agentesQueCumplieronDeuda())
    agentes.forEach({ agente => agente.aumentarDeuda(100) })
    // las dos líneas anteriores podrían ser un solo foreach con un if, no estaría mal, si está bien delegado.
  }

  method agentesQueCumplieronDeuda() = agentes.filter({agente => agente.pagoSuDeuda()})
}

// Punto 3), paquetes:
class Paquete {
  method costoPara(cliente) = (100 * self.cuantoReduceA(cliente)).min(350)
  
  method cuantoReduceA(cliente)
}

object tren inherits Paquete {
  override method cuantoReduceA(cliente) = 4
}

class Bote inherits Paquete {  
  override method cuantoReduceA(cliente) = (cliente.accionesBuenas() / 50).min(2)
}

object palo inherits Paquete {
  override method cuantoReduceA(cliente) = 0.05
}

object crucero inherits Bote {
  override method cuantoReduceA(cliente) = super(cliente) * 2
}

class Cliente {
  const dinero
  const cantAccionesBuenas

  method puedeCostear(paquete) = paquete.costoPara(self) <= self.capital()

  method capital() = cantAccionesBuenas + dinero
    
  method cantAccionesBuenas() = cantAccionesBuenas
}


// Estrategias punto 4:

const paquetes = [tren, new Bote(), crucero, palo]

object clasico {
  method paquetePara(cliente) = paquetes.max( { e => e.costoPara(cliente)})
}
object navegante {
  method paquetePara(cliente) = if (cliente.cantAccionesBuenas() > 50) crucero else new Bote()
}

object indiferente {  
  method paquetePara(cliente) = paquetes.anyOne()
}