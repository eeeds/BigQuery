--agregar datos desde fuentes externas(descargué el csv produts y lo agregué al dataset ecommerce)
--#standardSQL
SELECT
  *
FROM
  ecommerce.products
ORDER BY
  stockLevel DESC
LIMIT  5



#standardSQL
SELECT
  *,
  SAFE_DIVIDE(orderedQuantity,stockLevel) AS ratio
FROM
  ecommerce.products
WHERE
# include products that have been ordered and
# are 80% through their inventory
orderedQuantity > 0
AND SAFE_DIVIDE(orderedQuantity,stockLevel) >= .8
ORDER BY
  restockingLeadTime DESC

  --Note: If you specify a relative project name path like ecommerce.products instead of project_id.ecommerce.products,
  -- BigQuery will assume the current project.

--con el google sheet, se agregó una nueva columna, luego como tabla externa agregaba más comentarios y hacía correr de nuevo
  #standardSQL
SELECT * FROM ecommerce.products_comments WHERE comments IS NOT NULL
