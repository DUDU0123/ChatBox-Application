import 'package:chatbox/core/enums/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UploadedStatusEntity extends Equatable {
  final StatusType? statusType;
  final String? statusCaption;
  final String? statusContent;
  final String? statusUploadedTime;
  final String? statusDuration;
  final bool? isViewedStatus;
  final Color? textStatusBgColor;
  const UploadedStatusEntity({
    this.statusType,
    this.statusCaption,
    this.statusContent,
    this.statusUploadedTime,
    this.statusDuration,
    this.textStatusBgColor,
    this.isViewedStatus,
  });

  @override
  List<Object?> get props => [
        statusType,
        statusCaption,
        statusContent,
        statusUploadedTime,
        statusDuration,
        isViewedStatus,
        textStatusBgColor,
      ];
}

