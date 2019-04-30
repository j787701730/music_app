import 'package:flutter/material.dart';
import '../pageLoading.dart';

//import 'detailContent.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CommonListView extends StatelessWidget {
  final data;

  CommonListView(this.data);

  void open(BuildContext context, final int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPhotoViewWrapper(
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                imageProviders: data['data'],
                index: index,
              ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: data.isEmpty
            ? PageLoading()
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    height: 220,
                    margin: EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        open(context, index);
                      },
                      child: Image.network(
                        data['data'][index]['url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                itemCount: data['data'].length,
              ));
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.imageProviders,
    this.loadingChild,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.index,
  }) : pageController = PageController(initialPage: index);

  List imageProviders;

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int index;
  final PageController pageController;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.index;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery(
                scrollPhysics: const BouncingScrollPhysics(),
//                pageOptions: <PhotoViewGalleryPageOptions>[
//                  PhotoViewGalleryPageOptions(
//                    imageProvider: widget.imageProvider,
//                    heroTag: "tag1",
//                  ),
//                  PhotoViewGalleryPageOptions(
//                      imageProvider: widget.imageProvider2,
//                      heroTag: "tag2",
//                      maxScale: PhotoViewComputedScale.contained * 0.3),
//                  PhotoViewGalleryPageOptions(
//                    imageProvider: widget.imageProvider3,
//                    initialScale: PhotoViewComputedScale.contained * 0.8,
//                    minScale: PhotoViewComputedScale.contained * 0.8,
//                    maxScale: PhotoViewComputedScale.covered * 1.1,
//                    heroTag: "tag3",
//                  ),
//                ],
                pageOptions: widget.imageProviders.map<PhotoViewGalleryPageOptions>((item) {
                  return PhotoViewGalleryPageOptions(imageProvider: NetworkImage(item['url']));
                }).toList(),
                loadingChild: widget.loadingChild,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Image ${currentIndex + 1}",
                  style: const TextStyle(color: Colors.white, fontSize: 17.0, decoration: null),
                ),
              )
            ],
          )),
    );
  }
}
