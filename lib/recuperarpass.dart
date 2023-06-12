import 'package:cloud_notes/inicio_sesion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Recuperar extends StatefulWidget {
  const Recuperar({Key? key}) : super(key: key);

  @override
  State<Recuperar> createState() => _RecuperarState();
}

class _RecuperarState extends State<Recuperar> {

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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context){
                        return InicioSesion();
                      }
                  ));
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
      backgroundColor: Color.fromRGBO(0, 0, 98, 1),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Recupera tu contraseña", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: CupertinoTextField(
                  placeholder: "Correo",
                  placeholderStyle: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              SizedBox(height: 25,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: CupertinoTextField(
                  placeholder: "Confirmar correo",
                  placeholderStyle: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                mostrar_alerta("Se envio un correo");
              }, child: Text("Recuperar contraseña"),style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5)
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
