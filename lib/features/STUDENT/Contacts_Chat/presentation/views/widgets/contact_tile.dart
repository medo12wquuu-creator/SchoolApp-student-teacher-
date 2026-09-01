import 'package:flutter/material.dart';
import '../../../data/models/contact_model.dart';
import 'contact_avatar.dart';
import 'contact_name.dart';

class ContactTile extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback? onTap;

  const ContactTile({super.key, required this.contact, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: ContactAvatar(
        imageUrl: contact.personalPhoto,
        file: contact.personalPhotoFile,
      ),
      title: ContactName(name: contact.name),
      onTap: onTap,
    );
  }
}
