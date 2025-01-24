import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FreightRatesScreen extends StatefulWidget {
  const FreightRatesScreen({super.key});

  @override
  _FreightRatesScreenState createState() => _FreightRatesScreenState();
}

class _FreightRatesScreenState extends State<FreightRatesScreen> {
  bool includeNearbyOriginPorts = false;
  bool includeNearbyDestinationPorts = false;
  String commodity = '40\' Standard';
  bool isFCL = true;
  bool isLCL = false;
  int numOfBoxes = 0;
  double weight = 0.0;
  List<String> universities = [];
  final TextEditingController _autocompleteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUniversities();
  }

  Future<void> _fetchUniversities() async {
    final response = await http
        .get(Uri.parse('http://universities.hipolabs.com/search?name=middle'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      setState(() {
        universities = data.map((item) => item['name'] as String).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(230, 235, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Search the Best Freight Rates'),
            Container(
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(230, 235, 255, 1),
                border: Border.all(
                  color: Color.fromRGBO(1, 57, 255, 1),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(
                "History",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color.fromRGBO(1, 57, 255, 1),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Origin',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/location.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Checkbox(
                              value: includeNearbyOriginPorts,
                              onChanged: (value) {
                                setState(() {
                                  includeNearbyOriginPorts = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: Text('Include nearby origin ports'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Destination',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/location.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Checkbox(
                              value: includeNearbyDestinationPorts,
                              onChanged: (value) {
                                setState(() {
                                  includeNearbyDestinationPorts = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: Text('Include nearby destination ports'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Commodity',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/commodity.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cut Off Date',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/cut_off_date.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Shipment Type:'),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: isFCL,
                    onChanged: (value) {
                      setState(() {
                        isFCL = value!;
                        isLCL = !value;
                      });
                    },
                  ),
                  Text('FCL'),
                  SizedBox(width: 30),
                  Checkbox(
                    value: isLCL,
                    onChanged: (value) {
                      setState(() {
                        isLCL = value!;
                        isFCL = !value;
                      });
                    },
                  ),
                  Text('LCL'),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ListView(
                              children: [
                                ...[
                                  '40\' Standard',
                                  '20\' Standard',
                                  '40\' High Cube'
                                ].map((e) {
                                  return ListTile(
                                    title: Text(e),
                                    onTap: () {
                                      setState(() {
                                        commodity = e;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        );
                      },
                      child: TextField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: commodity,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Select Commodity',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/commodity.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Number of boxes',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          numOfBoxes = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Weight(kg)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          weight = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/info-circle.png',
                    width: 24,
                    height: 24,
                  ),
                  Expanded(
                    child: Text(
                        "To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate."),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Container Internal Dimensions :",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Length"),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("39.46 ft")
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Width"),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("7.70 ft")
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Height"),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("7.84 ft")
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/container1.png",
                          width: 300,
                          height: 300,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return universities.where((String option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _autocompleteController.text = selection;
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  _autocompleteController.value = fieldController.value;

                  return TextField(
                    controller: fieldController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Enter a university name',
                      prefixIcon: Icon(Icons.school),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => onFieldSubmitted(),
                  );
                },
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(230, 235, 255, 1),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Color.fromRGBO(1, 57, 255, 1),
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/search-normal.png",
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Search',
                          style: TextStyle(
                            color: Color.fromRGBO(1, 57, 255, 1),
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
