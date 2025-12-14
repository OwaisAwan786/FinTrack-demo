import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:fintrack_app/core/utils/ai_logic.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/providers/fintrack_provider.dart';
import 'package:fintrack_app/widgets/glass_panel.dart';

class AdvisorScreen extends StatelessWidget {
  const AdvisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinTrackProvider>(builder: (context, provider, child) {
       final result = AiLogic.generateInsights(provider.transactions, provider.budget, provider.savingsPocket);
       final insights = result['insights'] as List<Insight>;
       final healthScore = result['healthScore'] as int;
       
       Color getScoreColor(int score) {
          if (score >= 80) return AppColors.successColor;
          if (score >= 50) return Colors.amber;
          return AppColors.dangerColor;
       }

       IconData getIcon(String type) {
          switch (type) {
            case 'warning': return LucideIcons.alertTriangle;
            case 'danger': return LucideIcons.alertTriangle;
            case 'success': return LucideIcons.trendingUp;
            case 'tip': return LucideIcons.lightbulb;
            default: return LucideIcons.shieldCheck;
          }
       }
       
       return SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             const Text('AI Financial Advisor', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
             const SizedBox(height: 4),
             const Text('Personalized insights to help you save smarter and grow your wealth.', style: TextStyle(color: AppColors.textSecondary)),
             AppSpacers.vLg,
             
             LayoutBuilder(builder: (context, constraints) {
               final isLarge = constraints.maxWidth > 1024;
               
               return Flex(
                 direction: isLarge ? Axis.horizontal : Axis.vertical,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   // Health Score Card (Left)
                   Container(
                     width: isLarge ? constraints.maxWidth / 3 : double.infinity,
                     constraints: isLarge ? null : const BoxConstraints(minHeight: 200),
                     child: Container(
                       padding: const EdgeInsets.all(40),
                       decoration: BoxDecoration(
                         color: AppColors.surfaceColor,
                         borderRadius: BorderRadius.circular(16),
                         border: Border.all(color: AppColors.borderColor),
                       ),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           // Simple gradient line at top relative to container not easy, skip or use Container with Stack.
                           const Icon(LucideIcons.bot, size: 56, color: AppColors.primaryColor),
                           const SizedBox(height: 24),
                           const Text('Financial Health Score', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFD1D5DB))),
                           const SizedBox(height: 8),
                           Text('$healthScore', style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: getScoreColor(healthScore))),
                           const SizedBox(height: 16),
                           const Text('Based on your budget adherence, savings rate, and spending variety.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                         ],
                       ),
                     ),
                   ),
                   if (isLarge) AppSpacers.hLg else AppSpacers.vLg,
                   
                   // Insights Feed (Right)
                   Expanded(
                     flex: isLarge ? 2 : 0,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                          const Row(children: [Icon(LucideIcons.sparkles, size: 20, color: AppColors.primaryColor), SizedBox(width: 8), Text('Latest Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                          AppSpacers.vMd,
                          ...insights.map((insight) {
                             Color color;
                             Color bgColor;
                             switch (insight.type) {
                               case 'danger': color = AppColors.dangerColor; bgColor = AppColors.dangerColor.withOpacity(0.1); break;
                               case 'warning': color = Colors.amber; bgColor = Colors.amber.withOpacity(0.1); break;
                               case 'success': color = AppColors.successColor; bgColor = AppColors.successColor.withOpacity(0.1); break;
                               default: color = AppColors.primaryColor; bgColor = AppColors.primaryColor.withOpacity(0.1);
                             }
                             
                             return Container(
                               margin: const EdgeInsets.only(bottom: 20),
                               child: GlassPanel(
                                 padding: const EdgeInsets.all(24),
                                 child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       Container(
                                         padding: const EdgeInsets.all(12),
                                         decoration: BoxDecoration(color: const Color(0xFF0F172A).withOpacity(0.5), shape: BoxShape.circle),
                                         child: Icon(getIcon(insight.type), size: 24, color: color),
                                       ),
                                       AppSpacers.hMd,
                                       Expanded(
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                              Text(insight.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                                              const SizedBox(height: 4),
                                              Text(insight.message, style: const TextStyle(color: Color(0xFFD1D5DB), height: 1.5)),
                                           ],
                                         ),
                                       ),
                                    ],
                                 ),
                               ),
                             );
                          }),
                       ],
                     ),
                   ),
                 ],
               );
             }),
           ],
         ),
       );
    });
  }
}
