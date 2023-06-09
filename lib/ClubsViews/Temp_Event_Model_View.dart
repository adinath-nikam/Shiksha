import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';

enum ConfirmAction { CANCEL, ACCEPT }

final GlobalKey<ScaffoldState> _eventSK = new GlobalKey<ScaffoldState>();

class Event extends StatefulWidget {
 late String id;
 late String branch;
  late int currentAvailable;
  late String date;
  late String description;
  late String eventName;
  late String extraInfo;
  late String imageUrl;
  late Timestamp postedOn;
  late String semester;
  late String timings;
  late int totalSeats;
  late String venue;
  late String whatToBring;
  late int registered;
  late DocumentReference reference;

  Event();

  Event.fromData(
      this.id,
      this.branch,
      this.currentAvailable,
      this.date,
      this.description,
      this.eventName,
      this.extraInfo,
      this.imageUrl,
      this.postedOn,
      this.semester,
      this.timings,
      this.totalSeats,
      this.venue,
      this.whatToBring,
      this.registered,
      );

  Event.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['branch'] != null),
        assert(map['currentAvailable'] != null),
        assert(map['date'] != null),
        assert(map['description'] != null),
        assert(map['eventName'] != null),
        assert(map['extraInfo'] != null),
        assert(map['imageUrl'] != null),
        assert(map['postedOn'] != null),
        assert(map['semester'] != null),
        assert(map['timings'] != null),
        assert(map['totalSeats'] != null),
        assert(map['venue'] != null),
        assert(map['what_to_bring'] != null),
        branch = map['branch'],
        currentAvailable = map['currentAvailable'].toInt(),
        date = map['date'],
        description = map['description'],
        eventName = map['eventName'],
        extraInfo = map['extraInfo'],
        imageUrl = map['imageUrl'],
        postedOn = map['postedOn'],
        semester = map['semester'],
        timings = map['timings'],
        totalSeats = int.parse(map['totalSeats'].toString()),
        venue = map['venue'],
        whatToBring = map['what_to_bring'],
        id = reference.id;

 Event.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(
   snapshot.data() as Map<String, dynamic>,
   reference: snapshot.reference,
 );


 @override
  State<StatefulWidget> createState() {
    return EventState();
  }
}


class EventState extends State<Event> {
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("events")
        .doc(widget.id)
        .collection("participants")
        .get()
        .then((docs) {
      widget.registered = docs.docs.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _eventSK,
      backgroundColor: Theme.of(context).primaryColor,
      // appBar: AppBar(
      //   title: Text(widget.eventName),
      //   elevation: 0,
      //   actions: canEdit
      //       ? <Widget>[
      //     PopupMenuButton(
      //       onSelected: (ActionButton result) {
      //         setState(() {
      //           if (result == ActionButton.edit) {
      //             _doEdit();
      //           } else {
      //             _doDelete();
      //           }
      //         });
      //       },
      //       itemBuilder: (BuildContext context) =>
      //       <PopupMenuEntry<ActionButton>>[
      //         const PopupMenuItem<ActionButton>(
      //           value: ActionButton.edit,
      //           child: Text('Edit'),
      //         ),
      //         const PopupMenuItem<ActionButton>(
      //           value: ActionButton.delete,
      //           child: Text('Delete'),
      //         ),
      //       ],
      //     )
      //   ]
      //       : null,
      // ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Hero(
                              tag: widget.eventName + widget.date,
                              child: Image(
                                fit: BoxFit.fitWidth,
                                image: CachedNetworkImageProvider(
                                  widget.imageUrl,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    widget.eventName,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          widget.date,
                                        ),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                                _getExpandable(
                                    "Description", widget.description),
                                _getLine(),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Seats",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        SizedBox(
                                          width: 65,
                                        ),
                                        getPill(
                                            widget.currentAvailable.toString(),
                                            Color.fromRGBO(15, 157, 88, 0.3)),
                                        Text(
                                          ' / ',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        getPill(
                                          widget.totalSeats.toString(),
                                          Color.fromRGBO(66, 133, 244, 0.3),
                                        ),
                                      ],
                                    )),
                                _getLine(),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Timing",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        getPill(
                                          widget.timings,
                                          Color.fromRGBO(244, 160, 0, 0.3),
                                        ),
                                      ],
                                    )),
                                _getLine(),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: <Widget>[
                                      getTextLabelAndValue(
                                        "Venue",
                                        widget.venue,
                                      ),
                                      getTextLabelAndValue(
                                        "Branch",
                                        widget.branch,
                                      ),
                                      getTextLabelAndValue(
                                        "Semester",
                                        widget.semester,
                                      ),
                                    ],
                                  ),
                                ),
                                _getExpandable(
                                  "What to Bring",
                                  widget.whatToBring,
                                ),
                                _getExpandable(
                                  "Extra",
                                  widget.extraInfo,
                                ),
                                SizedBox(
                                  height: 70,
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
            ),
          ),
        ],
      ),
      floatingActionButton: _getFloatingButton(),
    );
  }

  FloatingActionButton _getFloatingButton() {
    if (widget.currentAvailable > 0) {
      return FloatingActionButton(
        child: Icon(
          Icons.stop,
        ),
        onPressed: () {

        },
      );
    } else {
      return FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
        },
      );
    }
  }

  Widget getPill(String text, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
        ),
      ),
    );
  }

  Widget getTextLabelAndValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Text(
            label + ": ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _getExpandable(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ExpandablePanel(
        header: Text(title),
        collapsed: Text(
          text,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[500]),
        ),
        expanded: Text(
          text,
          softWrap: true,
        ),
        theme: ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center),
      ),
    );
  }

  Widget _getLine() {
    return Container(
      color: Colors.grey[300],
      width: MediaQuery.of(context).size.width,
      height: 1,
    );
  }
}