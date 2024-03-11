// c 2024-02-16
// m 2024-03-11

string       gameMode;
string       myName;
string       myUserId;
const string title = "\\$FFF" + Icons::Trophy + "\\$G Trophies";

void Main() {
    CTrackMania@ App = cast<CTrackMania@>(GetApp());
    CTrackManiaNetwork@ Network = cast<CTrackManiaNetwork@>(App.Network);
    CTrackManiaNetworkServerInfo@ ServerInfo = cast<CTrackManiaNetworkServerInfo@>(Network.ServerInfo);

    myName = App.LocalPlayerInfo.Name;
    myUserId = App.LocalPlayerInfo.WebServicesUserId;

    ChangeFont();

    while (true) {
        gameMode = ServerInfo.CurGameModeStr;

        if (gameMode == "TM_COTDQualifications_Online" || gameMode == "TM_KnockoutDaily_Online")
            SetCotdInfo();

        yield();
    }
}

void OnSettingsChanged() {
    if (currentFont != S_Font)
        ChangeFont();
}

void RenderMenu() {
    if (UI::BeginMenu(title)) {
        if (UI::MenuItem(Icons::CheckSquareO + " Enabled", "", S_Enabled))
            S_Enabled = !S_Enabled;

        if (UI::MenuItem(Icons::ClockO + " Qualifier", "", S_Qualifier))
            S_Qualifier = !S_Qualifier;

        if (UI::MenuItem(Icons::Kenney::Fist + " Knockout", "", S_Knockout))
            S_Knockout = !S_Knockout;

        if (UI::MenuItem(Icons::Code + " Debug", "", S_Debug))
            S_Debug = !S_Debug;

        UI::EndMenu();
    }
}

