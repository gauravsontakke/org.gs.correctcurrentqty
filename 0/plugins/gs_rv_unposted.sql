-- View: gs_rv_unposted

-- DROP VIEW gs_rv_unposted;

CREATE OR REPLACE VIEW gs_rv_unposted AS 
 SELECT gl_journal.ad_client_id,
    gl_journal.ad_org_id,
    gl_journal.created,
    gl_journal.createdby,
    gl_journal.updated,
    gl_journal.updatedby,
    gl_journal.isactive,
    gl_journal.documentno,
    gl_journal.datedoc,
    gl_journal.dateacct,
    224 AS ad_table_id,
    gl_journal.gl_journal_id AS record_id,
    'N'::text AS issotrx,
    gl_journal.posted,
    gl_journal.processing,
    gl_journal.processed,
    gl_journal.docstatus,
    gl_journal.processedon,
    NULL::numeric AS m_product_id
   FROM gl_journal
  WHERE gl_journal.posted <> 'Y'::bpchar AND gl_journal.docstatus <> 'VO'::bpchar
UNION
 SELECT pi.ad_client_id,
    pi.ad_org_id,
    pi.created,
    pi.createdby,
    pi.updated,
    pi.updatedby,
    pi.isactive,
    (p.name::text || '_'::text) || pi.line AS documentno,
    pi.movementdate AS datedoc,
    pi.movementdate AS dateacct,
    623 AS ad_table_id,
    pi.c_projectissue_id AS record_id,
    'N'::text AS issotrx,
    pi.posted,
    pi.processing,
    pi.processed,
    'CO'::bpchar AS docstatus,
    pi.processedon,
    pi.m_product_id
   FROM c_projectissue pi
     JOIN c_project p ON pi.c_project_id = p.c_project_id
  WHERE pi.posted <> 'Y'::bpchar
UNION
 SELECT c_invoice.ad_client_id,
    c_invoice.ad_org_id,
    c_invoice.created,
    c_invoice.createdby,
    c_invoice.updated,
    c_invoice.updatedby,
    c_invoice.isactive,
    c_invoice.documentno,
    c_invoice.dateinvoiced AS datedoc,
    c_invoice.dateacct,
    318 AS ad_table_id,
    c_invoice.c_invoice_id AS record_id,
    c_invoice.issotrx,
    c_invoice.posted,
    c_invoice.processing,
    c_invoice.processed,
    c_invoice.docstatus,
    c_invoice.processedon,
    NULL::numeric AS m_product_id
   FROM c_invoice
  WHERE c_invoice.posted <> 'Y'::bpchar AND c_invoice.docstatus <> 'VO'::bpchar
UNION
 SELECT m_inout.ad_client_id,
    m_inout.ad_org_id,
    m_inout.created,
    m_inout.createdby,
    m_inout.updated,
    m_inout.updatedby,
    m_inout.isactive,
    m_inout.documentno,
    m_inout.movementdate AS datedoc,
    m_inout.dateacct,
    319 AS ad_table_id,
    m_inout.m_inout_id AS record_id,
    m_inout.issotrx,
    m_inout.posted,
    m_inout.processing,
    m_inout.processed,
    m_inout.docstatus,
    m_inout.processedon,
    m_inoutline.m_product_id
   FROM m_inout,
    m_inoutline
  WHERE m_inout.m_inout_id = m_inoutline.m_inout_id AND m_inout.posted <> 'Y'::bpchar AND m_inout.docstatus <> 'VO'::bpchar
UNION
 SELECT m_inventory.ad_client_id,
    m_inventory.ad_org_id,
    m_inventory.created,
    m_inventory.createdby,
    m_inventory.updated,
    m_inventory.updatedby,
    m_inventory.isactive,
    m_inventory.documentno,
    m_inventory.movementdate AS datedoc,
    m_inventory.movementdate AS dateacct,
    321 AS ad_table_id,
    m_inventory.m_inventory_id AS record_id,
    'N'::text AS issotrx,
    m_inventory.posted,
    m_inventory.processing,
    m_inventory.processed,
    m_inventory.docstatus,
    m_inventory.processedon,
    m_inventoryline.m_product_id
   FROM m_inventory,
    m_inventoryline
  WHERE m_inventory.m_inventory_id = m_inventoryline.m_inventory_id AND m_inventory.posted <> 'Y'::bpchar AND m_inventory.docstatus <> 'VO'::bpchar
