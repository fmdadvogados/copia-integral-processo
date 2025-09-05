unit unMain;

interface

uses Sysutils, IOUtils, unBaseClass, Firedac.Comp.Client, Generics.Collections;

type
   TMain = class(TBaseClass)
   private
      FDiretorioBaseCopias: string;
      FDiretorioBaseProcessos: string;
      FDiretorioCopiasPendentes: string;
      FDiretorioCopiasRealizados: string;
      FDiretorioProcesso: string;
      procedure LoadParams();
      function ListaArquivos(const ADiretorio: string): TList<string>;
   public
      procedure Execute();
   end;

implementation

{ TMain }
uses unConfig, unProcesso, unProcessoRepository;

procedure TMain.Execute;
var
   processo: TProcesso;
   procRepo: TProcessoRepository;
   arquivo, numeroProcesso, diretorioProcesso: string;
begin

   procRepo := TProcessoRepository.Create;
   try
      LoadParams;
      for arquivo in ListaArquivos(FDiretorioCopiasPendentes) do
      begin
         if not SameText(LowerCase(ExtractFileExt(arquivo)), '.pdf') then
            Continue;

         numeroProcesso := ExtractFileName(arquivo).ToLower.Replace('.pdf', '').Trim;
         for processo in procRepo.FindByProcessNumber(numeroProcesso, Fconnection) do
         begin
            diretorioProcesso := TPath.Combine(FDiretorioBaseProcessos, IntToStr(processo.cod_processo));
            if not DirectoryExists(diretorioProcesso) then
            begin
               ForceDirectories(diretorioProcesso);
               if not DirectoryExists(diretorioProcesso) then
                  raise Exception.Create('Falha ao criar diretório: ' + diretorioProcesso);
            end;

            diretorioProcesso := diretorioProcesso + PathDelim + 'INICIAL'+'-'+numeroProcesso+ '.pdf';
            TFile.Copy(arquivo, diretorioProcesso,True);
            TFile.Move(arquivo, FDiretorioCopiasRealizados + PathDelim + ExtractFileName(arquivo));
         end;
      end;
      FreeAndNil(procRepo);
   except
      on e: Exception do
      begin
         LogErro(e.Message);
         FreeAndNil(procRepo);
      end;

   end;

end;

function TMain.ListaArquivos(const ADiretorio: string): TList<string>;
var
   SR: TSearchRec;
begin
   Result := TList<string>.Create;
   try
      if FindFirst(IncludeTrailingPathDelimiter(ADiretorio) + '*.*', faAnyFile, SR) = 0 then
      begin
         repeat
            if (SR.Attr and faDirectory) = 0 then
               Result.Add(IncludeTrailingPathDelimiter(ADiretorio) + SR.Name);
         until FindNext(SR) <> 0;
         Sysutils.FindClose(SR);
      end;
   except
      Result.Free;
      raise;
   end;
end;

procedure TMain.LoadParams;
var
   Config: TConfig;
begin
   Config := TConfig.Create;
   try
      Config.Carregar('CopiaIntegralProcesso.ini');

      FDiretorioBaseCopias := Config.DiretorioBaseCopias;
      FDiretorioBaseProcessos := Config.DiretorioBaseProcessos;
      FDiretorioCopiasPendentes := TPath.Combine(FDiretorioBaseCopias, 'PENDENTES');
      FDiretorioCopiasRealizados := TPath.Combine(FDiretorioBaseCopias, 'REALIZADOS');
      FreeAndNil(Config);
   except
      on e: Exception do
      begin
         FreeAndNil(Config);
         raise;
      end;
   end;
end;

end.
