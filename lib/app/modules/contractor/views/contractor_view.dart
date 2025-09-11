import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../home/views/chat_home_view.dart';
import 'contractor_details_view.dart';

class ContractorView extends GetView {
  const ContractorView({super.key});
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
                  ChatHomeView().buildAIMessage(context,
                    "Hi there! I'm your AI assistant, here to help you manage and track your flooring or construction project — every step of the way.",
                  ),
                  const SizedBox(height: 16),

                  // Second AI message
                  ChatHomeView().buildAIMessage(context,
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
                          'Popular contactor in your city',
                          style: h3.copyWith(
                            fontSize: 20,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // First AI message
                  ContractorView().buildContractor(
                    'assets/images/contractor/contractor_image.png',
                    'BlueWave Plumbing',
                    'ST 12345',
                    '4.9(127)',
                    'Available this weelk',
                  ),
                  const SizedBox(height: 5),

                  // Second AI message
                  ContractorView().buildContractor(
                    'assets/images/contractor/contractor_image.png',
                    'PipeMasters Plumbing',
                    'ST 12345',
                    '4.9(127)',
                    'Available this weelk',
                  ),
                  const SizedBox(height: 5),

                  // Second AI message
                  ContractorView().buildContractor(
                    'assets/images/contractor/contractor_image.png',
                    'ClearFlow Plumbing Solutions',
                    'ST 12345',
                    '4.9(127)',
                    'Available this weelk',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildContractor(
      String imagePath,
      String title,
      String location,
      String rating,
      String available,
      ) {
    return GestureDetector(
      onTap: ()=> Get.to(ContractorDetailsView()),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // Adjust radius here
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imagePath),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: h3.copyWith(fontSize: 16, color: AppColors.textColor),
                  ),
                  SizedBox(height: 4),
                  Row(children: [
                    SvgPicture.asset('assets/images/contractor/location.svg'),
                    SizedBox(width: 5),
                    Text(location,style: h4.copyWith(color: AppColors.blurtext6,fontSize: 14),),
                    SizedBox(width: 15),
                    SvgPicture.asset('assets/images/contractor/star.svg'),
                    SizedBox(width: 5),
                    Text(rating,style: h3.copyWith(color: AppColors.textColor,fontSize: 14))]),
                  SizedBox(height: 4),
                  Text(available,style: h4.copyWith(color: AppColors.textGreen2,fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}