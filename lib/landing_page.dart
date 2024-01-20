import 'package:file_manager_flutter/Home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300,
              height: 308,
              padding: const EdgeInsets.only(left: 10, top: 10),
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(31, 255, 255, 255)),
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: SvgPicture.asset("assets/icons/big-folder.svg"),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            const SizedBox(
                width: 302,
                height: 84,
                child: Center(
                  child: Text(
                      "Manage your personal data with complete security",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold)),
                )),
            const SizedBox(
                width: 302,
                height: 108,
                child: Center(
                  child: Text(
                      "Tap on “Get Started” button to continue further step",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w500)),
                )),
            SizedBox(
              width: 302,
              height: 84,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Privacy Policy
                    buildClickableText(
                      'Privacy Policy',
                      context,
                    ),

                    const Text(" and "),

                    // Terms & Conditions
                    buildClickableText(
                      'Terms & Conditions',
                      context,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(303, 54)),
                  backgroundColor: MaterialStatePropertyAll(Color(0xff6350FF))),
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()))
              },
              child: const Text(
                "Get Stted",
                style: TextStyle(
                    fontSize: 15,
                    color: Color(0xffFFFFFF), //6350FF
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildClickableText(String s, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMaterialModalBottomSheet(
          context: context,
          builder: (context) => Container(
            child: const Text(
              "Get Started",
              style: TextStyle(
                  fontSize: 15,
                  color: Color(0xffFFFFFF), //6350FF
                  fontWeight: FontWeight.w500),
            ),
          ),
        ); // Open the URL when the text is tapped
      },
      child: Text(s,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 15,
              color: Color(0xff6350FF), //6350FF
              fontWeight: FontWeight.w500)),
    );
  }
}
