class Note {
  String? id;
  String? titulo;
  String? cuerpo;
  String? fecha;
  String? hora;

  Note(this.id, this.titulo, this.cuerpo, this.fecha,this.hora);

  Note.fromJson(Map<String, dynamic> json) {
      id = json['id'].toString();
      titulo = json['titulo'].toString();
      cuerpo = json['cuerpo'].toString();
      fecha = json['fecha'].toString();
      hora = json['hora'].toString();
  }
}