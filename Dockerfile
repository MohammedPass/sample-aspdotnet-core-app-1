FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["ASP.NETCoreDemos.csproj", "sample-aspdotnet-core-app-1/"]
RUN dotnet restore "sample-aspdotnet-core-app-1/ASP.NETCoreDemos.csproj"
WORKDIR "/src/sample-aspdotnet-core-app-1"
COPY . .
RUN dotnet build "ASP.NETCoreDemos.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ASP.NETCoreDemos.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ASP.NETCoreDemos.dll"]