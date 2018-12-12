CREATE TABLE IF NOT EXISTS ORDERS
(
  Order_Number SERIAL      NOT NULL,
  Phone        VARCHAR(20) NOT NULL,
  ToStreet     TEXT        NOT NULL,
  ToCity       TEXT        NOT NULL,
  ShipDate     TIMESTAMP   NOT NULL,
  PRIMARY KEY (Order_Number),
  CONSTRAINT FK FOREIGN KEY (Phone) REFERENCES CUSTOMERS (Phone) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE FUNCTION MAKE_TSVECTOR_ORD(ToStreet text, ToCity text)
  RETURNS TSVECTOR AS
$$
BEGIN
  RETURN (SETWEIGHT(TO_TSVECTOR('english', ToStreet), 'E')) ||
         SETWEIGHT(TO_TSVECTOR('english', ToCity), 'E');
END
$$ LANGUAGE 'plpgsql'
   IMMUTABLE;

CREATE INDEX IF NOT EXISTS IDX_FTS_CUSTOMERS ON ORDERS
  USING gin (MAKE_TSVECTOR_ORD(ToStreet, ToCity));