import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:essumin_mix/blocs/data_event.dart';
import 'package:essumin_mix/blocs/data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(HomeState());

  Stream<DataState> mapEventToState(DataEvent event) async* {
    if (event is SelectSiglasEvent) {
      yield SiglasState();
    } else if (event is SelectSimbologiasEvent) {
      yield SimbologiasState();
    } else {
      yield HomeState();
    }
  }
}
