import 'package:flutter/material.dart';

class AllRoutesPage extends StatelessWidget {
  final List<Map<String, dynamic>> routes = [
    {
      'title': '1. Ennore Bus Stand',
      'stops': [
        {'name': 'Ennore Bus Stand', 'time': '5.45 am'},
        {'name': 'Ernavur Anna Nagar', 'time': '5.48'},
        {'name': 'Lift Gate', 'time': '5.54'},
        {'name': 'Wimco Nagar', 'time': '6.00'},
        {'name': 'Thiruvottiyur Bus Terminal', 'time': '6.01'},
        {'name': 'Periar Nagar', 'time': '6.02'},
        {'name': 'Vellayan Chettiyar School', 'time': '6.03'},
        {'name': 'Thiruvottiyur Market', 'time': '6.04'},
        {'name': 'Theradi', 'time': '6.05'},
        {'name': 'Raja Kadai', 'time': '6.06'},
        {'name': 'Ellaiyamman Kovil', 'time': '6.07'},
        {'name': 'Kaladipet Market', 'time': '6.08'},
        {'name': 'Thangal', 'time': '6.09'},
        {'name': 'Tollgate', 'time': '6.11'},
        {'name': 'Kasimedu Signal', 'time': '6.13'},
        {'name': 'Kalmandapam', 'time': '6.16'},
        {'name': 'Clive Battery', 'time': '6.20'},
        {'name': 'College Campus', 'time': '7.40 am'},
      ],
      'via': 'Non Stop Beach station, Parrys, Central, Koyambedu Roundtana, Poonamallee Bye pass'
    },
    {
      'title': '1C. Tollgate (Thiruvotriyur)',
      'stops': [
        {'name': 'Lakshmi Koil', 'time': '6.05 am'},
        {'name': 'Tondiarpet Depot', 'time': '6.06'},
        {'name': 'Kasimedu', 'time': '6.10'},
        {'name': 'Kasimedu Petrol Bunk', 'time': '6.11'},
        {'name': 'Kalmandapam Police Station', 'time': '6.13'},
        {'name': "ST Anne's School", 'time': '6.14'},
        {'name': 'Royapuram Bridge', 'time': '6.16'},
        {'name': 'Beach Station', 'time': '6.20'},
        {'name': 'Annamalai Mandram', 'time': '6.23'},
        {'name': 'GH (Rajiv Gandhi Hospital)', 'time': '6.25'},
        {'name': 'Everest Hotel', 'time': '6.27'},
        {'name': 'Neyveli House', 'time': '6.31'},
        {'name': 'KMC', 'time': '6.32'},
        {'name': 'College Campus', 'time': '7.40 am'},
      ],
      'via': 'Non stop: Koyambedu Roundtana, Poonamallee Bye pass'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Routes'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  SizedBox(height: 10),
                  ...route['stops'].map<Widget>((stop) {
                    return ListTile(
                      leading: Icon(Icons.directions_bus, color: Colors.teal),
                      title: Text(stop['name']),
                      trailing: Text(
                        stop['time'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  Divider(),
                  Row(
                    children: [
                      Icon(Icons.alt_route, color: Colors.orange),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Via: ${route['via']}',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
