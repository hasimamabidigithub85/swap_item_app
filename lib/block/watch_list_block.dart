import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_list_app/block/watch_list_event.dart';
import 'package:swap_list_app/block/watch_list_state.dart';
import '../model/stock.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(WatchlistState([])) {

    on<LoadWatchlist>((event, emit) {
      emit(WatchlistState([
        Stock(name: "AAPL", price: 180),
        Stock(name: "GOOGL", price: 2800),
        Stock(name: "TSLA", price: 900),
        Stock(name: "AMZN", price: 3300),
      ]));
    });

    on<SwapItems>((event, emit) {
      final list = List<Stock>.from(state.stocks);

      if (event.fromIndex == event.toIndex) return;

      final temp = list[event.fromIndex];
      list[event.fromIndex] = list[event.toIndex];
      list[event.toIndex] = temp;

      emit(WatchlistState(list));
    });


    on<ReorderWatchlist>((event, emit) {
      final list = List<Stock>.from(state.stocks);

      int newIndex = event.newIndex;
      if (newIndex > event.oldIndex) newIndex -= 1;

      final item = list.removeAt(event.oldIndex);
      list.insert(newIndex, item);

      emit(WatchlistState(list));
    });


  }
}