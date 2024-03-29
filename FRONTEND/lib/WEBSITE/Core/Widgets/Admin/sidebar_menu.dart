import 'package:origami_structure/imports.dart';

class SideBarMenuWS extends StatefulWidget
{
  @override
  _SideBarMenuWSState createState() => _SideBarMenuWSState();
}

class _SideBarMenuWSState extends State<SideBarMenuWS> with SingleTickerProviderStateMixin
{
  double maxWidth = 250;
  double minWidgth = 70;
  bool collapsed = false;
  int selectedIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState()
  {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _animation = Tween<double>(begin: maxWidth, end: minWidgth).animate(_animationController);
  }

  @override
  Widget build(BuildContext context)
  {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child)
      {
        return Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 2)
            ],
            color: drawerBgColor,
          ),
          width: _animation.value,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    image: const DecorationImage(
                      image: NetworkImage(
                          'https://backgrounddownload.com/wp-content/uploads/2018/09/google-material-design-background-6.jpg'),
                      fit: BoxFit.cover,
                    )),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: const NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI4JuatGP6M5_Q0wYSkx2jAVzJff1FBaPYXV7zFbMngh5RV6J7'),
                            backgroundColor: Colors.white,
                            radius: _animation.value >= 250 ? 30 : 20,
                          ),
                          SizedBox(
                            width: _animation.value >= 250 ? 20 : 0,
                          ),
                          (_animation.value >= 250)
                              ? Text('Atharva Kulkarni',
                                  style: menuListTileDefaultText)
                              : Container(),
                        ],
                      ),
                      SizedBox(
                        height: _animation.value >= 250 ? 20 : 0,
                      ),
                      const Spacer(),
                      (_animation.value >= 250)
                          ? const Text(
                              'Atharva Kulkarni',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Container(),
                      (_animation.value >= 250)
                          ? const Text(
                              'atharvakulkarni2204@gmail.com',
                              style:  TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, counter)
                  {
                    return const Divider(
                      height: 2,
                    );
                  },
                  itemCount: menuItems.length,
                  itemBuilder: (BuildContext context, int index)
                  {
                    return MenuItemTileWS(
                      title: menuItems[index].title!,
                      icon: menuItems[index].icon!,
                      animationController: _animationController,
                      isSelected: selectedIndex == index,
                      onTap: ()
                      {
                        setState(()
                        {
                          selectedIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),
              InkWell(
                onTap: ()
                {
                  setState(()
                  {
                    collapsed = !collapsed;
                    collapsed ? _animationController.reverse() : _animationController.forward();
                  });
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.close_menu,
                  progress: _animationController,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );
  }
}

///------------------------------------------------- COMPONENTS -------------------------------------------------///

class Menu
{
  String? title;
  IconData? icon;

  Menu({this.title, this.icon});
}

List<Menu> menuItems =
[
  Menu(title: 'Dashboard', icon: Icons.dashboard),
  Menu(title: 'Notifications', icon: Icons.notification_important),
  Menu(title: 'Web UI', icon: Icons.web),
  Menu(title: 'Charts', icon: Icons.insert_chart),
];