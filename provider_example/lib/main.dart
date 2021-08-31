import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter.dart';


void main() => runApp(ExampleApp2());

class ExampleApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>(
      create: (_) => Counter(),
      child: MaterialApp(
        title: 'Provider Example',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Provider Example'),
          ),
          body: Center(
            child: Consumer<Counter>( // Consumer를 사용하여 ElevatedButton을 감쌌다.
              builder: (_, counter, __) => ElevatedButton(
                child: Text(
                  '현재 숫자: ${counter.count}',
                ),
                onPressed: () {
                  counter.increment();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>( // ChangeNotifierProvider로 변경.
      create: (_) => Counter(),
      child: MaterialApp(
        title: 'Provider Example',
        home: Example(),
      ),
    );
  }
}

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Example'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text(
            '현재 숫자: ${Provider.of<Counter>(context).count}', // Provider.of<Counter>(context) 사용.
          ),
          onPressed: () {
            Provider.of<Counter>(context, listen: false).increment(); // Provider.of<Counter>(context, listen: false) 사용.
          },
        ),
      ),
    );
  }
}
