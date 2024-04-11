// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

// pageextension 50112 CustomerListExt extends "Customer List"
// {
//     trigger OnOpenPage();
//     begin
//         Message('App published: Hello world this');
//     end;
// }

table 50109 IICar
{
    DataClassification = ToBeClassified;
    Caption = 'Car Park';
    fields
    {
        field(1; CarNo; Code[20])
        {
            NotBlank = true;
            Caption = 'Car Number';
        }

        field(2; CarAge; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Car Age';
        }

        field(3; OwnerName; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Owner Name';
        }
    }

    keys
    {
        key(PK; CarNo)
        {
            Clustered = true;
        }
    }
}

page 50100 IICarListPage
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = IICar;

    layout
    {
        area(content)
        {
            repeater(Cars)
            {

                field(RegistrationNumber; Rec.CarNo)
                {
                    ApplicationArea = All;
                }

                field(Age; Rec.CarAge)
                {
                    ApplicationArea = All;
                }

                field(OwnerName; Rec.OwnerName)
                {
                    ApplicationArea = All;
                    Caption = 'Owner Name';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Calulate Median Age")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    IICarManagement: Codeunit "IICarManagement";
                begin
                    IICarManagement.CalculateMedianAge;
                end;
            }
        }
    }
}

codeunit 50100 IICarManagement
{
    procedure CalculateMedianAge()
    var
        TotalAge: Integer;
        CarCount: Integer;
        MedianAge: Decimal;
        CarRec: Record IICar;
    begin
        TotalAge := 0;
        CarCount := 0;

        CarRec.RESET;
        IF CarRec.FINDSET THEN BEGIN
            REPEAT
                TotalAge += CarRec.CarAge;
                CarCount += 1;
            UNTIL CarRec.NEXT = 0;
        END;

        IF CarCount > 0 THEN
            MedianAge := TotalAge / CarCount
        ELSE
            MedianAge := 0;

        Message('The median age of cars is: ' + FORMAT(MedianAge));
    end;
}

