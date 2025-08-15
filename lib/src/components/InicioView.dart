
import 'package:flutter/material.dart';
import 'CardBase.dart';


class InicioView extends StatefulWidget{
  const InicioView({super.key});

  @override
  _InicioViewState createState ()=> _InicioViewState();

}

class _InicioViewState extends State<InicioView>{

  @override
  Widget build(BuildContext context){
    return Container(
      //color: Colors.green,
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start ,
        children: [

            Container(
                alignment: Alignment.topLeft,
                //color: Colors.yellow,
                child:Text(
                  "Articulos Populares",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                )
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  CardBase(),
                ],
              )

            ),)



           ]
         )
    );

  }
}