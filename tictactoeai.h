#pragma once

#include "field.h"
#include <algorithm>
#include <cstdint>
#include <map>
#include <vector>

class TicTacToeAI {
public:
    explicit TicTacToeAI();

    CellIndex makeMove(Field& field, CellState player) const;

private:
    int16_t minimax(Field& field, CellState player, uint8_t depth, bool isMax = false) const;

    int16_t computeScores(Field& field, CellState player) const;

    static constexpr int8_t _bestScore = 1000;
    static constexpr int8_t _worstScore = -1000;
};
