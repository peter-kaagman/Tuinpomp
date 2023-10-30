Create Table circuit(
	name TEXT NOT NULL,
	color TEXT NOT NULL,
	gpio int NOT NULL,
	button int NOT NULL
);

Create Table schedule(
	circuit int NOT NULL,
	day int NOT NULL Default 0,
	start int NOT NULL Default 0,
	end int NOT NULL Default 0,
	FOREIGN KEY(circuit) REFERENCES circuit(ROWID)
);
