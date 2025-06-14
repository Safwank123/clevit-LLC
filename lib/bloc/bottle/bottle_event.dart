part of 'bottle_bloc.dart';

abstract class BottleEvent extends Equatable {
  const BottleEvent();

  @override
  List<Object> get props => [];
}

class FetchBottles extends BottleEvent {}

class FetchBottleDetails extends BottleEvent {
  final int id;

  const FetchBottleDetails(this.id);

  @override
  List<Object> get props => [id];
}

class RefreshBottles extends BottleEvent {}