UNION
 SELECT m_movement.ad_client_id,
    m_movement.ad_org_id,
    m_movement.created,
    m_movement.createdby,
    m_movement.updated,
    m_movement.updatedby,
    m_movement.isactive,
    m_movement.documentno,
    m_movement.movementdate AS datedoc,
    m_movement.movementdate AS dateacct,
    323 AS ad_table_id,
    m_movement.m_movement_id AS record_id,
    'N'::text AS issotrx,
    m_movement.posted,
    m_movement.processing,
    m_movement.processed,
    m_movement.docstatus,
    m_movement.processedon,
    NULL::numeric AS m_product_id
   FROM m_movement
  WHERE m_movement.posted <> 'Y'::bpchar AND m_movement.docstatus <> 'VO'::bpchar
UNION
 SELECT m_production.ad_client_id,
    m_production.ad_org_id,
    m_production.created,
    m_production.createdby,
    m_production.updated,
    m_production.updatedby,
    m_production.isactive,
    m_production.documentno,
    m_production.movementdate AS datedoc,
    m_production.movementdate AS dateacct,
    325 AS ad_table_id,
    m_production.m_production_id AS record_id,
    'N'::text AS issotrx,
    m_production.posted,
    m_production.processing,
    m_production.processed,
    m_production.docstatus,
    m_production.processedon,
    line.m_production_id AS m_product_id
   FROM m_production,
    m_productionline line
  WHERE m_production.m_production_id = line.m_production_id AND m_production.posted <> 'Y'::bpchar AND m_production.docstatus::text <> 'VO'::text
UNION
 SELECT c_cash.ad_client_id,
    c_cash.ad_org_id,
    c_cash.created,
    c_cash.createdby,
    c_cash.updated,
    c_cash.updatedby,
    c_cash.isactive,
    c_cash.name AS documentno,
    c_cash.statementdate AS datedoc,
    c_cash.dateacct,
    407 AS ad_table_id,
    c_cash.c_cash_id AS record_id,
    'N'::text AS issotrx,
    c_cash.posted,
    c_cash.processing,
    c_cash.processed,
    c_cash.docstatus,
    c_cash.processedon,
    NULL::numeric AS m_product_id
   FROM c_cash
  WHERE c_cash.posted <> 'Y'::bpchar AND c_cash.docstatus <> 'VO'::bpchar
UNION
 SELECT c_payment.ad_client_id,
    c_payment.ad_org_id,
    c_payment.created,
    c_payment.createdby,
    c_payment.updated,
    c_payment.updatedby,
    c_payment.isactive,
    c_payment.documentno,
    c_payment.datetrx AS datedoc,
    c_payment.dateacct,
    335 AS ad_table_id,
    c_payment.c_payment_id AS record_id,
    'N'::text AS issotrx,
    c_payment.posted,
    c_payment.processing,
    c_payment.processed,
    c_payment.docstatus,
    c_payment.processedon,
    NULL::numeric AS m_product_id
   FROM c_payment
  WHERE c_payment.posted <> 'Y'::bpchar AND c_payment.docstatus <> 'VO'::bpchar
UNION
 SELECT c_allocationhdr.ad_client_id,
    c_allocationhdr.ad_org_id,
    c_allocationhdr.created,
    c_allocationhdr.createdby,
    c_allocationhdr.updated,
    c_allocationhdr.updatedby,
    c_allocationhdr.isactive,
    c_allocationhdr.documentno,
    c_allocationhdr.datetrx AS datedoc,
    c_allocationhdr.dateacct,
    735 AS ad_table_id,
    c_allocationhdr.c_allocationhdr_id AS record_id,
    'N'::text AS issotrx,
    c_allocationhdr.posted,
    c_allocationhdr.processing,
    c_allocationhdr.processed,
    c_allocationhdr.docstatus,
    c_allocationhdr.processedon,
    NULL::numeric AS m_product_id
   FROM c_allocationhdr
  WHERE c_allocationhdr.posted <> 'Y'::bpchar AND c_allocationhdr.docstatus <> 'VO'::bpchar
