import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../domain/country_phone_dto.dart';
import '../inputs/go_text_input.dart';

class PhoneAndCountry extends StatefulWidget {
  const PhoneAndCountry({super.key});

  @override
  State<PhoneAndCountry> createState() => _PhoneAndCountryState();
}

class _PhoneAndCountryState extends State<PhoneAndCountry> {
  final formController = FormController();
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

  late final MaskTextInputFormatter maskFormatter;

  late CountryPhoneDto defaultCountry;

  @override
  void initState() {
    final locale = 'RU';
    defaultCountry = countries.firstWhere(
      (c) => c.countryCode == locale,
      orElse: () => countries.first,
    );

    maskFormatter = MaskTextInputFormatter(
      mask: defaultCountry.phoneMask,
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );

    super.initState();

    formController.addFieldValueListener((field, value) {
      if (field == 'country') {
        final country = formController.getFieldValue<CountryPhoneDto>('country');
        formController.setValue('phone', '');
        updateMaskFormatter(country ?? defaultCountry);
      }
    });
  }

  void updateMaskFormatter(CountryPhoneDto country) {
    setState(() {
      maskFormatter = MaskTextInputFormatter(
        mask: country.phoneMask,
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GoPhoneInput(
              countries: countries,
              formController: formController,
              phoneMask: maskFormatter,
              defaultCountry: defaultCountry,
            ),
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

class GoPhoneInput extends StatefulWidget {
  final List<CountryPhoneDto> countries;
  final FormController formController;
  final MaskTextInputFormatter phoneMask;
  final CountryPhoneDto defaultCountry;

  const GoPhoneInput({
    super.key,
    required this.formController,
    required this.countries,
    required this.phoneMask,
    required this.defaultCountry,
  });

  @override
  State<GoPhoneInput> createState() => _GoPhoneInputState();
}

class _GoPhoneInputState extends State<GoPhoneInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CountryDropdown(
          countries: widget.countries,
          formController: widget.formController,
          defaultCountry: widget.defaultCountry,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DynamicForm(
            fields: [
              GoTextInput(
                keyboardType: const TextInputType.numberWithOptions(),
                label: 'Телефон',
                name: 'phone',
                inputFormatters: [widget.phoneMask],
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Поле обязательно';
                  }
                  return null;
                },
              ),
            ],
            controller: widget.formController,
          ),
        ),
      ],
    );
  }
}

class CountryDropdown extends StatelessWidget {
  final List<CountryPhoneDto> countries;
  final FormController formController;
  final CountryPhoneDto defaultCountry;

  const CountryDropdown({
    super.key,
    required this.countries,
    required this.formController,
    required this.defaultCountry,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicForm(
      fields: [
        CountryCodeSelector(
          name: 'country',
          countries: countries,
          validator: (v) {
            if (v == null) {
              return 'Поле обязательно';
            }
            return null;
          },
          initialValue: defaultCountry,
        )
      ],
      controller: formController,
    );
  }
}

class CountryCodeSelector extends FormFieldModelBase<CountryPhoneDto> {
  final List<CountryPhoneDto> countries;

  const CountryCodeSelector({
    required super.name,
    required this.countries,
    super.validator,
    super.initialValue,
  });

  @override
  Widget build(
      BuildContext context, FieldController<CountryPhoneDto> controller) {
    return InkWell(
      onTap: () => _showCountrySelectionSheet(context, controller),
      child: Text(
        '${controller.value?.flagEmoji} ${controller.value?.dialCode}',
      ),
    );
  }

  void _showCountrySelectionSheet(
      BuildContext context, FieldController<CountryPhoneDto> controller) {
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
                          controller.setValue(country);
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
