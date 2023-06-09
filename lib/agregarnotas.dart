import 'package:cloud_notes/notes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AgregarNotas extends StatefulWidget {
  const AgregarNotas({Key? key}) : super(key: key);

  @override
  State<AgregarNotas> createState() => _AgregarNotasState();
}

class _AgregarNotasState extends State<AgregarNotas> {

  var c_titulo = TextEditingController();
  var c_cuerpo = TextEditingController();

  String? titulo = "";
  String? cuerpo = "";

  subir_nota() async{
    var url = Uri.parse('https://xstracel.com.mx/dbcloudnotes/guardar_nota.php');
    var response = await http.post(url, body: {
      'titulo': titulo,
      'cuerpo': cuerpo
    }).timeout(Duration(seconds: 90));

    if(response.body == '1'){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context){
            return new NotasPage();
          }), (route) => false);
      c_titulo.text = "";
      c_cuerpo.text = "";
    }else{
      mostrar_alerta(response.body);
    }
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
    subir_nota().then((value){
      setState(() {
        SmartDialog.dismiss();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 98, 1),
        title: Text("Agregar Nota",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
      ),
      body: GestureDetector(
        onTap: (){
          final FocusScopeNode focus = FocusScope.of(context);
          if(!focus.hasPrimaryFocus && focus.hasFocus){
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
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
              )
            ],
          ),
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
