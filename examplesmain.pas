unit ExamplesMain;

{$IFDEF Lazarus}
//{$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  NumericGrid
{$IFDEF Lazarus}
  , LCLType, Masks, Grids, Menus
{$ENDIF}
  ;

type
    TDataSource = class(TInterfacedObject, IGridDataSource)
    public
      function ValueToString(const ACol, ARow: LongInt): string;
          //  преобразует значение в источнике данных в строковое
          //  представление, используется также и для нумерации
          //  (или другого способа обозначения) Fixed колонок/строк
      procedure StringToValue(const ACol, ARow: LongInt;
          //  преобразует строку в значение; если преобразовать
          //  невозможно - вызывается исключение
          const AString: string);
      procedure SetValueByDefault(const ACol, ARow: LongInt);
          //  устанавливает правильное значение "по умолчанию"
          //  для данной ячейки; используется при обработке операции
          //  очистки ячейки
      function GetCellColor(const ACol, ARow: LongInt; var Color: TColor): Boolean;
          //  возвращает True, если должен быть установлен цвет Color,
          //  в противном случае - False
      function GetCellEditMask(const ACol, ARow: LongInt): string;
      function GetCellEnabledCharSet(const ACol, ARow: LongInt): TCharSet;
      function IsCellDisabled(const ACol, ARow: LongInt): Boolean;
          //  возвращает признак запрещения ввода в ячейки -
          //  True - ввод запрещен
      function IsDataValid(const ACol, ARow: LongInt;
          //  выполняет "мягкую" проверку данных без возбуждения
          //  исключения; однако, если координаты строки/колонки
          //  имеют недорустимые значения исключение вызывается
          const AString: string): Boolean;

      //  функции проверки возможности выполнения действия
      function MayIDoInsertRows(StartRow, RowsCount: LongInt): Boolean;
      function MayIDoDeleteRows(StartRow, RowsCount: LongInt): Boolean;
      function MayIDoAddRow: Boolean;

      function MayIDoInsertColumns(StartCol, ColsCount: LongInt): Boolean;
      function MayIDoDeleteColumns(StartCol, ColsCount: LongInt): Boolean;
      function MayIDoAddColumn: Boolean;

      function MayIDoDeleteAllData: Boolean;
      function MayIDoClearSelectedArea: Boolean;
      function MayIDoClearAllCells: Boolean;

      procedure RowsDeleted(const StartPos, Count: LongInt);
      procedure RowsInserted(const StartPos, Count: LongInt);
      procedure RowAdded;

      procedure ColumnsDeleted(const StartPos, Count: LongInt);
      procedure ColumnsInserted(const StartPos, Count: LongInt);
      procedure ColumnAdded;

      procedure AllDataDeleted;

      function GetColCount: LongInt;  //  полное число колонок, включая Fixed
      function GetRowCount: LongInt;  //  полное число строк, включая Fixed
      function GetFixedCols: LongInt; //  число фиксированных колонок
      function GetFixedRows: LongInt; //  число фиксированных строк
      function GetColNumFixed: Boolean;
      function GetRowNumFixed: Boolean;

      function GetColWidth(const Col: LongInt): LongInt;
      procedure SaveColWidth(const Col, Width: LongInt);
      function GetRowHeight(const Row: LongInt): LongInt;
      procedure SaveRowHeight(const Row, Height: LongInt);
      function AutoWidths: Boolean;
      function AutoHeights: Boolean;
          //  определяют необходимость использования
          //  автоматической настройки ширины и высоты ячеек

      function GetSelection: TGridRect;
      procedure SaveSelection(const Selection: TGridRect);
      function GetCol: LongInt;       //  The number of currently selected column.
      procedure SaveCol(const Col: LongInt);
      function GetRow: LongInt;       //  The number of currently selected row.
      procedure SaveRow(const Row: LongInt);
      function GetLeftCol: LongInt;
      procedure SaveLeftCol(const LeftCol: LongInt);
      function GetTopRow: LongInt;
      procedure SaveTopRow(const TopRow: LongInt);
  end;

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    ColoredGrid1: TColoredGrid;
    ColorStringGrid1: TColorStringGrid;
    DataGrid1: TDataGrid;
    GEFGrid1: TGEFGrid;
    IDAGrid1: TIDAGrid;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItemAddColumn: TMenuItem;
    MenuItemAddRow: TMenuItem;
    MenuItemDeleteRow: TMenuItem;
    MenuItemDeleteColumn: TMenuItem;
    MenuItemInsertColumn: TMenuItem;
    MenuItemInsertRow: TMenuItem;
    NumericGrid1: TNumericGrid;
    PopupMenuIDAGrid: TPopupMenu;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GEFGrid1GridEditingFinished(Sender: TObject; Col, Row: LongInt);
    procedure MenuItemAddColumnClick(Sender: TObject);
    procedure MenuItemAddRowClick(Sender: TObject);
    procedure MenuItemDeleteRowClick(Sender: TObject);
    procedure MenuItemDeleteColumnClick(Sender: TObject);
    procedure MenuItemInsertColumnClick(Sender: TObject);
    procedure MenuItemInsertRowClick(Sender: TObject);
  private
    { private declarations }
    DataSource: TDataSource;

    procedure FillIDAGrid;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
    ColorStringGrid1.CopyToClipBoard;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
    GEFGrid1.CopyToClipBoard;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
    ColorStringGrid1.PasteFromClipBoard;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
    GEFGrid1.PasteFromClipBoard;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    NumericGrid1.ColOptions[1] := coReal;
    NumericGrid1.ColOptions[2] := coInteger;
    NumericGrid1.ColOptions[3] := coChars;
    NumericGrid1.ColOptions[4] := coText;
    NumericGrid1.ColOptions[5] := coDisabled;

    DataSource := TDataSource.Create;

    DataGrid1.SetGridDataSource(DataSource as IGridDataSource);
    ColoredGrid1.SetGridDataSource(DataSource as IGridDataSource);

    FillIDAGrid;
