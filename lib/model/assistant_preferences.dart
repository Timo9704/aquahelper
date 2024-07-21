class AssistantPreferences {
  String useOwnData;
  String aquarium;
  String experienceLevel;
  String detailLevel;

  AssistantPreferences(
      this.useOwnData,
      this.aquarium,
      this.experienceLevel,
      this.detailLevel
  );

  factory AssistantPreferences.fromMap(Map<String, dynamic> json){
    return AssistantPreferences(
        json["useOwnData"],
        json["aquarium"],
        json["experienceLevel"],
        json["detailLevel"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'useOwnData': useOwnData,
      'aquarium': aquarium,
      'experienceLevel': experienceLevel,
      'detailLevel': detailLevel,
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'useOwnData': useOwnData,
      'aquarium': aquarium,
      'experienceLevel': experienceLevel,
      'detailLevel': detailLevel
    };
  }
}
