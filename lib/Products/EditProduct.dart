import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopperstore/Products/ProductModel.dart';

class EditProduct extends StatefulWidget {
  final ProductModel product;
  final String images;
//
//   final ProductModel product;
//   final String images;
//   // final String category;
  // final String brand;
  // final String productName;
  // final String productPrice;
  // final String color;
  // final String productDescription;
  // final String product1;
  // final String product2;
  // final String product3;
  // final String product4;
  // final String title1;
  // final String title2;
  // final String title3;
  // final String title4;
  // final String discount;
  // final String newPrice;
  //

  //   required this.product,
  //   required this.images,
  //   // required this.category,
  //   // required this.brand,
  //   required this.productName,
  //   required this.productPrice,
  //   required this.color,
  //   required this.productDescription,
  //   required this.product1,
  //   required this.product2,
  //   required this.product3,
  //   required this.product4,
  //   required this.title1,
  //   required this.title2,
  //   required this.title3,
  //   required this.title4,
  //   required this.discount,
  //   required this.newPrice,
  EditProduct({Key? key,required this.product, required this.images,
  }) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  String? selectCategory;
  String? selectBrand;
  String? selectedCategory;
  List<File>? selectedImage;
  String? selectedBrand;
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productColorController = TextEditingController();
  final TextEditingController productTitle1Controller = TextEditingController();
  final TextEditingController productTitleDetail1Controller = TextEditingController();
  final TextEditingController productTitle2Controller = TextEditingController();
  final TextEditingController productTitleDetail2Controller = TextEditingController();
  final TextEditingController productTitle3Controller = TextEditingController();
  final TextEditingController productTitleDetail3Controller = TextEditingController();
  final TextEditingController productTitle4Controller = TextEditingController();
  final TextEditingController productTitleDetail4Controller = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController productNewPriceController = TextEditingController();
  final TextEditingController productDiscountController = TextEditingController();
  bool isLoading = false;

  @override

  void initState() {
    super.initState();
    selectCategory = widget.product.category.toString();
    selectedBrand = widget.product.brand.toString();
    productNameController.text = widget.product.productName.toString();
    productPriceController.text = widget.product.productPrice.toString();
    productColorController.text = widget.product.color.toString();
    productTitle1Controller.text = widget.product.title1.toString();
    productTitleDetail1Controller.text = widget.product.product1.toString();
    productTitle2Controller.text = widget.product.title2.toString();
    productTitleDetail2Controller.text = widget.product.product2.toString();
    productTitle3Controller.text = widget.product.title3.toString();
    productTitleDetail3Controller.text = widget.product.product3.toString();
    productTitle4Controller.text = widget.product.title4.toString();
    productTitleDetail4Controller.text = widget.product.product4.toString();
    productDescriptionController.text = widget.product.productDescription.toString();
    productNewPriceController.text = widget.product.newPrice.toString();
    productDiscountController.text = widget.product.discount.toString();

  }

  Future<void> _updateProduct() async {
    setState(() {
      isLoading = true;
    });

    DocumentReference productref = FirebaseFirestore.instance.collection('Products').doc(widget.product.id);

    List<String> imageUrls = [];

    if (selectedImage != null) {
      for (File imageFile in selectedImage!){
        String imageUrl = await uploadImageToUpload(imageFile);
        imageUrls.add(imageUrl);
      }
    }

    Map<String, dynamic> updatedData = {

      'productName' : productNameController.text,
      'priceController' : productPriceController.text,
      'discountController': productDiscountController.text,
      'productNewPriceController': productNewPriceController.text,
      'productColorController': productColorController.text,
      'productTitleDetail1Controller': productTitleDetail1Controller.text,
      'productTitleDetail2Controller': productTitleDetail2Controller.text,
      'productTitleDetail3Controller': productTitleDetail3Controller.text,
      'productTitleDetail4Controller': productTitleDetail4Controller.text,
      'productTitle1Controller': productTitle1Controller.text,
      'productTitle2Controller': productTitle2Controller.text,
      'productTitle3Controller': productTitle3Controller.text,
      'productTitle4Controller': productTitle4Controller.text,
      'productDescriptionController': productDescriptionController.text,
      // 'category': selectedCategory,
      // 'subCategory': selectedBrand,

    };

     try{
      await productref.update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Edited Successfully'),
      backgroundColor: Colors.cyan,
       )
      );
      setState(() {

      });
     } catch(error){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update product'),
        )
      );
     } finally {
       setState(() {
         isLoading = false;
       });
     }
  }

  Future<String> uploadImageToUpload(File imageFile) async {
    Reference storageref = FirebaseStorage.instance.ref().child('Product_images/${widget.product.id}');
    return await storageref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product',style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20,),

              if (selectedImage != null && selectedImage!.isNotEmpty)
                  Image.file(selectedImage! [0], height: 200, width: 200,)
                  else Image.network(
                widget.images,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20,),

              Container(
                width: double.infinity,
                child: ElevatedButton(onPressed: () async {
                  ImagePicker imagepicker = ImagePicker();
                 List<XFile>? files = await imagepicker.pickMultiImage();
                  // if(files == null)
                  //   return;
                  selectedImage = files.map((file) => File(file.path)).toList();
                  setState(() {

                  });

                }, child: const Text('Select Images', style: TextStyle(
                    fontSize: 15,
                    color: Colors.black
                  ),
                 ),
                ),
              ),

              SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productPriceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productDiscountController,
                  decoration: InputDecoration(
                    labelText: 'Discount',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productNewPriceController,
                  decoration: InputDecoration(
                    labelText: 'New Price',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productColorController,
                  decoration: InputDecoration(
                    labelText: 'Edit Color',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productTitleDetail1Controller,
                  decoration: InputDecoration(
                    labelText: 'Product 1',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productTitle1Controller,
                  decoration: InputDecoration(
                    labelText: 'Title 1',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productTitleDetail2Controller,
                  decoration: InputDecoration(
                    labelText: 'Product 2',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productTitle2Controller,
                  decoration: InputDecoration(
                    labelText: 'Title 2',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productTitleDetail3Controller,
                  decoration: InputDecoration(
                    labelText: 'Product 3',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productTitle3Controller,
                  decoration: InputDecoration(
                    labelText: 'Title 3',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productTitleDetail4Controller,
                  decoration: InputDecoration(
                    labelText: 'Product 4',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productTitle4Controller,
                  decoration: InputDecoration(
                    labelText: 'Title 4',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Edit Description',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),


              const SizedBox(height: 20,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () async{
                  setState(() {
                    isLoading = true;
                  });
                  await _updateProduct();
                  setState(() {
                    isLoading = false;
                  });
                 }, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  child: isLoading
                  ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text('Save',style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
