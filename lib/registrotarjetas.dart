class Tarjeta{
  String? id = '';
  String? titular = '';
  String? numero = '';
  String? fecha = '';

  Tarjeta(this.id, this.titular, this.numero, this.fecha);

  Tarjeta.fromjson(Map<String, dynamic> json){
    id = json['id'].toString();
    titular = json['titular'].toString();
    numero = json['numero'].toString();
    fecha = json['fecha'].toString();
  }
}