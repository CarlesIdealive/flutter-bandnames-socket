

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
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      name: obj.containsKey('name') ?  obj['name'] : 'no-name',
      votes: obj.containsKey('votes') ? obj['votes'] : 0
    );
  }


}