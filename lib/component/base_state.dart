import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';

abstract class BaseState<T extends StatefulWidget, F extends BlocBase> extends State<T>{
  F bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<F>(context);
  }
}