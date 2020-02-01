import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2)));

        class Constants {

          static const String SignOut = 'Sign Out';
          static const String Add = 'Ajouter';
          static const String Plan = 'Plannifier';

          static const List<String> choices = <String>[
            SignOut,
            Add,
            Plan
          ];

        }
