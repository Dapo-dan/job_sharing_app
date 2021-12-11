import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:job_sharing_app/services/global_variables.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _fullNameController = TextEditingController(text: '');
  late TextEditingController _emailTextController = TextEditingController(text: '');
  late TextEditingController _passTextController = TextEditingController(text: '');
  late TextEditingController _locationController = TextEditingController(text: '');
  late TextEditingController _phoneNumberController = TextEditingController(text: '');

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _positionCPFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? imageUrl;

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positionCPFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Designing the sign up screen
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
              imageUrl: signUpUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: ListView(
                children: [
                  Form(
                      key: _signUpFormKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            _showImageDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: size.width * 0.24,
                              height:  size.height * 0.24,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: imageFile == null
                                    ? const Icon(Icons.camera_enhance, color: Colors.blue, size: 30,)
                                    : Image.file(imageFile!, fit: BoxFit.fill,)
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameController,
                          validator: (value){
                            if(value!.isEmpty){
                              return "This field is missing";
                            }else{
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Full name/ Company name',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            )
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value){
                            if(value!.isEmpty || !value.contains('@')){
                              return "Please enter a valid email address";
                            }else{
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              )
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                          focusNode: _passFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          validator: (value){
                            if(value!.isEmpty || value.length < 7 ){
                              return "Please enter a valid password";
                            }else{
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              )
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_positionCPFocusNode),
                          focusNode: _phoneNumberFocusNode,
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberController,
                          validator: (value){
                            if(value!.isEmpty){
                              return "This field is missing";
                            }else{
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: 'Phone number',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              )
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_positionCPFocusNode),
                          focusNode: _positionCPFocusNode,
                          keyboardType: TextInputType.text,
                          controller: _locationController,
                          validator: (value){
                            if(value!.isEmpty){
                              return "This field is missing";
                            }else{
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: 'Company address',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              )
                          ),
                        ),
                        const SizedBox(height: 20,),
                        _isLoading ? Center(
                          child: Container(
                            width: 70,
                            height: 70,
                            child: const CircularProgressIndicator(),
                          ),
                        ) : MaterialButton(
                            onPressed: (){},
                          color: Colors.blue,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'SignUp',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40,),
                        Center(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Already have an account',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    )
                                ),
                                TextSpan(text: '   '),
                                TextSpan(
                                    text: 'Login here',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  )
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showImageDialog(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Please choose an option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: (){
                _getFromCamera(); //Option to capture image from camera

              },
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.camera,
                      color: Colors.purple,
                    ),
                  ),
                  Text(
                    'Camera',
                    style: TextStyle(color: Colors.purple),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: (){
                _getFromGallery(); //Option to pick image from gallery

              },
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.image,
                      color: Colors.purple,
                    ),
                  ),
                  Text(
                    'Gallery',
                    style: TextStyle(color: Colors.purple),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  void _getFromGallery() async{
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromCamera() async{
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async{
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if(croppedImage != null){
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

}



