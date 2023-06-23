import 'package:activitypub/APIs/activity_api.dart';
import 'package:activitypub/APIs/actor_api.dart';
import 'package:activitypub/Models/actor.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fedodo_micro/Components/PostComponents/post_head_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Components/PostComponents/user_header.dart';
import '../../Globals/general.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({
    Key? key,
    required this.appTitle,
    this.inReplyToActor,
    this.inReplyToPost,
  }) : super(key: key);

  final String appTitle;
  final String? inReplyToPost;
  final String? inReplyToActor;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  Function()? buttonFunction;
  final TextEditingController _controller = TextEditingController();

  bool emojiShowing = false;

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    List<Widget> widgets = [
      UserHeader(
        profileId: General.fullActorId,
        appTitle: widget.appTitle,
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              maxLines: null,
              onChanged: (String text) {
                setButtonFunction(text);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Here you can type and paste freely',
              ),
            ),
          ),
        ),
      ),
      Row(
        children: [
          IconButton(onPressed: (){
            setState(() {
              emojiShowing = !emojiShowing;
            });
          }, icon: const Icon(Icons.emoji_emotions))
        ],
      ),
      Offstage(
        offstage: !emojiShowing,
        child: SizedBox(
            height: height * 0.5,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji){
                setButtonFunction(_controller.text);
              },
              textEditingController: _controller,
              config: Config(
                columns: (width / 50).ceil(),
                verticalSpacing: 0,
                horizontalSpacing: 0,
                gridPadding: EdgeInsets.zero,
                initCategory: Category.RECENT,
                bgColor: const Color(0xFFF2F2F2),
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                backspaceColor: Colors.blue,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                // showRecentsTab: true,
                recentsLimit: 28,
                replaceEmojiOnLimitExceed: false,
                noRecents: const Text(
                  'No Recent',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                  textAlign: TextAlign.center,
                ),
                loadingIndicator: const SizedBox.shrink(),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
                checkPlatformCompatibility: true,
              ),
            )),
      ),
    ];

    if (widget.inReplyToActor != null) {
      ActorAPI actorProvider = ActorAPI();
      Future<Actor> actorFuture =
          actorProvider.getActor(widget.inReplyToActor!);
      widgets.insert(
        0,
        FutureBuilder<Actor>(
          future: actorFuture,
          builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = PostHeadIndicator(
                icon: FontAwesomeIcons.reply,
                text: "In reply to ${snapshot.data?.name}",
              );
            } else if (snapshot.hasError) {
              child = const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              );
            } else {
              child = const Center(
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return child;
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.xmark),
        ),
        actions: [
          ElevatedButton(
            onPressed: buttonFunction,
            child: const Text("Publish"),
          ),
        ],
      ),
      body: Column(
        children: widgets,
      ),
    );
  }

  void setButtonFunction(String text){
    if (text != "") {
      setState(() {
        buttonFunction = () {
          ActivityAPI activityHandler = ActivityAPI();
          activityHandler.post(text, widget.inReplyToPost);

          Navigator.pop(context);
        };
      });
    } else {
      setState(() {
        buttonFunction = null;
      });
    }
  }

}
