import 'package:blockchain_upi/constants.dart';
import 'package:blockchain_upi/http/http.dart';
import 'package:blockchain_upi/models/get_home_data.dart';
import 'package:blockchain_upi/screens/Chatbot/mybot.dart';
import 'package:blockchain_upi/screens/HOME_NEW/market_movers.dart';
import 'package:blockchain_upi/screens/HOME_NEW/portfolio_card.dart';
import 'package:blockchain_upi/screens/HOME_NEW/reccomendations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({Key? key}) : super(key: key);

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  SharedPreferences? prefs;
  String? profileImage;
  String? userName;
  String? address;
  bool hide = false;
  bool loading = false;
  HomeModel? res;

  void getData() async {
    setState(() {
      loading = true;
    });
    prefs = await SharedPreferences.getInstance();

    profileImage = prefs!.getString("image");
    userName = prefs!.getString('name');
    address = prefs!.getString("address");
    res = await HttpApiCalls().getHomeData({'address': address});

    print(address);
    print(userName);

    loading = false;
    setState(() {});
  }

  Future<void> _refreshData() async {
    getData(); // Call getData when the user pulls to refresh
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  String _formatBalance(String balance) {
    String balanceString = balance.toString();

    // Check if it has a decimal point
    if (balanceString.contains('.')) {
      // Split the string into whole number and fractional parts
      var parts = balanceString.split('.');
      var wholeNumber = parts[0];
      var fractionalPart = parts[1];

      // Show up to 5 decimal places if they exist
      if (fractionalPart.length > 5) {
        return '$wholeNumber.${fractionalPart.substring(0, 5)} ETH';
      } else {
        return '$wholeNumber.$fractionalPart ETH';
      }
    }

    return '$balanceString ETH'; // If no decimal, return whole number
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Chatbot(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: purple1,
          fixedSize: const Size(60, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        icon: const Icon(
          CupertinoIcons.chat_bubble_text,
          size: 32,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Section
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Blue Container
                        Container(
                          height: 250,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: blue,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(profileImage!),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Welcome back,',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 28,
                                    ),
                                  ),
                                  Text(
                                    userName ?? "User",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Balance Card
                        Positioned(
                          bottom: -50,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total balance',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _formatBalance(res!.balance!),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Cash available',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                    //3 cards
                    MarketMovers(),
                    //Portfolio
                    const PortFolioCard(),
                    //Recommendations
                    const RecommendationCard(),

                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
