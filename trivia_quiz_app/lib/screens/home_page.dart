import 'dart:math';
import 'package:flutter/material.dart';

enum HeightUnit {
    feetAndInches,
    centimeters,
  }

enum WeightUnit{
  kilograms,
  stoneAndPounds,
}

HeightUnit selectedHeightUnit = HeightUnit.feetAndInches;
WeightUnit selectedWeightUnit = WeightUnit.kilograms;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final TextEditingController _centimeterController = TextEditingController();
  final TextEditingController _stoneController = TextEditingController();
  final TextEditingController _poundsController = TextEditingController();
  final TextEditingController _kilogramsController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();
  bool showResult = false;
  bool isCalculating = false;
  double computation = 0.0;
  double weight = 0.0;
  double height = 0.0;
  String equivalent = ""; 

  void _convertedWeight (WeightUnit newUnit){
    if (selectedWeightUnit == WeightUnit.stoneAndPounds && newUnit == WeightUnit.kilograms){
      double stone = double.tryParse(_stoneController.text) ?? 0;
      double pounds = double.tryParse(_poundsController.text) ?? 0;
      double convertedWeight = (stone * 14 + pounds) * 0.453592;

      setState(() {
      _kilogramsController.text = convertedWeight.toStringAsFixed(2);
    });
    }

    else if (selectedWeightUnit == WeightUnit.kilograms && newUnit == WeightUnit.stoneAndPounds) {
      double kilograms = double.tryParse(_kilogramsController.text) ?? 0;
      double convertedWeightPounds = kilograms * 2.20462;

      setState(() {
      _stoneController.text =  (convertedWeightPounds / 14).floor().toString();
      _poundsController.text = (convertedWeightPounds % 14).toStringAsFixed(2);
    });
      
    }
    selectedWeightUnit = newUnit;
  }

  void _convertedHeight(HeightUnit newUnit) {
    if(selectedHeightUnit == HeightUnit.feetAndInches && newUnit == HeightUnit.centimeters) {
    double feet = double.tryParse(_feetController.text) ?? 0;
    double inches = double.tryParse(_inchesController.text) ?? 0;
    double convertedHeight = (feet * 30.48) + (inches * 2.54);

    setState(() {
      _centimeterController.text = convertedHeight.toStringAsFixed(2);
    });
    }

    else if (selectedHeightUnit == HeightUnit.centimeters && newUnit == HeightUnit.feetAndInches) {
      double centimeters = double.tryParse(_centimeterController.text) ?? 0;
      double convertedHeightFeet = (centimeters * 0.0328084).floor().toDouble();
      double convertedHeightInches = ((centimeters * 0.0328084) - convertedHeightFeet) * 12;
      
      setState(() {
      _feetController.text = convertedHeightFeet.toString();
      _inchesController.text = convertedHeightInches.toStringAsFixed(2);
    });
    }
    selectedHeightUnit = newUnit;
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState ((){

    });
  }
  
  void calculateBMI(){
    setState(() {
      isCalculating = true;
      _resultController.text = "Calculating BMI...";
    });

    fetchData().then((_) {
      if(selectedWeightUnit == WeightUnit.kilograms) {
        weight = double.tryParse(_kilogramsController.text) ?? 0;
      }
      
      else if(selectedWeightUnit == WeightUnit.stoneAndPounds) {
        double stone = double.tryParse(_stoneController.text) ?? 0;
        double pounds = double.tryParse(_poundsController.text) ?? 0;
        weight = (stone * 14 + pounds) * 0.453592;
      }
    
      // Height Conversion to Meters
      if(selectedHeightUnit == HeightUnit.centimeters) {
        double centimeters = double.tryParse(_centimeterController.text) ?? 0;
        height = centimeters * .01;
      }
      else if(selectedHeightUnit == HeightUnit.feetAndInches) {
        double feet = double.tryParse(_feetController.text) ?? 0;
        double inches = double.tryParse(_inchesController.text) ?? 0;
        height = (feet*0.3048)+(inches*0.0254);
      }

      computation = weight / (pow(height, 2));

      if(computation < 18.4){
        equivalent = "UNDERWEIGHT";
      }
      else if(computation >= 18.5 && computation <= 24.9){
        equivalent = "NORMAL";
      }
      else if(computation >= 25 && computation <= 39.9){
        equivalent = "OVERWEIGHT";
      }
      else if(computation >= 40){
        equivalent = "OBESE";
      }
      
      setState(() {
        _resultController.text = "${computation.toStringAsFixed(2)} - $equivalent for a ${_ageController.text} yr old";
        isCalculating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
    appBar: AppBar(
      title: const Text('Adult BMI'),
      centerTitle: true,
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Text("Enter your details"),

        // Weight 
        Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              if(selectedWeightUnit == WeightUnit.stoneAndPounds)
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _stoneController,
                      // keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Stone",
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  Flexible(
                    child: TextField(
                      controller: _poundsController,
                      // keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Pounds",
                      ),
                    ),
                  ),
                ],
              ),
              
              if(selectedWeightUnit == WeightUnit.kilograms)
                TextField(
                  controller: _kilogramsController,
                  // keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Kilograms",
                  ),
                ),

                const SizedBox(height: 5),
                DropdownButton<WeightUnit>(
                  value: selectedWeightUnit,
                  onChanged: (newValue) {
                    setState(() {
                      // selectedWeightUnit = newValue!;
                      _convertedWeight(newValue!);
                    });
                  },
                  items: WeightUnit.values.map<DropdownMenuItem<WeightUnit>>((WeightUnit value) {
                    return DropdownMenuItem<WeightUnit>( 
                      value: value,
                      child: Text(value == WeightUnit.stoneAndPounds ? 'Stone & Pounds' : 'Kilograms'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        // Height
        Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              if(selectedHeightUnit == HeightUnit.feetAndInches)
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _feetController,
                      // keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Feet",
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  Flexible(
                    child: TextField(
                      controller: _inchesController,
                      // keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Inches",
                      ),
                    ),
                  ),
                ],
              ),
              
              if(selectedHeightUnit == HeightUnit.centimeters)
                TextField(
                  controller: _centimeterController,
                  // keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Centimeters",
                  ),
                ),

                const SizedBox(height: 5),
                DropdownButton<HeightUnit>(
                  value: selectedHeightUnit,
                  onChanged: (newValue) {
                    setState(() {
                      // selectedHeightUnit = newValue!;
                      _convertedHeight(newValue!);
                    });
                  },
                  items: HeightUnit.values.map<DropdownMenuItem<HeightUnit>>((HeightUnit value) {
                    return DropdownMenuItem<HeightUnit>( 
                      value: value,
                      child: Text(value == HeightUnit.feetAndInches ? 'Feet & Inches' : 'Centimeters'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        Container(
          padding: const EdgeInsets.all(5),
          child: TextField(
            controller: _ageController,
            // keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Input your age",
            ),
          
        ),
        ),

        Container(
          padding: const EdgeInsets.all(5),
          child: TextField(
            controller: _resultController,
            enabled: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Result",
            ),
          
        ),
        ),

        Flexible(
          child: ElevatedButton(
            onPressed: isCalculating ? null: (){
              calculateBMI();
              showResult = true;
            },
            child: const Text("Calculate"),
          ),
        ),

      ],
    )
  );
  }
}    