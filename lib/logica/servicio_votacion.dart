import '../modelos/votacion.dart';
import '../modelos/opcion_votacion.dart';
import '../modelos/resultado_opcion.dart';
import 'resultado_voto.dart';

class ServicioVotacion {
  final Votacion votacion;
  ServicioVotacion(this.votacion);

  ResultadoVoto registrarVoto({required String idUsuario, required String idOpcion}) {
    final yaCerro = DateTime.now().isAfter(votacion.fechaCierre);
    if (yaCerro) return ResultadoVoto.votacionCerrada;

    final yaVoto = votacion.votantes.contains(idUsuario);
    if (yaVoto) return ResultadoVoto.usuarioYaVoto;

    final opcion = _buscarOpcion(idOpcion);
    if (opcion == null) return ResultadoVoto.opcionInvalida;

    opcion.votos++;
    votacion.votantes.add(idUsuario);
    return ResultadoVoto.exitoso;
  }

  List<ResultadoOpcion> obtenerResultados() {
    final total = votacion.opciones.fold<int>(0, (suma, o) => suma + o.votos);
    return votacion.opciones.map((o) {
      final porcentaje = total == 0 ? 0.0 : (o.votos / total) * 100;
      return ResultadoOpcion(o, porcentaje);
    }).toList();
  }

  List<OpcionVotacion> determinarGanador() {
    final maxVotos = votacion.opciones.map((o) => o.votos).reduce((a, b) => a > b ? a : b);
    return votacion.opciones.where((o) => o.votos == maxVotos).toList();
  }

  OpcionVotacion? _buscarOpcion(String id) {
    for (final o in votacion.opciones) {
      if (o.id == id) return o;
    }
    return null;
  }
}
