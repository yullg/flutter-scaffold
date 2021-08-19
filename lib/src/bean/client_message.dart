class ClientMessage {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String? link;
  final DateTime time;

  ClientMessage({required this.id, required this.title, required this.summary, required this.content, this.link, required this.time});

  @override
  String toString() {
    return 'ClientMessage{id: $id, title: $title, summary: $summary, content: $content, link: $link, time: $time}';
  }
}

class ClientMessageStatistics {
  final int unreadCount;
  final ClientMessage? latestMessage;

  ClientMessageStatistics({required this.unreadCount, this.latestMessage});

  @override
  String toString() {
    return 'ClientMessageStatistics{unreadCount: $unreadCount, latestMessage: $latestMessage}';
  }
}
