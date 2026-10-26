# tsqldep

**A lightweight T-SQL parser, formatter, and CRUD analyzer powered by Microsoft SQL Server ScriptDom.**

```text
SQL input  ──▶  ScriptDom  ──▶  Parse results · Formatted SQL · Parse tree · Tables · CRUD
```

```powershell
# Format a query
./tsqldep.ps1 -f "select * from dbo.Orders"

# List tables referenced by a query
./tsqldep.ps1 -t "select * from dbo.Orders o join dbo.Customers c on c.Id = o.CustomerId"

# Show CRUD operations
./tsqldep.ps1 -c "select * from dbo.Orders; update dbo.Customers set Name = 'Ada';"
```

## What it does

tsqldep analyzes Transact-SQL (T-SQL) using Microsoft's ScriptDom parser and presents the results as PowerShell objects and tables.

| Mode | Option | Output |
| --- | --- | --- |
| Parse | `-p` (default) | Parse result and any syntax errors |
| Format | `-f` | SQL formatted by ScriptDom |
| Parse tree | `-r` | Parsed syntax tree, one row per statement |
| Tables | `-t` | Tables referenced by each statement |
| CRUD | `-c` | Tables grouped by create, read, update, and delete operations |

You can provide a SQL string, a single `.sql` file, or a directory. When given a directory, tsqldep recursively processes its `.sql` files.

## Getting started

### Requirements

- PowerShell
- Microsoft SQL Server Transact-SQL ScriptDom

The repository includes a ScriptDom assembly. tsqldep prefers the local `Microsoft.SqlServer.TransactSql.ScriptDom.dll` and falls back to an installed assembly if the local file is not present.

### Run a query

Run the script with a SQL string as the input:

```powershell
./tsqldep.ps1 "select * from dbo.Orders"
```

Parsing is the default operation. Use `-p` to make it explicit.

### Choose an operation

```powershell
# Parse and report syntax errors
./tsqldep.ps1 -p "select * from dbo.Orders"

# Format SQL
./tsqldep.ps1 -f "select * from dbo.Orders"

# Inspect the parse tree
./tsqldep.ps1 -r "select * from dbo.Orders"

# List referenced tables
./tsqldep.ps1 -t "select * from dbo.Orders"

# Summarize CRUD operations
./tsqldep.ps1 -c "insert into dbo.Orders (Id) select Id from dbo.Source"
```

The long-form operation names can also be supplied with `-op`:

```powershell
./tsqldep.ps1 -op format "select * from dbo.Orders"
./tsqldep.ps1 -op tables "select * from dbo.Orders"
```

### Process files and directories

Pass a file path to analyze one SQL file, or a directory to recursively process its `.sql` files.

```powershell
# Analyze one file
./tsqldep.ps1 -c ./queries/report.sql

# Analyze all SQL files below a directory
./tsqldep.ps1 -c ./queries/
```

Directory results are printed in the order the files are parsed.

## Select a SQL Server parser version

Use `-version` to select the ScriptDom parser that matches the target SQL Server syntax. The default is `TSql110Parser` (SQL Server 2012).

| SQL Server | Parser |
| --- | --- |
| SQL Server 2000 | `TSql80Parser` |
| SQL Server 2005 | `TSql90Parser` |
| SQL Server 2008 | `TSql100Parser` |
| SQL Server 2012 | `TSql110Parser` |
| SQL Server 2014 | `TSql120Parser` |
| SQL Server 2016 | `TSql130Parser` |
| SQL Server 2017 | `TSql140Parser` |
| SQL Server 2019 | `TSql150Parser` |
| SQL Server 2022 | `TSql160Parser` |
| SQL Server 2025 | `TSql170Parser` |
| Next / preview syntax | `TSql180Parser` |

For example:

```powershell
./tsqldep.ps1 -version TSql180Parser -f "select * from dbo.Orders"
```

Available parser types depend on the ScriptDom assembly being loaded.

## Use it from PowerShell

The script returns objects, so you can select properties or capture a result for further processing.

```powershell
$result = ./tsqldep.ps1 -f "select * from dbo.Orders"
$result.formatted
```

## Notes

- SQL formatting follows ScriptDom's SQL generator.
- CRUD analysis is still evolving; verify its results for queries with complex or unusual syntax.
- The `-desc` option includes statement details in the output.
- The `-tablelist` option writes table-list output under the `tablelist` directory.

## License

See [LICENSE](LICENSE) for license information.
