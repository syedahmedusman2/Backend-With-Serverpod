--
-- Class Product as table product
--

CREATE TABLE "product" (
  "id" serial,
  "title" text NOT NULL,
  "price" double precision NOT NULL,
  "description" text NOT NULL,
  "unit" integer NOT NULL,
  "isAvailable" boolean NOT NULL
);

ALTER TABLE ONLY "product"
  ADD CONSTRAINT product_pkey PRIMARY KEY (id);


