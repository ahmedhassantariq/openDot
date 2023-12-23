import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/models/postModel.dart';

import '../../components/postTextfield.dart';
import '../../services/firebase/firebase_services.dart';
import '../../services/posts/post_services.dart';

class UpdatePostPage extends StatefulWidget {
  final PostModel postModel;
  final Function()? stateUpdate;
  const UpdatePostPage({
    this.stateUpdate,
    required this.postModel,
    super.key
  });

  @override
  State<UpdatePostPage> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  late TextEditingController _postTextFieldTitleController = TextEditingController();
  late TextEditingController _postTextFieldBodyController = TextEditingController();
  late final PostServices _postServices = PostServices();
  final ImagePicker picker = ImagePicker();
  late List<dynamic> imageUrl = [];
  double iconSize = 30;
  bool isUploading = false;

  @override
  void initState() {
    _postTextFieldTitleController.text = widget.postModel.postTitle!;
    _postTextFieldBodyController.text = widget.postModel.postDescription!;
    imageUrl = widget.postModel.imageUrl;

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height-76,
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: (){Navigator.pop(context);},
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: const Icon(Icons.close)),
                    !isUploading ? TextButton(
                      onPressed: (){
                        if(_postTextFieldTitleController.text.isNotEmpty){
                          _postServices.updatePost(
                              widget.postModel.postID,
                              _postTextFieldTitleController.text,
                              _postTextFieldBodyController.text,
                              imageUrl
                          );
                          Navigator.pop(context);
                          Provider.of<PostServices>(context, listen: false).notifyListeners();
                          _postTextFieldTitleController.clear();
                          _postTextFieldBodyController.clear();
                        }
                      },
                      style: TextButton.styleFrom(
                          minimumSize: const Size(75, 50),
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.lightBlueAccent),
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                      child: const Text("Update", style: TextStyle(color: Colors.white),),
                    ): const Icon(Icons.stop, color: Colors.red,size: 50,),
                  ],
                ),
              ),
              PostTextField(controller: _postTextFieldTitleController, hintText: "Title", obscureText: false, fontWeight: FontWeight.w600,fontSize: 18,),
              PostTextField(controller: _postTextFieldBodyController, hintText: "Body", obscureText: false, fontSize: 16,),
              for(int i=0;i<imageUrl.length;i++)
                imageUrl.isNotEmpty ?
                Column(
                  children: [
                    IconButton(onPressed: (){setState(() {
                      imageUrl.removeAt(i);
                    });}, icon: const Icon(Icons.delete_outline)),
                    Container(
                        alignment: Alignment.center,child:
                    CachedNetworkImage(imageUrl: imageUrl[i],placeholder: (context, url) => const CircularProgressIndicator(), errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined))),
                  ],
                )
                    :const SizedBox(width: 0,height: 0,),
            ],
          ),
        ),
        isUploading ? LinearProgressIndicator() : SizedBox(width:0,height: 0,),
        Container(
          height: 56,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.keyboard, color: Colors.grey, size: iconSize),
                const SizedBox(width: 8.0,),
                Icon(Icons.add_link, color: Colors.grey, size: iconSize),
                const SizedBox(width: 8.0,),
                Icon(Icons.gif_box_outlined, color: Colors.grey, size: iconSize),
                const SizedBox(width: 8.0,),
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
                            .then((value){ imageUrl.add(value);
                        setState(() {
                          isUploading = false;
                        });});
                      }

                    },
                    child: const Icon(Icons.photo_outlined, color: Colors.grey))
              ],
            ),
          ),
        )
      ],
    );
  }
}
