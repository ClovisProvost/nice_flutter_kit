import 'dart:collection';

import 'package:nice_flutter_kit/nice_flutter_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NiceOnboardingGlobalConfig {
  final String sharedPrefKey;
  late SharedPreferences _sharedPref;
  bool? _onboardingCompleted;
  late HashMap<NicePermissionTypes, bool> isPermissionEnabled = new HashMap<NicePermissionTypes, bool>();
  final Set<NicePermissionTypes>? permissions;
  final bool debug;

  NiceOnboardingGlobalConfig({
    this.sharedPrefKey: "ONBOARDING_COMPLETED",
    this.permissions,
    this.debug: false,
  });

  Future<void> init() async {
    _sharedPref = await SharedPreferences.getInstance();
    this._onboardingCompleted = _sharedPref.getBool(sharedPrefKey) ?? false;

    if (!debug) {
      this._onboardingCompleted = false;
    }

    for (final permission in (permissions ?? {}).toList()) {
      isPermissionEnabled[permission] = await NicePermissionUtils.isPermissionEnabled(permission);
    }
  }

  bool get onboardingCompleted {
    assert(this._onboardingCompleted != null,
        "NiceOnboarding wasn't initialized, please provide NiceOnboardingConfig in main");
    return this._onboardingCompleted!;
  }

  set onboardingCompleted(bool onboardingCompleted) {
    assert(this._onboardingCompleted != null,
        "NiceOnboarding wasn't initialized, please provide NiceOnboardingConfig in main");
    this._onboardingCompleted = onboardingCompleted;
    _sharedPref.setBool(sharedPrefKey, true);
  }
}
