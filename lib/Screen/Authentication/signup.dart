import 'dart:convert';
import 'dart:io';

import 'package:eshopmultivendor/Helper/AppBtn.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/ContainerDesing.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Helper/app_assets.dart';
import 'package:eshopmultivendor/Screen/Authentication/Login.dart';
import 'package:eshopmultivendor/Screen/Home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Helper/Color.dart';

class SigUpScreen extends StatefulWidget {
  const SigUpScreen({Key? key}) : super(key: key);

  @override
  State<SigUpScreen> createState() => _SigUpScreenState();
}

class _SigUpScreenState extends State<SigUpScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final nameController = TextEditingController();
  final shopNameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final referralController = TextEditingController();

  final bankNameController = TextEditingController();
  final accountNoController = TextEditingController();
  final accountNameController = TextEditingController();
  final ifscController = TextEditingController();

  final nameFocus = FocusNode();
  final shopFocus = FocusNode();
  final contactFocus = FocusNode();
  final emailFocus = FocusNode();
  final referralFocus = FocusNode();

  final bankNameFocus = FocusNode();
  final accountNoFocus = FocusNode();
  final accountNameFocus = FocusNode();
  final ifscFocus = FocusNode();

  final ImagePicker _picker = ImagePicker();
  File? gstFile;
  File? imagefssai;
  File? imagepan;
  File? imageadhar;
  File? selfieImage;
  File? shopImage;
   String? sellerRegistrationCharge ;
   String? userId ;

  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  late Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSettings();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);


    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    buttonSqueezeanimation = new Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController!,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Stack(
          children: [
            backBtn(),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: back(),
            ),
            Image.asset(
              'assets/images/doodle.png',
              color: primary,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            //getBgImage(),
            getLoginContainer(),
            getLogo(),
          ],
        ));
  }

  backBtn() {
    return Platform.isIOS
        ? Container(
            padding: EdgeInsetsDirectional.only(top: 20.0, start: 10.0),
            alignment: AlignmentDirectional.topStart,
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 4.0),
                child: InkWell(
                  child: Icon(Icons.keyboard_arrow_left, color: primary),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ))
        : Container();
  }

  getLoginContainer() {
    return Positioned.directional(
      start: MediaQuery.of(context).size.width * 0.025,
      // end: width * 0.025,
      // top: width * 0.45,
      top: MediaQuery.of(context).size.height * 0.2, //original
      //    bottom: height * 0.1,
      textDirection: Directionality.of(context),
      child: ClipPath(
        clipper: ContainerClipper(),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom * 0.8),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.95,
          color: Colors.white,
          child: Form(
            key: _formkey,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 2.5,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      Text('Step-1',style: TextStyle(color: primary, fontSize: 20), ),
                    Container(
                  decoration: BoxDecoration(
                  border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          registerTxt(
                              getTranslated(context, 'SELLER_REGISTER_DETAILS')!),
                          customTextField(
                              nameController,
                              nameFocus,
                              getTranslated(context, 'NAME_LBL') ?? '',
                              Icons.account_circle_outlined),
                          customTextField(
                              shopNameController,
                              shopFocus,
                              getTranslated(context, 'SHOP_LBL') ?? '',
                              Icons.shop_outlined),
                          customTextField(
                              contactController,
                              contactFocus,
                              getTranslated(context, 'MobileNumber') ?? '',
                              Icons.phone_android_outlined,isFromMobile: true),
                          customTextField(
                              emailController,
                              emailFocus,
                              getTranslated(context, 'Email') ?? '',
                              Icons.email_outlined),

                          customTextField2(
                              referralController,
                              referralFocus,
                              'Referral Code',
                              Icons.all_inclusive_sharp),
                          SizedBox(
                            height: 10,
                          ),
                          uploadImage(),
                          SizedBox(height: 10,),
                          uploadSelfie(),
                          SizedBox(height: 10,),
                          uploadShopPhoto(),
                          SizedBox(height: 10,)


                          //showPass(),
                          //verifyBtn(),
                          //loginTxt(),
                        ],
                      ),
                    ),
                      SizedBox(height: 20,),
                      Text('Step-2',style: TextStyle(color: primary, fontSize: 20), ),
                      Container(decoration: BoxDecoration(
                          border: Border.all(color: primary),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          registerTxt(
                              getTranslated(context, 'ACCOUNTDETAIL')!),
                          customTextField(
                              accountNoController,
                              accountNoFocus,
                              getTranslated(context, 'AccountNumber') ?? '',
                              Icons.account_balance),
                          customTextField(
                              accountNameController,
                              accountNameFocus,
                              getTranslated(context, 'AccountName') ?? '',
                              Icons.person_outline,),
                          customTextField(
                            ifscController,
                            ifscFocus,
                            'IFSC Code' ?? '',
                            Icons.account_balance,),
                          customTextField(
                            bankNameController,
                            bankNameFocus,
                            getTranslated(context, 'BankName') ?? '',
                            Icons.account_balance,),

                      ],),),
                      SizedBox(height: 20,),
                      Text('Step-3',style: TextStyle(color: primary, fontSize: 20), ),
                      signupBtn(),
                      Text('Registration Fee ₹${(sellerRegistrationCharge ?? '')}, Pay and signup', style: TextStyle(color: primary),),



                  ],),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget registerTxt(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(text,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: primary, fontWeight: FontWeight.bold, fontSize: 25)),
      ),
    );
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      if(imagepan == null){
        Fluttertoast.showToast(msg: 'Upload pan Card');
      }else if(imageadhar == null){
        Fluttertoast.showToast(msg: 'Upload Adhar Card');
      }else if(selfieImage == null){
        Fluttertoast.showToast(msg: 'Upload Selfie');
      }else if(shopImage == null){
        Fluttertoast.showToast(msg: 'Upload Shop photo');
      }else {
        _playAnimation();
      checkNetwork();
      }

    }
  }
  bool _isNetworkAvail = true;

  Future<void> checkNetwork() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
     // getLoginUser();
      signupSeller();
    } else {
      Future.delayed(Duration(seconds: 2)).then(
            (_) async {
          await buttonController!.reverse();
          setState(
                () {
              _isNetworkAvail = false;
            },
          );
        },
      );
    }
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }
  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  signupBtn() {
    return AppBtn(
      title: getTranslated(context, "SIGNUP_LBL")!,
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: ()  async{

        //Navigator.push(context, MaterialPageRoute(builder: (context) => SigUpScreen()));
        validateAndSubmit();
      },
    );
  }

  Widget getLogo() {
    return Positioned(
      left: (MediaQuery.of(context).size.width / 2) - 50,
      top: (MediaQuery.of(context).size.height * 0.2) - 50,
      child: SizedBox(
        width: 100,
        height: 100,
        // child: SvgPicture.asset(
        //   'assets/images/loginlogo.svg',
        // ),
        child: Image.asset(Myassets.login_logo),
      ),
    );
  }

  Widget uploadImage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          gstFile == null ?
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(color: primary),
                borderRadius: BorderRadius.circular(10)),
            child: customIconRow(text: 'Upload GST', icon: Icons.file_copy_outlined, onTap: (){
              _getFromGallery('gst');
            })
          ) : Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: primary),
                  borderRadius: BorderRadius.circular(10)),
              child: customIconRow(text: gstFile.toString(), icon: Icons.file_copy_outlined, onTap: (){
                _getFromGallery('gst');
              })
          ),
          SizedBox(height: 10,),
          imagefssai == null ?
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: primary),
                  borderRadius: BorderRadius.circular(10)),
              child: customIconRow(text: 'Upload fssai', icon: Icons.file_copy_outlined, onTap: (){
                _getFromGallery('fssai');
              })
          ) : Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: primary),
                  borderRadius: BorderRadius.circular(10)),
              child: customIconRow(text: imagefssai.toString(), icon: Icons.file_copy_outlined, onTap: (){
                _getFromGallery('fssai');
              })
          ),
          SizedBox(height: 10,),
          imagepan == null ?
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: primary),
                  borderRadius: BorderRadius.circular(10)),
              child: customIconRow(text: '*Upload PAN', icon: Icons.file_copy_outlined, onTap: (){
                _getFromGallery('pan');
              })
          ) : Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: primary),
                  borderRadius: BorderRadius.circular(10)),
              child: customIconRow(text: imagepan.toString(), icon: Icons.file_copy_outlined, onTap: (){
                _getFromGallery('pan');
              })
          ),
          SizedBox(height: 10,),
          imageadhar == null ?
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: primary),
                  borderRadius: BorderRadius.circular(10)),
              child: customIconRow(text: '*Upload ADHAR', icon: Icons.file_copy_outlined, onTap: (){
                _getFromGallery('adhar');
              })
          ) : Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: primary),
                  borderRadius: BorderRadius.circular(10)),
              child: customIconRow(text: imageadhar.toString(), icon: Icons.file_copy_outlined, onTap: (){
                _getFromGallery('adhar');
              })
          ),

        ],
      ),
    );
  }

  Widget uploadSelfie(){
    return selfieImage==null ? Container(
        height: 200,
        width: 160,
        decoration: BoxDecoration(
            border: Border.all(color: primary),
            borderRadius: BorderRadius.circular(10)),
        child: customIconRow(text: '*Upload Selfie', icon: Icons.photo_camera, onTap: (){
          _getFromCamera();
        })
    ):
    InkWell(
      onTap: (){
        _getFromCamera();
      },
      child: Container(
          height: 200,
          width: 160,
          decoration: BoxDecoration(
              border: Border.all(color: primary),
              borderRadius: BorderRadius.circular(10), image: DecorationImage(image: FileImage(selfieImage!))),

      ),
    );
  }

  Widget uploadShopPhoto(){
    return shopImage==null ? Container(
        height: 160,
        width: 300,
        decoration: BoxDecoration(
            border: Border.all(color: primary),
            borderRadius: BorderRadius.circular(10)),
        child: customIconRow(text: '*UploadShop Photo', icon: Icons.file_copy_outlined, onTap: (){
          _getFromGallery('shopPhoto');
        })
    ):
    InkWell(
      onTap: (){
        _getFromGallery('shopPhoto');
      },
      child: Container(
        height: 160,
        width: 300,
        decoration: BoxDecoration(
            border: Border.all(color: primary),
            borderRadius: BorderRadius.circular(10), image: DecorationImage(image: FileImage(shopImage!,),fit: BoxFit.cover)),

      ),
    );
  }



  Widget customIconRow({String? text, IconData? icon , VoidCallback ? onTap}){

    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,


        children: [
          Icon(icon, color: primary,),
          SizedBox(
            width: 100,
            child: Text(
              text ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: primary),),
          )],),
    );
  }

  customTextField(TextEditingController controller, FocusNode focusNode,
      String hint, IconData icon, {bool? isFromMobile}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 15.0,
        end: 15.0,
      ),
      child: TextFormField(
        keyboardType: isFromMobile ?? false ? TextInputType.number :TextInputType.text,

        textCapitalization: TextCapitalization.words,
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        validator: (val) => isFromMobile ?? false ? validateMob(val!, context)  :validateField(val!, context),
        onSaved: (String? value) {
          //name = value;
        },
        onFieldSubmitted: (v) {
          //_fieldFocusChange(context, nameFocus!, emailFocus);
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primary),
            borderRadius: BorderRadius.circular(7.0),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.black,
            size: 17,
          ),
          hintText: hint+'*',
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: Colors.black, fontWeight: FontWeight.normal),
          // filled: true,
          // fillColor: Theme.of(context).colorScheme.lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 25),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Theme.of(context).colorScheme.fontColor),
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
  customTextField2(TextEditingController controller, FocusNode focusNode,
      String hint, IconData icon) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 15.0,
        end: 15.0,
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        /*validator: (val) => validateField(val!, context),*/
        onSaved: (String? value) {
          //name = value;
        },
        onFieldSubmitted: (v) {
          //_fieldFocusChange(context, nameFocus!, emailFocus);
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primary),
            borderRadius: BorderRadius.circular(7.0),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.black,
            size: 17,
          ),
          hintText: hint,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: Colors.black, fontWeight: FontWeight.normal),
          // filled: true,
          // fillColor: Theme.of(context).colorScheme.lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 25),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Theme.of(context).colorScheme.fontColor),
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }





  _getFromGallery(String type) async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100, maxHeight: 480, maxWidth: 480);
    if (pickedFile != null) {
      setState(() {
        if(type == 'gst'){gstFile = File(pickedFile.path);}
        else if(type == 'fssai'){imagefssai = File(pickedFile.path);}
        else if(type == 'pan'){imagepan = File(pickedFile.path);}
        else if(type == 'adhar'){imageadhar = File(pickedFile.path);}
        else {shopImage = File(pickedFile.path);}

      });
      //Navigator.pop(context);
    }
  }

  _getFromCamera() async {

    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 80,maxHeight: 480, maxWidth: 480);

    if (pickedFile != null) {
      setState(() {
        selfieImage = File(pickedFile.path);
      });
    }
  }



  void openCheckout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? phone = prefs.getString('phone');
   int amt = int.parse(sellerRegistrationCharge!);


    print('${email}_______________');
    print('${phone}_______________');
    //print('${widget.totalAmount.toString()}_______________');
    //print('${amt}_______________');

    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amt*100,
      'name': 'jdx-user',
      'description': 'jdx-user',
      "currency": "INR",
      'prefill': {'contact': '$phone', 'email': '$email'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // RazorpayDetailApi();
    // Order_cash_ondelivery();
    /* advancePayment( widget.data.quotation!.id
        .toString(),
        widget.data.quotation!
            .assignmentId
            .toString(),
        response.paymentId);*/

    //signupSeller();
    verifyPayment(paymentId: response.paymentId);
    Fluttertoast.showToast(
        msg: "Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardScreen()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);

    print('${response.error}________error_________');
    print('${response.code}________code_________');
    verifyPayment();
    Fluttertoast.showToast(
        msg: "Payment cancelled by user",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }


  Future<void> signupSeller() async{


      var headers = {
        'Cookie': 'ci_session=2a448dec2b5f1d65fa090b7daf3b41f27bf416c6'
      };
      var request = http.MultipartRequest('POST', Uri.parse('https://nippy.ind.in/seller/app/v1/api/signup'));
      request.fields.addAll({
        'name': nameController.text,
        'shop_name': shopNameController.text,
        'mobile': contactController.text,
        'email': emailController.text,
        'bank_name': bankNameController.text,
        'account_no': accountNoController.text,
        'account_holder_name': accountNameController.text,
        'ifsc_code': ifscController.text,
        'refferral_code': referralController.text.isEmpty ? '' : referralController.text
      });

      request.files.add(await http.MultipartFile.fromPath('pan_card', imagepan!.path));

      request.files.add(await http.MultipartFile.fromPath('aadhar_card_front', imageadhar!.path));
     request.files.add(await http.MultipartFile.fromPath('shop_image', shopImage!.path));
      request.files.add(await http.MultipartFile.fromPath('image', selfieImage!.path));
      if(imagefssai != null) {
        request.files.add(await http.MultipartFile.fromPath('fassai', imagefssai!.path));
      }
      if(gstFile != null) {
        request.files.add(await http.MultipartFile.fromPath('gst_no', gstFile!.path));
      }

      request.headers.addAll(headers);


      http.StreamedResponse response = await request.send();

      print("_______${request.fields}_______");
      print("_______${request.files}_______");
      print("_______${request.url}_______");
      print("_______${response.statusCode}_______");




      if (response.statusCode == 200) {
       var result = await response.stream.bytesToString();
       var finalresul = jsonDecode(result);
       if(!(finalresul['error'])) {
         userId = finalresul['id'];
         print("_______${userId}_______");
         openCheckout();

        //Fluttertoast.showToast(msg: finalresul['message']);

      }else{

         Fluttertoast.showToast(msg: finalresul['message']);

       }
    }
      else {
        print(response.reasonPhrase);
      }







  }

  Future<void> verifyPayment({String? paymentId}) async{
    var headers = {
      'Cookie': 'ci_session=d789bce1be24c58d888d4d98ada5ff9f97f1128b'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://nippy.ind.in/seller/app/v1/api/update_transactions'));
    request.fields.addAll({
      'user_id': userId ?? '',
      'transaction_id': paymentId ?? ''
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print("_______${request.fields}_______");

    if (response.statusCode == 200) {
      var result  =await response.stream.bytesToString();
      var finalResult  =jsonDecode(result);
      if(!(finalResult['error'])){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
      }else{
        Fluttertoast.showToast(msg: finalResult['message']);
      }

    }
    else {
      print(response.reasonPhrase);
    }

  }


  getSettings() async {
    var parameter = {};
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      apiBaseHelper.postAPICall(getSettingsApi, parameter).then(
            (getdata) async {
          bool error = getdata["error"];
          String msg = getdata["message"];
          if (!error) {
            sellerRegistrationCharge = getdata["data"]["system_settings"][0]["seller_reg_charge"].toString();
          } else {
            setSnackbar(msg);
          }
          setState(
                () {
              //_isLoading = false;
            },
          );
        },
        onError: (error) {
          setSnackbar(error.toString());
        },
      );
    } else {
      setState(
            () {
          //_isLoading = false;
          _isNetworkAvail = false;
        },
      );
    }
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: black,
          ),
        ),
        backgroundColor: white,
        elevation: 1.0,
      ),
    );
  }

}
