// c 2024-02-16
// m 2024-03-01

const int trophy1 = 1;
const int trophy2 = 10;
const int trophy3 = 100;
const int trophy4 = 1000;
const int trophy5 = 10000;
const int trophy6 = 100000;
const int trophy7 = 1000000;
const int trophy8 = 10000000;
const int trophy9 = 100000000;

float TopPercentage() {
    if (totalPlayers < 1 || division < 1)
        return 0.0f;

    return float(division) / Math::Ceil(float(totalPlayers) / 64.0f);
}

int CotdQualifierTrophies() {
    if (qualiRank == 0)
        return 0;

    if (qualiRank > 2500) return trophy3;
    if (qualiRank > 1000) return trophy4;
    if (qualiRank > 500)  return trophy4 * 3;
    if (qualiRank > 250)  return trophy4 * 6;
    if (qualiRank > 100)  return trophy4 * 9;
    if (qualiRank > 50)   return trophy5;
    if (qualiRank > 10)   return trophy5 * 3;
    if (qualiRank > 3)    return trophy5 * 5;
    if (qualiRank > 2)    return trophy5 * 7;
    if (qualiRank > 1)    return trophy5 * 9;
    return trophy6;
}

int CotdKnockoutTrophies(int rank) {
    if (totalPlayers == 0 || division == 0 || rank == 0)
        return 0;

    if (division == 1) {
        if (rank > 32) return trophy6;
        if (rank > 8)  return trophy6 * 2;
        if (rank > 3)  return trophy6 * 6;
        if (rank > 2)  return trophy6 * 7;
        if (rank > 1)  return trophy6 * 8;
        return trophy7;
    }

    float percent = TopPercentage();

    // top 100%
    if (percent > 0.5) {
        if (rank > 32) return trophy4 * 3;
        if (rank > 8)  return trophy4 * 6;
        if (rank > 3)  return trophy5;
        if (rank > 2)  return trophy5 * 2;
        if (rank > 1)  return trophy5 * 3;
        return trophy5 * 4;
    }

    // top 50%
    if (percent > 0.25) {
        if (rank > 32) return trophy4 * 6;
        if (rank > 8)  return trophy4 * 9;
        if (rank > 3)  return trophy5 * 4;
        if (rank > 2)  return trophy5 * 5;
        if (rank > 1)  return trophy5 * 6;
        return trophy5 * 7;
    }

    // top 25%
    if (percent > 0.1) {
        if (rank > 32) return trophy5;
        if (rank > 8)  return trophy5 * 3;
        if (rank > 3)  return trophy5 * 7;
        if (rank > 2)  return trophy6;
        if (rank > 1)  return trophy6 * 2;
        return trophy6 * 3;
    }

    // top 10%
    if (rank > 32) return trophy5 * 6;
    if (rank > 8)  return trophy5 * 9;
    if (rank > 3)  return trophy6 * 3;
    if (rank > 2)  return trophy6 * 4;
    if (rank > 1)  return trophy6 * 5;
    return trophy6 * 6;
}

int CotdRerunQualifierTrophies() {
    if (qualiRank == 0)
        return 0;

    if (qualiRank > 250) return trophy4 * 2;
    if (qualiRank > 100) return trophy4 * 4;
    if (qualiRank > 50)  return trophy4 * 5;
    if (qualiRank > 10)  return trophy4 * 8;
    if (qualiRank > 3)   return trophy5;
    if (qualiRank > 2)   return trophy5 * 2;
    if (qualiRank > 1)   return trophy5 * 4;
    return trophy5 * 5;
}

int CotdRerunKnockoutTrophies(int rank) {
    if (totalPlayers == 0 || division == 0 || rank == 0)
        return 0;

    if (division == 1) {
        if (rank > 32) return trophy5 * 5;
        if (rank > 8)  return trophy5 * 6;
        if (rank > 3)  return trophy6;
        if (rank > 2)  return trophy6 * 2;
        if (rank > 1)  return trophy6 * 4;
        return trophy6 * 5;
    }

    // top 100%
    if (TopPercentage() > 0.5f) {
        if (rank > 32) return trophy4;
        if (rank > 8)  return trophy4 * 3;
        if (rank > 3)  return trophy4 * 7;
        if (rank > 2)  return trophy4 * 9;
        if (rank > 1)  return trophy5;
        return trophy5 * 2;
    }

    // top 50%
    if (rank > 32) return trophy4;
    if (rank > 8)  return trophy4 * 4;
    if (rank > 3)  return trophy4 * 8;
    if (rank > 2)  return trophy5;
    if (rank > 1)  return trophy5 * 2;
    return trophy5 * 3;
}