end;

procedure TForm1.GEFGrid1GridEditingFinished(Sender: TObject; Col, Row: LongInt
  );
var Msg: string;
begin
    Msg := 'Editing finished. Col = ' + IntToStr(Col) +
        ', Row = ' + IntToStr(Row);
    Application.MessageBox(PChar(Msg),
        'Event handler', MB_OK or MB_ICONINFORMATION);
end;

procedure TForm1.MenuItemAddColumnClick(Sender: TObject);
begin
    IDAGrid1.AddColumn;
end;

procedure TForm1.MenuItemAddRowClick(Sender: TObject);
begin
    IDAGrid1.AddRow;
end;

procedure TForm1.MenuItemDeleteRowClick(Sender: TObject);
begin
    IDAGrid1.DeleteRow(IDAGrid1.Row);
end;

procedure TForm1.MenuItemDeleteColumnClick(Sender: TObject);
begin
    IDAGrid1.DeleteColumns(IDAGrid1.Col, 1);
end;

procedure TForm1.MenuItemInsertColumnClick(Sender: TObject);
begin
    IDAGrid1.InsertColumns(IDAGrid1.Col, 1, True);
end;

procedure TForm1.MenuItemInsertRowClick(Sender: TObject);
begin
    IDAGrid1.InsertRows(IDAGrid1.Row, 1, True);
end;

function TDataSource.ValueToString(const ACol, ARow: LongInt): string;
begin
    if (ACol = 1) and (ARow = 0) then Result := 'Col width'
    else
    if (ACol = ARow) and (ACol <> 0) then Result := 'Cell color'
    else
    if (ACol = 0) and (ARow = 1) then Result := 'Row height'
    else
        if (ACol <> 0) and (ARow <> 0) then
            Result := 'Cell text'
        else
            Result := '';
end;

procedure TDataSource.StringToValue(const ACol, ARow: LongInt;
    const AString: string);
begin
end;

procedure TDataSource.SetValueByDefault(const ACol, ARow: LongInt);
begin

end;

function TDataSource.GetCellColor(
    const ACol, ARow: LongInt; var Color: TColor): Boolean;
begin
    if ACol = ARow then Color := clYellow
    else Color := clAqua;
    Result := True;
end;

function TDataSource.GetCellEditMask(const ACol, ARow: LongInt): string;
begin
    Result := '';
end;

function TDataSource.GetCellEnabledCharSet(
    const ACol, ARow: LongInt): TCharSet;
begin

end;

