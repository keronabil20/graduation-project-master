// Project imports:
import '../../../utils/services/image_upload_service.dart';
import '../../repo/owner/owner_repository.dart';

class UploadOwnerImageUseCase {
  final OwnerRepository repository;
  final ImageUploadService imageService;

  UploadOwnerImageUseCase(this.repository, this.imageService);

  Future<void> call(String ownerId) async {
    final file = await imageService.pickImage();
    if (file != null) {
      final base64Image = await imageService.fileToBase64(file);
      if (base64Image != null) {
        await repository.uploadOwnerImage(ownerId, base64Image);
      }
    }
  }
}