void Render() {
    if (
        !S_Enabled
        || (S_HideWithGame && !UI::IsGameUIVisible())
        || (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    const float posX = Draw::GetWidth() * S_X;
    const float posY = Draw::GetHeight() * S_Y;

    nvg::TextAlign(nvg::Align::Center | nvg::Align::Top);
    nvg::FontFace(font);

    float maxTextWidth = 0.0f;

    nvg::FontSize(S_HeaderFontSize);
    // const string header = "COTD " + (gameMode == "TM_COTDQualifications_Online" ? "Qualifier" : "Knockout");
    const string header = "COTD Qualifier";
    const vec2 headerSize = nvg::TextBounds(header);

    if (S_Header)
        maxTextWidth = headerSize.x;

    nvg::FontSize(S_FontSize);
    const string subheaderRank = "Rank " + qualiRank + " / " + 2717;
    const vec2 subheaderRankSize = nvg::TextBounds(subheaderRank);
    const float subheaderRankOffsetY = headerSize.y + S_HeaderFontSize * 0.2f;

    if (S_Subheader)
        maxTextWidth = Math::Max(maxTextWidth, subheaderRankSize.x);

    const string subheaderDiv = "Division " + 14;
    const vec2 subheaderDivSize = nvg::TextBounds(subheaderDiv);
    const float subheaderDivOffsetY = subheaderRankOffsetY + subheaderRankSize.y;

    if (S_Subheader)
        maxTextWidth = Math::Max(maxTextWidth, subheaderDivSize.x);

    const vec2 fullTextBounds = vec2(
        maxTextWidth,
        S_Subheader ? subheaderRankSize.y + subheaderRankOffsetY + subheaderDivSize.y : headerSize.y
    );

    if (S_Background) {
        nvg::FillColor(S_BackgroundColor);
        nvg::BeginPath();
        nvg::RoundedRect(
            posX,
            posY,
            fullTextBounds.x + S_BackgroundXPad * 2.0f,
            fullTextBounds.y + S_BackgroundYPad * 2.0f,
            S_BackgroundRadius
        );
        nvg::Fill();
    }

    if (S_Header) {
        nvg::FontSize(S_HeaderFontSize);
        nvg::FillColor(S_FontColor);
        nvg::Text(
            posX + S_BackgroundXPad + maxTextWidth * 0.5f,
            posY + S_BackgroundYPad,
            header
        );
    }

    if (S_Subheader) {
        // rank / total players
        nvg::FontSize(S_FontSize);
        nvg::FillColor(S_FontColor);
        nvg::Text(
            posX + S_BackgroundXPad + maxTextWidth * 0.5f,
            posY + S_BackgroundYPad + subheaderRankOffsetY,
            subheaderRank
        );

        // division
        nvg::Text(
            posX + S_BackgroundXPad + maxTextWidth * 0.5f,
            posY + S_BackgroundYPad + subheaderDivOffsetY,
            subheaderDiv
        );
    }

    //#########################################################################

    // if (S_Qualifier && gameMode == "TM_COTDQualifications_Online") {
        qualiRank = GetQualiRank();

        UI::Begin(title, S_Qualifier, UI::WindowFlags::AlwaysAutoResize);
            UI::Text("total players: " + totalPlayers);
            UI::Text("rank: " + qualiRank);

            UI::Separator();

            if (edition > 1) {
                UI::Text((qualiRank == 1 ? GREEN : WHITE)                          + "Rank 1: "       + InsertSeparators(CotdQualifierTrophies(1,   true)));
                UI::Text((qualiRank == 2 ? GREEN : WHITE)                          + "Rank 2: "       + InsertSeparators(CotdQualifierTrophies(2,   true)));
                UI::Text((qualiRank == 3 ? GREEN : WHITE)                          + "Rank 3: "       + InsertSeparators(CotdQualifierTrophies(3,   true)));
                UI::Text((IsBetweenInclusive(qualiRank, 3, 10) ? GREEN : WHITE)    + "Rank 4-10: "    + InsertSeparators(CotdQualifierTrophies(4,   true)));
                UI::Text((IsBetweenInclusive(qualiRank, 11, 51) ? GREEN : WHITE)   + "Rank 11-50: "   + InsertSeparators(CotdQualifierTrophies(11,  true)));
                UI::Text((IsBetweenInclusive(qualiRank, 51, 100) ? GREEN : WHITE)  + "Rank 51-100: "  + InsertSeparators(CotdQualifierTrophies(51,  true)));
                UI::Text((IsBetweenInclusive(qualiRank, 101, 250) ? GREEN : WHITE) + "Rank 101-250: " + InsertSeparators(CotdQualifierTrophies(101, true)));
                UI::Text((qualiRank > 250 ? GREEN : WHITE)                         + "Rank 251+: "    + InsertSeparators(CotdQualifierTrophies(251, true)));
            } else {
                UI::Text((qualiRank == 1                            ? GREEN : WHITE) + "Rank 1: "         + InsertSeparators(CotdQualifierTrophies(1)));
                UI::Text((qualiRank == 2                            ? GREEN : WHITE) + "Rank 2: "         + InsertSeparators(CotdQualifierTrophies(2)));
                UI::Text((qualiRank == 3                            ? GREEN : WHITE) + "Rank 3: "         + InsertSeparators(CotdQualifierTrophies(3)));
                UI::Text((IsBetweenInclusive(qualiRank, 4, 10)      ? GREEN : WHITE) + "Rank 4-10: "      + InsertSeparators(CotdQualifierTrophies(4)));
                UI::Text((IsBetweenInclusive(qualiRank, 11, 50)     ? GREEN : WHITE) + "Rank 11-50: "     + InsertSeparators(CotdQualifierTrophies(11)));
                UI::Text((IsBetweenInclusive(qualiRank, 51, 100)    ? GREEN : WHITE) + "Rank 51-100: "    + InsertSeparators(CotdQualifierTrophies(51)));
                UI::Text((IsBetweenInclusive(qualiRank, 101, 250)   ? GREEN : WHITE) + "Rank 101-250: "   + InsertSeparators(CotdQualifierTrophies(101)));
                UI::Text((IsBetweenInclusive(qualiRank, 251, 500)   ? GREEN : WHITE) + "Rank 251-500: "   + InsertSeparators(CotdQualifierTrophies(251)));
                UI::Text((IsBetweenInclusive(qualiRank, 501, 1000)  ? GREEN : WHITE) + "Rank 501-1000: "  + InsertSeparators(CotdQualifierTrophies(501)));
                UI::Text((IsBetweenInclusive(qualiRank, 1001, 2500) ? GREEN : WHITE) + "Rank 1001-2500: " + InsertSeparators(CotdQualifierTrophies(1001)));
                UI::Text((qualiRank > 2500                          ? GREEN : WHITE) + "Rank 2501+: "     + InsertSeparators(CotdQualifierTrophies(2501)));
            }

        UI::End();
    // } else if (S_Knockout && gameMode == "TM_KnockoutDaily_Online") {
    //     SetKoInfo();

    //     UI::Begin(title, S_Knockout, UI::WindowFlags::AlwaysAutoResize);
    //         UI::Text("rerun: " + (edition > 1));
    //         UI::Text("total players: " + totalPlayers);
    //         UI::Text("total divisions: " + Math::Ceil(float(totalPlayers) / 64.0f));
    //         UI::Text("division: " + division);
    //         UI::Text("rank: " + divisionRank);
    //         UI::Text("players left: " + playersLeft);
    //         UI::Text("alive: " + alive);

    //         UI::Separator();

    //         if (edition > 1) {
    //             UI::Text(                                    "Rank 1: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 1,  true)));
    //             UI::Text(                                    "Rank 2: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 2,  true)));
    //             UI::Text((playersLeft > 2  ? WHITE : GRAY) + "Rank 3: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 3,  true)));
    //             UI::Text((playersLeft > 3  ? WHITE : GRAY) + "Rank 4-8: "  + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 4,  true)));
    //             UI::Text((playersLeft > 8  ? WHITE : GRAY) + "Rank 9-32: " + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 9,  true)));
    //             UI::Text((playersLeft > 32 ? WHITE : GRAY) + "Rank 33+: "  + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 33, true)));
    //         } else {
    //             UI::Text(                                    "Rank 1: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 1)));
    //             UI::Text(                                    "Rank 2: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 2)));
    //             UI::Text((playersLeft > 2  ? WHITE : GRAY) + "Rank 3: "    + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 3)));
    //             UI::Text((playersLeft > 3  ? WHITE : GRAY) + "Rank 4-8: "  + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 4)));
    //             UI::Text((playersLeft > 8  ? WHITE : GRAY) + "Rank 9-32: " + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 9)));
    //             UI::Text((playersLeft > 32 ? WHITE : GRAY) + "Rank 33+: "  + InsertSeparators(CotdKnockoutTrophies(totalPlayers, division, 33)));
    //         }

    //     UI::End();
    // }

    RenderDebug();
}