import 'package:flutter/material.dart';
import 'package:testshoesmart/helper/color_app/color_app.dart';
import 'package:testshoesmart/helper/font_setting/font_setting.dart';
import 'package:testshoesmart/helper/hex_color/hex_color.dart';

class PButton {
  MainButton(String textButton, Function function) {
    return Center(
      child: ButtonTheme(
        minWidth: double.infinity,
        child: RaisedButton(
          elevation: 0,
          color: ColorApp.main_color_app,
          highlightElevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(textButton,
              style: TextStyle(
                  fontFamily: FontSetting.fontButton,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 14)),
          onPressed: function,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(4)),
        ),
      ),
    );
  }

  RoundedMainButton(String textButton, Function function) {
    return Center(
      child: ButtonTheme(
        minWidth: double.infinity,
        child: RaisedButton(
          elevation: 1,
          color: ColorApp.main_color_app,
          highlightElevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(textButton,
              style: TextStyle(
                  fontFamily: FontSetting.fontButton,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 14)),
          onPressed: function,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30)),
        ),
      ),
    );
  }

  RedButton(String textButton, Function function) {
    return Center(
      child: ButtonTheme(
        minWidth: double.infinity,
        child: RaisedButton(
          elevation: 0,
          color: HexColor("#F98080"),
          highlightElevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(textButton,
              style: TextStyle(
                  fontFamily: FontSetting.fontButton,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 14)),
          onPressed: function,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(4)),
        ),
      ),
    );
  }

  WhiteButton(String textButton, Function function) {
    return Center(
      child: ButtonTheme(
        minWidth: double.infinity,
        child: OutlineButton(
          color: HexColor("#FFFFFF"),
          borderSide: BorderSide(color: HexColor("#BCBCBC").withOpacity(0.250)),
          splashColor: ColorApp.main_color_app.withOpacity(0.1),
          highlightColor: ColorApp.main_color_app.withOpacity(0.1),
          highlightedBorderColor: ColorApp.main_color_app.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(textButton,
              style: TextStyle(
                  fontFamily: FontSetting.fontButton,
                  fontWeight: FontWeight.w600,
                  color: ColorApp.main_color_app,
                  fontSize: 14)),
          onPressed: function,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(4)),
        ),
      ),
    );
  }

  WhiteFlatWithThinTextButton(String textButton, Function function) {
    return Center(
      child: ButtonTheme(
        minWidth: double.infinity,
        child: FlatButton(
          color: HexColor("#FFFFFF"),
          splashColor: ColorApp.main_color_app.withOpacity(0.1),
          highlightColor: ColorApp.main_color_app.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(textButton,
              style: TextStyle(
                  fontFamily: FontSetting.fontButton,
                  fontWeight: FontWeight.w400,
                  color: ColorApp.main_color_app,
                  fontSize: 13)),
          onPressed: function,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5)),
        ),
      ),
    );
  }

  IconImageButton(
      {String textButton,
      Color colorHighlightButton,
      Color colorBorderButton,
      Color colorTextButton,
      String urlIcon,
      Function function}) {
    return Center(
      child: ButtonTheme(
        minWidth: double.infinity,
        child: FlatButton.icon(
          highlightColor: colorHighlightButton,
          splashColor: colorHighlightButton,
          icon: Image.asset(
            urlIcon,
            width: 20.0,
            height: 20.0,
          ),
          color: Colors.white24,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          label: Text(textButton,
              style: TextStyle(
                  fontFamily: FontSetting.fontButton,
                  fontWeight: FontWeight.w600,
                  color: colorTextButton,
                  fontSize: 14)),
          onPressed: function,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30),
              side: BorderSide(color: colorBorderButton.withOpacity(0.1))),
        ),
      ),
    );
  }
}
