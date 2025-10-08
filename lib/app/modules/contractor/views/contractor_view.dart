import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/chat_home_view.dart';
import '../../home/views/upload_photo_view.dart';
import '../../project/views/startMilestone_view.dart';
import 'contractor_details_view.dart';
import '../controllers/contractor_controller.dart';

class ContractorView extends GetView<ContractorController> {
  ContractorView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ContractorController());
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Obx(() => Column(
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
            const SizedBox(height: 16),
            // Chat messages area
            Expanded(
              flex: 2,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ChatHomeView().buildAIMessage(
                    context,
                    "Hi there! I'm your AI assistant, here to help you manage and track your flooring or construction project — every step of the way.",
                  ),
                  const SizedBox(height: 16),
                  ChatHomeView().buildAIMessage(
                    context,
                    "I share you a list of contractor company in your nearby location",
                  ),
                ],
              ),
            ),
            // Contractor list or button when no milestone
            Expanded(
              flex: 5,
              child: controller.isContractorsLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.contractorsError.value != null
                  ? Center(
                child: Text(
                  controller.contractorsError.value!,
                  style: h4.copyWith(color: AppColors.textColor),
                  textAlign: TextAlign.center,
                ),
              )
                  : !controller.hasMilestone.value
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: CustomButton(
                    label: 'Start Next Phase',
                    onPressed: () {
                      final HomeController homeController = Get.find<HomeController>();
                      final project = homeController.currentProject.value;
                      final ongoingMilestone = project?.milestones
                          .firstWhereOrNull((m) => m.status == 'on_going');
                      if (ongoingMilestone != null) {
                        // Assuming a method exists in the controller to handle completion
                        // controller.completeCurrentMilestone();
                        //Get.to(StartMilestoneView());
                        Get.to(UploadPhotoView());
                      } else {
                        Get.to(StartMilestoneView());
                      }
                    },
                    radius: 6,
                    svgPath2: 'assets/images/home/double_arrow_icon.svg',
                    height: 45,
                    fontSize: 15,
                  ),
                ),
              )
                  : controller.contractors.isEmpty
                  ? Center(
                child: Text(
                  'No contractors available for the selected milestone.',
                  style: h4.copyWith(color: AppColors.textColor),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/contractor/arrow.svg'),
                        const SizedBox(width: 10),
                        Text(
                          'Popular contractors in your city',
                          style: h3.copyWith(
                            fontSize: 20,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...controller.contractors.map((contractor) => Column(
                    children: [
                      buildContractor(
                        contractor.image ??
                            'assets/images/contractor/contractor_image.png',
                        contractor.name,
                        contractor.address.split(',').first,
                        '${contractor.rating}(${contractor.totalReviews})',
                        contractor.availableThisWeek
                            ? 'Available this week'
                            : 'Not available',
                        contractor,
                      ),
                      const SizedBox(height: 5),
                    ],
                  )).toList(),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget buildContractor(
      String imagePath,
      String title,
      String location,
      String rating,
      String available,
      Contractor contractor,
      ) {
    return GestureDetector(
      onTap: () => Get.to(() => ContractorDetailsView(contractor: contractor)),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imagePath.startsWith('http')
                  ? Image.network(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/contractor/contractor_image.png',
                  width: 80,
                  height: 80,
                ),
              )
                  : Image.asset(imagePath, width: 80, height: 80),
              const SizedBox(width: 20),
              Expanded(
                // Wrap Column in Expanded to constrain its width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: h3.copyWith(fontSize: 16, color: AppColors.textColor),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/contractor/location.svg'),
                        const SizedBox(width: 5),
                        Expanded(
                          // Wrap location Text in Expanded to allow wrapping
                          child: Text(
                            location,
                            style: h4.copyWith(color: AppColors.blurtext6, fontSize: 14),
                            maxLines: 2, // Allow up to 2 lines for location
                            overflow: TextOverflow.ellipsis, // Truncate with ellipsis if still too long
                          ),
                        ),
                        const SizedBox(width: 15),
                        SvgPicture.asset('assets/images/contractor/star.svg'),
                        const SizedBox(width: 5),
                        Text(
                          rating,
                          style: h3.copyWith(color: AppColors.textColor, fontSize: 14),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      available,
                      style: h4.copyWith(color: AppColors.textGreen2, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}