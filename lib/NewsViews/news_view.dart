import 'package:flutter/material.dart';

import '../colors/colors.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: PageView(
        scrollDirection: Axis.vertical,
        controller: _controller,
        children: const [
          NewsContent(),
          NewsContent(),
        ],
      )),
    );
  }
}

class NewsContent extends StatelessWidget {
  const NewsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Image(
            fit: BoxFit.fitWidth,
            height: 250,
            image: NetworkImage(
                "https://phantom-marca.unidadeditorial.es/61cf03eb96627c498490b67ba1f0554a/resize/1320/f/jpg/assets/multimedia/imagenes/2021/08/11/16287009162794.jpg"),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Text(
            "Lucifer",
            style: TextStyle(
                fontFamily: "ProductSans-Bold",
                color: primaryDarkColor,
                fontSize: 22),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text(
            "15 Aug, 2021 - 3:05 PM",
            style: TextStyle(
                fontFamily: "ProductSans-Regular",
                color: primaryDarkColor.withOpacity(0.5),
                fontSize: 12),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text(
            "he Taliban have taken control of the presidential palace in Kabul after former President Ashraf Ghani fled the country."
            "\nThe US defense secretary approved 1,000 more US troops into Afghanistan due to the deteriorating security situation, a defense official tells CNN, for a total of 6,000 US troops that will be in the country soon.\nEarlier today, the US completed the evacuation of its embassy in Afghanistan and took down the American flag at the diplomatic compound.",
            style: TextStyle(
                fontFamily: "ProductSans-Regular",
                color: primaryDarkColor,
                fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text(
            "",
            style: TextStyle(
                fontFamily: "ProductSans-Regular",
                color: primaryDarkColor,
                fontSize: 14),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: chip("VERIFIED", Colors.green))
      ],
    );
  }

  Widget chip(String label, Color color) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      avatar: CircleAvatar(
        radius: 15,
        backgroundColor: primaryWhiteColor,
        child: const Icon(
          Icons.verified_user,
          size: 20,
        ),
      ),
      label: Text(
        label,
        style: const TextStyle(
            fontFamily: "ProductSans-Bold", color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      elevation: 0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(5.0),
    );
  }
}
