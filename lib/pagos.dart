import 'package:cloud_notes/notes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  var c_titular = TextEditingController();
  var c_numero = TextEditingController();
  var c_cvv = TextEditingController();
  var c_fecha = TextEditingController();

  String? id = '';
  String? titular = '';
  String? numero = '';
  String? cvv = '';
  String? fecha = '';

  Future<void> obtener_id() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = await prefs.getString('id').toString();
  }

  Future<void> agregar_tarjeta() async{
    var url = Uri.parse('https://xstracel.com.mx/dbcloudnotes/agregar_tarjeta.php');
    var response = await http.post(url, body: {
      'id':id,
      'titular': titular,
      'numero': numero,
      'cvv': cvv,
      'fecha': fecha
    }).timeout(Duration(seconds: 90));

    if(response.body == '1'){
      mostrar_alerta('El metódo de pago se guardo exitosamente');
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
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (BuildContext context){
                        return new NotasPage();
                      }), (route) => false);

                  c_titular.text = '';
                  c_numero.text = '';
                  c_cvv.text = '';
                  c_fecha.text = '';
                },
                child: Text("Aceptar"),
              ),
            ],
          );
        }
    );
  }

  mostrar_alerta_regular(mensaje){
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
  void initState() {
    // TODO: implement initState
    super.initState();
    obtener_id();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 93, 1),
        title: Text('Nuevo método de pago'),
      ),
      body: GestureDetector(
        onTap: (){
          final FocusScopeNode focus = FocusScope.of(context);
          if(!focus.hasPrimaryFocus && focus.hasFocus){
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Titular de la tarjeta',
                    ),
                    controller: c_titular,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Número de la tarjeta',
                    ),
                    controller: c_numero,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            labelText: 'Fecha de expiración',
                          ),
                          controller: c_fecha,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                          ),
                          controller: c_cvv,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      titular = c_titular.text;
                      numero = c_numero.text;
                      cvv = c_cvv.text;
                      fecha = c_fecha.text;

                      if(titular == '' || numero == '' || cvv == '' || fecha == ''){
                        mostrar_alerta_regular('Debes llenar todos los datos');
                      }else{
                        agregar_tarjeta();
                      }
                    },
                    child: Text('Guardar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}