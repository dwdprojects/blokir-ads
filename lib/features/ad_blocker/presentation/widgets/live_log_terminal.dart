// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/ad_blocker_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LiveLogTerminalWidget extends StatefulWidget {
  const LiveLogTerminalWidget({super.key});

  @override
  State<LiveLogTerminalWidget> createState() => _LiveLogTerminalWidgetState();
}

class _LiveLogTerminalWidgetState extends State<LiveLogTerminalWidget> {
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<String>? _logSubscription;
  static const int _maxLogs = 100;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    final cubit = context.read<AdBlockerCubit>();
    _logSubscription = cubit.logStream.listen((log) {
      setState(() {
        _logs.add(log);
        if (_logs.length > _maxLogs) {
          _logs.removeAt(0);
        }
      });
      // Auto-scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _logSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark terminal background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.terminal, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                'Live DNS Terminal',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.warning,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 16),
          Expanded(
            child: _logs.isEmpty
                ? Center(
                    child: Text(
                      'Menunggu DNS query...',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white54,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      final isBlocked = log.startsWith('BLOCKED');
                      
                      // Extract domain from log (e.g. "DNS query: example.com" -> "example.com")
                      String domain = "";
                      if (!isBlocked && log.startsWith("DNS query: ")) {
                        domain = log.replaceFirst("DNS query: ", "").trim();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: isBlocked || domain.isEmpty
                            ? Text(
                                '> $log',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  color: isBlocked
                                      ? AppColors.warning
                                      : const Color(0xFF10B981),
                                ),
                              )
                            : GestureDetector(
                                onTap: () => _showBlockConfirmationDialog(domain),
                                child: Text(
                                  '> $log',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    color: Color(0xFF10B981), // Emerald green
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white24,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showBlockConfirmationDialog(String domain) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Blokir Domain?',
          style: AppTextStyles.titleMedium,
        ),
        content: Text(
          'Apakah Anda yakin ingin memblokir iklan dari:\n\n$domain\n\nJika ini bukan iklan, aplikasi target mungkin akan bermasalah.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: AppTextStyles.labelSmall),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AdBlockerCubit>().blockCustomDomain(domain);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$domain berhasil diblokir!'),
                  backgroundColor: AppColors.warning,
                ),
              );
            },
            child: Text(
              'Blokir Sekarang',
              style: AppTextStyles.labelSmall.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
