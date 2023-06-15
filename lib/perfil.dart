import 'package:cloud_notes/editar_perfil.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  String id = '';
  String user_avatar = '';
  String nombre = '';
  String correo = '';
  String edad = '';

  File? imagen = null;
  final picker = ImagePicker();
  Dio dio = new Dio();

  selinmagen(opc) async{
    var pickedFile;

    if(opc ==1){
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    }else{
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      if(pickedFile != null){
        imagen = File(pickedFile.path);
        subirImagen();
        //cortar(File(pickedFile.path));
      }else{
        print("No se encontró nada");
      }
    });
  }

  seleccionar(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      selinmagen(1);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1, color: Colors.grey)
                          )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Tomar una foto', style: TextStyle(
                                fontSize: 16
                            ),),
                          ),
                          Icon(Icons.camera_alt, color: Colors.blue,)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      selinmagen(2);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1, color: Colors.grey)
                          )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Seleccionar de Galeria', style: TextStyle(
                                fontSize: 16
                            ),),
                          ),
                          Icon(Icons.image, color: Colors.blue,)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Cancelar', style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                          ),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<void> subirImagen()async{
    try{
      String filename = imagen!.path.split('/').last;
      FormData formData = FormData.fromMap({
        'id': id,
        'file': await MultipartFile.fromFile(
            imagen!.path, filename: filename
        )
      });
      await dio.post('https://xstracel.com.mx/dbcloudnotes/subir_imagen.php',
          data: formData).then((value){
        if(value.toString() == '1'){
          print("Se subió la imagen correctamente");
        }else{
          print(value.toString());
        }
      });

    }catch(e){
      print(e.toString());
    }
  }


  Future<void> mostra_datos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      id = prefs.getString('id').toString();
      nombre = prefs.getString('usuario').toString();
      correo = prefs.getString('correo').toString();
      edad = prefs.getString('edad').toString();
      user_avatar = prefs.getString('img').toString();
    });
    print(id);
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
              GestureDetector(
                onTap: (){
                  seleccionar();
                },
                child: ClipOval(
                  child: Image.network('https://xstracel.com.mx/dbcloudnotes/imgperfil/'+user_avatar,fit: BoxFit.cover, width: 100, height: 100,),
                ),
              ),
              SizedBox(height: 30,),
              Text(nombre.toString(),style: TextStyle(color: Colors.white, fontSize: 25)),
              SizedBox(height: 30,),
              Text(correo.toString(),style: TextStyle(color: Colors.white, fontSize: 25)),
              SizedBox(height: 30,),
              Text('Edad: '+edad.toString(),style: TextStyle(color: Colors.white, fontSize: 25)),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context){
                      return EditarPerfil();
                    }
                ));
              }, child: Text("Editar información"), style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10)
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
