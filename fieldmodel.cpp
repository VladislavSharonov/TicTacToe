#include "fieldmodel.h"

FieldModel::FieldModel() { _playerRole = CellState::Empty; }

QVariant FieldModel::data(const QModelIndex &index, int role) const
{
    switch (role)
        {
        case Qt::DisplayRole:
            return QString("%1, %2").arg(index.row()).arg(index.column());
            break;
        case Qt::BackgroundRole:
            switch (_field.at(index.row(), index.column()))
            {
            case CellState::X:
                return "resources/sprites/X.svg";
                break;
            case CellState::O:
                return "resources/sprites/O.svg";
                break;
            default:
                return "";
            }
        default:
            break;
        }

        return QVariant();
}

bool FieldModel::setData(const QModelIndex &/*index*/, const QVariant &/*value*/, int /*role*/)
{
    emit dataChanged(createIndex(0, 0), createIndex(rowCount(), columnCount()), { Qt::BackgroundRole });
    return true;
}

void FieldModel::tryMove(const QModelIndex &index)
{
    if (_field[index.row()][index.column()] != CellState::Empty)
        return;

    _field[index.row()][index.column()] = _playerRole;
    tryEnd();

    aiTryMove();

#ifdef QT_DEBUG
    printField(index.row(), index.column(), _playerRole);
#endif
    emit dataChanged(createIndex(0, 0), createIndex(rowCount(), columnCount()), { Qt::BackgroundRole });
}

void FieldModel::aiTryMove()
{
    if (!_field.hasMove() || _gameState == GameState::Win || _gameState == GameState::Draw)
        return;

    CellIndex opponentMove = _ai.makeMove(_field, _playerRole == CellState::O ? CellState::X : CellState::O);
    if (opponentMove.row < rowCount() && opponentMove.column < columnCount())
    {
        _field[opponentMove.row][opponentMove.column] = _opponentRole;
        tryEnd();
    }
}

void FieldModel::setPlayer(const bool isO)
{
    _playerRole = isO ? CellState::O : CellState::X;
    _opponentRole = _playerRole == CellState::O ? CellState::X : CellState::O;
    _gameState = GameState::InGame;

    if (_playerRole == CellState::O)
    {
        aiTryMove();
        emit dataChanged(createIndex(0, 0), createIndex(rowCount(), columnCount()), { Qt::BackgroundRole });
    }

#ifdef AI_VS_AI
    do {
        _playerRole = _playerRole == CellState::O ? CellState::X : CellState::O;
        _opponentRole = _opponentRole == CellState::O ? CellState::X : CellState::O;
        aiTryMove();
        tryEnd();
    }
    while (_gameState == GameState::InGame);

    emit dataChanged(createIndex(0, 0), createIndex(rowCount(), columnCount()), { Qt::BackgroundRole });
#endif

#ifdef QT_DEBUG
{
    std::cout << "Game started" << "\n";
    char playerRole = _playerRole == CellState::X ? 'X' : _playerRole == CellState::O ? 'O' : '_';
    char opponentRole = _opponentRole == CellState::X ? 'X' : _playerRole == CellState::O ? 'O' : '_';
    std::cout << "Player role: " << playerRole << "\n" << "Opponent role: " << opponentRole << "\n\n";
}
#endif
}

void FieldModel::restart()
{
    _field.clear();
    _playerRole = CellState::Empty;
    _gameState = GameState::InGame;

    emit dataChanged(createIndex(0, 0), createIndex(rowCount(), columnCount()), { Qt::BackgroundRole });
}

void FieldModel::updateGameState()
{
    for (int i = 0; i < std::min(_field.row(), _field.column()); ++i)
    {
        if (_field.at(i, i) != CellState::Empty && (_field.rowHasTheSameValues(i) || _field.columnHasTheSameValues(i)))
        {
            _gameState = _field.at(i, i) == _playerRole
                    ? GameState::Win
                    : GameState::Lose;
            return;
        }
    }

    if (_field.at(1, 1) != CellState::Empty && _field.hasDiagonalSameValues())
    {
        _gameState = _field.at(1, 1) == _playerRole
                ? GameState::Win
                : GameState::Lose;
        return;
    }

    if(!_field.hasMove())
        _gameState = GameState::Draw;
}

void FieldModel::tryEnd()
{
    updateGameState();
    if (_gameState != GameState::InGame && _gameState != GameState::Stoped)
    {
        emit gameResultChanged();
        emit isResultVisibleChanged();
    }
}

QString FieldModel::getGameResult() const
{
    switch(_gameState)
    {
    case GameState::Win:
        return "Win";
    case GameState::Lose:
        return "Lose";
    default:
        return "Draw";
    }
};


#ifdef QT_DEBUG
void FieldModel::printField(int row, int column, CellState move)
{
    char moveChar = move == CellState::X ? 'X' : move == CellState::O ? 'O' : ' ';
    std::cout << moveChar << ": " << "[ row: " << row + 1 << ", column: " << column + 1 << " ]\n";

    for (int i = 0; i < rowCount(); ++i)
    {
        std::cout << " ";
        for (int j = 0; j < columnCount(); ++j)
        {
            switch (_field[i][j])
            {
            case CellState::X:
                std::cout << "X";
                break;
            case CellState::O:
                std::cout << "O";
                break;
            default:
                std::cout << " ";
            }
            std::cout << (j < 2 ? " | " : "\n");
        }

        std::cout << (i < 2 ? "---+---+---\n" : "\n");
    }
}
#endif
