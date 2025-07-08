// Project imports:
import '../../entities/owner.dart';

abstract class OwnerRepository {
  Future<Owner> getOwnerById(String id);
  Future<void> updateOwner(Owner owner);
  Future<void> uploadOwnerImage(String ownerId, String base64Image);
}
