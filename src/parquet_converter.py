import sys
import argparse
from pathlib import Path
import pandas as pd
from pyarrow import parquet as pq


class ParquetConverter:
    def __init__(self, input_dir: str = "data", output_dir: str = "data"):
        self.input_dir = Path(input_dir)
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        
    def convert_file(self, csv_file: Path, compression: str = "snappy") -> bool:
        df = pd.read_csv(csv_file)
        if df.empty:
            return False
            
        output_file = self.output_dir / f"{csv_file.stem}.parquet"
            
        df.to_parquet(
                output_file,
                engine='pyarrow',
                compression=compression,
                index=False
            )
            
        return True
    
    def convert_directory(self, compression: str = "snappy") -> dict:
        csv_files = list(self.input_dir.glob("*.csv"))
        
        if not csv_files:
            return {"success": 0, "failed": 0, "total": 0}
        
        results = {"success": 0, "failed": 0, "total": len(csv_files)}
        
        for csv_file in csv_files:
            if self.convert_file(csv_file, compression):
                results["success"] += 1
            else:
                results["failed"] += 1
        
        return results
    
    def get_file_info(self, file_path: Path) -> dict:
        table = pq.read_table(file_path)
        return {
                "rows": len(table),
                "columns": len(table.schema),
                "size_bytes": file_path.stat().st_size,
                "schema": str(table.schema)
            }


def main():
    parser = argparse.ArgumentParser(description="Convierte archivos CSV a Parquet")
    parser.add_argument("--input", "-i", default="data", help="Directorio de entrada con archivos CSV")
    parser.add_argument(
        "--compression", "-c",
        choices=["snappy", "gzip", "brotli", "lz4", "zstd"],
        default="snappy",
        help="Algoritmo de compresión (default: snappy)"
    )
    parser.add_argument("--file", "-f", help="Archivo CSV específico a convertir")
    
    args = parser.parse_args()
    
    converter = ParquetConverter(args.input)
    
    if args.file:
        csv_file = Path(args.file)
        if not csv_file.exists():
            sys.exit(1)
        
        success = converter.convert_file(csv_file, args.compression)
        if success:
            output_file = Path(args.input) / f"{csv_file.stem}.parquet"
            info = converter.get_file_info(output_file)
        else:
            sys.exit(1)
    else:
        results = converter.convert_directory(args.compression)
        
        if results['failed'] > 0:
            sys.exit(1)


if __name__ == "__main__":
    main()