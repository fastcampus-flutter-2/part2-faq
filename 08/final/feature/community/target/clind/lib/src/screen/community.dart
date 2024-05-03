import 'dart:async';

import 'package:community_domain/domain.dart';
import 'package:core_flutter_bloc/flutter_bloc.dart';
import 'package:core_util/util.dart';
import 'package:feature_community/clind.dart';
import 'package:flutter/material.dart';
import 'package:tool_clind_component/component.dart';
import 'package:tool_clind_theme/theme.dart';

enum CommunityTabType {
  normal(title: '홈'),
  popular(title: '인기');

  final String title;

  const CommunityTabType({
    required this.title,
  });

  static String encode(CommunityTabType value) => value.name;

  static CommunityTabType decode(String value) => CommunityTabType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => CommunityTabType.normal,
      );
}

class CommunityScreen extends StatefulWidget {
  final CommunityTabType type;

  const CommunityScreen({
    super.key,
    required this.type,
  });

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
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
    switch (widget.type) {
      case CommunityTabType.normal:
        await Future.wait([
          context.readFlowBloc<CommunityChannelListCubit>().load(forceUpdate: forceUpdate),
          context.readFlowBloc<CommunityPostListCubit>().load(forceUpdate: forceUpdate),
        ]);
      case CommunityTabType.popular:
        await Future.wait([
          context.readFlowBloc<CommunityPopularChannelListCubit>().load(forceUpdate: forceUpdate),
          context.readFlowBloc<CommunityPopularPostListCubit>().load(forceUpdate: forceUpdate),
        ]);
    }
  }

  Future<void> _loadMore() async {
    switch (widget.type) {
      case CommunityTabType.normal:
        await context.readFlowBloc<CommunityPostListCubit>().loadMore();
      case CommunityTabType.popular:
        await context.readFlowBloc<CommunityPopularPostListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.darkBlack,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: context.appBarTheme.backgroundColor,
              scrolledUnderElevation: 0,
              floating: true,
              snap: true,
              leading: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: ClindIcon.logoSmall(),
                ),
              ),
              leadingWidth: 55.0,
              title: ClindSearchBar(
                text: '관심 있는 글 검색',
                onTap: () => Modular.get<EventBus>().fire(RouteEvent('/search')),
              ),
              titleSpacing: 0.0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 6.5,
                    right: 8.5,
                  ),
                  child: ClindAppBarIconAction(
                    icon: ClindIcon.sms(
                      color: context.colorScheme.white,
                    ),
                  ),
                ),
              ],
            ),
          ];
        },
        body: CoreRefreshIndicator(
          onRefresh: () => _refresh(forceUpdate: false),
          indicator: ClindIcon.restartAlt(
            color: context.colorScheme.gray600,
          ),
          child: CoreLoadMore(
            onLoadMore: () => _loadMore(),
            child: CustomScrollView(
              key: PageStorageKey<String>('$CommunityTabType${widget.type}'),
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                          bottom: 9.0,
                        ),
                        child: SizedBox(
                          height: 33.0,
                          child: Builder(
                            builder: (context) {
                              switch (widget.type) {
                                case CommunityTabType.normal:
                                  return FlowBlocBuilder<CommunityChannelListCubit, List<Channel>>.when(
                                    loading: (context, state) => const CommunityLoadingChannelListView(),
                                    orElse: (context, state) {
                                      final List<Channel> items = state.data ?? [];
                                      return CommunityChannelListView(
                                        items: items,
                                        onTap: (item) {},
                                      );
                                    },
                                  );
                                case CommunityTabType.popular:
                                  return FlowBlocBuilder<CommunityPopularChannelListCubit, List<Channel>>.when(
                                    loading: (context, state) => const CommunityLoadingChannelListView(),
                                    orElse: (context, state) {
                                      final List<Channel> items = state.data ?? [];
                                      return CommunityChannelListView(
                                        items: items,
                                        onTap: (item) {},
                                      );
                                    },
                                  );
                              }
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Builder(
                          builder: (context) {
                            switch (widget.type) {
                              case CommunityTabType.normal:
                                return FlowBlocBuilder<CommunityChannelListCubit, List<Channel>>.when(
                                  loading: (context, state) => const CommunityLoadingAllChannelButton(),
                                  orElse: (context, state) => CommunityAllChannelButton(
                                    onTap: () {},
                                  ),
                                );
                              case CommunityTabType.popular:
                                return FlowBlocBuilder<CommunityPopularChannelListCubit, List<Channel>>.when(
                                  loading: (context, state) => const CommunityLoadingAllChannelButton(),
                                  orElse: (context, state) => CommunityAllChannelButton(
                                    onTap: () {},
                                  ),
                                );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: ClindSortFilter(
                      text: '최신순',
                      onTap: () {},
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 9.0,
                  ),
                ),
                Builder(
                  builder: (context) {
                    switch (widget.type) {
                      case CommunityTabType.normal:
                        return FlowBlocBuilder<CommunityPostListCubit, List<Post>>.when(
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
                        );
                      case CommunityTabType.popular:
                        return FlowBlocBuilder<CommunityPopularPostListCubit, List<Post>>.when(
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
                        );
                    }
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
