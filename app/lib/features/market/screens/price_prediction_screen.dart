import 'package:flutter/material.dart';
import '../../../shared/components/module_in_progress_view.dart';

/// Price Prediction & Trend screen showing a polished In-Progress state.
class PricePredictionScreen extends StatelessWidget {
  const PricePredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ModuleInProgressView(
          module: AgriModule.pricePrediction,
        ),
      ),
    );
  }
}
