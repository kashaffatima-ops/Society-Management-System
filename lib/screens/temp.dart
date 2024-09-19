import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FolderImages extends StatefulWidget {
  @override
  _FolderImagesState createState() => _FolderImagesState();
}

class _FolderImagesState extends State<FolderImages> {
  Map<String, List<String>> folderImages = {};

  @override
  void initState() {
    super.initState();
    fetchFolderImages();
  }

  Future<void> fetchFolderImages() async {
    // Replace 'EventImages' with your actual root folder path in Firebase Storage
    final Reference storageRef = FirebaseStorage.instance.ref('EventImages');

    // Recursively list all files and group them by folder
    await listAllFiles(storageRef);

    setState(() {});
  }

  Future<void> listAllFiles(Reference ref) async {
    final ListResult result = await ref.listAll();

    for (Reference folder in result.prefixes) {
      // Recursively list images in subfolders
      await listAllFiles(folder);
    }

    for (Reference file in result.items) {
      // Fetch and store download URLs
      String downloadUrl = await file.getDownloadURL();

      // Extract folder name
      String folderName = ref.fullPath.split('/').last;

      // Add image URL to corresponding folder list
      if (folderImages.containsKey(folderName)) {
        folderImages[folderName]!.add(downloadUrl);
      } else {
        folderImages[folderName] = [downloadUrl];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: folderImages.keys.length,
      itemBuilder: (context, index) {
        String folderName = folderImages.keys.elementAt(index);
        List<String> images = folderImages[folderName]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                folderName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Adjust the number of columns as needed
              ),
              itemCount: images.length,
              itemBuilder: (context, imageIndex) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(
                    images[imageIndex],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Failed to load image'));
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
