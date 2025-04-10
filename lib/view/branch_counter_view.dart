import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/branch_model.dart';
import '../providers/counter_provider.dart';

class BranchCounterView extends StatefulWidget {
  const BranchCounterView({super.key, required this.branchModel});
  final BranchModel branchModel;

  @override
  State<BranchCounterView> createState() => _BranchCounterViewState();
}

class _BranchCounterViewState extends State<BranchCounterView> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await Provider.of<CounterProvider>(context, listen: false).getCounter(branchId: widget.branchModel.id);
      await Provider.of<CounterProvider>(context, listen: false).getLog(branchId: widget.branchModel.id);
      timer = Timer.periodic(
        const Duration(seconds: 10),
        (Timer t) => Provider.of<CounterProvider>(context, listen: false).getLog(branchId: widget.branchModel.id),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Theme.of(context).colorScheme.inversePrimary;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text("${widget.branchModel.branch} Queue"),
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Previous",
                  style: TextStyle(color: Colors.blue[800], fontSize: 34.0),
                ),
                SizedBox(
                  height: 750.0,
                  width: 200.0,
                  child: Consumer<CounterProvider>(
                    builder: (context, provider, child) {
                      // final tempLog = <LogModel>[];
                      // // tempLog.add(provider.log.removeAt(0));
                      // tempLog.addAll(provider.log);
                      // tempLog.removeAt(0);
                      return ListView.builder(
                        itemCount: provider.previouslog.length,
                        itemBuilder: (ctx, i) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 5.0),
                            height: 200.0,
                            width: 200,
                            // color: Colors.red,
                            decoration: BoxDecoration(
                              // color: bgColor,
                              border: Border.all(width: 2.0),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${provider.previouslog[i].counter}',
                                  style: TextStyle(color: Colors.blue[800], fontSize: 40.0),
                                ),
                                const Divider(),
                                Text(
                                  'Window ${provider.previouslog[i].window}',
                                  style: TextStyle(color: Colors.blue[800], fontSize: 30.0),
                                ),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Now Serving",
                  style: TextStyle(color: Colors.blue[800], fontSize: 38.0),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    border: Border.all(width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  height: 300.0,
                  width: 300.0,
                  child: Align(
                    alignment: const Alignment(0, 0),
                    child: Consumer<CounterProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (provider.log.isNotEmpty) ...[
                              Text(
                                "${provider.log.first.counter}",
                                style: const TextStyle(color: Colors.white, fontSize: 50.0),
                              ),
                              const Divider(
                                color: Colors.white,
                              ),
                              Text(
                                'Window ${provider.log.first.window}',
                                style: const TextStyle(color: Colors.white, fontSize: 36.0),
                              ),
                            ] else ...[
                              // const Text(
                              //   "0",
                              //   style: TextStyle(color: Colors.white, fontSize: 40.0),
                              // ),
                              // const Text(
                              //   'Window 0',
                              //   style: TextStyle(color: Colors.white, fontSize: 36.0),
                              // ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
