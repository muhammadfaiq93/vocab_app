import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE8F0FE),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top section with character
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Child character illustration
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Main child character
                          Container(
                            width: 180,
                            height: 220,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Body
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: 120,
                                    height: 140,
                                    child: Column(
                                      children: [
                                        // Torso - Yellow shirt
                                        Container(
                                          width: 80,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFDD835),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        // Legs - Blue pants
                                        Container(
                                          width: 70,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF1976D2),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        // Shoes
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 25,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF1976D2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              width: 25,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF1976D2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Head
                                Positioned(
                                  top: 0,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD7940C),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Stack(
                                      children: [
                                        // Hair
                                        Positioned(
                                          top: 5,
                                          left: 15,
                                          right: 15,
                                          child: Container(
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5D4037),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(35),
                                                topRight: Radius.circular(35),
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Eyes
                                        Positioned(
                                          top: 45,
                                          left: 25,
                                          child: Row(
                                            children: [
                                              // Left eye
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF5D4037),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 25),
                                              // Right eye
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF5D4037),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Smile
                                        Positioned(
                                          top: 70,
                                          left: 30,
                                          child: Container(
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE53935),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Left arm (pointing up)
                                Positioned(
                                  top: 80,
                                  left: 10,
                                  child: Transform.rotate(
                                    angle: -0.8,
                                    child: Container(
                                      width: 15,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFD7940C),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),

                                // Right arm holding book
                                Positioned(
                                  top: 90,
                                  right: 20,
                                  child: Container(
                                    width: 15,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD7940C),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                                // Book
                                Positioned(
                                  top: 110,
                                  right: 5,
                                  child: Container(
                                    width: 20,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1976D2),
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Lightbulb idea
                          Positioned(
                            top: -20,
                            right: 20,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFFFDD835),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFDD835).withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.lightbulb,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom blue section
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        SizedBox(height: 20),

                        // App logo and name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lightbulb,
                                color: Color(0xFFFDD835),
                                size: 18,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'WordWise',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Main title
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            children: [
                              TextSpan(
                                text: 'Daily words.\n',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Lifelong ',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'impact!',
                                style: TextStyle(color: Color(0xFFFDD835)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),

                        // Subtitle
                        Text(
                          'Your daily dose of vocabulary.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        Spacer(),

                        // Start Learning button
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF6366F1),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Start Learning',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Page indicator
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
