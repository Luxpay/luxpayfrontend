import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:luxpay/views/accountSettings/verifyEmail.dart';
import '../../models/aboutUser.dart';
import '../../models/errors/authError.dart';
import '../../networking/DioServices/dio_client.dart';
import '../../networking/DioServices/dio_errors.dart';
import '../../utils/colors.dart';
import '../../utils/hexcolor.dart';
import '../../utils/sizeConfig.dart';
import '../../widgets/lux_buttons.dart';
import '../../widgets/lux_textfield.dart';
import '../../widgets/methods/showDialog.dart';
import '../../widgets/util.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String selected_gender = 'Male';
  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerMiddleName = TextEditingController();
  bool _isLoading = false;
  var errors;
  DateTime dateTime = DateTime.now();
  String dateFormate = '';
  String? dateOfBirth, nothing;
  var fileImage;
  var memoryImage;
  final color = Colors.blue;
  var userAvatar;

  String checkImage = 'false';

  bool verifyEmail = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      aboutUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
            //margin: EdgeInsets.only(left: 30, right: 30),
            width: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: HexColor("#333333").withOpacity(0.3),
                        width: 0.5,
                      ),
                    )),
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () => {Navigator.pop(context)},
                              icon: const Icon(Icons.arrow_back_ios_new)),
                          const Text(
                            "Profile Details",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            child: verifyEmail == true
                                ? null
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VerifyEmail()));
                                    },
                                    child: const Text(
                                      "Verify Email",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 80, left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: grey4,
                                shape: BoxShape.circle,
                              ),
                              child: fileImage != null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(300.0),
                                      child: fileImage == null
                                          ? Icon(
                                              Icons.person,
                                              size: 100,
                                              color: grey2,
                                            )
                                          : Image.file(
                                              fileImage,
                                              fit: BoxFit.cover,
                                            ),
                                    )
                                  : CircleAvatar(
                                      radius: 30.5,
                                      backgroundImage:
                                          NetworkImage("${userAvatar}"),
                                      backgroundColor: Colors.transparent,
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 1,
                              child: InkWell(
                                  onTap: () {
                                    _showChoiceDialog(context);
                                  },
                                  child: buildEditIcon(color)),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 2.2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LuxTextField(
                              hint: "First Name",
                              controller: controllerFirstName,
                              innerHint: "eg john",
                            ),
                            Text(
                              "* first name can contain only letters",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 2.2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LuxTextField(
                                hint: "Middle Name",
                                controller: controllerMiddleName,
                                innerHint: "eg green",
                                onChanged: (v) {}),
                            Text(
                              "* middle name can contain only letters",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 2.2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LuxTextField(
                                hint: "Last Name",
                                controller: controllerLastName,
                                innerHint: "eg blak",
                                onChanged: (v) {}),
                            Text(
                              "* last name can contain only letters",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 2.2,
                        ),
                        LuxTextField(
                            hint: "Email",
                            controller: controllerEmail,
                            innerHint: "eg johnson@gmail.com",
                            onChanged: (v) {}),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Gender",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: HexColor("#1E1E1E")),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 8),
                              color: HexColor("#E8E8E8").withOpacity(0.35),
                              child: Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text("Select Gender: "),
                                    ),
                                    DropdownButton<String>(
                                      value: selected_gender,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      elevation: 16,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: HexColor("#1E1E1E"),
                                          fontWeight: FontWeight.w300),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selected_gender = newValue!;
                                          print(selected_gender);
                                        });
                                      },
                                      items: <String>['Male', 'Female']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical! * 2.2,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: Text(
                                  "Date Of Birth",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: HexColor("#1E1E1E")),
                                )),
                                SizedBox(height: 8),
                                Container(
                                    height: 55,
                                    color:
                                        HexColor("#E8E8E8").withOpacity(0.35),
                                    child: InkWell(
                                        onTap: () {
                                          Utils.showSheet(
                                            context,
                                            child: buildDatePicker(),
                                            onClicked: () {
                                              final value =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(dateTime);
                                              // Utils.showSnackBar(
                                              //     context, 'Selected "$value"');
                                              setState(() {
                                                dateOfBirth = value.toString();
                                                debugPrint(
                                                    "Date Of Birth : $dateOfBirth");
                                              });

                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: Text(
                                                "Pick Date of Birth",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: Text(dateOfBirth ?? "",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            )
                                          ],
                                        ))),
                                Text(
                                  "* User must be 18 years or older",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 4.0,
                        ),
                        InkWell(
                            onTap: () async {
                              var first_name = controllerFirstName.text.trim();
                              var last_name = controllerLastName.text.trim();
                              var middle_name =
                                  controllerMiddleName.text.trim();
                              var gender = selected_gender;
                              var birthDate = dateOfBirth.toString();
                              var email = controllerEmail.text.trim();

                              var validators = [
                                //imagePicked == false ? "Upload your image" : null,
                                first_name.isEmpty
                                    ? "Please Enter your first name"
                                    : null,
                                last_name.isEmpty
                                    ? "Please Enter your last name"
                                    : null,
                                middle_name.isEmpty
                                    ? "Please Enter your last name"
                                    : null,
                                gender.isEmpty ? "select gender" : null,
                                birthDate.isEmpty ? "Pick a BirthDate" : null,
                              ];
                              if (validators
                                  .any((element) => element != null)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(validators.firstWhere(
                                                (element) => element != null) ??
                                            "")));
                                return;
                              }
                              setState(() {
                                _isLoading = true;
                              });
                              var response = await updateAccount(
                                  firstName: first_name,
                                  lastName: last_name,
                                  gender: gender,
                                  middleName: middle_name,
                                  dateOfBirth: birthDate);

                              updateUserAvatar(
                                image: fileImage,
                              );

                              updateUserEmail(
                                email,
                              );

                              if (!response) {
                                setState(() {
                                  _isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(errors)));
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                                showErrorDialog(context,
                                    "Profile Successfully Updated", "Profile");
                              }
                            },
                            child: _isLoading
                                ? luxButtonLoading(
                                    HexColor("#D70A0A"), double.infinity)
                                : luxButton(HexColor("#D70A0A"), Colors.white,
                                    "Save", double.infinity,
                                    fontSize: 16)),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 3.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      )),
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) async {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    onTap: () {
                      _openGallery();
                    },
                    title: Text("Gallery"),
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Camera"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 12,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  void _openGallery() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    final file = File(pickedFile.path);
    setState(() {
      fileImage = file;
    });
    final bytes = await pickedFile.readAsBytes();
    setState(() {
      memoryImage = bytes;
    });
    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;
    final file = File(pickedFile.path);
    setState(() {
      fileImage = file;
    });
    final bytes = await pickedFile.readAsBytes();
    setState(() {
      memoryImage = bytes;
    });

    Navigator.pop(context);
  }

  Widget buildDatePicker() => SizedBox(
        height: 600,
        child: CupertinoDatePicker(
          minimumYear: 1950,
          maximumYear: DateTime.now().year,
          initialDateTime: dateTime,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
        ),
      );

  Future<bool> updateAccount(
      {required String? firstName,
      required String? lastName,
      required String? dateOfBirth,
      required String? gender,
      required String? middleName}) async {
    Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'gender': gender,
      'date_of_birth': dateOfBirth,
    };

    try {
      var response = await dio.put(
        "/user/profile/",
        data: body,
      );
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('${response.statusCode}');
        debugPrint('${data}');
        return true;
      } else {
        setState(() {
          _isLoading = false;
        });

        return false;
      }
    } on DioError catch (e) {
      final errorMessage = DioException.fromDioError(e).toString();
      if (e.response != null) {
        handleStatusCode(e.response?.statusCode, context);
        if (e.response?.statusCode == 401) {
          showExpiredsessionDialog(
              context, "Please Login again\nThanks", "Expired Session");
          return false;
        } else {
          setState(() {
            _isLoading = false;
          });
          var errorData = e.response?.data;
          var errorMessage = await AuthError.fromJson(errorData);
          errors = errorMessage.message;
          return false;
        }
      } else {
        errors = errorMessage;
        showErrorDialog(context, errors, "Luxpay");
        return false;
      }
    } catch (e) {
      debugPrint('${e}');
      return false;
    }
  }

  Future<bool> updateUserAvatar({
    required File? image,
  }) async {
    String fileName = image!.path.split('/').last;
    FormData formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(image.path, filename: fileName),
    });
    //debugPrint("UserUpdate: ${formData.toString}");

    try {
      var response = await dio.patch(
        "/user/profile/avatar/",
        data: formData,
      );

      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('${response.statusCode}');
        debugPrint('${data}');
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      final errorMessage = DioException.fromDioError(e).toString();
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          showExpiredsessionDialog(
              context, "Please Login again\nThanks", "Expired Session");
          return false;
        } else {
          var errorData = e.response?.data;
          var errorMessage = await AuthError.fromJson(errorData);
          errors = errorMessage.message;
          return false;
        }
      } else {
        errors = errorMessage;
        return false;
      }
    } catch (e) {
      debugPrint('${e}');
      return false;
    }
  }

  Future<bool> aboutUser() async {
    try {
      var response = await dio.get(
        "/user/profile/",
      );
      debugPrint('Data Code ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('${response.statusCode}');
        debugPrint('Check Data ${data}');

        var user = await AboutUser.fromJson(data);

        setState(() {
          controllerFirstName.text = user.data.firstName;
          controllerLastName.text = user.data.lastName;
          controllerEmail.text = user.data.email;
          controllerMiddleName.text = user.data.middleName ?? "N/A";
          //selected_gender = user.data.gender;
          userAvatar = user.data.avatar;
          verifyEmail = user.data.emailVerified;
        });

        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      final errorMessage = DioException.fromDioError(e).toString();
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          showExpiredsessionDialog(
              context, "Please Login again\nThanks", "Expired Session");
          return false;
        } else {
          var errorData = e.response?.data;
          var errorMessage = await AuthError.fromJson(errorData);
          errors = errorMessage.message;
          return false;
        }
      } else {
        errors = errorMessage;
        return false;
      }
    } catch (e) {
      debugPrint('${e}');
      return false;
    }
  }

  Future<bool> updateUserEmail(email) async {
    Map<String, dynamic> body = {"email": email};
    var response = await dio.patch("/user/email/", data: body);
    debugPrint('Data Code ${response.statusCode}');
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      final errorMessage = DioException.fromDioError(e).toString();
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          showExpiredsessionDialog(
              context, "Please Login again\nThanks", "Expired Session");
          return false;
        } else {
          var errorData = e.response?.data;
          var errorMessage = await AuthError.fromJson(errorData);
          errors = errorMessage.message;
          return false;
        }
      } else {
        errors = errorMessage;
        return false;
      }
    } catch (e) {
      debugPrint('${e}');
      return false;
    }
  }
}
