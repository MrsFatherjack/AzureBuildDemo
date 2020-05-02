
USE HUB

SELECT * FROM build.locale

/*********************************************************************
Insert new locale information
**********************************************************************/

INSERT INTO build.Locale
(
    LocaleName,
    AzureRegion,
    username,
    subscriptionID,
    Tier,
    IsLive,
    TenantID
)
VALUES
(   'Japan West Live',   -- LocalName - varchar(100)
    'Japan West',   -- AzureRegion - varchar(100)
    'annetteallen69@gmail.com',   -- username - varchar(100)
    'AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA',   -- Subscription - varchar(100)
    'Basic',   -- Tier - varchar(100)
    1, -- IsLive - bit
    'AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA'  -- TenantID - uniqueidentifier
    )

SELECT @@IDENTITY AS LocaleID

/*********************************************************************
Set up linked data
**********************************************************************/

-- Set the currency conversion

INSERT INTO build.ProductPrice
(
    LocaleID,
    ListPrice,
	DateUpdated
)
VALUES( 
5,
132.86, --AS ListPriceConversion, -- Convert £1 to 132.68 JPY
GETDATE()
)

-- Insert the necessary products









