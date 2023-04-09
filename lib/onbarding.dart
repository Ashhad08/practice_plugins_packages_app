import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingView extends StatefulWidget {
  OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> _list = ['Hi', 'Welcome', "by"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage == 0
                    ? const SizedBox(
                        height: 50,
                      )
                    : IconButton(
                        onPressed: () {
                          _controller.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        icon: const Icon(Icons.arrow_back)),
                _currentPage == 0.0
                    ? const SizedBox(
                        height: 50,
                      )
                    : TextButton(
                        onPressed: () {
                          _controller.animateToPage(3,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: const Text('Skip'))
              ],
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _list.length,
                onPageChanged: (val) {
                  setState(() {
                    _currentPage = val;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    height: 400,
                    width: 400,
                    color: Colors.black26,
                    child: Text(_list[index]),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const WormEffect(
                    // can change/modify the dots here.
                    )),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
