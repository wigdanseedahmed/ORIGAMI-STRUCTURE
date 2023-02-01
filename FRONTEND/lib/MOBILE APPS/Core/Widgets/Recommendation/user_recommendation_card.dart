import 'package:origami_structure/imports.dart';

class UserRecommendationCardMA extends StatelessWidget {
  final UserModel? user;
  final RecommendedUserModel? recommendedUser;
  final bool? assignedTo;
  final Function()? deleteOnPressed;
  final Function()? selectedRecommendedOnPressed;
  final Function()? assignedToOnPressed;

  const UserRecommendationCardMA({
    Key? key,
    this.user,
    this.recommendedUser,
    this.assignedTo,
    this.deleteOnPressed,
    this.selectedRecommendedOnPressed,
    this.assignedToOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 20),
      child: Container(
        width: 363,
        height: 312,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Color.fromRGBO(217, 217, 217, 0.23999999463558197),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: assignedTo == false ?
                  Container()
                      : const Text(
                    "Assigned",
                    style: TextStyle(
                      fontStyle: FontStyle.italic
                    ),

                  ), /*IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz_sharp,
                      color: Color.fromRGBO(217, 217, 217, 1), //primaryColour
                      size: 50,
                    ),
                  ),*/
                ),
              ),
            ),
            SizedBox(
              height: 95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 19.0),
                    child: Container(
                      width: 95,
                      height: 95,
                      decoration: user!.userPhotoFile == null
                          ? const BoxDecoration(
                              color: Color.fromRGBO(217, 217, 217, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(95, 95)),
                            )
                          : BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(
                                  base64Decode(user!.userPhotoFile!),
                                ),
                                fit: BoxFit.fitWidth,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.elliptical(95, 95),
                              ),
                            ),
                      child: user!.userPhotoFile == null
                          ? Center(
                              child: Text(
                                "${user!.firstName![0].toUpperCase()}${user!.lastName![0].toUpperCase()}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColour//Color.fromRGBO(76, 75, 75, 1),
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25, left: 10),
                    child: SizedBox(
                      width: 180,
                      height: 95,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user!.firstName} ${user!.lastName}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Arial Black',
                                fontSize: 20,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            user!.jobTitle!,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Arial',
                                fontSize: 18,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 10),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'SCORE',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Arial',
                              fontSize: 14,
                              letterSpacing: 1,
                              fontWeight: FontWeight.normal,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: SizedBox(
                              width: 35,
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: primaryColour,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${recommendedUser!.userScorePercentage!.toStringAsFixed(2)}%',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Arial',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 285,
              height: 95,
              child: Column(
                children: <Widget>[
                  Row(
                    children:  [
                      const Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: SizedBox(
                          width: 210,
                          child: Text(
                            'Job Field',
                            textAlign: TextAlign.left,
                            style:  TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Arial',
                                fontSize: 14,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: Text(
                          recommendedUser!.userJobFieldScore == null
                              ? "- / 1.0"
                              : '${recommendedUser!.userJobFieldScore!.toStringAsFixed(1)} / 1',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color:  Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Arial',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(
                        width: 210,
                        child: Text(
                          'Job Sub-Field',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Arial',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: Text(
                            recommendedUser!.userJobSubFieldScore == null
                                ? "- / 1.0"
                                : '${recommendedUser!.userJobSubFieldScore!.toStringAsFixed(1)} / 1',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Arial',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children:  [
                      const SizedBox(
                        width: 210,
                        child:  Text(
                          'Job Specialization',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Arial',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: Text(
                            recommendedUser!.userJobSpecializationScore == 0.0
                                ? "- / 1.0"
                                : '${recommendedUser!.userJobSpecializationScore!.toStringAsFixed(1)} / 1.0',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Arial',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(
                        width: 210,
                        child: Text(
                          'Hard Skills',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Arial',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: Text(
                          recommendedUser!.totalHardSkillsScore == null
                              ? ""
                              : recommendedUser!.userHardSkillsScore == null
                              ? "- / ${recommendedUser!.totalHardSkillsScore!.toStringAsFixed(1)}"
                              : '${recommendedUser!.userHardSkillsScore!.toStringAsFixed(1)} / ${recommendedUser!.totalHardSkillsScore!.toStringAsFixed(1)}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Arial',
                            fontSize: 14,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 218,
              height: 42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 42,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Color.fromRGBO(217, 217, 217, 1),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.clear_sharp, color: Colors.redAccent),//thumb_down
                        onPressed: deleteOnPressed,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Container(
                    width: 46,
                    height: 42,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Color.fromRGBO(217, 217, 217, 1),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.remove_red_eye_sharp, color: primaryColour),
                        onPressed: selectedRecommendedOnPressed,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Container(
                    width: 46,
                    height: 42,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Color.fromRGBO(217, 217, 217, 1),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),//thumb_up
                        onPressed: assignedToOnPressed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
