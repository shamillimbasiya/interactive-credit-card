import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Dropdown());
}

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  final _months = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12"
  ];
  final _years = [
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030",
    "2031",
    "2032",
    "2033",
    "2034"
  ];
  String? _selectedMonth;
  String? _selectedYear;
  String? _cardHolder;
  String? _cardNumber = "";
  String? _cvv = "";
  String _cardType = "visa";
  final String _amexCardMask = "#### ###### #####";
  final String _otherCardMask = "#### #### #### ####";

  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();

  final FocusNode _nodeCvv = FocusNode();

  double angle = 0;
  void _flip() {
    setState(() => angle = (angle + pi) % (2 * pi));
  }

  @override
  void initState() {
    super.initState();

    _cardNumberController.addListener(() {
      String formatedText = formatField(_cardNumberController.text);
      _cardNumberController.value = TextEditingValue(
        text: formatedText,
        selection: TextSelection.collapsed(offset: formatedText.length),
      );
    });
    _nodeCvv.addListener(() {
      _flip();
    });
  }

  void updateCardHolder(val) {
    setState(() => _cardHolder = val);
  }

  void updateCardNumber(val) {
    setState(() {
      _cardNumber = val;
      _cardType = getCardType(_cardNumber!);
      _cvv = "";
    });
    _cvvController.clear();
  }

  void updateCvv(val) {
    setState(() => _cvv = val);
  }

  String formatField(String input) {
    String? mask = _cardType == "amex" ? _amexCardMask : _otherCardMask;
    var inputIndex = 0;
    var result = '';
    String stringWithoutSpaces = input.replaceAll(' ', '');

    for (var i = 0; i < mask.length; i++) {
      if (inputIndex >= stringWithoutSpaces.length) {
        break;
      }
      if (mask[i] == " ") {
        result += " ";
      } else if (mask[i] == "#") {
        result += stringWithoutSpaces[inputIndex];
        inputIndex++;
      }
    }
    return result;
  }

  String formatCard(String input) {
    String? mask = _cardType == "amex" ? _amexCardMask : _otherCardMask;
    var result = '';
    int inputIndex = 0;
    String stringWithoutSpaces = input.replaceAll(' ', '');

    for (var i = 0; i < mask.length; i++) {
      if (mask[i] == " ") {
        result += " ";
      } else if (mask[i] == '#' && inputIndex < stringWithoutSpaces.length) {
        result += stringWithoutSpaces[inputIndex];
        inputIndex++;
      } else {
        result += mask[i];
      }
    }
    return result;
  }

  String getCardType(String cardNumber) {
    RegExp re;

    re = RegExp("^4");
    if (re.hasMatch(cardNumber)) return "visa";

    re = RegExp("^(34|37)");
    if (re.hasMatch(cardNumber)) return "amex";

    re = RegExp("^5[1-5]");
    if (re.hasMatch(cardNumber)) return "mastercard";

    re = RegExp("^6011");
    if (re.hasMatch(cardNumber)) return "discover";

    re = RegExp('^9792');
    if (re.hasMatch(cardNumber)) return 'troy';

    return "visa";
  }

  Widget cardNumberField() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Card Number",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: SizedBox(
              width: 500,
              child: TextFormField(
                controller: _cardNumberController,
                onChanged: (value) => updateCardNumber(value),
                maxLength: 19,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '',
                    counterText: ""),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardHolderField() {
    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 25, bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Card Holder",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: SizedBox(
              width: 500,
              child: TextFormField(
                onChanged: (value) => updateCardHolder(value),
                keyboardType: TextInputType.name,
                maxLength: 20,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter(RegExp(r'[a-öA-Ö ]'), allow: true)
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget monthDropDown() {
    return LayoutBuilder(builder: (context, constraints) {
      double maxWidth = MediaQuery.of(context).size.width < 500 ? 100 : 150;
      return SizedBox(
        width: maxWidth,
        child: DropdownButtonFormField(
            hint: const Text("Month"),
            value: _selectedMonth,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: _months
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                _selectedMonth = val;
              });
            }),
      );
    });
  }

  Widget yearDropDown() {
    return LayoutBuilder(builder: (context, constraints) {
      double maxWidth = MediaQuery.of(context).size.width < 500 ? 100 : 150;
      return SizedBox(
          width: maxWidth,
          child: DropdownButtonFormField(
              hint: const Text("Year"),
              value: _selectedYear,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: _years
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedYear = val;
                });
              }));
    });
  }

  Widget additionalInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 25, bottom: 25),
      child: Row(
        children: [
          dropDownColumn(),
          cvvColumn(),
        ],
      ),
    );
  }

  Padding cvvColumn() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CVV",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: LayoutBuilder(builder: (context, constraints) {
              double maxWidth =
                  MediaQuery.of(context).size.width < 550 ? 90 : 150;
              return SizedBox(
                width: maxWidth,
                child: TextFormField(
                  focusNode: _nodeCvv,
                  controller: _cvvController,
                  onChanged: (value) => updateCvv(value),
                  maxLength: _cardType == "amex" ? 4 : 3,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), counterText: ""),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Column dropDownColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Expiration date",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: monthDropDown(),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: yearDropDown(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget submitButton() {
    return Padding(
        padding: const EdgeInsets.only(right: 25, bottom: 25, left: 25),
        child: ElevatedButton(
          onPressed: () {},
          style: const ButtonStyle(
            fixedSize: MaterialStatePropertyAll(Size(500, 50)),
            backgroundColor: MaterialStatePropertyAll(Color(0xFF2364d2)),
            elevation: MaterialStatePropertyAll(10),
            shadowColor:
                MaterialStatePropertyAll(Color.fromRGBO(90, 116, 148, 0.4)),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ));
  }

  Widget card() {
    bool isBack = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: _flip,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: angle),
          duration: const Duration(seconds: 1),
          builder: (BuildContext context, double val, __) {
            if (val >= pi / 2) {
              isBack = false;
            } else {
              isBack = true;
            }
            return (Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(val),
              child: isBack
                  ? cardFrontSide()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: cardBackside()),
            ));
          },
        ),
      ),
    );
  }

  Stack cardBackside() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            "assets/images/13.jpeg",
            width: 430,
            height: 270,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 25,
          child: Container(
            width: 430,
            height: 45,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
          ),
        ),
        cvvWidgetCardBackSide(),
        Positioned(
          bottom: 30,
          right: 20,
          child: Image.asset(
            "assets/images/$_cardType.png",
            width: 85,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Positioned cvvWidgetCardBackSide() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 25, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "CVV",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              width: 400,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    "$_cvv",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack cardFrontSide() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            "assets/images/13.jpeg",
            width: 430,
            height: 270,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 25,
          left: 25,
          child: Image.asset(
            "assets/images/chip.png",
            width: 60,
          ),
        ),
        Positioned(
          top: 25,
          right: 25,
          child: Image.asset(
            "assets/images/$_cardType.png",
            width: 85,
          ),
        ),
        cardNumberWidget(),
        nameWidgetCard(),
        expiresWidgetCard(),
      ],
    );
  }

  Positioned cardNumberWidget() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 346, maxHeight: 27),
            child: Text(
              formatCard(_cardNumber!),
              style: const TextStyle(color: Colors.white, fontSize: 27),
            ),
          ),
        ),
      ),
    );
  }

  Positioned nameWidgetCard() {
    return Positioned(
      bottom: 25,
      left: 25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Card Holder",
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 285),
            child: Text(_cardHolder ?? "FULL NAME",
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Positioned expiresWidgetCard() {
    return Positioned(
      bottom: 25,
      right: 25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Expires",
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          Text(
            "${_selectedMonth ?? "MM"}/${_selectedYear?.substring(2) ?? "YY"}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget infoBox() {
    return Container(
      width: 570,
      height: 415,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 30),
            blurRadius: 60,
            spreadRadius: 0,
            color: Color.fromRGBO(90, 116, 148, 0.4),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cardNumberField(),
          cardHolderField(),
          additionalInfoRow(),
          submitButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: const Color(0xffddeefc),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  card(),
                  infoBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
