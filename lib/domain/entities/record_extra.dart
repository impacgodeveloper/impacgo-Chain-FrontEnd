/// Ported from `App.extraData[key]` — the per-record attachments/comments/
/// timeline data not present on the record itself.
class Attachment {
  Attachment({
    required this.id,
    required this.name,
    required this.size,
    required this.uploadedBy,
    required this.date,
  });

  final int id;
  final String name;
  final String size;
  final String uploadedBy;
  final DateTime date;
}

class Comment {
  Comment({required this.id, required this.author, required this.date, required this.text});

  final int id;
  final String author;
  final DateTime date;
  final String text;
}

class TimelineEvent {
  TimelineEvent({
    required this.title,
    required this.who,
    required this.date,
    this.icon = 'activity',
  });

  final String title;
  final String who;
  final DateTime date;
  final String icon;
}

/// Ported from `getExtra(entityKey,id)`'s return shape.
class RecordExtra {
  RecordExtra({List<Attachment>? attachments, List<Comment>? comments, List<TimelineEvent>? timelineExtra})
      : attachments = attachments ?? [],
        comments = comments ?? [],
        timelineExtra = timelineExtra ?? [];

  final List<Attachment> attachments;
  final List<Comment> comments;
  final List<TimelineEvent> timelineExtra;
}
