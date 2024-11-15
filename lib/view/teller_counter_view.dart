import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_parasat/model/teller_model.dart';

import '../providers/counter_provider.dart';

class TellerCounterView extends StatefulWidget {
  const TellerCounterView({super.key, required this.tellerModel});
  final TellerModel tellerModel;

  @override
  State<TellerCounterView> createState() => _TellerCounterViewState();
}

class _TellerCounterViewState extends State<TellerCounterView> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CounterProvider>(context, listen: false).getCounter(branchId: widget.tellerModel.branchId);
      timer = Timer.periodic(
        const Duration(seconds: 10),
        (Timer t) =>
            Provider.of<CounterProvider>(context, listen: false).getCounter(branchId: widget.tellerModel.branchId),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _confirmResetDialog({required String branch}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reset'),
          content: Text('Reset $branch queue counter?'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Provider.of<CounterProvider>(context, listen: false)
                    .resetCounter(branchId: widget.tellerModel.branchId, name: widget.tellerModel.name);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Theme.of(context).colorScheme.inversePrimary;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text("${widget.tellerModel.branch} Queue"),
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
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        FloatingActionButton(
          backgroundColor: Colors.green,
          heroTag: 'btn-add',
          child: const Text('Add'),
          onPressed: () {
            Provider.of<CounterProvider>(context, listen: false)
                .updateCounter(branchId: widget.tellerModel.branchId, name: widget.tellerModel.name);
          },
        ),
        FloatingActionButton(
          backgroundColor: Colors.red,
          heroTag: 'btn-reset',
          child: const Text('Reset'),
          onPressed: () {
            _confirmResetDialog(branch: widget.tellerModel.branch);
          },
        ),
      ],
    );
  }
}
