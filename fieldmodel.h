#pragma once

#include <QAbstractItemModel>
#include <QString>
#ifdef QT_DEBUG
    #include <iostream>
#endif

#include "field.h"
#include "tictactoeai.h"

//#define AI_VS_AI 1

enum struct GameState { Stoped, InGame, Win, Lose, Draw };

class FieldModel : public QAbstractItemModel
{
    Q_OBJECT

    Q_ENUM(CellState);

    Q_PROPERTY(bool isResultVisible READ isResultVisible NOTIFY isResultVisibleChanged)

    Q_PROPERTY(QString gameResult READ getGameResult NOTIFY gameResultChanged)

public:
    explicit FieldModel();

    Q_INVOKABLE void tryMove(const QModelIndex &index);

    void aiTryMove();

    Q_INVOKABLE void setPlayer(const bool isO);

    Q_INVOKABLE void restart();

    bool isResultVisible() const { return _gameState != GameState::InGame && _gameState != GameState::Stoped; }

    QString getGameResult() const;

signals:
    void isResultVisibleChanged();
    void gameResultChanged();

public:
    //---- QAbstractItemModel interface ----
    QModelIndex index(int row,
                      int column,
                      const QModelIndex &/*parent*/ = QModelIndex()) const override { return createIndex(row, column); };

    QModelIndex parent(const QModelIndex &/*index*/) const override { return QModelIndex(); }

    int rowCount(const QModelIndex & = QModelIndex()) const override { return 3; }

    int columnCount(const QModelIndex & = QModelIndex()) const override { return 3; }

    QVariant data(const QModelIndex &index, int role) const override;

    bool setData(const QModelIndex &/*index*/, const QVariant &/*value*/, int /*role*/ = Qt::EditRole) override;

    QHash<int, QByteArray> roleNames() const override { return {{ Qt::DisplayRole, "display"} , { Qt::BackgroundRole, "cellImage" }}; }

private:
    Field _field;
    TicTacToeAI _ai;
    CellState _playerRole;
    CellState _opponentRole;
    GameState _gameState = GameState::Stoped;
    void updateGameState();

    void tryEnd();

#ifdef QT_DEBUG
    void printField(int row, int column, CellState move = CellState::Empty);
#endif
};
