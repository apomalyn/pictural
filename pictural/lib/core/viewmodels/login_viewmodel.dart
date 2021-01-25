
import 'package:oktoast/oktoast.dart';
import 'package:pictural/core/constants/paths.dart';
import 'package:pictural/core/managers/user_repository.dart';
import 'package:pictural/core/services/navigation_service.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:stacked/stacked.dart';
import 'package:pictural/locator.dart';

class LoginViewModel extends BaseViewModel {

  final UserRepository _userRepository = locator<UserRepository>();

  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUp() async {
    setBusy(true);
    final bool loggingSuccessful = await _userRepository.logIn();

    if(loggingSuccessful) {
      _navigationService.pushNamed(Paths.photos);
    } else {
      setBusy(false);

      showToast(AppIntl.current.error, duration: const Duration(seconds: 3));
    }
  }
}
