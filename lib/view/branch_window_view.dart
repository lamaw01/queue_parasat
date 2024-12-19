import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/branch_model.dart';
import '../providers/branch_teller_provider.dart';

class BranchWindowView extends StatefulWidget {
  const BranchWindowView({super.key, required this.branchModel});
  final BranchModel branchModel;

  @override
  State<BranchWindowView> createState() => _BranchWindowViewState();
}

class _BranchWindowViewState extends State<BranchWindowView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<BranchTellerProvider>(context, listen: false).getBranchTeller(branchId: widget.branchModel.id);
    });
  }

  void _showWindowDetail(
      {required String window, required String name, required String type, required int counter}) async {
    final nameController = TextEditingController(text: name);
    final counterController = TextEditingController(text: counter.toString());
    const dropdownTypeList = <String>['Teller', 'CSR'];
    String dropdownTypeValue = type;
    bool isActive = true;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        debugPrint("counterController ${counterController.text}");
        return AlertDialog(
          title: Text('Window $window Details'),
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
                      // hintStyle: TextStyle(color: Colors.grey[800]),
                      // hintText: "Name..",
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
                      // hintStyle: TextStyle(color: Colors.grey[800]),
                      // hintText: "Counter..",
                      fillColor: Colors.white70,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    width: double.maxFinite,
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
              onPressed: () {
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
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              onTap: () {
                                _showWindowDetail(
                                    window: value.branchTeller[i].window,
                                    name: value.branchTeller[i].name,
                                    type: value.branchTeller[i].type,
                                    counter: value.branchTeller[i].counter);
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
    );
  }
}
