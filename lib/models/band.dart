

class Band {
  String id;
  String name;
  int votes;

  Band({
    required this.id,
    required this.name,
    this.votes = 0
  });

  // Recibe un Mapa con las llaves de tipo String y cualqir cosa (dynamic)
  factory Band.fromMap( Map<String, dynamic> obj)  {
    return Band(
      id: obj['id'],
      name: obj['name'],
      votes: obj['votes']
    );
  }


}