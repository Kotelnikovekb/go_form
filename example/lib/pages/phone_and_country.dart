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

  var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  late CountryPhoneDto defaultCountry;

  @override
  void initState() {
    final locale = 'RU';
    defaultCountry = countries.firstWhere(
      (c) => c.countryCode == locale,
      orElse: () => countries.first,
    );
    super.initState();

    formController.addFieldValueListener((f, v) {

      print('$f $v<');


      if (f == 'country') {
        final country = formController.getFieldValue<CountryPhoneDto>('country');
        formController.setValue('phone', '');

        print(formController.getFieldValue<String>('phone'));


        setState(() {
          maskFormatter.clear();
          maskFormatter = MaskTextInputFormatter(
            mask: country?.phoneMask ?? '(###) ###-##-##',
            filter: {"#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy,
          );
        });

        print(formController.getFieldValue<String>('phone'));

      }
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
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                print(formController.getFieldValue<String>('phone'));
              },
              child: Text('Значение поля'),
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
        Expanded(
          child: DynamicForm(
            fields: [
              GoTextInput(
                keyboardType: TextInputType.numberWithOptions(),
                label: 'autogen_057',
                name: 'phone',
                prefix: Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: DynamicForm(
                    fields: [
                      CountryCodeSelector(
                        name: 'country',
                        countries: widget.countries,
                        validator: (v) {
                          if (v == null) {
                            return 'autogen_058';
                          }
                          return null;
                        },
                        initialValue: widget.defaultCountry,
                      )
                    ],
                    controller: widget.formController,
                  ),
                ),
                inputFormatters: [widget.phoneMask],
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'autogen_058';
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
      child: Text(
        '${controller.value?.flagEmoji} ${controller.value?.dialCode}',
      ),
      onTap: () {
        showBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'select_country_title',
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            controller.setValue(countries[index]);
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${countries[index].flagEmoji} ${('country_code_${countries[index].countryCode}')}',
                              ),
                              Text(
                                countries[index].dialCode,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: countries.length,
                  ))
                ],
              ),
            );
          },
        );
      },
    );
  }
}
