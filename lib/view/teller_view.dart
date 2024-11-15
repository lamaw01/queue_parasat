import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/teller_provider.dart';

class TellerView extends StatefulWidget {
  const TellerView({super.key});

  @override
  State<TellerView> createState() => _TellerViewState();
}

class _TellerViewState extends State<TellerView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<TellerProvider>(context, listen: false).getTeller();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Teller/CSR'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 800.0,
              width: 500.0,
              child: Consumer<TellerProvider>(
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
                      itemCount: value.teller.length,
                      itemBuilder: (ctx, i) {
                        return Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          child: ListTile(
                            // leading: Text(value.teller[i].type),
                            title: Text(value.teller[i].name),
                            subtitle: Text("${value.teller[i].branch} ${value.teller[i].type}"),
                            onTap: () {
                              context.push('/teller_counter', extra: value.teller[i]);
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
