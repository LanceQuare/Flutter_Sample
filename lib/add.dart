import 'package:flutter/material.dart';
import 'package:proj_tracking/models/category.dart';
import 'package:proj_tracking/utils/db_helper.dart';

class AddPage extends StatefulWidget {
  final Category category;

  AddPage(this.category);

  @override
  State<StatefulWidget> createState() {
    return _AddPageState(this.category, this.category.name);
  }
}

class _AddPageState extends State<AddPage> {
  String barTitle;
  Category category;

  TextEditingController titleCtl = TextEditingController();
  TextEditingController descibeCtl = TextEditingController();
  DBHelper helper = DBHelper();

  _AddPageState(this.category, this.barTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.title;
    titleCtl.text = category.name;
    descibeCtl.text = category.name;

    return WillPopScope(
      onWillPop: () async {
        backToPrevioustPage();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(barTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              backToPrevioustPage();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleCtl,
                  style: titleStyle,
                  onChanged: (value) {
                    debugPrint('Title field changed!');
                    category.name = titleCtl.text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: titleStyle,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descibeCtl,
                  style: titleStyle,
                  onChanged: (value) {
                    debugPrint('Description field changed!');
                    //todo update the value once we have it later
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: titleStyle,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Save'), 
                        onPressed: () async {
                          setState(() {
                            saveCategory();  
                          });        
                        })
                    ),
                    Container(width: 5.0),
                    Expanded(
                      child: RaisedButton(
                        child: Text('Drop'), 
                        onPressed: () async {
                          backToPrevioustPage();
                          deleteCategory();
                        }
                      )
                    )
                  ],
                )
              )
            ],
          )
        ),
      ),
    );
  }

  void backToPrevioustPage() {
    Navigator.pop(context, true);
  }

  void saveCategory() {
    if(category.name.length < 2) {
      alert('Oops!', 'Please enter the correct name!');
      return;
    }

    if(category.id != null) {
      helper.updateCategory(category);
    } else {
      helper.insertCategory(category);
    }
    //dnt knw why somehow back event must b4 alert
    backToPrevioustPage();
    alert('Saved!', 'Content saved successfully!');
  }

  void deleteCategory() {
    if(category.id == null) {
      alert('Oops!', 'Nothing changed!!');
      return;
    }

    helper.deleteCategory(category.id);
    alert('Deleted!', 'Content delted successfully!');
  }

  void alert(String title, String msg) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg)
    );

    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}

