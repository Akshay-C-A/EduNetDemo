class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedButton = 'Details';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/ban1.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, .2],
                ),
              ),
            ),
            Container(
              height: height,
              child: Column(
                children: [
                  SizedBox(height: height * .15),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(width * .08, 0, width * .08, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: crossa,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.asset('assets/ban1.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(width: width * .05),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(
                                    'Andrew Huberman',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text('A Psychiatrist'),
                            ],
                          ),
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * .08, width * 0.03, width * .08, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: width * 0.08),
                        Column(
                          children: [
                            Text(
                              'Contact :',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 30,
                                ),
                                Icon(
                                  Icons.email,
                                  size: 30,
                                ),
                                Icon(
                                  Icons.location_on,
                                  size: 30,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: width * 0.08),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedButton = 'Details';
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: _selectedButton == 'Details'
                                    ? Colors.blue
                                    : Colors.black,
                                textStyle: TextStyle(
                                  decoration: _selectedButton == 'Details'
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                  decorationThickness: 2.0,
                                ),
                              ),
                              child: Text('Details'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedButton = 'Posts';
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: _selectedButton == 'Posts'
                                    ? Colors.blue
                                    : Colors.black,
                                textStyle: TextStyle(
                                  decoration: _selectedButton == 'Posts'
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                  decorationThickness: 2.0,
                                ),
                              ),
                              child: Text('Posts'),
                            ),
                          ],
                        ),
                        if (_selectedButton == 'Details')
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Details content'),
                          )
                        else
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Posts content'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

