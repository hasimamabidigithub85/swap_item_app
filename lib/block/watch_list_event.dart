abstract class WatchlistEvent {}

class LoadWatchlist extends WatchlistEvent {}

class ReorderWatchlist extends WatchlistEvent {
  final int oldIndex;
  final int newIndex;

  ReorderWatchlist(this.oldIndex, this.newIndex);
}
class SwapItems extends WatchlistEvent {
  final int fromIndex;
  final int toIndex;

  SwapItems(this.fromIndex, this.toIndex);
}