import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultPlaceHolder extends StatelessWidget {
  const DefaultPlaceHolder();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (Platform.isIOS && false)
            Center(
              child: CupertinoActivityIndicator(
                radius: 15,
              ),
            )
          else
            Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              ),
            ),
          Text("Load video..."),
        ],
      ),
    );
  }
}
