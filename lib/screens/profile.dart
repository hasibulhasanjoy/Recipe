import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/screens/favorite.dart';
import 'package:recipe/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Fetch user data from Firestore
  Future<void> _getUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        // Fetch user data from Firestore
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userData.exists) {
          setState(() {
            name = userData.data()?['name'] ?? 'User';
            isLoading = false;
          });
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error if fetching user data fails
      print('Error fetching user data: $error');
    }
  }

  void _navigateToFavoriteScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const FavoriteScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF48B04C),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF48B04C),
              ),
            ) // Show loading indicator while data is being fetched
          : Column(
              children: [
                const SizedBox(height: 20),
                // User Image
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Colors.grey.shade200, // Light background for icon
                    child: const Icon(
                      Icons.person, // Default user icon
                      size: 50,
                      color: Colors.grey, // Icon color
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Full Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Favorites Card
                Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _navigateToFavoriteScreen(context),
                    child: const ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      title: Text(
                        "Favorites",
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                    ),
                  ),
                ),

                // can be added my recipe card if needed in the future

                // sign out card
                Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _signOut,
                    child: const ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      title: Text(
                        "Sign Out",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red, // Highlight sign-out in red
                        ),
                      ),
                      trailing: Icon(Icons.logout, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _signOut() async {
    FirebaseAuth.instance.signOut();

    // Clear login state from SharedPreferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('isLoggedIn');

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }
}
