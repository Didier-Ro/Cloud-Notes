import 'dart:convert';
import 'package:cloud_notes/agregarnotas.dart';
import 'package:cloud_notes/editarnota.dart';
import 'package:cloud_notes/registros.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotasPage extends StatefulWidget {
  @override
  _NotasPageState createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {

  bool loading = true;
  List<Note> nts = [];


  Future<List<Note>> mostrar_notas() async{
    var url = Uri.parse('https://xstracel.com.mx/dbcloudnotes/mostrar_notas.php');
    var response = await http.post(url).timeout(Duration(seconds: 90));

    //print(response.body);
    final datos = jsonDecode(response.body);
    List<Note> notes = [];

    for(var datos in datos){
      notes.add(Note.fromJson(datos));
    }
    return notes;
  }

  void msm_BorrarNota(id, titulo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Borrar nota'),
          content: Text('¿Estás seguro de que quieres borrar esta nota?: '),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Borrar'),
              onPressed: () {
                setState(() {
                  eliminar_nota(id);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  Future eliminar_nota(id) async{

    var url = Uri.parse('https://xstracel.com.mx/dbcloudnotes/eliminar_notas.php');
    var response = await http.post(url, body: {'id': id}).timeout(Duration(seconds: 90));

    if(response.body == '1'){
      setState(() {
        loading = true;
        nts = [];
        mostrar_notas().then((value){
          setState(() {
            nts.addAll(value);
            loading = false;
          });
        });
      });
    }else{
      mostrar_alerta(response.body);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mostrar_notas().then((value){
      setState(() {
        nts.addAll(value);
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 98, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 98, 1),
        title: Text('Cloud Notes'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 98, 1),
              ),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                    ),
                    SizedBox(height: 10,),
                    Text("Didier Rojero", style: TextStyle(color: Colors.white, fontSize: 20),),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Usuario",),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text("Pagos",),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configuraciones",),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text("Cerrar Sesion",),
              onTap: (){

              },
            ),
          ],
        ),
      ),
      body: loading == true?
          const Center(
            child: CircularProgressIndicator(),
          )
        : nts.isEmpty ?
               Center(
            child: Text(
              'No hay notas creadas',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),
        itemCount: nts.length,
        itemBuilder: (BuildContext context, int index ) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context){
                    return EditarNota(nts[index].id!);
                  }
              )).then((value){
                setState(() {

                  loading = true;
                  nts = [];
                  mostrar_notas().then((value){
                    setState(() { //funciona para recargar las variables
                      nts.addAll(value);
                      loading = false;
                    });
                  });
                });
              });
            },
            onLongPress: (){
              msm_BorrarNota(nts[index].id, nts[index].titulo);
            },
            child: Card(
              margin: EdgeInsets.all(20),
              color: Colors.yellow[100],
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: ListView(
                    children: [
                      Text(nts[index].titulo!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Text(nts[index].fecha!),
                          SizedBox(width: 10,),
                          Text(nts[index].hora!),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text(nts[index].cuerpo!),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context){
                return AgregarNotas();
              }
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
