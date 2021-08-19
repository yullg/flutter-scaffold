import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../bll/complaint_service.dart';
import '../../core/exceptions.dart';

class ComplainPage extends StatelessWidget {
  final String title;

  ComplainPage({Key? key, this.title = "投诉"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
      ),
      body: GetX<ComplainController>(
        builder: (controller) {
          int? selectedReasonIndex = controller._selectedReasonIndex.value;
          return ListView(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Text("请选择对应理由"),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: SmartTable<String>(
                  space: 15,
                  datas: _reasons,
                  cellBuilder: (_, data, index, info) => TextButton(
                    child: Text(data),
                    onPressed: () {
                      if (index == selectedReasonIndex) {
                        controller._selectedReasonIndex.value = null;
                      } else {
                        controller._selectedReasonIndex.value = index;
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey.shade100),
                      foregroundColor: MaterialStateProperty.all(index == selectedReasonIndex ? Get.theme.primaryColor : Colors.black),
                      side: MaterialStateProperty.all(index == selectedReasonIndex ? BorderSide(color: Get.theme.primaryColor) : null),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
                child: SmartElevatedButton(
                  child: Text("提${StringHelper.EM_SPACE_STRING}交"),
                  lockedChild: Text("提交中"),
                  onPressed: selectedReasonIndex == null
                      ? null
                      : () async {
                          try {
                            await controller._submit();
                            ToastLayer.show("投诉已收到，我们会尽快处理~");
                            if (!controller.isClosed) {
                              Get.back();
                            }
                          } catch (e) {
                            showException(e);
                          }
                        },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

const _reasons = <String>["垃圾营销", "色情低俗", "不实信息", "人身攻击", "有害信息", "违法信息", "诈骗信息", "宣扬仇恨", "涉未成年人", "其它"];

class ComplainController extends GetxController {
  final String defendant;
  final String summary;
  final String? detail;
  final _selectedReasonIndex = RxnInt();
  final _complaintService = ComplaintService();

  ComplainController({required this.defendant, required this.summary, this.detail});

  Future<void> _submit() {
    return _complaintService.post(defendant: defendant, reason: _reasons[_selectedReasonIndex.value!], summary: summary, detail: detail);
  }
}
