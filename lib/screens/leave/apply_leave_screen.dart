import 'package:flutter/material.dart';
import 'package:hrms/services/leave_service.dart';
import 'package:intl/intl.dart';

class ApplyLeaveScreen extends StatefulWidget {
  static const String id = 'apply_leave_screen';

  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _reasonController = TextEditingController();

  String? selectedLeaveType;
  DateTime? fromDate;
  DateTime? toDate;

  bool isLoading = false;

  final List<String> leaveTypes = ['Casual Leave', 'Sick Leave', 'Privilege Leave', 'Work From Home'];

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  Future<void> _applyLeave() async {
    if (selectedLeaveType == null ||
        fromDate == null ||
        toDate == null ||
        _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await LeaveService.applyLeave(
        leaveType: selectedLeaveType!,
        fromDate: DateFormat('yyyy-MM-dd').format(fromDate!),
        toDate: DateFormat('yyyy-MM-dd').format(toDate!),
        reason: _reasonController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave applied successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to apply leave')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD),
      appBar: AppBar(
        title: const Text('Apply Leave'),
        backgroundColor: const Color(0xFFFF69B4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Type
            const Text('Leave Type'),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedLeaveType,
              items: leaveTypes
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => selectedLeaveType = value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select leave type',
              ),
            ),

            const SizedBox(height: 20),

            // From Date
            const Text('From Date'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => _pickDate(isFrom: true),
              child: _dateBox(
                fromDate != null
                    ? DateFormat('dd MMM yyyy').format(fromDate!)
                    : 'Select from date',
              ),
            ),

            const SizedBox(height: 20),

            // To Date
            const Text('To Date'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => _pickDate(isFrom: false),
              child: _dateBox(
                toDate != null
                    ? DateFormat('dd MMM yyyy').format(toDate!)
                    : 'Select to date',
              ),
            ),

            const SizedBox(height: 20),

            // Reason
            const Text('Reason'),
            const SizedBox(height: 6),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter reason',
              ),
            ),

            const Spacer(),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : _applyLeave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF69B4),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Apply Leave'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text),
    );
  }
}
