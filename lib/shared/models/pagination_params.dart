import '../../core/utils/strings/index.dart';
import '../../core/utils/typedf/index.dart';

class PaginationParams {
  final int pageSize;
  String? filter;
  int? skip;
  int page;

  PaginationParams({
    this.pageSize = 10,
    this.filter = emptyString,
    this.page = 1,
    this.skip,
  });

  JsonMap toPageJson() => {
    "page": page,
    "page_size": pageSize,
    "filter": filter,
  };
  JsonMap toCursorJson() => {
    "limit": pageSize,
    if (skip != null) "skip": skip,
    if (filter != null) "filter": filter,
  };
}
