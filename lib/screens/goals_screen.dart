import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:fintrack_app/core/models/models.dart';
import 'package:fintrack_app/core/utils/ai_logic.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/core/utils/formatters.dart';
import 'package:fintrack_app/providers/fintrack_provider.dart';
import 'package:fintrack_app/widgets/glass_panel.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _monthsController = TextEditingController();
  
  Map<String, dynamic>? _plan;

  void _calculatePlan() {
    if (_targetController.text.isEmpty || _monthsController.text.isEmpty) return;
    final target = double.tryParse(_targetController.text) ?? 0;
    final months = int.tryParse(_monthsController.text) ?? 0;
    
    if (months <= 0) return;

    setState(() {
      _plan = {
        'monthlyNeed': target / months,
        'target': target,
        'months': months,
      };
    });
  }

  void _handleCreateGoal(FinTrackProvider provider) {
    if (_nameController.text.isEmpty || _plan == null) return;
    
    provider.addGoal(
      _nameController.text,
      _plan!['target'],
      '#8B5CF6', // Default purple color code string
    );
    
    _nameController.clear();
    _targetController.clear();
    _monthsController.clear();
    setState(() => _plan = null);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Goal Planner',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text('Turn your dreams into reality with a solid financial plan.', style: TextStyle(color: AppColors.textSecondary)),
          AppSpacers.vLg,

          LayoutBuilder(builder: (context, constraints) {
            final isLarge = constraints.maxWidth > 1024;
            return isLarge ? _buildDesktopLayout(context) : _buildMobileLayout(context);
          }),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildInputForm(context)),
        AppSpacers.hLg,
        Expanded(child: _buildRightColumn(context)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildInputForm(context),
        AppSpacers.vLg,
        _buildRightColumn(context),
      ],
    );
  }

  Widget _buildInputForm(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.target, color: AppColors.primaryColor),
              SizedBox(width: 8),
              Text('Create New Goal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          AppSpacers.vLg,
          
          _buildTextField(
             controller: _nameController,
             label: 'Goal Name',
             hint: 'e.g. New iPhone 16',
          ),
          AppSpacers.vMd,
          Row(
            children: [
              Expanded(child: _buildTextField(
                controller: _targetController,
                label: 'Target Amount (PKR)',
                hint: '300000',
                keyboardType: TextInputType.number,
              )),
              AppSpacers.hMd,
              Expanded(child: _buildTextField(
                 controller: _monthsController,
                 label: 'Timeline (Months)',
                 hint: '6',
                 keyboardType: TextInputType.number,
              )),
            ],
          ),
          AppSpacers.vLg,
          
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _calculatePlan,
              icon: const Icon(LucideIcons.calculator, size: 18),
              label: const Text('Calculate Plan'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.borderColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: AppColors.surfaceHover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required String hint, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
             hintText: hint,
             hintStyle: const TextStyle(color: Colors.grey),
             filled: true,
             fillColor: AppColors.surfaceColor,
             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderColor)),
             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderColor)),
             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Consumer<FinTrackProvider>(
      builder: (context, provider, _) { 
        // Need insights
        final validation = AiLogic.generateInsights(provider.transactions, provider.budget, provider.savingsPocket);
        final insights = validation['insights'] as List<Insight>;
        final warnings = insights.where((i) => i.type == 'warning' || i.type == 'danger').toList();
        
        return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_plan != null)
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 300),
              child: GlassPanel(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(LucideIcons.sparkles, color: AppColors.successColor, size: 18), SizedBox(width: 8), Text('Plan Preview', style: TextStyle(color: AppColors.successColor, fontWeight: FontWeight.bold))]),
                    AppSpacers.vMd,
                    Text('To save ${Formatters.formatCurrency(_plan!['target'])} in ${_plan!['months']} months:', style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text('${Formatters.formatCurrency(_plan!['monthlyNeed'])} / month', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
                      child: Text.rich(TextSpan(
                        text: 'Your current "Savings Pocket" balance is ',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        children: [
                          TextSpan(text: Formatters.formatCurrency(provider.savingsPocket), style: const TextStyle(color: AppColors.primaryColor)),
                          TextSpan(text: provider.savingsPocket > _plan!['monthlyNeed'] ? " You're already covered for the first month! 🎉" : " Start auto-saving on transactions to reach this faster!"),
                        ]
                      )),
                    ),
                    AppSpacers.vMd,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleCreateGoal(provider),
                        style: ElevatedButton.styleFrom(
                           backgroundColor: AppColors.primaryColor,
                           foregroundColor: Colors.white,
                           padding: const EdgeInsets.symmetric(vertical: 16),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Confirm Goal'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_plan != null) AppSpacers.vLg,

          // Smart Goals Advice
          GlassPanel(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF6366F1).withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(LucideIcons.sparkles, size: 18, color: Color(0xFFA5B4FC))),
                    const SizedBox(width: 8),
                    const Text('Smart Savings Advice', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                 ),
                 AppSpacers.vMd,
                 if (warnings.isNotEmpty)
                    ...warnings.take(1).map((w) => Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.surfaceColor.withOpacity(0.5), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.dangerColor.withOpacity(0.2))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Padding(padding: const EdgeInsets.only(top: 4), child: Icon(LucideIcons.target, size: 16, color: AppColors.dangerColor)),
                           const SizedBox(width: 12),
                           Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                             Text(w.title, style: const TextStyle(color: Color(0xFFFCA5A5), fontWeight: FontWeight.bold, fontSize: 14)),
                             const SizedBox(height: 4),
                             Text(w.message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                             const SizedBox(height: 8),
                             const Text('💡 Tip: Reducing this by just 10% could save you PKR 2,000/month!', style: TextStyle(color: AppColors.primaryColor, fontSize: 12, fontWeight: FontWeight.w500)),
                           ])),
                        ],
                      ),
                    ))
                 else 
                    const Text('Your spending looks good! Keep using the "Auto-Save" feature to hit your targets steadily.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
          AppSpacers.vLg,
          
          // Active Goals List
           const Text('ACTIVE GOALS', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
           const SizedBox(height: 16),
           ...provider.goals.map((goal) => Container(
             margin: const EdgeInsets.only(bottom: 16),
             padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderColor)),
             child: Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                       Text(goal.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                       Text('Target: ${Formatters.formatCurrency(goal.target)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                     ]),
                     Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surfaceHover, borderRadius: BorderRadius.circular(8)), child: const Icon(LucideIcons.target, size: 20, color: AppColors.primaryColor)),
                   ],
                 ),
                 const SizedBox(height: 12),
                 ClipRRect(
                   borderRadius: BorderRadius.circular(4),
                   child: LinearProgressIndicator(
                     value: (goal.current / goal.target).clamp(0.0, 1.0),
                     backgroundColor: AppColors.surfaceHover,
                     color: AppColors.primaryColor,
                     minHeight: 8,
                   ),
                 ),
                 const SizedBox(height: 8),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('${Formatters.formatCurrency(goal.current)} Saved', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                     Text('${(goal.current / goal.target * 100).round()}%', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                   ],
                 ),
               ],
             ),
           )),
        ],
      );},
    );
  }
}
