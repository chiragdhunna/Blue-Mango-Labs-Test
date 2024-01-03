import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_mango_labs/bloc/beer_bloc.dart';
import 'package:blue_mango_labs/screens/detailsPage.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  String filterOption = 'No Filter';
  List<dynamic> beers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BeerBloc>(context).add(LoadBeerEvent());
  }

  void applyFilter(String filter) {
    BlocProvider.of<BeerBloc>(context).add(FilterBeerEvent(filter));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beer List'),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: SizedBox(
              width: 150,
              child: DropdownButton<String>(
                isExpanded: true,
                value: filterOption,
                onChanged: (String? newValue) {
                  setState(() {
                    filterOption = newValue!;
                  });
                  applyFilter(filterOption);
                },
                items: const <String>[
                  'No Filter',
                  'ABV High to Low',
                  'ABV Low to High',
                  'IBU High to Low',
                  'IBU Low to High',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<BeerBloc, BeerState>(
        listener: (context, state) {
          if (state is BeerLoaded) {
            setState(() {
              beers = state.beers;
              isLoading = false;
            });
          } else if (state is BeerError) {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: beers.length,
                itemBuilder: (context, index) {
                  final beer = beers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(beer: beer),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Image.network(
                        beer['image_url'],
                        fit: BoxFit.contain,
                        width: 60,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                      title: Text(beer['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ABV: ${beer['abv'] ?? 'N/A'}%'),
                          Text('IBU: ${beer['ibu'] ?? 'N/A'}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
