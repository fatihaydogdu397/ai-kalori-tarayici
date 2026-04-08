import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

// ── Mock AI responses ─────────────────────────────────────────────────────────

const _mockResponses = [
  "Great question! Based on your calorie intake, I'd recommend increasing your protein to support muscle maintenance. Aim for 1.6–2g per kg of bodyweight.",
  "Your nutrition looks solid today! One tip: spreading meals into 4–5 smaller portions can help stabilize blood sugar and reduce cravings.",
  "For fat loss, a moderate calorie deficit of 300–500 kcal below your TDEE is sustainable. Crash diets often backfire — consistency wins.",
  "Hydration matters more than most people realize. Even mild dehydration can reduce metabolism by up to 3%. Try to drink 30ml per kg of bodyweight daily.",
  "Fiber is your friend! It slows digestion, keeps you fuller longer, and feeds beneficial gut bacteria. Aim for 25–35g per day from whole foods.",
  "Carbohydrates aren't the enemy — timing matters. Consuming carbs around your workouts (pre/post) is optimal for energy and recovery.",
  "Sleep quality directly impacts hunger hormones (ghrelin and leptin). Poor sleep increases appetite by up to 24%. Prioritize 7–9 hours.",
  "Meal prepping 2–3 days in advance makes it much easier to stick to your nutrition goals. Try dedicating 1–2 hours on Sunday.",
  "If you're feeling fatigued, check your iron and vitamin D levels. Deficiencies in these are very common and can significantly impact energy.",
  "Post-workout nutrition window is real but not as narrow as once thought. Getting protein within 2 hours of training is sufficient for most people.",
];

const _greeting = "Hi! I'm your AI Dietitian powered by eatiq. Ask me anything about nutrition, meal planning, or how to reach your health goals. 🥗";

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  _ChatMessage({required this.text, required this.isUser, required this.time});
}

// ── Screen ────────────────────────────────────────────────────────────────────

class AiDietitianScreen extends StatefulWidget {
  const AiDietitianScreen({super.key});

  @override
  State<AiDietitianScreen> createState() => _AiDietitianScreenState();
}

class _AiDietitianScreenState extends State<AiDietitianScreen> {
  final _messages = <_ChatMessage>[
    _ChatMessage(text: _greeting, isUser: false, time: DateTime.now()),
  ];
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _isTyping = false;
  final _rng = Random();

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _isTyping) return;
    _ctrl.clear();

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true, time: DateTime.now()));
      _isTyping = true;
    });
    _scrollToBottom();

    // Mock AI reply after delay
    Timer(Duration(milliseconds: 1200 + _rng.nextInt(800)), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(
          text: _mockResponses[_rng.nextInt(_mockResponses.length)],
          isUser: false,
          time: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.limeDark;
    final border = isDark
        ? null
        : Border.all(color: AppColors.lightBorder, width: 0.5);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ────────────────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightBorder,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(10.r),
                        border: border,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16.sp,
                        color: textMuted,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: isDark ? 0.15 : 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text('🥗', style: TextStyle(fontSize: 18.sp)),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Dietitian',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          'Powered by eatiq AI',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: textMuted,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.mint.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: AppColors.mint,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Online',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.mint,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Quick Prompts ──────────────────────────────────────────────
            _QuickPrompts(
              isDark: isDark,
              accent: accent,
              textMuted: textMuted,
              onTap: (q) {
                _ctrl.text = q;
                _send();
              },
            ),

            // ── Messages ───────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (_, i) {
                  if (_isTyping && i == _messages.length) {
                    return _TypingIndicator(
                        isDark: isDark, cardBg: cardBg, accent: accent);
                  }
                  final msg = _messages[i];
                  return _Bubble(
                    message: msg,
                    isDark: isDark,
                    cardBg: cardBg,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    accent: accent,
                  );
                },
              ),
            ),

            // ── Input Bar ─────────────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(
                  16.w, 8.h, 16.w, MediaQuery.of(context).padding.bottom + 8.h),
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightBorder,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(22.r),
                        border: isDark
                            ? null
                            : Border.all(
                                color: AppColors.lightBorder, width: 0.5),
                      ),
                      child: TextField(
                        controller: _ctrl,
                        onSubmitted: (_) => _send(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ask about nutrition...',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: textMuted,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          isDense: true,
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 42.w,
                      height: 42.w,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(21.r),
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: isDark ? AppColors.void_ : Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quick Prompts ─────────────────────────────────────────────────────────────

class _QuickPrompts extends StatelessWidget {
  final bool isDark;
  final Color accent, textMuted;
  final void Function(String) onTap;

  const _QuickPrompts({
    required this.isDark,
    required this.accent,
    required this.textMuted,
    required this.onTap,
  });

  static const _prompts = [
    'How much protein do I need?',
    'Best foods for fat loss?',
    'Should I count calories?',
    'Meal prep tips?',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _prompts.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onTap(_prompts[i]),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(18.r),
            ),
            alignment: Alignment.center,
            child: Text(
              _prompts[i],
              style: TextStyle(
                fontSize: 12.sp,
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Chat Bubble ───────────────────────────────────────────────────────────────

class _Bubble extends StatelessWidget {
  final _ChatMessage message;
  final bool isDark;
  final Color cardBg, textPrimary, textMuted, accent;

  const _Bubble({
    required this.message,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28.w,
              height: 28.w,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: isDark ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text('🥗', style: TextStyle(fontSize: 14.sp)),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isUser
                    ? accent
                    : cardBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(isUser ? 16.r : 4.r),
                  bottomRight: Radius.circular(isUser ? 4.r : 16.r),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isUser
                      ? (isDark ? AppColors.void_ : Colors.white)
                      : textPrimary,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing Indicator ──────────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  final bool isDark;
  final Color cardBg, accent;
  const _TypingIndicator(
      {required this.isDark, required this.cardBg, required this.accent});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: widget.accent.withValues(alpha: widget.isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text('🥗', style: TextStyle(fontSize: 14.sp)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: widget.cardBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(4.r),
              ),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final offset = ((_ctrl.value * 3 - i) % 3) / 3;
                    final scale = 0.6 + 0.4 * (1 - (offset - 0.5).abs() * 2).clamp(0.0, 1.0);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 7.w,
                          height: 7.w,
                          decoration: BoxDecoration(
                            color: widget.accent.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
