import 'package:ann_shop_flutter/view/inapp/list_blog.dart';
import 'package:flutter/material.dart';

class BlogView extends StatefulWidget {
  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ann Blog'),
      ),
      body: _buildPageData(),
    );
  }

  Widget _buildPageData() {
    return ListBlog();
  }
}