UNION
 SELECT c_bankstatement.ad_client_id,
    c_bankstatement.ad_org_id,
    c_bankstatement.created,
    c_bankstatement.createdby,
    c_bankstatement.updated,
    c_bankstatement.updatedby,
    c_bankstatement.isactive,
    c_bankstatement.name AS documentno,
    c_bankstatement.statementdate AS datedoc,
    c_bankstatement.statementdate AS dateacct,
    392 AS ad_table_id,
    c_bankstatement.c_bankstatement_id AS record_id,
    'N'::text AS issotrx,
    c_bankstatement.posted,
    c_bankstatement.processing,
    c_bankstatement.processed,
    c_bankstatement.docstatus,
    c_bankstatement.processedon,
    NULL::numeric AS m_product_id
   FROM c_bankstatement
  WHERE c_bankstatement.posted <> 'Y'::bpchar AND c_bankstatement.docstatus <> 'VO'::bpchar
UNION
 SELECT m_matchinv.ad_client_id,
    m_matchinv.ad_org_id,
    m_matchinv.created,
    m_matchinv.createdby,
    m_matchinv.updated,
    m_matchinv.updatedby,
    m_matchinv.isactive,
    m_matchinv.documentno,
    m_matchinv.datetrx AS datedoc,
    m_matchinv.dateacct,
    472 AS ad_table_id,
    m_matchinv.m_matchinv_id AS record_id,
    'N'::text AS issotrx,
    m_matchinv.posted,
    m_matchinv.processing,
    m_matchinv.processed,
    'CO'::bpchar AS docstatus,
    m_matchinv.processedon,
    NULL::numeric AS m_product_id
   FROM m_matchinv
  WHERE m_matchinv.posted <> 'Y'::bpchar
UNION
 SELECT m_matchpo.ad_client_id,
    m_matchpo.ad_org_id,
    m_matchpo.created,
    m_matchpo.createdby,
    m_matchpo.updated,
    m_matchpo.updatedby,
    m_matchpo.isactive,
    m_matchpo.documentno,
    m_matchpo.datetrx AS datedoc,
    m_matchpo.dateacct,
    473 AS ad_table_id,
    m_matchpo.m_matchpo_id AS record_id,
    'N'::text AS issotrx,
    m_matchpo.posted,
    m_matchpo.processing,
    m_matchpo.processed,
    'CO'::bpchar AS docstatus,
    m_matchpo.processedon,
    NULL::numeric AS m_product_id
   FROM m_matchpo
  WHERE m_matchpo.posted <> 'Y'::bpchar
UNION
 SELECT c_order.ad_client_id,
    c_order.ad_org_id,
    c_order.created,
    c_order.createdby,
    c_order.updated,
    c_order.updatedby,
    c_order.isactive,
    c_order.documentno,
    c_order.dateordered AS datedoc,
    c_order.dateacct,
    259 AS ad_table_id,
    c_order.c_order_id AS record_id,
    c_order.issotrx,
    c_order.posted,
    c_order.processing,
    c_order.processed,
    c_order.docstatus,
    c_order.processedon,
    NULL::numeric AS m_product_id
   FROM c_order
  WHERE c_order.posted <> 'Y'::bpchar AND c_order.docstatus <> 'VO'::bpchar
UNION
 SELECT m_requisition.ad_client_id,
    m_requisition.ad_org_id,
    m_requisition.created,
    m_requisition.createdby,
    m_requisition.updated,
    m_requisition.updatedby,
    m_requisition.isactive,
    m_requisition.documentno,
    m_requisition.datedoc,
    m_requisition.datedoc AS dateacct,
    702 AS ad_table_id,
    m_requisition.m_requisition_id AS record_id,
    'N'::text AS issotrx,
    m_requisition.posted,
    m_requisition.processing,
    m_requisition.processed,
    m_requisition.docstatus,
    m_requisition.processedon,
    NULL::numeric AS m_product_id
   FROM m_requisition
  WHERE m_requisition.posted <> 'Y'::bpchar AND m_requisition.docstatus <> 'VO'::bpchar;

ALTER TABLE gs_rv_unposted
  OWNER TO adempiere;
