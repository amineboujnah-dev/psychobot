class UserModel {
  late String id;

  UserModel(this.id);
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String imageUrl;

  UserData(this.id, this.name, this.email, this.phoneNumber, this.address,
      this.imageUrl);
}
