class News {
  final String date;
  final String text;

  News({required this.date, required this.text});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      date: json['date'],
      text: json['text'],
    );
  }
}