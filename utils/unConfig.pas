unit unConfig;

interface

uses
   System.SysUtils, System.IniFiles, vcl.forms;

type
   TConfig = class
   private
      FDiretorioBaseCopias: string;
      FDiretorioBaseProcessos: string;
   public
      procedure Carregar(const AFileName: string);
      property DiretorioBaseCopias: string read FDiretorioBaseCopias;
      property DiretorioBaseProcessos: string read FDiretorioBaseProcessos;
   end;

implementation

{ TConfig }

procedure TConfig.Carregar(const AFileName: string);
var
   Ini: TIniFile;
   fileName:string;
begin
   fileName := ExtractFileDir(Application.ExeName) + PathDelim + AFileName;
   if not FileExists(fileName) then
      raise Exception.CreateFmt('Arquivo de configuração não encontrado: %s', [fileName]);

   Ini := TIniFile.Create(fileName);
   try
      // Seção "Diretorios"
      FDiretorioBaseCopias := Ini.ReadString('DIRETORIOS', 'COPIAS', '');
      FDiretorioBaseProcessos := Ini.ReadString('DIRETORIOS', 'PROCESSOS', '');
   finally
      Ini.Free;
   end;
end;

end.
