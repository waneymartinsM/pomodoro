import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pomodoro/app/config/localization/app_localization.dart';

Future<void> showPermissionDialog(
  BuildContext context, {
  required String title,
  required String description,
  required IconData icon,
}) async {
  final theme = Theme.of(context);
  final localization = AppLocalization.of(context);
  await showDialog(
    context: context,
    builder: (_) => Center(
      child: Container(
        height: 340.h,
        width: 300.w,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 100.r,
              color: theme.colorScheme.onBackground,
            ),
            20.verticalSpace,
            Text(
              title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            10.verticalSpace,
            Text(
              description,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            10.verticalSpace,
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                localization.permissionDialogOkIUnderstand,
                style: theme.primaryTextTheme.labelLarge,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
