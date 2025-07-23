import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MessageView extends GetView {
  const MessageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MessageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MessageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
