import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../ui/single_modal.dart';
import '../../services/formula_calculator.dart';
import '../formulas/formulas_page.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final _search = TextEditingController();
  late Stream<List<Customer>> _customers;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('顾客')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchBar(
              controller: _search,
              hintText: '搜索姓名或电话',
              leading: const Icon(Icons.search),
              onChanged: (_) => setState(_refresh),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Customer>>(
              stream: _customers,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('读取失败：${snapshot.error}'));
                }
                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  if (_search.text.trim().isNotEmpty) {
                    return const Center(child: Text('没有匹配的顾客'));
                  }
                  return Center(
                    child: FilledButton.icon(
                      onPressed: () => _edit(),
                      icon: const Icon(Icons.add),
                      label: const Text('添加第一位顾客'),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final details = <String>[
                      if (item.name.isNotEmpty && item.phone.isNotEmpty)
                        item.phone,
                      if (item.notes != null) item.notes!,
                    ].join(' · ');
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person_outline),
                      ),
                      title: Text(item.name.isEmpty ? item.phone : item.name),
                      subtitle: details.isEmpty ? null : Text(details),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => CustomerDetailPage(
                            database: widget.database,
                            customer: item,
                          ),
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        tooltip:
                            '${item.name.isEmpty ? item.phone : item.name}的更多操作',
                        onSelected: (action) =>
                            action == 'edit' ? _edit(item) : _delete(item),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('编辑')),
                          PopupMenuItem(value: 'delete', child: Text('删除')),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '添加顾客',
        onPressed: () => _edit(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _refresh() {
    _customers = widget.database.watchCustomers(search: _search.text);
  }

  Future<void> _edit([Customer? customer]) async {
    var name = customer?.name ?? '';
    var phone = customer?.phone ?? '';
    var notes = customer?.notes ?? '';
    final saved = await showSingleDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer == null ? '添加顾客' : '编辑顾客'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                autofocus: true,
                decoration: const InputDecoration(labelText: '姓名'),
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: '电话'),
                onChanged: (value) => phone = value,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: notes,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: '备注',
                  alignLabelWithHint: true,
                ),
                onChanged: (value) => notes = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                if (customer == null) {
                  await widget.database.createCustomer(
                    name: name,
                    phone: phone,
                    notes: notes,
                  );
                } else {
                  await widget.database.updateCustomer(
                    customer.id,
                    name: name,
                    phone: phone,
                    notes: notes,
                  );
                }
                if (context.mounted) Navigator.pop(context, true);
              } catch (error) {
                if (context.mounted) _message(_errorText(error), context);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (saved == true && mounted) _message('已保存');
  }

  Future<void> _delete(Customer customer) async {
    final action = await showSingleModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '删除“${customer.name.isEmpty ? customer.phone : customer.name}”？',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text('请选择调配记录的处理方式。顾客资料可在最近删除中恢复。'),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context, 'keep'),
                child: const Text('删除顾客，保留不关联的调配记录'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pop(context, 'all'),
                child: const Text('连同该顾客调配记录一起删除'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
            ],
          ),
        ),
      ),
    );
    if (action == null) return;
    try {
      await widget.database.deleteCustomer(
        customer.id,
        deleteSessions: action == 'all',
      );
    } catch (error) {
      if (mounted) _message(_errorText(error));
    }
  }

  void _message(String text, [BuildContext? target]) {
    ScaffoldMessenger.of(
      target ?? context,
    ).showSnackBar(SnackBar(content: Text(text)));
  }
}

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({
    super.key,
    required this.database,
    required this.customer,
  });

  final AppDatabase database;
  final Customer customer;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(customer.name.isEmpty ? customer.phone : customer.name),
    ),
    body: StreamBuilder<List<CustomerFormulaHistory>>(
      stream: database.watchCustomerFormulaHistory(customer.id),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return const Center(child: Text('该顾客还没有调配记录'));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(item.formulaName),
              subtitle: Text(
                '最后使用 ${_customerDate(item.lastUsedAtUtc)} · ${item.useCount} 次',
              ),
              trailing: IconButton(
                tooltip: '按上次比例调配',
                icon: const Icon(Icons.play_arrow),
                onPressed: () => _repeatLast(context, item),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => _CustomerFormulaSessionsPage(
                    database: database,
                    customerId: customer.id,
                    history: item,
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );

  Future<void> _repeatLast(
    BuildContext context,
    CustomerFormulaHistory history,
  ) async {
    var text = '';
    final weight = await showSingleDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('按上次最终比例调配'),
        content: TextField(
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: '目标总克重',
            suffixText: 'g',
          ),
          onChanged: (value) => text = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              try {
                Navigator.pop(context, parseWeight(text));
              } catch (error) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(_errorText(error))));
              }
            },
            child: const Text('进入调配'),
          ),
        ],
      ),
    );
    if (weight == null) return;
    try {
      final draft = await database.createDraftFromLastCustomerSession(
        customerId: customer.id,
        formulaId: history.formulaId,
        targetWeight: weight,
      );
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => MixingPage(database: database, draftId: draft.id),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorText(error))));
      }
    }
  }
}

class _CustomerFormulaSessionsPage extends StatelessWidget {
  const _CustomerFormulaSessionsPage({
    required this.database,
    required this.customerId,
    required this.history,
  });

  final AppDatabase database;
  final String customerId;
  final CustomerFormulaHistory history;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(history.formulaName)),
    body: StreamBuilder<List<MixingSession>>(
      stream: database.watchCustomerFormulaSessions(
        customerId,
        history.formulaId,
      ),
      builder: (context, snapshot) => ListView(
        children: [
          for (final session in snapshot.data ?? const <MixingSession>[])
            ListTile(
              title: Text('${formatFixed(session.finalWeight)}g'),
              subtitle: Text(_customerDate(session.completedAtUtc)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) =>
                      MixingSessionPage(database: database, session: session),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

String _customerDate(DateTime value) {
  final local = value.toLocal();
  return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
}

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
