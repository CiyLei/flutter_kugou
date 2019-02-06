import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:flutter_kugou/component/bloc/kugou_bloc.dart';

class PlayerBloc extends BlocBase {

  PlayerBloc(this.kuGouBloc);

  KuGouBloc kuGouBloc;

  @override
  void dispose() {
  }


}