import 'package:origami_structure/imports.dart';

final reactionsList = [
  Reaction<String>(
    value: null,
    previewIcon: _buildReactionsPreviewIcon('assets/emojis/thumbs_up.png'),
    icon: _buildReactionsIcon(
        'assets/emojis/thumbs_up.png'
    ),
  ),
  Reaction<String>(
    value: null,
    previewIcon: _buildReactionsPreviewIcon('assets/emojis/love.png'),
    icon: _buildReactionsIcon(
        'assets/emojis/love.png'
    ),
  ),
  Reaction<String>(
    value: null,
    previewIcon: _buildReactionsPreviewIcon('assets/emojis/happy.png'),
    icon: _buildReactionsIcon(
      'assets/emojis/happy.png'
    ),
  ),
  Reaction<String>(
    value: null,
    previewIcon: _buildReactionsPreviewIcon('assets/emojis/surprised.png'),
    icon: _buildReactionsIcon(
        'assets/emojis/surprised.png'
    ),
  ),
  Reaction<String>(
    value: null,
    previewIcon: _buildReactionsPreviewIcon('assets/emojis/sad.jpg'),
    icon: _buildReactionsIcon(
      'assets/emojis/sad.jpg'
    ),
  ),
  Reaction<String>(
    value: null,
    previewIcon: _buildReactionsPreviewIcon('assets/emojis/mad.png'),
    icon: _buildReactionsIcon(
      'assets/emojis/mad.png'
    ),
  ),
];
Padding _buildReactionsPreviewIcon(String path) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
    child: Image.asset(path, height: 40),
  );
}

Container _buildReactionsIcon(String path) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, height: 20),
      ],
    ),
  );
}