import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFullView extends StatelessWidget {
  final String _imageUrl;

  const ImageFullView(this._imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: true),
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        maxScale: 4,
        child: Hero(
          tag: _imageUrl,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: CachedNetworkImageProvider(
                      _imageUrl,
                    ))),
          ),
        ),
      ),
    );
  }
}
