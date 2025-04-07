import 'package:guardian_angel/utils.dart';
import 'package:flutter/material.dart';

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<TodoItem> todoItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: () {
            _addTodoItem();
          },
          tooltip: 'Add Task',
          child: Icon(Icons.add, color: ColorConstant.blackColor),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To-Do Lists',
                style: TextStyle(color: ColorConstant.blackColor, fontSize: 32, fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: todoItems.length,
                  padding: EdgeInsets.only(top: 16, bottom: 66),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {
                                    mainItemClickHandler(index);
                                  },
                                  child: Image.asset(todoItems[index].isCompleted ? ImageConstants.checked : ImageConstants.unchecked, height: 24, width: 24)),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  todoItems[index].title,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: todoItems[index].isCompleted ? ColorConstant.checkedColor : ColorConstant.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    decoration: todoItems[index].isCompleted ? TextDecoration.lineThrough : null,
                                    decorationColor: ColorConstant.checkedColor,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _addTodoItem(subItem: true, index: index);
                                },
                                child: Icon(
                                  Icons.add,
                                  color: ColorConstant.secondaryColor,
                                ),
                              )
                            ],
                          ),
                          if (todoItems[index].subItems.isNotEmpty)
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: todoItems[index].subItems.length,
                                itemBuilder: (BuildContext context, int subIndex) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 16, left: 32),
                                    child: Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              subItemClickHandler(index, subIndex);
                                            },
                                            child: Image.asset(todoItems[index].subItems[subIndex].isCompleted ? ImageConstants.subChecked : ImageConstants.subUnchecked,
                                                height: 24, width: 24)),
                                        SizedBox(width: 12),
                                        Text(
                                          todoItems[index].subItems[subIndex].title,
                                          style: TextStyle(
                                              color: todoItems[index].subItems[subIndex].isCompleted ? ColorConstant.checkedColor : ColorConstant.blackColor,
                                              fontSize: 16,
                                              decoration: todoItems[index].subItems[subIndex].isCompleted ? TextDecoration.lineThrough : null,
                                              decorationColor: ColorConstant.checkedColor,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  subItemClickHandler(int index, int subIndex) {
    todoItems[index].subItems[subIndex].isCompleted = !todoItems[index].subItems[subIndex].isCompleted;
    todoItems[index].isCompleted = !todoItems[index].subItems.map((e) => e.isCompleted).toList().contains(false);
    setState(() {});
  }

  mainItemClickHandler(int index) {
    todoItems[index].isCompleted = !todoItems[index].isCompleted;
    if (todoItems[index].subItems.isNotEmpty) {
      for (var i = 0; i < todoItems[index].subItems.length; i++) {
        if (todoItems[index].isCompleted) {
          todoItems[index].subItems[i].isCompleted = true;
        } else {
          todoItems[index].subItems[i].isCompleted = false;
        }
      }
    }
    setState(() {});
  }

  void _addTodoItem({bool subItem = false, int? index}) {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Enter task...'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (subItem) {
                  setState(() {
                    if (_textFieldController.text.isNotEmpty) {
                      if (todoItems[index!].subItems.isEmpty) {
                        todoItems[index].subItems = [];
                      }
                      todoItems[index].subItems.add(SubTodoItem(_textFieldController.text.toString()));
                      todoItems[index].isCompleted = !todoItems[index].subItems.map((e) => e.isCompleted).toList().contains(false);
                    }
                    Navigator.of(context).pop();
                  });
                  print(todoItems.toString());
                } else {
                  setState(() {
                    if (_textFieldController.text.isNotEmpty) {
                      todoItems.add(TodoItem(_textFieldController.text.toString()));
                    }
                    Navigator.of(context).pop();
                  });
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class TodoItem {
  int id;
  String title;
  bool isCompleted;
  List<SubTodoItem> subItems;

  TodoItem(this.title, {this.id = 0, this.isCompleted = false, this.subItems = const []});
}

class SubTodoItem {
  int id;
  String title;
  bool isCompleted;
  SubTodoItem(this.title, {this.id = 0, this.isCompleted = false});
}
