class WordRequestiModel {
  Correct? correct;
  Correct? wrong;

  WordRequestiModel({this.correct, this.wrong});

  WordRequestiModel.fromJson(Map<String, dynamic> json) {
    correct =
        json['correct'] != null ? new Correct.fromJson(json['correct']) : null;
    wrong = json['wrong'] != null ? new Correct.fromJson(json['wrong']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.correct != null) {
      data['correct'] = this.correct!.toJson();
    }
    if (this.wrong != null) {
      data['wrong'] = this.wrong!.toJson();
    }
    return data;
  }
}

class Correct {
  String? word;
  String? localWord;
  String? type;
  String? meaning;
  String? image;

  Correct({this.word, this.localWord, this.type, this.meaning, this.image});

  Correct.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    localWord = json['local_word'];
    type = json['type'];
    meaning = json['meaning'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['local_word'] = this.localWord;
    data['type'] = this.type;
    data['meaning'] = this.meaning;
    data['image'] = this.image;
    return data;
  }
}