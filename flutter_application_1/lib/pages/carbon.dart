import 'package:flutter/material.dart';

class CarbonPage extends StatefulWidget {
  const CarbonPage({super.key});

  @override
  _CarbonPageState createState() => _CarbonPageState();
}

class _CarbonPageState extends State<CarbonPage> {
  bool showActionPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showActionPage ? 'Take action' : 'Your carbon footprint'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(showActionPage ? Icons.more_horiz : Icons.info_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: showActionPage ? _buildActionPage() : _buildFootprintPage(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showActionPage = !showActionPage;
          });
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.swap_horiz),
      ),
    );
  }

  Widget _buildFootprintPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Month selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: Icon(Icons.chevron_left), onPressed: () {}),
            Text('May 2020', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            IconButton(icon: Icon(Icons.chevron_right), onPressed: () {}),
          ],
        ),
        
        // Carbon footprint dial
        Container(
          height: 200,
          width: 200,
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.transparent),
            gradient: SweepGradient(
              colors: [
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.red,
              ],
            ),
          ),
          child: Center(
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('2,400', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  Text('kg CO₂', style: TextStyle(fontSize: 16)),
                  Text('Estimated', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        
        // View transactions button
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
          ),
          child: Text('View transactions'),
        ),
        
        SizedBox(height: 20),
        
        // Action cards
        _buildActionCard(
          icon: Icons.eco,
          title: 'Donate trees',
          subtitle: 'Combat climate change with the Priceless Coalition',
        ),
        
        SizedBox(height: 10),
        
        _buildActionCard(
          icon: Icons.lightbulb_outline,
          title: 'Quick tips',
          subtitle: 'Learn how to reduce your carbon footprint',
        ),
      ],
    );
  }

  Widget _buildActionPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tree target', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('100 Million', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('18 projects worldwide', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        
        SizedBox(height: 16),
        
        Text('We are partnering with the Priceless Planet Coalition to help us reach the goal of planting 100 million trees.'),
        SizedBox(height: 8),
        Text('Planting trees is simple and powerful way to combat climate change by removing CO₂ from air.'),
        
        SizedBox(height: 20),
        
        Center(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text('Donate to plant trees'),
          ),
        ),
        
        SizedBox(height: 20),
        
        Text('Who plants the trees?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Two global organizations, Conservation International and World Resources Institute, manage the tree planting efforts.'),
      ],
    );
  }

  Widget _buildActionCard({required IconData icon, required String title, required String subtitle}) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.black),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}