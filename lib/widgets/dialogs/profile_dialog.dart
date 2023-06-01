import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoo/models/chat_user.dart';
import 'package:demoo/screens/view_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.width * 0.6,
        height: mq.height * .35,
        child: Stack(
          children: [
            // user profile picture
            Positioned(
              top: mq.height*.075,
              left: mq.width*0.1,
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .25),
                  child: CachedNetworkImage(
                    width: mq.width * .5,
                    fit: BoxFit.cover,
                    imageUrl: user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),
            ),

            //user name 
            Positioned(
              left: mq.width*.04 ,
              top:  mq.height*.02,
              width: mq.width*0.55,
              child: Text(
                user.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            //info button
            Positioned(right: mq.width*.03   ,
              top:  mq.height*.01,

              child: Align(
                
                
                child: MaterialButton(
                    minWidth: 0,
                    padding: EdgeInsets.all(0),
                    shape: CircleBorder(),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) =>ViewProfileScreen(user: user) ));
                    },
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.black,
                      size: 25,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
