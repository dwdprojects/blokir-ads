// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/ad_blocker_cubit.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';

import '../../../../core/localization/app_strings.dart';

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
            duration: Duration(milliseconds: 200),
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
    final strings = AppStrings.of(context);
    
    return Container(
      height: 200,
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF0F172A), // Dark terminal background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.terminal, color: context.colors.primary, size: 16),
              SizedBox(width: 8),
              Text(
                strings.liveDnsTerminal,
                style: context.textStyles.labelSmall.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: context.colors.warning,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Divider(color: Colors.white24, height: 16),
          Expanded(
            child: _logs.isEmpty
                ? Center(
                    child: Text(
                      strings.waitingDnsQuery,
                      style: context.textStyles.bodyMedium.copyWith(
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
                        padding: EdgeInsets.only(bottom: 4),
                        child: isBlocked || domain.isEmpty
                            ? Text(
                                '> $log',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  color: isBlocked
                                      ? context.colors.warning
                                      : Color(0xFF10B981),
                                ),
                              )
                            : GestureDetector(
                                onTap: () => _showBlockConfirmationDialog(domain),
                                child: Text(
                                  '> $log',
                                  style: TextStyle(
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
    final strings = AppStrings.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(
          strings.blockDomainTitle,
          style: context.textStyles.titleMedium,
        ),
        content: Text(
          strings.blockDomainMessage(domain),
          style: context.textStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(strings.cancel, style: context.textStyles.labelSmall),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.warning,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AdBlockerCubit>().blockCustomDomain(domain);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(strings.domainBlockedSuccess(domain)),
                  backgroundColor: context.colors.warning,
                ),
              );
            },
            child: Text(
              strings.blockNow,
              style: context.textStyles.labelSmall.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
