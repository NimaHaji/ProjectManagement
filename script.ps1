$ErrorActionPreference = "Stop"

$ProjectName = "ProjectManagement"

Write-Host "Creating $ProjectName..." -ForegroundColor Cyan

# ==========================================
# Solution
# ==========================================

dotnet new sln `
    -n $ProjectName

# ==========================================
# GraphQL API
# ==========================================

dotnet new web `
    -n "$ProjectName.GraphQL" `
    -o "src/Api/$ProjectName.GraphQL" `
    --framework net9.0

dotnet sln add `
    "src/Api/$ProjectName.GraphQL/$ProjectName.GraphQL.csproj"


# ==========================================
# Project Service - gRPC
# ==========================================

dotnet new grpc `
    -n "$ProjectName.ProjectService" `
    -o "src/Services/$ProjectName.ProjectService" `
    --framework net9.0

dotnet sln add `
    "src/Services/$ProjectName.ProjectService/$ProjectName.ProjectService.csproj"


# ==========================================
# User Service - gRPC
# ==========================================

dotnet new grpc `
    -n "$ProjectName.UserService" `
    -o "src/Services/$ProjectName.UserService" `
    --framework net9.0

dotnet sln add `
    "src/Services/$ProjectName.UserService/$ProjectName.UserService.csproj"


# ==========================================
# Shared
# ==========================================

dotnet new classlib `
    -n "$ProjectName.Shared" `
    -o "src/BuildingBlocks/$ProjectName.Shared" `
    --framework net9.0

dotnet sln add `
    "src/BuildingBlocks/$ProjectName.Shared/$ProjectName.Shared.csproj"


# ==========================================
# Tests
# ==========================================

dotnet new xunit `
    -n "ProjectService.Tests" `
    -o "tests/ProjectService.Tests" `
    --framework net9.0

dotnet sln add `
    "tests/ProjectService.Tests/ProjectService.Tests.csproj"


dotnet new xunit `
    -n "UserService.Tests" `
    -o "tests/UserService.Tests" `
    --framework net9.0

dotnet sln add `
    "tests/UserService.Tests/UserService.Tests.csproj"


# ==========================================
# GraphQL directories
# ==========================================

$directories = @(
    "src/Api/$ProjectName.GraphQL/GraphQL/Queries",
    "src/Api/$ProjectName.GraphQL/GraphQL/Mutations",
    "src/Api/$ProjectName.GraphQL/GraphQL/Types",
    "src/Api/$ProjectName.GraphQL/GraphQL/Inputs",
    "src/Api/$ProjectName.GraphQL/GraphQL/DataLoaders",
    "src/Api/$ProjectName.GraphQL/Configuration",
    "src/Api/$ProjectName.GraphQL/Extensions",

    # Project Service
    "src/Services/$ProjectName.ProjectService/Application",
    "src/Services/$ProjectName.ProjectService/Domain",
    "src/Services/$ProjectName.ProjectService/Infrastructure",
    "src/Services/$ProjectName.ProjectService/Grpc/Services",
    "src/Services/$ProjectName.ProjectService/Grpc/Protos",

    # User Service
    "src/Services/$ProjectName.UserService/Application",
    "src/Services/$ProjectName.UserService/Domain",
    "src/Services/$ProjectName.UserService/Infrastructure",
    "src/Services/$ProjectName.UserService/Grpc/Services",
    "src/Services/$ProjectName.UserService/Grpc/Protos",

    # Shared
    "src/BuildingBlocks/$ProjectName.Shared/Exceptions",
    "src/BuildingBlocks/$ProjectName.Shared/Results",
    "src/BuildingBlocks/$ProjectName.Shared/Constants",

    # Proto contracts
    "proto/project/v1",
    "proto/user/v1",

    # Documentation
    "docs/architecture",
    "docs/graphql"
)

foreach ($directory in $directories) {
    New-Item `
        -ItemType Directory `
        -Force `
        -Path $directory | Out-Null
}


# ==========================================
# .gitignore
# ==========================================

dotnet new gitignore


# ==========================================
# Build
# ==========================================

Write-Host ""
Write-Host "Building solution..." -ForegroundColor Yellow

dotnet restore

dotnet build


# ==========================================
# Git
# ==========================================

Write-Host ""
Write-Host "Initializing Git..." -ForegroundColor Yellow

git init

git add .

git commit -m "chore: initialize project management solution"


# ==========================================
# Result
# ==========================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " ProjectManagement created successfully!"
Write-Host " .NET 9 + GraphQL + gRPC"
Write-Host "==========================================" -ForegroundColor Green

Write-Host ""
Write-Host "Projects:" -ForegroundColor Cyan

dotnet sln list

Write-Host ""
Write-Host "Git status:" -ForegroundColor Cyan

git status

Write-Host ""
Write-Host "Done." -ForegroundColor Green