class Meta {
  Meta({this.wordCount});

  int wordCount;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    wordCount: json['wordCount'],
  );

  Map<String, int> toJson() => {
    'wordCount': wordCount,
  };
}

class Word {
  Word({
    this.original,
    this.translations,
    this.isLearned,
    this.id = 'NO_SET_UP',
  });

  String id;
  String original;
  List<String> translations;
  int isLearned;

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    id: json['id'],
    original: json['original'],
    translations: json['translations'].split(';'),
    isLearned: json['isLearned'],
  );

  Map<String, dynamic> toJson() => {
    'original': original,
    'translations': translationsToString(),
    'isLearned': isLearned,
    'id': id,
  };

  String translationsToString() {
    var result = '';

    for(var i = 0; i < translations.length; i++) {
      if (i != translations.length - 1) {
        result += translations[i] + ';';
      } else {
        result += translations[i];
      }
    }

    return result;
  }

  @override
  String toString() {
    return '$original - ${translations.first}';
  }
}
