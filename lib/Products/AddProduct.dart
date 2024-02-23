import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Brands/BrandModel.dart';
import '../Category/categorymodel.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String? selectedCategory;
  String? selectedBrands;
  bool isLoading = false;
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  List<File> selectedImages = [];
  // String? imageUrl;

  final TextEditingController productController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController newpriceController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController product1Controller = TextEditingController();
  final TextEditingController title1Controller = TextEditingController();
  final TextEditingController product2Controller = TextEditingController();
  final TextEditingController title2Controller = TextEditingController();
  final TextEditingController product3Controller = TextEditingController();
  final TextEditingController title3Controller = TextEditingController();
  final TextEditingController product4Controller = TextEditingController();
  final TextEditingController title4Controller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<bool> doesProductExist(String productName) async{
    final querySnapshot = await FirebaseFirestore.instance.collection('Products')
        .where('productName', isEqualTo: productName)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addProductToFirestore() async {
    final category = selectedCategory;
    final brand = selectedBrands;
    final productName = productController.text.trim();
    final productPrice = priceController.text.trim();
    final discount = discountController.text.trim();
    final newPrice = newpriceController.text.trim();
    final color = colorController.text.trim();
    final product1 = product1Controller.text.trim();
    final title1 = title1Controller.text.trim();
    final product2 = product2Controller.text.trim();
    final title2 = title2Controller.text.trim();
    final product3 = product3Controller.text.trim();
    final title3 = title3Controller.text.trim();
    final product4 = product4Controller.text.trim();
    final title4 = title4Controller.text.trim();
    final description = descriptionController.text.trim();

    if(category == null || category.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    if(brand == null || brand.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a Brand")),
      );
      return;
    }


    if (productName.isEmpty ||
        productPrice.isEmpty ||
        discount.isEmpty ||
        newPrice.isEmpty ||
        color.isEmpty ||
        product1.isEmpty ||
        title1.isEmpty ||
        product2.isEmpty ||
        title2.isEmpty ||
        product3.isEmpty ||
        title3.isEmpty ||
        product4.isEmpty ||
        title4.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all fields"),));

      return;
    }


    final doesExist = await doesProductExist(productName);

    if(doesExist){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Already exist')));

    } else {
      setState(() {
        isLoading = true;
      });
      if (selectedImages.isNotEmpty){
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('Product_Images');
        Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

        try{
          for(var image in selectedImages){
            await referenceImageToUpload.putFile(image);
          }
          final List<String> imageUrls = await Future.wait(selectedImages.map((image) async => await referenceImageToUpload.getDownloadURL()));

          print('Image Urls:');
          for(var url in imageUrls){
            print(url);
          }

          FirebaseFirestore.instance.collection("Products").add({
            'category': category,
            'brand': brand,
            'productName': productName,
            'productPrice': productPrice,
            'productColor': color,
            'productDescription': description,
            'productTitle1': product1,
            'productTitle2': product2,
            'productTitle3': product3,
            'productTitle4': product4,
            'productTitleDetail1': title1,
            'productTitleDetail2': title2,
            'productTitleDetail3': title3,
            'productTitleDetail4': title4,
            'discount': discount,
            'productNewPrice': newPrice,
            'images': imageUrls,

          }).then((value){
            selectedImages.clear();

            productController.clear();
            priceController.clear();
            colorController.clear();
            descriptionController.clear();
            product1Controller.clear();
            product2Controller.clear();
            product3Controller.clear();
            product4Controller.clear();
            title1Controller.clear();
            title2Controller.clear();
            title3Controller.clear();
            title4Controller.clear();
            discountController.clear();
            newpriceController.clear();
            selectedCategory = null;
            selectedBrands = null;

            setState(() {
              isLoading = false;
            });


            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Added Successfully')));
          });
        }catch (error) {
          print("Error uploading images: $error");
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select images")));
        setState(() {
          isLoading = false;
        });
      }

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products',
          style: TextStyle(
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              SizedBox(height: 180,
                  width: 200,
                  child: selectedImages.isNotEmpty ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(selectedImages[index],
                          width: 200,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                      : Image.asset("asset/images/nopicture.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,)
              ),

              Container(
                width: double.infinity,
                child: ElevatedButton(onPressed: () async{
                  ImagePicker imagePicker = ImagePicker();
                  List<XFile>? files = await imagePicker.pickMultiImage();

                  selectedImages = files.map((file) => File(file.path)).toList();
                  setState(() {

                  });
                }, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan,),
                  child: const Text('Select Images',
                    style: TextStyle(
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              CategoryDropdown(
                selectedCategory: selectedCategory,
                onChanged: (value){
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 25,),

              BrandDropDown(
                selectedCategory: selectedCategory,
                selectedBrands: selectedBrands,
                onChanged: (value){
                  setState(() {
                    selectedBrands = value;
                  });
                },
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: productController,
                decoration: InputDecoration(
                  hintText: 'Product Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  hintText: 'Product Price',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: discountController,
                decoration: InputDecoration(
                  hintText: 'Discount',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: newpriceController,
                decoration: InputDecoration(
                  hintText: 'Product New Price',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: colorController,
                decoration: InputDecoration(
                  hintText: 'Product Color',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: product1Controller,
                decoration: InputDecoration(
                  hintText: 'Product Title 1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: title1Controller,
                decoration: InputDecoration(
                  hintText: 'Title 1 detail',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: product2Controller,
                decoration: InputDecoration(
                  hintText: 'Product Title 2',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: title2Controller,
                decoration: InputDecoration(
                  hintText: 'Title 2 detail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: product3Controller,
                decoration: InputDecoration(
                  hintText: 'Product Title 3',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: title3Controller,
                decoration: InputDecoration(
                  hintText: 'Title 3 detail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: product4Controller,
                decoration: InputDecoration(
                  hintText: 'Product Title 4',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(
                controller: title4Controller,
                decoration: InputDecoration(
                  hintText: 'Title 4 detail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              TextFormField(maxLines: 6,
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Product Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),

              const SizedBox(height: 25,),

              Container(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  addProductToFirestore();
                }, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white,)
                      : const Text('Add Product',style: TextStyle(fontSize: 20,color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({required this.selectedCategory, required this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
        builder: (context, snapshot){
          if (!snapshot.hasData){
            return const CircularProgressIndicator();
          }

          final categoryDocs = snapshot.data!.docs;
          List <CategoryModel> categories = [];

          for(var doc in categoryDocs){
            final category = CategoryModel.fromSnapshot(doc);
            categories.add(category);
          }

          return DropdownButtonFormField<String>(
            value: selectedCategory,
            onChanged: onChanged,
            decoration: const InputDecoration(
                labelText: 'Select Category',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan)
                )
            ),
            items: categories.map((CategoryModel category){
              return DropdownMenuItem<String>(
                value: category.category,
                child: Text(category.category, style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Please select a Product';
              }
              return null;
            },
          );
        }
    );
  }
}

//
// class BrandDropDown extends StatelessWidget {
//   final String? selectedBrands;
//   final String? selectedCategory;
//   final ValueChanged<String?> onChanged;
//
//   const BrandDropDown({required this.selectedBrands, required this.onChanged, required this.selectedCategory, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('Brands').snapshots(),
//         builder: (context, snapshot){
//           if (!snapshot.hasData){
//             return const CircularProgressIndicator();
//           }
//
//           final brandDocs = snapshot.data!.docs;
//           List <BrandModel> brands = [];
//
//           for(var doc in brandDocs){
//             final brand = BrandModel.fromSnapshot(doc);
//
//             if(brand.category == selectedCategory){
//               brands.add(brand);
//             }
//           }
//
//           return DropdownButtonFormField<String>(
//             value: selectedBrands,
//             onChanged: onChanged,
//             decoration: const InputDecoration(
//                 labelText: 'Select Brand',
//                 labelStyle: TextStyle(color: Colors.black),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     borderSide: BorderSide(color: Colors.cyan)
//                 )
//             ),
//             items: brands.map((BrandModel brand){
//               return DropdownMenuItem<String>(
//                 value: brand.brand,
//                 child: Text(brand.brand, style: const TextStyle(color: Colors.black),
//                 ),
//               );
//             }).toList(),
//             validator: (value){
//               if(value == null || value.isEmpty){
//                 return 'Please select a Brand';
//               }
//               return null;
//             },
//           );
//         }
//     );
//   }
// }
//

class BrandDropDown extends StatelessWidget {
  final String? selectedBrands;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const BrandDropDown({required this.selectedBrands, required this.onChanged, required this.selectedCategory, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Brands').snapshots(),
        builder: (context, snapshot){

          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final brandDocs = snapshot.data!.docs;
          List <BrandModel> brands = [];

          for(var doc in brandDocs){
            final brand = BrandModel.fromSnapshot(doc);

            if(brand.category == selectedCategory){
              brands.add(brand);
            }
          }
          return DropdownButtonFormField<String>(
            value: selectedBrands,
            onChanged: onChanged,
            decoration: const InputDecoration(
              labelText: 'Select Brand',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.cyan)
              ),
            ),
            items: brands.map((BrandModel brand){
              return DropdownMenuItem<String>(
                value: brand.brand,
                child: Text(brand.brand, style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Please select a Brand';
              }
              return null;
            },
          );
        }
    );
  }
}