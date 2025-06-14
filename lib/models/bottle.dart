
class Bottle {
  final int id;
  final String name;
  final String labelNumber;
  final BottleDetails details;
  final TastingNotes tastingNotes;
  final List<HistoryItem> history;

  Bottle({
    required this.id,
    required this.name,
    required this.labelNumber,
    required this.details,
    required this.tastingNotes,
    required this.history,
  });

  factory Bottle.fromJson(Map<String, dynamic> json) {
    return Bottle(
      id: json['id'],
      name: json['bottle_name'],
      labelNumber: json['label_number'],
      details: BottleDetails.fromJson(json['details']),
      tastingNotes: TastingNotes.fromJson(json['tasting_notes']),
      history: List<HistoryItem>.from(
          json['history'].map((x) => HistoryItem.fromJson(x))),
    );
  }
}

class BottleDetails {
  final String distillery;
  final String region;
  final String country;
  final String type;
  final String ageStatement;
  final String filled;
  final String bottled;
  final String caskNumber;
  final String abv;
  final String size;
  final String finish;

  BottleDetails({
    required this.distillery,
    required this.region,
    required this.country,
    required this.type,
    required this.ageStatement,
    required this.filled,
    required this.bottled,
    required this.caskNumber,
    required this.abv,
    required this.size,
    required this.finish,
  });

  factory BottleDetails.fromJson(Map<String, dynamic> json) {
    return BottleDetails(
      distillery: json['Distillery'],
      region: json['Region'],
      country: json['Country'],
      type: json['Type'],
      ageStatement: json['Age statement'],
      filled: json['Filled'],
      bottled: json['Bottled'],
      caskNumber: json['Cask number'],
      abv: json['ABV'],
      size: json['Size'],
      finish: json['Finish'],
    );
  }
}

class TastingNotes {
  final String videoUrl;
  final String expert;
  final List<String> nose;
  final List<String> palate;
  final List<String> finish;

  TastingNotes({
    required this.videoUrl,
    required this.expert,
    required this.nose,
    required this.palate,
    required this.finish,
  });

  factory TastingNotes.fromJson(Map<String, dynamic> json) {
    return TastingNotes(
      videoUrl: json['video_url'],
      expert: json['expert'],
      nose: List<String>.from(json['Nose']),
      palate: List<String>.from(json['Palate']),
      finish: List<String>.from(json['Finish']),
    );
  }
}

class HistoryItem {
  final String label;
  final String title;
  final List<String> description;
  final List<String> attachments;

  HistoryItem({
    required this.label,
    required this.title,
    required this.description,
    required this.attachments,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      label: json['label'],
      title: json['title'],
      description: List<String>.from(json['description']),
      attachments: List<String>.from(json['attachments']),
    );
  }
}