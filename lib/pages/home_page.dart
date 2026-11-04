import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //for safe...
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),

          //title
          const Padding(
            padding: EdgeInsets.all(AppConstants.kDefaultPadding),
            child: Text(
              "NoteSphere",
              style: AppTextStyle.headingLarge,
            ),
          ),


          //main card
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppConstants.kDefaultPadding),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Today's Progress",
                          style: AppTextStyle.headingMedium,
                        ),
                        const SizedBox(height: 10,),

                        //details
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: const Text(
                            "You have Colpleted 1 out 3 tasks keep up the progress",
                            style: AppTextStyle.bodyMedium,
                          ),
                        )
                      ],
                    ),

                    //progress circle
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.kdeepBlue,
                            AppColors.kskyBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          "33%",
                          style: AppTextStyle.progress,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //note
                Padding(
                  padding: EdgeInsets.symmetric(vertical:  AppConstants.kDefaultPadding, ),
                  child: Card(
                    
                    child: SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.41,
                      child: const Padding(
                        padding: EdgeInsets.all(AppConstants.kDefaultPadding),
                        child: Column(children: [
                          Icon(Icons.bookmark_add_outlined, 
                          size: 50, color:
                           AppColors.kamberOrange),
                                        
                           Text("Notes",
                           style: AppTextStyle.bodyLarge,),
            
                           Text("3 Notes",
                           style: AppTextStyle.bodyMedium,)
                        ],),
                      ),
                    ),
                  ),
                ),
            
                 Padding(
                  padding: EdgeInsets.symmetric(vertical:  AppConstants.kDefaultPadding),
                  child: Card(
                    
                    child: SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.41,
                      child: const Padding(
                        padding: EdgeInsets.all(AppConstants.kDefaultPadding),
                        child: Column(children: [
                          Icon(Icons.bookmark_add_outlined, 
                          size: 50, color:
                           AppColors.kamberOrange),
                                        
                           Text("Notes",
                           style: AppTextStyle.bodyLarge,),
            
                           Text("3 Notes",
                           style: AppTextStyle.bodyMedium,)
                        ],),
                      ),
                    ),
                  ),
                ),
            
                //to do List
                Card()
              ],
            ),
          )
        ],
      ),
    );
  }
}
