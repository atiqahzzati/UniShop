import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminHomeReport.dart';
import 'package:fluttercalendar_app/students/view/adminCreateTrackingScreen.dart';
import 'package:fluttercalendar_app/students/view/adminReviewApplicationScreen.dart';
import 'package:fluttercalendar_app/students/view/chatScreen.dart';
import 'package:fluttercalendar_app/students/view/studenTutorRegisterListScreen.dart';
import 'package:fluttercalendar_app/students/view/studentManageProfile.dart';
import 'package:fluttercalendar_app/students/view/studentProductItems.dart'; // Import the studentProductItems.dart file
import 'package:fluttercalendar_app/students/view/studentPurchasedHistoryScreen.dart';
import 'package:fluttercalendar_app/students/view/studentTutorListScreen.dart';
import 'package:fluttercalendar_app/students/view/studentTutorStatusScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back arrow
        title: Row(
          children: [
            Image.asset(
              'assets/unishop_logo.png', // Ensure this path is correct
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Online UniShop',
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Spacer(), // Add space to separate the title and icons
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentPurchasedItemsScreen(), // Navigate to purchase history screen
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart, color: Colors.white), // Add shopping cart icon
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ),
                );
              },
              icon: Icon(Icons.chat, color: Colors.white), // Add chat icon
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF232526), Color(0xFF414345)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Categories',
                        suffixIcon: Icon(Icons.search, color: Colors.white), // Add search icon on the right side
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Categories',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  
                  _buildServiceCards(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF232526), Color(0xFF414345)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(0, 30, 20, 20),
          unselectedItemColor: const Color.fromARGB(179, 191, 191, 191), // Set unselected icon color
          selectedItemColor: const Color.fromARGB(255, 207, 207, 207),
          selectedFontSize: 13, // Set selected icon color
          unselectedFontSize: 13,
          showSelectedLabels: true, // Show labels for selected items
          showUnselectedLabels: true, //
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'ITEMS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'PROFILE',
            ),
          ],
          onTap: (int index) async {
            switch (index) {
              case 0:
                // Navigate to StudentHomeScreen page when "HOME" tab is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                );
                break;
              case 1:
                // Navigate to the StudentProductItems when "ITEMS" tab is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentProductItems()),
                );
                break;
              case 2:
                // Navigate to the StudentManageProfile page when "PROFILE" tab is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentManageProfile()),
                );
                break;
              default:
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildServiceCards() {
    List<Widget> services = [
      ServiceCard(
        title: 'Manage Tracking',
        icon: Icons.shopping_cart,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminCreateTrackingScreen()),
          );
        },
        gradientColors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
      ),
      ServiceCard(
        title: 'Manage Report',
        icon: Icons.sell,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminHomeReport()),
          );
        },
        gradientColors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
      ),
      ServiceCard(
        title: 'Applications History',
        icon: Icons.school,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => studentTutorRegisterListScreen()),
          );
        },
        gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)],
      ),
      ServiceCard(
        title: 'Review Application',
        icon: Icons.history,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminReviewApplicationScreen()),
          );
        },
        gradientColors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
      ),
      // ServiceCard(
      //   title: 'Give Tutor',
      //   icon: Icons.person_add,
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => studentCreateTutorScreen()),
      //     );
      //   },
      //   gradientColors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
      // ),
      // ServiceCard(
      //   title: 'Request Tutor',
      //   icon: Icons.request_page,
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => studentRequestTutorListScreen()),
      //     );
      //   },
      //   gradientColors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
      // ),
      // ServiceCard(
      //   title: 'Review Application',
      //   icon: Icons.rate_review,
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => adminReviewApplicationScreen()),
      //     );
      //   },
      //   gradientColors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
      // ),
      ServiceCard(
        title: 'Review Tutoring',
        icon: Icons.reviews,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => studentTutorListScreen()),
          );
        },
        gradientColors: [Color(0xFFFFA17F), Color(0xFFFFD194)],
      ),
      ServiceCard(
        title: 'Tutoring Status',
        icon: Icons.announcement,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentTutorStatusScreen()),
          );
        },
        gradientColors: [Color.fromARGB(255, 255, 106, 186), Color.fromARGB(255, 255, 0, 170)],
      ),
      //  ServiceCard(
      //   title: 'Items Tracking',
      //   icon: Icons.art_track,
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => AdminCreateTrackingScreen()),
      //     );
      //   },
      //   gradientColors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
      // ),
    ];

    if (_searchQuery.isNotEmpty) {
      services = services.where((service) {
        if (service is ServiceCard) {
          return service.title.toLowerCase().contains(_searchQuery.toLowerCase());
        }
        return false;
      }).toList();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 3 / 2,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return services[index];
      },
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
