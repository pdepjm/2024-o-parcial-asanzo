// Apellido y Nombre: 
// Apellido y Nombre: 
class Agente {
  const deudaInicial
  const ventas = []
  var estrategiaDeVenta = clasico
  
  // 1a)
  method venderA(paquete, alma) {
    if (!alma.puedeCostear(paquete)) {
      throw new DomainException(message = "El alma no puede costear el paquete")
    }
    ventas.add(new Venta(paquete=paquete, alma=alma)) 
    // esta es la forma de que funcionen todos los puntos posteriores, creando un objeto venta,
    // que registra qué paquete le fue a qué alma. Sino el punto 4 de los paquetes
    // predefinidos no se podría hacer.
  }  
  // 1d)
  method deuda() = deudaInicial - self.dineroGanado() // podría tener una deuda que se actualice también.
  
  // 1c)
  method dineroGanado() = ventas.sum({ venta => venta.costo() })
  
  method pagoSuDeuda() = self.deuda() <= 0
  
  // 4)
  method atender(alma) {
    self.venderA(estrategiaDeVenta.paquetePara(alma), alma)
  }

  // 4c)
  method cambiarEstrategia(estrategia) {
    estrategiaDeVenta = estrategia
  }
  
  method cantidadPaquetesVendidos() = ventas.size()
}

object departamentoDeLaMuerte {
  const agentes = []
  var property paquetesPredefinidos = [new Tren(basico=100), new Crucero(basico=40)] //ejemplos

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

class Venta {
  const alma
  const paquete

  method costo() = paquete.costoPara(alma) 
}

// Punto 3), paquetes:
class Paquete {
  const basico

  method costoPara(alma) = (basico * self.cuantoReduceA(alma)).min(350)
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
  method paquetesCosteables(alma) = departamentoDeLaMuerte.paquetesPredefinidos().filter({paq => alma.puedeCostear(paq)})
  method paquetePara(alma) = self.paquetesCosteables(alma).max( { p => p.costoPara(alma)})
}
object navegante {
  method paquetePara(alma) = if (alma.cantAccionesBuenas() > 50) 
    new Crucero(basico=alma.cantAccionesBuenas()) 
    else new Bote(basico=alma.cantAccionesBuenas())
}

object indiferente {  
  method paquetePara(alma) = new Palo(basico=1.randomUpTo(300))
}