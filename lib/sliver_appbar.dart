import 'package:flutter/material.dart';

class SliverAppBarView extends StatelessWidget {
  const SliverAppBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: currentOrientation == Orientation.landscape
                    ? MediaQuery.of(context).size.width * 0.18
                    : MediaQuery.of(context).size.height * 0.25,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      bottom: currentOrientation == Orientation.landscape
                            ? MediaQuery.of(context).size.width * 0.08
                            : MediaQuery.of(context).size.height * 0.15,
                    ),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: CircleAvatar(
                        radius: 30,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  titlePadding: EdgeInsets.zero,
                  title: const TabBar(
                    tabs: [
                      Tab(
                        text: 'Text',
                      ),
                      Tab(
                        text: 'Text',
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.deepPurple,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.deepPurple,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.deepPurple,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
