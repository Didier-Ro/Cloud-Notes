import 'dart:convert';
import 'package:cloud_notes/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({Key? key}) : super(key: key);

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {

  var c_edad = TextEditingController();
  var c_usuario = TextEditingController();
  var c_pass = TextEditingController();
  var c_confirm_pass = TextEditingController();

  String user_avatar = '';
  String? usuario = '';
  String? edad = '';
  String? pass = '';
  String? confirm_pass = '';
  String id = '';

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
        //imagen = File(pickedFile.path);
        //subirImagen();
        cortar(File(pickedFile.path));
      }else{
        print("No se encontró nada");
      }
    });
  }

  cortar(picked) async{
    CroppedFile? cortado = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1)
    );

    if(cortado != null){
      setState(() {
        imagen = File(cortado.path);
      });
    }
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

  Future<void> editar_datos() async{
    var url = Uri.parse('https://xstracel.com.mx/dbcloudnotes/editar_datos.php');
    var response = await http.post(url, body: {
      'id': id,
      'pass': pass,
      'usuario': usuario,
      'edad': edad
    }).timeout(Duration(seconds: 90));

    var respuesta = jsonDecode(response.body);

    if(respuesta['respuesta'] == '1'){
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('id', respuesta['id'].toString());
      await prefs.setString('pass', respuesta['pass'].toString());
      await prefs.setString('usuario', respuesta['usuario'].toString());
      await prefs.setString('edad', respuesta['edad'].toString());
      await prefs.setString('img', respuesta['img'].toString());

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context){
            return new NotasPage();
          }), (route) => false);
    }
    print('resposnse '+response.body);
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
          editar_datos();
          print("Se subió la imagen correctamente");
        }else{
          print(value.toString());
        }
      });

    }catch(e){
      print(e.toString());
    }
  }

  Future <void> mostra_datos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      id = prefs.getString('id').toString();
      user_avatar = prefs.getString('img').toString();
      c_usuario.text = prefs.getString('usuario').toString();
      c_edad.text = prefs.getString('edad').toString();
      c_pass.text = prefs.getString('pass').toString();
      c_confirm_pass.text = prefs.getString('pass').toString();
    });
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
    editar_datos().then((value){
      setState(() {
        SmartDialog.dismiss();
      });
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
    return GestureDetector(
      onTap: (){
        final FocusScopeNode focus = FocusScope.of(context);
        if(!focus.hasPrimaryFocus && focus.hasFocus){
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Container(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(0, 0, 98, 1),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(0, 0, 98, 1),
            title: Text('Editar Perfil'),
          ),
          body: ListView(
            children: [
              Center(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Text("Usuario", style: TextStyle(color: Colors.yellow, fontSize: 16),),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60),
                        child: CupertinoTextField(
                          controller: c_usuario,
                          placeholderStyle: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("Contraseña", style: TextStyle(color: Colors.yellow, fontSize: 16),),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60),
                        child: CupertinoTextField(
                          controller: c_pass,
                          obscureText: true,
                          placeholderStyle: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("Confirmar contraseña", style: TextStyle(color: Colors.yellow, fontSize: 16),),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60),
                        child: CupertinoTextField(
                          controller: c_confirm_pass,
                          obscureText: true,
                          placeholderStyle: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("Edad", style: TextStyle(color: Colors.yellow, fontSize: 16),),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60),
                        child: CupertinoTextField(
                          controller: c_edad,
                          placeholderStyle: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                      ),
                      SizedBox(height: 20,),
                      imagen == null ? Center() : Image.file(imagen!),
                      SizedBox(height: 15,),
                      ElevatedButton(onPressed: (){
                        usuario = c_usuario.text;
                        pass = c_pass.text;
                        confirm_pass = c_confirm_pass.text;
                        edad = c_edad.text;

                        if(usuario == '' || pass == '' || confirm_pass == '' || edad == ''){
                          mostrar_alerta("Uno de los datos está vacio");
                        }else{
                          if(pass == confirm_pass){
                            _showLoading();
                          }else{
                            mostrar_alerta("Las contraseñas no coinciden");
                          }
                        }
                      }, child: Text("Cambiar"), style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10)
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
