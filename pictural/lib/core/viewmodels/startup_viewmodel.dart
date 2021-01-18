import 'package:pictural/core/constants/paths.dart';
import 'package:pictural/core/managers/user_repository.dart';
import 'package:pictural/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:pictural/locator.dart';

class StartupViewModel extends BaseViewModel {
  final UserRepository _userRepository = locator<UserRepository>();

  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUp() async {
    final bool loggingSuccessful = await _userRepository.logIn(silent: true);
    /// Wait 1s to avoid ultra speed loading, will result to the user asking what was that
    await Future.delayed(Duration(seconds: 1));

    if (loggingSuccessful) {
      _navigationService.pushNamed(Paths.friends);
    } else {
      print("Silent sign in failed, redirect to login");
      _navigationService.pushNamed(Paths.login);
    }
  }
}
