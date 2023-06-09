import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import '../Components/CommonComponentWidgets.dart';
import '../colors/colors.dart';
import 'Temp_Event_Model_View.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .orderBy('postedOn', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    // snapshot.sort((a, b) => b.data()["postedOn"].compareTo(a.data()["postedOn"]));
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final event = Event.fromSnapshot(data);
    return Padding(
        key: ValueKey(event.eventName),
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
        child: GestureDetector(
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            Event e = Event.fromData(
                event.id,
                event.branch,
                event.currentAvailable,
                event.date,
                event.description,
                event.eventName,
                event.extraInfo,
                event.imageUrl,
                event.postedOn,
                event.semester,
                event.timings,
                event.totalSeats,
                event.venue,
                event.whatToBring,
                event.totalSeats - event.currentAvailable);
            return e;
          })),
          child: Card(
            elevation: 2,
            color: Colors.grey[50],
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3),
                        topRight: Radius.circular(3)),
                    // borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Container(
                      height: 150.0,
                      width: MediaQuery.of(context).size.width - 32,
                      child: Hero(
                        tag: event.eventName + event.date,
                        child: CachedNetworkImage(
                          imageUrl: event.imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.only(top: 148.0),
                            child: LinearProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          event.eventName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(event.date)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
