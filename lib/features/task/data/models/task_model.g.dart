// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      taskId: json['task_id'] as String,
      siteId: json['site_id'] as String?,
      siteName: json['site_name'] as String?,
      plantId: json['plant_id'] as String?,
      plantName: json['plant_name'] as String?,
      taskName: json['task_name'] as String,
      taskDescription: json['task_description'] as String?,
      taskType: json['task_type'] as String,
      taskStatus: json['task_status'] as String,
      taskPriority: json['task_priority'] as String,
      taskDueDate: json['task_due_date'] == null
          ? null
          : DateTime.parse(json['task_due_date'] as String),
      taskCompletedDate: json['task_completed_date'] == null
          ? null
          : DateTime.parse(json['task_completed_date'] as String),
      assignedTo: json['assigned_to'] as String?,
      assignedToName: json['assigned_to_name'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'task_id': instance.taskId,
      'site_id': instance.siteId,
      'site_name': instance.siteName,
      'plant_id': instance.plantId,
      'plant_name': instance.plantName,
      'task_name': instance.taskName,
      'task_description': instance.taskDescription,
      'task_type': instance.taskType,
      'task_status': instance.taskStatus,
      'task_priority': instance.taskPriority,
      'task_due_date': instance.taskDueDate?.toIso8601String(),
      'task_completed_date': instance.taskCompletedDate?.toIso8601String(),
      'assigned_to': instance.assignedTo,
      'assigned_to_name': instance.assignedToName,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'notes': instance.notes,
    };
