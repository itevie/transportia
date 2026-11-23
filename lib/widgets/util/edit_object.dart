import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:transportia/widgets/prompts/big_button_selector.dart';

class CsvOptions {
  final List<String> templateCsvParts;
  final Future<void> Function(String csv) rowCallback;

  const CsvOptions({required this.templateCsvParts, required this.rowCallback});
}

class EditObjectPage extends StatefulWidget {
  final String title;
  final Widget child;
  final Future<void> Function() onSave;
  final List<Widget> options;
  final CsvOptions? csvOptions;

  const EditObjectPage({
    super.key,
    required this.onSave,
    required this.title,
    required this.options,
    required this.child,
    this.csvOptions,
  });

  @override
  State<EditObjectPage> createState() => _EditObjectPageState();
}

class _EditObjectPageState extends State<EditObjectPage> {
  bool _isSaving = false;
  bool _isImporting = false;

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      await widget.onSave();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _downloadCsvTemplate() async {
    final csvOptions = widget.csvOptions;
    if (csvOptions == null) return;

    try {
      final csvString = csv.encode([csvOptions.templateCsvParts]);

      final bytes = Uint8List.fromList([
        0xEF,
        0xBB,
        0xBF,
        ...utf8.encode(csvString),
      ]);

      await FilePicker.saveFile(
        fileName: 'transportia_template.csv',
        bytes: bytes,
        mimeType: 'text/csv',
        dialogTitle: 'Save CSV Template',
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save CSV template: $e')),
      );
    }
  }

  Future<void> _uploadCsv() async {
    final csvOptions = widget.csvOptions;
    if (csvOptions == null || _isImporting) return;

    setState(() => _isImporting = true);

    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (file == null) return;

      final contents = utf8
          .decode(await file.readAsBytes(), allowMalformed: true)
          .replaceFirst('\uFEFF', '');

      await csvOptions.rowCallback(contents);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('CSV import failed: $e')));
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  Future<void> _showCsvOptions() async {
    await showBigButtonPrompt(context, "What to do?", [
      BigButtonOption(
        icon: Icons.download,
        label: "Download Template",
        onPressed: _downloadCsvTemplate,
      ),
      BigButtonOption(
        icon: Icons.upload,
        label: "Upload",
        onPressed: _uploadCsv,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var filter in widget.options) ...[
                      filter,
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 320, child: widget.child),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? 'Saving...' : 'Save'),
            ),
            if (widget.csvOptions != null) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: "Import CSV",
                onPressed: _isImporting ? null : _showCsvOptions,
                icon: _isImporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.table_chart),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
