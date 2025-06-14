import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/bloc/bottle/bottle_bloc.dart';
import 'package:flutter_task/models/bottle.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCollectionScreen extends StatelessWidget {
  const MyCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          context.read<BottleBloc>().add(FetchBottles());
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1519),
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My collection',
                      style: GoogleFonts.ebGaramond(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Image.asset(
                      'assets/icons/icon-button-notification.png',
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: BlocBuilder<BottleBloc, BottleState>(
                  builder: (context, state) {
                    if (state is BottleInitial || state is BottleLoading) {
                      return const Center(child: CircularProgressIndicator(color: Colors.amber));
                    }

                    if (state is BottleError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                              onPressed: () => context.read<BottleBloc>().add(FetchBottles()),
                              child: const Text('Retry', style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      );
                    }

                    List<Bottle> bottles = [];
                    if (state is BottleLoaded) bottles = state.bottles;
                    if (state is BottleRefreshing) bottles = state.bottles;
                    if (state is BottleDetailsLoaded) bottles = state.bottles;

                    if (bottles.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No bottles found', style: TextStyle(color: Colors.white)),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                              onPressed: () => context.read<BottleBloc>().add(FetchBottles()),
                              child: const Text('Refresh', style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: Colors.amber,
                      onRefresh: () async => context.read<BottleBloc>().add(RefreshBottles()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.6,
                          ),
                          itemCount: bottles.length,
                          itemBuilder: (context, index) {
                            final bottle = bottles[index];
                            return GestureDetector(
                              onTap: () {
                                final bloc = context.read<BottleBloc>();
                                bloc.add(FetchBottleDetails(bottle.id));
                                Navigator.pushNamed(context, '/bottle', arguments: bottle.id)
                                  .then((_) => bloc.add(FetchBottles()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF112025),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          'assets/images/product-image.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        bottle.name,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.ebGaramond(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Text(
                                        bottle.labelNumber,
                                        style: GoogleFonts.lato(
                                          color: Colors.white60,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1519),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavIcon(Icons.qr_code_scanner, 'Scan'),
            _buildNavIcon(Icons.grid_view_rounded, 'Collection', selected: true),
            _buildNavIcon(Icons.shopping_bag_outlined, 'Shop'),
            _buildNavIcon(Icons.settings, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label, {bool selected = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: selected ? Colors.white : Colors.white60, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 12,
            color: selected ? Colors.white : Colors.white60,
          ),
        ),
      ],
    );
  }
}