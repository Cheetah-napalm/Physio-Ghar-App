class TherapistProfileModel {
  final String name;
  final String specialization;
  final String email;
  final String phone;
  final String experience;
  final String address;
  final String imageUrl;

  TherapistProfileModel({
    required this.name,
    required this.specialization,
    required this.email,
    required this.phone,
    required this.experience,
    required this.address,
    required this.imageUrl,
  });

  TherapistProfileModel copyWith({
    String? name,
    String? specialization,
    String? email,
    String? phone,
    String? experience,
    String? address,
    String? imageUrl,
  }) {
    return TherapistProfileModel(
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      experience: experience ?? this.experience,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory TherapistProfileModel.fromJson(Map<String, dynamic> json) {
    return TherapistProfileModel(
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      experience: json['experience'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialization': specialization,
      'email': email,
      'phone': phone,
      'experience': experience,
      'address': address,
      'image_url': imageUrl,
    };
  }
}