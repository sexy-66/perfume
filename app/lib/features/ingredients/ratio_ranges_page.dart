import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../ui/single_modal.dart';

class RatioRangesPage extends StatefulWidget {
  const RatioRangesPage({
    super.key,
    required this.database,
    required this.target,
    required this.targetId,
    required this.title,
    this.description,
  });

  final AppDatabase database;
  final RatioRangeTarget target;
  final String targetId;
  final String title;
  final String? description;

  @override
  State<RatioRangesPage> createState() => _RatioRangesPageState();
}

class _RatioRangesPageState extends State<RatioRangesPage> {
  late final Stream<List<RatioRangeSetting>> _ranges;

  @override
  void initState() {
    super.initState();
    _ranges = widget.database.watchRatioRanges(widget.target, widget.targetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: StreamBuilder<List<RatioRangeSetting>>(
        stream: _ranges,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('读取失败：${snapshot.error}'));
          }
          final items = snapshot.data ?? const [];
          return ListView(
            children: [
              if (widget.description != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Text(widget.description!),
                ),
              for (final item in items)
                ListTile(
                  title: Text(item.productionTypeName),
                  subtitle: item.productionTypeInactive
                      ? const Text('制作类型已停用')
                      : item.inherited
                      ? const Text('跟随香料大类')
                      : null,
                  trailing: Text(
                    item.minRatio == null
                        ? '未设置'
                        : '${formatRatioPercentage(item.minRatio!)}%–${formatRatioPercentage(item.maxRatio!)}%',
                  ),
                  onTap: item.productionTypeInactive ? null : () => _edit(item),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _edit(RatioRangeSetting setting) async {
    var minText = setting.minRatio == null
        ? ''
        : formatRatioPercentage(setting.minRatio!);
    var maxText = setting.maxRatio == null
        ? ''
        : formatRatioPercentage(setting.maxRatio!);
    final action = await showSingleDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${setting.productionTypeName}推荐区间'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (setting.inherited) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '当前跟随香料大类，保存后将改为单独设置。',
                  style: TextStyle(color: Color(0xff636366), fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              initialValue: minText,
              autofocus: true,
              textInputAction: TextInputAction.next,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: '最低比例',
                suffixText: '%',
              ),
              onChanged: (value) => maxText = value,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: maxText,
              textInputAction: TextInputAction.done,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: '最高比例',
                suffixText: '%',
              ),
              onChanged: (value) => minText = value,
              onFieldSubmitted: (_) => Navigator.pop(context, 'save'),
            ),
          ],
        ),
        actions: [
          if (setting.rangeId != null)
            TextButton(
              onPressed: () => Navigator.pop(context, 'clear'),
              child: Text(
                widget.target == RatioRangeTarget.ingredient
                    ? '恢复跟随大类'
                    : '清除区间',
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (!mounted || action == null) return;
    try {
      if (action == 'clear') {
        await widget.database.clearRatioRange(
          widget.target,
          widget.targetId,
          setting.productionTypeId,
        );
      } else {
        await widget.database.setRatioRange(
          target: widget.target,
          targetId: widget.targetId,
          productionTypeId: setting.productionTypeId,
          minRatio: parseRatioPercentage(minText),
          maxRatio: parseRatioPercentage(maxText),
        );
      }
      if (mounted) _message('已保存');
    } catch (error) {
      if (mounted) _message(_errorText(error));
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

int parseRatioPercentage(String text) {
  final match = RegExp(r'^(\d{1,3})(?:\.(\d{1,2}))?$').firstMatch(text.trim());
  if (match == null) throw const FormatException('比例最多保留两位小数');
  final fraction = (match.group(2) ?? '').padRight(2, '0');
  final value =
      int.parse(match.group(1)!) * 100 +
      (fraction.isEmpty ? 0 : int.parse(fraction));
  if (value > 10000) throw const FormatException('比例不能超过 100.00%');
  return value;
}

String formatRatioPercentage(int value) =>
    '${value ~/ 100}.${(value % 100).toString().padLeft(2, '0')}';

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is FormatException) return error.message;
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
