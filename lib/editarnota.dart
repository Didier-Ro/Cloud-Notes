import 'dart:convert';
import 'package:cloud_notes/notes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditarNota extends StatefulWidget {
  String id;
  EditarNota(this.id, {Key? key}) : super(key: key);

  @override
  State<EditarNota> createState() => _EditarNotaState();
}

class _EditarNotaState extends State<EditarNota> {

  var c_titulo = TextEditingController();
  var c_cuerpo = TextEditingController();

  String? usuario;
  String? titulo = "";
  String? cuerpo = "";

  editar_nota()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      usuario = prefs.getString('id');
      print(usuario);
    });

    var url = Uri.parse("https://xstracel.com.mx/dbcloudnotes/editar_nota.php");
    var response = await http.post(url, body: {
      'id': widget.id,
      'titulo': titulo,
      'cuerpo': cuerpo
    }).timeout(Duration(seconds: 90));

    if (response.body == '1'){
      Navigator.of(context).pop();
      c_titulo.text = "";
      c_cuerpo.text = "";
    }else{
      mostrar_alerta(response.body);
    }
  }

  Future<void> mostrar_nota()async{
    var url = Uri.parse("https://xstracel.com.mx/dbcloudnotes/ver_nota.php");
    var response = await http.post(url, body: {
      'id': widget.id
    }).timeout(Duration(seconds: 90));

    var datos = jsonDecode(response.body);

    c_titulo.text = datos["titulo"].toString();
    c_cuerpo.text = datos["cuerpo"].toString();
  }

  mostrar_alerta(mensaje){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Amazon"),
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
    editar_nota().then((value){
      setState(() {
        SmartDialog.dismiss();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mostrar_nota();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 98, 1),
        title: Text("Nota",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
      ),
      body: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: c_titulo,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Título",
                ),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: TextField(
                  controller: c_cuerpo,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tú nota",
                  ),
                ),
              ),
            ],
          )
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          titulo = c_titulo.text;
          cuerpo = c_cuerpo.text;

          if(c_titulo == "" || c_cuerpo ==""){
            mostrar_alerta("Debes crear un título y/o contenido");
          }else{
            _showLoading();
          }
        },
        label: Text("Guardar"),
        icon: Icon(Icons.save),
      ),
    );
  }
}
