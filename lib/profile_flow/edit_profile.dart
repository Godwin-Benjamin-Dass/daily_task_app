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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              height: 34,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (nameController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Please enter your Name')));
                      return;
                    }
                    if (bloodController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Please enter your Blood group')));
                      return;
                    }
                    if (dobController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Please enter your DOB')));
                      return;
                    }
                    if (phoneController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Please enter your Contact number')));
                      return;
                    }
                    if (emailController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Please enter your Email id')));
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
                      Provider.of<ProfileProvider>(context, listen: false)
                          .getProfileDate();
                      if (widget.isCreate) {
                        Provider.of<ProfileProvider>(context, listen: false)
                            .setNew = false;
                      } else {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.isCreate ? 'Set up Profile' : 'Edit Profile',
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Name: *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Blood Group: *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: bloodController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'DOB: *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: dobController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Contact Number: *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Email id: *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Address: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Aadhar Card Number: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: aadharController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Pan Card Number: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: panController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Driving license: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: drivingController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                      ))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Voter Id: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: electionController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                      ))),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
