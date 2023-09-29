Create Table color(
	name TEXT NOT NULL,
	vallue TEXT NOT NULL
);
Create Table circuit(
	name TEXT NOT NULL,
	color int NOT NULL,
	gpio int NOT NULL,
	FOREIGN KEY(color) REFERENCES color(ROWID)
);
Create Table schedule(
	circuit int NOT NULL,
	day int NOT NULL Default 0,
	start int NOT NULL Default 0,
	end int NOT NULL Default 0,
	FOREIGN KEY(circuit) REFERENCES circuit(ROWID)
);
