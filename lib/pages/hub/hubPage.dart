import 'package:flutter/material.dart';
import 'package:reddit_app/models/hubModel.dart';



class HubPage extends StatefulWidget {
  final HubModel hubModel;
  const HubPage({
    required this.hubModel,
    super.key
  });


  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.hubModel.hubTitle, style: const TextStyle(color: Colors.black)),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back), color: Colors.black),
      ),
      body: const Column(
        children: []),
    );
  }
}
