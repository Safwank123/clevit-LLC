import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/bottle.dart';
import '../../repositories/bottle_repository.dart';

part 'bottle_event.dart';
part 'bottle_state.dart';

class BottleBloc extends Bloc<BottleEvent, BottleState> {
  final BottleRepository repository;

  BottleBloc({required this.repository}) : super(BottleInitial()) {
    on<FetchBottles>(_onFetchBottles);
    on<FetchBottleDetails>(_onFetchBottleDetails);
    on<RefreshBottles>(_onRefreshBottles);
  }

  Future<void> _onFetchBottles(
    FetchBottles event,
    Emitter<BottleState> emit,
  ) async {
    emit(BottleLoading());
    try {
      final bottles = await repository.fetchBottles();
      emit(BottleLoaded(bottles: bottles));
    } catch (e) {
      emit(BottleError(message: e.toString()));
    }
  }

  Future<void> _onFetchBottleDetails(
    FetchBottleDetails event,
    Emitter<BottleState> emit,
  ) async {
    emit(BottleLoading());
    try {
      final bottle = await repository.fetchBottleDetails(event.id);
      if (state is BottleLoaded) {
        emit(BottleDetailsLoaded(
          bottles: (state as BottleLoaded).bottles,
          selectedBottle: bottle,
        ));
      } else {
        emit(BottleDetailsLoaded(
          bottles: [],
          selectedBottle: bottle,
        ));
      }
    } catch (e) {
      emit(BottleError(message: e.toString()));
    }
  }

  Future<void> _onRefreshBottles(
    RefreshBottles event,
    Emitter<BottleState> emit,
  ) async {
    if (state is BottleLoaded || state is BottleRefreshing) {
      final currentBottles = state is BottleLoaded 
          ? (state as BottleLoaded).bottles 
          : (state as BottleRefreshing).bottles;
      
      emit(BottleRefreshing(bottles: currentBottles));
      try {
        final bottles = await repository.fetchBottles();
        emit(BottleLoaded(bottles: bottles));
      } catch (e) {
        emit(BottleError(message: e.toString()));
      }
    }
  }
}