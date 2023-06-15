import 'dart:convert';

import 'package:cloud_notes/notes.dart';
import 'package:cloud_notes/pagos.dart';
import 'package:cloud_notes/registrotarjetas.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AgregarPagos extends StatefulWidget {
  const AgregarPagos({Key? key}) : super(key: key);

  @override
  State<AgregarPagos> createState() => _AgregarPagosState();
}
class _AgregarPagosState extends State<AgregarPagos> {
  bool loading = true;
  List<Tarjeta> crdtcard = [];
  String? id = '';

  Future<List<Tarjeta>> mostrar_tarjetar()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id').toString();
    });

    var url = Uri.parse('https://xstracel.com.mx/dbcloudnotes/mostrar_tarjeta.php');
    var respose = await http.post(url, body: {
      'id': id
    }).timeout(Duration(seconds: 90));

    print(respose.body);
    final datos = jsonDecode(respose.body);
    List<Tarjeta> card = [];

    for(var datos in datos){
      card.add(Tarjeta.fromjson(datos));
    }
    return card;
  }
  void msm_BorrarTarjeta(id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Borrar nota'),
          content: Text('¿Estás seguro de que quieres borrar esta tarjeta?: '),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Borrar'),
              onPressed: () {
                setState(() {
                  eliminar_tarjeta(id);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> eliminar_tarjeta(id)async{
    var url = Uri.parse('https://xstracel.com.mx/dbcloudnotes/eliminar_tarjeta.php');
    var response = await http.post(url, body: {
      'id':id
    }).timeout(Duration(seconds: 90));

    if(response.body == '1'){
      setState(() {
        loading = true;
        crdtcard = [];
        mostrar_tarjetar().then((value){
          setState(() {
            crdtcard.addAll(value);
            loading = false;
          });
        });
      });
    }else{
      print(response.body);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mostrar_tarjetar().then((value){
      setState(() {
        crdtcard.addAll(value);
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 93, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 93, 1),
        title: Text("Métodos de pago"),
      ),
      body: loading == true ?
          const Center(
            child: CircularProgressIndicator(),
          )
          : crdtcard.isEmpty?
          Center(
            child: Text(
              'No hay metodos de pagos'
            ),
          )
          : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1),
          itemCount: crdtcard.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onLongPress: (){
                msm_BorrarTarjeta(crdtcard[index].id!);
              },
              child: Center(
                child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          crdtcard[index].titular!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          crdtcard[index].numero!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          crdtcard[index].fecha!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context){
                  return PaymentScreen();
                }
            ));
          },
        label: Text("Agregar método de pago"),
        icon: Icon(Icons.add),),
    );
  }
}

