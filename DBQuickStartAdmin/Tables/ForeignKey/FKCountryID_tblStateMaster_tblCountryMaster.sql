ALTER TABLE [dbo].[tblStateMaster]
	ADD CONSTRAINT [FKCountryID_tblStateMaster_tblCountryMaster]
	FOREIGN KEY (FKCountryID)
	REFERENCES [tblCountryMaster] (PKCountryID)
