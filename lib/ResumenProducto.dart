import 'package:tpv_fruteria/producto.dart';

class ResumenProducto {
  final Producto producto;
  int unidades;
  double ingresos;
  int frecuencia;

  ResumenProducto({
    required this.producto,
    required this.unidades,
    required this.ingresos,
    required this.frecuencia,
  });
}