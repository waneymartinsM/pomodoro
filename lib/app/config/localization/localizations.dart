import 'package:flutter/material.dart';
import 'package:persian/persian.dart';
import 'package:pomodoro/app/config/localization/app_localization_data.dart';
import 'package:pomodoro/app/utils/extensions/extensions.dart';

const englishLocale = Locale('en', 'US');
const portugueseLocale = Locale('pt', 'BR');

const supportedLocales = [englishLocale, portugueseLocale];

AppLocalizationData get englishLocalization => AppLocalizationData(
      locale: englishLocale,
      fontFamily: 'Poppins',
      appName: 'Pomodoro',
      convertNumber: (number) => number,
      convertDateToString: (date) => date.convertToDateString,
      // tasks screen
      tasksScreenTitle: 'Tasks',
      tasksScreenAll: 'All',
      tasksScreenDone: 'Done',
      tasksScreenRemain: 'Remain',
      tasksScreenNoDoneTasksTitle: 'No Done Task',
      tasksScreenNoDoneTasksDescription: 'You have no done task yet',
      tasksScreenNoTasksTitle: 'You Have No Task!',
      tasksScreenNoTasksDescription:
          'Please add some task by using below add button.',
      tasksScreenNoRemainedTasksTitle: 'Good job! All Done',
      tasksScreenNoRemainedTasksDescription:
          'congratulation, you done all today tasks.',
      tasksScreenError: 'Something went wrong.',
      tasksScreenLongBreakTimePrefix: 'LB',
      tasksScreenShortBreakTimePrefix: 'SB',
      tasksScreenWorkTimePrefix: 'W',
      tasksScreenTimeSuffix: 'm',
      tasksScreenDelete: 'Delete',
      tasksScreenEdit: 'Edit',
      // home screen
      baseScreenHome: 'Home',
      baseScreenCalendar: 'Calendar',
      permissionDialogOkIUnderstand: 'Ok,I understand',
      permissionDialogNotificationTitle: 'Show Notification Permission',
      permissionDialogNotificationDescription:
          'Enable notification so you can see timer status when app closed.',

      // calendar screen
      calendarScreenCompleted: 'completed',
      calendarScreenUncompleted: 'uncompleted',
      calendarScreenTitle: 'Calendar',
      calendarScreenEmptyListTitle: 'Empty List!',
      calendarScreenEmptyListDescription: 'You have no recorded task yet',
      calendarScreenNoRecordedTasksFound:
          'There are no recorded task for selected date.',
      calendarScreenError: 'Something went wrong.',
      calendarScreenTimeSuffix: (date) => date.hour > 11 ? ' PM' : ' AM',
      //add pomodoro screen
      addPomodoroScreenAddTitle: 'Add New Task',
      addPomodoroScreenEditTitle: 'Edit Task',
      addPomodoroScreenAddButton: 'Add New Task',
      addPomodoroScreenEditButton: 'Save Task',
      addPomodoroScreenRounds: 'Rounds',
      addPomodoroScreenIntervals: 'Intervals',
      addPomodoroScreenWorkIntervals: 'Work Interval',
      addPomodoroScreenShortBreak: 'Short Break',
      addPomodoroScreenLongBreak: 'Long Break',
      addPomodoroScreenMinutes: 'Minutes',
      addPomodoroScreenTaskName: 'Task name',
      addPomodoroScreenVibrationTitle: 'Vibration',
      addPomodoroScreenVibrationDescription:
          'Add vibration when an event comes.',
      addPomodoroScreenReadStatusTitle: 'Read Status',
      addPomodoroScreenReadStatusDescription:
          'Read pomodoro time status aloud.',
      addPomodoroScreenToneAndVolume: 'Tone and Volume',
      addPomodoroScreenSelectedTone: 'Selected Tone: ',
      //addPomodoroScreenTaskNameError: 'Please enter name.',
      addPomodoroScreenTaskNameTooLongError: 'Too long.',
      addPomodoroScreenSoundSettingMute: 'Sound settings sets to mute.',
      // start pomodoro screen

      startPomodoroTaskScreenCancelTimerTitle:
          'Do you want to cancel the time?',
      startPomodoroTaskScreenCancel: 'Cancel',
      startPomodoroTaskScreenContinue: 'Continue',
      startPomodoroTaskScreenPomodoroFinish:
          'Good job! your pomodoro task has been completed.',
      startPomodoroTaskScreenSoundSettingsSetToMute:
          'Sound settings sets to mute.',
      getWorkTimeText: (time) =>
          'Mantenha o foco por ${time.inMinutes} minutos',
      getShortBreakText: (time) =>
          'Faça uma pequena pausa de ${time.inMinutes} minutos',
      getLongBreakText: (time) =>
          'Faça uma pausa longa de ${time.inMinutes} minutos',
      // getSubtitleText: (round, maxRound) => '$round of $maxRound session',

      // app introduction screen
      appIntroductionAppMotto: 'More focus, Better results, Less fatigue',
      appIntroductionAppDescription:
          'Using pomodoro technique and customizability we will help you to be more focused '
          'and reduces your fatigue while doing daily tasks.',
      appIntroductionWhatIsPomodoro: 'What is pomodoro?',
      appIntroductionWhatIsPomodoroDescription:
          'In simple words: Pomodoro is a technique for improve your results and help you to focus on your works.',
      appIntroductionHowToUse: 'How to use it?',
      appIntroductionHowToUseDescription:
          'Divide your daily tasks into desired time sections and after each work section,'
          ' you can take a short break and after completing the number of work sections, you give yourself a long break'
          ' to maintain mental and physical readiness.',
      appIntroductionDone: 'Done',
      appIntroductionSkip: 'Skip',
    );

