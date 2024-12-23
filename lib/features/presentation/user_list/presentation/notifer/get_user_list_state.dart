import 'package:heal_tether_task/core/enums/enums.dart';
import 'package:heal_tether_task/features/presentation/user_list/data/model/get_users_list_response.dart';

class GetUsersListNotifierState {
  GetUsersListNotifierState({
    required this.getUsersListState,
    required this.getUsersListResponse,
  });
  factory GetUsersListNotifierState.initial() {
    return GetUsersListNotifierState(
      getUsersListState: LoadState.idle,
      getUsersListResponse: [],
    );
  }

  final LoadState getUsersListState;
  final List<GetUsersListResponse>? getUsersListResponse;
  GetUsersListNotifierState copyWith({
    LoadState? getUsersListState,
    final List<GetUsersListResponse>? getUsersListResponse,
  }) {
    return GetUsersListNotifierState(
      getUsersListResponse: getUsersListResponse ?? this.getUsersListResponse,
      getUsersListState: getUsersListState ?? this.getUsersListState,
    );
  }
}
