import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/bloc/bottle/bottle_bloc.dart';

import 'package:google_fonts/google_fonts.dart';

class BottleDetailPage extends StatelessWidget {
  final int bottleId;

  const BottleDetailPage({super.key, required this.bottleId});

  @override
  Widget build(BuildContext context) {
    context.read<BottleBloc>().add(FetchBottleDetails(bottleId));

    return BlocBuilder<BottleBloc, BottleState>(
      builder: (context, state) {
        if (state is BottleDetailsLoaded &&
            state.selectedBottle.id == bottleId) {
          final bottle = state.selectedBottle;
          return Scaffold(
            backgroundColor: const Color(0xFF0B1519),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background_image.png',
                    fit: BoxFit.cover,
                  ),
                ),

                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 72,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Genesis Collection',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: const Color.fromRGBO(
                                  11,
                                  21,
                                  25,
                                  1,
                                ),
                                child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: 343,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.verified,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Genuine Bottle (Unopened)',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Bottle Image
                        Container(
                          width: 343,
                          height: 457,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/bottle.png',
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          width: 343,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF132026).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DefaultTabController(
                            length: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bottle.labelNumber,
                                  style: GoogleFonts.lato(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    text: '${bottle.details.distillery} ',
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: bottle.details.ageStatement,
                                        style: GoogleFonts.lato(
                                          color: Colors.orangeAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '#${bottle.details.caskNumber}',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Tab Bar
                                Container(
                                  width: 311,
                                  height: 32,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(14, 28, 33, 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TabBar(
                                    indicator: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelPadding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.white70,
                                    tabs: const [
                                      Tab(text: 'Details'),
                                      Tab(text: 'Tasting Note'),
                                      Tab(text: 'History'),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 12),

                                SizedBox(
                                  height: 400,
                                  child: TabBarView(
                                    children: [
                                      ListView(
                                        padding: EdgeInsets.zero,
                                        children: [
                                          buildDataRow(
                                            'Distillery',
                                            bottle.details.distillery,
                                          ),
                                          buildDataRow(
                                            'Region',
                                            bottle.details.region,
                                          ),
                                          buildDataRow(
                                            'Country',
                                            bottle.details.country,
                                          ),
                                          buildDataRow(
                                            'Type',
                                            bottle.details.type,
                                          ),
                                          buildDataRow(
                                            'Age statement',
                                            bottle.details.ageStatement,
                                          ),
                                          buildDataRow(
                                            'Filled',
                                            bottle.details.filled,
                                          ),
                                          buildDataRow(
                                            'Bottled',
                                            bottle.details.bottled,
                                          ),
                                          buildDataRow(
                                            'Cask number',
                                            bottle.details.caskNumber,
                                          ),
                                          buildDataRow(
                                            'ABV',
                                            bottle.details.abv,
                                          ),
                                          buildDataRow(
                                            'Size',
                                            bottle.details.size,
                                          ),
                                          buildDataRow(
                                            'Finish',
                                            bottle.details.finish,
                                          ),
                                        ],
                                      ),

                                      // TASTING NOTES TAB
                                      SingleChildScrollView(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tasting notes',
                                              style: GoogleFonts.ebGaramond(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'by ${bottle.tastingNotes.expert}',
                                              style: GoogleFonts.lato(
                                                color: Colors.white60,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 12),

                                            // Video Placeholder
                                            Container(
                                              height: 223,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16),

                                            // Tasting Sections
                                            _buildTastingSection(
                                              'Nose',
                                              bottle.tastingNotes.nose,
                                            ),
                                            _buildTastingSection(
                                              'Palate',
                                              bottle.tastingNotes.palate,
                                            ),
                                            _buildTastingSection(
                                              'Finish',
                                              bottle.tastingNotes.finish,
                                            ),
                                          ],
                                        ),
                                      ),

                                      // HISTORY TAB
                                      SingleChildScrollView(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Column(
                                          children: bottle.history
                                              .map(
                                                (history) => _buildHistoryItem(
                                                  label: history.label,
                                                  title: history.title,
                                                  description:
                                                      history.description,
                                                  attachments:
                                                      history.attachments,
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.add),
                            label: Text(
                              'Add to my collection',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is BottleError) {
          return Scaffold(
            backgroundColor: const Color(0xFF0B1519),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading bottle details',
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () => context.read<BottleBloc>().add(
                      FetchBottleDetails(bottleId),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          backgroundColor: Color(0xFF0B1519),
          body: Center(child: CircularProgressIndicator(color: Colors.amber)),
        );
      },
    );
  }

  Widget _buildTastingSection(String title, List<String> notes) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.ebGaramond(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...notes.map(
            (note) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                note,
                style: GoogleFonts.lato(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String label,
    required String title,
    required List<String> description,
    required List<String> attachments,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              // Circle
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.amber, width: 2),
                ),
              ),

              Container(
                width: 2,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  backgroundBlendMode: BlendMode.dst,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0E1C21),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.lato(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.ebGaramond(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...description.map(
                    (text) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        text,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (attachments.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.attachment,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Attachments',
                                style: GoogleFonts.lato(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: attachments
                                .map(
                                  (url) => Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[600],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Image.asset(url, fit: BoxFit.cover),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildDataRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lato(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
