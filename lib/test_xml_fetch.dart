import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class FetchXMLTest extends StatefulWidget {
  const FetchXMLTest({Key? key}) : super(key: key);

  @override
  State<FetchXMLTest> createState() => _FetchXMLTestState();
}

class _FetchXMLTestState extends State<FetchXMLTest> {
  // String data = '';
  List<MapEntry<dynamic, dynamic>> entries = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        'Key : ${entries[i].key}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Value : ${entries[i].value}',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )));
  }

  loadData() async {
    const String url =
        'https://telugustop.com/geo-content/feed-data/telugu/app_config_posts.xml';

    await http.get(Uri.parse(url)).then((value) {
      final xmlDoc = xml.XmlDocument.parse(value.body);
      final rssNode = xmlDoc.findElements('rss');
      final channelNode = rssNode.first.findElements('channel');
      final items = channelNode.first.findElements('item').last;
      final content = items.findElements('content:encoded').first.text;
      entries = convertToMap(content).entries.toList();
      // data = entries.length.toString();
    });
    setState(() {});
  }

  Map convertToMap(String data) {
    Map keyValueData = {};
    data = data.replaceAll(".</p>", "");
    data = data.replaceAll("<p>", "");
    data = data.replaceAll("</p>", "");
    data = data.replaceAll("@@@", ".");
    data = data.replaceAll("\$\$\$\$\$\$", "=");
    data = data.replaceAll("#038;", "");
    data = data.replaceAll("#x1f534;", "");
    List<String> mainEntries = data.split("#");

    for (var element in mainEntries) {
      String subEntry = element;
      List<String> tokens = subEntry.split("=");
      String key = "";
      String value = "";
      if (tokens.isNotEmpty) {
        key = tokens[0];
      }
      if (tokens.length > 1) {
        value = tokens[1];
      }
      keyValueData[key.trim().toLowerCase()] = value;
    }
    return keyValueData;
  }
}
