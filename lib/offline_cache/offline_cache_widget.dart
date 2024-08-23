import 'package:flutter/material.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';

import 'offline_cache_controller.dart';

class OfflineCacheListWidget extends StatelessWidget {
  final Function()? onSynComplete;

  const OfflineCacheListWidget({super.key, this.onSynComplete});

  @override
  Widget build(BuildContext context) {
    OfflineCacheSyncController offlineCont =
        Get.find<OfflineCacheSyncController>();

    return Obx(() {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: offlineCont.isLoading.value
                ? null
                : () async {
                    await offlineCont.updateCache();
                    if (onSynComplete != null) {
                      onSynComplete!();
                    }
                  },
            icon: Icon(Icons.refresh),
            label: Text("Update"),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var cachePage =
                  offlineCont.offlineCacheStatus.value?.cachepages[index];
              return ListTile(
                title: Text(cachePage?.nickName ?? ""),
                subtitle: Text(cachePage?.status_name ?? "Scheduled"),
                trailing: Text(
                  "@count# of @total#".interpolate({
                    "total": cachePage?.totalCount ?? 0,
                    "count": cachePage?.count ?? 0
                  }),
                ),
              );
            },
            itemCount: offlineCont.offlineCacheStatus.value?.cachepages.length,
          ),
        ],
      );
    });
  }
}
