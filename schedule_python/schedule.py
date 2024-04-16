#! /usr/bin/env python

from sqlalchemy import create_engine, text

engine = create_engine("sqlite+pysqlite:///../db/schedule.db", echo=True)
with engine.connect() as conn:
  result = conn.execute(text("select * from circuit"))
  print(result.all())