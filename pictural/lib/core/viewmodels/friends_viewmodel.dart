import 'package:pictural/core/constants/paths.dart';
import 'package:pictural/core/managers/user_repository.dart';
import 'package:pictural/core/models/user.dart';
import 'package:pictural/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:pictural/locator.dart';

class FriendsViewModel extends FutureViewModel<User> {
  final UserRepository _userRepository = locator<UserRepository>();

  final NavigationService _navigationService = locator<NavigationService>();

  User get user => _userRepository.user;

  @override
  Future<User> futureToRun() async {
    setBusy(true);
    if (_userRepository.user == null) {
      if (await _userRepository.logIn(silent: true) == false)
        _navigationService.pushReplacementNamed(Paths.login);
    }
    setBusy(false);

    return _userRepository.user;
  }
}
