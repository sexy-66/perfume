import 'package:flutter/material.dart';

import '../../data/app_database.dart';

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
                      onTap: () => _edit(item),
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
    final saved = await showDialog<bool>(
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
              TextFormField(
                initialValue: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: '电话'),
                onChanged: (value) => phone = value,
              ),
              TextFormField(
                initialValue: notes,
                maxLines: 3,
                decoration: const InputDecoration(labelText: '备注'),
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
    final confirmed = await showModalBottomSheet<bool>(
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
              const Text('删除后可在最近删除中恢复。'),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('确认删除'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true) return;
    try {
      await widget.database.deleteCustomer(customer.id);
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

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
