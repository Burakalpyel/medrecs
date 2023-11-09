import 'package:flutter/material.dart';

class FilterScreen extends StatelessWidget {
  static const String routeName = "/filters";

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => FilterScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('History Filters')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "Category",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              const CustomCategoryFilter(
                  categories: ["User Access", "Injury", "Accident"]),
            ],
          ),
        ));
  }
}

class CustomCategoryFilter extends StatelessWidget {
  final List<String> categories;

  const CustomCategoryFilter({Key? key, required this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: ((context, index) {
        return Container(
          width: double.infinity,
        );
      }),
    );
  }
}
