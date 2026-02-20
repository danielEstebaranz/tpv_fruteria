import 'package:tpv_fruteria/producto.dart';

class LineaCarrito {
  final Producto producto;
  int cantidad;

  LineaCarrito({required this.producto,this.cantidad=1});
}