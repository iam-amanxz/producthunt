import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:producthunt/core/common/widgets/my_button.dart';
import 'package:producthunt/core/theme/app_palette.dart';
import 'package:producthunt/core/util/show_snackbar.dart';

import '../../../../core/common/widgets/app_name.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../blocs/products_create/products_create_bloc.dart';
import '../blocs/products_list/products_list_bloc.dart';

@RoutePage()
class ProductCreatePage extends StatefulWidget {
  const ProductCreatePage({super.key});

  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  int _rating = 5;
  Color? _selectedColor;
  XFile? _image;
  final _brandController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _brandController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCreatePageBloc, ProductCreatePageState>(
      listener: (context, state) {
        if (state is ProductCreateSuccess) {
          _showSnackbar("Product created successfully");
          context.read<ProductsListPageBloc>().add(const LoadProductsEvent());
          AutoRouter.of(context).maybePop();
        }
        if (state is ProductCreateFailure) {
          _showSnackbar("Failed to create product", isSuccess: false);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  void _showSnackbar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const AppName(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _brandController,
              hintText: 'Product Brand',
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _nameController,
              hintText: 'Product Name *',
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _descriptionController,
              hintText: 'Product Description',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const _SectionTitle(title: "Product Rating *"),
            const SizedBox(height: 10),
            _buildRatingStars(),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: _buildImagePicker()),
                const SizedBox(width: 15.0),
                Expanded(child: _buildColorPicker()),
              ],
            ),
            const SizedBox(height: 20),
            MyButton(onPressed: _createProduct, label: "Create Product")
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      maxLines: maxLines,
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(10, (index) {
        bool isSelected = index < _rating;
        return GestureDetector(
          child: Icon(
            Icons.star,
            color: isSelected ? Colors.amber : AppPalette.schabzigerGreen,
            size: 30,
          ),
          onTap: () {
            setState(() {
              _rating = index + 1;
            });
          },
        );
      }),
    );
  }

  Widget _buildImagePicker() {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: "Product Image *"),
          const SizedBox(height: 10),
          Expanded(
            child: GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? const _PlaceholderBox(icon: Icons.image)
                  : _SelectedImage(image: _image!),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Widget _buildColorPicker() {
    return GestureDetector(
      onTap: _pickColor,
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(title: "Product Color"),
            const SizedBox(height: 10),
            Expanded(
              child: _PlaceholderBox(
                icon: Icons.color_lens,
                backgroundColor: _selectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickColor() {
    ColorPicker(
      color: _selectedColor ?? AppPalette.greigeViolet,
      onColorChanged: (color) {
        setState(() {
          _selectedColor = color;
        });
      },
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: false,
      },
      heading: Text(
        'Select Product Color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select Shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
    ).showPickerDialog(
      context,
      transitionBuilder: (
        BuildContext context,
        Animation<double> a1,
        Animation<double> a2,
        Widget widget,
      ) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  void _createProduct() {
    if (_image == null || _nameController.text.isEmpty) {
      showSnackbar(context, "Please fill required fields", isSuccess: false);
      return;
    }

    context.read<ProductsCreatePageBloc>().add(
          CreateProductEvent(
            params: CreateProductParams(
              image: _image!,
              name: _nameController.text,
              rating: _rating,
              brandName: _brandController.text,
              description: _descriptionController.text,
              color: _selectedColor?.value.toRadixString(10),
            ),
          ),
        );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _PlaceholderBox extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;

  const _PlaceholderBox({
    required this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppPalette.schabzigerGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          icon,
          color: (backgroundColor ?? AppPalette.schabzigerGreen)
                      .computeLuminance() >
                  0.5
              ? AppPalette.crownBlue
              : Colors.white,
          size: 50,
        ),
      ),
    );
  }
}

class _SelectedImage extends StatelessWidget {
  final XFile image;

  const _SelectedImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(image.path),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
