import 'dart:async';

import 'package:nocterm/nocterm.dart';

class SimmerLoading extends StatefulComponent {
  final int rowCount;

  const SimmerLoading({this.rowCount = 10, super.key});

  @override
  State<SimmerLoading> createState() => _SimmerLoadingState();
}

class _SimmerLoadingState extends State<SimmerLoading> {
  late final int rowCount;
  int _frame = 0;
  Timer? _timer;

  static const _frames = ['.  ', '.. ', '...', ' ..', '  .', '   '];

  @override
  void initState() {
    super.initState();
    rowCount = component.rowCount;
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      setState(() => _frame = (_frame + 1) % _frames.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final theme = TuiTheme.of(context);
    final pattern = _frames[_frame];
    return Column(
      children: [
        const SizedBox(height: 1),
        Text(
          'Loading$pattern',
          style: TextStyle(color: theme.outline),
        ),
        ...List.generate(
          rowCount,
          (i) => _skeletonRow(i, theme),
        ),
      ],
    );
  }

  Component _skeletonRow(int i, TuiThemeData theme) {
    final width = 20 + (i * 7) % 40;
    final dots = '.' * width;
    final muted = theme.outline.withOpacity(0.3);
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
          height: 1,
          child: Row(
            children: [
              const Text('   '),
              Expanded(
                child: Text(
                  dots,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: muted),
                ),
              ),
              Text(
                ' ..pts',
                style: TextStyle(color: muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
