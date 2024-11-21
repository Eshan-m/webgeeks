  # WebGeeks

WebGeeks is a full-stack web application featuring a client-facing app developed in Angular, an API built using C# (.NET Framework), and a Microsoft SQL Server database. This project showcases a robust, scalable architecture suitable for modern web development.

## Features
### Client Application:
A dynamic, responsive user interface built with Angular, providing a seamless experience for users.
### API:
A RESTful API created with C# (.NET Framework) to handle business logic and data exchange between the front end and the database.
### Database:
A Microsoft SQL Server database designed to manage and store application data effectively.
### Scalable Design:
Built with scalability and maintainability in mind, suitable for deployment in diverse environments.
## Technologies Used
Frontend: Angular
Backend: C# (.NET Framework)
Database: Microsoft SQL Server

## Setup Instructions
Clone the repository
```
git clone https://github.com/Eshan-m/webgeeks.git  
cd webgeeks
```
Set up the Client App (Angular)

Navigate to the Angular project directory:
```
cd client-app  
```
Install dependencies:
```
npm install  
```
Start the development server:
```
ng serve 
``` 
Access the app in your browser at http://localhost:4200.

## Set up the API (C#)

Open the API project in Visual Studio.
Restore NuGet packages.
Update the database connection string in the appsettings.json file.
Run the API project to start the backend server.

## Set up the Database (SQL Server)

Ensure Microsoft SQL Server is installed and running.
Import the database schema provided in the repository's /database directory.
Update connection settings as required for local or remote database use.

## Deployment Instructions
### Deploy the Angular Client

Build the production version of the Angular app:
```
ng build --prod  
```
Serve the built files using a web server (e.g., NGINX, Apache, or Azure Blob Storage).
For NGINX, configure a server block pointing to the dist/ directory.

### Deploy the API

Publish the .NET Framework API project to a target environment (e.g., Azure App Service, IIS, or Docker).
Ensure the correct connection string is configured for the production database.
Expose the API on a secure HTTPS endpoint.

### Deploy the Database

Deploy the SQL Server database to a cloud-hosted SQL Server instance (e.g., Azure SQL Database) or an on-premise server.
Update the schema and data using migration scripts or tools like SQL Server Management Studio (SSMS).
Ensure proper access control and security configurations are in place.
Domain and SSL

Set up a custom domain (e.g., using DNS services).
Obtain and configure an SSL certificate to enable HTTPS for both the API and client app.
Architecture Diagram
Below is a high-level architecture diagram illustrating the flow and interaction between components:

![image](https://github.com/user-attachments/assets/ae1d004a-6199-4b8f-b832-1a9cc2ae2dfa)


Example:

The Angular client communicates with the API via HTTP/HTTPS requests.
The API interacts with the SQL Server database for data persistence and retrieval.
The application is hosted using cloud or on-premise services.
How to Contribute
Contributions are welcome! Please fork the repository and create a pull request with your proposed changes. Ensure your code adheres to the project's coding standards.

## License

This project is licensed under the MIT License.

Contact
For any questions or suggestions, feel free to contact the repository owner through GitHub.
