import 'dart:io';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeViewModel extends GetxController {
  final String _urlInsta = 'https://www.instagram.com/';
  final String _urlYoutube = 'https://www.youtube.com/';
  final String _urlTwitter = 'https://twitter.com/explore';

  launchInsta() async {
    if (Platform.isIOS) {
      if (await canLaunch(_urlInsta)) {
        await launch(_urlInsta, forceSafariVC: false);
      } else {
        if (await canLaunch(_urlInsta)) {
          await launch(_urlInsta);
        } else {
          throw 'Could not launch $_urlInsta';
        }
      }
    } else {
      if (await canLaunch(_urlInsta)) {
        await launch(_urlInsta);
      } else {
        throw 'Could not launch $_urlInsta';
      }
    }
  }

  launchYoutube() async {
    if (Platform.isIOS) {
      if (await canLaunch(_urlYoutube)) {
        await launch(_urlYoutube, forceSafariVC: false);
      } else {
        if (await canLaunch(_urlYoutube)) {
          await launch(_urlYoutube);
        } else {
          throw 'Could not launch $_urlYoutube';
        }
      }
    } else {
      if (await canLaunch(_urlYoutube)) {
        await launch(_urlYoutube);
      } else {
        throw 'Could not launch $_urlYoutube';
      }
    }
  }

  launchTwitter() async {
    if (Platform.isIOS) {
      if (await canLaunch(_urlTwitter)) {
        await launch(_urlTwitter, forceSafariVC: false);
      } else {
        if (await canLaunch(_urlTwitter)) {
          await launch(_urlTwitter);
        } else {
          throw 'Could not launch $_urlTwitter';
        }
      }
    } else {
      if (await canLaunch(_urlTwitter)) {
        await launch(_urlTwitter);
      } else {
        throw 'Could not launch $_urlTwitter';
      }
    }
  }
}
