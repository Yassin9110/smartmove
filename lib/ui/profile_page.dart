import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:smart/core/app_theme.dart';

import '../auth/data/datasorce/authentication_remote_ds/authentication.dart';
import '../auth/data/model/user_model.dart';
import '../auth/presentation/bloc/auth_bloc/authentication_bloc.dart';
import '../auth/presentation/bloc/user_data_bloc/user_data_bloc.dart';
import '../auth/presentation/pages/login_page.dart';
import '../core/networks/network_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController emergencyNameController;
  late TextEditingController emergencyNumberController;

  UserModel? currentUser;

  bool isProfileModified = false; // لتحديد إذا كان هناك تعديل أم لا

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    emergencyNameController = TextEditingController();
    emergencyNumberController = TextEditingController();

    // Fetch user data when the page initializes
    context.read<UserBloc>().add(GetUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoadedState) {
            currentUser = state.usersModel;
            nameController.text = currentUser?.name ?? '';
            ageController.text = currentUser?.age.toString() ?? '';
            emergencyNameController.text = currentUser?.emergencyName ?? '';
            emergencyNumberController.text = currentUser?.emergencyNumber ?? '';
          }
        },
        builder: (context, state) {
          if (state is UserLoadingState) {
            return Center(child: CircularProgressIndicator(color: primaryColor,));
          } else if (state is UserLoadedState) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9), // جعل ال width متوافق مع حجم الشاشة
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lottie animation for decoration (optional)
                      const SizedBox(height: 30),
                      //Lottie.asset('assets/profile.json', height: 150),
                      const SizedBox(height: 20),
                      _buildReadOnlyField('Email', currentUser?.email ?? ''),
                      _buildEditableField('Name', nameController, Icons.person),
                      _buildEditableField('Age', ageController, Icons.calendar_today),
                      _buildEditableField('Emergency Name', emergencyNameController, Icons.contact_page),
                      _buildEditableField('Emergency Number', emergencyNumberController, Icons.phone),
                      const SizedBox(height: 20),
                      _buildSaveButton(),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MaterialButton(
                          onPressed: _logout,
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('No user data found.'));
        },
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.email),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          setState(() {
            isProfileModified = true;
          });
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),

        ),

        cursorColor: primaryColor,
      ),
    );
  }


  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isProfileModified ? primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        onPressed: isProfileModified ? _saveChanges : null,
        child: const Text(
          'Save Changes',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  void _saveChanges() {
    if (currentUser != null) {
      UserModel updatedUser = currentUser!.copyWith(
        name: nameController.text.trim(),
        age: int.tryParse(ageController.text.trim()) ?? currentUser!.age,
        emergencyName: emergencyNameController.text.trim(),
        emergencyNumber: emergencyNumberController.text.trim(),
      );

      // Trigger the UserBloc to update Firestore
      context.read<UserBloc>().add(UpdateUserEvent(userModel: updatedUser));

      setState(() {
        isProfileModified = false;
      });
    }
  }

  Future<void> _logout() async {
    // Show confirmation dialog
    bool? isConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User pressed "Cancel"
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User pressed "OK"
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    // If the user confirms, proceed with logging out
    if (isConfirmed ?? false) {
      await AuthenticationRemoteDsImpl(
        networkInfo: NetworkInfoImpl(connectionChecker: InternetConnectionChecker()),
      ).signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

}