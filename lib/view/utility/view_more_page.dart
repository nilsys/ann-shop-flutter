import 'package:ann_shop_flutter/core/core.dart';
import 'package:ann_shop_flutter/core/utility.dart';
import 'package:ann_shop_flutter/provider/response_provider.dart';
import 'package:ann_shop_flutter/repository/inapp_repository.dart';
import 'package:ann_shop_flutter/ui/utility/html_content.dart';
import 'package:ann_shop_flutter/ui/utility/indicator.dart';
import 'package:ann_shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:flutter/material.dart';

class ViewMorePage extends StatefulWidget {
  ViewMorePage(this.slug);

  final slug;

  @override
  _ViewMorePageState createState() => _ViewMorePageState();
}

class _ViewMorePageState extends State<ViewMorePage> {
  ResponseProvider<Map> data = ResponseProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  _loadData() async {
    data.loading = 'loading';
    Map result =
        await InAppRepository.instance.loadContentViewMore(widget.slug);
    setState(() {
      if (result == null) {
        data.error = 'error';
      } else {
        data.completed = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Đang tải...'),
        ),
        body: Container(child: Indicator()),
      );
    } else if (data.isError) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Đang tải...'),
        ),
        body: Container(child: SomethingWentWrong(
          onReload: () {
            setState(() {
              data.loading = 'loading';
            });
            _loadData();
          },
        )),
      );
    } else {
      String title = data.data['title'] ?? 'Thông báo';
      String content = data.data['content'];
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Utility.isNullOrEmpty(content)
              ? Center(
                  child: Text('Không có nội dung'),
                )
              : ListView(
                  children: <Widget>[
                    SizedBox(height: 15,),
                    HtmlContent(content),
                  ],
                ),
        ),
      );
    }
  }
}
