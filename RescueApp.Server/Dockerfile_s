# Use the .NET 8 SDK image for building the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy the project files
COPY . ./

# Restore dependencies and build the project
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Use a smaller runtime image for the published app
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose port 80 for the API
EXPOSE 5279
EXPOSE 8080
EXPOSE 80

# Set the entry point for the app
ENTRYPOINT ["dotnet", "RescueApp.Server.dll"]

