program CopiaIntegralProcesso;

{$APPTYPE CONSOLE}
{$R *.res}

uses
   System.SysUtils,
   FireDAC.Moni.RemoteClient,
   unMain in 'unMain.pas',
   unConfig in 'utils\unConfig.pas',
   unProcesso in '..\apj-fmd\classes\entities\unProcesso.pas',
   unProcessoRepository in '..\apj-fmd\classes\repositories\unProcessoRepository.pas',
   unPadraoRepository in '..\apj-fmd\classes\repositories\unPadraoRepository.pas',
   unSystemConfiguration in '..\apj-fmd\utils\unSystemConfiguration.pas',
   unLogErrors in '..\apj-fmd\utils\unLogErrors.pas',
   unUtils in '..\apj-fmd\utils\unUtils.pas',
   unBaseClass in '..\apj-fmd\classes\repositories\unBaseClass.pas';

var
   main: TMain;

begin
   main := TMain.Create;
   try
      main.Execute;
      FreeAndNil(main);
   except
      on E: Exception do
      begin
         Writeln(E.ClassName, ': ', E.Message);
         FreeAndNil(main);
      end;
   end;

end.