function TDataSource.IsCellDisabled(const ACol, ARow: LongInt): Boolean;
begin
    Result := False;
end;

function TDataSource.IsDataValid(const ACol, ARow: LongInt;
    const AString: string): Boolean;
begin
    Result := False;
end;

function TDataSource.MayIDoInsertRows(StartRow, RowsCount: LongInt): Boolean;
begin
    Result := True;
end;

function TDataSource.MayIDoDeleteRows(StartRow, RowsCount: LongInt): Boolean;
begin
    Result := True;
end;

function TDataSource.MayIDoAddRow: Boolean;
begin
    Result := True;
end;

function TDataSource.MayIDoInsertColumns(StartCol, ColsCount: LongInt): Boolean;
begin
    Result := True;
end;

function TDataSource.MayIDoDeleteColumns(StartCol, ColsCount: LongInt): Boolean;
begin
    Result := True;
end;

function TDataSource.MayIDoAddColumn: Boolean;
begin
    Result := True;
end;

function TDataSource.MayIDoDeleteAllData: Boolean;
begin
    Result := True;
end;

function TDataSource.MayIDoClearSelectedArea: Boolean;
begin
    Result := True;
end;

function TDataSource.MayIDoClearAllCells: Boolean;
begin
    Result := True;
end;

procedure TDataSource.RowsDeleted(const StartPos, Count: LongInt);
begin

end;

procedure TDataSource.RowsInserted(const StartPos, Count: LongInt);
begin
end;

procedure TDataSource.RowAdded;
begin
end;

procedure TDataSource.ColumnsDeleted(const StartPos, Count: LongInt);
begin

end;

procedure TDataSource.ColumnsInserted(const StartPos, Count: LongInt);
begin

end;

procedure TDataSource.ColumnAdded;
begin

end;

procedure TDataSource.AllDataDeleted;
begin

end;

function TDataSource.GetColCount: LongInt;
begin
    Result := 5;
end;

function TDataSource.GetRowCount: LongInt;
begin
    Result := 5;
end;

function TDataSource.GetFixedCols: LongInt;
begin
    Result := 1;
end;

function TDataSource.GetFixedRows: LongInt;
begin
    Result := 1;
end;

function TDataSource.GetColNumFixed: Boolean;
begin
    Result := True;
end;

function TDataSource.GetRowNumFixed: Boolean;
begin
    Result := True;
end;

function TDataSource.GetColWidth(const Col: LongInt): LongInt;
begin
    Result := 150;
end;

procedure TDataSource.SaveColWidth(const Col, Width: LongInt);
begin

end;

function TDataSource.GetRowHeight(const Row: LongInt): LongInt;
begin
    Result := 50;
end;

procedure TDataSource.SaveRowHeight(const Row, Height: LongInt);
begin

end;

function TDataSource.AutoWidths: Boolean;
begin
    Result := False;
end;

function TDataSource.AutoHeights: Boolean;
begin
    Result := False;
end;

function TDataSource.GetSelection: TGridRect;
begin

end;

procedure TDataSource.SaveSelection(const Selection: TGridRect);
begin

end;

function TDataSource.GetCol: LongInt;
begin
    //  Must return valid value in the given range.
    Result := 1;
end;

procedure TDataSource.SaveCol(const Col: LongInt);
begin

end;

function TDataSource.GetRow: LongInt;
begin
    //  Must return valid value in the given range.
    Result := 1;
end;

procedure TDataSource.SaveRow(const Row: LongInt);
begin

end;

function TDataSource.GetLeftCol: LongInt;
begin
    Result := 0;
end;

procedure TDataSource.SaveLeftCol(const LeftCol: LongInt);
begin

end;

function TDataSource.GetTopRow: LongInt;
begin
    Result := 0;
end;

procedure TDataSource.SaveTopRow(const TopRow: LongInt);
begin

end;

procedure TForm1.FillIDAGrid;
var i, j: LongInt;
begin
    for i := IDAGrid1.FixedRows to IDAGrid1.RowCount - 1 do
        for j := IDAGrid1.FixedCols to IDAGrid1.ColCount - 1 do
            IDAGrid1.Cells[j, i] :=
                '(' + IntToStr(j) + ', ' + IntToStr(i) + ')';
end;

end.

