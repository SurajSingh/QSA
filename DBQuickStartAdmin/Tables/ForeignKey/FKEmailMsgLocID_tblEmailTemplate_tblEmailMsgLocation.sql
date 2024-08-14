ALTER TABLE [dbo].[tblEmailTemplate]
	ADD CONSTRAINT [FKEmailMsgLocID_tblEmailTemplate_tblEmailMsgLocation]
	FOREIGN KEY (FKEmailMsgLocID)
	REFERENCES [tblEmailMsgLocation] (PKID)
