import 'dart:convert';

import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:flutter/material.dart';

class ScanID extends StatefulWidget {
  const ScanID({Key? key}) : super(key: key);

  @override
  _ScanIDState createState() => _ScanIDState();
}

class _ScanIDState extends State<ScanID> {
  String? _resultString = "";
  String? _fullDocumentFrontImageBase64 = "";
  String? _faceImageBase64 = "";

  // This widget will display a complete image of the passport or national id that is scanned.
  @override
  Widget build(BuildContext context) {
    Widget fullDocumentFrontImage = Container();
    if (_fullDocumentFrontImageBase64 != null &&
        _fullDocumentFrontImageBase64 != "") {
      fullDocumentFrontImage = Column(
        children: <Widget>[
          const Text("Document Front Image:"),
          Image.memory(
            const Base64Decoder().convert(_fullDocumentFrontImageBase64!),
            height: 180,
            width: 350,
          )
        ],
      );
    }
    //This widget will show the user image obtained from the passport or national id
    Widget faceImage = Container();
    if (_faceImageBase64 != null && _faceImageBase64 != "") {
      faceImage = Column(
        children: <Widget>[
          const Text("Face Image:"),
          Image.memory(
            const Base64Decoder().convert(_faceImageBase64!),
            height: 150,
            width: 100,
          )
        ],
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text(
            "Scan ID",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                  child: ElevatedButton(
                    child: const Text("Scan ID"),
                    onPressed: () => scan(),
                  ),
                  padding: const EdgeInsets.only(bottom: 16.0)),
              Text(_resultString!),
              fullDocumentFrontImage,
              // fullDocumentBackImage,
              faceImage,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scan() async {
    String license;
    // Set the license key depending on the target platform you are building for.
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      license =
          "sRwAAAAUY29tLnByb2pldC5tb2JpbGVreWMRqxd32LV0D7hJfts7i/49sXA1O3RlyS1+hzJrCdBdhq5ikhhILWqKLcr5SHvy8JeDEuZIAWR8+mZCogiXsCqFhmGCVAs5sSB2BKzK6i/cc6etacv3qAHeaxf8zTyWiX/H4PeViJ1Il5y6hvtffV+QOZ1HRsSes/WXwCbRxWoOr4/98dK9Vdwfwxrpa0dNf8Tl9hQKRBo01lu9bZP8NznvQAMSjwJL/kLFT4+mXMEwVg==";
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      license =
          "sRwAAAAUY29tLnByb2pldC5tb2JpbGVreWMRqxd32LV0D7hJfts7i/49sXA1O3RlyS1+hzJrCdBdhq5ikhhILWqKLcr5SHvy8JeDEuZIAWR8+mZCogiXsCqFhmGCVAs5sSB2BKzK6i/cc6etacv3qAHeaxf8zTyWiX/H4PeViJ1Il5y6hvtffV+QOZ1HRsSes/WXwCbRxWoOr4/98dK9Vdwfwxrpa0dNf8Tl9hQKRBo01lu9bZP8NznvQAMSjwJL/kLFT4+mXMEwVg==";
    } else {
      license =
          "sRwAAAAUY29tLnByb2pldC5tb2JpbGVreWMRqxd32LV0D7hJfts7i/49sXA1O3RlyS1+hzJrCdBdhq5ikhhILWqKLcr5SHvy8JeDEuZIAWR8+mZCogiXsCqFhmGCVAs5sSB2BKzK6i/cc6etacv3qAHeaxf8zTyWiX/H4PeViJ1Il5y6hvtffV+QOZ1HRsSes/WXwCbRxWoOr4/98dK9Vdwfwxrpa0dNf8Tl9hQKRBo01lu9bZP8NznvQAMSjwJL/kLFT4+mXMEwVg==";
    }

    var idRecognizer = BlinkIdCombinedRecognizer();
    idRecognizer.returnFullDocumentImage = true;
    idRecognizer.returnFaceImage = true;

    BlinkIdOverlaySettings settings = BlinkIdOverlaySettings();

    var results = await MicroblinkScanner.scanWithCamera(
        RecognizerCollection([idRecognizer]), settings, license);

    if (!mounted) return;
    // When the scan is cancelled, the result is null therefore we return to the the main screen.
    if (results.isEmpty) return;
    //When the result is not null, we check if it is a passport then obtain the details using the `getPassportDetails` method and display them in the UI. If the document type is a national id, we get the details using the `getIdDetails` method and display them in the UI.
    for (var result in results) {
      if (result is BlinkIdCombinedRecognizerResult) {
        if (result.mrzResult?.documentType == MrtdDocumentType.Passport) {
          _resultString = getPassportResultString(result);
        } else {
          _resultString = getIdResultString(result);
        }

        setState(() {
          _resultString = _resultString;
          _fullDocumentFrontImageBase64 = result.fullDocumentFrontImage ?? "";
          _faceImageBase64 = result.faceImage ?? "";
        });

        return;
      }
    }
  }

  //This method is used to obtain the specific user details from the national id from the scan result object.
  String getIdResultString(BlinkIdCombinedRecognizerResult result) {
    // The information below will be otained from the natioal id if they are available.
    // In the case a field is not found, then it is skipped. For example, some national ids do not have the profession field.
    return buildResult(result.firstName, "First name") +
        buildResult(result.lastName, "Last name") +
        buildResult(result.fullName, "Full name") +
        buildResult(result.localizedName, "Localized name") +
        buildResult(result.additionalNameInformation, "Additional name info") +
        buildResult(result.address, "Address") +
        buildResult(
            result.additionalAddressInformation, "Additional address info") +
        buildResult(result.documentNumber, "Document number") +
        buildResult(
            result.documentAdditionalNumber, "Additional document number") +
        buildResult(result.sex, "Sex") +
        buildResult(result.issuingAuthority, "Issuing authority") +
        buildResult(result.nationality, "Nationality") +
        buildDateResult(result.dateOfBirth, "Date of birth") +
        buildIntResult(result.age, "Age") +
        buildDateResult(result.dateOfIssue, "Date of issue") +
        buildDateResult(result.dateOfExpiry, "Date of expiry") +
        buildResult(result.dateOfExpiryPermanent.toString(),
            "Date of expiry permanent") +
        buildResult(result.maritalStatus, "Martial status") +
        buildResult(result.personalIdNumber, "Personal Id Number") +
        buildResult(result.profession, "Profession") +
        buildResult(result.race, "Race") +
        buildResult(result.religion, "Religion") +
        buildResult(result.residentialStatus, "Residential Status") +
        buildResult(result.mrzResult!.mrzText, "MRZ Text") +
        buildDriverLicenceResult(result.driverLicenseDetailedInfo);
  }

  String buildResult(String? result, String propertyName) {
    if (result == null || result.isEmpty) {
      return "";
    }

    return propertyName + ": " + result + "\n";
  }

  //This function creates a complete date based on the date obtained from the scanned document. For example, date of the document issue.
  String buildDateResult(Date? result, String propertyName) {
    if (result == null || result.year == 0) {
      return "";
    }

    return buildResult(
        "${result.day}.${result.month}.${result.year}", propertyName);
  }

  String buildIntResult(int? result, String propertyName) {
    if (result == null || result < 0) {
      return "";
    }

    return buildResult(result.toString(), propertyName);
  }

  //This method obtained the
  String buildDriverLicenceResult(DriverLicenseDetailedInfo? result) {
    if (result == null) {
      return "";
    }

    return buildResult(result.restrictions, "Restrictions") +
        buildResult(result.endorsements, "Endorsements") +
        buildResult(result.vehicleClass, "Vehicle class") +
        buildResult(result.conditions, "Conditions");
  }

  String getPassportResultString(BlinkIdCombinedRecognizerResult? result) {
    if (result == null) {
      return "";
    }

    var dateOfBirth = "";
    if (result.mrzResult?.dateOfBirth != null) {
      dateOfBirth = "Date of birth: ${result.mrzResult!.dateOfBirth?.day}."
          "${result.mrzResult!.dateOfBirth?.month}."
          "${result.mrzResult!.dateOfBirth?.year}\n";
    }

    var dateOfExpiry = "";
    if (result.mrzResult?.dateOfExpiry != null) {
      dateOfExpiry = "Date of expiry: ${result.mrzResult?.dateOfExpiry?.day}."
          "${result.mrzResult?.dateOfExpiry?.month}."
          "${result.mrzResult?.dateOfExpiry?.year}\n";
    }

    return "First name: ${result.mrzResult?.secondaryId}\n"
        "Last name: ${result.mrzResult?.primaryId}\n"
        "Document number: ${result.mrzResult?.documentNumber}\n"
        "Sex: ${result.mrzResult?.gender}\n"
        "$dateOfBirth"
        "$dateOfExpiry"
        "MRZ text: ${result.mrzResult?.mrzText}";
  }
// This widget will display a complete image of the scanned passport or national id.
}
