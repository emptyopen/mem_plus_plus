import 'package:flutter/material.dart';
import 'package:mem_plus_plus/models/PAOData.dart';

class PAOView extends StatelessWidget {

  final PAOData paoData;

  PAOView({this.paoData});

  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: ListTile(

          leading: Text('${paoData.digits}'),
          title: Text('${paoData.person}'),
          subtitle: Text('${paoData.action} • ${paoData.object}'),
          trailing: FlatButton(
              child: Text('Edit',
                  style: TextStyle(color: Colors.cyan)),
              onPressed: () {
                /*  test */
              }
          ),
        ),
      ),
    );
  }
}