import 'package:tpv_fruteria/producto.dart';

class Venta {
  final List<LineaVenta> lineas;
  final double total;

  Venta({required this.lineas,required this.total});

}
class LineaVenta{
  final Producto producto;
  final int cantidad;

  LineaVenta({required this.producto,required this.cantidad});
}