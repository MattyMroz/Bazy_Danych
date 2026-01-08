import json
from rich import print
from rich.tree import Tree
from rich.console import Console


def generate_tree(data, tree):
    if isinstance(data, dict):
        for key, value in data.items():
            node = tree.add(
                f"[bold magenta]{key}[/bold magenta] ([italic blue]{type(value).__name__}[/italic blue])")
            generate_tree(value, node)
    elif isinstance(data, list):
        if len(data) > 0:
            # Pokazujemy strukturę tylko pierwszego elementu, żeby nie zaśmiecać widoku
            node = tree.add(f"[cyan]List item structure[/cyan]")
            generate_tree(data[0], node)
        else:
            tree.add("[italic white]Empty list[/italic white]")


def main():
    file_path = "C:\\Users\\mateu\\Desktop\\PROJECTS\\GitHub\\Bazy_Danych\\PIABD\\Projekt\\companies documents 1-6.json"

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        console = Console()
        tree = Tree(
            f":file_folder: [bold green]Structure of {file_path}[/bold green]")

        # Jeśli to lista dokumentów (jak w MongoDB), bierzemy pierwszy dokument do analizy
        if isinstance(data, list):
            generate_tree(data[0], tree)
        else:
            generate_tree(data, tree)

        console.print(tree)

    except FileNotFoundError:
        print(f"[red]Błąd: Nie znaleziono pliku {file_path}[/red]")
    except Exception as e:
        print(f"[red]Wystąpił błąd: {e}[/red]")


if __name__ == "__main__":
    main()
