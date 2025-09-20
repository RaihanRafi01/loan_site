import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';
import '../../../core/constants/api.dart';

const String mediaBaseUrl = Api.baseUrlPicture;

class MembersView extends StatelessWidget {
  final String groupName;
  final List<Map<String, dynamic>> participants;

  const MembersView({
    super.key,
    required this.groupName,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        backgroundColor: AppColors.appBc,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset('assets/images/community/arrow_left.svg'),
          ),
        ),
        title: Text(
          '$groupName Members',
          style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: participants.isEmpty
            ? const Center(child: Text('No members available'))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  final participant = participants[index];
                  final name = participant['name'] as String? ?? 'Unknown';
                  final avatar = _resolveMediaUrl(
                    participant['image'] as String?,
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: avatar.isNotEmpty
                              ? NetworkImage(avatar)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          name,
                          style: h2.copyWith(
                            fontSize: 18,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _resolveMediaUrl(String? input) {
    if (input == null || input.isEmpty) {
      return '';
    }
    if (input.startsWith('http://') ||
        input.startsWith('https://') ||
        input.startsWith('data:')) {
      return input;
    }
    return '$mediaBaseUrl$input';
  }
}
