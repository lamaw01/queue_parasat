import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_parasat/model/branch_model.dart';

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
      await Provider.of<CounterProvider>(context, listen: false).getCounter(branchId: widget.branchModel.id);
      timer = Timer.periodic(
        const Duration(seconds: 10),
        (Timer t) => Provider.of<CounterProvider>(context, listen: false).getCounter(branchId: widget.branchModel.id),
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
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          height: 200.0,
          width: 200.0,
          child: Align(
            alignment: const Alignment(0, 0),
            child: Consumer<CounterProvider>(
              builder: (context, value, child) {
                return Text(
                  "${value.counter}",
                  style: const TextStyle(color: Colors.white, fontSize: 40.0),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
