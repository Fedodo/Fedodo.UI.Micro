import 'dart:io';
import 'package:activitypub/config.dart';
import 'package:fedodo_micro/Extensions/string_extensions.dart';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:fedodo_micro/Globals/general.dart';
import 'package:fedodo_micro/Globals/preferences.dart';
import 'package:fedodo_micro/SuSi/APIs/login_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Views/navigation.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Config.accessToken = Preferences.prefs?.getString("AccessToken");
    Config.domainName = Preferences.prefs?.getString("DomainName");
    Config.ownActorId = General.actorId;
    Config.asProxyString = (String value) {
      return value.asProxyString();
    };
    Config.asProxyUri = (Uri value) {
      return value.asProxyUri();
    };
    Config.refreshAccessToken = () async {
      LoginManager loginManager = LoginManager(!kIsWeb && Platform.isAndroid);
      await loginManager.refreshAsync();
      Config.accessToken = Preferences.prefs?.getString("AccessToken");
    };

    return const Navigation(title: "Fedodo Micro");
  }
}
