import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trivia_quiz_app/main.dart';
import 'package:trivia_quiz_app/screens/quiz_page.dart';

int highScore = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String defaultURL = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple";
  
  void categoryNum(int num) {
    setState(() {
      baseUrl = defaultURL.replaceAllMapped(
            RegExp(r'category=\d+'),
            (match) => 'category=$num',
          );
    });
    // print(baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 228, 255), 
      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const SizedBox(height: 58),

            CircleAvatar(
              radius: 46.0,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.5), 
              child: const Icon(
                Icons.person,
                  size: 56.0,
                  color: Colors.white,
                ),
            ),
            
            const SizedBox(height: 15,),
            
            Text(
              "Welcome, $dispName!",
              style: GoogleFonts.bungee(
                fontSize: 18,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ), 
            ),

            const SizedBox(height: 32),

            //General Knowledge
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  categoryNum(9);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const TriviaQuizPage(
                      category: 'General Knowledge', 
                      description: 'Test your wits with a diverse range of questions covering a wide array of topics. Our General Knowledge category challenges you with intriguing facts, historical events, and fascinating tidbits from around the world. Sharpen your intellect and discover new facts while enjoying this fun and informative quiz category!',
                    )),
                  );
                 },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'General Knowledge',
                    ),
                    Icon(
                      Icons.library_books, 
                      size: 24.0,         
                    ),
                  ],
                ),
              )
            ),

            //Animals
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () { 
                  categoryNum(27);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const TriviaQuizPage(
                      category: 'Animals',
                      description: 'Dive into the wild world of creatures big and small with our Animals category. Explore the animal kingdoms fascinating diversity, from majestic mammals to exotic insects. Test your knowledge about the animal worlds wonders, habitats, and behaviors. Discover interesting facts about your favorite creatures and uncover the mysteries of the animal kingdom in this fun-filled trivia category!',
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    Text(
                      'Animals',
                    ),
                    Icon(
                      Icons.pets, 
                      size: 24.0,         
                    ),
                  ],
                ),
              )
            ),

            //Vehicles
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () { 
                  categoryNum(28);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const TriviaQuizPage(
                      category: 'Vehicles',
                      description: 'Get ready to hit the road in the Vehicles category! Whether you are a car enthusiast, a motorcycle aficionado, or simply curious about transportation, this category will put your knowledge to the test. Explore the world of automobiles, from classic cars to modern marvels. Learn about the history, design, and technology that drives these machines. Buckle up and get ready for a trivia adventure that takes you on a journey through the fascinating world of vehicles!',
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vehicles',
                    ),
                    Icon(
                       Icons.directions_car,
                      size: 24.0,        
                    ),
                  ],
                ),
              )
            ),

            //Science: Computers
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () { 
                  categoryNum(18);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const TriviaQuizPage(
                      category: 'Science: Computers',
                      description: 'Dive into the world of technology with the Science: Computers category! If you are a tech-savvy individual or just curious about the digital realm, this category is perfect for you. Test your knowledge about computer hardware, software, programming languages, and the fascinating history of computing. From the pioneers of the computer age to the latest innovations in artificial intelligence, you will explore it all. Get ready to geek out and discover the exciting world of computers in this trivia challenge', 
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Science: Computers',
                    ),
                    Icon(
                      Icons.computer,
                      size: 24.0,         
                    ),
                  ],
                ),
              )
            ),

            //Science: Mathematics
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () { 
                  categoryNum(15);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const TriviaQuizPage(
                      category: 'Video Games',
                      description: 'Calling all gamers! Step into the Video Games category and put your gaming knowledge to the test. From classic retro titles to the latest blockbusters, this category covers the vast world of video games. Explore iconic characters, legendary game franchises, gaming history, and more. Whether you are a casual player or a dedicated gamer, you will find questions that challenge your gaming expertise. Get ready to reminisce about your favorite titles and discover new facts about the gaming universe in this trivia adventure!',
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Video Games',
                    ),
                    Icon(
                      Icons.sports_esports,
                      size: 24.0,        
                    ),
                  ],
                ),
              )
            ),

            //home button icon
            Container(
              margin: const EdgeInsets.only(top: 120.0), 
              decoration: const ShapeDecoration(
                color: Colors.transparent,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.home,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary, 
                ),
                onPressed: () { 
                  categoryNum(15);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
