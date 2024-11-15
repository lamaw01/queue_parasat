import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/branch_provider.dart';

class BranchView extends StatefulWidget {
  const BranchView({super.key});

  @override
  State<BranchView> createState() => _BranchViewState();
}

class _BranchViewState extends State<BranchView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<BranchProvider>(context, listen: false).getBranch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Branch'),
      ),
      body: Center(
        child: SizedBox(
          height: 800.0,
          width: 500.0,
          child: Consumer<BranchProvider>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return const Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: value.branch.length,
                  itemBuilder: (ctx, i) {
                    return Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: ListTile(
                        title: Text(value.branch[i].branch),
                        onTap: () {
                          context.push('/branch_counter', extra: value.branch[i]);
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
