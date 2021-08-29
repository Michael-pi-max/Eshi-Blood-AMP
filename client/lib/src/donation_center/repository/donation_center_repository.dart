import 'package:eshiblood/src/donation_center/data_provider/donationCenterDB.dart';
import 'package:eshiblood/src/donation_center/data_provider/donation_center_data.dart';
import 'package:eshiblood/src/donation_center/models/donation_center.dart';

class DonationCenterRepository {
  final DonationCenterDataProvider dataProvider;
  final DonationCenterDB dbProvider = DonationCenterDB();

  DonationCenterRepository({required this.dataProvider});

  Future<DonationCenter> createDonationCenter(
      DonationCenter donationCenter) async {
    return await dataProvider.createDonationCenter(donationCenter);
  }

  Future<List<DonationCenter>> getDonationCenters() async {
    try {
      print("donation center fetch from network");
      var donationCenters = await dataProvider.getDonationCenters();
      try {
        print("donation center saving to db");
        if (donationCenters.length != 0) {
          // TODO
          await dbProvider.deleteDonationCenterTable();
          donationCenters.forEach((donationCenter) async {
            await dbProvider.createDonationCenter(donationCenter);
          });
        }
      } catch (e) {
        print("donation center saving failed");
        return [];
      }
      return donationCenters;
    } catch (e) {
      try {
        print("donation center fetch from db");
        var donationCenters = dbProvider.getDonationCenters();
        return donationCenters;
      } catch (e) {
        print("donation center fetch from db failed");
        return [];
      }
    }
  }

  Future<DonationCenter?> getDonationCenter(String id) async {
    try {
      print("donation center fetch from network");
      var donationCenter = await dataProvider.getDonationCenter(id);
      try {
        if (donationCenter != null) {
          print("donation center saving to db");
          await dbProvider.deleteDonationCenter(id);
          await dbProvider.createDonationCenter(donationCenter);
          return donationCenter;
        } else {
          return null;
        }
      } catch (e) {
        print("donation center saving failed");
        return donationCenter;
      }
    } catch (e) {
      try {
        print("donation center fetch from db");
        var donationCenter = await dbProvider.getDonationCenter(id);
        return donationCenter;
      } catch (e) {
        throw Exception("invalid id or can't get $id");
      }
    }
  }

  Future<void> updateDonationCenter(DonationCenter donationCenter) async {
    await dataProvider.updateDonationCenter(donationCenter);
  }

  Future<void> deleteDonationCenter(String id) async {
    await dataProvider.deleteDonationCenter(id);
    try {
      dbProvider.deleteDonationCenter(id);
    } catch (e) {
      print(
          "db donation center deletion exceptio may be id not found or not successful");
    }
  }
}
