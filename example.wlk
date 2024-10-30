class Nave
{
    var velocidad
    var direccion
    var combustible

    method cargarCombustible(cuanto)
    {
      combustible += cuanto
    }

    method descargarCombustible(cuanto)
    {
      combustible = (combustible - cuanto).max(0)
    }

    method acelerar(cuanto) {velocidad = 100000.min( velocidad + cuanto) }

    method desacelerar(cuanto) {velocidad -= 0.max(cuanto) }

    method irHaciaElSol() {direccion = 10 }

    method escaparHaciaElSol() {direccion = -10 }

    method ponerseParaleloAlSol() {direccion = 10 }

    method acercarseUnPocoAlSol() {direccion = 10.min(direccion + 1) }

    method alejarseUnPocoAlSol() {direccion = -10.max(direccion - 1) }

    method estaTranquila()
    {
      return combustible >= 4000 && velocidad <= 12000
    }

    method recibirAmenaza()
    {
      self.escapar()
      self.avisar()
    }

    method prepararViaje()
    {
      self.cargarCombustible(30000)
      self.acelerar(5000)
      self.accionAdicional()
    } 

    method estaDeRelajo() = self.estaTranquila() && self.tienePocaActividad()
    method tienePocaActividad() = true
    
    //Métodos abstractos
    method accionAdicional() 
    method escapar()
    method avisar()
}

class NaveBaliza inherits Nave
{
    var colorBaliza
    const coloresPosibles = #{"verde", "rojo", "azul"}
    var haCambiadoDeColor

    method initialize()
    {
      haCambiadoDeColor = false
      colorBaliza = "verde"
    } //se inicia siempre en falso sin permitir que se cambie al crear una instancia

    method cambiarColorDeBaliza(unColorNuevo)
    {
      if(!coloresPosibles.contains(unColorNuevo)) 
        self.error("El color indicado no es válido")

      colorBaliza = unColorNuevo
      haCambiadoDeColor = true
    }

    override method estaTranquila() {return super() && colorBaliza != "rojo" }

    override method accionAdicional()
    {
      self.cambiarColorDeBaliza("verde")
      self.ponerseParaleloAlSol()
    }

    override method escapar() {self.irHaciaElSol() }

    override method avisar() {self.cambiarColorDeBaliza("rojo") }

    override method tienePocaActividad() = !haCambiadoDeColor
}

class NaveDePasajeros inherits Nave
{
    const pasajeros
    var comida
    var bebida
    var racionesServidas = 0

    method cargarComida(cuanto) {comida += cuanto}
    method cargarBebida(cuanto) {bebida += cuanto}

    method descargarComida(cuanto) {comida = 0.max(comida - cuanto) racionesServidas += cuanto}
    method descargarBebida(cuanto) {bebida = 0.max(comida - cuanto)}

    override method accionAdicional()
    {
      self.cargarBebida(6*pasajeros)
      self.cargarComida(4*pasajeros)
      self.acercarseUnPocoAlSol()
    }

    override method escapar() {self.acelerar(velocidad) }

    override method avisar() 
    {
      self.descargarComida(pasajeros) 
      self.descargarBebida(pasajeros * 2)
    }

    override method tienePocaActividad() {racionesServidas < 50}
}

class NaveDeCombate inherits Nave
{
    var esInvisible = false
    var misilesDesplegados = false
    const mensajesEmitidos = []

    method ponerseVisible() {esInvisible = false}
    method ponerseInvisible() {esInvisible = true}
    method esInvisible() = esInvisible

    method desplegarMisiles() {misilesDesplegados = true}
    method replegarMisiles() {misilesDesplegados = false}
    method misilesDesplegados() = misilesDesplegados

    method emitirMensaje(mensaje) {mensajesEmitidos.add(mensaje)}

    method primerMensajeEmitido()
    {
      if(mensajesEmitidos.isEmpty())
      {self.error("No se emitieron mensajes")}

      return mensajesEmitidos.first()
    }

    method ultimoMensajeEmitido()
    {
      if(mensajesEmitidos.isEmpty())
      {self.error("No se emitieron mensajes")}

      return mensajesEmitidos.last()
    }

    override method estaTranquila()
    {
      return super() && !misilesDesplegados
    }

    method esEscueta() = mensajesEmitidos.any({m => m.length() <= 30})

    method emitioMensaje(unMensaje) = mensajesEmitidos.contains(unMensaje)

    override method accionAdicional()
    {
      self.ponerseVisible()
      self.replegarMisiles()
      self.acelerar(15000)
      self.emitioMensaje("Saliendo en misión")
    }

    override method escapar() 
    {
      self.acercarseUnPocoAlSol() 
      self.acercarseUnPocoAlSol() 
    }

    override method avisar() {self.emitioMensaje("Amenaza recibida") }
}

class NaveHospital inherits NaveDePasajeros
{
    var quirofanosPreparados = false

    method quirofanosPreparados() = quirofanosPreparados
    method prepararQuirofanos() {quirofanosPreparados = true }
  method desprepararQuirofanos() {quirofanosPreparados = false}


    override method estaTranquila()
    {
      return super() && !quirofanosPreparados
    }

    override method recibirAmenza()
    {
      super()
      self.prepararQuirofanos()
    }


}
class NaveSigilosa inherits NaveDeCombate
{
    override method estaTranquila()
    {
      return super() && !esInvisible
    }

    override method escapar()
    {
      super()
      self.desplegarMisiles()
      self.ponerseInvisible()
    }
}