package com.company;

public class King extends Piece {
    @Override
    public Turn move(BoardPlace moving) {
        return new Turn(this, moving);
    }
}
