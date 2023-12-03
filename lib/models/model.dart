class UserModelOne {
  String uid;
   String? name;
   String? phone;
   String? email;
   String? mailingAddress;
   String? billingAddress;
   bool? isSameAsMailingAddress;
   String? preferredDinnerNumber;
   int? earnedPoints;
   String? preferredPaymentMethod;

  UserModelOne({
    required this.uid,
     this.name,
     this.phone,
     this.email,
     this.mailingAddress,
     this.billingAddress,
     this.isSameAsMailingAddress,
     this.preferredDinnerNumber,
     this.earnedPoints,
     this.preferredPaymentMethod,
  });

  // data from server
  factory UserModelOne.fromMap(map) {
    return UserModelOne(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      billingAddress: map['billingAddress'],
      mailingAddress: map['mailingAddress'],
      phone: map['phone'],
      isSameAsMailingAddress: map['isSameAsMailingAddress'],
      preferredDinnerNumber: map['preferredDinnerNumber'] ?? '',
      earnedPoints: map['earnedPoints'] ?? 0,
      preferredPaymentMethod: map['preferredPaymentMethod'] ?? '',
    );
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'mailingAddress': mailingAddress,
      'billingAddress': billingAddress,
      'isSameAsMailingAddress': isSameAsMailingAddress,
      'preferredDinnerNumber': preferredDinnerNumber,
      'earnedPoints': earnedPoints,
      'preferredPaymentMethod': preferredPaymentMethod,
    };
  }
}
