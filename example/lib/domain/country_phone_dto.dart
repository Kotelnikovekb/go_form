class CountryPhoneDto {
  final String name;
  final String nativeName;
  final String countryCode;
  final String dialCode;
  final String flagEmoji;
  final String phoneMask;
  final int priority;

  CountryPhoneDto({
    required this.name,
    required this.nativeName,
    required this.countryCode,
    required this.dialCode,
    required this.flagEmoji,
    required this.phoneMask,
    required this.priority,
  });

  factory CountryPhoneDto.fromJson(Map<String, dynamic> json) {
    return CountryPhoneDto(
      name: json['name'],
      nativeName: json['nativeName'],
      countryCode: json['countryCode'],
      dialCode: json['dialCode'],
      flagEmoji: json['flagEmoji'],
      phoneMask: json['phoneMask'],
      priority: json['priority'],
    );
  }
}