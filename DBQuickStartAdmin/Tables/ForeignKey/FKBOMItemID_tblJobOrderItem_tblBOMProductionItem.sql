ALTER TABLE [dbo].[tblJobOrderItem]
	ADD CONSTRAINT [FKBOMItemID_tblJobOrderItem_tblBOMProductionItem]
	FOREIGN KEY (FKBOMItemID)
	REFERENCES [tblBOMProductionItem] (PKID)