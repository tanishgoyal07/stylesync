import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:stylesyncapp/utils/constants.dart';

class VirtualTryOnScreen extends StatefulWidget {
  @override
  _VirtualTryOnScreenState createState() => _VirtualTryOnScreenState();
}

class _VirtualTryOnScreenState extends State<VirtualTryOnScreen> {
  File? _modelImage;
  File? _clothImage;
  File? _outputImage;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(bool isModel) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isModel) {
          _modelImage = File(pickedFile.path);
        } else {
          _clothImage = File(pickedFile.path);
        }
        _outputImage = null;
      });
    }
  }

  //2tlBL28Qz1PkYv4YXydvMKBIUSY_7g1iM1Xbm2oYZdDnd8QbB  -> AUTH TOKEN

  Future<void> uploadImages() async {
    setState(() {
      _outputImage = null;
    });

    if (_modelImage == null || _clothImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both images')),
      );
      return;
    }

    setState(() => isLoading = true);

    var uri = Uri.parse("$collabURL/upload");
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('model', _modelImage!.path))
      ..files
          .add(await http.MultipartFile.fromPath('cloth', _clothImage!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      Uint8List bytes = await response.stream.toBytes();
      final tempDir = await getTemporaryDirectory();
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      File file = File('${tempDir.path}/output_$timestamp.jpg');
      await file.writeAsBytes(bytes);

      print(file);

      setState(() {
        _outputImage = null; // Clear previous image
      });
      await Future.delayed(Duration(milliseconds: 100)); // Ensure UI refresh
      setState(() {
        _outputImage = file;
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:
              const Color.fromARGB(255, 158, 119, 107), // White app bar
          elevation: 0.0,
          title: const Center(
            child: Text(
              'StyleSync Virtual Try-On',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      _modelImage != null
                          // ? Image.file(_modelImage!, height: 150)
                          ? ClothImageCard(clothImage: _modelImage!)
                          : const Icon(Icons.person, size: 100),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => pickImage(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8DFF5),
                          foregroundColor: const Color(0xFF5A3D7B),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: Color(0xFFB799D0), width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shadowColor: const Color(0xFFD0C2E9),
                        ),
                        child: const Text(
                          'Pick Model',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      _clothImage != null
                          ? ClothImageCard(clothImage: _clothImage!)
                          // ? Image.file(_clothImage!, height: 150)
                          : const Icon(Icons.shopping_bag, size: 100),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => pickImage(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8DFF5),
                          foregroundColor: const Color(0xFF5A3D7B),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: Color(0xFFB799D0), width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shadowColor: const Color(0xFFD0C2E9),
                        ),
                        child: const Text(
                          'Pick Cloth',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: uploadImages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8DFF5),
                  foregroundColor: const Color(0xFF5A3D7B),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFB799D0), width: 2),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shadowColor: const Color(0xFFD0C2E9),
                ),
                child: const Text(
                  'Try On',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (isLoading)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Hold on, we are trying your outfit..."),
                  ],
                ),
              _outputImage != null
                  // ? Image.file(_outputImage!, height: 200)
                  ? ClothImageCard(clothImage: _outputImage!)
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class ClothImageCard extends StatelessWidget {
  final File clothImage;

  const ClothImageCard({Key? key, required this.clothImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Smooth rounded corners
      ),
      elevation: 5, // Soft shadow effect
      color: Color(0xFFF3E5F5), // Pastel lavender background
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                clothImage,
                height: 180,
                fit: BoxFit.cover, // Ensures the image fills the space nicely
              ),
            ),
          ],
        ),
      ),
    );
  }
}
