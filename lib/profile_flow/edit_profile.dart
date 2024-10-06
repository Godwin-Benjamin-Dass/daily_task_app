import 'package:daily_task_app/models/profile_model.dart';
import 'package:daily_task_app/providers/profile_provider.dart';
import 'package:daily_task_app/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, this.isCreate = false, this.profile});
  final bool isCreate;
  final ProfileModel? profile;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    _setController();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController drivingController = TextEditingController();
  TextEditingController electionController = TextEditingController();
  _setController() {
    if (widget.profile != null) {
      nameController.text = widget.profile!.name!;
      bloodController.text = widget.profile!.bloodGroup!;
      dobController.text = widget.profile!.dob!;
      phoneController.text = widget.profile!.phoneNo!;
      emailController.text = widget.profile!.email!;
      addressController.text = widget.profile!.address!;
      aadharController.text = widget.profile!.aadharNo!;
      panController.text = widget.profile!.panNo!;
      drivingController.text = widget.profile!.drivingLisence!;
      electionController.text = widget.profile!.electionCard!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.isCreate
            ? null
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.isCreate ? 'Set up Profile' : 'Edit Profile',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Name*: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Blood group*: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: bloodController,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'DOB*: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: dobController,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Phone no*: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Email id*: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Address: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Aadhar no: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: aadharController,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Pan no: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: panController,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Driving lisence: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: drivingController,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Election card: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: electionController,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: InputBorder.none),
                      ))),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () {
                      if (nameController.text.trim() == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter your name')));
                        return;
                      }
                      if (bloodController.text.trim() == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please enter your blood group')));
                        return;
                      }
                      if (dobController.text.trim() == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter your dob')));
                        return;
                      }
                      if (phoneController.text.trim() == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter your phone no')));
                        return;
                      }
                      if (emailController.text.trim() == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter your email id')));
                        return;
                      }
                      ProfileService.setProfileData(
                              profile: ProfileModel(
                                  name: nameController.text.trim(),
                                  bloodGroup: bloodController.text.trim(),
                                  dob: dobController.text.trim(),
                                  phoneNo: phoneController.text.trim(),
                                  email: emailController.text.trim(),
                                  electionCard: electionController.text.trim(),
                                  aadharNo: aadharController.text.trim(),
                                  address: addressController.text.trim(),
                                  drivingLisence: drivingController.text.trim(),
                                  panNo: panController.text.trim()))
                          .then((val) {
                        if (widget.isCreate) {
                          Provider.of<ProfileProvider>(context, listen: false)
                              .setNew = false;
                        } else {
                          Navigator.pop(context, true);
                        }
                      });
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
