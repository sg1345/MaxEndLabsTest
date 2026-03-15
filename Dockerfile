FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything into the container
COPY . .

# Step into the folder where the .csproj actually lives
WORKDIR "/src/MaxEndLabs"

# Restore using the local path
RUN dotnet restore "MaxEndLabs.csproj"

# Build and Publish
RUN dotnet publish "MaxEndLabs.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Standard Port for Render
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "MaxEndLabs.dll"]
