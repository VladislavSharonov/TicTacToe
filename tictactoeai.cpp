#include "tictactoeai.h"

TicTacToeAI::TicTacToeAI()
{
}

CellIndex TicTacToeAI::makeMove(Field& field, CellState player) const
{
    int bestScore = -1000;
    CellIndex bestMove(-1, -1);

    for (int i = 0; i < field.row(); ++i) {
        for (int j = 0; j < field.column(); ++j) {
            if (field[i][j] != CellState::Empty)
                continue;

            field[i][j] = player;
            int moveScore = minimax(field, player, 0, false);

            field[i][j] = CellState::Empty;
            if (moveScore > bestScore) {
                bestMove.row = i;
                bestMove.column = j;
                bestScore = moveScore;
            }
        }
    }

    return bestMove;
}

int16_t TicTacToeAI::minimax(Field& field, CellState player, uint8_t depth, bool isMax) const
{
    CellState opponent = player == CellState::O ? CellState::X : CellState::O;
    int16_t score = computeScores(field, player);
    if (score == 10 || score == -10)
        return score;

    if (!field.hasMove())
        return 0;

    int16_t best = isMax ? -1000 : 1000;
    for (int i = 0; i < field.row(); ++i) {
        for (int j = 0; j < field.column(); ++j) {
            if (field.at(i, j) == CellState::Empty) {
                field[i][j] = isMax ? player : opponent;
                int16_t mm = minimax(field, player, depth + 1, !isMax);
                best = isMax
                    ? std::max(best, mm)
                    : std::min(best, mm);
                field[i][j] = CellState::Empty;
            }
        }
    }

    return best;
}

int16_t TicTacToeAI::computeScores(Field& field, CellState player) const
{
    for (int i = 0; i < std::min(field.row(), field.column()); ++i) {
        if (field.at(i, i) != CellState::Empty && (field.rowHasTheSameValues(i) || field.columnHasTheSameValues(i))) {
            return field.at(i, i) == player
                ? +10
                : -10;
        }
    }

    if (field.at(1, 1) != CellState::Empty && field.hasDiagonalSameValues()) {
        return field.at(1, 1) == player
            ? +10
            : -10;
    }

    // Draw
    return 0;
}
