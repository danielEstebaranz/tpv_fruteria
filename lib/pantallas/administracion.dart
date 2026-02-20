import 'package:flutter/material.dart';
import 'package:tpv_fruteria/producto.dart';
import 'package:tpv_fruteria/productos_finales.dart';

class Administracion extends StatefulWidget {
  const Administracion({super.key});

  @override
  State<Administracion> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Administracion> {
  String modo="fruta"; 
  String nombre="";
  String precio="";
  String imagen="";
  String tipo="fruta";
  List<String> opciones=["fruta","verdura"];
  Producto? productoSeleccionado;

  List<Producto> get productosFiltrados{
    List<Producto> lista=[];
    for(var producto in productos){
      if (producto.tipo==modo) {
        lista.add(producto);
      }
    }
    return lista;
  }
//si empieza por http usa network para que no se rompa al usar asset
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

  Widget listaProductos(){
    return Expanded(
      flex: 3,
      child: ListView.builder(
        itemCount:productosFiltrados.length,
        itemBuilder: (context, index) {
        final producto= productosFiltrados[index];

        return ListTile(
          leading: imagenProducto(producto.imagen),
          title: Text(producto.nombre),
          subtitle: Text("${producto.precio.toStringAsFixed(2)} €"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: (){
                setState(() {
                  productoSeleccionado=producto;
                  nombre=producto.nombre;
                  precio=producto.precio.toString();
                  imagen=producto.imagen;
                  tipo=producto.tipo;
                });
              }, icon: Icon(Icons.edit)),
              IconButton(onPressed: (){
                setState(() {
                  productos.remove(producto);
                  productoSeleccionado=null;
                });
              }, icon: Icon(Icons.delete)),
            ],
          ),
        );
      },
     )
    );
  }

  Widget botonesSuperiores(){
  return Padding(padding: EdgeInsets.all(12),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(onPressed: (){
        setState(() {
          modo="fruta";
        });
      }, child: Text("frutas")),
      SizedBox(width: 20,),
       ElevatedButton(onPressed: (){
        setState(() {
          modo="verdura";
        });
      }, child: Text("verduras")),
      Spacer(),
     
    ],
  ),
  );
}
Widget panelDerecho(){
  return Expanded(
    flex: 2,
    child: Padding(
      padding: EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productoSeleccionado == null ? "Añadir producto" : "Editar producto",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          TextField(
            decoration: InputDecoration(labelText: "Nombre"),
            controller: TextEditingController(text: nombre),  
            onChanged: (value) {
              nombre = value;
            },
          ),

          TextField(
            decoration: InputDecoration(labelText: "Precio"),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: precio), 
            onChanged: (value) {
              precio = value;
            },
          ),

          TextField(
            decoration: InputDecoration(labelText: "Url imagen"),
            controller: TextEditingController(text: imagen),  
            onChanged: (value) {
              imagen = value;
            },
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tipo: ", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              
              Container(
                padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: DropdownButton(
                  value: tipo, 
                  underline: SizedBox(),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(value: "fruta", child: Text("fruta")),
                    DropdownMenuItem(value: "verdura", child: Text("verdura")),
                  ],
                  onChanged: (valor) {
                    setState(() {
                      tipo = valor!;  
                    });
                  }
                ),
              ),
              
              SizedBox(height: 10),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (productoSeleccionado == null) {
                            productos.add(Producto(
                              nombre: nombre, 
                              precio: double.parse(precio), 
                              imagen: imagen, 
                              tipo: tipo
                            ));
                          } else {
                            productoSeleccionado!.nombre = nombre;
                            productoSeleccionado!.precio = double.parse(precio);
                            productoSeleccionado!.imagen = imagen;
                            productoSeleccionado!.tipo = tipo;
                          }
                          productoSeleccionado = null;
                          nombre = "";
                          precio = "";
                          imagen = "";
                          tipo = modo;
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green), 
                      child: Text(productoSeleccionado == null ? "Añadir producto" : "Guardar cambios")
                    ),
                  ),
                ],
              ),
              
              if (productoSeleccionado != null)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            productoSeleccionado = null;
                            nombre = "";
                            precio = "";
                            imagen = "";
                            tipo = modo;
                          });
                        },
                        child: Text("Cancelar Edicion", style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                ),
            ],
          )
        ],
      ),
    ),
  );
}
Widget formularioAdd(){
  return Expanded(
    flex: 3,
    child: Padding(padding: EdgeInsetsGeometry.all(8),
    
    child: Column(
      children: [
        Text("Añadir producto",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        TextField(
          decoration: InputDecoration(labelText: "Nombre"),
          onChanged: (value) {
            nombre=value;
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: "Precio"),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            precio=value;
          },
        ),
        SizedBox(height: 12,),

        ElevatedButton(onPressed: (){
          
          setState(() {
            productos.add(Producto(nombre: nombre, precio: double.parse(precio), imagen:imagen.isEmpty? "assets/images/default.jpg":imagen, tipo: modo=="verdura" ? "verdura" : "fruta"));
            nombre="";
            precio="";
            imagen="";
          });
        }, child: Text("Añadir producto"))
      ],
    ),
    
    )
    
    );
}
Widget formularioEdicion(){
  if (productoSeleccionado==null) {
    return SizedBox();
  }
  return Expanded(child: 
  Padding(padding: EdgeInsets.all(12),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text("Editar Prodcto",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
      TextField(
        decoration: InputDecoration(labelText: "Nombre"),
        onChanged: (value) {
          nombre=value;
        },
        controller: TextEditingController(text: productoSeleccionado!.nombre),

      ),
      TextField(
        decoration: InputDecoration(labelText: "Precio"),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          precio=value;
        },
        controller: TextEditingController(
          text: productoSeleccionado!.precio.toString()
        ),
      ),
      SizedBox(height: 8,),
      ElevatedButton(onPressed: (){
        setState(() {
          productoSeleccionado!.nombre=nombre;
          productoSeleccionado!.precio=double.parse(precio);
        });
      }, child: Text("Guardar cambios")),
      TextButton(onPressed: (){
        setState(() {
          productos.remove(productoSeleccionado);
          productoSeleccionado=null;
        });
      }, child: Text("Eliminar",))

    ],
  ),
  ),);
  
}
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        botonesSuperiores(),
        Expanded(child: Row(
          children: [
           listaProductos(),
           panelDerecho()
          ],
        ))
      ],
    );
  }
}
