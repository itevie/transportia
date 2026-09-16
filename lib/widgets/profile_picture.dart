import 'package:flutter/material.dart';

enum ProfilePictureUsage { nextToName, userProfile }

class ProfilePicture extends StatelessWidget {
  final String url;
  final ProfilePictureUsage usage;

  const ProfilePicture({
    super.key,
    required this.usage,
    this.url =
        "https://images.unsplash.com/photo-1789353287713-05b85ac6a3c3?q=80&w=930&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  });

  @override
  Widget build(BuildContext context) {
    return switch (usage) {
      ProfilePictureUsage.nextToName => ClipOval(
        child: Image.network(url, width: 40, height: 40, fit: BoxFit.cover),
      ),
      ProfilePictureUsage.userProfile => ClipOval(
        child: Image.network(url, width: 100, height: 100, fit: BoxFit.cover),
      ),
    };
  }
}
