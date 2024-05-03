import 'package:community_domain/domain.dart';
import 'package:community_presentation/presentation.dart';
import 'package:core_util/util.dart';
import 'package:feature_community/clind.dart';
import 'package:flutter/material.dart';
import 'package:tool_clind_component/component.dart';
import 'package:tool_clind_theme/gen/gen.dart';
import 'package:tool_clind_theme/theme.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refresh();
    });
    super.initState();
  }

  void _hideKeyboard() {
    final List<FocusNode> focusNodes = [
      FocusScope.of(context),
      FocusManager.instance.primaryFocus,
    ].whereType<FocusNode>().toList();

    for (final FocusNode focusNode in focusNodes) {
      focusNode.unfocus();
    }
  }

  Future<void> _refresh() async {
    await Future.wait([
      Provider.of<WritePostViewModel>(context, listen: false).load(),
      Provider.of<WriteMyViewModel>(context, listen: false).load(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.bg2,
      appBar: ClindAppBar(
        context: context,
        leading: ClindAppBarTextButton(
          text: '취소',
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          color: context.colorScheme.gray100,
          onTap: () => Navigator.of(context).pop(),
        ),
        leadingWidth: 56.0,
        actions: [
          Consumer<WritePostViewModel>(
            builder: (context, viewModel, child) {
              final Post post = viewModel.value ?? Post.empty();
              return ClindAppBarTextButton(
                text: '등록',
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(
                  right: 20.0,
                ),
                color: post.isActive ? ColorName.blue : context.colorScheme.gray600,
                onTap: () {
                  if (!post.isActive) return;
                  ClindDialog.showConfirm(
                    context,
                    title: "'${post.channel}'에 글을 등록하시겠습니까?",
                    onConfirm: () async {
                      await viewModel.publish();

                      Navigator.of(context).pop();

                      final Post result = viewModel.value ?? post;
                      Modular.get<EventBus>().fire(RouteEvent('/community/post?id=${result.id}'));
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => _hideKeyboard(),
        behavior: HitTestBehavior.translucent,
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    final WritePostViewModel viewModel = Provider.of<WritePostViewModel>(context, listen: false);
                    final Post post = viewModel.value ?? Post.empty();
                    viewModel.update(
                      channel: post.channel.isEmpty ? '회사생활' : '',
                    );
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    height: 38.0,
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 16.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Consumer<WritePostViewModel>(
                              builder: (context, viewModel, child) {
                                final Post post = viewModel.value ?? Post.empty();
                                return Text(
                                  post.channel.isEmpty ? '등록 위치를 선택하세요' : post.channel,
                                  style: context.textTheme.default16SemiBold.copyWith(
                                    color: context.colorScheme.gray100,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ),
                          ClindIcon.expandMore(
                            color: context.colorScheme.gray400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ClindDivider.horizontal(),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<WritePostViewModel>(
                        builder: (context, viewModel, child) {
                          final Post post = viewModel.value ?? Post.empty();
                          if (post.channel.isNotEmpty) return const SizedBox.shrink();
                          return Consumer<WriteMyViewModel>(
                            builder: (context, viewModel, child) {
                              final User user = viewModel.value ?? const User();
                              if (user.name.isEmpty) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20.0,
                                ),
                                child: Text(
                                  '작성자: ${user.name} · ${user.company}',
                                  style: context.textTheme.default12Regular.copyWith(
                                    color: context.colorScheme.gray600,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      CoreTextField(
                        cursorColor: context.colorScheme.white,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: '제목을 입력해주세요.',
                          hintStyle: context.textTheme.default17SemiBold.copyWith(
                            color: context.colorScheme.gray600,
                          ),
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        style: context.textTheme.default17SemiBold.copyWith(
                          color: context.colorScheme.gray100,
                        ),
                        keyboardAppearance: context.colorScheme.brightness,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => Provider.of<WritePostViewModel>(context, listen: false).update(
                          title: value,
                        ),
                        onSubmitted: (value) => Provider.of<WritePostViewModel>(context, listen: false).update(
                          title: value,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      CoreTextField(
                        cursorColor: context.colorScheme.white,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: '내용을 입력해주세요.',
                          hintStyle: context.textTheme.default15Medium.copyWith(
                            color: context.colorScheme.gray600,
                          ),
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        style: context.textTheme.default15Medium.copyWith(
                          color: context.colorScheme.gray100,
                        ),
                        keyboardAppearance: context.colorScheme.brightness,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (value) => Provider.of<WritePostViewModel>(context, listen: false).update(
                          content: value,
                        ),
                        onSubmitted: (value) => Provider.of<WritePostViewModel>(context, listen: false).update(
                          content: value,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.viewPaddingOf(context).bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on Post {
  bool get isActive => channel.isNotEmpty && title.isNotEmpty && content.isNotEmpty;
}
