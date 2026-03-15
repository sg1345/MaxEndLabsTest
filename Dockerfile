# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files to restore dependencies
COPY ["MaxEndLabs.sln", "./"]
COPY ["MaxEndLabs/MaxEndLabs.csproj", "MaxEndLabs/"]
RUN dotnet restore

# Copy everything else and build
COPY . .
WORKDIR "/src/MaxEndLabs"
RUN dotnet publish "MaxEndLabs.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Render dynamically assigns a port; ASP.NET 8 listens on 8080 by default
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "MaxEndLabs.dll"]
