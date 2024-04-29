// import 'package:flutter/material.dart';

// class EventPostCard extends StatefulWidget {
//   final String postId;
//   final List<String> likes;
//   final String communityName;
//   final String venue;
//   final String moderatorId;
//   final String date;
//   final String moderatorName;
//   final String otherDetails;
//   final String eventTitle;
//   final String imageURL;
//   final String dpURL;

//   EventPostCard({
//     required this.venue,
//     required this.moderatorId,
//     required this.moderatorName,
//     required this.otherDetails,
//     required this.eventTitle,
//     required this.imageURL,
//     required this.dpURL,
//     required this.postId,
//     required this.likes,
//     required this.date,
//     required this.communityName,
//   });

//   @override
//   State<EventPostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<EventPostCard> {
//   bool isLoved = false;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(10.0),
//       elevation: 5.0,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundImage: NetworkImage(widget.dpURL),
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.eventTitle,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           '${widget.date}',
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 // PopupMenuButton(
//                 //   itemBuilder: (_) => [
//                 //     PopupMenuItem(
//                 //       child: Text('Option 1'),
//                 //       value: 'option1',
//                 //     ),
//                 //     PopupMenuItem(
//                 //       child: Text('Option 2'),
//                 //       value: 'option2',
//                 //     ),
//                 //     PopupMenuItem(
//                 //       child: Text('Option 3'),
//                 //       value: 'option3',
//                 //     ),
//                 //   ],
//                 // ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Text(
//               widget.otherDetails,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: widget.imageURL!.isNotEmpty
//                 ? Image.network(
//                     widget.imageURL,
//                     fit: BoxFit.cover,
//                   )
//                 : Container(),
//           ),
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Text(widget.otherDetails),
//           ),
//           ButtonBar(
//             alignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     isLoved = !isLoved;
//                   });
//                 },
//                 icon: Stack(
//                   children: [
//                     Icon(
//                       Icons.favorite_border,
//                       color: isLoved ? Colors.red : Colors.black,
//                     ),
//                     Positioned.fill(
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Icon(
//                           Icons.favorite,
//                           color: isLoved ? Colors.red : Colors.transparent,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: () {},
//               ),
//               IconButton(
//                 icon: Icon(Icons.bookmark_border),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';

// class EventPostCard extends StatefulWidget {
//   final String postId;
//   final List<String> likes;
//   final String communityName;
//   final String venue;
//   final String moderatorId;
//   final String date;
//   final String moderatorName;
//   final String otherDetails;
//   final String eventTitle;
//   final String imageURL;
//   final String dpURL;

//   EventPostCard({
//     required this.venue,
//     required this.moderatorId,
//     required this.moderatorName,
//     required this.otherDetails,
//     required this.eventTitle,
//     required this.imageURL,
//     required this.dpURL,
//     required this.postId,
//     required this.likes,
//     required this.date,
//     required this.communityName,
//   });

//   @override
//   State<EventPostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<EventPostCard> {
//   bool isLoved = false;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(10.0),
//       elevation: 5.0,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundImage: NetworkImage(widget.dpURL),
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.communityName, // Changed
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           '${widget.moderatorName}', // Changed
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Event     :    ${widget.eventTitle}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4),
//                  Text(
//                   'Date      :    ${widget.date}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4),
//                  Text(
//                   'Venue   :     ${widget.venue}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4),
                
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: widget.imageURL.isNotEmpty
//                 ? Image.network(
//                     widget.imageURL,
//                     fit: BoxFit.cover,
//                   )
//                 : Container(),
//           ),
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Text(widget.otherDetails),
//           ),
                        
//               Row(
//               mainAxisAlignment: MainAxisAlignment.start, // Align to the left
//               children: [
//                 SizedBox(
//                   height: 40, // Set the desired height
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.green,
//                         width: 2.0,
//                       ),
//                       borderRadius: BorderRadius.circular(10.0), // Reduce the curve size
//                     ),
//                     // Add horizontal padding
//                     child: TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Enroll",
//                         style: TextStyle(
//                           color: Colors.green,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
           
//           ButtonBar(
//             alignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     isLoved = !isLoved;
//                   });
//                 },
//                 icon: Stack(
//                   children: [
//                     Icon(
//                       Icons.favorite_border,
//                       color: isLoved ? Colors.red : Colors.black,
//                     ),
//                     Positioned.fill(
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Icon(
//                           Icons.favorite,
//                           color: isLoved ? Colors.red : Colors.transparent,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: () {},
//               ),
//               IconButton(
//                 icon: Icon(Icons.bookmark_border),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
