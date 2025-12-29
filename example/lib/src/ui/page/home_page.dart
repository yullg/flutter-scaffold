import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

import 'scaffold/plugin/android/android_audio_record_page.dart';
import 'scaffold/plugin/android/basic_page.dart';
import 'scaffold/plugin/android/content_resolver_page.dart';
import 'scaffold/plugin/android/intent_page.dart';
import 'scaffold/plugin/android/media_projection_page.dart';
import 'scaffold/plugin/android/media_store_page.dart';
import 'scaffold/plugin/android/notification_page.dart';
import 'scaffold/ui/popup/loading_page.dart';
import 'scaffold/ui/widget/polymorphic_text_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    ScaffoldConfig.apply(
      messengerOption: ScaffoldMessengerOption(
        errorStyle: FunctionSupplier((context) => SnackBarMessageStyle(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
              showCloseIcon: true,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scaffold example app'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          TreeSliver<TreeSliverNodeContent>(
            tree: [
              TreeSliverNode(
                TreeSliverNodeContent(name: "scaffold"),
                children: [
                  TreeSliverNode(
                    TreeSliverNodeContent(name: "plugin"),
                    children: [
                      TreeSliverNode(
                        TreeSliverNodeContent(
                          name: "basic",
                          onClick: () => to(context, const BasicPage()),
                        ),
                      ),
                      TreeSliverNode(
                        TreeSliverNodeContent(name: "android"),
                        children: [
                          TreeSliverNode(
                            TreeSliverNodeContent(
                              name: "intent",
                              onClick: () => to(context, const IntentPage()),
                            ),
                          ),
                          TreeSliverNode(
                            TreeSliverNodeContent(
                              name: "media_store",
                              onClick: () => to(context, const MediaStorePage()),
                            ),
                          ),
                          TreeSliverNode(
                            TreeSliverNodeContent(
                              name: "content_resolver",
                              onClick: () => to(context, const ContentResolverPage()),
                            ),
                          ),
                          TreeSliverNode(
                            TreeSliverNodeContent(
                              name: "notification",
                              onClick: () => to(context, const NotificationPage()),
                            ),
                          ),
                          TreeSliverNode(
                            TreeSliverNodeContent(
                              name: "media_projection",
                              onClick: () => to(context, const MediaProjectionPage()),
                            ),
                          ),
                          TreeSliverNode(
                            TreeSliverNodeContent(
                              name: "android_audio_record",
                              onClick: () => to(context, const AndroidAudioRecordPage()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TreeSliverNode(TreeSliverNodeContent(name: "ui"), children: [
                    TreeSliverNode(
                      TreeSliverNodeContent(name: "popup"),
                      children: [
                        TreeSliverNode(
                          TreeSliverNodeContent(
                            name: "loading",
                            onClick: () => to(context, const LoadingPage()),
                          ),
                        ),
                      ],
                    ),
                    TreeSliverNode(
                      TreeSliverNodeContent(name: "widget"),
                      children: [
                        TreeSliverNode(
                          TreeSliverNodeContent(
                            name: "polymorphic_text",
                            onClick: () => to(context, const PolymorphicTextPage()),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
            ],
            treeNodeBuilder: _treeNodeBuilder,
          ),
        ],
      ),
    );
  }

  Widget _treeNodeBuilder(
    BuildContext context,
    TreeSliverNode<Object?> node,
    AnimationStyle toggleAnimationStyle,
  ) {
    final Duration animationDuration = toggleAnimationStyle.duration ?? TreeSliver.defaultAnimationDuration;
    final Curve animationCurve = toggleAnimationStyle.curve ?? TreeSliver.defaultAnimationCurve;
    final int index = TreeSliverController.of(context).getActiveIndexFor(node)!;
    return InkWell(
      onTap: () {
        TreeSliverController.of(context).toggleNode(node);
        if (node.content is TreeSliverNodeContent) {
          (node.content as TreeSliverNodeContent).onClick?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            SizedBox.square(
              dimension: 30.0,
              child: node.children.isNotEmpty
                  ? AnimatedRotation(
                      key: ValueKey<int>(index),
                      turns: node.isExpanded ? 0.25 : 0.0,
                      duration: animationDuration,
                      curve: animationCurve,
                      child: const Icon(IconData(0x25BA), size: 14),
                    )
                  : null,
            ),
            const SizedBox(width: 8.0),
            Text(node.content.toString()),
          ],
        ),
      ),
    );
  }

  Future<T?> to<T>(BuildContext context, Widget page) => Navigator.push<T>(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
}

class TreeSliverNodeContent {
  final String name;
  final VoidCallback? onClick;

  TreeSliverNodeContent({
    required this.name,
    this.onClick,
  });

  @override
  String toString() => name;
}
