import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heal_tether_task/core/enums/enums.dart';
import 'package:heal_tether_task/features/presentation/user_list/data/repository/get_user_list_repository.dart';
import 'package:heal_tether_task/features/presentation/user_list/presentation/notifer/get_user_list_state.dart';

class GetUsersListNotifier
    extends AutoDisposeNotifier<GetUsersListNotifierState> {
  GetUsersListNotifier();

  late GetUserListRepository _getUsersListRepository;

  @override
  GetUsersListNotifierState build() {
    _getUsersListRepository = ref.read(getUserListRepositoryProvider);

    return GetUsersListNotifierState.initial();
  }

  Future<void> getUsersList() async {
    state = state.copyWith(getUsersListState: LoadState.loading);

    try {
      final value = await _getUsersListRepository.getUsersList();

      if (value == false) throw 'An error occurred';

      state = state.copyWith(
          getUsersListState: LoadState.idle, getUsersListResponse: value);
    } catch (e) {
      state = state.copyWith(getUsersListState: LoadState.idle);
    }
  }
}

final getUsersListNotifierProvider = NotifierProvider.autoDispose<
    GetUsersListNotifier, GetUsersListNotifierState>(GetUsersListNotifier.new);
