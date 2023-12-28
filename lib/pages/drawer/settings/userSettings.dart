import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_app/components/myTextfield.dart';
import 'package:reddit_app/models/userDataModel.dart';
import 'package:reddit_app/services/auth/auth_service.dart';
import 'package:reddit_app/services/posts/post_services.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({
    super.key
  });

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  late Future<UserCredentialsModel> credentialsModel;
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final PostServices _postServices = PostServices();
  bool isUploading = false;



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PostServices().getUser(_firebaseAuth.currentUser!.uid),
        builder: (builder, snapshot){
          if(snapshot.hasError){
            return const Text("Error");
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const LinearProgressIndicator();
          }
          _displayNameController.text = snapshot.data!.displayName;
          _userNameController.text = snapshot.data!.userName;
          _phoneNumberController.text = snapshot.data!.phoneNumber;


          updateUserSettings(){
            if(_displayNameController.text != snapshot.data!.displayName && _displayNameController.text.isNotEmpty){
              _authService.updateDisplayName(_displayNameController.text);
            }
            if(_phoneNumberController.text != snapshot.data!.phoneNumber && _phoneNumberController.text.isNotEmpty){
              _authService.updatePhoneNumber(_phoneNumberController.text);
            }
            if(_userNameController.text != snapshot.data!.userName && _userNameController.text.isNotEmpty){
              _authService.updateUserName(_userNameController.text);
            }
          }

          return ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            children: [
              GestureDetector(
                onTap: () async {
                  final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                  if(pickedImage?.path!=null) {
                    File file = File(pickedImage!.path);
                    Image image = Image.memory(await pickedImage.readAsBytes());
                    Uint8List img = await pickedImage.readAsBytes();
                    setState(() {
                      isUploading = true;
                    });
                    _postServices.uploadImage(pickedImage.name, img)
                        .then((value){ _authService.updateDisplayPhoto(value);
                    setState(() {});
                        });
                  }
                },
                  child: CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.imageUrl),minRadius: 50,)),
              const SizedBox(height: 8.0),
              MyTextField(controller: _userNameController, hintText: "User Name", obscureText: false),
              const SizedBox(height: 8.0),
              MyTextField(controller: _displayNameController, hintText: "Display Name", obscureText: false),
              const SizedBox(height: 8.0),
              MyTextField(controller: _phoneNumberController, hintText: "Phone Number", obscureText: false),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: (){
                  updateUserSettings();
                  Navigator.pop(context);
                  },
                style: TextButton.styleFrom(
                    minimumSize: const Size(75, 50),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )
                ),
                child: const Text("Update", style: TextStyle(color: Colors.white),),
              )
            ],
          );
        });
  }
}
