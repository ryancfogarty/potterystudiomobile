import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/usecases/DeleteFiringUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetFiringUseCase.dart';

class FiringPage extends StatefulWidget {
  FiringPage({
    Key key,
    @required this.firingId
  }) : super(key: key);

  final String firingId;

  @override
  State<StatefulWidget> createState() => _FiringPageState();
}

class _FiringPageState extends State<FiringPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _getFiring);
  }

  void _getFiring() async {
    var useCase = Provider.of<GetFiringUseCase>(context, listen: false);
    useCase.clear();
    useCase.invoke(widget.firingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firing"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Consumer<GetFiringUseCase>(
      builder: (context, useCase, _) {
        return Column(
          children: [
            Consumer<GetFiringUseCase>(
              builder: (context, useCase, _) {
                return Text(useCase.firing?.start?.toIso8601String() ?? "Loading...");
              }
            ),
            Consumer<DeleteFiringUseCase>(
              builder: (context, useCase, _) {
                return Visibility(
                  visible: useCase.loading,
                  child: CircularProgressIndicator(),
                  replacement: Card(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Delete"),
                      ),
                      onTap: _deleteFiring,
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  void _deleteFiring() async {
    try {
      await Provider.of<DeleteFiringUseCase>(context, listen: false).deleteFiring(widget.firingId);
      Navigator.of(context).pop(true);
    } catch (e) {}
  }
}