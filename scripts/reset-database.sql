-- Drops the database so the submission file can be tested from a clean slate.
-- Replace XX with the team number.

USE master;
GO

ALTER DATABASE LocalDeliveryMarketplace_Team_XX
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE LocalDeliveryMarketplace_Team_XX;
GO
