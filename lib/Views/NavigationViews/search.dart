import 'package:fedodo_micro/APIs/webfinger_api.dart';
import 'package:fedodo_micro/Views/NavigationViews/profile.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  Search({
    Key? key,
    required this.appTitle,
  }) : super(key: key);

  final searchTextEditingController = TextEditingController();
  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: searchTextEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                onPressed: () async {

                  String input = searchTextEditingController.text;

                  if(input.contains("@")){

                    WebfingerApi webfingerApi = WebfingerApi();
                    String profileId = await webfingerApi.getUser(input);

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        reverseTransitionDuration:
                        const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, animation2) => Profile(
                          appTitle: appTitle,
                          profileId: profileId,
                          showAppBar: true,
                        ),
                        transitionsBuilder:
                            (context, animation, animation2, widget) =>
                            SlideTransition(
                                position: Tween(
                                  begin: const Offset(1.0, 0.0),
                                  end: const Offset(0.0, 0.0),
                                ).animate(animation),
                                child: widget),
                      ),
                    );
                  }

                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
