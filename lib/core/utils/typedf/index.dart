import '../../../shared/models/pagination_params.dart' show PaginationParams;
import '../../network/api_result.dart';

typedef JsonMap = Map<String, dynamic>;
typedef FutureCall<T> =
    Future<ApiResult<T>> Function(PaginationParams paginationParams);
