
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Constant.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';

class ReferEarn extends StatefulWidget {
  @override
  _ReferEarnState createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: getAppBar('Refer and Earn', context),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/refer.svg",
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Text(
                    'Refer and Earn',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: primary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                     'Invite your friends to join and get the reward as soon as your friend first order placed',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Text(
                    'Your Referral Code',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: primary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: new BoxDecoration(
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: secondary,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        refferCode ?? '',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          new BorderRadius.all(const Radius.circular(4.0))),
                      child: Text('Tap to copy',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.button!.copyWith(
                            color: primary,
                          ))),
                  onPressed: () {
                    Clipboard.setData(new ClipboardData(text: refferCode));
                    setSnackbar('Refercode Copied to clipboard');
                  },
                ),
                SimBtn(
                  size: 100,
                  title:  "SHARE_APP",
                  onBtnSelected: () {
                    var str =
                        "$appName\nRefer Code:${refferCode}\n${ 'APPFIND'}";
                    Share.share(str);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: primary,
      elevation: 1.0,
    ));
  }


  SimBtn({double? size, String? title, VoidCallback ? onBtnSelected}){
    return CupertinoButton(
      child: Container(
          width: size,
          height: 35,
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(

            color: primary,
            borderRadius: new BorderRadius.all(const Radius.circular(5.0)),
          ),
          child: Text(title!,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.normal))),
      onPressed: () {
        onBtnSelected!();
      },
    );
  }
String? refferCode ;
  getUserDetails() async{
    refferCode = await getPrefrence(REFER);
    setState(() {});
  }
}