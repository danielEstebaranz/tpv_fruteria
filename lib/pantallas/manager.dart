import 'package:flutter/material.dart';
import 'package:tpv_fruteria/producto.dart';
import 'package:tpv_fruteria/ventas_globales.dart';
import 'package:tpv_fruteria/ResumenProducto.dart';

class Manager extends StatefulWidget {
  const Manager({super.key});

  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  // suma total--------------------------------
  double get recaudacionTotal {
    double suma = 0;
    for (var venta in ventas) {
      suma += venta.total;
    }
    return suma;
  }

  //nª ventas------------------------------
  int get totalVentas {
    return ventas.length;
  }

  // producto estrella---------------------------
  Producto? get productoEstrella {
    Producto? estrella;
    double maxIngresos = 0;

    List<ResumenProducto> resumen = resumenProductos;

    for (var resu in resumen) {
      if (resu.ingresos > maxIngresos) {
        maxIngresos = resu.ingresos;
        estrella = resu.producto;
      }
    }
    return estrella;
  }

  //resumen producto-------------------------------------------
  List<ResumenProducto> get resumenProductos {
    List<ResumenProducto> lista = [];

    for (var venta in ventas) {
      for (var linea in venta.lineas) {
        ResumenProducto?encontrado;
        for (var ls in lista) {
          if (ls.producto.nombre==linea.producto.nombre) {
            encontrado=ls;
            break;
          }
        }

        if (encontrado == null) {
          lista.add(
            ResumenProducto(
              producto: linea.producto,
              unidades: linea.cantidad,
              ingresos: linea.cantidad * linea.producto.precio,
              frecuencia: 1,
            ),
          );
        } else {
          encontrado.unidades += linea.cantidad;
          encontrado.ingresos += linea.cantidad * linea.producto.precio;
          encontrado.frecuencia += 1;
        }
      }
    }
    return lista;
  }

  // cards stats--------------------------------
  Widget tarjeta(String titulo, String valor,IconData icono) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 187, 221, 237),
                borderRadius: BorderRadius.circular(6)
              ),
              child: Icon(icono,color: Colors.yellow,)
              ),
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(valor, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

 Widget imagenProducto(String img) {
  if (img.startsWith("http")) {
    return Image.network(
      img,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  } else {
    return Image.asset(
      img,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  }
}
  @override
  Widget build(BuildContext context) {
    Producto? estrella = productoEstrella;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // stats generales------------------------------------
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(child: tarjeta("Recaudación total","${recaudacionTotal.toStringAsFixed(2)} €",Icons.money)),
              Expanded(child: tarjeta("Total ventas",totalVentas.toString(),Icons.document_scanner)),
              Expanded(child: tarjeta("Producto Top",estrella == null ? "Ninguno" : estrella.nombre,Icons.emoji_events)),
            ],
          ),
        ),

        const Divider(),

        // Resumen producto--------------------------
        Expanded(
          child: ListView.builder(
            itemCount: resumenProductos.length,
            itemBuilder: (context, index) {
              final resu = resumenProductos[index];

              return ListTile(
                leading: imagenProducto(resu.producto.imagen),
                title: Text(resu.producto.nombre),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tickets: ${resu.unidades}"),
                        Text("Nª Ventas: ${resu.frecuencia} venta/s"),
                      ],
                    ),
                    Spacer(),
                    Text("Ingresos: ${resu.ingresos.toStringAsFixed(2)} €",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.green),),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
