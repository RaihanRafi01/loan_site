import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/contractor/views/schedule_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class ContractorDetailsView extends GetView {
  const ContractorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatBc,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
              SizedBox(height: 10),
              // Profile Header
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      6,
                    ), // Adjust radius here
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/contractor/contractor_image_2.png',
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BlueWave Plumbing',
                                  style: h3.copyWith(
                                    fontSize: 16,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/contractor/star.svg',
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '4.9(127)',
                                      style: h3.copyWith(
                                        color: AppColors.textColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Available this weelk',
                                      style: h4.copyWith(
                                        color: AppColors.textGreen2,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        buildHyperlinkRow(
                          svgPath: 'assets/images/contractor/location.svg',
                          text: '1234 Constraction Ave, ST 12345',
                          isHyperlink: false,
                          url: '',
                          isUnderline: false,
                        ),
                        buildHyperlinkRow(
                          svgPath: 'assets/images/contractor/phone_icon.svg',
                          text: '(555) 123-4567',
                          isHyperlink: false,
                          url: '',
                          isUnderline: true,
                        ),
                        buildHyperlinkRow(
                          svgPath: 'assets/images/contractor/mail_icon.svg',
                          text: 'info@gmail.com',
                          isHyperlink: false,
                          url: '',
                          isUnderline: true,
                        ),
                        buildHyperlinkRow(
                          svgPath: 'assets/images/contractor/web_icon.svg',
                          text: 'www.premiumfloor.com',
                          isHyperlink: true,
                          url: 'www.premiumfloor.com',
                          isUnderline: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/images/contractor/call_now.svg',
                              ),
                              GestureDetector(
                                onTap: (){
                                  Get.to(ScheduleView());
                                },
                                child: SvgPicture.asset(
                                  'assets/images/contractor/shedule.svg',
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
                        spacing: 12, // Horizontal spacing between widgets
                        runSpacing: 10, // Vertical spacing between lines
                        alignment: WrapAlignment.start,
                        children: [
                          roundedTextWidget(text: 'Installation'),
                          roundedTextWidget(text: 'Repair'),
                          roundedTextWidget(text: 'Water Heater'),
                          roundedTextWidget(text: 'Kitchen Plumbing'),
                        ],
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
                    _buildServiceItem('Residential'),
                    _buildServiceItem('Kitchen Plumbing'),
                    _buildServiceItem('Service Included'),
                    _buildServiceItem('Pipe Installation and Repair'),
                    _buildServiceItem('Water Heater Installation and Repair'),
                    _buildServiceItem('Leak Detection and Repair'),
                    _buildServiceItem('Sewer Line Repair and Replacement'),
                    _buildServiceItem('Bathroom Plumbing Systems'),
                    _buildServiceItem('Plumbing Inspections'),
                    _buildServiceItem('Drain Warranty'),
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
                      color: AppColors.borderClr1, // Added border color
                      width: 1.0, // Default border width, adjust as needed
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
                      _buildReviewItem(
                        'Sarah M.',
                        4,
                        'The technician was extremely professional and the entire process was smooth. They explained everything in detail and made sure all my questions were answered. I would definitely recommend their services to anyone.',
                      ),
                      Divider(),
                      _buildReviewItem(
                        'Sarah M.',
                        5,
                        'Very knowledgeable and courteous. He also ran estimates for extra work that might make sense based on current condition. The workers were on time and did good work.',
                      ),
                      Divider(),
                      _buildReviewItem(
                        'Michael R.',
                        5,
                        'The entire process was seamless and the guys were very professional. Will be using them for all my future plumbing needs.',
                      ),
                      Divider(),
                      _buildReviewItem(
                        'David L.',
                        5,
                        'They did a thorough job including our main water line. Great work and very clean finish. Will be contacting them for future work.',
                      ),
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
        throw 'Could not launch $url';
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isHyperlink
                    ? Text(
                        text,
                        style: h4.copyWith(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      )
                    : Text(
                        text,
                        style: h4.copyWith(
                          fontSize: 14,
                          color: AppColors.gray3,
                          decoration: isUnderline
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
              ],
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
            color: price.toLowerCase() == 'free'
                ? AppColors.textGreen2
                : AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget pricingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.borderClr1,
            // Assuming AppColors.borderClr1 is defined
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
            // First Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildPricingItem('Consultation', 'Free')),
                const SizedBox(width: 4), // Minimal horizontal spacing
                Expanded(child: _buildPricingItem('Repire', '\$200-1500')),
              ],
            ),
            const SizedBox(height: 10), // Minimal vertical spacing
            // Second Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildPricingItem('Kithchen Plumbing', '\$150-500'),
                ),
                const SizedBox(width: 4), // Minimal horizontal spacing
                Expanded(
                  child: _buildPricingItem(
                    'Water Heater',
                    'Starting \$100-400',
                  ),
                ),
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
