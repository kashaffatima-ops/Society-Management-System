import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
//import 'dart:html' as html;
import 'package:path_provider/path_provider.dart';
import 'image_file.dart' if (dart.library.html) 'image_file_web.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';

class UploadAndDisplayImages extends StatefulWidget {
  @override
  _UploadAndDisplayImagesState createState() => _UploadAndDisplayImagesState();
}

class _UploadAndDisplayImagesState extends State<UploadAndDisplayImages> {
  final ImagePicker imagePicker = ImagePicker();
  Map<String, List<String>> folderImages = {};
  List<XFile> imageFileList = [];
  String eventName = "";

  @override
  void initState() {
    super.initState();
    fetchFolderImages();
  }

  Future<void> fetchFolderImages() async {
    final Reference storageRef = FirebaseStorage.instance.ref('EventImages');
    folderImages.clear();
    await listAllFiles(storageRef);
    setState(() {});
  }

  Future<void> listAllFiles(Reference ref) async {
    final ListResult result = await ref.listAll();

    for (Reference folder in result.prefixes) {
      await listAllFiles(folder);
    }

    for (Reference file in result.items) {
      String downloadUrl = await file.getDownloadURL();
      String folderName = ref.fullPath.split('/').last;

      if (folderImages.containsKey(folderName)) {
        folderImages[folderName]!.add(downloadUrl);
      } else {
        folderImages[folderName] = [downloadUrl];
      }
    }
  }

  void selectImage() async {
    try {
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages != null && selectedImages.isNotEmpty) {
        setState(() {
          imageFileList.addAll(selectedImages);
          _showEventNameDialog();
        });
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  Future<void> uploadinFirebase(List<XFile> list) async {
    for (XFile file in list) {
      try {
        Reference storageRef = FirebaseStorage.instance.ref().child(
            "EventImages/$eventName/${DateTime.now().millisecondsSinceEpoch}_${file.name}");

        UploadTask uploadTask;
        if (kIsWeb) {
          Uint8List fileData = await file.readAsBytes();
          uploadTask = storageRef.putData(fileData);
        } else {
          File fileToUpload = File(file.path);
          uploadTask = storageRef.putFile(fileToUpload);
        }

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print(
            "File uploaded: ${taskSnapshot.ref.fullPath}, Download URL: $downloadUrl");
      } catch (e) {
        print("Error uploading file: $e");
      }
    }

    await fetchFolderImages();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Notification"),
        content: const Text("Images uploaded successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showEventNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempEventName = "";
        return AlertDialog(
          title: const Text("Enter Event Name"),
          content: TextField(
            onChanged: (value) {
              tempEventName = value;
            },
            decoration: const InputDecoration(hintText: "Event Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (tempEventName.isNotEmpty) {
                  setState(() {
                    eventName = tempEventName;
                  });
                  Navigator.of(context).pop();
                  uploadinFirebase(imageFileList);
                }
              },
              child: const Text("Submit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> downloadFolderAsZip(String folderName) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref('EventImages/$folderName');
      final ListResult result = await storageRef.listAll();

      final archive = Archive();
      for (var item in result.items) {
        final fileData = await item.getData();
        final fileName = item.name;
        archive.addFile(ArchiveFile(fileName, fileData!.length, fileData));
      }

      final encodedData = ZipEncoder().encode(archive);

      if (encodedData != null) {
        if (kIsWeb) {
          // Web-specific download logic
          // final blob = html.Blob([encodedData], 'application/zip');
          // final url = html.Url.createObjectUrlFromBlob(blob);
          // final anchor = html.AnchorElement(href: url)
          //   ..setAttribute("download", "$folderName.zip")
          //   ..click();
          // html.Url.revokeObjectUrl(url);

          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      )
                    ],
                    title: const Text("Notification"),
                    contentPadding: const EdgeInsets.all(20.0),
                    content: const Text("File downloaded successfully!!"),
                  ));
        } else {
          // Mobile/Desktop-specific download logic
          final tempDir = await getTemporaryDirectory();
          final zipFile = File('${tempDir.path}/$folderName.zip');
          await zipFile.writeAsBytes(encodedData);
          print('Downloaded ZIP is saved at: ${zipFile.path}');
        }
      } else {
        print('Error: Could not encode archive to ZIP');
      }
    } catch (e) {
      print('Error downloading folder as ZIP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.black,
            elevation: 8,
            toolbarHeight: 60,
            centerTitle: true,
            title: const Text(
              "Event Images",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white70,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white70),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectImage();
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorchanger('#A70052'),
              colorchanger('#A0153E'),
              colorchanger('#720455'),
              colorchanger('#3C0753'),
              colorchanger('#0F094F'),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: folderImages.keys.length,
          itemBuilder: (context, index) {
            String folderName = folderImages.keys.elementAt(index);
            List<String> images = folderImages[folderName]!;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                color: Colors.black.withOpacity(0.7),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            folderName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.download, color: Colors.white70),
                            onPressed: () {
                              downloadFolderAsZip(folderName);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 250,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemCount: images.length,
                          itemBuilder: (context, imageIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.network(
                                images[imageIndex],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      'Failed to load image',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
/*

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.black,
            elevation: 8,
            toolbarHeight: 60,
            centerTitle: true,
            title: const Text(
              "Event Images",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white70,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white70),
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorchanger('#A70052'),
              colorchanger('#A0153E'),
              colorchanger('#720455'),
              colorchanger('#3C0753'),
              colorchanger('#0F094F'),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: folderImages.keys.length,
          itemBuilder: (context, index) {
            String folderName = folderImages.keys.elementAt(index);
            List<String> images = folderImages[folderName]!;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                color: Colors.black.withOpacity(0.7),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            folderName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.download, color: Colors.white70),
                            onPressed: () {
                              downloadFolderAsZip(folderName);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 250,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemCount: images.length,
                          itemBuilder: (context, imageIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.network(
                                images[imageIndex],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      'Failed to load image',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }*/
}
