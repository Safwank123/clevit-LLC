part of 'bottle_bloc.dart';

abstract class BottleState extends Equatable {
  const BottleState();

  @override
  List<Object> get props => [];
}

class BottleInitial extends BottleState {}

class BottleLoading extends BottleState {}

class BottleRefreshing extends BottleState {
  final List<Bottle> bottles;

  const BottleRefreshing({required this.bottles});

  @override
  List<Object> get props => [bottles];
}

class BottleLoaded extends BottleState {
  final List<Bottle> bottles;

  const BottleLoaded({required this.bottles});

  @override
  List<Object> get props => [bottles];
}

class BottleDetailsLoaded extends BottleState {
  final List<Bottle> bottles;
  final Bottle selectedBottle;

  const BottleDetailsLoaded({
    required this.bottles,
    required this.selectedBottle,
  });

  @override
  List<Object> get props => [bottles, selectedBottle];
}

class BottleError extends BottleState {
  final String message;

  const BottleError({required this.message});

  @override
  List<Object> get props => [message];
}