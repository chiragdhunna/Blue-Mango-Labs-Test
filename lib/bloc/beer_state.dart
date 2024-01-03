part of 'beer_bloc.dart';

sealed class BeerState {}

final class BeerInitial extends BeerState {}

final class BeerLoading extends BeerState {}

final class BeerLoaded extends BeerState {
  final List<dynamic> beers;
  BeerLoaded(this.beers);
}

final class BeerError extends BeerState {
  final String error;
  BeerError(this.error);
}
