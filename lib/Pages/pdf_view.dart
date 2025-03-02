import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:swastik/Constant/app_color.dart';
import 'package:swastik/Controllers/items_controller.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key});

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  pw.Document? document;

  ItemController itemController = Get.find<ItemController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await itemController.methodImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "PDF View",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GetBuilder<ItemController>(
        builder: (controller) {
          return PdfPreview(
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            padding: EdgeInsets.zero,
            pdfPreviewPageDecoration:
                const BoxDecoration(color: AppColors.backgroundColor),
            pdfFileName: 'estimate.pdf',
            loadingWidget:
                const CircularProgressIndicator(color: AppColors.primaryColor),
            build: (format) {
              return generatePdf(controller);
            },
          );
        },
      ),
    );
  }

  Future<Uint8List> generatePdf(ItemController controller) async {
    final font = await PdfGoogleFonts.notoSansGujaratiRegular();
    final pdf = pw.Document();

    if (controller.selectedItems.length < 34) {
      pdf.addPage(
        pw.MultiPage(
          orientation: pw.PageOrientation.portrait,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0),
          build: (context) => [
            pw.Container(
              padding: const pw.EdgeInsets.all(2.5),
              child: pw.Expanded(
                child: pw.Container(
                  margin: pw.EdgeInsets.zero,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 0.5),
                    color: const PdfColor(0.933, 0.886, 0.745),
                  ),
                  width: double.infinity,
                  height: 835.5,
                  child: pw.Stack(
                    children: [
                      pw.Container(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Container(
                                  width: 270,
                                  height: 135,
                                  child: pw.Center(
                                    child: pw.Image(
                                      pw.MemoryImage(
                                        controller.logoImage!,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Container(
                                      width: 120,
                                      child: pw.Center(
                                        child: pw.Image(
                                          pw.MemoryImage(
                                            controller.title!,
                                          ),
                                        ),
                                      ),
                                    ),
                                    pw.SizedBox(height: 5),
                                    pw.Container(
                                      width: 320,
                                      child: pw.Center(
                                        child: pw.Image(
                                          pw.MemoryImage(
                                            controller.address!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),

                            /// INFORMATION CARD

                            headerInfo(controller),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              height: 439,
                              width: 560,
                              margin:
                                  const pw.EdgeInsets.symmetric(horizontal: 15),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.white,
                                border: pw.Border.all(color: PdfColors.black),
                                borderRadius: pw.BorderRadius.circular(20),
                              ),
                              child: pw.Stack(
                                children: [
                                  pw.Positioned(
                                    bottom: 0,
                                    top: 0,
                                    child: pw.Center(
                                      child: pw.Center(
                                        child: pw.Image(
                                          pw.MemoryImage(
                                            controller.scLogo!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Row(
                                    children: [
                                      pw.Container(
                                        width: 280,
                                        decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                            right: pw.BorderSide(
                                              color: PdfColors.black,
                                            ),
                                          ),
                                        ),
                                        child: pw.ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return pw.Row(
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: List.generate(
                                                56,
                                                (index) => pw.Container(
                                                  height: 1,
                                                  width: 2.5,
                                                  color: PdfColors.black,
                                                  margin:
                                                      const pw.EdgeInsets.only(
                                                          right: 2.5),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: 17,
                                          itemBuilder: (context, index) {
                                            return pw.Container(
                                              height: 24.8,
                                              child: controller.selectedItems
                                                          .length >
                                                      index
                                                  ? pw.Row(
                                                      children: [
                                                        pw.Padding(
                                                          padding: const pw
                                                              .EdgeInsets.only(
                                                              left: 15),
                                                          child: pw.Center(
                                                            child: pw.Text(
                                                              "${controller.selectedItems[index].categoryName} : ",
                                                              maxLines: 1,
                                                              style:
                                                                  pw.TextStyle(
                                                                color: index ==
                                                                            0 ||
                                                                        (index >
                                                                                0 &&
                                                                            controller.selectedItems[index].categoryName !=
                                                                                controller.selectedItems[index - 1].categoryName)
                                                                    ? PdfColors.black
                                                                    : PdfColors.white,
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        pw.Padding(
                                                          padding: const pw
                                                              .EdgeInsets.only(
                                                              right: 20),
                                                          child: pw.Center(
                                                            child: pw.Text(
                                                                controller
                                                                        .selectedItems[
                                                                            index]
                                                                        .name ??
                                                                    "",
                                                                maxLines: 1),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : pw.SizedBox(),
                                            );
                                          },
                                        ),
                                      ),
                                      pw.Container(
                                        width: 280,
                                        child: pw.ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return pw.Row(
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: List.generate(
                                                56,
                                                (index) => pw.Container(
                                                  height: 1,
                                                  width: 2.5,
                                                  color: PdfColors.black,
                                                  margin:
                                                      const pw.EdgeInsets.only(
                                                    right: 2.5,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: 17,
                                          itemBuilder: (context, index) {
                                            return pw.Container(
                                              height: 24.8,
                                              child: controller.selectedItems
                                                          .length >
                                                      (index + 17)
                                                  ? pw.Row(
                                                      children: [
                                                        pw.Padding(
                                                          padding: const pw
                                                              .EdgeInsets.only(
                                                              left: 15),
                                                          child: pw.Center(
                                                            child: pw.Text(
                                                              "${controller.selectedItems[(index + 17)].categoryName} : ",
                                                              maxLines: 1,
                                                              style:
                                                                  pw.TextStyle(
                                                                color: index ==
                                                                            0 ||
                                                                        (index >
                                                                                0 &&
                                                                            controller.selectedItems[(index + 17)].categoryName !=
                                                                                controller.selectedItems[(index + 17) - 1].categoryName)
                                                                    ? PdfColors.black
                                                                    : PdfColors.white,
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        pw.Padding(
                                                          padding: const pw
                                                              .EdgeInsets.only(
                                                              right: 20),
                                                          child: pw.Center(
                                                            child: pw.Text(
                                                                controller
                                                                        .selectedItems[(index +
                                                                            17)]
                                                                        .name ??
                                                                    "",
                                                                maxLines: 1),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : pw.SizedBox(),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            pw.Container(
                              margin:
                                  const pw.EdgeInsets.symmetric(horizontal: 15)
                                      .copyWith(top: 18),
                              height: 20,
                              padding: const pw.EdgeInsets.only(top: 2),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.white,
                                border: pw.Border.all(color: PdfColors.black),
                                borderRadius: pw.BorderRadius.circular(10),
                              ),
                              child: pw.Center(
                                child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Center(
                                      child: pw.Text(
                                        style: pw.TextStyle(font: font),
                                        "ડીશ ભાવ : ${controller.dishPrice.text}",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            bottomInfo(controller),
                          ],
                        ),
                      ),
                      pw.Positioned(
                        bottom: 112.5,
                        left: 0,
                        right: 0,
                        child: pw.Stack(
                          children: [
                            pw.Center(
                              child: pw.Container(
                                color: PdfColors.white,
                                width: 220,
                                height: 10,
                                margin: const pw.EdgeInsets.only(top: 7),
                              ),
                            ),
                            pw.Center(
                              child: pw.Container(
                                decoration: pw.BoxDecoration(
                                  image: pw.DecorationImage(
                                    image: pw.MemoryImage(controller.image50!),
                                  ),
                                ),
                                margin: const pw.EdgeInsets.only(top: 7),
                                width: 240,
                                height: 20,
                                child: pw.Center(
                                  child: pw.Text(
                                    ".",
                                    style: const pw.TextStyle(
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      return pdf.save();
    } else {
      pdf.addPage(
        pw.MultiPage(
          orientation: pw.PageOrientation.portrait,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0),
          build: (context) => [
            pw.Container(
              padding: const pw.EdgeInsets.all(2.5),
              child: pw.Expanded(
                child: pw.Container(
                  margin: pw.EdgeInsets.zero,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 0.5),
                    color: const PdfColor(0.933, 0.886, 0.745),
                  ),
                  width: double.infinity,
                  height: 835.5,
                  child: pw.Container(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 270,
                              height: 140,
                              child: pw.Center(
                                child: pw.Image(
                                  pw.MemoryImage(
                                    controller.logoImage!,
                                  ),
                                ),
                              ),
                            ),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Container(
                                  width: 120,
                                  child: pw.Center(
                                    child: pw.Image(
                                      pw.MemoryImage(
                                        controller.title!,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.SizedBox(height: 5),
                                pw.Container(
                                  width: 320,
                                  child: pw.Center(
                                    child: pw.Image(
                                      pw.MemoryImage(
                                        controller.address!,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),

                        /// INFORMATION CARD

                        headerInfo(controller),

                        pw.SizedBox(height: 5),
                        pw.Container(
                          height: 542,
                          width: 560,
                          margin: const pw.EdgeInsets.symmetric(horizontal: 15),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.white,
                            border: pw.Border.all(color: PdfColors.black),
                            borderRadius: pw.BorderRadius.circular(20),
                          ),
                          child: pw.Stack(
                            children: [
                              pw.Positioned(
                                bottom: 0,
                                top: 0,
                                child: pw.Center(
                                  child: pw.Center(
                                    child: pw.Image(
                                      pw.MemoryImage(
                                        controller.scLogo!,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 280,
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        right: pw.BorderSide(
                                          color: PdfColors.black,
                                        ),
                                      ),
                                    ),
                                    child: pw.ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.center,
                                          children: List.generate(
                                            56,
                                            (index) => pw.Container(
                                              height: 1,
                                              width: 2.5,
                                              color: PdfColors.black,
                                              margin: const pw.EdgeInsets.only(
                                                right: 2.5,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: 21,
                                      itemBuilder: (context, index) {
                                        return pw.Container(
                                          height: 24.8,
                                          child: controller
                                                      .selectedItems.length >
                                                  index
                                              ? pw.Row(
                                                  children: [
                                                    pw.Padding(
                                                      padding: const pw
                                                          .EdgeInsets.only(
                                                          left: 15),
                                                      child: pw.Center(
                                                        child: pw.Text(
                                                          "${controller.selectedItems[index].categoryName} : ",
                                                          maxLines: 1,
                                                          style: pw.TextStyle(
                                                            color: index == 0 ||
                                                                    (index >
                                                                            0 &&
                                                                        controller.selectedItems[index].categoryName !=
                                                                            controller.selectedItems[index - 1].categoryName)
                                                                ? PdfColors.black
                                                                : PdfColors.white,
                                                            fontWeight: pw
                                                                .FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    pw.Padding(
                                                      padding: const pw
                                                          .EdgeInsets.only(
                                                          right: 20),
                                                      child: pw.Center(
                                                        child: pw.Text(
                                                            controller
                                                                    .selectedItems[
                                                                        index]
                                                                    .name ??
                                                                "",
                                                            maxLines: 1),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : pw.SizedBox(),
                                        );
                                      },
                                    ),
                                  ),
                                  pw.Container(
                                    width: 280,
                                    child: pw.ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.center,
                                          children: List.generate(
                                            56,
                                            (index) => pw.Container(
                                              height: 1,
                                              width: 2.5,
                                              color: PdfColors.black,
                                              margin: const pw.EdgeInsets.only(
                                                right: 2.5,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: 21,
                                      itemBuilder: (context, index) {
                                        return pw.Container(
                                          height: 24.8,
                                          child: controller
                                                      .selectedItems.length >
                                                  (index + 21)
                                              ? pw.Row(
                                                  children: [
                                                    pw.Padding(
                                                      padding: const pw
                                                          .EdgeInsets.only(
                                                          left: 15),
                                                      child: pw.Center(
                                                        child: pw.Text(
                                                          "${controller.selectedItems[(index + 21)].categoryName} : ",
                                                          maxLines: 1,
                                                          style: pw.TextStyle(
                                                            color: index == 0 ||
                                                                    (index >
                                                                            0 &&
                                                                        controller.selectedItems[(index + 21)].categoryName !=
                                                                            controller.selectedItems[(index + 21) - 1].categoryName)
                                                                ? PdfColors.black
                                                                : PdfColors.white,
                                                            fontWeight: pw
                                                                .FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    pw.Padding(
                                                      padding: const pw
                                                          .EdgeInsets.only(
                                                          right: 20),
                                                      child: pw.Center(
                                                        child: pw.Text(
                                                            controller
                                                                    .selectedItems[
                                                                        (index +
                                                                            21)]
                                                                    .name ??
                                                                "",
                                                            maxLines: 1),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : pw.SizedBox(),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      if (controller.selectedItems.length > 96) {
        pdf.addPage(
          pw.MultiPage(
            orientation: pw.PageOrientation.portrait,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(0),
            build: (context) => [
              pw.Container(
                padding: const pw.EdgeInsets.all(2.5),
                child: pw.Expanded(
                  child: pw.Container(
                    margin: pw.EdgeInsets.zero,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 0.5),
                      color: const PdfColor(0.933, 0.886, 0.745),
                    ),
                    width: double.infinity,
                    height: 835.5,
                    child: pw.Container(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            height: 800,
                            width: 560,
                            margin:
                                const pw.EdgeInsets.symmetric(horizontal: 15)
                                    .copyWith(top: 20),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.white,
                              border: pw.Border.all(color: PdfColors.black),
                              borderRadius: pw.BorderRadius.circular(20),
                            ),
                            child: pw.Stack(
                              children: [
                                pw.Positioned(
                                  bottom: 0,
                                  top: 0,
                                  child: pw.Center(
                                    child: pw.Center(
                                      child: pw.Image(
                                        pw.MemoryImage(
                                          controller.scLogo!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                pw.Row(
                                  children: [
                                    pw.Container(
                                      width: 280,
                                      decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                          right: pw.BorderSide(
                                            color: PdfColors.black,
                                          ),
                                        ),
                                      ),
                                      child: pw.ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return pw.Row(
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.center,
                                            children: List.generate(
                                              56,
                                              (index) => pw.Container(
                                                height: 1,
                                                width: 2.5,
                                                color: PdfColors.black,
                                                margin:
                                                    const pw.EdgeInsets.only(
                                                  right: 2.5,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: 31,
                                        itemBuilder: (context, index) {
                                          return pw.Container(
                                            height: 24.8,
                                            child: controller
                                                        .selectedItems.length >
                                                    (index + 42)
                                                ? pw.Row(
                                                    children: [
                                                      pw.Padding(
                                                        padding: const pw
                                                            .EdgeInsets.only(
                                                            left: 15),
                                                        child: pw.Center(
                                                          child: pw.Text(
                                                            "${controller.selectedItems[(index + 42)].categoryName} : ",
                                                            maxLines: 1,
                                                            style: pw.TextStyle(
                                                              color: index ==
                                                                          0 ||
                                                                      (index >
                                                                              0 &&
                                                                          controller.selectedItems[(index + 42)].categoryName !=
                                                                              controller.selectedItems[(index + 42) - 1].categoryName)
                                                                  ? PdfColors.black
                                                                  : PdfColors.white,
                                                              fontWeight: pw
                                                                  .FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      pw.Padding(
                                                        padding: const pw
                                                            .EdgeInsets.only(
                                                            right: 20),
                                                        child: pw.Center(
                                                          child: pw.Text(
                                                              controller
                                                                      .selectedItems[
                                                                          (index +
                                                                              42)]
                                                                      .name ??
                                                                  "",
                                                              maxLines: 1),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : pw.SizedBox(),
                                          );
                                        },
                                      ),
                                    ),
                                    pw.Container(
                                      width: 280,
                                      child: pw.ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return pw.Row(
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.center,
                                            children: List.generate(
                                              56,
                                              (index) => pw.Container(
                                                height: 1,
                                                width: 2.5,
                                                color: PdfColors.black,
                                                margin:
                                                    const pw.EdgeInsets.only(
                                                  right: 2.5,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: 31,
                                        itemBuilder: (context, index) {
                                          return pw.Container(
                                            height: 24.8,
                                            child: controller
                                                        .selectedItems.length >
                                                    (index + 73)
                                                ? pw.Row(
                                                    children: [
                                                      pw.Padding(
                                                        padding: const pw
                                                            .EdgeInsets.only(
                                                            left: 15),
                                                        child: pw.Center(
                                                          child: pw.Text(
                                                            "${controller.selectedItems[(index + 73)].categoryName} : ",
                                                            maxLines: 1,
                                                            style: pw.TextStyle(
                                                              color: index ==
                                                                          0 ||
                                                                      (index >
                                                                              0 &&
                                                                          controller.selectedItems[(index + 73)].categoryName !=
                                                                              controller.selectedItems[(index + 73) - 1].categoryName)
                                                                  ? PdfColors.black
                                                                  : PdfColors.white,
                                                              fontWeight: pw
                                                                  .FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      pw.Padding(
                                                        padding: const pw
                                                            .EdgeInsets.only(
                                                            right: 20),
                                                        child: pw.Center(
                                                          child: pw.Text(
                                                              controller
                                                                      .selectedItems[
                                                                          (index +
                                                                              73)]
                                                                      .name ??
                                                                  "",
                                                              maxLines: 1),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : pw.SizedBox(),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      pdf.addPage(
        pw.MultiPage(
          orientation: pw.PageOrientation.portrait,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0),
          build: (context) => [
            pw.Container(
              padding: const pw.EdgeInsets.all(2.5),
              child: pw.Expanded(
                child: pw.Container(
                  margin: pw.EdgeInsets.zero,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 0.5),
                    color: const PdfColor(0.933, 0.886, 0.745),
                  ),
                  width: double.infinity,
                  height: 835.5,
                  child: pw.Stack(
                    children: [
                      pw.Container(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              height: 697,
                              width: 560,
                              margin:
                                  const pw.EdgeInsets.symmetric(horizontal: 15)
                                      .copyWith(top: 18),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.white,
                                border: pw.Border.all(color: PdfColors.black),
                                borderRadius: pw.BorderRadius.circular(20),
                              ),
                              child: pw.Stack(
                                children: [
                                  pw.Positioned(
                                    bottom: 0,
                                    top: 0,
                                    child: pw.Center(
                                      child: pw.Center(
                                        child: pw.Image(
                                          pw.MemoryImage(
                                            controller.scLogo!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Row(
                                    children: [
                                      pw.Container(
                                        width: 280,
                                        decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                            right: pw.BorderSide(
                                              color: PdfColors.black,
                                            ),
                                          ),
                                        ),
                                        child: pw.ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return pw.Row(
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: List.generate(
                                                56,
                                                (index) => pw.Container(
                                                  height: 1,
                                                  width: 2.5,
                                                  color: PdfColors.black,
                                                  margin:
                                                      const pw.EdgeInsets.only(
                                                    right: 2.5,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: 27,
                                          itemBuilder: (context, index) {
                                            return pw.Container(
                                              height: 24.8,
                                              child: controller.selectedItems
                                                          .length >
                                                      (index +
                                                          (controller.selectedItems
                                                                      .length >
                                                                  96
                                                              ? 104
                                                              : 43))
                                                  ? pw.Row(
                                                      children: [
                                                        pw.Padding(
                                                          padding: const pw
                                                              .EdgeInsets.only(
                                                              left: 15),
                                                          child: pw.Center(
                                                            child: pw.Text(
                                                              "${controller.selectedItems[(index + (controller.selectedItems.length > 96 ? 104 : 43))].categoryName} : ",
                                                              maxLines: 1,
                                                              style:
                                                                  pw.TextStyle(
                                                                color: index ==
                                                                            0 ||
                                                                        (index >
                                                                                0 &&
                                                                            controller.selectedItems[(index + (controller.selectedItems.length > 96 ? 104 : 43))].categoryName !=
                                                                                controller.selectedItems[(index + (controller.selectedItems.length > 96 ? 104 : 43)) - 1].categoryName)
                                                                    ? PdfColors.black
                                                                    : PdfColors.white,
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        pw.Padding(
                                                          padding: const pw
                                                              .EdgeInsets.only(
                                                              right: 20),
                                                          child: pw.Center(
                                                            child: pw.Text(
                                                                controller
                                                                        .selectedItems[(index +
                                                                            (controller.selectedItems.length > 96
                                                                                ? 104
                                                                                : 43))]
                                                                        .name ??
                                                                    "",
                                                                maxLines: 1),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : pw.SizedBox(),
                                            );
                                          },
                                        ),
                                      ),
                                      pw.Container(
                                        width: 280,
                                        child: pw.ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return pw.Row(
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: List.generate(
                                                56,
                                                (index) => pw.Container(
                                                  height: 1,
                                                  width: 2.5,
                                                  color: PdfColors.black,
                                                  margin:
                                                      const pw.EdgeInsets.only(
                                                    right: 2.5,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: 27,
                                          itemBuilder: (context, index) {
                                            return pw.Container(
                                              height: 24.8,
                                              child: controller.selectedItems
                                                          .length >
                                                      (index +
                                                          (controller.selectedItems
                                                                      .length >
                                                                  96
                                                              ? 131
                                                              : 70))
                                                  ? pw.Row(
                                                      children: [
                                                        pw.Padding(
                                                          padding: const pw
                                                              .EdgeInsets.only(
                                                              left: 15),
                                                          child: pw.Center(
                                                            child: pw.Text(
                                                              "${controller.selectedItems[(index + (controller.selectedItems.length > 96 ? 131 : 70))].categoryName} : ",
                                                              maxLines: 1,
                                                              style:
                                                                  pw.TextStyle(
                                                                color: index ==
                                                                            0 ||
                                                                        (index >
                                                                                0 &&
                                                                            controller.selectedItems[(index + (controller.selectedItems.length > 96 ? 131 : 70))].categoryName !=
                                                                                controller.selectedItems[(index + (controller.selectedItems.length > 96 ? 131 : 70)) - 1].categoryName)
                                                                    ? PdfColors.black
                                                                    : PdfColors.white,
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        pw.Padding(
                                                          padding: const pw
                                                              .EdgeInsets.only(
                                                              right: 20),
                                                          child: pw.Center(
                                                            child: pw.Text(
                                                                controller
                                                                        .selectedItems[(index +
                                                                            (controller.selectedItems.length > 96
                                                                                ? 131
                                                                                : 70))]
                                                                        .name ??
                                                                    "",
                                                                maxLines: 1),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : pw.SizedBox(),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            pw.Container(
                              margin:
                                  const pw.EdgeInsets.symmetric(horizontal: 15)
                                      .copyWith(top: 18),
                              height: 20,
                              padding: const pw.EdgeInsets.only(top: 2),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.white,
                                border: pw.Border.all(color: PdfColors.black),
                                borderRadius: pw.BorderRadius.circular(10),
                              ),
                              child: pw.Center(
                                child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Center(
                                      child: pw.Text(
                                        style: pw.TextStyle(font: font),
                                        "ડીશ ભાવ : ${controller.dishPrice.text}",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            /// PARTY"S END CARD

                            bottomInfo(controller),
                          ],
                        ),
                      ),
                      pw.Positioned(
                        bottom: 112.5,
                        left: 0,
                        right: 0,
                        child: pw.Stack(
                          children: [
                            pw.Center(
                              child: pw.Container(
                                color: PdfColors.white,
                                width: 220,
                                height: 10,
                                margin: const pw.EdgeInsets.only(top: 7),
                              ),
                            ),
                            pw.Center(
                              child: pw.Container(
                                decoration: pw.BoxDecoration(
                                  image: pw.DecorationImage(
                                    image: pw.MemoryImage(controller.image50!),
                                  ),
                                ),
                                margin: const pw.EdgeInsets.only(top: 7),
                                width: 240,
                                height: 20,
                                child: pw.Center(
                                  child: pw.Text(
                                    ".",
                                    style: const pw.TextStyle(
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      return pdf.save();
    }
  }

  pw.Container headerInfo(ItemController controller) {
    return pw.Container(
      height: 130,
      margin: const pw.EdgeInsets.symmetric(horizontal: 15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColors.black),
        borderRadius: pw.BorderRadius.circular(20),
      ),
      child: pw.Stack(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8),
            child: pw.Center(
              child: pw.Image(
                pw.MemoryImage(
                  controller.upperImage!,
                ),
              ),
            ),
          ),
          pw.Positioned(
            top: 5,
            left: 52,
            child: pw.Container(
              width: 260,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 6),
              child: infoText(controller.name.text),
            ),
          ),
          pw.Positioned(
            top: 5,
            left: 360,
            child: pw.Container(
              width: 175,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 6),
              child: infoText(controller.date.text),
            ),
          ),
          pw.Positioned(
            top: 28,
            left: 58,
            child: pw.Container(
              width: 188,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 6),
              child: infoText(controller.event.text),
            ),
          ),
          pw.Positioned(
            top: 28,
            left: 326,
            child: pw.Container(
              width: 210,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 6),
              child: infoText(controller.eventAddress.text),
            ),
          ),
          pw.Positioned(
            top: 51,
            left: 90,
            child: pw.Container(
              width: 220,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 6),
              child: infoText(controller.homeAddress.text),
            ),
          ),
          pw.Positioned(
            top: 51,
            left: 362,
            child: pw.Container(
              width: 175,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 6),
              child: infoText(controller.reference.text),
            ),
          ),
          pw.Positioned(
            top: 76,
            left: 57,
            child: pw.Container(
              width: 46,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 5.5),
              child: pw.Center(child: infoText(controller.morningDish.text)),
            ),
          ),
          pw.Positioned(
            top: 76,
            left: 140,
            child: pw.Container(
              width: 48,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 5.5),
              child: pw.Center(
                  child: infoText(controller.morningTime.text, isSmall: true)),
            ),
          ),
          pw.Positioned(
            top: 76,
            left: 230,
            child: pw.Container(
              width: 46,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 5.5),
              child: pw.Center(child: infoText(controller.afternoonDish.text)),
            ),
          ),
          pw.Positioned(
            top: 76,
            left: 318,
            child: pw.Container(
              width: 48,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 5.5),
              child: pw.Center(
                  child:
                      infoText(controller.afternoonTime.text, isSmall: true)),
            ),
          ),
          pw.Positioned(
            top: 76,
            left: 403,
            child: pw.Container(
              width: 46,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 5.5),
              child: pw.Center(child: infoText(controller.eveningDish.text)),
            ),
          ),
          pw.Positioned(
            top: 76,
            left: 490,
            child: pw.Container(
              width: 46,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 5.5),
              child: pw.Center(
                  child: infoText(controller.eveningTime.text, isSmall: true)),
            ),
          ),
          pw.Positioned(
            top: 98,
            left: 47,
            child: pw.Container(
              width: 264,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 6),
              child: infoText(controller.mobileNumber.text),
            ),
          ),
          pw.Positioned(
            top: 98,
            left: 343,
            child: pw.Container(
              width: 193,
              height: 20.5,
              padding: const pw.EdgeInsets.only(top: 6),
              child: infoText(controller.alternateMobileNumber.text),
            ),
          ),
        ],
      ),
    );
  }

  pw.Container bottomInfo(ItemController controller) {
    return pw.Container(
      height: 60,
      margin: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: pw.Stack(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8),
            child: pw.Center(
              child: pw.Image(
                pw.MemoryImage(
                  controller.bottomImage!,
                ),
              ),
            ),
          ),
          pw.Positioned(
            top: 22,
            left: 93,
            child: bottomText(controller.porch.text),
          ),
          pw.Positioned(
            top: 22,
            left: 233.2,
            child: bottomText(controller.washbasin.text),
          ),
          pw.Positioned(
            top: 22,
            left: 376,
            child: bottomText(controller.counter3.text),
          ),
          pw.Positioned(
            top: 22,
            left: 516,
            child: bottomText(controller.counter1.text),
          ),
          pw.Positioned(
            top: 40.5,
            left: 93,
            child: bottomText(controller.letters.text),
          ),
          pw.Positioned(
            top: 40.5,
            left: 233.2,
            child: bottomText(controller.elePoint.text),
          ),
        ],
      ),
    );
  }

  pw.Container bottomText(String name) {
    return pw.Container(
      height: 10.7,
      width: 28.5,
      child: pw.Center(
        child: pw.Text(
          maxLines: 1,
          name,
          style: const pw.TextStyle(fontSize: 10),
        ),
      ),
    );
  }

  pw.Text infoText(String name, {bool? isSmall}) {
    return pw.Text(
      isSmall == true ? name.toLowerCase() : name,
      maxLines: 1,
      style: const pw.TextStyle(
        fontSize: 11.5,
      ),
    );
  }
}
