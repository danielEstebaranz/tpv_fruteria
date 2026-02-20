import 'package:tpv_fruteria/producto.dart';

class Estadisticaproducto {
  Producto producto;
  int unidadesTotales;
  double ingresos;
  int frecuencia;

  Estadisticaproducto({
    required this.producto,
    this.unidadesTotales=0,
    this.ingresos=0,
    this.frecuencia=0,
  });
}