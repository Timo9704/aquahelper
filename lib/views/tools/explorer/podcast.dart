import 'package:aquahelper/viewmodels/tools/explorer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Podcasts extends StatelessWidget {
  const Podcasts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorerViewModel>(
      builder: (context, viewModel, child) => Column(
        children: [
          const SizedBox(height: 10),
          const Text('Filtere die Podcasts nach Themen:',
              style: TextStyle(fontSize: 20)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            child: Wrap(
              spacing: 5.0,
              children: viewModel.tags
                  .map((tag) => FilterChip(
                        label: Text(tag),
                        selected: viewModel.selectedTags.contains(tag),
                        padding: const EdgeInsets.all(10),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.grey,
                        selectedColor: Colors.lightGreen,
                        checkmarkColor: Colors.white,
                        showCheckmark: false,
                        onSelected: (selected) {
                          selected
                              ? viewModel.selectedTags.add(tag)
                              : viewModel.selectedTags.remove(tag);
                          viewModel.filterPodcasts();
                        },
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.filteredPodcasts.length,
              itemBuilder: (context, index) {
                var podcast = viewModel.filteredPodcasts[index][0]['name'];
                var podcastHost = viewModel.filteredPodcasts[index][0]['by'];
                var podcastLink =
                    viewModel.filteredPodcasts[index][1]['spotify'];
                var podcastImage =
                    viewModel.filteredPodcasts[index][1]['image'];

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Image.network(podcastImage, width: 300),
                        onPressed: () {
                          viewModel.launchPodcasts(podcastLink);
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        podcast,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "by: $podcastHost",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
