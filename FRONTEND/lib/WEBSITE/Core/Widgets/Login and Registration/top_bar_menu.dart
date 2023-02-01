import 'package:origami_structure/imports.dart';

class TopBarMenuWS extends StatelessWidget {
  const TopBarMenuWS({
    Key? key,
    required this.isLoginOrRegistration,
    required this.isSelectedPage,
  }) : super(key: key);

  final String isLoginOrRegistration;
  final String isSelectedPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              topBarMenuItemsWS(
                context: context,
                title: 'Home',
                isActive: isSelectedPage == 'Home' ? true : false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const HomeScreenWS();
                      },
                    ),
                  );
                },
              ),
              topBarMenuItemsWS(
                context: context,
                title: 'About us',
                isActive: isSelectedPage == 'About us' ? true : false,

                //TODO: ADD ABOUT US
              ),
              topBarMenuItemsWS(
                context: context,
                title: 'Contact us',
                isActive: isSelectedPage == 'Contact us' ? true : false,

                //TODO: ADD CONTACT US
              ),
              topBarMenuItemsWS(
                context: context,
                title: 'Help',
                isActive: isSelectedPage == 'Help' ? true : false,

                //TODO: ADD HELP
              ),
            ],
          ),
          Row(
            children: [
              topBarMenuItemsWS(
                context: context,
                title: 'Sign In',
                isActive: isLoginOrRegistration == "Login" ? true : false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreenWS();
                      },
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const RegistrationScreenWS();
                      },
                    ),
                  );
                },
                child: registerButton(context, isLoginOrRegistration == "Registration" ? true : false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TopBarMenuAfterLoginWS extends StatelessWidget {
  const TopBarMenuAfterLoginWS({
    Key? key,
    required this.isSelectedPage,
    required this.user,
  }) : super(key: key);

  final String isSelectedPage;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              topBarMenuItemsWS(
                context: context,
                title: 'Home',
                isActive: isSelectedPage == 'Home' ? true : false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const HomeScreenWS();
                      },
                    ),
                  );
                },
              ),
              topBarMenuItemsWS(
                context: context,
                title: 'Weekly Report',
                isActive: isSelectedPage == 'Weekly Report' ? true : false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const WeeklyTaskReportScreenWS();
                      },
                    ),
                  );
                },
              ),
              topBarMenuItemsWS(
                context: context,
                title: 'Projects',
                isActive: isSelectedPage == 'Projects' ? true : false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ProjectScreenWS();
                      },
                    ),
                  );
                },
              ),
              topBarMenuItemsWS(
                context: context,
                title: 'Notifications',
                isActive: isSelectedPage == 'Notifications' ? true : false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CardScreen(cardName: "Card 1",card: TaskModel());
                      },
                    ),
                  );
                },
                //TODO: ADD HELP
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingsScreenWS();
                  },
                ),
              );
            },
            child: Row(
              children: [
                user.userPhotoFile == null
                    ? Container(
                  height: 20,
                  width: 320,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(202, 202, 202, 1),
                    borderRadius: BorderRadius.all(
                        Radius.circular(MediaQuery.of(context).size.width * 0.2)),
                  ),
                  child: Center(
                    child: Text(
                      "${user.firstName![0]}${user.lastName![0]}",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(76, 75, 75, 1),
                      ),
                    ),
                  ),
                )
                    : CircleAvatar(
                  backgroundImage: MemoryImage(
                    base64Decode(user.userPhotoFile!),
                  ),
                  radius: 20,
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.008),
                Center(
                  child: Text(
                    "${user.firstName!} ${user.lastName!}",
                    style: const TextStyle(
                      // fontSize: MediaQuery.of(context).size.width / 75,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey ,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