AppLocalizationData get persianLocalization => AppLocalizationData(
      locale: portugueseLocale,
      fontFamily: 'SourceSansPro',
      appName: 'Sptimer',
      convertNumber: (number) => number.withPersianNumbers(),
      convertDateToString: (date) => date.toPersian().toString(),

      // tasks screen
      tasksScreenTitle: 'کارها',
      tasksScreenAll: 'همه',
      tasksScreenDone: 'انجام شده',
      tasksScreenRemain: 'باقی مانده',
      tasksScreenNoDoneTasksTitle: 'کار انجام شدای پیدا نشد!',
      tasksScreenNoDoneTasksDescription: 'شما هنوزی کاری را انجام نداده اید.',
      tasksScreenNoTasksTitle: 'شما کاری اضافه نکرده اید!',
      tasksScreenNoTasksDescription:
          'لطفا کارهای خود را با دکمه اضافه در پایین اضافه نمایید.',
      tasksScreenNoRemainedTasksTitle: 'همه کار ها تمام شده!',
      tasksScreenNoRemainedTasksDescription:
          'تبریک شما همه کارهای امروز خود را انجام داده اید.',
      tasksScreenError: 'مشکلی پیش امده است.',
      tasksScreenLongBreakTimePrefix: 'ا.ط',
      tasksScreenShortBreakTimePrefix: 'ا.ک',
      tasksScreenWorkTimePrefix: 'ک',
      tasksScreenTimeSuffix: 'دقیقه',
      tasksScreenDelete: 'حذف',
      tasksScreenEdit: 'ویرایش',
      // home screen
      baseScreenHome: 'خانه',
      baseScreenCalendar: 'تقویم',
      permissionDialogOkIUnderstand: 'باشه،متوجه شدم',
      permissionDialogNotificationTitle: 'مجوز نشان دادن اعلان',
      permissionDialogNotificationDescription:
          'اعلان ها را فعال کنید تا بتوانید هنگام بسته شدن برنامه وضعیت تایمر را ببینید.',
      // calendar screen
      calendarScreenCompleted: 'کامل شده',
      calendarScreenUncompleted: 'کامل نشده',
      calendarScreenTitle: 'تقویم',
      calendarScreenEmptyListTitle: 'لیست گزارشات خالی است!',
      calendarScreenEmptyListDescription: 'َشما گزارش ثبت شده ای ندارید.',
      calendarScreenNoRecordedTasksFound:
          'ّبرای تاریخ انتخاب شده گزارشی ثبت نشده!',
      calendarScreenError: 'مشکلی پیش امده.',
      calendarScreenTimeSuffix: (date) => date.hour > 11 ? ' ب ظ' : ' ق ظ',
      //add pomodoro screen
      addPomodoroScreenAddTitle: 'اضافه کردن کار جدید',
      addPomodoroScreenEditTitle: 'ویرایش کار',
      addPomodoroScreenAddButton: 'اضافه کردن',
      addPomodoroScreenEditButton: 'ثبت تغییرات',
      addPomodoroScreenRounds: 'دورها',
      addPomodoroScreenIntervals: 'تعداد',
      addPomodoroScreenWorkIntervals: 'کار',
      addPomodoroScreenShortBreak: 'استراحت کوتاه',
      addPomodoroScreenLongBreak: 'استراحت طولانی',
      addPomodoroScreenMinutes: 'دقیقه',
      addPomodoroScreenTaskName: 'اسم',
      addPomodoroScreenVibrationTitle: 'ویبره',
      addPomodoroScreenVibrationDescription:
          'اضافه کردن ویبره وقتی یک رویداد تمام میشود.',
      addPomodoroScreenReadStatusTitle: 'خواندن وضعیت',
      addPomodoroScreenReadStatusDescription:
          'خواندن وضعیت تایمر با صدای بلند.',
      addPomodoroScreenToneAndVolume: 'صدا و درجه صدا',
      addPomodoroScreenSelectedTone: 'صدای انتخاب شده:',
      //addPomodoroScreenTaskNameError: 'لطفا اسم را وارد نمایید',
      addPomodoroScreenTaskNameTooLongError:
          'طول اسم وارد شده بیش از حد طولانی باشد',
      addPomodoroScreenSoundSettingMute: 'تنظیمات صدا بر روی حالت سکوت میباشد.',
      // start pomodoro screen

      startPomodoroTaskScreenCancelTimerTitle:
          'ایا میخواهید تایمر را متوقف کنید؟',
      startPomodoroTaskScreenCancel: 'توقف',
      startPomodoroTaskScreenContinue: 'ادامه',
      startPomodoroTaskScreenPomodoroFinish:
          'تبریک! کار پومودورو شما به اتمام رسید.',
      startPomodoroTaskScreenSoundSettingsSetToMute:
          'تنظیمات صدا بر روی حالت سکوت میباشد.',
      getWorkTimeText: (time) =>
          'برای ${time.inMinutes} دقیقه تمرکز کنید'.withPersianNumbers(),
      getShortBreakText: (time) =>
          'برای ${time.inMinutes} دقیقه استراحت کوتاه کنید'
              .withPersianNumbers(),
      getLongBreakText: (time) =>
          'برای ${time.inMinutes} دقیقه استراحت کنید'.withPersianNumbers(),
      // getSubtitleText: (round, maxRound) =>
      //     '$round از $maxRound دور'.withPersianNumbers(),

      // app introduction screen
      appIntroductionAppMotto: 'تمرکز بیشتر، نتیجه بهتر، خستگی کمتر',
      appIntroductionAppDescription:
          'با استفاده از تکنیک پومودورو و قابلیت شخصی‌سازی به شما کمک می‌کنیم تا تمرکز بیشتری داشته باشید و خستگی شما را در حین انجام کارهای روزانه کاهش می دهیم.',
      appIntroductionWhatIsPomodoro: 'پومودورو چیست؟',
      appIntroductionWhatIsPomodoroDescription:
          'به عبارت ساده: پومودورو تکنیکی است برای بهبود نتایج و کمک به شما برای تمرکز روی کارهایتان.',
      appIntroductionHowToUse: 'راهنمای برنامه',
      appIntroductionHowToUseDescription:
          'کارهای روزانه خود را به بخش های زمانی دلخواه تقسیم کنید و بعد از هر بخش کاری می توانید استراحت کوتاهی داشته باشید و پس از تکمیل تعداد قسمت های کاری، برای حفظ آمادگی روحی و جسمی به خود استراحتی طولانی بدهید.',
      appIntroductionDone: 'تمام',
      appIntroductionSkip: 'رد شدن',
    );
