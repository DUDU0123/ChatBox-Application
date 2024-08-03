import 'package:chatbox/features/data/models/broadcast_model/broadcast_model.dart';

abstract class BroadcastRepository{
  Future<bool> createBroadCast({
    required BroadCastModel brocastModel,
  });
  Stream<List<BroadCastModel>>? getAllBroadCast();
}