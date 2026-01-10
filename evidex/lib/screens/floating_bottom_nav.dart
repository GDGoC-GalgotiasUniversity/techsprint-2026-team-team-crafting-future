import 'package:evidex/screens/analyze_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class FloatingBottomNav extends StatefulWidget {
  const FloatingBottomNav({super.key});

  @override
  State<FloatingBottomNav> createState() => _FloatingBottomNavState();
}

class _FloatingBottomNavState extends State<FloatingBottomNav> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    Center(child: Text("Simulator")),
    Center(child: Text("Stats")),
    AnalyzeScreen(),
    Center(child: Text("Profile")),
  ];

  final List<IconData> icons = [
    Icons.home_filled,
    Icons.vrpano,
    Icons.inventory_2,
    Icons.manage_search,
    Icons.settings,
  ];

  final List<String> labels = [
    "Home",
    "Simulator",
    "Stats",
    "Analysis",
    "Setting",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      /// FLOATING BOTTOM NAV
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 68,
          margin: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFF1765BE), Color(0xFF0B2F58)],
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) => _navItem(index)),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      flex: isSelected ? 5 : 4, // give selected a bit more breathing room
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double circleSize = (constraints.maxHeight - 22).clamp(36, 48);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icons[index],
                    size: 22,
                    color:
                        isSelected ? const Color(0xFF1765BE) : Colors.white,
                  ),
                ),
                const SizedBox(height: 2), // gap after the circle
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
