import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/record_extra.dart';

/// Ported from `App.extraData` + `getExtra(entityKey,id)` — lazily seeds
/// each record with a plausible attachment/comment on first view (70%/60%
/// chance respectively, matching the prototype), then holds whatever the
/// user adds afterward.
class RecordExtraNotifier extends Notifier<Map<String, RecordExtra>> {
  final _rng = Random();
  int _uid = 500000;

  @override
  Map<String, RecordExtra> build() => {};

  String _recordKey(String entityKey, int id) => '$entityKey:$id';

  RecordExtra of(String entityKey, int id) {
    final key = _recordKey(entityKey, id);
    final existing = state[key];
    if (existing != null) return existing;

    final seeded = RecordExtra(
      attachments: _rng.nextDouble() < 0.7
          ? [
              Attachment(
                id: ++_uid,
                name: [
                  'Signed_Agreement.pdf', 'Spec_Sheet.pdf', 'Photo_Evidence.jpg', 'Terms.docx',
                ][_rng.nextInt(4)],
                size: '${80 + _rng.nextInt(2320)} KB',
                uploadedBy: 'Sarah Alvarez',
                date: DateTime.now().subtract(Duration(days: _rng.nextInt(60))),
              ),
            ]
          : [],
      comments: _rng.nextDouble() < 0.6
          ? [
              Comment(
                id: ++_uid,
                author: 'Sarah Alvarez',
                date: DateTime.now().subtract(Duration(days: _rng.nextInt(20))),
                text: [
                  'Please confirm quantity with the warehouse before proceeding.',
                  'Customer requested expedited handling on this one.',
                  'Verified against contract terms — looks good.',
                  'Following up with the counterpart for confirmation.',
                ][_rng.nextInt(4)],
              ),
            ]
          : [],
    );
    
    Future.microtask(() {
      if (state[key] == null) {
        state = {...state, key: seeded};
      }
    });
    
    return seeded;
  }

  void addAttachment(String entityKey, int id, String name) {
    final extra = of(entityKey, id);
    extra.attachments.add(Attachment(
      id: ++_uid, name: name, size: '${50 + _rng.nextInt(2950)} KB',
      uploadedBy: 'Sarah Alvarez', date: DateTime.now(),
    ));
    state = {...state};
  }

  void removeAttachment(String entityKey, int id, int attachmentId) {
    of(entityKey, id).attachments.removeWhere((a) => a.id == attachmentId);
    state = {...state};
  }

  void addComment(String entityKey, int id, String text) {
    of(entityKey, id).comments.add(Comment(id: ++_uid, author: 'Sarah Alvarez', date: DateTime.now(), text: text));
    state = {...state};
  }

  void addTimelineEvent(String entityKey, int id, String title, {String icon = 'activity'}) {
    of(entityKey, id).timelineExtra.add(TimelineEvent(title: title, who: 'Sarah Alvarez', date: DateTime.now(), icon: icon));
    state = {...state};
  }
}

final recordExtraProvider = NotifierProvider<RecordExtraNotifier, Map<String, RecordExtra>>(
  RecordExtraNotifier.new,
);
