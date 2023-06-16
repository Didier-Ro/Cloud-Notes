import 'dart:convert';

import 'package:cloud_notes/notes.dart';
import 'package:cloud_notes/recuperarpass.dart';
import 'package:cloud_notes/registrarse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({Key? key}) : super(key: key);

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {

  var c_correo = TextEditingController();
  var c_pass = TextEditingController();

  String correo = '';
  String pass = '';

  Future<void> guardar_datos(String correo, String pass) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('correo', correo);
    await prefs.setString('pass', pass);
  }

  Future<void> enviar_datos() async{
    var url = Uri.parse('https://xstracel.com.mx/dbcloudnotes/iniciar_sesion.php');
    var response = await http.post(url, body: {
      'correo': correo,
      'pass': pass
    }).timeout(Duration(seconds: 90));

    var respuesta = jsonDecode(response.body);

    if(respuesta["respuesta"] == '1'){
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('id', respuesta['id'].toString());
      await prefs.setString('usuario', respuesta['usuario'].toString());
      await prefs.setString('edad', respuesta['edad'].toString());
      await prefs.setString('img', respuesta['img'].toString());

      guardar_datos(correo, pass);

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context){
            return new NotasPage();
          }), (route) => false);
    }else{
      print(response.body);
    }
    if (respuesta['respuesta'] == 'Hubo un error'){
      mostrar_alerta('Correo o contraseña inválidos');
    }
  }

  Future<void> ver_datos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    correo = (await prefs.getString('correo'))!;
    pass = (await prefs.getString('pass'))!;

    if(correo != null){
      if(correo != '' ){
        enviar_datos();
      }
      else{
        correo = '';
        pass = '';
      }
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

  void _showLoading() async {
    setState(() {
      SmartDialog.showLoading();
    });
    enviar_datos().then((value){
      setState(() {
        SmartDialog.dismiss();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ver_datos();
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
                    Text("Iniciar Sesión", style: TextStyle(fontSize: 30, color: Colors.white),),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: (){

                            FocusScope.of(context).unfocus();

                            correo = c_correo.text;
                            pass = c_pass.text;

                            if(correo == "" || pass == ""){
                              mostrar_alerta("Debes llenar todos los datos");
                            }else{
                              _showLoading();
                            }

                          }, child: Text("Iniciar Sesión"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10)
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text("¿Olvidaste tu contraseña?", style: TextStyle(color: Colors.white, fontSize: 18),),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context){
                              return Recuperar();
                            }
                        ));
                      },
                      child: Text("Presiona aquí", style: TextStyle(color: Colors.yellow, fontSize: 16),),
                    ),
                    SizedBox(height: 15,),
                    Text("¿Nuevo en Cloud Notes?", style: TextStyle(color: Colors.white, fontSize: 18),),
                    SizedBox(height: 5,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context){
                              return Registrarse();
                            }
                        ));
                      },
                      child: Text("Regístrate", style: TextStyle(color: Colors.yellow, fontSize: 16),),
                    )
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
