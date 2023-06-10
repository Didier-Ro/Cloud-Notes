import 'package:cloud_notes/registrarse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
                        controller: c_correo,
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


                          }, child: Text("Iniciar Sesión"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10)
                          ),
                        ),
                      ],
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
