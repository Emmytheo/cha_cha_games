
import 'package:cha_cha_games/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({Key? key}) : super(key: key);

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    List<Widget> _pages = <Widget>[
      GamesHomePage(),
      // AccountHomePage(),
      Center(
        child: Text(
          'Account',
          style: GoogleFonts.inter(color: Colors.white),
        ),
      ),
      Center(
        child: Text(
          'Casino',
          style: GoogleFonts.inter(color: Colors.white),
        ),
      ),
      Center(
        child: Text(
          'Settings',
          style: GoogleFonts.inter(color: Colors.white),
        ),
      ),
    ];

    return Container(
      decoration: chachaBackground(),
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 68,
                  height: 68,
                ),
              ],
            ),
            backgroundColor: chachaDarkColor(),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () {
                    // Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 3),
                child: InkWell(
                  child: Container(
                    child: Center(
                        child: Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: chachaDarkColor(),
                      // border: Border.all(color: Colors.white)
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 3),
                child: InkWell(
                  child: Container(
                    child: Center(
                        child: Text(
                      'Login',
                      style: GoogleFonts.inter(
                        // color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      // border: Border.all(color: Colors.white)
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: chachaBottomAppBarColor(),
            elevation: 0,
            iconSize: 26,
            selectedFontSize: 12,
            selectedIconTheme:
                const IconThemeData(color: Colors.white, size: 26),
            selectedItemColor: Colors.white,
            selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
            unselectedIconTheme: IconThemeData(
              color: chachaLightColor().withAlpha(125),
            ),
            unselectedItemColor: chachaLightColor().withAlpha(125),
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.casino),
                label: 'Casino',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex, //New
            onTap: _onItemTapped, //New
          ),
          // drawer: Drawer(
          //   child: Container(
          //     decoration: chachaBackground(),
          //     child: ListView(
          //       // Important: Remove any padding from the ListView.
          //       padding: EdgeInsets.zero,
          //       children: [
          //         DrawerHeader(
          //           decoration: BoxDecoration(
          //             color: chachaAppBarColor(),
          //           ),
          //           child: Center(
          //             child: Image.asset(
          //               "assets/images/logo.png",
          //               width: 128,
          //               height: 128,
          //             ),
          //           ),
          //         ),
          //         Container(
          //           margin:
          //               const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //           decoration: BoxDecoration(
          //             color: const Color.fromRGBO(246, 198, 237, 0.36),
          //             borderRadius: BorderRadius.circular(8),
          //             // boxShadow: const [
          //             //   BoxShadow(
          //             //     color: Colors.black26,
          //             //     blurRadius: 5,
          //             //     offset: Offset(0, 2),
          //             //   ),
          //             // ],
          //           ),
          //           child: ListTile(
          //             title: Text(
          //               'Item 1',
          //               style: GoogleFonts.inter(color: Colors.white),
          //             ),
          //             onTap: () {
          //               // Update the state of the app.
          //               // ...
          //             },
          //           ),
          //         ),
          //         Container(
          //           margin:
          //               const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //           decoration: BoxDecoration(
          //             color: const Color.fromRGBO(246, 198, 237, 0.36),
          //             borderRadius: BorderRadius.circular(8),
          //             // boxShadow: const [
          //             //   BoxShadow(
          //             //     color: Colors.black26,
          //             //     blurRadius: 5,
          //             //     offset: Offset(0, 2),
          //             //   ),
          //             // ],
          //           ),
          //           child: ListTile(
          //             title: Text(
          //               'Item 2',
          //               style: GoogleFonts.inter(color: Colors.white),
          //             ),
          //             onTap: () {
          //               // Update the state of the app.
          //               // ...
          //             },
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          )),
    );
  }
}

class GamesHomePage extends StatelessWidget {
  const GamesHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // SliverList(
        //     delegate: SliverChildBuilderDelegate(
        //   (BuildContext context, int index) {
        //     var name = Games[index]['name'];
        //     var type = Games[index]['type'];
        //     var route = Games[index]['route'];
        //     return Container(
        //       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //       decoration: BoxDecoration(
        //         color: chachaLightColor(),
        //         borderRadius: BorderRadius.circular(8),
        //         boxShadow: const [
        //           BoxShadow(
        //             color: Colors.black26,
        //             blurRadius: 5,
        //             offset: Offset(0, 2),
        //           ),
        //         ],
        //       ),
        //       child: ListTile(
        //         title: Text(name),
        //         subtitle: Text('Game Type: $type'),
        //         onTap: () {
        //           Navigator.pushNamed(context, route);
        //         },
        //       ),
        //     );
        //   },
        //   childCount: Games.length,
        // )),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                  child: Text(
                    "Top Winnings",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,

                        // height: 0.95,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 300.0,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 8,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: Winnings.length,
                    itemBuilder: (context, index) {
                      var total = Winnings[index]['total'];
                      var desc = Winnings[index]['desc'];
                      var route = Winnings[index]['route'];
                      var image = Winnings[index]['image'];
                      return SizedBox(
                        width: 210.0,
                        child: IntrinsicWidth(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                clipBehavior: Clip.antiAlias,
                                // margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: chachaLightColor(),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  border: const Border(
                                    bottom: BorderSide.none,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Center(
                                  child: Image.asset(
                                    image,
                                    height: 210,
                                    scale: 1,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 1, color: Colors.white),
                                  ),
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                ),
                                padding: const EdgeInsets.all(8),
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(total,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                                height: 0.95)),
                                        Text(
                                          desc,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Center(
                                              child: Text(
                                            'Play Now',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: chachaBottomAppBarColor()),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 3),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
            padding: EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 2, top: 10),
                    child: Text(
                      "Games",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,

                          // height: 0.95,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            )),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150.0,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                var name = Games[index]['name'];
                var type = Games[index]['type'];
                var route = Games[index]['route'];
                var image = Games[index]['image'];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, route);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: chachaLightColor(),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Center(
                      child: Image.asset(
                        image,
                      ),
                    ),
                  ),
                );
              },
              childCount: Games.length,
            ),
          ),
        )
      ],
    );
  }
}

