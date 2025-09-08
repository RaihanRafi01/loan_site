import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loan_site/app/modules/project/controllers/project_controller.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../../common/widgets/custom_snackbar.dart';
import '../../home/controllers/chat_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/view_instruction_view.dart';

class ProjectView extends GetView<ProjectController> {
  final int projectId;
  const ProjectView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    // Make sure details are loaded for this id
    controller.ensureProjectLoaded(projectId);

    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        backgroundColor: AppColors.appBc,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('My Project', style: h2.copyWith(color: AppColors.textColor, fontSize: 22)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isProjectLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.projectError.value != null) {
            return Center(child: Text(controller.projectError.value!, style: h3.copyWith(fontSize: 16)));
          }
          final d = controller.projectDetail.value;
          if (d == null) {
            return const Center(child: Text('No project data'));
          }

          final p = d.progress;
          final currentPhase = d.milestones.firstWhereOrNull((m) => m.status != 'completed')?.name ?? 'All phases completed';
          final percentText = '${p.percent100}% Complete';

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Header
                    Text(d.name, style: h3.copyWith(fontSize: 24, color: AppColors.textColor)),
                    const SizedBox(height: 4),
                    Text(d.type, style: h4.copyWith(fontSize: 16, color: AppColors.blurtext5)),
                    const SizedBox(height: 20),

                    // Progress Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.cardGradient1, AppColors.cardGradient2],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Project Progress', style: h1.copyWith(color: AppColors.textWhite1, fontSize: 24)),
                                  Text('(${p.completedPhases} of ${p.totalPhases} Milestone${p.totalPhases == 1 ? '' : 's'} completed)',
                                      style: h3.copyWith(color: AppColors.textWhite1, fontSize: 12)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                child: Text(percentText, style: h3.copyWith(color: AppColors.textColor5, fontSize: 10)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 10,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                            child: FractionallySizedBox(
                              widthFactor: p.percent0to1,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(color: AppColors.progressClr, borderRadius: BorderRadius.circular(40)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Started: ${p.fmtDate(p.startDate)}', style: h4.copyWith(color: Colors.white, fontSize: 14)),
                              Text('Estimated: ${p.fmtDate(p.endDate)}', style: h4.copyWith(color: Colors.white, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: _buildStatCard('${p.daysRemaining}', 'Days Remaining', AppColors.clrOrange)),
                        Expanded(child: _buildStatCard('${p.percent100}%', 'Progress', AppColors.clrGreen)),
                        Expanded(child: _buildStatCard('${p.completedPhases}/${p.totalPhases}', 'Phases Done', AppColors.clrBrown)),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text('Project Information', style: h3.copyWith(color: AppColors.textColor, fontSize: 20)),
                    ),
                    _projectInformation('Project Name :', d.name),
                    _projectInformation('Project Type :', d.type),
                    _projectInformation('Location :', d.location),
                    _projectInformation('Project Manager :', d.manager),

                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text('Current Phase', style: h3.copyWith(color: AppColors.textColor, fontSize: 20)),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.cardGradient3, AppColors.cardGradient4],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(currentPhase, style: h1.copyWith(color: AppColors.textWhite1, fontSize: 24)),
                                    Text('(${p.completedPhases} of ${p.totalPhases} Milestone${p.totalPhases == 1 ? '' : 's'} completed)',
                                        style: h3.copyWith(color: AppColors.textWhite1, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                child: Text(percentText, style: h3.copyWith(color: AppColors.textColor5, fontSize: 10)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 10,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                            child: FractionallySizedBox(
                              widthFactor: p.percent0to1,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration:
                                BoxDecoration(color: AppColors.textColor, borderRadius: BorderRadius.circular(40)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Next up: ${currentPhase == 'All phases completed' ? '—' : currentPhase}.',
                            style: h4.copyWith(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    // (Optional) Milestones list preview
                    if (d.milestones.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text('Milestones', style: h3.copyWith(color: AppColors.textColor, fontSize: 20)),
                      const SizedBox(height: 8),
                      ...d.milestones.map((m) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.cardSky,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          title: Text(m.name, style: h3.copyWith(color: AppColors.appColor2, fontSize: 18)),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: m.status == 'completed' ? Colors.green.shade100 : Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              m.status.capitalize ?? m.status,
                              style: h4.copyWith(
                                  fontSize: 12,
                                  color: m.status == 'completed' ? Colors.green.shade900 : Colors.orange.shade900),
                            ),
                          ),
                        ),
                      )),
                    ],

                    // Action button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () => Get.to(() => const ViewInstructionView()),
                        child: SvgPicture.asset('assets/images/project/view_instruction.svg',
                            width: MediaQuery.of(context).size.width),
                      ),
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),

              // Fixed bottom button
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: // In ProjectController or the view using it
                CustomButton(
                  svgPath: 'assets/images/project/switch_icon.svg',
                  label: 'Switch to this project',
                  onPressed: () async {
                    final d = controller.projectDetail.value;
                    if (d == null) return;
                    await ProjectPrefs.saveContext(projectDetail: d);
                    // Update HomeController
                    if (Get.isRegistered<HomeController>()) {
                      await Get.find<HomeController>().loadContextFromPrefs();
                    }
                    // Update ChatController (if applicable)
                    if (Get.isRegistered<ChatController>()) {
                      Get.find<ChatController>().refreshContext();
                    }
                    Get.snackbar('Success', 'Switched to project: ${d.name}');
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _projectInformation(String title, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(title, style: h4.copyWith(color: AppColors.gray7, fontSize: 16)),
          const SizedBox(width: 6),
          Expanded(child: Text(details, style: h3.copyWith(color: AppColors.textColor, fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, textAlign: TextAlign.center, style: h1.copyWith(fontSize: 32, color: color)),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center, style: h4.copyWith(fontSize: 14, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
