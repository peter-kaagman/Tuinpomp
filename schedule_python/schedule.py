#! /usr/bin/env python

from typing import Optional
from sqlmodel import Field, SQLModel, Session, create_engine, select

class Circuit(SQLModel, table=True):
  name: str
  color: str
  gpio: int

engine = create_engine("sqlite:///test.sqlite")

SQLMOdel.metadata.create_all(engine)

with Session(engine) as session:
  statement = select(Circuit)
  circuit = session.exec(statement).first()
  print(circuit)
