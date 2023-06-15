import 'package:cloud_notes/notes.dart';
import 'package:flutter/material.dart';

class Subscripcion extends StatefulWidget {
  const Subscripcion({Key? key}) : super(key: key);

  @override
  State<Subscripcion> createState() => _SubscripcionState();
}

class _SubscripcionState extends State<Subscripcion> {

  mostrar_alerta(mensaje){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Cloud Notes"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(mensaje),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (BuildContext context){
                        return new NotasPage();
                      }), (route) => false);
                },
                child: Text("Aceptar"),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 93, 1),
        title: Text("Subscripción"),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              Text("Cloud +", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              SizedBox(height: 20,),
              Text("Recupera todas tus notas eliminadas", style: TextStyle(fontSize: 18,)),
              SizedBox(height: 20,),
              Text("10 Pesos al mes", style: TextStyle(fontSize: 18,)),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                mostrar_alerta("Subscripción activada");
              }, child: Text("Subscribirse"))
            ],
          ),
        ),
      ),
    );
  }
}
