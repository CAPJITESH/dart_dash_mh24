import 'package:blockchain_upi/constants.dart';
import 'package:blockchain_upi/http/http.dart';
import 'package:blockchain_upi/models/get_home_data.dart';
import 'package:blockchain_upi/screens/History/history.dart';
import 'package:blockchain_upi/screens/QR%20Page/qr_page.dart';
import 'package:blockchain_upi/screens/Scanner/scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool actionIcon = false;
  String? profileImage;
  String? userName;
  String? address;

  String pri_address = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  SharedPreferences? prefs;

  void getData() async {
    prefs = await SharedPreferences.getInstance();

    profileImage = prefs!.getString("image");
    userName = prefs!.getString('name');
    address = prefs!.getString("address");

    print(address);
    print(userName);
    setState(() {});
  }

  Stream homeDataStream() async* {
    while (true) {
      yield await HttpApiCalls().getHomeData({'address': address});

      await Future.delayed(const Duration(seconds: 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
        buttonSize: const Size(60, 60),
        backgroundColor: purple2,
        overlayOpacity: 0,
        spacing: 15,
        // spaceBetweenChildren: 15,
        onOpen: () {
          setState(() {
            actionIcon = true;
          });
        },
        onClose: () {
          setState(() {
            actionIcon = false;
          });
        },
        children: [
          SpeedDialChild(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            labelShadow: [],
            elevation: 0,
            backgroundColor: green3,
            labelBackgroundColor: green4,
            label: "Scan QR",
            labelStyle: TextStyle(
              color: green2,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const QRScanner(),
                ),
              );
            },
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          SpeedDialChild(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            labelShadow: [],
            elevation: 0,
            backgroundColor: blue1,
            labelBackgroundColor: blue2,
            label: "Show QR",
            labelStyle: TextStyle(
              color: blue1,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const QRPage(),
                ),
              );
            },
            child: const Icon(
              Icons.qr_code_2_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
        child: Icon(
          actionIcon ? Icons.close_rounded : Icons.qr_code_2_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      body: StreamBuilder<dynamic>(
        stream: homeDataStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            HomeModel res = snapshot.data;
            int length =
            res.transaction!.length < 3 ? res.transaction!.length : 3;

            final frontadd = address?.substring(0, 4);
            final endadd =
            address?.substring(address!.length - 4, address!.length);

            return Column(
              children: [
                // SizedBox(
                //   height: 300,
                //   child: Stack(
                //     alignment: Alignment.center,
                //     children: [
                //       Container(
                //         height: 150,
                //         width: MediaQuery.of(context).size.width,
                //         decoration: BoxDecoration(
                //           color: blue,
                //           borderRadius: const BorderRadius.only(
                //             bottomLeft: Radius.circular(20),
                //             bottomRight: Radius.circular(20),
                //           ),
                //         ),
                //       ),

                //     ],
                //   ),
                // )
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
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
                    ),
                    // Balance Card
                    const Positioned(
                      top: 50,
                      child: Text(
                        "Wallet",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 130,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              20),
                          child: Stack(
                            children: [
                              // Center circle
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 300,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: const Color(0xFF6488E5),
                                  ),
                                ),
                              ),
                              // Bottom right circle
                              Align(
                                alignment: const Alignment(5, -1),
                                child: Container(
                                  height: 300,
                                  width: 270,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(100),
                                    ),
                                    color: Color(0xFFE56372),
                                  ),
                                ),
                              ),
                              // Bottom circle
                              Align(
                                alignment: const Alignment(-3, -1),
                                child: Container(
                                  height: 300,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    color: const Color(0xFFF9BE7D),
                                  ),
                                ),
                              ),
                              // Overlay for text and logo
                              Container(
                                width: 350,
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                ),
                                child: Stack(
                                  children: [
                                    // VISA logo
                                    const Positioned(
                                      top: 20,
                                      right: 20,
                                      child: Text(
                                        'ETH',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Amount
                                    Positioned(
                                      top: 20,
                                      left: 20,
                                      child: Text(
                                        res.balance ?? "100",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Card number
                                    Positioned(
                                      bottom: 50,
                                      left: 20,
                                      child: Text(
                                        '$frontadd •••• •••• $endadd',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.wallet,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Recent Transactions',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const HistoryPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                    color: blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: length,
                              itemBuilder: (context, index) {
                                final data = res.transaction![index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: data.myself!
                                        ? DecorationImage(
                                      image: NetworkImage(
                                          data.senderImage!),
                                      fit: BoxFit.cover,
                                    )
                                        : DecorationImage(
                                      image: NetworkImage(
                                          data.receiverImage!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.bar_chart,
                            color: Colors.blue,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'My Transaction Analysis',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(address)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final categories =
                            snapshot.data!.data() as Map<String, dynamic>;

                            if (categories.values
                                .every((value) => value == 0)) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      height: 140,
                                      width: 140,
                                      child: PieChart(
                                        PieChartData(
                                          centerSpaceRadius: 35,
                                          sections: [
                                            PieChartSectionData(
                                              value: categories['bills']
                                                  .toDouble(),
                                              title: "Bills",
                                              color: red2Light,
                                              showTitle: true,
                                              titleStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                            PieChartSectionData(
                                              value: categories['food expenses']
                                                  .toDouble(),
                                              title: "Food",
                                              color: yellow1Light,
                                              showTitle: true,
                                              titleStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                            PieChartSectionData(
                                              value: categories['medical']
                                                  .toDouble(),
                                              title: "Medical Expenses",
                                              showTitle: true,
                                              color: violet1Light,
                                              titleStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                            PieChartSectionData(
                                              value: categories['finance']
                                                  .toDouble(),
                                              title: "Finance",
                                              color: green2Light,
                                              showTitle: true,
                                              titleStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                            PieChartSectionData(
                                              value: categories['others']
                                                  .toDouble(),
                                              title: "Others",
                                              color: purple2Light,
                                              showTitle: true,
                                              titleStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              color: red2Light,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            const Text(
                                              "Bills",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              color: yellow1Light,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            const Text(
                                              "Food",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              color: violet1Light,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            const Text(
                                              "Medical Expenses",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              color: green2Light,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            const Text(
                                              "Finance",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              color: purple2Light,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            const Text(
                                              "Others",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            print("WTFFFFFFF");
                            print(snapshot.error);
                            return const Center(
                              child: Text('No Internet Connection'),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            print("WTFFFFFFF");
            print(snapshot.error);
            return const Center(
              child: Text('No Internet Connection'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}