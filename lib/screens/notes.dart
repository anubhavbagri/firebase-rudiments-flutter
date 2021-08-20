import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_firebase/custom_widgets/snackbar.dart';
import 'package:todo_app_firebase/screens/create_note.dart';
import 'package:todo_app_firebase/screens/user_info_screen.dart';
import 'package:todo_app_firebase/services/constants.dart';
import 'package:todo_app_firebase/services/dynamic_size.dart';
import 'package:todo_app_firebase/utils/custom_colors.dart';
import 'package:todo_app_firebase/utils/database_helper.dart';
import 'package:todo_app_firebase/utils/note_modal.dart';

enum NoteQuery {
  titleAsc,
  titleDesc,
  dateAsc,
  dateDesc,
}

extension on Query<Note> {
  ///Create a firebase query from a [NoteQuery]
  Query<Note> queryBy(NoteQuery query) {
    switch (query) {
      case NoteQuery.titleAsc:
      case NoteQuery.titleDesc:
        return orderBy('title', descending: query == NoteQuery.titleDesc);
      case NoteQuery.dateAsc:
      case NoteQuery.dateDesc:
        return orderBy('dateTime', descending: query == NoteQuery.dateDesc);
    }
  }
}

class MyNotes extends StatefulWidget {
  final User? _user;
  const MyNotes({Key? key, User? user})
      : _user = user,
        super(key: key);

  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  late Stream<QuerySnapshot<Note>> _notes;
  ValueNotifier<NoteQuery> _selectedItem =
      new ValueNotifier<NoteQuery>(NoteQuery.dateAsc);
  late Query<Note> _notesQuery;

  void _updateNotesQuery(NoteQuery query) {
    setState(() {
      Database.updateNoteRef(FirebaseAuth.instance.currentUser!.uid);
      _notesQuery = Database.notesRef.queryBy(query);
      _notes = _notesQuery.snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateNotesQuery(NoteQuery.dateAsc); //sorting date in ascending order
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: DynamicSize.safeVertical! * .17,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.symmetric(
                  horizontal: DynamicSize.safeHorizontal! * .08,
                  vertical: DynamicSize.safeVertical! * .02,
                ),
                title: Text(
                  'Notes',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: CustomColors.matte,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              actions: [
                PopupMenuButton<NoteQuery>(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.sort_rounded,
                    size: 34.0,
                  ),
                  itemBuilder: (BuildContext context) {
                    return new List<PopupMenuEntry<NoteQuery>>.generate(
                      NoteQuery.values.length,
                      (int index) {
                        return new PopupMenuItem(
                          value: NoteQuery.values[index],
                          child: new AnimatedBuilder(
                            child: new Text(
                              SORT_MENU[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.matte,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            animation: _selectedItem,
                            builder: (BuildContext context, Widget? child) {
                              return new RadioListTile<NoteQuery>(
                                dense: true,
                                activeColor: CustomColors.orange,
                                value: NoteQuery.values[index],
                                groupValue: _selectedItem.value,
                                title: child,
                                onChanged: (NoteQuery? value) {
                                  _selectedItem.value = value as NoteQuery;
                                  _updateNotesQuery(value);
                                  Get.back();
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    size: 28,
                  ),
                  onPressed: () {
                    Get.to(() => UserInfoScreen(user: widget._user));
                  },
                ),
                SizedBox(
                  width: DynamicSize.safeHorizontal! * .01,
                ),
              ],
            ),
          ],
          body: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder<QuerySnapshot<Note>>(
                    stream: _notes,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Note>> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Icon(
                            FontAwesomeIcons.exclamationTriangle,
                            size: 80,
                            color: CustomColors.orange,
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                CustomColors.orange),
                          ),
                        );
                      } else if (snapshot.data!.docs.length == 0) {
                        return Center(
                          child: Text(
                            EMPTY_INFO,
                            style: TextStyle(
                                color: CustomColors.matte.withOpacity(0.3)),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: Key(snapshot.data!.docs[index].id),
                              background: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                color: Colors.transparent,
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
                                  child: Icon(
                                    Icons.delete,
                                    size: 32,
                                    color: CustomColors.orange,
                                  ),
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                Database.deleteNoteById(
                                    snapshot.data!.docs[index].id);
                                CustomSnackBar.show(
                                  'Note deleted',
                                  Icons.delete,
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: DynamicSize.safeHorizontal! * .07,
                                  vertical: DynamicSize.safeVertical! * .01,
                                ),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        /// storing document of a particular document id
                                        DocumentReference docRef = Database
                                            .notesRef
                                            .doc(snapshot.data!.docs[index].id);
                                        DocumentSnapshot<Note> docSnap =
                                            await docRef.get()
                                                as DocumentSnapshot<Note>;

                                        ///navigate to createNote screen
                                        Get.to(CreateNote(document: docSnap));
                                      },
                                      child: Container(
                                        height: DynamicSize.safeVertical! * .18,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  DynamicSize.safeHorizontal! *
                                                      .1,
                                              top: DynamicSize.safeVertical! *
                                                  .01),
                                          child: Text(
                                            snapshot.data!.docs[index]
                                                .data()
                                                .title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                  color: CustomColors.orange,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            // overflow: TextOverflow.fade,
                                            // softWrap: false,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              CustomColors.peach,
                                              CustomColors.peach,
                                              CustomColors.orange,
                                              CustomColors.orange
                                            ],
                                            stops: [0.0, 0.87, 0.87, 1.0],
                                            end: Alignment.topLeft,
                                            begin: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: DynamicSize.safeHorizontal! * .09,
                                      bottom: DynamicSize.safeVertical! * .01,
                                      child: Row(
                                        children: [
                                          Card(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${DateFormat("d MMM y").format(snapshot.data!.docs[index].data().dateTime!.toDate())}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                      color:
                                                          CustomColors.orange,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: DynamicSize.safeHorizontal! *
                                                .05,
                                          ),
                                          Text(
                                            '${DateFormat("jm").format(snapshot.data!.docs[index].data().dateTime!.toDate())}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(
                                                  color: CustomColors.orange,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.orange,
          onPressed: () {
            Get.to(CreateNote());
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
