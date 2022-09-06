#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["./web_api_test/web_api_test.csproj", "."]
RUN dotnet restore "./web_api_test.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./web_api_test/web_api_test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./web_api_test/web_api_test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS http://*:5000
ENTRYPOINT ["dotnet", "web_api_test.dll"]