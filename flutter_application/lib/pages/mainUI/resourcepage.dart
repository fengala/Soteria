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
          'Additional Resources',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 20),
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
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () =>
                            launch('https://www.purdue.edu/police/'),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Purdue University Police Department',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
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
                ),
              ),
              SizedBox(height: 10.0),




              Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () =>
                            launch('https://www.purdue.edu/caps/index.html'),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Counseling and Psychological Services',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
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
                ),
              ),
            SizedBox(height: 10.0),

////////////////////////


              Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () =>
                            launch('https://www.purdue.edu/titleix/what-is-title-ix/index.html'),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Title IX Office',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
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
                ),
              ),
              SizedBox(height: 10.0),

///////////////////////////

//////////////////////////

              Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () =>
                            launch('https://www.rainn.org/about-national-sexual-assault-telephone-hotline'),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '\nNational Sexual Assault Helpline',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      TextButton(
                        onPressed: () => launch('tel:${'800-656-4673'}'),
                        child: Text(
                          '800-656-4673',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),
//////////////////////////

              Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () =>
                            launch('https://988lifeline.org/'),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '\nNational Suicide Prevention Lifeline',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      TextButton(
                        onPressed: () => launch('tel:${'988'}'),
                        child: Text(
                          '800-656-4673',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),

/////////////////////////


              Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () =>
                            launch('https://www.samhsa.gov/find-help/national-helpline'),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '\nNational Mental Health Helpline',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      TextButton(
                        onPressed: () => launch('tel:${'1-800-662-4357'}'),
                        child: Text(
                          '1-800-662-4357',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),

 ////////////////////////

          ],
        ),
      ),
      ),
    );
  }
}
