import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import 'schedule_view.dart';
import '../controllers/contractor_controller.dart';

class ContractorDetailsView extends GetView<ContractorController> {
  final Contractor contractor;

  const ContractorDetailsView({super.key, required this.contractor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 10),
              // Profile Header
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            contractor.image != null && contractor.image!.startsWith('http')
                                ? Image.network(
                              contractor.image!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                'assets/images/contractor/contractor_image_2.png',
                                width: 80,
                                height: 80,
                              ),
                            )
                                : Image.asset(
                              'assets/images/contractor/contractor_image_2.png',
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contractor.name,
                                    style: h3.copyWith(
                                      fontSize: 16,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/contractor/star.svg',
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${contractor.rating}(${contractor.totalReviews})',
                                        style: h3.copyWith(
                                          color: AppColors.textColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        contractor.availableThisWeek
                                            ? 'Available this week'
                                            : 'Not available',
                                        style: h4.copyWith(
                                          color: AppColors.textGreen2,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        buildHyperlinkRow(
                          svgPath: 'assets/images/contractor/location.svg',
                          text: contractor.address,
                          isHyperlink: false,
                          url: '',
                          isUnderline: false,
                        ),
                        buildHyperlinkRow(
                          svgPath: 'assets/images/contractor/phone_icon.svg',
                          text: contractor.phone,
                          isHyperlink: contractor.phone != 'N/A',
                          url: 'tel:${contractor.phone}',
                          isUnderline: true,
                        ),
                        buildHyperlinkRow(
                          svgPath: 'assets/images/contractor/mail_icon.svg',
                          text: contractor.email == 'N/A' ? 'Not available' : contractor.email,
                          isHyperlink: contractor.email != 'N/A',
                          url: 'mailto:${contractor.email}',
                          isUnderline: true,
                        ),
                        buildHyperlinkRow(
                          svgPath: 'assets/images/contractor/web_icon.svg',
                          text: contractor.website == 'N/A' ? 'Not available' : contractor.website,
                          isHyperlink: contractor.website != 'N/A',
                          url: contractor.website,
                          isUnderline: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SvgPicture.asset(
                                  'assets/images/contractor/call_now.svg',
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => ScheduleView());
                                  },
                                  child: SvgPicture.asset(
                                    'assets/images/contractor/shedule.svg',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Services & Specialties
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service & Specialties',
                      style: h3.copyWith(
                        fontSize: 20,
                        color: AppColors.textColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        alignment: WrapAlignment.start,
                        children: contractor.specialties
                            .map<Widget>((specialty) => roundedTextWidget(text: specialty))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Service Included',
                      style: h3.copyWith(
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...contractor.servicesIncluded
                        .map<Widget>((service) => _buildServiceItem(service))
                        .toList(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Pricing
              pricingSection(),
              const SizedBox(height: 12),
              // Recent Reviews
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.borderClr1,
                      width: 1.0,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Reviews',
                        style: h2.copyWith(
                          fontSize: 20,
                          color: AppColors.textColor,
                        ),
                      ),
                      ...contractor.reviews.asMap().entries.map<Widget>(
                            (entry) {
                          int idx = entry.key;
                          String review = entry.value;
                          if (review.isEmpty || review == 'No additional review available.') {
                            return Container();
                          }
                          return Column(
                            children: [
                              _buildReviewItem(
                                'User ${idx + 1}',
                                contractor.rating.toInt(),
                                review,
                              ),
                              if (idx < contractor.reviews.length - 1) const Divider(),
                            ],
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roundedTextWidget({
    required String text,
    Color backgroundColor = AppColors.gray4,
    Color textColor = AppColors.textColor,
    double borderRadius = 48,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 2,
    ),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      child: Text(text, style: h4.copyWith(color: textColor, fontSize: 16)),
    );
  }

  Widget buildHyperlinkRow({
    required String svgPath,
    required String text,
    required bool isHyperlink,
    required bool isUnderline,
    required String url,
  }) {
    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar('Error', 'Could not launch $url');
      }
    }

    return GestureDetector(
      onTap: isHyperlink ? () => _launchUrl(url) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(svgPath),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: h4.copyWith(
                      fontSize: 14,
                      color: isHyperlink ? Colors.blue : AppColors.gray3,
                      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
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

  Widget _buildServiceItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/contractor/tic_icon.svg'),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: h4.copyWith(fontSize: 16, color: AppColors.textColor6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingItem(String service, String price) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          service,
          style: h4.copyWith(fontSize: 16, color: AppColors.textColor6),
        ),
        Text(
          price,
          style: h2.copyWith(
            fontSize: 16,
            color: price.toLowerCase() == 'free' ? AppColors.textGreen2 : AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget pricingSection() {
    // Convert pricing entries to a list for easier indexing
    final pricingEntries = contractor.pricing.entries.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.borderClr1,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing',
              style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
            ),
            const SizedBox(height: 16),
            // Build rows of pricing items (two per row)
            for (int i = 0; i < pricingEntries.length; i += 2)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildPricingItem(
                          pricingEntries[i].key,
                          pricingEntries[i].value,
                        ),
                      ),
                      if (i + 1 < pricingEntries.length)
                        Expanded(
                          child: _buildPricingItem(
                            pricingEntries[i + 1].key,
                            pricingEntries[i + 1].value,
                          ),
                        )
                      else
                        const Expanded(child: SizedBox()), // Empty space if odd number
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String name, int rating, String review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: h3.copyWith(fontSize: 16, color: AppColors.textColor),
              ),
              const SizedBox(width: 8),
              Row(
                children: List.generate(
                  rating,
                      (index) => SvgPicture.asset(
                    'assets/images/contractor/star_icon.svg',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review,
            style: h4.copyWith(fontSize: 13, color: AppColors.textColor7),
          ),
        ],
      ),
    );
  }
}