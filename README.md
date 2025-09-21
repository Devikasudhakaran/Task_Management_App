
# Task Management App 
 

A Flutter application to manage task assignments within a company of 10 employees.  
The app supports **Admin** and **Employee** roles with Firebase Authentication and Firestore integration.  

---

##  Features  

###  Authentication  
- User **Sign Up** with email, password, username, and role (Admin/Employee).  
- User **Login** with Firebase Auth.  
- Role-based navigation:
  - **Admin → Admin Dashboard**  
  - **Employee → Employee Dashboard**  

###  Admin Functionality  
- Assign tasks to employees.  
- Task form includes:
  - Employee selection  
  - Task title & description  
  - Start date & time  
  - End date & time  
- Store tasks in Firestore.  
- Send **Firebase push notifications** when a new task is assigned.  

### Employee Functionality  
- Login and view only tasks assigned to them.  
- Task list with title, description, and deadline.  

### Notifications  
- Employees receive push notifications when a new task is assigned (title + description).  

---

## Tech Stack  

- **Flutter & Dart**  
- **Firebase Authentication**  
- **Cloud Firestore** (database)  
- **Firebase Cloud Messaging (FCM)**  
- **Bloc (flutter_bloc)** – for state management  

---