class AccountHomePage extends StatelessWidget {
  const AccountHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // SliverList(
        //     delegate: SliverChildBuilderDelegate(
        //   (BuildContext context, int index) {
        //     var name = Games[index]['name'];
        //     var type = Games[index]['type'];
        //     var route = Games[index]['route'];
        //     return Container(
        //       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //       decoration: BoxDecoration(
        //         color: chachaLightColor(),
        //         borderRadius: BorderRadius.circular(8),
        //         boxShadow: const [
        //           BoxShadow(
        //             color: Colors.black26,
        //             blurRadius: 5,
        //             offset: Offset(0, 2),
        //           ),
        //         ],
        //       ),
        //       child: ListTile(
        //         title: Text(name),
        //         subtitle: Text('Game Type: $type'),
        //         onTap: () {
        //           Navigator.pushNamed(context, route);
        //         },
        //       ),
        //     );
        //   },
        //   childCount: Games.length,
        // )),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                  child: Text(
                    "Top Winnings",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,

                        // height: 0.95,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 300.0,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 8,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: Winnings.length,
                    itemBuilder: (context, index) {
                      var total = Winnings[index]['total'];
                      var desc = Winnings[index]['desc'];
                      var route = Winnings[index]['route'];
                      var image = Winnings[index]['image'];
                      return SizedBox(
                        width: 210.0,
                        child: IntrinsicWidth(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                clipBehavior: Clip.antiAlias,
                                // margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: chachaLightColor(),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  border: const Border(
                                    bottom: BorderSide.none,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Center(
                                  child: Image.asset(
                                    image,
                                    height: 210,
                                    scale: 1,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 1, color: Colors.white),
                                  ),
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                ),
                                padding: const EdgeInsets.all(8),
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(total,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                                height: 0.95)),
                                        Text(
                                          desc,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Center(
                                              child: Text(
                                            'Play Now',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: chachaBottomAppBarColor()),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 3),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
            padding: EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 2, top: 10),
                    child: Text(
                      "Games",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,

                          // height: 0.95,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            )),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150.0,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                var name = Games[index]['name'];
                var type = Games[index]['type'];
                var route = Games[index]['route'];
                var image = Games[index]['image'];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, route);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: chachaLightColor(),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Center(
                      child: Image.asset(
                        image,
                      ),
                    ),
                  ),
                );
              },
              childCount: Games.length,
            ),
          ),
        )
      ],
    );
  }
}
