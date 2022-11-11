import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sealine_app/constants/routes.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/buttons.dart';
import 'package:sealine_app/widgets/only_text_input.dart';
import 'package:sealine_app/widgets/scf_msg.dart';

class EditBoat extends StatefulWidget {
  final String id;
  final Map<String, dynamic> boatData;

  const EditBoat({
    Key? key,
    required this.id,
    required this.boatData,
  }) : super(key: key);

  @override
  State<EditBoat> createState() => _EditBoatState();
}

class _EditBoatState extends State<EditBoat> {
  final FirebaseServices _services = FirebaseServices();
  final SCF _scf = SCF();
  final _formkey = GlobalKey<FormState>();
  var boatNameInput = TextEditingController();
  var boatBrandInput = TextEditingController();
  var yearInput = TextEditingController();
  var engineCapacityInput = TextEditingController();
  var fishCapacityInput = TextEditingController();
  var maxMembersInput = TextEditingController();
  var fuelCapacityInput = TextEditingController();
  String? boatType;

  @override
  void initState() {
    setState(() {
      boatNameInput.text = widget.boatData['boatName'];
      boatBrandInput.text = widget.boatData['boatBrand'];
      boatType = widget.boatData['boatType'];
      yearInput.text = widget.boatData['year'];
      engineCapacityInput.text = widget.boatData['engineCapacity'];
      fishCapacityInput.text = widget.boatData['fishCapacity'];
      maxMembersInput.text = widget.boatData['maxMembers'];
      fuelCapacityInput.text = widget.boatData['fuelCapacity'];
    });
    super.initState();
  }

  @override
  void dispose() {
    boatNameInput.dispose();
    boatBrandInput.dispose();
    yearInput.dispose();
    engineCapacityInput.dispose();
    fishCapacityInput.dispose();
    maxMembersInput.dispose();
    fuelCapacityInput.dispose();
    super.dispose();
  }

  Widget _boatTypeDrop() {
    return DropdownButtonFormField<String>(
      value: boatType,
      hint: Text(
        'Select Boat Type',
        style: TextStyle(color: Colors.grey[800]),
      ),
      decoration: InputDecoration(
        labelText: 'Boat Type',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.grey[300],
      ),
      items: ['Multi-Day Vessal', 'Single-Day Vessal']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          boatType = value!;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Select Boat Type is required';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/12610_1920x1080.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    // Edit Boat
                    const Text(
                      'Edit Boat',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    // Delete Button
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Do you want to delete?',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'CANCEL',
                                            style: TextStyle(
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            try {
                                              EasyLoading.show();
                                              _services.boat
                                                  .doc(widget.id)
                                                  .delete()
                                                  .then((value) {
                                                EasyLoading.dismiss();
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        boatHomeRoute,
                                                        (route) => false);
                                              });
                                            } catch (e) {
                                              _scf.scaffoldMsg(
                                                context: context,
                                                msg: e.toString().toUpperCase(),
                                                backgroundColor: Colors.red,
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                              color: Colors.purple,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
                // Boat Name
                FormattedTextInputLabel(
                  controller: boatNameInput,
                  label: 'Boat Name',
                  filled: true,
                  fillColor: Colors.grey[300],
                  enabledBorder: Colors.transparent,
                ),
                // Boat Brand
                FormattedTextInputLabel(
                  controller: boatBrandInput,
                  label: 'Boat Brand',
                  filled: true,
                  fillColor: Colors.grey[300],
                  enabledBorder: Colors.transparent,
                ),
                // Select Boat Type
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: _boatTypeDrop(),
                ),
                // Year of Manufacture
                FormattedTextInputLabel(
                  controller: yearInput,
                  label: 'Boat Brand',
                  filled: true,
                  fillColor: Colors.grey[300],
                  maxLength: 4,
                  inputType: TextInputType.number,
                  enabledBorder: Colors.transparent,
                ),
                // Engine Capacity
                FormattedTextInputLabel(
                  controller: engineCapacityInput,
                  label: 'Engine Capacity',
                  filled: true,
                  fillColor: Colors.grey[300],
                  inputType: TextInputType.number,
                  enabledBorder: Colors.transparent,
                ),
                // Fish Hold Capacity
                FormattedTextInputLabel(
                  controller: fishCapacityInput,
                  label: 'Fish Hold Capacity',
                  filled: true,
                  fillColor: Colors.grey[300],
                  inputType: TextInputType.number,
                  enabledBorder: Colors.transparent,
                ),
                // Max Crew Members
                FormattedTextInputLabel(
                  controller: maxMembersInput,
                  label: 'Max Crew Members',
                  filled: true,
                  fillColor: Colors.grey[300],
                  inputType: TextInputType.number,
                  enabledBorder: Colors.transparent,
                ),
                // Fuel Capacity
                FormattedTextInputLabel(
                  controller: fuelCapacityInput,
                  label: 'Fuel Capacity',
                  filled: true,
                  fillColor: Colors.grey[300],
                  inputType: TextInputType.number,
                  enabledBorder: Colors.transparent,
                ),
                // Edit Button
                ElevatedButtonClick(
                  text: 'Edit',
                  fontSize: 20,
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      try {
                        EasyLoading.show();
                        await _services.boat.doc(widget.id).update(
                          {
                            'boatName': boatNameInput.text,
                            'boatBrand': boatBrandInput.text,
                            'boatType': boatType,
                            'year': yearInput.text,
                            'engineCapacity': engineCapacityInput.text,
                            'maxMembers': maxMembersInput.text,
                            'fishCapacity': fishCapacityInput.text,
                            'fuelCapacity': fuelCapacityInput.text,
                          },
                        ).then((value) {
                          EasyLoading.dismiss();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              boatHomeRoute, (route) => false);
                        });
                      } catch (e) {
                        _scf.scaffoldMsg(
                          context: context,
                          msg: e.toString().toUpperCase(),
                          backgroundColor: Colors.red,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
