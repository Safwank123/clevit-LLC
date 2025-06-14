import 'package:flutter/material.dart';
import 'package:flutter_task/screens/my_collection_screen.dart';
import 'package:flutter_task/screens/sigin_in_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(11, 21, 25, 1),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 514),
                Container(
                  height: 264,
                  width: 343,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Welcome!',
                          style: GoogleFonts.ebGaramond(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Text text text',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                          SizedBox(height: 20),
                        SizedBox(
                          width: 311,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(212, 154, 0, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                            ),
                            child: Text(
                              'Scan bottle',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                         const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Have an account?',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
               
              },
              child: Text(
                'Sign in First',
                style: GoogleFonts.lato(
                  color: Color.fromRGBO(212, 154, 0, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ]
        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
