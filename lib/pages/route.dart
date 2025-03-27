import 'package:flutter/material.dart';
import 'live_tracking.dart'; // Importing the Live Tracking page

class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final Map<String, List<String>> busRoutes = {
    "1. Ennore Bus Stand - 5.45 am": [
      "Ennore Bus Stand - 5.45 am",
      "Ernavur Anna Nagar - 5.48",
      "College Campus - 7.40 am"
    ],
    "2. Tondiarpet": [
      "Tondiarpet Mani Cycle Shop - 6.10 am",
      "Maharani (Singapore Shoppee) - 6.13",
      "College Campus - 7.40 am"
    ],
  };

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade900, Colors.purple.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),

              // 🏛 College Name - Large, Bold
              Text(
                "Rajalakshmi Engineering College",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // 🚧 Metro Work Alert (Centered)
              Center(
                child: Container(
                  padding: EdgeInsets.all(14),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.shade700.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Keeps the container size compact
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "⚠ Metro Work Alert: Some boarding points skipped (Routes 27 & 27C). No buses via Poonamallee.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 🔍 Search Bar
              TextField(
                onChanged: (query) {
                  setState(() {
                    searchQuery = query.toLowerCase();
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search for a bus stop...",
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.purple.shade700,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 🚌 Enlarged Bus Schedule
              _buildLargeInfoCard(Icons.directions_bus, "Morning to College", "131 buses in All routes"),
              _buildLargeInfoCard(Icons.wb_sunny_rounded, "Forenoon to College", "6 buses in Main routes"),
              _buildLargeInfoCard(Icons.schedule, "Return after 3:45 PM", "125 buses in All routes"),
              _buildLargeInfoCard(Icons.nightlife, "Return after 5:00 PM", "6 buses in Main routes"),
              _buildLargeInfoCard(Icons.night_shelter, "Return after 7:20 PM", "6 buses in Main routes"),

              SizedBox(height: 30),

              // 📍 Bus Routes List
              Expanded(
                child: ListView(
                  children: busRoutes.keys.where((busName) {
                    return searchQuery.isEmpty ||
                        busName.toLowerCase().contains(searchQuery) ||
                        busRoutes[busName]!.any((stop) => stop.toLowerCase().contains(searchQuery));
                  }).map((busName) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        color: Colors.white,
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueGrey.shade800,
                            child: Icon(Icons.directions_bus, color: Colors.white),
                          ),
                          title: Text(
                            busName,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo.shade900),
                          ),
                          children: busRoutes[busName]!
                              .map((stop) => ListTile(
                                    title: Text(stop, style: TextStyle(color: Colors.black87)),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 20),

              // 📍 Live Location Button (Enlarged, Centered)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LiveTrackingPage()), // Navigate to Live Tracking Page
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Enlarged Button
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent.shade700, Colors.deepPurpleAccent.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.shade700.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "📍 Live Location",
                      style: TextStyle(
                        fontSize: 20, // Larger Font Size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 🏷 Enlarged Info Cards
  Widget _buildLargeInfoCard(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(vertical: 12),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueGrey.shade800,
              child: Icon(icon, color: Colors.white, size: 35),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
