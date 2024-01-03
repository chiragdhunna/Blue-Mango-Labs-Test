import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';

part 'beer_event.dart';
part 'beer_state.dart';

Future<List<dynamic>> fetchBeerData() async {
  final response =
      await http.get(Uri.parse('https://api.punkapi.com/v2/beers'));

  if (response.statusCode == 200) {
    final List<dynamic> beerData = json.decode(response.body);
    return beerData;
  } else {
    throw Exception('Failed to load beer data');
  }
}

List<dynamic> filterBeers(List<dynamic> beers, String filterOption) {
  switch (filterOption) {
    case 'ABV High to Low':
      return beers.where((beer) => beer['abv'] != null).toList()
        ..sort((a, b) => b['abv'].compareTo(a['abv']));
    case 'ABV Low to High':
      return beers.where((beer) => beer['abv'] != null).toList()
        ..sort((a, b) => a['abv'].compareTo(b['abv']));
    case 'IBU High to Low':
      return beers.where((beer) => beer['ibu'] != null).toList()
        ..sort((a, b) => b['ibu'].compareTo(a['ibu']));
    case 'IBU Low to High':
      return beers.where((beer) => beer['ibu'] != null).toList()
        ..sort((a, b) => a['ibu'].compareTo(b['ibu']));
    default:
      return beers;
  }
}

class BeerBloc extends Bloc<BeerEvent, BeerState> {
  BeerBloc() : super(BeerInitial()) {
    on<LoadBeerEvent>((event, emit) async {
      try {
        final beers = await fetchBeerData();
        emit(BeerLoaded(beers));
      } catch (error) {
        emit(BeerError('Failed to load data: $error'));
      }
    });

    on<FilterBeerEvent>((event, emit) async {
      try {
        final beers = await fetchBeerData();
        final filteredBeers = filterBeers(beers, event.filterOption);
        emit(BeerLoaded(filteredBeers));
      } catch (error) {
        emit(BeerError('Failed to filter data: $error'));
      }
    });
  }
}
