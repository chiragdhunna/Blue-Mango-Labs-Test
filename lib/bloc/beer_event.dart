part of 'beer_bloc.dart';

sealed class BeerEvent {}

class LoadBeerEvent extends BeerEvent {}

class FilterBeerEvent extends BeerEvent {
  final String filterOption;
  FilterBeerEvent(this.filterOption);
}
