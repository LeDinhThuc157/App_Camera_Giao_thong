
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontrolpanel/changeNotifier.dart';
import 'package:fluttercontrolpanel/components/add_cam.dart';
import 'package:fluttercontrolpanel/components/side_menu.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';



class ListCamera extends StatelessWidget {

  final Stream<QuerySnapshot> cam =
  FirebaseFirestore.instance.collection('cameraIp').snapshots();

  void check_cam() async{
    // const url = 'http://27.72.149.120:1880////fgfhfgsn';
    // try {
    //   await canLaunch(url) ?
    //   await launch(url):
    //   throw 'Error';
    // } catch(e){
    //
    // }
    bool check = false;
    try{

      const url = 'http://27.72.149.120:1880/';
      if (await canLaunch(url)) {
        await launch(url);
        check = true;
      } else {
        throw 'Could not launch $url';
      }
      print(check);
    }

    catch(e){
      //debug e
    }

  }

  _show(){
    return StreamBuilder<QuerySnapshot>(
        stream: cam,
        builder: (
            context,
            AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
          if (snapshot.hasError) {
            return Text('Something went wrong.');
          }
          return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String,
                    dynamic>;
                //print(document.id);
                return ListTile(
                  title: Text('${data['namecam']}'),
                  trailing: PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    itemBuilder: (context) =>[
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.video_call_sharp),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Xem camera")
                          ],
                        ),
                        onTap: () {
                          check_cam();
                          //launch('${data['Ipcamera']}');
                        },
                      ),
                      PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.delete_forever),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Xóa camera")
                            ],
                          ),
                          onTap: (){

                            CollectionReference camdl = FirebaseFirestore.instance.collection('cameraIp');
                            camdl.doc(document.id).delete();
                          }

                      ),
                    ],
                  ),
                );
              }
              )
                  .toList()
          );
        }
    );

  }

  //CollectionReference cam = FirebaseFirestore.instance.collection('cameraIp');

  @override
  Widget build(BuildContext context) {
    final width_screen = MediaQuery
        .of(context)
        .size
        .width;
    final height_screen = MediaQuery
        .of(context)
        .size
        .height;

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: Colors.grey[300],
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
    return Column(
      children: [
        SizedBox(
          height: height_screen / 400,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                    //Add_camera(),
                    SideMenu(currentIndex: 1, currentIndex_listcamera: 1,),
                    opaque: false,
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              },
              child: Text('Add Camera'),
            ),
            SizedBox(
              width: width_screen / 200,
            ),
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        SideMenu(currentIndex: 1, currentIndex_listcamera: 1,),
                    opaque: false,
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              },
              child: Text('Remove Camera'),
            ),
          ],
        ),
        // Consumer<Counter>(
        //   builder: (context, counter, child) {
        //     return GridView.count(
        //       crossAxisCount: 5,
        //       crossAxisSpacing: 10.0,
        //       mainAxisSpacing: 10.0,
        //       shrinkWrap: true,
        //       children: List.generate(
        //         counter.count,
        //             (index) {
        //           return Padding(
        //             padding: const EdgeInsets.all(10.0),
        //             child: Container(
        //               alignment: Alignment.center,
        //               child: Text("phuc"),
        //               decoration: BoxDecoration(
        //                 color: Colors.red,
        //                 borderRadius: BorderRadius.all(
        //                   Radius.circular(20.0),
        //                 ),
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        //     );
        //   },
        // )
        Center(
          child: _show(),
        ),


      ],
    );


  }


  _showcam() {
    final String documentId;


    CollectionReference cam = FirebaseFirestore.instance.collection('cameraIp');
    return FutureBuilder<DocumentSnapshot>
      (
      future: cam.doc().get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {

          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          print('${data['namecam']}');
          //final files = snapshot.data!.hashCode;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,

            itemCount: 3,
            itemBuilder: (context, index){
              return ListTile(
                title: Text('${data['namecam']}'),
                trailing: PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) =>[
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.video_call_sharp),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Xem camera")
                        ],
                      ),
                      onTap: () {
                        launch('${data['Ipcamera']}');

                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete_forever),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Xóa camera")
                        ],
                      ),
                      onTap: (){
                        cam.doc('bWdrrCFA1W0DJgMpIUsh').delete();
                      },


                    ),
                  ],
                ),
              );
            },

          );
        }
        return Text("loading");
      },

    );

  }
  _showcam2(){
    Future<ListResult>? futureFiles;
    @override
    void initState() {
      //super.initState();
      futureFiles = FirebaseStorage.instance.ref('cameraIp').listAll();
      //futureFiles = Firebase.initializeApp.ref('/file').listAll();
    }

    return FutureBuilder<ListResult>(
      future: futureFiles,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final files = snapshot.data!.items;
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              print('day la ${file.name}');


              return ListTile(
                title: Text('${file.name}'),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.video_call_sharp,
                    color: Colors.black,
                  ),
                  onPressed: () {

                  },
                ),
              );
            },

          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error occurred'),);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

}
class Getname extends StatelessWidget {
  final String documentId;
  Getname(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference cam = FirebaseFirestore.instance.collection('cameraIp');
    return FutureBuilder<DocumentSnapshot>
      (
      future: cam.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {

          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          print('${data['namecam']}');
          //final files = snapshot.data!.hashCode;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,

            itemCount: 3,
            itemBuilder: (context, index){
              return ListTile(
                title: Text('${data['namecam']}'),
                trailing: PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) =>[
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.video_call_sharp),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Xem camera")
                        ],
                      ),
                      onTap: () {
                        launch('${data['Ipcamera']}');

                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete_forever),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Xóa camera")
                        ],
                      ),
                      onTap: (){
                        cam.doc(documentId).delete();
                      },


                    ),
                  ],
                ),
              );
            },

          );
        }
        return Text("loading");
      },

    );
  }
}
