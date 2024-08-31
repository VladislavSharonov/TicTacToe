#include "field.h"

Field::Field()
{
    clear();
}

void Field::clear()
{
    for (auto &row : _field)
    {
        for (auto &item : row)
            item = CellState::Empty;
    }
}

bool Field::hasMove() const
{
    for (auto &row : _field)
    {
        for (auto &item : row)
        {
            if (item == CellState::Empty)
                return true;
        }
    }
    return false;
}

bool Field::rowHasTheSameValues(uint8_t row) const
{
    return !std::any_of(_field[row].begin(),
                       _field[row].end(),
                        [this, row](CellState state){ return state != _field[row][0]; });
}

bool Field::columnHasTheSameValues(uint8_t column) const
{
    return !std::any_of(_field.begin(),
                        _field.end(),
                        [this, column](std::array<CellState, 3> row){ return row[column] != _field[0][column]; });
}

bool Field::hasDiagonalSameValues() const
{
    uint8_t bigestIndex = std::min(row(), column()) - 1;
    bool hasSame = true;
    for (uint8_t i = 0; i < bigestIndex; ++i)
    {
        if (at(i, i) != at(i + 1, i + 1))
            hasSame = false;
    }
    if (hasSame)
        return true;

    for (uint8_t i = 0; i <= bigestIndex; ++i)
    {
        if (at(i, bigestIndex - i) != at(0, bigestIndex))
            return false;
    }

    return true;
}
