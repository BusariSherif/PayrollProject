/// <summary>
/// Page Headline RC AppName (ID 50003).
/// </summary>
page 50003 "HLH HR Headline Part"
{
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    Caption = 'HR Headline Part';

    layout
    {
        area(Content)
        {
            field(Greeting; 'Hi! ' + UserId)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ''Hi! '' + UserId field.';
            }
            group(Quotes)
            {
                field(Headline7; hdl7Txt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the hdl7Txt field.';
                }
                field(Headline8; hdl8Txt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the hdl8Txt field.';
                }
                field(Headline9; hdl9Txt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the hdl9Txt field.';
                }
                field(Headline10; hdl10Txt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the hdl10Txt field.';
                }
                field(Headline11; hdl11Txt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the hdl11Txt field.';
                }
                field(Headline12; hdl12Txt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the hdl12Txt field.';
                }
                field(Headline13; hdl13Txt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the hdl13Txt field.';
                }
            }
            field(Headline1; hdl1Txt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the hdl1Txt field.';
            }
            field(Headline2; hdl2Txt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the hdl2Txt field.';
            }
            field(Headline3; hdl3Txt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the hdl3Txt field.';
            }
            field(Headline4; hdl4Txt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the hdl4Txt field.';
            }
            field(Headline5; hdl5Txt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the hdl5Txt field.';
            }
            field(Headline6; hdl6Txt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the hdl6Txt field.';
                trigger OnDrillDown()
                var
                    DrillDownURLTxt: Label 'https://www.ha-shem.com/', Locked = True;
                begin
                    Hyperlink(DrillDownURLTxt)
                end;
            }
        }
    }

    var
        hdl1Txt: Label '<qualifier>Employee Experience </qualifier><payload>We can’t help everyone, but everyone can <emphasize>help</emphasize> someone.</payload>';
        hdl2Txt: Label '<qualifier>Employee Development </qualifier><payload>What would you attempt to do if you knew you would not fail?</payload>';
        hdl3Txt: Label '<qualifier>Employee Relationship </qualifier><payload>Relationships, not power, drive you forward.</payload>';
        hdl4Txt: Label '<qualifier>Kim Malone Scott</qualifier><payload>Compassion is empathy plus action.</payload>';
        hdl5Txt: Label '<qualifier>Jim Goodnight</qualifier><payload>Treat employees like they make a difference and they will.</payload>';
        hdl6Txt: Label '<qualifier>Doug Conant</qualifier><payload>To win in the marketplace, you must first win the workplace.</payload>';
        hdl7Txt: Label '<qualifier>John Cleese</qualifier><payload>If you want creative workers, give them enough time to play.</payload>';
        hdl8Txt: Label '<qualifier>Eleanor Roosevelt</qualifier><payload>To handle yourself, use your head; to handle others, use your heart.</payload>';
        hdl9Txt: Label '<qualifier>Amit Kalantri</qualifier><payload>Children imitate their parents, employees their managers.</payload>';
        hdl10Txt: Label '<qualifier>Robert Half</qualifier><payload>Time spent on hiring is time well spent.</payload>';
        hdl11Txt: Label '<qualifier>Nolan Bushnell</qualifier><payload>Hire for passion and intensity; there is training for everything.</payload>';
        hdl12Txt: Label '<qualifier>Booker T. Washington</qualifier><payload>If you want to lift yourself up, lift up someone else.</payload>';
        hdl13Txt: Label '<qualifier>Peter Schutz</qualifier><payload>Hire character. Train skill.</payload>';
}