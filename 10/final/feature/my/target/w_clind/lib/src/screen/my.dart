import 'package:core_flutter_bloc/flutter_bloc.dart';
import 'package:core_util/util.dart';
import 'package:feature_community/clind.dart' hide User;
import 'package:feature_w_my/w_clind.dart';
import 'package:flutter/material.dart';
import 'package:my_domain/domain.dart';
import 'package:my_presentation/presentation.dart';
import 'package:tool_clind_component/component.dart';
import 'package:tool_clind_theme/theme.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refresh();
    });
    super.initState();
  }

  Future<void> _refresh({
    bool forceUpdate = true,
  }) async {
    await Future.wait([
      context.readFlowBloc<MyCubit>().load(),
      context.readFlowBloc<CommunityChannelListCubit>().load(forceUpdate: forceUpdate),
      context.readFlowBloc<CommunityPostListCubit>().load(forceUpdate: forceUpdate),
    ]);
  }

  Future<void> _loadMore() async {
    await context.readFlowBloc<CommunityPostListCubit>().loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.darkBlack,
      appBar: ClindAppBar(
        context: context,
        title: ClindAppBarTitle.simple(
          context,
          text: '마이페이지',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.5,
            ),
            child: ClindAppBarIconAction(
              icon: ClindIcon.logout(
                color: context.colorScheme.gray300,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: ClindDivider.horizontal(),
        ),
      ),
      body: SizedBox.expand(
        child: CoreRefreshIndicator(
          onRefresh: () => _refresh(forceUpdate: false),
          indicator: ClindIcon.restartAlt(
            color: context.colorScheme.gray600,
          ),
          child: CoreLoadMore(
            onLoadMore: () => _loadMore(),
            child: CustomScrollView(
              slivers: [
                FlowBlocBuilder<MyCubit, User>(
                  builder: (context, state) {
                    final User user = state.data ?? const User();
                    return SliverToBoxAdapter(
                      child: MyProfileCard.item(
                        user,
                        onModify: () {},
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 12.0,
                  ),
                ),
                FlowBlocBuilder<CommunityPostListCubit, List<Post>>.when(
                  loading: (context, state) => const CommunityLoadingPostCardListView(),
                  orElse: (context, state) {
                    final List<Post> items = state.data ?? [];
                    return CommunityPostCardListView(
                      items: items,
                      onChannelTapped: (item) {},
                      onCompanyTapped: (item) {},
                      onLikeTapped: (item) {},
                      onCommentTapped: (item) {},
                      onViewTapped: (item) {},
                      onTap: (item) => ICommunityRouteTo.post(
                        id: item.id,
                      ),
                      isLoadMore: state is LoadMoreState,
                    );
                  },
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 56.0 + 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
