-- Stored procedures signal success or failure through their return code,
-- which is read with an output variable rather than a result set.

DECLARE @rc int;

EXEC @rc = Create_Zone 'Maadi', 25.00, 1;
SELECT @rc AS return_code;    -- 0 on success, negative on failure

SELECT * FROM Zone;

-- Functions are called with the dbo. prefix:
--   SELECT * FROM dbo.ZoneOrderReport(1, '2026-11-01', '2026-11-30');
--   SELECT dbo.CustomerLoginValidation('username', 'password');
