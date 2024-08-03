import 'package:chatbox/features/data/data_sources/broadcast_data/broadcast_data.dart';
import 'package:chatbox/features/data/models/broadcast_model/broadcast_model.dart';
import 'package:chatbox/features/domain/repositories/broadcast_repo/broadcast_repository.dart';

class BrocastRepositoryImpl extends BroadcastRepository {
  final BroadcastData broadcastData;
  BrocastRepositoryImpl({
    required this.broadcastData,
  });
  @override
  Future<bool> createBroadCast({required BroadCastModel brocastModel}) async {
    return await broadcastData.createBroadCast(brocastModel: brocastModel);
  }
  
  @override
  Stream<List<BroadCastModel>>? getAllBroadCast() {
    return broadcastData.getAllBroadCast();
  }
}
