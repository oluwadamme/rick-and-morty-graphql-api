import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/src/models/responsive.dart';
import 'package:rickandmorty/src/view_model/home_view_model.dart';
import 'package:rickandmorty/src/views/character_card.dart';
import 'package:rickandmorty/src/views/character_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      var provider = Provider.of<HomeViewModel>(context, listen: false);

      provider.getCharacter(page: 0).then((value) => provider.result = value);
    });
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeViewModel>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: provider.info?.prev == null
              ? const Text('Character List Page 1')
              : Text('Character List Page ${provider.info?.prev + 1}'),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return Stack(
            children: [
              provider.result.isNotEmpty
                  ?  Responsive(
          mobile: CharacterView(provider: provider, crossAxisCount: orientation == Orientation.portrait ? 1 : 2, orientation:orientation,childAspectRatio: orientation == Orientation.portrait ? 2.1 : 2,),
          desktop: CharacterView(provider: provider, orientation:orientation),
          tablet: CharacterView(provider: provider, crossAxisCount: orientation == Orientation.portrait ? 1 : 2, orientation:orientation,childAspectRatio: 1.1),
          mobileLarge: CharacterView(provider: provider, crossAxisCount: orientation == Orientation.portrait ? 1 : 2, orientation:orientation,childAspectRatio: orientation == Orientation.portrait ? 2.1 : 2,),
        )
                  
                  : const Center(child: CircularProgressIndicator()),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    width: size.width * 0.8,
                    height: size.height * 0.07,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            child: const Icon(
                              Icons.backspace,
                              color: Colors.white,
                            ),
                            onTap: () async {
                              if (provider.info?.prev == null) {
                                provider.result.clear();
                                await provider.getCharacter(page: 0);
                              } else {
                                provider.result.clear();
                                await provider.getCharacter(
                                    page: provider.info?.prev);
                              }
                            }),
                        GestureDetector(
                            child: const Icon(
                              Icons.forward,
                              color: Colors.white,
                            ),
                            onTap: () async {
                              provider.result.clear();
                              await provider.getCharacter(
                                  page: provider.info?.next);
                            })
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }));
  }
}

