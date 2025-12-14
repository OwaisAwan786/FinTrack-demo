import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:fintrack_app/core/models/models.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/widgets/glass_panel.dart';
import 'package:fintrack_app/providers/fintrack_provider.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _category = 'Food';
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(AppSpacers.lg),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Expense',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextButton.icon(
                  onPressed: () {
                    context.read<FinTrackProvider>().simulateBillPayment();
                  },
                  icon: const Icon(LucideIcons.zap, size: 12, color: Color(0xFFFBBF24)),
                  label: const Text(
                    'Simulate Bill Pay',
                    style: TextStyle(fontSize: 12, color: Color(0xFFFBBF24)),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    backgroundColor: const Color(0xFFF59E0B).withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: const Color(0xFFF59E0B).withOpacity(0.2)),
                    ),
                  ),
                ),
              ],
            ),
            AppSpacers.vLg,
            _buildTextField(
              controller: _titleController,
              label: 'Title',
              hint: 'e.g. Grocery, Cinema',
            ),
            AppSpacers.vMd,
            _buildTextField(
              controller: _amountController,
              label: 'Amount (PKR)',
              hint: '0.00',
              keyboardType: TextInputType.number,
            ),
            AppSpacers.vMd,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Category', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _category,
                            isExpanded: true,
                            dropdownColor: AppColors.surfaceColor,
                            items: ['Food', 'Transport', 'Shopping', 'Bills', 'Health', 'Others']
                                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white))))
                                .toList(),
                            onChanged: (v) => setState(() => _category = v!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacers.hMd,
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _date.toIso8601String().split('T')[0],
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Icon(LucideIcons.calendar, size: 16, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AppSpacers.vLg,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(LucideIcons.plus, size: 18),
                label: const Text('Add Transaction'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
  }) {
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
            contentPadding: const EdgeInsets.all(12),
          ),
          validator: (v) => v!.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        id: 0,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _category,
        date: _date.toIso8601String().split('T')[0],
        type: 'expense',
      );
      context.read<FinTrackProvider>().addTransaction(transaction);
      
      _titleController.clear();
      _amountController.clear();
      // Keep category and date
    }
  }
}
