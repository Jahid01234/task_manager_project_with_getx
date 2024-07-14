import 'package:flutter/material.dart';
import 'package:task_manager_project_with_getx/data/models/network_response.dart';
import 'package:task_manager_project_with_getx/data/models/task_model.dart';
import 'package:task_manager_project_with_getx/data/network_caller/network_caller.dart';
import 'package:task_manager_project_with_getx/data/utilities/urls.dart';
import 'package:task_manager_project_with_getx/ui/widgets/snack_bar_message.dart';


class TaskItem extends StatefulWidget {
  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  const TaskItem({
    super.key,
    required this.taskModel,
    required this.onUpdateTask,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteInProgress = false;
  bool _updateStatusInProgress = false;
  String? _selectedStatus;

  Color getStatusColor(String? status) {
    switch (status) {
      case 'Progress':
        return Colors.teal;
      case 'Completed':
        return Colors.cyan;
      case 'Cancelled':
        return Colors.deepOrange;
      default:
        return Colors.pinkAccent;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 1,
      child: ListTile(
        title:  Text(widget.taskModel.title ?? '',
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(widget.taskModel.description ?? '',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 2),
            Text(
              "Date :${widget.taskModel.createdDate ?? ''}",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label:  Text(widget.taskModel.status ?? 'New',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor:  getStatusColor(widget.taskModel.status),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                ButtonBar(
                  children: [
                    Visibility(
                      visible: _updateStatusInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: IconButton(
                        onPressed: (){
                          _showStatusUpdateDialog();
                        },
                        icon: const Icon(Icons.edit,color: Colors.greenAccent),
                      ),
                    ),

                    Visibility(
                      visible: _deleteInProgress==false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: IconButton(
                        onPressed: (){
                          _deleteTask();
                        },
                        icon: const Icon(Icons.delete,color: Colors.deepOrange),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void  _showStatusUpdateDialog(){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('New'),
              onTap: () {
                _selectedStatus = 'New';
                Navigator.pop(context);
                _updateTaskStatus();
              },
            ),
            ListTile(
              leading:const Icon(Icons.access_time_rounded),
              title: const Text('Progress'),
              onTap: () {
                _selectedStatus = 'Progress';
                Navigator.pop(context);
                _updateTaskStatus();
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outlined),
              title: const Text('Completed'),
              onTap: () {
                _selectedStatus = 'Completed';
                Navigator.pop(context);
                _updateTaskStatus();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Cancelled'),
              onTap: () {
                _selectedStatus = 'Cancelled';
                Navigator.pop(context);
                _updateTaskStatus();
              },
            ),
          ],
        );
      },
    );
  }


  //create Deleted Task api method
  Future<void> _deleteTask() async {
    _deleteInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.deleteTask(widget.taskModel.sId!));

    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Task deleted failed! Try again',
        );
      }
    }
    _deleteInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  //create Updated Task Status api method
  Future<void> _updateTaskStatus() async {
    if (_selectedStatus == null) {
      showSnackBarMessage(context, 'Please select a status to update.');
      return;
    }

    _updateStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(
      Urls.updateTaskStatus(widget.taskModel.sId!, _selectedStatus!),
    );

    if (response.isSuccess) {
      widget.onUpdateTask();
      if(mounted) {
        showSnackBarMessage(context, 'Task status updated successfully.');
      }
    } else {
      if(mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Update task status failed! Try again.');
      }
    }

    _updateStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}