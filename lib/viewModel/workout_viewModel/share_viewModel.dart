import 'dart:io';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareViewModel extends GetxController {
  final String _urlInsta = 'https://www.instagram.com/';
  final String _urlFacebook = 'https://www.facebook.com/';
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

  launchFacebook() async {
    if (Platform.isIOS) {
      if (await canLaunch(_urlFacebook)) {
        await launch(_urlFacebook, forceSafariVC: false);
      } else {
        if (await canLaunch(_urlFacebook)) {
          await launch(_urlFacebook);
        } else {
          throw 'Could not launch $_urlFacebook';
        }
      }
    } else {
      if (await canLaunch(_urlFacebook)) {
        await launch(_urlFacebook);
      } else {
        throw 'Could not launch $_urlFacebook';
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
