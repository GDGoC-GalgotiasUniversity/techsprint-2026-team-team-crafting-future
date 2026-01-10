import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double dragX = 0;

  final List<Map<String, String>> newsList = [
    {
      "tag": "Trending #1",
      "title": "New Economic Sanctions Announced Amid Rising Regional Tensions",
      "desc":
          "Governments have introduced fresh economic sanctions, raising questions about their long-term impact on civilian livelihoods and regional stability.",
    },
    {
      "tag": "Trending #2",
      "title": "Healthcare Reform Bill Sparks Nationwide Debate",
      "desc":
          "The proposed healthcare reforms have ignited debate among policymakers, professionals, and the general public.",
    },
    {
      "tag": "Trending #3",
      "title": "Global Markets React to Interest Rate Changes",
      "desc":
          "Stock markets worldwide showed volatility following the announcement of new interest rate policies.",
    },
  ];

  void _onSwipeEnd() {
    if (dragX < -120) {
      setState(() {
        final removed = newsList.removeAt(0);
        newsList.add(removed);
      });
    }
    dragX = 0;
  }

  @override
  Widget build(BuildContext context) {
    final swipeProgress = (dragX.abs() / 220).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _searchBar(),
            _categoryTabs(),
            const SizedBox(height: 10),

            /// STACKED CARD DECK
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(min(3, newsList.length), (index) {
                  final isTop = index == 0;

                  final double offsetX = index == 1
                      ? lerpDouble(18.0, 0.0, swipeProgress)!
                      : index == 2
                      ? lerpDouble(36.0, 18.0, swipeProgress)!
                      : 0.0;

                  final double offsetY = index * 6.0;

                  final scale = index == 1
                      ? lerpDouble(0.95, 1.0, swipeProgress)!
                      : index == 2
                      ? lerpDouble(0.9, 0.95, swipeProgress)!
                      : 1.0;

                  return Positioned(
                    child: isTop
                        ? _draggableCard(newsList[index])
                        : Transform.translate(
                            offset: Offset(offsetX, offsetY),
                            child: Transform.scale(
                              scale: scale,
                              child: _newsCard(newsList[index]),
                            ),
                          ),
                  );
                }).reversed.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- CARD BEHAVIOR ----------------

  Widget _draggableCard(Map<String, String> news) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          dragX += details.delta.dx;
        });
      },
      onPanEnd: (_) => _onSwipeEnd(),
      child: Transform.translate(
        offset: Offset(dragX, 0), // locked vertical
        child: Transform.rotate(
          angle: dragX * pi / 2600, // curved path
          child: _newsCard(news),
        ),
      ),
    );
  }

  // ---------------- UI ----------------

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Text(
            "Evidex",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1765BE),
            ),
          ),
          Spacer(),
          CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8),
            Text("Search for any news", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _categoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: const [
          Text("Trending", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 16),
          Text("Policies"),
          SizedBox(width: 16),
          Text("Healthcare"),
          SizedBox(width: 16),
          Text("Finance"),
          SizedBox(width: 16),
          Text("Education"),
        ],
      ),
    );
  }

  // ---------------- CARD UI ----------------

  Widget _newsCard(Map<String, String> news) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.86,
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2DE8A),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              news["tag"]!,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            news["title"]!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(news["desc"]!, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.thumb_up_alt_outlined),
              Icon(Icons.share_outlined),
              Icon(Icons.bookmark_border),
              Icon(Icons.send),
            ],
          ),
        ],
      ),
    );
  }
}
