#pragma once

#include <array>
#include <vector>
#include <cstdint>
#include <algorithm>

enum struct CellState { Empty, O, X };

struct CellIndex
{
    explicit CellIndex() {}
    explicit CellIndex(uint8_t row, uint8_t column) : row(row), column(column) {}

    uint8_t row = 0;
    uint8_t column = 0;
};

class Field
{
public:
    explicit Field();

    uint8_t row() const { return _field.size(); };

    uint8_t column() const { return _field[0].size(); };

    std::array<CellState, 3> &operator[]( size_t row ) { return _field[row]; }

    CellState at(uint8_t row, uint8_t column) const { return _field[row][column]; }

    CellState &operator[]( CellIndex index ) { return _field[index.row][index.column]; }

    const CellState &operator[]( CellIndex index ) const { return _field.at(index.row).at(index.column); }

    void clear();

    bool hasMove() const;

    const std::array<std::array<CellState, 3>, 3> data() const { return _field; };

    bool rowHasTheSameValues(uint8_t row) const;

    bool columnHasTheSameValues(uint8_t column) const;

    bool hasDiagonalSameValues() const;

private:
    std::array<std::array<CellState, 3>, 3> _field;
};
