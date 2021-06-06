class TaskEntry {
  TaskEntry();

  String id = '';
  String title = '';
  String description = '';
  int estimateMin = 0;

  bool isActive = false;
  bool isEdit = false;
  bool isPreview = false;

  Map toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'estimateMin': estimateMin,
      };

  TaskEntry.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        estimateMin = json['estimateMin'];

  toString() {
    return '[TaskEntry]\n#id: $id\n#title: $title\n#description: $description\n#estimateMin: $estimateMin';
  }

  TaskEntry fromInput(String input) {
    this.title = '';
    this.description = '';
    this.estimateMin = 0;
    if (input.isEmpty) return this;

    var lines = input.split('\n');
    var firstlineSplit = lines[0].trim().split(' ');
    var exp = RegExp(r"(\d+)m");
    try {
      var match =
          exp.allMatches(firstlineSplit[firstlineSplit.length - 1]).first;
      var min = match.group(1);
      this.estimateMin = int.parse(min!) | 0;
      print(match.end);
      this.title = lines[0].trim().substring(0, lines[0].length - match.end);
    } catch (e) {
      this.estimateMin = 0;
      this.title = lines[0];
    }

    for (var i = 0; i < lines.length; i++) {
      if (i == 0) continue;
      this.description += lines[i] + '\n';
    }
    if (this.description.endsWith('\n'))
      this.description =
          this.description.substring(0, this.description.length - 1);
    return this;
  }

  String toInput() {
    if (this.title.isEmpty) return '';
    return this.title +
        (this.estimateMin != 0 ? '${this.estimateMin}m' : '') +
        (this.description.isEmpty ? '' : '\n${this.description}');
  }
}
