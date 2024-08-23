# Penalty_Simulator Game

## Inicjalizacja środowiska

Aby rozpocząć pracę z projektem, należy uruchomić terminal w folderze projektu i zainicjalizować środowisko:

```bash
. env.sh
```

Następnie, pozostając w głównym folderze, można wywoływać dostępne narzędzia:

* `run_simulation.sh`
* `generate_bitstream.sh`
* `program_fpga.sh`
* `clean.sh`

Narzędzia te zostały opisane poniżej.

## Generowanie bitstreamu

```bash
generate_bitstream.sh
```

Skrypt ten uruchamia generację bitstreamu, który finalnie znajdzie się w folderze `results`. Następnie sprawdza logi z syntezy i implementacji pod kątem ewentualnych ostrzeżeń (_warning_, _critical warning_) i błędów (_error_), a w razie ich wystąpienie kopiuje ich treść do pliku `results/warning_summary.log`

## Wgrywanie bitstreamu do Basys3

```bash
program_fpga.sh
```

Aby skrypt poprawnie wgrał bitstream do FPGA, w folderze `results` musi znajdować się **tylko jeden** plik z rozszerzeniem `.bit`.