import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/app.dart';
import 'package:xiangfangbu/data/app_database.dart';

void main() {
  testWidgets('shows the three destinations and ordered more page', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.initialize();
    await tester.pumpWidget(XiangApp(database: database));

    expect(find.text('主页'), findsWidgets);
    expect(find.text('香方'), findsOneWidget);
    expect(find.text('更多'), findsOneWidget);

    await tester.tap(find.text('更多'));
    await tester.pump();
    for (final item in const [
      '香料库',
      '香牌目录',
      '顾客',
      '推荐配置',
      '资产清点',
      '最近删除',
      '同步与设备',
      '备份与恢复',
      '设置',
    ]) {
      expect(find.text(item), findsOneWidget);
    }
  });
}
