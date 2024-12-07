import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/scalesize.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../items/news_item.dart';

class DashboardNews extends StatelessWidget {
  const DashboardNews({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) => Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text('Neuigkeiten',
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: viewModel.newsList.length,
                          itemBuilder: (context, index) {
                            return NewsItem(
                                date: viewModel.newsList[index].date,
                                text: viewModel.newsList[index].text);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
