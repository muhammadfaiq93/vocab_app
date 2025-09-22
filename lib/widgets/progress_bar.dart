import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color? backgroundColor;
  final Color? progressColor;
  final double height;
  final BorderRadius? borderRadius;
  final Duration animationDuration;
  final String? label;
  final bool showPercentage;
  final TextStyle? labelStyle;
  final TextStyle? percentageStyle;
  final EdgeInsets? padding;

  const ProgressBar({
    Key? key,
    required this.progress,
    this.backgroundColor,
    this.progressColor,
    this.height = 8.0,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 500),
    this.label,
    this.showPercentage = false,
    this.labelStyle,
    this.percentageStyle,
    this.padding,
  }) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress.clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ));
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label!,
                  style: widget.labelStyle ??
                      TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                ),
                if (widget.showPercentage)
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Text(
                        '${(_progressAnimation.value * 100).round()}%',
                        style: widget.percentageStyle ??
                            TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                      );
                    },
                  ),
              ],
            ),
            SizedBox(height: 8),
          ],
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.grey[200],
                  borderRadius: widget.borderRadius ??
                      BorderRadius.circular(widget.height / 2),
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius ??
                      BorderRadius.circular(widget.height / 2),
                  child: LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.progressColor ?? AppColors.primaryBlue,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CircularProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final Duration animationDuration;
  final Widget? child;
  final bool showPercentage;
  final TextStyle? percentageStyle;

  const CircularProgressBar({
    Key? key,
    required this.progress,
    this.size = 100.0,
    this.strokeWidth = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.animationDuration = const Duration(milliseconds: 800),
    this.child,
    this.showPercentage = true,
    this.percentageStyle,
  }) : super(key: key);

  @override
  State<CircularProgressBar> createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(CircularProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress.clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ));
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return CircularProgressIndicator(
                value: _progressAnimation.value,
                strokeWidth: widget.strokeWidth,
                backgroundColor: widget.backgroundColor ?? Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.progressColor ?? AppColors.primaryBlue,
                ),
              );
            },
          ),
          if (widget.child != null)
            widget.child!
          else if (widget.showPercentage)
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Text(
                  '${(_progressAnimation.value * 100).round()}%',
                  style: widget.percentageStyle ??
                      TextStyle(
                        fontSize: widget.size * 0.15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? completedColor;
  final double stepSize;
  final double lineHeight;
  final List<String>? stepLabels;
  final TextStyle? labelStyle;

  const StepProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
    this.stepSize = 32.0,
    this.lineHeight = 4.0,
    this.stepLabels,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;
            final isLast = index == totalSteps - 1;

            return Expanded(
              child: Row(
                children: [
                  _buildStep(index, isCompleted, isCurrent),
                  if (!isLast) _buildLine(isCompleted),
                ],
              ),
            );
          }),
        ),
        if (stepLabels != null) ...[
          SizedBox(height: 12),
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentStep;
              return Expanded(
                child: Text(
                  stepLabels![index],
                  textAlign: TextAlign.center,
                  style: labelStyle ??
                      TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                        color: isActive
                            ? AppColors.primaryBlue
                            : AppColors.textLight,
                      ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildStep(int index, bool isCompleted, bool isCurrent) {
    Color stepColor;
    Widget stepChild;

    if (isCompleted) {
      stepColor = completedColor ?? AppColors.success;
      stepChild = Icon(
        Icons.check,
        color: Colors.white,
        size: stepSize * 0.6,
      );
    } else if (isCurrent) {
      stepColor = activeColor ?? AppColors.primaryBlue;
      stepChild = Text(
        '${index + 1}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: stepSize * 0.4,
        ),
      );
    } else {
      stepColor = inactiveColor ?? AppColors.textLight;
      stepChild = Text(
        '${index + 1}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: stepSize * 0.4,
        ),
      );
    }

    return Container(
      width: stepSize,
      height: stepSize,
      decoration: BoxDecoration(
        color: stepColor,
        shape: BoxShape.circle,
        boxShadow: isCurrent || isCompleted
            ? [
                BoxShadow(
                  color: stepColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(child: stepChild),
    );
  }

  Widget _buildLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: lineHeight,
        color: isCompleted
            ? (completedColor ?? AppColors.success)
            : (inactiveColor ?? AppColors.textLight),
      ),
    );
  }
}

class WeeklyProgressBar extends StatelessWidget {
  final List<double> weeklyData; // 7 values for each day
  final List<String> dayLabels;
  final Color? barColor;
  final Color? backgroundColor;
  final double maxHeight;
  final double barWidth;

  const WeeklyProgressBar({
    Key? key,
    required this.weeklyData,
    this.dayLabels = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    this.barColor,
    this.backgroundColor,
    this.maxHeight = 100.0,
    this.barWidth = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxValue = weeklyData.isNotEmpty
        ? weeklyData.reduce((a, b) => a > b ? a : b)
        : 1.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) {
        final value = index < weeklyData.length ? weeklyData[index] : 0.0;
        final normalizedHeight =
            maxValue > 0 ? (value / maxValue) * maxHeight : 0.0;

        return Column(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: normalizedHeight),
              duration: Duration(milliseconds: 500 + (index * 100)),
              curve: Curves.easeOut,
              builder: (context, height, child) {
                return Container(
                  width: barWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: barColor ?? AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(barWidth / 4),
                    boxShadow: [
                      BoxShadow(
                        color: (barColor ?? AppColors.primaryBlue)
                            .withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 8),
            Text(
              dayLabels[index],
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }),
    );
  }
}
