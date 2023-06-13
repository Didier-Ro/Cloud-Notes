import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  String user_avatar = 'default_user.jpg';
  String nombre = '';
  String correo = '';
  String edad = '';

  Future<void> mostra_datos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      nombre = prefs.getString('usuario').toString();
      correo = prefs.getString('correo').toString();
      edad = prefs.getString('edad').toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mostra_datos();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 98, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 98, 1),
        title: Text("Perfil", style: TextStyle(fontSize: 30),),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 15,),
              ClipOval(
                child: Image.network('https://xstracel.com.mx/dbcloudnotes/imgperfil/'+user_avatar,fit: BoxFit.cover, width: 100, height: 100, color: Colors.red,),
              ),
              SizedBox(height: 30,),
              Text(nombre.toString(),style: TextStyle(color: Colors.white, fontSize: 25)),
              SizedBox(height: 30,),
              Text(correo.toString(),style: TextStyle(color: Colors.white, fontSize: 25)),
              SizedBox(height: 30,),
              Text('Edad: '+edad.toString(),style: TextStyle(color: Colors.white, fontSize: 25)),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){

              }, child: Text("Editar información"), style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10)
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
