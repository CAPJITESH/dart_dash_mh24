import 'package:flutter/material.dart';

class MarketMovers extends StatelessWidget {
  MarketMovers({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> marketMoversData = [
    {
      'title': 'Top Gainers',
      'icon': Icons.trending_up,
      'color': Colors.green.withOpacity(0.2),
      'gradientColors': [
        Colors.green.withOpacity(0.3),
        Colors.green.withOpacity(0.1),
      ],
    },
    {
      'title': 'Top Losers',
      'icon': Icons.trending_down,
      'color': Colors.red.withOpacity(0.2),
      'gradientColors': [
        Colors.red.withOpacity(0.3),
        Colors.red.withOpacity(0.1),
      ],
    },
    {
      'title': 'Watchlist',
      'icon': Icons.remove_red_eye_outlined,
      'color': Colors.blue.withOpacity(0.2),
      'gradientColors': [
        Colors.blue.withOpacity(0.3),
        Colors.blue.withOpacity(0.1),
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Market Movers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Market movers ListView
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: marketMoversData.length,
              itemBuilder: (context, index) {
                final data = marketMoversData[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildGlassContainer(
                    data['title'],
                    data['icon'],
                    data['color'],
                    data['gradientColors'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer(
    String title,
    IconData icon,
    Color backgroundColor,
    List<Color> gradientColors,
  ) {
    return Container(
      width: 130,
      padding: const EdgeInsets.only(left: 12, top: 16, bottom: 16, right: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 18,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
