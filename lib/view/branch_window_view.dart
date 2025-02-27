import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_parasat/model/teller_model.dart';

import '../model/branch_model.dart';
import '../providers/branch_teller_provider.dart';
import '../widgets/snackbar_widget.dart';

class BranchWindowView extends StatefulWidget {
  const BranchWindowView({super.key, required this.branchModel});
  final BranchModel branchModel;

  @override
  State<BranchWindowView> createState() => _BranchWindowViewState();
}

class _BranchWindowViewState extends State<BranchWindowView> {
  late BranchTellerProvider branchTellerProvider;
  @override
  void initState() {
    super.initState();
    branchTellerProvider = Provider.of<BranchTellerProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await branchTellerProvider.getBranchTeller(branchId: widget.branchModel.id);
    });
  }

  void _showWindowDetail({
    required TellerModel tellerModel,
    required String window,
    required String name,
    required String type,
    required int counter,
    required BranchTellerProvider branchTellerProvider,
  }) async {
    final nameController = TextEditingController(text: name);
    final counterController = TextEditingController(text: counter.toString());
    final windowController = TextEditingController(text: window);
    const dropdownTypeList = <String>['Teller', 'CSR'];
    String dropdownTypeValue = type;
    bool isActive = tellerModel.active == 1 ? true : false;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Window $window Details'),
          content: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 300.0,
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: "Name..",
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  TextField(
                    controller: counterController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: "Counter..",
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  TextField(
                    controller: windowController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: "Window..",
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Type:', style: TextStyle(fontSize: 16.0)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        width: 200.0,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            borderRadius: BorderRadius.circular(8.0),
                            padding: const EdgeInsets.all(8.0),
                            value: dropdownTypeValue,
                            onChanged: (String? value) {
                              setState(() {
                                dropdownTypeValue = value!;
                              });
                              debugPrint("dropdownTypeValue $dropdownTypeValue");
                            },
                            items: dropdownTypeList.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return SizedBox(
                        width: 280.0,
                        child: Row(
                          children: [
                            const Text(
                              'Active:',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            CupertinoSwitch(
                              value: isActive,
                              onChanged: (_) {
                                setState(() {
                                  isActive = !isActive;
                                });
                                debugPrint("isActive $isActive");
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await branchTellerProvider.updateTeller(
                    id: tellerModel.id,
                    counter: int.tryParse(counterController.text) ?? 0,
                    name: nameController.text.trim(),
                    type: dropdownTypeValue,
                    window: windowController.text.trim(),
                    active: isActive == true ? 1 : 0,
                  );
                } else {
                  showError(message: 'Missing Parameters..');
                }
                // ignore: use_build_context_synchronously
                branchTellerProvider.getBranchTeller(branchId: widget.branchModel.id);
                // ignore: use_build_context_synchronously
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

  void _showInsertTellerWindow({required BranchTellerProvider branchTellerProvider}) async {
    final nameController = TextEditingController();
    final windowController = TextEditingController();
    const dropdownTypeList = <String>['Teller', 'CSR'];
    String dropdownTypeValue = dropdownTypeList.first;
    bool isActive = true;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Teller'),
          content: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 250.0,
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: "Name..",
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  TextField(
                    controller: windowController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: "Window..",
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Type:', style: TextStyle(fontSize: 16.0)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        width: 200.0,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            borderRadius: BorderRadius.circular(8.0),
                            padding: const EdgeInsets.all(8.0),
                            value: dropdownTypeValue,
                            onChanged: (String? value) {
                              setState(() {
                                dropdownTypeValue = value!;
                              });
                              debugPrint("dropdownTypeValue $dropdownTypeValue");
                            },
                            items: dropdownTypeList.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return SizedBox(
                        width: 280.0,
                        child: Row(
                          children: [
                            const Text(
                              'Active:',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            CupertinoSwitch(
                              value: isActive,
                              onChanged: (_) {
                                setState(() {
                                  isActive = !isActive;
                                });
                                debugPrint("isActive $isActive");
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () async {
                if (nameController.text.isNotEmpty && windowController.text.isNotEmpty) {
                  await branchTellerProvider.insertTeller(
                    name: nameController.text,
                    type: dropdownTypeValue,
                    branchId: widget.branchModel.id,
                    window: windowController.text.trim(),
                  );
                } else {
                  showError(message: 'Missing Parameters..');
                }
                // ignore: use_build_context_synchronously
                branchTellerProvider.getBranchTeller(branchId: widget.branchModel.id);
                // ignore: use_build_context_synchronously
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

  void _showDeleteTellerWindow({
    required BranchTellerProvider branchTellerProvider,
    required TellerModel tellerModel,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Teller'),
          content: Text('Delete ${tellerModel.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () async {
                await branchTellerProvider.deleteTeller(id: tellerModel.id);
                // ignore: use_build_context_synchronously
                branchTellerProvider.getBranchTeller(branchId: widget.branchModel.id);
                // ignore: use_build_context_synchronously
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.branchModel.branch} Window Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50.0,
              width: 500.0,
              color: Colors.grey,
              child: const Center(
                child: Text(
                  'Window',
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 500.0,
                child: Consumer<BranchTellerProvider>(
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
                        itemCount: value.branchTeller.length,
                        itemBuilder: (ctx, i) {
                          return Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: ListTile(
                              leading: Text(
                                value.branchTeller[i].window,
                                style: const TextStyle(fontSize: 18.0),
                              ),
                              title: Text(value.branchTeller[i].name),
                              subtitle: Text("${value.branchTeller[i].type} "),
                              trailing: IconButton(
                                onPressed: () {
                                  _showDeleteTellerWindow(
                                    branchTellerProvider: branchTellerProvider,
                                    tellerModel: value.branchTeller[i],
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              onTap: () {
                                _showWindowDetail(
                                  tellerModel: value.branchTeller[i],
                                  window: value.branchTeller[i].window,
                                  name: value.branchTeller[i].name,
                                  type: value.branchTeller[i].type,
                                  counter: value.branchTeller[i].counter,
                                  branchTellerProvider: branchTellerProvider,
                                );
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInsertTellerWindow(branchTellerProvider: branchTellerProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
