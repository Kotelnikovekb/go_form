import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

import '../domain/country_phone_dto.dart';
import '../inputs/go_text_input.dart';
import '../inputs/root_input.dart';

class PhoneAndCountry extends StatefulWidget {
  const PhoneAndCountry({super.key});

  @override
  State<PhoneAndCountry> createState() => _PhoneAndCountryState();
}

class _PhoneAndCountryState extends State<PhoneAndCountry> {
  final formController = FormController(debug: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DynamicForm(fields: [
              GoPhoneAndCountryInput(name: 'phoneAndCountrty'),
            ], controller: formController),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                debugPrint(formController.getFieldValue<String>('phone'));
              },
              child: const Text('Значение поля'),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneState {
  final String? value;
  final MaskTextInputFormatter maskFormatter;
  final CountryPhoneDto country;

  const PhoneState({
    this.value,
    required this.maskFormatter,
    required this.country,
  });

  PhoneState copyWith({
    String? value,
    MaskTextInputFormatter? maskFormatter,
    CountryPhoneDto? country,
    bool? clearPhone,
  }) =>
      PhoneState(
        value: (clearPhone == true) ? null : value ?? this.value,
        maskFormatter: maskFormatter ?? this.maskFormatter,
        country: country ?? this.country,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneState &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          maskFormatter == other.maskFormatter &&
          country == other.country;

  @override
  int get hashCode => Object.hash(value, maskFormatter, country);
}

List<CountryPhoneDto> countries = [
  CountryPhoneDto(
    name: 'Россия',
    nativeName: 'Россия',
    countryCode: 'RU',
    dialCode: '+7',
    flagEmoji: '🇷🇺',
    phoneMask: '(###) ###-##-##',
    priority: 1,
  ),
  CountryPhoneDto(
    name: 'США',
    nativeName: 'United States',
    countryCode: 'US',
    dialCode: '+1',
    flagEmoji: '🇺🇸',
    phoneMask: '(###) ###-####',
    priority: 2,
  ),
  CountryPhoneDto(
    name: 'Германия',
    nativeName: 'Deutschland',
    countryCode: 'DE',
    dialCode: '+49',
    flagEmoji: '🇩🇪',
    phoneMask: '#### ########',
    priority: 4,
  ),
  CountryPhoneDto(
    name: 'Франция',
    nativeName: 'France',
    countryCode: 'FR',
    dialCode: '+33',
    flagEmoji: '🇫🇷',
    phoneMask: '# ## ## ## ##',
    priority: 5,
  ),
  CountryPhoneDto(
    name: 'Бразилия',
    nativeName: 'Brasil',
    countryCode: 'BR',
    dialCode: '+55',
    flagEmoji: '🇧🇷',
    phoneMask: '(##) #####-####',
    priority: 6,
  ),
];

class GoPhoneAndCountryInput extends FormFieldModelBase<PhoneState> {
  final String? label;

  const GoPhoneAndCountryInput({
    required super.name,
    this.label,
  });

  @override
  void onInit(FieldController<PhoneState> controller) {
    final country = countries.firstWhere(
      (c) => c.countryCode == 'RU',
      orElse: () => countries.first,
    );
    final maskFormatter = MaskTextInputFormatter(
      mask: country.phoneMask,
      filter: {"#": RegExp(r'[0-9]')},
    );
    controller.setValue(
      PhoneState(value: '', maskFormatter: maskFormatter, country: country),
    );

    super.onInit(controller);
  }

  @override
  Widget build(BuildContext context, FieldController<PhoneState> controller) {
    final value = controller.value;
    if (value == null) {
      return Container();
    }

    return RootInput(
      initialValue: controller.value?.value,
      key: ValueKey(controller.value!.maskFormatter.getMask()),
      onChanged: (newValue) =>
          controller.onChange(controller.value?.copyWith(value: newValue)),
      errorText: controller.error,
      labelText: label,
      prefix: InkWell(
        onTap: () => _showCountrySelectionSheet(context, controller),
        child: Text(
          '${controller.value?.country.flagEmoji} ${controller.value?.country.dialCode} ',
        ),
      ),
      inputFormatters: [controller.value!.maskFormatter],
      focusNode: controller.focusNode,
    );
  }

  void _showCountrySelectionSheet(
      BuildContext context, FieldController<PhoneState> controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Выберите страну',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: InkWell(
                        onTap: () {
                          controller.setValue(
                            controller.value?.copyWith(
                              country: country,
                              maskFormatter: MaskTextInputFormatter(
                                mask: country.phoneMask,
                                filter: {"#": RegExp(r'[0-9]')},
                              ),
                              clearPhone: true,
                            ),
                          );
                          controller.value?.maskFormatter.clear();
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${country.flagEmoji} ${country.name}'),
                            Text(country.dialCode),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}
