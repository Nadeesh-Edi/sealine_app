import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sealine_app/constants/routes.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/buttons.dart';
import 'package:sealine_app/widgets/only_text_input.dart';
import 'package:sealine_app/widgets/scf_msg.dart';

class AddNewBoat extends StatefulWidget {
  const AddNewBoat({Key? key}) : super(key: key);

  @override
  State<AddNewBoat> createState() => _AddNewBoatState();
}

class _AddNewBoatState extends State<AddNewBoat> {
  final FirebaseServices services = FirebaseServices();
  late final TextEditingController _boatName;
  late final TextEditingController _boatBrand;
  late final TextEditingController _year;
  late final TextEditingController _engineCapacity;
  late final TextEditingController _maxMembers;
  late final TextEditingController _fuelCapacity;
  late final TextEditingController _fishCapacity;
  final _formkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final SCF _scf = SCF();
  XFile? boatImage;
  String? boatType;
  String? imageName;
  String? boatImageURL;

  @override
  void initState() {
    _boatName = TextEditingController();
    _boatBrand = TextEditingController();
    _year = TextEditingController();
    _engineCapacity = TextEditingController();
    _maxMembers = TextEditingController();
    _fuelCapacity = TextEditingController();
    _fishCapacity = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _boatName.dispose();
    _boatBrand.dispose();
    _year.dispose();
    _engineCapacity.dispose();
    _maxMembers.dispose();
    _fuelCapacity.dispose();
    _fishCapacity.dispose();
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

  Future<XFile?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
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
                // Register Boat
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Register Boat',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                // Boat Name
                FormattedTextInputLabel(
                  controller: _boatName,
                  label: 'Boat Name',
                  filled: true,
                  fillColor: Colors.grey[300],
                  enabledBorder: Colors.transparent,
                ),
                // Boat Brand
                FormattedTextInputLabel(
                  controller: _boatBrand,
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
                  controller: _year,
                  label: 'Year of Manufacture',
                  filled: true,
                  fillColor: Colors.grey[300],
                  enabledBorder: Colors.transparent,
                  maxLength: 4,
                  inputType: TextInputType.number,
                ),
                // Engine Capacity
                FormattedTextInputLabel(
                  controller: _engineCapacity,
                  label: 'Engine Capacity (knots)',
                  filled: true,
                  fillColor: Colors.grey[300],
                  enabledBorder: Colors.transparent,
                  inputType: TextInputType.number,
                ),
                // Fish Hold Capacity
                FormattedTextInputLabel(
                  controller: _fishCapacity,
                  label: 'Fish Hold Capacity (KG)',
                  filled: true,
                  fillColor: Colors.grey[300],
                  enabledBorder: Colors.transparent,
                  inputType: TextInputType.number,
                ),
                // Max Crew Members
                FormattedTextInputLabel(
                  controller: _maxMembers,
                  label: 'Max Crew Members',
                  filled: true,
                  fillColor: Colors.grey[300],
                  enabledBorder: Colors.transparent,
                  inputType: TextInputType.number,
                ),
                // Fuel Capacity
                FormattedTextInputLabel(
                  controller: _fuelCapacity,
                  label: 'Fuel Capacity (L)',
                  filled: true,
                  fillColor: Colors.grey[300],
                  enabledBorder: Colors.transparent,
                  inputType: TextInputType.number,
                ),
                // Add Images
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Text(
                        'Add Images:',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(width: 20),
                      boatImage == null
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  EasyLoading.show();
                                  pickImage().then((value) {
                                    EasyLoading.showSuccess('Image Selected');
                                    setState(() {
                                      boatImage = value;
                                    });
                                  });
                                },
                                icon: const Icon(Icons.add),
                              ),
                            )
                          : const Icon(Icons.image, size: 50),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Text(
                          'Image can not be edited',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
                // Register Button
                ElevatedButtonClick(
                  text: 'Register',
                  fontSize: 20,
                  onPressed: () {
                    if (boatImage == null) {
                      _scf.scaffoldMsg(
                        context: context,
                        backgroundColor: Colors.red,
                        msg: 'Boat Image not selected',
                      );
                      return;
                    }
                    if (_formkey.currentState!.validate()) {
                      try {
                        EasyLoading.show(status: 'Please Wait');
                        services
                            .uploadImg(
                                file: boatImage,
                                reference: 'boatImage/${DateTime.now()}')
                            .then((url) {
                          if (url.isNotEmpty) {
                            setState(() {
                              boatImageURL = url;
                            });
                          }
                        }).then((value) {
                          services.addBoat(
                            data: {
                              'boatName': _boatName.text,
                              'boatBrand': _boatBrand.text,
                              'boatType': boatType,
                              'year': _year.text,
                              'engineCapacity': _engineCapacity.text,
                              'maxMembers': _maxMembers.text,
                              'fishCapacity': _fishCapacity.text,
                              'fuelCapacity': _fuelCapacity.text,
                              'boatImage': boatImageURL,
                              'uid': services.user!.uid,
                            },
                          ).then((value) {
                            EasyLoading.dismiss();
                            return Navigator.of(context)
                                .pushNamedAndRemoveUntil(
                                    boatHomeRoute, (route) => false);
                          });
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
