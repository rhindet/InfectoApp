



import 'package:flutter/cupertino.dart';

class TableVacunacion extends StatefulWidget {

  const TableVacunacion({super.key});

  @override
  _TableVacunacionState createState() => _TableVacunacionState();
}

class _TableVacunacionState extends State<TableVacunacion> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Esquema Nacional de Vacunación',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Image(
            image: AssetImage('assets/vacunacion.png'),
            width: 500,
            height: 500,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

}