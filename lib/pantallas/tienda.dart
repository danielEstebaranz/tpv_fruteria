import 'package:flutter/material.dart';
import 'package:tpv_fruteria/linea_carrito.dart';
import 'package:tpv_fruteria/producto.dart';
import 'package:tpv_fruteria/productoCard.dart';
import 'package:tpv_fruteria/productos_finales.dart';
import 'package:tpv_fruteria/venta.dart';
import 'package:tpv_fruteria/ventas_globales.dart';

class Tienda extends StatefulWidget {
  const Tienda({super.key});

  @override
  State<Tienda> createState() => _TiendaState();
}

class _TiendaState extends State<Tienda> {
  String filtroSeleccionado = "todo";
  List<LineaCarrito> carrito = [];
  double iva=0.21;

  double get subtotal{
    double suma=0;
    for(var p in carrito){
      suma+=p.producto.precio*p.cantidad;
    }
    return suma;
  }
  double get impuesto{
    return subtotal*iva;
  }
  double get total{
    return subtotal - impuesto;
  }

  List<Producto> get productosFiltrados {
   if (filtroSeleccionado=="todo") {
    return productos;
   }

   List<Producto> lista=[];
   for (var producto in productos) {
     if (producto.tipo==filtroSeleccionado) {
       lista.add(producto);
     }
   }
   return lista;
  }
  int cantidadEnCarrito(Producto producto) {
  for (var linea in carrito) {
    if (linea.producto.nombre==producto.nombre) {
      return linea.cantidad;
    }
  }
  return 0;
}
void quitarProducto(Producto producto){
  LineaCarrito? linea;
  for (var p in carrito) {
    if (p.producto.nombre==producto.nombre) {
      linea=p;
      break;
    }
  }
  if(linea!=null){
    quitarUnidad(linea);
  }
}
  void anadirCarrito(Producto producto,int cantidad) {
   setState(() {
    LineaCarrito? encontrado;
    for (var linea in carrito) {
      if (linea.producto.nombre==producto.nombre) {
        encontrado=linea;
        break;
      }
    }

    if (encontrado == null) {
      carrito.add(LineaCarrito(producto: producto, cantidad: cantidad));
    } else {
      encontrado.cantidad += cantidad; 
    }
  });
  }
  void quitarUnidad(LineaCarrito linea){
    setState(() {
      if (linea.cantidad>1) {
        linea.cantidad--;
      }else{
        carrito.remove(linea);
      }
    });
  }
Widget imagenProducto(String img, {double size = 50}) {
  if (img.startsWith("http")) {
    return Image.network(
      img,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  } else {
    return Image.asset(
      img,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    //Filtros-------------------------
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filtroSeleccionado = "todo";
                  });
                },
                child: const Text("Todo"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filtroSeleccionado = "fruta";
                  });
                },
                child: const Text("Fruta"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filtroSeleccionado = "verdura";
                  });
                },
                child: const Text("Verdura"),
              ),
            ],
          ),
        ),



        //grid--------------------------------
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: GridView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: productosFiltrados.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final producto = productosFiltrados[index];
                    
                    return Productocard(
                      producto: producto,
                      onAdd: anadirCarrito,
                      cantidadEnCarrito: cantidadEnCarrito(producto),
                    );
                    
                  },
                ),
              ),



              //carro-------------------------------
              if (carrito.isNotEmpty)
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(245, 245, 245, 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Carrito",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                     Expanded(child: ListView(
                      children: [
                        for(final producto in carrito)
                        Container(
                          margin: EdgeInsets.only(top: 4 ,bottom: 4),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow:[BoxShadow(color: Colors.black)]
                          ),
                          child: Row(
                            children: [
                              imagenProducto(producto.producto.imagen),
                              SizedBox(width: 10,),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(producto.producto.nombre,style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text("${producto.cantidad} uds ",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text("${producto.producto.precio.toStringAsFixed(2)}  €",style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              )),
                               IconButton(onPressed: (){
                          quitarUnidad(producto);
                        }, icon:Icon(Icons.close))
                            ],
                          ),
                        )
                       
                      ],
                     ),                    
                     ),



                      //totales----------------------------------
                      Center(child: 
                      Column(
                        children: [
                          Text("Subtotal:   ${total.toStringAsFixed(2)} € ",style: TextStyle(fontSize: 18),),
                          Text("Impuesta:   ${impuesto.toStringAsFixed(2)} € ",style: TextStyle(fontSize: 18),),
                          Text("Total:   ${subtotal.toStringAsFixed(2)} € ",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
                         ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  List<LineaVenta> lineas=[];

                                  for (var linea in carrito) {
                                    lineas.add(
                                      LineaVenta(producto: linea.producto, cantidad: linea.cantidad)
                                    );
                                  }
                                  ventas.add( Venta(lineas: lineas, total: subtotal));
                                  carrito.clear();
                                });
                              },
                              child: Text("Pagar"),
                            )
                        ],
                      )
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
