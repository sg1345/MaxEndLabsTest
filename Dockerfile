FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything from the root
COPY . .

# Find the project file and restore
RUN dotnet restore "MaxEndLabs/MaxEndLabs.csproj"

# Build the project
WORKDIR "/src/MaxEndLabs"
RUN dotnet publish "MaxEndLabs.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "MaxEndLabs.dll"]
