import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resources',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ResourcesPage(),
    );
  }
}

class ResourcesPage extends StatefulWidget {
  ResourcesPage({Key key}) : super(key: key);

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  @override
  Widget build(BuildContext context) {
    int page = 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.amber,
        leading: Container(
          margin: const EdgeInsets.all(10.0),
        ),
        title: Text(
          'Resources Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Center(
                child: Text(
                  'Purdue Safety Resources',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  InkWell(
                    child: Row(
                      children: [
                        Text(
                          '\nPurdue University Police Department',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    onTap: () => launch('https://www.purdue.edu/police/'),
                  ),
                  SizedBox(height: 5.0),
                  InkWell(
                    child: Row(
                      children: [
                        //SizedBox(width: 20.0),
                        TextButton(
                          onPressed: () => launch('tel:${'765-494-8221'}'),
                          child: Text(
                            '765-494-8221',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () => launch('tel:${'765-494-8221'}'),
                  ),
                ],
              ),
            ),

            // Text(
            //   'Purdue Safety Resources:',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(height: 10.0),
            // InkWell(
            //   child: Row(
            //     children: [
            //       Text(
            //         '\nPurdue University Police Department',
            //         style: TextStyle(
            //           color: Colors.blue,
            //           fontSize: 16.0,
            //         ),
            //       ),
            //       Spacer(),
            //     ],
            //   ),
            //   onTap: () => launch('https://www.purdue.edu/police/'),
            // ),
            // SizedBox(height: 5.0),
            // InkWell(
            //   child: Row(
            //     children: [
            //       //SizedBox(width: 20.0),
            //       TextButton(
            //         onPressed: () => launch('tel:${'765-494-8221'}'),
            //         child: Text(
            //           '765-494-8221',
            //           style: TextStyle(
            //             color: Colors.blue,
            //             fontSize: 16.0,
            //             decoration: TextDecoration.underline,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            //   onTap: () => launch('tel:${'765-494-8221'}'),
            // ),
            SizedBox(height: 10.0),
            // InkWell(
            //   child: Row(
            //     children: [
            //       Text(
            //         'Counseling and Psychological Services',
            //         style: TextStyle(
            //           color: Colors.blue,
            //           fontSize: 16.0,
            //         ),
            //       ),
            //       Spacer(),
            //     ],
            //   ),
            //   onTap: () => launch('https://www.purdue.edu/caps/index.html'),
            // ),
            // SizedBox(height: 5.0),
            // InkWell(
            //   child: Row(
            //     children: [
            //       //SizedBox(width: 20.0),
            //       TextButton(
            //         onPressed: () => launch('tel:${'765-494-6995'}'),
            //         child: Text(
            //           '765-494-6995',
            //           style: TextStyle(
            //             color: Colors.blue,
            //             fontSize: 16.0,
            //             decoration: TextDecoration.underline,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            //   onTap: () => launch('tel:${'765-494-6995'}'),
            // ),
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  InkWell(
                    child: Row(
                      children: [
                        Text(
                          '\nCounseling and Psychological Services',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    onTap: () =>
                        launch('https://www.purdue.edu/caps/index.html'),
                  ),
                  SizedBox(height: 5.0),
                  InkWell(
                    child: Row(
                      children: [
                        //SizedBox(width: 20.0),
                        TextButton(
                          onPressed: () => launch('tel:${'765-494-6995'}'),
                          child: Text(
                            '765-494-6995',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () => launch('tel:${'765-494-6995'}'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            InkWell(
              child: Row(
                children: [
                  Text(
                    'Title IX Office',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              onTap: () => launch(
                  'https://www.purdue.edu/titleix/what-is-title-ix/index.html'),
            ),
            SizedBox(height: 5.0),
            InkWell(
              child: Row(
                children: [
                  //SizedBox(width: 20.0),
                  TextButton(
                    onPressed: () => launch('tel:${'765-494-7255'}'),
                    child: Text(
                      '765-494-7255',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () => launch('tel:${'765-494-7255'}'),
            ),
          ],
        ),
      ),
    );
  }
}
