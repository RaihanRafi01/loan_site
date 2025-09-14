import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../dashboard/controllers/dashboard_lender_controller.dart';

class ProjectLenderView extends GetView<DashboardLenderController> {
  const ProjectLenderView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    // Add listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoadingMore.value &&
          controller.hasMoreProjects.value) {
        controller.fetchProjectsData(isLoadMore: true);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appBc,
        scrolledUnderElevation: 0,
        title: Text(
          'Projects',
          style: h2.copyWith(
            color: AppColors.textColor,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardSky,
                borderRadius: BorderRadius.circular(48),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.appColor2,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(4),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.gray13,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabs: const [
                    Tab(text: 'Active'),
                    Tab(text: 'Complete'),
                    Tab(text: 'Delayed'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildProjectList(status: 'On Going', statusColor: AppColors.textYellow, scrollController: scrollController),
                  _buildProjectList(status: 'Completed', statusColor: AppColors.clrGreen, scrollController: scrollController),
                  _buildProjectList(status: 'Delayed', statusColor: AppColors.lenderRed, scrollController: scrollController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList({
    required String status,
    required Color statusColor,
    required ScrollController scrollController,
  }) {
    return Obx(() {
      final filteredProjects = controller.projectList
          .where((project) => project['project_status'] == status)
          .toList();

      if (filteredProjects.isEmpty && !controller.isLoadingMore.value) {
        return Center(
          child: Text(
            'No $status projects found',
            style: h4.copyWith(
              fontSize: 16,
              color: AppColors.gray12,
            ),
          ),
        );
      }

      return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: filteredProjects.length + (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == filteredProjects.length && controller.isLoadingMore.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final project = filteredProjects[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildProjectCard(
              projectName: project['name'] ?? 'Unknown',
              companyName: project['location'] ?? 'Unknown',
              progress: project['progress_percentage'] ?? 0,
              status: project['project_status'] ?? status,
              statusColor: statusColor,
            ),
          );
        },
      );
    });
  }

  Widget _buildProjectCard({
    required String projectName,
    required String companyName,
    required int progress,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        color: Colors.white,
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
                    Text(
                      projectName,
                      style: h3.copyWith(
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      companyName,
                      style: h4.copyWith(
                        fontSize: 14,
                        color: AppColors.gray12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$progress% Progress',
                    style: h3.copyWith(
                      fontSize: 14,
                      color: AppColors.lenderSky,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Text(
                      status,
                      style: h3.copyWith(
                        fontSize: 14,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}