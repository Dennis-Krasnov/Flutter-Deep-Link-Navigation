import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_base_route/deep_links.dart';
import 'package:single_base_route/model.dart';

final bankAccounts = [BankAccount(id: "123", name: "Debit card", balance: 234.42)];

class BankAccountListScreen extends StatelessWidget {
  final String title;
  BankAccountListScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Provider.of<DeepLinkNavigator>(context, listen: false).push(SettingsDL()),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bankAccounts.length,
        itemBuilder: (BuildContext context, int index) {
          final bankAccount = bankAccounts[index];
          return ListTile(
            title: Text(bankAccount.name),
            onTap: () => null,
          );
        }
      ),
    );
  }
}