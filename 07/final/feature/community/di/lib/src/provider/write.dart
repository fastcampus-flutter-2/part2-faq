import 'package:community_data/data.dart';
import 'package:community_domain/domain.dart';
import 'package:community_presentation/presentation.dart';
import 'package:core_util/util.dart';
import 'package:flutter/material.dart';
import 'package:tool_clind_network/network.dart';

class WriteProvider extends StatelessWidget {
  final Widget child;

  const WriteProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IPostRemoteDataSource>(
          create: (context) => PostRemoteDataSource(PostApi(Modular.get<ClindRestClient>())),
        ),
        Provider<IProfileRemoteDataSource>(
          create: (context) => ProfileRemoteDataSource(ProfileApi(Modular.get<ClindRestClient>())),
        ),
      ],
      child: Provider<WriteDataSource>(
        create: (context) => WriteDataSource(
          Provider.of<IPostRemoteDataSource>(context, listen: false),
          Provider.of<IProfileRemoteDataSource>(context, listen: false),
        ),
        child: Provider<IWriteRepository>(
          create: (context) => WriteRepository(
            Provider.of<WriteDataSource>(context, listen: false),
          ),
          child: MultiProvider(
            providers: [
              Provider<CreatePostUseCase>(
                create: (context) => CreatePostUseCase(
                  Provider.of<IWriteRepository>(context, listen: false),
                ),
              ),
              Provider<GetMyUseCase>(
                create: (context) => GetMyUseCase(
                  Provider.of<IWriteRepository>(context, listen: false),
                ),
              ),
            ],
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider<WritePostViewModel>(
                  create: (context) => WritePostViewModel(
                    Provider.of<CreatePostUseCase>(context, listen: false),
                  ),
                ),
                ChangeNotifierProvider<WriteMyViewModel>(
                  create: (context) => WriteMyViewModel(
                    Provider.of<GetMyUseCase>(context, listen: false),
                  ),
                ),
              ],
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
