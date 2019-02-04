import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/view/kugou_drawer.dart';

class KuGouNavigator extends StatefulWidget {
  Widget child;

  KuGouNavigator({this.child});

  @override
  KuGouNavigatorState createState() => KuGouNavigatorState();

  static KuGouNavigatorState of(BuildContext context) {
    return context.ancestorStateOfType(TypeMatcher<KuGouNavigatorState>());
  }
}

class KuGouNavigatorState extends State<KuGouNavigator> {
  // 想根据Navigator的栈数量来判断是否在首页，而进行禁止侧滑菜单的功能，但是Navigator的栈_history是私有属性，不能获取，故在这里手动记录栈数
  int currentNavigatorStack = 0;
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState.canPop()) {
          _navigatorKey.currentState.pop();
          return false;
        }
        return true;
      },
      child: Navigator(
        key: _navigatorKey,
        observers: [
          KuGouNavigatorObserver(onChange: (val) {
            if (currentNavigatorStack == 0) {
              currentNavigatorStack += val;
            } else {
              currentNavigatorStack += val;
              // 根据栈数绝对是否禁止侧滑菜单
              KuGouDrawerNotification(drawerEnable: currentNavigatorStack <= 1)
                  .dispatch(context);
            }
          }),
        ],
        onGenerateRoute: (RouteSettings settings) =>
            MaterialPageRoute(builder: (context) => widget.child),
      ),
    );
  }

  Future push(Widget widget) {
    return _navigatorKey.currentState.push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (buildContext, child) {
              return Transform.translate(
                offset: Offset(MediaQuery.of(context).size.width - animation.value * MediaQuery.of(context).size.width, 0),
                child: widget,
              );
            },
          );
        },
      )
    );
  }

  bool pop<T extends Object>([T result]) {
    return _navigatorKey.currentState.pop(result);
  }
}

class KuGouNavigatorObserver with NavigatorObserver {
  KuGouNavigatorObserver({this.onChange});

  ValueChanged<int> onChange;

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    if (onChange != null) onChange(-1);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if (onChange != null) onChange(1);
  }
}
