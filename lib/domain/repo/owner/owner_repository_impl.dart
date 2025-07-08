// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import '../../../data/owner_model.dart';
import '../../entities/owner.dart';
import 'owner_repository.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final FirebaseFirestore firestore;

  OwnerRepositoryImpl(this.firestore);

  @override
  Future<Owner> getOwnerById(String id) async {
    final doc = await firestore.collection('owners').doc(id).get();
    return OwnerModel.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<void> updateOwner(Owner owner) async {
    await firestore.collection('owners').doc(owner.id).update(
          (owner as OwnerModel).toJson(),
        );
  }

  @override
  Future<void> uploadOwnerImage(String ownerId, String base64Image) async {
    await firestore
        .collection('owners')
        .doc(ownerId)
        .update({'image': base64Image});
  }
}
