import 'dart:convert';

import 'package:cloud_notes/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Registrarse extends StatefulWidget {
  const Registrarse({Key? key}) : super(key: key);

  @override
  State<Registrarse> createState() => _RegistrarseState();
}

class _RegistrarseState extends State<Registrarse> {

  var c_correo = TextEditingController();
  var c_pass = TextEditingController();
  var c_usuario = TextEditingController();
  var c_edad = TextEditingController();

  String correo = '';
  String pass = '';
  String usuario = '';
  String edad = '';

  Future<void> guardar_datos(String correo, String pass,)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('correo', correo);
    await prefs.setString('pass', pass);
  }

  Future<void> registrar()async{
    var url = Uri.parse('https://xstracel.com.mx/dbcloudnotes/registrarse.php');
    var response = await http.post(url, body: {
      'correo': correo,
      'pass': pass,
      'usuario': usuario,
      'edad': edad
    }).timeout(Duration(seconds: 90));

    var respuesta = jsonDecode(response.body);

    print(response.body);

    if (respuesta["respuesta"] == '1') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', respuesta['id'].toString());
      await prefs.setString('usuario', respuesta['usuario'].toString());
      await prefs.setString('edad', respuesta['edad'].toString());

      guardar_datos(correo, pass);

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context){
            return new NotasPage();
          }), (route) => false);
    }else{
      print(respuesta['respuesta']);
    }
  }

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
                  Navigator.of(context).pop();
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
    return GestureDetector(
      onTap: (){
        final FocusScopeNode focus = FocusScope.of(context);
        if (!focus.hasPrimaryFocus && focus.hasFocus){
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 98, 1),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(25),
                /*decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),*/
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Cloud Notes", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
                        Image.asset("images/nube.png",width: 60,),
                        Column(
                          children: [],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text("Regístrate", style: TextStyle(fontSize: 30, color: Colors.white),),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: CupertinoTextField(
                        controller: c_correo,
                        placeholder: "Correo",
                        placeholderStyle: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: CupertinoTextField(
                        controller: c_pass,
                        obscureText: true,
                        placeholder: "Contraseña",
                        placeholderStyle: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: CupertinoTextField(
                        controller: c_usuario,
                        placeholder: "Nombre de usuario",
                        placeholderStyle: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: CupertinoTextField(
                        controller: c_edad,
                        placeholder: "Edad",
                        placeholderStyle: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: (){

                            FocusScope.of(context).unfocus();

                            correo = c_correo.text;
                            pass = c_pass.text;
                            usuario = c_usuario.text;
                            edad = c_edad.text;

                            if (correo == '' || pass == '' || usuario == '' || edad == ''){
                              mostrar_alerta("Debes llenar todos los datos");
                            }else{
                              registrar();
                            }
                          }, child: Text("Registrarse"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 84, vertical: 10)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
