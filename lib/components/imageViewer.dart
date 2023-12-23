import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final String url;
  const ImageViewer({
    required this.url,
    super.key
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.close)),
        actions: const [Icon(Icons.bookmark_border_outlined)],
      ),
      body: Center(
        child: Draggable(
          feedback: Image.network(widget.url),
          child: Image.network(widget.url),
          onDraggableCanceled: (velocity, offset){
            print(offset);
            if(offset.dy>300){
              Navigator.pop(context);
            }
          },

        ),
        
      ),
    );
  }
}
