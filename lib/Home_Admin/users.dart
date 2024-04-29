import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<QuerySnapshot<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final usersCollection = FirebaseFirestore.instance.collection('User');
    _usersFuture = usersCollection.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.cyan,
        title: Text(
          'Users',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data!.docs;

          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final userData = users[index].data();
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    'Name: ${userData['Name']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email: ${userData['Email']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Mobile: ${userData['Mobile']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'UserId: ${userData['UID']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}