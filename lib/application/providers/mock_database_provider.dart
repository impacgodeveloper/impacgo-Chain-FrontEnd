import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/mock/mock_database.dart';

/// Ported from `DB` + `initApp()` calling `genMasterData()`/
/// `genTransactional()` once on boot. `Provider` mirrors that: the dataset
/// is generated once and kept for the app's lifetime.
final mockDatabaseProvider = Provider<MockDatabase>((ref) {
  return MockDatabase.generate();
});

/// Bumped after any insert/update/delete so screens watching a table
/// re-read it. Ported from the prototype's `rerenderList(key)` /
/// `renderDrawer()` re-render-on-mutation pattern, adapted to Riverpod
/// (the `MockDatabase` instance itself is mutated in place; this counter is
/// what widgets actually watch to know to rebuild).
final mockDatabaseRevisionProvider = StateProvider<int>((ref) => 0);

void bumpMockDatabaseRevision(WidgetRef ref) {
  ref.read(mockDatabaseRevisionProvider.notifier).state++;
}
