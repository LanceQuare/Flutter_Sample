import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:proj_tracking/add.dart';
import 'package:proj_tracking/models/category.dart';
import 'package:proj_tracking/utils/db_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DBHelper dbHelper = DBHelper();
  List<Category> categoryList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if(categoryList == null) {
      categoryList = List<Category>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Category(''), 'Add Todo');
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(this.categoryList[position].name.substring(0, 2),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.categoryList[position].name,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.categoryList[position].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, categoryList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.categoryList[position], 'Edit Todo');
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(Category category, String name) async {
   bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
     return AddPage(category);
   }));

   if (result == true) {
     updateListView();
   }
    debugPrint("Navigate to editor!!");
  }

  void updateListView() {
    final Future<Database> getDB = dbHelper.initializeDatabase();
    getDB.then((database) {
      Future<List<Category>> todoListFuture = dbHelper.getCategoryList();
      todoListFuture.then((list) {
        setState(() {
          this.categoryList = list;
          this.count = list.length;
        });
      });
    });
  }

  void _delete(BuildContext context, Category category) async {
    int result = await dbHelper.deleteCategory(category.id);
    if (result != 0) {
      _showSnackBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
