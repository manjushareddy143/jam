import 'package:flutter/material.dart';
import 'package:jam/login/signup.dart';
class serviceProviderSignup extends StatelessWidget{
  Widget build(BuildContext context) {
    return Center(child: serviceProviderSignupUIPage());
  }
}
class serviceProviderSignupUIPage extends StatefulWidget {

  @override
  _serviceProviderUIPageState createState() => _serviceProviderUIPageState();
}
class _serviceProviderUIPageState extends State<serviceProviderSignupUIPage> with TickerProviderStateMixin{
TabController _tabController;
List<Tab> tabList = List();
  @override
  void initState() {
    // TODO: implement initState
   // tabList.add(new Tab(icon: Icon(Icons.person), text: "FOR INDIVIDUAL",),);
    //tabList.add(new Tab(icon: Icon(Icons.people), text: "FOR ORGANISATION",),);
   _tabController = new TabController(vsync: this, length:2);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
   _tabController.dispose();
    super.dispose();
  }






  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Image.asset("assets/images/jamLogo.png",
                  height: 40.0, width: 95.0 , fit: BoxFit.fill, ),
                Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,10),
                  child: new Text(

                    "SERVICE PROVIDER SIGN-UP",
                    textAlign: TextAlign.center,

                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0,),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0),
                  child: Container(height:70,decoration: BoxDecoration(border: Border.all(color: Colors.teal, width: 1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.teal,
                      labelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(color: Colors.teal, borderRadius:BorderRadius.only(topRight: Radius.circular(10), 
                      topLeft: Radius.circular(10))),

                      tabs:  <Widget>[
                        Tab(icon: Icon(Icons.person), text: "FOR INDIVIDUAL"),
                        Tab(icon: Icon(Icons.group), text: "FOR ORGANISATION"),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10,10),
                  child: Container(height: 500,decoration: BoxDecoration(border: Border.all(color: Colors.teal, width: 1),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                    child: TabBarView(controller:_tabController,


                      children: <Widget>[
                        Signup(),
                        Workouts(),
                        ],),
                  ),
                ),]
          ),
        ),
      ),
      ),);
  }
Widget _getPage(Tab tab){
  switch(tab.text){
    case 'Individual': return OverView();
    case 'Organisation': return Workouts();
  }
}
Widget OverView(){
    return Text("Individual");
}
Widget Workouts(){
    return Text("organisation");
}

}