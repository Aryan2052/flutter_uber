import 'package:flutter/material.dart';

class CarbonPage extends StatefulWidget {
  const CarbonPage({super.key});

  @override
  _CarbonPageState createState() => _CarbonPageState();
}

class _CarbonPageState extends State<CarbonPage> {
  final TextEditingController timeController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  String? result;
  bool isLoading = false;

  @override
  void dispose() {
    timeController.dispose();
    distanceController.dispose();
    daysController.dispose();
    super.dispose();
  }

  void calculateFootprint() {
    if (timeController.text.isEmpty ||
        distanceController.text.isEmpty ||
        daysController.text.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Simple calculation:
      // Assuming average petrol car emits 120g CO2 per km
      double distance = double.parse(distanceController.text);
      double days = double.parse(daysController.text);
      double weeklyEmissions = distance * days * 0.12; // in kg
      int treesNeeded = (weeklyEmissions * 52 / 22)
          .ceil(); // yearly emissions divided by 22kg (absorption per tree)

      setState(() {
        result = '''
Weekly CO₂ emissions: ${weeklyEmissions.toStringAsFixed(2)} kg
Trees needed to offset yearly emissions: $treesNeeded

Tip: Consider carpooling or using public transport to reduce your carbon footprint!
''';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        result = 'Error calculating footprint. Please enter valid numbers.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your carbon footprint'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Calculate Your Footprint',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                            'Daily Travel Time (hours)', timeController),
                        const SizedBox(height: 12),
                        _buildInputField(
                            'Daily Distance (km)', distanceController),
                        const SizedBox(height: 12),
                        _buildInputField('Days per Week', daysController),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : calculateFootprint,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Calculate',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (result != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Results',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            result!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _buildActionCard(
                  icon: Icons.eco,
                  title: 'Donate trees',
                  subtitle:
                      'Combat climate change with the Priceless Coalition',
                  onTap: () {
                    // Add donation functionality
                  },
                ),
                const SizedBox(height: 12),
                _buildActionCard(
                  icon: Icons.lightbulb_outline,
                  title: 'Quick tips',
                  subtitle: 'Learn how to reduce your carbon footprint',
                  onTap: () {
                    // Add tips functionality
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.black),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
