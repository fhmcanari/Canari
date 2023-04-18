import 'package:flutter/material.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  ScrollController _controller = ScrollController();
  List<String> _menuItems = [    'Item 1',    'Item 2',    'Item 3',    'Item 4',    'Item 5',    'Item 6',    'Item 7',    'Item 8',    'Item 9',    'Item 10',    'Item 11',    'Item 12',    'Item 13',    'Item 14',    'Item 15',    'Item 16',    'Item 17',    'Item 18',    'Item 19',    'Item 20',  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu List'),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.grey[200],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _menuItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      _controller.animateTo(
                        index * 60.0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      _menuItems[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: _menuItems.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_menuItems[index]),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
