import 'package:core_util/util.dart';
import 'package:flutter/material.dart';
import 'package:my_data/data.dart';
import 'package:my_domain/domain.dart';
import 'package:my_presentation/presentation.dart';
import 'package:tool_clind_network/network.dart';

class MyProvider extends StatelessWidget {
  final Widget child;

  const MyProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<IProfileRemoteDataSource>(
      create: (context) => ProfileRemoteDataSource(ProfileApi(Modular.get<ClindRestClient>())),
      child: Provider<MyDataSource>(
        create: (context) => MyDataSource(
          Provider.of<IProfileRemoteDataSource>(context, listen: false),
        ),
        child: Provider<IMyRepository>(
          create: (context) => MyRepository(
            Provider.of<MyDataSource>(context, listen: false),
          ),
          child: Provider<GetMyUseCase>(
            create: (context) => GetMyUseCase(
              Provider.of<IMyRepository>(context, listen: false),
            ),
            child: ChangeNotifierProvider<MyViewModel>(
              create: (context) => MyViewModel(
                Provider.of<GetMyUseCase>(context, listen: false),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
