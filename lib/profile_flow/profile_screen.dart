import 'package:daily_task_app/models/profile_model.dart';
import 'package:daily_task_app/profile_flow/edit_profile.dart';
import 'package:daily_task_app/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  bool verificationInfo = false;
  @override
  void initState() {
    super.initState();
    _getProfileData();
  }

  _getProfileData() async {
    isLoading = true;
    setState(() {});
    ProfileModel? profileData =
        await Provider.of<ProfileProvider>(context, listen: false)
            .getProfileDate();
    if (profileData != null) {
      // ignore: use_build_context_synchronously
      Provider.of<ProfileProvider>(context, listen: false).setNew = false;
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Consumer<ProfileProvider>(
            builder: (context, profile, child) => profile.isNew
                ? const EditProfile(
                    isCreate: true,
                  )
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      title: const Text(
                        'Profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 100.0, // Set your desired width
                            height: 100.0, // Set your desired height
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Make the shape circular
                              border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor, // Optional: Add a border
                                width: 0.5, // Optional: Set border width
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/profile.png', // Replace with your image URL
                                  fit: BoxFit.cover,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            profile.profileData!.name!,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            profile.profileData!.email!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black54),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "  ${profile.profileData!.dob!}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.bloodtype_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "  ${profile.profileData!.bloodGroup!}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.call_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "  ${profile.profileData!.phoneNo!}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.home_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "  ${profile.profileData!.address!}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Verification Proof Info ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              Transform.scale(
                                  scale: 0.7,
                                  child: Switch(
                                    value: verificationInfo,
                                    onChanged: (value) {
                                      setState(() {
                                        verificationInfo = value;
                                      });
                                    },
                                  ))
                            ],
                          ),
                          verificationInfo
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const Text(
                                          'Aadhar Card Number: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          profile.profileData!.aadharNo == ''
                                              ? ' -'
                                              : profile.profileData!.aadharNo!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Pan Card Number: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          profile.profileData!.panNo == ''
                                              ? " -"
                                              : profile.profileData!.panNo!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Driving license: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          profile.profileData!.drivingLisence ==
                                                  ''
                                              ? " -"
                                              : profile
                                                  .profileData!.drivingLisence!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Voter ID: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          profile.profileData!.electionCard ==
                                                  ""
                                              ? " -"
                                              : profile
                                                  .profileData!.electionCard!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                        child: const Icon(Icons.edit),
                        onPressed: () async {
                          bool? stat = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                        profile: profile.profileData,
                                      )));
                          if (stat != null) {
                            _getProfileData();
                          }
                        }),
                  ),
          );
  }
}
