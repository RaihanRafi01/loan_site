import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:loan_site/app/modules/contractor/views/contractor_view.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import 'chat_home_view.dart';

class ViewInstructionView extends GetView {
  const ViewInstructionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              width: double.maxFinite,
              color: AppColors.chatCard,
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/home/chat_bot.svg'),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: h3.copyWith(
                          color: AppColors.textColor,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Construction Guide',
                        style: h4.copyWith(
                          color: AppColors.gray2,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Chat messages area
            Expanded(
              flex: 2,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // First AI message
                  ChatHomeView().buildAIMessage(
                    context,
                    "Hi there! I'm your AI assistant, here to help you manage and track your flooring or construction project — every step of the way.",
                  ),
                  const SizedBox(height: 16),

                  // Second AI message
                  ChatHomeView().buildAIMessage(
                    context,
                    "I share you a list of contractor company in your nearby location",
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 5,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/contractor/arrow.svg'),
                        SizedBox(width: 10),
                        Text(
                          'Steps to Follow After Plumbing:',
                          style: h3.copyWith(
                            fontSize: 20,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('1'), backgroundColor: Colors.blue[100]),
                      title: Text('Floor Installation'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('2'), backgroundColor: Colors.blue[100]),
                      title: Text('Flooring Materials'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('3'), backgroundColor: Colors.blue[100]),
                      title: Text('Prepare the Surface'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('4'), backgroundColor: Colors.blue[100]),
                      title: Text('Quality Inspection'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('5'), backgroundColor: Colors.blue[100]),
                      title: Text('Final Inspection'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
