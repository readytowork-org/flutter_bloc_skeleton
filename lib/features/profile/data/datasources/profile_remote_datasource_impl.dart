import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/data/models/user_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  final DioClient _dioClient;
  ProfileRemoteDataSourceImpl(DioClient dioClient) : _dioClient = dioClient;
  @override
  Future<UserModel> getProfile() async {
    final response = await _dioClient.get(ApiEndpoints.profile);
    return UserModel.fromJson(response.data);
  }
}
