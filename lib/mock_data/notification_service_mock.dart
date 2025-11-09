final List<Map<String, dynamic>> hardcodedNotifications = [
  {
    "id": "1",
    "type": "reminder",
    "title": "Reminder: Don't forget to buy fresh vegetables today.",
    "createdAt": DateTime.now().subtract(const Duration(minutes: 1)),
    "isRead": false,
  },
  {
    "id": "2",
    "type": "shared",
    "title": "Anna shared a shopping list with you: “Weekly Groceries”.",
    "createdAt": DateTime.now().subtract(const Duration(minutes: 7)),
    "isRead": true,
  },
  {
    "id": "3",
    "type": "activity",
    "title": "Anna added 'Coffee beans' to the list “Weekly Groceries”.",
    "createdAt": DateTime.now().subtract(const Duration(minutes: 22)),
    "isRead": false,
  },
  {
    "id": "4",
    "type": "security",
    "title": "New sign-in detected on your account from Android device.",
    "createdAt": DateTime.now().subtract(const Duration(hours: 1)),
    "isRead": true,
  },
  {
    "id": "5",
    "type": "general",
    "title": "New feature unlocked: Attach images to list items!",
    "createdAt": DateTime.now().subtract(const Duration(hours: 5)),
    "isRead": false,
  },
];
