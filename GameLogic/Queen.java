package com.company;

public class Queen extends Piece {
    @Override
    public Turn move(BoardPlace moving) {
        return new Turn(this, moving);
    }
}
