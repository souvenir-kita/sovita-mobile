import 'package:flutter/material.dart';

class PromoDetailScreen extends StatelessWidget {  
  const PromoDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.red, 
            height: MediaQuery.of(context).size.height * 0.5, 
            width: MediaQuery.of(context).size.width,
            child: Center(
              child : SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  onPressed: (){}, 
                  child: Text("OWA")
                  ),
              ),
            ),
            ),
          Container(
            color: Colors.blue,
            height: MediaQuery.of(context).size.height * 0.5,
            )
        ],
      ),
    );
  }
}