import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

String formatTime(DateTime? time) {
  if (time == null) {
    return '';
  }
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final aWeekAgo = today.subtract(const Duration(days: 7));

  if (time.isAfter(today)) {
    // 如果时间是今天，返回 "HH:mm" 格式的时间
    return DateFormat('HH:mm').format(time);
  } else if (time.isAfter(yesterday)) {
    // 如果时间是昨天，返回 "昨天 HH:mm" 格式的时间
    return '昨天 ${DateFormat('HH:mm').format(time)}';
  } else if (time.isAfter(aWeekAgo)) {
    // 如果时间是一周内，返回星期几
    return '星期${['日', '一', '二', '三', '四', '五', '六'][time.weekday - 1]}';
  } else {
    // 如果时间是一周前，返回 "M月d日" 格式的时间
    return DateFormat('M月d日').format(time);
  }
}

ImageProvider<Object> getAvatar(String url) {
  return url.startsWith("assets")
      ? AssetImage(url)
      : NetworkImage(url) as ImageProvider<Object>;
}

Future<String> requestPermission() async {
  if (Platform.isMacOS) {
    return "";
  }
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
    if (!status.isGranted) {
      return "Permission denied";
    }
  }
  return "";
}
