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
    final pattern = _frames[_frame];
    return Column(
      children: [
        const SizedBox(height: 1),
        Text(
          'Loading$pattern',
          style: const TextStyle(color: Colors.gray),
        ),
        ...List.generate(
          rowCount,
          (i) => _skeletonRow(i),
        ),
      ],
    );
  }

  Component _skeletonRow(int i) {
    final width = 20 + (i * 7) % 40;
    final dots = '.' * width;
    return Container(
      color: i.isEven
          ? const Color(0x0a0000ff)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
          height: 1,
          child: Row(
            children: [
              const Text('   ', style: TextStyle(color: Colors.gray)),
              Expanded(
                child: Text(
                  dots,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0x33ffffff)),
                ),
              ),
              Text(
                ' ..pts',
                style: const TextStyle(color: Color(0x33ffffff)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
