import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/custom_appbar_all.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: 'null',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
    // orders: []
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
  };
  var _isInit = true;
  var _isLoading = false;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  final String cloudinaryUploadUrl =
      'https://api.cloudinary.com/v1_1/dgd6rhtby/image/upload';
  final String cloudinaryPreset = 'j3zsbovl';

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).getId(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _pickedImage = File(_editedProduct.imageUrl);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(cloudinaryUploadUrl),
    );
    request.fields['upload_preset'] = cloudinaryPreset;
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final decodedData = json.decode(responseData);
      return decodedData['secure_url'];
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_pickedImage != null) {
        // Upload image to Cloudinary
        final imageUrl = await _uploadImage(_pickedImage!);
        _editedProduct = Product(
          title: _editedProduct.title,
          price: _editedProduct.price,
          description: _editedProduct.description,
          imageUrl: imageUrl, // Use the Cloudinary URL
          id: _editedProduct.id,
          isFavourite: _editedProduct.isFavourite,
          // orders:_editedProduct.orders
        );
      }

      if (_editedProduct.id != 'null') {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } else {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong.'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(
        title: 'Add/ Edit Product',
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white,),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value!,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          // orders: _editedProduct.orders
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: double.parse(value!),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          //  orders: _editedProduct.orders
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value!,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          //  orders: _editedProduct.orders
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _pickedImage == null
                              ? Center(
                                  child: Text(
                                    'No Image Selected',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Image.file(
                                  _pickedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: Icon(Icons.image),
                            label: Text("Pick Image"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
