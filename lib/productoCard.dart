import 'package:flutter/material.dart';
import 'package:tpv_fruteria/producto.dart';

class Productocard extends StatefulWidget {
  final Producto producto;
  final void Function(Producto, int) onAdd; 
  final int cantidadEnCarrito;

  Productocard({
    super.key,
    required this.producto,
    required this.onAdd,
    required this.cantidadEnCarrito
  });

  @override
  State<Productocard> createState() => _ProductocardState();
}

class _ProductocardState extends State<Productocard> {
  int cantidadTemporal = 0;

Widget imagenProducto(String img) {
  if (img.startsWith("http")) {
    return Image.network(img,fit: BoxFit.cover,);
  } else {
    return Image.asset(img,fit: BoxFit.cover,);
  }
}


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [


            Expanded(child: imagenProducto(widget.producto.imagen)),
            Text(widget.producto.nombre, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("${widget.producto.precio.toStringAsFixed(2)} €/kg"),
            
            if (widget.cantidadEnCarrito > 0)
              Text("En carrito: ${widget.cantidadEnCarrito}", 
                   style: TextStyle(color: Colors.green, fontSize: 12)),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: cantidadTemporal > 0 ? () {
                        setState(() {
                          cantidadTemporal--;
                        });
                      }: null,
                  icon: Icon(Icons.remove)
                ),
                Text(cantidadTemporal.toString(), style: TextStyle(fontSize: 16)),
                IconButton(
                  onPressed: cantidadTemporal < 10
                    ? () {
                        setState(() {
                          cantidadTemporal++;
                        });
                      }
                    : null,
                  icon: Icon(Icons.add)
                ),
              ],
            ),
            
            if (cantidadTemporal > 0)
              ElevatedButton(
                onPressed: () {
                  widget.onAdd(widget.producto, cantidadTemporal);
                  setState(() {
                    cantidadTemporal = 0;  
                  });
                },
                child: Text("Añadir al carrito")
              )
          ],
        ),
      ),
    );
  }
}