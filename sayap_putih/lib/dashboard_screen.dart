import 'package:sayap_putih/buku/list_buku.dart';
import 'package:sayap_putih/genre/list_genre.dart';
import 'package:sayap_putih/member/list_member.dart';
import 'package:sayap_putih/pengarang/list_pengarang.dart';
import 'package:sayap_putih/profile/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'transition_route_observer.dart';
import 'widgets/fade_in.dart';
import 'widgets/round_button.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/')
    // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  AnimationController? _loadingController;
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _page = 0;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
          parent: _loadingController!,
          curve: headerAniInterval,
        ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context) as PageRoute<dynamic>?);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: theme.accentColor,
      icon: const Icon(
        FontAwesomeIcons.userCircle,
        size: 35.0,
      ),
      onPressed: () {},
    );
    final signOutBtn = IconButton(
      icon: const Icon(
        FontAwesomeIcons.signOutAlt,
        size: 35.0
      ),
      color: theme.accentColor,
      onPressed: () => _goToLogin(context),
    );
    final title = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          HeroText(
            'Sayap Putih',
            tag: 'Sayap Putih',
            viewState: ViewState.shrunk,
            style: LoginThemeHelper.loginTextStyle,
          ),
          SizedBox(width: 20),
        ],
      ),
    );

    return AppBar(
      leading: FadeIn(
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.startToEnd,
        child: menuBtn,
      ),
      actions: <Widget>[
        FadeIn(
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
          child: signOutBtn,
        ),
      ],
      title: title,
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }


  Widget _buildButton(
      {Widget? icon, String? label, required Interval interval, required VoidCallback onPressed}) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: ElasticOutCurve(0.42),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildDashboardGrid() {
    const step = 0.04;
    const aniInterval = 0.75;

    return GridView.count(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 20,
      ),
      childAspectRatio: .9,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        _buildButton(
          icon: Icon(FontAwesomeIcons.bookmark),
          label: 'Genre',
          interval: Interval(0, aniInterval),
          onPressed: () {  
            Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context)=> GenreList())
            );
        },
        ),
        _buildButton(
          icon: Container(
            // fix icon is not centered like others for some reasons
            padding: const EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: Icon(
              FontAwesomeIcons.user,
              size: 20,
            ),
          ),
          label: 'Pengarang',
          onPressed: () {  
            Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context)=> PengarangList())
            );
        },
          interval: Interval(step, aniInterval + step),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.book),
          label: 'Buku',
          interval: Interval(step * 2, aniInterval + step * 2),
           onPressed: () {  
            Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context)=> BukuList())
            );
        },
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.userAlt),
          label: 'Member',
          interval: Interval(0, aniInterval),
           onPressed: () {  
            Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context)=> MemberList())
            );
        },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor.withOpacity(.1),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: ScaleTransition(
                      scale: _headerScaleAnimation,
                        child: FadeIn(
                          controller: _loadingController,
                          curve: headerAniInterval,
                          fadeDirection: FadeDirection.bottomToTop,
                          offset: .5,
                          child: Padding( 
                            padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            top: 30.0,
                          ),
                            child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                               ProfileDetail()
                            ],
                          ),
                        )),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: ShaderMask(
                        // blendMode: BlendMode.srcOver,
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            tileMode: TileMode.clamp,
                            colors: <Color>[
                              Colors.deepPurpleAccent.shade100,
                              Colors.deepPurple.shade100,
                              Colors.deepPurple.shade100,
                              Colors.deepPurple.shade100
                            ],
                          ).createShader(bounds);
                        },
                        child: _buildDashboardGrid(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            height: 60.0,
            index: _page,
            backgroundColor: Colors.deepPurple,
            items: <Widget>[
               Column(
                children: <Widget>[
                  Icon(Icons.home, size: 20),
                  Text('Home')
                ],
              )
            ],
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            animationCurve: Curves.easeInOut,
            onTap: (index) {
              setState(() {
                _page = index;
              });
              //Handle button tap
            },
          ),
        ),
      ),
    );
  }
}