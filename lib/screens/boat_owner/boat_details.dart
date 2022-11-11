import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sealine_app/screens/boat_owner/edit_boat.dart';
import 'package:sealine_app/widgets/buttons.dart';

class BoatDetails extends StatefulWidget {
  final String id;
  final Map<String, dynamic> boatData;

  const BoatDetails({
    Key? key,
    required this.id,
    required this.boatData,
  }) : super(key: key);

  @override
  State<BoatDetails> createState() => _BoatDetailsState();
}

class _BoatDetailsState extends State<BoatDetails> {
  Widget items({String? text, double? fontSize, FontWeight? fontWeight}) {
    return Expanded(
      child: SizedBox(
        height: 30,
        child: Center(
          child: Text(
            text!,
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'SEALINE',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Image
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[400],
            child: CachedNetworkImage(
              imageUrl: widget.boatData['boatImage'],
              fit: BoxFit.cover,
            ),
          ),
          // Boat Name
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text(
                  widget.boatData['boatName'],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            height: 5,
            color: Colors.grey[300],
          ),
          // Boat Brand | Boat Type | Engine Cap
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    items(
                        text: 'Boat Brand',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    items(
                        text: 'Boat Type',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    items(
                        text: 'Engine Cap',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    items(
                      text: widget.boatData['boatBrand'],
                    ),
                    items(
                      text: widget.boatData['boatType'],
                    ),
                    items(
                      text: widget.boatData['engineCapacity'],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black),
          // Less than 24Hrs ago
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [Text('Less than 24Hrs ago')],
            ),
          ),
          const Divider(color: Colors.black),
          const SizedBox(height: 20),
          const Text(
            'Description',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('Year of manufacture: ${widget.boatData['year']}'),
          const SizedBox(height: 5),
          Text('Fish Hold Capacity: ${widget.boatData['fishCapacity']}kg'),
          const SizedBox(height: 5),
          Text('Maximum Members: ${widget.boatData['maxMembers']}'),
          const SizedBox(height: 5),
          Text('Fuel Capacity: ${widget.boatData['fuelCapacity']}l'),
          const SizedBox(height: 20),
          ElevatedButtonClick(
            text: 'EDIT',
            fontSize: 20,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditBoat(
                    id: widget.id,
                    boatData: widget.boatData,
                  ),
                ),
              );
            },
            primary: Colors.indigo,
          )
        ],
      ),
    );
  }
}
