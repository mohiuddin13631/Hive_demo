import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController textEditingController = TextEditingController();

  List _country = ["Bangladesh","India","Pakistan","Nepal","Bhutan"];

  Box? countryBox;
  @override
  void initState() {
    // TODO: implement initState
    countryBox = Hive.box("country_list");
    super.initState();
  }
  var textFieldValue = "Update";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)
                  )
                ),
              ),
            ),
            SizedBox(height: 11,),
            ElevatedButton(onPressed: (){
              final userInput = textEditingController.text;
              countryBox!.add(userInput);
              textEditingController.clear();
            }, child: Text("Add Data")),
            SizedBox(height: 11,),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable:Hive.box("country_list").listenable(), builder: (context, value, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: countryBox!.keys.toList().length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(countryBox!.getAt(index).toString()),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(onPressed: (){
                                textFieldValue = countryBox!.getAt(index).toString();
                                print(textFieldValue);
                                // setState(() {
                                //
                                // });
                                showDialog(context: context, builder: (context) {
                                  TextEditingController dialogController = TextEditingController(text: textFieldValue);
                                  return AlertDialog(

                                    content: Container(
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          TextField(
                                            controller: dialogController,

                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16)
                                                )
                                            ),
                                          ),
                                          SizedBox(height: 11,),
                                          ElevatedButton(onPressed: (){
                                            final updateValue = dialogController.text;
                                            countryBox!.putAt(index, updateValue);
                                            Navigator.pop(context);
                                          }, child: Text("Update Data")),
                                        ],
                                      ),
                                    ),
                                  );
                                },);
                              },icon: Icon(Icons.edit)),
                              SizedBox(width: 16,),
                              IconButton(onPressed: (){
                                countryBox!.deleteAt(index);
                              },icon: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },);
              },),
            ),

          ],
        ),
      ),
    );
  }
}
